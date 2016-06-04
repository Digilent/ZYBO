/*
 * main.cpp
 *
 *  Created on: Feb 8, 2016
 *      Author: tkappenm
 */
#include "xil_types.h"
#include "xil_cache.h"
#include "bitmap.h"

#include "xparameters.h"
#include "PmodOLEDrgb.h"
void DemoInitialize();
void DemoRun();

PmodOLEDrgb oledrgb;

uint8_t rgbUserFont[] = {
	0x00, 0x04, 0x02, 0x1F, 0x02, 0x04, 0x00, 0x00,	// 0x00
	0x0E, 0x1F, 0x15, 0x1F, 0x17, 0x10, 0x1F, 0x0E,	// 0x01
	0x00, 0x1F, 0x11, 0x00, 0x00, 0x11, 0x1F, 0x00,	// 0x02
	0x00, 0x0A, 0x15, 0x11, 0x0A, 0x04, 0x00, 0x00,	// 0x03
        0x07, 0x0C, 0xFA, 0x2F, 0x2F, 0xFA, 0x0C, 0x07  // 0x04
}; // this table defines 5 user characters, although only one is used



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
	OLEDrgb_begin(&oledrgb, XPAR_PMODOLEDRGB_0_AXI_LITE_GPIO_BASEADDR, XPAR_PMODOLEDRGB_0_AXI_LITE_SPI_BASEADDR);
}


void DemoRun()
{
	char ch;

	/* Define the user definable characters .
	  */
	  for (ch = 0; ch < 5; ch++) {
	    OLEDrgb_DefUserChar(&oledrgb,ch, &rgbUserFont[ch*8]);
	  }

	  OLEDrgb_SetCursor(&oledrgb, 2, 1);
	  OLEDrgb_PutString(&oledrgb,"Digilent"); // default color (green)
	  OLEDrgb_SetCursor(&oledrgb, 4, 4);
	  OLEDrgb_SetFontColor(&oledrgb ,OLEDrgb_BuildRGB(  0,  0, 255)); // blue font
	  OLEDrgb_PutString(&oledrgb,"OledRGB");

	  OLEDrgb_SetFontColor(&oledrgb,OLEDrgb_BuildRGB( 200, 200, 44));
	  OLEDrgb_SetCursor(&oledrgb,1, 6);
	  OLEDrgb_PutChar(&oledrgb, 4);

	  OLEDrgb_SetFontColor(&oledrgb,OLEDrgb_BuildRGB(200, 12,44));
	  OLEDrgb_SetCursor(&oledrgb,5, 6);
	  OLEDrgb_PutString(&oledrgb,"Demo");
	  OLEDrgb_PutChar(&oledrgb, 0);

	  usleep(5000);//Wait 5 seconds

	  OLEDrgb_DrawBitmap(&oledrgb,0,0,95,63, (u8*)tommy);
}
