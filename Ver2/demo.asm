;CodeVisionAVR C Compiler V1.24.5 Standard
;(C) Copyright 1998-2005 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;e-mail:office@hpinfotech.com

;Chip type              : ATmega128
;Program type           : Application
;Clock frequency        : 14,745600 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : long, width
;(s)scanf features      : long, width
;External SRAM size     : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 2268 byte(s)
;Promote char to int    : No
;char is unsigned       : Yes
;8 bit enums            : Yes
;Word align FLASH struct: Yes
;Enhanced core instructions    : On
;Automatic register allocation : On

	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __CLRD1S
	LDI  R30,0
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+@1)
	LDI  R31,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+@2)
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+@3)
	LDI  R@1,HIGH(@2+@3)
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+@1
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	LDS  R22,@0+@1+2
	LDS  R23,@0+@1+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@2,@0+@1
	.ENDM

	.MACRO __GETWRMN
	LDS  R@2,@0+@1
	LDS  R@3,@0+@1+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+@1
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	LDS  R24,@0+@1+2
	LDS  R25,@0+@1+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+@1,R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	STS  @0+@1+2,R22
	STS  @0+@1+3,R23
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+@1,R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+@1,R@2
	STS  @0+@1+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	ICALL
	.ENDM


	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	CALL __GETW1PF
	ICALL
	.ENDM


	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMRDW
	ICALL
	.ENDM


	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOV  R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOV  R30,R0
	.ENDM

	.CSEG
	.ORG 0

	.INCLUDE "demo.vec"
	.INCLUDE "demo.inc"

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30
	OUT  RAMPZ,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,13
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x724)
	LDI  R25,HIGH(0x724)
	LDI  R26,LOW(0x100)
	LDI  R27,HIGH(0x100)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x823)
	OUT  SPL,R30
	LDI  R30,HIGH(0x823)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x500)
	LDI  R29,HIGH(0x500)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500
;       1 /*********************************************
;       2 Project : FlashFileSD Example
;       3 Version : 
;       4 Date    : 12/23/2003
;       5 Author  : Erick M Higa    
;       6 Company : Progressive Resources LLC       
;       7 Comments: 
;       8 This is a simple example program for the FlashFileSD
;       9 
;      10 
;      11 Chip type           : ATmega128
;      12 Program type        : Application
;      13 Clock frequency     : 14.745600 MHz
;      14 Memory model        : Small
;      15 External SRAM size  : 0
;      16 Data Stack size     : 1024
;      17 *********************************************/
;      18 
;      19 
;      20 #include "options.h"
;      21 /*
;      22 	Progressive Resources LLC
;      23                                     
;      24 			FlashFile
;      25 	
;      26 	Version : 	1.32
;      27 	Date: 		12/31/2003
;      28 	Author: 	Erick M. Higa
;      29                                            
;      30 	Software License
;      31 	The use of Progressive Resources LLC FlashFile Source Package indicates 
;      32 	your understanding and acceptance of the following terms and conditions. 
;      33 	This license shall supersede any verbal or prior verbal or written, statement 
;      34 	or agreement to the contrary. If you do not understand or accept these terms, 
;      35 	or your local regulations prohibit "after sale" license agreements or limited 
;      36 	disclaimers, you must cease and desist using this product immediately.
;      37 	This product is © Copyright 2003 by Progressive Resources LLC, all rights 
;      38 	reserved. International copyright laws, international treaties and all other 
;      39 	applicable national or international laws protect this product. This software 
;      40 	product and documentation may not, in whole or in part, be copied, photocopied, 
;      41 	translated, or reduced to any electronic medium or machine readable form, without 
;      42 	prior consent in writing, from Progressive Resources LLC and according to all 
;      43 	applicable laws. The sole owner of this product is Progressive Resources LLC.
;      44 
;      45 	Operating License
;      46 	You have the non-exclusive right to use any enclosed product but have no right 
;      47 	to distribute it as a source code product without the express written permission 
;      48 	of Progressive Resources LLC. Use over a "local area network" (within the same 
;      49 	locale) is permitted provided that only a single person, on a single computer 
;      50 	uses the product at a time. Use over a "wide area network" (outside the same 
;      51 	locale) is strictly prohibited under any and all circumstances.
;      52                                            
;      53 	Liability Disclaimer
;      54 	This product and/or license is provided as is, without any representation or 
;      55 	warranty of any kind, either express or implied, including without limitation 
;      56 	any representations or endorsements regarding the use of, the results of, or 
;      57 	performance of the product, Its appropriateness, accuracy, reliability, or 
;      58 	correctness. The user and/or licensee assume the entire risk as to the use of 
;      59 	this product. Progressive Resources LLC does not assume liability for the use 
;      60 	of this product beyond the original purchase price of the software. In no event 
;      61 	will Progressive Resources LLC be liable for additional direct or indirect 
;      62 	damages including any lost profits, lost savings, or other incidental or 
;      63 	consequential damages arising from any defects, or the use or inability to 
;      64 	use these products, even if Progressive Resources LLC have been advised of 
;      65 	the possibility of such damages.
;      66 */                                 
;      67 
;      68 /*
;      69 #include _AVR_LIB_
;      70 #include <stdio.h>
;      71 
;      72 #ifndef _file_sys_h_
;      73 	#include "..\flash\file_sys.h"
;      74 #endif
;      75 */
;      76 
;      77 unsigned long OCR_REG;
_OCR_REG:
	.BYTE 0x4
;      78 unsigned char _FF_buff[512];
__FF_buff:
	.BYTE 0x200
;      79 unsigned int PT_SecStart;
;      80 unsigned long BS_jmpBoot;
_BS_jmpBoot:
	.BYTE 0x4
;      81 unsigned int BPB_BytsPerSec;
;      82 unsigned char BPB_SecPerClus;
;      83 unsigned int BPB_RsvdSecCnt;
;      84 unsigned char BPB_NumFATs;
;      85 unsigned int BPB_RootEntCnt;
;      86 unsigned int BPB_FATSz16;
_BPB_FATSz16:
	.BYTE 0x2
;      87 unsigned char BPB_FATType;
;      88 unsigned long BPB_TotSec;
_BPB_TotSec:
	.BYTE 0x4
;      89 unsigned long BS_VolSerial;
_BS_VolSerial:
	.BYTE 0x4
;      90 unsigned char BS_VolLab[12];
_BS_VolLab:
	.BYTE 0xC
;      91 unsigned long _FF_PART_ADDR, _FF_ROOT_ADDR, _FF_DIR_ADDR;
__FF_PART_ADDR:
	.BYTE 0x4
__FF_ROOT_ADDR:
	.BYTE 0x4
__FF_DIR_ADDR:
	.BYTE 0x4
;      92 unsigned long _FF_FAT1_ADDR, _FF_FAT2_ADDR;
__FF_FAT1_ADDR:
	.BYTE 0x4
__FF_FAT2_ADDR:
	.BYTE 0x4
;      93 unsigned long _FF_RootDirSectors;
__FF_RootDirSectors:
	.BYTE 0x4
;      94 unsigned int FirstDataSector;
_FirstDataSector:
	.BYTE 0x2
;      95 unsigned long FirstSectorofCluster;
_FirstSectorofCluster:
	.BYTE 0x4
;      96 unsigned char _FF_error;
__FF_error:
	.BYTE 0x1
;      97 unsigned long _FF_buff_addr;
__FF_buff_addr:
	.BYTE 0x4
;      98 extern unsigned long clus_0_addr, _FF_n_temp;
;      99 extern unsigned int c_counter;
;     100 extern unsigned char _FF_FULL_PATH[_FF_PATH_LENGTH];
;     101 
;     102 unsigned long DataClusTot;
_DataClusTot:
	.BYTE 0x4
;     103 
;     104 flash struct CMD
;     105 {
;     106 	unsigned int index;
;     107 	unsigned int tx_data;
;     108 	unsigned int arg;
;     109 	unsigned int resp;
;     110 };
;     111 
;     112 flash struct CMD sd_cmd[CMD_TOT] =

	.CSEG
