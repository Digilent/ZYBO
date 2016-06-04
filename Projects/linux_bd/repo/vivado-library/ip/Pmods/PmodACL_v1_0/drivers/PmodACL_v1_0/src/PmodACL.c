

/***************************** Include Files *******************************/
#include "PmodACL.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
/************************** Function Definitions ***************************/
XSpi_Config XSpi_ACLConfig =
{
	0,
	0,
	1,
	0,
	1,
	8,
	0,
	0,
	0,
	0,
	0
};
/* ------------------------------------------------------------ */
/***	void ACL_begin(PmodACL* InstancePtr, u32 GPIO_Address, u32 SPI_Address)
**
**	Parameters:
**		InstancePtr: A PmodACL object to start
**		GPIO_Address: The Base address of the PmodACL GPIO
**		SPI_Address: The Base address of the PmodACL SPI
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Initialize the PmodACL.
*/
void ACL_begin(PmodACL* InstancePtr, u32 GPIO_Address, u32 SPI_Address)
{
	InstancePtr->GPIO_addr=GPIO_Address;
	XSpi_ACLConfig.BaseAddress=SPI_Address;
	Xil_Out32(InstancePtr->GPIO_addr+4, 0b11);
	ACL_SPIInit(&InstancePtr->ACLSpi);
}

/* ------------------------------------------------------------ */
/***	ACL_SPIInit
**
**	Parameters:
**		none
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Initializes the PmodACL SPI.

*/

int ACL_SPIInit(XSpi *SpiInstancePtr){
	int Status;
	XSpi_Config *ConfigPtr; /* Pointer to Configuration data */

	/*
	 * Initialize the SPI driver so that it is  ready to use.
	 */
	ConfigPtr = &XSpi_ACLConfig;
	if (ConfigPtr == NULL) {
		return XST_DEVICE_NOT_FOUND;
	}

	Status = XSpi_CfgInitialize(SpiInstancePtr, ConfigPtr, ConfigPtr->BaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}



	Status = XSpi_SetOptions(SpiInstancePtr, (XSP_MASTER_OPTION | XSP_CLK_ACTIVE_LOW_OPTION | XSP_CLK_PHASE_1_OPTION) | XSP_MANUAL_SSELECT_OPTION); //Manual SS off
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	Status = XSpi_SetSlaveSelect(SpiInstancePtr, 1);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Start the SPI driver so that the device is enabled.
	 */
	XSpi_Start(SpiInstancePtr);

	/*
	 * Disable Global interrupt to use polled mode operation
	 */
	XSpi_IntrGlobalDisable(SpiInstancePtr);

	return XST_SUCCESS;

}

/* ------------------------------------------------------------ */
/***	ACL_WriteSpi
**
**	Synopsis:
**		ACL_WriteSpi(&ACLobj, 0x3A, &bytearray, 5);
**
**	Parameters:
**		PmodACL *InstancePtr	- the PmodACL object to communicate with
**		u8 reg			- the starting register to write to
**		u8* wData		- the data to write
**		int nData		- the number of data bytes to write
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Writes the byte array to the chip via SPI. It will write the first byte into the specified register, then the next into the following register until all of the data has been sent.

*/
void ACL_WriteSpi(PmodACL* InstancePtr, uint8_t reg, uint8_t *wData, int nData)
{
	// As requested by documentation, first byte contains:
	//	bit 7 = 0 because is a write operation
	//	bit 6 = 1 if more than one bytes is written, 0 if a single byte is written
	// 	bits 5-0 - the address
	u8 bytearray[nData+1];
	bytearray[0] = ((nData>1) ? 0x40: 0) | (reg&0x3F);
	memcpy(&bytearray[1],wData, nData);//Copy write commands over to bytearray
	XSpi_Transfer(&InstancePtr->ACLSpi, bytearray, 0, nData+1);

}

