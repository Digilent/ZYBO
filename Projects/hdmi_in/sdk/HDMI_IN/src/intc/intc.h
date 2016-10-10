/******************************************************************************
 * @file intc.h
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
 * Ver   Who           Date        Changes
 * ----- ------------  ----------- -----------------------------------------------
 * 1.00  Elod Gyorgy   2015-Jan-3  First release
 * 1.01  Sam Bobrowicz 2015-Nov-20 Added Zynq Support
 *
 * </pre>
 *
 *****************************************************************************/

#ifndef INTC_H_
#define INTC_H_

#include "xstatus.h"

/*
 * TODO: check if there is a better preprocessor check to determine
 *       if this is a microblaze or zynq system.
 */
#ifdef XPAR_INTC_0_DEVICE_ID
 #include "xintc.h"
#else
 #include "xscugic.h"
#endif

#ifdef XPAR_INTC_0_DEVICE_ID
 #define INTC_DEVICE_ID	XPAR_INTC_0_DEVICE_ID
 #define INTC		XIntc
 #define INTC_HANDLER	XIntc_InterruptHandler
#else
 #define INTC_DEVICE_ID	XPAR_SCUGIC_SINGLE_DEVICE_ID
 #define INTC		XScuGic
 #define INTC_HANDLER	XScuGic_InterruptHandler
#endif

#define RETURN_ON_FAILURE(x) if ((x) != XST_SUCCESS) return XST_FAILURE;

/*
 * Structure for interrupt id, handler and callback reference
 */
typedef struct {
	u8 id;
	XInterruptHandler handler;
	void *pvCallbackRef;
	u8 priority; //not used for microblaze, set to 0
	u8 trigType; //not used for microblaze, set to 0
} ivt_t;

XStatus fnInitInterruptController(INTC *psIntc);
void fnEnableInterrupts(INTC *psIntc, const ivt_t *prgsIvt, unsigned int csIVectors);

#endif /* INTC_H_ */
