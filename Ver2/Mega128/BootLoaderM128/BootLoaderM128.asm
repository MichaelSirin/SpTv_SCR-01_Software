;CodeVisionAVR C Compiler V1.24.5 Standard
;(C) Copyright 1998-2005 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;e-mail:office@hpinfotech.com

;Chip type              : ATmega128
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External SRAM size     : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : No
;char is unsigned       : Yes
;8 bit enums            : Yes
;Word align FLASH struct: No
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

	.INCLUDE "BootLoaderM128.vec"
	.INCLUDE "BootLoaderM128.inc"

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
	LDI  R24,LOW(0x1000)
	LDI  R25,HIGH(0x1000)
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
	LDI  R30,LOW(0x10FF)
	OUT  SPL,R30
	LDI  R30,HIGH(0x10FF)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x500)
	LDI  R29,HIGH(0x500)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500
;       1 /////////////////////////////////////////////////////////////////////////////////////////////
;       2 // Что касается "железа" I2CxCOM
;       3 #include "monitor.h"
;       4 
;       5 #define BAUD 38400		// Скорость обмена по COM-порту
;       6 const unsigned int scrambling_seed = 333;

	.CSEG
;       7 
;       8 void HardwareInit(void)
;       9 {
_HardwareInit:
;      10 	// Настраиваю UART
;      11 	UCSR0A = 0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
;      12 	UCSR0B = 0x010; //0x18;
	LDI  R30,LOW(16)
	OUT  0xA,R30
;      13 	UCSR0C = 0x06;
	LDI  R30,LOW(6)
	STS  0x95,R30
;      14 	UBRR0L = ((_MCU_CLOCK_FREQUENCY_ / (16 * BAUD)) - 1) & 0xFF;
	LDI  R30,LOW(12)
	OUT  0x9,R30
;      15 	UBRR0H = (((_MCU_CLOCK_FREQUENCY_ / (16 * BAUD)) - 1) >> 8) & 0xFF;
	LDI  R30,LOW(0)
	STS  0x90,R30
;      16 		
;      17 	// Запрещаю компаратор
;      18 	ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;      19 	SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
;      20 
;      21 	// Вотчдог
;      22 	WDTCR=0x1F;
	LDI  R30,LOW(31)
	OUT  0x21,R30
;      23 	WDTCR=0x0F;
	LDI  R30,LOW(15)
	OUT  0x21,R30
;      24 }
	RET
;      25 
;      26 #define USR  UCSR0A
;      27 #define UDRE (1 << 5)
;      28 #define UDR  UDR0
;      29 #define RXC  (1 << 7)
;      30 
;      31 // Передача байта в канал
;      32 inline void XmitChar(unsigned char byt)
;      33 {
;      34 	while(!(USR & UDRE));
;      35 	UDR = byt;
;      36 }
;      37 
;      38 // Наличие принятого байта
;      39 unsigned char HaveRxChar(void)
;      40 {
;      41 	return USR & RXC;
;      42 }
;      43 
;      44 // Прием байта из канала
;      45 inline unsigned char ReceiveChar(void)
;      46 {
;      47 	while(!HaveRxChar());
;      48 	return UDR;
;      49 }
;      50 ////////////////////////////////////////////////////////////////////////////////////////////
;      51 // Монитор - загрузчик FLASH и EEPROM
;      52 ////////////////////////////////////////////////////////////////////////////////////////////
;      53 #include "monitor.h"
;      54 
;      55 // Вернуть информацию о мониторе и процессоре
;      56 void PrgInfo(void)
;      57 {
_PrgInfo:
;      58 	// Проверяю завершение пакета
;      59 	if (!PackOk())
	CALL _PackOk
	CPI  R30,0
	BRNE _0x9
;      60 	{
;      61 		return;
	RET
;      62 	}
;      63 	
;      64 	// Отправляю ответ
;      65 	#asm("wdr");
_0x9:
	wdr
;      66 	ReplyStart(sizeof(RP_PRGINFO));
	LDI  R30,LOW(8)
	ST   -Y,R30
	CALL _ReplyStart
;      67 	#asm("wdr");
	wdr
;      68 	PutWord(PAGESIZ);
	CALL SUBOPT_0x0
;      69 	#asm("wdr");
	wdr
;      70 	PutWord(PRGPAGES);
	LDI  R30,LOW(504)
	LDI  R31,HIGH(504)
	ST   -Y,R31
	ST   -Y,R30
	CALL _PutWord
;      71 	#asm("wdr");
	wdr
;      72 	PutWord(EEPROMSIZ);
	LDI  R30,LOW(4096)
	LDI  R31,HIGH(4096)
	ST   -Y,R31
	ST   -Y,R30
	CALL _PutWord
;      73 	#asm("wdr");
	wdr
;      74 	PutWord(MONITORVERSION);
	CALL SUBOPT_0x0
;      75 	#asm("wdr");
	wdr
;      76 	ReplyEnd();
	CALL _ReplyEnd
;      77 
;      78 	// Перешел в режим программирования - теперь могу долго ждать очередной пакет
;      79 	prgmode = 1;
	SET
	BLD  R2,0
;      80 	
;      81 	// Обнуляю генератор дешифрующей последовательности
;      82 	ResetDescrambling();
	CALL _ResetDescrambling
;      83 }
	RET
