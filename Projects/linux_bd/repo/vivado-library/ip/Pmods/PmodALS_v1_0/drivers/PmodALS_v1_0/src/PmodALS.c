

/***************************** Include Files *******************************/
#include "PmodALS.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
/************************** Function Definitions ***************************/
XSpi_Config XSpi_ALSConfig =
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
/***	void ALS_begin(PmodALS* InstancePtr, u32 GPIO_Address, u32 SPI_Address)
**
**	Parameters:
**		InstancePtr: A PmodALS object to start
**		GPIO_Address: The Base address of the PmodALS GPIO
**		SPI_Address: The Base address of the PmodALS SPI
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Initialize the PmodALS.
*/
void ALS_begin(PmodALS* InstancePtr, u32 SPI_Address)
{
	XSpi_ALSConfig.BaseAddress=SPI_Address;
	ALS_SPIInit(&InstancePtr->ALSSpi);
}

/* ------------------------------------------------------------ */
/***	ALS_SPIInit
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
**		Initializes the PmodALS SPI.

*/

int ALS_SPIInit(XSpi *SpiInstancePtr){
	int Status;
	XSpi_Config *ConfigPtr; /* Pointer to Configuration data */

	/*
	 * Initialize the SPI driver so that it is  ready to use.
	 */
	ConfigPtr = &XSpi_ALSConfig;
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
/***	ALS_Read
**
**	Synopsis:
**		light = ALS_Read(&ALS)
**
**	Parameters:
**		PmodALS *InstancePtr	- the PmodALS object to communicate with
**
**	Return Value:
**		u8 light	- Light level from PmodALS
**
**	Errors:
**		none
**
**	Description:
**		Reads ambient light sensor
*/

u8 ALS_read(PmodALS* InstancePtr){
	u8 light[2];
	XSpi_Transfer(&InstancePtr->ALSSpi, light, light, 2);
	return light[0]<<3|light[1]>>5;
}