/* ------------------------------------------------------------ */
/***	ACL_ReadSpi
**
**	Synopsis:
**		ACL_ReadSpi(&ACLobj, 0x3A, &bytearray, 5);
**
**	Parameters:
**		PmodACL *InstancePtr	- the PmodACL object to communicate with
**		u8 reg			- the starting register to read from
**		u8* rData		- the byte array to read into
**		int nData		- the number of data bytes to read
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Reads data in through SPI. It will read the first byte from the starting register, then the next from the following register. Data is stored into rData.
*/
void ACL_ReadSpi(PmodACL* InstancePtr, uint8_t reg, uint8_t *rData, int nData)
{
	// As requested by documentation, first byte contains:
	//	bit 7 = 1 because is a read operation
	//	bit 6 = 1 if more than one bytes is written, 0 if a single byte is written
	// 	bits 5-0 - the address
	u8 bytearray[nData+1];

	bytearray[0] = ((nData>1) ? 0xC0: 0x80) | (reg&0x3F);
	XSpi_Transfer(&InstancePtr->ACLSpi, bytearray, bytearray, nData+1);
	memcpy(rData,&bytearray[1], nData);
}


/* ------------------------------------------------------------ */
/*        SetRegisterBits
**
**        Synopsis:
**				SetRegisterBits(&ACLobj, ACL_ADR_POWER_CTL, bPowerControlMask, fValue);
**        Parameters:
**        		PmodACL *InstancePtr		- the PmodACL object to communicate with
**				uint8_t bRegisterAddress 	- the address of the register whose bits are set
**				uint8_t bMask				- the mask indicating which bits are affected
**				bool fValue					- 1 if the bits are set or 0 if their bits are reset
**
**
**        Return Values:
**                void
**
**        Errors:
**
**
**        Description:
**				This function sets the value of some bits (corresponding to the bMask) of a register (indicated by bRegisterAddress) to 1 or 0 (indicated by fValue).
**
**
*/
void SetRegisterBits(PmodACL* InstancePtr, uint8_t reg, uint8_t mask, bool fValue){
	u8 regval;
	ACL_ReadSpi(InstancePtr, reg, &regval, 1);
	if (fValue)regval |= mask;
	else regval &= ~mask;
	ACL_WriteSpi(InstancePtr, reg, &regval, 1);
}

/* ------------------------------------------------------------ */
/*        GetRegisterBits
**
**        Synopsis:
**				return GetRegisterBits(&ACLobj, ACL_ADR_BW_RATE, MSK_BW_RATE_RATE);
**        Parameters:
**        		PmodACL *InstancePtr	- the PmodACL object to communicate with
**				uint8_t bRegisterAddress 	- the address of the register whose bits are read
**				uint8_t bMask				- the mask indicating which bits are read
**
**
**        Return Values:
**                uint8_t 					- a byte containing only the bits correspoding to the mask.
**
**        Errors:
**
**
**        Description:
**				Returns a byte containing only the bits from a register (indicated by bRegisterAddress), correspoding to the bMask mask.
**
**
*/
uint8_t GetRegisterBits(PmodACL* InstancePtr, uint8_t bRegisterAddress, uint8_t bMask)
{
	uint8_t bRegValue;
	ACL_ReadSpi(InstancePtr, bRegisterAddress, &bRegValue, 1);
	return bRegValue & bMask;
}

/* ------------------------------------------------------------ */
/*        ConvertReadingToValueG
**
**        Synopsis:
**				*pdAclXg = ConvertReadingToValueG(rgwRegVals[0]);
**        Parameters:
**        		PmodACL *InstancePtr	- the PmodACL object to get the Grange from
**				int16_t uiReading	- the 2 bytes containing the reading (in fact only 10 bits are used).
**
**
**        Return Values:
**                float - the value of the acceleration in "g" corresponding to the 10 bits reading and the current g range
**
**        Errors:
**
**
**        Description:
**				Converts the value from the 10 bits reading to the float value (in g) corresponding to the acceleration, considering the current selected g range.
**
**
*/
float ConvertReadingToValueG(PmodACL* InstancePtr, int16_t uiReading)
{
	//Convert the accelerometer value to G's.
  //With 10 (ACL_NO_BITS) bits measuring over a +/- ng range we can find how to convert by using the equation:
  // Gs = Measurement Value * (G-range/(2^10))
  // m_dGRangeLSB is pre-computed in ACLSetGRange
  float dResult = ((float)uiReading) * InstancePtr->m_dGRangeLSB;
  return dResult;
}


