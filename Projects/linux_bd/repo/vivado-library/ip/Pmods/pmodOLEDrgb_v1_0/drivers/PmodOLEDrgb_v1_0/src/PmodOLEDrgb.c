/************************************************************************/
/*																		*/
/*	PmodOLEDrgb.c	--	OLEDrgb Display Driver for Microblaze/Zynq		*/
/*																		*/
/************************************************************************/
/*	Author: 	Cristian Fatu, Thomas Kappenman							*/
/*	Copyright 2015, Digilent Inc.										*/
/************************************************************************/
/*
  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/
/************************************************************************/
/*  Module Description: 												*/
/*																		*/
/*	This module contains the implementation of the object class that	*/
/*	forms the chipKIT interface to the graphics driver functions for	*/
/*	the OLEDrgb display on the Digilent Basic I/O Shield.				*/
/*																		*/
/************************************************************************/
/*  Revision History:													*/
/*																		*/
/*	07/20/2015(CristianF): created										*/
/*  04/19/2015(TommyK): Adapted for use with Microblaze/Zynq .c designs	*/
/*																		*/
/************************************************************************/

/***************************** Include Files *******************************/
#include "PmodOLEDrgb.h"
#include "ChrFont0.h"
#include <stdlib.h>
#include <string.h>

/************************** Function Definitions ***************************/

u8 num_devices=0;
XSpi_Config XSpi_OLEDrgb =
{
	0,
	0,
	1,
	0,
	1,
	8,
	0,
	0,
	0,
	0,
	0
};

/* ------------------------------------------------------------ */
/***	OLEDrgb_begin(void)
**
**	Parameters:
**		InstancePtr		- PmodOLEDrgb object to start
**		GPIO_Address	- XPAR base address of OLEDrgb GPIO interface
**		SPI_Address		- XPAR base address of OLEDrgb SPI interface
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Initialize the OLED display controller and turn the display on.
*/
void OLEDrgb_begin(PmodOLEDrgb* InstancePtr, u32 GPIO_Address, u32 SPI_Address)
{
	int	ib;
	InstancePtr->GPIO_addr=GPIO_Address;
	XSpi_OLEDrgb.BaseAddress=SPI_Address;

	InstancePtr->dxcoOledrgbFontCur = OLEDRGB_CHARBYTES;
	InstancePtr->dycoOledrgbFontCur = 8;

	for (ib = 0; ib < OLEDRGB_CHARBYTES_USER; ib++) {
		InstancePtr->rgbOledrgbFontUser[ib] = 0;
	}
	InstancePtr->xchOledrgbMax = OLEDRGB_WIDTH  / InstancePtr->dxcoOledrgbFontCur;
	InstancePtr->ychOledrgbMax = OLEDRGB_HEIGHT / InstancePtr->dycoOledrgbFontCur;

	OLEDrgb_SetFontColor(InstancePtr, OLEDrgb_BuildRGB(0, 0xFF, 0)); 	// green
	OLEDrgb_SetFontBkColor(InstancePtr, OLEDrgb_BuildRGB(0, 0, 0)); 	// black

	OLEDrgb_SetCurrentFontTable(InstancePtr, (uint8_t*)rgbOledRgbFont0);
	OLEDrgb_SetCurrentUserFontTable(InstancePtr, InstancePtr->rgbOledrgbFontUser);
	OLEDrgb_SPIInit(&InstancePtr->OLEDSpi);
	OLEDrgb_HostInit(InstancePtr);
	OLEDrgb_DevInit(InstancePtr);
}
/* ------------------------------------------------------------ */
/***	OLEDrgb_end(void)
**
**	Parameters:
**		InstancePtr		- PmodOLEDrgb object to stop
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Powers down the device, leaves pins floating, stops SPI controller
*/
void OLEDrgb_end(PmodOLEDrgb* InstancePtr){
	OLEDrgb_HostTerm(InstancePtr);
	OLEDrgb_DevTerm(InstancePtr);
}

