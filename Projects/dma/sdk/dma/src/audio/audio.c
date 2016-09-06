/******************************************************************************
 * @file audio.c
 * Audio driver.
 *
 * @authors RoHegbeC
 *
 * @date 2014-Oct-30
 *
 * @copyright
 * (c) 2015 Copyright Digilent Incorporated
 * All Rights Reserved
 *
 * This program is free software; distributed under the terms of BSD 3-clause
 * license ("Revised BSD License", "New BSD License", or "Modified BSD License")
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. Neither the name(s) of the above-listed copyright holder(s) nor the names
 *    of its contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 * @desciption
 *
 * This program was initially developed to be run from within the BRAM. It is
 * constructed to run in a polling mode, in which the program poles the Empty and
 * Full signals of the two FIFO's which are implemented in the audio I2S VHDL core.
 * In order to have a continuous and stable Sound both when recording and playing
 * the user must ensure that DDR cache is enabled. This is only mandatory when the
 * program is loaded in to the DDR, if the program is stored in the BRAM then
 * the cache is not mandatory.
 *
 * <pre>
 * MODIFICATION HISTORY:
 *
 * Ver   Who          Date     Changes
 * ----- ------------ ----------- -----------------------------------------------
 * 1.00  RoHegbeC 2014-Oct-30 First release
 *
 * </pre>
 *
 *****************************************************************************/


#include "audio.h"
#include "../demo.h"

/************************** Variable Definitions *****************************/

extern volatile sDemo_t Demo;

/******************************************************************************
 * Function to write one byte (8-bits) to one of the registers from the audio
 * controller.
 *
 * @param	u8RegAddr is the LSB part of the register address (0x40xx).
 * @param	u8Data is the data byte to write.
 *
 * @return	XST_SUCCESS if all the bytes have been sent to Controller.
 * 			XST_FAILURE otherwise.
 *****************************************************************************/
XStatus fnAudioWriteToReg(u8 u8RegAddr, u16 u8Data) {

	u8 u8TxData[2];
	u8 u8BytesSent;

	u8TxData[0] = u8RegAddr << 1;
	u8TxData[0] = u8TxData[0] | ((u8Data>>8) & 0b1);

	u8TxData[1] = u8Data & 0xFF;

	u8BytesSent = XIic_Send(XPAR_IIC_0_BASEADDR, IIC_SLAVE_ADDR, u8TxData, 2, XIIC_STOP);

	//check if all the bytes where sent
	if (u8BytesSent != 3)
	{
		//return XST_FAILURE;
	}

	return XST_SUCCESS;
}

/******************************************************************************
 * Function to read one byte (8-bits) from the register space of audio controller.
 *
 * @param	u8RegAddr is the LSB part of the register address (0x40xx).
 * @param	u8RxData is the returned value
 *
 * @return	XST_SUCCESS if the desired number of bytes have been read from the controller
 * 			XST_FAILURE otherwise
 *****************************************************************************/
