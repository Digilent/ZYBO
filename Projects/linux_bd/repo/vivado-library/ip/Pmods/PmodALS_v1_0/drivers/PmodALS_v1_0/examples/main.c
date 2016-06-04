#include "xparameters.h"
#include "xil_types.h"
#include "xil_io.h"
#include "PmodALS.h"
#include <stdio.h>
#include <sleep.h>
#include "xil_cache.h"

void DemoInitialize();
void DemoRun();

PmodALS ALS;

int main(void)
{
	Xil_ICacheEnable();

	DemoInitialize();
	DemoRun();
	return 0;
}

void DemoInitialize()
{
	ALS_begin(&ALS, XPAR_PMODALS_0_AXI_LITE_SPI_BASEADDR);
}


void DemoRun()
{
	int light=0;
	while (1){
		light = ALS_read(&ALS);
		xil_printf("Light = %d\n\r", light);
	}
}
