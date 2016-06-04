

/***************************** Include Files *******************************/
#include "PmodAMP2.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
/************************** Function Definitions ***************************/

/* ------------------------------------------------------------ */
/***	void AMP2_begin(PmodAMP2* InstancePtr, u32 GPIO_Address, u32 SPI_Address)
**
**	Parameters:
**		InstancePtr: A PmodAMP2 object to start
**		GPIO_Address: The Base address of the PmodAMP2 GPIO
**		SPI_Address: The Base address of the PmodAMP2 SPI
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Initialize the PmodAMP2.
*/
void AMP2_begin(PmodAMP2* InstancePtr, u32 GPIO_Address, u32 PWM_Address)
{
	InstancePtr->GPIO_addr=GPIO_Address;
	InstancePtr->PWM_addr=PWM_Address;
	Xil_Out32(InstancePtr->GPIO_addr+4, 0b000);
	Xil_Out32(InstancePtr->GPIO_addr, 0b101);
	Xil_Out32(InstancePtr->PWM_addr+8, 0xf);
	Xil_Out32(InstancePtr->PWM_addr+4, 4096);
}

void AMP2_setPWM(PmodAMP2* InstancePtr,int duty){
	Xil_Out32(InstancePtr->PWM_addr, duty);
}

void AMP2_setPWMPeriod(PmodAMP2* InstancePtr,int period){
	Xil_Out32(InstancePtr->PWM_addr+4, period);
}

int AMP2_setupInterrupt(PmodAMP2* InstancePtr, u32 interruptID, void* handlerFunction){

	int Result;

#ifdef XPAR_XINTC_NUM_INSTANCES
	INTC *IntcInstancePtr = &InstancePtr->intc;
	/*
	 * Initialize the interrupt controller driver so that it's ready to use.
	 * specify the device ID that was generated in xparameters.h
	 */
	Result = XIntc_Initialize(IntcInstancePtr, interruptID);
	if (Result != XST_SUCCESS) {
		return Result;
	}

	/* Hook up interrupt service routine */
	XIntc_Connect(IntcInstancePtr, interruptID,
		      (Xil_ExceptionHandler)handlerFunction, InstancePtr);

	/* Enable the interrupt vector at the interrupt controller */

	XIntc_Enable(IntcInstancePtr, interruptID);

	/*
	 * Start the interrupt controller such that interrupts are recognized
	 * and handled by the processor
	 */
	Result = XIntc_Start(IntcInstancePtr, XIN_REAL_MODE);
	if (Result != XST_SUCCESS) {
		return Result;
	}
	/*
	 * Initialize the exception table and register the interrupt
	 * controller handler with the exception table
	 */
	Xil_ExceptionInit();

	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			 (Xil_ExceptionHandler)INTC_HANDLER, IntcInstancePtr);

	/* Enable non-critical exceptions */
	Xil_ExceptionEnable();

#endif
#ifdef XPAR_SCUGIC_0_DEVICE_ID
	INTC *IntcInstancePtr = &InstancePtr->intc;
	XScuGic_Config *IntcConfig;

	/*
	 * Initialize the interrupt controller driver so that it is ready to
	 * use.
	 */
	IntcConfig = XScuGic_LookupConfig(INTC_DEVICE_ID);
	if (NULL == IntcConfig) {
		return XST_FAILURE;
	}

	Result = XScuGic_CfgInitialize(IntcInstancePtr, IntcConfig,
					IntcConfig->CpuBaseAddress);
	if (Result != XST_SUCCESS) {
		return XST_FAILURE;
	}

	XScuGic_SetPriorityTriggerType(IntcInstancePtr, interruptID,
					0xA0, 0x3);

	/*
	 * Connect the interrupt handler that will be called when an
	 * interrupt occurs for the device.
	 */
	Result = XScuGic_Connect(IntcInstancePtr, interruptID,
				 (Xil_ExceptionHandler)handlerFunction, InstancePtr);
	if (Result != XST_SUCCESS) {
		return Result;
	}

	/*
	 * Enable the interrupt for the GPIO device.
	 */
	XScuGic_Enable(IntcInstancePtr, interruptID);

	/*
	 * Enable the GPIO channel interrupts so that push button can be
	 * detected and enable interrupts for the GPIO device
	 */


	/*
	 * Initialize the exception table and register the interrupt
	 * controller handler with the exception table
	 */
	Xil_ExceptionInit();

	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			 (Xil_ExceptionHandler)INTC_HANDLER, IntcInstancePtr);

	/* Enable non-critical exceptions */
	Xil_ExceptionEnable();

#endif
return 0;
}
