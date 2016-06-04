
#ifndef PMODALS_H
#define PMODALS_H


/****************** Include Files ********************/
#include "xil_types.h"
#include "xstatus.h"
#include "xspi_l.h"
#include "xspi.h"

/* ------------------------------------------------------------ */
/*					Definitions									*/
/* ------------------------------------------------------------ */
#define bool u8
#define true 1
#define false 0


/* ------------------------------------------------------------ */
/*		Register addresses Definitions							*/
/* ------------------------------------------------------------ */

/* ------------------------------------------------------------ */
/*				Bit masks Definitions							*/
/* ------------------------------------------------------------ */


/* ------------------------------------------------------------ */
/*				Parameters Definitions							*/
/* ------------------------------------------------------------ */



/* ------------------------------------------------------------ */
/*					Procedure Declarations						*/
/* ------------------------------------------------------------ */

typedef struct PmodALS{
	XSpi ALSSpi;
}PmodALS;

void ALS_begin(PmodALS* InstancePtr, u32 SPI_Address);
int ALS_SPIInit(XSpi *SpiInstancePtr);
u8 ALS_read(PmodALS* InstancePtr);





#endif // PMODALS_H