/* ------------------------------------------------------------ */
/*        GetGRangeLSB
**
**        Synopsis:
**				m_dGRangeLSB = GetGRangeLSB(bGRange);
**        Parameters:
**				uint8_t bGRange	- the parameter specifying the g range. Can be one of the parameters in the following list
**					0	PAR_GRANGE_PM2G	Parameter g range : +/- 2g
**					1	PAR_GRANGE_PM4G	Parameter g range : +/- 4g
**					2	PAR_GRANGE_PM8G	Parameter g range : +/- 8g
**					3	PAR_GRANGE_PM16G Parameter g range : +/- 16g
**
**        Return Values:
**                float - the value in "g" corresponding to the G range parameter, that corresponds to 1 accelerometer LSB
**
**        Errors:
**
**
**        Description:
**				Converts the parameter indicating the G range into the value that corresponds to 1 accelerometer LSB.
**					For ex PAR_GRANGE_PM8G: Range is 16g, accelerometer is on 10 bits, that corresponds to 16/(2^10). This constant is later used in converting readings to acceleration values in g.
**					(for ex converts PAR_GRANGE_PM8G into 8).
**
**
*/
float GetGRangeLSB(uint8_t bGRange)
{
	float dGMaxValue = 0;
	float dResult;
	switch(bGRange)
	{
		case PAR_GRANGE_PM2G:
			dGMaxValue = 2;
			break;
		case PAR_GRANGE_PM4G:
			dGMaxValue = 4;
			break;
		case PAR_GRANGE_PM8G:
			dGMaxValue = 8;
			break;
		case PAR_GRANGE_PM16G:
			dGMaxValue = 16;
			break;
	}
	dResult = 2 * dGMaxValue / (float)(1 << ACL_NO_BITS);
	return dResult;
}

/* ------------------------------------------------------------ */
/*        ReadAccelG
**
**        Synopsis:
**				ReadAccelG(&ACLobj, &dX, &dY, &dZ);
**        Parameters:
**        		PmodACL *InstancePtr	- the PmodACL object to communicate with
**				float *dAclXg	- the output parameter that will receive acceleration on X axis (in "g")
**				float *dAclYg	- the output parameter that will receive acceleration on Y axis (in "g")
**				float *dAclZg	- the output parameter that will receive acceleration on Z axis (in "g")
**
**
**        Return Values:
**                void
**
**        Errors:
**
**
**        Description:
**				This function is the main function used for acceleration reading, providing the 3 current acceleration values in “g”.
**					-	It reads simultaneously the acceleration on three axes in a buffer of 6 bytes using the ReadRegister function
**					-	For each of the three axes, combines the two bytes in order to get a 10-bit value
**					-	For each of the three axes, converts the 10-bit value to the value expressed in “g”, considering the currently selected g range

**
**
*/
void ReadAccelG(PmodACL* InstancePtr, float *dAclXg, float *dAclYg, float *dAclZg) {
	uint16_t rgwRegVals[3];
	ACL_ReadSpi(InstancePtr, ACL_ADR_DATAX0, (uint8_t *)rgwRegVals, 6);
	*dAclXg = ConvertReadingToValueG(InstancePtr, rgwRegVals[0]);
	*dAclYg = ConvertReadingToValueG(InstancePtr, rgwRegVals[1]);
	*dAclZg = ConvertReadingToValueG(InstancePtr, rgwRegVals[2]);
}
/* ------------------------------------------------------------ */
/*        ReadAccel
**
**        Synopsis:
**				ReadAccel(&ACLobj, &iX, &iY, &iZ);
**        Parameters:
**        		PmodACL *InstancePtr	- the PmodACL object to communicate with
**				int16_t *iAclX	- the output parameter that will receive acceleration on X axis - 10 bits signed value
**				int16_t *iAclY	- the output parameter that will receive acceleration on Y axis - 10 bits signed value
**				int16_t *iAclZ	- the output parameter that will receive acceleration on Z axis - 10 bits signed value
**
**
**        Return Values:
**                void
**
**        Errors:
**
**
**        Description:
**				This function provides the 3 "raw" 10-bit values read from the accelerometer.
**					-	It reads simultaneously the acceleration on three axes in a buffer of 6 bytes using the ReadRegister function
**					-	For each of the three axes, combines the two bytes in order to get a 10-bit value
**
**
*/
void ReadAccel(PmodACL* InstancePtr, int16_t *iAclX, int16_t *iAclY, int16_t *iAclZ)
{
	uint16_t rgwRegVals[3];
	ACL_ReadSpi(InstancePtr, ACL_ADR_DATAX0,(uint8_t *)rgwRegVals, 6);
	*iAclX = rgwRegVals[0];
	*iAclY = rgwRegVals[1];
	*iAclZ = rgwRegVals[2];
}
/* ------------------------------------------------------------ */
/*        SetMeasure
**
**        Synopsis:
**				SetMeasure(&ACLobj, true);
**
**        Parameters:
**        		PmodACL *InstancePtr	- the PmodACL object to communicate with
**				bool fMeasure	– the value to be set for MEASURE bit of POWER_CTL register
**
**
**
**        Return Values:
**
**
**        Description:
**				This function sets the MEASURE bit of POWER_CTL register. This toggles between measurement and standby mode.
**
*/
void SetMeasure(PmodACL* InstancePtr, bool fMeasure)
{
	SetRegisterBits(InstancePtr, ACL_ADR_POWER_CTL, MSK_POWER_CTL_MEASURE, fMeasure);
}

