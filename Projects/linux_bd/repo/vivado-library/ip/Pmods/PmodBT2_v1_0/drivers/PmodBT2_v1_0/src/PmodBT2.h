
#ifndef PMODBT2_H
#define PMODBT2_H


/****************** Include Files ********************/
#include "xil_types.h"
#include "xstatus.h"
#include "xuartlite_l.h"
#include "xuartlite.h"
#include "xparameters.h"

#ifdef XPAR_XINTC_NUM_INSTANCES
 #include "xintc.h"
 #define INTC		XIntc
 #define INTC_HANDLER	XIntc_InterruptHandler
#else
#ifdef XPAR_SCUGIC_0_DEVICE_ID
 #include "xscugic.h"
 #define INTC		XScuGic
 #define INTC_HANDLER	XScuGic_InterruptHandler
#else
#define NO_IRPT 1
#endif
#endif

/* ------------------------------------------------------------ */
/*					Definitions									*/
/* ------------------------------------------------------------ */
#define bool u8
#define true 1
#define false 0


/* ------------------------------------------------------------ */
/*					Procedure Declarations						*/
/* ------------------------------------------------------------ */

typedef struct PmodBT2{
	u32 GPIO_addr;
#ifndef NO_IRPT
	INTC intc;
#endif
	XUartLite BT2Uart;
	char recv[8];

}PmodBT2;

void BT2_begin(PmodBT2* InstancePtr, u32 GPIO_Address, u32 UART_Address);
int BT2_UARTInit(XUartLite *UartInstancePtr);
int BT2_getData(PmodBT2* InstancePtr, int buffersize);
int BT2_sendData(PmodBT2* InstancePtr, char* sendData, int size);
int BT2_SetupInterruptSystem(PmodBT2* InstancePtr, u32 interruptID, void* receiveHandlerFunction, void* sendHandlerFunction);


#endif // PMODBT2_H