/* ------------------------------------------------------------ */
/***	OLEDrgb_DrawPixel
**
**	Parameters:
**		InstancePtr	- PmodOLEDrgb object to draw to
**		c			- column of pixel
**		r			- row of pixel
**		pixelColor	- color of the pixel (565 rgb value)
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Draws a pixel in the specified position using the specified color (565 rgb value)
*/
void OLEDrgb_DrawPixel(PmodOLEDrgb* InstancePtr, uint8_t c, uint8_t r, uint16_t pixelColor)
{
	uint8_t cmds[6];
	uint8_t data[2];
	//set column start and end
	cmds[0] = CMD_SETCOLUMNADDRESS;
	cmds[1] = c;					// Set the starting column coordinates
	cmds[2] = OLEDRGB_WIDTH - 1;					// Set the finishing column coordinates

	//set row start and end
	cmds[3] = CMD_SETROWADDRESS;
	cmds[4] = r;					// Set the starting row coordinates
	cmds[5] = OLEDRGB_HEIGHT - 1;					// Set the finishing row coordinates

	data[0] = pixelColor >> 8;
	data[1] = pixelColor;

	OLEDrgb_WriteSPI(InstancePtr, cmds, 6, data, 2);
}
/* ------------------------------------------------------------ */
/***	OLEDrgb_DrawLine
**
**	Parameters:
**		InstancePtr - PmodOLEDrgb object to draw to
**		c1			- column start address of line
**		r1			- row start address of line
**		c2			- column end address of line
**		r2			- row end address of line
**		lineColor	- color of the line (565 rgb value)
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Draws a line from the specified start position to the specified
**		end position using the specified color (565 rgb value).
*/
void OLEDrgb_DrawLine(PmodOLEDrgb* InstancePtr, uint8_t c1, uint8_t r1, uint8_t c2, uint8_t r2, uint16_t lineColor)
{
	uint8_t cmds[8];
	cmds[0] = CMD_DRAWLINE; 		//draw line
	cmds[1] = c1;					// start column
	cmds[2] = r1;					// start row
	cmds[3] = c2;					// end column
	cmds[4] = r2;					//end row
	cmds[5] = OLEDrgb_ExtractRFromRGB(lineColor);	//R
	cmds[6] = OLEDrgb_ExtractGFromRGB(lineColor);	//G
	cmds[7] = OLEDrgb_ExtractBFromRGB(lineColor);	//R

	OLEDrgb_WriteSPI(InstancePtr, cmds, 8, NULL, 0);
}
/* ------------------------------------------------------------ */
/***	OLEDrgb_DrawRectangle
**
**	Parameters:
**		InstancePtr - PmodOLEDrgb object to draw to
**		c1			- column start address of rectangle
**		r1			- row start address of rectangle
**		c2			- column end address of rectangle
**		r2			- row end address of rectangle
**		lineColor	- color of the rectangle line
**		bFill		- true if rectangle should be filled
**		fillColor	- color used to fill the rectangle (565 rgb value). This parameter can be missed, 0 value will be used
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Draws a rectangle from the specified start position to the specified
**		end position using the specified line color (565 rgb value). According to the
** 		bFill parameter, the rectangle is filled using fillColor (565 rgb value).
*/
void OLEDrgb_DrawRectangle(PmodOLEDrgb* InstancePtr, uint8_t c1, uint8_t r1, uint8_t c2, uint8_t r2, uint16_t lineColor, bool bFill, uint16_t fillColor)
{
	uint8_t cmds[13];
    cmds[0] = CMD_FILLWINDOW;		//fill window
    cmds[1] = (bFill ? ENABLE_FILL: DISABLE_FILL);
    cmds[2] = CMD_DRAWRECTANGLE;	//draw rectangle
	cmds[3] = c1;					// start column
	cmds[4] = r1;					// start row
	cmds[5] = c2;					// end column
	cmds[6] = r2;					//end row

	cmds[7] = OLEDrgb_ExtractRFromRGB(lineColor);	//R
	cmds[8] = OLEDrgb_ExtractGFromRGB(lineColor);	//G
	cmds[9] = OLEDrgb_ExtractBFromRGB(lineColor);	//R


	if(bFill)
	{
		cmds[10] = OLEDrgb_ExtractRFromRGB(fillColor);	//R
		cmds[11] = OLEDrgb_ExtractGFromRGB(fillColor);	//G
		cmds[12] = OLEDrgb_ExtractBFromRGB(fillColor);	//R
	}
	OLEDrgb_WriteSPI(InstancePtr, cmds, bFill ? 13: 10, NULL, 0);
}

/* ------------------------------------------------------------ */
/***	OLEDrgb_clear(void)
**
**	Parameters:
**		InstancePtr - PmodOLEDrgb object to clear
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Clear the display. This clears the memory buffer and then
**		updates the display.
*/
void OLEDrgb_Clear(PmodOLEDrgb* InstancePtr)
{
	uint8_t cmds[5];
	cmds[0] = CMD_CLEARWINDOW; 		// Enter the “clear mode”
	cmds[1] = 0x00;					// Set the starting column coordinates
	cmds[2] = 0x00;					// Set the starting row coordinates
	cmds[3] = OLEDRGB_WIDTH - 1;	// Set the finishing column coordinates;
	cmds[4] = OLEDRGB_HEIGHT - 1;	// Set the finishing row coordinates;
	OLEDrgb_WriteSPI(InstancePtr, cmds, 5, NULL, 0);
	usleep(5);
}
/* ------------------------------------------------------------ */
/***	OLEDrgb_DrawBitmap
**
**	Parameters:
**		InstancePtr - PmodOLEDrgb object to draw to
**		c1			- column start address of bitmap
**		r1			- row start address of bitmap
**		c2			- column end address of bitmap
**		r2			- row end address of bitmap
**		pBmp		- pointer to the 16 bit data array containing pixel colors (565 rgb values)
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Draws a bitmap in the specified rectangle using the array of pixel colors (565 rgb values).
**		The number of pixels in the array should match the surrounding rectangle.
*/
void OLEDrgb_DrawBitmap(PmodOLEDrgb* InstancePtr, uint8_t c1, uint8_t r1, uint8_t c2, uint8_t r2, uint8_t *pBmp)
{
	uint8_t cmds[6];
	//set column start and end
	cmds[0] = CMD_SETCOLUMNADDRESS;
	cmds[1] = c1;					// Set the starting column coordinates
	cmds[2] = c2;					// Set the finishing column coordinates

	//set row start and end
	cmds[3] = CMD_SETROWADDRESS;
	cmds[4] = r1;					// Set the starting row coordinates
	cmds[5] = r2;					// Set the finishing row coordinates

	OLEDrgb_WriteSPI(InstancePtr, cmds, 6, pBmp, (((c2 - c1 + 1)  * (r2 - r1 + 1)) << 1));
	usleep(5);
}