/* ------------------------------------------------------------ */
/*        GetMeasure
**
**        Synopsis:
**				fMeasure = GetMeasure(&ACLobj);
**
**        Parameters:
**				PmodACL *InstancePtr	- the PmodACL object to communicate with
**
**
**        Return Values:
**				bool – the value of the MEASURE bit of POWER_CTL register
**
**
**        Description:
**				This function returns the value of MEASURE bit of POWER_CTL register.
**
*/
bool GetMeasure(PmodACL* InstancePtr)
{
	return (GetRegisterBits(InstancePtr, ACL_ADR_POWER_CTL, MSK_POWER_CTL_MEASURE) != 0);
}

/* ------------------------------------------------------------ */
/*        SetGRange
**
**        Synopsis:
**					SetGRange(&ACLobj, PAR_GRANGE_PM2G);
**        Parameters:
**        		PmodACL *InstancePtr	- the PmodACL object to communicate with
**				uint8_t bGRangePar	- the parameter specifying the g range. Can be one of the parameters from the following list:
**					0	PAR_GRANGE_PM2G	Parameter g range : +/- 2g
**					1	PAR_GRANGE_PM4G	Parameter g range : +/- 4g
**					2	PAR_GRANGE_PM8G	Parameter g range : +/- 8g
**					3	PAR_GRANGE_PM16G Parameter g range : +/- 16g
**
**
**        Return Value:
**
**
**        Description:
**				The function sets the appropriate g range bits in the DATA_FORMAT register. The accepted argument values are between 0 and 3.
**				If the argument is within the accepted values range, it sets the g range bits in DATA_FORMAT register and ACL_ERR_SUCCESS status is returned.
**				If value is outside this range no value is set.
**
*/
void SetGRange(PmodACL *InstancePtr, uint8_t bGRangePar)
{
	uint8_t bResult;
	InstancePtr->m_dGRangeLSB = GetGRangeLSB(bGRangePar);

	SetRegisterBits(InstancePtr, ACL_ADR_DATA_FORMAT, MSK_DATA_FORMAT_RANGE0, (bGRangePar & 1));
	SetRegisterBits(InstancePtr, ACL_ADR_DATA_FORMAT, MSK_DATA_FORMAT_RANGE1, (bGRangePar & 2) >> 1);
}

/* ------------------------------------------------------------ */
/*        GetGRange
**
**        Synopsis:
**
**        Parameters:
**
**
**        Return Values:
**        		PmodACL *InstancePtr	- the PmodACL object to communicate with
**                uint8_t - the value specifying the g Range parameter. Can be one of the values from the following list
**					0	PAR_GRANGE_PM2G	Parameter g range : +/- 2g
**					1	PAR_GRANGE_PM4G	Parameter g range : +/- 4g
**					2	PAR_GRANGE_PM8G	Parameter g range : +/- 8g
**					3	PAR_GRANGE_PM16G Parameter g range : +/- 16g
**
**        Errors:
**
**
**        Description:
**				The function returns the value specifying the g range parameter. It relies on the data in DATA_FORMAT register.
**
*/
uint8_t GetGRange(PmodACL* InstancePtr)
{
	uint8_t bVal = (GetRegisterBits(InstancePtr, ACL_ADR_DATA_FORMAT, MSK_DATA_FORMAT_RANGE1) << 1) + GetRegisterBits(InstancePtr, ACL_ADR_DATA_FORMAT, MSK_DATA_FORMAT_RANGE0);
	return bVal;
}

