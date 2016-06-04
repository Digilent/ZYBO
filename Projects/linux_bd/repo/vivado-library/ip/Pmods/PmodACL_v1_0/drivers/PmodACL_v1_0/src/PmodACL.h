
#ifndef PMODACL_H
#define PMODACL_H


/****************** Include Files ********************/
#include "xil_types.h"
#include "xstatus.h"
#include "xspi_l.h"
#include "xspi.h"

/* ------------------------------------------------------------ */
/*					Definitions									*/
/* ------------------------------------------------------------ */
#define bool u8
#define true 1
#define false 0


#define MAX_SIZE  128

#define ACL_NO_BITS		10
#define ACL_I2C_ADDR	0x1D
#define ACL_CONV_OFFSET_G_LSB (15.6 * 0.001) 	// convert offset (g) to LSB, 15.6 mg/LSB
/* ------------------------------------------------------------ */
/*		Register addresses Definitions							*/
/* ------------------------------------------------------------ */
#define	ACL_ADR_DEVID 			0x00
#define	ACL_ADR_OFSX			0x1E
#define	ACL_ADR_OFSY 			0x1F
#define	ACL_ADR_OFSZ 			0x20
#define	ACL_ADR_DUR 			0x21
#define	ACL_ADR_LATENT			0x22
#define	ACL_ADR_WINDOW			0x23
#define	ACL_ADR_THRESH_ACT 		0x24
#define	ACL_ADR_THRESH_INACT 	0x25
#define	ACL_ADR_TIME_INACT 		0x26
#define	ACL_ADR_ACT_INACT_CTL 	0x27
#define	ACL_ADR_THRESH_FF 		0x28
#define	ACL_ADR_TIME_FF 		0x29
#define	ACL_ADR_BW_RATE 		0x2C
#define	ACL_ADR_POWER_CTL 		0x2D
#define	ACL_ADR_INT_ENABLE 		0x2E
#define	ACL_ADR_INT_MAP 		0x2F
#define	ACL_ADR_INT_SOURCE 		0x30
#define	ACL_ADR_DATA_FORMAT 	0x31
#define	ACL_ADR_DATAX0			0x32
#define	ACL_ADR_DATAX1			0x33
#define	ACL_ADR_DATAY0			0x34
#define	ACL_ADR_DATAY1			0x35
#define	ACL_ADR_DATAZ0			0x36
#define	ACL_ADR_DATAZ1			0x37
#define	ACL_ADR_FIFO_CTL 		0x38
#define	ACL_ADR_FIFO_STATUS		0x39
/* ------------------------------------------------------------ */
/*				Bit masks Definitions							*/
/* ------------------------------------------------------------ */
#define	MSK_POWER_CTL_MEASURE			1<<3
#define	MSK_DATA_FORMAT_RANGE0			1<<0
#define	MSK_DATA_FORMAT_RANGE1			1<<1

/* ------------------------------------------------------------ */
/*				Parameters Definitions							*/
/* ------------------------------------------------------------ */

#define	PAR_ACCESS_DSPI0		0
#define	PAR_ACCESS_DSPI1		1
#define	PAR_ACCESS_DSPI2		2
#define	PAR_ACCESS_I2C			10
#define	PAR_GRANGE_PM2G		0
#define	PAR_GRANGE_PM4G		1
#define	PAR_GRANGE_PM8G		2
#define	PAR_GRANGE_PM16G	3
#define	PAR_AXIS_XP				0
#define	PAR_AXIS_XN				1
#define	PAR_AXIS_YP				2
#define	PAR_AXIS_YN				3
#define	PAR_AXIS_ZP				4
#define	PAR_AXIS_ZN				5
#define	PAR_AXIS_X				0
#define	PAR_AXIS_Y				1
#define	PAR_AXIS_Z				2

/* ------------------------------------------------------------ */
/*					Procedure Declarations						*/
/* ------------------------------------------------------------ */

typedef struct PmodACL{
	u32 GPIO_addr;
	XSpi ACLSpi;
	float m_dGRangeLSB;
}PmodACL;

	int ACL_SPIInit(XSpi *SpiInstancePtr);

	void ACL_begin(PmodACL* InstancePtr, u32 GPIO_Address, u32 SPI_Address);
	void ACL_WriteSpi(PmodACL* InstancePtr, uint8_t reg, uint8_t *wData, int nData);
	void ACL_ReadSpi(PmodACL* InstancePtr, uint8_t reg, uint8_t *rData, int nData);
	void SetRegisterBits(PmodACL* InstancePtr, uint8_t reg, uint8_t mask, bool fValue);
	uint8_t GetRegisterBits(PmodACL* InstancePtr, uint8_t bRegisterAddress, uint8_t bMask);
	float ConvertReadingToValueG(PmodACL* InstancePtr, int16_t uiReading);
	float GetGRangeLSB(uint8_t bGRange);
	void ReadAccelG(PmodACL* InstancePtr, float *dAclXg, float *dAclYg, float *dAclZg);
	void ReadAccel(PmodACL* InstancePtr, int16_t *iAclX, int16_t *iAclY, int16_t *iAclZ);
	void SetMeasure(PmodACL* InstancePtr, bool fMeasure);
	bool GetMeasure(PmodACL* InstancePtr);
	void SetGRange(PmodACL *InstancePtr, uint8_t bGRangePar);
	uint8_t GetGRange(PmodACL* InstancePtr);
	void SetOffsetG(PmodACL* InstancePtr, uint8_t bAxisParam, float dOffset);
	float GetOffsetG(PmodACL* InstancePtr, uint8_t bAxisParam);
	void CalibrateOneAxisGravitational(PmodACL* InstancePtr, uint8_t bAxisInfo);





#endif // PMODACL_H