/* ------------------------------------------------------------ */
/***	OLEDrgb_SetCursor
**
**	Parameters:
**		InstancePtr - PmodOLEDrgb object to set
**		xch			- horizontal character position
**		ych			- vertical character position
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Sets the character cursor position to the specified location.
**		If either the specified X or Y location is off the display, it
**		is clamped to be on the display.
*/
void OLEDrgb_SetCursor(PmodOLEDrgb* InstancePtr, int xch, int ych)
{
	/* Clamp the specified location to the display surface
	*/
	if (xch >= InstancePtr->xchOledrgbMax) {
		xch = InstancePtr->xchOledrgbMax - 1;
	}

	if (ych >= InstancePtr->ychOledrgbMax) {
		ych = InstancePtr->ychOledrgbMax - 1;
	}

	/* Save the given character location.
	*/
	InstancePtr->xchOledCur = xch;
	InstancePtr->ychOledCur = ych;
}

/* ------------------------------------------------------------ */
/***	OLEDrgb_GetCursor
**
**	Parameters:
**		InstancePtr - PmodOLEDrgb object to get from
**		pxch		- pointer to variable to receive horizontal position
**		pych		- pointer to variable to receive vertical position
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Fetch the current cursor position
*/
void OLEDrgb_GetCursor(PmodOLEDrgb* InstancePtr, int *pxch, int* pych)
{
	*pxch = InstancePtr->xchOledCur;
	*pych = InstancePtr->ychOledCur;
}

/* ------------------------------------------------------------ */
/***	OLEDrgb_DefUserChar
**
**	Parameters:
**		InstancePtr - PmodOLEDrgb object to define
**		ch		- character code to define
**		pbDef	- definition for the character
**
**	Return Value:
**		none
**
**	Errors:
**		Returns TRUE if successful, FALSE if not
**
**	Description:
**		Give a definition for the glyph for the specified user
**		character code. User definable character codes are in
**		the range 0x00 - 0x1F. If the code specified by ch is
**		outside this range, the function returns false.
**		A character is defined as a sequence of 8 bytes. Each byte describes a vertical slice through the character,
**		having the first byte corresponding to the left side and most significant bit for each byte corresponding to the lower side.
*/
int OLEDrgb_DefUserChar(PmodOLEDrgb* InstancePtr, char ch, uint8_t * pbDef)
{
	uint8_t *	pb;
	int		ib;

	if (ch < OLEDRGB_USERCHAR_MAX) {
		pb = InstancePtr->pbOledrgbFontUser + ch * OLEDRGB_CHARBYTES;
		for (ib = 0; ib < OLEDRGB_CHARBYTES; ib++)
		{
			*pb++ = *pbDef++;
		}
		return 1;
	}
	else
	{
		return 0;
	}
}

/* ------------------------------------------------------------ */
/***	OLEDrgb_DrawGlyph
**
**	Parameters:
**		InstancePtr - PmodOLEDrgb object to draw to
**		ch		- character code of character to draw
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Renders the specified character into the display buffer
**		at the current character cursor location. This does not
**		affect the current character cursor location or the
**		current drawing position in the display buffer.
**		It uses the font color at the background colors.
*/
void OLEDrgb_DrawGlyph(PmodOLEDrgb* InstancePtr, char ch)
{
	uint8_t *	pbFont;
	int	ibx, iby, iw, x, y;
	uint16_t rgwCharBmp[OLEDRGB_CHARBYTES << 4];

	if ((ch & 0x80) != 0) {
		return;
	}

	if (ch < OLEDRGB_USERCHAR_MAX) {
		pbFont = InstancePtr->pbOledrgbFontUser + ch*OLEDRGB_CHARBYTES;
	}
	else if ((ch & 0x80) == 0) {
		pbFont = InstancePtr->pbOledrgbFontCur + (ch - OLEDRGB_USERCHAR_MAX) * OLEDRGB_CHARBYTES;
	}

	iw = 0;
	for(iby = 0; iby < InstancePtr->dycoOledrgbFontCur; iby++)
	{
		for (ibx = 0; ibx < InstancePtr->dxcoOledrgbFontCur; ibx++) {
			if(pbFont[ibx] & (1 << iby))
			{
				// point in glyph
				rgwCharBmp[iw] = InstancePtr->m_FontColor;
			}
			else
			{
				// background
				rgwCharBmp[iw] = InstancePtr->m_FontBkColor;
			}
			iw++;
		}
	}
	x = InstancePtr->xchOledCur*InstancePtr->dxcoOledrgbFontCur;
	y = InstancePtr->ychOledCur*InstancePtr->dycoOledrgbFontCur;

	OLEDrgb_DrawBitmap(InstancePtr, x, y, x + OLEDRGB_CHARBYTES - 1, y  + 7, (u8*)rgwCharBmp);
}

