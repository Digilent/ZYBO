#include "xparameters.h"
#include "xil_cache.h"
#include "PmodGPS.h"

void DemoInitialize();
void DemoRun();

PmodGPS GPS;

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
	GPS_begin(&GPS, XPAR_PMODGPS_0_AXI_LITE_GPIO_BASEADDR, XPAR_PMODGPS_0_AXI_LITE_UART_BASEADDR);
	#ifndef NO_IRPT //If there are interrupts
		//GPS_SetupInterruptSystem(&GPS,XPAR_INTC_0_DEVICE_ID, XPAR_INTC_0_PMODGPS_0_VEC_ID);//Set up interrupts, Microblaze System
		GPS_SetupInterruptSystem(&GPS, XPAR_PS7_SCUGIC_0_DEVICE_ID, XPAR_FABRIC_PMODGPS_0_GPS_UART_INTERRUPT_INTR);//Setup interrupts, Zynq
	#endif

	GPS_setUpdateRate(&GPS, 1000);
}


void DemoRun()
{
	while(1){

#ifdef NO_IRPT //If no interrupts
		GPS_getData(&GPS);//Receive data from GPS in Polled Mode
#endif
		if (GPS.ping==true){
			GPS_formatSentence(&GPS);
			if (GPS_isFixed(&GPS)){
				xil_printf("Latitude: %s\n\r",GPS_getLatitude(&GPS));
				  xil_printf("Longitude: %s\n\r",GPS_getLongitude(&GPS));
				  xil_printf("Altitude: %s\n\r",GPS_getAltitudeString(&GPS));
				  xil_printf("Number of Satellites: %d\n\n\r",GPS_getNumSats(&GPS));
			}
			else{
				xil_printf("Number of Satellites: %d\n\r", GPS_getNumSats(&GPS));
			}
			GPS.ping=false;
		}
	}
}