;      84 
;      85 // Запись в EEPROM
;      86 void WriteEeprom(void)
;      87 {
_WriteEeprom:
;      88 	register unsigned short addr;
;      89 	register unsigned char  data;
;      90 
;      91 	DescrambleStart();
	CALL __SAVELOCR3
;	addr -> R16,R17
;	data -> R18
	SET
	BLD  R2,1
;      92 
;      93 	// Прием адреса и данных	
;      94 	#asm ("wdr");
	wdr
;      95 	addr = GetWord();
	CALL _GetWord
	__PUTW1R 16,17
;      96 	data = GetByte();
	CALL _GetByte
	MOV  R18,R30
;      97 	
;      98 	DescrambleStop();
	CLT
	BLD  R2,1
;      99 
;     100 	// Проверяю завершение и корректность пакета
;     101 	if (!PackOk() || (addr >= EEPROMSIZ))
	CALL _PackOk
	CPI  R30,0
	BREQ _0xB
	__CPWRN 16,17,4096
	BRLO _0xA
_0xB:
;     102 	{
;     103 		ReplyStart(1);
	CALL SUBOPT_0x1
;     104 		PutByte(RES_ERR);
;     105 		ReplyEnd();
;     106 		return;
	RJMP _0x22
;     107 	}
;     108 	
;     109 	// Пишу в EEPROM
;     110 	*((char eeprom *)addr) = data;
_0xA:
	MOV  R30,R18
	__GETW2R 16,17
	CALL __EEPROMWRB
;     111 	
;     112 	// Проверяю, записалось ли
;     113 	if (*((char eeprom *)addr) != data)
	__GETW2R 16,17
	CALL __EEPROMRDB
	CP   R18,R30
	BREQ _0xD
;     114 	{
;     115 		ReplyStart(1);
	CALL SUBOPT_0x1
;     116 		PutByte(RES_ERR);
;     117 		ReplyEnd();
;     118 		return;
_0x22:
	CALL __LOADLOCR3
	ADIW R28,3
	RET
;     119 	}
;     120 
;     121 	// Сигналю, что все в порядке 
;     122 	#asm ("wdr");
_0xD:
	wdr
;     123 	ReplyStart(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _ReplyStart
;     124 	PutByte(RES_OK);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _PutByte
;     125 	ReplyEnd();
	CALL _ReplyEnd
;     126 }
	CALL __LOADLOCR3
	ADIW R28,3
	RET
;     127 
;     128 // Чтение байта из FLASH по адресу
;     129 #ifdef USE_RAMPZ
;     130 	#pragma warn-
;     131 	unsigned char FlashByte(FADDRTYPE addr)
;     132 	{
_FlashByte:
;     133 	#asm
;     134 		ld		r30, y		; Загружаю Z
		ld		r30, y		; Загружаю Z
;     135 		ldd		r31, y+1
		ldd		r31, y+1
;     136 		in		r23, rampz	; Сохраняю RAMPZ
		in		r23, rampz	; Сохраняю RAMPZ
;     137 		ldd		r22, y+2	; Переношу RAMPZ
		ldd		r22, y+2	; Переношу RAMPZ
;     138 		out		rampz, r22
		out		rampz, r22
;     139 		elpm	r24, z		; Читаю FLASH
		elpm	r24, z		; Читаю FLASH
;     140 		out		rampz, r23	; Восстанавливаю RAMPZ
		out		rampz, r23	; Восстанавливаю RAMPZ
;     141 		mov		r30, r24	; Возвращаемое значение
		mov		r30, r24	; Возвращаемое значение
;     142 	#endasm
;     143 	}	
	ADIW R28,4
	RET
;     144 	#pragma warn+
;     145 #else
;     146 	#define FlashByte(a) (*((flash unsigned char *)a))
;     147 #endif
;     148 
;     149 // Проверка наличия "рабочей" программы
;     150 unsigned char AppOk(void)
;     151 {
_AppOk:
;     152 	FADDRTYPE addr, lastaddr;
;     153 	unsigned short crc, fcrc;
;     154 	
;     155 	#asm("wdr");
	SBIW R28,8
	CALL __SAVELOCR4
;	addr -> Y+8
;	lastaddr -> Y+4
;	crc -> R16,R17
;	fcrc -> R18,R19
	wdr
;     156 	
;     157 	lastaddr = ( (FADDRTYPE)FlashByte(PRGPAGES*PAGESIZ - 4) | 
;     158 	            ((FADDRTYPE)FlashByte(PRGPAGES*PAGESIZ - 3) << 8))
;     159 	            << (ZPAGEMSB + 1);
	__GETD1N 0x1F7FC
	RCALL SUBOPT_0x2
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1N 0x1F7FD
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ORD12
	RCALL SUBOPT_0x3
	__PUTD1S 4
;     160 	
;     161 	for (addr = 0, crc = 0; addr != lastaddr; addr ++)
	__CLRD1S 8
	__GETWRN 16,17,0
_0xF:
	__GETD1S 4
	__GETD2S 8
	CALL __CPD12
	BREQ _0x10
;     162 	{
;     163 		crc += FlashByte(addr);
	__GETD1S 8
	CALL __PUTPARD1
	CALL _FlashByte
	__GETW2R 16,17
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1R 16,17
;     164 	}
	__GETD1S 8
	__SUBD1N -1
	__PUTD1S 8
	RJMP _0xF
_0x10:
;     165 	
;     166 	#asm("wdr");
	wdr
;     167 	
;     168 	fcrc = 	 (unsigned short)FlashByte(PRGPAGES*PAGESIZ - 2) | 
;     169 			((unsigned short)FlashByte(PRGPAGES*PAGESIZ - 1) << 8);
	__GETD1N 0x1F7FE
	CALL __PUTPARD1
	CALL _FlashByte
	LDI  R31,0
	PUSH R31
	PUSH R30
	__GETD1N 0x1F7FF
	CALL __PUTPARD1
	CALL _FlashByte
	MOV  R31,R30
	LDI  R30,0
	POP  R26
	POP  R27
	OR   R30,R26
	OR   R31,R27
	__PUTW1R 18,19
;     170 	
;     171 	if (crc != fcrc)
	__CPWRR 18,19,16,17
	BREQ _0x11
;     172 	{
;     173 		return 0;
	LDI  R30,LOW(0)
	RJMP _0x21
;     174 	}
;     175 	
;     176 	return 1;
_0x11:
	LDI  R30,LOW(1)
_0x21:
	CALL __LOADLOCR4
	ADIW R28,12
	RET
;     177 }
;     178 
;     179 // Перезагрузка в рабочий режим
;     180 void RebootToWork(void)
;     181 {
_RebootToWork:
;     182 	// Проверяю, есть ли куда грузиться
;     183 	if (!AppOk())
	RCALL _AppOk
	CPI  R30,0
	BRNE _0x12
;     184 	{
;     185 		return;
	RET
;     186 	}
;     187 
;     188 	#asm("cli");
_0x12:
	cli
;     189 	IVCREG = 1 << IVCE;
	LDI  R30,LOW(1)
	OUT  0x35,R30
;     190 	IVCREG = 0;
	LDI  R30,LOW(0)
	OUT  0x35,R30
;     191 
;     192 	#asm("wdr");
	wdr
;     193 	#asm("rjmp 0");
	rjmp 0
;     194 }
	RET
;     195 
;     196 // Реакция на команду перейти в рабочий режим
;     197 void ToWorkMode(void)
;     198 {
_ToWorkMode:
;     199 	// Проверяю завершение пакета
;     200 	if (!PackOk())
	CALL _PackOk
	CPI  R30,0
	BRNE _0x13
;     201 	{
;     202 		return;
	RET
;     203 	}
;     204 	
;     205 	// Отправляю ответ
;     206 	ReplyStart(0);
_0x13:
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _ReplyStart
;     207 	ReplyEnd();
	CALL _ReplyEnd
;     208 
;     209 	prgmode = 0;
	CLT
	BLD  R2,0
;     210 	  
;     211 	// На перезагрузку
;     212 	RebootToWork();
	RCALL _RebootToWork
;     213 }
	RET
;     214 
;     215 void main(void)
;     216 {
_main:
;     217 	// Это был сброс по вотчдогу?
;     218 	if (MCUCSR & (1 << WDRF))
	IN   R30,0x34
	SBRS R30,3
	RJMP _0x14
;     219 	{
;     220 		MCUCSR &= (1 << WDRF) ^ 0xFF;
	IN   R30,0x34
	ANDI R30,0XF7
	OUT  0x34,R30
;     221 	
;     222 		// Если вылетел по вотчдогу - пытаюсь перегрузиться в рабочий режим	
;     223 		RebootToWork();
	RCALL _RebootToWork
;     224 	}
;     225 	
;     226 	// Настраиваю "железо"
;     227 	HardwareInit();
_0x14:
	CALL _HardwareInit
;     228 	
;     229 	// Ожидание, прием и исполнение команд
;     230 	while (1)
_0x15:
;     231 	{
;     232 		switch(Wait4Hdr())
	CALL _Wait4Hdr
;     233 		{
;     234 		case PT_PRGINFO:	// Вернуть информацию о мониторе и процессоре
	CPI  R30,LOW(0x8)
	BRNE _0x1B
;     235 			PrgInfo();
	CALL _PrgInfo
;     236 			break;
	RJMP _0x1A
;     237 		case PT_WRFLASH:	// Записать страницу FLASH
_0x1B:
	CPI  R30,LOW(0x9)
	BRNE _0x1C
;     238 			WriteFlash();
	CALL _WriteFlash
;     239 			break;
	RJMP _0x1A
;     240 		case PT_WREEPROM:	// Записать байт в EEPROM
_0x1C:
	CPI  R30,LOW(0xA)
	BRNE _0x1D
;     241 			WriteEeprom();
	CALL _WriteEeprom
;     242 			break;
	RJMP _0x1A
;     243 		case PT_TOWORK:		// Вернуться в режим работы
_0x1D:
	CPI  R30,LOW(0xB)
	BRNE _0x1F
;     244 			ToWorkMode();			
	RCALL _ToWorkMode
;     245 			break;
;     246 		default:
_0x1F:
;     247 			break;
;     248 		}
_0x1A:
;     249 	}
	RJMP _0x15
;     250 }
_0x20:
	RJMP _0x20


;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x0:
	LDI  R30,LOW(256)
	LDI  R31,HIGH(256)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _PutWord

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1:
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _ReplyStart
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _PutByte
	JMP  _ReplyEnd

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2:
	CALL __PUTPARD1
	CALL _FlashByte
	CLR  R31
	CLR  R22
	CLR  R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3:
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(8)
	CALL __LSLD12
	RET

__ORD12:
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
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

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIC EECR,EEWE
	RJMP __EEPROMWRB
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

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