/* ------------------------------------------------------------ */
/***	OLEDrgb_PutChar
**
**	Parameters:
**		InstancePtr - PmodOLEDrgb object to draw to
**		ch			- character to write to display
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Write the specified character to the display at the current
**		cursor position and advance the cursor.
*/
void OLEDrgb_PutChar(PmodOLEDrgb* InstancePtr, char ch)
{
	OLEDrgb_DrawGlyph(InstancePtr, ch);
	OLEDrgb_AdvanceCursor(InstancePtr);
}

/* ------------------------------------------------------------ */
/***	OLEDrgb_PutString
**
**	Parameters:
**		InstancePtr - PmodOLEDrgb object to draw to
**		sz		- pointer to the null terminated string
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Write the specified null terminated character string to the
**		display and advance the cursor.
*/
void OLEDrgb_PutString(PmodOLEDrgb* InstancePtr, char * sz)
{
	while (*sz != '\0') {
		OLEDrgb_DrawGlyph(InstancePtr, *sz);
		OLEDrgb_AdvanceCursor(InstancePtr);
		sz += 1;
	}
}

/* ------------------------------------------------------------ */
/***	OLEDrgb_SetFontColor
**
**	Parameters:
**		InstancePtr - PmodOLEDrgb object to set
**		fontColor	- color to be used as font color when printing characters(565 rgb value)
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Set the color to be used as font color when printing characters (565 rgb value)
**
**
*/
void OLEDrgb_SetFontColor(PmodOLEDrgb* InstancePtr, uint16_t fontColor)
{
	InstancePtr->m_FontColor = fontColor;
}

/* ------------------------------------------------------------ */
/***	OLEDrgb_SetFontBkColor
**
**	Parameters:
**		InstancePtr - PmodOLEDrgb object to set
**		fontBkColor	- color to be used as font background color when printing characters(565 rgb value)
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Set the color to be used as font background color when printing characters (565 rgb value)
**
**
*/
void OLEDrgb_SetFontBkColor(PmodOLEDrgb* InstancePtr, uint16_t fontBkColor)
{
	InstancePtr->m_FontBkColor = fontBkColor;
}

/* ------------------------------------------------------------ */
/***	OLEDrgb_SetCurrentFontTable
**
**	Parameters:
**		InstancePtr - PmodOLEDrgb object to set
**		pbFont - pointer to a font table.
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Define a new font table. The table must contain 8 bytes for each character. The characters correspond to codes 0x20 - 0x7F (96 characters).
**		A character is defined as a sequence of 8 bytes. Each byte describes a vertical slice through the character,
**		having the first byte corresponding to the left side and most significant bit for each byte corresponding to the lower side.
*/
void OLEDrgb_SetCurrentFontTable(PmodOLEDrgb* InstancePtr, uint8_t *pbFont)
{
	InstancePtr->pbOledrgbFontCur = pbFont;
}

/* ------------------------------------------------------------ */
/***	OLEDrgb_SetCurrentUserFontTable
**
**	Parameters:
**		InstancePtr - PmodOLEDrgb object to set
**		pbUserFont - pointer to a font table.
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Define a new user font table. The table must contain 8 bytes for each character. The characters correspond to codes 0x00 - 0x1F (32 characters).
**		The table can define fewer than 32 characters, if there is no need for more user characters.
**		A character is defined as a sequence of 8 bytes. Each byte describes a vertical slice through the character,
**		having the first byte corresponding to the left side and most significant bit for each byte corresponding to the lower side.
*/
void OLEDrgb_SetCurrentUserFontTable(PmodOLEDrgb* InstancePtr, uint8_t *pbUserFont)
{
	InstancePtr->pbOledrgbFontUser = pbUserFont;
}


