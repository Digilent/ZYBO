#include "xparameters.h"
//#include "xil_types.h"
//#include "xil_io.h"

#include "xil_cache.h"
#include "PmodBT2.h"

#define BUFFERSIZE 8

void DemoInitialize();
void DemoRun();

void recv(PmodBT2* InstancePtr);
void send(PmodBT2* InstancePtr);

PmodBT2 BT2;


int main(void)
{
	Xil_ICacheEnable();
	Xil_DCacheEnable();

	DemoInitialize();
	DemoRun();
	return 0;
}

void DemoInitialize()
{
	BT2_begin(&BT2, XPAR_PMODBT2_0_AXI_LITE_GPIO_BASEADDR, XPAR_PMODBT2_0_AXI_LITE_UART_BASEADDR);
#ifndef NO_IRPT
	BT2_SetupInterruptSystem(&BT2, XPAR_INTC_0_PMODBT2_0_VEC_ID, recv, send);
#endif
}


void DemoRun()
{
	int len;

	BT2_getData(&BT2, BUFFERSIZE);//Start scanning for input
	while(1){
		//Polled mode, if no interrupts
		/*if((len=BT2_getData(&BT2, BUFFERSIZE))){
			BT2_sendData(&BT2, BT2.recv, len);
		}*/
	}
}

void recv(PmodBT2* InstancePtr){
	BT2_sendData(InstancePtr, BT2.recv, BUFFERSIZE);//Echo back through BT
	BT2_getData(&BT2, BUFFERSIZE);//Start scanning for next input
}
void send(PmodBT2* InstancePtr){

}