;     113 {
;     114 	{CMD0,	0x40,	NO_ARG,		RESP_1},		// GO_IDLE_STATE
;     115 	{CMD1,	0x41,	NO_ARG,		RESP_1},		// SEND_OP_COND (ACMD41 = 0x69)
;     116 	{CMD9,	0x49,	NO_ARG,		RESP_1},		// SEND_CSD
;     117 	{CMD10,	0x4A,	NO_ARG,		RESP_1},		// SEND_CID
;     118 	{CMD12,	0x4C,	NO_ARG,		RESP_1},		// STOP_TRANSMISSION
;     119 	{CMD13,	0x4D,	NO_ARG,		RESP_2},		// SEND_STATUS
;     120 	{CMD16,	0x50,	BLOCK_LEN,	RESP_1},		// SET_BLOCKLEN
;     121 	{CMD17, 0x51,	DATA_ADDR,	RESP_1},		// READ_SINGLE_BLOCK
;     122 	{CMD18, 0x52,	DATA_ADDR,	RESP_1},		// READ_MULTIPLE_BLOCK
;     123 	{CMD24, 0x58,	DATA_ADDR,	RESP_1},		// WRITE_BLOCK
;     124 	{CMD25, 0x59,	DATA_ADDR,	RESP_1},		// WRITE_MULTIPLE_BLOCK
;     125 	{CMD27,	0x5B,	NO_ARG,		RESP_1},		// PROGRAM_CSD
;     126 	{CMD28, 0x5C,	DATA_ADDR,	RESP_1b},		// SET_WRITE_PROT
;     127 	{CMD29, 0x5D,	DATA_ADDR,	RESP_1b},		// CLR_WRITE_PROT
;     128 	{CMD30, 0x5E,	DATA_ADDR,	RESP_1},		// SEND_WRITE_PROT
;     129 	{CMD32,	0x60,	DATA_ADDR,	RESP_1},		// TAG_SECTOR_START
;     130 	{CMD33,	0x61,	DATA_ADDR,	RESP_1},		// TAG_SECTOR_END
;     131 	{CMD34,	0x62,	DATA_ADDR,	RESP_1},		// UNTAG_SECTOR
;     132 	{CMD35,	0x63,	DATA_ADDR,	RESP_1},		// TAG_ERASE_GROUP_START
;     133 	{CMD36,	0x64,	DATA_ADDR,	RESP_1},		// TAG_ERASE_GROUP_END
;     134 	{CMD37,	0x65,	DATA_ADDR,	RESP_1},		// TAG_ERASE_GROUP
;     135 	{CMD38,	0x66,	STUFF_BITS,	RESP_1b},		// ERASE
;     136 	{CMD42,	0x6A,	STUFF_BITS,	RESP_1b},		// LOCK_UNLOCK
;     137 	{CMD58,	0x7A,	NO_ARG,		RESP_3},		// READ_OCR
;     138 	{CMD59,	0x7B,	STUFF_BITS,	RESP_1},		// CRC_ON_OFF
;     139 	{ACMD41, 0x69,	NO_ARG,		RESP_1}
;     140 };
;     141 
;     142 unsigned char _FF_spi(unsigned char mydata)
;     143 {
__FF_spi:
;     144     SPDR = mydata;          //byte 1
	LD   R30,Y
	OUT  0xF,R30
;     145     while ((SPSR&0x80) == 0); 
_0x3:
	SBIS 0xE,7
	RJMP _0x3
;     146     return SPDR;
	IN   R30,0xF
	ADIW R28,1
	RET
;     147 }
;     148 	
;     149 unsigned int send_cmd(unsigned char command, unsigned long argument)
;     150 {
_send_cmd:
;     151 	unsigned char spi_data_out;
;     152 	unsigned char response_1;
;     153 	unsigned long response_2;
;     154 	unsigned int c, i;
;     155 	
;     156 	SD_CS_ON();			// select chip
	SBIW R28,4
	CALL __SAVELOCR6
;	command -> Y+14
;	argument -> Y+10
;	spi_data_out -> R16
;	response_1 -> R17
;	response_2 -> Y+6
;	c -> R18,R19
;	i -> R20,R21
	CBI  0x18,4
;     157 	
;     158 	spi_data_out = sd_cmd[command].tx_data;
	LDD  R26,Y+14
	CLR  R27
	__POINTW1FN _sd_cmd,2
	PUSH R31
	PUSH R30
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __MULW12U
	POP  R26
	POP  R27
	ADD  R30,R26
	ADC  R31,R27
	LPM  R16,Z
;     159 	_FF_spi(spi_data_out);
	ST   -Y,R16
	CALL SUBOPT_0x0
;     160 	
;     161 	c = sd_cmd[command].arg;
	__POINTW1FN _sd_cmd,4
	PUSH R31
	PUSH R30
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __MULW12U
	POP  R26
	POP  R27
	CALL SUBOPT_0x1
;     162 	if (c == NO_ARG)
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x6
;     163 		for (i=0; i<4; i++)
	__GETWRN 20,21,0
_0x8:
	__CPWRN 20,21,4
	BRSH _0x9
;     164 			_FF_spi(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL __FF_spi
;     165 	else
	__ADDWRN 20,21,1
	RJMP _0x8
_0x9:
	RJMP _0xA
_0x6:
;     166 	{
;     167 		spi_data_out = (argument & 0xFF000000) >> 24;
	__GETD1S 10
	__ANDD1N 0xFF000000
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(24)
	CALL SUBOPT_0x2
;     168 		_FF_spi(spi_data_out);
;     169 		spi_data_out = (argument & 0x00FF0000) >> 16;
	__ANDD1N 0xFF0000
	CALL __LSRD16
	CALL SUBOPT_0x3
;     170 		_FF_spi(spi_data_out);
;     171 		spi_data_out = (argument & 0x0000FF00) >> 8;
	__GETD1S 10
	__ANDD1N 0xFF00
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(8)
	CALL SUBOPT_0x2
;     172 		_FF_spi(spi_data_out);
;     173 		spi_data_out = (argument & 0x000000FF);
	__ANDD1N 0xFF
	CALL SUBOPT_0x3
;     174 		_FF_spi(spi_data_out);
;     175 	}
_0xA:
;     176 	if (command == CMD0)
	LDD  R30,Y+14
	CPI  R30,0
	BRNE _0xB
;     177 		spi_data_out = 0x95;		// CRC byte, don't care except for first signal=0x95
	LDI  R16,LOW(149)
;     178 	else
	RJMP _0xC
_0xB:
;     179 		spi_data_out = 0xFF;
	LDI  R16,LOW(255)
;     180 	_FF_spi(spi_data_out);
_0xC:
	ST   -Y,R16
	CALL SUBOPT_0x4
;     181 	_FF_spi(0xff);	
	CALL SUBOPT_0x0
;     182 	c = sd_cmd[command].resp;
	__POINTW1FN _sd_cmd,6
	PUSH R31
	PUSH R30
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __MULW12U
	POP  R26
	POP  R27
	CALL SUBOPT_0x1
;     183 	switch(c)
	__GETW1R 18,19
;     184 	{
;     185 		case RESP_1:
	SBIW R30,0
	BRNE _0x10
;     186 			return (_FF_spi(0xFF));
	CALL SUBOPT_0x5
	LDI  R31,0
	RJMP _0x3F0
;     187 			break;
;     188 		case RESP_1b:
_0x10:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x11
;     189 			response_1 = _FF_spi(0xFF);
	CALL SUBOPT_0x5
	MOV  R17,R30
;     190 			response_2 = 0;
	__CLRD1S 6
;     191 			while (response_2 == 0)
_0x12:
	__GETD1S 6
	CALL __CPD10
	BRNE _0x14
;     192 				response_2 = _FF_spi(0xFF);
	CALL SUBOPT_0x5
	CLR  R31
	CLR  R22
	CLR  R23
	__PUTD1S 6
;     193 			return (response_1);
	RJMP _0x12
_0x14:
	MOV  R30,R17
	LDI  R31,0
	RJMP _0x3F0
;     194 			break;
;     195 		case RESP_2:
_0x11:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x15
;     196 			response_2 = _FF_spi(0xFF);
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
;     197 			response_2 = (response_2 << 8) | _FF_spi(0xFF);
	LDI  R30,LOW(8)
	CALL __LSLD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x5
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __ORD12
	__PUTD1S 6
;     198 			return (response_2);
	RJMP _0x3F0
;     199 			break;
;     200 		case RESP_3:
_0x15:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0xF
;     201 			response_1 = _FF_spi(0xFF);
	CALL SUBOPT_0x5
	MOV  R17,R30
;     202 			OCR_REG = 0;
	LDI  R30,0
	STS  _OCR_REG,R30
	STS  _OCR_REG+1,R30
	STS  _OCR_REG+2,R30
	STS  _OCR_REG+3,R30
;     203 			response_2 = _FF_spi(0xFF);
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
;     204 			OCR_REG = response_2 << 24;
	LDI  R30,LOW(24)
	CALL __LSLD12
	STS  _OCR_REG,R30
	STS  _OCR_REG+1,R31
	STS  _OCR_REG+2,R22
	STS  _OCR_REG+3,R23
;     205 			response_2 = _FF_spi(0xFF);
	CALL SUBOPT_0x5
	CALL SUBOPT_0x7
;     206 			OCR_REG |= (response_2 << 16);
	CALL __LSLD16
	CALL SUBOPT_0x8
;     207 			response_2 = _FF_spi(0xFF);
	CALL SUBOPT_0x6
;     208 			OCR_REG |= (response_2 << 8);
	LDI  R30,LOW(8)
	CALL __LSLD12
	CALL SUBOPT_0x8
;     209 			response_2 = _FF_spi(0xFF);
	CALL SUBOPT_0x7
;     210 			OCR_REG |= (response_2);
	LDS  R26,_OCR_REG
	LDS  R27,_OCR_REG+1
	LDS  R24,_OCR_REG+2
	LDS  R25,_OCR_REG+3
	CALL __ORD12
	STS  _OCR_REG,R30
	STS  _OCR_REG+1,R31
	STS  _OCR_REG+2,R22
	STS  _OCR_REG+3,R23
;     211 			return (response_1);
	MOV  R30,R17
	LDI  R31,0
	RJMP _0x3F0
;     212 			break;
;     213 	}
_0xF:
;     214 	return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x3F0:
	CALL __LOADLOCR6
	ADIW R28,15
	RET
;     215 }
;     216 
;     217 void clear_sd_buff(void)
;     218 {
_clear_sd_buff:
;     219 	SD_CS_OFF();
	SBI  0x18,4
;     220 	_FF_spi(0xFF);
	CALL SUBOPT_0x9
;     221 	_FF_spi(0xFF);
	CALL __FF_spi
;     222 }	
	RET
;     223 
;     224 unsigned char initialize_media(void)
;     225 {
_initialize_media:
;     226 	unsigned char data_temp;
;     227 	unsigned long n;
;     228 	
;     229 	// SPI BUS SETUP
;     230 	// SPI initialization
;     231 	// SPI Type: Master
;     232 	// SPI Clock Rate: 921.600 kHz
;     233 	// SPI Clock Phase: Cycle Half
;     234 	// SPI Clock Polarity: Low
;     235 	// SPI Data Order: MSB First
;     236 	DDRB |= 0x07;		// Set SS, SCK, and MOSI to Output (If not output, processor will be a slave)
	SBIW R28,4
	ST   -Y,R16
;	data_temp -> R16
;	n -> Y+1
	IN   R30,0x17
	ORI  R30,LOW(0x7)
	OUT  0x17,R30
;     237 	DDRB &= 0xF7;		// Set MISO to Input
	CBI  0x17,3
;     238 	CS_DDR_SET();		// Set CS to Output
	SBI  0x17,4
;     239 	SPCR=0x50;
	CALL SUBOPT_0xA
;     240 	SPSR=0x00;
	OUT  0xE,R30
;     241 		
;     242 	BPB_BytsPerSec = 512;	// Initialize sector size to 512 (all SD cards have a 512 sector size)
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	__PUTW1R 6,7
;     243     _FF_n_temp = 0;
	LDI  R30,0
	STS  __FF_n_temp,R30
	STS  __FF_n_temp+1,R30
	STS  __FF_n_temp+2,R30
	STS  __FF_n_temp+3,R30
;     244 	if (reset_sd()==0)
	RCALL _reset_sd
	CPI  R30,0
	BRNE _0x17
;     245 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x3EF
;     246 	// delay_ms(50);
;     247 	for (n=0; ((n<100)||(data_temp==0)) ; n++)
_0x17:
	__CLRD1S 1
_0x19:
	__GETD2S 1
	__CPD2N 0x64
	BRLO _0x1B
	CPI  R16,0
	BRNE _0x1A
_0x1B:
;     248 	{
;     249 		SD_CS_ON();
	CBI  0x18,4
;     250 		data_temp = _FF_spi(0xFF);
	CALL SUBOPT_0x5
	MOV  R16,R30
;     251 		SD_CS_OFF();
	SBI  0x18,4
;     252 	}
	CALL SUBOPT_0xB
	RJMP _0x19
_0x1A:
;     253 	// delay_ms(50);
;     254 	for (n=0; n<100; n++)
	__CLRD1S 1
_0x1E:
	__GETD2S 1
	__CPD2N 0x64
	BRSH _0x1F
;     255 	{
;     256 		if (init_sd())		// Initialization Succeeded
	RCALL _init_sd
	CPI  R30,0
	BRNE _0x1F
;     257 			break;
;     258 		if (n==99)
	__GETD2S 1
	__CPD2N 0x63
	BRNE _0x21
;     259 			return (0);
	LDI  R30,LOW(0)
	RJMP _0x3EF
;     260 	}
_0x21:
	CALL SUBOPT_0xB
	RJMP _0x1E
_0x1F:
;     261 
;     262 	if (_FF_read(0x0)==0)
	__GETD1N 0x0
	CALL SUBOPT_0xC
	BRNE _0x22
;     263 	{
;     264 		#ifdef _DEBUG_ON_
;     265 			printf("\n\rREAD_ERR"); 		
	__POINTW1FN _0,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL SUBOPT_0xD
;     266 		#endif
;     267 		_FF_error = INIT_ERR;
;     268 		return (0);
	RJMP _0x3EF
;     269 	}
;     270 	PT_SecStart = ((int) _FF_buff[0x1c7] << 8) | (int) _FF_buff[0x1c6];
_0x22:
	__GETBRMN __FF_buff,455,27
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,454
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__PUTW1R 4,5
;     271 	
;     272 	if ((((_FF_buff[0]==0xEB)&&(_FF_buff[2]==0x90))||(_FF_buff[0]==0xE9)) && ((_FF_buff[510]==0x55)&&(_FF_buff[511]==0xAA)))
	LDS  R26,__FF_buff
	CPI  R26,LOW(0xEB)
	BRNE _0x24
	__GETB1MN __FF_buff,2
	CPI  R30,LOW(0x90)
	BREQ _0x26
_0x24:
	LDS  R26,__FF_buff
	CPI  R26,LOW(0xE9)
	BRNE _0x28
_0x26:
	__GETB1MN __FF_buff,510
	CPI  R30,LOW(0x55)
	BRNE _0x29
	__GETB1MN __FF_buff,511
	CPI  R30,LOW(0xAA)
	BREQ _0x2A
_0x29:
	RJMP _0x28
_0x2A:
	RJMP _0x2B
_0x28:
	RJMP _0x23
_0x2B:
;     273     	PT_SecStart = 0;
	CLR  R4
	CLR  R5
;     274  
;     275 	_FF_PART_ADDR = (long) PT_SecStart * (long) BPB_BytsPerSec;
_0x23:
	__GETW1R 4,5
	CALL SUBOPT_0xE
	STS  __FF_PART_ADDR,R30
	STS  __FF_PART_ADDR+1,R31
	STS  __FF_PART_ADDR+2,R22
	STS  __FF_PART_ADDR+3,R23
;     276 
;     277 	if (PT_SecStart)
	MOV  R0,R4
	OR   R0,R5
	BREQ _0x2C
;     278 	{
;     279 		if (_FF_read(_FF_PART_ADDR)==0)
	CALL SUBOPT_0xC
	BRNE _0x2D
;     280 		{
;     281 		   	#ifdef _DEBUG_ON_
;     282 				printf("\n\rREAD_ERR");
	__POINTW1FN _0,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL SUBOPT_0xD
;     283 			#endif
;     284 			_FF_error = INIT_ERR;
;     285 			return (0);
	RJMP _0x3EF
;     286 		}
;     287 	}
_0x2D:
;     288 
;     289  	#ifdef _DEBUG_ON_
;     290 		printf("\n\rBoot_Sec: [0x%X %X %X] [0x%X] [0x%X]", _FF_buff[0],_FF_buff[1],_FF_buff[2],_FF_buff[510],_FF_buff[511]); 		
_0x2C:
	__POINTW1FN _0,11
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,__FF_buff
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETB1MN __FF_buff,1
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETB1MN __FF_buff,2
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETB1MN __FF_buff,510
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETB1MN __FF_buff,511
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,20
	CALL _printf
	ADIW R28,22
;     291 	#endif
;     292    	
;     293     BS_jmpBoot = (((long) _FF_buff[0] << 16) | ((int) _FF_buff[1] << 8) | (int) _FF_buff[2]);    		
	LDS  R30,__FF_buff
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __LSLD16
	MOVW R26,R30
	MOVW R24,R22
	__GETBRMN __FF_buff,1,31
	LDI  R30,LOW(0)
	CALL __CWD1
	CALL __ORD12
	MOVW R26,R30
	MOVW R24,R22
	__GETB1MN __FF_buff,2
	LDI  R31,0
	CALL __CWD1
	CALL __ORD12
	STS  _BS_jmpBoot,R30
	STS  _BS_jmpBoot+1,R31
	STS  _BS_jmpBoot+2,R22
	STS  _BS_jmpBoot+3,R23
;     294 	BPB_BytsPerSec = ((int) _FF_buff[0xC] << 8) | (int) _FF_buff[0xB];
	__GETBRMN __FF_buff,12,27
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,11
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__PUTW1R 6,7
;     295     BPB_SecPerClus = _FF_buff[0xD];
	__POINTW1MN __FF_buff,13
	LD   R8,Z
;     296 	BPB_RsvdSecCnt = ((int) _FF_buff[0xF] << 8) | (int) _FF_buff[0xE];	
	__GETBRMN __FF_buff,15,27
	__GETB1MN __FF_buff,14
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__PUTW1R 9,10
;     297 	BPB_NumFATs = _FF_buff[0x10];
	__POINTW1MN __FF_buff,16
	LD   R11,Z
;     298 	BPB_RootEntCnt = ((int) _FF_buff[0x12] << 8) | (int) _FF_buff[0x11];	
	__GETBRMN __FF_buff,18,27
	__GETB1MN __FF_buff,17
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__PUTW1R 12,13
;     299 	BPB_FATSz16 = ((int) _FF_buff[0x17] << 8) | (int) _FF_buff[0x16];
	__GETBRMN __FF_buff,23,27
	__GETB1MN __FF_buff,22
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _BPB_FATSz16,R30
	STS  _BPB_FATSz16+1,R31
;     300 	BPB_TotSec = ((unsigned int) _FF_buff[0x14] << 8) | (unsigned int) _FF_buff[0x13];
	__GETBRMN __FF_buff,20,27
	__GETB1MN __FF_buff,19
	CALL SUBOPT_0xF
	STS  _BPB_TotSec,R30
	STS  _BPB_TotSec+1,R31
	STS  _BPB_TotSec+2,R22
	STS  _BPB_TotSec+3,R23
;     301 	if (BPB_TotSec==0)
	CALL __CPD10
	BRNE _0x2E
;     302 		BPB_TotSec = ((unsigned long) _FF_buff[0x23] << 24) | ((unsigned long) _FF_buff[0x22] << 16)
;     303 					| ((unsigned long) _FF_buff[0x21] << 8) | ((unsigned long) _FF_buff[0x20]);
	__GETB1MN __FF_buff,35
	CALL SUBOPT_0x10
	__GETB1MN __FF_buff,34
	CALL SUBOPT_0x11
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETB1MN __FF_buff,33
	CALL SUBOPT_0x12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ORD12
	MOVW R26,R30
	MOVW R24,R22
	__GETB1MN __FF_buff,32
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __ORD12
	STS  _BPB_TotSec,R30
	STS  _BPB_TotSec+1,R31
	STS  _BPB_TotSec+2,R22
	STS  _BPB_TotSec+3,R23
;     304 	BS_VolSerial = ((unsigned long) _FF_buff[0x2A] << 24) | ((unsigned long) _FF_buff[0x29] << 16)
_0x2E:
;     305 				| ((unsigned long) _FF_buff[0x28] << 8) | ((unsigned long) _FF_buff[0x27]);
	__GETB1MN __FF_buff,42
	CALL SUBOPT_0x10
	__GETB1MN __FF_buff,41
	CALL SUBOPT_0x11
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETB1MN __FF_buff,40
	CALL SUBOPT_0x12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ORD12
	MOVW R26,R30
	MOVW R24,R22
	__GETB1MN __FF_buff,39
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __ORD12
	STS  _BS_VolSerial,R30
	STS  _BS_VolSerial+1,R31
	STS  _BS_VolSerial+2,R22
	STS  _BS_VolSerial+3,R23
;     306 	for (n=0; n<11; n++)
	__CLRD1S 1
_0x30:
	__GETD2S 1
	__CPD2N 0xB
	BRSH _0x31
;     307 		BS_VolLab[n] = _FF_buff[0x2B+n];
	__GETD1S 1
	SUBI R30,LOW(-_BS_VolLab)
	SBCI R31,HIGH(-_BS_VolLab)
	MOVW R26,R30
	__GETD1S 1
	__ADDD1N 43
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	LD   R30,Z
	ST   X,R30
;     308 	BS_VolLab[11] = 0;		// Terminate the string
	CALL SUBOPT_0xB
	RJMP _0x30
_0x31:
	LDI  R30,LOW(0)
	__PUTB1MN _BS_VolLab,11
;     309 	_FF_FAT1_ADDR = _FF_PART_ADDR + ((long) BPB_RsvdSecCnt * (long) BPB_BytsPerSec); 
	__GETW1R 9,10
	CALL SUBOPT_0xE
	LDS  R26,__FF_PART_ADDR
	LDS  R27,__FF_PART_ADDR+1
	LDS  R24,__FF_PART_ADDR+2
	LDS  R25,__FF_PART_ADDR+3
	CALL __ADDD12
	STS  __FF_FAT1_ADDR,R30
	STS  __FF_FAT1_ADDR+1,R31
	STS  __FF_FAT1_ADDR+2,R22
	STS  __FF_FAT1_ADDR+3,R23
;     310 	_FF_FAT2_ADDR = _FF_FAT1_ADDR + ((long) BPB_FATSz16 * (long) BPB_BytsPerSec);
	LDS  R30,_BPB_FATSz16
	LDS  R31,_BPB_FATSz16+1
	CALL SUBOPT_0xE
	LDS  R26,__FF_FAT1_ADDR
	LDS  R27,__FF_FAT1_ADDR+1
	LDS  R24,__FF_FAT1_ADDR+2
	LDS  R25,__FF_FAT1_ADDR+3
	CALL __ADDD12
	STS  __FF_FAT2_ADDR,R30
	STS  __FF_FAT2_ADDR+1,R31
	STS  __FF_FAT2_ADDR+2,R22
	STS  __FF_FAT2_ADDR+3,R23
;     311 	_FF_ROOT_ADDR = ((long) BPB_NumFATs * (long) BPB_FATSz16) + (long) BPB_RsvdSecCnt;
	MOV  R30,R11
	CLR  R31
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_BPB_FATSz16
	LDS  R31,_BPB_FATSz16+1
	CLR  R22
	CLR  R23
	CALL __MULD12
	MOVW R26,R30
	MOVW R24,R22
	__GETW1R 9,10
	CLR  R22
	CLR  R23
	CALL __ADDD12
	STS  __FF_ROOT_ADDR,R30
	STS  __FF_ROOT_ADDR+1,R31
	STS  __FF_ROOT_ADDR+2,R22
	STS  __FF_ROOT_ADDR+3,R23
;     312 	_FF_ROOT_ADDR *= BPB_BytsPerSec;
	__GETW1R 6,7
	LDS  R26,__FF_ROOT_ADDR
	LDS  R27,__FF_ROOT_ADDR+1
	LDS  R24,__FF_ROOT_ADDR+2
	LDS  R25,__FF_ROOT_ADDR+3
	CLR  R22
	CLR  R23
	CALL __MULD12U
	STS  __FF_ROOT_ADDR,R30
	STS  __FF_ROOT_ADDR+1,R31
	STS  __FF_ROOT_ADDR+2,R22
	STS  __FF_ROOT_ADDR+3,R23
;     313 	_FF_ROOT_ADDR += _FF_PART_ADDR;
	LDS  R30,__FF_PART_ADDR
	LDS  R31,__FF_PART_ADDR+1
	LDS  R22,__FF_PART_ADDR+2
	LDS  R23,__FF_PART_ADDR+3
	LDS  R26,__FF_ROOT_ADDR
	LDS  R27,__FF_ROOT_ADDR+1
	LDS  R24,__FF_ROOT_ADDR+2
	LDS  R25,__FF_ROOT_ADDR+3
	CALL __ADDD12
	STS  __FF_ROOT_ADDR,R30
	STS  __FF_ROOT_ADDR+1,R31
	STS  __FF_ROOT_ADDR+2,R22
	STS  __FF_ROOT_ADDR+3,R23
;     314 	
;     315 	_FF_RootDirSectors = ((BPB_RootEntCnt * 32) + BPB_BytsPerSec - 1) / BPB_BytsPerSec;
	__GETW1R 12,13
	LSL  R30
	ROL  R31
	CALL __LSLW4
	ADD  R30,R6
	ADC  R31,R7
	CALL SUBOPT_0x13
	CALL __DIVW21U
	CLR  R22
	CLR  R23
	STS  __FF_RootDirSectors,R30
	STS  __FF_RootDirSectors+1,R31
	STS  __FF_RootDirSectors+2,R22
	STS  __FF_RootDirSectors+3,R23
;     316 	FirstDataSector = (BPB_NumFATs * BPB_FATSz16) + BPB_RsvdSecCnt + _FF_RootDirSectors; 
	LDS  R30,_BPB_FATSz16
	LDS  R31,_BPB_FATSz16+1
	MOV  R26,R11
	LDI  R27,0
	CALL __MULW12U
	ADD  R30,R9
	ADC  R31,R10
	MOVW R26,R30
	LDS  R30,__FF_RootDirSectors
	LDS  R31,__FF_RootDirSectors+1
	LDS  R22,__FF_RootDirSectors+2
	LDS  R23,__FF_RootDirSectors+3
	CLR  R24
	CLR  R25
	CALL __ADDD12
	STS  _FirstDataSector,R30
	STS  _FirstDataSector+1,R31
;     317 	
;     318 	DataClusTot = BPB_TotSec - FirstDataSector;
	LDS  R26,_BPB_TotSec
	LDS  R27,_BPB_TotSec+1
	LDS  R24,_BPB_TotSec+2
	LDS  R25,_BPB_TotSec+3
	CALL SUBOPT_0x14
	STS  _DataClusTot,R30
	STS  _DataClusTot+1,R31
	STS  _DataClusTot+2,R22
	STS  _DataClusTot+3,R23
;     319 	DataClusTot /= BPB_SecPerClus;
	MOV  R30,R8
	LDS  R26,_DataClusTot
	LDS  R27,_DataClusTot+1
	LDS  R24,_DataClusTot+2
	LDS  R25,_DataClusTot+3
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	STS  _DataClusTot,R30
	STS  _DataClusTot+1,R31
	STS  _DataClusTot+2,R22
	STS  _DataClusTot+3,R23
;     320 	clus_0_addr = 0;		// Reset Empty Cluster table location
	LDI  R30,0
	STS  _clus_0_addr,R30
	STS  _clus_0_addr+1,R30
	STS  _clus_0_addr+2,R30
	STS  _clus_0_addr+3,R30
;     321 	c_counter = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _c_counter,R30
	STS  _c_counter+1,R31
;     322 	
;     323 	if (DataClusTot < 4085)				// FAT12
	LDS  R26,_DataClusTot
	LDS  R27,_DataClusTot+1
	LDS  R24,_DataClusTot+2
	LDS  R25,_DataClusTot+3
	__CPD2N 0xFF5
	BRSH _0x32
;     324 		BPB_FATType = 0x32;
	LDI  R30,LOW(50)
	MOV  R14,R30
;     325 	else if (DataClusTot < 65525)		// FAT16
	RJMP _0x33
_0x32:
	LDS  R26,_DataClusTot
	LDS  R27,_DataClusTot+1
	LDS  R24,_DataClusTot+2
	LDS  R25,_DataClusTot+3
	__CPD2N 0xFFF5
	BRSH _0x34
;     326 		BPB_FATType = 0x36;
	LDI  R30,LOW(54)
	MOV  R14,R30
;     327 	else
	RJMP _0x35
_0x34:
;     328 	{
;     329 		BPB_FATType = 0;
	CLR  R14
;     330 		_FF_error = FAT_ERR;
	LDI  R30,LOW(12)
	STS  __FF_error,R30
;     331 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x3EF
;     332 	}
_0x35:
_0x33:
;     333     
;     334 	_FF_DIR_ADDR = _FF_ROOT_ADDR;		// Set current directory to root address
	LDS  R30,__FF_ROOT_ADDR
	LDS  R31,__FF_ROOT_ADDR+1
	LDS  R22,__FF_ROOT_ADDR+2
	LDS  R23,__FF_ROOT_ADDR+3
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;     335 
;     336 	_FF_FULL_PATH[0] = 0x5C;	// a '\'
	LDI  R30,LOW(92)
	STS  __FF_FULL_PATH,R30
;     337 	_FF_FULL_PATH[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN __FF_FULL_PATH,1
;     338 	
;     339 	#ifdef _DEBUG_ON_
;     340 		printf("\n\rPart Address:  %lX", _FF_PART_ADDR);
	__POINTW1FN _0,50
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,__FF_PART_ADDR
	LDS  R31,__FF_PART_ADDR+1
	LDS  R22,__FF_PART_ADDR+2
	LDS  R23,__FF_PART_ADDR+3
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
;     341 		printf("\n\rBS_jmpBoot:  %lX", BS_jmpBoot);
	__POINTW1FN _0,71
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_BS_jmpBoot
	LDS  R31,_BS_jmpBoot+1
	LDS  R22,_BS_jmpBoot+2
	LDS  R23,_BS_jmpBoot+3
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
;     342 		printf("\n\rBPB_BytsPerSec:  %X", BPB_BytsPerSec);
	__POINTW1FN _0,90
	ST   -Y,R31
	ST   -Y,R30
	__GETW1R 6,7
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
;     343 		printf("\n\rBPB_SecPerClus:  %X", BPB_SecPerClus);
	__POINTW1FN _0,112
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R8
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
;     344 		printf("\n\rBPB_RsvdSecCnt:  %X", BPB_RsvdSecCnt);
	__POINTW1FN _0,134
	ST   -Y,R31
	ST   -Y,R30
	__GETW1R 9,10
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
;     345 		printf("\n\rBPB_NumFATs:  %X", BPB_NumFATs);
	__POINTW1FN _0,156
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R11
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
;     346 		printf("\n\rBPB_RootEntCnt:  %X", BPB_RootEntCnt);
	__POINTW1FN _0,175
	ST   -Y,R31
	ST   -Y,R30
	__GETW1R 12,13
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
;     347 		printf("\n\rBPB_FATSz16:  %X", BPB_FATSz16);
	__POINTW1FN _0,197
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_BPB_FATSz16
	LDS  R31,_BPB_FATSz16+1
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
;     348 		printf("\n\rBPB_TotSec16:  %lX", BPB_TotSec);
	__POINTW1FN _0,216
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_BPB_TotSec
	LDS  R31,_BPB_TotSec+1
	LDS  R22,_BPB_TotSec+2
	LDS  R23,_BPB_TotSec+3
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
;     349 		if (BPB_FATType == 0x32)
	LDI  R30,LOW(50)
	CP   R30,R14
	BRNE _0x36
;     350 			printf("\n\rBPB_FATType:  FAT12");
	__POINTW1FN _0,237
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;     351 		else if (BPB_FATType == 0x36)
	RJMP _0x37
_0x36:
	LDI  R30,LOW(54)
	CP   R30,R14
	BRNE _0x38
;     352 			printf("\n\rBPB_FATType:  FAT16");
	__POINTW1FN _0,259
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RJMP _0x3F1
;     353 		else
_0x38:
;     354 			printf("\n\rBPB_FATType:  FAT ERROR!!");
	__POINTW1FN _0,281
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
_0x3F1:
	CALL _printf
	ADIW R28,2
;     355 		printf("\n\rClusterCnt:  %lX", DataClusTot);
_0x37:
	__POINTW1FN _0,309
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_DataClusTot
	LDS  R31,_DataClusTot+1
	LDS  R22,_DataClusTot+2
	LDS  R23,_DataClusTot+3
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
;     356 		printf("\n\rROOT_ADDR:  %lX", _FF_ROOT_ADDR);
	__POINTW1FN _0,328
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,__FF_ROOT_ADDR
	LDS  R31,__FF_ROOT_ADDR+1
	LDS  R22,__FF_ROOT_ADDR+2
	LDS  R23,__FF_ROOT_ADDR+3
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
;     357 		printf("\n\rFAT2_ADDR:  %lX", _FF_FAT2_ADDR);
	__POINTW1FN _0,346
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,__FF_FAT2_ADDR
	LDS  R31,__FF_FAT2_ADDR+1
	LDS  R22,__FF_FAT2_ADDR+2
	LDS  R23,__FF_FAT2_ADDR+3
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
;     358 		printf("\n\rRootDirSectors:  %X", _FF_RootDirSectors);
	__POINTW1FN _0,364
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,__FF_RootDirSectors
	LDS  R31,__FF_RootDirSectors+1
	LDS  R22,__FF_RootDirSectors+2
	LDS  R23,__FF_RootDirSectors+3
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
;     359 		printf("\n\rFirstDataSector:  %X", FirstDataSector);
	__POINTW1FN _0,386
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_FirstDataSector
	LDS  R31,_FirstDataSector+1
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
;     360 	#endif
;     361 	
;     362 	return (1);	
	LDI  R30,LOW(1)
_0x3EF:
	LDD  R16,Y+0
	ADIW R28,5
	RET
;     363 }
;     364 
;     365 unsigned char spi_speedset(void)
;     366 {
_spi_speedset:
;     367 	if (SPCR == 0x50)
	IN   R30,0xD
	CPI  R30,LOW(0x50)
	BRNE _0x3A
;     368 		SPCR = 0x51;
	LDI  R30,LOW(81)
	OUT  0xD,R30
;     369 	else if (SPCR == 0x51)
	RJMP _0x3B
_0x3A:
	IN   R30,0xD
	CPI  R30,LOW(0x51)
	BRNE _0x3C
;     370 		SPCR = 0x52;
	LDI  R30,LOW(82)
	OUT  0xD,R30
;     371 	else if (SPCR == 0x52)
	RJMP _0x3D
_0x3C:
	IN   R30,0xD
	CPI  R30,LOW(0x52)
	BRNE _0x3E
;     372 		SPCR = 0x53;
	LDI  R30,LOW(83)
	OUT  0xD,R30
;     373 	else
	RJMP _0x3F
_0x3E:
;     374 	{
;     375 		SPCR = 0x50;
	CALL SUBOPT_0xA
;     376 		return (0);
	RET
;     377 	}
_0x3F:
_0x3D:
_0x3B:
;     378 	return (1);
	LDI  R30,LOW(1)
	RET
;     379 }
;     380 
;     381 unsigned char reset_sd(void)
;     382 {
_reset_sd:
;     383 	unsigned char resp, n, c;
;     384 
;     385 	#ifdef _DEBUG_ON_
;     386 		printf("\n\rReset CMD:  ");	
	CALL __SAVELOCR3
;	resp -> R16
;	n -> R17
;	c -> R18
	__POINTW1FN _0,409
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;     387 	#endif
;     388 	
;     389 	for (c=0; c<4; c++)		// try reset command 3 times if needed
	LDI  R18,LOW(0)
_0x41:
	CPI  R18,4
	BRSH _0x42
;     390 	{
;     391 		SD_CS_OFF();
	SBI  0x18,4
;     392 		for (n=0; n<10; n++)	// initialize clk signal to sync card
	LDI  R17,LOW(0)
_0x44:
	CPI  R17,10
	BRSH _0x45
;     393 			_FF_spi(0xFF);
	CALL SUBOPT_0x5
;     394 		resp = send_cmd(CMD0,0);
	SUBI R17,-1
	RJMP _0x44
_0x45:
	LDI  R30,LOW(0)
	CALL SUBOPT_0x15
;     395 		for (n=0; n<200; n++)
	LDI  R17,LOW(0)
_0x47:
	CPI  R17,200
	BRSH _0x48
;     396 		{
;     397 			if (resp == 0x1)
	CPI  R16,1
	BRNE _0x49
;     398 			{
;     399 				SD_CS_OFF();
	SBI  0x18,4
;     400     			#ifdef _DEBUG_ON_
;     401 					printf("OK!!!");
	__POINTW1FN _0,424
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;     402 				#endif
;     403 				SPCR = 0x50;
	CALL SUBOPT_0x16
;     404 				return(1);
	RJMP _0x3EE
;     405 			}
;     406 	      	resp = _FF_spi(0xFF);
_0x49:
	CALL SUBOPT_0x5
	MOV  R16,R30
;     407 		}
	SUBI R17,-1
	RJMP _0x47
_0x48:
;     408 		#ifdef _DEBUG_ON_
;     409 			printf("ERROR!!!");
	__POINTW1FN _0,430
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;     410 		#endif
;     411  		if (spi_speedset()==0)
	CALL _spi_speedset
	CPI  R30,0
	BRNE _0x4A
;     412  		{
;     413 		    SD_CS_OFF();
	SBI  0x18,4
;     414  			return (0);
	LDI  R30,LOW(0)
	RJMP _0x3EE
;     415  		}
;     416 	}
_0x4A:
	SUBI R18,-1
	RJMP _0x41
_0x42:
;     417 	return (0);
	LDI  R30,LOW(0)
	RJMP _0x3EE
;     418 }
;     419 
;     420 unsigned char init_sd(void)
;     421 {
_init_sd:
;     422 	unsigned char resp;
;     423 	unsigned int c;
;     424 	
;     425 	clear_sd_buff();
	CALL __SAVELOCR3
;	resp -> R16
;	c -> R17,R18
	CALL _clear_sd_buff
;     426 
;     427     #ifdef _DEBUG_ON_
;     428 		printf("\r\nInitialization:  ");
	__POINTW1FN _0,439
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;     429 	#endif
;     430     for (c=0; c<1000; c++)
	__GETWRN 17,18,0
_0x4C:
	__CPWRN 17,18,1000
	BRSH _0x4D
;     431     {
;     432     	resp = send_cmd(CMD1, 0);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x15
;     433     	if (resp == 0)
	CPI  R16,0
	BREQ _0x4D
;     434     		break;
;     435    		resp = _FF_spi(0xFF);
	CALL SUBOPT_0x5
	MOV  R16,R30
;     436    		if (resp == 0)
	CPI  R16,0
	BREQ _0x4D
;     437    			break;
;     438    		resp = _FF_spi(0xFF);
	CALL SUBOPT_0x5
	MOV  R16,R30
;     439    		if (resp == 0)
	CPI  R16,0
	BREQ _0x4D
;     440    			break;
;     441 	}
	__ADDWRN 17,18,1
	RJMP _0x4C
_0x4D:
;     442    	if (resp == 0)
	CPI  R16,0
	BRNE _0x51
;     443 	{
;     444 		#ifdef _DEBUG_ON_
;     445    			printf("OK!");
	__POINTW1FN _0,459
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;     446 	   	#endif
;     447 		return (1);
	LDI  R30,LOW(1)
	RJMP _0x3EE
;     448 	}
;     449 	else
_0x51:
;     450 	{
;     451 		#ifdef _DEBUG_ON_
;     452    			printf("ERROR-%x  ", resp);
	__POINTW1FN _0,463
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
;     453 	   	#endif
;     454 		return (0);
	LDI  R30,LOW(0)
;     455  	}        		
;     456 }
_0x3EE:
	CALL __LOADLOCR3
	ADIW R28,3
	RET
;     457 
;     458 unsigned char _FF_read_disp(unsigned long sd_addr)
;     459 {
;     460 	unsigned char resp;
;     461 	unsigned long n, remainder;
;     462 	
;     463 	if (sd_addr % 0x200)
;	sd_addr -> Y+9
;	resp -> R16
;	n -> Y+5
;	remainder -> Y+1
;     464 	{	// Not a valid read address, return 0
;     465 		_FF_error = READ_ERR;
;     466 		return (0);
;     467 	}
;     468 
;     469 	clear_sd_buff();
;     470 	resp = send_cmd(CMD17, sd_addr);		// Send read request
;     471 	
;     472 	while(resp!=0xFE)
;     473 		resp = _FF_spi(0xFF);
;     474 	for (n=0; n<512; n++)
;     475 	{
;     476 		remainder = n % 0x10;
;     477 		if (remainder == 0)
;     478 			printf("\n\r");
;     479 		_FF_buff[n] = _FF_spi(0xFF);
;     480 		if (_FF_buff[n]<0x10)
;     481 			putchar(0x30);
;     482 		printf("%X ", _FF_buff[n]);
;     483 	}
;     484 	_FF_spi(0xFF);
;     485 	_FF_spi(0xFF);
;     486 	_FF_spi(0xFF);
;     487 	SD_CS_OFF();
;     488 	return (1);
;     489 }
;     490 
;     491 // Read data from a SD card @ address
;     492 unsigned char _FF_read(unsigned long sd_addr)
;     493 {
__FF_read:
;     494 	unsigned char resp;
;     495 	unsigned long n;
;     496 //printf("\r\nReadin ADDR [0x%lX]", sd_addr);
;     497 	
;     498 	if (sd_addr % BPB_BytsPerSec)
	SBIW R28,4
	ST   -Y,R16
;	sd_addr -> Y+5
;	resp -> R16
;	n -> Y+1
	CALL SUBOPT_0x17
	BREQ _0x5C
;     499 	{	// Not a valid read address, return 0
;     500 		_FF_error = READ_ERR;
	CALL SUBOPT_0x18
;     501 		return (0);
	RJMP _0x3ED
;     502 	}
;     503 		
;     504 	for (;;)
_0x5C:
_0x5E:
;     505 	{
;     506 		clear_sd_buff();
	CALL _clear_sd_buff
;     507 		resp = send_cmd(CMD17, sd_addr);	// read block command
	LDI  R30,LOW(7)
	CALL SUBOPT_0x19
;     508 		for (n=0; n<1000; n++)
	__CLRD1S 1
_0x61:
	__GETD2S 1
	__CPD2N 0x3E8
	BRSH _0x62
;     509 		{
;     510 			if (resp==0xFE)
	CPI  R16,254
	BREQ _0x62
;     511 			{	// waiting for start byte
;     512 				break;
;     513 			}
;     514 			resp = _FF_spi(0xFF);
	CALL SUBOPT_0x5
	MOV  R16,R30
;     515 		}
	CALL SUBOPT_0xB
	RJMP _0x61
_0x62:
;     516 		if (resp==0xFE)
	CPI  R16,254
	BRNE _0x64
;     517 		{	// if it is a valid start byte => start reading SD Card
;     518 			for (n=0; n<BPB_BytsPerSec; n++)
	__CLRD1S 1
_0x66:
	__GETW1R 6,7
	__GETD2S 1
	CLR  R22
	CLR  R23
	CALL __CPD21
	BRSH _0x67
;     519 				_FF_buff[n] = _FF_spi(0xFF);
	__GETD1S 1
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x5
	POP  R26
	POP  R27
	ST   X,R30
;     520 			_FF_spi(0xFF);
	CALL SUBOPT_0xB
	RJMP _0x66
_0x67:
	CALL SUBOPT_0x9
;     521 			_FF_spi(0xFF);
	CALL SUBOPT_0x4
;     522 			_FF_spi(0xFF);
	CALL __FF_spi
;     523 			SD_CS_OFF();
	SBI  0x18,4
;     524 			_FF_error = NO_ERR;
	LDI  R30,LOW(0)
	STS  __FF_error,R30
;     525 			_FF_buff_addr = sd_addr;
	__GETD1S 5
	STS  __FF_buff_addr,R30
	STS  __FF_buff_addr+1,R31
	STS  __FF_buff_addr+2,R22
	STS  __FF_buff_addr+3,R23
;     526 			SPCR = 0x50;
	CALL SUBOPT_0x16
;     527 			return (1);
	RJMP _0x3ED
;     528 		}
;     529 
;     530 		SD_CS_OFF();
_0x64:
	SBI  0x18,4
;     531 
;     532 		if (spi_speedset()==0)
	CALL _spi_speedset
	CPI  R30,0
	BREQ _0x5F
;     533 			break;
;     534 	}	
	RJMP _0x5E
_0x5F:
;     535 	_FF_error = READ_ERR;    
	CALL SUBOPT_0x18
;     536 	return(0);
_0x3ED:
	LDD  R16,Y+0
	ADIW R28,9
	RET
;     537 }
;     538 
;     539 
;     540 #ifndef _READ_ONLY_
;     541 unsigned char _FF_write(unsigned long sd_addr)
;     542 {
__FF_write:
;     543 	unsigned char resp, calc, valid_flag;
;     544 	unsigned int n;
;     545 	
;     546 	if ((sd_addr%BPB_BytsPerSec) || (sd_addr <= _FF_PART_ADDR))
	CALL __SAVELOCR5
;	sd_addr -> Y+5
;	resp -> R16
;	calc -> R17
;	valid_flag -> R18
;	n -> R19,R20
	CALL SUBOPT_0x17
	BRNE _0x6A
	LDS  R30,__FF_PART_ADDR
	LDS  R31,__FF_PART_ADDR+1
	LDS  R22,__FF_PART_ADDR+2
	LDS  R23,__FF_PART_ADDR+3
	__GETD2S 5
	CALL __CPD12
	BRLO _0x69
_0x6A:
;     547 	{	// Not a valid write address, return 0
;     548 		_FF_error = WRITE_ERR;
	CALL SUBOPT_0x1A
;     549 		return (0);
	RJMP _0x3EC
;     550 	}
;     551 
;     552 //printf("\r\nWriting to address:  %lX", sd_addr);
;     553 	for (;;)
_0x69:
_0x6D:
;     554 	{
;     555 		clear_sd_buff();
	CALL _clear_sd_buff
;     556 		resp = send_cmd(CMD24, sd_addr);
	LDI  R30,LOW(9)
	CALL SUBOPT_0x19
;     557 		valid_flag = 0;
	LDI  R18,LOW(0)
;     558 		for (n=0; n<1000; n++)
	__GETWRN 19,20,0
_0x70:
	__CPWRN 19,20,1000
	BRSH _0x71
;     559 		{
;     560 			if (resp == 0x00)
	CPI  R16,0
	BRNE _0x72
;     561 			{
;     562 				valid_flag = 1;
	LDI  R18,LOW(1)
;     563 				break;
	RJMP _0x71
;     564 			}
;     565 			resp = _FF_spi(0xFF);
_0x72:
	CALL SUBOPT_0x5
	MOV  R16,R30
;     566 		}
	__ADDWRN 19,20,1
	RJMP _0x70
_0x71:
;     567 	
;     568 		if (valid_flag)
	CPI  R18,0
	BREQ _0x73
;     569 		{
;     570 			_FF_spi(0xFF);
	CALL SUBOPT_0x5
;     571 			_FF_spi(0xFE);					// Start Block Token
	LDI  R30,LOW(254)
	ST   -Y,R30
	CALL __FF_spi
;     572 			for (n=0; n<BPB_BytsPerSec; n++)		// Write Data in buffer to card
	__GETWRN 19,20,0
_0x75:
	__CPWRR 19,20,6,7
	BRSH _0x76
;     573 				_FF_spi(_FF_buff[n]);
	LDI  R26,LOW(__FF_buff)
	LDI  R27,HIGH(__FF_buff)
	ADD  R26,R19
	ADC  R27,R20
	LD   R30,X
	ST   -Y,R30
	CALL __FF_spi
;     574 			_FF_spi(0xFF);					// Send 2 blank CRC bytes
	__ADDWRN 19,20,1
	RJMP _0x75
_0x76:
	CALL SUBOPT_0x9
;     575 			_FF_spi(0xFF);
	CALL SUBOPT_0x4
;     576 			resp = _FF_spi(0xFF);			// Response should be 0bXXX00101
	CALL __FF_spi
	MOV  R16,R30
;     577 			calc = resp | 0xE0;
	MOV  R30,R16
	ORI  R30,LOW(0xE0)
	MOV  R17,R30
;     578 			if (calc==0xE5)
	CPI  R17,229
	BRNE _0x77
;     579 			{
;     580 				while(_FF_spi(0xFF)==0)
_0x78:
	CALL SUBOPT_0x5
	CPI  R30,0
	BREQ _0x78
;     581 					;	// Clear Buffer before returning 'OK'
;     582 				SD_CS_OFF();
	SBI  0x18,4
;     583 //				SPCR = 0x50;			// Reset SPI bus Speed
;     584 				_FF_error = NO_ERR;
	LDI  R30,LOW(0)
	STS  __FF_error,R30
;     585 				return(1);
	LDI  R30,LOW(1)
	RJMP _0x3EC
;     586 			}
;     587 		}
_0x77:
;     588 		SD_CS_OFF(); 
_0x73:
	SBI  0x18,4
;     589 
;     590 		if (spi_speedset()==0)
	CALL _spi_speedset
	CPI  R30,0
	BREQ _0x6E
;     591 			break;
;     592 		// delay_ms(100);		
;     593 	}
	RJMP _0x6D
_0x6E:
;     594 	_FF_error = WRITE_ERR;
	CALL SUBOPT_0x1A
;     595 	return(0x0);
_0x3EC:
	CALL __LOADLOCR5
	ADIW R28,9
	RET
;     596 }
;     597 #endif
;     598 /*
;     599 	Progressive Resources LLC
;     600                                     
;     601 			FlashFile
;     602 	
;     603 	Version : 	1.32
;     604 	Date: 		12/31/2003
;     605 	Author: 	Erick M. Higa
;     606 	
;     607 	Revision History:
;     608 	12/31/2003 - EMH - v1.00 
;     609 			   	 	 - Initial Release
;     610 	01/19/2004 - EMH - v1.10
;     611 			   	 	 - fixed FAT access errors by allowing both FAT tables to be updated
;     612 					 - fixed erase_cluster chain to stop if chain goes to '0'
;     613 					 - fixed #include's so other non m128 processors could be used
;     614 					 - fixed fcreate to match 'C' standard for function "creat"
;     615 					 - fixed fseek so it would not error when in "READ" mode
;     616 					 - modified SPI interface to use _FF_spi() so it is more universal
;     617 					   (see the "sd_cmd.c" file for the function used)
;     618 					 - redifined global variables and #defines for more unique names
;     619 					 - added string functions fputs, fputsc, & fgets
;     620 					 - added functions fquickformat, fgetfileinfo, & GetVolID()
;     621 					 - added directory support
;     622 					 - modified delays in "sd_cmd.c" to increase transfer speed to max
;     623 					 - updated "options.h" to include additions, and to make #defines 
;     624 					   more universal to multiple platforms
;     625 	01/21/2004 - EMH - v1.20
;     626 			   	 	 - Added ICC Support to the FlashFileSD
;     627 					 - fixed card initialization error for MMC/SD's that have only a boot 
;     628 			   	 	   sector and no partition table
;     629 					 - Fixed intermittant error on fcreate when creating existing file
;     630 					 - changed "options.h" to #include all required files
;     631 	02/19/2004 - EMH - v1.21
;     632 					 - Replaced all "const" refrances to "flash" to support CodeVision 1.24.1b
;     633 	03/02/2004 - EMH - v1.22 (unofficial release)
;     634 					 - Changed Directory Functions to allow for multi-cluster directory entries
;     635 					 - Added function addr_to_clust() to support long directories
;     636 					 - Fixed FAT table address calculation to support multiple reserved sectors
;     637 					   (previously) assumed one reserved sector, if XP formats card sometimes 
;     638 					   multiple reserved sectors - thanks YW
;     639 	03/10/2004 - EMH - v1.30
;     640 					 - Added support for a Compact Flash package
;     641 					 - Renamed read and write to flash function names for multiple media support	
;     642 	03/26/2004 - EMH - v1.31
;     643 					 - Added define for easy MEGA128Dev board setup
;     644 					 - Changed demo projects so "option.h" is in the project directory	
;     645 	04/01/2004 - EMH - v1.32
;     646 					 - Fixed bug in "prev_cluster()" that didn't use updated FAT table address
;     647 					   calculations.  (effects XP formatted cards see v1.22 notes)
;     648                                            
;     649 	Software License
;     650 	The use of Progressive Resources LLC FlashFile Source Package indicates 
;     651 	your understanding and acceptance of the following terms and conditions. 
;     652 	This license shall supersede any verbal or prior verbal or written, statement 
;     653 	or agreement to the contrary. If you do not understand or accept these terms, 
;     654 	or your local regulations prohibit "after sale" license agreements or limited 
;     655 	disclaimers, you must cease and desist using this product immediately.
;     656 	This product is © Copyright 2003 by Progressive Resources LLC, all rights 
;     657 	reserved. International copyright laws, international treaties and all other 
;     658 	applicable national or international laws protect this product. This software 
;     659 	product and documentation may not, in whole or in part, be copied, photocopied, 
;     660 	translated, or reduced to any electronic medium or machine readable form, without 
;     661 	prior consent in writing, from Progressive Resources LLC and according to all 
;     662 	applicable laws. The sole owner of this product is Progressive Resources LLC.
;     663 
;     664 	Operating License
;     665 	You have the non-exclusive right to use any enclosed product but have no right 
;     666 	to distribute it as a source code product without the express written permission 
;     667 	of Progressive Resources LLC. Use over a "local area network" (within the same 
;     668 	locale) is permitted provided that only a single person, on a single computer 
;     669 	uses the product at a time. Use over a "wide area network" (outside the same 
;     670 	locale) is strictly prohibited under any and all circumstances.
;     671                                            
;     672 	Liability Disclaimer
;     673 	This product and/or license is provided as is, without any representation or 
;     674 	warranty of any kind, either express or implied, including without limitation 
;     675 	any representations or endorsements regarding the use of, the results of, or 
;     676 	performance of the product, Its appropriateness, accuracy, reliability, or 
;     677 	correctness. The user and/or licensee assume the entire risk as to the use of 
;     678 	this product. Progressive Resources LLC does not assume liability for the use 
;     679 	of this product beyond the original purchase price of the software. In no event 
;     680 	will Progressive Resources LLC be liable for additional direct or indirect 
;     681 	damages including any lost profits, lost savings, or other incidental or 
;     682 	consequential damages arising from any defects, or the use or inability to 
;     683 	use these products, even if Progressive Resources LLC have been advised of 
;     684 	the possibility of such damages.
;     685 */                                 
;     686 
;     687 extern unsigned long OCR_REG;
;     688 extern unsigned char _FF_buff[512];
;     689 extern unsigned int PT_SecStart;
;     690 extern unsigned long BS_jmpBoot;
;     691 extern unsigned int BPB_BytsPerSec;
;     692 extern unsigned char BPB_SecPerClus;
;     693 extern unsigned int BPB_RsvdSecCnt;
;     694 extern unsigned char BPB_NumFATs;
;     695 extern unsigned int BPB_RootEntCnt;
;     696 extern unsigned int BPB_FATSz16;
;     697 extern unsigned char BPB_FATType;
;     698 extern unsigned long BPB_TotSec;
;     699 extern unsigned long BS_VolSerial;
;     700 extern unsigned char BS_VolLab[12];
;     701 extern unsigned long _FF_PART_ADDR, _FF_ROOT_ADDR, _FF_DIR_ADDR;
;     702 extern unsigned long _FF_FAT1_ADDR, _FF_FAT2_ADDR;
;     703 extern unsigned int FirstDataSector;
;     704 extern unsigned long FirstSectorofCluster;
;     705 extern unsigned char _FF_error;
;     706 extern unsigned long _FF_buff_addr;
;     707 extern unsigned long DataClusTot;
;     708 unsigned char rtc_hour, rtc_min, rtc_sec;

	.DSEG
_rtc_hour:
	.BYTE 0x1
_rtc_min:
	.BYTE 0x1
_rtc_sec:
	.BYTE 0x1
;     709 unsigned char rtc_date, rtc_month;
_rtc_date:
	.BYTE 0x1
_rtc_month:
	.BYTE 0x1
;     710 unsigned int rtc_year;
_rtc_year:
	.BYTE 0x2
;     711 unsigned long clus_0_addr, _FF_n_temp;
_clus_0_addr:
	.BYTE 0x4
__FF_n_temp:
	.BYTE 0x4
;     712 unsigned int c_counter;
_c_counter:
	.BYTE 0x2
;     713 unsigned char _FF_FULL_PATH[_FF_PATH_LENGTH];
__FF_FULL_PATH:
	.BYTE 0x64
;     714 unsigned char FILENAME[12];
_FILENAME:
	.BYTE 0xC
;     715 
;     716 // Conversion file to change an ASCII valued character into the calculated value
;     717 unsigned char ascii_to_char(unsigned char ascii_char)
;     718 {

	.CSEG
;     719 	unsigned char temp_char;
;     720 	
;     721 	if (ascii_char < 0x30)		// invalid, return error
;	ascii_char -> Y+1
;	temp_char -> R16
;     722 		return (0xFF);
;     723 	else if (ascii_char < 0x3A)
;     724 	{	//number, subtract 0x30, retrun value
;     725 		temp_char = ascii_char - 0x30;
;     726 		return (temp_char);
;     727 	}
;     728 	else if (ascii_char < 0x41)	// invalid, return error
;     729 		return (0xFF);
;     730 	else if (ascii_char < 0x47)
;     731 	{	// lower case a-f, subtract 0x37, return value
;     732 		temp_char = ascii_char - 0x37;
;     733 		return (temp_char);
;     734 	}
;     735 	else if (ascii_char < 0x61)	// invalid, return error
;     736 		return (0xFF);
;     737 	else if (ascii_char < 0x67)
;     738 	{	// upper case A-F, subtract 0x57, return value
;     739 		temp_char = ascii_char - 0x57;
;     740 		return (temp_char);
;     741 	}
;     742 	else	// invalid, return error
;     743 		return (0xFF);
;     744 }
;     745 
;     746 // Function to see if the character is a valid FILENAME character
;     747 int valid_file_char(unsigned char file_char)
;     748 {
_valid_file_char:
;     749 	if (file_char < 0x20)
	LD   R26,Y
	CPI  R26,LOW(0x20)
	BRSH _0x88
;     750 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3EB
;     751 	else if ((file_char==0x22) || (file_char==0x2A) || (file_char==0x2B) || (file_char==0x2C) ||
_0x88:
;     752 			(file_char==0x2E) || (file_char==0x2F) || ((file_char>=0x3A)&&(file_char<=0x3F)) ||
;     753 			((file_char>=0x5B)&&(file_char<=0x5D)) || (file_char==0x7C) || (file_char==0xE5))
	LD   R26,Y
	CPI  R26,LOW(0x22)
	BREQ _0x8B
	CPI  R26,LOW(0x2A)
	BREQ _0x8B
	CPI  R26,LOW(0x2B)
	BREQ _0x8B
	CPI  R26,LOW(0x2C)
	BREQ _0x8B
	CPI  R26,LOW(0x2E)
	BREQ _0x8B
	CPI  R26,LOW(0x2F)
	BREQ _0x8B
	CPI  R26,LOW(0x3A)
	BRLO _0x8C
	LDI  R30,LOW(63)
	CP   R30,R26
	BRSH _0x8B
_0x8C:
	LD   R26,Y
	CPI  R26,LOW(0x5B)
	BRLO _0x8E
	LDI  R30,LOW(93)
	CP   R30,R26
	BRSH _0x8B
_0x8E:
	LD   R26,Y
	CPI  R26,LOW(0x7C)
	BREQ _0x8B
	CPI  R26,LOW(0xE5)
	BRNE _0x8A
_0x8B:
;     754 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3EB
;     755 	else
_0x8A:
;     756 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
;     757 }
_0x3EB:
	ADIW R28,1
	RET
;     758 
;     759 // Function will scan the directory @VALID_ADDR and return a
;     760 // '0' if successful (w/ VALID_ADDR changing to location of entry avaliable),
;     761 // and a '-1' if file or folder exists (w/ VALID_ADDR changing to location of
;     762 // entry of exisiting file/folder) or if no more entry space (VALID_ADDR would
;     763 // change to 0).
;     764 int scan_directory(unsigned long *VALID_ADDR, unsigned char *NAME)
;     765 {
_scan_directory:
;     766 	unsigned int ent_cntr, ent_max, n, c, dir_clus;
;     767 	unsigned long temp_addr;
;     768 	unsigned char *sp, *qp, aval_flag, name_store[14];
;     769 	
;     770 	aval_flag = 0;
	SBIW R28,27
	CALL __SAVELOCR6
;	*VALID_ADDR -> Y+35
;	*NAME -> Y+33
;	ent_cntr -> R16,R17
;	ent_max -> R18,R19
;	n -> R20,R21
;	c -> Y+31
;	dir_clus -> Y+29
;	temp_addr -> Y+25
;	*sp -> Y+23
;	*qp -> Y+21
;	aval_flag -> Y+20
;	name_store -> Y+6
	LDI  R30,LOW(0)
	STD  Y+20,R30
;     771 	ent_cntr = 0;	// set to 0
	__GETWRN 16,17,0
;     772 	
;     773 	qp = NAME;
	LDD  R30,Y+33
	LDD  R31,Y+33+1
	STD  Y+21,R30
	STD  Y+21+1,R31
;     774 	for (c=0; c<11; c++)
	LDI  R30,0
	STD  Y+31,R30
	STD  Y+31+1,R30
_0x93:
	LDD  R26,Y+31
	LDD  R27,Y+31+1
	CPI  R26,LOW(0xB)
	LDI  R30,HIGH(0xB)
	CPC  R27,R30
	BRLO PC+3
	JMP _0x94
;     775 	{
;     776 		if (valid_file_char(*qp)==0)
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	CALL SUBOPT_0x1B
	BRNE _0x95
;     777 			name_store[c] = toupper(*qp++);
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	MOVW R26,R28
	ADIW R26,6
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	LD   R30,X+
	STD  Y+21,R26
	STD  Y+21+1,R27
	ST   -Y,R30
	CALL _toupper
	POP  R26
	POP  R27
	ST   X,R30
;     778 		else if (*qp == '.')
	RJMP _0x96
_0x95:
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BRNE _0x97
;     779 		{
;     780 			while (c<8)
_0x98:
	LDD  R26,Y+31
	LDD  R27,Y+31+1
	CPI  R26,LOW(0x8)
	LDI  R30,HIGH(0x8)
	CPC  R27,R30
	BRSH _0x9A
;     781 				name_store[c++] = 0x20;
	CALL SUBOPT_0x1C
;     782 			c--;
	RJMP _0x98
_0x9A:
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	SBIW R30,1
	STD  Y+31,R30
	STD  Y+31+1,R31
;     783 			
;     784 			qp++;
	CALL SUBOPT_0x1D
;     785 			aval_flag |= 1;
	LDD  R30,Y+20
	ORI  R30,1
	STD  Y+20,R30
;     786 		}
;     787 		else if (*qp == 0)
	RJMP _0x9B
_0x97:
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	LD   R30,X
	CPI  R30,0
	BRNE _0x9C
;     788 		{
;     789 			while (c<11)
_0x9D:
	LDD  R26,Y+31
	LDD  R27,Y+31+1
	CPI  R26,LOW(0xB)
	LDI  R30,HIGH(0xB)
	CPC  R27,R30
	BRSH _0x9F
;     790 				name_store[c++] = 0x20;
	CALL SUBOPT_0x1C
;     791 		}
	RJMP _0x9D
_0x9F:
;     792 		else
	RJMP _0xA0
_0x9C:
;     793 		{
;     794 			*VALID_ADDR = 0;
	CALL SUBOPT_0x1E
;     795 			return (EOF);
	RJMP _0x3EA
;     796 		}
_0xA0:
_0x9B:
_0x96:
;     797 	}
	CALL SUBOPT_0x1F
	RJMP _0x93
_0x94:
;     798 	name_store[11] = 0;
	LDI  R30,LOW(0)
	STD  Y+17,R30
;     799 	
;     800 	if (*VALID_ADDR == _FF_ROOT_ADDR)
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __GETD1P
	LDS  R26,__FF_ROOT_ADDR
	LDS  R27,__FF_ROOT_ADDR+1
	LDS  R24,__FF_ROOT_ADDR+2
	LDS  R25,__FF_ROOT_ADDR+3
	CALL __CPD12
	BRNE _0xA1
;     801 		ent_max = BPB_RootEntCnt;
	__MOVEWRR 18,19,12,13
;     802 	else
	RJMP _0xA2
_0xA1:
;     803 	{
;     804 		dir_clus = addr_to_clust(*VALID_ADDR);
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __GETD1P
	CALL __PUTPARD1
	RCALL _addr_to_clust
	STD  Y+29,R30
	STD  Y+29+1,R31
;     805 		if (dir_clus != 0)
	SBIW R30,0
	BREQ _0xA3
;     806 			aval_flag |= 0x80;
	LDD  R30,Y+20
	ORI  R30,0x80
	STD  Y+20,R30
;     807 		ent_max = ((long) BPB_BytsPerSec * (long) BPB_SecPerClus) / 0x20;
_0xA3:
	CALL SUBOPT_0x20
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x20
	CALL __DIVD21
	__PUTW1R 18,19
;     808     }
_0xA2:
;     809 	c = 0;
	LDI  R30,0
	STD  Y+31,R30
	STD  Y+31+1,R30
;     810 	while (ent_cntr < ent_max)	
_0xA4:
	__CPWRR 16,17,18,19
	BRLO PC+3
	JMP _0xA6
;     811 	{
;     812 		if (_FF_read(*VALID_ADDR+((long)c*BPB_BytsPerSec))==0)
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x21
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	CALL SUBOPT_0xC
	BRNE _0xA7
;     813 			break;
	RJMP _0xA6
;     814 		for (n=0; n<16; n++)
_0xA7:
	__GETWRN 20,21,0
_0xA9:
	__CPWRN 20,21,16
	BRLO PC+3
	JMP _0xAA
;     815 		{
;     816 			sp = &_FF_buff[n*0x20];
	CALL SUBOPT_0x22
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	STD  Y+23,R30
	STD  Y+23+1,R31
;     817 			qp = name_store;
	MOVW R30,R28
	ADIW R30,6
	STD  Y+21,R30
	STD  Y+21+1,R31
;     818 			if (*sp==0)
	LDD  R26,Y+23
	LDD  R27,Y+23+1
	LD   R30,X
	CPI  R30,0
	BRNE _0xAB
;     819 			{
;     820 				if ((aval_flag&0x10)==0)
	LDD  R30,Y+20
	ANDI R30,LOW(0x10)
	BRNE _0xAC
;     821 					temp_addr = *VALID_ADDR + ((long) c * BPB_BytsPerSec) + (n * 0x20);
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x21
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD21
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;     822 				*VALID_ADDR = temp_addr;
_0xAC:
	CALL SUBOPT_0x24
;     823 				return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x3EA
;     824 			}
;     825 			else if (*sp==0xE5)
_0xAB:
	LDD  R26,Y+23
	LDD  R27,Y+23+1
	LD   R26,X
	CPI  R26,LOW(0xE5)
	BRNE _0xAE
;     826 			{
;     827 				temp_addr = *VALID_ADDR + ((long) c * BPB_BytsPerSec) + (n * 0x20);
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x21
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD21
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;     828 				aval_flag |= 0x10;
	LDD  R30,Y+20
	ORI  R30,0x10
	STD  Y+20,R30
;     829 			}
;     830 			else
	RJMP _0xAF
_0xAE:
;     831 			{
;     832 				if (aval_flag & 0x01)	// file
	LDD  R30,Y+20
	ANDI R30,LOW(0x1)
	BREQ _0xB0
;     833 				{
;     834 					if (strncmp(qp, sp, 11)==0)
	CALL SUBOPT_0x25
	BRNE _0xB1
;     835 					{
;     836 						temp_addr = *VALID_ADDR + ((long) c * BPB_BytsPerSec) + (n * 0x20);
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x21
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD21
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;     837 						*VALID_ADDR = temp_addr;
	CALL SUBOPT_0x24
;     838 						return (EOF);	// file exists @ temp_addr
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3EA
;     839 					}
;     840 				}
_0xB1:
;     841 				else					// folder
	RJMP _0xB2
_0xB0:
;     842 				{
;     843 					if ((strncmp(qp, sp, 11)==0)&&(*(sp+11)&0x10))
	CALL SUBOPT_0x25
	BRNE _0xB4
	LDD  R26,Y+23
	LDD  R27,Y+23+1
	ADIW R26,11
	LD   R30,X
	ANDI R30,LOW(0x10)
	BRNE _0xB5
_0xB4:
	RJMP _0xB3
_0xB5:
;     844 					{
;     845 						temp_addr = *VALID_ADDR + ((long) c * BPB_BytsPerSec) + (n * 0x20);
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x21
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD21
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
;     846 						*VALID_ADDR = temp_addr;
	CALL SUBOPT_0x24
;     847 						return (EOF);	// file exists @ temp_addr
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3EA
;     848 					}
;     849 				}
_0xB3:
_0xB2:
;     850 			}
_0xAF:
;     851 			ent_cntr++;
	__ADDWRN 16,17,1
;     852 		}
	__ADDWRN 20,21,1
	RJMP _0xA9
_0xAA:
;     853 		c++;
	CALL SUBOPT_0x1F
;     854 		if (ent_cntr == ent_max)
	__CPWRR 18,19,16,17
	BRNE _0xB6
;     855 		{
;     856 			if (aval_flag & 0x80)		// a folder @ a valid cluster
	LDD  R30,Y+20
	ANDI R30,LOW(0x80)
	BREQ _0xB7
;     857 			{
;     858 				c = next_cluster(dir_clus, SINGLE);
	LDD  R30,Y+29
	LDD  R31,Y+29+1
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x26
	STD  Y+31,R30
	STD  Y+31+1,R31
;     859 				if (c != EOF)
	LDD  R26,Y+31
	LDD  R27,Y+31+1
	CPI  R26,LOW(0xFFFF)
	LDI  R30,HIGH(0xFFFF)
	CPC  R27,R30
	BREQ _0xB8
;     860 				{	// another dir cluster exists
;     861 					*VALID_ADDR = clust_to_addr(c);
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _clust_to_addr
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __PUTDP1
;     862 					dir_clus = c;
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	STD  Y+29,R30
	STD  Y+29+1,R31
;     863 					ent_cntr = 0;
	__GETWRN 16,17,0
;     864 					c = 0;
	LDI  R30,0
	STD  Y+31,R30
	STD  Y+31+1,R30
;     865 				}
;     866 			}
_0xB8:
;     867 		}
_0xB7:
;     868 	}
_0xB6:
	RJMP _0xA4
_0xA6:
;     869 	*VALID_ADDR = 0;
	CALL SUBOPT_0x1E
;     870 	return (EOF);	
_0x3EA:
	CALL __LOADLOCR6
	ADIW R28,37
	RET
;     871 }
;     872 
;     873 #ifdef _DEBUG_ON_
;     874 // Function to display all files and folders in the root directory, 
;     875 // with the size of the file in bytes within the [brakets]
;     876 void read_directory(void)
;     877 {
;     878 	unsigned char valid_flag, attribute_temp;
;     879 	unsigned int c, n, d, m, dir_clus;
;     880 	unsigned long calc, calc_clus, dir_addr;
;     881 	
;     882 	if (_FF_DIR_ADDR != _FF_ROOT_ADDR)
;	valid_flag -> R16
;	attribute_temp -> R17
;	c -> R18,R19
;	n -> R20,R21
;	d -> Y+22
;	m -> Y+20
;	dir_clus -> Y+18
;	calc -> Y+14
;	calc_clus -> Y+10
;	dir_addr -> Y+6
;     883 	{
;     884 		dir_clus = addr_to_clust(_FF_DIR_ADDR);
;     885 		if (dir_clus == 0)
;     886 			return;
;     887 	}
;     888 
;     889 	printf("\r\nFile Listing for:  ROOT\\");
;     890 	for (d=0; d<_FF_PATH_LENGTH; d++)
;     891 	{
;     892 		if (_FF_FULL_PATH[d])
;     893 			putchar(_FF_FULL_PATH[d]);
;     894 		else
;     895 			break;
;     896 	}
;     897 	
;     898     
;     899     dir_addr = _FF_DIR_ADDR;
;     900 	d = 0;
;     901 	m = 0;
;     902 	while (d<BPB_RootEntCnt)
;     903 	{
;     904     	if (_FF_read(dir_addr+(m*0x200))==0)
;     905     		break;
;     906 		for (n=0; n<16; n++)
;     907 		{
;     908 			for (c=0; c<11; c++)
;     909 			{
;     910 				if (_FF_buff[(n*0x20)]==0)
;     911 				{
;     912 					n=16;
;     913 					d=BPB_RootEntCnt;
;     914 					valid_flag = 0;
;     915 					break;
;     916 				}
;     917 				valid_flag = 1;
;     918 				if (valid_file_char(_FF_buff[(n*0x20)+c]))
;     919 				{
;     920 					valid_flag = 0;
;     921 					break;
;     922 				}
;     923 		    }   
;     924 		    if (valid_flag)
;     925 	  		{
;     926 		  		calc = (n * 0x20) + 0xB;
;     927 		  		attribute_temp = _FF_buff[calc];
;     928 		  		putchar('\n');
;     929 				putchar('\r');
;     930 				c = (n * 0x20);
;     931 			  	calc = ((long) _FF_buff[c+0x1F] << 24) | ((long) _FF_buff[c+0x1E] << 16) |
;     932 			  			((long) _FF_buff[c+0x1D] << 8) | ((long) _FF_buff[c+0x1C]);
;     933 			  	calc_clus = ((int) _FF_buff[c+0x1B] << 8) | (int) _FF_buff[c+0x1A];
;     934 				if (attribute_temp & 0x10)
;     935 					printf("  [");
;     936 				else
;     937 			  		printf("                [%ld] bytes      (%X)\r  ", calc, calc_clus);		  		
;     938 				for (c=0; c<8; c++)
;     939 				{
;     940 					calc = (n * 0x20) + c;
;     941 					if (_FF_buff[calc]==0x20)
;     942 						break;
;     943 					putchar(_FF_buff[calc]);
;     944 				}
;     945 				if (attribute_temp & 0x10)
;     946 				{
;     947 					printf("]      (%X)", calc_clus);
;     948 				}
;     949 				else
;     950 				{
;     951 					putchar('.');
;     952 					for (c=8; c<11; c++)
;     953 					{
;     954 						calc = (n * 0x20) + c;
;     955 						if (_FF_buff[calc]==0x20)
;     956 							break;
;     957 						putchar(_FF_buff[calc]);
;     958 					}
;     959 				}
;     960 		  	}
;     961 		  	d++;		  		
;     962 		}
;     963 		m++;
;     964 		if (_FF_ROOT_ADDR!=_FF_DIR_ADDR)
;     965 		{
;     966 		   	if (m==BPB_SecPerClus)
;     967 		   	{
;     968 
;     969 				m = next_cluster(dir_clus, SINGLE);
;     970 				if (m != EOF)
;     971 				{	// another dir cluster exists
;     972 					dir_addr = clust_to_addr(m);
;     973 					dir_clus = m;
;     974 					d = 0;
;     975 					m = 0;
;     976 				}
;     977 				else
;     978 					break;
;     979 		   		
;     980 		   	}
;     981 		}
;     982 	}
;     983 	putchar('\n');
;     984 	putchar('\r');	
;     985 } 
;     986 
;     987 void GetVolID(void)
;     988 {
;     989 	printf("\r\n  Volume Serial:  [0x%lX]", BS_VolSerial);
;     990 	printf("\r\n  Volume Label:  [%s]\r\n", BS_VolLab);
;     991 }
;     992 #endif
;     993 
;     994 // Convert a cluster number into a read address
;     995 unsigned long clust_to_addr(unsigned int clust_no)
;     996 {
_clust_to_addr:
;     997 	unsigned long clust_addr;
;     998 	
;     999 	FirstSectorofCluster = ((clust_no - 2) * (long) BPB_SecPerClus) + (long) FirstDataSector;
	SBIW R28,4
;	clust_no -> Y+4
;	clust_addr -> Y+0
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,2
	MOV  R30,R8
	CLR  R31
	CLR  R22
	CLR  R23
	CLR  R24
	CLR  R25
	CALL __MULD12U
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_FirstDataSector
	LDS  R31,_FirstDataSector+1
	CLR  R22
	CLR  R23
	CALL __ADDD12
	STS  _FirstSectorofCluster,R30
	STS  _FirstSectorofCluster+1,R31
	STS  _FirstSectorofCluster+2,R22
	STS  _FirstSectorofCluster+3,R23
;    1000 	clust_addr = (long) FirstSectorofCluster * (long) BPB_BytsPerSec + _FF_PART_ADDR;
	__GETW1R 6,7
	CLR  R22
	CLR  R23
	LDS  R26,_FirstSectorofCluster
	LDS  R27,_FirstSectorofCluster+1
	LDS  R24,_FirstSectorofCluster+2
	LDS  R25,_FirstSectorofCluster+3
	CALL SUBOPT_0x27
	__PUTD1S 0
;    1001 
;    1002 	return (clust_addr);
	ADIW R28,6
	RET
;    1003 }
;    1004 
;    1005 // Converts an address into a cluster number
;    1006 unsigned int addr_to_clust(unsigned long clus_addr)
;    1007 {
_addr_to_clust:
;    1008 	if (clus_addr <= _FF_PART_ADDR)
	LDS  R30,__FF_PART_ADDR
	LDS  R31,__FF_PART_ADDR+1
	LDS  R22,__FF_PART_ADDR+2
	LDS  R23,__FF_PART_ADDR+3
	__GETD2S 0
	CALL __CPD12
	BRLO _0xDD
;    1009 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x3E9
;    1010 	clus_addr -= _FF_PART_ADDR;
_0xDD:
	LDS  R26,__FF_PART_ADDR
	LDS  R27,__FF_PART_ADDR+1
	LDS  R24,__FF_PART_ADDR+2
	LDS  R25,__FF_PART_ADDR+3
	__GETD1S 0
	CALL __SUBD12
	__PUTD1S 0
;    1011 	clus_addr /= BPB_BytsPerSec;
	__GETW1R 6,7
	__GETD2S 0
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	__PUTD1S 0
;    1012 	if (clus_addr <= (unsigned long) FirstDataSector)
	LDS  R30,_FirstDataSector
	LDS  R31,_FirstDataSector+1
	CLR  R22
	CLR  R23
	__GETD2S 0
	CALL __CPD12
	BRLO _0xDE
;    1013 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x3E9
;    1014 	clus_addr -= FirstDataSector;
_0xDE:
	LDS  R30,_FirstDataSector
	LDS  R31,_FirstDataSector+1
	__GETD2S 0
	CALL SUBOPT_0x14
	__PUTD1S 0
;    1015 	clus_addr /= BPB_SecPerClus;
	MOV  R30,R8
	__GETD2S 0
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	__PUTD1S 0
;    1016 	clus_addr += 2;
	__ADDD1N 2
	__PUTD1S 0
;    1017 	if (clus_addr > 0xFFFF)
	__GETD2S 0
	__GETD1N 0xFFFF
	CALL __CPD12
	BRSH _0xDF
;    1018 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x3E9
;    1019 	
;    1020 	return ((int) clus_addr);	
_0xDF:
	LD   R30,Y
	LDD  R31,Y+1
_0x3E9:
	ADIW R28,4
	RET
;    1021 }
;    1022 
;    1023 // Find the cluster that the current cluster is pointing to
;    1024 unsigned int next_cluster(unsigned int current_cluster, unsigned char mode)
;    1025 {
_next_cluster:
;    1026 	unsigned int calc_sec, calc_offset, calc_remainder, next_clust;
;    1027 	unsigned long addr_temp;
;    1028 	
;    1029 	if (current_cluster<=1)		// If cluster is 0 or 1, its the wrong cluster
	SBIW R28,6
	CALL __SAVELOCR6
;	current_cluster -> Y+13
;	mode -> Y+12
;	calc_sec -> R16,R17
;	calc_offset -> R18,R19
;	calc_remainder -> R20,R21
;	next_clust -> Y+10
;	addr_temp -> Y+6
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R26
	CPC  R31,R27
	BRLO _0xE0
;    1030 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3E8
;    1031 		
;    1032 	if (BPB_FATType == 0x36)		// if FAT16
_0xE0:
	LDI  R30,LOW(54)
	CP   R30,R14
	BREQ PC+3
	JMP _0xE1
;    1033 	{
;    1034 		// FAT16 table address calculations
;    1035 		calc_sec = current_cluster / (BPB_BytsPerSec / 2) + BPB_RsvdSecCnt;
	CALL SUBOPT_0x28
	CALL SUBOPT_0x29
;    1036 		calc_offset = 2 * (current_cluster % (BPB_BytsPerSec / 2));
	CALL SUBOPT_0x28
	CALL SUBOPT_0x2A
;    1037 	    
;    1038 	 	addr_temp = _FF_PART_ADDR+(calc_sec*0x200);
	CALL SUBOPT_0x2B
;    1039 		if (mode==SINGLE)
	CPI  R26,LOW(0x1)
	BRNE _0xE2
;    1040 		{	// This is a single cluster lookup
;    1041 			if (_FF_read(addr_temp)==0)
	__GETD1S 6
	CALL SUBOPT_0xC
	BRNE _0xE3
;    1042 				return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3E8
;    1043 		}
_0xE3:
;    1044 		else if ((mode==CHAIN) || (mode==END_CHAIN))
	RJMP _0xE4
_0xE2:
	LDD  R26,Y+12
	CPI  R26,LOW(0x0)
	BREQ _0xE6
	CPI  R26,LOW(0x2)
	BRNE _0xE5
_0xE6:
;    1045 		{	// Mupltiple clusters to lookup
;    1046 			if (addr_temp!=_FF_buff_addr)
	CALL SUBOPT_0x2C
	BREQ _0xE8
;    1047 			{	// Is the address of lookup is different then the current buffere address
;    1048 				#ifndef _READ_ONLY_
;    1049 				if (_FF_buff_addr)	// if the buffer address is 0, don't write
	LDS  R30,__FF_buff_addr
	LDS  R31,__FF_buff_addr+1
	LDS  R22,__FF_buff_addr+2
	LDS  R23,__FF_buff_addr+3
	CALL __CPD10
	BREQ _0xE9
;    1050 				{
;    1051 					#ifdef _SECOND_FAT_ON_
;    1052 						if (_FF_buff_addr < _FF_FAT2_ADDR)
	CALL SUBOPT_0x2D
	BRSH _0xEA
;    1053 							if (_FF_write(_FF_buff_addr+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
	CALL SUBOPT_0x2E
	BRNE _0xEB
;    1054 								return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3E8
;    1055 					#endif
;    1056 					if (_FF_write(_FF_buff_addr)==0)	// Save buffer data to card
_0xEB:
_0xEA:
	CALL SUBOPT_0x2F
	BRNE _0xEC
;    1057 						return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3E8
;    1058 				}
_0xEC:
;    1059 				#endif
;    1060 				if (_FF_read(addr_temp)==0)	// Read new table info
_0xE9:
	__GETD1S 6
	CALL SUBOPT_0xC
	BRNE _0xED
;    1061 					return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3E8
;    1062 			}
_0xED:
;    1063 		}
_0xE8:
;    1064 		next_clust = ((int) _FF_buff[calc_offset+1] << 8) | _FF_buff[calc_offset];
_0xE5:
_0xE4:
	CALL SUBOPT_0x30
	LDI  R30,LOW(0)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x31
	POP  R26
	POP  R27
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
;    1065 	}
;    1066 	#ifdef _FAT12_ON_
;    1067 	else if (BPB_FATType == 0x32)	// if FAT12
	RJMP _0xEE
_0xE1:
	LDI  R30,LOW(50)
	CP   R30,R14
	BREQ PC+3
	JMP _0xEF
;    1068 	{
;    1069 		// FAT12 table address calculations
;    1070 		calc_offset = (current_cluster * 3) / 2;
	CALL SUBOPT_0x32
	LSR  R31
	ROR  R30
	__PUTW1R 18,19
;    1071 		calc_remainder = (current_cluster * 3) % 2;
	CALL SUBOPT_0x32
	ANDI R30,LOW(0x1)
	ANDI R31,HIGH(0x1)
	__PUTW1R 20,21
;    1072 		calc_sec = (calc_offset / BPB_BytsPerSec) + BPB_RsvdSecCnt;
	CALL SUBOPT_0x33
;    1073 		calc_offset %= BPB_BytsPerSec;
	CALL SUBOPT_0x34
;    1074 
;    1075 	 	addr_temp = _FF_PART_ADDR+(calc_sec*BPB_BytsPerSec);
	__GETW1R 6,7
	__GETW2R 16,17
	CALL __MULW12U
	LDS  R26,__FF_PART_ADDR
	LDS  R27,__FF_PART_ADDR+1
	LDS  R24,__FF_PART_ADDR+2
	LDS  R25,__FF_PART_ADDR+3
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1S 6
;    1076 		if (mode==SINGLE)
	LDD  R26,Y+12
	CPI  R26,LOW(0x1)
	BRNE _0xF0
;    1077 		{	// This is a single cluster lookup
;    1078 			if (_FF_read(addr_temp)==0)
	CALL SUBOPT_0xC
	BRNE _0xF1
;    1079 				return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3E8
;    1080 		}
_0xF1:
;    1081 		else if ((mode==CHAIN) || (mode==END_CHAIN))
	RJMP _0xF2
_0xF0:
	LDD  R26,Y+12
	CPI  R26,LOW(0x0)
	BREQ _0xF4
	CPI  R26,LOW(0x2)
	BRNE _0xF3
_0xF4:
;    1082 		{	// Mupltiple clusters to lookup
;    1083 			if (addr_temp!=_FF_buff_addr)
	CALL SUBOPT_0x2C
	BREQ _0xF6
;    1084 			{	// Is the address of lookup is different then the current buffere address
;    1085 				#ifndef _READ_ONLY_
;    1086 				if (_FF_buff_addr)	// if the buffer address is 0, don't write
	LDS  R30,__FF_buff_addr
	LDS  R31,__FF_buff_addr+1
	LDS  R22,__FF_buff_addr+2
	LDS  R23,__FF_buff_addr+3
	CALL __CPD10
	BREQ _0xF7
;    1087 				{
;    1088 					#ifdef _SECOND_FAT_ON_
;    1089 						if (_FF_buff_addr < _FF_FAT2_ADDR)
	CALL SUBOPT_0x2D
	BRSH _0xF8
;    1090 							if (_FF_write(_FF_buff_addr+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
	CALL SUBOPT_0x2E
	BRNE _0xF9
;    1091 								return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3E8
;    1092 					#endif
;    1093 					if (_FF_write(_FF_buff_addr)==0)	// Save buffer data to card
_0xF9:
_0xF8:
	CALL SUBOPT_0x2F
	BRNE _0xFA
;    1094 						return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3E8
;    1095 				}
_0xFA:
;    1096 				#endif
;    1097 				if (_FF_read(addr_temp)==0)	// Read new table info
_0xF7:
	__GETD1S 6
	CALL SUBOPT_0xC
	BRNE _0xFB
;    1098 					return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3E8
;    1099 			}
_0xFB:
;    1100 		}
_0xF6:
;    1101 		next_clust = _FF_buff[calc_offset];
_0xF3:
_0xF2:
	CALL SUBOPT_0x31
	LDI  R31,0
	STD  Y+10,R30
	STD  Y+10+1,R31
;    1102 		if (calc_offset == (BPB_BytsPerSec-1))
	CALL SUBOPT_0x35
	BRNE _0xFC
;    1103 		{	// Is the FAT12 record accross more than one sector?
;    1104 			addr_temp = _FF_PART_ADDR+((calc_sec+1)*0x200);
	__GETW1R 16,17
	ADIW R30,1
	CALL SUBOPT_0x2B
;    1105 			if ((mode==CHAIN) || (mode==END_CHAIN))
	CPI  R26,LOW(0x0)
	BREQ _0xFE
	LDD  R26,Y+12
	CPI  R26,LOW(0x2)
	BRNE _0xFD
_0xFE:
;    1106 			{	// multiple chain lookup
;    1107 				#ifndef _READ_ONLY_
;    1108 					#ifdef _SECOND_FAT_ON_
;    1109 						if (_FF_buff_addr < _FF_FAT2_ADDR)
	CALL SUBOPT_0x2D
	BRSH _0x100
;    1110 							if (_FF_write(_FF_buff_addr+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
	CALL SUBOPT_0x2E
	BRNE _0x101
;    1111 								return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3E8
;    1112 					#endif
;    1113 				if (_FF_write(_FF_buff_addr)==0)	// Save buffer data to card
_0x101:
_0x100:
	CALL SUBOPT_0x2F
	BRNE _0x102
;    1114 					return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3E8
;    1115 				#endif
;    1116 				_FF_buff_addr = addr_temp;		// Save new buffer address
_0x102:
	__GETD1S 6
	STS  __FF_buff_addr,R30
	STS  __FF_buff_addr+1,R31
	STS  __FF_buff_addr+2,R22
	STS  __FF_buff_addr+3,R23
;    1117 			}
;    1118 			if (_FF_read(addr_temp)==0)
_0xFD:
	__GETD1S 6
	CALL SUBOPT_0xC
	BRNE _0x103
;    1119 				return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3E8
;    1120 			next_clust |= ((int) _FF_buff[0] << 8);
_0x103:
	LDS  R31,__FF_buff
	RJMP _0x3F2
;    1121 		}
;    1122 		else
_0xFC:
;    1123 			next_clust |= ((int) _FF_buff[calc_offset+1] << 8);
	CALL SUBOPT_0x30
_0x3F2:
	LDI  R30,LOW(0)
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	OR   R30,R26
	OR   R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
;    1124 
;    1125 		if (calc_remainder)
	MOV  R0,R20
	OR   R0,R21
	BREQ _0x105
;    1126 			next_clust >>= 4;
	CALL __LSRW4
	RJMP _0x3F3
;    1127 		else
_0x105:
;    1128 			next_clust &= 0x0FFF;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ANDI R31,HIGH(0xFFF)
_0x3F3:
	STD  Y+10,R30
	STD  Y+10+1,R31
;    1129 			
;    1130 		if (next_clust >= 0xFF8)
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CPI  R26,LOW(0xFF8)
	LDI  R30,HIGH(0xFF8)
	CPC  R27,R30
	BRLO _0x107
;    1131 			next_clust |= 0xF000;			
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ORI  R31,HIGH(0xF000)
	STD  Y+10,R30
	STD  Y+10+1,R31
;    1132 	}
_0x107:
;    1133 	#endif
;    1134 	else		// not FAT12 or FAT16, return 0
	RJMP _0x108
_0xEF:
;    1135 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3E8
;    1136 	return (next_clust);
_0x108:
_0xEE:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
_0x3E8:
	CALL __LOADLOCR6
	ADIW R28,15
	RET
;    1137 }
;    1138 
;    1139 // Convert a constant string file name into the proper 8.3 FAT format
;    1140 unsigned char *file_name_conversion(unsigned char *current_file)
;    1141 {
_file_name_conversion:
;    1142 	unsigned char n, c;
;    1143 		
;    1144 	c = 0;
	ST   -Y,R17
	ST   -Y,R16
;	*current_file -> Y+2
;	n -> R16
;	c -> R17
	LDI  R17,LOW(0)
;    1145 	
;    1146 	for (n=0; n<14; n++)
	LDI  R16,LOW(0)
_0x10A:
	CPI  R16,14
	BRSH _0x10B
;    1147 	{
;    1148 		if (valid_file_char(current_file[n])==0)
	CALL SUBOPT_0x36
	CALL SUBOPT_0x1B
	BRNE _0x10C
;    1149 			// If the character is valid, save in uppercase to file name buffer
;    1150 			FILENAME[c++] = toupper(current_file[n]);
	MOV  R30,R17
	SUBI R17,-1
	LDI  R31,0
	SUBI R30,LOW(-_FILENAME)
	SBCI R31,HIGH(-_FILENAME)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x36
	CALL SUBOPT_0x37
	POP  R26
	POP  R27
	ST   X,R30
;    1151 		else if (current_file[n]=='.')
	RJMP _0x10D
_0x10C:
	CALL SUBOPT_0x36
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BRNE _0x10E
;    1152 			// If it is a period, back fill buffer with [spaces], till 8 characters deep
;    1153 			while (c<8)
_0x10F:
	CPI  R17,8
	BRSH _0x111
;    1154 				FILENAME[c++] = 0x20;
	MOV  R30,R17
	SUBI R17,-1
	CALL SUBOPT_0x38
;    1155 		else if (current_file[n]==0)
	RJMP _0x10F
_0x111:
	RJMP _0x112
_0x10E:
	CALL SUBOPT_0x36
	LD   R30,X
	CPI  R30,0
	BRNE _0x113
;    1156 		{	// If it is NULL, back fill buffer with [spaces], till 11 characters deep
;    1157 			while (c<11)
_0x114:
	CPI  R17,11
	BRSH _0x116
;    1158 				FILENAME[c++] = 0x20;
	MOV  R30,R17
	SUBI R17,-1
	CALL SUBOPT_0x38
;    1159 			break;
	RJMP _0x114
_0x116:
	RJMP _0x10B
;    1160 		}
;    1161 		else
_0x113:
;    1162 		{
;    1163 			_FF_error = NAME_ERR;
	LDI  R30,LOW(5)
	STS  __FF_error,R30
;    1164 			return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x3E7
;    1165 		}
_0x112:
_0x10D:
;    1166 		if (c>=11)
	CPI  R17,11
	BRSH _0x10B
;    1167 			break;
;    1168 	}
	SUBI R16,-1
	RJMP _0x10A
_0x10B:
;    1169 	FILENAME[c] = 0;
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_FILENAME)
	SBCI R27,HIGH(-_FILENAME)
	LDI  R30,LOW(0)
	ST   X,R30
;    1170 	// Return the pointer of the filename
;    1171 	return (FILENAME);		
	LDI  R30,LOW(_FILENAME)
	LDI  R31,HIGH(_FILENAME)
_0x3E7:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
;    1172 }
;    1173 
;    1174 // Find the first cluster that is pointing to clus_no
;    1175 unsigned int prev_cluster(unsigned int clus_no)
;    1176 {
_prev_cluster:
;    1177 	unsigned char read_flag;
;    1178 	unsigned int calc_temp, n, c, n_temp;
;    1179 	unsigned long calc_clus, addr_temp;
;    1180 	
;    1181 	addr_temp = _FF_FAT1_ADDR;
	SBIW R28,12
	CALL __SAVELOCR5
;	clus_no -> Y+17
;	read_flag -> R16
;	calc_temp -> R17,R18
;	n -> R19,R20
;	c -> Y+15
;	n_temp -> Y+13
;	calc_clus -> Y+9
;	addr_temp -> Y+5
	LDS  R30,__FF_FAT1_ADDR
	LDS  R31,__FF_FAT1_ADDR+1
	LDS  R22,__FF_FAT1_ADDR+2
	LDS  R23,__FF_FAT1_ADDR+3
	__PUTD1S 5
;    1182 	c = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+15,R30
	STD  Y+15+1,R31
;    1183 	if ((clus_no==0) && (BPB_FATType==0x36))
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	CALL __CPW02
	BRNE _0x11A
	LDI  R30,LOW(54)
	CP   R30,R14
	BREQ _0x11B
_0x11A:
	RJMP _0x119
_0x11B:
;    1184 	{
;    1185 		if (clus_0_addr>addr_temp)
	__GETD1S 5
	LDS  R26,_clus_0_addr
	LDS  R27,_clus_0_addr+1
	LDS  R24,_clus_0_addr+2
	LDS  R25,_clus_0_addr+3
	CALL __CPD12
	BRSH _0x11C
;    1186 		{
;    1187 			addr_temp = clus_0_addr;
	LDS  R30,_clus_0_addr
	LDS  R31,_clus_0_addr+1
	LDS  R22,_clus_0_addr+2
	LDS  R23,_clus_0_addr+3
	__PUTD1S 5
;    1188 			c = c_counter;
	LDS  R30,_c_counter
	LDS  R31,_c_counter+1
	STD  Y+15,R30
	STD  Y+15+1,R31
;    1189 		}
;    1190 	}
_0x11C:
;    1191 
;    1192 	read_flag = 1;
_0x119:
	LDI  R16,LOW(1)
;    1193 	
;    1194 	while (addr_temp<_FF_FAT2_ADDR)
_0x11D:
	LDS  R30,__FF_FAT2_ADDR
	LDS  R31,__FF_FAT2_ADDR+1
	LDS  R22,__FF_FAT2_ADDR+2
	LDS  R23,__FF_FAT2_ADDR+3
	__GETD2S 5
	CALL __CPD21
	BRLO PC+3
	JMP _0x11F
;    1195 	{
;    1196 		if (BPB_FATType == 0x36)		// if FAT16
	LDI  R30,LOW(54)
	CP   R30,R14
	BREQ PC+3
	JMP _0x120
;    1197 		{
;    1198 			if (clus_no==0)
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	SBIW R30,0
	BRNE _0x121
;    1199 			{
;    1200 				clus_0_addr = addr_temp;
	__GETD1S 5
	STS  _clus_0_addr,R30
	STS  _clus_0_addr+1,R31
	STS  _clus_0_addr+2,R22
	STS  _clus_0_addr+3,R23
;    1201 				c_counter = c;
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	STS  _c_counter,R30
	STS  _c_counter+1,R31
;    1202 			}
;    1203 			if (_FF_read(addr_temp)==0)		// Read error ==> break
_0x121:
	__GETD1S 5
	CALL SUBOPT_0xC
	BRNE _0x122
;    1204 				return(0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x3E6
;    1205 			if (_FF_n_temp)
_0x122:
	LDS  R30,__FF_n_temp
	LDS  R31,__FF_n_temp+1
	LDS  R22,__FF_n_temp+2
	LDS  R23,__FF_n_temp+3
	CALL __CPD10
	BREQ _0x123
;    1206 			{
;    1207 				n_temp = _FF_n_temp;
	LDS  R30,__FF_n_temp
	LDS  R31,__FF_n_temp+1
	STD  Y+13,R30
	STD  Y+13+1,R31
;    1208 				_FF_n_temp = 0;
	LDI  R30,0
	STS  __FF_n_temp,R30
	STS  __FF_n_temp+1,R30
	STS  __FF_n_temp+2,R30
	STS  __FF_n_temp+3,R30
;    1209 			}
;    1210 			else
	RJMP _0x124
_0x123:
;    1211 				n_temp = 0;
	LDI  R30,0
	STD  Y+13,R30
	STD  Y+13+1,R30
;    1212 			for (n=n_temp; n<(BPB_BytsPerSec/2); n++)
_0x124:
	__GETWRS 19,20,13
_0x126:
	__GETW1R 6,7
	LSR  R31
	ROR  R30
	CP   R19,R30
	CPC  R20,R31
	BRLO PC+3
	JMP _0x127
;    1213 			{
;    1214 				calc_clus = ((unsigned int) _FF_buff[(n*2)+1] << 8) | ((unsigned int) _FF_buff[n*2]);
	__GETW1R 19,20
	LSL  R30
	ROL  R31
	ADIW R30,1
	CALL SUBOPT_0x39
	MOVW R26,R30
	__GETW1R 19,20
	LSL  R30
	ROL  R31
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	LD   R30,Z
	CALL SUBOPT_0xF
	__PUTD1S 9
;    1215 				calc_temp = (unsigned long) n + (((unsigned long) BPB_BytsPerSec/2) * ((unsigned long) c - 1));
	__GETW1R 19,20
	CLR  R22
	CLR  R23
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETW1R 6,7
	CLR  R22
	CLR  R23
	CALL __LSRD1
	MOVW R26,R30
	MOVW R24,R22
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	CLR  R22
	CLR  R23
	__SUBD1N 1
	CALL __MULD12U
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	__PUTW1R 17,18
;    1216 				if (calc_clus==clus_no)
	CALL SUBOPT_0x3A
	BRNE _0x128
;    1217 				{
;    1218 					if (calc_clus==0)
	__GETD1S 9
	CALL __CPD10
	BRNE _0x129
;    1219 						_FF_n_temp = n;
	__GETW1R 19,20
	CLR  R22
	CLR  R23
	STS  __FF_n_temp,R30
	STS  __FF_n_temp+1,R31
	STS  __FF_n_temp+2,R22
	STS  __FF_n_temp+3,R23
;    1220 					return(calc_temp);
_0x129:
	__GETW1R 17,18
	RJMP _0x3E6
;    1221 				}
;    1222 				else if (calc_temp > DataClusTot)
_0x128:
	LDS  R30,_DataClusTot
	LDS  R31,_DataClusTot+1
	LDS  R22,_DataClusTot+2
	LDS  R23,_DataClusTot+3
	__GETW2R 17,18
	CLR  R24
	CLR  R25
	CALL __CPD12
	BRSH _0x12B
;    1223 				{
;    1224 					_FF_error = DISK_FULL;
	CALL SUBOPT_0x3B
;    1225 					return (0);
	RJMP _0x3E6
;    1226 				}
;    1227 			}
_0x12B:
	__ADDWRN 19,20,1
	RJMP _0x126
_0x127:
;    1228 			addr_temp += 0x200;
	CALL SUBOPT_0x3C
;    1229 			c++;
	CALL SUBOPT_0x3D
;    1230 		}
;    1231 		#ifdef _FAT12_ON_
;    1232 		else if (BPB_FATType == 0x32)	// if FAT12
	RJMP _0x12C
_0x120:
	LDI  R30,LOW(50)
	CP   R30,R14
	BREQ PC+3
	JMP _0x12D
;    1233 		{
;    1234 			if (read_flag)
	CPI  R16,0
	BREQ _0x12E
;    1235 			{
;    1236 				if (_FF_read(addr_temp)==0)
	__GETD1S 5
	CALL SUBOPT_0xC
	BRNE _0x12F
;    1237 					return (0);	// if the read fails return 0
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x3E6
;    1238 				read_flag = 0;
_0x12F:
	LDI  R16,LOW(0)
;    1239 			}
;    1240 			calc_temp = ((unsigned long) c * 3) / 2;
_0x12E:
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	CLR  R22
	CLR  R23
	__GETD2N 0x3
	CALL __MULD12U
	CALL __LSRD1
	__PUTW1R 17,18
;    1241 			calc_temp %= BPB_BytsPerSec;
	__GETW1R 6,7
	__GETW2R 17,18
	CALL __MODW21U
	__PUTW1R 17,18
;    1242 			calc_clus = _FF_buff[calc_temp++];
	__GETW1R 17,18
	__ADDWRN 17,18,1
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	LD   R30,Z
	CLR  R31
	CLR  R22
	CLR  R23
	__PUTD1S 9
;    1243 			if (calc_temp == BPB_BytsPerSec)
	__CPWRR 6,7,17,18
	BRNE _0x130
;    1244 			{	// Is the FAT12 record accross a sector?
;    1245 				addr_temp += 0x200;
	CALL SUBOPT_0x3C
;    1246 				if (_FF_read(addr_temp)==0)
	__GETD1S 5
	CALL SUBOPT_0xC
	BRNE _0x131
;    1247 					return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x3E6
;    1248 				calc_clus |= ((unsigned int) _FF_buff[0] << 8);
_0x131:
	LDS  R31,__FF_buff
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3E
;    1249 				calc_temp = 0;
	__GETWRN 17,18,0
;    1250 			}
;    1251 			else
	RJMP _0x132
_0x130:
;    1252 				calc_clus |= ((unsigned int) _FF_buff[calc_temp++] << 8);
	__GETW1R 17,18
	__ADDWRN 17,18,1
	CALL SUBOPT_0x39
	CALL SUBOPT_0x3E
;    1253                           	
;    1254 			if (c % 2)
_0x132:
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ANDI R30,LOW(0x1)
	BREQ _0x133
;    1255 				calc_clus >>= 4;
	__GETD2S 9
	LDI  R30,LOW(4)
	CALL __LSRD12
	RJMP _0x3F4
;    1256 			else
_0x133:
;    1257 				calc_clus &= 0x0FFF;
	__GETD1S 9
	__ANDD1N 0xFFF
_0x3F4:
	__PUTD1S 9
;    1258 			
;    1259 			if (calc_clus == clus_no)
	CALL SUBOPT_0x3A
	BRNE _0x135
;    1260 				return (c);
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	RJMP _0x3E6
;    1261 			else if (c > DataClusTot)
_0x135:
	LDS  R30,_DataClusTot
	LDS  R31,_DataClusTot+1
	LDS  R22,_DataClusTot+2
	LDS  R23,_DataClusTot+3
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	CLR  R24
	CLR  R25
	CALL __CPD12
	BRSH _0x137
;    1262 			{
;    1263 				_FF_error = DISK_FULL;
	CALL SUBOPT_0x3B
;    1264 				return (0);
	RJMP _0x3E6
;    1265 			}
;    1266 			if ((calc_temp == BPB_BytsPerSec) && (c % 2))
_0x137:
	__CPWRR 6,7,17,18
	BRNE _0x139
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ANDI R30,LOW(0x1)
	BRNE _0x13A
_0x139:
	RJMP _0x138
_0x13A:
;    1267 			{
;    1268 				addr_temp += 0x200;
	CALL SUBOPT_0x3C
;    1269 				read_flag = 1;
	LDI  R16,LOW(1)
;    1270 			}                                                           
;    1271 			
;    1272 			c++;			
_0x138:
	CALL SUBOPT_0x3D
;    1273 		}
;    1274 		#endif
;    1275 		else
	RJMP _0x13B
_0x12D:
;    1276 			return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x3E6
;    1277 	}
_0x13B:
_0x12C:
	RJMP _0x11D
_0x11F:
;    1278 	_FF_error = DISK_FULL;
	CALL SUBOPT_0x3B
;    1279 	return (0);
_0x3E6:
	CALL __LOADLOCR5
	ADIW R28,19
	RET
;    1280 }
;    1281 
;    1282 #ifndef _READ_ONLY_
;    1283 // Update cluster table to point to new cluster
;    1284 unsigned char write_clus_table(unsigned int current_cluster, unsigned int next_value, unsigned char mode)
;    1285 {
_write_clus_table:
;    1286 	unsigned long addr_temp;
;    1287 	unsigned int calc_sec, calc_offset, calc_temp, calc_remainder;
;    1288 	unsigned char nibble[3];
;    1289 	
;    1290 	if (current_cluster <=1)		// Should never be writing to cluster 0 or 1
	SBIW R28,9
	CALL __SAVELOCR6
;	current_cluster -> Y+18
;	next_value -> Y+16
;	mode -> Y+15
;	addr_temp -> Y+11
;	calc_sec -> R16,R17
;	calc_offset -> R18,R19
;	calc_temp -> R20,R21
;	calc_remainder -> Y+9
;	nibble -> Y+6
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x13C
;    1291 	{
;    1292 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x3E5
;    1293 	}
;    1294 	if (BPB_FATType == 0x36)		// if FAT16
_0x13C:
	LDI  R30,LOW(54)
	CP   R30,R14
	BREQ PC+3
	JMP _0x13D
;    1295 	{
;    1296 		calc_sec = current_cluster / (BPB_BytsPerSec / 2) + BPB_RsvdSecCnt;
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x29
;    1297 		calc_offset = 2 * (current_cluster % (BPB_BytsPerSec / 2));
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x2A
;    1298 		addr_temp = _FF_PART_ADDR + ((long) calc_sec*0x200);
	CLR  R22
	CLR  R23
	__GETD2N 0x200
	CALL SUBOPT_0x27
	CALL SUBOPT_0x40
;    1299 		if (mode==SINGLE)
	BRNE _0x13E
;    1300 		{	// Updating a single cluster (like writing or saving a file)
;    1301 			if (_FF_read(addr_temp)==0)
	__GETD1S 11
	CALL SUBOPT_0xC
	BRNE _0x13F
;    1302 				return(0);
	LDI  R30,LOW(0)
	RJMP _0x3E5
;    1303 		}
_0x13F:
;    1304 		else if ((mode==CHAIN) || (mode==END_CHAIN))
	RJMP _0x140
_0x13E:
	LDD  R26,Y+15
	CPI  R26,LOW(0x0)
	BREQ _0x142
	CPI  R26,LOW(0x2)
	BRNE _0x141
_0x142:
;    1305 		{	// Multiple table access operation
;    1306 			if (addr_temp!=_FF_buff_addr)
	CALL SUBOPT_0x41
	BREQ _0x144
;    1307 			{	// if the desired address is already in the buffer => skip loading buffer
;    1308 				if (_FF_buff_addr)	// if new table address, write buffered, and load new
	LDS  R30,__FF_buff_addr
	LDS  R31,__FF_buff_addr+1
	LDS  R22,__FF_buff_addr+2
	LDS  R23,__FF_buff_addr+3
	CALL __CPD10
	BREQ _0x145
;    1309 				{
;    1310 					#ifdef _SECOND_FAT_ON_
;    1311 						if (_FF_buff_addr < _FF_FAT2_ADDR)
	CALL SUBOPT_0x2D
	BRSH _0x146
;    1312 							if (_FF_write(_FF_buff_addr+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
	CALL SUBOPT_0x2E
	BRNE _0x147
;    1313 								return(0);
	LDI  R30,LOW(0)
	RJMP _0x3E5
;    1314 					#endif
;    1315 					if (_FF_write(_FF_buff_addr)==0)
_0x147:
_0x146:
	CALL SUBOPT_0x2F
	BRNE _0x148
;    1316 						return(0);
	LDI  R30,LOW(0)
	RJMP _0x3E5
;    1317 				}
_0x148:
;    1318 				if (_FF_read(addr_temp)==0)
_0x145:
	__GETD1S 11
	CALL SUBOPT_0xC
	BRNE _0x149
;    1319 					return(0);
	LDI  R30,LOW(0)
	RJMP _0x3E5
;    1320 			}
_0x149:
;    1321 		}
_0x144:
;    1322 				
;    1323 		_FF_buff[calc_offset+1] = (next_value >> 8); 
_0x141:
_0x140:
	CALL SUBOPT_0x42
	MOVW R26,R30
	LDD  R30,Y+17
	ANDI R31,HIGH(0x0)
	ST   X,R30
;    1324 		_FF_buff[calc_offset] = (next_value & 0xFF);
	__GETW2R 18,19
	SUBI R26,LOW(-__FF_buff)
	SBCI R27,HIGH(-__FF_buff)
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ANDI R31,HIGH(0xFF)
	CALL SUBOPT_0x43
;    1325 		if ((mode==SINGLE) || (mode==END_CHAIN))
	BREQ _0x14B
	LDD  R26,Y+15
	CPI  R26,LOW(0x2)
	BRNE _0x14A
_0x14B:
;    1326 		{
;    1327 			#ifdef _SECOND_FAT_ON_
;    1328 				if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
	CALL SUBOPT_0x44
	BRNE _0x14D
;    1329 					return(0);
	LDI  R30,LOW(0)
	RJMP _0x3E5
;    1330 			#endif
;    1331 			if (_FF_write(addr_temp)==0)
_0x14D:
	CALL SUBOPT_0x45
	BRNE _0x14E
;    1332 			{
;    1333 				return(0);
	LDI  R30,LOW(0)
	RJMP _0x3E5
;    1334 			}
;    1335 		}
_0x14E:
;    1336 	}
_0x14A:
;    1337 	#ifdef _FAT12_ON_
;    1338 		else if (BPB_FATType == 0x32)		// if FAT12
	RJMP _0x14F
_0x13D:
	LDI  R30,LOW(50)
	CP   R30,R14
	BREQ PC+3
	JMP _0x150
;    1339 		{
;    1340 			calc_offset = (current_cluster * 3) / 2;
	CALL SUBOPT_0x46
	LSR  R31
	ROR  R30
	__PUTW1R 18,19
;    1341 			calc_remainder = (current_cluster * 3) % 2;
	CALL SUBOPT_0x46
	ANDI R30,LOW(0x1)
	ANDI R31,HIGH(0x1)
	STD  Y+9,R30
	STD  Y+9+1,R31
;    1342 			calc_sec = calc_offset / BPB_BytsPerSec + BPB_RsvdSecCnt;
	CALL SUBOPT_0x33
;    1343 			calc_offset %= BPB_BytsPerSec;
	CALL SUBOPT_0x34
;    1344 			addr_temp = _FF_PART_ADDR + ((long) calc_sec * (long) BPB_BytsPerSec);
	__GETW1R 16,17
	CALL SUBOPT_0xE
	LDS  R26,__FF_PART_ADDR
	LDS  R27,__FF_PART_ADDR+1
	LDS  R24,__FF_PART_ADDR+2
	LDS  R25,__FF_PART_ADDR+3
	CALL __ADDD12
	CALL SUBOPT_0x40
;    1345 
;    1346 			if (mode==SINGLE)
	BRNE _0x151
;    1347 			{
;    1348 				if (_FF_read(addr_temp)==0)
	__GETD1S 11
	CALL SUBOPT_0xC
	BRNE _0x152
;    1349 					return(0);
	LDI  R30,LOW(0)
	RJMP _0x3E5
;    1350  			}
_0x152:
;    1351  			else if ((mode==CHAIN) || (mode==END_CHAIN))
	RJMP _0x153
_0x151:
	LDD  R26,Y+15
	CPI  R26,LOW(0x0)
	BREQ _0x155
	CPI  R26,LOW(0x2)
	BRNE _0x154
_0x155:
;    1352   			{
;    1353 				if (addr_temp!=_FF_buff_addr)
	CALL SUBOPT_0x41
	BREQ _0x157
;    1354 				{
;    1355 					if (_FF_buff_addr)
	LDS  R30,__FF_buff_addr
	LDS  R31,__FF_buff_addr+1
	LDS  R22,__FF_buff_addr+2
	LDS  R23,__FF_buff_addr+3
	CALL __CPD10
	BREQ _0x158
;    1356 					{
;    1357 					#ifdef _SECOND_FAT_ON_
;    1358 						if (_FF_buff_addr < _FF_FAT2_ADDR)
	CALL SUBOPT_0x2D
	BRSH _0x159
;    1359 							if (_FF_write(_FF_buff_addr+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
	CALL SUBOPT_0x2E
	BRNE _0x15A
;    1360 								return(0);
	LDI  R30,LOW(0)
	RJMP _0x3E5
;    1361 					#endif
;    1362 						if (_FF_write(_FF_buff_addr)==0)
_0x15A:
_0x159:
	CALL SUBOPT_0x2F
	BRNE _0x15B
;    1363 							return(0);
	LDI  R30,LOW(0)
	RJMP _0x3E5
;    1364 					}
_0x15B:
;    1365 					if (_FF_read(addr_temp)==0)
_0x158:
	__GETD1S 11
	CALL SUBOPT_0xC
	BRNE _0x15C
;    1366 						return(0);
	LDI  R30,LOW(0)
	RJMP _0x3E5
;    1367 				}
_0x15C:
;    1368 			}
_0x157:
;    1369 			nibble[0] = next_value & 0x00F;
_0x154:
_0x153:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	STD  Y+6,R30
;    1370 			nibble[1] = (next_value >> 4) & 0x00F;
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	CALL __LSRW4
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	STD  Y+7,R30
;    1371 			nibble[2] = (next_value >> 8) & 0x00F;
	LDD  R30,Y+17
	ANDI R31,HIGH(0x0)
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	STD  Y+8,R30
;    1372     	
;    1373 			if (calc_offset == (BPB_BytsPerSec-1))
	CALL SUBOPT_0x35
	BREQ PC+3
	JMP _0x15D
;    1374 			{	// Is the FAT12 record accross a sector?
;    1375 				if (calc_remainder)
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	SBIW R30,0
	BREQ _0x15E
;    1376 				{	// Record table uses 1 nibble of last byte
;    1377 					calc_temp = _FF_buff[calc_offset] & 0x0F;	// Mask to add new value
	CALL SUBOPT_0x31
	CALL SUBOPT_0x47
;    1378 					_FF_buff[calc_offset] = calc_temp | (nibble[0] << 4);	// store nibble in correct location
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x48
	POP  R26
	POP  R27
	ST   X,R30
;    1379 					#ifdef _SECOND_FAT_ON_
;    1380 						if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
	CALL SUBOPT_0x44
	BRNE _0x15F
;    1381 							return(0);
	LDI  R30,LOW(0)
	RJMP _0x3E5
;    1382 					#endif
;    1383 					if (_FF_write(addr_temp)==0)
_0x15F:
	CALL SUBOPT_0x45
	BRNE _0x160
;    1384 						return(0);
	LDI  R30,LOW(0)
	RJMP _0x3E5
;    1385 					addr_temp += BPB_BytsPerSec;
_0x160:
	CALL SUBOPT_0x49
;    1386 					if (_FF_read(addr_temp)==0)
	BRNE _0x161
;    1387 						return(0);	// if the read fails return 0
	LDI  R30,LOW(0)
	RJMP _0x3E5
;    1388 					_FF_buff[0] = (nibble[2] << 4) | nibble[1];
_0x161:
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x4B
;    1389 					if ((mode==SINGLE) || (mode==END_CHAIN))
	BREQ _0x163
	LDD  R26,Y+15
	CPI  R26,LOW(0x2)
	BRNE _0x162
_0x163:
;    1390 					{
;    1391 						#ifdef _SECOND_FAT_ON_
;    1392 							if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
	CALL SUBOPT_0x44
	BRNE _0x165
;    1393 								return(0);
	LDI  R30,LOW(0)
	RJMP _0x3E5
;    1394 						#endif
;    1395 						if (_FF_write(addr_temp)==0)
_0x165:
	CALL SUBOPT_0x45
	BRNE _0x166
;    1396 							return(0);
	LDI  R30,LOW(0)
	RJMP _0x3E5
;    1397 					}
_0x166:
;    1398 				}
_0x162:
;    1399 				else
	RJMP _0x167
_0x15E:
;    1400 				{	// Record table uses whole last byte
;    1401 					_FF_buff[calc_offset] = (nibble[1] << 4) | nibble[0];
	__GETW1R 18,19
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x4C
	POP  R26
	POP  R27
	ST   X,R30
;    1402 					#ifdef _SECOND_FAT_ON_
;    1403 						if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
	CALL SUBOPT_0x44
	BRNE _0x168
;    1404 							return(0);
	LDI  R30,LOW(0)
	RJMP _0x3E5
;    1405 					#endif
;    1406 					if (_FF_write(addr_temp)==0)
_0x168:
	CALL SUBOPT_0x45
	BRNE _0x169
;    1407 						return(0);
	LDI  R30,LOW(0)
	RJMP _0x3E5
;    1408 					addr_temp += BPB_BytsPerSec;
_0x169:
	CALL SUBOPT_0x49
;    1409 					if (_FF_read(addr_temp)==0)
	BRNE _0x16A
;    1410 						return(0);	// if the read fails return 0
	LDI  R30,LOW(0)
	RJMP _0x3E5
;    1411 					calc_temp = _FF_buff[0] & 0xF0;		// Mask to add new value
_0x16A:
	LDS  R30,__FF_buff
	CALL SUBOPT_0x4D
;    1412 					_FF_buff[0] = calc_temp | nibble[2];	// store nibble in correct location
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x4B
;    1413 					if ((mode==SINGLE) || (mode==END_CHAIN))
	BREQ _0x16C
	LDD  R26,Y+15
	CPI  R26,LOW(0x2)
	BRNE _0x16B
_0x16C:
;    1414 					{
;    1415 						#ifdef _SECOND_FAT_ON_
;    1416 							if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
	CALL SUBOPT_0x44
	BRNE _0x16E
;    1417 								return(0);
	LDI  R30,LOW(0)
	RJMP _0x3E5
;    1418 						#endif
;    1419 						if (_FF_write(addr_temp)==0)
_0x16E:
	CALL SUBOPT_0x45
	BRNE _0x16F
;    1420 							return(0);
	LDI  R30,LOW(0)
	RJMP _0x3E5
;    1421 					}
_0x16F:
;    1422 				}
_0x16B:
_0x167:
;    1423 			}
;    1424 			else
	RJMP _0x170
_0x15D:
;    1425 			{
;    1426 				if (calc_remainder)
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	SBIW R30,0
	BREQ _0x171
;    1427 				{	// Record table uses 1 nibble of current byte
;    1428 					calc_temp = _FF_buff[calc_offset] & 0x0F;	// Mask to add new value
	CALL SUBOPT_0x31
	CALL SUBOPT_0x47
;    1429 					_FF_buff[calc_offset] = calc_temp | (nibble[0] << 4);	// store nibble in correct location
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x48
	POP  R26
	POP  R27
	ST   X,R30
;    1430 					_FF_buff[calc_offset+1] = (nibble[2] << 4) | nibble[1];
	CALL SUBOPT_0x42
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x4A
	POP  R26
	POP  R27
	CALL SUBOPT_0x43
;    1431 					if ((mode==SINGLE) || (mode==END_CHAIN))
	BREQ _0x173
	LDD  R26,Y+15
	CPI  R26,LOW(0x2)
	BRNE _0x172
_0x173:
;    1432 					{
;    1433 						#ifdef _SECOND_FAT_ON_
;    1434 							if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
	CALL SUBOPT_0x44
	BRNE _0x175
;    1435 								return(0);
	LDI  R30,LOW(0)
	RJMP _0x3E5
;    1436 						#endif
;    1437 						if (_FF_write(addr_temp)==0)
_0x175:
	CALL SUBOPT_0x45
	BRNE _0x176
;    1438 							return(0);
	LDI  R30,LOW(0)
	RJMP _0x3E5
;    1439 					}
_0x176:
;    1440 				}
_0x172:
;    1441 				else
	RJMP _0x177
_0x171:
;    1442 				{	// Record table uses whole current byte
;    1443 					_FF_buff[calc_offset] = (nibble[1] << 4) | nibble[0];
	__GETW1R 18,19
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x4C
	POP  R26
	POP  R27
	ST   X,R30
;    1444 					calc_temp = _FF_buff[calc_offset+1] & 0xF0;		// Mask to add new value
	CALL SUBOPT_0x42
	LD   R30,Z
	CALL SUBOPT_0x4D
;    1445 					_FF_buff[calc_offset+1] = calc_temp | nibble[2];	// store nibble in correct location
	CALL SUBOPT_0x42
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x4E
	POP  R26
	POP  R27
	CALL SUBOPT_0x43
;    1446 					if ((mode==SINGLE) || (mode==END_CHAIN))
	BREQ _0x179
	LDD  R26,Y+15
	CPI  R26,LOW(0x2)
	BRNE _0x178
_0x179:
;    1447 					{
;    1448 						#ifdef _SECOND_FAT_ON_
;    1449 							if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
	CALL SUBOPT_0x44
	BRNE _0x17B
;    1450 								return(0);
	LDI  R30,LOW(0)
	RJMP _0x3E5
;    1451 						#endif
;    1452 						if (_FF_write(addr_temp)==0)
_0x17B:
	CALL SUBOPT_0x45
	BRNE _0x17C
;    1453 							return(0);
	LDI  R30,LOW(0)
	RJMP _0x3E5
;    1454 					}
_0x17C:
;    1455 				}
_0x178:
_0x177:
;    1456 			}
_0x170:
;    1457 		}
;    1458 	#endif
;    1459 	else		// not FAT12 or FAT16, return 0
	RJMP _0x17D
_0x150:
;    1460 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x3E5
;    1461 		
;    1462 	return(1);	
_0x17D:
_0x14F:
	LDI  R30,LOW(1)
_0x3E5:
	CALL __LOADLOCR6
	ADIW R28,20
	RET
;    1463 }
;    1464 #endif
;    1465 
;    1466 #ifndef _READ_ONLY_
;    1467 // Save new entry data to FAT entry
;    1468 unsigned char append_toc(FILE *rp)
;    1469 {
_append_toc:
;    1470 	unsigned long file_data;
;    1471 	unsigned char n;
;    1472 	unsigned char *fp;
;    1473 	unsigned int calc_temp, calc_date;
;    1474 	
;    1475 	if (rp==NULL)
	SBIW R28,6
	CALL __SAVELOCR5
;	*rp -> Y+11
;	file_data -> Y+7
;	n -> R16
;	*fp -> R17,R18
;	calc_temp -> R19,R20
;	calc_date -> Y+5
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	SBIW R30,0
	BRNE _0x17E
;    1476 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x3E4
;    1477 
;    1478 	file_data = rp->length;
_0x17E:
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	CALL __GETD1P
	__PUTD1S 7
;    1479 	if (_FF_read(rp->entry_sec_addr)==0)
	CALL SUBOPT_0x4F
	CALL __FF_read
	CPI  R30,0
	BRNE _0x17F
;    1480 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x3E4
;    1481 	
;    1482 	// Update Starting Cluster 
;    1483 	fp = &_FF_buff[rp->entry_offset+0x1a];
_0x17F:
	CALL SUBOPT_0x50
	ADIW R30,26
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	__PUTW1R 17,18
;    1484 	*fp++ = rp->clus_start & 0xFF;
	PUSH R18
	PUSH R17
	__ADDWRN 17,18,1
	CALL SUBOPT_0x51
	ANDI R31,HIGH(0xFF)
	POP  R26
	POP  R27
	ST   X,R30
;    1485 	*fp++ = rp->clus_start >> 8;
	PUSH R18
	PUSH R17
	__ADDWRN 17,18,1
	CALL SUBOPT_0x51
	MOV  R30,R31
	LDI  R31,0
	POP  R26
	POP  R27
	ST   X,R30
;    1486 	
;    1487 	// Update the File Size
;    1488 	for (n=0; n<4; n++)
	LDI  R16,LOW(0)
_0x181:
	CPI  R16,4
	BRSH _0x182
;    1489 	{
;    1490 		*fp = file_data & 0xFF;
	CALL SUBOPT_0x52
;    1491 		file_data >>= 8;
;    1492 		fp++;
	__ADDWRN 17,18,1
;    1493 	}
	SUBI R16,-1
	RJMP _0x181
_0x182:
;    1494 	
;    1495 	
;    1496 	fp = &_FF_buff[rp->entry_offset+0x16];
	CALL SUBOPT_0x50
	ADIW R30,22
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	__PUTW1R 17,18
;    1497 	#ifdef _RTC_ON_ 	// Date/Time Stamp file w/ RTC
;    1498 		rtc_get_timeNdate(&rtc_hour, &rtc_min, &rtc_sec, &rtc_date, &rtc_month, (int *)&rtc_year);	    			
;    1499 		calc_temp = ((int)rtc_sec&0x1F) | (((int)rtc_min&0x3F)<<5) | (((int)rtc_hour&0x1F)<<11);
;    1500 		*fp++ = calc_temp&0x00FF;	// File create Time 
;    1501 		*fp++ = (calc_temp&0xFF00) >> 8;
;    1502 		calc_date = ((int)rtc_date&0x1F) | (((int)rtc_month&0x0F)<<5) | (((rtc_year-1980)&0x7F)<<9);
;    1503 		*fp++ = calc_date&0x00FF;	// File create Date
;    1504 		*fp++ = (calc_date&0xFF00) >> 8;
;    1505 	#else		// Increment Date Code, no RTC used 
;    1506 		file_data = 0;
	__CLRD1S 7
;    1507 		for (n=0; n<4; n++)
	LDI  R16,LOW(0)
_0x184:
	CPI  R16,4
	BRSH _0x185
;    1508 		{
;    1509 			file_data <<= 8;
	__GETD2S 7
	LDI  R30,LOW(8)
	CALL __LSLD12
	__PUTD1S 7
;    1510 			file_data |= *fp;
	__GETW2R 17,18
	LD   R30,X
	__GETD2S 7
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __ORD12
	__PUTD1S 7
;    1511 			fp--;
	__SUBWRN 17,18,1
;    1512 		}
	SUBI R16,-1
	RJMP _0x184
_0x185:
;    1513 		file_data++;
	__GETD1S 7
	__SUBD1N -1
	__PUTD1S 7
;    1514 		for (n=0; n<4; n++)
	LDI  R16,LOW(0)
_0x187:
	CPI  R16,4
	BRSH _0x188
;    1515 		{
;    1516 			fp++;
	__ADDWRN 17,18,1
;    1517 			*fp = file_data & 0xFF;
	CALL SUBOPT_0x52
;    1518 			file_data >>=8;
;    1519 		}
	SUBI R16,-1
	RJMP _0x187
_0x188:
;    1520 	#endif
;    1521 	if (_FF_write(rp->entry_sec_addr)==0)
	CALL SUBOPT_0x4F
	CALL __FF_write
	CPI  R30,0
	BRNE _0x189
;    1522 		return(0);
	LDI  R30,LOW(0)
	RJMP _0x3E4
;    1523 	
;    1524 	return(1);
_0x189:
	LDI  R30,LOW(1)
_0x3E4:
	CALL __LOADLOCR5
	ADIW R28,13
	RET
;    1525 }
;    1526 #endif
;    1527 
;    1528 #ifndef _READ_ONLY_
;    1529 // Erase a chain of clusters (set table entries to 0 for clusters in chain)
;    1530 unsigned char erase_clus_chain(unsigned int start_clus)
;    1531 {
_erase_clus_chain:
;    1532 	unsigned int clus_temp, clus_use;
;    1533 	
;    1534 	if (start_clus==0)
	CALL __SAVELOCR4
;	start_clus -> Y+4
;	clus_temp -> R16,R17
;	clus_use -> R18,R19
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BRNE _0x18A
;    1535 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x3E3
;    1536 	clus_use = start_clus;
_0x18A:
	__GETWRS 18,19,4
;    1537 	_FF_buff_addr = 0;
	LDI  R30,0
	STS  __FF_buff_addr,R30
	STS  __FF_buff_addr+1,R30
	STS  __FF_buff_addr+2,R30
	STS  __FF_buff_addr+3,R30
;    1538 	while(clus_use <= 0xFFF8)
_0x18B:
	LDI  R30,LOW(65528)
	LDI  R31,HIGH(65528)
	CP   R30,R18
	CPC  R31,R19
	BRLO _0x18D
;    1539 	{
;    1540 		clus_temp = next_cluster(clus_use, CHAIN);
	CALL SUBOPT_0x53
	__PUTW1R 16,17
;    1541 		if ((clus_temp >= 0xFFF8) || (clus_temp == 0))
	__CPWRN 16,17,65528
	BRSH _0x18F
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRNE _0x18E
_0x18F:
;    1542 			break;
	RJMP _0x18D
;    1543 		if (write_clus_table(clus_use, 0, CHAIN) == 0)
_0x18E:
	CALL SUBOPT_0x54
	CALL SUBOPT_0x55
	BRNE _0x191
;    1544 			return (0);
	LDI  R30,LOW(0)
	RJMP _0x3E3
;    1545 		clus_use = clus_temp;
_0x191:
	__MOVEWRR 18,19,16,17
;    1546 	}
	RJMP _0x18B
_0x18D:
;    1547 	if (write_clus_table(clus_use, 0, END_CHAIN) == 0)
	CALL SUBOPT_0x54
	CALL SUBOPT_0x56
	BRNE _0x192
;    1548 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x3E3
;    1549 	clus_0_addr = 0;
_0x192:
	LDI  R30,0
	STS  _clus_0_addr,R30
	STS  _clus_0_addr+1,R30
	STS  _clus_0_addr+2,R30
	STS  _clus_0_addr+3,R30
;    1550 	c_counter = 0;
	LDI  R30,0
	STS  _c_counter,R30
	STS  _c_counter+1,R30
;    1551 	
;    1552 	return (1);	
	LDI  R30,LOW(1)
_0x3E3:
	CALL __LOADLOCR4
	ADIW R28,6
	RET
;    1553 }
;    1554 
;    1555 // Quickformat of a card (erase cluster table and root directory
;    1556 int fquickformat(void)
;    1557 {
;    1558 	long c;
;    1559 	
;    1560 	for (c=0; c<BPB_BytsPerSec; c++)
;	c -> Y+0
;    1561 		_FF_buff[c] = 0;
;    1562 	
;    1563 	c = _FF_FAT1_ADDR + 0x200;
;    1564 	while (c < (_FF_ROOT_ADDR + (0x400 * BPB_SecPerClus)))
;    1565 	{
;    1566 		if (_FF_write(c)==0)
;    1567 		{
;    1568 			_FF_error = WRITE_ERR;
;    1569 			return (EOF);
;    1570 		}
;    1571 		c += 0x200;
;    1572 	}	
;    1573 	_FF_buff[0] = 0xF8;
;    1574 	_FF_buff[1] = 0xFF;
;    1575 	_FF_buff[2] = 0xFF;
;    1576 	if (BPB_FATType == 0x36)
;    1577 		_FF_buff[3] = 0xFF;
;    1578 	if ((_FF_write(_FF_FAT1_ADDR)==0) || (_FF_write(_FF_FAT2_ADDR)==0))
;    1579 	{
;    1580 		_FF_error = WRITE_ERR;
;    1581 		return (EOF);
;    1582 	}
;    1583 	return (0);
;    1584 }
;    1585 #endif
;    1586 
;    1587 // function that checks for directory changes then gets into a working form
;    1588 int _FF_checkdir(char *F_PATH, unsigned long *SAVE_ADDR, char *path_temp)
;    1589 {
__FF_checkdir:
;    1590 	unsigned char *sp, *qp;
;    1591     
;    1592     *SAVE_ADDR = _FF_DIR_ADDR;	// save local dir addr
	CALL __SAVELOCR4
;	*F_PATH -> Y+8
;	*SAVE_ADDR -> Y+6
;	*path_temp -> Y+4
;	*sp -> R16,R17
;	*qp -> R18,R19
	LDS  R30,__FF_DIR_ADDR
	LDS  R31,__FF_DIR_ADDR+1
	LDS  R22,__FF_DIR_ADDR+2
	LDS  R23,__FF_DIR_ADDR+3
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __PUTDP1
;    1593     
;    1594     qp = F_PATH;
	__GETWRS 18,19,8
;    1595     if (*qp=='\\')
	CALL SUBOPT_0x57
	BRNE _0x19E
;    1596     {
;    1597     	_FF_DIR_ADDR = _FF_ROOT_ADDR;
	LDS  R30,__FF_ROOT_ADDR
	LDS  R31,__FF_ROOT_ADDR+1
	LDS  R22,__FF_ROOT_ADDR+2
	LDS  R23,__FF_ROOT_ADDR+3
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    1598 		qp++;
	__ADDWRN 18,19,1
;    1599 	}
;    1600 
;    1601 	sp = path_temp;
_0x19E:
	__GETWRS 16,17,4
;    1602 	while(*qp)
_0x19F:
	CALL SUBOPT_0x58
	BREQ _0x1A1
;    1603 	{
;    1604 		if ((valid_file_char(*qp)==0) || (*qp=='.'))
	__GETW2R 18,19
	CALL SUBOPT_0x1B
	BREQ _0x1A3
	__GETW2R 18,19
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BRNE _0x1A2
_0x1A3:
;    1605 			*sp++ = toupper(*qp++);
	PUSH R17
	PUSH R16
	__ADDWRN 16,17,1
	__GETW2R 18,19
	__ADDWRN 18,19,1
	CALL SUBOPT_0x37
	POP  R26
	POP  R27
	ST   X,R30
;    1606 		else if (*qp=='\\')
	RJMP _0x1A5
_0x1A2:
	CALL SUBOPT_0x57
	BRNE _0x1A6
;    1607 		{
;    1608 			*sp = 0;	// terminate string
	CALL SUBOPT_0x59
;    1609 			if (_FF_chdir(path_temp))
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL __FF_chdir
	SBIW R30,0
	BREQ _0x1A7
;    1610 			{
;    1611 				return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3E2
;    1612 			}
;    1613 			sp = path_temp;
_0x1A7:
	__GETWRS 16,17,4
;    1614 			qp++;
	__ADDWRN 18,19,1
;    1615 		}
;    1616 		else
	RJMP _0x1A8
_0x1A6:
;    1617 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3E2
;    1618 	}
_0x1A8:
_0x1A5:
	RJMP _0x19F
_0x1A1:
;    1619 	
;    1620 	*sp = 0;		// terminate string
	CALL SUBOPT_0x59
;    1621 	return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x3E2:
	CALL __LOADLOCR4
	ADIW R28,10
	RET
;    1622 }
;    1623 
;    1624 #ifndef _READ_ONLY_
;    1625 int mkdir(char *F_PATH)
;    1626 {
;    1627 	unsigned char *sp, *qp;
;    1628 	unsigned char fpath[14];
;    1629 	unsigned int c, calc_temp, clus_temp, calc_time, calc_date;
;    1630 	int s;
;    1631 	unsigned long addr_temp, path_addr_temp;
;    1632     
;    1633     addr_temp = 0;	// save local dir addr
;	*F_PATH -> Y+38
;	*sp -> R16,R17
;	*qp -> R18,R19
;	fpath -> Y+24
;	c -> R20,R21
;	calc_temp -> Y+22
;	clus_temp -> Y+20
;	calc_time -> Y+18
;	calc_date -> Y+16
;	s -> Y+14
;	addr_temp -> Y+10
;	path_addr_temp -> Y+6
;    1634     
;    1635     if (_FF_checkdir(F_PATH, &addr_temp, fpath))
;    1636 	{
;    1637 		_FF_DIR_ADDR = addr_temp;
;    1638 		return (EOF);
;    1639 	}
;    1640     
;    1641 	path_addr_temp = _FF_DIR_ADDR;
;    1642 	s = scan_directory(&path_addr_temp, fpath);
;    1643 	if ((s) || (path_addr_temp==0))
;    1644 	{
;    1645 		_FF_DIR_ADDR = addr_temp;
;    1646 		return (EOF);
;    1647 	}
;    1648 	clus_temp = prev_cluster(0);				
;    1649 	calc_temp = path_addr_temp % BPB_BytsPerSec;
;    1650 	path_addr_temp -= calc_temp;
;    1651 	if (_FF_read(path_addr_temp)==0)	
;    1652 	{
;    1653 		_FF_DIR_ADDR = addr_temp;
;    1654 		return (EOF);
;    1655 	}
;    1656 	
;    1657 	sp = &_FF_buff[calc_temp];
;    1658 	qp = fpath;
;    1659 
;    1660 	for (c=0; c<11; c++)	// Write Folder name
;    1661 	{
;    1662 	 	if (*qp)
;    1663 		 	*sp++ = *qp++;
;    1664 		else 
;    1665 			*sp++ = 0x20;	// '0' pad
;    1666 	}
;    1667 	*sp++ = 0x10;				// Attribute bit auto set to "Directory"
;    1668 	*sp++ = 0;					// Reserved for WinNT
;    1669 	*sp++ = 0;					// Mili-second stamp for create
;    1670 	for (c=0; c<4; c++)			// set create and modify time to '0'
;    1671 		*sp++ = 0;
;    1672 	*sp++ = 0;					// File access date (2 bytes)
;    1673 	*sp++ = 0;
;    1674 	*sp++ = 0;					// 0 for FAT12/16 (2 bytes)
;    1675 	*sp++ = 0;
;    1676 	#ifdef _RTC_ON_
;    1677 		rtc_get_timeNdate(&rtc_hour, &rtc_min, &rtc_sec, &rtc_date, &rtc_month, (int *)&rtc_year);	    			
;    1678 		calc_time = ((int)rtc_sec&0x1F) | (((int)rtc_min&0x3F)<<5) | (((int)rtc_hour&0x1F)<<11);
;    1679 		*sp++ = calc_time&0x00FF;	// File modify Time 
;    1680 		*sp++ = (calc_time&0xFF00) >> 8;
;    1681 		calc_date = ((int)rtc_date&0x1F) | (((int)rtc_month&0x0F)<<5) | (((rtc_year-1980)&0x7F)<<9);
;    1682 		*sp++ = calc_date&0x00FF;	// File modify Date
;    1683 		*sp++ = (calc_date&0xFF00) >> 8;
;    1684 	#else
;    1685 		for (c=0; c<4; c++)			// set file create and modify time to '0'
;    1686 			*sp++ = 0;
;    1687 	#endif
;    1688 	
;    1689 	*sp++ = clus_temp & 0xFF;				// Starting cluster (2 bytes)
;    1690 	*sp++ = (clus_temp >> 8) & 0xFF;
;    1691 	for (c=0; c<4; c++)
;    1692 		*sp++ = 0;			// File length (0 for folder)
;    1693 
;    1694 	
;    1695 	if (_FF_write(path_addr_temp)==0)	// write entry to card
;    1696 	{
;    1697 		_FF_DIR_ADDR = addr_temp;
;    1698 		return (EOF);
;    1699 	}
;    1700 	if (write_clus_table(clus_temp, 0xFFFF, SINGLE)==0)
;    1701 	{
;    1702 		_FF_DIR_ADDR = addr_temp;
;    1703 		return (EOF);
;    1704 	}
;    1705 	if (_FF_read(_FF_DIR_ADDR)==0)	
;    1706 	{
;    1707 		_FF_DIR_ADDR = addr_temp;
;    1708 		return (EOF);
;    1709 	}
;    1710 	if (_FF_DIR_ADDR != _FF_ROOT_ADDR)
;    1711 	{
;    1712 		sp = &_FF_buff[0];
;    1713 		qp = &_FF_buff[0x20];
;    1714 		for (c=0; c<0x20; c++)
;    1715 			*qp++ = *sp++;
;    1716 		_FF_buff[1] = ' ';
;    1717 		for (c=0x3C; c<0x40; c++)
;    1718 			_FF_buff[c] = 0;
;    1719 	}
;    1720 	else
;    1721 	{
;    1722 		for (c=0x01; c<0x0B; c++)
;    1723 			_FF_buff[c] = 0x20;
;    1724 		for (c=0x0C; c<0x20; c++)
;    1725 			_FF_buff[c] = 0;
;    1726 		_FF_buff[0] = '.';
;    1727 		_FF_buff[0x0B] = 0x10;
;    1728 		#ifdef _RTC_ON_
;    1729 			_FF_buff[0x0E] = calc_time&0x00FF;	// File modify Time 
;    1730 			_FF_buff[0x0F] = (calc_time&0xFF00) >> 8;
;    1731 			_FF_buff[0x10] = calc_date&0x00FF;	// File modify Date
;    1732 			_FF_buff[0x11] = (calc_date&0xFF00) >> 8;
;    1733 			_FF_buff[0x16] = calc_time&0x00FF;	// File modify Time 
;    1734 			_FF_buff[0x17] = (calc_time&0xFF00) >> 8;
;    1735 			_FF_buff[0x18] = calc_date&0x00FF;	// File modify Date
;    1736 			_FF_buff[0x19] = (calc_date&0xFF00) >> 8;
;    1737 		#endif
;    1738 		for (c=0x3A; c<0x40; c++)
;    1739 			_FF_buff[c] = 0;
;    1740 	}
;    1741 	for (c=0x22; c<0x2B; c++)
;    1742 		_FF_buff[c] = 0x20;
;    1743 	#ifdef _RTC_ON_
;    1744 		_FF_buff[0x2E] = calc_time&0x00FF;	// File modify Time 
;    1745 		_FF_buff[0x2F] = (calc_time&0xFF00) >> 8;
;    1746 		_FF_buff[0x30] = calc_date&0x00FF;	// File modify Date
;    1747 		_FF_buff[0x31] = (calc_date&0xFF00) >> 8;
;    1748 		_FF_buff[0x36] = calc_time&0x00FF;	// File modify Time 
;    1749 		_FF_buff[0x37] = (calc_time&0xFF00) >> 8;
;    1750 		_FF_buff[0x38] = calc_date&0x00FF;	// File modify Date
;    1751 		_FF_buff[0x39] = (calc_date&0xFF00) >> 8;
;    1752 	#endif
;    1753 	_FF_buff[0x20] = '.';
;    1754 	_FF_buff[0x21] = '.';
;    1755 	_FF_buff[0x2B] = 0x10;
;    1756 
;    1757 	_FF_buff[0x1A] = clus_temp & 0xFF;				// Starting cluster (2 bytes)
;    1758 	_FF_buff[0x1B] = (clus_temp >> 8) & 0xFF;
;    1759 	for (c=0x40; c<BPB_BytsPerSec; c++)
;    1760 		_FF_buff[c] = 0;
;    1761 	path_addr_temp = clust_to_addr(clus_temp);
;    1762 
;    1763 	_FF_DIR_ADDR = addr_temp;	// reset dir addr
;    1764 	if (_FF_write(path_addr_temp)==0)	
;    1765 		return (EOF);
;    1766 	for (c=0; c<0x40; c++)
;    1767 		_FF_buff[c] = 0;
;    1768 	for (c=1; c<BPB_SecPerClus; c++)
;    1769 	{
;    1770 		if (_FF_write(path_addr_temp+((long)c*0x200))==0)	
;    1771 			return (EOF);
;    1772 	}
;    1773 	return (0);		
;    1774 }
;    1775 
;    1776 int rmdir(char *F_PATH)
;    1777 {
;    1778 	unsigned char *sp;
;    1779 	unsigned char fpath[14];
;    1780 	unsigned int c, n, calc_temp, clus_temp;
;    1781 	int s;
;    1782 	unsigned long addr_temp, path_addr_temp;
;    1783 	
;    1784 	addr_temp = 0;	// save local dir addr
;	*F_PATH -> Y+34
;	*sp -> R16,R17
;	fpath -> Y+20
;	c -> R18,R19
;	n -> R20,R21
;	calc_temp -> Y+18
;	clus_temp -> Y+16
;	s -> Y+14
;	addr_temp -> Y+10
;	path_addr_temp -> Y+6
;    1785     
;    1786     if (_FF_checkdir(F_PATH, &addr_temp, fpath))
;    1787 	{
;    1788 		_FF_DIR_ADDR = addr_temp;
;    1789 		return (EOF);
;    1790 	}
;    1791 	if (fpath[0]==0)
;    1792 	{
;    1793 		_FF_DIR_ADDR = addr_temp;
;    1794 		return (EOF);
;    1795 	}
;    1796 
;    1797     path_addr_temp = _FF_DIR_ADDR;	// save addr for later
;    1798 	
;    1799 	if (_FF_chdir(fpath))	// Change directory to dir to be deleted
;    1800 	{	
;    1801 		_FF_DIR_ADDR = addr_temp;
;    1802 		return (EOF);
;    1803 	}
;    1804 	if ((_FF_DIR_ADDR==_FF_ROOT_ADDR)||(_FF_DIR_ADDR==addr_temp))
;    1805 	{	// if trying to delete root, or current dir error
;    1806 		_FF_DIR_ADDR = addr_temp;
;    1807 		return (EOF);
;    1808 	}
;    1809 	
;    1810 	for (c=0; c<BPB_SecPerClus; c++)
;    1811 	{	// scan through dir to see if it is empty
;    1812 		if (_FF_read(_FF_DIR_ADDR+((long)c*0x200))==0)
;    1813 		{	// read sectors 	
;    1814 			_FF_DIR_ADDR = addr_temp;
;    1815 			return (EOF);
;    1816 		}
;    1817 		for (n=0; n<0x10; n++)
;    1818 		{
;    1819 			if ((c==0)&&(n==0))	// skip first 2 entries 
;    1820 				n=2;
;    1821 			sp = &_FF_buff[n*0x20];
;    1822 			if (*sp==0)
;    1823 			{	// 
;    1824 				c = BPB_SecPerClus;
;    1825 				break;
;    1826 			}
;    1827 			while (valid_file_char(*sp)==0)
;    1828 			{
;    1829 				sp++;
;    1830 				if (sp == &_FF_buff[(n*0x20)+0x0A])
;    1831 				{	// a valid file or folder found
;    1832 					_FF_DIR_ADDR = addr_temp;
;    1833 					return (EOF);
;    1834 				}
;    1835 			}
;    1836 		}
;    1837 	}
;    1838 	// directory empty, delete dir
;    1839 	_FF_DIR_ADDR = path_addr_temp;	// go back to previous directory 
;    1840 
;    1841 	s = scan_directory(&path_addr_temp, fpath);
;    1842 
;    1843 	_FF_DIR_ADDR = addr_temp;	// reset address
;    1844 
;    1845 	if (s == 0)
;    1846 		return (EOF);
;    1847 	
;    1848 	calc_temp = path_addr_temp % BPB_BytsPerSec;
;    1849 	path_addr_temp -= calc_temp;
;    1850 
;    1851 	if (_FF_read(path_addr_temp)==0)	
;    1852 		return (EOF);
;    1853     
;    1854 	clus_temp = ((int) _FF_buff[calc_temp+0x1B] << 8) | _FF_buff[calc_temp+0x1A];
;    1855 	_FF_buff[calc_temp] = 0xE5;
;    1856 	
;    1857 	if (_FF_buff[calc_temp+0x0B]&0x02)
;    1858 		return (EOF);
;    1859 	if (_FF_write(path_addr_temp)==0) 
;    1860 		return (EOF);
;    1861 	if (erase_clus_chain(clus_temp)==0)
;    1862 		return (EOF);
;    1863 	
;    1864     return (0);
;    1865 }
;    1866 #endif
;    1867 
;    1868 int chdirc(char flash *F_PATH)
;    1869 {
;    1870 	unsigned char fpath[_FF_PATH_LENGTH];
;    1871 	int c;
;    1872 	
;    1873 	for (c=0; c<_FF_PATH_LENGTH; c++)
;	*F_PATH -> Y+102
;	fpath -> Y+2
;	c -> R16,R17
;    1874 	{
;    1875 		fpath[c] = F_PATH[c];
;    1876 		if (F_PATH[c]==0)
;    1877 			break;
;    1878 	}
;    1879 	return (chdir(fpath));
;    1880 }
;    1881 
;    1882 int chdir(char *F_PATH)
;    1883 {
;    1884 	unsigned char *qp, *sp, fpath[14], valid_flag;
;    1885 	unsigned int m, n, c, d, calc;
;    1886 	unsigned long addr_temp;
;    1887 
;    1888     
;    1889     addr_temp = 0;	// save local dir addr
;	*F_PATH -> Y+33
;	*qp -> R16,R17
;	*sp -> R18,R19
;	fpath -> Y+19
;	valid_flag -> R20
;	m -> Y+17
;	n -> Y+15
;	c -> Y+13
;	d -> Y+11
;	calc -> Y+9
;	addr_temp -> Y+5
;    1890     
;    1891 	if ((F_PATH[0]=='\\') && (F_PATH[1]==0))
;    1892 	{
;    1893 		_FF_DIR_ADDR = _FF_ROOT_ADDR;
;    1894 		_FF_FULL_PATH[1] = 0;
;    1895 		return (0);
;    1896 	}
;    1897 	
;    1898     if (_FF_checkdir(F_PATH, &addr_temp, fpath))
;    1899 	{
;    1900 		_FF_DIR_ADDR = addr_temp;
;    1901 		return (EOF);
;    1902 	}
;    1903 	if (fpath[0]==0)
;    1904 		return (EOF);
;    1905 
;    1906 	if ((fpath[0]=='.') && (fpath[1]=='.') && (fpath[2]==0))
;    1907 	{	// trying to get back to prev dir
;    1908 		if (_FF_DIR_ADDR == _FF_ROOT_ADDR)		// already as far back as can go
;    1909 			return (EOF);
;    1910 		if (_FF_read(_FF_DIR_ADDR)==0)
;    1911 			return (EOF);
;    1912 		m = ((unsigned int) _FF_buff[0x3B] << 8) | (unsigned int) _FF_buff[0x3A];
;    1913 		if (m)
;    1914 			_FF_DIR_ADDR = clust_to_addr(m);
;    1915 		else
;    1916 			_FF_DIR_ADDR = _FF_ROOT_ADDR;
;    1917 		
;    1918 					sp = F_PATH;
;    1919 					qp = _FF_FULL_PATH + strlen(_FF_FULL_PATH);
;    1920 					while (*sp)
;    1921 					{
;    1922 						if ((*sp=='.')&&(*(sp+1)=='.'))
;    1923 						{
;    1924 							#ifdef _ICCAVR_
;    1925 								qp = strrchr(_FF_FULL_PATH, '\\');
;    1926 								if (qp==0)
;    1927 								   return (EOF);
;    1928 								*qp = 0;
;    1929 								qp = strrchr(_FF_FULL_PATH, '\\');
;    1930 								if (qp==0)
;    1931 								   return (EOF);
;    1932 								qp++;
;    1933 							#endif
;    1934 							#ifdef _CVAVR_
;    1935 								_FF_FULL_PATH[strrpos(_FF_FULL_PATH, '\\')] = 0;
;    1936 							    c = strrpos(_FF_FULL_PATH, '\\');
;    1937 								if (c==EOF)
;    1938 									return (EOF);
;    1939 								qp = _FF_FULL_PATH + c;
;    1940 							#endif
;    1941 							*qp = 0;
;    1942 							sp += 2;
;    1943 						}
;    1944 						else 
;    1945 							*qp++ = toupper(*sp++);
;    1946 					}
;    1947 					*qp++ = '\\';
;    1948 					*qp = 0;
;    1949 
;    1950 		return (0);
;    1951 	}
;    1952 		
;    1953 	qp = fpath;
;    1954 	sp = fpath;
;    1955 	while(sp < (fpath+11))
;    1956 	{
;    1957 		if (*qp)
;    1958 			*sp++ = toupper(*qp++);
;    1959 		else	// (*qp==0)
;    1960 			*sp++ = 0x20;
;    1961 	}     
;    1962 	*sp = 0;
;    1963 
;    1964 	qp = fpath;
;    1965 	m = 0;
;    1966 	d = 0;
;    1967 	valid_flag = 0;
;    1968 	while (d<BPB_RootEntCnt)
;    1969 	{
;    1970     	_FF_read(_FF_DIR_ADDR+(m*0x200));
;    1971 		for (n=0; n<16; n++)
;    1972 		{
;    1973 			if (_FF_buff[n*0x20] == 0)	// no more entries in dir
;    1974 			{
;    1975 				_FF_DIR_ADDR = addr_temp;
;    1976 				return (EOF);
;    1977 			}
;    1978 			calc = (n*0x20);
;    1979 			for (c=0; c<11; c++)
;    1980 			{	// check for name match
;    1981 				if (fpath[c] == _FF_buff[calc+c])
;    1982 					valid_flag = 1;
;    1983 				else if (fpath[c] == 0)
;    1984 				{
;    1985 					if (_FF_buff[calc+c]==0x20)
;    1986 						break;
;    1987 				}
;    1988 				else
;    1989 				{
;    1990 					valid_flag = 0;	
;    1991 					break;
;    1992 				}
;    1993 		    }   
;    1994 		    if (valid_flag)
;    1995 	  		{
;    1996 	  			if (_FF_buff[calc+0xB] != 0x10)	// not a directory
;    1997 	  				valid_flag = 0;
;    1998 	  			else
;    1999 	  			{
;    2000 	  				c = ((int) _FF_buff[calc+0x1B] << 8) | ((int) _FF_buff[calc+0x1A]);
;    2001 					_FF_DIR_ADDR = clust_to_addr(c);
;    2002 					sp = F_PATH;
;    2003 					if (*sp=='\\')
;    2004 					{	// Restart String @root
;    2005 						qp = _FF_FULL_PATH + 1;
;    2006 						*qp = 0;
;    2007 						sp++;
;    2008 					}
;    2009 					else
;    2010 						qp = _FF_FULL_PATH + strlen(_FF_FULL_PATH);
;    2011 					while (*sp)
;    2012 					{
;    2013 						if ((*sp=='.')&&(*(sp+1)=='.'))
;    2014 						{
;    2015 							#ifdef _ICCAVR_
;    2016 								qp = strrchr(_FF_FULL_PATH, '\\');
;    2017 								if (qp==0)
;    2018 								   return (EOF);
;    2019 								*qp = 0;
;    2020 								qp = strrchr(_FF_FULL_PATH, '\\');
;    2021 								if (qp==0)
;    2022 								   return (EOF);
;    2023 								qp++;
;    2024 							#endif
;    2025 							#ifdef _CVAVR_
;    2026 								_FF_FULL_PATH[strrpos(_FF_FULL_PATH, '\\')] = 0;
;    2027 								c = strrpos(_FF_FULL_PATH, '\\');
;    2028 								if (c==EOF)
;    2029 								   return (EOF);
;    2030 								qp = _FF_FULL_PATH + c;
;    2031 							#endif
;    2032 							*qp = 0;
;    2033 							sp += 2;
;    2034 						}
;    2035 						else 
;    2036 							*qp++ = toupper(*sp++);
;    2037 					}
;    2038 					*qp++ = '\\';
;    2039 					*qp = 0;
;    2040 					return (0);
;    2041 				}
;    2042 			}
;    2043 		  	d++;		  		
;    2044 		}
;    2045 		m++;
;    2046 	}
;    2047 	_FF_DIR_ADDR = addr_temp;
;    2048 	return (EOF);
;    2049 }
;    2050 
;    2051 // Function to change directories one at a time, not effecting the working dir string
;    2052 int _FF_chdir(char *F_PATH)
;    2053 {
__FF_chdir:
;    2054 	unsigned char *qp, *sp, valid_flag, fpath[14];
;    2055 	unsigned int m, n, c, d, calc;
;    2056     
;    2057 	if ((F_PATH[0]=='.') && (F_PATH[1]=='.') && (F_PATH[2]==0))
	SBIW R28,24
	CALL __SAVELOCR5
;	*F_PATH -> Y+29
;	*qp -> R16,R17
;	*sp -> R18,R19
;	valid_flag -> R20
;	fpath -> Y+15
;	m -> Y+13
;	n -> Y+11
;	c -> Y+9
;	d -> Y+7
;	calc -> Y+5
	LDD  R26,Y+29
	LDD  R27,Y+29+1
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BRNE _0x232
	LDD  R26,Y+29
	LDD  R27,Y+29+1
	ADIW R26,1
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BRNE _0x232
	LDD  R26,Y+29
	LDD  R27,Y+29+1
	ADIW R26,2
	LD   R26,X
	CPI  R26,LOW(0x0)
	BREQ _0x233
_0x232:
	RJMP _0x231
_0x233:
;    2058 	{	// trying to get back to prev dir
;    2059 		if (_FF_DIR_ADDR == _FF_ROOT_ADDR)		// already as far back as can go
	LDS  R30,__FF_ROOT_ADDR
	LDS  R31,__FF_ROOT_ADDR+1
	LDS  R22,__FF_ROOT_ADDR+2
	LDS  R23,__FF_ROOT_ADDR+3
	LDS  R26,__FF_DIR_ADDR
	LDS  R27,__FF_DIR_ADDR+1
	LDS  R24,__FF_DIR_ADDR+2
	LDS  R25,__FF_DIR_ADDR+3
	CALL __CPD12
	BRNE _0x234
;    2060 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3E1
;    2061 		if (_FF_read(_FF_DIR_ADDR)==0)
_0x234:
	LDS  R30,__FF_DIR_ADDR
	LDS  R31,__FF_DIR_ADDR+1
	LDS  R22,__FF_DIR_ADDR+2
	LDS  R23,__FF_DIR_ADDR+3
	CALL SUBOPT_0xC
	BRNE _0x235
;    2062 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3E1
;    2063 		m = ((unsigned int) _FF_buff[0x3B] << 8) | (unsigned int) _FF_buff[0x3A];
_0x235:
	__GETBRMN __FF_buff,59,27
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,58
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STD  Y+13,R30
	STD  Y+13+1,R31
;    2064 		if (m)
	SBIW R30,0
	BREQ _0x236
;    2065 			_FF_DIR_ADDR = clust_to_addr(m);
	ST   -Y,R31
	ST   -Y,R30
	CALL _clust_to_addr
	RJMP _0x3F5
;    2066 		else
_0x236:
;    2067 			_FF_DIR_ADDR = _FF_ROOT_ADDR;
	LDS  R30,__FF_ROOT_ADDR
	LDS  R31,__FF_ROOT_ADDR+1
	LDS  R22,__FF_ROOT_ADDR+2
	LDS  R23,__FF_ROOT_ADDR+3
_0x3F5:
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    2068 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x3E1
;    2069 	}
;    2070 		
;    2071 	qp = F_PATH;
_0x231:
	__GETWRS 16,17,29
;    2072 	sp = fpath;
	MOVW R30,R28
	ADIW R30,15
	__PUTW1R 18,19
;    2073 	while(sp < (fpath+11))
_0x238:
	MOVW R30,R28
	ADIW R30,26
	CP   R18,R30
	CPC  R19,R31
	BRSH _0x23A
;    2074 	{
;    2075 		if (valid_file_char(*qp)==0)
	__GETW2R 16,17
	CALL SUBOPT_0x1B
	BRNE _0x23B
;    2076 			*sp++ = toupper(*qp++);
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	__GETW2R 16,17
	__ADDWRN 16,17,1
	CALL SUBOPT_0x37
	POP  R26
	POP  R27
	ST   X,R30
;    2077 		else if (*qp==0)
	RJMP _0x23C
_0x23B:
	__GETW2R 16,17
	LD   R30,X
	CPI  R30,0
	BRNE _0x23D
;    2078 			*sp++ = 0x20;
	__GETW2R 18,19
	__ADDWRN 18,19,1
	LDI  R30,LOW(32)
	ST   X,R30
;    2079 		else
	RJMP _0x23E
_0x23D:
;    2080 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3E1
;    2081 	}     
_0x23E:
_0x23C:
	RJMP _0x238
_0x23A:
;    2082 	*sp = 0;
	__GETW2R 18,19
	LDI  R30,LOW(0)
	ST   X,R30
;    2083 	m = 0;
	LDI  R30,0
	STD  Y+13,R30
	STD  Y+13+1,R30
;    2084 	d = 0;
	LDI  R30,0
	STD  Y+7,R30
	STD  Y+7+1,R30
;    2085 	valid_flag = 0;
	LDI  R20,LOW(0)
;    2086 	while (d<BPB_RootEntCnt)
_0x23F:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CP   R26,R12
	CPC  R27,R13
	BRLO PC+3
	JMP _0x241
;    2087 	{
;    2088     	_FF_read(_FF_DIR_ADDR+(m*0x200));
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	CALL SUBOPT_0x5A
	CALL __FF_read
;    2089 		for (n=0; n<16; n++)
	LDI  R30,0
	STD  Y+11,R30
	STD  Y+11+1,R30
_0x243:
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	CPI  R26,LOW(0x10)
	LDI  R30,HIGH(0x10)
	CPC  R27,R30
	BRLO PC+3
	JMP _0x244
;    2090 		{
;    2091 			calc = (n*0x20);
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	LSL  R30
	ROL  R31
	CALL __LSLW4
	STD  Y+5,R30
	STD  Y+5+1,R31
;    2092 			if (_FF_buff[calc] == 0)	// no more entries in dir
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	LD   R30,Z
	CPI  R30,0
	BRNE _0x245
;    2093 				return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3E1
;    2094 			for (c=0; c<11; c++)
_0x245:
	LDI  R30,0
	STD  Y+9,R30
	STD  Y+9+1,R30
_0x247:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	CPI  R26,LOW(0xB)
	LDI  R30,HIGH(0xB)
	CPC  R27,R30
	BRSH _0x248
;    2095 			{	// check for name match
;    2096 				if (fpath[c] == _FF_buff[calc+c])
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	MOVW R26,R28
	ADIW R26,15
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	PUSH R30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	ADD  R30,R26
	ADC  R31,R27
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	LD   R30,Z
	POP  R26
	CP   R30,R26
	BRNE _0x249
;    2097 					valid_flag = 1;
	LDI  R20,LOW(1)
;    2098 				else
	RJMP _0x24A
_0x249:
;    2099 				{
;    2100 					valid_flag = 0;	
	LDI  R20,LOW(0)
;    2101 					c = 11;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	STD  Y+9,R30
	STD  Y+9+1,R31
;    2102 				}
_0x24A:
;    2103 		    }   
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ADIW R30,1
	STD  Y+9,R30
	STD  Y+9+1,R31
	RJMP _0x247
_0x248:
;    2104 		    if (valid_flag)
	CPI  R20,0
	BREQ _0x24B
;    2105 	  		{
;    2106 	  			if (_FF_buff[calc+0xB] != 0x10)	// not a directory
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	CALL SUBOPT_0x5B
	CPI  R30,LOW(0x10)
	BREQ _0x24C
;    2107 	  				valid_flag = 0;
	LDI  R20,LOW(0)
;    2108 	  			else
	RJMP _0x24D
_0x24C:
;    2109 	  			{
;    2110 	  				c = ((int) _FF_buff[calc+0x1B] << 8) | ((int) _FF_buff[calc+0x1A]);
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	ADIW R30,27
	CALL SUBOPT_0x39
	MOVW R26,R30
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	CALL SUBOPT_0x5C
	STD  Y+9,R30
	STD  Y+9+1,R31
;    2111 					_FF_DIR_ADDR = clust_to_addr(c);
	ST   -Y,R31
	ST   -Y,R30
	CALL _clust_to_addr
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    2112 					return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x3E1
;    2113 				}
_0x24D:
;    2114 			}
;    2115 		  	d++;		  		
_0x24B:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
;    2116 		}
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ADIW R30,1
	STD  Y+11,R30
	STD  Y+11+1,R31
	RJMP _0x243
_0x244:
;    2117 		m++;
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ADIW R30,1
	STD  Y+13,R30
	STD  Y+13+1,R31
;    2118 	}
	RJMP _0x23F
_0x241:
;    2119 	return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x3E1:
	CALL __LOADLOCR5
	ADIW R28,31
	RET
;    2120 }
;    2121 
;    2122 #ifndef _SECOND_FAT_ON_
;    2123 // Function that clears the secondary FAT table
;    2124 int clear_second_FAT(void)
;    2125 {
;    2126 	unsigned int c, d;
;    2127 	unsigned long n;
;    2128 	
;    2129 	for (n=1; n<BPB_FATSz16; n++)
;    2130 	{
;    2131 		if (_FF_read(_FF_FAT2_ADDR+(n*0x200))==0)
;    2132 			return (EOF);
;    2133 		for (c=0; c<BPB_BytsPerSec; c++)
;    2134 		{
;    2135 			if (_FF_buff[c] != 0)
;    2136 			{
;    2137 				for (d=0; d<BPB_BytsPerSec; d++)
;    2138 					_FF_buff[d] = 0;
;    2139 				if (_FF_write(_FF_FAT2_ADDR+(n*0x200))==0)
;    2140 					return (EOF);
;    2141 				break;
;    2142 			}
;    2143 		}
;    2144 	}
;    2145 	for (d=2; d<BPB_BytsPerSec; d++)
;    2146 		_FF_buff[d] = 0;
;    2147 	_FF_buff[0] = 0xF8;
;    2148 	_FF_buff[1] = 0xFF;
;    2149 	_FF_buff[2] = 0xFF;
;    2150 	if (BPB_FATType == 0x36)
;    2151 		_FF_buff[3] = 0xFF;
;    2152 	if (_FF_write(_FF_FAT2_ADDR)==0)
;    2153 		return (EOF);
;    2154 	
;    2155 	return (1);
;    2156 }
;    2157 #endif
;    2158  
;    2159 // Open a file, name stored in string fileopen
;    2160 FILE *fopenc(unsigned char flash *NAMEC, unsigned char MODEC)
;    2161 {
;    2162 	unsigned char c, temp_data[12];
;    2163 	FILE *tp;
;    2164 	
;    2165 	for (c=0; c<12; c++)
;	*NAMEC -> Y+16
;	MODEC -> Y+15
;	c -> R16
;	temp_data -> Y+3
;	*tp -> R17,R18
;    2166 		temp_data[c] = NAMEC[c];
;    2167 	
;    2168 	tp = fopen(temp_data, MODEC);
;    2169 	return(tp);
;    2170 }
;    2171 
;    2172 FILE *fopen(unsigned char *NAME, unsigned char MODE)
;    2173 {
_fopen:
;    2174 	unsigned char fpath[14];
;    2175 	unsigned int c, s, calc_temp;
;    2176 	unsigned char *sp, *qp;
;    2177 	unsigned long addr_temp, path_addr_temp;
;    2178 	FILE *rp;
;    2179 	
;    2180 	#ifdef _READ_ONLY_
;    2181 		if (MODE!=READ)
;    2182 			return (0);
;    2183 	#endif
;    2184 	
;    2185     addr_temp = 0;	// save local dir addr
	CALL SUBOPT_0x5D
;	*NAME -> Y+35
;	MODE -> Y+34
;	fpath -> Y+20
;	c -> R16,R17
;	s -> R18,R19
;	calc_temp -> R20,R21
;	*sp -> Y+18
;	*qp -> Y+16
;	addr_temp -> Y+12
;	path_addr_temp -> Y+8
;	*rp -> Y+6
;    2186     
;    2187     if (_FF_checkdir(NAME, &addr_temp, fpath))
	BREQ _0x251
;    2188 	{
;    2189 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x5E
;    2190 		return (0);
	RJMP _0x3E0
;    2191 	}
;    2192 	if (fpath[0]==0)
_0x251:
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x252
;    2193 	{
;    2194 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x5E
;    2195 		return (0);
	RJMP _0x3E0
;    2196 	}
;    2197     
;    2198 	path_addr_temp = _FF_DIR_ADDR;
_0x252:
	CALL SUBOPT_0x5F
;    2199 	s = scan_directory(&path_addr_temp, fpath);
;    2200 	if ((path_addr_temp==0) || (s==0))
	__GETD2S 8
	CALL __CPD02
	BREQ _0x254
	CLR  R0
	CP   R0,R18
	CPC  R0,R19
	BRNE _0x253
_0x254:
;    2201 	{
;    2202 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x5E
;    2203 		return (0);
	RJMP _0x3E0
;    2204 	}
;    2205 
;    2206 	rp = 0;
_0x253:
	LDI  R30,0
	STD  Y+6,R30
	STD  Y+6+1,R30
;    2207 	rp = malloc(sizeof(FILE));
	LDI  R30,LOW(553)
	LDI  R31,HIGH(553)
	ST   -Y,R31
	ST   -Y,R30
	CALL _malloc
	CALL SUBOPT_0x60
;    2208 	if (rp == 0)
	BRNE _0x256
;    2209 	{	// Could not allocate requested memory
;    2210 		_FF_error = ALLOC_ERR;
	LDI  R30,LOW(9)
	STS  __FF_error,R30
;    2211 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x5E
;    2212 		return (0);
	RJMP _0x3E0
;    2213 	}
;    2214 	rp->length = 0x46344456;
_0x256:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	__GETD1N 0x46344456
	CALL __PUTDP1
;    2215 	rp->clus_start = 0xe4;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,12
	LDI  R30,LOW(228)
	LDI  R31,HIGH(228)
	ST   X+,R30
	ST   X,R31
;    2216 	rp->position = 0x45664446;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-544)
	SBCI R27,HIGH(-544)
	__GETD1N 0x45664446
	CALL __PUTDP1
;    2217 
;    2218 	calc_temp = path_addr_temp % BPB_BytsPerSec;
	CALL SUBOPT_0x61
;    2219 	path_addr_temp -= calc_temp;
	CALL SUBOPT_0x62
;    2220 	if (_FF_read(path_addr_temp)==0)	
	BRNE _0x257
;    2221 	{
;    2222 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x5E
;    2223 		return (0);
	RJMP _0x3E0
;    2224 	}
;    2225 	
;    2226 	// Get the filename into a form we can use to compare
;    2227 	qp = file_name_conversion(fpath);
_0x257:
	CALL SUBOPT_0x63
;    2228 	if (qp==0)
	BRNE _0x258
;    2229 	{	// If File name entered is NOT valid, return 0
;    2230 		free(rp);
	CALL SUBOPT_0x64
;    2231 		_FF_DIR_ADDR = addr_temp;
;    2232 		return (0);
	RJMP _0x3E0
;    2233 	}
;    2234 	
;    2235 	sp = &_FF_buff[calc_temp];
_0x258:
	CALL SUBOPT_0x65
;    2236 
;    2237 	if (s)
	BRNE PC+3
	JMP _0x259
;    2238 	{	// File exists, open 
;    2239 		if (((MODE==WRITE) || (MODE==APPEND)) && (_FF_buff[calc_temp+0x0B]&0x01))
	LDD  R26,Y+34
	CPI  R26,LOW(0x2)
	BREQ _0x25B
	CPI  R26,LOW(0x3)
	BRNE _0x25D
_0x25B:
	__GETW1R 20,21
	CALL SUBOPT_0x5B
	ANDI R30,LOW(0x1)
	BRNE _0x25E
_0x25D:
	RJMP _0x25A
_0x25E:
;    2240 		{	// if writing to file verify it is not "READ ONLY"
;    2241 			_FF_error = MODE_ERR;
	CALL SUBOPT_0x66
;    2242 			free(rp);
;    2243 			_FF_DIR_ADDR = addr_temp;
;    2244 			return (0);
	RJMP _0x3E0
;    2245 		}
;    2246 		for (c=0; c<12; c++)	// Save Filename to Buffer
_0x25A:
	__GETWRN 16,17,0
_0x260:
	__CPWRN 16,17,12
	BRSH _0x261
;    2247 			rp->name[c] = FILENAME[c];
	__GETW1R 16,17
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R26,LOW(_FILENAME)
	LDI  R27,HIGH(_FILENAME)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	POP  R26
	POP  R27
	ST   X,R30
;    2248 		// Save Starting Cluster
;    2249 		rp->clus_start = ((int) _FF_buff[calc_temp+0x1B] << 8) | (int) _FF_buff[calc_temp+0x1A];
	__ADDWRN 16,17,1
	RJMP _0x260
_0x261:
	__GETW1R 20,21
	ADIW R30,27
	CALL SUBOPT_0x39
	MOVW R26,R30
	__GETW1R 20,21
	CALL SUBOPT_0x5C
	__PUTW1SNS 6,12
;    2250 		// Set Current Cluster
;    2251 		rp->clus_current = rp->clus_start;
	CALL SUBOPT_0x67
	__PUTW1SNS 6,14
;    2252 		// Set Previous Cluster to 0 (indicating @start)
;    2253 		rp->clus_prev = 0;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x68
;    2254 		// Save file length
;    2255 		rp->length = 0;
	CALL SUBOPT_0x69
;    2256 		sp = _FF_buff + calc_temp + 0x1F;
	CALL SUBOPT_0x6A
;    2257 		for (c=0; c<4; c++)
	__GETWRN 16,17,0
_0x263:
	__CPWRN 16,17,4
	BRSH _0x264
;    2258 		{
;    2259 			rp->length <<= 8;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SUBI R30,LOW(-540)
	SBCI R31,HIGH(-540)
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(8)
	CALL __LSLD12
	POP  R26
	POP  R27
	CALL __PUTDP1
;    2260 			rp->length |= *sp--;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SUBI R30,LOW(-540)
	SBCI R31,HIGH(-540)
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6B
	LD   R30,X
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __ORD12
	POP  R26
	POP  R27
	CALL __PUTDP1
;    2261 		}
	__ADDWRN 16,17,1
	RJMP _0x263
_0x264:
;    2262 		// Set Current Position to 0
;    2263 		rp->position = 0;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-544)
	SBCI R27,HIGH(-544)
	__GETD1N 0x0
	CALL __PUTDP1
;    2264 		#ifndef _READ_ONLY_
;    2265 			if (MODE==WRITE)
	LDD  R26,Y+34
	CPI  R26,LOW(0x2)
	BRNE _0x265
;    2266 			{	// Change file to blank
;    2267 				sp = _FF_buff + calc_temp + 0x1F;
	CALL SUBOPT_0x6A
;    2268 				for (c=0; c<6; c++)
	__GETWRN 16,17,0
_0x267:
	__CPWRN 16,17,6
	BRSH _0x268
;    2269 					*sp-- = 0;
	CALL SUBOPT_0x6B
	LDI  R30,LOW(0)
	ST   X,R30
;    2270 				if (rp->length)
	__ADDWRN 16,17,1
	RJMP _0x267
_0x268:
	CALL SUBOPT_0x6C
	BREQ _0x269
;    2271 				{
;    2272 					if (_FF_write(_FF_DIR_ADDR + (0x200 * s))==0)
	__GETW1R 18,19
	CALL SUBOPT_0x5A
	CALL __FF_write
	CPI  R30,0
	BRNE _0x26A
;    2273 					{
;    2274 						free(rp);
	CALL SUBOPT_0x64
;    2275 						_FF_DIR_ADDR = addr_temp;
;    2276 						return (0);
	RJMP _0x3E0
;    2277 					}
;    2278 					rp->length = 0;
_0x26A:
	CALL SUBOPT_0x69
;    2279 					erase_clus_chain(rp->clus_start);
	CALL SUBOPT_0x6D
	CALL _erase_clus_chain
;    2280 					rp->clus_start = 0;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,12
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
;    2281 				}
;    2282 			}
_0x269:
;    2283 		#endif
;    2284 		// Set and save next cluster #
;    2285 		rp->clus_next = next_cluster(rp->clus_current, SINGLE);
_0x265:
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x26
	__PUTW1SNS 6,16
;    2286 		if ((rp->length==0) && (rp->clus_start==0))
	CALL SUBOPT_0x6C
	BRNE _0x26C
	CALL SUBOPT_0x67
	SBIW R30,0
	BREQ _0x26D
_0x26C:
	RJMP _0x26B
_0x26D:
;    2287 		{	// Check for Blank File 
;    2288 			if (MODE==READ)
	LDD  R26,Y+34
	CPI  R26,LOW(0x1)
	BRNE _0x26E
;    2289 			{	// IF trying to open a blank file to read, ERROR
;    2290 				_FF_error = MODE_ERR;
	CALL SUBOPT_0x66
;    2291 				free(rp);
;    2292 				_FF_DIR_ADDR = addr_temp;
;    2293 				return (0);
	RJMP _0x3E0
;    2294 			}
;    2295 			//Setup blank FILE characteristics
;    2296 			#ifndef _READ_ONLY_
;    2297 				MODE = WRITE; 
_0x26E:
	LDI  R30,LOW(2)
	STD  Y+34,R30
;    2298 			#endif
;    2299 		}
;    2300 		// Save the file offset to read entry
;    2301 		rp->entry_sec_addr = path_addr_temp;
_0x26B:
	__GETD1S 8
	__PUTD1SNS 6,22
;    2302 		rp->entry_offset =  calc_temp;
	__GETW1R 20,21
	__PUTW1SNS 6,26
;    2303 		// Set sector offset to 1
;    2304 		rp->sec_offset = 1;
	CALL SUBOPT_0x6F
;    2305 		if (MODE==APPEND)
	LDD  R26,Y+34
	CPI  R26,LOW(0x3)
	BRNE _0x26F
;    2306 		{
;    2307 			if (fseek(rp, 0,SEEK_END)==EOF)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL SUBOPT_0x70
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _fseek
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x270
;    2308 			{
;    2309 				free(rp);
	CALL SUBOPT_0x64
;    2310 				_FF_DIR_ADDR = addr_temp;
;    2311 				return (0);
	RJMP _0x3E0
;    2312 			}
;    2313 		}
_0x270:
;    2314 		else
	RJMP _0x271
_0x26F:
;    2315 		{	// Set pointer to the begining of the file
;    2316 			_FF_read(clust_to_addr(rp->clus_current));
	CALL SUBOPT_0x6E
	CALL _clust_to_addr
	CALL __PUTPARD1
	CALL __FF_read
;    2317 			for (c=0; c<BPB_BytsPerSec; c++)
	__GETWRN 16,17,0
_0x273:
	__CPWRR 16,17,6,7
	BRSH _0x274
;    2318 				rp->buff[c] = _FF_buff[c];
	CALL SUBOPT_0x71
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x72
	POP  R26
	POP  R27
	ST   X,R30
;    2319 			rp->pntr = &rp->buff[0];
	__ADDWRN 16,17,1
	RJMP _0x273
_0x274:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,28
	__PUTW1SN 6,551
;    2320 		}
_0x271:
;    2321 		#ifndef _READ_ONLY_
;    2322 			#ifndef _SECOND_FAT_ON_
;    2323 				if ((MODE==WRITE) || (MODE==APPEND))
;    2324 					clear_second_FAT();
;    2325 			#endif
;    2326     	#endif
;    2327 		rp->mode = MODE;
	LDD  R30,Y+34
	__PUTB1SN 6,548
;    2328 		_FF_error = NO_ERR;
	LDI  R30,LOW(0)
	STS  __FF_error,R30
;    2329 		_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    2330 		return(rp);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RJMP _0x3E0
;    2331 	}
;    2332 	else
_0x259:
;    2333 	{                          		
;    2334 		_FF_error = FILE_ERR;
	LDI  R30,LOW(2)
	STS  __FF_error,R30
;    2335 		free(rp);
	CALL SUBOPT_0x64
;    2336 		_FF_DIR_ADDR = addr_temp;
;    2337 		return(0);
	RJMP _0x3E0
;    2338 	}
;    2339 }
	RJMP _0x3E0
;    2340 
;    2341 #ifndef _READ_ONLY_
;    2342 // Create a file
;    2343 FILE *fcreatec(unsigned char flash *NAMEC, unsigned char MODE)
;    2344 {
_fcreatec:
;    2345 	unsigned char sd_temp[12];
;    2346 	int c;
;    2347 
;    2348 	for (c=0; c<12; c++)
	SBIW R28,12
	ST   -Y,R17
	ST   -Y,R16
;	*NAMEC -> Y+15
;	MODE -> Y+14
;	sd_temp -> Y+2
;	c -> R16,R17
	__GETWRN 16,17,0
_0x277:
	__CPWRN 16,17,12
	BRGE _0x278
;    2349 		sd_temp[c] = NAMEC[c];
	__GETW1R 16,17
	MOVW R26,R28
	ADIW R26,2
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	__GETW1R 16,17
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	POP  R26
	POP  R27
	ST   X,R30
;    2350 	
;    2351 	return (fcreate(sd_temp, MODE));
	__ADDWRN 16,17,1
	RJMP _0x277
_0x278:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+16
	ST   -Y,R30
	RCALL _fcreate
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,17
	RET
;    2352 }
;    2353 
;    2354 FILE *fcreate(unsigned char *NAME, unsigned char MODE)
;    2355 {
_fcreate:
;    2356 	unsigned char fpath[14];
;    2357 	unsigned int c, s, calc_temp;
;    2358 	unsigned char *sp, *qp;
;    2359 	unsigned long addr_temp, path_addr_temp;
;    2360 	FILE *temp_file_pntr;
;    2361 
;    2362     addr_temp = 0;	// save local dir addr
	CALL SUBOPT_0x5D
;	*NAME -> Y+35
;	MODE -> Y+34
;	fpath -> Y+20
;	c -> R16,R17
;	s -> R18,R19
;	calc_temp -> R20,R21
;	*sp -> Y+18
;	*qp -> Y+16
;	addr_temp -> Y+12
;	path_addr_temp -> Y+8
;	*temp_file_pntr -> Y+6
;    2363     
;    2364     if (_FF_checkdir(NAME, &addr_temp, fpath))
	BREQ _0x279
;    2365 	{
;    2366 		_FF_error = PATH_ERR;
	LDI  R30,LOW(14)
	STS  __FF_error,R30
;    2367 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x5E
;    2368 		return (0);
	RJMP _0x3E0
;    2369 	}
;    2370 	if (fpath[0]==0)
_0x279:
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x27A
;    2371 	{
;    2372 		_FF_error = NAME_ERR; 
	CALL SUBOPT_0x73
;    2373 		_FF_DIR_ADDR = addr_temp;
;    2374 		return (0);
	RJMP _0x3E0
;    2375 	}
;    2376     
;    2377 	path_addr_temp = _FF_DIR_ADDR;
_0x27A:
	CALL SUBOPT_0x5F
;    2378 	s = scan_directory(&path_addr_temp, fpath);
;    2379 	if (path_addr_temp==0)
	__GETD1S 8
	CALL __CPD10
	BRNE _0x27B
;    2380 	{
;    2381 		_FF_error = NO_ENTRY_AVAL;
	LDI  R30,LOW(15)
	STS  __FF_error,R30
;    2382 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x5E
;    2383 		return (0);
	RJMP _0x3E0
;    2384 	}
;    2385 
;    2386 	calc_temp = path_addr_temp % BPB_BytsPerSec;
_0x27B:
	CALL SUBOPT_0x61
;    2387 	path_addr_temp -= calc_temp;
	CALL SUBOPT_0x62
;    2388 	if (_FF_read(path_addr_temp)==0)	
	BRNE _0x27C
;    2389 	{
;    2390 		_FF_error = READ_ERR;
	LDI  R30,LOW(4)
	STS  __FF_error,R30
;    2391 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x5E
;    2392 		return (0);
	RJMP _0x3E0
;    2393 	}
;    2394 
;    2395 	// Get the filename into a form we can use to compare
;    2396 	qp = file_name_conversion(fpath);
_0x27C:
	CALL SUBOPT_0x63
;    2397 	if (qp==0)
	BRNE _0x27D
;    2398 	{
;    2399 		_FF_error = NAME_ERR; 
	CALL SUBOPT_0x73
;    2400 		_FF_DIR_ADDR = addr_temp;
;    2401 		return (0);
	RJMP _0x3E0
;    2402 	}
;    2403 	sp = &_FF_buff[calc_temp];
_0x27D:
	CALL SUBOPT_0x65
;    2404 	
;    2405 	if (s)
	BREQ _0x27E
;    2406 	{
;    2407 		if ((_FF_buff[calc_temp+0x0B]&0x1)==1)	// is file read only
	__GETW1R 20,21
	CALL SUBOPT_0x5B
	ANDI R30,LOW(0x1)
	CPI  R30,LOW(0x1)
	BRNE _0x27F
;    2408 		{
;    2409 			_FF_error = READONLY_ERR;
	LDI  R30,LOW(6)
	STS  __FF_error,R30
;    2410 			_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x5E
;    2411 			return (0);
	RJMP _0x3E0
;    2412 		}
;    2413 	}
_0x27F:
;    2414 	else
	RJMP _0x280
_0x27E:
;    2415 	{
;    2416 		for (c=0; c<11; c++)	// Write Filename
	__GETWRN 16,17,0
_0x282:
	__CPWRN 16,17,11
	BRSH _0x283
;    2417 			*sp++ = *qp++;
	CALL SUBOPT_0x74
	SBIW R30,1
	PUSH R31
	PUSH R30
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R30,X+
	STD  Y+16,R26
	STD  Y+16+1,R27
	POP  R26
	POP  R27
	ST   X,R30
;    2418 		*sp = 0x20;				// Attribute bit auto set to "ARCHIVE"
	__ADDWRN 16,17,1
	RJMP _0x282
_0x283:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDI  R30,LOW(32)
	ST   X,R30
;    2419 		sp++;		
	CALL SUBOPT_0x74
;    2420 		*sp++ = 0;				// Reserved for WinNT
	CALL SUBOPT_0x75
;    2421 		*sp++ = 0;				// Mili-second stamp for create
	CALL SUBOPT_0x75
;    2422 	
;    2423 		#ifdef _RTC_ON_
;    2424 			rtc_get_timeNdate(&rtc_hour, &rtc_min, &rtc_sec, &rtc_date, &rtc_month, (int *)&rtc_year);	    			
;    2425     	    calc_temp = ((int)rtc_sec&0x1F) | (((int)rtc_min&0x3F)<<5) | (((int)rtc_hour&0x1F)<<11);
;    2426 			*sp++ = calc_temp&0x00FF;	// File create Time 
;    2427 			*sp++ = (calc_temp&0xFF00) >> 8;
;    2428 			calc_temp = ((int)rtc_date&0x1F) | (((int)rtc_month&0x0F)<<5) | (((rtc_year-1980)&0x7F)<<9);
;    2429 			*sp++ = calc_temp&0x00FF;	// File create Date
;    2430 			*sp++ = (calc_temp&0xFF00) >> 8;
;    2431 		#else
;    2432 			for (c=0; c<4; c++)
	__GETWRN 16,17,0
_0x285:
	__CPWRN 16,17,4
	BRSH _0x286
;    2433 				*sp++ = 0;
	CALL SUBOPT_0x75
;    2434 		#endif
;    2435 
;    2436 		*sp++ = 0;				// File access date (2 bytes)
	__ADDWRN 16,17,1
	RJMP _0x285
_0x286:
	CALL SUBOPT_0x75
;    2437 		*sp++ = 0;
	CALL SUBOPT_0x75
;    2438 		*sp++ = 0;				// 0 for FAT12/16 (2 bytes)
	CALL SUBOPT_0x75
;    2439 		*sp++ = 0;
	CALL SUBOPT_0x75
;    2440 		for (c=0; c<4; c++)		// Modify time/date
	__GETWRN 16,17,0
_0x288:
	__CPWRN 16,17,4
	BRSH _0x289
;    2441 			*sp++ = 0;
	CALL SUBOPT_0x75
;    2442 		*sp++ = 0;				// Starting cluster (2 bytes)
	__ADDWRN 16,17,1
	RJMP _0x288
_0x289:
	CALL SUBOPT_0x75
;    2443 		*sp++ = 0;
	CALL SUBOPT_0x75
;    2444 		for (c=0; c<4; c++)
	__GETWRN 16,17,0
_0x28B:
	__CPWRN 16,17,4
	BRSH _0x28C
;    2445 			*sp++ = 0;			// File length (0 for new)
	CALL SUBOPT_0x75
;    2446 	
;    2447 		if (_FF_write(path_addr_temp)==0)
	__ADDWRN 16,17,1
	RJMP _0x28B
_0x28C:
	__GETD1S 8
	CALL SUBOPT_0x76
	BRNE _0x28D
;    2448 		{
;    2449 			_FF_error = WRITE_ERR;
	LDI  R30,LOW(3)
	STS  __FF_error,R30
;    2450 			_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x5E
;    2451 			return (0);				
	RJMP _0x3E0
;    2452 		}
;    2453 	}
_0x28D:
_0x280:
;    2454 	_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    2455 	temp_file_pntr = fopen(NAME, WRITE);
	LDD  R30,Y+35
	LDD  R31,Y+35+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _fopen
	CALL SUBOPT_0x60
;    2456 	if (temp_file_pntr == 0)	// Will file open
	BRNE _0x28E
;    2457 		return (0);				
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x3E0
;    2458 	if (MODE)
_0x28E:
	LDD  R30,Y+34
	CPI  R30,0
	BREQ _0x28F
;    2459 	{
;    2460 		if (_FF_read(addr_temp)==0)
	__GETD1S 12
	CALL SUBOPT_0xC
	BRNE _0x290
;    2461 		{
;    2462 			_FF_error = READ_ERR;
	LDI  R30,LOW(4)
	STS  __FF_error,R30
;    2463 			return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x3E0
;    2464 		}
;    2465 		_FF_buff[calc_temp+12] |= MODE;		
_0x290:
	__GETW1R 20,21
	ADIW R30,12
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	PUSH R31
	PUSH R30
	LD   R30,Z
	LDD  R26,Y+34
	OR   R30,R26
	POP  R26
	POP  R27
	ST   X,R30
;    2466 		if (_FF_write(addr_temp)==0)
	__GETD1S 12
	CALL SUBOPT_0x76
	BRNE _0x291
;    2467 		{
;    2468 			_FF_error = WRITE_ERR;
	LDI  R30,LOW(3)
	STS  __FF_error,R30
;    2469 			return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x3E0
;    2470 		}
;    2471 	}
_0x291:
;    2472 	_FF_error = NO_ERR;
_0x28F:
	LDI  R30,LOW(0)
	STS  __FF_error,R30
;    2473 	return (temp_file_pntr);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
_0x3E0:
	CALL __LOADLOCR6
	ADIW R28,37
	RET
;    2474 }
;    2475 #endif
;    2476 
;    2477 #ifndef _READ_ONLY_
;    2478 // Open a file, name stored in string fileopen
;    2479 int removec(unsigned char flash *NAMEC)
;    2480 {
;    2481 	int c;
;    2482 	unsigned char sd_temp[12];
;    2483 	
;    2484 	for (c=0; c<12; c++)
;	*NAMEC -> Y+14
;	c -> R16,R17
;	sd_temp -> Y+2
;    2485 		sd_temp[c] = NAMEC[c];
;    2486 	
;    2487 	c = remove(sd_temp);
;    2488 	return (c);
;    2489 }
;    2490 
;    2491 // Remove a file from the root directory
;    2492 int remove(unsigned char *NAME)
;    2493 {
;    2494 	unsigned char fpath[14];
;    2495 	unsigned int s, calc_temp;
;    2496 	unsigned long addr_temp, path_addr_temp;
;    2497 	
;    2498 	#ifndef _SECOND_FAT_ON_
;    2499 		clear_second_FAT();
;    2500     #endif
;    2501     
;    2502     addr_temp = 0;	// save local dir addr
;	*NAME -> Y+26
;	fpath -> Y+12
;	s -> R16,R17
;	calc_temp -> R18,R19
;	addr_temp -> Y+8
;	path_addr_temp -> Y+4
;    2503     
;    2504     if (_FF_checkdir(NAME, &addr_temp, fpath))
;    2505 	{
;    2506 		_FF_error = PATH_ERR;
;    2507 		_FF_DIR_ADDR = addr_temp;
;    2508 		return (EOF);
;    2509 	}
;    2510 	if (fpath[0]==0)
;    2511 	{
;    2512 		_FF_error = NAME_ERR; 
;    2513 		_FF_DIR_ADDR = addr_temp;
;    2514 		return (EOF);
;    2515 	}
;    2516     
;    2517 	path_addr_temp = _FF_DIR_ADDR;
;    2518 	s = scan_directory(&path_addr_temp, fpath);
;    2519 	if ((path_addr_temp==0) || (s==0))
;    2520 	{
;    2521 		_FF_error = NO_ENTRY_AVAL;
;    2522 		_FF_DIR_ADDR = addr_temp;
;    2523 		return (EOF);
;    2524 	}
;    2525 	_FF_DIR_ADDR = addr_temp;		// Reset current dir
;    2526 
;    2527 	calc_temp = path_addr_temp % BPB_BytsPerSec;
;    2528 	path_addr_temp -= calc_temp;
;    2529 	if (_FF_read(path_addr_temp)==0)	
;    2530 	{
;    2531 		_FF_error = READ_ERR;
;    2532 		return (EOF);
;    2533 	}
;    2534 	
;    2535 	// Erase entry (put 0xE5 into start of the filename
;    2536 	_FF_buff[calc_temp] = 0xE5;
;    2537 	if (_FF_write(path_addr_temp)==0)
;    2538 	{
;    2539 		_FF_error = WRITE_ERR;
;    2540 		return (EOF);
;    2541 	}
;    2542 	// Save Starting Cluster
;    2543 	calc_temp = ((int) _FF_buff[calc_temp+0x1B] << 8) | (int) _FF_buff[calc_temp+0x1A];
;    2544 	// Destroy cluster chain
;    2545 	if (calc_temp)
;    2546 		if (erase_clus_chain(calc_temp) == 0)
;    2547 			return (EOF);
;    2548 			
;    2549 	return (1);
;    2550 }
;    2551 #endif
;    2552 
;    2553 #ifndef _READ_ONLY_
;    2554 // Rename a file in the Root Directory
;    2555 int rename(unsigned char *NAME_OLD, unsigned char *NAME_NEW)
;    2556 {
;    2557 	unsigned char c;
;    2558 	unsigned int calc_temp;
;    2559 	unsigned long addr_temp, path_addr_temp;
;    2560 	unsigned char *sp, *qp;
;    2561 	unsigned char fpath[14];
;    2562 
;    2563 	// Get the filename into a form we can use to compare
;    2564 	qp = file_name_conversion(NAME_NEW);
;	*NAME_OLD -> Y+31
;	*NAME_NEW -> Y+29
;	c -> R16
;	calc_temp -> R17,R18
;	addr_temp -> Y+25
;	path_addr_temp -> Y+21
;	*sp -> R19,R20
;	*qp -> Y+19
;	fpath -> Y+5
;    2565 	if (qp==0)
;    2566 	{
;    2567 		_FF_error = NAME_ERR;
;    2568 		return (EOF);
;    2569 	}
;    2570 	
;    2571     addr_temp = 0;	// save local dir addr
;    2572     
;    2573     if (_FF_checkdir(NAME_OLD, &addr_temp, fpath))
;    2574 	{
;    2575 		_FF_error = PATH_ERR;
;    2576 		_FF_DIR_ADDR = addr_temp;
;    2577 		return (EOF);
;    2578 	}
;    2579 	if (fpath[0]==0)
;    2580 	{
;    2581 		_FF_error = NAME_ERR; 
;    2582 		_FF_DIR_ADDR = addr_temp;
;    2583 		return (EOF);
;    2584 	}
;    2585 
;    2586 	path_addr_temp = _FF_DIR_ADDR;
;    2587 	calc_temp = scan_directory(&path_addr_temp, NAME_NEW);
;    2588 	if (calc_temp)
;    2589 	{	// does new name alread exist?
;    2590 		_FF_DIR_ADDR = addr_temp;
;    2591 		_FF_error = EXIST_ERR;
;    2592 		return (EOF);
;    2593 	}
;    2594 
;    2595 	path_addr_temp = _FF_DIR_ADDR;
;    2596 	calc_temp = scan_directory(&path_addr_temp, fpath);
;    2597 	if ((path_addr_temp==0) || (calc_temp==0))
;    2598 	{
;    2599 		_FF_DIR_ADDR = addr_temp;
;    2600 		_FF_error = EXIST_ERR;
;    2601 		return (EOF);
;    2602 	}
;    2603 
;    2604 
;    2605 	_FF_DIR_ADDR = addr_temp;		// Reset current dir
;    2606 
;    2607 	calc_temp = path_addr_temp % BPB_BytsPerSec;
;    2608 	path_addr_temp -= calc_temp;
;    2609 	if (_FF_read(path_addr_temp)==0)	
;    2610 	{
;    2611 		_FF_error = READ_ERR;
;    2612 		return (EOF);
;    2613 	}
;    2614 	
;    2615 	// Rename entry
;    2616 	sp = &_FF_buff[calc_temp];
;    2617 	for (c=0; c<11; c++)
;    2618 		*sp++ = *qp++;
;    2619 	if (_FF_write(path_addr_temp)==0)
;    2620 		return (EOF);
;    2621 
;    2622 	return(0);
;    2623 }
;    2624 #endif
;    2625 
;    2626 #ifndef _READ_ONLY_
;    2627 // Save Contents of file, w/o closing
;    2628 int fflush(FILE *rp)	
;    2629 {
_fflush:
;    2630 	unsigned int  n;
;    2631 	unsigned long addr_temp;
;    2632 	
;    2633 	if ((rp==NULL) || (rp->mode==READ))
	CALL SUBOPT_0x77
;	*rp -> Y+6
;	n -> R16,R17
;	addr_temp -> Y+2
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __CPW02
	BREQ _0x2AB
	CALL SUBOPT_0x78
	CPI  R26,LOW(0x1)
	BRNE _0x2AA
_0x2AB:
;    2634 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3DF
;    2635 	
;    2636 	if ((rp->mode==WRITE) || (rp->mode==APPEND))
_0x2AA:
	CALL SUBOPT_0x78
	CPI  R26,LOW(0x2)
	BREQ _0x2AE
	CALL SUBOPT_0x78
	CPI  R26,LOW(0x3)
	BRNE _0x2AD
_0x2AE:
;    2637 	{
;    2638 		addr_temp = (clust_to_addr(rp->clus_current) + ((rp->sec_offset-1)*BPB_BytsPerSec));
	CALL SUBOPT_0x6E
	CALL _clust_to_addr
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x79
	CALL __MULW12U
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x7A
;    2639 		for (n=0; n<BPB_BytsPerSec; n++)	// Save file buffer to SD buffer
	__GETWRN 16,17,0
_0x2B1:
	__CPWRR 16,17,6,7
	BRSH _0x2B2
;    2640 			_FF_buff[n] = rp->buff[n];
	CALL SUBOPT_0x7B
	LD   R30,Z
	ST   X,R30
;    2641 		if (_FF_write(addr_temp)==0)	// Write SD buffer to disk
	__ADDWRN 16,17,1
	RJMP _0x2B1
_0x2B2:
	__GETD1S 2
	CALL SUBOPT_0x76
	BRNE _0x2B3
;    2642 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3DF
;    2643 		if (append_toc(rp)==0)	// Update Entry or Error
_0x2B3:
	CALL SUBOPT_0x7C
	BRNE _0x2B4
;    2644 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3DF
;    2645 	}
_0x2B4:
;    2646 	
;    2647 	return (0);
_0x2AD:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x3DF:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	RET
;    2648 }
;    2649 #endif		
;    2650 
;    2651 
;    2652 // Close an open file
;    2653 int fclose(FILE *rp)	
;    2654 {
_fclose:
;    2655 	#ifndef _READ_ONLY_
;    2656 	if (rp->mode!=READ)
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0x7D
	BREQ _0x2B5
;    2657 		if (fflush(rp)==EOF)
	LD   R30,Y
	LDD  R31,Y+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _fflush
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2B6
;    2658 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3DE
;    2659 	#endif	
;    2660 	// Clear File Structure
;    2661 	free(rp);
_0x2B6:
_0x2B5:
	LD   R30,Y
	LDD  R31,Y+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _free
;    2662 	rp = 0;
	LDI  R30,0
	STD  Y+0,R30
	STD  Y+0+1,R30
;    2663 	return(0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x3DE:
	ADIW R28,2
	RET
;    2664 }
;    2665 
;    2666 int ffreemem(FILE *rp)	
;    2667 {
;    2668 	// Clear File Structure
;    2669 	if (rp==0)
;    2670 		return (EOF);
;    2671 	free(rp);
;    2672 	return(0);
;    2673 }
;    2674 
;    2675 int fget_file_infoc(unsigned char flash *NAMEC, unsigned long *F_SIZE, unsigned char *F_CREATE,
;    2676 				unsigned char *F_MODIFY, unsigned char *F_ATTRIBUTE, unsigned int *F_CLUS_START)
;    2677 {
;    2678 	int c;
;    2679 	unsigned char sd_temp[12];
;    2680 	
;    2681 	for (c=0; c<12; c++)
;	*NAMEC -> Y+24
;	*F_SIZE -> Y+22
;	*F_CREATE -> Y+20
;	*F_MODIFY -> Y+18
;	*F_ATTRIBUTE -> Y+16
;	*F_CLUS_START -> Y+14
;	c -> R16,R17
;	sd_temp -> Y+2
;    2682 		sd_temp[c] = NAMEC[c];
;    2683 	
;    2684 	c = fget_file_info(sd_temp, F_SIZE, F_CREATE, F_MODIFY, F_ATTRIBUTE, F_CLUS_START);
;    2685 	return (c);
;    2686 }
;    2687 
;    2688 int fget_file_info(unsigned char *NAME, unsigned long *F_SIZE, unsigned char *F_CREATE,
;    2689 				unsigned char *F_MODIFY, unsigned char *F_ATTRIBUTE, unsigned int *F_CLUS_START)
;    2690 {
;    2691 	unsigned char n;
;    2692 	unsigned int s, calc_temp;
;    2693 	unsigned long addr_temp, file_calc_temp;
;    2694 	unsigned char *sp, *qp;
;    2695 	
;    2696 	// Get the filename into a form we can use to compare
;    2697 	qp = file_name_conversion(NAME);
;	*NAME -> Y+27
;	*F_SIZE -> Y+25
;	*F_CREATE -> Y+23
;	*F_MODIFY -> Y+21
;	*F_ATTRIBUTE -> Y+19
;	*F_CLUS_START -> Y+17
;	n -> R16
;	s -> R17,R18
;	calc_temp -> R19,R20
;	addr_temp -> Y+13
;	file_calc_temp -> Y+9
;	*sp -> Y+7
;	*qp -> Y+5
;    2698 	if (qp==0)
;    2699 	{
;    2700 		_FF_error = NAME_ERR;
;    2701 		return (EOF);
;    2702 	}
;    2703 	
;    2704 	for (s=0; s<BPB_BytsPerSec; s++)
;    2705 	{	// Scan through directory entries to find file
;    2706 		addr_temp = _FF_DIR_ADDR + (0x200 * s);
;    2707 		if (_FF_read(addr_temp)==0)
;    2708 			return (EOF);
;    2709 		for (n=0; n<16; n++)
;    2710 		{
;    2711 			calc_temp = (int) n * 0x20;
;    2712 			qp = &FILENAME[0];
;    2713 			sp = &_FF_buff[calc_temp];
;    2714 			if (*sp == 0)
;    2715 				return (EOF);
;    2716 			if (strncmp(qp, sp, 11)==0)		// Does this entry == Filename
;    2717 			{
;    2718 				*F_ATTRIBUTE = _FF_buff[calc_temp+11];	// Save ATTRIBUTE Byte to location
;    2719 				*F_SIZE = ((long) _FF_buff[calc_temp+31] << 24) | ((long) _FF_buff[calc_temp+30] << 16)
;    2720 							| ((long) _FF_buff[calc_temp+29] << 8) | ((long) _FF_buff[calc_temp+28]);
;    2721 							// Save SIZE of file to location
;    2722                 *F_CLUS_START = ((unsigned int) _FF_buff[calc_temp+27] << 8) | ((unsigned int) _FF_buff[calc_temp+26]);
;    2723 				file_calc_temp = ((unsigned int) _FF_buff[calc_temp+17] << 8) | ((unsigned int) _FF_buff[calc_temp+16]);
;    2724 				qp = F_CREATE;
;    2725 				*qp++ = (((file_calc_temp >> 5) & 0x0F) / 10) + '0';
;    2726 				*qp++ = (((file_calc_temp >> 5) & 0x0F) % 10) + '0';
;    2727 				*qp++ = '/';
;    2728 				*qp++ = ((file_calc_temp & 0x1F) / 10) + '0';
;    2729 				*qp++ = ((file_calc_temp & 0x1F) % 10) + '0';
;    2730 				*qp++ = '/';
;    2731 				file_calc_temp = ((file_calc_temp >> 9) & 0x7F) + 1980;
;    2732 				*qp++ = (file_calc_temp / 1000) + '0';
;    2733 				file_calc_temp %= 1000;
;    2734 				*qp++ = (file_calc_temp / 100) + '0';
;    2735 				file_calc_temp %= 100;
;    2736 				*qp++ = (file_calc_temp / 10) + '0';
;    2737 				*qp++ = (file_calc_temp % 10) + '0';
;    2738 				*qp++ = ' ';
;    2739 				*qp++ = ' ';
;    2740 				file_calc_temp = ((unsigned int) _FF_buff[calc_temp+15] << 8) | ((unsigned int) _FF_buff[calc_temp+14]);
;    2741 				*qp++ = (((file_calc_temp >> 11) & 0x1F) / 10) + '0';
;    2742 				*qp++ = (((file_calc_temp >> 11) & 0x1F) % 10) + '0';
;    2743 				*qp++ = ':';
;    2744 				*qp++ = (((file_calc_temp >> 5) & 0x3F) / 10) + '0';
;    2745 				*qp++ = (((file_calc_temp >> 5) & 0x3F) % 10) + '0';
;    2746 				*qp++ = ':';
;    2747 				*qp++ = (((file_calc_temp & 0x1F) * 2) / 10) + '0';
;    2748 				*qp++ = (((file_calc_temp & 0x1F) * 2) % 10) + '0';
;    2749 				*qp = 0;
;    2750 				
;    2751 				file_calc_temp = ((unsigned int) _FF_buff[calc_temp+25] << 8) | ((unsigned int) _FF_buff[calc_temp+24]);
;    2752 				qp = F_MODIFY;
;    2753 				*qp++ = (((file_calc_temp >> 5) & 0x0F) / 10) + '0';
;    2754 				*qp++ = (((file_calc_temp >> 5) & 0x0F) % 10) + '0';
;    2755 				*qp++ = '/';
;    2756 				*qp++ = ((file_calc_temp & 0x1F) / 10) + '0';
;    2757 				*qp++ = ((file_calc_temp & 0x1F) % 10) + '0';
;    2758 				*qp++ = '/';
;    2759 				file_calc_temp = ((file_calc_temp >> 9) & 0x7F) + 1980;
;    2760 				*qp++ = (file_calc_temp / 1000) + '0';
;    2761 				file_calc_temp %= 1000;
;    2762 				*qp++ = (file_calc_temp / 100) + '0';
;    2763 				file_calc_temp %= 100;
;    2764 				*qp++ = (file_calc_temp / 10) + '0';
;    2765 				*qp++ = (file_calc_temp % 10) + '0';
;    2766 				*qp++ = ' ';
;    2767 				*qp++ = ' ';
;    2768 				file_calc_temp = ((unsigned int) _FF_buff[calc_temp+23] << 8) | ((unsigned int) _FF_buff[calc_temp+22]);
;    2769 				*qp++ = (((file_calc_temp >> 11) & 0x1F) / 10) + '0';
;    2770 				*qp++ = (((file_calc_temp >> 11) & 0x1F) % 10) + '0';
;    2771 				*qp++ = ':';
;    2772 				*qp++ = (((file_calc_temp >> 5) & 0x3F) / 10) + '0';
;    2773 				*qp++ = (((file_calc_temp >> 5) & 0x3F) % 10) + '0';
;    2774 				*qp++ = ':';
;    2775 				*qp++ = (((file_calc_temp & 0x1F) * 2) / 10) + '0';
;    2776 				*qp++ = (((file_calc_temp & 0x1F) * 2) % 10) + '0';
;    2777 				*qp = 0;
;    2778 				
;    2779 				return (0);
;    2780 			}
;    2781 		}                          		
;    2782 	}
;    2783 	_FF_error = FILE_ERR;
;    2784 	return(EOF);
;    2785 }
;    2786 
;    2787 // Get File data and increment file pointer
;    2788 int fgetc(FILE *rp)
;    2789 {
;    2790 	unsigned char get_data;
;    2791 	unsigned int n;
;    2792 	unsigned long addr_temp;
;    2793 	
;    2794 	if (rp==NULL)
;	*rp -> Y+7
;	get_data -> R16
;	n -> R17,R18
;	addr_temp -> Y+3
;    2795 		return (EOF);
;    2796 
;    2797 	if (rp->position == rp->length)
;    2798 	{
;    2799 		rp->error = POS_ERR;
;    2800 		return (EOF);
;    2801 	}
;    2802 	
;    2803 	get_data = *rp->pntr;
;    2804 	
;    2805 	if ((rp->pntr)==(&rp->buff[BPB_BytsPerSec-1]))
;    2806 	{	// Check to see if pointer is at the end of a sector
;    2807 		#ifndef _READ_ONLY_
;    2808 		if ((rp->mode==WRITE) || (rp->mode==APPEND))
;    2809 		{	// if in write or append mode, update the current sector before loading next
;    2810 			for (n=0; n<BPB_BytsPerSec; n++)
;    2811 				_FF_buff[n] = rp->buff[n];
;    2812 			addr_temp = clust_to_addr(rp->clus_current) + (((rp->sec_offset)-1)*BPB_BytsPerSec);
;    2813 			if (_FF_write(addr_temp)==0)
;    2814 				return (EOF);
;    2815 		}
;    2816 		#endif
;    2817 		if (rp->sec_offset < BPB_SecPerClus)
;    2818 		{	// Goto next sector if not at the end of a cluster
;    2819 			addr_temp = clust_to_addr(rp->clus_current) + (rp->sec_offset*BPB_BytsPerSec);
;    2820 			rp->sec_offset++;
;    2821 		}
;    2822 		else
;    2823 		{	// End of Cluster, find next
;    2824 			if (rp->clus_next>=0xFFF8)	// No next cluster, EOF marker
;    2825 			{
;    2826 				rp->EOF_flag = 1;	// Set flag so Putchar knows to get new cluster
;    2827 				rp->position++;		// Only time doing this, position + 1 should equal length
;    2828 				return(get_data);
;    2829 			}
;    2830 			addr_temp = clust_to_addr(rp->clus_next);
;    2831 			rp->sec_offset = 1;
;    2832 			rp->clus_prev = rp->clus_current;
;    2833 			rp->clus_current = rp->clus_next;
;    2834 			rp->clus_next = next_cluster(rp->clus_current, SINGLE);
;    2835 		}
;    2836 		if (_FF_read(addr_temp)==0)
;    2837 			return (EOF);
;    2838 		for (n=0; n<BPB_BytsPerSec; n++)
;    2839 			rp->buff[n] = _FF_buff[n];
;    2840 		rp->pntr = &rp->buff[0];
;    2841 	}
;    2842 	else
;    2843 		rp->pntr++;
;    2844 	
;    2845 	rp->position++;	
;    2846 	return(get_data);		
;    2847 }
;    2848 
;    2849 char *fgets(char *buffer, int n, FILE *rp)
;    2850 {
;    2851 	int c, temp_data;
;    2852 	
;    2853 	for (c=0; c<n; c++)
;	*buffer -> Y+8
;	n -> Y+6
;	*rp -> Y+4
;	c -> R16,R17
;	temp_data -> R18,R19
;    2854 	{
;    2855 		temp_data = fgetc(rp);
;    2856 		*buffer = temp_data & 0xFF;
;    2857 		if (temp_data == '\n')
;    2858 			break;
;    2859 		else if (temp_data == EOF)
;    2860 			break;
;    2861 		buffer++;
;    2862 	}
;    2863 	if (c==n)
;    2864 		buffer++;
;    2865 	*buffer-- = '\0';
;    2866 	if (temp_data == EOF)
;    2867 		return (NULL);
;    2868 	return (buffer);
;    2869 }
;    2870 
;    2871 #ifndef _READ_ONLY_
;    2872 // Decrement file pointer, then get file data
;    2873 int ungetc(unsigned char file_data, FILE *rp)
;    2874 {
;    2875 	unsigned int n;
;    2876 	unsigned long addr_temp;
;    2877 	
;    2878 	if ((rp==NULL) || (rp->position==0))
;	file_data -> Y+8
;	*rp -> Y+6
;	n -> R16,R17
;	addr_temp -> Y+2
;    2879 		return (EOF);
;    2880 	if ((rp->mode!=APPEND) && (rp->mode!=WRITE))
;    2881 		return (EOF);	// needs to be in WRITE or APPEND mode
;    2882 
;    2883 	if (((rp->position) == rp->length) && (rp->EOF_flag))
;    2884 	{	// if the file posisition is equal to the length, return data, turn flag off
;    2885 		rp->EOF_flag = 0;
;    2886 		*rp->pntr = file_data;
;    2887 		return (*rp->pntr);
;    2888 	}
;    2889 	if ((rp->pntr)==(&rp->buff[0]))
;    2890 	{	// Check to see if pointer is at the beginning of a Sector
;    2891 		// Update the current sector before loading next
;    2892 		for (n=0; n<BPB_BytsPerSec; n++)
;    2893 			_FF_buff[n] = rp->buff[n];
;    2894 		addr_temp = clust_to_addr(rp->clus_current) + (((rp->sec_offset)-1)*BPB_BytsPerSec);
;    2895 		if (_FF_write(addr_temp)==0)
;    2896 			return (EOF);
;    2897 			
;    2898 		if (rp->sec_offset > 1)
;    2899 		{	// Goto previous sector if not at the beginning of a cluster
;    2900 			addr_temp = clust_to_addr(rp->clus_current) + ((rp->sec_offset-2)*BPB_BytsPerSec);
;    2901 			rp->sec_offset--;
;    2902 		}
;    2903 		else
;    2904 		{	// Beginning of Cluster, find previous
;    2905 			if (rp->clus_start==rp->clus_current)
;    2906 			{	// Positioned @ Beginning of File
;    2907 				_FF_error = SOF_ERR;
;    2908 				return(EOF);
;    2909 			}
;    2910 			rp->sec_offset = BPB_SecPerClus;	// Set sector offset to last sector
;    2911 			rp->clus_next = rp->clus_current;
;    2912 			rp->clus_current = rp->clus_prev;
;    2913 			if (rp->clus_current != rp->clus_start)
;    2914 				rp->clus_prev = prev_cluster(rp->clus_current);
;    2915 			else
;    2916 				rp->clus_prev = 0;
;    2917 			addr_temp = clust_to_addr(rp->clus_current) + (((long) BPB_SecPerClus-1) * (long) BPB_BytsPerSec);
;    2918 		}
;    2919 		_FF_read(addr_temp);
;    2920 		for (n=0; n<BPB_BytsPerSec; n++)
;    2921 			rp->buff[n] = _FF_buff[n];
;    2922 		rp->pntr = &rp->buff[511];
;    2923 	}
;    2924 	else
;    2925 		rp->pntr--;
;    2926 	
;    2927 	rp->position--;
;    2928 	*rp->pntr = file_data;	
;    2929 	return(*rp->pntr);	// Get data	
;    2930 }
;    2931 #endif
;    2932 
;    2933 #ifndef _READ_ONLY_
;    2934 int fputc(unsigned char file_data, FILE *rp)	
;    2935 {
_fputc:
;    2936 	unsigned int n;
;    2937 	unsigned long addr_temp;
;    2938 	
;    2939 	if (rp==NULL)
	CALL SUBOPT_0x77
;	file_data -> Y+8
;	*rp -> Y+6
;	n -> R16,R17
;	addr_temp -> Y+2
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,0
	BRNE _0x2F6
;    2940 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3DD
;    2941 
;    2942 	if (rp->mode == READ)
_0x2F6:
	CALL SUBOPT_0x78
	CPI  R26,LOW(0x1)
	BRNE _0x2F7
;    2943 	{
;    2944 		_FF_error = READONLY_ERR;
	LDI  R30,LOW(6)
	STS  __FF_error,R30
;    2945 		return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3DD
;    2946 	}
;    2947 	if (rp->length == 0)
_0x2F7:
	CALL SUBOPT_0x6C
	BRNE _0x2F8
;    2948 	{	// Blank file start writing cluster table
;    2949 		rp->clus_start = prev_cluster(0);
	CALL SUBOPT_0x7E
	__PUTW1SNS 6,12
;    2950 		rp->clus_next = 0xFFFF;
	CALL SUBOPT_0x7F
;    2951 		rp->clus_current = rp->clus_start;
	CALL SUBOPT_0x67
	__PUTW1SNS 6,14
;    2952 		if (write_clus_table(rp->clus_start, rp->clus_next, SINGLE)==0)
	CALL SUBOPT_0x6D
	CALL SUBOPT_0x80
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _write_clus_table
	CPI  R30,0
	BRNE _0x2F9
;    2953 		{
;    2954 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3DD
;    2955 		}
;    2956 	}
_0x2F9:
;    2957 	
;    2958 	if ((rp->position==rp->length) && (rp->EOF_flag))
_0x2F8:
	CALL SUBOPT_0x81
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x82
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD12
	BRNE _0x2FB
	CALL SUBOPT_0x83
	BRNE _0x2FC
_0x2FB:
	RJMP _0x2FA
_0x2FC:
;    2959 	{	// At end of file, and end of cluster, flagged
;    2960 		rp->clus_prev = rp->clus_current;
	CALL SUBOPT_0x84
	__PUTW1SNS 6,18
;    2961 		rp->clus_current = prev_cluster(0);	// Find first cluster pointing to '0'
	CALL SUBOPT_0x7E
	__PUTW1SNS 6,14
;    2962 		rp->clus_next = 0xFFFF;
	CALL SUBOPT_0x7F
;    2963 		rp->sec_offset = 1;
	CALL SUBOPT_0x6F
;    2964 		if (write_clus_table(rp->clus_prev, rp->clus_current, CHAIN)==0)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+18
	LDD  R27,Z+19
	ST   -Y,R27
	ST   -Y,R26
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Z+14
	LDD  R27,Z+15
	ST   -Y,R27
	ST   -Y,R26
	CALL SUBOPT_0x55
	BRNE _0x2FD
;    2965 		{
;    2966 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3DD
;    2967 		}
;    2968 		if (write_clus_table(rp->clus_current, rp->clus_next, END_CHAIN)==0)
_0x2FD:
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x80
	CALL SUBOPT_0x56
	BRNE _0x2FE
;    2969 		{
;    2970 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3DD
;    2971 		}
;    2972 		if (append_toc(rp)==0)
_0x2FE:
	CALL SUBOPT_0x7C
	BRNE _0x2FF
;    2973 		{
;    2974 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3DD
;    2975 		}
;    2976 		rp->EOF_flag = 0;
_0x2FF:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x85
;    2977 		rp->pntr = &rp->buff[0];		
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,28
	__PUTW1SN 6,551
;    2978 	}
;    2979 	
;    2980 	*rp->pntr = file_data;
_0x2FA:
	CALL SUBOPT_0x86
	LDD  R26,Y+8
	STD  Z+0,R26
;    2981 	
;    2982 	if (rp->pntr == &rp->buff[BPB_BytsPerSec-1])
	CALL SUBOPT_0x86
	PUSH R31
	PUSH R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x87
	POP  R26
	POP  R27
	CP   R30,R26
	CPC  R31,R27
	BREQ PC+3
	JMP _0x300
;    2983 	{	// This is on the Sector Limit
;    2984 		if (rp->position > rp->length)
	CALL SUBOPT_0x81
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x82
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD12
	BRSH _0x301
;    2985 		{	// ERROR, position should never be greater than length
;    2986 			_FF_error = 0x10;		// file position ERROR
	LDI  R30,LOW(16)
	STS  __FF_error,R30
;    2987 			return (EOF); 
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3DD
;    2988 		}
;    2989 		// Position is at end of a sector?
;    2990 		
;    2991 		addr_temp = (clust_to_addr(rp->clus_current) + ((rp->sec_offset-1)*BPB_BytsPerSec));
_0x301:
	CALL SUBOPT_0x6E
	CALL _clust_to_addr
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x79
	CALL __MULW12U
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x7A
;    2992 		for (n=0; n<BPB_BytsPerSec; n++)
	__GETWRN 16,17,0
_0x303:
	__CPWRR 16,17,6,7
	BRSH _0x304
;    2993 			_FF_buff[n] = rp->buff[n];
	CALL SUBOPT_0x7B
	LD   R30,Z
	ST   X,R30
;    2994 		_FF_write(addr_temp);
	__ADDWRN 16,17,1
	RJMP _0x303
_0x304:
	__GETD1S 2
	CALL __PUTPARD1
	CALL __FF_write
;    2995 			// Save MMC buffer to card, set pointer to begining of new buffer
;    2996 		if (rp->sec_offset < BPB_SecPerClus)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+20
	LDD  R27,Z+21
	MOV  R30,R8
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x305
;    2997 		{	// Are there more sectors in this cluster?
;    2998 			addr_temp = clust_to_addr(rp->clus_current) + (rp->sec_offset * BPB_BytsPerSec);
	CALL SUBOPT_0x6E
	CALL _clust_to_addr
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+20
	LDD  R27,Z+21
	__GETW1R 6,7
	CALL __MULW12U
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x7A
;    2999 			rp->sec_offset++;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x88
;    3000 		}
;    3001 		else
	RJMP _0x306
_0x305:
;    3002 		{	// Find next cluster, load first sector into file.buff
;    3003 			if (((rp->clus_next>=0xFFF8)&&(BPB_FATType==0x36)) ||
;    3004 				((rp->clus_next>=0xFF8)&&(BPB_FATType==0x32)))
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+16
	LDD  R27,Z+17
	CPI  R26,LOW(0xFFF8)
	LDI  R30,HIGH(0xFFF8)
	CPC  R27,R30
	BRLO _0x308
	LDI  R30,LOW(54)
	CP   R30,R14
	BREQ _0x30A
_0x308:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+16
	LDD  R27,Z+17
	CPI  R26,LOW(0xFF8)
	LDI  R30,HIGH(0xFF8)
	CPC  R27,R30
	BRLO _0x30B
	LDI  R30,LOW(50)
	CP   R30,R14
	BREQ _0x30A
_0x30B:
	RJMP _0x307
_0x30A:
;    3005 			{	// EOF, need to find new empty cluster
;    3006 				if (rp->position != rp->length)
	CALL SUBOPT_0x81
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x82
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD12
	BREQ _0x30E
;    3007 				{	// if not equal there's an error
;    3008 					_FF_error = 0x20;		// EOF position error
	LDI  R30,LOW(32)
	STS  __FF_error,R30
;    3009 					return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3DD
;    3010 				}
;    3011 				rp->EOF_flag = 1;
_0x30E:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x89
;    3012 			}
;    3013 			else
	RJMP _0x30F
_0x307:
;    3014 			{	// Not EOF, find next cluster
;    3015 				rp->clus_prev = rp->clus_current;
	CALL SUBOPT_0x84
	__PUTW1SNS 6,18
;    3016 				rp->clus_current = rp->clus_next;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,16
	CALL __GETW1P
	__PUTW1SNS 6,14
;    3017 				rp->clus_next = next_cluster(rp->clus_current, SINGLE);
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x26
	__PUTW1SNS 6,16
;    3018 			}
_0x30F:
;    3019 			rp->sec_offset = 1;
	CALL SUBOPT_0x6F
;    3020 			addr_temp = clust_to_addr(rp->clus_current);
	CALL SUBOPT_0x6E
	CALL _clust_to_addr
	__PUTD1S 2
;    3021 		}
_0x306:
;    3022 		
;    3023 		if (rp->EOF_flag == 0)
	CALL SUBOPT_0x83
	BRNE _0x310
;    3024 		{
;    3025 			if (_FF_read(addr_temp)==0)
	__GETD1S 2
	CALL SUBOPT_0xC
	BRNE _0x311
;    3026 				return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3DD
;    3027 			for (n=0; n<512; n++)
_0x311:
	__GETWRN 16,17,0
_0x313:
	__CPWRN 16,17,512
	BRSH _0x314
;    3028 				rp->buff[n] = _FF_buff[n];
	CALL SUBOPT_0x71
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x72
	POP  R26
	POP  R27
	ST   X,R30
;    3029 			rp->pntr = &rp->buff[0];	// Set pointer to next location				
	__ADDWRN 16,17,1
	RJMP _0x313
_0x314:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,28
	__PUTW1SN 6,551
;    3030 		}
;    3031 		if (rp->length==rp->position)
_0x310:
	CALL SUBOPT_0x82
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x81
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD12
	BRNE _0x315
;    3032 			rp->length++;
	CALL SUBOPT_0x82
	__SUBD1N -1
	CALL __PUTDP1
;    3033 		if (append_toc(rp)==0)
_0x315:
	CALL SUBOPT_0x7C
	BRNE _0x316
;    3034 			return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3DD
;    3035 	}
_0x316:
;    3036 	else
	RJMP _0x317
_0x300:
;    3037 	{
;    3038 		rp->pntr++;
	CALL SUBOPT_0x86
	ADIW R30,1
	ST   X+,R30
	ST   X,R31
;    3039 		if (rp->length==rp->position)
	CALL SUBOPT_0x82
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x81
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD12
	BRNE _0x318
;    3040 			rp->length++;
	CALL SUBOPT_0x82
	__SUBD1N -1
	CALL __PUTDP1
;    3041 	}
_0x318:
_0x317:
;    3042 	rp->position++;
	CALL SUBOPT_0x81
	__SUBD1N -1
	CALL __PUTDP1
;    3043 	return(file_data);
	LDD  R30,Y+8
	LDI  R31,0
_0x3DD:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,9
	RET
;    3044 }
;    3045 
;    3046 int fputs(unsigned char *file_data, FILE *rp)
;    3047 {
;    3048 	while(*file_data)
;    3049 		if (fputc(*file_data++,rp) == EOF)
;    3050 			return (EOF);
;    3051 	if (fputc('\r',rp) == EOF)
;    3052 		return (EOF);
;    3053 	if (fputc('\n',rp) == EOF)
;    3054 		return (EOF);
;    3055 	return (0);
;    3056 }
;    3057 
;    3058 int fputsc(flash unsigned char *file_data, FILE *rp)
;    3059 {
;    3060 	while(*file_data)
;    3061 		if (fputc(*file_data++,rp) == EOF)
;    3062 			return (EOF);
;    3063 	if (fputc('\r',rp) == EOF)
;    3064 		return (EOF);
;    3065 	if (fputc('\n',rp) == EOF)
;    3066 		return (EOF);
;    3067 	return (0);
;    3068 }
;    3069 #endif
;    3070 
;    3071 #ifndef _READ_ONLY_
;    3072 #ifdef _CVAVR_
;    3073 void fprintf(FILE *rp, unsigned char flash *pstr, ...)
;    3074 {
_fprintf:
	PUSH R15
	MOV  R15,R24
;    3075 	va_list arglist;
;    3076 	unsigned char temp_buff[_FF_MAX_FPRINT], *fp;
;    3077 	
;    3078 	va_start(arglist, pstr);
	SBIW R28,63
	SBIW R28,37
	CALL __SAVELOCR4
;	*rp -> Y+106
;	*pstr -> Y+104
;	*arglist -> R16,R17
;	temp_buff -> Y+4
;	*fp -> R18,R19
	MOVW R26,R28
	SUBI R26,LOW(-(100))
	SBCI R27,HIGH(-(100))
	CALL __ADDW2R15
	__PUTW2R 16,17
;    3079 	vsprintf(temp_buff, pstr, arglist);
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	SUBI R26,LOW(-(106))
	SBCI R27,HIGH(-(106))
	CALL SUBOPT_0x8A
	ST   -Y,R17
	ST   -Y,R16
	CALL _vsprintf
;    3080 	va_end(arglist);
;    3081 	
;    3082 	fp = temp_buff;
	MOVW R30,R28
	ADIW R30,4
	__PUTW1R 18,19
;    3083 	while (*fp)
_0x325:
	CALL SUBOPT_0x58
	BREQ _0x327
;    3084 		fputc(*fp++, rp);	
	__GETW2R 18,19
	__ADDWRN 18,19,1
	LD   R30,X
	ST   -Y,R30
	MOVW R26,R28
	SUBI R26,LOW(-(107))
	SBCI R27,HIGH(-(107))
	CALL SUBOPT_0x8A
	CALL _fputc
;    3085 }
	RJMP _0x325
_0x327:
	CALL __LOADLOCR4
	ADIW R28,63
	ADIW R28,41
	POP  R15
	RET
;    3086 #endif
;    3087 #ifdef _ICCAVR_
;    3088 void fprintf(FILE *rp, unsigned char flash *pstr, long var)
;    3089 {
;    3090 	unsigned char temp_buff[_FF_MAX_FPRINT], *fp;
;    3091 	
;    3092 	csprintf(temp_buff, pstr, var);
;    3093 	
;    3094 	fp = temp_buff;
;    3095 	while (*fp)
;    3096 		fputc(*fp++, rp);	
;    3097 }
;    3098 #endif
;    3099 #endif
;    3100 
;    3101 // Set file pointer to the end of the file
;    3102 int fend(FILE *rp)
;    3103 {
;    3104 	return (fseek(rp, 0, SEEK_END));	
;    3105 }
;    3106 
;    3107 // Goto position "off_set" of a file
;    3108 int fseek(FILE *rp, unsigned long off_set, unsigned char mode)
;    3109 {
_fseek:
;    3110 	unsigned int n, clus_temp;
;    3111 	unsigned long length_check, addr_calc;
;    3112 	
;    3113 	if (rp==NULL)
	SBIW R28,8
	CALL __SAVELOCR4
;	*rp -> Y+17
;	off_set -> Y+13
;	mode -> Y+12
;	n -> R16,R17
;	clus_temp -> R18,R19
;	length_check -> Y+8
;	addr_calc -> Y+4
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	SBIW R30,0
	BRNE _0x328
;    3114 	{	// ERROR if FILE pointer is NULL
;    3115 		_FF_error = FILE_ERR;
	LDI  R30,LOW(2)
	STS  __FF_error,R30
;    3116 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3DC
;    3117 	}
;    3118 	if (mode==SEEK_CUR)
_0x328:
	LDD  R30,Y+12
	CPI  R30,0
	BRNE _0x329
;    3119 	{	// Trying to position pointer to offset from current position
;    3120 		off_set += rp->position;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SUBI R26,LOW(-544)
	SBCI R27,HIGH(-544)
	CALL __GETD1P
	__GETD2S 13
	CALL __ADDD12
	__PUTD1S 13
;    3121 	}
;    3122 	if (off_set > rp->length)
_0x329:
	CALL SUBOPT_0x8B
	CALL __CPD12
	BRSH _0x32A
;    3123 	{	// trying to position beyond or before file
;    3124 		rp->error = POS_ERR;
	CALL SUBOPT_0x8C
;    3125 		_FF_error = POS_ERR;
;    3126 		return (EOF);
	RJMP _0x3DC
;    3127 	}
;    3128 	if (mode==SEEK_END)
_0x32A:
	LDD  R26,Y+12
	CPI  R26,LOW(0x1)
	BRNE _0x32B
;    3129 	{	// Trying to position pointer to offset from EOF
;    3130 		off_set = rp->length - off_set;
	CALL SUBOPT_0x8B
	CALL __SUBD12
	__PUTD1S 13
;    3131 	}
;    3132 	#ifndef _READ_ONLY_
;    3133 	if (rp->mode != READ)
_0x32B:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	CALL SUBOPT_0x7D
	BREQ _0x32C
;    3134 		if (fflush(rp))
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _fflush
	SBIW R30,0
	BREQ _0x32D
;    3135 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3DC
;    3136 	#endif
;    3137 	clus_temp = rp->clus_start;
_0x32D:
_0x32C:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,12
	LD   R18,X+
	LD   R19,X
;    3138 	rp->clus_current = clus_temp;
	__GETW1R 18,19
	__PUTW1SNS 17,14
;    3139 	rp->clus_next = next_cluster(clus_temp, SINGLE);
	ST   -Y,R19
	ST   -Y,R18
	CALL SUBOPT_0x26
	__PUTW1SNS 17,16
;    3140 	rp->clus_prev = 0;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	CALL SUBOPT_0x68
;    3141 	
;    3142 	addr_calc = off_set / ((long) BPB_BytsPerSec * (long) BPB_SecPerClus);
	CALL SUBOPT_0x20
	__GETD2S 13
	CALL __DIVD21U
	__PUTD1S 4
;    3143 	length_check = off_set % ((long) BPB_BytsPerSec * (long) BPB_SecPerClus);
	CALL SUBOPT_0x20
	__GETD2S 13
	CALL __MODD21U
	__PUTD1S 8
;    3144 	rp->EOF_flag = 0;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	CALL SUBOPT_0x85
;    3145 
;    3146 	while (addr_calc)
_0x32E:
	__GETD1S 4
	CALL __CPD10
	BRNE PC+3
	JMP _0x330
;    3147 	{
;    3148 		if (rp->clus_next >= 0xFFF8)
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	LDD  R26,Z+16
	LDD  R27,Z+17
	CPI  R26,LOW(0xFFF8)
	LDI  R30,HIGH(0xFFF8)
	CPC  R27,R30
	BRLO _0x331
;    3149 		{	// trying to position beyond or before file
;    3150 			if ((addr_calc==1) && (length_check==0))
	__GETD2S 4
	__CPD2N 0x1
	BRNE _0x333
	__GETD2S 8
	CALL __CPD02
	BREQ _0x334
_0x333:
	RJMP _0x332
_0x334:
;    3151 			{
;    3152 				rp->EOF_flag = 1;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	CALL SUBOPT_0x89
;    3153 				break;
	RJMP _0x330
;    3154 			}				
;    3155 			rp->error = POS_ERR;
_0x332:
	CALL SUBOPT_0x8C
;    3156 			_FF_error = POS_ERR;
;    3157 			return (EOF);
	RJMP _0x3DC
;    3158 		}
;    3159 		clus_temp = rp->clus_next;
_0x331:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,16
	LD   R18,X+
	LD   R19,X
;    3160 		rp->clus_prev = rp->clus_current;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,14
	CALL __GETW1P
	__PUTW1SNS 17,18
;    3161 		rp->clus_current = clus_temp;
	__GETW1R 18,19
	__PUTW1SNS 17,14
;    3162 		rp->clus_next = next_cluster(clus_temp, CHAIN);
	CALL SUBOPT_0x53
	__PUTW1SNS 17,16
;    3163 		addr_calc--;
	__GETD1S 4
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	__PUTD1S 4
;    3164 	}
	RJMP _0x32E
_0x330:
;    3165 	
;    3166 	addr_calc = clust_to_addr(rp->clus_current);
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	LDD  R26,Z+14
	LDD  R27,Z+15
	ST   -Y,R27
	ST   -Y,R26
	CALL _clust_to_addr
	__PUTD1S 4
;    3167 	rp->sec_offset = 1;			// Reset Reading Sector
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,20
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
;    3168 	while (length_check >= BPB_BytsPerSec)
_0x335:
	__GETW1R 6,7
	__GETD2S 8
	CLR  R22
	CLR  R23
	CALL __CPD21
	BRLO _0x337
;    3169 	{
;    3170 		addr_calc += BPB_BytsPerSec;
	__GETW1R 6,7
	__GETD2S 4
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1S 4
;    3171 		length_check -= BPB_BytsPerSec;
	__GETW1R 6,7
	__GETD2S 8
	CALL SUBOPT_0x14
	__PUTD1S 8
;    3172 		rp->sec_offset++;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	CALL SUBOPT_0x88
;    3173 	}
	RJMP _0x335
_0x337:
;    3174 	
;    3175 	if (_FF_read(addr_calc)==0)		// Read Current Data Sector
	__GETD1S 4
	CALL SUBOPT_0xC
	BRNE _0x338
;    3176 		return(EOF);		// Read Error  
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x3DC
;    3177 		
;    3178 	for (n=0; n<BPB_BytsPerSec; n++)
_0x338:
	__GETWRN 16,17,0
_0x33A:
	__CPWRR 16,17,6,7
	BRSH _0x33B
;    3179 		rp->buff[n] = _FF_buff[n];
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ADIW R30,28
	ADD  R30,R16
	ADC  R31,R17
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x72
	POP  R26
	POP  R27
	ST   X,R30
;    3180     
;    3181     if ((rp->EOF_flag == 1) && (length_check == 0))
	__ADDWRN 16,17,1
	RJMP _0x33A
_0x33B:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SUBI R26,LOW(-550)
	SBCI R27,HIGH(-550)
	LD   R26,X
	CPI  R26,LOW(0x1)
	BRNE _0x33D
	__GETD2S 8
	CALL __CPD02
	BREQ _0x33E
_0x33D:
	RJMP _0x33C
_0x33E:
;    3182     	rp->pntr = &rp->buff[BPB_BytsPerSec-1];
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	CALL SUBOPT_0x87
	__PUTW1SN 17,551
;    3183 	rp->pntr = &rp->buff[length_check];
_0x33C:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,28
	__GETD1S 8
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1SN 17,551
;    3184 	rp->position = off_set;
	__GETD1S 13
	__PUTD1SN 17,544
;    3185 		
;    3186 	return (0);	
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x3DC:
	CALL __LOADLOCR4
	ADIW R28,19
	RET
;    3187 }
;    3188 
;    3189 // Return the current position of the file rp with respect to the begining of the file
;    3190 long ftell(FILE *rp)
;    3191 {
;    3192 	if (rp==NULL)
;    3193 		return (EOF);
;    3194 	else
;    3195 		return (rp->position);
;    3196 }
;    3197 
;    3198 // Funtion that returns a '1' for @EOF, '0' otherwise
;    3199 int feof(FILE *rp)
;    3200 {
;    3201 	if (rp==NULL)
;    3202 		return (EOF);
;    3203 	
;    3204 	if (rp->length==rp->position)
;    3205 		return (1);
;    3206 	else
;    3207 		return (0);
;    3208 }
;    3209 		
;    3210 void dump_file_data_hex(FILE *rp)
;    3211 {
;    3212 	unsigned int n, c;
;    3213 	
;    3214 	if (rp==NULL)
;	*rp -> Y+4
;	n -> R16,R17
;	c -> R18,R19
;    3215 		return;
;    3216 
;    3217 	for (n=0; n<0x20; n++)
;    3218 	{   
;    3219 		printf("\n\r");
;    3220 		for (c=0; c<0x10; c++)
;    3221 			printf("%02X ", rp->buff[(n*0x20)+c]);
;    3222 	}
;    3223 }
;    3224 
;    3225 void dump_file_data_view(FILE *rp)
;    3226 {
;    3227 	unsigned int n;
;    3228 	
;    3229 	if (rp==NULL)
;	*rp -> Y+2
;	n -> R16,R17
;    3230 		return;
;    3231 
;    3232 	printf("\n\r");
;    3233 	for (n=0; n<512; n++)
;    3234 		putchar(rp->buff[n]);
;    3235 }
;    3236 
;    3237 
;    3238 #ifndef _UART_INT_
;    3239 	#define		rx_counter0		(UCSR0A & 0x80)
;    3240 	#define		tx_counter0		((!UCSR0A) & 0x40)
;    3241 	#define		rx_counter1		(UCSR1A & 0x80)
;    3242 	#define		tx_counter1		((!UCSR1A) & 0x40)
;    3243 #endif
;    3244 
;    3245 void port_init(void)
;    3246 {
_port_init:
;    3247 	PORTA = 0xFF;		DDRA  = 0x00;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
	LDI  R30,LOW(0)
	OUT  0x1A,R30
;    3248 	PORTB = 0xFF;		DDRB  = 0xD0;
	LDI  R30,LOW(255)
	OUT  0x18,R30
	LDI  R30,LOW(208)
	OUT  0x17,R30
;    3249 	PORTC = 0xFF; 		DDRC  = 0x00;	  //m103 output only
	LDI  R30,LOW(255)
	OUT  0x15,R30
	LDI  R30,LOW(0)
	OUT  0x14,R30
;    3250 	PORTD = 0xFF;		DDRD  = 0x00;
	LDI  R30,LOW(255)
	OUT  0x12,R30
	LDI  R30,LOW(0)
	OUT  0x11,R30
;    3251 	PORTE = 0xFF;		DDRE  = 0x00;
	LDI  R30,LOW(255)
	OUT  0x3,R30
	LDI  R30,LOW(0)
	OUT  0x2,R30
;    3252 	PORTF = 0xFF;		DDRF  = 0x00;
	LDI  R30,LOW(255)
	STS  0x62,R30
	LDI  R30,LOW(0)
	STS  0x61,R30
;    3253 	PORTG = 0x1F;		DDRG  = 0x00;
	LDI  R30,LOW(31)
	STS  0x65,R30
	LDI  R30,LOW(0)
	STS  0x64,R30
;    3254 }
	RET
;    3255 
;    3256 //UART0 initialisation
;    3257 // desired baud rate: 115200
;    3258 // actual: baud rate:115200 (0.0%)
;    3259 // char size: 8 bit
;    3260 // parity: Disabled
;    3261 void uart0_init(void)
;    3262 {
_uart0_init:
;    3263 	UCSR0B = 0x00; //disable while setting baud rate
	LDI  R30,LOW(0)
	OUT  0xA,R30
;    3264 	UCSR0A = 0x00;
	OUT  0xB,R30
;    3265 	UCSR0C = 0x06;
	LDI  R30,LOW(6)
	STS  0x95,R30
;    3266 	UBRR0L = 0x07; //set baud rate lo
	LDI  R30,LOW(7)
	OUT  0x9,R30
;    3267 	UBRR0H = 0x00; //set baud rate hi
	LDI  R30,LOW(0)
	STS  0x90,R30
;    3268 	UCSR0B = 0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
;    3269 }
	RET
;    3270 
;    3271 
;    3272 //UART1 initialisation
;    3273 // desired baud rate:115200
;    3274 // actual baud rate:115200 (0.0%)
;    3275 // char size: 8 bit
;    3276 // parity: Disabled
;    3277 void uart1_init(void)
;    3278 {
_uart1_init:
;    3279 	UCSR1B = 0x00; //disable while setting baud rate
	LDI  R30,LOW(0)
	STS  0x9A,R30
;    3280 	UCSR1A = 0x00;
	STS  0x9B,R30
;    3281 	UCSR1C = 0x06;
	LDI  R30,LOW(6)
	STS  0x9D,R30
;    3282 	UBRR1L = 0x07; //set baud rate lo
	LDI  R30,LOW(7)
	STS  0x99,R30
;    3283 	UBRR1H = 0x00; //set baud rate hi
	LDI  R30,LOW(0)
	STS  0x98,R30
;    3284 	UCSR1B = 0x18;
	LDI  R30,LOW(24)
	STS  0x9A,R30
;    3285 }
	RET
;    3286 
;    3287 
;    3288 //call this routine to initialise all peripherals
;    3289 void init_devices(void)
;    3290 {
_init_devices:
;    3291 	//stop errant interrupts until set up
;    3292 	CLI(); //disable all interrupts
	cli
;    3293 	XDIV  = 0x00; //xtal divider
	LDI  R30,LOW(0)
	OUT  0x3C,R30
;    3294 	XMCRA = 0x00; //external memory
	STS  0x6D,R30
;    3295 	port_init();
	CALL _port_init
;    3296 	uart0_init();
	CALL _uart0_init
;    3297 	uart1_init();
	CALL _uart1_init
;    3298 
;    3299 	MCUCR = 0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
;    3300 	EICRA = 0x00; //extended ext ints
	STS  0x6A,R30
;    3301 	EICRB = 0x00; //extended ext ints
	OUT  0x3A,R30
;    3302 	EIMSK = 0x00;
	OUT  0x39,R30
;    3303 	TIMSK = 0x00; //timer interrupt sources
	OUT  0x37,R30
;    3304 	ETIMSK = 0x00; //extended timer interrupt sources
	STS  0x7D,R30
;    3305 	SEI(); //re-enable interrupts
	sei
;    3306 	//all peripherals are now initialised
;    3307 }
	RET
;    3308 
;    3309 // Declare your global variables here
;    3310 extern unsigned char rtc_hour, rtc_min, rtc_sec;
;    3311 extern unsigned char rtc_date, rtc_month;
;    3312 extern unsigned int rtc_year;
;    3313 #ifdef _ICCAVR_
;    3314 extern char _bss_end;
;    3315 #endif
;    3316 
;    3317 
;    3318 void main(void)
;    3319 {
_main:
;    3320 	FILE *pntr1;
;    3321 	unsigned long c, n;
;    3322 
;    3323  	init_devices();
	SBIW R28,8
;	*pntr1 -> R16,R17
;	c -> Y+4
;	n -> Y+0
	CALL _init_devices
;    3324 
;    3325 	#ifdef _ICCAVR_
;    3326 		_NewHeap(&_bss_end + 1, &_bss_end + 1001);
;    3327 	#endif
;    3328 	
;    3329 	#ifdef _RTC_ON_
;    3330 		twi_setup();
;    3331 	#endif 
;    3332 
;    3333 
;    3334 	PORTB |= 0xD0;    
	IN   R30,0x18
	ORI  R30,LOW(0xD0)
	OUT  0x18,R30
;    3335 	
;    3336 	// initialize the Secure Digital card
;    3337 	while (initialize_media()==0)
_0x34F:
	CALL _initialize_media
	CPI  R30,0
	BRNE _0x351
;    3338 	{	// Blink LED while waiting to initialize
;    3339 		PORTB ^= 0x40;
	CALL SUBOPT_0x8D
;    3340 	}
	RJMP _0x34F
_0x351:
;    3341 	PORTB &= 0x5F;
	IN   R30,0x18
	ANDI R30,LOW(0x5F)
	OUT  0x18,R30
;    3342 
;    3343 	// Create File
;    3344 	
;    3345 	pntr1 = fcreatec("demo.dat", 0);
	__POINTW1FN _0,625
	CALL SUBOPT_0x8E
;    3346 	while (pntr1==0)
_0x352:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x354
;    3347 		pntr1 = fcreatec("demo.dat", 0);
	__POINTW1FN _0,625
	CALL SUBOPT_0x8E
;    3348 
;    3349 	// Write to file
;    3350 	#ifdef _RTC_ON_
;    3351 		// if real time clock enabled, get and print time and date to file
;    3352 		rtc_get_timeNdate(&rtc_hour, &rtc_min, &rtc_sec, &rtc_date, &rtc_month, (int *)&rtc_year);
;    3353 		fputc(0x22, pntr1);		// put a " in before time/date
;    3354 		if ((rtc_month/10)==0)
;    3355 			fputc('0', pntr1);
;    3356 		fprintf(pntr1, "%d/", rtc_month);
;    3357 		if ((rtc_date/10)==0)
;    3358 			fputc('0', pntr1);
;    3359 		fprintf(pntr1, "%d/", rtc_date);
;    3360 		fprintf(pntr1, "%d  ", rtc_year);
;    3361 		if ((rtc_hour/10)==0)
;    3362 			fputc('0', pntr1);
;    3363 		fprintf(pntr1, "%d:", rtc_hour);
;    3364 			if ((rtc_min/10)==0)
;    3365 			fputc('0', pntr1);
;    3366 		fprintf(pntr1, "%d:", rtc_min);
;    3367 		if ((rtc_sec/10)==0)
;    3368 			fputc('0', pntr1);
;    3369 		fprintf(pntr1, "%d", rtc_sec);
;    3370 		fputc(0x22, pntr1);	    // put a " in after time/date
;    3371 		fputsc("", pntr1);
;    3372 	#endif
;    3373 	
;    3374 	#ifdef _CVAVR_
;    3375 	fprintf(pntr1, "Column %d, Column %d, Column %d, Column %d, Column %d, Column %d, Column %d, Column %d, Column %d, Column %d,\r\n",
	RJMP _0x352
_0x354:
;    3376 		0, 1, 2, 3, 4, 5, 6, 7, 8, 9);
	ST   -Y,R17
	ST   -Y,R16
	__POINTW1FN _0,634
	CALL SUBOPT_0x70
	__GETD1N 0x1
	CALL __PUTPARD1
	__GETD1N 0x2
	CALL __PUTPARD1
	__GETD1N 0x3
	CALL __PUTPARD1
	__GETD1N 0x4
	CALL __PUTPARD1
	__GETD1N 0x5
	CALL __PUTPARD1
	__GETD1N 0x6
	CALL __PUTPARD1
	__GETD1N 0x7
	CALL __PUTPARD1
	__GETD1N 0x8
	CALL __PUTPARD1
	__GETD1N 0x9
	CALL __PUTPARD1
	LDI  R24,40
	CALL _fprintf
	ADIW R28,44
;    3377 	#endif
;    3378 	#ifdef _ICCAVR_
;    3379 	fputsc("Column 0, Column 1, Column 2, Column 3, Column 4, Column 5, Column 6, Column 7, Column 8, Column 9,", pntr1);
;    3380 	#endif
;    3381 	
;    3382 	
;    3383 	for (c=0; c<100; c++)
	__CLRD1S 4
_0x356:
	__GETD2S 4
	__CPD2N 0x64
	BRLO PC+3
	JMP _0x357
;    3384 	{	// print numbers separated by commas
;    3385 		for (n=0; n<10; n++)
	__CLRD1S 0
_0x359:
	__GETD2S 0
	__CPD2N 0xA
	BRSH _0x35A
;    3386 			fprintf(pntr1, "%ld, ", (((long)c*10)+(long)n));
	ST   -Y,R17
	ST   -Y,R16
	__POINTW1FN _0,746
	ST   -Y,R31
	ST   -Y,R30
	__GETD2S 8
	__GETD1N 0xA
	CALL __MULD12
	__GETD2S 4
	CALL __ADDD12
	CALL __PUTPARD1
	LDI  R24,4
	CALL _fprintf
	ADIW R28,8
;    3387 		if (fputc('\r', pntr1)==EOF)
	__GETD1S 0
	__SUBD1N -1
	__PUTD1S 0
	RJMP _0x359
_0x35A:
	LDI  R30,LOW(13)
	CALL SUBOPT_0x8F
	BREQ _0x357
;    3388 			break;			// line feed/carriage return
;    3389 		if (fputc('\n', pntr1)==EOF)
	LDI  R30,LOW(10)
	CALL SUBOPT_0x8F
	BREQ _0x357
;    3390 			break;			// line feed/carriage return
;    3391 		PORTB ^= 0x40;
	CALL SUBOPT_0x8D
;    3392 		PORTB ^= 0x80;
	CALL SUBOPT_0x90
;    3393 	}
	CALL SUBOPT_0x91
	RJMP _0x356
_0x357:
;    3394 
;    3395 	fclose(pntr1);
	ST   -Y,R17
	ST   -Y,R16
	CALL _fclose
;    3396 
;    3397 	printf("\r\n\r\nDONE!!!");
	__POINTW1FN _0,752
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;    3398 	PORTB &= 0xBF;	// Keep LED on when done
	CBI  0x18,6
;    3399 	while (1)
_0x35D:
;    3400 	{	// Blink LED when done
;    3401 		PORTB ^= 0x80;
	CALL SUBOPT_0x90
;    3402 		for (c=0; c<100000; c++)
	__CLRD1S 4
_0x361:
	__GETD2S 4
	__CPD2N 0x186A0
	BRSH _0x362
;    3403 			;
	CALL SUBOPT_0x91
	RJMP _0x361
_0x362:
;    3404 	};
	RJMP _0x35D
;    3405 }
	ADIW R28,8
_0x363:
	RJMP _0x363

_getchar:
     sbis usr,rxc
     rjmp _getchar
     in   r26,udr
	RET
_putchar:
     sbis usr,udre
     rjmp _putchar
     ld   r26,y
     out  udr,r26
	ADIW R28,1
	RET
__put_G2:
	put:
	LD   R26,Y
	LDD  R27,Y+1
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x364
	CALL __GETW1P
	ADIW R30,1
	ST   X+,R30
	ST   X,R31
	SBIW R30,1
	LDD  R26,Y+2
	STD  Z+0,R26
	RJMP _0x365
_0x364:
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _putchar
_0x365:
	ADIW R28,3
	RET
__print_G2:
	SBIW R28,11
	CALL __SAVELOCR6
	LDI  R16,0
_0x366:
	RCALL SUBOPT_0x1D
	SBIW R30,1
	LPM  R30,Z
	MOV  R19,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x368
	MOV  R30,R16
	CPI  R30,0
	BRNE _0x36C
	CPI  R19,37
	BRNE _0x36D
	LDI  R16,LOW(1)
	RJMP _0x36E
_0x36D:
	RCALL SUBOPT_0x92
_0x36E:
	RJMP _0x36B
_0x36C:
	CPI  R30,LOW(0x1)
	BRNE _0x36F
	CPI  R19,37
	BRNE _0x370
	RCALL SUBOPT_0x92
	LDI  R16,LOW(0)
	RJMP _0x36B
_0x370:
	LDI  R16,LOW(2)
	LDI  R21,LOW(0)
	LDI  R17,LOW(0)
	CPI  R19,45
	BRNE _0x371
	LDI  R17,LOW(1)
	RJMP _0x36B
_0x371:
	CPI  R19,43
	BRNE _0x372
	LDI  R21,LOW(43)
	RJMP _0x36B
_0x372:
	CPI  R19,32
	BRNE _0x373
	LDI  R21,LOW(32)
	RJMP _0x36B
_0x373:
	RJMP _0x374
_0x36F:
	CPI  R30,LOW(0x2)
	BRNE _0x375
_0x374:
	LDI  R20,LOW(0)
	LDI  R16,LOW(3)
	CPI  R19,48
	BRNE _0x376
	ORI  R17,LOW(128)
	RJMP _0x36B
_0x376:
	RJMP _0x377
_0x375:
	CPI  R30,LOW(0x3)
	BRNE _0x378
_0x377:
	CPI  R19,48
	BRLO _0x37A
	CPI  R19,58
	BRLO _0x37B
_0x37A:
	RJMP _0x379
_0x37B:
	MOV  R26,R20
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOV  R30,R0
	MOV  R20,R30
	MOV  R30,R19
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x36B
_0x379:
	CPI  R19,108
	BRNE _0x37C
	ORI  R17,LOW(2)
	LDI  R16,LOW(5)
	RJMP _0x36B
_0x37C:
	RJMP _0x37D
_0x378:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x36B
_0x37D:
	MOV  R30,R19
	CPI  R30,LOW(0x63)
	BRNE _0x382
	RCALL SUBOPT_0x93
	LD   R30,X
	RCALL SUBOPT_0x94
	RJMP _0x383
_0x382:
	CPI  R30,LOW(0x73)
	BRNE _0x385
	RCALL SUBOPT_0x93
	RCALL SUBOPT_0x95
	CALL _strlen
	MOV  R16,R30
	RJMP _0x386
_0x385:
	CPI  R30,LOW(0x70)
	BRNE _0x388
	RCALL SUBOPT_0x93
	RCALL SUBOPT_0x95
	CALL _strlenf
	MOV  R16,R30
	ORI  R17,LOW(8)
_0x386:
	ANDI R17,LOW(127)
	LDI  R30,LOW(0)
	STD  Y+16,R30
	LDI  R18,LOW(0)
	RJMP _0x389
_0x388:
	CPI  R30,LOW(0x64)
	BREQ _0x38C
	CPI  R30,LOW(0x69)
	BRNE _0x38D
_0x38C:
	ORI  R17,LOW(4)
	RJMP _0x38E
_0x38D:
	CPI  R30,LOW(0x75)
	BRNE _0x38F
_0x38E:
	LDI  R30,LOW(10)
	STD  Y+16,R30
	SBRS R17,1
	RJMP _0x390
	__GETD1N 0x3B9ACA00
	__PUTD1S 8
	LDI  R16,LOW(10)
	RJMP _0x391
_0x390:
	__GETD1N 0x2710
	__PUTD1S 8
	LDI  R16,LOW(5)
	RJMP _0x391
_0x38F:
	CPI  R30,LOW(0x58)
	BRNE _0x393
	ORI  R17,LOW(8)
	RJMP _0x394
_0x393:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x3C7
_0x394:
	LDI  R30,LOW(16)
	STD  Y+16,R30
	SBRS R17,1
	RJMP _0x396
	__GETD1N 0x10000000
	__PUTD1S 8
	LDI  R16,LOW(8)
	RJMP _0x391
_0x396:
	__GETD1N 0x1000
	__PUTD1S 8
	LDI  R16,LOW(4)
_0x391:
	SBRS R17,1
	RJMP _0x397
	RCALL SUBOPT_0x93
	CALL __GETD1P
	__PUTD1S 12
	RJMP _0x398
_0x397:
	SBRS R17,2
	RJMP _0x399
	RCALL SUBOPT_0x93
	CALL __GETW1P
	CALL __CWD1
	RJMP _0x3F6
_0x399:
	RCALL SUBOPT_0x93
	CALL __GETW1P
	CLR  R22
	CLR  R23
_0x3F6:
	__PUTD1S 12
_0x398:
	SBRS R17,2
	RJMP _0x39B
	__GETD2S 12
	CALL __CPD20
	BRGE _0x39C
	__GETD1S 12
	CALL __ANEGD1
	__PUTD1S 12
	LDI  R21,LOW(45)
_0x39C:
	CPI  R21,0
	BREQ _0x39D
	SUBI R16,-LOW(1)
	RJMP _0x39E
_0x39D:
	ANDI R17,LOW(251)
_0x39E:
_0x39B:
_0x389:
	SBRC R17,0
	RJMP _0x39F
_0x3A0:
	CP   R16,R20
	BRSH _0x3A2
	SBRS R17,7
	RJMP _0x3A3
	SBRS R17,2
	RJMP _0x3A4
	ANDI R17,LOW(251)
	MOV  R19,R21
	SUBI R16,LOW(1)
	RJMP _0x3A5
_0x3A4:
	LDI  R19,LOW(48)
_0x3A5:
	RJMP _0x3A6
_0x3A3:
	LDI  R19,LOW(32)
_0x3A6:
	RCALL SUBOPT_0x92
	SUBI R20,LOW(1)
	RJMP _0x3A0
_0x3A2:
_0x39F:
	MOV  R18,R16
	LDD  R30,Y+16
	CPI  R30,0
	BRNE _0x3A7
_0x3A8:
	CPI  R18,0
	BREQ _0x3AA
	SBRS R17,3
	RJMP _0x3AB
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBIW R30,1
	LPM  R30,Z
	RJMP _0x3F7
_0x3AB:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R30,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x3F7:
	ST   -Y,R30
	RCALL SUBOPT_0x96
	CPI  R20,0
	BREQ _0x3AD
	SUBI R20,LOW(1)
_0x3AD:
	SUBI R18,LOW(1)
	RJMP _0x3A8
_0x3AA:
	RJMP _0x3AE
_0x3A7:
_0x3B0:
	__GETD1S 8
	__GETD2S 12
	CALL __DIVD21U
	MOV  R19,R30
	LDI  R30,LOW(9)
	CP   R30,R19
	BRSH _0x3B2
	SBRS R17,3
	RJMP _0x3B3
	SUBI R19,-LOW(55)
	RJMP _0x3B4
_0x3B3:
	SUBI R19,-LOW(87)
_0x3B4:
	RJMP _0x3B5
_0x3B2:
	SUBI R19,-LOW(48)
_0x3B5:
	SBRC R17,4
	RJMP _0x3B7
	LDI  R30,LOW(48)
	CP   R30,R19
	BRLO _0x3B9
	__GETD2S 8
	__CPD2N 0x1
	BRNE _0x3B8
_0x3B9:
	RJMP _0x3BB
_0x3B8:
	CP   R20,R18
	BRLO _0x3BD
	SBRS R17,0
	RJMP _0x3BE
_0x3BD:
	RJMP _0x3BC
_0x3BE:
	LDI  R19,LOW(32)
	SBRS R17,7
	RJMP _0x3BF
	LDI  R19,LOW(48)
_0x3BB:
	ORI  R17,LOW(16)
	SBRS R17,2
	RJMP _0x3C0
	ANDI R17,LOW(251)
	ST   -Y,R21
	RCALL SUBOPT_0x96
	CPI  R20,0
	BREQ _0x3C1
	SUBI R20,LOW(1)
_0x3C1:
_0x3C0:
_0x3BF:
_0x3B7:
	RCALL SUBOPT_0x92
	CPI  R20,0
	BREQ _0x3C2
	SUBI R20,LOW(1)
_0x3C2:
_0x3BC:
	SUBI R18,LOW(1)
	__GETD1S 8
	__GETD2S 12
	CALL __MODD21U
	__PUTD1S 12
	LDD  R30,Y+16
	__GETD2S 8
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	__PUTD1S 8
	CALL __CPD10
	BREQ _0x3B1
	RJMP _0x3B0
_0x3B1:
_0x3AE:
	SBRS R17,0
	RJMP _0x3C3
_0x3C4:
	CPI  R20,0
	BREQ _0x3C6
	SUBI R20,LOW(1)
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x94
	RJMP _0x3C4
_0x3C6:
_0x3C3:
_0x3C7:
_0x383:
	LDI  R16,LOW(0)
_0x36B:
	RJMP _0x366
_0x368:
	CALL __LOADLOCR6
	ADIW R28,23
	RET
_vsprintf:
	SBIW R28,2
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   Y,R30
	STD  Y+1,R31
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G2
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(0)
	ST   X,R30
	ADIW R28,8
	RET
_printf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,2
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	CALL __ADDW2R15
	__PUTW2R 16,17
	LDI  R30,0
	STD  Y+2,R30
	STD  Y+2+1,R30
	MOVW R26,R28
	ADIW R26,4
	RCALL SUBOPT_0x8A
	ST   -Y,R17
	ST   -Y,R16
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G2
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	POP  R15
	RET
_allocate_block_G3:
	SBIW R28,2
	CALL __SAVELOCR6
	__GETWRN 16,17,2084
	__GETW2R 16,17
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x3C8:
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x3CA
	__GETW2R 16,17
	CALL __GETW1P
	ADD  R30,R16
	ADC  R31,R17
	ADIW R30,4
	__PUTW1R 20,21
	RCALL SUBOPT_0x97
	SBIW R30,0
	BREQ _0x3CB
	__PUTWSR 18,19,6
	RJMP _0x3CC
_0x3CB:
	LDI  R30,LOW(4352)
	LDI  R31,HIGH(4352)
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x3CC:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SUB  R30,R20
	SBC  R31,R21
	MOVW R26,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,4
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x3CD
	__GETW1R 20,21
	__PUTW1RNS 16,2
	__GETW1R 18,19
	__PUTW1RNS 20,2
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	__GETW2R 20,21
	ST   X+,R30
	ST   X,R31
	__ADDWRN 20,21,4
	__GETW1R 20,21
	RJMP _0x3DB
_0x3CD:
	__MOVEWRR 16,17,18,19
	RJMP _0x3C8
_0x3CA:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x3DB:
	CALL __LOADLOCR6
	ADIW R28,10
	RET
_find_prev_block_G3:
	CALL __SAVELOCR4
	__GETWRN 16,17,2084
_0x3CE:
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x3D0
	RCALL SUBOPT_0x97
	MOVW R26,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x3D1
	__GETW1R 16,17
	RJMP _0x3DA
_0x3D1:
	__MOVEWRR 16,17,18,19
	RJMP _0x3CE
_0x3D0:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x3DA:
	CALL __LOADLOCR4
	ADIW R28,6
	RET
_realloc:
	SBIW R28,2
	CALL __SAVELOCR6
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SBIW R30,0
	BRNE PC+3
	JMP _0x3D2
	SBIW R30,4
	__PUTW1R 16,17
	ST   -Y,R17
	ST   -Y,R16
	RCALL _find_prev_block_G3
	__PUTW1R 18,19
	SBIW R30,0
	BREQ _0x3D3
	__GETW2R 16,17
	ADIW R26,2
	CALL __GETW1P
	__PUTW1RNS 18,2
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SBIW R30,0
	BREQ _0x3D4
	ST   -Y,R31
	ST   -Y,R30
	RCALL _allocate_block_G3
	__PUTW1R 20,21
	SBIW R30,0
	BREQ _0x3D5
	__GETW2R 16,17
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	MOVW R26,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x3D6
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	STD  Y+8,R30
	STD  Y+8+1,R31
_0x3D6:
	ST   -Y,R21
	ST   -Y,R20
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _memmove
	__GETW1R 20,21
	RJMP _0x3D9
_0x3D5:
	__GETW1R 16,17
	__PUTW1RNS 18,2
_0x3D4:
_0x3D3:
_0x3D2:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x3D9:
	CALL __LOADLOCR6
	ADIW R28,12
	RET
_malloc:
	ST   -Y,R17
	ST   -Y,R16
	__GETWRN 16,17,0
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,0
	BREQ _0x3D7
	ST   -Y,R31
	ST   -Y,R30
	RCALL _allocate_block_G3
	__PUTW1R 16,17
	SBIW R30,0
	BREQ _0x3D8
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
_0x3D8:
_0x3D7:
	__GETW1R 16,17
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
_free:
	LD   R30,Y
	LDD  R31,Y+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _realloc
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x0:
	CALL __FF_spi
	LDD  R26,Y+14
	CLR  R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1:
	ADD  R30,R26
	ADC  R31,R27
	CALL __GETW1PF
	__PUTW1R 18,19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2:
	CALL __LSRD12
	MOV  R16,R30
	ST   -Y,R16
	CALL __FF_spi
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3:
	MOV  R16,R30
	ST   -Y,R16
	JMP  __FF_spi

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0x4:
	CALL __FF_spi
	LDI  R30,LOW(255)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES
SUBOPT_0x5:
	LDI  R30,LOW(255)
	ST   -Y,R30
	JMP  __FF_spi

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x6:
	CLR  R31
	CLR  R22
	CLR  R23
	__PUTD1S 6
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x7:
	CLR  R31
	CLR  R22
	CLR  R23
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x8:
	LDS  R26,_OCR_REG
	LDS  R27,_OCR_REG+1
	LDS  R24,_OCR_REG+2
	LDS  R25,_OCR_REG+3
	CALL __ORD12
	STS  _OCR_REG,R30
	STS  _OCR_REG+1,R31
	STS  _OCR_REG+2,R22
	STS  _OCR_REG+3,R23
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x9:
	LDI  R30,LOW(255)
	ST   -Y,R30
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xA:
	LDI  R30,LOW(80)
	OUT  0xD,R30
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0xB:
	__GETD1S 1
	__SUBD1N -1
	__PUTD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES
SUBOPT_0xC:
	CALL __PUTPARD1
	CALL __FF_read
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xD:
	RCALL _printf
	ADIW R28,2
	LDI  R30,LOW(1)
	STS  __FF_error,R30
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0xE:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	__GETW1R 6,7
	CLR  R22
	CLR  R23
	CALL __MULD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xF:
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	CLR  R22
	CLR  R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x10:
	CLR  R31
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(24)
	CALL __LSLD12
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x11:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __LSLD16
	CALL __ORD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x12:
	CLR  R31
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(8)
	CALL __LSLD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x13:
	SBIW R30,1
	MOVW R26,R30
	__GETW1R 6,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x14:
	CLR  R22
	CLR  R23
	CALL __SWAPD12
	CALL __SUBD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x15:
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	CALL _send_cmd
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x16:
	LDI  R30,LOW(80)
	OUT  0xD,R30
	LDI  R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x17:
	__GETW1R 6,7
	__GETD2S 5
	CLR  R22
	CLR  R23
	CALL __MODD21U
	CALL __CPD10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x18:
	LDI  R30,LOW(4)
	STS  __FF_error,R30
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x19:
	ST   -Y,R30
	__GETD1S 6
	CALL __PUTPARD1
	CALL _send_cmd
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1A:
	LDI  R30,LOW(3)
	STS  __FF_error,R30
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x1B:
	LD   R30,X
	ST   -Y,R30
	CALL _valid_file_char
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1C:
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	ADIW R30,1
	STD  Y+31,R30
	STD  Y+31+1,R31
	SBIW R30,1
	MOVW R26,R28
	ADIW R26,6
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(32)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1D:
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	ADIW R30,1
	STD  Y+21,R30
	STD  Y+21+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1E:
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	__GETD1N 0x0
	CALL __PUTDP1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1F:
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	ADIW R30,1
	STD  Y+31,R30
	STD  Y+31+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x20:
	__GETW1R 6,7
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	MOV  R30,R8
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __MULD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x21:
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	__GETW1R 6,7
	CLR  R22
	CLR  R23
	CALL __MULD12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x22:
	__GETW1R 20,21
	LSL  R30
	ROL  R31
	CALL __LSLW4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x23:
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1S 25
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x24:
	__GETD1S 25
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __PUTDP1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x25:
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+25
	LDD  R31,Y+25+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(11)
	ST   -Y,R30
	CALL _strncmp
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x26:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _next_cluster

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x27:
	CALL __MULD12
	LDS  R26,__FF_PART_ADDR
	LDS  R27,__FF_PART_ADDR+1
	LDS  R24,__FF_PART_ADDR+2
	LDS  R25,__FF_PART_ADDR+3
	CALL __ADDD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x28:
	__GETW1R 6,7
	LSR  R31
	ROR  R30
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x29:
	CALL __DIVW21U
	ADD  R30,R9
	ADC  R31,R10
	__PUTW1R 16,17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2A:
	CALL __MODW21U
	LSL  R30
	ROL  R31
	__PUTW1R 18,19
	__GETW1R 16,17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2B:
	LSL  R30
	ROL  R31
	MOV  R31,R30
	LDI  R30,0
	LDS  R26,__FF_PART_ADDR
	LDS  R27,__FF_PART_ADDR+1
	LDS  R24,__FF_PART_ADDR+2
	LDS  R25,__FF_PART_ADDR+3
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1S 6
	LDD  R26,Y+12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2C:
	LDS  R30,__FF_buff_addr
	LDS  R31,__FF_buff_addr+1
	LDS  R22,__FF_buff_addr+2
	LDS  R23,__FF_buff_addr+3
	__GETD2S 6
	CALL __CPD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x2D:
	LDS  R30,__FF_FAT2_ADDR
	LDS  R31,__FF_FAT2_ADDR+1
	LDS  R22,__FF_FAT2_ADDR+2
	LDS  R23,__FF_FAT2_ADDR+3
	LDS  R26,__FF_buff_addr
	LDS  R27,__FF_buff_addr+1
	LDS  R24,__FF_buff_addr+2
	LDS  R25,__FF_buff_addr+3
	CALL __CPD21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x2E:
	LDS  R26,__FF_FAT1_ADDR
	LDS  R27,__FF_FAT1_ADDR+1
	LDS  R24,__FF_FAT1_ADDR+2
	LDS  R25,__FF_FAT1_ADDR+3
	LDS  R30,__FF_FAT2_ADDR
	LDS  R31,__FF_FAT2_ADDR+1
	LDS  R22,__FF_FAT2_ADDR+2
	LDS  R23,__FF_FAT2_ADDR+3
	CALL __SUBD12
	LDS  R26,__FF_buff_addr
	LDS  R27,__FF_buff_addr+1
	LDS  R24,__FF_buff_addr+2
	LDS  R25,__FF_buff_addr+3
	CALL __ADDD12
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x2F:
	LDS  R30,__FF_buff_addr
	LDS  R31,__FF_buff_addr+1
	LDS  R22,__FF_buff_addr+2
	LDS  R23,__FF_buff_addr+3
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x30:
	__GETW1R 18,19
	ADIW R30,1
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	LD   R31,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x31:
	LDI  R26,LOW(__FF_buff)
	LDI  R27,HIGH(__FF_buff)
	ADD  R26,R18
	ADC  R27,R19
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x32:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __MULW12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x33:
	__GETW1R 6,7
	__GETW2R 18,19
	RJMP SUBOPT_0x29

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x34:
	__GETW1R 6,7
	__GETW2R 18,19
	CALL __MODW21U
	__PUTW1R 18,19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x35:
	__GETW1R 6,7
	SBIW R30,1
	CP   R30,R18
	CPC  R31,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x36:
	MOV  R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x37:
	LD   R30,X
	ST   -Y,R30
	JMP  _toupper

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x38:
	LDI  R31,0
	SUBI R30,LOW(-_FILENAME)
	SBCI R31,HIGH(-_FILENAME)
	MOVW R26,R30
	LDI  R30,LOW(32)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x39:
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	LD   R31,Z
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3A:
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	__GETD2S 9
	CLR  R22
	CLR  R23
	CALL __CPD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x3B:
	LDI  R30,LOW(13)
	STS  __FF_error,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x3C:
	__GETD1S 5
	__ADDD1N 512
	__PUTD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3D:
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ADIW R30,1
	STD  Y+15,R30
	STD  Y+15+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3E:
	__GETD2S 9
	CLR  R22
	CLR  R23
	CALL __ORD12
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3F:
	__GETW1R 6,7
	LSR  R31
	ROR  R30
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x40:
	__PUTD1S 11
	LDD  R26,Y+15
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x41:
	LDS  R30,__FF_buff_addr
	LDS  R31,__FF_buff_addr+1
	LDS  R22,__FF_buff_addr+2
	LDS  R23,__FF_buff_addr+3
	__GETD2S 11
	CALL __CPD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x42:
	__GETW1R 18,19
	ADIW R30,1
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x43:
	ST   X,R30
	LDD  R26,Y+15
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES
SUBOPT_0x44:
	LDS  R26,__FF_FAT1_ADDR
	LDS  R27,__FF_FAT1_ADDR+1
	LDS  R24,__FF_FAT1_ADDR+2
	LDS  R25,__FF_FAT1_ADDR+3
	LDS  R30,__FF_FAT2_ADDR
	LDS  R31,__FF_FAT2_ADDR+1
	LDS  R22,__FF_FAT2_ADDR+2
	LDS  R23,__FF_FAT2_ADDR+3
	CALL __SUBD12
	__GETD2S 11
	CALL __ADDD12
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES
SUBOPT_0x45:
	__GETD1S 11
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x46:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __MULW12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x47:
	ANDI R30,LOW(0xF)
	LDI  R31,0
	__PUTW1R 20,21
	__GETW1R 18,19
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x48:
	LDD  R30,Y+6
	SWAP R30
	ANDI R30,0xF0
	__GETW2R 20,21
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x49:
	__GETW1R 6,7
	__GETD2S 11
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1S 11
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4A:
	LDD  R30,Y+8
	SWAP R30
	ANDI R30,0xF0
	LDD  R26,Y+7
	OR   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4B:
	STS  __FF_buff,R30
	LDD  R26,Y+15
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4C:
	LDD  R30,Y+7
	SWAP R30
	ANDI R30,0xF0
	LDD  R26,Y+6
	OR   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4D:
	ANDI R30,LOW(0xF0)
	LDI  R31,0
	__PUTW1R 20,21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4E:
	LDD  R30,Y+8
	__GETW2R 20,21
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4F:
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	__GETD2Z 22
	CALL __PUTPARD2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x50:
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	ADIW R26,26
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x51:
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	ADIW R26,12
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x52:
	__GETD1S 7
	__ANDD1N 0xFF
	__GETW2R 17,18
	ST   X,R30
	__GETD2S 7
	LDI  R30,LOW(8)
	CALL __LSRD12
	__PUTD1S 7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x53:
	ST   -Y,R19
	ST   -Y,R18
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _next_cluster

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x54:
	ST   -Y,R19
	ST   -Y,R18
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x55:
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _write_clus_table
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x56:
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _write_clus_table
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x57:
	__GETW2R 18,19
	LD   R26,X
	CPI  R26,LOW(0x5C)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x58:
	__GETW2R 18,19
	LD   R30,X
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x59:
	__GETW2R 16,17
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5A:
	LSL  R30
	ROL  R31
	MOV  R31,R30
	LDI  R30,0
	LDS  R26,__FF_DIR_ADDR
	LDS  R27,__FF_DIR_ADDR+1
	LDS  R24,__FF_DIR_ADDR+2
	LDS  R25,__FF_DIR_ADDR+3
	CLR  R22
	CLR  R23
	CALL __ADDD12
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x5B:
	ADIW R30,11
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5C:
	ADIW R30,26
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	LD   R30,Z
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5D:
	SBIW R28,28
	CALL __SAVELOCR6
	__CLRD1S 12
	LDD  R30,Y+35
	LDD  R31,Y+35+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,14
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,24
	ST   -Y,R31
	ST   -Y,R30
	CALL __FF_checkdir
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES
SUBOPT_0x5E:
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5F:
	LDS  R30,__FF_DIR_ADDR
	LDS  R31,__FF_DIR_ADDR+1
	LDS  R22,__FF_DIR_ADDR+2
	LDS  R23,__FF_DIR_ADDR+3
	__PUTD1S 8
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,22
	ST   -Y,R31
	ST   -Y,R30
	CALL _scan_directory
	__PUTW1R 18,19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x60:
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x61:
	__GETW1R 6,7
	__GETD2S 8
	CLR  R22
	CLR  R23
	CALL __MODD21U
	__PUTW1R 20,21
	__GETW1R 20,21
	__GETD2S 8
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x62:
	__PUTD1S 8
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x63:
	MOVW R30,R28
	ADIW R30,20
	ST   -Y,R31
	ST   -Y,R30
	CALL _file_name_conversion
	STD  Y+16,R30
	STD  Y+16+1,R31
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0x64:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _free
	RJMP SUBOPT_0x5E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x65:
	__GETW1R 20,21
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	STD  Y+18,R30
	STD  Y+18+1,R31
	MOV  R0,R18
	OR   R0,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x66:
	LDI  R30,LOW(11)
	STS  __FF_error,R30
	RJMP SUBOPT_0x64

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x67:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,12
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x68:
	ADIW R26,18
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x69:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	__GETD1N 0x0
	CALL __PUTDP1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6A:
	__GETW1R 20,21
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	ADIW R30,31
	STD  Y+18,R30
	STD  Y+18+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6B:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	SBIW R26,1
	STD  Y+18,R26
	STD  Y+18+1,R27
	ADIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x6C:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	CALL __GETD1P
	CALL __CPD10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6D:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+12
	LDD  R27,Z+13
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES
SUBOPT_0x6E:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+14
	LDD  R27,Z+15
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x6F:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,20
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x70:
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x71:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,28
	ADD  R30,R16
	ADC  R31,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x72:
	LDI  R26,LOW(__FF_buff)
	LDI  R27,HIGH(__FF_buff)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x73:
	LDI  R30,LOW(5)
	STS  __FF_error,R30
	RJMP SUBOPT_0x5E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x74:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES
SUBOPT_0x75:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,1
	STD  Y+18,R26
	STD  Y+18+1,R27
	SBIW R26,1
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x76:
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x77:
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x78:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-548)
	SBCI R27,HIGH(-548)
	LD   R26,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x79:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,20
	CALL __GETW1P
	RJMP SUBOPT_0x13

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x7A:
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x7B:
	__GETW2R 16,17
	SUBI R26,LOW(-__FF_buff)
	SBCI R27,HIGH(-__FF_buff)
	RJMP SUBOPT_0x71

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x7C:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _append_toc
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x7D:
	SUBI R26,LOW(-548)
	SBCI R27,HIGH(-548)
	LD   R26,X
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x7E:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _prev_cluster

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x7F:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,16
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x80:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Z+16
	LDD  R27,Z+17
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0x81:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-544)
	SBCI R27,HIGH(-544)
	CALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES
SUBOPT_0x82:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	CALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x83:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-550)
	SBCI R27,HIGH(-550)
	LD   R30,X
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x84:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,14
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x85:
	SUBI R26,LOW(-550)
	SBCI R27,HIGH(-550)
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x86:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-551)
	SBCI R27,HIGH(-551)
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x87:
	ADIW R26,28
	__GETW1R 6,7
	SBIW R30,1
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x88:
	ADIW R26,20
	CALL __GETW1P
	ADIW R30,1
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x89:
	SUBI R26,LOW(-550)
	SBCI R27,HIGH(-550)
	LDI  R30,LOW(1)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x8A:
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x8B:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	CALL __GETD1P
	__GETD2S 13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x8C:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SUBI R26,LOW(-549)
	SBCI R27,HIGH(-549)
	LDI  R30,LOW(10)
	ST   X,R30
	STS  __FF_error,R30
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x8D:
	IN   R30,0x18
	LDI  R26,LOW(64)
	EOR  R30,R26
	OUT  0x18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x8E:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _fcreatec
	__PUTW1R 16,17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x8F:
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	CALL _fputc
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x90:
	IN   R30,0x18
	LDI  R26,LOW(128)
	EOR  R30,R26
	OUT  0x18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x91:
	__GETD1S 4
	__SUBD1N -1
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x92:
	ST   -Y,R19
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G2

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0x93:
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	SBIW R26,4
	STD  Y+19,R26
	STD  Y+19+1,R27
	ADIW R26,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x94:
	ST   -Y,R30
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x95:
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x96:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x97:
	__GETW2R 16,17
	ADIW R26,2
	CALL __GETW1P
	__PUTW1R 18,19
	RET

_memmove:
	ldd  r25,y+1
	ld   r24,y
	adiw r24,0
	breq __memmove3
	ldd  r27,y+5
	ldd  r26,y+4
	ldd  r31,y+3
	ldd  r30,y+2
	cp   r30,r26
	cpc  r31,r27
	breq __memmove3
	brlt __memmove1
__memmove0:
	ld   r22,z+
	st   x+,r22
	sbiw r24,1
	brne __memmove0
	rjmp __memmove3
__memmove1:
	add  r26,r24
	adc  r27,r25
	add  r30,r24
	adc  r31,r25
__memmove2:
	ld   r22,-z
	st   -x,r22
	sbiw r24,1
	brne __memmove2
__memmove3:
	ldd  r31,y+5
	ldd  r30,y+4
	adiw r28,6
	ret

_memset:
	ldd  r27,y+1
	ld   r26,y
	adiw r26,0
	breq __memset1
	ldd  r31,y+4
	ldd  r30,y+3
	ldd  r22,y+2
__memset0:
	st   z+,r22
	sbiw r26,1
	brne __memset0
__memset1:
	ldd  r30,y+3
	ldd  r31,y+4
	adiw r28,5
	ret

_strlen:
	ld   r26,y+
	ld   r27,y+
	clr  r30
	clr  r31
__strlen0:
	ld   r22,x+
	tst  r22
	breq __strlen1
	adiw r30,1
	rjmp __strlen0
__strlen1:
	ret

_strlenf:
	clr  r26
	clr  r27
	ld   r30,y+
	ld   r31,y+
__strlenf0:
	lpm  r0,z+
	tst  r0
	breq __strlenf1
	adiw r26,1
	rjmp __strlenf0
__strlenf1:
	movw r30,r26
	ret

_strncmp:
	clr  r22
	clr  r23
	ld   r24,y+
	ld   r30,y+
	ld   r31,y+
	ld   r26,y+
	ld   r27,y+
__strncmp0:
	tst  r24
	breq __strncmp1
	dec  r24
	ld   r22,x+
	ld   r23,z+
	cp   r22,r23
	brne __strncmp1
	tst  r22
	brne __strncmp0
__strncmp3:
	clr  r30
	ret
__strncmp1:
	sub  r22,r23
	breq __strncmp3
	ldi  r30,1
	brcc __strncmp2
	subi r30,2
__strncmp2:
	ret

_strrpos:
	ld   r22,y+
	ld   r26,y+
	ld   r27,y+
	ldi  r30,-1
	clr  r31
__strrpos0:
	ld   r23,x+
	cp   r22,r23
	brne __strrpos1
	mov  r30,r31
__strrpos1:
	inc  r31
	tst  r23
	brne __strrpos0
	ret

_toupper:
	ld   r30,y+
	cpi  r30,'a'
	brlo __toupper0
	cpi  r30,'z'+1
	brcc __toupper0
	subi r30,32
__toupper0:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__ADDD21:
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	RET

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__ORD12:
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	RET

__ANEGD1:
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSLD12R
__LSLD12L:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R0
	BRNE __LSLD12L
__LSLD12R:
	RET

__LSRD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSRD12R
__LSRD12L:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R0
	BRNE __LSRD12L
__LSRD12R:
	RET

__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__LSRW4:
	LSR  R31
	ROR  R30
__LSRW3:
	LSR  R31
	ROR  R30
__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__LSRD1:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	RET

__LSRD16:
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	RET

__LSLD16:
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R19
	CLR  R20
	LDI  R21,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R19
	ROL  R20
	SUB  R0,R30
	SBC  R1,R31
	SBC  R19,R22
	SBC  R20,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R19,R22
	ADC  R20,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R21
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOV  R24,R19
	MOV  R25,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__CPD20:
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