/* ------------------------------------------------------------ */
/***	OLEDrgb_AdvanceCursor
**
**	Parameters:
**		InstancePtr - PmodOLEDrgb object to advance
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Advance the character cursor by one character location,
**		wrapping at the end of line and back to the top at the
**		end of the display.
*/
void OLEDrgb_AdvanceCursor(PmodOLEDrgb* InstancePtr)
{
	InstancePtr->xchOledCur += 1;
	if (InstancePtr->xchOledCur >= InstancePtr->xchOledrgbMax) {
		InstancePtr->xchOledCur = 0;
		InstancePtr->ychOledCur += 1;
	}
	if (InstancePtr->ychOledCur >= InstancePtr->ychOledrgbMax) {
		InstancePtr->ychOledCur = 0;
	}
	OLEDrgb_SetCursor(InstancePtr, InstancePtr->xchOledCur, InstancePtr->ychOledCur);
}

/* ------------------------------------------------------------ */
/***	OLEDrgb_SetScrolling
**
**	Parameters:
**		InstancePtr 	- PmodOLEDrgb object to set
**		scrollH			- number of column as horizontal scroll offset
**		scrollV			- number of row as vertical scroll offset
**		rowAddr			- start row address
**		rowNum			- number of rows to be scrolled
**		timeInterval	- time interval between each scroll step
**			00b 6 frames
**			01b 10 frames
**			10b 100 frames
**			11b 200 frames
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Configures scrolling (horizontal, vertical, or diagonal), according to the specified parameters for horizontal and/or vertical scrolling.
**		In the end enables scrolling.
*/
void OLEDrgb_SetScrolling(PmodOLEDrgb* InstancePtr, uint8_t scrollH, uint8_t scrollV, uint8_t rowAddr, uint8_t rowNum, uint8_t timeInterval)
{
	u8 cmds[7];
	cmds[0] = CMD_CONTINUOUSSCROLLINGSETUP;
	cmds[1] = scrollH;					// Horizontal scroll
	cmds[2] = rowAddr;					// start row address
	cmds[3] = rowNum; 					// Number of scrolling rows
	cmds[4] = scrollV;					// Vertical scroll
	cmds[5] = timeInterval; 			// time interval
	cmds[6] = CMD_ACTIVESCROLLING;		// Set the starting row coordinates

	OLEDrgb_WriteSPI(InstancePtr, cmds, 7, NULL, 0);
	usleep(5);
}

/* ------------------------------------------------------------ */
/***	OLEDrgb_EnableScrolling
**
**	Parameters:
**		InstancePtr - PmodOLEDrgb object to set
**		fEnable		- the desired action to be taken
			fEnable = true  - the intended operation is Enable Scrolling
			fEnable = false - the intended operation is Disable Scrolling
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Enables / Disables scrolling. Scrolling configuration can be set using the SetScrolling function.
**
*/
void OLEDrgb_EnableScrolling(PmodOLEDrgb* InstancePtr, bool fEnable)
{
	OLEDrgb_WriteSPICommand(InstancePtr, fEnable ? CMD_ACTIVESCROLLING: CMD_DEACTIVESCROLLING);
}

/* ------------------------------------------------------------ */
/***	OLEDrgb_EnablePmod
**
**	Parameters:
**		InstancePtr - PmodOLEDrgb object to enable
**		fEnable		- the desired action to be taken
						fEnable = true  - the intended operation is Enable PmodOLEDRgb
						fEnable = false - the intended operation is Disable PmodOLEDRgb
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Enables / Disables the PmodOLEDrgb, according to the provided parameter.
**		When disabled, the device is put in a low power mode by setting low voltage on PmodEn pin and by putting setting all other Pmod pins to float (high impedance).
** 		When enabled, the PmodEn pin si set to HIGH, olther Pmod pins are declared as output and all the initialization sequence is run again
**		so that all the settings previously made to the device are lost.
**
*/
void OLEDrgb_EnablePmod(PmodOLEDrgb* InstancePtr, bool fEnable)
{
	if(fEnable)
	{
		OLEDrgb_HostInit(InstancePtr);
		OLEDrgb_DevInit(InstancePtr);
	}
	else
	{
		OLEDrgb_DevTerm(InstancePtr);
		OLEDrgb_HostTerm(InstancePtr);
	}
}

