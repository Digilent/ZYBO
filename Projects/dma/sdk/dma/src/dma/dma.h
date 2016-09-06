/*
 * dma.h
 *
 *  Created on: Jan 20, 2015
 *      Author: ROHegbeC
 */

#ifndef DMA_H_
#define DMA_H_

#include "xparameters.h"
#include "xil_printf.h"
#include "xaxidma.h"

/************************** Variable Definitions *****************************/


/************************** Function Definitions *****************************/

void fnS2MMInterruptHandler (void *Callback);
void fnMM2SInterruptHandler (void *Callback);
XStatus fnConfigDma(XAxiDma *AxiDma);

#endif /* DMA_H_ */
