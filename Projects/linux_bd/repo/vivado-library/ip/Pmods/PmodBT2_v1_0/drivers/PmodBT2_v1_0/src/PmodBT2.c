

/***************************** Include Files *******************************/
#include "PmodBT2.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
/************************** Function Definitions ***************************/
XUartLite_Config BT2_Config =
{
	0,
	0,
	115200,
	0,
	0,
	8
};
/* ------------------------------------------------------------ */
/***	void BT2_begin(PmodBT2* InstancePtr, u32 GPIO_Address, u32 UART_Address)
**
**	Parameters:
**		InstancePtr: A PmodBT2 object to start
**		GPIO_Address: The Base address of the PmodBT2 GPIO
**		UART_Address: The Base address of the PmodBT2 UART
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Initialize the PmodBT2.
*/
void BT2_begin(PmodBT2* InstancePtr, u32 GPIO_Address, u32 UART_Address)
{
	InstancePtr->GPIO_addr=GPIO_Address;
	BT2_Config.RegBaseAddr=UART_Address;
	Xil_Out32(InstancePtr->GPIO_addr+4, 0b11);//Set RTS and CTS to inputs
	BT2_UARTInit(&InstancePtr->BT2Uart);
}

/* ------------------------------------------------------------ */
/***	BT2_UARTInit
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
**		Initializes the PmodBT2 UART.

*/

int BT2_UARTInit(XUartLite *UartInstancePtr){
	int Status;
	XUartLite_Config *ConfigPtr; /* Pointer to Configuration data */

	ConfigPtr = &BT2_Config;
	if (ConfigPtr == NULL) {
		return XST_DEVICE_NOT_FOUND;
	}

	Status = XUartLite_CfgInitialize(UartInstancePtr, ConfigPtr, ConfigPtr->RegBaseAddr);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

/*int BT2_readPPSpin(PmodBT2* InstancePtr){
	return Xil_In32(InstancePtr->GPIO_addr)&0b10;
}

int BT2_read3DFpin(PmodBT2* InstancePtr){
	return Xil_In32(InstancePtr->GPIO_addr)&0b01;
}*/

/* ------------------------------------------------------------ */
/*  getData()
**
**  Parameters:
**	  serPort: The HardwareSerial port (Serial1, Serial2, etc) from
**				MPIDE that will be used to communicate with the PmodBT2
**
**  Return Value:
**    The type of sentence that was recieved.
**
**  Errors:
**    none
**
**  Description:
**    Does a read of data. finishes when a value of decimal
**	  10 (ASCII <LF>) is detected. Reads the first three characters to
**	  verify the packet starts with $GP, then checks the next three
**	  to decide which struct to parse the data into.
*/
int BT2_getData(PmodBT2* InstancePtr, int buffersize)
{
	//char recv[500]={0};
	unsigned int ReceivedCount = 0;
	ReceivedCount += XUartLite_Recv(&InstancePtr->BT2Uart, InstancePtr->recv, buffersize);

	return ReceivedCount;
}

/* ------------------------------------------------------------ */
/*  getData()
**
**  Parameters:
**	  serPort: The HardwareSerial port (Serial1, Serial2, etc) from
**				MPIDE that will be used to communicate with the PmodBT2
**
**  Return Value:
**    The type of sentence that was recieved.
**
**  Errors:
**    none
**
**  Description:
**    Does a read of data. finishes when a value of decimal
**	  10 (ASCII <LF>) is detected. Reads the first three characters to
**	  verify the packet starts with $GP, then checks the next three
**	  to decide which struct to parse the data into.
*/
int BT2_sendData(PmodBT2* InstancePtr, char* sendData, int size)
{
	char recv[500]={0};
	int i=0;
	int count = 0;
	unsigned int ReceivedCount = 0;
	while(i<size){
		i+= XUartLite_Send(&InstancePtr->BT2Uart, sendData, size);
		//while(XUartLite_IsSending(&InstancePtr->BT2Uart));
	}

	return i;//Return the type of sentence that was sent
}


/****************************************************************************/
/**
* This function sets up the interrupt system for the example.  The processing
* contained in this funtion assumes the hardware system was built with
* and interrupt controller.
*
* @param	None.
*
* @return	A status indicating XST_SUCCESS or a value that is contained in
*		xstatus.h.
*
* @note		None.
*
*****************************************************************************/
int BT2_SetupInterruptSystem(PmodBT2* InstancePtr, u32 interruptID, void* receiveHandlerFunction, void* sendHandlerFunction)
{
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
		      (Xil_ExceptionHandler)XUartLite_InterruptHandler, &InstancePtr->BT2Uart);

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
	XUartLite_SetRecvHandler(&InstancePtr->BT2Uart, (XUartLite_Handler)receiveHandlerFunction, InstancePtr);
	XUartLite_SetSendHandler(&InstancePtr->BT2Uart, (XUartLite_Handler)sendHandlerFunction, InstancePtr);
	/*
	 * Initialize the exception table and register the interrupt
	 * controller handler with the exception table
	 */
	Xil_ExceptionInit();

	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			 (Xil_ExceptionHandler)INTC_HANDLER, IntcInstancePtr);

	/* Enable non-critical exceptions */
	Xil_ExceptionEnable();

	XUartLite_EnableInterrupt(&InstancePtr->BT2Uart);
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
				 (Xil_ExceptionHandler)XUartLite_InterruptHandler, &InstancePtr->BT2Uart);
	if (Result != XST_SUCCESS) {
		return Result;
	}

	/*
	 * Enable the interrupt for the GPIO device.
	 */
	XScuGic_Enable(IntcInstancePtr, interruptID);

	XUartLite_SetRecvHandler(&InstancePtr->BT2Uart, (XUartLite_Handler)receiveHandlerFunction, InstancePtr);
	XUartLite_SetSendHandler(&InstancePtr->BT2Uart, (XUartLite_Handler)sendHandlerFunction, InstancePtr);

	/*
	 * Initialize the exception table and register the interrupt
	 * controller handler with the exception table
	 */
	Xil_ExceptionInit();

	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			 (Xil_ExceptionHandler)INTC_HANDLER, IntcInstancePtr);

	/* Enable non-critical exceptions */
	Xil_ExceptionEnable();

	XUartLite_EnableInterrupt(&InstancePtr->GPSUart);
#endif


	return XST_SUCCESS;
}