/* ------------------------------------------------------------ */
/***	OLEDrgb_EnableBackLight
**
**	Parameters:
**		InstancePtr - PmodOLEDrgb object to configure
**		fEnable		- the desired action to be taken
						fEnable = true  - the intended operation is Enable backlight
						fEnable = false - the intended operation is Disable backlight
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Enable / Disable the Backlight by setting the VCCRef pin to HIGH or LOW and executing Display on / off command
**		All the settings and visual content are preserved when backlight is enabled after it was disabled.

*/
void OLEDrgb_EnableBackLight(PmodOLEDrgb* InstancePtr, bool fEnable)
{
	if (fEnable)
	{
		Xil_Out32(InstancePtr->GPIO_addr+4, Xil_In32(InstancePtr->GPIO_addr+4)&0b1011);
		//pinMode(m_VCCEnPin, OUTPUT);
		Xil_Out32(InstancePtr->GPIO_addr, Xil_In32(InstancePtr->GPIO_addr)|0b0100);
		//digitalWrite(m_VCCEnPin, HIGH);
		usleep(25);
		//delay(DELAY_TIME_VCCEN_HIGH);
		OLEDrgb_WriteSPICommand(InstancePtr, CMD_DISPLAYON);
	}
	else
	{
		OLEDrgb_WriteSPICommand(InstancePtr, CMD_DISPLAYOFF);
		Xil_Out32(InstancePtr->GPIO_addr, Xil_In32(InstancePtr->GPIO_addr)&0b1011);
		//digitalWrite(m_VCCEnPin, LOW);
		Xil_Out32(InstancePtr->GPIO_addr+4, Xil_In32(InstancePtr->GPIO_addr+4)|0b0100);
		//pinMode(m_VCCEnPin, INPUT);
	}
}

/* ------------------------------------------------------------ */
/***	OLEDrgb_Copy
**
**	Parameters:
**		InstancePtr - PmodOLEDrgb object to copy
**		c1			- column start address of rectangle to be copied
**		r1			- row start address of rectangle to be copied
**		c2			- column end address of rectangle to be copied
**		r2			- row end address of rectangle to be copied
**		c3			- column start address of new location
**		r3			- row start address of new location
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Copy the specified rectangle to the new location.
**
*/
void OLEDrgb_Copy(PmodOLEDrgb* InstancePtr, uint8_t c1, uint8_t r1, uint8_t c2, uint8_t r2, uint8_t c3, uint8_t r3)
{
	u8 cmds[7];
	cmds[0] = CMD_COPYWINDOW;
	cmds[1] = c1;					// Set the starting column coordinates
	cmds[2] = r1;					// Set the starting row coordinates
	cmds[3] = c2;					// Set the finishing column coordinates
	cmds[4] = r2;					// Set the finishing row coordinates
	cmds[5] = c3;					// Set the new starting column coordinates
	cmds[6] = r3;					// Set the new starting row coordinates

	OLEDrgb_WriteSPI(InstancePtr, cmds, 7, NULL, 0);
	usleep(5);
}

/* ------------------------------------------------------------ */
/***	OLEDrgb_Dim
**
**	Parameters:
**		InstancePtr - PmodOLEDrgb object to dim
**		c1			- column start address of rectangle to be dimmed
**		r1			- row start address of of rectangle to be dimmed
**		c2			- column end address of of rectangle to be dimmed
**		r2			- row end address of of rectangle to be dimmed
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Dim the content inside the specified rectangle.
**
*/
void OLEDrgb_Dim(PmodOLEDrgb* InstancePtr, uint8_t c1, uint8_t r1, uint8_t c2, uint8_t r2)
{
	u8 cmds[5];
	cmds[0] = CMD_DIMWINDOW;
	cmds[1] = c1;					// Set the starting column coordinates
	cmds[2] = r1;					// Set the starting row coordinates
	cmds[3] = c2;					// Set the finishing column coordinates
	cmds[4] = r2;					// Set the finishing row coordinates

	OLEDrgb_WriteSPI(InstancePtr, cmds, 5, NULL, 0);
	usleep(5);
}

/* ------------------------------------------------------------ */
/***	OLEDrgb_HostInit
**
**	Parameters:
**		InstancePtr - PmodOLEDrgb object to initialize
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Perform FPGA device initialization to prepare for use
**		of the OLEDrgb display.

*/
void OLEDrgb_HostInit(PmodOLEDrgb* InstancePtr)
	{
	Xil_Out32(InstancePtr->GPIO_addr+4, 0x0000);
	Xil_Out32(InstancePtr->GPIO_addr, 0xA);
	//Start the SPI driver so that the device is enabled.
	XSpi_Start(&InstancePtr->OLEDSpi);
	//Disable Global interrupt to use polled mode operation
	XSpi_IntrGlobalDisable(&InstancePtr->OLEDSpi);

}
/* ------------------------------------------------------------ */
/***	OLEDrgb_HostTerm
**
**	Parameters:
**		InstancePtr - PmodOLEDrgb object to terminate
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Releases processor resources used by the library
*/

