/******************************************************************************
 * @file audio.h
 * Audio driver include file.
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

#ifndef AUDIO_H_
#define AUDIO_H_

#include "xparameters.h"
#include "xil_io.h"
#include "xiic.h"
#include "xil_printf.h"
#include "xil_cache.h"
#include "xstatus.h"
#include "sleep.h"
#include "../dma/dma.h"
#include "../demo.h"

/************************** Constant Definitions *****************************/
#define DDR_OFFSET				0x07F00000

// Base Addresses
#define SW_ADDR					XPAR_SWITCHES_0_BASEADDR
#define AUDIO_CTL_ADDR			XPAR_D_AXI_I2S_AUDIO_0_AXI_L_BASEADDR

//SLave address of the ADAU audio controller
#define IIC_SLAVE_ADDR			0x1A //for Zybo 0b0011010
#define DDR_BASEADDR			XPAR_MIG_7SERIES_0_BASEADDR


//Bit field construction
struct bits {
	u32 u32bit0:1;
	u32 u32bit1:1;
	u32 u32bit2:1;
	u32 u32bit3:1;
	u32 u32bit4:1;
	u32 u32bit5:1;
	u32 u32bit6:1;
	u32 u32bit7:1;
	u32 u32bit8:1;
	u32 u32bit9:1;
	u32 u32bit10:1;
	u32 u32bit11:1;
	u32 u32bit12:1;
	u32 u32bit13:1;
	u32 u32bit14:1;
	u32 u32bit15:1;
	u32 u32bit16:1;
	u32 u32bit17:1;
	u32 u32bit18:1;
	u32 u32bit19:1;
	u32 u32bit20:1;
	u32 u32bit21:1;
	u32 u32bit22:1;
	u32 u32bit23:1;
	u32 u32bit24:1;
	u32 u32bit25:1;
	u32 u32bit26:1;
	u32 u32bit27:1;
	u32 u32bit28:1;
	u32 u32bit29:1;
	u32 u32bit30:1;
	u32 u32bit31:1;
};

union ubitField{
	u8 rgu8[4];
	u32 l;
	struct bits bit;
};


// I2S Status Register Flags
enum i2sStatusFlags {
	TX_FIFO_EMPTY				= 0,
	TX_FIFO_FULL				= 1,
	RX_FIFO_EMPTY				= 16,
	RX_FIFO_FULL				= 17
};

// I2S Fifo Control Register Bits
enum i2sFifoControlBits {
	TX_FIFO_WR_EN				= 0,
	RX_FIFO_RD_EN				= 1,
	TX_FIFO_RST					= 30,
	RX_FIFO_RST					= 31
};

// I2S Fifo Transfer Control Register Bits
enum i2sFifoTransferControlBits {
	TX_RS						= 0,
	RX_RS						= 1
};

// I2S CLK control register
enum i2sClockControlBits {
	SAMPLING_RATE_BIT0			= 0,
	SAMPLING_RATE_BIT1			= 1,
	SAMPLING_RATE_BIT2			= 2,
	SAMPLING_RATE_BIT3			= 3,
	MASTER_MODE_ENABLE      	= 16,
};

//Audio controller registers

//Audio controller registers
enum i2sRegisters {
	I2S_RESET_REG				= AUDIO_CTL_ADDR,
	I2S_TRANSFER_CONTROL_REG	= AUDIO_CTL_ADDR + 0x04,
	I2S_FIFO_CONTROL_REG      	= AUDIO_CTL_ADDR + 0x08,
	I2S_DATA_IN_REG         	= AUDIO_CTL_ADDR + 0x0c,
	I2S_DATA_OUT_REG          	= AUDIO_CTL_ADDR + 0x10,
	I2S_STATUS_REG           	= AUDIO_CTL_ADDR + 0x14,
	I2S_CLOCK_CONTROL_REG     	= AUDIO_CTL_ADDR + 0x18,
	I2S_PERIOD_COUNT_REG       	= AUDIO_CTL_ADDR + 0x1C,
	I2S_STREAM_CONTROL_REG     	= AUDIO_CTL_ADDR + 0x20
};


//ADAU internal register addresses
enum adauRegisterAdresses {
	R0_LEFT_ADC_VOL									= 0x00,
	R1_RIGHT_ADC_VOL								= 0x01,
	R2_LEFT_DAC_VOL						 			= 0x02,
	R3_RIGHT_DAC_VOL								= 0x03,
	R4_ANALOG_PATH				 					= 0x04,
	R5_DIGITAL_PATH				 					= 0x05,
	R6_POWER_MGMT					 				= 0x06,
	R7_DIGITAL_IF					 				= 0x07,
	R8_SAMPLE_RATE							 		= 0x08,
	R9_ACTIVE								 		= 0x09,
	R15_SOFTWARE_RESET				 				= 0x0F,
	R16_ALC_CONTROL_1								= 0x10,
	R17_ALC_CONTROL_2								= 0x11,
	R18_ALC_CONTROL_2								= 0x12
};

/************************** Variable Definitions *****************************/

// general reg
extern u8 u8Verbose;

/************************** Function Definitions *****************************/

XStatus fnAudioWriteToReg(u8 u8RegAddr, u16 u8Data);
XStatus fnAudioReadFromReg(u8 u8RegAddr, u8 *u8RxData);
//XStatus fnAudioPllConfig();
XStatus fnAudioStartupConfig ();
XStatus fnInitAudio();
void fnAudioRecord(XAxiDma AxiDma, u32 u32NrSamples);
void fnAudioPlay(XAxiDma AxiDma, u32 u32NrSamples);
void fnSetLineInput();
void fnSetLineOutput();
void fnSetMicInput();
void fnSetHpOutput();

#endif /* AUDIO_H_ */