/* ------------------------------------------------------------ */
/*        SetOffsetG
**
**        Synopsis:
**				SetOffsetG(&ACLobj, PAR_AXIS_Z, 0.5);
**
**        Parameters:
**				PmodACL* InstancePtr	- the PmodACL object to communicate with
**				uint8_t bAxisParam - byte indicating the axis whose offset will be set. Can be one of:
**					PAR_AXIS_X		- indicating X axis
**                  PAR_AXIS_Y 		- indicating Y axis
**                  PAR_AXIS_Z 		- indicating Z axis
**
**				float dOffsetX	– the offset for X axis in “g”
**
**        Return Values:
**
**
**        Description:
**				This function sets the specified axis offset, the value being given in “g”. The accepted argument values are between -2g and +2g.
**				If argument is within the accepted values range, its value is quantified in the 8-bit offset register using a scale factor of 15.6 mg/LSB and ACL_ERR_SUCCESS is returned.
**				If value is outside this range or if bAxisParam parameter is outside 0 - 3 range, the function does nothing.
**
*/
void SetOffsetG(PmodACL* InstancePtr, uint8_t bAxisParam, float dOffset)
{
	int8_t bOffsetVal = (uint8_t)(dOffset/(float)ACL_CONV_OFFSET_G_LSB);
	switch (bAxisParam)
	{
		case PAR_AXIS_X:
			ACL_WriteSpi(InstancePtr, ACL_ADR_OFSX, (uint8_t *)&bOffsetVal, 1);
			break;
		case PAR_AXIS_Y:
			ACL_WriteSpi(InstancePtr, ACL_ADR_OFSY, (uint8_t *)&bOffsetVal, 1);
			break;
		case PAR_AXIS_Z:
			ACL_WriteSpi(InstancePtr, ACL_ADR_OFSZ, (uint8_t *)&bOffsetVal, 1);
			break;
	}
}

/* ------------------------------------------------------------ */
/*        ACL::GetOffsetG
**
**        Synopsis:
**				dOffsetG = GetOffsetG(&ACLobj, PAR_AXIS_X);
**
**        Parameters:
**        		PmodACL* InstancePtr - the PmodACL object to communicate with
**				uint8_t bAxisParam - byte indicating the axis whose acceleration will be read. Can be one of:
**					PAR_AXIS_X		- indicating X axis
**                  PAR_AXIS_Y 		- indicating Y axis
**                  PAR_AXIS_Z 		- indicating Z axis
**
**
**
**        Return Values:
**                float 	- the offset for X axis in “g”.
**
**        Errors:
**
**
**        Description:
**				This function returns the offset, in “g”, for the specified axis.
**				It converts the 8-bit value quantified in the offset register into a value expressed in “g”, using a scale factor of 15.6 mg/LSB.
**
**
*/
float GetOffsetG(PmodACL* InstancePtr, uint8_t bAxisParam)
{
	int8_t bOffsetVal;
	float dResult;
	switch (bAxisParam)
	{
		case PAR_AXIS_X:
			ACL_ReadSpi(InstancePtr, ACL_ADR_OFSX, (uint8_t *)&bOffsetVal, 1);
			break;
		case PAR_AXIS_Y:
			ACL_ReadSpi(InstancePtr, ACL_ADR_OFSY, (uint8_t *)&bOffsetVal, 1);
			break;
		case PAR_AXIS_Z:
			ACL_ReadSpi(InstancePtr, ACL_ADR_OFSZ, (uint8_t *)&bOffsetVal, 1);
			break;
	}
	dResult = (float)bOffsetVal * (float)ACL_CONV_OFFSET_G_LSB;
	return dResult;
}