void OLEDrgb_HostTerm(PmodOLEDrgb* InstancePtr)
{
	XSpi_Stop(&InstancePtr->OLEDSpi);
	// Make signal pins and power control pins be inputs.
	Xil_Out32(InstancePtr->GPIO_addr, 0b0011);
	Xil_Out32(InstancePtr->GPIO_addr+4, 0b1111);
}
/* ------------------------------------------------------------ */
/***	OLEDrgb_DevInit
**
**	Parameters:
**		InstancePtr - PmodOLEDrgb object to initialize
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Initializes the OLEDrgb display controller and turn the display on.
**
**
*/
void OLEDrgb_DevInit(PmodOLEDrgb* InstancePtr)
	{
	u8 cmds[39];


	/*Bring PmodEn HIGH*/
	Xil_Out32(InstancePtr->GPIO_addr,0b1010);
	usleep(20);//Delay for 20us

	/*Assert Reset*/
	Xil_Out32(InstancePtr->GPIO_addr,0b1000);
	usleep(1);
	Xil_Out32(InstancePtr->GPIO_addr,0b1010);
	usleep(2);

	/* command un-lock*/
	cmds[0]=0xFD;
	cmds[1]=0x12;
	/* 5. Univision Initialization Steps*/
	// 5a) Set Display Off
	cmds[2]=CMD_DISPLAYOFF;
	// 5b) Set Remap and Data Format
	cmds[3]=CMD_SETREMAP;
	cmds[4]=0x72;
	// 5c) Set Display Start Line
	cmds[5]=CMD_SETDISPLAYSTARTLINE;
	cmds[6]=0x00;//start line is set at upper left corner
	// 5d) Set Display Offset
	cmds[7]=CMD_SETDISPLAYOFFSET;
	cmds[8]=0x00;//no offset
	// 5e)
	cmds[9]=CMD_NORMALDISPLAY;
	// 5f) Set Multiplex Ratio
	cmds[10]=CMD_SETMULTIPLEXRATIO;
	cmds[11]=0x3F;//64MUX
	// 5g)Set Master Configuration
	cmds[12]=CMD_SETMASTERCONFIGURE;
	cmds[13]=0x8E;
	// 5h)Set Power Saving Mode
	cmds[14]=CMD_POWERSAVEMODE;
	cmds[15]=0x0B;
	// 5i) Set Phase Length
	cmds[16]=CMD_PHASEPERIODADJUSTMENT;
	cmds[17]=0x31;//phase 2 = 14 DCLKs, phase 1 = 15 DCLKS
	// 5j) Send Clock Divide Ratio and Oscillator Frequency
	cmds[18]=CMD_DISPLAYCLOCKDIV;
	cmds[19]=0xF0;//mid high oscillator frequency, DCLK = FpbCllk/2
	// 5k) Set Second Pre-charge Speed of Color A
	cmds[20]=CMD_SETPRECHARGESPEEDA;
	cmds[21]=0x64;
	// 5l) Set Set Second Pre-charge Speed of Color B
	cmds[22]=CMD_SETPRECHARGESPEEDB;
	cmds[23]=0x78;
	// 5m) Set Second Pre-charge Speed of Color C
	cmds[24]=CMD_SETPRECHARGESPEEDC;
	cmds[25]=0x64;
	// 5n) Set Pre-Charge Voltage
	cmds[26]=CMD_SETPRECHARGEVOLTAGE;
	cmds[27]=0x3A;// Pre-charge voltage =...Vcc
	// 50) Set VCOMH Deselect Level
	cmds[28]=CMD_SETVVOLTAGE;
	cmds[29]=0x3E;// Vcomh = ...*Vcc
	// 5p) Set Master Current
	cmds[30]=CMD_MASTERCURRENTCONTROL;
	cmds[31]=0x06;
	// 5q) Set Contrast for Color A
	cmds[32]=CMD_SETCONTRASTA;
	cmds[33]=0x91;
	// 5r) Set Contrast for Color B
	cmds[34]=CMD_SETCONTRASTB;
	cmds[35]=0x50;
	// 5s) Set Contrast for Color C
	cmds[36]=CMD_SETCONTRASTC;
	cmds[37]=0x7D;
	//disable scrolling
	cmds[38]=CMD_DEACTIVESCROLLING;

	OLEDrgb_WriteSPI(InstancePtr, cmds, 39, NULL, 0);

	// 5u) Clear Screen
	OLEDrgb_Clear(InstancePtr);
	/* Turn on VCC and wait for it to become stable*/
	Xil_Out32(InstancePtr->GPIO_addr,0b1110);

	usleep(25);

	/* Send Display On command*/
	OLEDrgb_WriteSPICommand(InstancePtr, CMD_DISPLAYON);

	usleep(100);

}

/* ------------------------------------------------------------ */
/***	OLEDrgb_DevTerm
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
**		Shuts down the OLEDrgb display hardware
*/
void OLEDrgb_DevTerm(PmodOLEDrgb* InstancePtr)
{
	OLEDrgb_WriteSPICommand(InstancePtr, CMD_DISPLAYOFF);
	Xil_Out32(InstancePtr->GPIO_addr, Xil_In32(InstancePtr->GPIO_addr)&0b1011);
	usleep(400);
}
/* ------------------------------------------------------------ */
/***	OLEDrgb_SPIInit
**
**	Parameters:
**		InstancePtr - SPI object to initialize
**
**	Return Value:
**		0 if success
**
**	Errors:
**		none
**
**	Description:
**		Configures the XSpi object for use with the PmodOLEDrgb
**
**
*/
int OLEDrgb_SPIInit(XSpi *SpiInstancePtr){
	int Status;

	Status = XSpi_CfgInitialize(SpiInstancePtr, &XSpi_OLEDrgb, XSpi_OLEDrgb.BaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Set the Spi device as a master and in loopback mode.
	 */
	Status = XSpi_SetOptions(SpiInstancePtr, (XSP_MASTER_OPTION) & ~XSP_MANUAL_SSELECT_OPTION); //Might need to be OR'ed with 0x4 for phase also
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	Status = XSpi_SetSlaveSelect(SpiInstancePtr, 1);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}


	return XST_SUCCESS;
}

