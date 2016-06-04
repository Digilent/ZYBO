#include "xparameters.h"
#include "xil_types.h"
#include "xil_io.h"
#include "PmodACL.h"
#include <stdio.h>
#include <sleep.h>
#include "xil_cache.h"

void DemoInitialize();
void DemoRun();

PmodACL ACL;

int main(void)
{
	Xil_ICacheEnable();

	DemoInitialize();
	DemoRun();
	return 0;
}

void DemoInitialize()
{
	ACL_begin(&ACL, XPAR_PMODACL_0_AXI_LITE_GPIO_BASEADDR,XPAR_PMODACL_0_AXI_LITE_SPI_BASEADDR);
	SetMeasure(&ACL, FALSE);
	SetGRange(&ACL, PAR_GRANGE_PM4G);
	SetMeasure(&ACL, TRUE);
	CalibrateOneAxisGravitational(&ACL, PAR_AXIS_ZP);
}


void DemoRun()
{
	float x;
	float y;
	float z;
	char strMes[150];
	while (1){
		ReadAccelG(&ACL, &x, &y, &z);
		sprintf(strMes ,"X=%f\tY=%f\tZ=%f\n\r", x, y, z);
		xil_printf(strMes);
		usleep(100000);
	}
}