XStatus fnAudioReadFromReg(u8 u8RegAddr, u8 *u8RxData) {

	u8 u8TxData[2];
	u8 u8BytesSent, u8BytesReceived;

	u8TxData[0] = u8RegAddr;
	u8TxData[1] = IIC_SLAVE_ADDR;

	u8BytesSent = XIic_Send(XPAR_IIC_0_BASEADDR, IIC_SLAVE_ADDR, u8TxData, 2, XIIC_STOP);
	//check if all the bytes where sent
	if (u8BytesSent != 2)
	{
		return XST_FAILURE;
	}

	u8BytesReceived = XIic_Recv(XPAR_IIC_0_BASEADDR, IIC_SLAVE_ADDR, u8RxData, 1, XIIC_STOP);
	//check if there are missing bytes
	if (u8BytesReceived != 1)
	{
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

/******************************************************************************
 * Configures audio codes's internal PLL. With MCLK = 12.288 MHz it configures the
 * PLL for a VCO frequency = 49.152 MHz.
 *
 * @param	none.
 *
 * @return	XST_SUCCESS if PLL is locked
 *****************************************************************************/
//XStatus fnAudioPllConfig() {
//
//	u8 u8TxData[8], u8RxData[6];
//	int Status;
//
//	Status = fnAudioWriteToReg(R0_CLOCK_CONTROL, 0x0E);
//	if (Status == XST_FAILURE)
//	{
//		if (Demo.u8Verbose)
//		{
//			xil_printf("\r\nError: could not write R0_CLOCK_CONTROL (0x0E)");
//		}
//		return XST_FAILURE;
//	}
//
//	// Write 6 bytes to R1
//	// For setting the PLL with a MCLK = 12.288 MHz the datasheet suggests the
//	// following configuration 0xXXXXXX2001
//	u8TxData[0] = 0x40;
//	u8TxData[1] = 0x02;
//	u8TxData[2] = 0x00; // byte 1
//	u8TxData[3] = 0x7D; // byte 2
//	u8TxData[4] = 0x00; // byte 3
//	u8TxData[5] = 0x0C; // byte 4
//	u8TxData[6] = 0x20; // byte 5
//	u8TxData[7] = 0x01; // byte 6
//
//	Status = XIic_Send(XPAR_IIC_0_BASEADDR, IIC_SLAVE_ADDR, u8TxData, 8, XIIC_STOP);
//	if (Status != 8)
//	{
//		if (Demo.u8Verbose)
//		{
//			xil_printf("\r\nError: could not send data to R1_PLL_CONTROL (0xXXXXXX2001)");
//		}
//		return XST_FAILURE;
//	}
//	// Poll PLL Lock bit
//	u8TxData[0] = 0x40;
//	u8TxData[1] = 0x02;
//
//	//Wait for the PLL to lock
//	do {
//		XIic_Send(XPAR_IIC_0_BASEADDR, IIC_SLAVE_ADDR, u8TxData, 2, XIIC_STOP);
//
//		XIic_Recv(XPAR_IIC_0_BASEADDR, IIC_SLAVE_ADDR, u8RxData, 6, XIIC_STOP);
//		if(Demo.u8Verbose) {
//			xil_printf("\nAudio PLL R1 = 0x%x%x%x%x%x%x", u8RxData[0], u8RxData[1],
//				u8RxData[2], u8RxData[3], u8RxData[4], u8RxData[5]);
//		}
//	}
//	while((u8RxData[5] & 0x02) == 0);
//
//	//Set COREN
//	Status = fnAudioWriteToReg(R0_CLOCK_CONTROL, 0x0F);
//	if (Status == XST_FAILURE)
//	{
//		if (Demo.u8Verbose)
//		{
//			xil_printf("\r\nError: could not write R0_CLOCK_CONTROL (0x0F)");
//		}
//		return XST_FAILURE;
//	}
//
//	return XST_SUCCESS;
//}

/******************************************************************************
 * Configure the initial settings of the audio controller, the majority of
 * these will remain unchanged during the normal functioning of the code.
 * In order to generate a correct BCLK and LRCK, which are crucial for the
 * correct operating of the controller, the sampling rate must me set in the
 * I2S_TRANSFER_CONTROL_REG. The sampling rate options are:
 *    "000" -  8 KHz
 *    "001" - 12 KHz
 *    "010" - 16 KHz
 *    "011" - 24 KHz
 *    "100" - 32 KHz
 *    "101" - 48 KHz
 *    "110" - 96 KHz
 * These options are valid only if the I2S controller is in slave mode.
 * When In master mode the ADAU will generate the appropriate BCLK and LRCLK
 * internally, and the sampling rates which will be set in the I2S_TRANSFER_CONTROL_REG
 * are ignored.
 *
 * @param	none.
 *
 * @return	XST_SUCCESS if the configuration is successful
 *****************************************************************************/
XStatus fnAudioStartupConfig ()
{

	union ubitField uConfigurationVariable;
	int Status;

	// Configure the I2S controller for generating a valid sampling rate
	uConfigurationVariable.l = Xil_In32(I2S_CLOCK_CONTROL_REG);
	uConfigurationVariable.bit.u32bit0 = 1;
	uConfigurationVariable.bit.u32bit1 = 0;
	uConfigurationVariable.bit.u32bit2 = 1;
	Xil_Out32(I2S_CLOCK_CONTROL_REG, uConfigurationVariable.l);

	uConfigurationVariable.l = 0x00000000;

	//STOP_TRANSACTION
	uConfigurationVariable.bit.u32bit1 = 1;
	Xil_Out32(I2S_TRANSFER_CONTROL_REG, uConfigurationVariable.l);

	//STOP_TRANSACTION
	uConfigurationVariable.bit.u32bit1 = 0;
	Xil_Out32(I2S_TRANSFER_CONTROL_REG, uConfigurationVariable.l);

	//slave: I2S
	Status = fnAudioWriteToReg(R15_SOFTWARE_RESET, 0b000000000);
	Status = XST_SUCCESS;
	if (Status == XST_FAILURE)
	{
		if (Demo.u8Verbose)
		{
			xil_printf("\r\nError: could not write R15_SOFTWARE_RESET (0x00)");
		}
		return XST_FAILURE;
	}
	usleep(1000);
	Status = fnAudioWriteToReg(R6_POWER_MGMT, 0b000110000);
	if (Status == XST_FAILURE)
	{
		if (Demo.u8Verbose)
		{
			xil_printf("\r\nError: could not write R6_POWER_MGMT (0b000110000)");
		}
		return XST_FAILURE;
	}
	Status = fnAudioWriteToReg(R0_LEFT_ADC_VOL, 0b000010111);
	if (Status == XST_FAILURE)
	{
		if (Demo.u8Verbose)
		{
			xil_printf("\r\nError: could not write R0_LEFT_ADC_VOL (0b000010111)");
		}
		return XST_FAILURE;
	}
	Status = fnAudioWriteToReg(R1_RIGHT_ADC_VOL, 0b000010111);
	if (Status == XST_FAILURE)
	{
		if (Demo.u8Verbose)
		{
			xil_printf("\r\nError: could not write R0_LEFT_ADC_VOL (0b000010111)");
		}
		return XST_FAILURE;
	}
	Status = fnAudioWriteToReg(R2_LEFT_DAC_VOL, 0b101111001);
	if (Status == XST_FAILURE)
	{
		if (Demo.u8Verbose)
		{
			xil_printf("\r\nError: could not write R0_LEFT_ADC_VOL (0b000010111)");
		}
		return XST_FAILURE;
	}
	Status = fnAudioWriteToReg(R3_RIGHT_DAC_VOL, 0b101111001);
	if (Status == XST_FAILURE)
	{
		if (Demo.u8Verbose)
		{
			xil_printf("\r\nError: could not write R0_LEFT_ADC_VOL (0b000010111)");
		}
		return XST_FAILURE;
	}
	Status = fnAudioWriteToReg(R4_ANALOG_PATH, 0b000000000);
	if (Status == XST_FAILURE)
	{
		if (Demo.u8Verbose)
		{
			xil_printf("\r\nError: could not write R0_LEFT_ADC_VOL (0b000010111)");
		}
		return XST_FAILURE;
	}
	fnAudioWriteToReg(R5_DIGITAL_PATH, 0b000000000);
	fnAudioWriteToReg(R7_DIGITAL_IF, 0b000001010);
	fnAudioWriteToReg(R8_SAMPLE_RATE, 0b000000000);
	usleep(1000);
	fnAudioWriteToReg(R9_ACTIVE, 0b000000001);
	fnAudioWriteToReg(R6_POWER_MGMT, 0b000100000);


	return XST_SUCCESS;
}

/******************************************************************************
 * Initialize PLL and Audio controller over the I2C bus
 *
 * @param	none
 *
 * @return	none.
 *****************************************************************************/
XStatus fnInitAudio()
{
	int Status;

	//Set the PLL and wait for Lock
	//Status = fnAudioPllConfig();
//	if (Status != XST_SUCCESS)
//	{
//		if (Demo.u8Verbose)
//		{
//			xil_printf("\r\nError: Could not lock PLL");
//		}
//	}

	//Configure the ADAU registers
	Status = fnAudioStartupConfig();
	if (Status != XST_SUCCESS)
	{
		if (Demo.u8Verbose)
		{
			xil_printf("\r\nError: Failed I2C Configuration");
		}
	}

	Demo.fAudioPlayback = 0;
	Demo.fAudioRecord = 0;

	return XST_SUCCESS;
}

/******************************************************************************
 * Configure the the I2S controller to receive data, which will be stored locally
 * in a vector. (Mem)
 *
 * @param	u32NrSamples is the number of samples to store.
 *
 * @return	none.
 *****************************************************************************/
void fnAudioRecord(XAxiDma AxiDma, u32 u32NrSamples)
{
	union ubitField uTransferVariable;

	if (Demo.u8Verbose)
	{
		xil_printf("\r\nEnter Record function");
	}

	uTransferVariable.l = XAxiDma_SimpleTransfer(&AxiDma,(u32) MEM_BASE_ADDR, 5*u32NrSamples, XAXIDMA_DEVICE_TO_DMA);
	if (uTransferVariable.l != XST_SUCCESS)
	{
		if (Demo.u8Verbose)
			xil_printf("\n fail @ rec; ERROR: %d", uTransferVariable.l);
	}

	// Send number of samples to recorde
	Xil_Out32(I2S_PERIOD_COUNT_REG, u32NrSamples);

	// Start i2s initialization sequence
	uTransferVariable.l = 0x00000000;
	Xil_Out32(I2S_TRANSFER_CONTROL_REG, uTransferVariable.l);
	uTransferVariable.bit.u32bit1 = 1;
	Xil_Out32(I2S_TRANSFER_CONTROL_REG, uTransferVariable.l);

	// Enable Stream function to send data (S2MM)
	Xil_Out32(I2S_STREAM_CONTROL_REG, 0x00000001);

	if (Demo.u8Verbose)
	{
		xil_printf("\r\nRecording function done");
	}
}

/******************************************************************************
 * Configure the I2S controller to transmit data, which will be read out from
 * the local memory vector (Mem)
 *
 * @param	u32NrSamples is the number of samples to store.
 *
 * @return	none.
 *****************************************************************************/
void fnAudioPlay(XAxiDma AxiDma, u32 u32NrSamples)
{
	union ubitField uTransferVariable;

	if (Demo.u8Verbose)
	{
		xil_printf("\r\nEnter Playback function");
	}

	// Send number of samples to record
	Xil_Out32(I2S_PERIOD_COUNT_REG, u32NrSamples);
	// Start i2s initialization sequence
	uTransferVariable.l = 0x00000000;
	Xil_Out32(I2S_TRANSFER_CONTROL_REG, uTransferVariable.l);
	uTransferVariable.bit.u32bit0 = 1;
	Xil_Out32(I2S_TRANSFER_CONTROL_REG, uTransferVariable.l);


	uTransferVariable.l = XAxiDma_SimpleTransfer(&AxiDma,(u32) MEM_BASE_ADDR, 5*u32NrSamples, XAXIDMA_DMA_TO_DEVICE);
	if (uTransferVariable.l != XST_SUCCESS)
	{
		if (Demo.u8Verbose)
			xil_printf("\n fail @ play; ERROR: %d", uTransferVariable.l);
	}

	// Enable Stream function to send data (MM2S)
		Xil_Out32(I2S_STREAM_CONTROL_REG, 0x00000002);
	if (Demo.u8Verbose)
	{
		xil_printf("\r\nPlayback function done");
	}
}

/******************************************************************************
 * Configure the input path to MIC and disables all other input paths.
 * For additional information pleas refer to the ADAU1761 datasheet
 *
 * @param	none
 *
 * @return	none.
 *****************************************************************************/
void fnSetMicInput()
{
	//MX1AUXG = MUTE; MX2AUXG = MUTE; LDBOOST = 0dB; RDBOOST = 0dB
	fnAudioWriteToReg(R4_ANALOG_PATH, 0b000010100);
	if (Demo.u8Verbose)
	{
		xil_printf("\r\nInput set to MIC");
	}
}

/******************************************************************************
 * Configure the input path to Line and disables all other input paths
 * For additional information pleas refer to the ADAU1761 datasheet
 *
 * @param	none
 *
 * @return	none.
 *****************************************************************************/
void fnSetLineInput()
{
	//MX1AUXG = 0dB; MX2AUXG = 0dB; LDBOOST = MUTE; RDBOOST = MUTE
	fnAudioWriteToReg(R4_ANALOG_PATH, 0b000010010);
	fnAudioWriteToReg(R5_DIGITAL_PATH, 0b000000000);
	if (Demo.u8Verbose)
	{
		xil_printf("\r\nInput set to LineIn");
	}
}

/******************************************************************************
 * Configure the output path to Line and disables all other output paths
 * For additional information pleas refer to the ADAU1761 datasheet
 *
 * @param	none
 *
 * @return	none.
 *****************************************************************************/
void fnSetLineOutput()
{
	//zybo does not have a line output
	//MX3G1 = mute; MX3G2 = mute; MX4G1 = mute; MX4G2 = mute;
	//fnAudioWriteToReg(R4_ANALOG_PATH, 0x00);

	if (Demo.u8Verbose)
	{
		xil_printf("\r\nOutput set to LineOut");
	}
}

/******************************************************************************
 * Configure the output path to Headphone and disables all other output paths
 * For additional information pleas refer to the ADAU1761 datasheet
 *
 * @param	none
 *
 * @return	none.
 *****************************************************************************/
void fnSetHpOutput()
{
	//MX5G3 = MUTE; MX5EN = MUTE; MX6G4 = MUTE; MX6EN = MUTE
	fnAudioWriteToReg(R4_ANALOG_PATH, 0b000010110);
	fnAudioWriteToReg(R5_DIGITAL_PATH, 0b000000000);
	if (Demo.u8Verbose)
	{
		xil_printf("\r\nOutput set to HeadPhones");
	}
}
