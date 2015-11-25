/******************************************************************************
 * @file intc.c
 * Interrupt system initialization.
 *
 * @author Elod Gyorgy
 *
 * @date 2015-Jan-3
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
 * Contains interrupt controller initialization function.
 *
 * <pre>
 * MODIFICATION HISTORY:
 *
 * Ver   Who          Date     Changes
 * ----- ------------ ----------- -----------------------------------------------
 * 1.00  Elod Gyorgy   2015-Jan-3  First release
 * 1.01  Sam Bobrowicz 2015-Nov-20 Added Zynq Support
 *
 * </pre>
 *
 *****************************************************************************/

#include "intc.h"
#include "xparameters.h"

XStatus fnInitInterruptController(INTC *psIntc)
{
#ifdef XPAR_INTC_0_DEVICE_ID

	// Init driver instance
	RETURN_ON_FAILURE(XIntc_Initialize(psIntc, INTC_DEVICE_ID));

	// Start interrupt controller
	RETURN_ON_FAILURE(XIntc_Start(psIntc, XIN_REAL_MODE));

#else
	XScuGic_Config *IntcConfig;

	/*
	 * Initialize the interrupt controller driver so that it is ready to
	 * use.
	 */
	IntcConfig = XScuGic_LookupConfig(INTC_DEVICE_ID);
	if (NULL == IntcConfig) {
		return XST_FAILURE;
	}

	RETURN_ON_FAILURE(XScuGic_CfgInitialize(psIntc, IntcConfig,
					IntcConfig->CpuBaseAddress));
#endif

	return XST_SUCCESS;
}

/*
 * This function enables interrupts and connects interrupt service routines declared in
 * an interrupt vector table
 */
void fnEnableInterrupts(INTC *psIntc, const ivt_t *prgsIvt, unsigned int csIVectors)
{
	unsigned int isIVector;

	Xil_AssertVoid(psIntc != NULL);
	Xil_AssertVoid(psIntc->IsReady == XIL_COMPONENT_IS_READY);

	/* Hook up interrupt service routines from IVT */
	for (isIVector = 0; isIVector < csIVectors; isIVector++)
	{
#ifdef XPAR_INTC_0_DEVICE_ID
		XIntc_Connect(psIntc, prgsIvt[isIVector].id, prgsIvt[isIVector].handler, prgsIvt[isIVector].pvCallbackRef);

		/* Enable the interrupt vector at the interrupt controller */
		XIntc_Enable(psIntc, prgsIvt[isIVector].id);
#else
		XScuGic_SetPriorityTriggerType(psIntc, prgsIvt[isIVector].id,
				prgsIvt[isIVector].priority, prgsIvt[isIVector].trigType);

		XScuGic_Connect(psIntc, prgsIvt[isIVector].id,
					 (Xil_ExceptionHandler)prgsIvt[isIVector].handler, prgsIvt[isIVector].pvCallbackRef);

		XScuGic_Enable(psIntc, prgsIvt[isIVector].id);
#endif
	}

	Xil_ExceptionInit();
	// Register the interrupt controller handler with the exception table.
	// This is in fact the ISR dispatch routine, which calls our ISRs
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
				(Xil_ExceptionHandler)INTC_HANDLER,
				psIntc);
	Xil_ExceptionEnable();

}