/* ------------------------------------------------------------ */
/*        CalibrateOneAxisGravitational
**
**        Synopsis:
**				CalibrateOneAxisGravitational(&ACLobj, PAR_AXIS_ZP);
**        Parameters:
**        		PmodACL *InstancePtr	- the PmodACL object to communicate with
**				uint8_t bAxisInfo - Parameter specifying axes orientation. Can be one of the following:
**					0	PAR_AXIS_XP - X axis is oriented in the gravitational direction
**					1	PAR_AXIS_XN - X axis is oriented in the opposite gravitational direction
**					2	PAR_AXIS_YP - Y axis is oriented in the gravitational direction
**					3	PAR_AXIS_YN - Y axis is oriented in the opposite gravitational direction
**					4	PAR_AXIS_ZP - Z axis is oriented in the gravitational direction
**					5	PAR_AXIS_ZN - Z axis is oriented in the opposite gravitational direction
**
**        Return Value:
**
**        Errors:
**
**
**        Description:
**				The accepted argument values are between 0 and +5.
**				This function performs the calibration of the accelerometer by setting the offset registers in the following manner:
**				 computes the correction factor that must be loaded in the offset registers so that the acceleration readings are:
**					1 for the gravitational axis, if positive orientation
**					-1 for the gravitational axis, if negative orientation
**					0 for the other axes
**				The accepted argument values are between 0 and 5.
**				If the argument value is outside this range, the function does nothing.
**
*/
void CalibrateOneAxisGravitational(PmodACL* InstancePtr, uint8_t bAxisInfo)
{
		// perform calibration
		float dX, dSumX = 0, dY, dSumY = 0, dZ, dSumZ = 0;
		// set the offset registers to 0
		//Put the device into standby mode to configure it.
		SetMeasure(InstancePtr,false);
		SetOffsetG(InstancePtr, PAR_AXIS_X, 0);
		SetOffsetG(InstancePtr, PAR_AXIS_Y, 0);
		SetOffsetG(InstancePtr, PAR_AXIS_Z, 0);
		SetMeasure(InstancePtr,true);


		// read average acceleration on the three axes
		int idxAvg;

		int nCntMeasurements = 128;
		// consume some readings
		for(idxAvg = 0; idxAvg < nCntMeasurements; idxAvg++)
		{
			ReadAccelG(InstancePtr, &dX, &dY, &dZ);
		}
		// compute average values
		for(idxAvg = 0; idxAvg < nCntMeasurements; idxAvg++)
		{
			ReadAccelG(InstancePtr, &dX, &dY, &dZ);
			dSumX = dSumX + dX;
			dSumY = dSumY + dY;
			dSumZ = dSumZ + dZ;
		}
		dX = dSumX/nCntMeasurements;
		dY = dSumY/nCntMeasurements;
		dZ = dSumZ/nCntMeasurements;
		// computes the correction that must be put in the offset registers so that the acceleration readings are:
		//	1 (for the gravitational axis, if positive
		//	-1 (for the gravitational axis, if negative
		// 0 (for the other axes)
		switch (bAxisInfo)
		{
			case PAR_AXIS_XP:
				dX = 1.0 - dX;
				dY = 0.0 - dY;
				dZ = 0.0 - dZ;
				break;
			case PAR_AXIS_XN:
				dX = -1.0 - dX;
				dY = 0.0 - dY;
				dZ = 0.0 - dZ;
				break;
			case PAR_AXIS_YP:
				dY = 1.0 - dY;
				dX = 0.0 - dX;
				dZ = 0.0 - dZ;
				break;
			case PAR_AXIS_YN:
				dY = -1.0 - dY;
				dX = 0.0 - dX;
				dZ = 0.0 - dZ;
				break;
			case PAR_AXIS_ZP:
				dZ = 1.0 - dZ;
				dY = 0.0 - dY;
				dX = 0.0 - dX;
				break;
			case PAR_AXIS_ZN:
				dZ = -1.0 - dZ;
				dY = 0.0 - dY;
				dX = 0.0 - dX;
				break;
		}
		//Put the device into standby mode to configure it.
		SetMeasure(InstancePtr, false);
		// set the offset data to registers
		SetOffsetG(InstancePtr, PAR_AXIS_X, dX);
		SetOffsetG(InstancePtr, PAR_AXIS_Y, dY);
		SetOffsetG(InstancePtr, PAR_AXIS_Z, dZ);
		SetMeasure(InstancePtr, true);

		// some delay is needed
		usleep(10000);

}
