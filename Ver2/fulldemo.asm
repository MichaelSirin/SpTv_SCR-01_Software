;CodeVisionAVR C Compiler V1.24.7e Professional
;(C) Copyright 1998-2005 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega128
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
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

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

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

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM
	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM
	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM
	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM
	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM
	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
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

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
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

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	LDI  R22,BYTE3(2*@0+@1)
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

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+@3)
	LDI  R@1,HIGH(@2*2+@3)
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

	.MACRO __GETB1HMN
	LDS  R31,@0+@1
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
	LDS  R@0,@1+@2
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+@3
	LDS  R@1,@2+@3+1
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

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
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

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
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

	.INCLUDE "fulldemo.vec"
	.INCLUDE "fulldemo.inc"

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
;       2 Project : FlashFileSD
;       3 Version : 1.31 
;       4 Date    : 12/19/2003
;       5 Author  : Erick Higa       
;       6 Company : Progressive Resources LLC       
;       7 
;       8 Chip type           : ATmega128
;       9 Program type        : Application
;      10 Clock frequency     : 14.745600 MHz
;      11 Memory model        : Small
;      12 External SRAM size  : 0
;      13 Data Stack size     : 1024
;      14 
;      15 Comments:
;      16 The "fulldemo.c" file is an example of how the FlasFileSD
;      17 can be used.  It is setup to use an ATMega128 processor,
;      18 a 14.7456 MHz oscillator, with USART0 @ 115200 bps.
;      19 
;      20 See "file_sys.c" header for revision history
;      21 
;      22 Software License
;      23 The use of Progressive Resources LLC FlashFile Source Package indicates 
;      24 your understanding and acceptance of the following terms and conditions. 
;      25 This license shall supersede any verbal or prior verbal or written, statement 
;      26 or agreement to the contrary. If you do not understand or accept these terms, 
;      27 or your local regulations prohibit "after sale" license agreements or limited 
;      28 disclaimers, you must cease and desist using this product immediately.
;      29 This product is © Copyright 2003 by Progressive Resources LLC, all rights 
;      30 reserved. International copyright laws, international treaties and all other 
;      31 applicable national or international laws protect this product. This software 
;      32 product and documentation may not, in whole or in part, be copied, photocopied, 
;      33 translated, or reduced to any electronic medium or machine readable form, without 
;      34 prior consent in writing, from Progressive Resources LLC and according to all 
;      35 applicable laws. The sole owner of this product is Progressive Resources LLC.
;      36 
;      37 Operating License
;      38 You have the non-exclusive right to use any enclosed product but have no right 
;      39 to distribute it as a source code product without the express written permission 
;      40 of Progressive Resources LLC. Use over a "local area network" (within the same 
;      41 locale) is permitted provided that only a single person, on a single computer 
;      42 uses the product at a time. Use over a "wide area network" (outside the same 
;      43 locale) is strictly prohibited under any and all circumstances.
;      44                                            
;      45 Liability Disclaimer
;      46 This product and/or license is provided as is, without any representation or 
;      47 warranty of any kind, either express or implied, including without limitation 
;      48 any representations or endorsements regarding the use of, the results of, or 
;      49 performance of the product, Its appropriateness, accuracy, reliability, or 
;      50 correctness. The user and/or licensee assume the entire risk as to the use of 
;      51 this product. Progressive Resources LLC does not assume liability for the use 
;      52 of this product beyond the original purchase price of the software. In no event 
;      53 will Progressive Resources LLC be liable for additional direct or indirect 
;      54 damages including any lost profits, lost savings, or other incidental or 
;      55 consequential damages arising from any defects, or the use or inability to 
;      56 use these products, even if Progressive Resources LLC have been advised of 
;      57 the possibility of such damages.
;      58 *********************************************/
;      59 
;      60 #include <mega128.h>
;      61 
;      62 #define RXB8 1
;      63 #define TXB8 0
;      64 #define UPE 2
;      65 #define OVR 3
;      66 #define FE 4
;      67 #define UDRE 5
;      68 #define RXC 7
;      69 
;      70 #define FRAMING_ERROR (1<<FE)
;      71 #define PARITY_ERROR (1<<UPE)
;      72 #define DATA_OVERRUN (1<<OVR)
;      73 #define DATA_REGISTER_EMPTY (1<<UDRE)
;      74 #define RX_COMPLETE (1<<RXC)
;      75 
;      76 // Get a character from the USART0 Receiver
;      77 #ifndef _DEBUG_TERMINAL_IO_
;      78 #define _ALTERNATE_GETCHAR_
;      79 #pragma used+
;      80 char getchar(void)
;      81 {

	.CSEG
_getchar:
;      82 char status,data;
;      83 while (1)
	ST   -Y,R17
	ST   -Y,R16
;	status -> R16
;	data -> R17
_0x3:
;      84       {
;      85       while (((status=UCSR0A) & RX_COMPLETE)==0);
_0x6:
	IN   R30,0xB
	MOV  R16,R30
	ANDI R30,LOW(0x80)
	BREQ _0x6
;      86       data=UDR0;
	IN   R17,12
;      87       if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R16
	ANDI R30,LOW(0x1C)
	BRNE _0x9
;      88          return data;
	MOV  R30,R17
	RJMP _0x523
;      89       };
_0x9:
	RJMP _0x3
;      90 }
_0x523:
	LD   R16,Y+
	LD   R17,Y+
	RET
;      91 #pragma used-
;      92 #endif
;      93 
;      94 // Write a character to the USART0 Transmitter
;      95 #ifndef _DEBUG_TERMINAL_IO_
;      96 #define _ALTERNATE_PUTCHAR_
;      97 #pragma used+
;      98 void putchar(char c)
;      99 {
_putchar:
;     100 while ((UCSR0A & DATA_REGISTER_EMPTY)==0);
_0xA:
	SBIS 0xB,5
	RJMP _0xA
;     101 UDR0=c;
	LD   R30,Y
	OUT  0xC,R30
;     102 }
	RJMP _0x522
;     103 #pragma used-
;     104 #endif
;     105 
;     106 #include "options.h"
;     107 /*
;     108 	Progressive Resources LLC
;     109                                     
;     110 			FlashFile
;     111 	
;     112 	Version : 	1.32
;     113 	Date: 		12/31/2003
;     114 	Author: 	Erick M. Higa
;     115                                            
;     116 	Software License
;     117 	The use of Progressive Resources LLC FlashFile Source Package indicates 
;     118 	your understanding and acceptance of the following terms and conditions. 
;     119 	This license shall supersede any verbal or prior verbal or written, statement 
;     120 	or agreement to the contrary. If you do not understand or accept these terms, 
;     121 	or your local regulations prohibit "after sale" license agreements or limited 
;     122 	disclaimers, you must cease and desist using this product immediately.
;     123 	This product is © Copyright 2003 by Progressive Resources LLC, all rights 
;     124 	reserved. International copyright laws, international treaties and all other 
;     125 	applicable national or international laws protect this product. This software 
;     126 	product and documentation may not, in whole or in part, be copied, photocopied, 
;     127 	translated, or reduced to any electronic medium or machine readable form, without 
;     128 	prior consent in writing, from Progressive Resources LLC and according to all 
;     129 	applicable laws. The sole owner of this product is Progressive Resources LLC.
;     130 
;     131 	Operating License
;     132 	You have the non-exclusive right to use any enclosed product but have no right 
;     133 	to distribute it as a source code product without the express written permission 
;     134 	of Progressive Resources LLC. Use over a "local area network" (within the same 
;     135 	locale) is permitted provided that only a single person, on a single computer 
;     136 	uses the product at a time. Use over a "wide area network" (outside the same 
;     137 	locale) is strictly prohibited under any and all circumstances.
;     138                                            
;     139 	Liability Disclaimer
;     140 	This product and/or license is provided as is, without any representation or 
;     141 	warranty of any kind, either express or implied, including without limitation 
;     142 	any representations or endorsements regarding the use of, the results of, or 
;     143 	performance of the product, Its appropriateness, accuracy, reliability, or 
;     144 	correctness. The user and/or licensee assume the entire risk as to the use of 
;     145 	this product. Progressive Resources LLC does not assume liability for the use 
;     146 	of this product beyond the original purchase price of the software. In no event 
;     147 	will Progressive Resources LLC be liable for additional direct or indirect 
;     148 	damages including any lost profits, lost savings, or other incidental or 
;     149 	consequential damages arising from any defects, or the use or inability to 
;     150 	use these products, even if Progressive Resources LLC have been advised of 
;     151 	the possibility of such damages.
;     152 */                                 
;     153 
;     154 /*
;     155 #include _AVR_LIB_
;     156 #include <stdio.h>
;     157 
;     158 #ifndef _file_sys_h_
;     159 	#include "..\flash\file_sys.h"
;     160 #endif
;     161 */
;     162 
;     163 unsigned long OCR_REG;

	.DSEG
_OCR_REG:
	.BYTE 0x4
;     164 unsigned char _FF_buff[512];
__FF_buff:
	.BYTE 0x200
;     165 unsigned int PT_SecStart;
;     166 unsigned long BS_jmpBoot;
_BS_jmpBoot:
	.BYTE 0x4
;     167 unsigned int BPB_BytsPerSec;
;     168 unsigned char BPB_SecPerClus;
;     169 unsigned int BPB_RsvdSecCnt;
;     170 unsigned char BPB_NumFATs;
;     171 unsigned int BPB_RootEntCnt;
;     172 unsigned int BPB_FATSz16;
_BPB_FATSz16:
	.BYTE 0x2
;     173 unsigned char BPB_FATType;
;     174 unsigned long BPB_TotSec;
_BPB_TotSec:
	.BYTE 0x4
;     175 unsigned long BS_VolSerial;
_BS_VolSerial:
	.BYTE 0x4
;     176 unsigned char BS_VolLab[12];
_BS_VolLab:
	.BYTE 0xC
;     177 unsigned long _FF_PART_ADDR, _FF_ROOT_ADDR, _FF_DIR_ADDR;
__FF_PART_ADDR:
	.BYTE 0x4
__FF_ROOT_ADDR:
	.BYTE 0x4
__FF_DIR_ADDR:
	.BYTE 0x4
;     178 unsigned long _FF_FAT1_ADDR, _FF_FAT2_ADDR;
__FF_FAT1_ADDR:
	.BYTE 0x4
__FF_FAT2_ADDR:
	.BYTE 0x4
;     179 unsigned long _FF_RootDirSectors;
__FF_RootDirSectors:
	.BYTE 0x4
;     180 unsigned int FirstDataSector;
_FirstDataSector:
	.BYTE 0x2
;     181 unsigned long FirstSectorofCluster;
_FirstSectorofCluster:
	.BYTE 0x4
;     182 unsigned char _FF_error;
__FF_error:
	.BYTE 0x1
;     183 unsigned long _FF_buff_addr;
__FF_buff_addr:
	.BYTE 0x4
;     184 extern unsigned long clus_0_addr, _FF_n_temp;
;     185 extern unsigned int c_counter;
;     186 extern unsigned char _FF_FULL_PATH[_FF_PATH_LENGTH];
;     187 
;     188 unsigned long DataClusTot;
_DataClusTot:
	.BYTE 0x4
;     189 
;     190 flash struct CMD
;     191 {
;     192 	unsigned int index;
;     193 	unsigned int tx_data;
;     194 	unsigned int arg;
;     195 	unsigned int resp;
;     196 };
;     197 
;     198 flash struct CMD sd_cmd[CMD_TOT] =

	.CSEG
;     199 {
;     200 	{CMD0,	0x40,	NO_ARG,		RESP_1},		// GO_IDLE_STATE
;     201 	{CMD1,	0x41,	NO_ARG,		RESP_1},		// SEND_OP_COND (ACMD41 = 0x69)
;     202 	{CMD9,	0x49,	NO_ARG,		RESP_1},		// SEND_CSD
;     203 	{CMD10,	0x4A,	NO_ARG,		RESP_1},		// SEND_CID
;     204 	{CMD12,	0x4C,	NO_ARG,		RESP_1},		// STOP_TRANSMISSION
;     205 	{CMD13,	0x4D,	NO_ARG,		RESP_2},		// SEND_STATUS
;     206 	{CMD16,	0x50,	BLOCK_LEN,	RESP_1},		// SET_BLOCKLEN
;     207 	{CMD17, 0x51,	DATA_ADDR,	RESP_1},		// READ_SINGLE_BLOCK
;     208 	{CMD18, 0x52,	DATA_ADDR,	RESP_1},		// READ_MULTIPLE_BLOCK
;     209 	{CMD24, 0x58,	DATA_ADDR,	RESP_1},		// WRITE_BLOCK
;     210 	{CMD25, 0x59,	DATA_ADDR,	RESP_1},		// WRITE_MULTIPLE_BLOCK
;     211 	{CMD27,	0x5B,	NO_ARG,		RESP_1},		// PROGRAM_CSD
;     212 	{CMD28, 0x5C,	DATA_ADDR,	RESP_1b},		// SET_WRITE_PROT
;     213 	{CMD29, 0x5D,	DATA_ADDR,	RESP_1b},		// CLR_WRITE_PROT
;     214 	{CMD30, 0x5E,	DATA_ADDR,	RESP_1},		// SEND_WRITE_PROT
;     215 	{CMD32,	0x60,	DATA_ADDR,	RESP_1},		// TAG_SECTOR_START
;     216 	{CMD33,	0x61,	DATA_ADDR,	RESP_1},		// TAG_SECTOR_END
;     217 	{CMD34,	0x62,	DATA_ADDR,	RESP_1},		// UNTAG_SECTOR
;     218 	{CMD35,	0x63,	DATA_ADDR,	RESP_1},		// TAG_ERASE_GROUP_START
;     219 	{CMD36,	0x64,	DATA_ADDR,	RESP_1},		// TAG_ERASE_GROUP_END
;     220 	{CMD37,	0x65,	DATA_ADDR,	RESP_1},		// TAG_ERASE_GROUP
;     221 	{CMD38,	0x66,	STUFF_BITS,	RESP_1b},		// ERASE
;     222 	{CMD42,	0x6A,	STUFF_BITS,	RESP_1b},		// LOCK_UNLOCK
;     223 	{CMD58,	0x7A,	NO_ARG,		RESP_3},		// READ_OCR
;     224 	{CMD59,	0x7B,	STUFF_BITS,	RESP_1},		// CRC_ON_OFF
;     225 	{ACMD41, 0x69,	NO_ARG,		RESP_1}
;     226 };
;     227 
;     228 unsigned char _FF_spi(unsigned char mydata)
;     229 {
__FF_spi:
;     230     SPDR = mydata;          //byte 1
	LD   R30,Y
	OUT  0xF,R30
;     231     while ((SPSR&0x80) == 0); 
_0xD:
	SBIS 0xE,7
	RJMP _0xD
;     232     return SPDR;
	IN   R30,0xF
_0x522:
	ADIW R28,1
	RET
;     233 }
;     234 	
;     235 unsigned int send_cmd(unsigned char command, unsigned long argument)
;     236 {
_send_cmd:
;     237 	unsigned char spi_data_out;
;     238 	unsigned char response_1;
;     239 	unsigned long response_2;
;     240 	unsigned int c, i;
;     241 	
;     242 	SD_CS_ON();			// select chip
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
;     243 	
;     244 	spi_data_out = sd_cmd[command].tx_data;
	LDD  R26,Y+14
	CLR  R27
	__POINTWRFN 22,23,_sd_cmd,2
	CALL SUBOPT_0x0
	LPM  R16,Z
;     245 	_FF_spi(spi_data_out);
	ST   -Y,R16
	CALL SUBOPT_0x1
;     246 	
;     247 	c = sd_cmd[command].arg;
	__POINTWRFN 22,23,_sd_cmd,4
	CALL SUBOPT_0x0
	CALL __GETW1PF
	MOVW R18,R30
;     248 	if (c == NO_ARG)
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x10
;     249 		for (i=0; i<4; i++)
	__GETWRN 20,21,0
_0x12:
	__CPWRN 20,21,4
	BRSH _0x13
;     250 			_FF_spi(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL __FF_spi
;     251 	else
	__ADDWRN 20,21,1
	RJMP _0x12
_0x13:
	RJMP _0x14
_0x10:
;     252 	{
;     253 		spi_data_out = (argument & 0xFF000000) >> 24;
	__GETD1S 10
	__ANDD1N 0xFF000000
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(24)
	CALL SUBOPT_0x2
;     254 		_FF_spi(spi_data_out);
;     255 		spi_data_out = (argument & 0x00FF0000) >> 16;
	__ANDD1N 0xFF0000
	CALL __LSRD16
	CALL SUBOPT_0x3
;     256 		_FF_spi(spi_data_out);
;     257 		spi_data_out = (argument & 0x0000FF00) >> 8;
	__GETD1S 10
	__ANDD1N 0xFF00
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(8)
	CALL SUBOPT_0x2
;     258 		_FF_spi(spi_data_out);
;     259 		spi_data_out = (argument & 0x000000FF);
	__ANDD1N 0xFF
	CALL SUBOPT_0x3
;     260 		_FF_spi(spi_data_out);
;     261 	}
_0x14:
;     262 	if (command == CMD0)
	LDD  R30,Y+14
	CPI  R30,0
	BRNE _0x15
;     263 		spi_data_out = 0x95;		// CRC byte, don't care except for first signal=0x95
	LDI  R16,LOW(149)
;     264 	else
	RJMP _0x16
_0x15:
;     265 		spi_data_out = 0xFF;
	LDI  R16,LOW(255)
;     266 	_FF_spi(spi_data_out);
_0x16:
	ST   -Y,R16
	CALL SUBOPT_0x4
;     267 	_FF_spi(0xff);	
	CALL SUBOPT_0x1
;     268 	c = sd_cmd[command].resp;
	__POINTWRFN 22,23,_sd_cmd,6
	CALL SUBOPT_0x0
	CALL __GETW1PF
	MOVW R18,R30
;     269 	switch(c)
	MOVW R30,R18
;     270 	{
;     271 		case RESP_1:
	SBIW R30,0
	BRNE _0x1A
;     272 			return (_FF_spi(0xFF));
	CALL SUBOPT_0x5
	LDI  R31,0
	RJMP _0x521
;     273 			break;
;     274 		case RESP_1b:
_0x1A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1B
;     275 			response_1 = _FF_spi(0xFF);
	CALL SUBOPT_0x5
	MOV  R17,R30
;     276 			response_2 = 0;
	__CLRD1S 6
;     277 			while (response_2 == 0)
_0x1C:
	__GETD1S 6
	CALL __CPD10
	BRNE _0x1E
;     278 				response_2 = _FF_spi(0xFF);
	CALL SUBOPT_0x5
	CLR  R31
	CLR  R22
	CLR  R23
	__PUTD1S 6
;     279 			return (response_1);
	RJMP _0x1C
_0x1E:
	MOV  R30,R17
	LDI  R31,0
	RJMP _0x521
;     280 			break;
;     281 		case RESP_2:
_0x1B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1F
;     282 			response_2 = _FF_spi(0xFF);
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
;     283 			response_2 = (response_2 << 8) | _FF_spi(0xFF);
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
;     284 			return (response_2);
	RJMP _0x521
;     285 			break;
;     286 		case RESP_3:
_0x1F:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x19
;     287 			response_1 = _FF_spi(0xFF);
	CALL SUBOPT_0x5
	MOV  R17,R30
;     288 			OCR_REG = 0;
	LDI  R30,0
	STS  _OCR_REG,R30
	STS  _OCR_REG+1,R30
	STS  _OCR_REG+2,R30
	STS  _OCR_REG+3,R30
;     289 			response_2 = _FF_spi(0xFF);
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
;     290 			OCR_REG = response_2 << 24;
	LDI  R30,LOW(24)
	CALL __LSLD12
	STS  _OCR_REG,R30
	STS  _OCR_REG+1,R31
	STS  _OCR_REG+2,R22
	STS  _OCR_REG+3,R23
;     291 			response_2 = _FF_spi(0xFF);
	CALL SUBOPT_0x5
	CALL SUBOPT_0x7
;     292 			OCR_REG |= (response_2 << 16);
	CALL __LSLD16
	CALL SUBOPT_0x8
;     293 			response_2 = _FF_spi(0xFF);
	CALL SUBOPT_0x6
;     294 			OCR_REG |= (response_2 << 8);
	LDI  R30,LOW(8)
	CALL __LSLD12
	CALL SUBOPT_0x8
;     295 			response_2 = _FF_spi(0xFF);
	CALL SUBOPT_0x7
;     296 			OCR_REG |= (response_2);
	LDS  R26,_OCR_REG
	LDS  R27,_OCR_REG+1
	LDS  R24,_OCR_REG+2
	LDS  R25,_OCR_REG+3
	CALL __ORD12
	STS  _OCR_REG,R30
	STS  _OCR_REG+1,R31
	STS  _OCR_REG+2,R22
	STS  _OCR_REG+3,R23
;     297 			return (response_1);
	MOV  R30,R17
	LDI  R31,0
	RJMP _0x521
;     298 			break;
;     299 	}
_0x19:
;     300 	return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x521:
	CALL __LOADLOCR6
	ADIW R28,15
	RET
;     301 }
;     302 
;     303 void clear_sd_buff(void)
;     304 {
_clear_sd_buff:
;     305 	SD_CS_OFF();
	SBI  0x18,4
;     306 	_FF_spi(0xFF);
	CALL SUBOPT_0x9
;     307 	_FF_spi(0xFF);
	CALL __FF_spi
;     308 }	
	RET
;     309 
;     310 unsigned char initialize_media(void)
;     311 {
_initialize_media:
;     312 	unsigned char data_temp;
;     313 	unsigned long n;
;     314 	
;     315 	// SPI BUS SETUP
;     316 	// SPI initialization
;     317 	// SPI Type: Master
;     318 	// SPI Clock Rate: 921.600 kHz
;     319 	// SPI Clock Phase: Cycle Half
;     320 	// SPI Clock Polarity: Low
;     321 	// SPI Data Order: MSB First
;     322 	DDRB |= 0x07;		// Set SS, SCK, and MOSI to Output (If not output, processor will be a slave)
	SBIW R28,4
	ST   -Y,R16
;	data_temp -> R16
;	n -> Y+1
	IN   R30,0x17
	ORI  R30,LOW(0x7)
	OUT  0x17,R30
;     323 	DDRB &= 0xF7;		// Set MISO to Input
	CBI  0x17,3
;     324 	CS_DDR_SET();		// Set CS to Output
	SBI  0x17,4
;     325 	SPCR=0x50;
	CALL SUBOPT_0xA
;     326 	SPSR=0x00;
	OUT  0xE,R30
;     327 		
;     328 	BPB_BytsPerSec = 512;	// Initialize sector size to 512 (all SD cards have a 512 sector size)
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	MOVW R6,R30
;     329     _FF_n_temp = 0;
	LDI  R30,0
	STS  __FF_n_temp,R30
	STS  __FF_n_temp+1,R30
	STS  __FF_n_temp+2,R30
	STS  __FF_n_temp+3,R30
;     330 	if (reset_sd()==0)
	RCALL _reset_sd
	CPI  R30,0
	BRNE _0x21
;     331 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x520
;     332 	// delay_ms(50);
;     333 	for (n=0; ((n<100)||(data_temp==0)) ; n++)
_0x21:
	__CLRD1S 1
_0x23:
	__GETD2S 1
	__CPD2N 0x64
	BRLO _0x25
	CPI  R16,0
	BRNE _0x24
_0x25:
;     334 	{
;     335 		SD_CS_ON();
	CBI  0x18,4
;     336 		data_temp = _FF_spi(0xFF);
	CALL SUBOPT_0x5
	MOV  R16,R30
;     337 		SD_CS_OFF();
	SBI  0x18,4
;     338 	}
	CALL SUBOPT_0xB
	RJMP _0x23
_0x24:
;     339 	// delay_ms(50);
;     340 	for (n=0; n<100; n++)
	__CLRD1S 1
_0x28:
	__GETD2S 1
	__CPD2N 0x64
	BRSH _0x29
;     341 	{
;     342 		if (init_sd())		// Initialization Succeeded
	RCALL _init_sd
	CPI  R30,0
	BRNE _0x29
;     343 			break;
;     344 		if (n==99)
	__GETD2S 1
	__CPD2N 0x63
	BRNE _0x2B
;     345 			return (0);
	LDI  R30,LOW(0)
	RJMP _0x520
;     346 	}
_0x2B:
	CALL SUBOPT_0xB
	RJMP _0x28
_0x29:
;     347 
;     348 	if (_FF_read(0x0)==0)
	__GETD1N 0x0
	CALL SUBOPT_0xC
	BRNE _0x2C
;     349 	{
;     350 		#ifdef _DEBUG_ON_
;     351 			printf("\n\rREAD_ERR"); 		
	__POINTW1FN _0,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL SUBOPT_0xD
;     352 		#endif
;     353 		_FF_error = INIT_ERR;
;     354 		return (0);
	RJMP _0x520
;     355 	}
;     356 	PT_SecStart = ((int) _FF_buff[0x1c7] << 8) | (int) _FF_buff[0x1c6];
_0x2C:
	__GETBRMN 27,__FF_buff,455
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,454
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	MOVW R4,R30
;     357 	
;     358 	if ((((_FF_buff[0]==0xEB)&&(_FF_buff[2]==0x90))||(_FF_buff[0]==0xE9)) && ((_FF_buff[510]==0x55)&&(_FF_buff[511]==0xAA)))
	LDS  R26,__FF_buff
	CPI  R26,LOW(0xEB)
	BRNE _0x2E
	__GETB1MN __FF_buff,2
	CPI  R30,LOW(0x90)
	BREQ _0x30
_0x2E:
	LDS  R26,__FF_buff
	CPI  R26,LOW(0xE9)
	BRNE _0x32
_0x30:
	__GETB1MN __FF_buff,510
	CPI  R30,LOW(0x55)
	BRNE _0x33
	__GETB1MN __FF_buff,511
	CPI  R30,LOW(0xAA)
	BREQ _0x34
_0x33:
	RJMP _0x32
_0x34:
	RJMP _0x35
_0x32:
	RJMP _0x2D
_0x35:
;     359     	PT_SecStart = 0;
	CLR  R4
	CLR  R5
;     360  
;     361 	_FF_PART_ADDR = (long) PT_SecStart * (long) BPB_BytsPerSec;
_0x2D:
	MOVW R30,R4
	CALL SUBOPT_0xE
	STS  __FF_PART_ADDR,R30
	STS  __FF_PART_ADDR+1,R31
	STS  __FF_PART_ADDR+2,R22
	STS  __FF_PART_ADDR+3,R23
;     362 
;     363 	if (PT_SecStart)
	MOV  R0,R4
	OR   R0,R5
	BREQ _0x36
;     364 	{
;     365 		if (_FF_read(_FF_PART_ADDR)==0)
	CALL SUBOPT_0xC
	BRNE _0x37
;     366 		{
;     367 		   	#ifdef _DEBUG_ON_
;     368 				printf("\n\rREAD_ERR");
	__POINTW1FN _0,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL SUBOPT_0xD
;     369 			#endif
;     370 			_FF_error = INIT_ERR;
;     371 			return (0);
	RJMP _0x520
;     372 		}
;     373 	}
_0x37:
;     374 
;     375  	#ifdef _DEBUG_ON_
;     376 		printf("\n\rBoot_Sec: [0x%X %X %X] [0x%X] [0x%X]", _FF_buff[0],_FF_buff[1],_FF_buff[2],_FF_buff[510],_FF_buff[511]); 		
_0x36:
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
;     377 	#endif
;     378    	
;     379     BS_jmpBoot = (((long) _FF_buff[0] << 16) | ((int) _FF_buff[1] << 8) | (int) _FF_buff[2]);    		
	LDS  R30,__FF_buff
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __LSLD16
	MOVW R26,R30
	MOVW R24,R22
	__GETBRMN 31,__FF_buff,1
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
;     380 	BPB_BytsPerSec = ((int) _FF_buff[0xC] << 8) | (int) _FF_buff[0xB];
	__GETBRMN 27,__FF_buff,12
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,11
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	MOVW R6,R30
;     381     BPB_SecPerClus = _FF_buff[0xD];
	__GETBRMN 8,__FF_buff,13
;     382 	BPB_RsvdSecCnt = ((int) _FF_buff[0xF] << 8) | (int) _FF_buff[0xE];	
	__GETBRMN 27,__FF_buff,15
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,14
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__PUTW1R 9,10
;     383 	BPB_NumFATs = _FF_buff[0x10];
	__GETBRMN 11,__FF_buff,16
;     384 	BPB_RootEntCnt = ((int) _FF_buff[0x12] << 8) | (int) _FF_buff[0x11];	
	__GETBRMN 27,__FF_buff,18
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,17
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	MOVW R12,R30
;     385 	BPB_FATSz16 = ((int) _FF_buff[0x17] << 8) | (int) _FF_buff[0x16];
	__GETBRMN 27,__FF_buff,23
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,22
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _BPB_FATSz16,R30
	STS  _BPB_FATSz16+1,R31
;     386 	BPB_TotSec = ((unsigned int) _FF_buff[0x14] << 8) | (unsigned int) _FF_buff[0x13];
	__GETBRMN 27,__FF_buff,20
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,19
	CALL SUBOPT_0xF
	STS  _BPB_TotSec,R30
	STS  _BPB_TotSec+1,R31
	STS  _BPB_TotSec+2,R22
	STS  _BPB_TotSec+3,R23
;     387 	if (BPB_TotSec==0)
	CALL __CPD10
	BRNE _0x38
;     388 		BPB_TotSec = ((unsigned long) _FF_buff[0x23] << 24) | ((unsigned long) _FF_buff[0x22] << 16)
;     389 					| ((unsigned long) _FF_buff[0x21] << 8) | ((unsigned long) _FF_buff[0x20]);
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
;     390 	BS_VolSerial = ((unsigned long) _FF_buff[0x2A] << 24) | ((unsigned long) _FF_buff[0x29] << 16)
_0x38:
;     391 				| ((unsigned long) _FF_buff[0x28] << 8) | ((unsigned long) _FF_buff[0x27]);
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
;     392 	for (n=0; n<11; n++)
	__CLRD1S 1
_0x3A:
	__GETD2S 1
	__CPD2N 0xB
	BRSH _0x3B
;     393 		BS_VolLab[n] = _FF_buff[0x2B+n];
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
;     394 	BS_VolLab[11] = 0;		// Terminate the string
	CALL SUBOPT_0xB
	RJMP _0x3A
_0x3B:
	LDI  R30,LOW(0)
	__PUTB1MN _BS_VolLab,11
;     395 	_FF_FAT1_ADDR = _FF_PART_ADDR + ((long) BPB_RsvdSecCnt * (long) BPB_BytsPerSec); 
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
;     396 	_FF_FAT2_ADDR = _FF_FAT1_ADDR + ((long) BPB_FATSz16 * (long) BPB_BytsPerSec);
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
;     397 	_FF_ROOT_ADDR = ((long) BPB_NumFATs * (long) BPB_FATSz16) + (long) BPB_RsvdSecCnt;
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
;     398 	_FF_ROOT_ADDR *= BPB_BytsPerSec;
	MOVW R30,R6
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
;     399 	_FF_ROOT_ADDR += _FF_PART_ADDR;
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
;     400 	
;     401 	_FF_RootDirSectors = ((BPB_RootEntCnt * 32) + BPB_BytsPerSec - 1) / BPB_BytsPerSec;
	MOVW R30,R12
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
;     402 	FirstDataSector = (BPB_NumFATs * BPB_FATSz16) + BPB_RsvdSecCnt + _FF_RootDirSectors; 
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
;     403 	
;     404 	DataClusTot = BPB_TotSec - FirstDataSector;
	LDS  R26,_BPB_TotSec
	LDS  R27,_BPB_TotSec+1
	LDS  R24,_BPB_TotSec+2
	LDS  R25,_BPB_TotSec+3
	CLR  R22
	CLR  R23
	CALL __SUBD21
	STS  _DataClusTot,R26
	STS  _DataClusTot+1,R27
	STS  _DataClusTot+2,R24
	STS  _DataClusTot+3,R25
;     405 	DataClusTot /= BPB_SecPerClus;
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
;     406 	clus_0_addr = 0;		// Reset Empty Cluster table location
	LDI  R30,0
	STS  _clus_0_addr,R30
	STS  _clus_0_addr+1,R30
	STS  _clus_0_addr+2,R30
	STS  _clus_0_addr+3,R30
;     407 	c_counter = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _c_counter,R30
	STS  _c_counter+1,R31
;     408 	
;     409 	if (DataClusTot < 4085)				// FAT12
	LDS  R26,_DataClusTot
	LDS  R27,_DataClusTot+1
	LDS  R24,_DataClusTot+2
	LDS  R25,_DataClusTot+3
	__CPD2N 0xFF5
	BRSH _0x3C
;     410 		BPB_FATType = 0x32;
	LDI  R30,LOW(50)
	MOV  R14,R30
;     411 	else if (DataClusTot < 65525)		// FAT16
	RJMP _0x3D
_0x3C:
	LDS  R26,_DataClusTot
	LDS  R27,_DataClusTot+1
	LDS  R24,_DataClusTot+2
	LDS  R25,_DataClusTot+3
	__CPD2N 0xFFF5
	BRSH _0x3E
;     412 		BPB_FATType = 0x36;
	LDI  R30,LOW(54)
	MOV  R14,R30
;     413 	else
	RJMP _0x3F
_0x3E:
;     414 	{
;     415 		BPB_FATType = 0;
	CLR  R14
;     416 		_FF_error = FAT_ERR;
	LDI  R30,LOW(12)
	STS  __FF_error,R30
;     417 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x520
;     418 	}
_0x3F:
_0x3D:
;     419     
;     420 	_FF_DIR_ADDR = _FF_ROOT_ADDR;		// Set current directory to root address
	LDS  R30,__FF_ROOT_ADDR
	LDS  R31,__FF_ROOT_ADDR+1
	LDS  R22,__FF_ROOT_ADDR+2
	LDS  R23,__FF_ROOT_ADDR+3
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;     421 
;     422 	_FF_FULL_PATH[0] = 0x5C;	// a '\'
	LDI  R30,LOW(92)
	STS  __FF_FULL_PATH,R30
;     423 	_FF_FULL_PATH[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN __FF_FULL_PATH,1
;     424 	
;     425 	#ifdef _DEBUG_ON_
;     426 		printf("\n\rPart Address:  %lX", _FF_PART_ADDR);
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
;     427 		printf("\n\rBS_jmpBoot:  %lX", BS_jmpBoot);
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
;     428 		printf("\n\rBPB_BytsPerSec:  %X", BPB_BytsPerSec);
	__POINTW1FN _0,90
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R6
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
;     429 		printf("\n\rBPB_SecPerClus:  %X", BPB_SecPerClus);
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
;     430 		printf("\n\rBPB_RsvdSecCnt:  %X", BPB_RsvdSecCnt);
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
;     431 		printf("\n\rBPB_NumFATs:  %X", BPB_NumFATs);
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
;     432 		printf("\n\rBPB_RootEntCnt:  %X", BPB_RootEntCnt);
	__POINTW1FN _0,175
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R12
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
;     433 		printf("\n\rBPB_FATSz16:  %X", BPB_FATSz16);
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
;     434 		printf("\n\rBPB_TotSec16:  %lX", BPB_TotSec);
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
;     435 		if (BPB_FATType == 0x32)
	LDI  R30,LOW(50)
	CP   R30,R14
	BRNE _0x40
;     436 			printf("\n\rBPB_FATType:  FAT12");
	__POINTW1FN _0,237
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RJMP _0x524
;     437 		else if (BPB_FATType == 0x36)
_0x40:
	LDI  R30,LOW(54)
	CP   R30,R14
	BRNE _0x42
;     438 			printf("\n\rBPB_FATType:  FAT16");
	__POINTW1FN _0,259
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RJMP _0x524
;     439 		else
_0x42:
;     440 			printf("\n\rBPB_FATType:  FAT ERROR!!");
	__POINTW1FN _0,281
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
_0x524:
	CALL _printf
	ADIW R28,2
;     441 		printf("\n\rClusterCnt:  %lX", DataClusTot);
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
;     442 		printf("\n\rROOT_ADDR:  %lX", _FF_ROOT_ADDR);
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
;     443 		printf("\n\rFAT2_ADDR:  %lX", _FF_FAT2_ADDR);
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
;     444 		printf("\n\rRootDirSectors:  %X", _FF_RootDirSectors);
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
;     445 		printf("\n\rFirstDataSector:  %X", FirstDataSector);
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
;     446 	#endif
;     447 	
;     448 	return (1);	
	LDI  R30,LOW(1)
_0x520:
	LDD  R16,Y+0
	ADIW R28,5
	RET
;     449 }
;     450 
;     451 unsigned char spi_speedset(void)
;     452 {
_spi_speedset:
;     453 	if (SPCR == 0x50)
	IN   R30,0xD
	CPI  R30,LOW(0x50)
	BRNE _0x44
;     454 		SPCR = 0x51;
	LDI  R30,LOW(81)
	OUT  0xD,R30
;     455 	else if (SPCR == 0x51)
	RJMP _0x45
_0x44:
	IN   R30,0xD
	CPI  R30,LOW(0x51)
	BRNE _0x46
;     456 		SPCR = 0x52;
	LDI  R30,LOW(82)
	OUT  0xD,R30
;     457 	else if (SPCR == 0x52)
	RJMP _0x47
_0x46:
	IN   R30,0xD
	CPI  R30,LOW(0x52)
	BRNE _0x48
;     458 		SPCR = 0x53;
	LDI  R30,LOW(83)
	OUT  0xD,R30
;     459 	else
	RJMP _0x49
_0x48:
;     460 	{
;     461 		SPCR = 0x50;
	CALL SUBOPT_0xA
;     462 		return (0);
	RET
;     463 	}
_0x49:
_0x47:
_0x45:
;     464 	return (1);
	LDI  R30,LOW(1)
	RET
;     465 }
;     466 
;     467 unsigned char reset_sd(void)
;     468 {
_reset_sd:
;     469 	unsigned char resp, n, c;
;     470 
;     471 	#ifdef _DEBUG_ON_
;     472 		printf("\n\rReset CMD:  ");	
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
;     473 	#endif
;     474 	
;     475 	for (c=0; c<4; c++)		// try reset command 3 times if needed
	LDI  R18,LOW(0)
_0x4B:
	CPI  R18,4
	BRSH _0x4C
;     476 	{
;     477 		SD_CS_OFF();
	SBI  0x18,4
;     478 		for (n=0; n<10; n++)	// initialize clk signal to sync card
	LDI  R17,LOW(0)
_0x4E:
	CPI  R17,10
	BRSH _0x4F
;     479 			_FF_spi(0xFF);
	CALL SUBOPT_0x5
;     480 		resp = send_cmd(CMD0,0);
	SUBI R17,-1
	RJMP _0x4E
_0x4F:
	LDI  R30,LOW(0)
	CALL SUBOPT_0x14
;     481 		for (n=0; n<200; n++)
	LDI  R17,LOW(0)
_0x51:
	CPI  R17,200
	BRSH _0x52
;     482 		{
;     483 			if (resp == 0x1)
	CPI  R16,1
	BRNE _0x53
;     484 			{
;     485 				SD_CS_OFF();
	SBI  0x18,4
;     486     			#ifdef _DEBUG_ON_
;     487 					printf("OK!!!");
	__POINTW1FN _0,424
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;     488 				#endif
;     489 				SPCR = 0x50;
	CALL SUBOPT_0x15
;     490 				return(1);
	RJMP _0x51F
;     491 			}
;     492 	      	resp = _FF_spi(0xFF);
_0x53:
	CALL SUBOPT_0x5
	MOV  R16,R30
;     493 		}
	SUBI R17,-1
	RJMP _0x51
_0x52:
;     494 		#ifdef _DEBUG_ON_
;     495 			printf("ERROR!!!");
	__POINTW1FN _0,430
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;     496 		#endif
;     497  		if (spi_speedset()==0)
	CALL _spi_speedset
	CPI  R30,0
	BRNE _0x54
;     498  		{
;     499 		    SD_CS_OFF();
	SBI  0x18,4
;     500  			return (0);
	LDI  R30,LOW(0)
	RJMP _0x51F
;     501  		}
;     502 	}
_0x54:
	SUBI R18,-1
	RJMP _0x4B
_0x4C:
;     503 	return (0);
	LDI  R30,LOW(0)
	RJMP _0x51F
;     504 }
;     505 
;     506 unsigned char init_sd(void)
;     507 {
_init_sd:
;     508 	unsigned char resp;
;     509 	unsigned int c;
;     510 	
;     511 	clear_sd_buff();
	CALL __SAVELOCR3
;	resp -> R16
;	c -> R17,R18
	CALL _clear_sd_buff
;     512 
;     513     #ifdef _DEBUG_ON_
;     514 		printf("\r\nInitialization:  ");
	__POINTW1FN _0,439
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;     515 	#endif
;     516     for (c=0; c<1000; c++)
	__GETWRN 17,18,0
_0x56:
	__CPWRN 17,18,1000
	BRSH _0x57
;     517     {
;     518     	resp = send_cmd(CMD1, 0);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x14
;     519     	if (resp == 0)
	CPI  R16,0
	BREQ _0x57
;     520     		break;
;     521    		resp = _FF_spi(0xFF);
	CALL SUBOPT_0x5
	MOV  R16,R30
;     522    		if (resp == 0)
	CPI  R16,0
	BREQ _0x57
;     523    			break;
;     524    		resp = _FF_spi(0xFF);
	CALL SUBOPT_0x5
	MOV  R16,R30
;     525    		if (resp == 0)
	CPI  R16,0
	BREQ _0x57
;     526    			break;
;     527 	}
	__ADDWRN 17,18,1
	RJMP _0x56
_0x57:
;     528    	if (resp == 0)
	CPI  R16,0
	BRNE _0x5B
;     529 	{
;     530 		#ifdef _DEBUG_ON_
;     531    			printf("OK!");
	__POINTW1FN _0,459
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL SUBOPT_0x16
;     532 	   	#endif
;     533 		return (1);
	RJMP _0x51F
;     534 	}
;     535 	else
_0x5B:
;     536 	{
;     537 		#ifdef _DEBUG_ON_
;     538    			printf("ERROR-%x  ", resp);
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
;     539 	   	#endif
;     540 		return (0);
	LDI  R30,LOW(0)
;     541  	}        		
;     542 }
_0x51F:
	CALL __LOADLOCR3
	ADIW R28,3
	RET
;     543 
;     544 unsigned char _FF_read_disp(unsigned long sd_addr)
;     545 {
__FF_read_disp:
;     546 	unsigned char resp;
;     547 	unsigned long n, remainder;
;     548 	
;     549 	if (sd_addr % 0x200)
	SBIW R28,8
	ST   -Y,R16
;	sd_addr -> Y+9
;	resp -> R16
;	n -> Y+5
;	remainder -> Y+1
	__GETD1S 9
	ANDI R31,HIGH(0x1FF)
	SBIW R30,0
	BREQ _0x5D
;     550 	{	// Not a valid read address, return 0
;     551 		_FF_error = READ_ERR;
	CALL SUBOPT_0x17
;     552 		return (0);
	RJMP _0x51E
;     553 	}
;     554 
;     555 	clear_sd_buff();
_0x5D:
	CALL SUBOPT_0x18
;     556 	resp = send_cmd(CMD17, sd_addr);		// Send read request
	__GETD1S 10
	CALL SUBOPT_0x19
;     557 	
;     558 	while(resp!=0xFE)
_0x5E:
	CPI  R16,254
	BREQ _0x60
;     559 		resp = _FF_spi(0xFF);
	CALL SUBOPT_0x5
	MOV  R16,R30
;     560 	for (n=0; n<512; n++)
	RJMP _0x5E
_0x60:
	__CLRD1S 5
_0x62:
	__GETD2S 5
	__CPD2N 0x200
	BRLO PC+3
	JMP _0x63
;     561 	{
;     562 		remainder = n % 0x10;
	__GETD1S 5
	__ANDD1N 0xF
	__PUTD1S 1
;     563 		if (remainder == 0)
	CALL __CPD10
	BRNE _0x64
;     564 			printf("\n\r");
	__POINTW1FN _0,474
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;     565 		_FF_buff[n] = _FF_spi(0xFF);
_0x64:
	__GETD1S 5
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x5
	POP  R26
	POP  R27
	ST   X,R30
;     566 		if (_FF_buff[n]<0x10)
	__GETD1S 5
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	LD   R30,Z
	CPI  R30,LOW(0x10)
	BRSH _0x65
;     567 			putchar(0x30);
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL _putchar
;     568 		printf("%X ", _FF_buff[n]);
_0x65:
	__POINTW1FN _0,477
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 7
	CALL SUBOPT_0x1A
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
;     569 	}
	__GETD1S 5
	__SUBD1N -1
	__PUTD1S 5
	RJMP _0x62
_0x63:
;     570 	_FF_spi(0xFF);
	CALL SUBOPT_0x9
;     571 	_FF_spi(0xFF);
	CALL SUBOPT_0x4
;     572 	_FF_spi(0xFF);
	CALL __FF_spi
;     573 	SD_CS_OFF();
	SBI  0x18,4
;     574 	return (1);
	LDI  R30,LOW(1)
_0x51E:
	LDD  R16,Y+0
	ADIW R28,13
	RET
;     575 }
;     576 
;     577 // Read data from a SD card @ address
;     578 unsigned char _FF_read(unsigned long sd_addr)
;     579 {
__FF_read:
;     580 	unsigned char resp;
;     581 	unsigned long n;
;     582 //printf("\r\nReadin ADDR [0x%lX]", sd_addr);
;     583 	
;     584 	if (sd_addr % BPB_BytsPerSec)
	SBIW R28,4
	ST   -Y,R16
;	sd_addr -> Y+5
;	resp -> R16
;	n -> Y+1
	CALL SUBOPT_0x1B
	BREQ _0x66
;     585 	{	// Not a valid read address, return 0
;     586 		_FF_error = READ_ERR;
	CALL SUBOPT_0x17
;     587 		return (0);
	RJMP _0x51D
;     588 	}
;     589 		
;     590 	for (;;)
_0x66:
_0x68:
;     591 	{
;     592 		clear_sd_buff();
	CALL SUBOPT_0x18
;     593 		resp = send_cmd(CMD17, sd_addr);	// read block command
	__GETD1S 6
	CALL SUBOPT_0x19
;     594 		for (n=0; n<1000; n++)
	__CLRD1S 1
_0x6B:
	__GETD2S 1
	__CPD2N 0x3E8
	BRSH _0x6C
;     595 		{
;     596 			if (resp==0xFE)
	CPI  R16,254
	BREQ _0x6C
;     597 			{	// waiting for start byte
;     598 				break;
;     599 			}
;     600 			resp = _FF_spi(0xFF);
	CALL SUBOPT_0x5
	MOV  R16,R30
;     601 		}
	CALL SUBOPT_0xB
	RJMP _0x6B
_0x6C:
;     602 		if (resp==0xFE)
	CPI  R16,254
	BRNE _0x6E
;     603 		{	// if it is a valid start byte => start reading SD Card
;     604 			for (n=0; n<BPB_BytsPerSec; n++)
	__CLRD1S 1
_0x70:
	MOVW R30,R6
	__GETD2S 1
	CLR  R22
	CLR  R23
	CALL __CPD21
	BRSH _0x71
;     605 				_FF_buff[n] = _FF_spi(0xFF);
	__GETD1S 1
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x5
	POP  R26
	POP  R27
	ST   X,R30
;     606 			_FF_spi(0xFF);
	CALL SUBOPT_0xB
	RJMP _0x70
_0x71:
	CALL SUBOPT_0x9
;     607 			_FF_spi(0xFF);
	CALL SUBOPT_0x4
;     608 			_FF_spi(0xFF);
	CALL __FF_spi
;     609 			SD_CS_OFF();
	SBI  0x18,4
;     610 			_FF_error = NO_ERR;
	LDI  R30,LOW(0)
	STS  __FF_error,R30
;     611 			_FF_buff_addr = sd_addr;
	__GETD1S 5
	STS  __FF_buff_addr,R30
	STS  __FF_buff_addr+1,R31
	STS  __FF_buff_addr+2,R22
	STS  __FF_buff_addr+3,R23
;     612 			SPCR = 0x50;
	CALL SUBOPT_0x15
;     613 			return (1);
	RJMP _0x51D
;     614 		}
;     615 
;     616 		SD_CS_OFF();
_0x6E:
	SBI  0x18,4
;     617 
;     618 		if (spi_speedset()==0)
	CALL _spi_speedset
	CPI  R30,0
	BREQ _0x69
;     619 			break;
;     620 	}	
	RJMP _0x68
_0x69:
;     621 	_FF_error = READ_ERR;    
	CALL SUBOPT_0x17
;     622 	return(0);
_0x51D:
	LDD  R16,Y+0
	ADIW R28,9
	RET
;     623 }
;     624 
;     625 
;     626 #ifndef _READ_ONLY_
;     627 unsigned char _FF_write(unsigned long sd_addr)
;     628 {
__FF_write:
;     629 	unsigned char resp, calc, valid_flag;
;     630 	unsigned int n;
;     631 	
;     632 	if ((sd_addr%BPB_BytsPerSec) || (sd_addr <= _FF_PART_ADDR))
	CALL __SAVELOCR5
;	sd_addr -> Y+5
;	resp -> R16
;	calc -> R17
;	valid_flag -> R18
;	n -> R19,R20
	CALL SUBOPT_0x1B
	BRNE _0x74
	LDS  R30,__FF_PART_ADDR
	LDS  R31,__FF_PART_ADDR+1
	LDS  R22,__FF_PART_ADDR+2
	LDS  R23,__FF_PART_ADDR+3
	__GETD2S 5
	CALL __CPD12
	BRLO _0x73
_0x74:
;     633 	{	// Not a valid write address, return 0
;     634 		_FF_error = WRITE_ERR;
	CALL SUBOPT_0x1C
;     635 		return (0);
	RJMP _0x51C
;     636 	}
;     637 
;     638 //printf("\r\nWriting to address:  %lX", sd_addr);
;     639 	for (;;)
_0x73:
_0x77:
;     640 	{
;     641 		clear_sd_buff();
	CALL _clear_sd_buff
;     642 		resp = send_cmd(CMD24, sd_addr);
	LDI  R30,LOW(9)
	ST   -Y,R30
	__GETD1S 6
	CALL SUBOPT_0x19
;     643 		valid_flag = 0;
	LDI  R18,LOW(0)
;     644 		for (n=0; n<1000; n++)
	__GETWRN 19,20,0
_0x7A:
	__CPWRN 19,20,1000
	BRSH _0x7B
;     645 		{
;     646 			if (resp == 0x00)
	CPI  R16,0
	BRNE _0x7C
;     647 			{
;     648 				valid_flag = 1;
	LDI  R18,LOW(1)
;     649 				break;
	RJMP _0x7B
;     650 			}
;     651 			resp = _FF_spi(0xFF);
_0x7C:
	CALL SUBOPT_0x5
	MOV  R16,R30
;     652 		}
	__ADDWRN 19,20,1
	RJMP _0x7A
_0x7B:
;     653 	
;     654 		if (valid_flag)
	CPI  R18,0
	BREQ _0x7D
;     655 		{
;     656 			_FF_spi(0xFF);
	CALL SUBOPT_0x5
;     657 			_FF_spi(0xFE);					// Start Block Token
	LDI  R30,LOW(254)
	ST   -Y,R30
	CALL __FF_spi
;     658 			for (n=0; n<BPB_BytsPerSec; n++)		// Write Data in buffer to card
	__GETWRN 19,20,0
_0x7F:
	__CPWRR 19,20,6,7
	BRSH _0x80
;     659 				_FF_spi(_FF_buff[n]);
	LDI  R26,LOW(__FF_buff)
	LDI  R27,HIGH(__FF_buff)
	ADD  R26,R19
	ADC  R27,R20
	LD   R30,X
	ST   -Y,R30
	CALL __FF_spi
;     660 			_FF_spi(0xFF);					// Send 2 blank CRC bytes
	__ADDWRN 19,20,1
	RJMP _0x7F
_0x80:
	CALL SUBOPT_0x9
;     661 			_FF_spi(0xFF);
	CALL SUBOPT_0x4
;     662 			resp = _FF_spi(0xFF);			// Response should be 0bXXX00101
	CALL __FF_spi
	MOV  R16,R30
;     663 			calc = resp | 0xE0;
	MOV  R30,R16
	ORI  R30,LOW(0xE0)
	MOV  R17,R30
;     664 			if (calc==0xE5)
	CPI  R17,229
	BRNE _0x81
;     665 			{
;     666 				while(_FF_spi(0xFF)==0)
_0x82:
	CALL SUBOPT_0x5
	CPI  R30,0
	BREQ _0x82
;     667 					;	// Clear Buffer before returning 'OK'
;     668 				SD_CS_OFF();
	SBI  0x18,4
;     669 //				SPCR = 0x50;			// Reset SPI bus Speed
;     670 				_FF_error = NO_ERR;
	LDI  R30,LOW(0)
	STS  __FF_error,R30
;     671 				return(1);
	LDI  R30,LOW(1)
	RJMP _0x51C
;     672 			}
;     673 		}
_0x81:
;     674 		SD_CS_OFF(); 
_0x7D:
	SBI  0x18,4
;     675 
;     676 		if (spi_speedset()==0)
	CALL _spi_speedset
	CPI  R30,0
	BREQ _0x78
;     677 			break;
;     678 		// delay_ms(100);		
;     679 	}
	RJMP _0x77
_0x78:
;     680 	_FF_error = WRITE_ERR;
	CALL SUBOPT_0x1C
;     681 	return(0x0);
_0x51C:
	CALL __LOADLOCR5
	ADIW R28,9
	RET
;     682 }
;     683 #endif
;     684 /*
;     685 	Progressive Resources LLC
;     686                                     
;     687 			FlashFile
;     688 	
;     689 	Version : 	1.32
;     690 	Date: 		12/31/2003
;     691 	Author: 	Erick M. Higa
;     692 	
;     693 	Revision History:
;     694 	12/31/2003 - EMH - v1.00 
;     695 			   	 	 - Initial Release
;     696 	01/19/2004 - EMH - v1.10
;     697 			   	 	 - fixed FAT access errors by allowing both FAT tables to be updated
;     698 					 - fixed erase_cluster chain to stop if chain goes to '0'
;     699 					 - fixed #include's so other non m128 processors could be used
;     700 					 - fixed fcreate to match 'C' standard for function "creat"
;     701 					 - fixed fseek so it would not error when in "READ" mode
;     702 					 - modified SPI interface to use _FF_spi() so it is more universal
;     703 					   (see the "sd_cmd.c" file for the function used)
;     704 					 - redifined global variables and #defines for more unique names
;     705 					 - added string functions fputs, fputsc, & fgets
;     706 					 - added functions fquickformat, fgetfileinfo, & GetVolID()
;     707 					 - added directory support
;     708 					 - modified delays in "sd_cmd.c" to increase transfer speed to max
;     709 					 - updated "options.h" to include additions, and to make #defines 
;     710 					   more universal to multiple platforms
;     711 	01/21/2004 - EMH - v1.20
;     712 			   	 	 - Added ICC Support to the FlashFileSD
;     713 					 - fixed card initialization error for MMC/SD's that have only a boot 
;     714 			   	 	   sector and no partition table
;     715 					 - Fixed intermittant error on fcreate when creating existing file
;     716 					 - changed "options.h" to #include all required files
;     717 	02/19/2004 - EMH - v1.21
;     718 					 - Replaced all "const" refrances to "flash" to support CodeVision 1.24.1b
;     719 	03/02/2004 - EMH - v1.22 (unofficial release)
;     720 					 - Changed Directory Functions to allow for multi-cluster directory entries
;     721 					 - Added function addr_to_clust() to support long directories
;     722 					 - Fixed FAT table address calculation to support multiple reserved sectors
;     723 					   (previously) assumed one reserved sector, if XP formats card sometimes 
;     724 					   multiple reserved sectors - thanks YW
;     725 	03/10/2004 - EMH - v1.30
;     726 					 - Added support for a Compact Flash package
;     727 					 - Renamed read and write to flash function names for multiple media support	
;     728 	03/26/2004 - EMH - v1.31
;     729 					 - Added define for easy MEGA128Dev board setup
;     730 					 - Changed demo projects so "option.h" is in the project directory	
;     731 	04/01/2004 - EMH - v1.32
;     732 					 - Fixed bug in "prev_cluster()" that didn't use updated FAT table address
;     733 					   calculations.  (effects XP formatted cards see v1.22 notes)
;     734                                            
;     735 	Software License
;     736 	The use of Progressive Resources LLC FlashFile Source Package indicates 
;     737 	your understanding and acceptance of the following terms and conditions. 
;     738 	This license shall supersede any verbal or prior verbal or written, statement 
;     739 	or agreement to the contrary. If you do not understand or accept these terms, 
;     740 	or your local regulations prohibit "after sale" license agreements or limited 
;     741 	disclaimers, you must cease and desist using this product immediately.
;     742 	This product is © Copyright 2003 by Progressive Resources LLC, all rights 
;     743 	reserved. International copyright laws, international treaties and all other 
;     744 	applicable national or international laws protect this product. This software 
;     745 	product and documentation may not, in whole or in part, be copied, photocopied, 
;     746 	translated, or reduced to any electronic medium or machine readable form, without 
;     747 	prior consent in writing, from Progressive Resources LLC and according to all 
;     748 	applicable laws. The sole owner of this product is Progressive Resources LLC.
;     749 
;     750 	Operating License
;     751 	You have the non-exclusive right to use any enclosed product but have no right 
;     752 	to distribute it as a source code product without the express written permission 
;     753 	of Progressive Resources LLC. Use over a "local area network" (within the same 
;     754 	locale) is permitted provided that only a single person, on a single computer 
;     755 	uses the product at a time. Use over a "wide area network" (outside the same 
;     756 	locale) is strictly prohibited under any and all circumstances.
;     757                                            
;     758 	Liability Disclaimer
;     759 	This product and/or license is provided as is, without any representation or 
;     760 	warranty of any kind, either express or implied, including without limitation 
;     761 	any representations or endorsements regarding the use of, the results of, or 
;     762 	performance of the product, Its appropriateness, accuracy, reliability, or 
;     763 	correctness. The user and/or licensee assume the entire risk as to the use of 
;     764 	this product. Progressive Resources LLC does not assume liability for the use 
;     765 	of this product beyond the original purchase price of the software. In no event 
;     766 	will Progressive Resources LLC be liable for additional direct or indirect 
;     767 	damages including any lost profits, lost savings, or other incidental or 
;     768 	consequential damages arising from any defects, or the use or inability to 
;     769 	use these products, even if Progressive Resources LLC have been advised of 
;     770 	the possibility of such damages.
;     771 */                                 
;     772 
;     773 extern unsigned long OCR_REG;
;     774 extern unsigned char _FF_buff[512];
;     775 extern unsigned int PT_SecStart;
;     776 extern unsigned long BS_jmpBoot;
;     777 extern unsigned int BPB_BytsPerSec;
;     778 extern unsigned char BPB_SecPerClus;
;     779 extern unsigned int BPB_RsvdSecCnt;
;     780 extern unsigned char BPB_NumFATs;
;     781 extern unsigned int BPB_RootEntCnt;
;     782 extern unsigned int BPB_FATSz16;
;     783 extern unsigned char BPB_FATType;
;     784 extern unsigned long BPB_TotSec;
;     785 extern unsigned long BS_VolSerial;
;     786 extern unsigned char BS_VolLab[12];
;     787 extern unsigned long _FF_PART_ADDR, _FF_ROOT_ADDR, _FF_DIR_ADDR;
;     788 extern unsigned long _FF_FAT1_ADDR, _FF_FAT2_ADDR;
;     789 extern unsigned int FirstDataSector;
;     790 extern unsigned long FirstSectorofCluster;
;     791 extern unsigned char _FF_error;
;     792 extern unsigned long _FF_buff_addr;
;     793 extern unsigned long DataClusTot;
;     794 unsigned char rtc_hour, rtc_min, rtc_sec;

	.DSEG
_rtc_hour:
	.BYTE 0x1
_rtc_min:
	.BYTE 0x1
_rtc_sec:
	.BYTE 0x1
;     795 unsigned char rtc_date, rtc_month;
_rtc_date:
	.BYTE 0x1
_rtc_month:
	.BYTE 0x1
;     796 unsigned int rtc_year;
_rtc_year:
	.BYTE 0x2
;     797 unsigned long clus_0_addr, _FF_n_temp;
_clus_0_addr:
	.BYTE 0x4
__FF_n_temp:
	.BYTE 0x4
;     798 unsigned int c_counter;
_c_counter:
	.BYTE 0x2
;     799 unsigned char _FF_FULL_PATH[_FF_PATH_LENGTH];
__FF_FULL_PATH:
	.BYTE 0x64
;     800 unsigned char FILENAME[12];
_FILENAME:
	.BYTE 0xC
;     801 
;     802 // Conversion file to change an ASCII valued character into the calculated value
;     803 unsigned char ascii_to_char(unsigned char ascii_char)
;     804 {

	.CSEG
_ascii_to_char:
;     805 	unsigned char temp_char;
;     806 	
;     807 	if (ascii_char < 0x30)		// invalid, return error
	ST   -Y,R16
;	ascii_char -> Y+1
;	temp_char -> R16
	LDD  R26,Y+1
	CPI  R26,LOW(0x30)
	BRSH _0x86
;     808 		return (0xFF);
	LDI  R30,LOW(255)
	RJMP _0x51B
;     809 	else if (ascii_char < 0x3A)
_0x86:
	LDD  R26,Y+1
	CPI  R26,LOW(0x3A)
	BRSH _0x88
;     810 	{	//number, subtract 0x30, retrun value
;     811 		temp_char = ascii_char - 0x30;
	LDD  R30,Y+1
	SUBI R30,LOW(48)
	MOV  R16,R30
;     812 		return (temp_char);
	MOV  R30,R16
	RJMP _0x51B
;     813 	}
;     814 	else if (ascii_char < 0x41)	// invalid, return error
_0x88:
	LDD  R26,Y+1
	CPI  R26,LOW(0x41)
	BRSH _0x8A
;     815 		return (0xFF);
	LDI  R30,LOW(255)
	RJMP _0x51B
;     816 	else if (ascii_char < 0x47)
_0x8A:
	LDD  R26,Y+1
	CPI  R26,LOW(0x47)
	BRSH _0x8C
;     817 	{	// lower case a-f, subtract 0x37, return value
;     818 		temp_char = ascii_char - 0x37;
	LDD  R30,Y+1
	SUBI R30,LOW(55)
	MOV  R16,R30
;     819 		return (temp_char);
	MOV  R30,R16
	RJMP _0x51B
;     820 	}
;     821 	else if (ascii_char < 0x61)	// invalid, return error
_0x8C:
	LDD  R26,Y+1
	CPI  R26,LOW(0x61)
	BRSH _0x8E
;     822 		return (0xFF);
	LDI  R30,LOW(255)
	RJMP _0x51B
;     823 	else if (ascii_char < 0x67)
_0x8E:
	LDD  R26,Y+1
	CPI  R26,LOW(0x67)
	BRSH _0x90
;     824 	{	// upper case A-F, subtract 0x57, return value
;     825 		temp_char = ascii_char - 0x57;
	LDD  R30,Y+1
	SUBI R30,LOW(87)
	MOV  R16,R30
;     826 		return (temp_char);
	MOV  R30,R16
	RJMP _0x51B
;     827 	}
;     828 	else	// invalid, return error
_0x90:
;     829 		return (0xFF);
	LDI  R30,LOW(255)
;     830 }
_0x51B:
	LDD  R16,Y+0
	ADIW R28,2
	RET
;     831 
;     832 // Function to see if the character is a valid FILENAME character
;     833 int valid_file_char(unsigned char file_char)
;     834 {
_valid_file_char:
;     835 	if (file_char < 0x20)
	LD   R26,Y
	CPI  R26,LOW(0x20)
	BRSH _0x92
;     836 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x51A
;     837 	else if ((file_char==0x22) || (file_char==0x2A) || (file_char==0x2B) || (file_char==0x2C) ||
_0x92:
;     838 			(file_char==0x2E) || (file_char==0x2F) || ((file_char>=0x3A)&&(file_char<=0x3F)) ||
;     839 			((file_char>=0x5B)&&(file_char<=0x5D)) || (file_char==0x7C) || (file_char==0xE5))
	LD   R26,Y
	CPI  R26,LOW(0x22)
	BREQ _0x95
	CPI  R26,LOW(0x2A)
	BREQ _0x95
	CPI  R26,LOW(0x2B)
	BREQ _0x95
	CPI  R26,LOW(0x2C)
	BREQ _0x95
	CPI  R26,LOW(0x2E)
	BREQ _0x95
	CPI  R26,LOW(0x2F)
	BREQ _0x95
	CPI  R26,LOW(0x3A)
	BRLO _0x96
	CPI  R26,LOW(0x40)
	BRLO _0x95
_0x96:
	LD   R26,Y
	CPI  R26,LOW(0x5B)
	BRLO _0x98
	CPI  R26,LOW(0x5E)
	BRLO _0x95
_0x98:
	LD   R26,Y
	CPI  R26,LOW(0x7C)
	BREQ _0x95
	CPI  R26,LOW(0xE5)
	BRNE _0x94
_0x95:
;     840 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x51A
;     841 	else
_0x94:
;     842 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
;     843 }
_0x51A:
	ADIW R28,1
	RET
;     844 
;     845 // Function will scan the directory @VALID_ADDR and return a
;     846 // '0' if successful (w/ VALID_ADDR changing to location of entry avaliable),
;     847 // and a '-1' if file or folder exists (w/ VALID_ADDR changing to location of
;     848 // entry of exisiting file/folder) or if no more entry space (VALID_ADDR would
;     849 // change to 0).
;     850 int scan_directory(unsigned long *VALID_ADDR, unsigned char *NAME)
;     851 {
_scan_directory:
;     852 	unsigned int ent_cntr, ent_max, n, c, dir_clus;
;     853 	unsigned long temp_addr;
;     854 	unsigned char *sp, *qp, aval_flag, name_store[14];
;     855 	
;     856 	aval_flag = 0;
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
;     857 	ent_cntr = 0;	// set to 0
	__GETWRN 16,17,0
;     858 	
;     859 	qp = NAME;
	LDD  R30,Y+33
	LDD  R31,Y+33+1
	STD  Y+21,R30
	STD  Y+21+1,R31
;     860 	for (c=0; c<11; c++)
	LDI  R30,0
	STD  Y+31,R30
	STD  Y+31+1,R30
_0x9D:
	LDD  R26,Y+31
	LDD  R27,Y+31+1
	SBIW R26,11
	BRLO PC+3
	JMP _0x9E
;     861 	{
;     862 		if (valid_file_char(*qp)==0)
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	CALL SUBOPT_0x1D
	BRNE _0x9F
;     863 			name_store[c] = toupper(*qp++);
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
;     864 		else if (*qp == '.')
	RJMP _0xA0
_0x9F:
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BRNE _0xA1
;     865 		{
;     866 			while (c<8)
_0xA2:
	LDD  R26,Y+31
	LDD  R27,Y+31+1
	SBIW R26,8
	BRSH _0xA4
;     867 				name_store[c++] = 0x20;
	CALL SUBOPT_0x1E
;     868 			c--;
	RJMP _0xA2
_0xA4:
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	SBIW R30,1
	STD  Y+31,R30
	STD  Y+31+1,R31
;     869 			
;     870 			qp++;
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	ADIW R30,1
	STD  Y+21,R30
	STD  Y+21+1,R31
;     871 			aval_flag |= 1;
	LDD  R30,Y+20
	ORI  R30,1
	STD  Y+20,R30
;     872 		}
;     873 		else if (*qp == 0)
	RJMP _0xA5
_0xA1:
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	LD   R30,X
	CPI  R30,0
	BRNE _0xA6
;     874 		{
;     875 			while (c<11)
_0xA7:
	LDD  R26,Y+31
	LDD  R27,Y+31+1
	SBIW R26,11
	BRSH _0xA9
;     876 				name_store[c++] = 0x20;
	CALL SUBOPT_0x1E
;     877 		}
	RJMP _0xA7
_0xA9:
;     878 		else
	RJMP _0xAA
_0xA6:
;     879 		{
;     880 			*VALID_ADDR = 0;
	CALL SUBOPT_0x1F
;     881 			return (EOF);
	RJMP _0x519
;     882 		}
_0xAA:
_0xA5:
_0xA0:
;     883 	}
	CALL SUBOPT_0x20
	RJMP _0x9D
_0x9E:
;     884 	name_store[11] = 0;
	LDI  R30,LOW(0)
	STD  Y+17,R30
;     885 	
;     886 	if (*VALID_ADDR == _FF_ROOT_ADDR)
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __GETD1P
	LDS  R26,__FF_ROOT_ADDR
	LDS  R27,__FF_ROOT_ADDR+1
	LDS  R24,__FF_ROOT_ADDR+2
	LDS  R25,__FF_ROOT_ADDR+3
	CALL __CPD12
	BRNE _0xAB
;     887 		ent_max = BPB_RootEntCnt;
	__MOVEWRR 18,19,12,13
;     888 	else
	RJMP _0xAC
_0xAB:
;     889 	{
;     890 		dir_clus = addr_to_clust(*VALID_ADDR);
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __GETD1P
	CALL __PUTPARD1
	RCALL _addr_to_clust
	STD  Y+29,R30
	STD  Y+29+1,R31
;     891 		if (dir_clus != 0)
	SBIW R30,0
	BREQ _0xAD
;     892 			aval_flag |= 0x80;
	LDD  R30,Y+20
	ORI  R30,0x80
	STD  Y+20,R30
;     893 		ent_max = ((long) BPB_BytsPerSec * (long) BPB_SecPerClus) / 0x20;
_0xAD:
	CALL SUBOPT_0x21
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x20
	CALL __DIVD21
	MOVW R18,R30
;     894     }
_0xAC:
;     895 	c = 0;
	LDI  R30,0
	STD  Y+31,R30
	STD  Y+31+1,R30
;     896 	while (ent_cntr < ent_max)	
_0xAE:
	__CPWRR 16,17,18,19
	BRLO PC+3
	JMP _0xB0
;     897 	{
;     898 		if (_FF_read(*VALID_ADDR+((long)c*BPB_BytsPerSec))==0)
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x22
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	CALL SUBOPT_0xC
	BRNE _0xB1
;     899 			break;
	RJMP _0xB0
;     900 		for (n=0; n<16; n++)
_0xB1:
	__GETWRN 20,21,0
_0xB3:
	__CPWRN 20,21,16
	BRLO PC+3
	JMP _0xB4
;     901 		{
;     902 			sp = &_FF_buff[n*0x20];
	CALL SUBOPT_0x23
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	STD  Y+23,R30
	STD  Y+23+1,R31
;     903 			qp = name_store;
	MOVW R30,R28
	ADIW R30,6
	STD  Y+21,R30
	STD  Y+21+1,R31
;     904 			if (*sp==0)
	LDD  R26,Y+23
	LDD  R27,Y+23+1
	LD   R30,X
	CPI  R30,0
	BRNE _0xB5
;     905 			{
;     906 				if ((aval_flag&0x10)==0)
	LDD  R30,Y+20
	ANDI R30,LOW(0x10)
	BRNE _0xB6
;     907 					temp_addr = *VALID_ADDR + ((long) c * BPB_BytsPerSec) + (n * 0x20);
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x22
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD21
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
;     908 				*VALID_ADDR = temp_addr;
_0xB6:
	CALL SUBOPT_0x25
;     909 				return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x519
;     910 			}
;     911 			else if (*sp==0xE5)
_0xB5:
	LDD  R26,Y+23
	LDD  R27,Y+23+1
	LD   R26,X
	CPI  R26,LOW(0xE5)
	BRNE _0xB8
;     912 			{
;     913 				temp_addr = *VALID_ADDR + ((long) c * BPB_BytsPerSec) + (n * 0x20);
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x22
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD21
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
;     914 				aval_flag |= 0x10;
	LDD  R30,Y+20
	ORI  R30,0x10
	STD  Y+20,R30
;     915 			}
;     916 			else
	RJMP _0xB9
_0xB8:
;     917 			{
;     918 				if (aval_flag & 0x01)	// file
	LDD  R30,Y+20
	ANDI R30,LOW(0x1)
	BREQ _0xBA
;     919 				{
;     920 					if (strncmp(qp, sp, 11)==0)
	CALL SUBOPT_0x26
	BRNE _0xBB
;     921 					{
;     922 						temp_addr = *VALID_ADDR + ((long) c * BPB_BytsPerSec) + (n * 0x20);
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x22
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD21
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
;     923 						*VALID_ADDR = temp_addr;
	CALL SUBOPT_0x25
;     924 						return (EOF);	// file exists @ temp_addr
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x519
;     925 					}
;     926 				}
_0xBB:
;     927 				else					// folder
	RJMP _0xBC
_0xBA:
;     928 				{
;     929 					if ((strncmp(qp, sp, 11)==0)&&(*(sp+11)&0x10))
	CALL SUBOPT_0x26
	BRNE _0xBE
	LDD  R26,Y+23
	LDD  R27,Y+23+1
	ADIW R26,11
	LD   R30,X
	ANDI R30,LOW(0x10)
	BRNE _0xBF
_0xBE:
	RJMP _0xBD
_0xBF:
;     930 					{
;     931 						temp_addr = *VALID_ADDR + ((long) c * BPB_BytsPerSec) + (n * 0x20);
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x22
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD21
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
;     932 						*VALID_ADDR = temp_addr;
	CALL SUBOPT_0x25
;     933 						return (EOF);	// file exists @ temp_addr
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x519
;     934 					}
;     935 				}
_0xBD:
_0xBC:
;     936 			}
_0xB9:
;     937 			ent_cntr++;
	__ADDWRN 16,17,1
;     938 		}
	__ADDWRN 20,21,1
	RJMP _0xB3
_0xB4:
;     939 		c++;
	CALL SUBOPT_0x20
;     940 		if (ent_cntr == ent_max)
	__CPWRR 18,19,16,17
	BRNE _0xC0
;     941 		{
;     942 			if (aval_flag & 0x80)		// a folder @ a valid cluster
	LDD  R30,Y+20
	ANDI R30,LOW(0x80)
	BREQ _0xC1
;     943 			{
;     944 				c = next_cluster(dir_clus, SINGLE);
	LDD  R30,Y+29
	LDD  R31,Y+29+1
	CALL SUBOPT_0x27
	STD  Y+31,R30
	STD  Y+31+1,R31
;     945 				if (c != EOF)
	LDD  R26,Y+31
	LDD  R27,Y+31+1
	CPI  R26,LOW(0xFFFF)
	LDI  R30,HIGH(0xFFFF)
	CPC  R27,R30
	BREQ _0xC2
;     946 				{	// another dir cluster exists
;     947 					*VALID_ADDR = clust_to_addr(c);
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _clust_to_addr
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __PUTDP1
;     948 					dir_clus = c;
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	STD  Y+29,R30
	STD  Y+29+1,R31
;     949 					ent_cntr = 0;
	__GETWRN 16,17,0
;     950 					c = 0;
	LDI  R30,0
	STD  Y+31,R30
	STD  Y+31+1,R30
;     951 				}
;     952 			}
_0xC2:
;     953 		}
_0xC1:
;     954 	}
_0xC0:
	RJMP _0xAE
_0xB0:
;     955 	*VALID_ADDR = 0;
	CALL SUBOPT_0x1F
;     956 	return (EOF);	
_0x519:
	CALL __LOADLOCR6
	ADIW R28,37
	RET
;     957 }
;     958 
;     959 #ifdef _DEBUG_ON_
;     960 // Function to display all files and folders in the root directory, 
;     961 // with the size of the file in bytes within the [brakets]
;     962 void read_directory(void)
;     963 {
_read_directory:
;     964 	unsigned char valid_flag, attribute_temp;
;     965 	unsigned int c, n, d, m, dir_clus;
;     966 	unsigned long calc, calc_clus, dir_addr;
;     967 	
;     968 	if (_FF_DIR_ADDR != _FF_ROOT_ADDR)
	SBIW R28,18
	CALL __SAVELOCR6
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
	CALL SUBOPT_0x28
	BREQ _0xC3
;     969 	{
;     970 		dir_clus = addr_to_clust(_FF_DIR_ADDR);
	LDS  R30,__FF_DIR_ADDR
	LDS  R31,__FF_DIR_ADDR+1
	LDS  R22,__FF_DIR_ADDR+2
	LDS  R23,__FF_DIR_ADDR+3
	CALL __PUTPARD1
	RCALL _addr_to_clust
	STD  Y+18,R30
	STD  Y+18+1,R31
;     971 		if (dir_clus == 0)
	SBIW R30,0
	BRNE _0xC4
;     972 			return;
	RJMP _0x518
;     973 	}
_0xC4:
;     974 
;     975 	printf("\r\nFile Listing for:  ROOT\\");
_0xC3:
	__POINTW1FN _0,481
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;     976 	for (d=0; d<_FF_PATH_LENGTH; d++)
	LDI  R30,0
	STD  Y+22,R30
	STD  Y+22+1,R30
_0xC6:
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRSH _0xC7
;     977 	{
;     978 		if (_FF_FULL_PATH[d])
	CALL SUBOPT_0x29
	CPI  R30,0
	BREQ _0xC8
;     979 			putchar(_FF_FULL_PATH[d]);
	CALL SUBOPT_0x29
	ST   -Y,R30
	CALL _putchar
;     980 		else
	RJMP _0xC9
_0xC8:
;     981 			break;
	RJMP _0xC7
;     982 	}
_0xC9:
	CALL SUBOPT_0x2A
	RJMP _0xC6
_0xC7:
;     983 	
;     984     
;     985     dir_addr = _FF_DIR_ADDR;
	LDS  R30,__FF_DIR_ADDR
	LDS  R31,__FF_DIR_ADDR+1
	LDS  R22,__FF_DIR_ADDR+2
	LDS  R23,__FF_DIR_ADDR+3
	__PUTD1S 6
;     986 	d = 0;
	LDI  R30,0
	STD  Y+22,R30
	STD  Y+22+1,R30
;     987 	m = 0;
	LDI  R30,0
	STD  Y+20,R30
	STD  Y+20+1,R30
;     988 	while (d<BPB_RootEntCnt)
_0xCA:
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CP   R26,R12
	CPC  R27,R13
	BRLO PC+3
	JMP _0xCC
;     989 	{
;     990     	if (_FF_read(dir_addr+(m*0x200))==0)
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	LSL  R30
	ROL  R31
	MOV  R31,R30
	LDI  R30,0
	__GETD2S 6
	CLR  R22
	CLR  R23
	CALL __ADDD12
	CALL SUBOPT_0xC
	BRNE _0xCD
;     991     		break;
	RJMP _0xCC
;     992 		for (n=0; n<16; n++)
_0xCD:
	__GETWRN 20,21,0
_0xCF:
	__CPWRN 20,21,16
	BRLO PC+3
	JMP _0xD0
;     993 		{
;     994 			for (c=0; c<11; c++)
	__GETWRN 18,19,0
_0xD2:
	__CPWRN 18,19,11
	BRSH _0xD3
;     995 			{
;     996 				if (_FF_buff[(n*0x20)]==0)
	CALL SUBOPT_0x23
	CALL SUBOPT_0x2B
	BRNE _0xD4
;     997 				{
;     998 					n=16;
	__GETWRN 20,21,16
;     999 					d=BPB_RootEntCnt;
	__PUTWSR 12,13,22
;    1000 					valid_flag = 0;
	LDI  R16,LOW(0)
;    1001 					break;
	RJMP _0xD3
;    1002 				}
;    1003 				valid_flag = 1;
_0xD4:
	LDI  R16,LOW(1)
;    1004 				if (valid_file_char(_FF_buff[(n*0x20)+c]))
	CALL SUBOPT_0x23
	ADD  R30,R18
	ADC  R31,R19
	CALL SUBOPT_0x2C
	CALL _valid_file_char
	SBIW R30,0
	BREQ _0xD5
;    1005 				{
;    1006 					valid_flag = 0;
	LDI  R16,LOW(0)
;    1007 					break;
	RJMP _0xD3
;    1008 				}
;    1009 		    }   
_0xD5:
	__ADDWRN 18,19,1
	RJMP _0xD2
_0xD3:
;    1010 		    if (valid_flag)
	CPI  R16,0
	BRNE PC+3
	JMP _0xD6
;    1011 	  		{
;    1012 		  		calc = (n * 0x20) + 0xB;
	CALL SUBOPT_0x23
	ADIW R30,11
	CALL SUBOPT_0x2D
;    1013 		  		attribute_temp = _FF_buff[calc];
	LD   R17,Z
;    1014 		  		putchar('\n');
	CALL SUBOPT_0x2E
;    1015 				putchar('\r');
;    1016 				c = (n * 0x20);
	CALL SUBOPT_0x23
	MOVW R18,R30
;    1017 			  	calc = ((long) _FF_buff[c+0x1F] << 24) | ((long) _FF_buff[c+0x1E] << 16) |
;    1018 			  			((long) _FF_buff[c+0x1D] << 8) | ((long) _FF_buff[c+0x1C]);
	MOVW R30,R18
	__ADDW1MN __FF_buff,31
	LD   R30,Z
	CALL SUBOPT_0x10
	MOVW R30,R18
	__ADDW1MN __FF_buff,30
	LD   R30,Z
	CALL SUBOPT_0x11
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R18
	__ADDW1MN __FF_buff,29
	LD   R30,Z
	CALL SUBOPT_0x12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ORD12
	MOVW R26,R30
	MOVW R24,R22
	MOVW R30,R18
	__ADDW1MN __FF_buff,28
	CALL SUBOPT_0x2F
	__PUTD1S 14
;    1019 			  	calc_clus = ((int) _FF_buff[c+0x1B] << 8) | (int) _FF_buff[c+0x1A];
	MOVW R30,R18
	__ADDW1MN __FF_buff,27
	CALL SUBOPT_0x30
	MOVW R30,R18
	__ADDW1MN __FF_buff,26
	CALL SUBOPT_0x31
	CALL __CWD1
	__PUTD1S 10
;    1020 				if (attribute_temp & 0x10)
	SBRS R17,4
	RJMP _0xD7
;    1021 					printf("  [");
	__POINTW1FN _0,508
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;    1022 				else
	RJMP _0xD8
_0xD7:
;    1023 			  		printf("                [%ld] bytes      (%X)\r  ", calc, calc_clus);		  		
	__POINTW1FN _0,512
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 16
	CALL __PUTPARD1
	__GETD1S 16
	CALL __PUTPARD1
	LDI  R24,8
	CALL _printf
	ADIW R28,10
;    1024 				for (c=0; c<8; c++)
_0xD8:
	__GETWRN 18,19,0
_0xDA:
	__CPWRN 18,19,8
	BRSH _0xDB
;    1025 				{
;    1026 					calc = (n * 0x20) + c;
	CALL SUBOPT_0x23
	ADD  R30,R18
	ADC  R31,R19
	CALL SUBOPT_0x2D
;    1027 					if (_FF_buff[calc]==0x20)
	LD   R30,Z
	CPI  R30,LOW(0x20)
	BREQ _0xDB
;    1028 						break;
;    1029 					putchar(_FF_buff[calc]);
	__GETD1S 14
	CALL SUBOPT_0x2C
	CALL _putchar
;    1030 				}
	__ADDWRN 18,19,1
	RJMP _0xDA
_0xDB:
;    1031 				if (attribute_temp & 0x10)
	SBRS R17,4
	RJMP _0xDD
;    1032 				{
;    1033 					printf("]      (%X)", calc_clus);
	__POINTW1FN _0,553
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 12
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
;    1034 				}
;    1035 				else
	RJMP _0xDE
_0xDD:
;    1036 				{
;    1037 					putchar('.');
	LDI  R30,LOW(46)
	ST   -Y,R30
	CALL _putchar
;    1038 					for (c=8; c<11; c++)
	__GETWRN 18,19,8
_0xE0:
	__CPWRN 18,19,11
	BRSH _0xE1
;    1039 					{
;    1040 						calc = (n * 0x20) + c;
	CALL SUBOPT_0x23
	ADD  R30,R18
	ADC  R31,R19
	CALL SUBOPT_0x2D
;    1041 						if (_FF_buff[calc]==0x20)
	LD   R30,Z
	CPI  R30,LOW(0x20)
	BREQ _0xE1
;    1042 							break;
;    1043 						putchar(_FF_buff[calc]);
	__GETD1S 14
	CALL SUBOPT_0x2C
	CALL _putchar
;    1044 					}
	__ADDWRN 18,19,1
	RJMP _0xE0
_0xE1:
;    1045 				}
_0xDE:
;    1046 		  	}
;    1047 		  	d++;		  		
_0xD6:
	CALL SUBOPT_0x2A
;    1048 		}
	__ADDWRN 20,21,1
	RJMP _0xCF
_0xD0:
;    1049 		m++;
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ADIW R30,1
	STD  Y+20,R30
	STD  Y+20+1,R31
;    1050 		if (_FF_ROOT_ADDR!=_FF_DIR_ADDR)
	LDS  R30,__FF_DIR_ADDR
	LDS  R31,__FF_DIR_ADDR+1
	LDS  R22,__FF_DIR_ADDR+2
	LDS  R23,__FF_DIR_ADDR+3
	LDS  R26,__FF_ROOT_ADDR
	LDS  R27,__FF_ROOT_ADDR+1
	LDS  R24,__FF_ROOT_ADDR+2
	LDS  R25,__FF_ROOT_ADDR+3
	CALL __CPD12
	BREQ _0xE3
;    1051 		{
;    1052 		   	if (m==BPB_SecPerClus)
	MOV  R30,R8
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRNE _0xE4
;    1053 		   	{
;    1054 
;    1055 				m = next_cluster(dir_clus, SINGLE);
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	CALL SUBOPT_0x27
	STD  Y+20,R30
	STD  Y+20+1,R31
;    1056 				if (m != EOF)
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CPI  R26,LOW(0xFFFF)
	LDI  R30,HIGH(0xFFFF)
	CPC  R27,R30
	BREQ _0xE5
;    1057 				{	// another dir cluster exists
;    1058 					dir_addr = clust_to_addr(m);
	CALL SUBOPT_0x32
;    1059 					dir_clus = m;
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	STD  Y+18,R30
	STD  Y+18+1,R31
;    1060 					d = 0;
	LDI  R30,0
	STD  Y+22,R30
	STD  Y+22+1,R30
;    1061 					m = 0;
	LDI  R30,0
	STD  Y+20,R30
	STD  Y+20+1,R30
;    1062 				}
;    1063 				else
	RJMP _0xE6
_0xE5:
;    1064 					break;
	RJMP _0xCC
;    1065 		   		
;    1066 		   	}
_0xE6:
;    1067 		}
_0xE4:
;    1068 	}
_0xE3:
	RJMP _0xCA
_0xCC:
;    1069 	putchar('\n');
	CALL SUBOPT_0x2E
;    1070 	putchar('\r');	
;    1071 } 
_0x518:
	CALL __LOADLOCR6
	ADIW R28,24
	RET
;    1072 
;    1073 void GetVolID(void)
;    1074 {
_GetVolID:
;    1075 	printf("\r\n  Volume Serial:  [0x%lX]", BS_VolSerial);
	__POINTW1FN _0,565
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_BS_VolSerial
	LDS  R31,_BS_VolSerial+1
	LDS  R22,_BS_VolSerial+2
	LDS  R23,_BS_VolSerial+3
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
;    1076 	printf("\r\n  Volume Label:  [%s]\r\n", BS_VolLab);
	__POINTW1FN _0,593
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_BS_VolLab)
	LDI  R31,HIGH(_BS_VolLab)
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	RJMP _0x517
;    1077 }
;    1078 #endif
;    1079 
;    1080 // Convert a cluster number into a read address
;    1081 unsigned long clust_to_addr(unsigned int clust_no)
;    1082 {
_clust_to_addr:
;    1083 	unsigned long clust_addr;
;    1084 	
;    1085 	FirstSectorofCluster = ((clust_no - 2) * (long) BPB_SecPerClus) + (long) FirstDataSector;
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
	CALL __MULD12
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
;    1086 	clust_addr = (long) FirstSectorofCluster * (long) BPB_BytsPerSec + _FF_PART_ADDR;
	MOVW R30,R6
	CLR  R22
	CLR  R23
	LDS  R26,_FirstSectorofCluster
	LDS  R27,_FirstSectorofCluster+1
	LDS  R24,_FirstSectorofCluster+2
	LDS  R25,_FirstSectorofCluster+3
	CALL SUBOPT_0x33
	__PUTD1S 0
;    1087 
;    1088 	return (clust_addr);
_0x517:
	ADIW R28,6
	RET
;    1089 }
;    1090 
;    1091 // Converts an address into a cluster number
;    1092 unsigned int addr_to_clust(unsigned long clus_addr)
;    1093 {
_addr_to_clust:
;    1094 	if (clus_addr <= _FF_PART_ADDR)
	LDS  R30,__FF_PART_ADDR
	LDS  R31,__FF_PART_ADDR+1
	LDS  R22,__FF_PART_ADDR+2
	LDS  R23,__FF_PART_ADDR+3
	__GETD2S 0
	CALL __CPD12
	BRLO _0xE7
;    1095 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x516
;    1096 	clus_addr -= _FF_PART_ADDR;
_0xE7:
	LDS  R26,__FF_PART_ADDR
	LDS  R27,__FF_PART_ADDR+1
	LDS  R24,__FF_PART_ADDR+2
	LDS  R25,__FF_PART_ADDR+3
	__GETD1S 0
	CALL __SUBD12
	__PUTD1S 0
;    1097 	clus_addr /= BPB_BytsPerSec;
	CALL SUBOPT_0x34
	CALL __DIVD21U
	__PUTD1S 0
;    1098 	if (clus_addr <= (unsigned long) FirstDataSector)
	LDS  R30,_FirstDataSector
	LDS  R31,_FirstDataSector+1
	CLR  R22
	CLR  R23
	__GETD2S 0
	CALL __CPD12
	BRLO _0xE8
;    1099 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x516
;    1100 	clus_addr -= FirstDataSector;
_0xE8:
	LDS  R30,_FirstDataSector
	LDS  R31,_FirstDataSector+1
	__GETD2S 0
	CLR  R22
	CLR  R23
	CALL __SUBD21
	__PUTD2S 0
;    1101 	clus_addr /= BPB_SecPerClus;
	MOV  R30,R8
	__GETD2S 0
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	__PUTD1S 0
;    1102 	clus_addr += 2;
	__ADDD1N 2
	__PUTD1S 0
;    1103 	if (clus_addr > 0xFFFF)
	__GETD2S 0
	__CPD2N 0x10000
	BRLO _0xE9
;    1104 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x516
;    1105 	
;    1106 	return ((int) clus_addr);	
_0xE9:
	LD   R30,Y
	LDD  R31,Y+1
_0x516:
	ADIW R28,4
	RET
;    1107 }
;    1108 
;    1109 // Find the cluster that the current cluster is pointing to
;    1110 unsigned int next_cluster(unsigned int current_cluster, unsigned char mode)
;    1111 {
_next_cluster:
;    1112 	unsigned int calc_sec, calc_offset, calc_remainder, next_clust;
;    1113 	unsigned long addr_temp;
;    1114 	
;    1115 	if (current_cluster<=1)		// If cluster is 0 or 1, its the wrong cluster
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
	SBIW R26,2
	BRSH _0xEA
;    1116 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x515
;    1117 		
;    1118 	if (BPB_FATType == 0x36)		// if FAT16
_0xEA:
	LDI  R30,LOW(54)
	CP   R30,R14
	BREQ PC+3
	JMP _0xEB
;    1119 	{
;    1120 		// FAT16 table address calculations
;    1121 		calc_sec = current_cluster / (BPB_BytsPerSec / 2) + BPB_RsvdSecCnt;
	CALL SUBOPT_0x35
	CALL SUBOPT_0x36
;    1122 		calc_offset = 2 * (current_cluster % (BPB_BytsPerSec / 2));
	CALL SUBOPT_0x35
	CALL SUBOPT_0x37
;    1123 	    
;    1124 	 	addr_temp = _FF_PART_ADDR+(calc_sec*0x200);
	CALL SUBOPT_0x38
;    1125 		if (mode==SINGLE)
	CPI  R26,LOW(0x1)
	BRNE _0xEC
;    1126 		{	// This is a single cluster lookup
;    1127 			if (_FF_read(addr_temp)==0)
	__GETD1S 6
	CALL SUBOPT_0xC
	BRNE _0xED
;    1128 				return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x515
;    1129 		}
_0xED:
;    1130 		else if ((mode==CHAIN) || (mode==END_CHAIN))
	RJMP _0xEE
_0xEC:
	LDD  R26,Y+12
	CPI  R26,LOW(0x0)
	BREQ _0xF0
	CPI  R26,LOW(0x2)
	BRNE _0xEF
_0xF0:
;    1131 		{	// Mupltiple clusters to lookup
;    1132 			if (addr_temp!=_FF_buff_addr)
	CALL SUBOPT_0x39
	BREQ _0xF2
;    1133 			{	// Is the address of lookup is different then the current buffere address
;    1134 				#ifndef _READ_ONLY_
;    1135 				if (_FF_buff_addr)	// if the buffer address is 0, don't write
	LDS  R30,__FF_buff_addr
	LDS  R31,__FF_buff_addr+1
	LDS  R22,__FF_buff_addr+2
	LDS  R23,__FF_buff_addr+3
	CALL __CPD10
	BREQ _0xF3
;    1136 				{
;    1137 					#ifdef _SECOND_FAT_ON_
;    1138 						if (_FF_buff_addr < _FF_FAT2_ADDR)
	CALL SUBOPT_0x3A
	BRSH _0xF4
;    1139 							if (_FF_write(_FF_buff_addr+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
	CALL SUBOPT_0x3B
	BRNE _0xF5
;    1140 								return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x515
;    1141 					#endif
;    1142 					if (_FF_write(_FF_buff_addr)==0)	// Save buffer data to card
_0xF5:
_0xF4:
	CALL SUBOPT_0x3C
	BRNE _0xF6
;    1143 						return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x515
;    1144 				}
_0xF6:
;    1145 				#endif
;    1146 				if (_FF_read(addr_temp)==0)	// Read new table info
_0xF3:
	__GETD1S 6
	CALL SUBOPT_0xC
	BRNE _0xF7
;    1147 					return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x515
;    1148 			}
_0xF7:
;    1149 		}
_0xF2:
;    1150 		next_clust = ((int) _FF_buff[calc_offset+1] << 8) | _FF_buff[calc_offset];
_0xEF:
_0xEE:
	MOVW R30,R18
	__ADDW1MN __FF_buff,1
	LD   R31,Z
	LDI  R30,LOW(0)
	MOVW R0,R30
	CALL SUBOPT_0x3D
	MOVW R26,R0
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
;    1151 	}
;    1152 	#ifdef _FAT12_ON_
;    1153 	else if (BPB_FATType == 0x32)	// if FAT12
	RJMP _0xF8
_0xEB:
	LDI  R30,LOW(50)
	CP   R30,R14
	BREQ PC+3
	JMP _0xF9
;    1154 	{
;    1155 		// FAT12 table address calculations
;    1156 		calc_offset = (current_cluster * 3) / 2;
	CALL SUBOPT_0x3E
	LSR  R31
	ROR  R30
	MOVW R18,R30
;    1157 		calc_remainder = (current_cluster * 3) % 2;
	CALL SUBOPT_0x3E
	ANDI R30,LOW(0x1)
	ANDI R31,HIGH(0x1)
	MOVW R20,R30
;    1158 		calc_sec = (calc_offset / BPB_BytsPerSec) + BPB_RsvdSecCnt;
	CALL SUBOPT_0x3F
;    1159 		calc_offset %= BPB_BytsPerSec;
	CALL SUBOPT_0x40
;    1160 
;    1161 	 	addr_temp = _FF_PART_ADDR+(calc_sec*BPB_BytsPerSec);
	MOVW R30,R6
	MOVW R26,R16
	CALL __MULW12U
	LDS  R26,__FF_PART_ADDR
	LDS  R27,__FF_PART_ADDR+1
	LDS  R24,__FF_PART_ADDR+2
	LDS  R25,__FF_PART_ADDR+3
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1S 6
;    1162 		if (mode==SINGLE)
	LDD  R26,Y+12
	CPI  R26,LOW(0x1)
	BRNE _0xFA
;    1163 		{	// This is a single cluster lookup
;    1164 			if (_FF_read(addr_temp)==0)
	CALL SUBOPT_0xC
	BRNE _0xFB
;    1165 				return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x515
;    1166 		}
_0xFB:
;    1167 		else if ((mode==CHAIN) || (mode==END_CHAIN))
	RJMP _0xFC
_0xFA:
	LDD  R26,Y+12
	CPI  R26,LOW(0x0)
	BREQ _0xFE
	CPI  R26,LOW(0x2)
	BRNE _0xFD
_0xFE:
;    1168 		{	// Mupltiple clusters to lookup
;    1169 			if (addr_temp!=_FF_buff_addr)
	CALL SUBOPT_0x39
	BREQ _0x100
;    1170 			{	// Is the address of lookup is different then the current buffere address
;    1171 				#ifndef _READ_ONLY_
;    1172 				if (_FF_buff_addr)	// if the buffer address is 0, don't write
	LDS  R30,__FF_buff_addr
	LDS  R31,__FF_buff_addr+1
	LDS  R22,__FF_buff_addr+2
	LDS  R23,__FF_buff_addr+3
	CALL __CPD10
	BREQ _0x101
;    1173 				{
;    1174 					#ifdef _SECOND_FAT_ON_
;    1175 						if (_FF_buff_addr < _FF_FAT2_ADDR)
	CALL SUBOPT_0x3A
	BRSH _0x102
;    1176 							if (_FF_write(_FF_buff_addr+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
	CALL SUBOPT_0x3B
	BRNE _0x103
;    1177 								return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x515
;    1178 					#endif
;    1179 					if (_FF_write(_FF_buff_addr)==0)	// Save buffer data to card
_0x103:
_0x102:
	CALL SUBOPT_0x3C
	BRNE _0x104
;    1180 						return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x515
;    1181 				}
_0x104:
;    1182 				#endif
;    1183 				if (_FF_read(addr_temp)==0)	// Read new table info
_0x101:
	__GETD1S 6
	CALL SUBOPT_0xC
	BRNE _0x105
;    1184 					return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x515
;    1185 			}
_0x105:
;    1186 		}
_0x100:
;    1187 		next_clust = _FF_buff[calc_offset];
_0xFD:
_0xFC:
	CALL SUBOPT_0x3D
	LDI  R31,0
	STD  Y+10,R30
	STD  Y+10+1,R31
;    1188 		if (calc_offset == (BPB_BytsPerSec-1))
	CALL SUBOPT_0x41
	BRNE _0x106
;    1189 		{	// Is the FAT12 record accross more than one sector?
;    1190 			addr_temp = _FF_PART_ADDR+((calc_sec+1)*0x200);
	MOVW R30,R16
	ADIW R30,1
	CALL SUBOPT_0x38
;    1191 			if ((mode==CHAIN) || (mode==END_CHAIN))
	CPI  R26,LOW(0x0)
	BREQ _0x108
	LDD  R26,Y+12
	CPI  R26,LOW(0x2)
	BRNE _0x107
_0x108:
;    1192 			{	// multiple chain lookup
;    1193 				#ifndef _READ_ONLY_
;    1194 					#ifdef _SECOND_FAT_ON_
;    1195 						if (_FF_buff_addr < _FF_FAT2_ADDR)
	CALL SUBOPT_0x3A
	BRSH _0x10A
;    1196 							if (_FF_write(_FF_buff_addr+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
	CALL SUBOPT_0x3B
	BRNE _0x10B
;    1197 								return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x515
;    1198 					#endif
;    1199 				if (_FF_write(_FF_buff_addr)==0)	// Save buffer data to card
_0x10B:
_0x10A:
	CALL SUBOPT_0x3C
	BRNE _0x10C
;    1200 					return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x515
;    1201 				#endif
;    1202 				_FF_buff_addr = addr_temp;		// Save new buffer address
_0x10C:
	__GETD1S 6
	STS  __FF_buff_addr,R30
	STS  __FF_buff_addr+1,R31
	STS  __FF_buff_addr+2,R22
	STS  __FF_buff_addr+3,R23
;    1203 			}
;    1204 			if (_FF_read(addr_temp)==0)
_0x107:
	__GETD1S 6
	CALL SUBOPT_0xC
	BRNE _0x10D
;    1205 				return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x515
;    1206 			next_clust |= ((int) _FF_buff[0] << 8);
_0x10D:
	LDS  R31,__FF_buff
	RJMP _0x525
;    1207 		}
;    1208 		else
_0x106:
;    1209 			next_clust |= ((int) _FF_buff[calc_offset+1] << 8);
	MOVW R30,R18
	__ADDW1MN __FF_buff,1
	LD   R31,Z
_0x525:
	LDI  R30,LOW(0)
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	OR   R30,R26
	OR   R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
;    1210 
;    1211 		if (calc_remainder)
	MOV  R0,R20
	OR   R0,R21
	BREQ _0x10F
;    1212 			next_clust >>= 4;
	CALL __LSRW4
	RJMP _0x526
;    1213 		else
_0x10F:
;    1214 			next_clust &= 0x0FFF;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ANDI R31,HIGH(0xFFF)
_0x526:
	STD  Y+10,R30
	STD  Y+10+1,R31
;    1215 			
;    1216 		if (next_clust >= 0xFF8)
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CPI  R26,LOW(0xFF8)
	LDI  R30,HIGH(0xFF8)
	CPC  R27,R30
	BRLO _0x111
;    1217 			next_clust |= 0xF000;			
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ORI  R31,HIGH(0xF000)
	STD  Y+10,R30
	STD  Y+10+1,R31
;    1218 	}
_0x111:
;    1219 	#endif
;    1220 	else		// not FAT12 or FAT16, return 0
	RJMP _0x112
_0xF9:
;    1221 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x515
;    1222 	return (next_clust);
_0x112:
_0xF8:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
_0x515:
	CALL __LOADLOCR6
	ADIW R28,15
	RET
;    1223 }
;    1224 
;    1225 // Convert a constant string file name into the proper 8.3 FAT format
;    1226 unsigned char *file_name_conversion(unsigned char *current_file)
;    1227 {
_file_name_conversion:
;    1228 	unsigned char n, c;
;    1229 		
;    1230 	c = 0;
	ST   -Y,R17
	ST   -Y,R16
;	*current_file -> Y+2
;	n -> R16
;	c -> R17
	LDI  R17,LOW(0)
;    1231 	
;    1232 	for (n=0; n<14; n++)
	LDI  R16,LOW(0)
_0x114:
	CPI  R16,14
	BRSH _0x115
;    1233 	{
;    1234 		if (valid_file_char(current_file[n])==0)
	CALL SUBOPT_0x42
	CALL SUBOPT_0x1D
	BRNE _0x116
;    1235 			// If the character is valid, save in uppercase to file name buffer
;    1236 			FILENAME[c++] = toupper(current_file[n]);
	MOV  R30,R17
	SUBI R17,-1
	LDI  R31,0
	SUBI R30,LOW(-_FILENAME)
	SBCI R31,HIGH(-_FILENAME)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x42
	CALL SUBOPT_0x43
	POP  R26
	POP  R27
	ST   X,R30
;    1237 		else if (current_file[n]=='.')
	RJMP _0x117
_0x116:
	CALL SUBOPT_0x42
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BRNE _0x118
;    1238 			// If it is a period, back fill buffer with [spaces], till 8 characters deep
;    1239 			while (c<8)
_0x119:
	CPI  R17,8
	BRSH _0x11B
;    1240 				FILENAME[c++] = 0x20;
	MOV  R30,R17
	SUBI R17,-1
	CALL SUBOPT_0x44
;    1241 		else if (current_file[n]==0)
	RJMP _0x119
_0x11B:
	RJMP _0x11C
_0x118:
	CALL SUBOPT_0x42
	LD   R30,X
	CPI  R30,0
	BRNE _0x11D
;    1242 		{	// If it is NULL, back fill buffer with [spaces], till 11 characters deep
;    1243 			while (c<11)
_0x11E:
	CPI  R17,11
	BRSH _0x120
;    1244 				FILENAME[c++] = 0x20;
	MOV  R30,R17
	SUBI R17,-1
	CALL SUBOPT_0x44
;    1245 			break;
	RJMP _0x11E
_0x120:
	RJMP _0x115
;    1246 		}
;    1247 		else
_0x11D:
;    1248 		{
;    1249 			_FF_error = NAME_ERR;
	LDI  R30,LOW(5)
	STS  __FF_error,R30
;    1250 			return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x514
;    1251 		}
_0x11C:
_0x117:
;    1252 		if (c>=11)
	CPI  R17,11
	BRSH _0x115
;    1253 			break;
;    1254 	}
	SUBI R16,-1
	RJMP _0x114
_0x115:
;    1255 	FILENAME[c] = 0;
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_FILENAME)
	SBCI R27,HIGH(-_FILENAME)
	LDI  R30,LOW(0)
	ST   X,R30
;    1256 	// Return the pointer of the filename
;    1257 	return (FILENAME);		
	LDI  R30,LOW(_FILENAME)
	LDI  R31,HIGH(_FILENAME)
_0x514:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
;    1258 }
;    1259 
;    1260 // Find the first cluster that is pointing to clus_no
;    1261 unsigned int prev_cluster(unsigned int clus_no)
;    1262 {
_prev_cluster:
;    1263 	unsigned char read_flag;
;    1264 	unsigned int calc_temp, n, c, n_temp;
;    1265 	unsigned long calc_clus, addr_temp;
;    1266 	
;    1267 	addr_temp = _FF_FAT1_ADDR;
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
;    1268 	c = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+15,R30
	STD  Y+15+1,R31
;    1269 	if ((clus_no==0) && (BPB_FATType==0x36))
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	CALL __CPW02
	BRNE _0x124
	LDI  R30,LOW(54)
	CP   R30,R14
	BREQ _0x125
_0x124:
	RJMP _0x123
_0x125:
;    1270 	{
;    1271 		if (clus_0_addr>addr_temp)
	__GETD1S 5
	LDS  R26,_clus_0_addr
	LDS  R27,_clus_0_addr+1
	LDS  R24,_clus_0_addr+2
	LDS  R25,_clus_0_addr+3
	CALL __CPD12
	BRSH _0x126
;    1272 		{
;    1273 			addr_temp = clus_0_addr;
	LDS  R30,_clus_0_addr
	LDS  R31,_clus_0_addr+1
	LDS  R22,_clus_0_addr+2
	LDS  R23,_clus_0_addr+3
	__PUTD1S 5
;    1274 			c = c_counter;
	LDS  R30,_c_counter
	LDS  R31,_c_counter+1
	STD  Y+15,R30
	STD  Y+15+1,R31
;    1275 		}
;    1276 	}
_0x126:
;    1277 
;    1278 	read_flag = 1;
_0x123:
	LDI  R16,LOW(1)
;    1279 	
;    1280 	while (addr_temp<_FF_FAT2_ADDR)
_0x127:
	LDS  R30,__FF_FAT2_ADDR
	LDS  R31,__FF_FAT2_ADDR+1
	LDS  R22,__FF_FAT2_ADDR+2
	LDS  R23,__FF_FAT2_ADDR+3
	__GETD2S 5
	CALL __CPD21
	BRLO PC+3
	JMP _0x129
;    1281 	{
;    1282 		if (BPB_FATType == 0x36)		// if FAT16
	LDI  R30,LOW(54)
	CP   R30,R14
	BREQ PC+3
	JMP _0x12A
;    1283 		{
;    1284 			if (clus_no==0)
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	SBIW R30,0
	BRNE _0x12B
;    1285 			{
;    1286 				clus_0_addr = addr_temp;
	__GETD1S 5
	STS  _clus_0_addr,R30
	STS  _clus_0_addr+1,R31
	STS  _clus_0_addr+2,R22
	STS  _clus_0_addr+3,R23
;    1287 				c_counter = c;
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	STS  _c_counter,R30
	STS  _c_counter+1,R31
;    1288 			}
;    1289 			if (_FF_read(addr_temp)==0)		// Read error ==> break
_0x12B:
	__GETD1S 5
	CALL SUBOPT_0xC
	BRNE _0x12C
;    1290 				return(0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x513
;    1291 			if (_FF_n_temp)
_0x12C:
	LDS  R30,__FF_n_temp
	LDS  R31,__FF_n_temp+1
	LDS  R22,__FF_n_temp+2
	LDS  R23,__FF_n_temp+3
	CALL __CPD10
	BREQ _0x12D
;    1292 			{
;    1293 				n_temp = _FF_n_temp;
	LDS  R30,__FF_n_temp
	LDS  R31,__FF_n_temp+1
	STD  Y+13,R30
	STD  Y+13+1,R31
;    1294 				_FF_n_temp = 0;
	LDI  R30,0
	STS  __FF_n_temp,R30
	STS  __FF_n_temp+1,R30
	STS  __FF_n_temp+2,R30
	STS  __FF_n_temp+3,R30
;    1295 			}
;    1296 			else
	RJMP _0x12E
_0x12D:
;    1297 				n_temp = 0;
	LDI  R30,0
	STD  Y+13,R30
	STD  Y+13+1,R30
;    1298 			for (n=n_temp; n<(BPB_BytsPerSec/2); n++)
_0x12E:
	__GETWRS 19,20,13
_0x130:
	MOVW R30,R6
	LSR  R31
	ROR  R30
	CP   R19,R30
	CPC  R20,R31
	BRLO PC+3
	JMP _0x131
;    1299 			{
;    1300 				calc_clus = ((unsigned int) _FF_buff[(n*2)+1] << 8) | ((unsigned int) _FF_buff[n*2]);
	__GETW1R 19,20
	LSL  R30
	ROL  R31
	__ADDW1MN __FF_buff,1
	CALL SUBOPT_0x30
	__GETW1R 19,20
	LSL  R30
	ROL  R31
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	LD   R30,Z
	CALL SUBOPT_0xF
	__PUTD1S 9
;    1301 				calc_temp = (unsigned long) n + (((unsigned long) BPB_BytsPerSec/2) * ((unsigned long) c - 1));
	__GETW1R 19,20
	CLR  R22
	CLR  R23
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R6
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
;    1302 				if (calc_clus==clus_no)
	CALL SUBOPT_0x45
	BRNE _0x132
;    1303 				{
;    1304 					if (calc_clus==0)
	__GETD1S 9
	CALL __CPD10
	BRNE _0x133
;    1305 						_FF_n_temp = n;
	__GETW1R 19,20
	CLR  R22
	CLR  R23
	STS  __FF_n_temp,R30
	STS  __FF_n_temp+1,R31
	STS  __FF_n_temp+2,R22
	STS  __FF_n_temp+3,R23
;    1306 					return(calc_temp);
_0x133:
	__GETW1R 17,18
	RJMP _0x513
;    1307 				}
;    1308 				else if (calc_temp > DataClusTot)
_0x132:
	LDS  R30,_DataClusTot
	LDS  R31,_DataClusTot+1
	LDS  R22,_DataClusTot+2
	LDS  R23,_DataClusTot+3
	__GETW2R 17,18
	CLR  R24
	CLR  R25
	CALL __CPD12
	BRSH _0x135
;    1309 				{
;    1310 					_FF_error = DISK_FULL;
	CALL SUBOPT_0x46
;    1311 					return (0);
	RJMP _0x513
;    1312 				}
;    1313 			}
_0x135:
	__ADDWRN 19,20,1
	RJMP _0x130
_0x131:
;    1314 			addr_temp += 0x200;
	CALL SUBOPT_0x47
;    1315 			c++;
	CALL SUBOPT_0x48
;    1316 		}
;    1317 		#ifdef _FAT12_ON_
;    1318 		else if (BPB_FATType == 0x32)	// if FAT12
	RJMP _0x136
_0x12A:
	LDI  R30,LOW(50)
	CP   R30,R14
	BREQ PC+3
	JMP _0x137
;    1319 		{
;    1320 			if (read_flag)
	CPI  R16,0
	BREQ _0x138
;    1321 			{
;    1322 				if (_FF_read(addr_temp)==0)
	__GETD1S 5
	CALL SUBOPT_0xC
	BRNE _0x139
;    1323 					return (0);	// if the read fails return 0
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x513
;    1324 				read_flag = 0;
_0x139:
	LDI  R16,LOW(0)
;    1325 			}
;    1326 			calc_temp = ((unsigned long) c * 3) / 2;
_0x138:
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	CLR  R22
	CLR  R23
	__GETD2N 0x3
	CALL __MULD12U
	CALL __LSRD1
	__PUTW1R 17,18
;    1327 			calc_temp %= BPB_BytsPerSec;
	MOVW R30,R6
	__GETW2R 17,18
	CALL __MODW21U
	__PUTW1R 17,18
;    1328 			calc_clus = _FF_buff[calc_temp++];
	__GETW1R 17,18
	__ADDWRN 17,18,1
	CALL SUBOPT_0x1A
	__PUTD1S 9
;    1329 			if (calc_temp == BPB_BytsPerSec)
	__CPWRR 6,7,17,18
	BRNE _0x13A
;    1330 			{	// Is the FAT12 record accross a sector?
;    1331 				addr_temp += 0x200;
	CALL SUBOPT_0x47
;    1332 				if (_FF_read(addr_temp)==0)
	__GETD1S 5
	CALL SUBOPT_0xC
	BRNE _0x13B
;    1333 					return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x513
;    1334 				calc_clus |= ((unsigned int) _FF_buff[0] << 8);
_0x13B:
	LDS  R31,__FF_buff
	CALL SUBOPT_0x49
;    1335 				calc_temp = 0;
	__GETWRN 17,18,0
;    1336 			}
;    1337 			else
	RJMP _0x13C
_0x13A:
;    1338 				calc_clus |= ((unsigned int) _FF_buff[calc_temp++] << 8);
	__GETW1R 17,18
	__ADDWRN 17,18,1
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	LD   R31,Z
	CALL SUBOPT_0x49
;    1339                           	
;    1340 			if (c % 2)
_0x13C:
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ANDI R30,LOW(0x1)
	BREQ _0x13D
;    1341 				calc_clus >>= 4;
	__GETD2S 9
	LDI  R30,LOW(4)
	CALL __LSRD12
	RJMP _0x527
;    1342 			else
_0x13D:
;    1343 				calc_clus &= 0x0FFF;
	__GETD1S 9
	__ANDD1N 0xFFF
_0x527:
	__PUTD1S 9
;    1344 			
;    1345 			if (calc_clus == clus_no)
	CALL SUBOPT_0x45
	BRNE _0x13F
;    1346 				return (c);
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	RJMP _0x513
;    1347 			else if (c > DataClusTot)
_0x13F:
	LDS  R30,_DataClusTot
	LDS  R31,_DataClusTot+1
	LDS  R22,_DataClusTot+2
	LDS  R23,_DataClusTot+3
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	CLR  R24
	CLR  R25
	CALL __CPD12
	BRSH _0x141
;    1348 			{
;    1349 				_FF_error = DISK_FULL;
	CALL SUBOPT_0x46
;    1350 				return (0);
	RJMP _0x513
;    1351 			}
;    1352 			if ((calc_temp == BPB_BytsPerSec) && (c % 2))
_0x141:
	__CPWRR 6,7,17,18
	BRNE _0x143
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ANDI R30,LOW(0x1)
	BRNE _0x144
_0x143:
	RJMP _0x142
_0x144:
;    1353 			{
;    1354 				addr_temp += 0x200;
	CALL SUBOPT_0x47
;    1355 				read_flag = 1;
	LDI  R16,LOW(1)
;    1356 			}                                                           
;    1357 			
;    1358 			c++;			
_0x142:
	CALL SUBOPT_0x48
;    1359 		}
;    1360 		#endif
;    1361 		else
	RJMP _0x145
_0x137:
;    1362 			return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x513
;    1363 	}
_0x145:
_0x136:
	RJMP _0x127
_0x129:
;    1364 	_FF_error = DISK_FULL;
	CALL SUBOPT_0x46
;    1365 	return (0);
_0x513:
	CALL __LOADLOCR5
	ADIW R28,19
	RET
;    1366 }
;    1367 
;    1368 #ifndef _READ_ONLY_
;    1369 // Update cluster table to point to new cluster
;    1370 unsigned char write_clus_table(unsigned int current_cluster, unsigned int next_value, unsigned char mode)
;    1371 {
_write_clus_table:
;    1372 	unsigned long addr_temp;
;    1373 	unsigned int calc_sec, calc_offset, calc_temp, calc_remainder;
;    1374 	unsigned char nibble[3];
;    1375 	
;    1376 	if (current_cluster <=1)		// Should never be writing to cluster 0 or 1
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
	SBIW R26,2
	BRSH _0x146
;    1377 	{
;    1378 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x512
;    1379 	}
;    1380 	if (BPB_FATType == 0x36)		// if FAT16
_0x146:
	LDI  R30,LOW(54)
	CP   R30,R14
	BREQ PC+3
	JMP _0x147
;    1381 	{
;    1382 		calc_sec = current_cluster / (BPB_BytsPerSec / 2) + BPB_RsvdSecCnt;
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x36
;    1383 		calc_offset = 2 * (current_cluster % (BPB_BytsPerSec / 2));
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x37
;    1384 		addr_temp = _FF_PART_ADDR + ((long) calc_sec*0x200);
	CLR  R22
	CLR  R23
	__GETD2N 0x200
	CALL SUBOPT_0x33
	CALL SUBOPT_0x4B
;    1385 		if (mode==SINGLE)
	BRNE _0x148
;    1386 		{	// Updating a single cluster (like writing or saving a file)
;    1387 			if (_FF_read(addr_temp)==0)
	__GETD1S 11
	CALL SUBOPT_0xC
	BRNE _0x149
;    1388 				return(0);
	LDI  R30,LOW(0)
	RJMP _0x512
;    1389 		}
_0x149:
;    1390 		else if ((mode==CHAIN) || (mode==END_CHAIN))
	RJMP _0x14A
_0x148:
	LDD  R26,Y+15
	CPI  R26,LOW(0x0)
	BREQ _0x14C
	CPI  R26,LOW(0x2)
	BRNE _0x14B
_0x14C:
;    1391 		{	// Multiple table access operation
;    1392 			if (addr_temp!=_FF_buff_addr)
	CALL SUBOPT_0x4C
	BREQ _0x14E
;    1393 			{	// if the desired address is already in the buffer => skip loading buffer
;    1394 				if (_FF_buff_addr)	// if new table address, write buffered, and load new
	LDS  R30,__FF_buff_addr
	LDS  R31,__FF_buff_addr+1
	LDS  R22,__FF_buff_addr+2
	LDS  R23,__FF_buff_addr+3
	CALL __CPD10
	BREQ _0x14F
;    1395 				{
;    1396 					#ifdef _SECOND_FAT_ON_
;    1397 						if (_FF_buff_addr < _FF_FAT2_ADDR)
	CALL SUBOPT_0x3A
	BRSH _0x150
;    1398 							if (_FF_write(_FF_buff_addr+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
	CALL SUBOPT_0x3B
	BRNE _0x151
;    1399 								return(0);
	LDI  R30,LOW(0)
	RJMP _0x512
;    1400 					#endif
;    1401 					if (_FF_write(_FF_buff_addr)==0)
_0x151:
_0x150:
	CALL SUBOPT_0x3C
	BRNE _0x152
;    1402 						return(0);
	LDI  R30,LOW(0)
	RJMP _0x512
;    1403 				}
_0x152:
;    1404 				if (_FF_read(addr_temp)==0)
_0x14F:
	__GETD1S 11
	CALL SUBOPT_0xC
	BRNE _0x153
;    1405 					return(0);
	LDI  R30,LOW(0)
	RJMP _0x512
;    1406 			}
_0x153:
;    1407 		}
_0x14E:
;    1408 				
;    1409 		_FF_buff[calc_offset+1] = (next_value >> 8); 
_0x14B:
_0x14A:
	MOVW R30,R18
	__ADDW1MN __FF_buff,1
	MOVW R26,R30
	LDD  R30,Y+17
	ANDI R31,HIGH(0x0)
	ST   X,R30
;    1410 		_FF_buff[calc_offset] = (next_value & 0xFF);
	MOVW R26,R18
	SUBI R26,LOW(-__FF_buff)
	SBCI R27,HIGH(-__FF_buff)
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ANDI R31,HIGH(0xFF)
	CALL SUBOPT_0x4D
;    1411 		if ((mode==SINGLE) || (mode==END_CHAIN))
	BREQ _0x155
	LDD  R26,Y+15
	CPI  R26,LOW(0x2)
	BRNE _0x154
_0x155:
;    1412 		{
;    1413 			#ifdef _SECOND_FAT_ON_
;    1414 				if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
	CALL SUBOPT_0x4E
	BRNE _0x157
;    1415 					return(0);
	LDI  R30,LOW(0)
	RJMP _0x512
;    1416 			#endif
;    1417 			if (_FF_write(addr_temp)==0)
_0x157:
	CALL SUBOPT_0x4F
	BRNE _0x158
;    1418 			{
;    1419 				return(0);
	LDI  R30,LOW(0)
	RJMP _0x512
;    1420 			}
;    1421 		}
_0x158:
;    1422 	}
_0x154:
;    1423 	#ifdef _FAT12_ON_
;    1424 		else if (BPB_FATType == 0x32)		// if FAT12
	RJMP _0x159
_0x147:
	LDI  R30,LOW(50)
	CP   R30,R14
	BREQ PC+3
	JMP _0x15A
;    1425 		{
;    1426 			calc_offset = (current_cluster * 3) / 2;
	CALL SUBOPT_0x50
	LSR  R31
	ROR  R30
	MOVW R18,R30
;    1427 			calc_remainder = (current_cluster * 3) % 2;
	CALL SUBOPT_0x50
	ANDI R30,LOW(0x1)
	ANDI R31,HIGH(0x1)
	STD  Y+9,R30
	STD  Y+9+1,R31
;    1428 			calc_sec = calc_offset / BPB_BytsPerSec + BPB_RsvdSecCnt;
	CALL SUBOPT_0x3F
;    1429 			calc_offset %= BPB_BytsPerSec;
	CALL SUBOPT_0x40
;    1430 			addr_temp = _FF_PART_ADDR + ((long) calc_sec * (long) BPB_BytsPerSec);
	MOVW R30,R16
	CALL SUBOPT_0xE
	LDS  R26,__FF_PART_ADDR
	LDS  R27,__FF_PART_ADDR+1
	LDS  R24,__FF_PART_ADDR+2
	LDS  R25,__FF_PART_ADDR+3
	CALL __ADDD12
	CALL SUBOPT_0x4B
;    1431 
;    1432 			if (mode==SINGLE)
	BRNE _0x15B
;    1433 			{
;    1434 				if (_FF_read(addr_temp)==0)
	__GETD1S 11
	CALL SUBOPT_0xC
	BRNE _0x15C
;    1435 					return(0);
	LDI  R30,LOW(0)
	RJMP _0x512
;    1436  			}
_0x15C:
;    1437  			else if ((mode==CHAIN) || (mode==END_CHAIN))
	RJMP _0x15D
_0x15B:
	LDD  R26,Y+15
	CPI  R26,LOW(0x0)
	BREQ _0x15F
	CPI  R26,LOW(0x2)
	BRNE _0x15E
_0x15F:
;    1438   			{
;    1439 				if (addr_temp!=_FF_buff_addr)
	CALL SUBOPT_0x4C
	BREQ _0x161
;    1440 				{
;    1441 					if (_FF_buff_addr)
	LDS  R30,__FF_buff_addr
	LDS  R31,__FF_buff_addr+1
	LDS  R22,__FF_buff_addr+2
	LDS  R23,__FF_buff_addr+3
	CALL __CPD10
	BREQ _0x162
;    1442 					{
;    1443 					#ifdef _SECOND_FAT_ON_
;    1444 						if (_FF_buff_addr < _FF_FAT2_ADDR)
	CALL SUBOPT_0x3A
	BRSH _0x163
;    1445 							if (_FF_write(_FF_buff_addr+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
	CALL SUBOPT_0x3B
	BRNE _0x164
;    1446 								return(0);
	LDI  R30,LOW(0)
	RJMP _0x512
;    1447 					#endif
;    1448 						if (_FF_write(_FF_buff_addr)==0)
_0x164:
_0x163:
	CALL SUBOPT_0x3C
	BRNE _0x165
;    1449 							return(0);
	LDI  R30,LOW(0)
	RJMP _0x512
;    1450 					}
_0x165:
;    1451 					if (_FF_read(addr_temp)==0)
_0x162:
	__GETD1S 11
	CALL SUBOPT_0xC
	BRNE _0x166
;    1452 						return(0);
	LDI  R30,LOW(0)
	RJMP _0x512
;    1453 				}
_0x166:
;    1454 			}
_0x161:
;    1455 			nibble[0] = next_value & 0x00F;
_0x15E:
_0x15D:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	STD  Y+6,R30
;    1456 			nibble[1] = (next_value >> 4) & 0x00F;
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	CALL __LSRW4
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	STD  Y+7,R30
;    1457 			nibble[2] = (next_value >> 8) & 0x00F;
	LDD  R30,Y+17
	ANDI R31,HIGH(0x0)
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	STD  Y+8,R30
;    1458     	
;    1459 			if (calc_offset == (BPB_BytsPerSec-1))
	CALL SUBOPT_0x41
	BREQ PC+3
	JMP _0x167
;    1460 			{	// Is the FAT12 record accross a sector?
;    1461 				if (calc_remainder)
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	SBIW R30,0
	BREQ _0x168
;    1462 				{	// Record table uses 1 nibble of last byte
;    1463 					calc_temp = _FF_buff[calc_offset] & 0x0F;	// Mask to add new value
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x51
;    1464 					_FF_buff[calc_offset] = calc_temp | (nibble[0] << 4);	// store nibble in correct location
;    1465 					#ifdef _SECOND_FAT_ON_
;    1466 						if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
	CALL SUBOPT_0x4E
	BRNE _0x169
;    1467 							return(0);
	LDI  R30,LOW(0)
	RJMP _0x512
;    1468 					#endif
;    1469 					if (_FF_write(addr_temp)==0)
_0x169:
	CALL SUBOPT_0x4F
	BRNE _0x16A
;    1470 						return(0);
	LDI  R30,LOW(0)
	RJMP _0x512
;    1471 					addr_temp += BPB_BytsPerSec;
_0x16A:
	CALL SUBOPT_0x52
;    1472 					if (_FF_read(addr_temp)==0)
	BRNE _0x16B
;    1473 						return(0);	// if the read fails return 0
	LDI  R30,LOW(0)
	RJMP _0x512
;    1474 					_FF_buff[0] = (nibble[2] << 4) | nibble[1];
_0x16B:
	CALL SUBOPT_0x53
	CALL SUBOPT_0x54
;    1475 					if ((mode==SINGLE) || (mode==END_CHAIN))
	BREQ _0x16D
	LDD  R26,Y+15
	CPI  R26,LOW(0x2)
	BRNE _0x16C
_0x16D:
;    1476 					{
;    1477 						#ifdef _SECOND_FAT_ON_
;    1478 							if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
	CALL SUBOPT_0x4E
	BRNE _0x16F
;    1479 								return(0);
	LDI  R30,LOW(0)
	RJMP _0x512
;    1480 						#endif
;    1481 						if (_FF_write(addr_temp)==0)
_0x16F:
	CALL SUBOPT_0x4F
	BRNE _0x170
;    1482 							return(0);
	LDI  R30,LOW(0)
	RJMP _0x512
;    1483 					}
_0x170:
;    1484 				}
_0x16C:
;    1485 				else
	RJMP _0x171
_0x168:
;    1486 				{	// Record table uses whole last byte
;    1487 					_FF_buff[calc_offset] = (nibble[1] << 4) | nibble[0];
	CALL SUBOPT_0x55
;    1488 					#ifdef _SECOND_FAT_ON_
;    1489 						if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
	CALL SUBOPT_0x4E
	BRNE _0x172
;    1490 							return(0);
	LDI  R30,LOW(0)
	RJMP _0x512
;    1491 					#endif
;    1492 					if (_FF_write(addr_temp)==0)
_0x172:
	CALL SUBOPT_0x4F
	BRNE _0x173
;    1493 						return(0);
	LDI  R30,LOW(0)
	RJMP _0x512
;    1494 					addr_temp += BPB_BytsPerSec;
_0x173:
	CALL SUBOPT_0x52
;    1495 					if (_FF_read(addr_temp)==0)
	BRNE _0x174
;    1496 						return(0);	// if the read fails return 0
	LDI  R30,LOW(0)
	RJMP _0x512
;    1497 					calc_temp = _FF_buff[0] & 0xF0;		// Mask to add new value
_0x174:
	LDS  R30,__FF_buff
	CALL SUBOPT_0x56
;    1498 					_FF_buff[0] = calc_temp | nibble[2];	// store nibble in correct location
	CALL SUBOPT_0x57
	OR   R30,R26
	CALL SUBOPT_0x54
;    1499 					if ((mode==SINGLE) || (mode==END_CHAIN))
	BREQ _0x176
	LDD  R26,Y+15
	CPI  R26,LOW(0x2)
	BRNE _0x175
_0x176:
;    1500 					{
;    1501 						#ifdef _SECOND_FAT_ON_
;    1502 							if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
	CALL SUBOPT_0x4E
	BRNE _0x178
;    1503 								return(0);
	LDI  R30,LOW(0)
	RJMP _0x512
;    1504 						#endif
;    1505 						if (_FF_write(addr_temp)==0)
_0x178:
	CALL SUBOPT_0x4F
	BRNE _0x179
;    1506 							return(0);
	LDI  R30,LOW(0)
	RJMP _0x512
;    1507 					}
_0x179:
;    1508 				}
_0x175:
_0x171:
;    1509 			}
;    1510 			else
	RJMP _0x17A
_0x167:
;    1511 			{
;    1512 				if (calc_remainder)
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	SBIW R30,0
	BREQ _0x17B
;    1513 				{	// Record table uses 1 nibble of current byte
;    1514 					calc_temp = _FF_buff[calc_offset] & 0x0F;	// Mask to add new value
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x51
;    1515 					_FF_buff[calc_offset] = calc_temp | (nibble[0] << 4);	// store nibble in correct location
;    1516 					_FF_buff[calc_offset+1] = (nibble[2] << 4) | nibble[1];
	MOVW R30,R18
	__ADDW1MN __FF_buff,1
	MOVW R0,R30
	CALL SUBOPT_0x53
	MOVW R26,R0
	CALL SUBOPT_0x4D
;    1517 					if ((mode==SINGLE) || (mode==END_CHAIN))
	BREQ _0x17D
	LDD  R26,Y+15
	CPI  R26,LOW(0x2)
	BRNE _0x17C
_0x17D:
;    1518 					{
;    1519 						#ifdef _SECOND_FAT_ON_
;    1520 							if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
	CALL SUBOPT_0x4E
	BRNE _0x17F
;    1521 								return(0);
	LDI  R30,LOW(0)
	RJMP _0x512
;    1522 						#endif
;    1523 						if (_FF_write(addr_temp)==0)
_0x17F:
	CALL SUBOPT_0x4F
	BRNE _0x180
;    1524 							return(0);
	LDI  R30,LOW(0)
	RJMP _0x512
;    1525 					}
_0x180:
;    1526 				}
_0x17C:
;    1527 				else
	RJMP _0x181
_0x17B:
;    1528 				{	// Record table uses whole current byte
;    1529 					_FF_buff[calc_offset] = (nibble[1] << 4) | nibble[0];
	CALL SUBOPT_0x55
;    1530 					calc_temp = _FF_buff[calc_offset+1] & 0xF0;		// Mask to add new value
	MOVW R30,R18
	__ADDW1MN __FF_buff,1
	LD   R30,Z
	CALL SUBOPT_0x56
;    1531 					_FF_buff[calc_offset+1] = calc_temp | nibble[2];	// store nibble in correct location
	MOVW R30,R18
	__ADDW1MN __FF_buff,1
	MOVW R0,R30
	CALL SUBOPT_0x57
	OR   R30,R26
	OR   R31,R27
	MOVW R26,R0
	CALL SUBOPT_0x4D
;    1532 					if ((mode==SINGLE) || (mode==END_CHAIN))
	BREQ _0x183
	LDD  R26,Y+15
	CPI  R26,LOW(0x2)
	BRNE _0x182
_0x183:
;    1533 					{
;    1534 						#ifdef _SECOND_FAT_ON_
;    1535 							if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
	CALL SUBOPT_0x4E
	BRNE _0x185
;    1536 								return(0);
	LDI  R30,LOW(0)
	RJMP _0x512
;    1537 						#endif
;    1538 						if (_FF_write(addr_temp)==0)
_0x185:
	CALL SUBOPT_0x4F
	BRNE _0x186
;    1539 							return(0);
	LDI  R30,LOW(0)
	RJMP _0x512
;    1540 					}
_0x186:
;    1541 				}
_0x182:
_0x181:
;    1542 			}
_0x17A:
;    1543 		}
;    1544 	#endif
;    1545 	else		// not FAT12 or FAT16, return 0
	RJMP _0x187
_0x15A:
;    1546 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x512
;    1547 		
;    1548 	return(1);	
_0x187:
_0x159:
	LDI  R30,LOW(1)
_0x512:
	CALL __LOADLOCR6
	ADIW R28,20
	RET
;    1549 }
;    1550 #endif
;    1551 
;    1552 #ifndef _READ_ONLY_
;    1553 // Save new entry data to FAT entry
;    1554 unsigned char append_toc(FILE *rp)
;    1555 {
_append_toc:
;    1556 	unsigned long file_data;
;    1557 	unsigned char n;
;    1558 	unsigned char *fp;
;    1559 	unsigned int calc_temp, calc_date;
;    1560 	
;    1561 	if (rp==NULL)
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
	BRNE _0x188
;    1562 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x511
;    1563 
;    1564 	file_data = rp->length;
_0x188:
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	CALL __GETD1P
	__PUTD1S 7
;    1565 	if (_FF_read(rp->entry_sec_addr)==0)
	CALL SUBOPT_0x58
	CALL __FF_read
	CPI  R30,0
	BRNE _0x189
;    1566 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x511
;    1567 	
;    1568 	// Update Starting Cluster 
;    1569 	fp = &_FF_buff[rp->entry_offset+0x1a];
_0x189:
	CALL SUBOPT_0x59
	__ADDW1MN __FF_buff,26
	__PUTW1R 17,18
;    1570 	*fp++ = rp->clus_start & 0xFF;
	PUSH R18
	PUSH R17
	__ADDWRN 17,18,1
	CALL SUBOPT_0x5A
	ANDI R31,HIGH(0xFF)
	POP  R26
	POP  R27
	ST   X,R30
;    1571 	*fp++ = rp->clus_start >> 8;
	PUSH R18
	PUSH R17
	__ADDWRN 17,18,1
	CALL SUBOPT_0x5A
	MOV  R30,R31
	LDI  R31,0
	POP  R26
	POP  R27
	ST   X,R30
;    1572 	
;    1573 	// Update the File Size
;    1574 	for (n=0; n<4; n++)
	LDI  R16,LOW(0)
_0x18B:
	CPI  R16,4
	BRSH _0x18C
;    1575 	{
;    1576 		*fp = file_data & 0xFF;
	CALL SUBOPT_0x5B
;    1577 		file_data >>= 8;
;    1578 		fp++;
	__ADDWRN 17,18,1
;    1579 	}
	SUBI R16,-1
	RJMP _0x18B
_0x18C:
;    1580 	
;    1581 	
;    1582 	fp = &_FF_buff[rp->entry_offset+0x16];
	CALL SUBOPT_0x59
	__ADDW1MN __FF_buff,22
	__PUTW1R 17,18
;    1583 	#ifdef _RTC_ON_ 	// Date/Time Stamp file w/ RTC
;    1584 		rtc_get_timeNdate(&rtc_hour, &rtc_min, &rtc_sec, &rtc_date, &rtc_month, (int *)&rtc_year);	    			
;    1585 		calc_temp = ((int)rtc_sec&0x1F) | (((int)rtc_min&0x3F)<<5) | (((int)rtc_hour&0x1F)<<11);
;    1586 		*fp++ = calc_temp&0x00FF;	// File create Time 
;    1587 		*fp++ = (calc_temp&0xFF00) >> 8;
;    1588 		calc_date = ((int)rtc_date&0x1F) | (((int)rtc_month&0x0F)<<5) | (((rtc_year-1980)&0x7F)<<9);
;    1589 		*fp++ = calc_date&0x00FF;	// File create Date
;    1590 		*fp++ = (calc_date&0xFF00) >> 8;
;    1591 	#else		// Increment Date Code, no RTC used 
;    1592 		file_data = 0;
	__CLRD1S 7
;    1593 		for (n=0; n<4; n++)
	LDI  R16,LOW(0)
_0x18E:
	CPI  R16,4
	BRSH _0x18F
;    1594 		{
;    1595 			file_data <<= 8;
	__GETD2S 7
	LDI  R30,LOW(8)
	CALL __LSLD12
	__PUTD1S 7
;    1596 			file_data |= *fp;
	__GETW2R 17,18
	LD   R30,X
	__GETD2S 7
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __ORD12
	__PUTD1S 7
;    1597 			fp--;
	__SUBWRN 17,18,1
;    1598 		}
	SUBI R16,-1
	RJMP _0x18E
_0x18F:
;    1599 		file_data++;
	__GETD1S 7
	__SUBD1N -1
	__PUTD1S 7
;    1600 		for (n=0; n<4; n++)
	LDI  R16,LOW(0)
_0x191:
	CPI  R16,4
	BRSH _0x192
;    1601 		{
;    1602 			fp++;
	__ADDWRN 17,18,1
;    1603 			*fp = file_data & 0xFF;
	CALL SUBOPT_0x5B
;    1604 			file_data >>=8;
;    1605 		}
	SUBI R16,-1
	RJMP _0x191
_0x192:
;    1606 	#endif
;    1607 	if (_FF_write(rp->entry_sec_addr)==0)
	CALL SUBOPT_0x58
	CALL __FF_write
	CPI  R30,0
	BRNE _0x193
;    1608 		return(0);
	LDI  R30,LOW(0)
	RJMP _0x511
;    1609 	
;    1610 	return(1);
_0x193:
	LDI  R30,LOW(1)
_0x511:
	CALL __LOADLOCR5
	ADIW R28,13
	RET
;    1611 }
;    1612 #endif
;    1613 
;    1614 #ifndef _READ_ONLY_
;    1615 // Erase a chain of clusters (set table entries to 0 for clusters in chain)
;    1616 unsigned char erase_clus_chain(unsigned int start_clus)
;    1617 {
_erase_clus_chain:
;    1618 	unsigned int clus_temp, clus_use;
;    1619 	
;    1620 	if (start_clus==0)
	CALL SUBOPT_0x5C
;	start_clus -> Y+4
;	clus_temp -> R16,R17
;	clus_use -> R18,R19
	BRNE _0x194
;    1621 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x510
;    1622 	clus_use = start_clus;
_0x194:
	__GETWRS 18,19,4
;    1623 	_FF_buff_addr = 0;
	LDI  R30,0
	STS  __FF_buff_addr,R30
	STS  __FF_buff_addr+1,R30
	STS  __FF_buff_addr+2,R30
	STS  __FF_buff_addr+3,R30
;    1624 	while(clus_use <= 0xFFF8)
_0x195:
	__CPWRN 18,19,65529
	BRSH _0x197
;    1625 	{
;    1626 		clus_temp = next_cluster(clus_use, CHAIN);
	CALL SUBOPT_0x5D
	MOVW R16,R30
;    1627 		if ((clus_temp >= 0xFFF8) || (clus_temp == 0))
	__CPWRN 16,17,65528
	BRSH _0x199
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRNE _0x198
_0x199:
;    1628 			break;
	RJMP _0x197
;    1629 		if (write_clus_table(clus_use, 0, CHAIN) == 0)
_0x198:
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x5F
	BRNE _0x19B
;    1630 			return (0);
	LDI  R30,LOW(0)
	RJMP _0x510
;    1631 		clus_use = clus_temp;
_0x19B:
	__MOVEWRR 18,19,16,17
;    1632 	}
	RJMP _0x195
_0x197:
;    1633 	if (write_clus_table(clus_use, 0, END_CHAIN) == 0)
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x60
	BRNE _0x19C
;    1634 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x510
;    1635 	clus_0_addr = 0;
_0x19C:
	LDI  R30,0
	STS  _clus_0_addr,R30
	STS  _clus_0_addr+1,R30
	STS  _clus_0_addr+2,R30
	STS  _clus_0_addr+3,R30
;    1636 	c_counter = 0;
	LDI  R30,0
	STS  _c_counter,R30
	STS  _c_counter+1,R30
;    1637 	
;    1638 	return (1);	
	LDI  R30,LOW(1)
_0x510:
	CALL __LOADLOCR4
	ADIW R28,6
	RET
;    1639 }
;    1640 
;    1641 // Quickformat of a card (erase cluster table and root directory
;    1642 int fquickformat(void)
;    1643 {
_fquickformat:
;    1644 	long c;
;    1645 	
;    1646 	for (c=0; c<BPB_BytsPerSec; c++)
	SBIW R28,4
;	c -> Y+0
	__CLRD1S 0
_0x19E:
	CALL SUBOPT_0x34
	CALL __CPD21
	BRGE _0x19F
;    1647 		_FF_buff[c] = 0;
	__GETD1S 0
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	CALL SUBOPT_0x61
;    1648 	
;    1649 	c = _FF_FAT1_ADDR + 0x200;
	__GETD1S 0
	__SUBD1N -1
	__PUTD1S 0
	RJMP _0x19E
_0x19F:
	LDS  R30,__FF_FAT1_ADDR
	LDS  R31,__FF_FAT1_ADDR+1
	LDS  R22,__FF_FAT1_ADDR+2
	LDS  R23,__FF_FAT1_ADDR+3
	__ADDD1N 512
	__PUTD1S 0
;    1650 	while (c < (_FF_ROOT_ADDR + (0x400 * BPB_SecPerClus)))
_0x1A0:
	MOV  R30,R8
	LDI  R26,LOW(1024)
	LDI  R27,HIGH(1024)
	LDI  R31,0
	CALL __MULW12
	LDS  R26,__FF_ROOT_ADDR
	LDS  R27,__FF_ROOT_ADDR+1
	LDS  R24,__FF_ROOT_ADDR+2
	LDS  R25,__FF_ROOT_ADDR+3
	CALL __CWD1
	CALL __ADDD12
	__GETD2S 0
	CALL __CPD21
	BRSH _0x1A2
;    1651 	{
;    1652 		if (_FF_write(c)==0)
	__GETD1S 0
	CALL SUBOPT_0x62
	BRNE _0x1A3
;    1653 		{
;    1654 			_FF_error = WRITE_ERR;
	CALL SUBOPT_0x63
;    1655 			return (EOF);
	RJMP _0x50F
;    1656 		}
;    1657 		c += 0x200;
_0x1A3:
	__GETD1S 0
	__ADDD1N 512
	__PUTD1S 0
;    1658 	}	
	RJMP _0x1A0
_0x1A2:
;    1659 	_FF_buff[0] = 0xF8;
	LDI  R30,LOW(248)
	STS  __FF_buff,R30
;    1660 	_FF_buff[1] = 0xFF;
	LDI  R30,LOW(255)
	__PUTB1MN __FF_buff,1
;    1661 	_FF_buff[2] = 0xFF;
	__PUTB1MN __FF_buff,2
;    1662 	if (BPB_FATType == 0x36)
	LDI  R30,LOW(54)
	CP   R30,R14
	BRNE _0x1A4
;    1663 		_FF_buff[3] = 0xFF;
	LDI  R30,LOW(255)
	__PUTB1MN __FF_buff,3
;    1664 	if ((_FF_write(_FF_FAT1_ADDR)==0) || (_FF_write(_FF_FAT2_ADDR)==0))
_0x1A4:
	LDS  R30,__FF_FAT1_ADDR
	LDS  R31,__FF_FAT1_ADDR+1
	LDS  R22,__FF_FAT1_ADDR+2
	LDS  R23,__FF_FAT1_ADDR+3
	CALL SUBOPT_0x62
	BREQ _0x1A6
	LDS  R30,__FF_FAT2_ADDR
	LDS  R31,__FF_FAT2_ADDR+1
	LDS  R22,__FF_FAT2_ADDR+2
	LDS  R23,__FF_FAT2_ADDR+3
	CALL SUBOPT_0x62
	BRNE _0x1A5
_0x1A6:
;    1665 	{
;    1666 		_FF_error = WRITE_ERR;
	CALL SUBOPT_0x63
;    1667 		return (EOF);
	RJMP _0x50F
;    1668 	}
;    1669 	return (0);
_0x1A5:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x50F:
	ADIW R28,4
	RET
;    1670 }
;    1671 #endif
;    1672 
;    1673 // function that checks for directory changes then gets into a working form
;    1674 int _FF_checkdir(char *F_PATH, unsigned long *SAVE_ADDR, char *path_temp)
;    1675 {
__FF_checkdir:
;    1676 	unsigned char *sp, *qp;
;    1677     
;    1678     *SAVE_ADDR = _FF_DIR_ADDR;	// save local dir addr
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
;    1679     
;    1680     qp = F_PATH;
	__GETWRS 18,19,8
;    1681     if (*qp=='\\')
	CALL SUBOPT_0x64
	BRNE _0x1A8
;    1682     {
;    1683     	_FF_DIR_ADDR = _FF_ROOT_ADDR;
	LDS  R30,__FF_ROOT_ADDR
	LDS  R31,__FF_ROOT_ADDR+1
	LDS  R22,__FF_ROOT_ADDR+2
	LDS  R23,__FF_ROOT_ADDR+3
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    1684 		qp++;
	__ADDWRN 18,19,1
;    1685 	}
;    1686 
;    1687 	sp = path_temp;
_0x1A8:
	__GETWRS 16,17,4
;    1688 	while(*qp)
_0x1A9:
	CALL SUBOPT_0x65
	BREQ _0x1AB
;    1689 	{
;    1690 		if ((valid_file_char(*qp)==0) || (*qp=='.'))
	MOVW R26,R18
	CALL SUBOPT_0x1D
	BREQ _0x1AD
	CALL SUBOPT_0x66
	BRNE _0x1AC
_0x1AD:
;    1691 			*sp++ = toupper(*qp++);
	PUSH R17
	PUSH R16
	__ADDWRN 16,17,1
	MOVW R26,R18
	__ADDWRN 18,19,1
	CALL SUBOPT_0x43
	POP  R26
	POP  R27
	ST   X,R30
;    1692 		else if (*qp=='\\')
	RJMP _0x1AF
_0x1AC:
	CALL SUBOPT_0x64
	BRNE _0x1B0
;    1693 		{
;    1694 			*sp = 0;	// terminate string
	CALL SUBOPT_0x67
;    1695 			if (_FF_chdir(path_temp))
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CALL SUBOPT_0x68
	BREQ _0x1B1
;    1696 			{
;    1697 				return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x50E
;    1698 			}
;    1699 			sp = path_temp;
_0x1B1:
	__GETWRS 16,17,4
;    1700 			qp++;
	__ADDWRN 18,19,1
;    1701 		}
;    1702 		else
	RJMP _0x1B2
_0x1B0:
;    1703 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x50E
;    1704 	}
_0x1B2:
_0x1AF:
	RJMP _0x1A9
_0x1AB:
;    1705 	
;    1706 	*sp = 0;		// terminate string
	CALL SUBOPT_0x67
;    1707 	return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x50E:
	CALL __LOADLOCR4
	ADIW R28,10
	RET
;    1708 }
;    1709 
;    1710 #ifndef _READ_ONLY_
;    1711 int mkdir(char *F_PATH)
;    1712 {
_mkdir:
;    1713 	unsigned char *sp, *qp;
;    1714 	unsigned char fpath[14];
;    1715 	unsigned int c, calc_temp, clus_temp, calc_time, calc_date;
;    1716 	int s;
;    1717 	unsigned long addr_temp, path_addr_temp;
;    1718     
;    1719     addr_temp = 0;	// save local dir addr
	SBIW R28,32
	CALL __SAVELOCR6
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
	__CLRD1S 10
;    1720     
;    1721     if (_FF_checkdir(F_PATH, &addr_temp, fpath))
	LDD  R30,Y+38
	LDD  R31,Y+38+1
	CALL SUBOPT_0x69
	MOVW R30,R28
	ADIW R30,28
	CALL SUBOPT_0x6A
	BREQ _0x1B3
;    1722 	{
;    1723 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x6B
;    1724 		return (EOF);
	RJMP _0x50D
;    1725 	}
;    1726     
;    1727 	path_addr_temp = _FF_DIR_ADDR;
_0x1B3:
	LDS  R30,__FF_DIR_ADDR
	LDS  R31,__FF_DIR_ADDR+1
	LDS  R22,__FF_DIR_ADDR+2
	LDS  R23,__FF_DIR_ADDR+3
	__PUTD1S 6
;    1728 	s = scan_directory(&path_addr_temp, fpath);
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,26
	CALL SUBOPT_0x6C
;    1729 	if ((s) || (path_addr_temp==0))
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	SBIW R30,0
	BRNE _0x1B5
	__GETD2S 6
	CALL __CPD02
	BRNE _0x1B4
_0x1B5:
;    1730 	{
;    1731 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x6B
;    1732 		return (EOF);
	RJMP _0x50D
;    1733 	}
;    1734 	clus_temp = prev_cluster(0);				
_0x1B4:
	CALL SUBOPT_0x6D
	STD  Y+20,R30
	STD  Y+20+1,R31
;    1735 	calc_temp = path_addr_temp % BPB_BytsPerSec;
	CALL SUBOPT_0x6E
	STD  Y+22,R30
	STD  Y+22+1,R31
;    1736 	path_addr_temp -= calc_temp;
	CALL SUBOPT_0x6F
;    1737 	if (_FF_read(path_addr_temp)==0)	
	BRNE _0x1B7
;    1738 	{
;    1739 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x6B
;    1740 		return (EOF);
	RJMP _0x50D
;    1741 	}
;    1742 	
;    1743 	sp = &_FF_buff[calc_temp];
_0x1B7:
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	MOVW R16,R30
;    1744 	qp = fpath;
	MOVW R30,R28
	ADIW R30,24
	MOVW R18,R30
;    1745 
;    1746 	for (c=0; c<11; c++)	// Write Folder name
	__GETWRN 20,21,0
_0x1B9:
	__CPWRN 20,21,11
	BRSH _0x1BA
;    1747 	{
;    1748 	 	if (*qp)
	CALL SUBOPT_0x65
	BREQ _0x1BB
;    1749 		 	*sp++ = *qp++;
	PUSH R17
	PUSH R16
	__ADDWRN 16,17,1
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R30,X
	POP  R26
	POP  R27
	RJMP _0x528
;    1750 		else 
_0x1BB:
;    1751 			*sp++ = 0x20;	// '0' pad
	MOVW R26,R16
	__ADDWRN 16,17,1
	LDI  R30,LOW(32)
_0x528:
	ST   X,R30
;    1752 	}
	__ADDWRN 20,21,1
	RJMP _0x1B9
_0x1BA:
;    1753 	*sp++ = 0x10;				// Attribute bit auto set to "Directory"
	MOVW R26,R16
	__ADDWRN 16,17,1
	LDI  R30,LOW(16)
	ST   X,R30
;    1754 	*sp++ = 0;					// Reserved for WinNT
	MOVW R26,R16
	__ADDWRN 16,17,1
	CALL SUBOPT_0x70
;    1755 	*sp++ = 0;					// Mili-second stamp for create
	__ADDWRN 16,17,1
	LDI  R30,LOW(0)
	ST   X,R30
;    1756 	for (c=0; c<4; c++)			// set create and modify time to '0'
	__GETWRN 20,21,0
_0x1BE:
	__CPWRN 20,21,4
	BRSH _0x1BF
;    1757 		*sp++ = 0;
	MOVW R26,R16
	__ADDWRN 16,17,1
	LDI  R30,LOW(0)
	ST   X,R30
;    1758 	*sp++ = 0;					// File access date (2 bytes)
	__ADDWRN 20,21,1
	RJMP _0x1BE
_0x1BF:
	MOVW R26,R16
	__ADDWRN 16,17,1
	CALL SUBOPT_0x70
;    1759 	*sp++ = 0;
	__ADDWRN 16,17,1
	CALL SUBOPT_0x70
;    1760 	*sp++ = 0;					// 0 for FAT12/16 (2 bytes)
	__ADDWRN 16,17,1
	CALL SUBOPT_0x70
;    1761 	*sp++ = 0;
	__ADDWRN 16,17,1
	LDI  R30,LOW(0)
	ST   X,R30
;    1762 	#ifdef _RTC_ON_
;    1763 		rtc_get_timeNdate(&rtc_hour, &rtc_min, &rtc_sec, &rtc_date, &rtc_month, (int *)&rtc_year);	    			
;    1764 		calc_time = ((int)rtc_sec&0x1F) | (((int)rtc_min&0x3F)<<5) | (((int)rtc_hour&0x1F)<<11);
;    1765 		*sp++ = calc_time&0x00FF;	// File modify Time 
;    1766 		*sp++ = (calc_time&0xFF00) >> 8;
;    1767 		calc_date = ((int)rtc_date&0x1F) | (((int)rtc_month&0x0F)<<5) | (((rtc_year-1980)&0x7F)<<9);
;    1768 		*sp++ = calc_date&0x00FF;	// File modify Date
;    1769 		*sp++ = (calc_date&0xFF00) >> 8;
;    1770 	#else
;    1771 		for (c=0; c<4; c++)			// set file create and modify time to '0'
	__GETWRN 20,21,0
_0x1C1:
	__CPWRN 20,21,4
	BRSH _0x1C2
;    1772 			*sp++ = 0;
	MOVW R26,R16
	__ADDWRN 16,17,1
	LDI  R30,LOW(0)
	ST   X,R30
;    1773 	#endif
;    1774 	
;    1775 	*sp++ = clus_temp & 0xFF;				// Starting cluster (2 bytes)
	__ADDWRN 20,21,1
	RJMP _0x1C1
_0x1C2:
	PUSH R17
	PUSH R16
	__ADDWRN 16,17,1
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ANDI R31,HIGH(0xFF)
	POP  R26
	POP  R27
	ST   X,R30
;    1776 	*sp++ = (clus_temp >> 8) & 0xFF;
	PUSH R17
	PUSH R16
	__ADDWRN 16,17,1
	LDD  R30,Y+21
	ANDI R31,HIGH(0x0)
	POP  R26
	POP  R27
	ST   X,R30
;    1777 	for (c=0; c<4; c++)
	__GETWRN 20,21,0
_0x1C4:
	__CPWRN 20,21,4
	BRSH _0x1C5
;    1778 		*sp++ = 0;			// File length (0 for folder)
	MOVW R26,R16
	__ADDWRN 16,17,1
	LDI  R30,LOW(0)
	ST   X,R30
;    1779 
;    1780 	
;    1781 	if (_FF_write(path_addr_temp)==0)	// write entry to card
	__ADDWRN 20,21,1
	RJMP _0x1C4
_0x1C5:
	__GETD1S 6
	CALL SUBOPT_0x62
	BRNE _0x1C6
;    1782 	{
;    1783 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x6B
;    1784 		return (EOF);
	RJMP _0x50D
;    1785 	}
;    1786 	if (write_clus_table(clus_temp, 0xFFFF, SINGLE)==0)
_0x1C6:
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CALL SUBOPT_0x71
	CALL _write_clus_table
	CPI  R30,0
	BRNE _0x1C7
;    1787 	{
;    1788 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x6B
;    1789 		return (EOF);
	RJMP _0x50D
;    1790 	}
;    1791 	if (_FF_read(_FF_DIR_ADDR)==0)	
_0x1C7:
	LDS  R30,__FF_DIR_ADDR
	LDS  R31,__FF_DIR_ADDR+1
	LDS  R22,__FF_DIR_ADDR+2
	LDS  R23,__FF_DIR_ADDR+3
	CALL SUBOPT_0xC
	BRNE _0x1C8
;    1792 	{
;    1793 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x6B
;    1794 		return (EOF);
	RJMP _0x50D
;    1795 	}
;    1796 	if (_FF_DIR_ADDR != _FF_ROOT_ADDR)
_0x1C8:
	CALL SUBOPT_0x28
	BREQ _0x1C9
;    1797 	{
;    1798 		sp = &_FF_buff[0];
	__POINTWRM 16,17,__FF_buff
;    1799 		qp = &_FF_buff[0x20];
	__POINTWRMN 18,19,__FF_buff,32
;    1800 		for (c=0; c<0x20; c++)
	__GETWRN 20,21,0
_0x1CB:
	__CPWRN 20,21,32
	BRSH _0x1CC
;    1801 			*qp++ = *sp++;
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	MOVW R26,R16
	__ADDWRN 16,17,1
	LD   R30,X
	POP  R26
	POP  R27
	ST   X,R30
;    1802 		_FF_buff[1] = ' ';
	__ADDWRN 20,21,1
	RJMP _0x1CB
_0x1CC:
	LDI  R30,LOW(32)
	__PUTB1MN __FF_buff,1
;    1803 		for (c=0x3C; c<0x40; c++)
	__GETWRN 20,21,60
_0x1CE:
	__CPWRN 20,21,64
	BRSH _0x1CF
;    1804 			_FF_buff[c] = 0;
	CALL SUBOPT_0x72
;    1805 	}
	__ADDWRN 20,21,1
	RJMP _0x1CE
_0x1CF:
;    1806 	else
	RJMP _0x1D0
_0x1C9:
;    1807 	{
;    1808 		for (c=0x01; c<0x0B; c++)
	__GETWRN 20,21,1
_0x1D2:
	__CPWRN 20,21,11
	BRSH _0x1D3
;    1809 			_FF_buff[c] = 0x20;
	CALL SUBOPT_0x73
;    1810 		for (c=0x0C; c<0x20; c++)
	__ADDWRN 20,21,1
	RJMP _0x1D2
_0x1D3:
	__GETWRN 20,21,12
_0x1D5:
	__CPWRN 20,21,32
	BRSH _0x1D6
;    1811 			_FF_buff[c] = 0;
	CALL SUBOPT_0x72
;    1812 		_FF_buff[0] = '.';
	__ADDWRN 20,21,1
	RJMP _0x1D5
_0x1D6:
	LDI  R30,LOW(46)
	STS  __FF_buff,R30
;    1813 		_FF_buff[0x0B] = 0x10;
	LDI  R30,LOW(16)
	__PUTB1MN __FF_buff,11
;    1814 		#ifdef _RTC_ON_
;    1815 			_FF_buff[0x0E] = calc_time&0x00FF;	// File modify Time 
;    1816 			_FF_buff[0x0F] = (calc_time&0xFF00) >> 8;
;    1817 			_FF_buff[0x10] = calc_date&0x00FF;	// File modify Date
;    1818 			_FF_buff[0x11] = (calc_date&0xFF00) >> 8;
;    1819 			_FF_buff[0x16] = calc_time&0x00FF;	// File modify Time 
;    1820 			_FF_buff[0x17] = (calc_time&0xFF00) >> 8;
;    1821 			_FF_buff[0x18] = calc_date&0x00FF;	// File modify Date
;    1822 			_FF_buff[0x19] = (calc_date&0xFF00) >> 8;
;    1823 		#endif
;    1824 		for (c=0x3A; c<0x40; c++)
	__GETWRN 20,21,58
_0x1D8:
	__CPWRN 20,21,64
	BRSH _0x1D9
;    1825 			_FF_buff[c] = 0;
	CALL SUBOPT_0x72
;    1826 	}
	__ADDWRN 20,21,1
	RJMP _0x1D8
_0x1D9:
_0x1D0:
;    1827 	for (c=0x22; c<0x2B; c++)
	__GETWRN 20,21,34
_0x1DB:
	__CPWRN 20,21,43
	BRSH _0x1DC
;    1828 		_FF_buff[c] = 0x20;
	CALL SUBOPT_0x73
;    1829 	#ifdef _RTC_ON_
;    1830 		_FF_buff[0x2E] = calc_time&0x00FF;	// File modify Time 
;    1831 		_FF_buff[0x2F] = (calc_time&0xFF00) >> 8;
;    1832 		_FF_buff[0x30] = calc_date&0x00FF;	// File modify Date
;    1833 		_FF_buff[0x31] = (calc_date&0xFF00) >> 8;
;    1834 		_FF_buff[0x36] = calc_time&0x00FF;	// File modify Time 
;    1835 		_FF_buff[0x37] = (calc_time&0xFF00) >> 8;
;    1836 		_FF_buff[0x38] = calc_date&0x00FF;	// File modify Date
;    1837 		_FF_buff[0x39] = (calc_date&0xFF00) >> 8;
;    1838 	#endif
;    1839 	_FF_buff[0x20] = '.';
	__ADDWRN 20,21,1
	RJMP _0x1DB
_0x1DC:
	LDI  R30,LOW(46)
	__PUTB1MN __FF_buff,32
;    1840 	_FF_buff[0x21] = '.';
	__PUTB1MN __FF_buff,33
;    1841 	_FF_buff[0x2B] = 0x10;
	LDI  R30,LOW(16)
	__PUTB1MN __FF_buff,43
;    1842 
;    1843 	_FF_buff[0x1A] = clus_temp & 0xFF;				// Starting cluster (2 bytes)
	LDD  R30,Y+20
	__PUTB1MN __FF_buff,26
;    1844 	_FF_buff[0x1B] = (clus_temp >> 8) & 0xFF;
	LDD  R30,Y+21
	__PUTB1MN __FF_buff,27
;    1845 	for (c=0x40; c<BPB_BytsPerSec; c++)
	__GETWRN 20,21,64
_0x1DE:
	__CPWRR 20,21,6,7
	BRSH _0x1DF
;    1846 		_FF_buff[c] = 0;
	CALL SUBOPT_0x72
;    1847 	path_addr_temp = clust_to_addr(clus_temp);
	__ADDWRN 20,21,1
	RJMP _0x1DE
_0x1DF:
	CALL SUBOPT_0x32
;    1848 
;    1849 	_FF_DIR_ADDR = addr_temp;	// reset dir addr
	__GETD1S 10
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    1850 	if (_FF_write(path_addr_temp)==0)	
	__GETD1S 6
	CALL SUBOPT_0x62
	BRNE _0x1E0
;    1851 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x50D
;    1852 	for (c=0; c<0x40; c++)
_0x1E0:
	__GETWRN 20,21,0
_0x1E2:
	__CPWRN 20,21,64
	BRSH _0x1E3
;    1853 		_FF_buff[c] = 0;
	CALL SUBOPT_0x72
;    1854 	for (c=1; c<BPB_SecPerClus; c++)
	__ADDWRN 20,21,1
	RJMP _0x1E2
_0x1E3:
	__GETWRN 20,21,1
_0x1E5:
	MOV  R30,R8
	MOVW R26,R20
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x1E6
;    1855 	{
;    1856 		if (_FF_write(path_addr_temp+((long)c*0x200))==0)	
	MOVW R30,R20
	CALL SUBOPT_0x74
	__GETD2S 6
	CALL __ADDD12
	CALL SUBOPT_0x62
	BRNE _0x1E7
;    1857 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x50D
;    1858 	}
_0x1E7:
	__ADDWRN 20,21,1
	RJMP _0x1E5
_0x1E6:
;    1859 	return (0);		
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x50D:
	CALL __LOADLOCR6
	ADIW R28,40
	RET
;    1860 }
;    1861 
;    1862 int rmdir(char *F_PATH)
;    1863 {
_rmdir:
;    1864 	unsigned char *sp;
;    1865 	unsigned char fpath[14];
;    1866 	unsigned int c, n, calc_temp, clus_temp;
;    1867 	int s;
;    1868 	unsigned long addr_temp, path_addr_temp;
;    1869 	
;    1870 	addr_temp = 0;	// save local dir addr
	SBIW R28,28
	CALL __SAVELOCR6
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
	__CLRD1S 10
;    1871     
;    1872     if (_FF_checkdir(F_PATH, &addr_temp, fpath))
	LDD  R30,Y+34
	LDD  R31,Y+34+1
	CALL SUBOPT_0x69
	MOVW R30,R28
	ADIW R30,24
	CALL SUBOPT_0x6A
	BREQ _0x1E8
;    1873 	{
;    1874 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x6B
;    1875 		return (EOF);
	RJMP _0x50C
;    1876 	}
;    1877 	if (fpath[0]==0)
_0x1E8:
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x1E9
;    1878 	{
;    1879 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x6B
;    1880 		return (EOF);
	RJMP _0x50C
;    1881 	}
;    1882 
;    1883     path_addr_temp = _FF_DIR_ADDR;	// save addr for later
_0x1E9:
	LDS  R30,__FF_DIR_ADDR
	LDS  R31,__FF_DIR_ADDR+1
	LDS  R22,__FF_DIR_ADDR+2
	LDS  R23,__FF_DIR_ADDR+3
	__PUTD1S 6
;    1884 	
;    1885 	if (_FF_chdir(fpath))	// Change directory to dir to be deleted
	MOVW R30,R28
	ADIW R30,20
	CALL SUBOPT_0x68
	BREQ _0x1EA
;    1886 	{	
;    1887 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x6B
;    1888 		return (EOF);
	RJMP _0x50C
;    1889 	}
;    1890 	if ((_FF_DIR_ADDR==_FF_ROOT_ADDR)||(_FF_DIR_ADDR==addr_temp))
_0x1EA:
	CALL SUBOPT_0x28
	BREQ _0x1EC
	__GETD1S 10
	LDS  R26,__FF_DIR_ADDR
	LDS  R27,__FF_DIR_ADDR+1
	LDS  R24,__FF_DIR_ADDR+2
	LDS  R25,__FF_DIR_ADDR+3
	CALL __CPD12
	BRNE _0x1EB
_0x1EC:
;    1891 	{	// if trying to delete root, or current dir error
;    1892 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x6B
;    1893 		return (EOF);
	RJMP _0x50C
;    1894 	}
;    1895 	
;    1896 	for (c=0; c<BPB_SecPerClus; c++)
_0x1EB:
	__GETWRN 18,19,0
_0x1EF:
	MOV  R30,R8
	MOVW R26,R18
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRLO PC+3
	JMP _0x1F0
;    1897 	{	// scan through dir to see if it is empty
;    1898 		if (_FF_read(_FF_DIR_ADDR+((long)c*0x200))==0)
	MOVW R30,R18
	CALL SUBOPT_0x74
	LDS  R26,__FF_DIR_ADDR
	LDS  R27,__FF_DIR_ADDR+1
	LDS  R24,__FF_DIR_ADDR+2
	LDS  R25,__FF_DIR_ADDR+3
	CALL __ADDD12
	CALL SUBOPT_0xC
	BRNE _0x1F1
;    1899 		{	// read sectors 	
;    1900 			_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x6B
;    1901 			return (EOF);
	RJMP _0x50C
;    1902 		}
;    1903 		for (n=0; n<0x10; n++)
_0x1F1:
	__GETWRN 20,21,0
_0x1F3:
	__CPWRN 20,21,16
	BRSH _0x1F4
;    1904 		{
;    1905 			if ((c==0)&&(n==0))	// skip first 2 entries 
	CLR  R0
	CP   R0,R18
	CPC  R0,R19
	BRNE _0x1F6
	CLR  R0
	CP   R0,R20
	CPC  R0,R21
	BREQ _0x1F7
_0x1F6:
	RJMP _0x1F5
_0x1F7:
;    1906 				n=2;
	__GETWRN 20,21,2
;    1907 			sp = &_FF_buff[n*0x20];
_0x1F5:
	CALL SUBOPT_0x23
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	MOVW R16,R30
;    1908 			if (*sp==0)
	CALL SUBOPT_0x75
	BRNE _0x1F8
;    1909 			{	// 
;    1910 				c = BPB_SecPerClus;
	MOV  R18,R8
	CLR  R19
;    1911 				break;
	RJMP _0x1F4
;    1912 			}
;    1913 			while (valid_file_char(*sp)==0)
_0x1F8:
_0x1F9:
	MOVW R26,R16
	CALL SUBOPT_0x1D
	BRNE _0x1FB
;    1914 			{
;    1915 				sp++;
	__ADDWRN 16,17,1
;    1916 				if (sp == &_FF_buff[(n*0x20)+0x0A])
	CALL SUBOPT_0x23
	__ADDW1MN __FF_buff,10
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x1FC
;    1917 				{	// a valid file or folder found
;    1918 					_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x6B
;    1919 					return (EOF);
	RJMP _0x50C
;    1920 				}
;    1921 			}
_0x1FC:
	RJMP _0x1F9
_0x1FB:
;    1922 		}
	__ADDWRN 20,21,1
	RJMP _0x1F3
_0x1F4:
;    1923 	}
	__ADDWRN 18,19,1
	RJMP _0x1EF
_0x1F0:
;    1924 	// directory empty, delete dir
;    1925 	_FF_DIR_ADDR = path_addr_temp;	// go back to previous directory 
	__GETD1S 6
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    1926 
;    1927 	s = scan_directory(&path_addr_temp, fpath);
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x6C
;    1928 
;    1929 	_FF_DIR_ADDR = addr_temp;	// reset address
	__GETD1S 10
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    1930 
;    1931 	if (s == 0)
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	SBIW R30,0
	BRNE _0x1FD
;    1932 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x50C
;    1933 	
;    1934 	calc_temp = path_addr_temp % BPB_BytsPerSec;
_0x1FD:
	CALL SUBOPT_0x6E
	STD  Y+18,R30
	STD  Y+18+1,R31
;    1935 	path_addr_temp -= calc_temp;
	CALL SUBOPT_0x6F
;    1936 
;    1937 	if (_FF_read(path_addr_temp)==0)	
	BRNE _0x1FE
;    1938 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x50C
;    1939     
;    1940 	clus_temp = ((int) _FF_buff[calc_temp+0x1B] << 8) | _FF_buff[calc_temp+0x1A];
_0x1FE:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	__ADDW1MN __FF_buff,27
	CALL SUBOPT_0x30
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	__ADDW1MN __FF_buff,26
	CALL SUBOPT_0x31
	STD  Y+16,R30
	STD  Y+16+1,R31
;    1941 	_FF_buff[calc_temp] = 0xE5;
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	SUBI R26,LOW(-__FF_buff)
	SBCI R27,HIGH(-__FF_buff)
	LDI  R30,LOW(229)
	ST   X,R30
;    1942 	
;    1943 	if (_FF_buff[calc_temp+0x0B]&0x02)
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	__ADDW1MN __FF_buff,11
	LD   R30,Z
	ANDI R30,LOW(0x2)
	BREQ _0x1FF
;    1944 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x50C
;    1945 	if (_FF_write(path_addr_temp)==0) 
_0x1FF:
	__GETD1S 6
	CALL SUBOPT_0x62
	BRNE _0x200
;    1946 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x50C
;    1947 	if (erase_clus_chain(clus_temp)==0)
_0x200:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _erase_clus_chain
	CPI  R30,0
	BRNE _0x201
;    1948 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x50C
;    1949 	
;    1950     return (0);
_0x201:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x50C:
	CALL __LOADLOCR6
	ADIW R28,36
	RET
;    1951 }
;    1952 #endif
;    1953 
;    1954 int chdirc(char flash *F_PATH)
;    1955 {
;    1956 	unsigned char fpath[_FF_PATH_LENGTH];
;    1957 	int c;
;    1958 	
;    1959 	for (c=0; c<_FF_PATH_LENGTH; c++)
;	*F_PATH -> Y+102
;	fpath -> Y+2
;	c -> R16,R17
;    1960 	{
;    1961 		fpath[c] = F_PATH[c];
;    1962 		if (F_PATH[c]==0)
;    1963 			break;
;    1964 	}
;    1965 	return (chdir(fpath));
;    1966 }
;    1967 
;    1968 int chdir(char *F_PATH)
;    1969 {
_chdir:
;    1970 	unsigned char *qp, *sp, fpath[14], valid_flag;
;    1971 	unsigned int m, n, c, d, calc;
;    1972 	unsigned long addr_temp;
;    1973 
;    1974     
;    1975     addr_temp = 0;	// save local dir addr
	SBIW R28,28
	CALL __SAVELOCR5
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
	__CLRD1S 5
;    1976     
;    1977 	if ((F_PATH[0]=='\\') && (F_PATH[1]==0))
	LDD  R26,Y+33
	LDD  R27,Y+33+1
	LD   R26,X
	CPI  R26,LOW(0x5C)
	BRNE _0x207
	LDD  R26,Y+33
	LDD  R27,Y+33+1
	ADIW R26,1
	LD   R26,X
	CPI  R26,LOW(0x0)
	BREQ _0x208
_0x207:
	RJMP _0x206
_0x208:
;    1978 	{
;    1979 		_FF_DIR_ADDR = _FF_ROOT_ADDR;
	LDS  R30,__FF_ROOT_ADDR
	LDS  R31,__FF_ROOT_ADDR+1
	LDS  R22,__FF_ROOT_ADDR+2
	LDS  R23,__FF_ROOT_ADDR+3
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    1980 		_FF_FULL_PATH[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN __FF_FULL_PATH,1
;    1981 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x50B
;    1982 	}
;    1983 	
;    1984     if (_FF_checkdir(F_PATH, &addr_temp, fpath))
_0x206:
	LDD  R30,Y+33
	LDD  R31,Y+33+1
	CALL SUBOPT_0x76
	MOVW R30,R28
	ADIW R30,23
	CALL SUBOPT_0x6A
	BREQ _0x209
;    1985 	{
;    1986 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x77
;    1987 		return (EOF);
	RJMP _0x50B
;    1988 	}
;    1989 	if (fpath[0]==0)
_0x209:
	LDD  R30,Y+19
	CPI  R30,0
	BRNE _0x20A
;    1990 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x50B
;    1991 
;    1992 	if ((fpath[0]=='.') && (fpath[1]=='.') && (fpath[2]==0))
_0x20A:
	LDD  R26,Y+19
	CPI  R26,LOW(0x2E)
	BRNE _0x20C
	LDD  R26,Y+20
	CPI  R26,LOW(0x2E)
	BRNE _0x20C
	LDD  R26,Y+21
	CPI  R26,LOW(0x0)
	BREQ _0x20D
_0x20C:
	RJMP _0x20B
_0x20D:
;    1993 	{	// trying to get back to prev dir
;    1994 		if (_FF_DIR_ADDR == _FF_ROOT_ADDR)		// already as far back as can go
	CALL SUBOPT_0x28
	BRNE _0x20E
;    1995 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x50B
;    1996 		if (_FF_read(_FF_DIR_ADDR)==0)
_0x20E:
	LDS  R30,__FF_DIR_ADDR
	LDS  R31,__FF_DIR_ADDR+1
	LDS  R22,__FF_DIR_ADDR+2
	LDS  R23,__FF_DIR_ADDR+3
	CALL SUBOPT_0xC
	BRNE _0x20F
;    1997 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x50B
;    1998 		m = ((unsigned int) _FF_buff[0x3B] << 8) | (unsigned int) _FF_buff[0x3A];
_0x20F:
	__GETBRMN 27,__FF_buff,59
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,58
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STD  Y+17,R30
	STD  Y+17+1,R31
;    1999 		if (m)
	SBIW R30,0
	BREQ _0x210
;    2000 			_FF_DIR_ADDR = clust_to_addr(m);
	ST   -Y,R31
	ST   -Y,R30
	CALL _clust_to_addr
	RJMP _0x529
;    2001 		else
_0x210:
;    2002 			_FF_DIR_ADDR = _FF_ROOT_ADDR;
	LDS  R30,__FF_ROOT_ADDR
	LDS  R31,__FF_ROOT_ADDR+1
	LDS  R22,__FF_ROOT_ADDR+2
	LDS  R23,__FF_ROOT_ADDR+3
_0x529:
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    2003 		
;    2004 					sp = F_PATH;
	__GETWRS 18,19,33
;    2005 					qp = _FF_FULL_PATH + strlen(_FF_FULL_PATH);
	CALL SUBOPT_0x78
;    2006 					while (*sp)
_0x212:
	CALL SUBOPT_0x65
	BREQ _0x214
;    2007 					{
;    2008 						if ((*sp=='.')&&(*(sp+1)=='.'))
	CALL SUBOPT_0x66
	BRNE _0x216
	CALL SUBOPT_0x79
	BREQ _0x217
_0x216:
	RJMP _0x215
_0x217:
;    2009 						{
;    2010 							#ifdef _ICCAVR_
;    2011 								qp = strrchr(_FF_FULL_PATH, '\\');
;    2012 								if (qp==0)
;    2013 								   return (EOF);
;    2014 								*qp = 0;
;    2015 								qp = strrchr(_FF_FULL_PATH, '\\');
;    2016 								if (qp==0)
;    2017 								   return (EOF);
;    2018 								qp++;
;    2019 							#endif
;    2020 							#ifdef _CVAVR_
;    2021 								_FF_FULL_PATH[strrpos(_FF_FULL_PATH, '\\')] = 0;
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x7B
;    2022 							    c = strrpos(_FF_FULL_PATH, '\\');
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x7C
;    2023 								if (c==EOF)
	BRNE _0x218
;    2024 									return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x50B
;    2025 								qp = _FF_FULL_PATH + c;
_0x218:
	CALL SUBOPT_0x7D
;    2026 							#endif
;    2027 							*qp = 0;
;    2028 							sp += 2;
	__ADDWRN 18,19,2
;    2029 						}
;    2030 						else 
	RJMP _0x219
_0x215:
;    2031 							*qp++ = toupper(*sp++);
	PUSH R17
	PUSH R16
	__ADDWRN 16,17,1
	MOVW R26,R18
	__ADDWRN 18,19,1
	CALL SUBOPT_0x43
	POP  R26
	POP  R27
	ST   X,R30
;    2032 					}
_0x219:
	RJMP _0x212
_0x214:
;    2033 					*qp++ = '\\';
	MOVW R26,R16
	__ADDWRN 16,17,1
	CALL SUBOPT_0x7E
;    2034 					*qp = 0;
;    2035 
;    2036 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x50B
;    2037 	}
;    2038 		
;    2039 	qp = fpath;
_0x20B:
	MOVW R30,R28
	ADIW R30,19
	MOVW R16,R30
;    2040 	sp = fpath;
	MOVW R30,R28
	ADIW R30,19
	MOVW R18,R30
;    2041 	while(sp < (fpath+11))
_0x21A:
	MOVW R30,R28
	ADIW R30,30
	CP   R18,R30
	CPC  R19,R31
	BRSH _0x21C
;    2042 	{
;    2043 		if (*qp)
	CALL SUBOPT_0x75
	BREQ _0x21D
;    2044 			*sp++ = toupper(*qp++);
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	MOVW R26,R16
	__ADDWRN 16,17,1
	CALL SUBOPT_0x43
	POP  R26
	POP  R27
	RJMP _0x52A
;    2045 		else	// (*qp==0)
_0x21D:
;    2046 			*sp++ = 0x20;
	MOVW R26,R18
	__ADDWRN 18,19,1
	LDI  R30,LOW(32)
_0x52A:
	ST   X,R30
;    2047 	}     
	RJMP _0x21A
_0x21C:
;    2048 	*sp = 0;
	CALL SUBOPT_0x7F
;    2049 
;    2050 	qp = fpath;
	MOVW R30,R28
	ADIW R30,19
	MOVW R16,R30
;    2051 	m = 0;
	LDI  R30,0
	STD  Y+17,R30
	STD  Y+17+1,R30
;    2052 	d = 0;
	LDI  R30,0
	STD  Y+11,R30
	STD  Y+11+1,R30
;    2053 	valid_flag = 0;
	LDI  R20,LOW(0)
;    2054 	while (d<BPB_RootEntCnt)
_0x21F:
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	CP   R26,R12
	CPC  R27,R13
	BRLO PC+3
	JMP _0x221
;    2055 	{
;    2056     	_FF_read(_FF_DIR_ADDR+(m*0x200));
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	CALL SUBOPT_0x80
;    2057 		for (n=0; n<16; n++)
	LDI  R30,0
	STD  Y+15,R30
	STD  Y+15+1,R30
_0x223:
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	SBIW R26,16
	BRLO PC+3
	JMP _0x224
;    2058 		{
;    2059 			if (_FF_buff[n*0x20] == 0)	// no more entries in dir
	CALL SUBOPT_0x81
	CALL SUBOPT_0x2B
	BRNE _0x225
;    2060 			{
;    2061 				_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x77
;    2062 				return (EOF);
	RJMP _0x50B
;    2063 			}
;    2064 			calc = (n*0x20);
_0x225:
	CALL SUBOPT_0x81
	STD  Y+9,R30
	STD  Y+9+1,R31
;    2065 			for (c=0; c<11; c++)
	LDI  R30,0
	STD  Y+13,R30
	STD  Y+13+1,R30
_0x227:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	SBIW R26,11
	BRSH _0x228
;    2066 			{	// check for name match
;    2067 				if (fpath[c] == _FF_buff[calc+c])
	CALL SUBOPT_0x82
	LD   R0,X
	CALL SUBOPT_0x83
	CP   R30,R0
	BRNE _0x229
;    2068 					valid_flag = 1;
	LDI  R20,LOW(1)
;    2069 				else if (fpath[c] == 0)
	RJMP _0x22A
_0x229:
	CALL SUBOPT_0x82
	LD   R30,X
	CPI  R30,0
	BRNE _0x22B
;    2070 				{
;    2071 					if (_FF_buff[calc+c]==0x20)
	CALL SUBOPT_0x83
	CPI  R30,LOW(0x20)
	BREQ _0x228
;    2072 						break;
;    2073 				}
;    2074 				else
	RJMP _0x22D
_0x22B:
;    2075 				{
;    2076 					valid_flag = 0;	
	LDI  R20,LOW(0)
;    2077 					break;
	RJMP _0x228
;    2078 				}
_0x22D:
_0x22A:
;    2079 		    }   
	CALL SUBOPT_0x84
	RJMP _0x227
_0x228:
;    2080 		    if (valid_flag)
	CPI  R20,0
	BRNE PC+3
	JMP _0x22E
;    2081 	  		{
;    2082 	  			if (_FF_buff[calc+0xB] != 0x10)	// not a directory
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	__ADDW1MN __FF_buff,11
	LD   R30,Z
	CPI  R30,LOW(0x10)
	BREQ _0x22F
;    2083 	  				valid_flag = 0;
	LDI  R20,LOW(0)
;    2084 	  			else
	RJMP _0x230
_0x22F:
;    2085 	  			{
;    2086 	  				c = ((int) _FF_buff[calc+0x1B] << 8) | ((int) _FF_buff[calc+0x1A]);
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	__ADDW1MN __FF_buff,27
	CALL SUBOPT_0x30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	__ADDW1MN __FF_buff,26
	CALL SUBOPT_0x31
	STD  Y+13,R30
	STD  Y+13+1,R31
;    2087 					_FF_DIR_ADDR = clust_to_addr(c);
	CALL SUBOPT_0x85
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    2088 					sp = F_PATH;
	__GETWRS 18,19,33
;    2089 					if (*sp=='\\')
	CALL SUBOPT_0x64
	BRNE _0x231
;    2090 					{	// Restart String @root
;    2091 						qp = _FF_FULL_PATH + 1;
	__POINTWRMN 16,17,__FF_FULL_PATH,1
;    2092 						*qp = 0;
	CALL SUBOPT_0x67
;    2093 						sp++;
	__ADDWRN 18,19,1
;    2094 					}
;    2095 					else
	RJMP _0x232
_0x231:
;    2096 						qp = _FF_FULL_PATH + strlen(_FF_FULL_PATH);
	CALL SUBOPT_0x78
;    2097 					while (*sp)
_0x232:
_0x233:
	CALL SUBOPT_0x65
	BREQ _0x235
;    2098 					{
;    2099 						if ((*sp=='.')&&(*(sp+1)=='.'))
	CALL SUBOPT_0x66
	BRNE _0x237
	CALL SUBOPT_0x79
	BREQ _0x238
_0x237:
	RJMP _0x236
_0x238:
;    2100 						{
;    2101 							#ifdef _ICCAVR_
;    2102 								qp = strrchr(_FF_FULL_PATH, '\\');
;    2103 								if (qp==0)
;    2104 								   return (EOF);
;    2105 								*qp = 0;
;    2106 								qp = strrchr(_FF_FULL_PATH, '\\');
;    2107 								if (qp==0)
;    2108 								   return (EOF);
;    2109 								qp++;
;    2110 							#endif
;    2111 							#ifdef _CVAVR_
;    2112 								_FF_FULL_PATH[strrpos(_FF_FULL_PATH, '\\')] = 0;
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x7B
;    2113 								c = strrpos(_FF_FULL_PATH, '\\');
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x7C
;    2114 								if (c==EOF)
	BRNE _0x239
;    2115 								   return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x50B
;    2116 								qp = _FF_FULL_PATH + c;
_0x239:
	CALL SUBOPT_0x7D
;    2117 							#endif
;    2118 							*qp = 0;
;    2119 							sp += 2;
	__ADDWRN 18,19,2
;    2120 						}
;    2121 						else 
	RJMP _0x23A
_0x236:
;    2122 							*qp++ = toupper(*sp++);
	PUSH R17
	PUSH R16
	__ADDWRN 16,17,1
	MOVW R26,R18
	__ADDWRN 18,19,1
	CALL SUBOPT_0x43
	POP  R26
	POP  R27
	ST   X,R30
;    2123 					}
_0x23A:
	RJMP _0x233
_0x235:
;    2124 					*qp++ = '\\';
	MOVW R26,R16
	__ADDWRN 16,17,1
	CALL SUBOPT_0x7E
;    2125 					*qp = 0;
;    2126 					return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x50B
;    2127 				}
_0x230:
;    2128 			}
;    2129 		  	d++;		  		
_0x22E:
	CALL SUBOPT_0x86
;    2130 		}
	CALL SUBOPT_0x48
	RJMP _0x223
_0x224:
;    2131 		m++;
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ADIW R30,1
	STD  Y+17,R30
	STD  Y+17+1,R31
;    2132 	}
	RJMP _0x21F
_0x221:
;    2133 	_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x77
;    2134 	return (EOF);
_0x50B:
	CALL __LOADLOCR5
	ADIW R28,35
	RET
;    2135 }
;    2136 
;    2137 // Function to change directories one at a time, not effecting the working dir string
;    2138 int _FF_chdir(char *F_PATH)
;    2139 {
__FF_chdir:
;    2140 	unsigned char *qp, *sp, valid_flag, fpath[14];
;    2141 	unsigned int m, n, c, d, calc;
;    2142     
;    2143 	if ((F_PATH[0]=='.') && (F_PATH[1]=='.') && (F_PATH[2]==0))
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
	BRNE _0x23C
	LDD  R26,Y+29
	LDD  R27,Y+29+1
	ADIW R26,1
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BRNE _0x23C
	LDD  R26,Y+29
	LDD  R27,Y+29+1
	ADIW R26,2
	LD   R26,X
	CPI  R26,LOW(0x0)
	BREQ _0x23D
_0x23C:
	RJMP _0x23B
_0x23D:
;    2144 	{	// trying to get back to prev dir
;    2145 		if (_FF_DIR_ADDR == _FF_ROOT_ADDR)		// already as far back as can go
	CALL SUBOPT_0x28
	BRNE _0x23E
;    2146 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x50A
;    2147 		if (_FF_read(_FF_DIR_ADDR)==0)
_0x23E:
	LDS  R30,__FF_DIR_ADDR
	LDS  R31,__FF_DIR_ADDR+1
	LDS  R22,__FF_DIR_ADDR+2
	LDS  R23,__FF_DIR_ADDR+3
	CALL SUBOPT_0xC
	BRNE _0x23F
;    2148 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x50A
;    2149 		m = ((unsigned int) _FF_buff[0x3B] << 8) | (unsigned int) _FF_buff[0x3A];
_0x23F:
	__GETBRMN 27,__FF_buff,59
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,58
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STD  Y+13,R30
	STD  Y+13+1,R31
;    2150 		if (m)
	SBIW R30,0
	BREQ _0x240
;    2151 			_FF_DIR_ADDR = clust_to_addr(m);
	CALL SUBOPT_0x85
	RJMP _0x52B
;    2152 		else
_0x240:
;    2153 			_FF_DIR_ADDR = _FF_ROOT_ADDR;
	LDS  R30,__FF_ROOT_ADDR
	LDS  R31,__FF_ROOT_ADDR+1
	LDS  R22,__FF_ROOT_ADDR+2
	LDS  R23,__FF_ROOT_ADDR+3
_0x52B:
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    2154 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x50A
;    2155 	}
;    2156 		
;    2157 	qp = F_PATH;
_0x23B:
	__GETWRS 16,17,29
;    2158 	sp = fpath;
	MOVW R30,R28
	ADIW R30,15
	MOVW R18,R30
;    2159 	while(sp < (fpath+11))
_0x242:
	MOVW R30,R28
	ADIW R30,26
	CP   R18,R30
	CPC  R19,R31
	BRSH _0x244
;    2160 	{
;    2161 		if (valid_file_char(*qp)==0)
	MOVW R26,R16
	CALL SUBOPT_0x1D
	BRNE _0x245
;    2162 			*sp++ = toupper(*qp++);
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	MOVW R26,R16
	__ADDWRN 16,17,1
	CALL SUBOPT_0x43
	POP  R26
	POP  R27
	ST   X,R30
;    2163 		else if (*qp==0)
	RJMP _0x246
_0x245:
	CALL SUBOPT_0x75
	BRNE _0x247
;    2164 			*sp++ = 0x20;
	MOVW R26,R18
	__ADDWRN 18,19,1
	LDI  R30,LOW(32)
	ST   X,R30
;    2165 		else
	RJMP _0x248
_0x247:
;    2166 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x50A
;    2167 	}     
_0x248:
_0x246:
	RJMP _0x242
_0x244:
;    2168 	*sp = 0;
	CALL SUBOPT_0x7F
;    2169 	m = 0;
	LDI  R30,0
	STD  Y+13,R30
	STD  Y+13+1,R30
;    2170 	d = 0;
	LDI  R30,0
	STD  Y+7,R30
	STD  Y+7+1,R30
;    2171 	valid_flag = 0;
	LDI  R20,LOW(0)
;    2172 	while (d<BPB_RootEntCnt)
_0x249:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CP   R26,R12
	CPC  R27,R13
	BRLO PC+3
	JMP _0x24B
;    2173 	{
;    2174     	_FF_read(_FF_DIR_ADDR+(m*0x200));
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	CALL SUBOPT_0x80
;    2175 		for (n=0; n<16; n++)
	LDI  R30,0
	STD  Y+11,R30
	STD  Y+11+1,R30
_0x24D:
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	SBIW R26,16
	BRLO PC+3
	JMP _0x24E
;    2176 		{
;    2177 			calc = (n*0x20);
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	LSL  R30
	ROL  R31
	CALL __LSLW4
	STD  Y+5,R30
	STD  Y+5+1,R31
;    2178 			if (_FF_buff[calc] == 0)	// no more entries in dir
	CALL SUBOPT_0x2B
	BRNE _0x24F
;    2179 				return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x50A
;    2180 			for (c=0; c<11; c++)
_0x24F:
	LDI  R30,0
	STD  Y+9,R30
	STD  Y+9+1,R30
_0x251:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	SBIW R26,11
	BRSH _0x252
;    2181 			{	// check for name match
;    2182 				if (fpath[c] == _FF_buff[calc+c])
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	MOVW R26,R28
	ADIW R26,15
	ADD  R26,R30
	ADC  R27,R31
	LD   R0,X
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	ADD  R30,R26
	ADC  R31,R27
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	LD   R30,Z
	CP   R30,R0
	BRNE _0x253
;    2183 					valid_flag = 1;
	LDI  R20,LOW(1)
;    2184 				else
	RJMP _0x254
_0x253:
;    2185 				{
;    2186 					valid_flag = 0;	
	LDI  R20,LOW(0)
;    2187 					c = 11;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	STD  Y+9,R30
	STD  Y+9+1,R31
;    2188 				}
_0x254:
;    2189 		    }   
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ADIW R30,1
	STD  Y+9,R30
	STD  Y+9+1,R31
	RJMP _0x251
_0x252:
;    2190 		    if (valid_flag)
	CPI  R20,0
	BREQ _0x255
;    2191 	  		{
;    2192 	  			if (_FF_buff[calc+0xB] != 0x10)	// not a directory
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	__ADDW1MN __FF_buff,11
	LD   R30,Z
	CPI  R30,LOW(0x10)
	BREQ _0x256
;    2193 	  				valid_flag = 0;
	LDI  R20,LOW(0)
;    2194 	  			else
	RJMP _0x257
_0x256:
;    2195 	  			{
;    2196 	  				c = ((int) _FF_buff[calc+0x1B] << 8) | ((int) _FF_buff[calc+0x1A]);
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	__ADDW1MN __FF_buff,27
	CALL SUBOPT_0x30
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	__ADDW1MN __FF_buff,26
	CALL SUBOPT_0x31
	STD  Y+9,R30
	STD  Y+9+1,R31
;    2197 					_FF_DIR_ADDR = clust_to_addr(c);
	ST   -Y,R31
	ST   -Y,R30
	CALL _clust_to_addr
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    2198 					return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x50A
;    2199 				}
_0x257:
;    2200 			}
;    2201 		  	d++;		  		
_0x255:
	CALL SUBOPT_0x87
;    2202 		}
	CALL SUBOPT_0x86
	RJMP _0x24D
_0x24E:
;    2203 		m++;
	CALL SUBOPT_0x84
;    2204 	}
	RJMP _0x249
_0x24B:
;    2205 	return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x50A:
	CALL __LOADLOCR5
	ADIW R28,31
	RET
;    2206 }
;    2207 
;    2208 #ifndef _SECOND_FAT_ON_
;    2209 // Function that clears the secondary FAT table
;    2210 int clear_second_FAT(void)
;    2211 {
;    2212 	unsigned int c, d;
;    2213 	unsigned long n;
;    2214 	
;    2215 	for (n=1; n<BPB_FATSz16; n++)
;    2216 	{
;    2217 		if (_FF_read(_FF_FAT2_ADDR+(n*0x200))==0)
;    2218 			return (EOF);
;    2219 		for (c=0; c<BPB_BytsPerSec; c++)
;    2220 		{
;    2221 			if (_FF_buff[c] != 0)
;    2222 			{
;    2223 				for (d=0; d<BPB_BytsPerSec; d++)
;    2224 					_FF_buff[d] = 0;
;    2225 				if (_FF_write(_FF_FAT2_ADDR+(n*0x200))==0)
;    2226 					return (EOF);
;    2227 				break;
;    2228 			}
;    2229 		}
;    2230 	}
;    2231 	for (d=2; d<BPB_BytsPerSec; d++)
;    2232 		_FF_buff[d] = 0;
;    2233 	_FF_buff[0] = 0xF8;
;    2234 	_FF_buff[1] = 0xFF;
;    2235 	_FF_buff[2] = 0xFF;
;    2236 	if (BPB_FATType == 0x36)
;    2237 		_FF_buff[3] = 0xFF;
;    2238 	if (_FF_write(_FF_FAT2_ADDR)==0)
;    2239 		return (EOF);
;    2240 	
;    2241 	return (1);
;    2242 }
;    2243 #endif
;    2244  
;    2245 // Open a file, name stored in string fileopen
;    2246 FILE *fopenc(unsigned char flash *NAMEC, unsigned char MODEC)
;    2247 {
;    2248 	unsigned char c, temp_data[12];
;    2249 	FILE *tp;
;    2250 	
;    2251 	for (c=0; c<12; c++)
;	*NAMEC -> Y+16
;	MODEC -> Y+15
;	c -> R16
;	temp_data -> Y+3
;	*tp -> R17,R18
;    2252 		temp_data[c] = NAMEC[c];
;    2253 	
;    2254 	tp = fopen(temp_data, MODEC);
;    2255 	return(tp);
;    2256 }
;    2257 
;    2258 FILE *fopen(unsigned char *NAME, unsigned char MODE)
;    2259 {
_fopen:
;    2260 	unsigned char fpath[14];
;    2261 	unsigned int c, s, calc_temp;
;    2262 	unsigned char *sp, *qp;
;    2263 	unsigned long addr_temp, path_addr_temp;
;    2264 	FILE *rp;
;    2265 	
;    2266 	#ifdef _READ_ONLY_
;    2267 		if (MODE!=READ)
;    2268 			return (0);
;    2269 	#endif
;    2270 	
;    2271     addr_temp = 0;	// save local dir addr
	CALL SUBOPT_0x88
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
;    2272     
;    2273     if (_FF_checkdir(NAME, &addr_temp, fpath))
	BREQ _0x25B
;    2274 	{
;    2275 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x89
;    2276 		return (0);
	RJMP _0x509
;    2277 	}
;    2278 	if (fpath[0]==0)
_0x25B:
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x25C
;    2279 	{
;    2280 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x89
;    2281 		return (0);
	RJMP _0x509
;    2282 	}
;    2283     
;    2284 	path_addr_temp = _FF_DIR_ADDR;
_0x25C:
	CALL SUBOPT_0x8A
;    2285 	s = scan_directory(&path_addr_temp, fpath);
;    2286 	if ((path_addr_temp==0) || (s==0))
	__GETD2S 8
	CALL __CPD02
	BREQ _0x25E
	CLR  R0
	CP   R0,R18
	CPC  R0,R19
	BRNE _0x25D
_0x25E:
;    2287 	{
;    2288 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x89
;    2289 		return (0);
	RJMP _0x509
;    2290 	}
;    2291 
;    2292 	rp = 0;
_0x25D:
	LDI  R30,0
	STD  Y+6,R30
	STD  Y+6+1,R30
;    2293 	rp = malloc(sizeof(FILE));
	LDI  R30,LOW(553)
	LDI  R31,HIGH(553)
	ST   -Y,R31
	ST   -Y,R30
	CALL _malloc
	CALL SUBOPT_0x8B
;    2294 	if (rp == 0)
	BRNE _0x260
;    2295 	{	// Could not allocate requested memory
;    2296 		_FF_error = ALLOC_ERR;
	LDI  R30,LOW(9)
	STS  __FF_error,R30
;    2297 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x89
;    2298 		return (0);
	RJMP _0x509
;    2299 	}
;    2300 	rp->length = 0x46344456;
_0x260:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	__GETD1N 0x46344456
	CALL __PUTDP1
;    2301 	rp->clus_start = 0xe4;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,12
	LDI  R30,LOW(228)
	LDI  R31,HIGH(228)
	ST   X+,R30
	ST   X,R31
;    2302 	rp->position = 0x45664446;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-544)
	SBCI R27,HIGH(-544)
	__GETD1N 0x45664446
	CALL __PUTDP1
;    2303 
;    2304 	calc_temp = path_addr_temp % BPB_BytsPerSec;
	CALL SUBOPT_0x8C
;    2305 	path_addr_temp -= calc_temp;
;    2306 	if (_FF_read(path_addr_temp)==0)	
	BRNE _0x261
;    2307 	{
;    2308 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x89
;    2309 		return (0);
	RJMP _0x509
;    2310 	}
;    2311 	
;    2312 	// Get the filename into a form we can use to compare
;    2313 	qp = file_name_conversion(fpath);
_0x261:
	CALL SUBOPT_0x8D
;    2314 	if (qp==0)
	BRNE _0x262
;    2315 	{	// If File name entered is NOT valid, return 0
;    2316 		free(rp);
	CALL SUBOPT_0x8E
;    2317 		_FF_DIR_ADDR = addr_temp;
;    2318 		return (0);
	RJMP _0x509
;    2319 	}
;    2320 	
;    2321 	sp = &_FF_buff[calc_temp];
_0x262:
	CALL SUBOPT_0x8F
;    2322 
;    2323 	if (s)
	BRNE PC+3
	JMP _0x263
;    2324 	{	// File exists, open 
;    2325 		if (((MODE==WRITE) || (MODE==APPEND)) && (_FF_buff[calc_temp+0x0B]&0x01))
	LDD  R26,Y+34
	CPI  R26,LOW(0x2)
	BREQ _0x265
	CPI  R26,LOW(0x3)
	BRNE _0x267
_0x265:
	MOVW R30,R20
	__ADDW1MN __FF_buff,11
	LD   R30,Z
	ANDI R30,LOW(0x1)
	BRNE _0x268
_0x267:
	RJMP _0x264
_0x268:
;    2326 		{	// if writing to file verify it is not "READ ONLY"
;    2327 			_FF_error = MODE_ERR;
	CALL SUBOPT_0x90
;    2328 			free(rp);
;    2329 			_FF_DIR_ADDR = addr_temp;
;    2330 			return (0);
	RJMP _0x509
;    2331 		}
;    2332 		for (c=0; c<12; c++)	// Save Filename to Buffer
_0x264:
	__GETWRN 16,17,0
_0x26A:
	__CPWRN 16,17,12
	BRSH _0x26B
;    2333 			rp->name[c] = FILENAME[c];
	MOVW R30,R16
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDI  R26,LOW(_FILENAME)
	LDI  R27,HIGH(_FILENAME)
	CALL SUBOPT_0x91
;    2334 		// Save Starting Cluster
;    2335 		rp->clus_start = ((int) _FF_buff[calc_temp+0x1B] << 8) | (int) _FF_buff[calc_temp+0x1A];
	__ADDWRN 16,17,1
	RJMP _0x26A
_0x26B:
	MOVW R30,R20
	__ADDW1MN __FF_buff,27
	CALL SUBOPT_0x30
	MOVW R30,R20
	__ADDW1MN __FF_buff,26
	CALL SUBOPT_0x31
	__PUTW1SNS 6,12
;    2336 		// Set Current Cluster
;    2337 		rp->clus_current = rp->clus_start;
	CALL SUBOPT_0x92
	__PUTW1SNS 6,14
;    2338 		// Set Previous Cluster to 0 (indicating @start)
;    2339 		rp->clus_prev = 0;
	CALL SUBOPT_0x93
;    2340 		// Save file length
;    2341 		rp->length = 0;
	CALL SUBOPT_0x94
;    2342 		sp = _FF_buff + calc_temp + 0x1F;
	CALL SUBOPT_0x95
;    2343 		for (c=0; c<4; c++)
	__GETWRN 16,17,0
_0x26D:
	__CPWRN 16,17,4
	BRSH _0x26E
;    2344 		{
;    2345 			rp->length <<= 8;
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
;    2346 			rp->length |= *sp--;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SUBI R30,LOW(-540)
	SBCI R31,HIGH(-540)
	MOVW R0,R30
	MOVW R26,R30
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x96
	LD   R30,X
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __ORD12
	MOVW R26,R0
	CALL __PUTDP1
;    2347 		}
	__ADDWRN 16,17,1
	RJMP _0x26D
_0x26E:
;    2348 		// Set Current Position to 0
;    2349 		rp->position = 0;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-544)
	SBCI R27,HIGH(-544)
	__GETD1N 0x0
	CALL __PUTDP1
;    2350 		#ifndef _READ_ONLY_
;    2351 			if (MODE==WRITE)
	LDD  R26,Y+34
	CPI  R26,LOW(0x2)
	BRNE _0x26F
;    2352 			{	// Change file to blank
;    2353 				sp = _FF_buff + calc_temp + 0x1F;
	CALL SUBOPT_0x95
;    2354 				for (c=0; c<6; c++)
	__GETWRN 16,17,0
_0x271:
	__CPWRN 16,17,6
	BRSH _0x272
;    2355 					*sp-- = 0;
	CALL SUBOPT_0x96
	LDI  R30,LOW(0)
	ST   X,R30
;    2356 				if (rp->length)
	__ADDWRN 16,17,1
	RJMP _0x271
_0x272:
	CALL SUBOPT_0x97
	BREQ _0x273
;    2357 				{
;    2358 					if (_FF_write(_FF_DIR_ADDR + (0x200 * s))==0)
	MOVW R30,R18
	CALL SUBOPT_0x98
	CALL SUBOPT_0x62
	BRNE _0x274
;    2359 					{
;    2360 						free(rp);
	CALL SUBOPT_0x8E
;    2361 						_FF_DIR_ADDR = addr_temp;
;    2362 						return (0);
	RJMP _0x509
;    2363 					}
;    2364 					rp->length = 0;
_0x274:
	CALL SUBOPT_0x94
;    2365 					erase_clus_chain(rp->clus_start);
	CALL SUBOPT_0x99
	CALL _erase_clus_chain
;    2366 					rp->clus_start = 0;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,12
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
;    2367 				}
;    2368 			}
_0x273:
;    2369 		#endif
;    2370 		// Set and save next cluster #
;    2371 		rp->clus_next = next_cluster(rp->clus_current, SINGLE);
_0x26F:
	CALL SUBOPT_0x9A
	CALL SUBOPT_0x9B
	__PUTW1SNS 6,16
;    2372 		if ((rp->length==0) && (rp->clus_start==0))
	CALL SUBOPT_0x97
	BRNE _0x276
	CALL SUBOPT_0x92
	SBIW R30,0
	BREQ _0x277
_0x276:
	RJMP _0x275
_0x277:
;    2373 		{	// Check for Blank File 
;    2374 			if (MODE==READ)
	LDD  R26,Y+34
	CPI  R26,LOW(0x1)
	BRNE _0x278
;    2375 			{	// IF trying to open a blank file to read, ERROR
;    2376 				_FF_error = MODE_ERR;
	CALL SUBOPT_0x90
;    2377 				free(rp);
;    2378 				_FF_DIR_ADDR = addr_temp;
;    2379 				return (0);
	RJMP _0x509
;    2380 			}
;    2381 			//Setup blank FILE characteristics
;    2382 			#ifndef _READ_ONLY_
;    2383 				MODE = WRITE; 
_0x278:
	LDI  R30,LOW(2)
	STD  Y+34,R30
;    2384 			#endif
;    2385 		}
;    2386 		// Save the file offset to read entry
;    2387 		rp->entry_sec_addr = path_addr_temp;
_0x275:
	__GETD1S 8
	__PUTD1SNS 6,22
;    2388 		rp->entry_offset =  calc_temp;
	MOVW R30,R20
	__PUTW1SNS 6,26
;    2389 		// Set sector offset to 1
;    2390 		rp->sec_offset = 1;
	CALL SUBOPT_0x9C
;    2391 		if (MODE==APPEND)
	LDD  R26,Y+34
	CPI  R26,LOW(0x3)
	BRNE _0x279
;    2392 		{
;    2393 			if (fseek(rp, 0,SEEK_END)==EOF)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _fseek
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x27A
;    2394 			{
;    2395 				free(rp);
	CALL SUBOPT_0x8E
;    2396 				_FF_DIR_ADDR = addr_temp;
;    2397 				return (0);
	RJMP _0x509
;    2398 			}
;    2399 		}
_0x27A:
;    2400 		else
	RJMP _0x27B
_0x279:
;    2401 		{	// Set pointer to the begining of the file
;    2402 			_FF_read(clust_to_addr(rp->clus_current));
	CALL SUBOPT_0x9A
	CALL _clust_to_addr
	CALL __PUTPARD1
	CALL __FF_read
;    2403 			for (c=0; c<BPB_BytsPerSec; c++)
	__GETWRN 16,17,0
_0x27D:
	__CPWRR 16,17,6,7
	BRSH _0x27E
;    2404 				rp->buff[c] = _FF_buff[c];
	CALL SUBOPT_0x9D
	CALL SUBOPT_0x9E
;    2405 			rp->pntr = &rp->buff[0];
	__ADDWRN 16,17,1
	RJMP _0x27D
_0x27E:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,28
	__PUTW1SN 6,551
;    2406 		}
_0x27B:
;    2407 		#ifndef _READ_ONLY_
;    2408 			#ifndef _SECOND_FAT_ON_
;    2409 				if ((MODE==WRITE) || (MODE==APPEND))
;    2410 					clear_second_FAT();
;    2411 			#endif
;    2412     	#endif
;    2413 		rp->mode = MODE;
	LDD  R30,Y+34
	__PUTB1SN 6,548
;    2414 		_FF_error = NO_ERR;
	LDI  R30,LOW(0)
	STS  __FF_error,R30
;    2415 		_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    2416 		return(rp);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RJMP _0x509
;    2417 	}
;    2418 	else
_0x263:
;    2419 	{                          		
;    2420 		_FF_error = FILE_ERR;
	LDI  R30,LOW(2)
	STS  __FF_error,R30
;    2421 		free(rp);
	CALL SUBOPT_0x8E
;    2422 		_FF_DIR_ADDR = addr_temp;
;    2423 		return(0);
	RJMP _0x509
;    2424 	}
;    2425 }
;    2426 
;    2427 #ifndef _READ_ONLY_
;    2428 // Create a file
;    2429 FILE *fcreatec(unsigned char flash *NAMEC, unsigned char MODE)
;    2430 {
;    2431 	unsigned char sd_temp[12];
;    2432 	int c;
;    2433 
;    2434 	for (c=0; c<12; c++)
;	*NAMEC -> Y+15
;	MODE -> Y+14
;	sd_temp -> Y+2
;	c -> R16,R17
;    2435 		sd_temp[c] = NAMEC[c];
;    2436 	
;    2437 	return (fcreate(sd_temp, MODE));
;    2438 }
;    2439 
;    2440 FILE *fcreate(unsigned char *NAME, unsigned char MODE)
;    2441 {
_fcreate:
;    2442 	unsigned char fpath[14];
;    2443 	unsigned int c, s, calc_temp;
;    2444 	unsigned char *sp, *qp;
;    2445 	unsigned long addr_temp, path_addr_temp;
;    2446 	FILE *temp_file_pntr;
;    2447 
;    2448     addr_temp = 0;	// save local dir addr
	CALL SUBOPT_0x88
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
;    2449     
;    2450     if (_FF_checkdir(NAME, &addr_temp, fpath))
	BREQ _0x283
;    2451 	{
;    2452 		_FF_error = PATH_ERR;
	LDI  R30,LOW(14)
	STS  __FF_error,R30
;    2453 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x89
;    2454 		return (0);
	RJMP _0x509
;    2455 	}
;    2456 	if (fpath[0]==0)
_0x283:
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x284
;    2457 	{
;    2458 		_FF_error = NAME_ERR; 
	CALL SUBOPT_0x9F
;    2459 		_FF_DIR_ADDR = addr_temp;
;    2460 		return (0);
	RJMP _0x509
;    2461 	}
;    2462     
;    2463 	path_addr_temp = _FF_DIR_ADDR;
_0x284:
	CALL SUBOPT_0x8A
;    2464 	s = scan_directory(&path_addr_temp, fpath);
;    2465 	if (path_addr_temp==0)
	__GETD1S 8
	CALL __CPD10
	BRNE _0x285
;    2466 	{
;    2467 		_FF_error = NO_ENTRY_AVAL;
	LDI  R30,LOW(15)
	STS  __FF_error,R30
;    2468 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x89
;    2469 		return (0);
	RJMP _0x509
;    2470 	}
;    2471 
;    2472 	calc_temp = path_addr_temp % BPB_BytsPerSec;
_0x285:
	CALL SUBOPT_0x8C
;    2473 	path_addr_temp -= calc_temp;
;    2474 	if (_FF_read(path_addr_temp)==0)	
	BRNE _0x286
;    2475 	{
;    2476 		_FF_error = READ_ERR;
	LDI  R30,LOW(4)
	STS  __FF_error,R30
;    2477 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x89
;    2478 		return (0);
	RJMP _0x509
;    2479 	}
;    2480 
;    2481 	// Get the filename into a form we can use to compare
;    2482 	qp = file_name_conversion(fpath);
_0x286:
	CALL SUBOPT_0x8D
;    2483 	if (qp==0)
	BRNE _0x287
;    2484 	{
;    2485 		_FF_error = NAME_ERR; 
	CALL SUBOPT_0x9F
;    2486 		_FF_DIR_ADDR = addr_temp;
;    2487 		return (0);
	RJMP _0x509
;    2488 	}
;    2489 	sp = &_FF_buff[calc_temp];
_0x287:
	CALL SUBOPT_0x8F
;    2490 	
;    2491 	if (s)
	BREQ _0x288
;    2492 	{
;    2493 		if ((_FF_buff[calc_temp+0x0B]&0x1)==1)	// is file read only
	MOVW R30,R20
	__ADDW1MN __FF_buff,11
	LD   R30,Z
	ANDI R30,LOW(0x1)
	CPI  R30,LOW(0x1)
	BRNE _0x289
;    2494 		{
;    2495 			_FF_error = READONLY_ERR;
	LDI  R30,LOW(6)
	STS  __FF_error,R30
;    2496 			_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x89
;    2497 			return (0);
	RJMP _0x509
;    2498 		}
;    2499 	}
_0x289:
;    2500 	else
	RJMP _0x28A
_0x288:
;    2501 	{
;    2502 		for (c=0; c<11; c++)	// Write Filename
	__GETWRN 16,17,0
_0x28C:
	__CPWRN 16,17,11
	BRSH _0x28D
;    2503 			*sp++ = *qp++;
	CALL SUBOPT_0xA0
	SBIW R30,1
	MOVW R0,R30
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R30,X+
	STD  Y+16,R26
	STD  Y+16+1,R27
	MOVW R26,R0
	ST   X,R30
;    2504 		*sp = 0x20;				// Attribute bit auto set to "ARCHIVE"
	__ADDWRN 16,17,1
	RJMP _0x28C
_0x28D:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDI  R30,LOW(32)
	ST   X,R30
;    2505 		sp++;		
	CALL SUBOPT_0xA0
;    2506 		*sp++ = 0;				// Reserved for WinNT
	CALL SUBOPT_0xA1
;    2507 		*sp++ = 0;				// Mili-second stamp for create
	CALL SUBOPT_0xA1
;    2508 	
;    2509 		#ifdef _RTC_ON_
;    2510 			rtc_get_timeNdate(&rtc_hour, &rtc_min, &rtc_sec, &rtc_date, &rtc_month, (int *)&rtc_year);	    			
;    2511     	    calc_temp = ((int)rtc_sec&0x1F) | (((int)rtc_min&0x3F)<<5) | (((int)rtc_hour&0x1F)<<11);
;    2512 			*sp++ = calc_temp&0x00FF;	// File create Time 
;    2513 			*sp++ = (calc_temp&0xFF00) >> 8;
;    2514 			calc_temp = ((int)rtc_date&0x1F) | (((int)rtc_month&0x0F)<<5) | (((rtc_year-1980)&0x7F)<<9);
;    2515 			*sp++ = calc_temp&0x00FF;	// File create Date
;    2516 			*sp++ = (calc_temp&0xFF00) >> 8;
;    2517 		#else
;    2518 			for (c=0; c<4; c++)
	__GETWRN 16,17,0
_0x28F:
	__CPWRN 16,17,4
	BRSH _0x290
;    2519 				*sp++ = 0;
	CALL SUBOPT_0xA1
;    2520 		#endif
;    2521 
;    2522 		*sp++ = 0;				// File access date (2 bytes)
	__ADDWRN 16,17,1
	RJMP _0x28F
_0x290:
	CALL SUBOPT_0xA1
;    2523 		*sp++ = 0;
	CALL SUBOPT_0xA1
;    2524 		*sp++ = 0;				// 0 for FAT12/16 (2 bytes)
	CALL SUBOPT_0xA1
;    2525 		*sp++ = 0;
	CALL SUBOPT_0xA1
;    2526 		for (c=0; c<4; c++)		// Modify time/date
	__GETWRN 16,17,0
_0x292:
	__CPWRN 16,17,4
	BRSH _0x293
;    2527 			*sp++ = 0;
	CALL SUBOPT_0xA1
;    2528 		*sp++ = 0;				// Starting cluster (2 bytes)
	__ADDWRN 16,17,1
	RJMP _0x292
_0x293:
	CALL SUBOPT_0xA1
;    2529 		*sp++ = 0;
	CALL SUBOPT_0xA1
;    2530 		for (c=0; c<4; c++)
	__GETWRN 16,17,0
_0x295:
	__CPWRN 16,17,4
	BRSH _0x296
;    2531 			*sp++ = 0;			// File length (0 for new)
	CALL SUBOPT_0xA1
;    2532 	
;    2533 		if (_FF_write(path_addr_temp)==0)
	__ADDWRN 16,17,1
	RJMP _0x295
_0x296:
	__GETD1S 8
	CALL SUBOPT_0x62
	BRNE _0x297
;    2534 		{
;    2535 			_FF_error = WRITE_ERR;
	LDI  R30,LOW(3)
	STS  __FF_error,R30
;    2536 			_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x89
;    2537 			return (0);				
	RJMP _0x509
;    2538 		}
;    2539 	}
_0x297:
_0x28A:
;    2540 	_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    2541 	temp_file_pntr = fopen(NAME, WRITE);
	LDD  R30,Y+35
	LDD  R31,Y+35+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _fopen
	CALL SUBOPT_0x8B
;    2542 	if (temp_file_pntr == 0)	// Will file open
	BRNE _0x298
;    2543 		return (0);				
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x509
;    2544 	if (MODE)
_0x298:
	LDD  R30,Y+34
	CPI  R30,0
	BREQ _0x299
;    2545 	{
;    2546 		if (_FF_read(addr_temp)==0)
	__GETD1S 12
	CALL SUBOPT_0xC
	BRNE _0x29A
;    2547 		{
;    2548 			_FF_error = READ_ERR;
	LDI  R30,LOW(4)
	STS  __FF_error,R30
;    2549 			return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x509
;    2550 		}
;    2551 		_FF_buff[calc_temp+12] |= MODE;		
_0x29A:
	MOVW R30,R20
	__ADDW1MN __FF_buff,12
	MOVW R0,R30
	LD   R30,Z
	LDD  R26,Y+34
	OR   R30,R26
	MOVW R26,R0
	ST   X,R30
;    2552 		if (_FF_write(addr_temp)==0)
	__GETD1S 12
	CALL SUBOPT_0x62
	BRNE _0x29B
;    2553 		{
;    2554 			_FF_error = WRITE_ERR;
	LDI  R30,LOW(3)
	STS  __FF_error,R30
;    2555 			return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x509
;    2556 		}
;    2557 	}
_0x29B:
;    2558 	_FF_error = NO_ERR;
_0x299:
	LDI  R30,LOW(0)
	STS  __FF_error,R30
;    2559 	return (temp_file_pntr);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
_0x509:
	CALL __LOADLOCR6
	ADIW R28,37
	RET
;    2560 }
;    2561 #endif
;    2562 
;    2563 #ifndef _READ_ONLY_
;    2564 // Open a file, name stored in string fileopen
;    2565 int removec(unsigned char flash *NAMEC)
;    2566 {
;    2567 	int c;
;    2568 	unsigned char sd_temp[12];
;    2569 	
;    2570 	for (c=0; c<12; c++)
;	*NAMEC -> Y+14
;	c -> R16,R17
;	sd_temp -> Y+2
;    2571 		sd_temp[c] = NAMEC[c];
;    2572 	
;    2573 	c = remove(sd_temp);
;    2574 	return (c);
;    2575 }
;    2576 
;    2577 // Remove a file from the root directory
;    2578 int remove(unsigned char *NAME)
;    2579 {
_remove:
;    2580 	unsigned char fpath[14];
;    2581 	unsigned int s, calc_temp;
;    2582 	unsigned long addr_temp, path_addr_temp;
;    2583 	
;    2584 	#ifndef _SECOND_FAT_ON_
;    2585 		clear_second_FAT();
;    2586     #endif
;    2587     
;    2588     addr_temp = 0;	// save local dir addr
	SBIW R28,22
	CALL __SAVELOCR4
;	*NAME -> Y+26
;	fpath -> Y+12
;	s -> R16,R17
;	calc_temp -> R18,R19
;	addr_temp -> Y+8
;	path_addr_temp -> Y+4
	__CLRD1S 8
;    2589     
;    2590     if (_FF_checkdir(NAME, &addr_temp, fpath))
	LDD  R30,Y+26
	LDD  R31,Y+26+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,16
	CALL SUBOPT_0x6A
	BREQ _0x29F
;    2591 	{
;    2592 		_FF_error = PATH_ERR;
	LDI  R30,LOW(14)
	CALL SUBOPT_0xA2
;    2593 		_FF_DIR_ADDR = addr_temp;
;    2594 		return (EOF);
	RJMP _0x508
;    2595 	}
;    2596 	if (fpath[0]==0)
_0x29F:
	LDD  R30,Y+12
	CPI  R30,0
	BRNE _0x2A0
;    2597 	{
;    2598 		_FF_error = NAME_ERR; 
	LDI  R30,LOW(5)
	CALL SUBOPT_0xA2
;    2599 		_FF_DIR_ADDR = addr_temp;
;    2600 		return (EOF);
	RJMP _0x508
;    2601 	}
;    2602     
;    2603 	path_addr_temp = _FF_DIR_ADDR;
_0x2A0:
	LDS  R30,__FF_DIR_ADDR
	LDS  R31,__FF_DIR_ADDR+1
	LDS  R22,__FF_DIR_ADDR+2
	LDS  R23,__FF_DIR_ADDR+3
	__PUTD1S 4
;    2604 	s = scan_directory(&path_addr_temp, fpath);
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,14
	ST   -Y,R31
	ST   -Y,R30
	CALL _scan_directory
	MOVW R16,R30
;    2605 	if ((path_addr_temp==0) || (s==0))
	__GETD2S 4
	CALL __CPD02
	BREQ _0x2A2
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRNE _0x2A1
_0x2A2:
;    2606 	{
;    2607 		_FF_error = NO_ENTRY_AVAL;
	LDI  R30,LOW(15)
	CALL SUBOPT_0xA2
;    2608 		_FF_DIR_ADDR = addr_temp;
;    2609 		return (EOF);
	RJMP _0x508
;    2610 	}
;    2611 	_FF_DIR_ADDR = addr_temp;		// Reset current dir
_0x2A1:
	__GETD1S 8
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    2612 
;    2613 	calc_temp = path_addr_temp % BPB_BytsPerSec;
	CALL SUBOPT_0xA3
	CALL __MODD21U
	MOVW R18,R30
;    2614 	path_addr_temp -= calc_temp;
	MOVW R30,R18
	__GETD2S 4
	CLR  R22
	CLR  R23
	CALL __SUBD21
	__PUTD2S 4
;    2615 	if (_FF_read(path_addr_temp)==0)	
	__GETD1S 4
	CALL SUBOPT_0xC
	BRNE _0x2A4
;    2616 	{
;    2617 		_FF_error = READ_ERR;
	CALL SUBOPT_0xA4
;    2618 		return (EOF);
	RJMP _0x508
;    2619 	}
;    2620 	
;    2621 	// Erase entry (put 0xE5 into start of the filename
;    2622 	_FF_buff[calc_temp] = 0xE5;
_0x2A4:
	LDI  R26,LOW(__FF_buff)
	LDI  R27,HIGH(__FF_buff)
	ADD  R26,R18
	ADC  R27,R19
	LDI  R30,LOW(229)
	ST   X,R30
;    2623 	if (_FF_write(path_addr_temp)==0)
	__GETD1S 4
	CALL SUBOPT_0x62
	BRNE _0x2A5
;    2624 	{
;    2625 		_FF_error = WRITE_ERR;
	CALL SUBOPT_0x63
;    2626 		return (EOF);
	RJMP _0x508
;    2627 	}
;    2628 	// Save Starting Cluster
;    2629 	calc_temp = ((int) _FF_buff[calc_temp+0x1B] << 8) | (int) _FF_buff[calc_temp+0x1A];
_0x2A5:
	MOVW R30,R18
	__ADDW1MN __FF_buff,27
	CALL SUBOPT_0x30
	MOVW R30,R18
	__ADDW1MN __FF_buff,26
	CALL SUBOPT_0x31
	MOVW R18,R30
;    2630 	// Destroy cluster chain
;    2631 	if (calc_temp)
	MOV  R0,R18
	OR   R0,R19
	BREQ _0x2A6
;    2632 		if (erase_clus_chain(calc_temp) == 0)
	ST   -Y,R19
	ST   -Y,R18
	CALL _erase_clus_chain
	CPI  R30,0
	BRNE _0x2A7
;    2633 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x508
;    2634 			
;    2635 	return (1);
_0x2A7:
_0x2A6:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
_0x508:
	CALL __LOADLOCR4
	ADIW R28,28
	RET
;    2636 }
;    2637 #endif
;    2638 
;    2639 #ifndef _READ_ONLY_
;    2640 // Rename a file in the Root Directory
;    2641 int rename(unsigned char *NAME_OLD, unsigned char *NAME_NEW)
;    2642 {
_rename:
;    2643 	unsigned char c;
;    2644 	unsigned int calc_temp;
;    2645 	unsigned long addr_temp, path_addr_temp;
;    2646 	unsigned char *sp, *qp;
;    2647 	unsigned char fpath[14];
;    2648 
;    2649 	// Get the filename into a form we can use to compare
;    2650 	qp = file_name_conversion(NAME_NEW);
	SBIW R28,24
	CALL __SAVELOCR5
;	*NAME_OLD -> Y+31
;	*NAME_NEW -> Y+29
;	c -> R16
;	calc_temp -> R17,R18
;	addr_temp -> Y+25
;	path_addr_temp -> Y+21
;	*sp -> R19,R20
;	*qp -> Y+19
;	fpath -> Y+5
	LDD  R30,Y+29
	LDD  R31,Y+29+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _file_name_conversion
	STD  Y+19,R30
	STD  Y+19+1,R31
;    2651 	if (qp==0)
	SBIW R30,0
	BRNE _0x2A8
;    2652 	{
;    2653 		_FF_error = NAME_ERR;
	CALL SUBOPT_0xA5
;    2654 		return (EOF);
	RJMP _0x507
;    2655 	}
;    2656 	
;    2657     addr_temp = 0;	// save local dir addr
_0x2A8:
	__CLRD1S 25
;    2658     
;    2659     if (_FF_checkdir(NAME_OLD, &addr_temp, fpath))
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,27
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,9
	CALL SUBOPT_0x6A
	BREQ _0x2A9
;    2660 	{
;    2661 		_FF_error = PATH_ERR;
	LDI  R30,LOW(14)
	CALL SUBOPT_0xA6
;    2662 		_FF_DIR_ADDR = addr_temp;
;    2663 		return (EOF);
	RJMP _0x507
;    2664 	}
;    2665 	if (fpath[0]==0)
_0x2A9:
	LDD  R30,Y+5
	CPI  R30,0
	BRNE _0x2AA
;    2666 	{
;    2667 		_FF_error = NAME_ERR; 
	LDI  R30,LOW(5)
	CALL SUBOPT_0xA6
;    2668 		_FF_DIR_ADDR = addr_temp;
;    2669 		return (EOF);
	RJMP _0x507
;    2670 	}
;    2671 
;    2672 	path_addr_temp = _FF_DIR_ADDR;
_0x2AA:
	CALL SUBOPT_0xA7
;    2673 	calc_temp = scan_directory(&path_addr_temp, NAME_NEW);
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _scan_directory
	__PUTW1R 17,18
;    2674 	if (calc_temp)
	MOV  R0,R17
	OR   R0,R18
	BREQ _0x2AB
;    2675 	{	// does new name alread exist?
;    2676 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0xA8
;    2677 		_FF_error = EXIST_ERR;
;    2678 		return (EOF);
	RJMP _0x507
;    2679 	}
;    2680 
;    2681 	path_addr_temp = _FF_DIR_ADDR;
_0x2AB:
	CALL SUBOPT_0xA7
;    2682 	calc_temp = scan_directory(&path_addr_temp, fpath);
	CALL SUBOPT_0x76
	CALL _scan_directory
	__PUTW1R 17,18
;    2683 	if ((path_addr_temp==0) || (calc_temp==0))
	__GETD2S 21
	CALL __CPD02
	BREQ _0x2AD
	CLR  R0
	CP   R0,R17
	CPC  R0,R18
	BRNE _0x2AC
_0x2AD:
;    2684 	{
;    2685 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0xA8
;    2686 		_FF_error = EXIST_ERR;
;    2687 		return (EOF);
	RJMP _0x507
;    2688 	}
;    2689 
;    2690 
;    2691 	_FF_DIR_ADDR = addr_temp;		// Reset current dir
_0x2AC:
	__GETD1S 25
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    2692 
;    2693 	calc_temp = path_addr_temp % BPB_BytsPerSec;
	MOVW R30,R6
	__GETD2S 21
	CLR  R22
	CLR  R23
	CALL __MODD21U
	__PUTW1R 17,18
;    2694 	path_addr_temp -= calc_temp;
	__GETW1R 17,18
	__GETD2S 21
	CLR  R22
	CLR  R23
	CALL __SUBD21
	__PUTD2S 21
;    2695 	if (_FF_read(path_addr_temp)==0)	
	__GETD1S 21
	CALL SUBOPT_0xC
	BRNE _0x2AF
;    2696 	{
;    2697 		_FF_error = READ_ERR;
	CALL SUBOPT_0xA4
;    2698 		return (EOF);
	RJMP _0x507
;    2699 	}
;    2700 	
;    2701 	// Rename entry
;    2702 	sp = &_FF_buff[calc_temp];
_0x2AF:
	__GETW1R 17,18
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	__PUTW1R 19,20
;    2703 	for (c=0; c<11; c++)
	LDI  R16,LOW(0)
_0x2B1:
	CPI  R16,11
	BRSH _0x2B2
;    2704 		*sp++ = *qp++;
	PUSH R20
	PUSH R19
	__ADDWRN 19,20,1
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	LD   R30,X+
	STD  Y+19,R26
	STD  Y+19+1,R27
	POP  R26
	POP  R27
	ST   X,R30
;    2705 	if (_FF_write(path_addr_temp)==0)
	SUBI R16,-1
	RJMP _0x2B1
_0x2B2:
	__GETD1S 21
	CALL SUBOPT_0x62
	BRNE _0x2B3
;    2706 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x507
;    2707 
;    2708 	return(0);
_0x2B3:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x507:
	CALL __LOADLOCR5
	ADIW R28,33
	RET
;    2709 }
;    2710 #endif
;    2711 
;    2712 #ifndef _READ_ONLY_
;    2713 // Save Contents of file, w/o closing
;    2714 int fflush(FILE *rp)	
;    2715 {
_fflush:
;    2716 	unsigned int  n;
;    2717 	unsigned long addr_temp;
;    2718 	
;    2719 	if ((rp==NULL) || (rp->mode==READ))
	CALL SUBOPT_0xA9
;	*rp -> Y+6
;	n -> R16,R17
;	addr_temp -> Y+2
	BREQ _0x2B5
	CALL SUBOPT_0xAA
	CPI  R26,LOW(0x1)
	BRNE _0x2B4
_0x2B5:
;    2720 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x506
;    2721 	
;    2722 	if ((rp->mode==WRITE) || (rp->mode==APPEND))
_0x2B4:
	CALL SUBOPT_0xAA
	CPI  R26,LOW(0x2)
	BREQ _0x2B8
	CALL SUBOPT_0xAA
	CPI  R26,LOW(0x3)
	BRNE _0x2B7
_0x2B8:
;    2723 	{
;    2724 		addr_temp = (clust_to_addr(rp->clus_current) + ((rp->sec_offset-1)*BPB_BytsPerSec));
	CALL SUBOPT_0x9A
	CALL _clust_to_addr
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xAB
	CALL __MULW12U
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0xAC
;    2725 		for (n=0; n<BPB_BytsPerSec; n++)	// Save file buffer to SD buffer
	__GETWRN 16,17,0
_0x2BB:
	__CPWRR 16,17,6,7
	BRSH _0x2BC
;    2726 			_FF_buff[n] = rp->buff[n];
	CALL SUBOPT_0xAD
	LD   R30,Z
	ST   X,R30
;    2727 		if (_FF_write(addr_temp)==0)	// Write SD buffer to disk
	__ADDWRN 16,17,1
	RJMP _0x2BB
_0x2BC:
	__GETD1S 2
	CALL SUBOPT_0x62
	BRNE _0x2BD
;    2728 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x506
;    2729 		if (append_toc(rp)==0)	// Update Entry or Error
_0x2BD:
	CALL SUBOPT_0xAE
	BRNE _0x2BE
;    2730 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x506
;    2731 	}
_0x2BE:
;    2732 	
;    2733 	return (0);
_0x2B7:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x506:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	RET
;    2734 }
;    2735 #endif		
;    2736 
;    2737 
;    2738 // Close an open file
;    2739 int fclose(FILE *rp)	
;    2740 {
_fclose:
;    2741 	#ifndef _READ_ONLY_
;    2742 	if (rp->mode!=READ)
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0xAF
	BREQ _0x2BF
;    2743 		if (fflush(rp)==EOF)
	LD   R30,Y
	LDD  R31,Y+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _fflush
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2C0
;    2744 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x505
;    2745 	#endif	
;    2746 	// Clear File Structure
;    2747 	free(rp);
_0x2C0:
_0x2BF:
	CALL SUBOPT_0xB0
;    2748 	rp = 0;
	LDI  R30,0
	STD  Y+0,R30
	STD  Y+0+1,R30
;    2749 	return(0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x505
;    2750 }
;    2751 
;    2752 int ffreemem(FILE *rp)	
;    2753 {
_ffreemem:
;    2754 	// Clear File Structure
;    2755 	if (rp==0)
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE _0x2C1
;    2756 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x505
;    2757 	free(rp);
_0x2C1:
	CALL SUBOPT_0xB0
;    2758 	return(0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x505:
	ADIW R28,2
	RET
;    2759 }
;    2760 
;    2761 int fget_file_infoc(unsigned char flash *NAMEC, unsigned long *F_SIZE, unsigned char *F_CREATE,
;    2762 				unsigned char *F_MODIFY, unsigned char *F_ATTRIBUTE, unsigned int *F_CLUS_START)
;    2763 {
;    2764 	int c;
;    2765 	unsigned char sd_temp[12];
;    2766 	
;    2767 	for (c=0; c<12; c++)
;	*NAMEC -> Y+24
;	*F_SIZE -> Y+22
;	*F_CREATE -> Y+20
;	*F_MODIFY -> Y+18
;	*F_ATTRIBUTE -> Y+16
;	*F_CLUS_START -> Y+14
;	c -> R16,R17
;	sd_temp -> Y+2
;    2768 		sd_temp[c] = NAMEC[c];
;    2769 	
;    2770 	c = fget_file_info(sd_temp, F_SIZE, F_CREATE, F_MODIFY, F_ATTRIBUTE, F_CLUS_START);
;    2771 	return (c);
;    2772 }
;    2773 
;    2774 int fget_file_info(unsigned char *NAME, unsigned long *F_SIZE, unsigned char *F_CREATE,
;    2775 				unsigned char *F_MODIFY, unsigned char *F_ATTRIBUTE, unsigned int *F_CLUS_START)
;    2776 {
_fget_file_info:
;    2777 	unsigned char n;
;    2778 	unsigned int s, calc_temp;
;    2779 	unsigned long addr_temp, file_calc_temp;
;    2780 	unsigned char *sp, *qp;
;    2781 	
;    2782 	// Get the filename into a form we can use to compare
;    2783 	qp = file_name_conversion(NAME);
	SBIW R28,12
	CALL __SAVELOCR5
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
	LDD  R30,Y+27
	LDD  R31,Y+27+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _file_name_conversion
	STD  Y+5,R30
	STD  Y+5+1,R31
;    2784 	if (qp==0)
	SBIW R30,0
	BRNE _0x2C5
;    2785 	{
;    2786 		_FF_error = NAME_ERR;
	CALL SUBOPT_0xA5
;    2787 		return (EOF);
	RJMP _0x504
;    2788 	}
;    2789 	
;    2790 	for (s=0; s<BPB_BytsPerSec; s++)
_0x2C5:
	__GETWRN 17,18,0
_0x2C7:
	__CPWRR 17,18,6,7
	BRLO PC+3
	JMP _0x2C8
;    2791 	{	// Scan through directory entries to find file
;    2792 		addr_temp = _FF_DIR_ADDR + (0x200 * s);
	__GETW1R 17,18
	CALL SUBOPT_0x98
	__PUTD1S 13
;    2793 		if (_FF_read(addr_temp)==0)
	CALL SUBOPT_0xC
	BRNE _0x2C9
;    2794 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x504
;    2795 		for (n=0; n<16; n++)
_0x2C9:
	LDI  R16,LOW(0)
_0x2CB:
	CPI  R16,16
	BRLO PC+3
	JMP _0x2CC
;    2796 		{
;    2797 			calc_temp = (int) n * 0x20;
	MOV  R30,R16
	LDI  R31,0
	LSL  R30
	ROL  R31
	CALL __LSLW4
	__PUTW1R 19,20
;    2798 			qp = &FILENAME[0];
	LDI  R30,LOW(_FILENAME)
	LDI  R31,HIGH(_FILENAME)
	STD  Y+5,R30
	STD  Y+5+1,R31
;    2799 			sp = &_FF_buff[calc_temp];
	__GETW1R 19,20
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	STD  Y+7,R30
	STD  Y+7+1,R31
;    2800 			if (*sp == 0)
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LD   R30,X
	CPI  R30,0
	BRNE _0x2CD
;    2801 				return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x504
;    2802 			if (strncmp(qp, sp, 11)==0)		// Does this entry == Filename
_0x2CD:
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(11)
	ST   -Y,R30
	CALL _strncmp
	CPI  R30,0
	BREQ PC+3
	JMP _0x2CE
;    2803 			{
;    2804 				*F_ATTRIBUTE = _FF_buff[calc_temp+11];	// Save ATTRIBUTE Byte to location
	__GETW1R 19,20
	__ADDW1MN __FF_buff,11
	LD   R30,Z
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	ST   X,R30
;    2805 				*F_SIZE = ((long) _FF_buff[calc_temp+31] << 24) | ((long) _FF_buff[calc_temp+30] << 16)
;    2806 							| ((long) _FF_buff[calc_temp+29] << 8) | ((long) _FF_buff[calc_temp+28]);
	__GETW1R 19,20
	__ADDW1MN __FF_buff,31
	LD   R30,Z
	CALL SUBOPT_0x10
	__GETW1R 19,20
	__ADDW1MN __FF_buff,30
	LD   R30,Z
	CALL SUBOPT_0x11
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETW1R 19,20
	__ADDW1MN __FF_buff,29
	LD   R30,Z
	CALL SUBOPT_0x12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ORD12
	MOVW R26,R30
	MOVW R24,R22
	__GETW1R 19,20
	__ADDW1MN __FF_buff,28
	CALL SUBOPT_0x2F
	LDD  R26,Y+25
	LDD  R27,Y+25+1
	CALL __PUTDP1
;    2807 							// Save SIZE of file to location
;    2808                 *F_CLUS_START = ((unsigned int) _FF_buff[calc_temp+27] << 8) | ((unsigned int) _FF_buff[calc_temp+26]);
	__GETW1R 19,20
	__ADDW1MN __FF_buff,27
	CALL SUBOPT_0x30
	__GETW1R 19,20
	__ADDW1MN __FF_buff,26
	CALL SUBOPT_0x31
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ST   X+,R30
	ST   X,R31
;    2809 				file_calc_temp = ((unsigned int) _FF_buff[calc_temp+17] << 8) | ((unsigned int) _FF_buff[calc_temp+16]);
	__GETW1R 19,20
	__ADDW1MN __FF_buff,17
	CALL SUBOPT_0x30
	__GETW1R 19,20
	__ADDW1MN __FF_buff,16
	LD   R30,Z
	CALL SUBOPT_0xF
	__PUTD1S 9
;    2810 				qp = F_CREATE;
	LDD  R30,Y+23
	LDD  R31,Y+23+1
	CALL SUBOPT_0xB1
;    2811 				*qp++ = (((file_calc_temp >> 5) & 0x0F) / 10) + '0';
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xB2
	CALL __DIVD21U
	__ADDD1N 48
	POP  R26
	POP  R27
	CALL SUBOPT_0xB3
;    2812 				*qp++ = (((file_calc_temp >> 5) & 0x0F) % 10) + '0';
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xB2
	CALL __MODD21U
	__ADDD1N 48
	POP  R26
	POP  R27
	CALL SUBOPT_0xB4
;    2813 				*qp++ = '/';
	CALL SUBOPT_0xB3
;    2814 				*qp++ = ((file_calc_temp & 0x1F) / 10) + '0';
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xB5
	CALL __DIVD21U
	__ADDD1N 48
	POP  R26
	POP  R27
	CALL SUBOPT_0xB3
;    2815 				*qp++ = ((file_calc_temp & 0x1F) % 10) + '0';
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xB5
	CALL __MODD21U
	__ADDD1N 48
	POP  R26
	POP  R27
	CALL SUBOPT_0xB4
;    2816 				*qp++ = '/';
	CALL SUBOPT_0xB6
;    2817 				file_calc_temp = ((file_calc_temp >> 9) & 0x7F) + 1980;
;    2818 				*qp++ = (file_calc_temp / 1000) + '0';
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xB7
	POP  R26
	POP  R27
	CALL SUBOPT_0xB8
;    2819 				file_calc_temp %= 1000;
;    2820 				*qp++ = (file_calc_temp / 100) + '0';
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xB9
	POP  R26
	POP  R27
	CALL SUBOPT_0xBA
;    2821 				file_calc_temp %= 100;
;    2822 				*qp++ = (file_calc_temp / 10) + '0';
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xBB
	POP  R26
	POP  R27
	CALL SUBOPT_0xB3
;    2823 				*qp++ = (file_calc_temp % 10) + '0';
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xBC
	POP  R26
	POP  R27
	CALL SUBOPT_0xBD
;    2824 				*qp++ = ' ';
	CALL SUBOPT_0xBD
;    2825 				*qp++ = ' ';
	ST   X,R30
;    2826 				file_calc_temp = ((unsigned int) _FF_buff[calc_temp+15] << 8) | ((unsigned int) _FF_buff[calc_temp+14]);
	__GETW1R 19,20
	__ADDW1MN __FF_buff,15
	CALL SUBOPT_0x30
	__GETW1R 19,20
	__ADDW1MN __FF_buff,14
	LD   R30,Z
	CALL SUBOPT_0xF
	CALL SUBOPT_0xBE
;    2827 				*qp++ = (((file_calc_temp >> 11) & 0x1F) / 10) + '0';
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xBF
	CALL __DIVD21U
	__ADDD1N 48
	POP  R26
	POP  R27
	CALL SUBOPT_0xB3
;    2828 				*qp++ = (((file_calc_temp >> 11) & 0x1F) % 10) + '0';
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xBF
	CALL __MODD21U
	__ADDD1N 48
	POP  R26
	POP  R27
	CALL SUBOPT_0xC0
;    2829 				*qp++ = ':';
;    2830 				*qp++ = (((file_calc_temp >> 5) & 0x3F) / 10) + '0';
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xC1
	CALL __DIVD21U
	__ADDD1N 48
	POP  R26
	POP  R27
	CALL SUBOPT_0xB3
;    2831 				*qp++ = (((file_calc_temp >> 5) & 0x3F) % 10) + '0';
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xC1
	CALL __MODD21U
	__ADDD1N 48
	POP  R26
	POP  R27
	CALL SUBOPT_0xC0
;    2832 				*qp++ = ':';
;    2833 				*qp++ = (((file_calc_temp & 0x1F) * 2) / 10) + '0';
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xC2
	CALL __DIVD21U
	__ADDD1N 48
	POP  R26
	POP  R27
	CALL SUBOPT_0xB3
;    2834 				*qp++ = (((file_calc_temp & 0x1F) * 2) % 10) + '0';
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xC2
	CALL __MODD21U
	__ADDD1N 48
	POP  R26
	POP  R27
	CALL SUBOPT_0xC3
;    2835 				*qp = 0;
;    2836 				
;    2837 				file_calc_temp = ((unsigned int) _FF_buff[calc_temp+25] << 8) | ((unsigned int) _FF_buff[calc_temp+24]);
	__GETW1R 19,20
	__ADDW1MN __FF_buff,25
	CALL SUBOPT_0x30
	__GETW1R 19,20
	__ADDW1MN __FF_buff,24
	LD   R30,Z
	CALL SUBOPT_0xF
	__PUTD1S 9
;    2838 				qp = F_MODIFY;
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	CALL SUBOPT_0xB1
;    2839 				*qp++ = (((file_calc_temp >> 5) & 0x0F) / 10) + '0';
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xB2
	CALL __DIVD21U
	__ADDD1N 48
	POP  R26
	POP  R27
	CALL SUBOPT_0xB3
;    2840 				*qp++ = (((file_calc_temp >> 5) & 0x0F) % 10) + '0';
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xB2
	CALL __MODD21U
	__ADDD1N 48
	POP  R26
	POP  R27
	CALL SUBOPT_0xB4
;    2841 				*qp++ = '/';
	CALL SUBOPT_0xB3
;    2842 				*qp++ = ((file_calc_temp & 0x1F) / 10) + '0';
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xB5
	CALL __DIVD21U
	__ADDD1N 48
	POP  R26
	POP  R27
	CALL SUBOPT_0xB3
;    2843 				*qp++ = ((file_calc_temp & 0x1F) % 10) + '0';
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xB5
	CALL __MODD21U
	__ADDD1N 48
	POP  R26
	POP  R27
	CALL SUBOPT_0xB4
;    2844 				*qp++ = '/';
	CALL SUBOPT_0xB6
;    2845 				file_calc_temp = ((file_calc_temp >> 9) & 0x7F) + 1980;
;    2846 				*qp++ = (file_calc_temp / 1000) + '0';
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xB7
	POP  R26
	POP  R27
	CALL SUBOPT_0xB8
;    2847 				file_calc_temp %= 1000;
;    2848 				*qp++ = (file_calc_temp / 100) + '0';
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xB9
	POP  R26
	POP  R27
	CALL SUBOPT_0xBA
;    2849 				file_calc_temp %= 100;
;    2850 				*qp++ = (file_calc_temp / 10) + '0';
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xBB
	POP  R26
	POP  R27
	CALL SUBOPT_0xB3
;    2851 				*qp++ = (file_calc_temp % 10) + '0';
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xBC
	POP  R26
	POP  R27
	CALL SUBOPT_0xBD
;    2852 				*qp++ = ' ';
	CALL SUBOPT_0xBD
;    2853 				*qp++ = ' ';
	ST   X,R30
;    2854 				file_calc_temp = ((unsigned int) _FF_buff[calc_temp+23] << 8) | ((unsigned int) _FF_buff[calc_temp+22]);
	__GETW1R 19,20
	__ADDW1MN __FF_buff,23
	CALL SUBOPT_0x30
	__GETW1R 19,20
	__ADDW1MN __FF_buff,22
	LD   R30,Z
	CALL SUBOPT_0xF
	CALL SUBOPT_0xBE
;    2855 				*qp++ = (((file_calc_temp >> 11) & 0x1F) / 10) + '0';
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xBF
	CALL __DIVD21U
	__ADDD1N 48
	POP  R26
	POP  R27
	CALL SUBOPT_0xB3
;    2856 				*qp++ = (((file_calc_temp >> 11) & 0x1F) % 10) + '0';
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xBF
	CALL __MODD21U
	__ADDD1N 48
	POP  R26
	POP  R27
	CALL SUBOPT_0xC0
;    2857 				*qp++ = ':';
;    2858 				*qp++ = (((file_calc_temp >> 5) & 0x3F) / 10) + '0';
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xC1
	CALL __DIVD21U
	__ADDD1N 48
	POP  R26
	POP  R27
	CALL SUBOPT_0xB3
;    2859 				*qp++ = (((file_calc_temp >> 5) & 0x3F) % 10) + '0';
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xC1
	CALL __MODD21U
	__ADDD1N 48
	POP  R26
	POP  R27
	CALL SUBOPT_0xC0
;    2860 				*qp++ = ':';
;    2861 				*qp++ = (((file_calc_temp & 0x1F) * 2) / 10) + '0';
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xC2
	CALL __DIVD21U
	__ADDD1N 48
	POP  R26
	POP  R27
	CALL SUBOPT_0xB3
;    2862 				*qp++ = (((file_calc_temp & 0x1F) * 2) % 10) + '0';
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xC2
	CALL __MODD21U
	__ADDD1N 48
	POP  R26
	POP  R27
	CALL SUBOPT_0xC3
;    2863 				*qp = 0;
;    2864 				
;    2865 				return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x504
;    2866 			}
;    2867 		}                          		
_0x2CE:
	SUBI R16,-1
	RJMP _0x2CB
_0x2CC:
;    2868 	}
	__ADDWRN 17,18,1
	RJMP _0x2C7
_0x2C8:
;    2869 	_FF_error = FILE_ERR;
	CALL SUBOPT_0xC4
;    2870 	return(EOF);
_0x504:
	CALL __LOADLOCR5
	ADIW R28,29
	RET
;    2871 }
;    2872 
;    2873 // Get File data and increment file pointer
;    2874 int fgetc(FILE *rp)
;    2875 {
_fgetc:
;    2876 	unsigned char get_data;
;    2877 	unsigned int n;
;    2878 	unsigned long addr_temp;
;    2879 	
;    2880 	if (rp==NULL)
	SBIW R28,4
	CALL __SAVELOCR3
;	*rp -> Y+7
;	get_data -> R16
;	n -> R17,R18
;	addr_temp -> Y+3
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	SBIW R30,0
	BRNE _0x2CF
;    2881 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x503
;    2882 
;    2883 	if (rp->position == rp->length)
_0x2CF:
	CALL SUBOPT_0xC5
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	CALL __GETD1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD12
	BRNE _0x2D0
;    2884 	{
;    2885 		rp->error = POS_ERR;
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CALL SUBOPT_0xC6
;    2886 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x503
;    2887 	}
;    2888 	
;    2889 	get_data = *rp->pntr;
_0x2D0:
	CALL SUBOPT_0xC7
	LD   R16,Z
;    2890 	
;    2891 	if ((rp->pntr)==(&rp->buff[BPB_BytsPerSec-1]))
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	SUBI R26,LOW(-551)
	SBCI R27,HIGH(-551)
	LD   R0,X+
	LD   R1,X
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CALL SUBOPT_0xC8
	BREQ PC+3
	JMP _0x2D1
;    2892 	{	// Check to see if pointer is at the end of a sector
;    2893 		#ifndef _READ_ONLY_
;    2894 		if ((rp->mode==WRITE) || (rp->mode==APPEND))
	CALL SUBOPT_0xC9
	CPI  R26,LOW(0x2)
	BREQ _0x2D3
	CALL SUBOPT_0xC9
	CPI  R26,LOW(0x3)
	BRNE _0x2D2
_0x2D3:
;    2895 		{	// if in write or append mode, update the current sector before loading next
;    2896 			for (n=0; n<BPB_BytsPerSec; n++)
	__GETWRN 17,18,0
_0x2D6:
	__CPWRR 17,18,6,7
	BRSH _0x2D7
;    2897 				_FF_buff[n] = rp->buff[n];
	__GETW2R 17,18
	SUBI R26,LOW(-__FF_buff)
	SBCI R27,HIGH(-__FF_buff)
	CALL SUBOPT_0xCA
	LD   R30,Z
	ST   X,R30
;    2898 			addr_temp = clust_to_addr(rp->clus_current) + (((rp->sec_offset)-1)*BPB_BytsPerSec);
	__ADDWRN 17,18,1
	RJMP _0x2D6
_0x2D7:
	CALL SUBOPT_0xCB
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xCC
	CALL SUBOPT_0x13
	CALL __MULW12U
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0xCD
;    2899 			if (_FF_write(addr_temp)==0)
	__GETD1S 3
	CALL SUBOPT_0x62
	BRNE _0x2D8
;    2900 				return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x503
;    2901 		}
_0x2D8:
;    2902 		#endif
;    2903 		if (rp->sec_offset < BPB_SecPerClus)
_0x2D2:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	CALL SUBOPT_0xCE
	BRSH _0x2D9
;    2904 		{	// Goto next sector if not at the end of a cluster
;    2905 			addr_temp = clust_to_addr(rp->clus_current) + (rp->sec_offset*BPB_BytsPerSec);
	CALL SUBOPT_0xCB
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	CALL SUBOPT_0xCF
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0xCD
;    2906 			rp->sec_offset++;
	CALL SUBOPT_0xCC
	ADIW R30,1
	ST   X+,R30
	ST   X,R31
;    2907 		}
;    2908 		else
	RJMP _0x2DA
_0x2D9:
;    2909 		{	// End of Cluster, find next
;    2910 			if (rp->clus_next>=0xFFF8)	// No next cluster, EOF marker
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R26,Z+16
	LDD  R27,Z+17
	CPI  R26,LOW(0xFFF8)
	LDI  R30,HIGH(0xFFF8)
	CPC  R27,R30
	BRLO _0x2DB
;    2911 			{
;    2912 				rp->EOF_flag = 1;	// Set flag so Putchar knows to get new cluster
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CALL SUBOPT_0xD0
;    2913 				rp->position++;		// Only time doing this, position + 1 should equal length
	CALL SUBOPT_0xC5
	CALL SUBOPT_0xD1
;    2914 				return(get_data);
	RJMP _0x503
;    2915 			}
;    2916 			addr_temp = clust_to_addr(rp->clus_next);
_0x2DB:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R26,Z+16
	LDD  R27,Z+17
	ST   -Y,R27
	ST   -Y,R26
	CALL _clust_to_addr
	__PUTD1S 3
;    2917 			rp->sec_offset = 1;
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CALL SUBOPT_0xD2
;    2918 			rp->clus_prev = rp->clus_current;
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ADIW R26,14
	CALL __GETW1P
	__PUTW1SNS 7,18
;    2919 			rp->clus_current = rp->clus_next;
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ADIW R26,16
	CALL __GETW1P
	__PUTW1SNS 7,14
;    2920 			rp->clus_next = next_cluster(rp->clus_current, SINGLE);
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R26,Z+14
	LDD  R27,Z+15
	ST   -Y,R27
	ST   -Y,R26
	CALL SUBOPT_0x9B
	__PUTW1SNS 7,16
;    2921 		}
_0x2DA:
;    2922 		if (_FF_read(addr_temp)==0)
	__GETD1S 3
	CALL SUBOPT_0xC
	BRNE _0x2DC
;    2923 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x503
;    2924 		for (n=0; n<BPB_BytsPerSec; n++)
_0x2DC:
	__GETWRN 17,18,0
_0x2DE:
	__CPWRR 17,18,6,7
	BRSH _0x2DF
;    2925 			rp->buff[n] = _FF_buff[n];
	CALL SUBOPT_0xCA
	MOVW R0,R30
	LDI  R26,LOW(__FF_buff)
	LDI  R27,HIGH(__FF_buff)
	ADD  R26,R17
	ADC  R27,R18
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
;    2926 		rp->pntr = &rp->buff[0];
	__ADDWRN 17,18,1
	RJMP _0x2DE
_0x2DF:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,28
	__PUTW1SN 7,551
;    2927 	}
;    2928 	else
	RJMP _0x2E0
_0x2D1:
;    2929 		rp->pntr++;
	CALL SUBOPT_0xC7
	ADIW R30,1
	ST   X+,R30
	ST   X,R31
;    2930 	
;    2931 	rp->position++;	
_0x2E0:
	CALL SUBOPT_0xC5
	CALL SUBOPT_0xD1
;    2932 	return(get_data);		
_0x503:
	CALL __LOADLOCR3
	ADIW R28,9
	RET
;    2933 }
;    2934 
;    2935 char *fgets(char *buffer, int n, FILE *rp)
;    2936 {
;    2937 	int c, temp_data;
;    2938 	
;    2939 	for (c=0; c<n; c++)
;	*buffer -> Y+8
;	n -> Y+6
;	*rp -> Y+4
;	c -> R16,R17
;	temp_data -> R18,R19
;    2940 	{
;    2941 		temp_data = fgetc(rp);
;    2942 		*buffer = temp_data & 0xFF;
;    2943 		if (temp_data == '\n')
;    2944 			break;
;    2945 		else if (temp_data == EOF)
;    2946 			break;
;    2947 		buffer++;
;    2948 	}
;    2949 	if (c==n)
;    2950 		buffer++;
;    2951 	*buffer-- = '\0';
;    2952 	if (temp_data == EOF)
;    2953 		return (NULL);
;    2954 	return (buffer);
;    2955 }
;    2956 
;    2957 #ifndef _READ_ONLY_
;    2958 // Decrement file pointer, then get file data
;    2959 int ungetc(unsigned char file_data, FILE *rp)
;    2960 {
_ungetc:
;    2961 	unsigned int n;
;    2962 	unsigned long addr_temp;
;    2963 	
;    2964 	if ((rp==NULL) || (rp->position==0))
	CALL SUBOPT_0xA9
;	file_data -> Y+8
;	*rp -> Y+6
;	n -> R16,R17
;	addr_temp -> Y+2
	BREQ _0x2EA
	CALL SUBOPT_0xD3
	CALL __CPD10
	BRNE _0x2E9
_0x2EA:
;    2965 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x502
;    2966 	if ((rp->mode!=APPEND) && (rp->mode!=WRITE))
_0x2E9:
	CALL SUBOPT_0xAA
	CPI  R26,LOW(0x3)
	BREQ _0x2ED
	CALL SUBOPT_0xAA
	CPI  R26,LOW(0x2)
	BRNE _0x2EE
_0x2ED:
	RJMP _0x2EC
_0x2EE:
;    2967 		return (EOF);	// needs to be in WRITE or APPEND mode
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x502
;    2968 
;    2969 	if (((rp->position) == rp->length) && (rp->EOF_flag))
_0x2EC:
	CALL SUBOPT_0xD3
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xD4
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD12
	BRNE _0x2F0
	CALL SUBOPT_0xD5
	BRNE _0x2F1
_0x2F0:
	RJMP _0x2EF
_0x2F1:
;    2970 	{	// if the file posisition is equal to the length, return data, turn flag off
;    2971 		rp->EOF_flag = 0;
	CALL SUBOPT_0xD6
;    2972 		*rp->pntr = file_data;
	CALL SUBOPT_0xD7
	CALL SUBOPT_0xD8
;    2973 		return (*rp->pntr);
	LD   R30,Z
	LDI  R31,0
	RJMP _0x502
;    2974 	}
;    2975 	if ((rp->pntr)==(&rp->buff[0]))
_0x2EF:
	CALL SUBOPT_0xD7
	MOVW R26,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,28
	CP   R30,R26
	CPC  R31,R27
	BREQ PC+3
	JMP _0x2F2
;    2976 	{	// Check to see if pointer is at the beginning of a Sector
;    2977 		// Update the current sector before loading next
;    2978 		for (n=0; n<BPB_BytsPerSec; n++)
	__GETWRN 16,17,0
_0x2F4:
	__CPWRR 16,17,6,7
	BRSH _0x2F5
;    2979 			_FF_buff[n] = rp->buff[n];
	CALL SUBOPT_0xAD
	LD   R30,Z
	ST   X,R30
;    2980 		addr_temp = clust_to_addr(rp->clus_current) + (((rp->sec_offset)-1)*BPB_BytsPerSec);
	__ADDWRN 16,17,1
	RJMP _0x2F4
_0x2F5:
	CALL SUBOPT_0x9A
	CALL _clust_to_addr
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xAB
	CALL __MULW12U
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0xAC
;    2981 		if (_FF_write(addr_temp)==0)
	__GETD1S 2
	CALL SUBOPT_0x62
	BRNE _0x2F6
;    2982 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x502
;    2983 			
;    2984 		if (rp->sec_offset > 1)
_0x2F6:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+20
	LDD  R27,Z+21
	SBIW R26,2
	BRLO _0x2F7
;    2985 		{	// Goto previous sector if not at the beginning of a cluster
;    2986 			addr_temp = clust_to_addr(rp->clus_current) + ((rp->sec_offset-2)*BPB_BytsPerSec);
	CALL SUBOPT_0x9A
	CALL _clust_to_addr
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xD9
	SBIW R30,2
	MOVW R26,R30
	MOVW R30,R6
	CALL __MULW12U
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0xAC
;    2987 			rp->sec_offset--;
	CALL SUBOPT_0xD9
	SBIW R30,1
	ST   X+,R30
	ST   X,R31
;    2988 		}
;    2989 		else
	RJMP _0x2F8
_0x2F7:
;    2990 		{	// Beginning of Cluster, find previous
;    2991 			if (rp->clus_start==rp->clus_current)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+12
	LDD  R27,Z+13
	PUSH R27
	PUSH R26
	CALL SUBOPT_0xDA
	POP  R26
	POP  R27
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x2F9
;    2992 			{	// Positioned @ Beginning of File
;    2993 				_FF_error = SOF_ERR;
	LDI  R30,LOW(7)
	STS  __FF_error,R30
;    2994 				return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x502
;    2995 			}
;    2996 			rp->sec_offset = BPB_SecPerClus;	// Set sector offset to last sector
_0x2F9:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,20
	MOV  R30,R8
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
;    2997 			rp->clus_next = rp->clus_current;
	CALL SUBOPT_0xDA
	__PUTW1SNS 6,16
;    2998 			rp->clus_current = rp->clus_prev;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,18
	CALL __GETW1P
	__PUTW1SNS 6,14
;    2999 			if (rp->clus_current != rp->clus_start)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+14
	LDD  R27,Z+15
	PUSH R27
	PUSH R26
	CALL SUBOPT_0x92
	POP  R26
	POP  R27
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x2FA
;    3000 				rp->clus_prev = prev_cluster(rp->clus_current);
	CALL SUBOPT_0x9A
	CALL _prev_cluster
	__PUTW1SNS 6,18
;    3001 			else
	RJMP _0x2FB
_0x2FA:
;    3002 				rp->clus_prev = 0;
	CALL SUBOPT_0x93
;    3003 			addr_temp = clust_to_addr(rp->clus_current) + (((long) BPB_SecPerClus-1) * (long) BPB_BytsPerSec);
_0x2FB:
	CALL SUBOPT_0x9A
	CALL _clust_to_addr
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOV  R30,R8
	CLR  R31
	CLR  R22
	CLR  R23
	__SUBD1N 1
	MOVW R26,R30
	MOVW R24,R22
	MOVW R30,R6
	CLR  R22
	CLR  R23
	CALL __MULD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	__PUTD1S 2
;    3004 		}
_0x2F8:
;    3005 		_FF_read(addr_temp);
	__GETD1S 2
	CALL __PUTPARD1
	CALL __FF_read
;    3006 		for (n=0; n<BPB_BytsPerSec; n++)
	__GETWRN 16,17,0
_0x2FD:
	__CPWRR 16,17,6,7
	BRSH _0x2FE
;    3007 			rp->buff[n] = _FF_buff[n];
	CALL SUBOPT_0x9D
	CALL SUBOPT_0x9E
;    3008 		rp->pntr = &rp->buff[511];
	__ADDWRN 16,17,1
	RJMP _0x2FD
_0x2FE:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,28
	SUBI R30,LOW(-511)
	SBCI R31,HIGH(-511)
	__PUTW1SN 6,551
;    3009 	}
;    3010 	else
	RJMP _0x2FF
_0x2F2:
;    3011 		rp->pntr--;
	CALL SUBOPT_0xD7
	SBIW R30,1
	ST   X+,R30
	ST   X,R31
;    3012 	
;    3013 	rp->position--;
_0x2FF:
	CALL SUBOPT_0xD3
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	CALL __PUTDP1
;    3014 	*rp->pntr = file_data;	
	CALL SUBOPT_0xD7
	CALL SUBOPT_0xD8
;    3015 	return(*rp->pntr);	// Get data	
	LD   R30,Z
	LDI  R31,0
	RJMP _0x502
;    3016 }
;    3017 #endif
;    3018 
;    3019 #ifndef _READ_ONLY_
;    3020 int fputc(unsigned char file_data, FILE *rp)	
;    3021 {
_fputc:
;    3022 	unsigned int n;
;    3023 	unsigned long addr_temp;
;    3024 	
;    3025 	if (rp==NULL)
	CALL SUBOPT_0xDB
;	file_data -> Y+8
;	*rp -> Y+6
;	n -> R16,R17
;	addr_temp -> Y+2
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,0
	BRNE _0x300
;    3026 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x502
;    3027 
;    3028 	if (rp->mode == READ)
_0x300:
	CALL SUBOPT_0xAA
	CPI  R26,LOW(0x1)
	BRNE _0x301
;    3029 	{
;    3030 		_FF_error = READONLY_ERR;
	LDI  R30,LOW(6)
	STS  __FF_error,R30
;    3031 		return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x502
;    3032 	}
;    3033 	if (rp->length == 0)
_0x301:
	CALL SUBOPT_0x97
	BRNE _0x302
;    3034 	{	// Blank file start writing cluster table
;    3035 		rp->clus_start = prev_cluster(0);
	CALL SUBOPT_0x6D
	__PUTW1SNS 6,12
;    3036 		rp->clus_next = 0xFFFF;
	CALL SUBOPT_0xDC
;    3037 		rp->clus_current = rp->clus_start;
	CALL SUBOPT_0x92
	__PUTW1SNS 6,14
;    3038 		if (write_clus_table(rp->clus_start, rp->clus_next, SINGLE)==0)
	CALL SUBOPT_0x99
	CALL SUBOPT_0xDD
	CALL SUBOPT_0xDE
	BRNE _0x303
;    3039 		{
;    3040 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x502
;    3041 		}
;    3042 	}
_0x303:
;    3043 	
;    3044 	if ((rp->position==rp->length) && (rp->EOF_flag))
_0x302:
	CALL SUBOPT_0xD3
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xD4
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD12
	BRNE _0x305
	CALL SUBOPT_0xD5
	BRNE _0x306
_0x305:
	RJMP _0x304
_0x306:
;    3045 	{	// At end of file, and end of cluster, flagged
;    3046 		rp->clus_prev = rp->clus_current;
	CALL SUBOPT_0xDA
	__PUTW1SNS 6,18
;    3047 		rp->clus_current = prev_cluster(0);	// Find first cluster pointing to '0'
	CALL SUBOPT_0x6D
	__PUTW1SNS 6,14
;    3048 		rp->clus_next = 0xFFFF;
	CALL SUBOPT_0xDC
;    3049 		rp->sec_offset = 1;
	CALL SUBOPT_0x9C
;    3050 		if (write_clus_table(rp->clus_prev, rp->clus_current, CHAIN)==0)
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
	CALL SUBOPT_0x5F
	BRNE _0x307
;    3051 		{
;    3052 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x502
;    3053 		}
;    3054 		if (write_clus_table(rp->clus_current, rp->clus_next, END_CHAIN)==0)
_0x307:
	CALL SUBOPT_0x9A
	CALL SUBOPT_0xDD
	CALL SUBOPT_0x60
	BRNE _0x308
;    3055 		{
;    3056 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x502
;    3057 		}
;    3058 		if (append_toc(rp)==0)
_0x308:
	CALL SUBOPT_0xAE
	BRNE _0x309
;    3059 		{
;    3060 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x502
;    3061 		}
;    3062 		rp->EOF_flag = 0;
_0x309:
	CALL SUBOPT_0xD6
;    3063 		rp->pntr = &rp->buff[0];		
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,28
	__PUTW1SN 6,551
;    3064 	}
;    3065 	
;    3066 	*rp->pntr = file_data;
_0x304:
	CALL SUBOPT_0xD7
	LDD  R26,Y+8
	STD  Z+0,R26
;    3067 	
;    3068 	if (rp->pntr == &rp->buff[BPB_BytsPerSec-1])
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-551)
	SBCI R27,HIGH(-551)
	LD   R0,X+
	LD   R1,X
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0xC8
	BREQ PC+3
	JMP _0x30A
;    3069 	{	// This is on the Sector Limit
;    3070 		if (rp->position > rp->length)
	CALL SUBOPT_0xD3
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xD4
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD12
	BRSH _0x30B
;    3071 		{	// ERROR, position should never be greater than length
;    3072 			_FF_error = 0x10;		// file position ERROR
	LDI  R30,LOW(16)
	STS  __FF_error,R30
;    3073 			return (EOF); 
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x502
;    3074 		}
;    3075 		// Position is at end of a sector?
;    3076 		
;    3077 		addr_temp = (clust_to_addr(rp->clus_current) + ((rp->sec_offset-1)*BPB_BytsPerSec));
_0x30B:
	CALL SUBOPT_0x9A
	CALL _clust_to_addr
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xAB
	CALL __MULW12U
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0xAC
;    3078 		for (n=0; n<BPB_BytsPerSec; n++)
	__GETWRN 16,17,0
_0x30D:
	__CPWRR 16,17,6,7
	BRSH _0x30E
;    3079 			_FF_buff[n] = rp->buff[n];
	CALL SUBOPT_0xAD
	LD   R30,Z
	ST   X,R30
;    3080 		_FF_write(addr_temp);
	__ADDWRN 16,17,1
	RJMP _0x30D
_0x30E:
	__GETD1S 2
	CALL __PUTPARD1
	CALL __FF_write
;    3081 			// Save MMC buffer to card, set pointer to begining of new buffer
;    3082 		if (rp->sec_offset < BPB_SecPerClus)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL SUBOPT_0xCE
	BRSH _0x30F
;    3083 		{	// Are there more sectors in this cluster?
;    3084 			addr_temp = clust_to_addr(rp->clus_current) + (rp->sec_offset * BPB_BytsPerSec);
	CALL SUBOPT_0x9A
	CALL _clust_to_addr
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL SUBOPT_0xCF
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0xAC
;    3085 			rp->sec_offset++;
	CALL SUBOPT_0xD9
	ADIW R30,1
	ST   X+,R30
	ST   X,R31
;    3086 		}
;    3087 		else
	RJMP _0x310
_0x30F:
;    3088 		{	// Find next cluster, load first sector into file.buff
;    3089 			if (((rp->clus_next>=0xFFF8)&&(BPB_FATType==0x36)) ||
;    3090 				((rp->clus_next>=0xFF8)&&(BPB_FATType==0x32)))
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+16
	LDD  R27,Z+17
	CPI  R26,LOW(0xFFF8)
	LDI  R30,HIGH(0xFFF8)
	CPC  R27,R30
	BRLO _0x312
	LDI  R30,LOW(54)
	CP   R30,R14
	BREQ _0x314
_0x312:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+16
	LDD  R27,Z+17
	CPI  R26,LOW(0xFF8)
	LDI  R30,HIGH(0xFF8)
	CPC  R27,R30
	BRLO _0x315
	LDI  R30,LOW(50)
	CP   R30,R14
	BREQ _0x314
_0x315:
	RJMP _0x311
_0x314:
;    3091 			{	// EOF, need to find new empty cluster
;    3092 				if (rp->position != rp->length)
	CALL SUBOPT_0xD3
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xD4
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD12
	BREQ _0x318
;    3093 				{	// if not equal there's an error
;    3094 					_FF_error = 0x20;		// EOF position error
	LDI  R30,LOW(32)
	STS  __FF_error,R30
;    3095 					return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x502
;    3096 				}
;    3097 				rp->EOF_flag = 1;
_0x318:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0xD0
;    3098 			}
;    3099 			else
	RJMP _0x319
_0x311:
;    3100 			{	// Not EOF, find next cluster
;    3101 				rp->clus_prev = rp->clus_current;
	CALL SUBOPT_0xDA
	__PUTW1SNS 6,18
;    3102 				rp->clus_current = rp->clus_next;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,16
	CALL __GETW1P
	__PUTW1SNS 6,14
;    3103 				rp->clus_next = next_cluster(rp->clus_current, SINGLE);
	CALL SUBOPT_0x9A
	CALL SUBOPT_0x9B
	__PUTW1SNS 6,16
;    3104 			}
_0x319:
;    3105 			rp->sec_offset = 1;
	CALL SUBOPT_0x9C
;    3106 			addr_temp = clust_to_addr(rp->clus_current);
	CALL SUBOPT_0x9A
	CALL _clust_to_addr
	__PUTD1S 2
;    3107 		}
_0x310:
;    3108 		
;    3109 		if (rp->EOF_flag == 0)
	CALL SUBOPT_0xD5
	BRNE _0x31A
;    3110 		{
;    3111 			if (_FF_read(addr_temp)==0)
	__GETD1S 2
	CALL SUBOPT_0xC
	BRNE _0x31B
;    3112 				return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x502
;    3113 			for (n=0; n<512; n++)
_0x31B:
	__GETWRN 16,17,0
_0x31D:
	__CPWRN 16,17,512
	BRSH _0x31E
;    3114 				rp->buff[n] = _FF_buff[n];
	CALL SUBOPT_0x9D
	CALL SUBOPT_0x9E
;    3115 			rp->pntr = &rp->buff[0];	// Set pointer to next location				
	__ADDWRN 16,17,1
	RJMP _0x31D
_0x31E:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,28
	__PUTW1SN 6,551
;    3116 		}
;    3117 		if (rp->length==rp->position)
_0x31A:
	CALL SUBOPT_0xD4
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xD3
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD12
	BRNE _0x31F
;    3118 			rp->length++;
	CALL SUBOPT_0xD4
	__SUBD1N -1
	CALL __PUTDP1
;    3119 		if (append_toc(rp)==0)
_0x31F:
	CALL SUBOPT_0xAE
	BRNE _0x320
;    3120 			return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x502
;    3121 	}
_0x320:
;    3122 	else
	RJMP _0x321
_0x30A:
;    3123 	{
;    3124 		rp->pntr++;
	CALL SUBOPT_0xD7
	ADIW R30,1
	ST   X+,R30
	ST   X,R31
;    3125 		if (rp->length==rp->position)
	CALL SUBOPT_0xD4
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xD3
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD12
	BRNE _0x322
;    3126 			rp->length++;
	CALL SUBOPT_0xD4
	__SUBD1N -1
	CALL __PUTDP1
;    3127 	}
_0x322:
_0x321:
;    3128 	rp->position++;
	CALL SUBOPT_0xD3
	__SUBD1N -1
	CALL __PUTDP1
;    3129 	return(file_data);
	LDD  R30,Y+8
	LDI  R31,0
_0x502:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,9
	RET
;    3130 }
;    3131 
;    3132 int fputs(unsigned char *file_data, FILE *rp)
;    3133 {
;    3134 	while(*file_data)
;    3135 		if (fputc(*file_data++,rp) == EOF)
;    3136 			return (EOF);
;    3137 	if (fputc('\r',rp) == EOF)
;    3138 		return (EOF);
;    3139 	if (fputc('\n',rp) == EOF)
;    3140 		return (EOF);
;    3141 	return (0);
;    3142 }
;    3143 
;    3144 int fputsc(flash unsigned char *file_data, FILE *rp)
;    3145 {
;    3146 	while(*file_data)
;    3147 		if (fputc(*file_data++,rp) == EOF)
;    3148 			return (EOF);
;    3149 	if (fputc('\r',rp) == EOF)
;    3150 		return (EOF);
;    3151 	if (fputc('\n',rp) == EOF)
;    3152 		return (EOF);
;    3153 	return (0);
;    3154 }
;    3155 #endif
;    3156 
;    3157 #ifndef _READ_ONLY_
;    3158 #ifdef _CVAVR_
;    3159 void fprintf(FILE *rp, unsigned char flash *pstr, ...)
;    3160 {
;    3161 	va_list arglist;
;    3162 	unsigned char temp_buff[_FF_MAX_FPRINT], *fp;
;    3163 	
;    3164 	va_start(arglist, pstr);
;	*rp -> Y+106
;	*pstr -> Y+104
;	*arglist -> R16,R17
;	temp_buff -> Y+4
;	*fp -> R18,R19
;    3165 	vsprintf(temp_buff, pstr, arglist);
;    3166 	va_end(arglist);
;    3167 	
;    3168 	fp = temp_buff;
;    3169 	while (*fp)
;    3170 		fputc(*fp++, rp);	
;    3171 }
;    3172 #endif
;    3173 #ifdef _ICCAVR_
;    3174 void fprintf(FILE *rp, unsigned char flash *pstr, long var)
;    3175 {
;    3176 	unsigned char temp_buff[_FF_MAX_FPRINT], *fp;
;    3177 	
;    3178 	csprintf(temp_buff, pstr, var);
;    3179 	
;    3180 	fp = temp_buff;
;    3181 	while (*fp)
;    3182 		fputc(*fp++, rp);	
;    3183 }
;    3184 #endif
;    3185 #endif
;    3186 
;    3187 // Set file pointer to the end of the file
;    3188 int fend(FILE *rp)
;    3189 {
;    3190 	return (fseek(rp, 0, SEEK_END));	
;    3191 }
;    3192 
;    3193 // Goto position "off_set" of a file
;    3194 int fseek(FILE *rp, unsigned long off_set, unsigned char mode)
;    3195 {
_fseek:
;    3196 	unsigned int n, clus_temp;
;    3197 	unsigned long length_check, addr_calc;
;    3198 	
;    3199 	if (rp==NULL)
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
	BRNE _0x332
;    3200 	{	// ERROR if FILE pointer is NULL
;    3201 		_FF_error = FILE_ERR;
	CALL SUBOPT_0xC4
;    3202 		return (EOF);
	RJMP _0x501
;    3203 	}
;    3204 	if (mode==SEEK_CUR)
_0x332:
	LDD  R30,Y+12
	CPI  R30,0
	BRNE _0x333
;    3205 	{	// Trying to position pointer to offset from current position
;    3206 		off_set += rp->position;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SUBI R26,LOW(-544)
	SBCI R27,HIGH(-544)
	CALL __GETD1P
	__GETD2S 13
	CALL __ADDD12
	__PUTD1S 13
;    3207 	}
;    3208 	if (off_set > rp->length)
_0x333:
	CALL SUBOPT_0xDF
	CALL __CPD12
	BRSH _0x334
;    3209 	{	// trying to position beyond or before file
;    3210 		rp->error = POS_ERR;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	CALL SUBOPT_0xC6
;    3211 		_FF_error = POS_ERR;
	CALL SUBOPT_0xE0
;    3212 		return (EOF);
	RJMP _0x501
;    3213 	}
;    3214 	if (mode==SEEK_END)
_0x334:
	LDD  R26,Y+12
	CPI  R26,LOW(0x1)
	BRNE _0x335
;    3215 	{	// Trying to position pointer to offset from EOF
;    3216 		off_set = rp->length - off_set;
	CALL SUBOPT_0xDF
	CALL __SUBD12
	__PUTD1S 13
;    3217 	}
;    3218 	#ifndef _READ_ONLY_
;    3219 	if (rp->mode != READ)
_0x335:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	CALL SUBOPT_0xAF
	BREQ _0x336
;    3220 		if (fflush(rp))
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _fflush
	SBIW R30,0
	BREQ _0x337
;    3221 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x501
;    3222 	#endif
;    3223 	clus_temp = rp->clus_start;
_0x337:
_0x336:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,12
	LD   R18,X+
	LD   R19,X
;    3224 	rp->clus_current = clus_temp;
	MOVW R30,R18
	__PUTW1SNS 17,14
;    3225 	rp->clus_next = next_cluster(clus_temp, SINGLE);
	ST   -Y,R19
	ST   -Y,R18
	CALL SUBOPT_0x9B
	__PUTW1SNS 17,16
;    3226 	rp->clus_prev = 0;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,18
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
;    3227 	
;    3228 	addr_calc = off_set / ((long) BPB_BytsPerSec * (long) BPB_SecPerClus);
	CALL SUBOPT_0x21
	__GETD2S 13
	CALL __DIVD21U
	__PUTD1S 4
;    3229 	length_check = off_set % ((long) BPB_BytsPerSec * (long) BPB_SecPerClus);
	CALL SUBOPT_0x21
	__GETD2S 13
	CALL __MODD21U
	__PUTD1S 8
;    3230 	rp->EOF_flag = 0;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SUBI R26,LOW(-550)
	SBCI R27,HIGH(-550)
	LDI  R30,LOW(0)
	ST   X,R30
;    3231 
;    3232 	while (addr_calc)
_0x338:
	__GETD1S 4
	CALL __CPD10
	BRNE PC+3
	JMP _0x33A
;    3233 	{
;    3234 		if (rp->clus_next >= 0xFFF8)
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	LDD  R26,Z+16
	LDD  R27,Z+17
	CPI  R26,LOW(0xFFF8)
	LDI  R30,HIGH(0xFFF8)
	CPC  R27,R30
	BRLO _0x33B
;    3235 		{	// trying to position beyond or before file
;    3236 			if ((addr_calc==1) && (length_check==0))
	__GETD2S 4
	__CPD2N 0x1
	BRNE _0x33D
	__GETD2S 8
	CALL __CPD02
	BREQ _0x33E
_0x33D:
	RJMP _0x33C
_0x33E:
;    3237 			{
;    3238 				rp->EOF_flag = 1;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	CALL SUBOPT_0xD0
;    3239 				break;
	RJMP _0x33A
;    3240 			}				
;    3241 			rp->error = POS_ERR;
_0x33C:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	CALL SUBOPT_0xC6
;    3242 			_FF_error = POS_ERR;
	CALL SUBOPT_0xE0
;    3243 			return (EOF);
	RJMP _0x501
;    3244 		}
;    3245 		clus_temp = rp->clus_next;
_0x33B:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,16
	LD   R18,X+
	LD   R19,X
;    3246 		rp->clus_prev = rp->clus_current;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,14
	CALL __GETW1P
	__PUTW1SNS 17,18
;    3247 		rp->clus_current = clus_temp;
	MOVW R30,R18
	__PUTW1SNS 17,14
;    3248 		rp->clus_next = next_cluster(clus_temp, CHAIN);
	CALL SUBOPT_0x5D
	__PUTW1SNS 17,16
;    3249 		addr_calc--;
	__GETD1S 4
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	__PUTD1S 4
;    3250 	}
	RJMP _0x338
_0x33A:
;    3251 	
;    3252 	addr_calc = clust_to_addr(rp->clus_current);
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	LDD  R26,Z+14
	LDD  R27,Z+15
	ST   -Y,R27
	ST   -Y,R26
	CALL _clust_to_addr
	__PUTD1S 4
;    3253 	rp->sec_offset = 1;			// Reset Reading Sector
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	CALL SUBOPT_0xD2
;    3254 	while (length_check >= BPB_BytsPerSec)
_0x33F:
	CALL SUBOPT_0xE1
	CALL __CPD21
	BRLO _0x341
;    3255 	{
;    3256 		addr_calc += BPB_BytsPerSec;
	CALL SUBOPT_0xA3
	CALL __ADDD12
	__PUTD1S 4
;    3257 		length_check -= BPB_BytsPerSec;
	CALL SUBOPT_0xE1
	CALL __SUBD21
	__PUTD2S 8
;    3258 		rp->sec_offset++;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,20
	CALL SUBOPT_0xE2
;    3259 	}
	RJMP _0x33F
_0x341:
;    3260 	
;    3261 	if (_FF_read(addr_calc)==0)		// Read Current Data Sector
	__GETD1S 4
	CALL SUBOPT_0xC
	BRNE _0x342
;    3262 		return(EOF);		// Read Error  
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x501
;    3263 		
;    3264 	for (n=0; n<BPB_BytsPerSec; n++)
_0x342:
	__GETWRN 16,17,0
_0x344:
	__CPWRR 16,17,6,7
	BRSH _0x345
;    3265 		rp->buff[n] = _FF_buff[n];
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ADIW R30,28
	ADD  R30,R16
	ADC  R31,R17
	CALL SUBOPT_0x9E
;    3266     
;    3267     if ((rp->EOF_flag == 1) && (length_check == 0))
	__ADDWRN 16,17,1
	RJMP _0x344
_0x345:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SUBI R26,LOW(-550)
	SBCI R27,HIGH(-550)
	LD   R26,X
	CPI  R26,LOW(0x1)
	BRNE _0x347
	__GETD2S 8
	CALL __CPD02
	BREQ _0x348
_0x347:
	RJMP _0x346
_0x348:
;    3268     	rp->pntr = &rp->buff[BPB_BytsPerSec-1];
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,28
	MOVW R30,R6
	SBIW R30,1
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1SN 17,551
;    3269 	rp->pntr = &rp->buff[length_check];
_0x346:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,28
	__GETD1S 8
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1SN 17,551
;    3270 	rp->position = off_set;
	__GETD1S 13
	__PUTD1SN 17,544
;    3271 		
;    3272 	return (0);	
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x501:
	CALL __LOADLOCR4
	ADIW R28,19
	RET
;    3273 }
;    3274 
;    3275 // Return the current position of the file rp with respect to the begining of the file
;    3276 long ftell(FILE *rp)
;    3277 {
_ftell:
;    3278 	if (rp==NULL)
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE _0x349
;    3279 		return (EOF);
	__GETD1N 0xFFFFFFFF
	RJMP _0x500
;    3280 	else
_0x349:
;    3281 		return (rp->position);
	CALL SUBOPT_0xE3
	RJMP _0x500
;    3282 }
;    3283 
;    3284 // Funtion that returns a '1' for @EOF, '0' otherwise
;    3285 int feof(FILE *rp)
;    3286 {
_feof:
;    3287 	if (rp==NULL)
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE _0x34B
;    3288 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x500
;    3289 	
;    3290 	if (rp->length==rp->position)
_0x34B:
	LD   R26,Y
	LDD  R27,Y+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xE3
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD12
	BRNE _0x34C
;    3291 		return (1);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x500
;    3292 	else
_0x34C:
;    3293 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
;    3294 }
_0x500:
	ADIW R28,2
	RET
;    3295 		
;    3296 void dump_file_data_hex(FILE *rp)
;    3297 {
_dump_file_data_hex:
;    3298 	unsigned int n, c;
;    3299 	
;    3300 	if (rp==NULL)
	CALL SUBOPT_0x5C
;	*rp -> Y+4
;	n -> R16,R17
;	c -> R18,R19
	BRNE _0x34E
;    3301 		return;
	RJMP _0x4FF
;    3302 
;    3303 	for (n=0; n<0x20; n++)
_0x34E:
	__GETWRN 16,17,0
_0x350:
	__CPWRN 16,17,32
	BRSH _0x351
;    3304 	{   
;    3305 		printf("\n\r");
	__POINTW1FN _0,474
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;    3306 		for (c=0; c<0x10; c++)
	__GETWRN 18,19,0
_0x353:
	__CPWRN 18,19,16
	BRSH _0x354
;    3307 			printf("%02X ", rp->buff[(n*0x20)+c]);
	__POINTW1FN _0,619
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,28
	MOVW R30,R16
	LSL  R30
	ROL  R31
	CALL __LSLW4
	ADD  R30,R18
	ADC  R31,R19
	ADD  R26,R30
	ADC  R27,R31
	CALL SUBOPT_0xE4
	LDI  R24,4
	CALL _printf
	ADIW R28,6
;    3308 	}
	__ADDWRN 18,19,1
	RJMP _0x353
_0x354:
	__ADDWRN 16,17,1
	RJMP _0x350
_0x351:
;    3309 }
_0x4FF:
	CALL __LOADLOCR4
	ADIW R28,6
	RET
;    3310 
;    3311 void dump_file_data_view(FILE *rp)
;    3312 {
_dump_file_data_view:
;    3313 	unsigned int n;
;    3314 	
;    3315 	if (rp==NULL)
	ST   -Y,R17
	ST   -Y,R16
;	*rp -> Y+2
;	n -> R16,R17
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,0
	BRNE _0x355
;    3316 		return;
	RJMP _0x4FE
;    3317 
;    3318 	printf("\n\r");
_0x355:
	__POINTW1FN _0,474
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;    3319 	for (n=0; n<512; n++)
	__GETWRN 16,17,0
_0x357:
	__CPWRN 16,17,512
	BRSH _0x358
;    3320 		putchar(rp->buff[n]);
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R30,28
	ADD  R30,R16
	ADC  R31,R17
	LD   R30,Z
	ST   -Y,R30
	CALL _putchar
;    3321 }
	__ADDWRN 16,17,1
	RJMP _0x357
_0x358:
_0x4FE:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
;    3322 
;    3323 
;    3324 #ifndef _UART_INT_
;    3325 	#define		rx_counter0		(UCSR0A & 0x80)
;    3326 	#define		tx_counter0		((!UCSR0A) & 0x40)
;    3327 	#define		rx_counter1		(UCSR1A & 0x80)
;    3328 	#define		tx_counter1		((!UCSR1A) & 0x40)
;    3329 #endif
;    3330 
;    3331 void port_init(void)
;    3332 {
_port_init:
;    3333  PORTA = 0b00000010;	DDRA  = 0x03;   //LCD Красный при включении
	LDI  R30,LOW(2)
	OUT  0x1B,R30
	LDI  R30,LOW(3)
	OUT  0x1A,R30
;    3334  PORTB = 0xFF;		DDRB  = 0x00;
	LDI  R30,LOW(255)
	OUT  0x18,R30
	LDI  R30,LOW(0)
	OUT  0x17,R30
;    3335  PORTC = 0xFF; 		DDRC  = 0x00;	  //m103 output only
	LDI  R30,LOW(255)
	OUT  0x15,R30
	LDI  R30,LOW(0)
	OUT  0x14,R30
;    3336  PORTD = 0xFF;		DDRD  = 0x00;
	LDI  R30,LOW(255)
	OUT  0x12,R30
	LDI  R30,LOW(0)
	OUT  0x11,R30
;    3337  PORTE = 0xFF;		DDRE  = 0x00;
	LDI  R30,LOW(255)
	OUT  0x3,R30
	LDI  R30,LOW(0)
	OUT  0x2,R30
;    3338  PORTF = 0xFF;		DDRF  = 0x00;
	LDI  R30,LOW(255)
	STS  98,R30
	LDI  R30,LOW(0)
	STS  97,R30
;    3339  PORTG = 0x1F;		DDRG  = 0x00;
	LDI  R30,LOW(31)
	STS  101,R30
	LDI  R30,LOW(0)
	STS  100,R30
;    3340 }
	RET
;    3341 
;    3342 
;    3343 /*//UART0 initialisation
;    3344 // desired baud rate: 115200
;    3345 // actual: baud rate:115200 (0.0%)
;    3346 // char size: 8 bit
;    3347 // parity: Disabled
;    3348 void uart0_init(void)
;    3349 {
;    3350  UCSR0B = 0x00; //disable while setting baud rate
;    3351  UCSR0A = 0x00;
;    3352  UCSR0C = 0x06;
;    3353 // UBRR0L = 0x07; //set baud rate lo
;    3354 // UBRR0H = 0x00; //set baud rate hi
;    3355  UBRR0H=0x00;
;    3356  UBRR0L=0x08;
;    3357  UCSR0B = 0x18;
;    3358 } */
;    3359 
;    3360 // USART0 initialization
;    3361 // Communication Parameters: 8 Data, 1 Stop, No Parity
;    3362 // USART0 Receiver: On
;    3363 // USART0 Transmitter: On
;    3364 // USART0 Mode: Asynchronous
;    3365 // USART0 Baud rate: 56000
;    3366 void uart0_init(void)
;    3367 {
_uart0_init:
;    3368 UCSR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
;    3369 UCSR0B=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
;    3370 UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  149,R30
;    3371 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
;    3372 UBRR0L=0x08;
	LDI  R30,LOW(8)
	OUT  0x9,R30
;    3373 }
	RET
;    3374 
;    3375 
;    3376 
;    3377 /*
;    3378 // USART0 initialization
;    3379 // Communication Parameters: 8 Data, 1 Stop, No Parity
;    3380 // USART0 Receiver: On
;    3381 // USART0 Transmitter: On
;    3382 // USART0 Mode: Asynchronous
;    3383 // USART0 Baud rate: 56000
;    3384 void uart0_init(void)
;    3385 {
;    3386 UCSR0A=0x00;
;    3387 UCSR0B=0x18;
;    3388 UCSR0C=0x06;
;    3389 UBRR0H=0x00;
;    3390 UBRR0L=0x08;
;    3391 } 
;    3392 */
;    3393 //UART1 initialisation
;    3394 // desired baud rate:115200
;    3395 // actual baud rate:115200 (0.0%)
;    3396 // char size: 8 bit
;    3397 // parity: Disabled
;    3398 void uart1_init(void)
;    3399 {
_uart1_init:
;    3400  UCSR1B = 0x00; //disable while setting baud rate
	LDI  R30,LOW(0)
	STS  154,R30
;    3401  UCSR1A = 0x00;
	STS  155,R30
;    3402  UCSR1C = 0x06;
	LDI  R30,LOW(6)
	STS  157,R30
;    3403  UBRR1L = 0x07; //set baud rate lo
	LDI  R30,LOW(7)
	STS  153,R30
;    3404  UBRR1H = 0x00; //set baud rate hi
	LDI  R30,LOW(0)
	STS  152,R30
;    3405  UCSR1B = 0x18;
	LDI  R30,LOW(24)
	STS  154,R30
;    3406 }
	RET
;    3407 
;    3408 
;    3409 //call this routine to initialise all peripherals
;    3410 void init_devices(void)
;    3411 {
_init_devices:
;    3412  //stop errant interrupts until set up
;    3413  CLI(); //disable all interrupts
	cli
;    3414  XDIV  = 0x00; //xtal divider
	LDI  R30,LOW(0)
	OUT  0x3C,R30
;    3415  XMCRA = 0x00; //external memory
	STS  109,R30
;    3416  port_init();
	CALL _port_init
;    3417  uart0_init();
	CALL _uart0_init
;    3418  uart1_init();
	CALL _uart1_init
;    3419 
;    3420  MCUCR = 0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
;    3421  EICRA = 0x00; //extended ext ints
	STS  106,R30
;    3422  EICRB = 0x00; //extended ext ints
	OUT  0x3A,R30
;    3423  EIMSK = 0x00;
	OUT  0x39,R30
;    3424  TIMSK = 0x00; //timer interrupt sources
	OUT  0x37,R30
;    3425  ETIMSK = 0x00; //extended timer interrupt sources
	STS  125,R30
;    3426  SEI(); //re-enable interrupts
	sei
;    3427  //all peripherals are now initialised
;    3428 }
	RET
;    3429 
;    3430 // Declare your global variables here 
;    3431 extern unsigned char _FF_buff[512];
;    3432 
;    3433 extern unsigned char rtc_hour, rtc_min, rtc_sec;
;    3434 extern unsigned char rtc_date, rtc_month;
;    3435 extern unsigned int rtc_year;
;    3436 
;    3437 char menu_level;

	.DSEG
_menu_level:
	.BYTE 0x1
;    3438 FILE *file1;
_file1:
	.BYTE 0x2
;    3439 
;    3440 
;    3441 
;    3442 void display_demo_commands(void)
;    3443 {

	.CSEG
_display_demo_commands:
;    3444 	printf("\r\nTest Commands:");
	__POINTW1FN _0,625
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;    3445 	printf("\r\n  (1)-Initialize Media      (2)-Read Directory Files");
	__POINTW1FN _0,642
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;    3446 	printf("\r\n  (3)-Create File           (4)-Delete File");
	__POINTW1FN _0,697
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;    3447 	printf("\r\n  (5)-Rename File           (6)-Open File");
	__POINTW1FN _0,743
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;    3448 	printf("\r\n  (7)-Make Directory        (8)-Delete Directory");
	__POINTW1FN _0,787
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;    3449 	printf("\r\n  (9)-Change Working Dir    (0)-Get File Info");
	__POINTW1FN _0,838
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;    3450 	printf("\r\n  (F)-Quick Format Card     (V)-Get Media Serial & Label");
	__POINTW1FN _0,886
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;    3451 	printf("\r\n  (c)-Display Time/Date     (C)-Set Time/Date\r\n");
	__POINTW1FN _0,945
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	RJMP _0x4FD
;    3452 }
;    3453 
;    3454 void display_file_commands(void)
;    3455 {
_display_file_commands:
;    3456 	printf("\r\nOpen File Commands:");
	__POINTW1FN _0,995
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;    3457 	printf("\r\n  (1)-ftell               (2)-fseek");
	__POINTW1FN _0,1017
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;    3458 	printf("\r\n  (3)-fgetc               (4)-ungetc");
	__POINTW1FN _0,1055
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;    3459 	printf("\r\n  (5)-Read file till END  (6)-Write to File");
	__POINTW1FN _0,1094
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;    3460 	printf("\r\n  (7)-Dump Buffer - HEX   (8)-Dump Buffer - ASCII");
	__POINTW1FN _0,1140
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;    3461 	printf("\r\n  (9)-fflush              (0)-fclose");
	__POINTW1FN _0,1192
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;    3462 	printf("\r\n  (E)-Free File Memory\r\n");
	__POINTW1FN _0,1231
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
_0x4FD:
	ADIW R28,2
;    3463 }
	RET
;    3464                                 
;    3465 void flush_receive(void)
;    3466 {
_flush_receive:
;    3467 	while (rx_counter0)
_0x359:
	SBIS 0xB,7
	RJMP _0x35B
;    3468 		getchar();
	CALL _getchar
;    3469 }                          
	RJMP _0x359
_0x35B:
	RET
;    3470                           
;    3471 int get_input_str(char *input_str, int max_size)
;    3472 {
_get_input_str:
;    3473 	int i;
;    3474 	char c;           
;    3475 
;    3476 	for (i=0; i<max_size;)
	CALL __SAVELOCR3
;	*input_str -> Y+5
;	max_size -> Y+3
;	i -> R16,R17
;	c -> R18
	__GETWRN 16,17,0
_0x35D:
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x35E
;    3477 	{
;    3478     	c = getchar();
	CALL _getchar
	MOV  R18,R30
;    3479         if ((c=='\n')||(c=='\r'))	// if its a Line Feed
	CPI  R18,10
	BREQ _0x360
	CPI  R18,13
	BRNE _0x35F
_0x360:
;    3480 		{
;    3481 			*input_str = '\0';		// null terminate the string and 
	CALL SUBOPT_0xE5
;    3482 			return i;				// return the length
	MOVW R30,R16
	RJMP _0x4FC
;    3483 		}                            
;    3484 		else if (c == 8)			// backspace
_0x35F:
	CPI  R18,8
	BRNE _0x363
;    3485 		{
;    3486 			if (i > 0) 
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRGE _0x364
;    3487 			{
;    3488 				putchar(c);
	ST   -Y,R18
	CALL _putchar
;    3489 				putchar(' ');
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL _putchar
;    3490 				putchar(c);
	ST   -Y,R18
	CALL _putchar
;    3491 				input_str--;
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	SBIW R30,1
	STD  Y+5,R30
	STD  Y+5+1,R31
;    3492 				*input_str = '\0';
	CALL SUBOPT_0xE5
;    3493 				i--;
	__SUBWRN 16,17,1
;    3494 			}
;    3495 		}       
_0x364:
;    3496 		else if (c == 0x1B)	   		// ESC
	RJMP _0x365
_0x363:
	CPI  R18,27
	BRNE _0x366
;    3497 		{            
;    3498 			*input_str = '\0';		// null terminate the string
	CALL SUBOPT_0xE5
;    3499 			return 0;				// flag escape with 0 lenght 
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x4FC
;    3500 		}
;    3501 		else
_0x366:
;    3502 		{
;    3503 			putchar(c);
	ST   -Y,R18
	CALL _putchar
;    3504 			*input_str++ = c;
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	ST   X+,R18
	STD  Y+5,R26
	STD  Y+5+1,R27
;    3505 			i++;             		// only increment on valid entries!
	__ADDWRN 16,17,1
;    3506 		}
_0x365:
;    3507 	}        
	RJMP _0x35D
_0x35E:
;    3508 	*input_str = '\0';	// null terminate       
	CALL SUBOPT_0xE5
;    3509 	return i;
	MOVW R30,R16
_0x4FC:
	CALL __LOADLOCR3
	ADIW R28,7
	RET
;    3510 }
;    3511                                         
;    3512 void set_date_time(void)
;    3513 {                           
;    3514 	char myinstr[25];
;    3515 	char *next_str;
;    3516 	int input_vals[6];
;    3517 	char c;
;    3518 	#ifdef _ICCAVR_
;    3519 		char d_str[3], semi_str[4];
;    3520 		cstrcpy(d_str, "%d");
;    3521 		cstrcpy(semi_str, "/: ");
;    3522 	#endif
;    3523 	printf("\n\rSend Date and Time as mm/dd/yyyy hh:mm:ss[ENTER]\n\r");
;	myinstr -> Y+15
;	*next_str -> R16,R17
;	input_vals -> Y+3
;	c -> R18
;    3524 	if (get_input_str(myinstr,20) == 0)
;    3525 		return;         
;    3526 	next_str = myinstr;
;    3527 	for (c=0;((c<6) && (strlen(next_str) != 0));c++)                         
;    3528 	{
;    3529 		#ifdef _CVAVR_
;    3530 			sscanf(next_str,"%d",&(input_vals[c]));
;    3531 			// find next delimiter
;    3532 			next_str = strpbrkf(next_str,"/: ");
;    3533 		#else		
;    3534 			sscanf(next_str, d_str,&(input_vals[c]));
;    3535 			// find next delimiter
;    3536 			next_str = strpbrk(next_str,semi_str);
;    3537 		#endif
;    3538 		// if not null, move past delimiter
;    3539 		if (next_str != '\0')
;    3540 			next_str++;
;    3541 	}
;    3542 //	rtc_set_time(input_vals[3], input_vals[4], input_vals[5]);
;    3543 //    rtc_set_date(input_vals[1],input_vals[0],input_vals[2]);  
;    3544 //    rtc_get_timeNdate(&rtc_hour, &rtc_min, &rtc_sec, &rtc_date, &rtc_month, (int *)&rtc_year);	    			
;    3545 //    printf("\r\n%02d/%02d/%04d %02d:%02d:%02d", rtc_month,rtc_date,rtc_year,rtc_hour,rtc_min,rtc_sec);
;    3546 }
;    3547 
;    3548 void print_result(int result,char error_flag,int bad_compare_value)
;    3549 {                 
_print_result:
;    3550 	if (result != bad_compare_value)
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x36F
;    3551 		printf("\r\n - OK!");
	__POINTW1FN _0,1318
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RJMP _0x52C
;    3552 	else
_0x36F:
;    3553 	{
;    3554 		if (error_flag == 1)
	LDD  R26,Y+2
	CPI  R26,LOW(0x1)
	BRNE _0x371
;    3555 	 		printf("\r\n - ERROR! - %X", _FF_error);
	__POINTW1FN _0,1327
	CALL SUBOPT_0xE6
	LDI  R24,4
	CALL _printf
	ADIW R28,6
;    3556 	 	else                                        
	RJMP _0x372
_0x371:
;    3557 	 		printf("\r\n - ERROR!");	 	
	__POINTW1FN _0,1344
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
_0x52C:
	CALL _printf
	ADIW R28,2
;    3558 	 }
_0x372:
;    3559 }
	ADIW R28,5
	RET
;    3560 
;    3561 long get_addr_entry(char addr_size)
;    3562 {            	
_get_addr_entry:
;    3563 	unsigned char test_char;
;    3564 	unsigned long addr_sd;
;    3565 	unsigned int n;
;    3566 	
;    3567    	test_char = getchar();
	SBIW R28,4
	CALL __SAVELOCR3
;	addr_size -> Y+7
;	test_char -> R16
;	addr_sd -> Y+3
;	n -> R17,R18
	CALL SUBOPT_0xE7
;    3568 	putchar(test_char);
;    3569     test_char = ascii_to_char(test_char);
	CALL SUBOPT_0xE8
;    3570     addr_sd = test_char;
	MOV  R30,R16
	CLR  R31
	CLR  R22
	CLR  R23
	__PUTD1S 3
;    3571     for (n=0; n<addr_size; n++)
	__GETWRN 17,18,0
_0x374:
	LDD  R30,Y+7
	__GETW2R 17,18
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRLO PC+3
	JMP _0x375
;    3572     {
;    3573     	test_char = getchar();
	CALL SUBOPT_0xE7
;    3574         putchar(test_char);
;    3575         if (test_char == 0x8)
	CPI  R16,8
	BRNE _0x376
;    3576         {
;    3577         	n -= 2;
	__SUBWRN 17,18,2
;    3578             addr_sd >>= 8;
	__GETD2S 3
	LDI  R30,LOW(8)
	CALL __LSRD12
	__PUTD1S 3
;    3579         }
;    3580         else if ((test_char=='\r')||(test_char=='\n'))
	RJMP _0x377
_0x376:
	CPI  R16,13
	BREQ _0x379
	CPI  R16,10
	BRNE _0x378
_0x379:
;    3581         	return addr_sd;
	__GETD1S 3
	RJMP _0x4FB
;    3582         if (test_char == 0x1B)
_0x378:
_0x377:
	CPI  R16,27
	BRNE _0x37B
;    3583         	return EOF;
	__GETD1N 0xFFFFFFFF
	RJMP _0x4FB
;    3584     	test_char = ascii_to_char(test_char);
_0x37B:
	CALL SUBOPT_0xE8
;    3585     	addr_sd = addr_sd << 4;
	__GETD2S 3
	LDI  R30,LOW(4)
	CALL __LSLD12
	__PUTD1S 3
;    3586     	addr_sd |= test_char;
	MOV  R30,R16
	__GETD2S 3
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __ORD12
	__PUTD1S 3
;    3587     }               
	__ADDWRN 17,18,1
	RJMP _0x374
_0x375:
;    3588     return addr_sd;
	__GETD1S 3
_0x4FB:
	CALL __LOADLOCR3
	ADIW R28,8
	RET
;    3589 }
;    3590 
;    3591 void handle_level1(unsigned char test_char)
;    3592 {                           
_handle_level1:
;    3593 	unsigned char *pointer, sd_temp[14], sd_temp2[24], create_info[22], modify_info[22];
;    3594 	unsigned int status, n;
;    3595 	unsigned long addr_sd, c;
;    3596 	char print_demo_flag;
;    3597 	pointer = 0;
	SBIW R28,63
	SBIW R28,28
	CALL __SAVELOCR6
;	test_char -> Y+97
;	*pointer -> R16,R17
;	sd_temp -> Y+83
;	sd_temp2 -> Y+59
;	create_info -> Y+37
;	modify_info -> Y+15
;	status -> R18,R19
;	n -> R20,R21
;	addr_sd -> Y+11
;	c -> Y+7
;	print_demo_flag -> Y+6
	__GETWRN 16,17,0
;    3598 	print_demo_flag = 1;	// assume for now that we will recognize the command!
	LDI  R30,LOW(1)
	STD  Y+6,R30
;    3599 	
;    3600    	switch(test_char)
	__GETB1SX 97
;    3601    	{	
;    3602    		case '$':
	CPI  R30,LOW(0x24)
	BRNE _0x37F
;    3603 	  		#ifdef _DEBUG_ON_
;    3604     		printf("\r\nJumping to Bootloader");
	__POINTW1FN _0,1356
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;    3605     		while(tx_counter0);
_0x380:
	IN   R30,0xB
	CALL __LNEGB1
	ANDI R30,LOW(0x40)
	BRNE _0x380
;    3606     		#endif
;    3607 //			#asm("jmp 0xFC00");
;    3608 		   	break;
	RJMP _0x37E
;    3609        	case '1':
_0x37F:
	CPI  R30,LOW(0x31)
	BRNE _0x383
;    3610        		printf("\r\nInitializing... ");
	__POINTW1FN _0,1380
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;    3611        		print_result(initialize_media(),0,0);
	CALL _initialize_media
	LDI  R31,0
	CALL SUBOPT_0xE9
	CALL SUBOPT_0xEA
;    3612    			break;
	RJMP _0x37E
;    3613 
;    3614    		#ifdef _DEBUG_ON_
;    3615    		case '2':
_0x383:
	CPI  R30,LOW(0x32)
	BRNE _0x384
;    3616    			read_directory();
	CALL _read_directory
;    3617       		break;
	RJMP _0x37E
;    3618        	#endif
;    3619 
;    3620        	#ifndef _READ_ONLY_
;    3621        	case '3':
_0x384:
	CPI  R30,LOW(0x33)
	BRNE _0x385
;    3622        		printf("\r\nCreating File:  ");
	__POINTW1FN _0,1399
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL SUBOPT_0xEB
;    3623 			if (get_input_str(sd_temp2, 24) != 0)
	CALL SUBOPT_0xEC
	BREQ _0x386
;    3624 			{
;    3625 
;    3626 printf ("My  Point1");
	__POINTW1FN _0,1418
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL SUBOPT_0xEB
;    3627 
;    3628    	    		file1 = fcreate(sd_temp2, 0);
	CALL SUBOPT_0xE9
	CALL _fcreate
	STS  _file1,R30
	STS  _file1+1,R31
;    3629 printf ("My  Point2");
	__POINTW1FN _0,1429
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL SUBOPT_0xED
;    3630    	    		print_result((int)file1,1,NULL);
	CALL SUBOPT_0x71
	CALL SUBOPT_0xEA
;    3631         		if (file1 != 0)
	LDS  R30,_file1
	LDS  R31,_file1+1
	SBIW R30,0
	BREQ _0x387
;    3632        				fclose(file1);
	ST   -Y,R31
	ST   -Y,R30
	CALL _fclose
;    3633    			}
_0x387:
;    3634        		break;
_0x386:
	RJMP _0x37E
;    3635        	case '4':
_0x385:
	CPI  R30,LOW(0x34)
	BRNE _0x388
;    3636        		printf("\r\nDeleting File:  ");
	__POINTW1FN _0,1440
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL SUBOPT_0xEB
;    3637 			if (get_input_str(sd_temp2, 24) != 0)
	CALL SUBOPT_0xEC
	BREQ _0x389
;    3638 				print_result(remove(sd_temp2),1,EOF);
	MOVW R30,R28
	ADIW R30,59
	ST   -Y,R31
	ST   -Y,R30
	CALL _remove
	CALL SUBOPT_0x71
	CALL SUBOPT_0xEE
;    3639        		break;
_0x389:
	RJMP _0x37E
;    3640        	case '5':
_0x388:
	CPI  R30,LOW(0x35)
	BRNE _0x38A
;    3641        		printf("\r\nRename File:\r\n  Old Name:  ");
	__POINTW1FN _0,1459
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL SUBOPT_0xEB
;    3642 			if (get_input_str(sd_temp2, 24) != 0)
	CALL SUBOPT_0xEC
	BREQ _0x38B
;    3643 			{               
;    3644         		printf("\r\n  New Name:  ");
	__POINTW1FN _0,1489
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL SUBOPT_0xEF
;    3645 				flush_receive();    	// clear out any hanging characters from last entry
;    3646 				if (get_input_str(sd_temp, 12) != 0)
	CALL SUBOPT_0xF0
	BREQ _0x38C
;    3647     	       		print_result(rename(sd_temp2, sd_temp),1,EOF);
	MOVW R30,R28
	ADIW R30,59
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	SUBI R30,LOW(-(85))
	SBCI R31,HIGH(-(85))
	ST   -Y,R31
	ST   -Y,R30
	CALL _rename
	CALL SUBOPT_0x71
	CALL SUBOPT_0xEE
;    3648     		}
_0x38C:
;    3649         	break;
_0x38B:
	RJMP _0x37E
;    3650        	#endif
;    3651        	case '6':
_0x38A:
	CPI  R30,LOW(0x36)
	BREQ PC+3
	JMP _0x38D
;    3652        		printf("\n\rOpen file:  ");
	__POINTW1FN _0,1505
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL SUBOPT_0xEB
;    3653 			if (get_input_str(sd_temp2, 24) != 0)
	CALL SUBOPT_0xEC
	BRNE PC+3
	JMP _0x38E
;    3654 			{
;    3655           		printf("\r\nChoose:  (1)-READ  (2)-WRITE  (3)-APPEND");
	__POINTW1FN _0,1520
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL SUBOPT_0xEF
;    3656 				flush_receive();    	// clear out any hanging characters from last entry          		
;    3657        			status = getchar();
	CALL SUBOPT_0xF1
;    3658        			switch (status)
	MOVW R30,R18
;    3659         		{
;    3660    	    			case '1':
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0x392
;    3661        					printf("  -- READ");
	__POINTW1FN _0,1563
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL SUBOPT_0xEB
;    3662        					file1 = fopen(sd_temp2, READ);
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	RJMP _0x52D
;    3663        					break;
;    3664         			case '2':
_0x392:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0x393
;    3665    	    				printf("  -- WRITE");
	__POINTW1FN _0,1573
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL SUBOPT_0xEB
;    3666        					file1 = fopen(sd_temp2, WRITE);
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	RJMP _0x52D
;    3667        					break;
;    3668        				case '3':
_0x393:
	CPI  R30,LOW(0x33)
	LDI  R26,HIGH(0x33)
	CPC  R31,R26
	BRNE _0x391
;    3669        					printf("  -- APPEND");
	__POINTW1FN _0,1584
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL SUBOPT_0xEB
;    3670         				file1 = fopen(sd_temp2, APPEND);
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(3)
_0x52D:
	ST   -Y,R30
	CALL _fopen
	STS  _file1,R30
	STS  _file1+1,R31
;    3671    	    				break;
;    3672        			}
_0x391:
;    3673        			if (file1==0)
	LDS  R30,_file1
	LDS  R31,_file1+1
	SBIW R30,0
	BRNE _0x395
;    3674        				printf("\r\nFileOpen Error = %x", _FF_error);
	__POINTW1FN _0,1596
	CALL SUBOPT_0xE6
	LDI  R24,4
	RCALL _printf
	ADIW R28,6
;    3675         		else
	RJMP _0x396
_0x395:
;    3676    	    		{
;    3677        				printf("\r\nSuccess!!!  -  %s - Opened! \r\n",sd_temp2);
	__POINTW1FN _0,1618
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,61
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	RCALL _printf
	ADIW R28,6
;    3678        				menu_level = 2;
	LDI  R30,LOW(2)
	STS  _menu_level,R30
;    3679        				display_file_commands();
	CALL _display_file_commands
;    3680        				print_demo_flag = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
;    3681        			}
_0x396:
;    3682    			}
;    3683    			break;
_0x38E:
	RJMP _0x37E
;    3684        	case '7':
_0x38D:
	CPI  R30,LOW(0x37)
	BRNE _0x397
;    3685 			printf("\r\nMake Directory:  ");
	__POINTW1FN _0,1651
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL SUBOPT_0xEB
;    3686     		if (get_input_str(sd_temp2, 24) != 0)
	CALL SUBOPT_0xEC
	BREQ _0x398
;    3687     	    	print_result(mkdir(sd_temp2),0,EOF);
	MOVW R30,R28
	ADIW R30,59
	ST   -Y,R31
	ST   -Y,R30
	CALL _mkdir
	CALL SUBOPT_0xE9
	CALL SUBOPT_0xEE
;    3688     	 	break;
_0x398:
	RJMP _0x37E
;    3689 		case '8':
_0x397:
	CPI  R30,LOW(0x38)
	BRNE _0x399
;    3690        		printf("\r\nDelete Directory:  ");
	__POINTW1FN _0,1671
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL SUBOPT_0xEB
;    3691     		if (get_input_str(sd_temp2, 24) != 0)
	CALL SUBOPT_0xEC
	BREQ _0x39A
;    3692     	 		print_result(rmdir(sd_temp2),0,EOF);
	MOVW R30,R28
	ADIW R30,59
	ST   -Y,R31
	ST   -Y,R30
	CALL _rmdir
	CALL SUBOPT_0xE9
	CALL SUBOPT_0xEE
;    3693         	break;
_0x39A:
	RJMP _0x37E
;    3694 		case '9':
_0x399:
	CPI  R30,LOW(0x39)
	BRNE _0x39B
;    3695         	printf("\r\nChange Current Directory to:  ");
	__POINTW1FN _0,1693
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL SUBOPT_0xEB
;    3696     		if (get_input_str(sd_temp2, 24) != 0)
	CALL SUBOPT_0xEC
	BREQ _0x39C
;    3697     	    	print_result(chdir(sd_temp2),0,EOF);
	MOVW R30,R28
	ADIW R30,59
	ST   -Y,R31
	ST   -Y,R30
	CALL _chdir
	CALL SUBOPT_0xE9
	CALL SUBOPT_0xEE
;    3698           	break;
_0x39C:
	RJMP _0x37E
;    3699 		case '0':
_0x39B:
	CPI  R30,LOW(0x30)
	BREQ PC+3
	JMP _0x39D
;    3700         	printf("\r\nGet File Info for:  ");
	__POINTW1FN _0,1726
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
;    3701     		if (get_input_str(sd_temp, 12) != 0)
	CALL SUBOPT_0xF0
	BRNE PC+3
	JMP _0x39E
;    3702     		{
;    3703     	    	if (fget_file_info(sd_temp, &addr_sd, create_info, modify_info, pointer, &n)!=EOF)
	MOVW R30,R28
	SUBI R30,LOW(-(83))
	SBCI R31,HIGH(-(83))
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,13
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,41
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,21
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	IN   R30,SPL
	IN   R31,SPH
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	PUSH R21
	PUSH R20
	CALL _fget_file_info
	POP  R20
	POP  R21
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BREQ _0x39F
;    3704         	    {
;    3705             		printf("\r\n  File Size:  %ld bytes\r\n  Create Time:  ", addr_sd);
	__POINTW1FN _0,1749
	CALL SUBOPT_0xF2
	LDI  R24,4
	RCALL _printf
	ADIW R28,6
;    3706             		puts(create_info);
	MOVW R30,R28
	ADIW R30,37
	ST   -Y,R31
	ST   -Y,R30
	CALL _puts
;    3707             		printf("\r  Modify Time:  ");
	__POINTW1FN _0,1793
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
;    3708             		puts(modify_info);
	MOVW R30,R28
	ADIW R30,15
	ST   -Y,R31
	ST   -Y,R30
	CALL _puts
;    3709 					printf("\r  Attributes:  0x%X\n", *pointer);
	__POINTW1FN _0,1811
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	CALL SUBOPT_0xE4
	LDI  R24,4
	RCALL _printf
	ADIW R28,6
;    3710         	    	printf("\r  Starting Cluster:  0x%lX @ ADDR: 0x%lX\r\n", n, clust_to_addr(n));
	__POINTW1FN _0,1833
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	ST   -Y,R21
	ST   -Y,R20
	CALL _clust_to_addr
	CALL __PUTPARD1
	LDI  R24,8
	RCALL _printf
	ADIW R28,10
;    3711      			}
;    3712             	else
	RJMP _0x3A0
_0x39F:
;    3713             		printf("\r\n - ERROR! - %X\r\n", _FF_error);
	__POINTW1FN _0,1877
	CALL SUBOPT_0xE6
	LDI  R24,4
	RCALL _printf
	ADIW R28,6
;    3714         	}
_0x3A0:
;    3715             break;
_0x39E:
	RJMP _0x37E
;    3716         case 'F':
_0x39D:
	CPI  R30,LOW(0x46)
	BREQ PC+3
	JMP _0x3A1
;    3717         	printf("\r\nQuick Format Card and delete all existing data?  (Y)es  (N)o\r\n  ");
	__POINTW1FN _0,1896
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL SUBOPT_0xF3
;    3718             c = getchar();
	CLR  R31
	CLR  R22
	CLR  R23
	__PUTD1S 7
;    3719             putchar(c);
	LDD  R30,Y+7
	ST   -Y,R30
	CALL _putchar
;    3720             if ((c=='Y')||(c=='y'))
	__GETD2S 7
	__CPD2N 0x59
	BREQ _0x3A3
	__CPD2N 0x79
	BRNE _0x3A2
_0x3A3:
;    3721             {
;    3722             	printf("es - ");
	__POINTW1FN _0,1963
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
;    3723             	print_result(fquickformat(),0,EOF);
	CALL _fquickformat
	CALL SUBOPT_0xE9
	CALL SUBOPT_0xEE
;    3724             }
;    3725             else if ((c=='N')||(c=='n'))
	RJMP _0x3A5
_0x3A2:
	__GETD2S 7
	__CPD2N 0x4E
	BREQ _0x3A7
	__CPD2N 0x6E
	BRNE _0x3A6
_0x3A7:
;    3726             	printf("o - Cancelled\r\n");
	__POINTW1FN _0,1969
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RJMP _0x52E
;    3727             else
_0x3A6:
;    3728             	printf(" - Ivnalid Response - Cancelled\r\n");
	__POINTW1FN _0,1985
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
_0x52E:
	RCALL _printf
	ADIW R28,2
;    3729             break;	
_0x3A5:
	RJMP _0x37E
;    3730          case '-':
_0x3A1:
	CPI  R30,LOW(0x2D)
	BRNE _0x3AA
;    3731          	printf("\n\rRead MMC - Enter Address: ");
	__POINTW1FN _0,2019
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL SUBOPT_0xF4
;    3732             addr_sd = get_addr_entry(7);
	__PUTD1S 11
;    3733             if (addr_sd!=EOF)
	__GETD2S 11
	__CPD2N 0xFFFFFFFF
	BREQ _0x3AB
;    3734             {
;    3735 				printf("\n\rCalc. address: %lx", addr_sd);
	__POINTW1FN _0,2048
	CALL SUBOPT_0xF2
	LDI  R24,4
	RCALL _printf
	ADIW R28,6
;    3736     	   		_FF_read_disp(addr_sd);
	__GETD1S 11
	CALL __PUTPARD1
	CALL __FF_read_disp
;    3737     		}
;    3738        		break;
_0x3AB:
	RJMP _0x37E
;    3739    		#ifndef _READ_ONLY_
;    3740    		case 'E':
_0x3AA:
	CPI  R30,LOW(0x45)
	BRNE _0x3AC
;    3741    			_FF_error = 0;
	LDI  R30,LOW(0)
	STS  __FF_error,R30
;    3742    			break;
	RJMP _0x37E
;    3743    		#ifdef _DEBUG_ON_
;    3744    		case 'N':
_0x3AC:
	CPI  R30,LOW(0x4E)
	BRNE _0x3AD
;    3745    			status = prev_cluster(0);
	CALL SUBOPT_0x6D
	MOVW R18,R30
;    3746    			printf("\n\rFinding Next Avaliable Cluster:  [%X],  _FF_error = [%X]", status, _FF_error);
	__POINTW1FN _0,2069
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,__FF_error
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,8
	RCALL _printf
	ADIW R28,10
;    3747    			printf("\n\rLocated @ 0x%lX", clust_to_addr(status));
	__POINTW1FN _0,2128
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R19
	ST   -Y,R18
	CALL _clust_to_addr
	CALL __PUTPARD1
	LDI  R24,4
	RCALL _printf
	ADIW R28,6
;    3748    			break;
	RJMP _0x37E
;    3749    		case 'M':
_0x3AD:
	CPI  R30,LOW(0x4D)
	BRNE _0x3AE
;    3750    			printf("\r\nPoint Cluster: 0x");
	__POINTW1FN _0,2146
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL SUBOPT_0xF5
;    3751    			addr_sd = get_addr_entry(4);
	__PUTD1S 11
;    3752    			printf("\r\nTo Cluster: 0x");
	__POINTW1FN _0,2166
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL SUBOPT_0xF5
;    3753    			status = get_addr_entry(4);
	MOVW R18,R30
;    3754    			if (write_clus_table(addr_sd, status, SINGLE))
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R19
	ST   -Y,R18
	CALL SUBOPT_0xDE
	BREQ _0x3AF
;    3755    				printf("  -  OK!!!");
	__POINTW1FN _0,2183
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RJMP _0x52F
;    3756    			else
_0x3AF:
;    3757    				printf("  -  ERROR!!!");
	__POINTW1FN _0,2194
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
_0x52F:
	RCALL _printf
	ADIW R28,2
;    3758    			break;
	RJMP _0x37E
;    3759    		#endif	
;    3760    		#endif         
;    3761 #ifdef _SD_MMC_MEDIA_
;    3762    		case 'R':
_0x3AE:
	CPI  R30,LOW(0x52)
	BRNE _0x3B1
;    3763 			reset_sd();
	CALL _reset_sd
;    3764         	break;
	RJMP _0x37E
;    3765    		case 'I':
_0x3B1:
	CPI  R30,LOW(0x49)
	BRNE _0x3B2
;    3766         	init_sd();
	CALL _init_sd
;    3767         	break;
	RJMP _0x37E
;    3768 #endif
;    3769 		#ifdef _RTC_ON_
;    3770     	case 'c':
;    3771         	rtc_get_timeNdate(&rtc_hour, &rtc_min, &rtc_sec, &rtc_date, &rtc_month, (int *)&rtc_year);	    			
;    3772         	printf("\r\n%02d/%02d/%04d %02d:%02d:%02d", rtc_month,rtc_date,rtc_year,rtc_hour,rtc_min,rtc_sec);
;    3773         	break;
;    3774     	case 'C':
;    3775     		set_date_time();
;    3776     		break;
;    3777     	#endif
;    3778        	case 'V':
_0x3B2:
	CPI  R30,LOW(0x56)
	BRNE _0x3B4
;    3779        		printf("\r\nVolume Serial Number and Label:");
	__POINTW1FN _0,2208
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
;    3780        		GetVolID();
	CALL _GetVolID
;    3781        		break;
	RJMP _0x37E
;    3782     	default:
_0x3B4:
;    3783     		print_demo_flag = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
;    3784     		break;
;    3785     }                                                  
_0x37E:
;    3786     // if this was a valid command, finish by printing the commands
;    3787 	if (print_demo_flag == 1)
	LDD  R26,Y+6
	CPI  R26,LOW(0x1)
	BRNE _0x3B5
;    3788 		display_demo_commands(); 
	CALL _display_demo_commands
;    3789 }
_0x3B5:
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,35
	RET
;    3790 
;    3791 
;    3792 void handle_level2(unsigned char testchar)
;    3793 {
_handle_level2:
;    3794 	unsigned int status, c;
;    3795 	unsigned long addr_sd;
;    3796 
;    3797 	switch (testchar)
	SBIW R28,4
	CALL __SAVELOCR4
;	testchar -> Y+8
;	status -> R16,R17
;	c -> R18,R19
;	addr_sd -> Y+4
	LDD  R30,Y+8
;    3798 	{
;    3799     	case '1':
	CPI  R30,LOW(0x31)
	BRNE _0x3B9
;    3800         	printf("\n\rftell:  position = 0x%lX", ftell(file1));
	__POINTW1FN _0,2242
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_file1
	LDS  R31,_file1+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _ftell
	CALL __PUTPARD1
	LDI  R24,4
	RCALL _printf
	ADIW R28,6
;    3801     		break;
	RJMP _0x3B8
;    3802 		case '2':
_0x3B9:
	CPI  R30,LOW(0x32)
	BREQ PC+3
	JMP _0x3BA
;    3803     		printf("\n\rfseek:  Offset = 0x");
	__POINTW1FN _0,2269
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL SUBOPT_0xF4
;    3804     		addr_sd = get_addr_entry(7);
	__PUTD1S 4
;    3805     		if (addr_sd==EOF)
	__GETD2S 4
	__CPD2N 0xFFFFFFFF
	BRNE _0x3BB
;    3806     			break;
	RJMP _0x3B8
;    3807 			printf("=%lX\r\n    Mode:  (1)-SEEK_CUR  (2)-SEEK_END  (3)-SEEK_SET :", addr_sd);
_0x3BB:
	__POINTW1FN _0,2291
	CALL SUBOPT_0xF6
	LDI  R24,4
	RCALL _printf
	ADIW R28,6
;    3808     		status = getchar();
	CALL SUBOPT_0xF7
;    3809 			switch (status)
	MOVW R30,R16
;    3810 			{
;    3811         		case '1':
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0x3BF
;    3812 			    	printf("  -- SEEK_CUR");
	__POINTW1FN _0,2351
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
;    3813         			status = 0;
	__GETWRN 16,17,0
;    3814 				    break;
	RJMP _0x3BE
;    3815     	   		case '2':
_0x3BF:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0x3C0
;    3816         			printf("  -- SEEK_END");
	__POINTW1FN _0,2365
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
;    3817 				    status = 1;
	__GETWRN 16,17,1
;    3818         			break;
	RJMP _0x3BE
;    3819 			    case '3':
_0x3C0:
	CPI  R30,LOW(0x33)
	LDI  R26,HIGH(0x33)
	CPC  R31,R26
	BRNE _0x3BE
;    3820         			printf("  -- SEEK_SET");
	__POINTW1FN _0,2379
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
;    3821 			        status = 2;
	__GETWRN 16,17,2
;    3822         			break;
;    3823        		}
_0x3BE:
;    3824 			print_result(fseek(file1, addr_sd, status),0,EOF);
	LDS  R30,_file1
	LDS  R31,_file1+1
	CALL SUBOPT_0xF6
	ST   -Y,R16
	CALL _fseek
	CALL SUBOPT_0xE9
	CALL SUBOPT_0xEE
;    3825 			break;
	RJMP _0x3B8
;    3826 		case '3':
_0x3BA:
	CPI  R30,LOW(0x33)
	BRNE _0x3C2
;    3827         	putchar(fgetc(file1));
	CALL SUBOPT_0xF8
;    3828     		break;
	RJMP _0x3B8
;    3829       	case '4':
_0x3C2:
	CPI  R30,LOW(0x34)
	BRNE _0x3C3
;    3830         	printf("\r\nEnter character to push back: ");
	__POINTW1FN _0,2393
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL SUBOPT_0xF3
;    3831     		putchar(ungetc(getchar(), file1)); 
	CALL SUBOPT_0xF9
	ST   -Y,R30
	CALL _putchar
;    3832     		printf(" - OK!\r\n");
	__POINTW1FN _0,2426
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RJMP _0x530
;    3833         	break;
;    3834   		case '5':
_0x3C3:
	CPI  R30,LOW(0x35)
	BRNE _0x3C4
;    3835         	while (feof(file1)==0)
_0x3C5:
	LDS  R30,_file1
	LDS  R31,_file1+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _feof
	SBIW R30,0
	BRNE _0x3C7
;    3836     			putchar(fgetc(file1));
	CALL SUBOPT_0xF8
;    3837         	break;
	RJMP _0x3C5
_0x3C7:
	RJMP _0x3B8
;    3838 		#ifndef _READ_ONLY_
;    3839     	case '6':
_0x3C4:
	CPI  R30,LOW(0x36)
	BRNE _0x3C8
;    3840         	printf("\r\nWrite to file:   Press [ESC] to end 'Write' mode\r\n");
	__POINTW1FN _0,2435
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL SUBOPT_0xF3
;    3841     		status = getchar();
	MOV  R16,R30
	CLR  R17
;    3842         	while (status!=0x1b)
_0x3C9:
	LDI  R30,LOW(27)
	LDI  R31,HIGH(27)
	CP   R30,R16
	CPC  R31,R17
	BREQ _0x3CB
;    3843     		{
;    3844         		if (fputc(status, file1)!=EOF)
	ST   -Y,R16
	LDS  R30,_file1
	LDS  R31,_file1+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _fputc
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BREQ _0x3CC
;    3845     			{
;    3846         			if (status==0x08)
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x3CD
;    3847     	    		{	// Backspace pressed
;    3848     					ungetc('0', file1);
	LDI  R30,LOW(48)
	CALL SUBOPT_0xF9
;    3849         				ungetc('0', file1);
	LDI  R30,LOW(48)
	CALL SUBOPT_0xF9
;    3850         			}
;    3851     				putchar(status);
_0x3CD:
	ST   -Y,R16
	CALL _putchar
;    3852     		    	status = getchar();
	CALL SUBOPT_0xF7
;    3853     			}
;    3854     		    else
	RJMP _0x3CE
_0x3CC:
;    3855     			{
;    3856     		    	printf("\r\nWrite ERROR!!!");
	__POINTW1FN _0,2488
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
;    3857     				status = 0x1b;					// exit the while loop
	__GETWRN 16,17,27
;    3858     			}
_0x3CE:
;    3859 			}
	RJMP _0x3C9
_0x3CB:
;    3860 			break;
	RJMP _0x3B8
;    3861    		#endif
;    3862     	case '7':
_0x3C8:
	CPI  R30,LOW(0x37)
	BRNE _0x3CF
;    3863         	dump_file_data_hex(file1);
	LDS  R30,_file1
	LDS  R31,_file1+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _dump_file_data_hex
;    3864 			break;
	RJMP _0x3B8
;    3865 		case '8':
_0x3CF:
	CPI  R30,LOW(0x38)
	BRNE _0x3D0
;    3866         	dump_file_data_view(file1);
	LDS  R30,_file1
	LDS  R31,_file1+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _dump_file_data_view
;    3867 			break;
	RJMP _0x3B8
;    3868 		#ifndef _READ_ONLY_
;    3869         case '9':
_0x3D0:
	CPI  R30,LOW(0x39)
	BRNE _0x3D1
;    3870     		printf("\n\rFile Flushing...");
	__POINTW1FN _0,2505
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL SUBOPT_0xED
;    3871       		print_result(fflush(file1),0,EOF);
	ST   -Y,R31
	ST   -Y,R30
	CALL _fflush
	CALL SUBOPT_0xE9
	CALL SUBOPT_0xEE
;    3872 			break;
	RJMP _0x3B8
;    3873    		#endif
;    3874     	case '0':
_0x3D1:
	CPI  R30,LOW(0x30)
	BRNE _0x3D2
;    3875     		printf("\n\rFile Closing...");  
	__POINTW1FN _0,2524
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL SUBOPT_0xED
;    3876     		status = fclose(file1);
	ST   -Y,R31
	ST   -Y,R30
	CALL _fclose
	MOVW R16,R30
;    3877         	print_result(status,0,EOF);
	CALL SUBOPT_0xFA
	CALL SUBOPT_0xEE
;    3878         	if (status==0)
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x3D3
;    3879         		file1 = NULL;
	LDI  R30,0
	STS  _file1,R30
	STS  _file1+1,R30
;    3880 			break;
_0x3D3:
	RJMP _0x3B8
;    3881 		case 'E':
_0x3D2:
	CPI  R30,LOW(0x45)
	BREQ PC+3
	JMP _0x3B8
;    3882         	printf("\r\nClose File w/o saving buffered data?  (Y)es  (N)o\r\n  ");
	__POINTW1FN _0,2542
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
;    3883             c = getchar();
	CALL SUBOPT_0xF1
;    3884             putchar(c);
	ST   -Y,R18
	CALL _putchar
;    3885             if ((c=='Y')||(c=='y'))
	LDI  R30,LOW(89)
	LDI  R31,HIGH(89)
	CP   R30,R18
	CPC  R31,R19
	BREQ _0x3D6
	LDI  R30,LOW(121)
	LDI  R31,HIGH(121)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x3D5
_0x3D6:
;    3886             {
;    3887             	printf("es - ");
	__POINTW1FN _0,1963
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL SUBOPT_0xED
;    3888             	print_result(ffreemem(file1),0,EOF);
	ST   -Y,R31
	ST   -Y,R30
	CALL _ffreemem
	CALL SUBOPT_0xE9
	CALL SUBOPT_0xEE
;    3889         		file1 = NULL;
	LDI  R30,0
	STS  _file1,R30
	STS  _file1+1,R30
;    3890             }
;    3891             else if ((c=='N')||(c=='n'))
	RJMP _0x3D8
_0x3D5:
	LDI  R30,LOW(78)
	LDI  R31,HIGH(78)
	CP   R30,R18
	CPC  R31,R19
	BREQ _0x3DA
	LDI  R30,LOW(110)
	LDI  R31,HIGH(110)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x3D9
_0x3DA:
;    3892             	printf("o - Cancelled\r\n");
	__POINTW1FN _0,1969
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RJMP _0x530
;    3893             else
_0x3D9:
;    3894             	printf(" - Ivnalid Response - Cancelled\r\n");
	__POINTW1FN _0,1985
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
_0x530:
	RCALL _printf
	ADIW R28,2
;    3895             break;	
_0x3D8:
;    3896 	}
_0x3B8:
;    3897 	if (file1 == NULL) 
	LDS  R30,_file1
	LDS  R31,_file1+1
	SBIW R30,0
	BRNE _0x3DD
;    3898 	{
;    3899 		menu_level = 1;
	LDI  R30,LOW(1)
	STS  _menu_level,R30
;    3900 		display_demo_commands();
	CALL _display_demo_commands
;    3901 	}
;    3902 	else if ((testchar != '0') && (testchar != '3'))
	RJMP _0x3DE
_0x3DD:
	LDD  R26,Y+8
	CPI  R26,LOW(0x30)
	BREQ _0x3E0
	CPI  R26,LOW(0x33)
	BRNE _0x3E1
_0x3E0:
	RJMP _0x3DF
_0x3E1:
;    3903 		display_file_commands();
	CALL _display_file_commands
;    3904 }
_0x3DF:
_0x3DE:
	CALL __LOADLOCR4
	ADIW R28,9
	RET
;    3905 
;    3906 extern char _bss_end;
;    3907 
;    3908 main()
;    3909 {
_main:
;    3910  	unsigned char test_char;
;    3911 	
;    3912 	init_devices();
;	test_char -> R16
	CALL _init_devices
;    3913 
;    3914 	#ifdef _ICCAVR_
;    3915 		_NewHeap(&_bss_end + 1, &_bss_end + 701);
;    3916 	#endif
;    3917 	
;    3918 //	twi_setup();    
;    3919 
;    3920 	menu_level = 1;
	LDI  R30,LOW(1)
	STS  _menu_level,R30
;    3921 	printf("\r\nMicrocontroller Reset!!!\r\n");
	__POINTW1FN _0,2598
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
;    3922 	printf("\r\nPress '1' to initialize media:");
	__POINTW1FN _0,2627
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
;    3923 
;    3924 	test_char = 1;
	LDI  R16,LOW(1)
;    3925 	while (test_char != '1')
_0x3E2:
	CPI  R16,49
	BREQ _0x3E4
;    3926 	{
;    3927 		test_char = getchar();
	CALL SUBOPT_0xE7
;    3928                 putchar (test_char);
;    3929 	}
	RJMP _0x3E2
_0x3E4:
;    3930 	while (initialize_media()==0)
_0x3E5:
	CALL _initialize_media
	CPI  R30,0
	BRNE _0x3E7
;    3931 	{
;    3932 		printf("\r\n  ERROR!!!\r\n");
	__POINTW1FN _0,2660
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
;    3933 		printf("\r\nPress '1' to initialize media:");
	__POINTW1FN _0,2627
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
;    3934 		while (getchar()!='1')
_0x3E8:
	CALL _getchar
	CPI  R30,LOW(0x31)
	BRNE _0x3E8
;    3935 			;
;    3936 	}
	RJMP _0x3E5
_0x3E7:
;    3937 	printf("\r\n  OK!!!");    
	__POINTW1FN _0,2675
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL SUBOPT_0x16
;    3938 	PORTA = 0x01;           //Если инициализация ОК-LCD зеленый
	OUT  0x1B,R30
;    3939 	display_demo_commands();
	CALL _display_demo_commands
;    3940 	
;    3941 	while (1)
_0x3EB:
;    3942     {
;    3943     	// Place your code here
;    3944 /*	    if (rx_counter1)
;    3945 	    {
;    3946 	    	if (getchar1()==0x24)
;    3947 	    	{
;    3948 		    	#ifdef _DEBUG_ON_
;    3949 		    		printf("\r\nJumping to Bootloader");
;    3950 			    	while(tx_counter1);
;    3951 		    	#endif
;    3952 //	    		#asm("jmp 0xFC00");
;    3953 	    	}
;    3954 	    }
;    3955 */	    if (rx_counter0)
	SBIS 0xB,7
	RJMP _0x3EE
;    3956 	    {
;    3957 	    	test_char = getchar();
	CALL _getchar
	MOV  R16,R30
;    3958 	    	if (menu_level == 1)
	LDS  R26,_menu_level
	CPI  R26,LOW(0x1)
	BRNE _0x3EF
;    3959 	    		handle_level1(test_char);
	ST   -Y,R16
	CALL _handle_level1
;    3960 	    	else
	RJMP _0x3F0
_0x3EF:
;    3961 	    		handle_level2(test_char);
	ST   -Y,R16
	CALL _handle_level2
;    3962 	    }
_0x3F0:
;    3963     }
_0x3EE:
	RJMP _0x3EB
;    3964 	return (0);
_0x3F1:
	RJMP _0x3F1
;    3965 }

__put_G2:
	LD   R26,Y
	LDD  R27,Y+1
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x3F2
	CALL SUBOPT_0xE2
	SBIW R30,1
	LDD  R26,Y+2
	STD  Z+0,R26
	RJMP _0x3F3
_0x3F2:
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _putchar
_0x3F3:
	ADIW R28,3
	RET
__ftoa_G2:
	CALL SUBOPT_0xDB
	LDD  R26,Y+8
	CPI  R26,LOW(0x6)
	BRLO _0x3F4
	LDI  R30,LOW(5)
	STD  Y+8,R30
_0x3F4:
	LDD  R30,Y+8
	LDI  R26,LOW(__fround_G2*2)
	LDI  R27,HIGH(__fround_G2*2)
	LDI  R31,0
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	CALL __GETD1PF
	__GETD2S 9
	CALL __ADDF12
	__PUTD1S 9
	LDI  R16,LOW(0)
	__GETD1N 0x3F800000
	__PUTD1S 2
_0x3F5:
	__GETD1S 2
	__GETD2S 9
	CALL __CMPF12
	BRLO _0x3F7
	__GETD2S 2
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 2
	SUBI R16,-LOW(1)
	RJMP _0x3F5
_0x3F7:
	CPI  R16,0
	BRNE _0x3F8
	CALL SUBOPT_0xFB
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x3F9
_0x3F8:
_0x3FA:
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BREQ _0x3FC
	__GETD2S 2
	CALL SUBOPT_0xFC
	__PUTD1S 2
	__GETD2S 9
	CALL SUBOPT_0xFD
	CALL SUBOPT_0xFB
	CALL SUBOPT_0xFE
	__GETD2S 2
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __MULF12
	__GETD2S 9
	CALL SUBOPT_0xFF
	RJMP _0x3FA
_0x3FC:
_0x3F9:
	LDD  R30,Y+8
	CPI  R30,0
	BRNE _0x3FD
	CALL SUBOPT_0x100
	RJMP _0x4FA
_0x3FD:
	CALL SUBOPT_0xFB
	LDI  R30,LOW(46)
	ST   X,R30
_0x3FE:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x400
	__GETD2S 9
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 9
	CALL __CFD1
	MOV  R17,R30
	CALL SUBOPT_0xFB
	CALL SUBOPT_0xFE
	__GETD2S 9
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL SUBOPT_0xFF
	RJMP _0x3FE
_0x400:
	CALL SUBOPT_0x100
_0x4FA:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET
__ftoe_G2:
	SBIW R28,4
	CALL __SAVELOCR3
	__GETD1N 0x3F800000
	__PUTD1S 3
	LDD  R26,Y+10
	CPI  R26,LOW(0x6)
	BRLO _0x401
	LDI  R30,LOW(5)
	STD  Y+10,R30
_0x401:
	LDD  R16,Y+10
_0x402:
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BREQ _0x404
	CALL SUBOPT_0x101
	RJMP _0x402
_0x404:
	__GETD1S 11
	CALL __CPD10
	BRNE _0x405
	LDI  R18,LOW(0)
	CALL SUBOPT_0x101
	RJMP _0x406
_0x405:
	LDD  R18,Y+10
	CALL SUBOPT_0x102
	BREQ PC+2
	BRCC PC+3
	JMP  _0x407
	CALL SUBOPT_0x101
_0x408:
	CALL SUBOPT_0x102
	BRLO _0x40A
	CALL SUBOPT_0x103
	SUBI R18,-LOW(1)
	RJMP _0x408
_0x40A:
	RJMP _0x40B
_0x407:
_0x40C:
	CALL SUBOPT_0x102
	BRSH _0x40E
	__GETD2S 11
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 11
	SUBI R18,LOW(1)
	RJMP _0x40C
_0x40E:
	CALL SUBOPT_0x101
_0x40B:
	__GETD1S 11
	__GETD2N 0x3F000000
	CALL __ADDF12
	__PUTD1S 11
	CALL SUBOPT_0x102
	BRLO _0x40F
	CALL SUBOPT_0x103
	SUBI R18,-LOW(1)
_0x40F:
_0x406:
	LDI  R16,LOW(0)
_0x410:
	LDD  R30,Y+10
	CP   R30,R16
	BRLO _0x412
	__GETD2S 3
	CALL SUBOPT_0xFC
	__PUTD1S 3
	__GETD2S 11
	CALL SUBOPT_0xFD
	CALL SUBOPT_0x104
	CALL SUBOPT_0xFE
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2S 3
	CALL __MULF12
	__GETD2S 11
	CALL __SWAPD12
	CALL __SUBF12
	__PUTD1S 11
	MOV  R30,R16
	SUBI R16,-1
	CPI  R30,0
	BRNE _0x410
	CALL SUBOPT_0x104
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x410
_0x412:
	CALL SUBOPT_0x87
	SBIW R30,1
	LDD  R26,Y+9
	STD  Z+0,R26
	CPI  R18,0
	BRGE _0x414
	CALL SUBOPT_0x104
	LDI  R30,LOW(45)
	ST   X,R30
	NEG  R18
_0x414:
	CPI  R18,10
	BRLT _0x415
	CALL SUBOPT_0x87
	CALL SUBOPT_0x105
	CALL __DIVB21
	CALL SUBOPT_0x106
_0x415:
	CALL SUBOPT_0x87
	CALL SUBOPT_0x105
	CALL __MODB21
	CALL SUBOPT_0x106
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDI  R30,LOW(0)
	ST   X,R30
	CALL __LOADLOCR3
	ADIW R28,15
	RET
__print_G2:
	SBIW R28,28
	CALL __SAVELOCR6
	LDI  R16,0
_0x416:
	LDD  R30,Y+38
	LDD  R31,Y+38+1
	ADIW R30,1
	STD  Y+38,R30
	STD  Y+38+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R19,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x418
	MOV  R30,R16
	CPI  R30,0
	BRNE _0x41C
	CPI  R19,37
	BRNE _0x41D
	LDI  R16,LOW(1)
	RJMP _0x41E
_0x41D:
	CALL SUBOPT_0x107
_0x41E:
	RJMP _0x41B
_0x41C:
	CPI  R30,LOW(0x1)
	BRNE _0x41F
	CPI  R19,37
	BRNE _0x420
	CALL SUBOPT_0x107
	LDI  R16,LOW(0)
	RJMP _0x41B
_0x420:
	LDI  R16,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+17,R30
	LDI  R17,LOW(0)
	CPI  R19,45
	BRNE _0x421
	LDI  R17,LOW(1)
	RJMP _0x41B
_0x421:
	CPI  R19,43
	BRNE _0x422
	LDI  R30,LOW(43)
	STD  Y+17,R30
	RJMP _0x41B
_0x422:
	CPI  R19,32
	BRNE _0x423
	LDI  R30,LOW(32)
	STD  Y+17,R30
	RJMP _0x41B
_0x423:
	RJMP _0x424
_0x41F:
	CPI  R30,LOW(0x2)
	BRNE _0x425
_0x424:
	LDI  R20,LOW(0)
	LDI  R16,LOW(3)
	CPI  R19,48
	BRNE _0x426
	ORI  R17,LOW(128)
	RJMP _0x41B
_0x426:
	RJMP _0x427
_0x425:
	CPI  R30,LOW(0x3)
	BRNE _0x428
_0x427:
	CPI  R19,48
	BRLO _0x42A
	CPI  R19,58
	BRLO _0x42B
_0x42A:
	RJMP _0x429
_0x42B:
	MOV  R26,R20
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOV  R30,R0
	MOV  R20,R30
	MOV  R30,R19
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x41B
_0x429:
	LDI  R21,LOW(0)
	CPI  R19,46
	BRNE _0x42C
	LDI  R16,LOW(4)
	RJMP _0x41B
_0x42C:
	RJMP _0x42D
_0x428:
	CPI  R30,LOW(0x4)
	BRNE _0x42F
	CPI  R19,48
	BRLO _0x431
	CPI  R19,58
	BRLO _0x432
_0x431:
	RJMP _0x430
_0x432:
	ORI  R17,LOW(32)
	MOV  R26,R21
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOV  R30,R0
	MOV  R21,R30
	MOV  R30,R19
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x41B
_0x430:
_0x42D:
	CPI  R19,108
	BRNE _0x433
	ORI  R17,LOW(2)
	LDI  R16,LOW(5)
	RJMP _0x41B
_0x433:
	RJMP _0x434
_0x42F:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x41B
_0x434:
	MOV  R30,R19
	CPI  R30,LOW(0x63)
	BRNE _0x439
	CALL SUBOPT_0x108
	LD   R30,X
	CALL SUBOPT_0x109
	RJMP _0x43A
_0x439:
	CPI  R30,LOW(0x45)
	BREQ _0x43D
	CPI  R30,LOW(0x65)
	BRNE _0x43E
_0x43D:
	RJMP _0x43F
_0x43E:
	CPI  R30,LOW(0x66)
	BREQ PC+3
	JMP _0x440
_0x43F:
	MOVW R30,R28
	ADIW R30,18
	STD  Y+10,R30
	STD  Y+10+1,R31
	CALL SUBOPT_0x108
	CALL __GETD1P
	__PUTD1S 6
	MOVW R26,R30
	MOVW R24,R22
	CALL __CPD20
	BRLT _0x441
	LDD  R26,Y+17
	CPI  R26,LOW(0x2B)
	BREQ _0x443
	RJMP _0x444
_0x441:
	__GETD1S 6
	CALL __ANEGF1
	CALL SUBOPT_0x10A
_0x443:
	SBRS R17,7
	RJMP _0x445
	LDD  R30,Y+17
	CALL SUBOPT_0x109
	RJMP _0x446
_0x445:
	CALL SUBOPT_0x10B
	LDD  R26,Y+17
	STD  Z+0,R26
_0x446:
_0x444:
	SBRS R17,5
	LDI  R21,LOW(5)
	CPI  R19,102
	BRNE _0x448
	CALL SUBOPT_0x10C
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ST   -Y,R31
	ST   -Y,R30
	CALL __ftoa_G2
	RJMP _0x449
_0x448:
	CALL SUBOPT_0x10C
	ST   -Y,R19
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ST   -Y,R31
	ST   -Y,R30
	CALL __ftoe_G2
_0x449:
	MOVW R30,R28
	ADIW R30,18
	CALL SUBOPT_0x10D
	RJMP _0x44A
_0x440:
	CPI  R30,LOW(0x73)
	BRNE _0x44C
	CALL SUBOPT_0x108
	CALL __GETW1P
	CALL SUBOPT_0x10D
	RJMP _0x44D
_0x44C:
	CPI  R30,LOW(0x70)
	BRNE _0x44F
	CALL SUBOPT_0x108
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOV  R16,R30
	ORI  R17,LOW(8)
_0x44D:
	ANDI R17,LOW(127)
	CPI  R21,0
	BREQ _0x451
	CP   R21,R16
	BRLO _0x452
_0x451:
	RJMP _0x450
_0x452:
	MOV  R16,R21
_0x450:
_0x44A:
	LDI  R21,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+16,R30
	LDI  R18,LOW(0)
	RJMP _0x453
_0x44F:
	CPI  R30,LOW(0x64)
	BREQ _0x456
	CPI  R30,LOW(0x69)
	BRNE _0x457
_0x456:
	ORI  R17,LOW(4)
	RJMP _0x458
_0x457:
	CPI  R30,LOW(0x75)
	BRNE _0x459
_0x458:
	LDI  R30,LOW(10)
	STD  Y+16,R30
	SBRS R17,1
	RJMP _0x45A
	__GETD1N 0x3B9ACA00
	__PUTD1S 12
	LDI  R16,LOW(10)
	RJMP _0x45B
_0x45A:
	__GETD1N 0x2710
	__PUTD1S 12
	LDI  R16,LOW(5)
	RJMP _0x45B
_0x459:
	CPI  R30,LOW(0x58)
	BRNE _0x45D
	ORI  R17,LOW(8)
	RJMP _0x45E
_0x45D:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x49C
_0x45E:
	LDI  R30,LOW(16)
	STD  Y+16,R30
	SBRS R17,1
	RJMP _0x460
	__GETD1N 0x10000000
	__PUTD1S 12
	LDI  R16,LOW(8)
	RJMP _0x45B
_0x460:
	__GETD1N 0x1000
	__PUTD1S 12
	LDI  R16,LOW(4)
_0x45B:
	CPI  R21,0
	BREQ _0x461
	ANDI R17,LOW(127)
	RJMP _0x462
_0x461:
	LDI  R21,LOW(1)
_0x462:
	SBRS R17,1
	RJMP _0x463
	CALL SUBOPT_0x108
	CALL __GETD1P
	RJMP _0x531
_0x463:
	SBRS R17,2
	RJMP _0x465
	CALL SUBOPT_0x108
	CALL __GETW1P
	CALL __CWD1
	RJMP _0x531
_0x465:
	CALL SUBOPT_0x108
	CALL __GETW1P
	CLR  R22
	CLR  R23
_0x531:
	__PUTD1S 6
	SBRS R17,2
	RJMP _0x467
	__GETD2S 6
	CALL __CPD20
	BRGE _0x468
	__GETD1S 6
	CALL __ANEGD1
	CALL SUBOPT_0x10A
_0x468:
	LDD  R30,Y+17
	CPI  R30,0
	BREQ _0x469
	SUBI R16,-LOW(1)
	SUBI R21,-LOW(1)
	RJMP _0x46A
_0x469:
	ANDI R17,LOW(251)
_0x46A:
_0x467:
	MOV  R18,R21
_0x453:
	SBRC R17,0
	RJMP _0x46B
_0x46C:
	CP   R16,R20
	BRSH _0x46F
	CP   R18,R20
	BRLO _0x470
_0x46F:
	RJMP _0x46E
_0x470:
	SBRS R17,7
	RJMP _0x471
	SBRS R17,2
	RJMP _0x472
	ANDI R17,LOW(251)
	LDD  R19,Y+17
	SUBI R16,LOW(1)
	RJMP _0x473
_0x472:
	LDI  R19,LOW(48)
_0x473:
	RJMP _0x474
_0x471:
	LDI  R19,LOW(32)
_0x474:
	CALL SUBOPT_0x107
	SUBI R20,LOW(1)
	RJMP _0x46C
_0x46E:
_0x46B:
_0x475:
	CP   R16,R21
	BRSH _0x477
	ORI  R17,LOW(16)
	SBRS R17,2
	RJMP _0x478
	ANDI R17,LOW(251)
	LDD  R30,Y+17
	CALL SUBOPT_0x109
	CPI  R20,0
	BREQ _0x479
	SUBI R20,LOW(1)
_0x479:
	SUBI R16,LOW(1)
	SUBI R21,LOW(1)
_0x478:
	LDI  R30,LOW(48)
	CALL SUBOPT_0x109
	CPI  R20,0
	BREQ _0x47A
	SUBI R20,LOW(1)
_0x47A:
	SUBI R21,LOW(1)
	RJMP _0x475
_0x477:
	MOV  R18,R16
	LDD  R30,Y+16
	CPI  R30,0
	BRNE _0x47B
_0x47C:
	CPI  R18,0
	BREQ _0x47E
	SBRS R17,3
	RJMP _0x47F
	CALL SUBOPT_0x10B
	LPM  R30,Z
	RJMP _0x532
_0x47F:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LD   R30,X+
	STD  Y+10,R26
	STD  Y+10+1,R27
_0x532:
	ST   -Y,R30
	LDD  R30,Y+35
	LDD  R31,Y+35+1
	ST   -Y,R31
	ST   -Y,R30
	CALL __put_G2
	CPI  R20,0
	BREQ _0x481
	SUBI R20,LOW(1)
_0x481:
	SUBI R18,LOW(1)
	RJMP _0x47C
_0x47E:
	RJMP _0x482
_0x47B:
_0x484:
	__GETD1S 12
	__GETD2S 6
	CALL __DIVD21U
	MOV  R19,R30
	CPI  R19,10
	BRLO _0x486
	SBRS R17,3
	RJMP _0x487
	SUBI R19,-LOW(55)
	RJMP _0x488
_0x487:
	SUBI R19,-LOW(87)
_0x488:
	RJMP _0x489
_0x486:
	SUBI R19,-LOW(48)
_0x489:
	SBRC R17,4
	RJMP _0x48B
	CPI  R19,49
	BRSH _0x48D
	__GETD2S 12
	__CPD2N 0x1
	BRNE _0x48C
_0x48D:
	RJMP _0x48F
_0x48C:
	CP   R21,R18
	BRLO _0x490
	LDI  R19,LOW(48)
	RJMP _0x48F
_0x490:
	CP   R20,R18
	BRLO _0x492
	SBRS R17,0
	RJMP _0x493
_0x492:
	RJMP _0x491
_0x493:
	LDI  R19,LOW(32)
	SBRS R17,7
	RJMP _0x494
	LDI  R19,LOW(48)
_0x48F:
	ORI  R17,LOW(16)
	SBRS R17,2
	RJMP _0x495
	ANDI R17,LOW(251)
	LDD  R30,Y+17
	CALL SUBOPT_0x109
	CPI  R20,0
	BREQ _0x496
	SUBI R20,LOW(1)
_0x496:
_0x495:
_0x494:
_0x48B:
	CALL SUBOPT_0x107
	CPI  R20,0
	BREQ _0x497
	SUBI R20,LOW(1)
_0x497:
_0x491:
	SUBI R18,LOW(1)
	__GETD1S 12
	__GETD2S 6
	CALL __MODD21U
	__PUTD1S 6
	LDD  R30,Y+16
	__GETD2S 12
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	__PUTD1S 12
	CALL __CPD10
	BREQ _0x485
	RJMP _0x484
_0x485:
_0x482:
	SBRS R17,0
	RJMP _0x498
_0x499:
	CPI  R20,0
	BREQ _0x49B
	SUBI R20,LOW(1)
	LDI  R30,LOW(32)
	CALL SUBOPT_0x109
	RJMP _0x499
_0x49B:
_0x498:
_0x49C:
_0x43A:
	LDI  R16,LOW(0)
_0x41B:
	RJMP _0x416
_0x418:
	CALL __LOADLOCR6
	ADIW R28,40
	RET
_printf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,2
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,0
	STD  Y+2,R30
	STD  Y+2+1,R30
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	CALL __print_G2
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	POP  R15
	RET
_allocate_block_G3:
	SBIW R28,2
	CALL __SAVELOCR6
	__GETWRN 16,17,2084
	MOVW R26,R16
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x4E6:
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x4E8
	MOVW R26,R16
	CALL __GETW1P
	ADD  R30,R16
	ADC  R31,R17
	ADIW R30,4
	MOVW R20,R30
	CALL SUBOPT_0x10E
	SBIW R30,0
	BREQ _0x4E9
	__PUTWSR 18,19,6
	RJMP _0x4EA
_0x4E9:
	LDI  R30,LOW(4352)
	LDI  R31,HIGH(4352)
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x4EA:
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
	BRLO _0x4EB
	MOVW R30,R20
	__PUTW1RNS 16,2
	MOVW R30,R18
	__PUTW1RNS 20,2
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	MOVW R26,R20
	ST   X+,R30
	ST   X,R31
	__ADDWRN 20,21,4
	MOVW R30,R20
	RJMP _0x4F9
_0x4EB:
	__MOVEWRR 16,17,18,19
	RJMP _0x4E6
_0x4E8:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x4F9:
	CALL __LOADLOCR6
	ADIW R28,10
	RET
_find_prev_block_G3:
	CALL __SAVELOCR4
	__GETWRN 16,17,2084
_0x4EC:
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x4EE
	CALL SUBOPT_0x10E
	MOVW R26,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x4EF
	MOVW R30,R16
	RJMP _0x4F8
_0x4EF:
	__MOVEWRR 16,17,18,19
	RJMP _0x4EC
_0x4EE:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x4F8:
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
	JMP _0x4F0
	SBIW R30,4
	MOVW R16,R30
	ST   -Y,R17
	ST   -Y,R16
	CALL _find_prev_block_G3
	MOVW R18,R30
	SBIW R30,0
	BREQ _0x4F1
	MOVW R26,R16
	ADIW R26,2
	CALL __GETW1P
	__PUTW1RNS 18,2
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SBIW R30,0
	BREQ _0x4F2
	ST   -Y,R31
	ST   -Y,R30
	CALL _allocate_block_G3
	MOVW R20,R30
	SBIW R30,0
	BREQ _0x4F3
	MOVW R26,R16
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	MOVW R26,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x4F4
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	STD  Y+8,R30
	STD  Y+8+1,R31
_0x4F4:
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
	MOVW R30,R20
	RJMP _0x4F7
_0x4F3:
	MOVW R30,R16
	__PUTW1RNS 18,2
_0x4F2:
_0x4F1:
_0x4F0:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x4F7:
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
	BREQ _0x4F5
	ST   -Y,R31
	ST   -Y,R30
	CALL _allocate_block_G3
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x4F6
	CALL SUBOPT_0xFA
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
_0x4F6:
_0x4F5:
	MOVW R30,R16
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
	CALL _realloc
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x0:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __MULW12U
	ADD  R30,R22
	ADC  R31,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1:
	CALL __FF_spi
	LDD  R26,Y+14
	CLR  R27
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES
SUBOPT_0x4:
	CALL __FF_spi
	LDI  R30,LOW(255)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 33 TIMES
SUBOPT_0xC:
	CALL __PUTPARD1
	CALL __FF_read
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xD:
	CALL _printf
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
	MOVW R30,R6
	CLR  R22
	CLR  R23
	CALL __MULD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0xF:
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	CLR  R22
	CLR  R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x11:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __LSLD16
	CALL __ORD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x12:
	CLR  R31
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(8)
	CALL __LSLD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x13:
	SBIW R30,1
	MOVW R26,R30
	MOVW R30,R6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x14:
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	CALL _send_cmd
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x15:
	LDI  R30,LOW(80)
	OUT  0xD,R30
	LDI  R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x16:
	CALL _printf
	ADIW R28,2
	LDI  R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x17:
	LDI  R30,LOW(4)
	STS  __FF_error,R30
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x18:
	CALL _clear_sd_buff
	LDI  R30,LOW(7)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x19:
	CALL __PUTPARD1
	CALL _send_cmd
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1A:
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	LD   R30,Z
	CLR  R31
	CLR  R22
	CLR  R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1B:
	MOVW R30,R6
	__GETD2S 5
	CLR  R22
	CLR  R23
	CALL __MODD21U
	CALL __CPD10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1C:
	LDI  R30,LOW(3)
	STS  __FF_error,R30
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x1D:
	LD   R30,X
	ST   -Y,R30
	CALL _valid_file_char
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1E:
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
SUBOPT_0x1F:
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	__GETD1N 0x0
	CALL __PUTDP1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x20:
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	ADIW R30,1
	STD  Y+31,R30
	STD  Y+31+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x21:
	MOVW R30,R6
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
SUBOPT_0x22:
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	MOVW R30,R6
	CLR  R22
	CLR  R23
	CALL __MULD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES
SUBOPT_0x23:
	MOVW R30,R20
	LSL  R30
	ROL  R31
	CALL __LSLW4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x24:
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1S 25
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x25:
	__GETD1S 25
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __PUTDP1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x26:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x27:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _next_cluster

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x28:
	LDS  R30,__FF_ROOT_ADDR
	LDS  R31,__FF_ROOT_ADDR+1
	LDS  R22,__FF_ROOT_ADDR+2
	LDS  R23,__FF_ROOT_ADDR+3
	LDS  R26,__FF_DIR_ADDR
	LDS  R27,__FF_DIR_ADDR+1
	LDS  R24,__FF_DIR_ADDR+2
	LDS  R25,__FF_DIR_ADDR+3
	CALL __CPD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x29:
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	SUBI R30,LOW(-__FF_FULL_PATH)
	SBCI R31,HIGH(-__FF_FULL_PATH)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2A:
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	ADIW R30,1
	STD  Y+22,R30
	STD  Y+22+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x2B:
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	LD   R30,Z
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x2C:
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	LD   R30,Z
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x2D:
	CLR  R22
	CLR  R23
	__PUTD1S 14
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2E:
	LDI  R30,LOW(10)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(13)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2F:
	LD   R30,Z
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __ORD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES
SUBOPT_0x30:
	LD   R31,Z
	LDI  R30,LOW(0)
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES
SUBOPT_0x31:
	LD   R30,Z
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x32:
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _clust_to_addr
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x33:
	CALL __MULD12
	LDS  R26,__FF_PART_ADDR
	LDS  R27,__FF_PART_ADDR+1
	LDS  R24,__FF_PART_ADDR+2
	LDS  R25,__FF_PART_ADDR+3
	CALL __ADDD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x34:
	MOVW R30,R6
	__GETD2S 0
	CLR  R22
	CLR  R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x35:
	MOVW R30,R6
	LSR  R31
	ROR  R30
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x36:
	CALL __DIVW21U
	ADD  R30,R9
	ADC  R31,R10
	MOVW R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x37:
	CALL __MODW21U
	LSL  R30
	ROL  R31
	MOVW R18,R30
	MOVW R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x38:
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
SUBOPT_0x39:
	LDS  R30,__FF_buff_addr
	LDS  R31,__FF_buff_addr+1
	LDS  R22,__FF_buff_addr+2
	LDS  R23,__FF_buff_addr+3
	__GETD2S 6
	CALL __CPD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x3A:
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
SUBOPT_0x3B:
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
SUBOPT_0x3C:
	LDS  R30,__FF_buff_addr
	LDS  R31,__FF_buff_addr+1
	LDS  R22,__FF_buff_addr+2
	LDS  R23,__FF_buff_addr+3
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x3D:
	LDI  R26,LOW(__FF_buff)
	LDI  R27,HIGH(__FF_buff)
	ADD  R26,R18
	ADC  R27,R19
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3E:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __MULW12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3F:
	MOVW R30,R6
	MOVW R26,R18
	RJMP SUBOPT_0x36

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x40:
	MOVW R30,R6
	MOVW R26,R18
	CALL __MODW21U
	MOVW R18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x41:
	MOVW R30,R6
	SBIW R30,1
	CP   R30,R18
	CPC  R31,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x42:
	MOV  R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0x43:
	LD   R30,X
	ST   -Y,R30
	JMP  _toupper

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x44:
	LDI  R31,0
	SUBI R30,LOW(-_FILENAME)
	SBCI R31,HIGH(-_FILENAME)
	MOVW R26,R30
	LDI  R30,LOW(32)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x45:
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	__GETD2S 9
	CLR  R22
	CLR  R23
	CALL __CPD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x46:
	LDI  R30,LOW(13)
	STS  __FF_error,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x47:
	__GETD1S 5
	__ADDD1N 512
	__PUTD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x48:
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ADIW R30,1
	STD  Y+15,R30
	STD  Y+15+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x49:
	LDI  R30,LOW(0)
	__GETD2S 9
	CLR  R22
	CLR  R23
	CALL __ORD12
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4A:
	MOVW R30,R6
	LSR  R31
	ROR  R30
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4B:
	__PUTD1S 11
	LDD  R26,Y+15
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4C:
	LDS  R30,__FF_buff_addr
	LDS  R31,__FF_buff_addr+1
	LDS  R22,__FF_buff_addr+2
	LDS  R23,__FF_buff_addr+3
	__GETD2S 11
	CALL __CPD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x4D:
	ST   X,R30
	LDD  R26,Y+15
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES
SUBOPT_0x4E:
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
SUBOPT_0x4F:
	__GETD1S 11
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x50:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __MULW12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x51:
	ANDI R30,LOW(0xF)
	MOV  R20,R30
	CLR  R21
	MOVW R30,R18
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	MOVW R0,R30
	LDD  R30,Y+6
	SWAP R30
	ANDI R30,0xF0
	MOVW R26,R20
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x52:
	MOVW R30,R6
	__GETD2S 11
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1S 11
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x53:
	LDD  R30,Y+8
	SWAP R30
	ANDI R30,0xF0
	LDD  R26,Y+7
	OR   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x54:
	STS  __FF_buff,R30
	LDD  R26,Y+15
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x55:
	MOVW R30,R18
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	MOVW R0,R30
	LDD  R30,Y+7
	SWAP R30
	ANDI R30,0xF0
	LDD  R26,Y+6
	OR   R30,R26
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x56:
	ANDI R30,LOW(0xF0)
	MOV  R20,R30
	CLR  R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x57:
	LDD  R30,Y+8
	MOVW R26,R20
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x58:
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	__GETD2Z 22
	CALL __PUTPARD2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x59:
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	ADIW R26,26
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5A:
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	ADIW R26,12
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5B:
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
SUBOPT_0x5C:
	CALL __SAVELOCR4
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5D:
	ST   -Y,R19
	ST   -Y,R18
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _next_cluster

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5E:
	ST   -Y,R19
	ST   -Y,R18
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5F:
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _write_clus_table
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x60:
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _write_clus_table
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x61:
	MOVW R26,R30
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES
SUBOPT_0x62:
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x63:
	LDI  R30,LOW(3)
	STS  __FF_error,R30
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x64:
	MOVW R26,R18
	LD   R26,X
	CPI  R26,LOW(0x5C)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x65:
	MOVW R26,R18
	LD   R30,X
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x66:
	MOVW R26,R18
	LD   R26,X
	CPI  R26,LOW(0x2E)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES
SUBOPT_0x67:
	MOVW R26,R16
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x68:
	ST   -Y,R31
	ST   -Y,R30
	CALL __FF_chdir
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x69:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,12
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES
SUBOPT_0x6A:
	ST   -Y,R31
	ST   -Y,R30
	CALL __FF_checkdir
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES
SUBOPT_0x6B:
	__GETD1S 10
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6C:
	ST   -Y,R31
	ST   -Y,R30
	CALL _scan_directory
	STD  Y+14,R30
	STD  Y+14+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x6D:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _prev_cluster

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6E:
	MOVW R30,R6
	__GETD2S 6
	CLR  R22
	CLR  R23
	CALL __MODD21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6F:
	__GETD2S 6
	CLR  R22
	CLR  R23
	CALL __SUBD21
	__PUTD2S 6
	__GETD1S 6
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x70:
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R26,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x71:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x72:
	LDI  R26,LOW(__FF_buff)
	LDI  R27,HIGH(__FF_buff)
	ADD  R26,R20
	ADC  R27,R21
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x73:
	LDI  R26,LOW(__FF_buff)
	LDI  R27,HIGH(__FF_buff)
	ADD  R26,R20
	ADC  R27,R21
	LDI  R30,LOW(32)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x74:
	CLR  R22
	CLR  R23
	__GETD2N 0x200
	CALL __MULD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x75:
	MOVW R26,R16
	LD   R30,X
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x76:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,7
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x77:
	__GETD1S 5
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x78:
	LDI  R30,LOW(__FF_FULL_PATH)
	LDI  R31,HIGH(__FF_FULL_PATH)
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	SUBI R30,LOW(-__FF_FULL_PATH)
	SBCI R31,HIGH(-__FF_FULL_PATH)
	MOVW R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x79:
	MOVW R30,R18
	LDD  R30,Z+1
	CPI  R30,LOW(0x2E)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x7A:
	LDI  R30,LOW(__FF_FULL_PATH)
	LDI  R31,HIGH(__FF_FULL_PATH)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(92)
	ST   -Y,R30
	JMP  _strrpos

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x7B:
	LDI  R31,0
	SUBI R30,LOW(-__FF_FULL_PATH)
	SBCI R31,HIGH(-__FF_FULL_PATH)
	RJMP SUBOPT_0x61

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x7C:
	LDI  R31,0
	SBRC R30,7
	SER  R31
	STD  Y+13,R30
	STD  Y+13+1,R31
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	CPI  R26,LOW(0xFFFF)
	LDI  R30,HIGH(0xFFFF)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x7D:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	SUBI R30,LOW(-__FF_FULL_PATH)
	SBCI R31,HIGH(-__FF_FULL_PATH)
	MOVW R16,R30
	RJMP SUBOPT_0x67

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x7E:
	LDI  R30,LOW(92)
	ST   X,R30
	RJMP SUBOPT_0x67

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x7F:
	MOVW R26,R18
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x80:
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
	JMP  __FF_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x81:
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	LSL  R30
	ROL  R31
	CALL __LSLW4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x82:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	MOVW R26,R28
	ADIW R26,19
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x83:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADD  R30,R26
	ADC  R31,R27
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x84:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ADIW R30,1
	STD  Y+13,R30
	STD  Y+13+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x85:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  _clust_to_addr

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x86:
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ADIW R30,1
	STD  Y+11,R30
	STD  Y+11+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x87:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x88:
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
	RJMP SUBOPT_0x6A

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES
SUBOPT_0x89:
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x8A:
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
	MOVW R18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x8B:
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x8C:
	MOVW R30,R6
	__GETD2S 8
	CLR  R22
	CLR  R23
	CALL __MODD21U
	MOVW R20,R30
	MOVW R30,R20
	__GETD2S 8
	CLR  R22
	CLR  R23
	CALL __SUBD21
	__PUTD2S 8
	__GETD1S 8
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x8D:
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
SUBOPT_0x8E:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _free
	RJMP SUBOPT_0x89

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x8F:
	MOVW R30,R20
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	STD  Y+18,R30
	STD  Y+18+1,R31
	MOV  R0,R18
	OR   R0,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x90:
	LDI  R30,LOW(11)
	STS  __FF_error,R30
	RJMP SUBOPT_0x8E

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x91:
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x92:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,12
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x93:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,18
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x94:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	__GETD1N 0x0
	CALL __PUTDP1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x95:
	MOVW R30,R20
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	ADIW R30,31
	STD  Y+18,R30
	STD  Y+18+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x96:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	SBIW R26,1
	STD  Y+18,R26
	STD  Y+18+1,R27
	ADIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x97:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	CALL __GETD1P
	CALL __CPD10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x98:
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
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x99:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+12
	LDD  R27,Z+13
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES
SUBOPT_0x9A:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+14
	LDD  R27,Z+15
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x9B:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _next_cluster

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x9C:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,20
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0x9D:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,28
	ADD  R30,R16
	ADC  R31,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x9E:
	MOVW R0,R30
	LDI  R26,LOW(__FF_buff)
	LDI  R27,HIGH(__FF_buff)
	RJMP SUBOPT_0x91

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x9F:
	LDI  R30,LOW(5)
	STS  __FF_error,R30
	RJMP SUBOPT_0x89

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xA0:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES
SUBOPT_0xA1:
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
SUBOPT_0xA2:
	STS  __FF_error,R30
	__GETD1S 8
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xA3:
	MOVW R30,R6
	__GETD2S 4
	CLR  R22
	CLR  R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xA4:
	LDI  R30,LOW(4)
	STS  __FF_error,R30
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xA5:
	LDI  R30,LOW(5)
	STS  __FF_error,R30
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xA6:
	STS  __FF_error,R30
	__GETD1S 25
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xA7:
	LDS  R30,__FF_DIR_ADDR
	LDS  R31,__FF_DIR_ADDR+1
	LDS  R22,__FF_DIR_ADDR+2
	LDS  R23,__FF_DIR_ADDR+3
	__PUTD1S 21
	MOVW R30,R28
	ADIW R30,21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xA8:
	__GETD1S 25
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
	LDI  R30,LOW(16)
	STS  __FF_error,R30
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xA9:
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0xAA:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-548)
	SBCI R27,HIGH(-548)
	LD   R26,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xAB:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,20
	CALL __GETW1P
	RJMP SUBOPT_0x13

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0xAC:
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xAD:
	MOVW R26,R16
	SUBI R26,LOW(-__FF_buff)
	SBCI R27,HIGH(-__FF_buff)
	RJMP SUBOPT_0x9D

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xAE:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _append_toc
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xAF:
	SUBI R26,LOW(-548)
	SBCI R27,HIGH(-548)
	LD   R26,X
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xB0:
	LD   R30,Y
	LDD  R31,Y+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  _free

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xB1:
	STD  Y+5,R30
	STD  Y+5+1,R31
	ADIW R30,1
	STD  Y+5,R30
	STD  Y+5+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0xB2:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	LDI  R30,LOW(5)
	CALL __LSRW12
	__ANDD1N 0xF
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0xA
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES
SUBOPT_0xB3:
	ST   X,R30
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	ADIW R30,1
	STD  Y+5,R30
	STD  Y+5+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0xB4:
	ST   X,R30
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	ADIW R26,1
	STD  Y+5,R26
	STD  Y+5+1,R27
	SBIW R26,1
	LDI  R30,LOW(47)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0xB5:
	__GETD1S 9
	__ANDD1N 0x1F
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0xA
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xB6:
	ST   X,R30
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	LDI  R30,LOW(9)
	CALL __LSRW12
	__ANDD1N 0x7F
	__ADDD1N 1980
	__PUTD1S 9
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	ADIW R30,1
	STD  Y+5,R30
	STD  Y+5+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xB7:
	__GETD2S 9
	__GETD1N 0x3E8
	CALL __DIVD21U
	__ADDD1N 48
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xB8:
	ST   X,R30
	__GETD2S 9
	__GETD1N 0x3E8
	CALL __MODD21U
	__PUTD1S 9
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	ADIW R30,1
	STD  Y+5,R30
	STD  Y+5+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xB9:
	__GETD2S 9
	__GETD1N 0x64
	CALL __DIVD21U
	__ADDD1N 48
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xBA:
	ST   X,R30
	__GETD2S 9
	__GETD1N 0x64
	CALL __MODD21U
	__PUTD1S 9
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	ADIW R30,1
	STD  Y+5,R30
	STD  Y+5+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xBB:
	__GETD2S 9
	__GETD1N 0xA
	CALL __DIVD21U
	__ADDD1N 48
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xBC:
	__GETD2S 9
	__GETD1N 0xA
	CALL __MODD21U
	__ADDD1N 48
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0xBD:
	ST   X,R30
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	ADIW R26,1
	STD  Y+5,R26
	STD  Y+5+1,R27
	SBIW R26,1
	LDI  R30,LOW(32)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xBE:
	__PUTD1S 9
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	ADIW R30,1
	STD  Y+5,R30
	STD  Y+5+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0xBF:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	LDI  R30,LOW(11)
	CALL __LSRW12
	__ANDD1N 0x1F
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0xA
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0xC0:
	ST   X,R30
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	ADIW R26,1
	STD  Y+5,R26
	STD  Y+5+1,R27
	SBIW R26,1
	LDI  R30,LOW(58)
	RJMP SUBOPT_0xB3

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0xC1:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	LDI  R30,LOW(5)
	CALL __LSRW12
	__ANDD1N 0x3F
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0xA
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0xC2:
	__GETD1S 9
	__ANDD1N 0x1F
	LSL  R30
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0xA
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xC3:
	ST   X,R30
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xC4:
	LDI  R30,LOW(2)
	STS  __FF_error,R30
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xC5:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	SUBI R26,LOW(-544)
	SBCI R27,HIGH(-544)
	CALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xC6:
	SUBI R26,LOW(-549)
	SBCI R27,HIGH(-549)
	LDI  R30,LOW(10)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xC7:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	SUBI R26,LOW(-551)
	SBCI R27,HIGH(-551)
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xC8:
	ADIW R26,28
	MOVW R30,R6
	SBIW R30,1
	ADD  R30,R26
	ADC  R31,R27
	CP   R30,R0
	CPC  R31,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xC9:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	SUBI R26,LOW(-548)
	SBCI R27,HIGH(-548)
	LD   R26,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xCA:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,28
	ADD  R30,R17
	ADC  R31,R18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xCB:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R26,Z+14
	LDD  R27,Z+15
	ST   -Y,R27
	ST   -Y,R26
	JMP  _clust_to_addr

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xCC:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ADIW R26,20
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xCD:
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1S 3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xCE:
	LDD  R26,Z+20
	LDD  R27,Z+21
	MOV  R30,R8
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xCF:
	LDD  R26,Z+20
	LDD  R27,Z+21
	MOVW R30,R6
	CALL __MULW12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xD0:
	SUBI R26,LOW(-550)
	SBCI R27,HIGH(-550)
	LDI  R30,LOW(1)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xD1:
	__SUBD1N -1
	CALL __PUTDP1
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xD2:
	ADIW R26,20
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES
SUBOPT_0xD3:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-544)
	SBCI R27,HIGH(-544)
	CALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES
SUBOPT_0xD4:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	CALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xD5:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-550)
	SBCI R27,HIGH(-550)
	LD   R30,X
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xD6:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-550)
	SBCI R27,HIGH(-550)
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES
SUBOPT_0xD7:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-551)
	SBCI R27,HIGH(-551)
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xD8:
	LDD  R26,Y+8
	STD  Z+0,R26
	RJMP SUBOPT_0xD7

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xD9:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,20
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0xDA:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,14
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xDB:
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xDC:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,16
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xDD:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Z+16
	LDD  R27,Z+17
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xDE:
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _write_clus_table
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xDF:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	CALL __GETD1P
	__GETD2S 13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xE0:
	LDI  R30,LOW(10)
	STS  __FF_error,R30
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xE1:
	MOVW R30,R6
	__GETD2S 8
	CLR  R22
	CLR  R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xE2:
	CALL __GETW1P
	ADIW R30,1
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xE3:
	LD   R26,Y
	LDD  R27,Y+1
	SUBI R26,LOW(-544)
	SBCI R27,HIGH(-544)
	CALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xE4:
	LD   R30,X
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0xE5:
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xE6:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,__FF_error
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xE7:
	CALL _getchar
	MOV  R16,R30
	ST   -Y,R16
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xE8:
	ST   -Y,R16
	CALL _ascii_to_char
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES
SUBOPT_0xE9:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xEA:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _print_result

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES
SUBOPT_0xEB:
	CALL _printf
	ADIW R28,2
	MOVW R30,R28
	ADIW R30,59
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES
SUBOPT_0xEC:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	ST   -Y,R31
	ST   -Y,R30
	CALL _get_input_str
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0xED:
	CALL _printf
	ADIW R28,2
	LDS  R30,_file1
	LDS  R31,_file1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES
SUBOPT_0xEE:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _print_result

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xEF:
	CALL _printf
	ADIW R28,2
	JMP  _flush_receive

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xF0:
	MOVW R30,R28
	SUBI R30,LOW(-(83))
	SBCI R31,HIGH(-(83))
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	ST   -Y,R31
	ST   -Y,R30
	CALL _get_input_str
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xF1:
	CALL _getchar
	MOV  R18,R30
	CLR  R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xF2:
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 13
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xF3:
	CALL _printf
	ADIW R28,2
	JMP  _getchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xF4:
	CALL _printf
	ADIW R28,2
	LDI  R30,LOW(7)
	ST   -Y,R30
	JMP  _get_addr_entry

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xF5:
	CALL _printf
	ADIW R28,2
	LDI  R30,LOW(4)
	ST   -Y,R30
	JMP  _get_addr_entry

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xF6:
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 6
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xF7:
	CALL _getchar
	MOV  R16,R30
	CLR  R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xF8:
	LDS  R30,_file1
	LDS  R31,_file1+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _fgetc
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xF9:
	ST   -Y,R30
	LDS  R30,_file1
	LDS  R31,_file1+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  _ungetc

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xFA:
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0xFB:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xFC:
	__GETD1N 0x41200000
	CALL __DIVF21
	__GETD2N 0x3F000000
	CALL __ADDF12
	CALL __PUTPARD1
	JMP  _floor

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xFD:
	CALL __DIVF21
	CALL __CFD1
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xFE:
	MOV  R30,R17
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xFF:
	CALL __SWAPD12
	CALL __SUBF12
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x100:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x101:
	__GETD2S 3
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x102:
	__GETD1S 3
	__GETD2S 11
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x103:
	__GETD2S 11
	__GETD1N 0x41200000
	CALL __DIVF21
	__PUTD1S 11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x104:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ADIW R26,1
	STD  Y+7,R26
	STD  Y+7+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x105:
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R18
	LDI  R30,LOW(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x106:
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x107:
	ST   -Y,R19
	LDD  R30,Y+35
	LDD  R31,Y+35+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G2

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES
SUBOPT_0x108:
	LDD  R26,Y+36
	LDD  R27,Y+36+1
	SBIW R26,4
	STD  Y+36,R26
	STD  Y+36+1,R27
	ADIW R26,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0x109:
	ST   -Y,R30
	LDD  R30,Y+35
	LDD  R31,Y+35+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x10A:
	__PUTD1S 6
	LDI  R30,LOW(45)
	STD  Y+17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x10B:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,1
	STD  Y+10,R30
	STD  Y+10+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x10C:
	__GETD1S 6
	CALL __PUTPARD1
	ST   -Y,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x10D:
	STD  Y+10,R30
	STD  Y+10+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x10E:
	MOVW R26,R16
	ADIW R26,2
	CALL __GETW1P
	MOVW R18,R30
	RET

_isspace:
	ldi  r30,1
	ld   r31,y+
	cpi  r31,' '
	breq __isspace1
	cpi  r31,9
	brlo __isspace0
	cpi  r31,14
	brlo __isspace1
__isspace0:
	clr  r30
__isspace1:
	ret

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

_puts:
	ld   r30,y+
	ld   r31,y+
__puts0:
	ld   r22,z+
	tst  r22
	breq __puts1
	push r30
	push r31
	rcall __puts2
	pop  r31
	pop  r30
	rjmp __puts0
__puts1:
	ldi  r22,10
__puts2:
	st   -y,r22
	jmp _putchar

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

_strpbrkf:
	ldd  r27,y+3
	ldd  r26,y+2
__strpbrkf0:
	ld   r22,x
	tst  r22
	breq __strpbrkf2
	ldd  r31,y+1
	ld   r30,y
__strpbrkf1:
	lpm 
	tst  r0
	breq __strpbrkf3
	adiw r30,1
	cp   r22,r0
	brne __strpbrkf1
	movw r30,r26
	rjmp __strpbrkf4
__strpbrkf3:
	adiw r26,1
	rjmp __strpbrkf0
__strpbrkf2:
	clr  r30
	clr  r31
__strpbrkf4:
	adiw r28,4
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

__ftrunc:
	ldd  r23,y+3
	ldd  r22,y+2
	ldd  r31,y+1
	ld   r30,y
	bst  r23,7
	lsl  r23
	sbrc r22,7
	sbr  r23,1
	mov  r25,r23
	subi r25,0x7e
	breq __ftrunc0
	brcs __ftrunc0
	cpi  r25,24
	brsh __ftrunc1
	clr  r26
	clr  r27
	clr  r24
__ftrunc2:
	sec
	ror  r24
	ror  r27
	ror  r26
	dec  r25
	brne __ftrunc2
	and  r30,r26
	and  r31,r27
	and  r22,r24
	rjmp __ftrunc1
__ftrunc0:
	clt
	clr  r23
	clr  r30
	clr  r31
	clr  r22
__ftrunc1:
	cbr  r22,0x80
	lsr  r23
	brcc __ftrunc3
	sbr  r22,0x80
__ftrunc3:
	bld  r23,7
	ld   r26,y+
	ld   r27,y+
	ld   r24,y+
	ld   r25,y+
	cp   r30,r26
	cpc  r31,r27
	cpc  r22,r24
	cpc  r23,r25
	bst  r25,7
	ret

_floor:
	rcall __ftrunc
	brne __floor1
__floor0:
	ret
__floor1:
	brtc __floor0
	ldi  r25,0xbf

__addfc:
	clr  r26
	clr  r27
	ldi  r24,0x80
	rjmp __addf12

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

__SUBD21:
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	RET

__ORD12:
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	RET

__ANEGW1:
	COM  R30
	COM  R31
	ADIW R30,1
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

__LSRW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSRW12R
__LSRW12L:
	LSR  R31
	ROR  R30
	DEC  R0
	BRNE __LSRW12L
__LSRW12R:
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

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__LNEGB1:
	TST  R30
	LDI  R30,1
	BREQ __LNEGB1F
	CLR  R30
__LNEGB1F:
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

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
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

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
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

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
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

__GETD1PF:
	LPM  R0,Z+
	LPM  R1,Z+
	LPM  R22,Z+
	LPM  R23,Z
	MOVW R30,R0
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

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	MOV  R21,R30
	MOV  R30,R26
	MOV  R26,R21
	MOV  R21,R31
	MOV  R31,R27
	MOV  R27,R21
	MOV  R21,R22
	MOV  R22,R24
	MOV  R24,R21
	MOV  R21,R23
	MOV  R23,R25
	MOV  R25,R21
	MOV  R21,R0
	MOV  R0,R1
	MOV  R1,R21
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF129
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,24
__MULF120:
	LSL  R19
	ROL  R20
	ROL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	BRCC __MULF121
	ADD  R19,R26
	ADC  R20,R27
	ADC  R21,R24
	ADC  R30,R1
	ADC  R31,R1
	ADC  R22,R1
__MULF121:
	DEC  R25
	BRNE __MULF120
	POP  R20
	POP  R19
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __REPACK
	POP  R21
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __MAXRES
	RJMP __MINRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	LSR  R22
	ROR  R31
	ROR  R30
	LSR  R24
	ROR  R27
	ROR  R26
	PUSH R20
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R25,24
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R1
	ROL  R20
	ROL  R21
	ROL  R26
	ROL  R27
	ROL  R24
	DEC  R25
	BRNE __DIVF212
	MOV  R30,R1
	MOV  R31,R20
	MOV  R22,R21
	LSR  R26
	ADC  R30,R25
	ADC  R31,R25
	ADC  R22,R25
	POP  R20
	TST  R22
	BRMI __DIVF215
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

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
