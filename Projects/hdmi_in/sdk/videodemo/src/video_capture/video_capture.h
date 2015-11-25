/******************************************************************************
 * @file video_capture.h
 * Digilent Video Capture Driver
 *
 * @author Sam Bobrowicz
 *
 * @date 2015-Nov-25
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
 * This module provides an easy to use API for streaming video into memory
 * on a Digilent system board. It currently has only been tested with HDMI
 * input streams, but other video sources such as an image sensor or displayport
 * should work with minor modifications. Current features include seamless
 * framebuffer-swapping, ability to pause/start streaming, and attaching a callback
 * function that is called on video detection and signal loss. The driver can
 * also be configured to automatically start streaming into memory when a video
 * signal is detected.
 *
 * To use this driver you must have a Xilinx Video Timing Controller core (vtc),
 * Xilinx axi_vdma core, Xilinx Video to AXI Stream core, Digilent DVI2RGB core,
 * and an axi_gpio core (for Hot-plug detect and signal lock detection) present
 * in your design. See the Video/Display reference projects for your system board
 * to see how they need to be connected. Digilent reference projects and IP cores
 * can be found at www.github.com/Digilent.
 *
 * <pre>
 * MODIFICATION HISTORY:
 *
 * Ver   Who          Date         Changes
 * ----- ------------ -----------  -----------------------------------------------
 * 1.00  Sam Bobrowicz 2015-Nov-25 First Release
 *
 * </pre>
 *
 *****************************************************************************/

#ifndef VIDEO_CAPTURE_H_
#define VIDEO_CAPTURE_H_

/* ------------------------------------------------------------ */
/*				Include File Definitions						*/
/* ------------------------------------------------------------ */

#include "xil_types.h"
#include "xaxivdma.h"
#include "xvtc.h"
#include "xgpio.h"
#include "../intc/intc.h"

/* ------------------------------------------------------------ */
/*					Miscellaneous Declarations					*/
/* ------------------------------------------------------------ */

/*
 * This driver currently supports 3 frames.
 */
#define VIDEO_NUM_FRAMES 3

/*
 * These constants define the pins that the HPD and pixel clock
 * locked signals are connected to on the AXI GPIO core
 */
#define HPD_CHANNEL 1
#define HPD_MASK 0x1
#define LOCKED_CHANNEL 2
#define LOCKED_MASK 0x1

/*
 * Macro for the GPIO IVT.
 * 	x=GPIO controller Interrupt ID
 * 	y=pointer to VideoCapture struct
 */
#define videoGpioIvt(x,y)\
	{x, (XInterruptHandler)GpioIsr, y, 0xA0, 0x3}
/*
 * Macro for the VTC IVT.
 * 	x=VTC Interrupt ID
 * 	y=pointer to XVtc struct referred to by VideoCapture struct
 */
#define videoVtcIvt(x,y)\
	{x, (XInterruptHandler)XVtc_IntrHandler, y, 0xB0, 0x3}


/* ------------------------------------------------------------ */
/*					General Type Declarations					*/
/* ------------------------------------------------------------ */

typedef enum {
	VIDEO_DISCONNECTED = 0,
	VIDEO_STREAMING = 1,
	VIDEO_PAUSED = 2
} VideoState;

/*
 * typedef for the video detector callback function.
 */
typedef void (*VideoCallBack)(void *callBackRef, void *pVideo);

typedef struct {
		XAxiVdma *vdma; /*VDMA driver struct*/
		XAxiVdma_DmaSetup vdmaConfig; /*VDMA channel configuration*/
		VideoCallBack callBack;
		void *callBackRef;
		XVtc vtc; /*VTC driver struct*/
		XVtc_Timing timing;
		INTC *intc; /*Interrupt controller driver struct*/
		u8 *framePtr[VIDEO_NUM_FRAMES]; /* Array of pointers to the framebuffers */
		u32 stride; /* The line stride of the framebuffers, in bytes */
		u32 curFrame; /* Current frame being displayed */
		XGpio gpio; /* XGPIO driver struct */
		u16 vtcId; /* Device ID of VTC core as defined in xparameters.h */
		u16 vtcIrptId; /* Interrupt ID for the VTC core */
		u32 startOnDetect; /* boolean Flag indicating whether or not the VDMA should be started in the interrupt when a signal is detected */
		VideoState state; /* Indicates if the Display is currently running */
} VideoCapture;

/* ------------------------------------------------------------ */
/*					Variable Declarations						*/
/* ------------------------------------------------------------ */

/* ------------------------------------------------------------ */
/*					Procedure Declarations						*/
/* ------------------------------------------------------------ */

int VideoStop(VideoCapture *videoPtr);
int VideoStart(VideoCapture *videoPtr);
int VideoInitialize(VideoCapture *videoPtr, INTC *intCtrl, XAxiVdma *vdma, u16 gpioId, u16 vtcId, u32 vtcIrptId, u8 *framePtr[VIDEO_NUM_FRAMES], u32 stride, u32 startOnDet);
int VideoChangeFrame(VideoCapture *videoPtr, u32 frameIndex);
void VideoSetCallback(VideoCapture *videoPtr, VideoCallBack CallBackFunc, void *CallBackRef);
void GpioIsr(void *InstancePtr);
void VtcIsr(void *InstancePtr, u32 pendingIrpt);
int SetupInterruptSystem(VideoCapture *videoPtr);

/* ------------------------------------------------------------ */

/************************************************************************/

#endif /* VIDEO_CAPTURE_H_ */