/* ------------------------------------------------------------ */
/***	OLEDrgb_WriteSPICommand
**
**	Parameters:
**		InstancePtr - PmodOLEDrgb object to initialize
**		cmd			- Command to send
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Writes a single byte over SPI
**
**
*/
void OLEDrgb_WriteSPICommand(PmodOLEDrgb* InstancePtr, uint8_t cmd)
{
	XSpi_Transfer(&InstancePtr->OLEDSpi, &cmd, NULL, 1);
}

/* ------------------------------------------------------------ */
/***	OLEDrgb_WriteSPI
**
**	Parameters:
**		InstancePtr - PmodOLEDrgb object to initialize
**		pCmd		- Array of byte commands to send
**		nCmd		- Number of commands to send
**		pData		- Data values corresponding to the previous command
**		nData		- Number of data values
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Writes a series of commands followed by data over SPI
**
**
*/
void OLEDrgb_WriteSPI(PmodOLEDrgb* InstancePtr, uint8_t *pCmd, int nCmd, uint8_t *pData, int nData)
{
	XSpi_Transfer(&InstancePtr->OLEDSpi, pCmd, 0, nCmd);
	if (nData!= 0){
		Xil_Out32(InstancePtr->GPIO_addr,0b1111);
		XSpi_Transfer(&InstancePtr->OLEDSpi, pData, 0, nData);
		Xil_Out32(InstancePtr->GPIO_addr,0b1110);
	}

}
/* ------------------------------------------------------------ */
/***	OLEDrgb_BuildHSV
**
**	Parameters:
**		hue		- Hue of color
**		sat		- Saturation of color
**		val		- Value of color
**
**	Return Value:
**		RGB representation of input color in 16-bit (565) color format
**
**	Errors:
**		none
**
**	Description:
**		Converts an HSV value into a 565 RGB color used by the OLEDrgb
**
**
*/
uint16_t OLEDrgb_BuildHSV(uint8_t hue, uint8_t sat, uint8_t val){
   uint8_t region, remain, p, q, t;
   uint8_t R,G,B;
   region = hue/43;
   remain = (hue - (region * 43))*6;
   p = (val * (255-sat))>>8;
   q = (val * (255 - ((sat * remain)>>8)))>>8;
   t = (val * (255 - ((sat * (255 - remain))>>8)))>>8;

   switch(region){
      case 0:
       R = val;
       G = t;
       B = p;
       break;
      case 1:
       R = q;
       G = val;
       B = p;
       break;
      case 2:
       R = p;
       G = val;
       B = t;
       break;
       case 3:
       R = p;
       G = q;
       B = val;
       break;
       case 4:
       R = t;
       G = p;
       B = val;
       break;
       default:
       R = val;
       G = p;
       B = q;
       break;
   }
   return OLEDrgb_BuildRGB(R,G,B);
}

/* ------------------------------------------------------------ */
/***	OLEDrgb_BuildRGB
**
**	Parameters:
**		R		- Red value
**		G		- Green Value
**		B		- Blue Value
**
**	Return Value:
**		RGB representation of input color in 16-bit (565) color format
**
**	Errors:
**		none
**
**	Description:
**		Converts separate RGB values into a 565 RGB value used by the OLEDrgb
**
**
*/
uint16_t OLEDrgb_BuildRGB(uint8_t R,uint8_t G,uint8_t B){return ((R>>3)<<11) | ((G>>2)<<5) | (B>>3);};
/* ------------------------------------------------------------ */
/***	OLEDrgb_ExtractXFromRGB
**
**	Parameters:
**		wRGB	- 565 color value
**
**	Return Value:
**		X color value
**
**	Errors:
**		none
**
**	Description:
**		Extracts the [Red,Green,Blue] value from the 565 color value
**
**
*/
uint8_t OLEDrgb_ExtractRFromRGB(uint16_t wRGB){return (uint8_t)((wRGB>>11)&0x1F);};
uint8_t OLEDrgb_ExtractGFromRGB(uint16_t wRGB){return (uint8_t)((wRGB>>5)&0x3F);};
uint8_t OLEDrgb_ExtractBFromRGB(uint16_t wRGB){return (uint8_t)(wRGB&0x1F);};

