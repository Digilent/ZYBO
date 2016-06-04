#include "xil_cache.h"
#include "xparameters.h"
#include "PmodAMP2.h"

void DemoInitialize();
void DemoRun();
void AMP2_interruptHandler(PmodAMP2* InstancePtr);
PmodAMP2 AMP2;
bool rise;

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
	AMP2_begin(&AMP2, XPAR_PMODAMP2_0_GPIO_AXI_BASEADDR, XPAR_PMODAMP2_0_PWM_AXI_BASEADDR);
	AMP2_setupInterrupt(&AMP2, XPAR_AXI_INTC_0_DEVICE_ID, AMP2_interruptHandler);
}


void DemoRun()
{
	//int i=0;
	while(1){
		/*for (i=0; i<4096; i++)
		{
			AMP2_setPWM(&AMP2, i);
		}
		for (i=4096; i>=0;i--)
		{
			AMP2_setPWM(&AMP2, i);
		}*/

	}

}

//Triggers after every PWM window
//Basic function that creates a triangle wave
void AMP2_interruptHandler(PmodAMP2* InstancePtr){
	int duty=Xil_In32(InstancePtr->PWM_addr);
	if (duty >= Xil_In32(InstancePtr->PWM_addr+4)){
		rise=0;
	}
	else if (duty==0){
		rise=1;
	}
	if (rise)Xil_Out32(InstancePtr->PWM_addr, duty+175);
	else Xil_Out32(InstancePtr->PWM_addr, duty-175);
}
