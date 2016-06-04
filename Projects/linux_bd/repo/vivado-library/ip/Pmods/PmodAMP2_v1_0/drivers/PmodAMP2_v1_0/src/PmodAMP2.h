
#ifndef PMODAMP2_H
#define PMODAMP2_H


/****************** Include Files ********************/
#include "xil_types.h"
#include "xstatus.h"
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

typedef struct PmodAMP2{
	u32 GPIO_addr;
	u32 PWM_addr;
#ifndef NO_IRPT
	INTC intc;
#endif
}PmodAMP2;

int AMP2_setupInterrupt(PmodAMP2* InstancePtr, u32 interruptID, void* handlerFunction);
void AMP2_begin(PmodAMP2* InstancePtr, u32 GPIO_Address, u32 PWM_Address);
void AMP2_setPWM(PmodAMP2* InstancePtr,int duty);





#endif // PMODAMP2_H
