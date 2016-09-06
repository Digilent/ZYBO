/******************************************************************************
 * @file userio.c
 *
 * @authors Elod Gyorgy
 *
 * @date 2015-Jan-15
 *
 * @copyright
 * (c) 2015 Copyright Digilent Incorporated
 * All Rights Reserved
 *
 * This program is free software; distributed under the terms of BSD 3-clause
 * license ("Revised BSD License", "New BSD License", or "Modified BSD License")
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. Neither the name(s) of the above-listed copyright holder(s) nor the names
 *    of its contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 * @desciption
 *
 * @note
 *
 * <pre>
 * MODIFICATION HISTORY:
 *
 * Ver   Who          Date        Changes
 * ----- ------------ ----------- --------------------------------------------
 * 1.00  Elod Gyorgy  2015-Jan-15 First release
 *
 * </pre>
 *
 *****************************************************************************/

#include <stdio.h>
#include "xparameters.h"
#include "userio.h"
#include "../demo.h"

#define USERIO_DEVICE_ID 	0

extern volatile sDemo_t Demo;

void fnUpdateLedsFromSwitches(XGpio *psGpio);

XStatus fnInitUserIO(XGpio *psGpio)
{
	/* Initialize the GPIO driver. If an error occurs then exit */
	RETURN_ON_FAILURE(XGpio_Initialize(psGpio, USERIO_DEVICE_ID));

	/*
	 * Perform a self-test on the GPIO.  This is a minimal test and only
	 * verifies that there is not any bus error when reading the data
	 * register
	 */
	RETURN_ON_FAILURE(XGpio_SelfTest(psGpio));

	/*
	 * Setup direction register so the switches and buttons are inputs and the LED is
	 * an output of the GPIO
	 */
	XGpio_SetDataDirection(psGpio, BTN_SW_CHANNEL, BTNS_SWS_MASK);

	fnUpdateLedsFromSwitches(psGpio);

	/*
	 * Enable the GPIO channel interrupts so that push button can be
	 * detected and enable interrupts for the GPIO device
	 */
	XGpio_InterruptEnable(psGpio, BTN_SW_INTERRUPT);
	XGpio_InterruptGlobalEnable(psGpio);

	return XST_SUCCESS;
}

void fnUpdateLedsFromSwitches(XGpio *psGpio)
{
	static u32 dwPrevButtons = 0;
	u32  dwBtn;
	u32 dwBtnSw;

	dwBtnSw = XGpio_DiscreteRead(psGpio, BTN_SW_CHANNEL);
	dwBtn = dwBtnSw & (BTNU_MASK|BTNR_MASK|BTND_MASK|BTNL_MASK|BTNC_MASK);
	if (dwBtn==0){//No buttons pressed?
		Demo.fUserIOEvent = 0;
		dwPrevButtons = dwBtn;
		return;
	}
	// Has anything changed?
	if ((dwBtn ^ dwPrevButtons))
	{

		u32 dwChanges = 0;


		dwChanges = dwBtn ^ dwPrevButtons;
		if (dwChanges & BTNU_MASK) {
			Demo.chBtn = 'u';
			if(Demo.u8Verbose) {
				xil_printf("\r\nBTNU");
			}
		}
		if (dwChanges & BTNR_MASK) {
			Demo.chBtn = 'r';
			if(Demo.u8Verbose) {
				xil_printf("\r\nBTNR");
			}
		}
		if (dwChanges & BTND_MASK) {
			Demo.chBtn = 'd';
			if(Demo.u8Verbose) {
				xil_printf("\r\nBTND");
			}
		}
		if (dwChanges & BTNL_MASK) {
			Demo.chBtn = 'l';
			if(Demo.u8Verbose) {
				xil_printf("\r\nBTNL");
			}
		}
		if (dwChanges & BTNC_MASK) {
			Demo.chBtn = 'c';
			if(Demo.u8Verbose) {
				xil_printf("\r\nBTNC");
			}
		}

		// Keep values in mind
		//dwPrevSwitches = dwSw;
		Demo.fUserIOEvent = 1;
		dwPrevButtons = dwBtn;
	}
}

/*
 * Default interrupt service routine
 * Lights up LEDs above active switches. Pressing any of the buttons inverts LEDs.
 */
void fnUserIOIsr(void *pvInst)
{
	XGpio *psGpio = (XGpio*)pvInst;

	/*
	 * Disable the interrupt
	 */
	XGpio_InterruptGlobalDisable(psGpio);




	/*
	 * Check if the interrupt interests us
	 */
	if ((XGpio_InterruptGetStatus(psGpio) & BTN_SW_INTERRUPT) !=
			BTN_SW_INTERRUPT) {
		XGpio_InterruptGlobalEnable(psGpio);
		return;
	}

	fnUpdateLedsFromSwitches(psGpio);



	 /* Clear the interrupt such that it is no longer pending in the GPIO */

	XGpio_InterruptClear(psGpio, BTN_SW_INTERRUPT);

	/*
	* Enable the interrupt
	*/
	XGpio_InterruptGlobalEnable(psGpio);
}
