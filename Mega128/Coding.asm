;CodeVisionAVR C Compiler V1.24.7e Professional
;(C) Copyright 1998-2005 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega128
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int
;(s)scanf features      : int, width
;External SRAM size     : 0
;Data Stack size        : 640 byte(s)
;Heap size              : 1200 byte(s)
;Promote char to int    : No
;char is unsigned       : Yes
;8 bit enums            : Yes
;Word align FLASH struct: No
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

	.INCLUDE "Coding.vec"
	.INCLUDE "Coding.inc"

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
	LDI  R24,LOW(0xB50)
	LDI  R25,HIGH(0xB50)
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
	LDI  R30,LOW(0xC4F)
	OUT  SPL,R30
	LDI  R30,HIGH(0xC4F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x380)
	LDI  R29,HIGH(0x380)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x380
;       1 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;       2 // Управляющая программа 
;       3 //  Подчиненные устройства сами сообщают о своем состоянии.
;       4 
;       5 #include "Coding.h"
;       6 
;       7 #ifdef print
;       8 const flash unsigned long update_program_ser_num = 0;			// номер устройства, в кот. работает закрытие
;       9 #else 
;      10 const flash unsigned long update_program_ser_num = 9;			// номер устройства, в кот. работает закрытие

	.CSEG
;      11 #endif
;      12 
;      13 flash u8 device_name[32] =	"Scrambling Device";       	// Имя устройства                                                  
;      14 const flash unsigned short my_version = 0x0209;			// Версия софта 
;      15 eeprom unsigned char my_addr = TO_MON;					// Мой адрес - изначально TO_MON

	.ESEG
_my_addr:
	.DB  0xFE
;      16 eeprom unsigned long my_ser_num = 0;				// Серийный номер устройства
_my_ser_num:
	.DW  0x0
	.DW  0x0
;      17 
;      18 
;      19 eeprom u8 f_buff_prog[len_prog_bin] = {0x01,0xff,0x7f};		// храним копию файла prog (+1 т.к. храню еще 1-й байт)
_f_buff_prog:
	.DB  0x1
	.DB  0xFF
	.DB  0x7F
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
;      20 u8	eeprom *eefprog = 0;
;      21 
;      22 u8 txBuffer 			[TWI_BUFFER_SIZE];			//буфер передатчика TWI

	.DSEG
_txBuffer:
	.BYTE 0xFF
;      23 u8 buff_wyh_paket	[TWI_BUFFER_SIZE];			//буфер для генерации выходного пакета
_buff_wyh_paket:
	.BYTE 0xFF
;      24 u8 rxBuffer 			[TWI_BUFFER_SIZE / 2];		//буфер приемника TWI
_rxBuffer:
	.BYTE 0x7F
;      25 
;      26 
;      27 flash u8 int_Devices		=	8;	//8			// количество подчиненных устройств

	.CSEG
;      28 u8 lAddrDevice	[16];				// храним лог. адреса подключенных устройств

	.DSEG
_lAddrDevice:
	.BYTE 0x10
;      29 											// 0 ячейка - кол-во портов 232 .1 ячейка содержит лог. адрес порта 1, 2-лог.
;      30 											// адрес порта 2 и т. д.  
;      31 
;      32 u8 counter_ciklov = 0;
;      33 u8 Combine_Responce_GEN_CALL = 0;	// собираем ответы при GEN CALL
;      34 u8 reflection_active_PORTS	=	0;			// зеркало портов (1-активен, 0 - не активен)
;      35 
;      36 bit EndTimePack = 0;				// таймаут передачи пакетов закрытия
;      37 bit intScremblerON	=	0;			// работает внутренний скремблер
;      38 bit CF_card_INI_OK	=	0;			// признак удачно проинициализированной CF карты
;      39 bit prog_bin_mode		=	0;			// режим открытого prog.bin файла 0-rd_file; 1-wr_file
;      40 
;      41 
;      42 strInPack * str = (strInPack *)(rx0buf);
;      43 strDataPack * str1 = (strDataPack *)(rx0buf);
;      44 
;      45 // Указатели для CRYPT
;      46 //FILE * fu;				//обьявляется переменная для указателя входного файла s userami
;      47 FILE * fprog;			//обьявляется переменная для указателя входного файла s programmami
;      48 FILE * fprogflas;
_fprogflas:
	.BYTE 0x2
;      49 
;      50 
;      51 #ifdef print_from_pin
;      52 #define _ALTERNATE_PUTCHAR_
;      53 void putchar(char c)
;      54 {
;      55 	putchar2 (c);
;      56 }               
;      57 #endif
;      58 
;      59 
;      60 
;      61 
;      62 
;      63 
;      64 typedef struct _chip_port
;      65 {
;      66 	flash char name[16];
;      67 	flash unsigned char addr;
;      68 } CHIPPORT;
;      69 
;      70 CHIPPORT cp[] = {"Port  RS-232 №", 0};
_cp:
_0cp:
	.BYTE 0x10
_1cp:
	.BYTE 0x1
;      71 
;      72 // Все для работы с TWI
;      73 TWISR TWI_statusReg;   
_TWI_statusReg:
	.BYTE 0x1
;      74 unsigned char  TWI_operation=0;
_TWI_operation:
	.BYTE 0x1
;      75 
;      76 //unsigned char TWI_targetSlaveAddress;
;      77 
;      78 //-----------------------------------------------------------------------------------------------------------------
;      79 // Возвращаю состояние устройства
;      80 static void GetState(void)
;      81 {

	.CSEG
_GetState_G1:
;      82 	register unsigned char i, n, b;
;      83 	
;      84 	#define strq  ((RQ_GETSTATE *)rx0buf)
;      85 
;      86 	switch(strq->page)
	CALL __SAVELOCR3
;	i -> R16
;	n -> R17
;	b -> R18
	LDS  R30,_rx0buf
;      87 	{
;      88 	case 0:
	CPI  R30,0
	BRNE _0x9
;      89 		StartReply(2 + 16 + 1);
	LDI  R30,LOW(19)
	ST   -Y,R30
	RCALL _StartReply
;      90 
;      91 		putchar0(2);               						 // число доступных страниц, включая эту
	LDI  R30,LOW(2)
	CALL SUBOPT_0x0
;      92 		putchar0(0);										// зарезервирован
;      93 		
;      94 
;      95 			for (i = 0; i < 15; i ++)
	LDI  R16,LOW(0)
_0xB:
	CPI  R16,15
	BRSH _0xC
;      96 			{
;      97 				b = cp[0].name[i];
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_cp)
	SBCI R31,HIGH(-_cp)
	LD   R18,Z
;      98 				if (!b)	break;
	CPI  R18,0
	BREQ _0xC
;      99 				putchar0(b);
	ST   -Y,R18
	RCALL _putchar0
;     100 			}
	SUBI R16,-1
	RJMP _0xB
_0xC:
;     101 				
;     102 
;     103 			while(i < 15)
_0xE:
	CPI  R16,15
	BRSH _0x10
;     104 			{
;     105 				putchar0(' ');
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL _putchar0
;     106 				i++;
	SUBI R16,-1
;     107 			}
	RJMP _0xE
_0x10:
;     108 			
;     109 			putchar0(cp[n].addr);
	MOV  R26,R17
	CLR  R27
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	CALL __MULW12U
	__POINTW2MN _cp,16
	CALL SUBOPT_0x1
	RCALL _putchar0
;     110 		
;     111 		putchar0(255);
	CALL SUBOPT_0x2
;     112 
;     113 		EndReply();
;     114 		return;
	RJMP _0x4E3
;     115 
;     116 	case 1:
_0x9:
	CPI  R30,LOW(0x1)
	BRNE _0x8
;     117 	
;     118 		StartReply(3 * int_Devices + 1);
	LDI  R30,LOW(_int_Devices*2)
	LDI  R31,HIGH(_int_Devices*2)
	LPM  R30,Z
	LDI  R26,LOW(3)
	MUL  R30,R26
	MOV  R30,R0
	SUBI R30,-LOW(1)
	ST   -Y,R30
	RCALL _StartReply
;     119 		
;     120 		for (n = 0; n < int_Devices; n++)
	LDI  R17,LOW(0)
_0x13:
	LDI  R30,LOW(_int_Devices*2)
	LDI  R31,HIGH(_int_Devices*2)
	LPM  R30,Z
	CP   R17,R30
	BRSH _0x14
;     121 		{
;     122 			putchar0(0);
	CALL SUBOPT_0x3
;     123 			putchar0( n+1 );
	MOV  R30,R17
	CALL SUBOPT_0x4
;     124 #pragma warn-
;     125 			putchar0((u8)lAddrDevice [n+1]);
	MOV  R30,R17
	LDI  R31,0
	__ADDW1MN _lAddrDevice,1
	LD   R30,Z
	ST   -Y,R30
	RCALL _putchar0
;     126 #pragma warn+
;     127 		}
	SUBI R17,-1
	RJMP _0x13
_0x14:
;     128 
;     129 		putchar0(255);
	CALL SUBOPT_0x2
;     130 
;     131 		EndReply();
;     132 		return;
;     133 	}
_0x8:
;     134 }
_0x4E3:
	CALL __LOADLOCR3
	ADIW R28,3
	RET
;     135 
;     136 //-----------------------------------------------------------------------------------------------------------------
;     137 // Информация об устройстве
;     138 static void GetInfo(void)
;     139 {
_GetInfo_G1:
;     140 	register unsigned char i;
;     141 	
;     142 	// 	Начинаю передачу ответа
;     143 	StartReply(40);
	ST   -Y,R16
;	i -> R16
	LDI  R30,LOW(40)
	ST   -Y,R30
	RCALL _StartReply
;     144 	
;     145 	for (i = 0; i < 32; i ++)	// Имя устройства
	LDI  R16,LOW(0)
_0x16:
	CPI  R16,32
	BRSH _0x17
;     146 	{
;     147 		putchar0(device_name[i]);
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_device_name*2)
	SBCI R31,HIGH(-_device_name*2)
	LPM  R30,Z
	ST   -Y,R30
	RCALL _putchar0
;     148 	}
	SUBI R16,-1
	RJMP _0x16
_0x17:
;     149 
;     150 	putword0(my_ser_num);		// Серийный номер
	LDI  R26,LOW(_my_ser_num)
	LDI  R27,HIGH(_my_ser_num)
	CALL __EEPROMRDD
	ST   -Y,R31
	ST   -Y,R30
	RCALL _putword0
;     151 	putword0(my_ser_num >> 16);	
	LDI  R26,LOW(_my_ser_num)
	LDI  R27,HIGH(_my_ser_num)
	CALL __EEPROMRDD
	CALL __LSRD16
	ST   -Y,R31
	ST   -Y,R30
	RCALL _putword0
;     152 	
;     153 	putchar0(my_addr);			// Адрес устройстав
	LDI  R26,LOW(_my_addr)
	LDI  R27,HIGH(_my_addr)
	CALL __EEPROMRDB
	CALL SUBOPT_0x0
;     154 
;     155 	putchar0(0);				// Зарезервированный байт
;     156 	
;     157 	putword0(my_version);		// Версия
	LDI  R30,LOW(_my_version*2)
	LDI  R31,HIGH(_my_version*2)
	CALL __GETW1PF
	ST   -Y,R31
	ST   -Y,R30
	RCALL _putword0
;     158 	
;     159 	EndReply();					// Завершаю ответ
	RCALL _EndReply
;     160 }
	LD   R16,Y+
	RET
;     161 
;     162 //-----------------------------------------------------------------------------------------------------------------
;     163 // Смена адреса устройства
;     164 static void SetAddr(void)
;     165 {
_SetAddr_G1:
;     166 	#define sap ((RQ_SETADDR *)rx0buf)
;     167 	
;     168 	my_addr = sap->addr;
	LDS  R30,_rx0buf
	LDI  R26,LOW(_my_addr)
	LDI  R27,HIGH(_my_addr)
	CALL __EEPROMWRB
;     169 	
;     170 	StartReply(1);
	CALL SUBOPT_0x5
;     171 	putchar0(RES_OK);
	CALL SUBOPT_0x6
;     172 	EndReply();
;     173 }
	RET
;     174 
;     175 //-----------------------------------------------------------------------------------------------------------------
;     176 // Назначение серийного номера устройства
;     177 static void SetSerial(void)
;     178 {
_SetSerial_G1:
;     179 	#define ssp ((RQ_SETSERIAL *)rx0buf)
;     180 	
;     181 	if (my_ser_num)
	LDI  R26,LOW(_my_ser_num)
	LDI  R27,HIGH(_my_ser_num)
	CALL __EEPROMRDD
	CALL __CPD10
	BREQ _0x18
;     182 	{
;     183 		StartReply(1);
	CALL SUBOPT_0x5
;     184 		putchar0(RES_ERR);
	CALL SUBOPT_0x3
;     185 		EndReply();
	RCALL _EndReply
;     186 		return;
	RET
;     187 	}
;     188 	
;     189 	my_ser_num = ssp->num;
_0x18:
	LDS  R30,_rx0buf
	LDS  R31,_rx0buf+1
	LDS  R22,_rx0buf+2
	LDS  R23,_rx0buf+3
	LDI  R26,LOW(_my_ser_num)
	LDI  R27,HIGH(_my_ser_num)
	CALL __EEPROMWRD
;     190 	
;     191 	StartReply(1);
	CALL SUBOPT_0x5
;     192 	putchar0(RES_OK);
	CALL SUBOPT_0x6
;     193 	EndReply();
;     194 }
	RET
;     195 
;     196 //-----------------------------------------------------------------------------------------------------------------
;     197 // Перезагрузка в режим программирования
;     198 static void ToProg(void)
;     199 {
_ToProg_G1:
;     200 	// Отправляю ответ
;     201 	StartReply(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _StartReply
;     202 	EndReply();
	RCALL _EndReply
;     203 
;     204 	// На перезагрузку в монитор
;     205 	MCUCR = 1 << IVCE;
	LDI  R30,LOW(1)
	OUT  0x35,R30
;     206 	MCUCR = 1 << IVSEL;
	LDI  R30,LOW(2)
	OUT  0x35,R30
;     207 
;     208 	#asm("jmp 0xFC00");
	jmp 0xFC00
;     209 }
	RET
;     210 
;     211 //-----------------------------------------------------------------------------------------------------------------
;     212 // Железо процессора в исходное состояние
;     213 static void HardwareInit(void)
;     214 {         
_HardwareInit_G1:
;     215         TWI_Master_Initialise();
	CALL _TWI_Master_Initialise
;     216 		CommInit();				// Инициализация  COM-порта
	RCALL _CommInit
;     217 		timer_0_Init ();			// Инициализируем таймер 0 (таймаут TWI)
	RCALL _timer_0_Init
;     218 		timer_2_Init ();			// Инициализируем таймер 2 (таймаут пакетов закрытия)
	RCALL _timer_2_Init
;     219 		timer_3_Init  ();			// Инициализируем таймер 3 (таймаут пакетов закрытия)
	RCALL _timer_3_Init
;     220 		portInit();					// Выводы - в исходное состояние
	RCALL _portInit
;     221 		
;     222 		// Вотчдог
;     223 		#ifdef WD_active
;     224 		WDTCR=0x1F;
;     225 		WDTCR=0x0F;   
;     226 		#endif           
;     227 
;     228         
;     229 }
	RET
;     230 
;     231 //-----------------------------------------------------------------------------------------------------------------
;     232 // Сброс периферии
;     233 void ResetPeripherial(void)
;     234 {
_ResetPeripherial:
;     235 		DDRA.2 = 1;		// RESET подчиненных процессоров
	SBI  0x1A,2
;     236         CRST = 0;
	CBI  0x1B,2
;     237         delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
;     238         CRST = 1;
	SBI  0x1B,2
;     239 		DDRA.2 = 0;
	CBI  0x1A,2
;     240 }
	RET
;     241 
;     242 //-----------------------------------------------------------------------------------------------------------------
;     243 // Точка входа в программу
;     244 void main(void)
;     245 {
_main:
;     246 
;     247 u8 TWI_targetSlaveAddress, a,counter_Responce = 0;
;     248 
;     249   TWI_targetSlaveAddress   = 0x10;
;	TWI_targetSlaveAddress -> R16
;	a -> R17
;	counter_Responce -> R18
	LDI  R18,0
	LDI  R16,LOW(16)
;     250 
;     251 
;     252 //	Пока происходят внутренние работы светодиод - красный. По окончании - зеленый.
;     253 
;     254     LedRed();               
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,0
	SBI  0x1B,1
;     255 	HardwareInit();				// Железо процессора
	CALL _HardwareInit_G1
;     256 
;     257 	#asm("sei")
	sei
;     258 
;     259 	ResetPeripherial();		// Сбрасываю периферию 
	CALL _ResetPeripherial
;     260 	delay_ms (3000);					// даем время отработать сброс
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
;     261 
;     262 	// активируем TWI	
;     263     txBuffer[0] = (TWI_GEN_CALL<< TWI_ADR_BITS) | (FALSE<<TWI_READ_BIT);
	LDI  R30,LOW(0)
	STS  _txBuffer,R30
;     264 	txBuffer[1] = TWI_CMD_MASTER_READ;             // The first byte is used for commands.
	LDI  R30,LOW(32)
	__PUTB1MN _txBuffer,1
;     265 	TWI_Start_Transceiver_With_Data( txBuffer, 2 );
	LDI  R30,LOW(_txBuffer)
	LDI  R31,HIGH(_txBuffer)
	CALL SUBOPT_0x7
	CALL _TWI_Start_Transceiver_With_Data
;     266 
;     267 	UCSR0B.3 = 1;		 				// Разрешаю передатчик UART
	SBI  0xA,3
;     268 
;     269 	#ifdef print
;     270 	printf ("Start program \r\n");
;     271 	#endif
;     272 
;     273 	if (my_ser_num == update_program_ser_num)
	LDI  R26,LOW(_my_ser_num)
	LDI  R27,HIGH(_my_ser_num)
	CALL __EEPROMRDD
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDI  R30,LOW(_update_program_ser_num*2)
	LDI  R31,HIGH(_update_program_ser_num*2)
	CALL __GETD1PF
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD12
	BRNE _0x19
;     274 	{
;     275 		// работаем с карточкой...
;     276 		#ifdef print
;     277 		printf ("Scrambling ON! \r\n");
;     278 		#endif
;     279 		if (initialize_media())							// инициализация CF Card   
	RCALL _initialize_media
	CPI  R30,0
	BREQ _0x1A
;     280 		{
;     281 
;     282 //format_CF();
;     283 				CF_card_INI_OK = 1;
	SET
	BLD  R2,2
;     284 				#ifdef print
;     285 				printf ("Ini CF - OK! \r\n");
;     286 				#endif
;     287 
;     288 				open_user_bin (rd_file);  // открываем БД юзеров (prog.bin)
	CALL SUBOPT_0x8
;     289 				 
;     290 		}
;     291 		else
_0x1A:
;     292 		{
;     293 		 		#ifdef print
;     294 				printf ("Ini CF - Error! \r\n");
;     295 				#endif
;     296 		}
;     297 	}
;     298 
;     299 	for (a=1; a<= int_Devices; a++)	     		   		// разблокируем порты
_0x19:
	LDI  R17,LOW(1)
_0x1D:
	LDI  R30,LOW(_int_Devices*2)
	LDI  R31,HIGH(_int_Devices*2)
	LPM  R30,Z
	CP   R30,R17
	BRLO _0x1E
;     300 	{
;     301 		unlock_Pack(a);
	ST   -Y,R17
	CALL _unlock_Pack
;     302 	}
	SUBI R17,-1
	RJMP _0x1D
_0x1E:
;     303 // ---------------------------------------------------------------------------------------------------------------------
;     304 while (1)
_0x1F:
;     305 {
;     306 	#asm("wdr");					// 	сброс WD
	wdr
;     307 
;     308 	LedGreen(); 
	SBI  0x1A,0
	SBI  0x1A,1
	SBI  0x1B,0
	CBI  0x1B,1
;     309 
;     310 		//					-------------------		TWI	---------------------
;     311 //	for (a=1+offset; a<= int_Devices+offset; a++)	     		   			// вычитываем у кого что есть
;     312 	for (a=1; a<= int_Devices; a++)	     		   			// вычитываем у кого что есть
	LDI  R17,LOW(1)
_0x23:
	LDI  R30,LOW(_int_Devices*2)
	LDI  R31,HIGH(_int_Devices*2)
	LPM  R30,Z
	CP   R30,R17
	BRLO _0x24
;     313 	{
;     314 		// подчиненные устройства - c адреса 0х01
;     315 		 if ( pingPack (a) )
	ST   -Y,R17
	CALL _pingPack
	CPI  R30,0
	BREQ _0x25
;     316 		 { 
;     317  			if ( Incoming_Pack_TWI == Internal_Packet )
	__GETB1MN _rxBuffer,2
	CPI  R30,0
	BRNE _0x26
;     318 		 	{
;     319 				switch (Incoming_Inernal_Information_TWI)
	__GETB1MN _rxBuffer,4
;     320 				{
;     321 					case GetLogAddr:            						// пришел лог. адрес
	CPI  R30,LOW(0x1)
	BRNE _0x2A
;     322 						check_incoming_LOG_ADDR (a);
	ST   -Y,R17
	RCALL _check_incoming_LOG_ADDR
;     323 						break;
	RJMP _0x29
;     324 
;     325 					case Responce_GEN_CALL:				// пришло подтверждение GEN CALL
_0x2A:
	CPI  R30,LOW(0x3)
	BRNE _0x2B
;     326 						Combine_Responce_GEN_CALL |=  ( rxBuffer[5] & 1 ) <<  ( a - 1);    
	__GETB1MN _rxBuffer,5
	CALL SUBOPT_0x9
	OR   R7,R30
;     327 						counter_Responce &= (1 <<  ( a - 1)) ^-1;
	CALL SUBOPT_0xA
	AND  R18,R30
;     328 
;     329 						if (counter_Responce == 0 )
	CPI  R18,0
	BRNE _0x2C
;     330 						{
;     331 								if ( Combine_Responce_GEN_CALL != reflection_active_PORTS )
	CP   R8,R7
	BREQ _0x2D
;     332 										Reply (FALSE);		// ошибка передачи
	LDI  R30,LOW(0)
	RJMP _0x4E4
;     333 								else 	Reply (TRUE);															// передача удалась
_0x2D:
	LDI  R30,LOW(1)
_0x4E4:
	ST   -Y,R30
	RCALL _Reply
;     334 								
;     335 //								EndTimePack = TRUE;		// разрешаем скремблер
;     336 						}                                  
;     337 						break;
_0x2C:
	RJMP _0x29
;     338 
;     339 					case Responce_GEN_CALL_internal:			// ответы для внутр. скремблера
_0x2B:
	CPI  R30,LOW(0x4)
	BRNE _0x31
;     340 						#ifdef print
;     341 						printf ("Resp Int Scremb \r\n");
;     342 						#endif
;     343 
;     344 						Combine_Responce_GEN_CALL |=  ( rxBuffer[5] & 1 ) <<  ( a - 1);    
	__GETB1MN _rxBuffer,5
	CALL SUBOPT_0x9
	OR   R7,R30
;     345 						counter_Responce &= (1 <<  ( a - 1)) ^-1;
	CALL SUBOPT_0xA
	AND  R18,R30
;     346 
;     347 						if (counter_Responce == 0 )
	CPI  R18,0
	BRNE _0x30
;     348 						{
;     349 						#ifdef print
;     350 						printf ("Resp OK! Scremb ON! \r\n");
;     351 						#endif
;     352 							EndTimePack = TRUE;		// разрешаем скремблер
	SET
	BLD  R2,0
;     353 						}
;     354 
;     355 						break;
_0x30:
;     356 
;     357 						
;     358 					default:	
_0x31:
;     359 						break;
;     360 				}		
_0x29:
;     361 		 	}
;     362 		 	else 	// пакет для ретрансляции
	RJMP _0x32
_0x26:
;     363 			{
;     364 				#ifdef print
;     365 				printf ("Relay TWI_UART \r\n");
;     366 				#endif
;     367 
;     368 				Transmitt_from_TWI_to_UART ( &rxBuffer[3] );
	__POINTW1MN _rxBuffer,3
	ST   -Y,R31
	ST   -Y,R30
	RCALL _Transmitt_from_TWI_to_UART
;     369 			}
_0x32:
;     370 		 }
;     371 		 else // нет полезной информации во внутр. канале
_0x25:
;     372 		 {           
;     373 		 
;     374 		 }
;     375 	 }
	SUBI R17,-1
	RJMP _0x23
_0x24:
;     376 
;     377 			 
;     378 
;     379 		// Проверяю пакет ---------------		UART		-----------------------
;     380 		if (HaveIncomingPack())
	RCALL _HaveIncomingPack
	CPI  R30,0
	BRNE PC+3
	JMP _0x34
;     381 		{
;     382 			scrambOff();							// при получении пакета выключаем скремблер на 8сек
	CALL _scrambOff
;     383 
;     384 			if ((rx0addr == my_addr) || (rx0addr == TO_ALL))				// адрес мой 
	LDI  R26,LOW(_my_addr)
	LDI  R27,HIGH(_my_addr)
	CALL __EEPROMRDB
	LDS  R26,_rx0addr
	CP   R30,R26
	BREQ _0x36
	CPI  R26,LOW(0xFF)
	BRNE _0x35
_0x36:
;     385 			{
;     386 				#ifdef print
;     387 				printf ("Have Incoming Pack \r\n");
;     388 				#endif
;     389 
;     390 				switch(IncomingPackType())
	RCALL _IncomingPackType
;     391 				{
;     392 					case PT_GETSTATE:
	CPI  R30,LOW(0x1)
	BRNE _0x3B
;     393 							GetState();
	CALL _GetState_G1
;     394 							break;
	RJMP _0x3A
;     395 				
;     396 					case PT_GETINFO:
_0x3B:
	CPI  R30,LOW(0x3)
	BRNE _0x3C
;     397 							GetInfo();
	CALL _GetInfo_G1
;     398 							break;
	RJMP _0x3A
;     399 				
;     400 					case PT_SETADDR:
_0x3C:
	CPI  R30,LOW(0x4)
	BRNE _0x3D
;     401 							SetAddr();
	CALL _SetAddr_G1
;     402 							break;
	RJMP _0x3A
;     403 				
;     404 					case PT_SETSERIAL:
_0x3D:
	CPI  R30,LOW(0x5)
	BRNE _0x3E
;     405 							SetSerial();
	CALL _SetSerial_G1
;     406 							break;
	RJMP _0x3A
;     407 		
;     408 					case PT_TOPROG:
_0x3E:
	CPI  R30,LOW(0x7)
	BRNE _0x3F
;     409 							ToProg();
	CALL _ToProg_G1
;     410 							break;      
	RJMP _0x3A
;     411 
;     412 					// ретрансляция пакета в TWI при MY_ADDR или 255. Приемник -  подчиненные
;     413 					// процессоры (только один).
;     414 					case PT_RELAY:           			
_0x3F:
	CPI  R30,LOW(0x6)
	BRNE _0x40
;     415 
;     416 //						    if ( ! ( Relay_pack_from_UART_to_TWI_Internal (rx0buf [0]+offset) ) )	Reply (FALSE);					//ошибка
;     417 						    if ( ! ( Relay_pack_from_UART_to_TWI_Internal (rx0buf [0]) ) )	Reply (FALSE);					//ошибка
	LDS  R30,_rx0buf
	ST   -Y,R30
	CALL _Relay_pack_from_UART_to_TWI_Internal
	CPI  R30,0
	BRNE _0x41
	CALL SUBOPT_0xB
;     418 							#ifdef print
;     419 							printf ("Relay to Internal PT_RELAY \r\n");
;     420 							#endif
;     421 							Combine_Responce_GEN_CALL = 0;	// сброс счетчиков приема подтверждений
_0x41:
	CLR  R7
;     422 							counter_Responce = reflection_active_PORTS;
	MOV  R18,R8
;     423 
;     424 							DiscardIncomingPack();        // разрешаем принимать след. пакет
	RJMP _0x4E5
;     425         	   				break;
;     426 
;     427 					case PT_CF_CARD:						// пакеты для работы с CF Flash
_0x40:
	CPI  R30,LOW(0xAD)
	BRNE _0x42
;     428 							flash_Work();
	RCALL _flash_Work
;     429 
;     430 							DiscardIncomingPack();
	RJMP _0x4E5
;     431            					break;
;     432 
;     433 					case PT_SCRCTL:
_0x42:
	CPI  R30,LOW(0xA0)
	BREQ _0x44
;     434 					case PT_SCRDATA:    
	CPI  R30,LOW(0xA1)
	BRNE _0x45
_0x44:
;     435 				#ifdef print
;     436 				printf ("Relay to Internal PT_SCRCTR or PT_SCRDATA\r\n");
;     437 				#endif
;     438 							Relay_pack_from_UART_to_TWI(Internal_Packet);
	CALL SUBOPT_0xC
;     439 							Combine_Responce_GEN_CALL = 0;	// сброс счетчиков приема подтверждений
;     440 							counter_Responce = reflection_active_PORTS;
	MOV  R18,R8
;     441 
;     442 							DiscardIncomingPack();
	RJMP _0x4E5
;     443            					break;
;     444 
;     445            					
;     446 					case PT_DESCRUPD:    
_0x45:
	CPI  R30,LOW(0xA2)
	BRNE _0x47
;     447 				#ifdef print
;     448 				printf ("Relay to Internal PT_DESCRUPD\r\n");
;     449 				#endif
;     450                         ModifyKey ();									// подменяем текущий ключ
	RCALL _ModifyKey
;     451 						Relay_pack_from_UART_to_TWI(Internal_Packet);
	CALL SUBOPT_0xC
;     452 
;     453 							Combine_Responce_GEN_CALL = 0;	// сброс счетчиков приема подтверждений
;     454 							counter_Responce = reflection_active_PORTS;
	MOV  R18,R8
;     455 
;     456 							DiscardIncomingPack();
;     457            					break;    
;     458                 			
;     459 					default:
_0x47:
;     460 							DiscardIncomingPack();
_0x4E5:
	RCALL _DiscardIncomingPack
;     461 							break;
;     462 				}
_0x3A:
;     463 		    }
;     464 		   	else																// ретранслируем
	RJMP _0x48
_0x35:
;     465 			{                                                                     
;     466 				#ifdef print
;     467 				printf ("Relay Pack \r\n");
;     468 				#endif
;     469 
;     470 
;     471 		        if ( ! Searching_Port_for_Relay () ) 
	CALL _Searching_Port_for_Relay
	CPI  R30,0
	BRNE _0x49
;     472 		        {
;     473 					#ifdef print
;     474 					printf ("port for Relay Pack not FOUND!\r\n");
;     475 					printf ("Incoming PORT-%x!\r\n",rx0addr);
;     476 					#endif
;     477 		        	Reply (FALSE);		// передаем ошибку
	CALL SUBOPT_0xB
;     478 	    	    }
;     479 				DiscardIncomingPack();        // разрешаем принимать след. пакет
_0x49:
	RCALL _DiscardIncomingPack
;     480 			}
_0x48:
;     481 		}
;     482 		
;     483 
;     484 		//					-------------------		Scrambler	---------------------
;     485 		// если карта проинициализировалась - запускаем скремблирование
;     486 		
;     487 		if (CF_card_INI_OK)				
_0x34:
	SBRS R2,2
	RJMP _0x4A
;     488 		{
;     489 			if (EndTimePack == TRUE) 		// таймер разрешения
	SBRS R2,0
	RJMP _0x4B
;     490 			{
;     491 				if (reflection_active_PORTS != 0)	// если нет подкл. устойств - не скремблируем
	TST  R8
	BREQ _0x4C
;     492 				{
;     493 					#ifdef print
;     494 					printf ("Scrambling... \r\n");
;     495 					#endif
;     496 
;     497 					scrambling();   		// создаем свои пакеты для передачи в линию
	CALL _scrambling
;     498 					timeOutPackStart();
	RCALL _timeOutPackStart
;     499 					LedRed(); 
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,0
	SBI  0x1B,1
;     500 
;     501 					Combine_Responce_GEN_CALL = 0;	// сброс счетчиков приема подтверждений
	CLR  R7
;     502 					counter_Responce = reflection_active_PORTS;
	MOV  R18,R8
;     503 				}
;     504 
;     505 			}
_0x4C:
;     506 		}	
_0x4B:
;     507 }
_0x4A:
	JMP  _0x1F
;     508 }    	
_0x4D:
	RJMP _0x4D
;     509 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;     510 // Управляющая программа КОДЕРА
;     511 // Связь с внешним миром
;     512 
;     513 #include "Coding.h"
;     514 
;     515 #define BAUD 38400
;     516 #define DTXDDR 	DDRC.0		// вывод программного UART   (35pin, на стороне - 16)
;     517 #define DTXPIN	PORTC.0		// вывод программного UART
;     518 
;     519 
;     520 ////////////////////////////////////////////////////////////////////////////////
;     521 // Фазы работы приемопередатчиков
;     522 #define RX_HDR	 1		// Принятый байт - заголовок
;     523 #define RX_LEN   2		// Принятый байт - длина
;     524 #define RX_ADDR  3		// Принятый байт - адрес
;     525 #define RX_TYPE  4		// Принятый байт - тип пакета
;     526 #define RX_DATA  5		// Принятый байт - байт данных
;     527 #define RX_CRC   6		// Принятый байт - CRC
;     528 #define RX_OK    7		// Пакет успешно принят и адресован мне
;     529 #define RX_TIME  8		// Во время приема произошел тайм-аут
;     530 #define RX_ERR   9		// Ошибка CRC приема
;     531 #define RX_BUSY 10		// Запрос прочитан, а ответ еще не сформирован
;     532 
;     533 #define UDRE 5
;     534 #define DATA_REGISTER_EMPTY (1<<UDRE)
;     535 
;     536 #define RXTIMEOUT 4000	// Тайм-аут приема наружного канала
;     537 
;     538 ////////////////////////////////////////////////////////////////////////////////
;     539 // Работа с наружным каналом
;     540 
;     541 unsigned char tx0crc;

	.DSEG
_tx0crc:
	.BYTE 0x1
;     542 unsigned char rx0state = RX_HDR;
_rx0state:
	.BYTE 0x1
;     543 unsigned char rx0crc;
_rx0crc:
	.BYTE 0x1
;     544 unsigned char rx0len;
_rx0len:
	.BYTE 0x1
;     545 unsigned char rx0addr;
_rx0addr:
	.BYTE 0x1
;     546 unsigned char rx0type;
_rx0type:
	.BYTE 0x1
;     547 
;     548 #define COMBUFSIZ 255
;     549 
;     550 unsigned char rx0buf[COMBUFSIZ];
_rx0buf:
	.BYTE 0xFF
;     551 unsigned char rx0ptr;
_rx0ptr:
	.BYTE 0x1
;     552 
;     553 // Передача байта во "внешний" канал
;     554 void putchar0(char byt)
;     555 {

	.CSEG
_putchar0:
;     556 	while ((UCSR0A & DATA_REGISTER_EMPTY)==0);
_0x4F:
	SBIS 0xB,5
	RJMP _0x4F
;     557 	UDR0 = byt;
	LD   R30,Y
	OUT  0xC,R30
;     558 	tx0crc += byt;
	LDS  R26,_tx0crc
	ADD  R30,R26
	STS  _tx0crc,R30
;     559 }
	RJMP _0x4E1
;     560 
;     561 // Начало ответа на запрос по внешнему каналу
;     562 void StartReply(unsigned char dlen) 
;     563 {
_StartReply:
;     564 	rx0state = RX_BUSY;					// Запрос обработан
	LDI  R30,LOW(10)
	STS  _rx0state,R30
;     565 	tx0crc = 0;										// Готовлю CRC
	LDI  R30,LOW(0)
	STS  _tx0crc,R30
;     566 	
;     567 //	UCSR0B.3 = 1;								// Разрешаю передатчик
;     568 	
;     569 	putchar0(dlen+1);							// Передаю длину
	LD   R30,Y
	CALL SUBOPT_0x4
;     570 }
	RJMP _0x4E1
;     571 
;     572 void EndReply(void)
;     573 {
_EndReply:
;     574 	putchar0(tx0crc);							// Контрольная сумма
	LDS  R30,_tx0crc
	ST   -Y,R30
	CALL _putchar0
;     575 //	UCSR0B.3 = 0;								// Запрещаю передатчик
;     576 	rx0state = RX_HDR;						// Разрешаю прием след. запроса
	LDI  R30,LOW(1)
	STS  _rx0state,R30
;     577 }        
	RET
;     578 
;     579 // 
;     580 void Reply(u8 status)
;     581 {
_Reply:
;     582 
;     583 		#ifdef print
;     584 		printf("Reply-%x\n\r",status);
;     585 		#endif
;     586 	
;     587 		StartReply (1);
	CALL SUBOPT_0x5
;     588 		putchar0(status);        // текущий статус
	CALL SUBOPT_0xD
;     589 		EndReply();  
	CALL _EndReply
;     590 
;     591 }
	RJMP _0x4E1
;     592 
;     593 // Прерывание по приему байта из "наружного" канала
;     594 interrupt [USART0_RXC] void uart_rx_isr(void)
;     595 {
_uart_rx_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;     596 	register unsigned char byt;
;     597 
;     598 	byt = UDR0;									// Принятый байт
	ST   -Y,R16
;	byt -> R16
	IN   R16,12
;     599 
;     600 	
;     601 	switch (rx0state)
	LDS  R30,_rx0state
;     602 	{
;     603 	case RX_HDR:								// Должен быть заголовок
	CPI  R30,LOW(0x1)
	BRNE _0x55
;     604 		if (byt != PACKHDR)					// Отбрасываю не заголовок
	CPI  R16,113
	BREQ _0x56
;     605 		{
;     606 			break;
	RJMP _0x54
;     607 		}
;     608 
;     609 
;     610 		rx0state = RX_LEN;					// Перехожу к ожиданию длины
_0x56:
	LDI  R30,LOW(2)
	STS  _rx0state,R30
;     611 		rx0crc = 0;								// Готовлю подсчет CRC
	LDI  R30,LOW(0)
	STS  _rx0crc,R30
;     612 		
;     613 		OCR1A = TCNT1+RXTIMEOUT;	// Взвожу тайм-аут
	IN   R30,0x2C
	IN   R31,0x2C+1
	SUBI R30,LOW(-4000)
	SBCI R31,HIGH(-4000)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
;     614 		TIFR = 0x10;								// Предотвращаю ложное срабатывание
	LDI  R30,LOW(16)
	OUT  0x36,R30
;     615 		TIMSK |= 0x10;							// Разрешение прерывания по тайм-ауту
	IN   R30,0x37
	ORI  R30,0x10
	OUT  0x37,R30
;     616 		break;
	RJMP _0x54
;     617 		
;     618 	case RX_LEN:
_0x55:
	CPI  R30,LOW(0x2)
	BRNE _0x57
;     619 		rx0len = byt - 3;							// Длина содержимого
	MOV  R30,R16
	SUBI R30,LOW(3)
	STS  _rx0len,R30
;     620 		rx0state = RX_ADDR;					// К приему адреса
	LDI  R30,LOW(3)
	RJMP _0x4E6
;     621 		break;
;     622 
;     623 	case RX_ADDR:
_0x57:
	CPI  R30,LOW(0x3)
	BRNE _0x58
;     624 		rx0addr = byt;							// Адрес
	STS  _rx0addr,R16
;     625 		rx0state = RX_TYPE;					// К приему типа
	LDI  R30,LOW(4)
	RJMP _0x4E6
;     626 		break;
;     627 
;     628 	case RX_TYPE:
_0x58:
	CPI  R30,LOW(0x4)
	BRNE _0x59
;     629 		rx0type = byt;							// Тип
	STS  _rx0type,R16
;     630 		rx0ptr = 0;									// Указатель на начало данных
	LDI  R30,LOW(0)
	STS  _rx0ptr,R30
;     631 		if (rx0len)
	LDS  R30,_rx0len
	CPI  R30,0
	BREQ _0x5A
;     632 		{
;     633 			rx0state = RX_DATA;				// К приему данных
	LDI  R30,LOW(5)
	RJMP _0x4E7
;     634 		}
;     635 		else
_0x5A:
;     636 		{
;     637 			rx0state = RX_CRC; 				// К приему контрольной суммы
	LDI  R30,LOW(6)
_0x4E7:
	STS  _rx0state,R30
;     638 		}
;     639 		break;
	RJMP _0x54
;     640 
;     641 	case RX_DATA:
_0x59:
	CPI  R30,LOW(0x5)
	BRNE _0x5C
;     642 		if (rx0ptr > (COMBUFSIZ-1))
	LDS  R26,_rx0ptr
	CPI  R26,LOW(0xFF)
	BRLO _0x5D
;     643 		{
;     644 			rx0state = RX_HDR;				// Если пакет слишком длинный - отвергаю и иду в начало
	RJMP _0x4E8
;     645 			break;
;     646 		}
;     647 		rx0buf[rx0ptr++] = byt;				// Данные
_0x5D:
	CALL SUBOPT_0xE
;     648 		if (rx0ptr < rx0len)						// Еще не все ?
	LDS  R30,_rx0len
	LDS  R26,_rx0ptr
	CP   R26,R30
	BRLO _0x54
;     649 		{
;     650 			break;
;     651 		}
;     652 		rx0state = RX_CRC;					// К приему контрольной суммы
	LDI  R30,LOW(6)
	RJMP _0x4E6
;     653 		break;
;     654 
;     655 	case RX_CRC:
_0x5C:
	CPI  R30,LOW(0x6)
	BRNE _0x62
;     656 		if (byt != rx0crc)
	LDS  R30,_rx0crc
	CP   R30,R16
	BREQ _0x60
;     657 		{
;     658 			rx0state = RX_HDR;				// Не сошлась CRC - игнорирую пакет и жду следующий
	LDI  R30,LOW(1)
	RJMP _0x4E9
;     659 		}
;     660 // убрал фильтр адреса
;     661 else
_0x60:
;     662 {
;     663 rx0buf[rx0ptr++] = byt;						// Данные
	CALL SUBOPT_0xE
;     664 rx0state = RX_OK;								// Принят пакет, на который нужно ответить
	LDI  R30,LOW(7)
_0x4E9:
	STS  _rx0state,R30
;     665 }
;     666 
;     667 		TIMSK &= 0x10 ^ 0xFF;				// Запретить прерывание по тайм-ауту
	CALL SUBOPT_0xF
;     668 		break;
	RJMP _0x54
;     669 		
;     670 		break;
;     671 		
;     672 	default:											// Ошибочное состояние
_0x62:
;     673 		rx0state = RX_HDR;					// Перехожу на начало
_0x4E8:
	LDI  R30,LOW(1)
_0x4E6:
	STS  _rx0state,R30
;     674 		break;
;     675 	}
_0x54:
;     676 
;     677 	rx0crc += byt;								// Подсчитываю контрольную сумму
	MOV  R30,R16
	LDS  R26,_rx0crc
	ADD  R30,R26
	STS  _rx0crc,R30
;     678 }
	LD   R16,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;     679 
;     680 // Прерывание по сравнению A таймера 1 для подсчета тайм-аута приема "внешнего" канала
;     681 interrupt [TIM1_COMPA] void timer1_comp_a_isr(void)
;     682 {
_timer1_comp_a_isr:
	CALL SUBOPT_0x10
;     683 	rx0state = RX_HDR;						// По тайм-ауту перехожу к началу приема нового пакета
	LDI  R30,LOW(1)
	STS  _rx0state,R30
;     684 	TIMSK &= 0x10 ^ 0xFF;					// Больше не генерировать прерываний
	CALL SUBOPT_0xF
;     685 }
	CALL SUBOPT_0x11
	RETI
;     686 
;     687 unsigned char HaveIncomingPack(void)
;     688 {
_HaveIncomingPack:
;     689 	if (rx0state == RX_OK)	return 255;
	LDS  R26,_rx0state
	CPI  R26,LOW(0x7)
	BRNE _0x63
	LDI  R30,LOW(255)
	RET
;     690 	else					return 0;
_0x63:
	LDI  R30,LOW(0)
	RET
;     691 }
	RET
;     692 
;     693 unsigned char IncomingPackType(void)
;     694 {
_IncomingPackType:
;     695 	return rx0type;
	LDS  R30,_rx0type
	RET
;     696 }
;     697 
;     698 void DiscardIncomingPack(void)
;     699 {
_DiscardIncomingPack:
;     700 	rx0state = RX_HDR;						// Разрешаю прием следующего пакета
	LDI  R30,LOW(1)
	STS  _rx0state,R30
;     701 }
	RET
;     702 
;     703 // Настройка приемопередатчика
;     704 void CommInit(void)
;     705 {
_CommInit:
;     706 	// Настраиваю UART
;     707 	UCSR0A = 0b00000000;
	LDI  R30,LOW(0)
	OUT  0xB,R30
;     708 	UCSR0B = 0b10010000;	//0b10011000;
	LDI  R30,LOW(144)
	OUT  0xA,R30
;     709 	UCSR0C = 0x86;
	LDI  R30,LOW(134)
	STS  149,R30
;     710 	UBRR0L = ((_MCU_CLOCK_FREQUENCY_ / (16 * BAUD)) - 1) & 0xFF;
	LDI  R30,LOW(12)
	OUT  0x9,R30
;     711 	UBRR0H = (((_MCU_CLOCK_FREQUENCY_ / (16 * BAUD)) - 1) >> 8) & 0xFF;
	LDI  R30,LOW(0)
	STS  144,R30
;     712 	
;     713 	// Таймер 1 для подсчета тайм-аутов приема
;     714 	TCCR1B  = 0b00000101;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
;     715 }
	RET
;     716 
;     717 void putword0(unsigned short wd)
;     718 {
_putword0:
;     719 	putchar0(wd);
	CALL SUBOPT_0xD
;     720 	putchar0(wd >> 8);
	LDD  R30,Y+1
	ANDI R31,HIGH(0x0)
	ST   -Y,R30
	CALL _putchar0
;     721 }                                  
	ADIW R28,2
	RET
;     722 
;     723 //--------------------------------------------------------------------------------------------
;     724 // "программный" UART
;     725 void dtxdl(void)
;     726 {
;     727 	int i;
;     728 	for (i = 0; i < 15; i ++)
;	i -> R16,R17
;     729 	{
;     730 		#asm("nop")
;     731 	}
;     732 }
;     733 
;     734 void putchar2(char c)
;     735 {
;     736 	register unsigned char b;
;     737 	
;     738 	#asm("cli")
;	c -> Y+1
;	b -> R16
;     739 	
;     740 	DTXDDR = 1;
;     741 //	DRXDDR = 0;
;     742 	DTXPIN = 0;
;     743 	dtxdl();
;     744 	
;     745 	for (b = 0; b < 8; b ++)
;     746 	{
;     747 		if (c & 1)
;     748 		{
;     749 			DTXPIN = 1;
;     750 		}
;     751 		else
;     752 		{
;     753 			DTXPIN = 0;
;     754 		}
;     755              
;     756 		c >>= 1;
;     757 		dtxdl();
;     758 	}
;     759 
;     760 	DTXPIN = 1;
;     761 	dtxdl();
;     762 	dtxdl();
;     763 	
;     764 	#asm("sei")
;     765 }
;     766 
;     767 // передача с внутреннего канада во внешний. Указываем количество передаваемых байт.
;     768 void	Transmitt_from_TWI_to_UART (u8 *Transmitting_Bytes)
;     769 {
_Transmitt_from_TWI_to_UART:
;     770 	u8 temp;
;     771 	
;     772 	temp = *Transmitting_Bytes + 1;
	ST   -Y,R16
;	*Transmitting_Bytes -> Y+1
;	temp -> R16
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X
	SUBI R30,-LOW(1)
	MOV  R16,R30
;     773 	
;     774 		while ( temp -- )
_0x6D:
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BREQ _0x6F
;     775 	   				putchar0 (*Transmitting_Bytes++);
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	ST   -Y,R30
	CALL _putchar0
;     776 }			
	RJMP _0x6D
_0x6F:
	RJMP _0x4E2
;     777 #include "Coding.h"
;     778 
;     779 unsigned char flagTWI				=	0;

	.DSEG
_flagTWI:
	.BYTE 0x1
;     780 
;     781 
;     782 
;     783 // Инициализация выводов
;     784 void portInit (void)
;     785 		{

	.CSEG
_portInit:
;     786 			DDRB.7 = 1;		// testpin
	SBI  0x17,7
;     787 			CS_DDR_SET();	// для CF Card
	SBI  0x17,4
;     788 		}
	RET
;     789 
;     790 
;     791 
;     792 // -------------------- Функции работы с таймером 0 -------------------------------
;     793 ///////////////////////////////////////////////////////////////////////////////////////////////
;     794 // Timer/Counter 0 initialization ; Clock source: System Clock
;     795 // Clock value: 31,250 kHz ;  Mode: Normal top=FFh   
;     796 // Используем для контроля за шиной TWI
;     797 ///////////////////////////////////////////////////////////////////////////////////////////////
;     798 void timer_0_Init  (void)
;     799 	{
_timer_0_Init:
;     800 		ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;     801 		TCCR0=0x0;        //0x06 -start
	OUT  0x33,R30
;     802 		TCNT0=0x01;
	LDI  R30,LOW(1)
	OUT  0x32,R30
;     803 		OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x31,R30
;     804 		TIMSK^=0x01;			// Timer(s)/Counter(s) Interrupt(s) initialization
	IN   R30,0x37
	LDI  R26,LOW(1)
	EOR  R30,R26
	OUT  0x37,R30
;     805 	}
	RET
;     806 
;     807 // -------------------- Функции работы с таймером 2 -------------------------------
;     808 ///////////////////////////////////////////////////////////////////////////////////////////////
;     809 // Timer/Counter 2 initialization;  Clock source: System Clock
;     810 // Clock value: 7,813 kHz ; Mode: Normal top=FFh
;     811 // Используем для таймаута передачи пакетов закрытия
;     812 ///////////////////////////////////////////////////////////////////////////////////////////////
;     813 void timer_2_Init  (void)
;     814 	{
_timer_2_Init:
;     815 		TCCR2=0x00;
	LDI  R30,LOW(0)
	OUT  0x25,R30
;     816 		TCNT2=0x00;
	OUT  0x24,R30
;     817 		OCR2=0x00;
	OUT  0x23,R30
;     818 		TIMSK^=0x40;			// Timer(s)/Counter(s) Interrupt(s) initialization
	IN   R30,0x37
	LDI  R26,LOW(64)
	CALL SUBOPT_0x12
;     819 		ETIMSK^=0x00;
	LDI  R26,LOW(0)
	EOR  R30,R26
	STS  125,R30
;     820 	}                      
	RET
;     821 	
;     822 // -------------------- Функции работы с таймером 3 -------------------------------
;     823 ///////////////////////////////////////////////////////////////////////////////////////////////
;     824 // Clock source: System Clock; Clock value: 7,813 kHz
;     825 // Mode: Normal top=FFFFh ;Timer 3 Overflow Interrupt: On
;     826 // Используем для таймаута передачи пакетов закрытия
;     827 ///////////////////////////////////////////////////////////////////////////////////////////////
;     828 void timer_3_Init  (void)
;     829 	{
_timer_3_Init:
;     830 		TCCR3A=0x00;
	CALL SUBOPT_0x13
;     831 		TCCR3B=0x05;
;     832 		TCNT3H=0x00;
	LDI  R30,LOW(0)
	STS  137,R30
;     833 		TCNT3L=0xAA;
	LDI  R30,LOW(170)
	STS  136,R30
;     834 		ICR3H=0x00;
	LDI  R30,LOW(0)
	STS  129,R30
;     835 		ICR3L=0xFF;
	LDI  R30,LOW(255)
	STS  128,R30
;     836 		OCR3AH=0x00;
	LDI  R30,LOW(0)
	STS  135,R30
;     837 		OCR3AL=0x00;
	STS  134,R30
;     838 		OCR3BH=0x00;
	STS  133,R30
;     839 		OCR3BL=0x00;
	STS  132,R30
;     840 		OCR3CH=0x00;
	STS  131,R30
;     841 		OCR3CL=0x00;
	STS  130,R30
;     842 										
;     843 		TIMSK^=0x00;                    // Timer(s)/Counter(s) Interrupt(s) initialization
	IN   R30,0x37
	LDI  R26,LOW(0)
	CALL SUBOPT_0x12
;     844 		ETIMSK^=0x04;   
	LDI  R26,LOW(4)
	EOR  R30,R26
	STS  125,R30
;     845 	}
	RET
;     846 
;     847 
;     848 
;     849 // Timer 0 overflow interrupt service routine
;     850 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;     851 {
_timer0_ovf_isr:
	CALL SUBOPT_0x10
;     852 		TCCR0 = 0x0;						//останавливаем таймер
	LDI  R30,LOW(0)
	OUT  0x33,R30
;     853 		flagTWI  = flagTWI  | (1 << time_is_Out);	 //взводим признак    
	LDS  R30,_flagTWI
	ORI  R30,1
	STS  _flagTWI,R30
;     854 
;     855 }
	CALL SUBOPT_0x11
	RETI
;     856                                                                                              
;     857 // Timer 2 overflow interrupt service routine
;     858 interrupt [TIM2_OVF] void timer2_ovf_isr(void)
;     859 {
_timer2_ovf_isr:
	ST   -Y,R30
;     860 		TCCR2 = 0x0; 						// останов таймера 
	LDI  R30,LOW(0)
	OUT  0x25,R30
;     861 }
	LD   R30,Y+
	RETI
;     862 
;     863 
;     864 
;     865 // запускаем таймер для таймаута
;     866 void timeOut (void)
;     867 	{
;     868 //		flagTWI  = (flagTWI  ^ (1 << time_is_Out));		// сброс признака
;     869 		TCNT0=0x0	;														// обнуляем счетчик
;     870 		TCCR0 = 0x06;													// пускаем таймер (около 10 мс)
;     871 	}
;     872 
;     873 // остановка таймера для таймаута
;     874 void timeOutStop (void)
;     875 	{
;     876 		TCCR0 = 0x0; 						// осттанов таймера (около 10 мс)
;     877 	}          
;     878 	
;     879 // Timer 3 overflow interrupt service routine
;     880 interrupt [TIM3_OVF] void timer3_ovf_isr(void)
;     881 {
_timer3_ovf_isr:
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
;     882 		EndTimePack = 1;			// время вышло
	SET
	BLD  R2,0
;     883 
;     884 						#ifdef print
;     885 						printf ("Timeout Scremb! \r\n");
;     886 						#endif
;     887 		
;     888 
;     889 		TCCR3A=0x00;			// останов таймера 
	LDI  R30,LOW(0)
	STS  139,R30
;     890 		TCCR3B=0x00;
	STS  138,R30
;     891 		
;     892 		testpin = ~testpin;
	CLT
	SBIS 0x18,7
	SET
	IN   R26,0x18
	BLD  R26,7
	OUT  0x18,R26
;     893 		
;     894 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
;     895 
;     896 // запускаем таймер для таймаута пакетов (150mc)
;     897 void timeOutPackStart (void)
;     898 	{
_timeOutPackStart:
;     899 		EndTimePack = 0;		// сброс признака
	CLT
	BLD  R2,0
;     900 		
;     901 //		TCNT3H=0xFF;			// иниц. величины 32мс
;     902 //		TCNT3L=0x00;			// иниц. величины 32мс
;     903 
;     904 //		TCNT3H=0xFC;			// иниц. величины 100мс
;     905 //		TCNT3L=0xF2;        // иниц. величины 100мс
;     906 
;     907 //		TCNT3H=0xFB;			// иниц. величины 150мс
;     908 //		TCNT3L=0x6C;			// иниц. величины 150мс
;     909 
;     910 		TCNT3H=0xF0;			// test
	LDI  R30,LOW(240)
	STS  137,R30
;     911 		TCNT3L=0x00;        // test
	LDI  R30,LOW(0)
	STS  136,R30
;     912 
;     913 		TCCR3A=0x00;			// делитель до 7.813кГц
	CALL SUBOPT_0x13
;     914 		TCCR3B=0x05;
;     915 
;     916 
;     917 	}
	RET
;     918 
;     919 // подменяем ключ в пакете
;     920 void ModifyKey (void)
;     921 {
_ModifyKey:
;     922 		u8 a,b;
;     923 		#ifdef print
;     924 		printf ("Modify Key\n\r");
;     925 		#endif
;     926 			
;     927 		#ifdef print
;     928 			for (a=0;a<rx0len;a++) printf ("%x ", rx0buf[a]);
;     929 		#endif
;     930 
;     931 		b=rx0buf [55];
	ST   -Y,R17
	ST   -Y,R16
;	a -> R16
;	b -> R17
	__GETBRMN 17,_rx0buf,55
;     932 		rx0buf[55] = ver_kl;
	__POINTW2MN _rx0buf,55
	LDS  R30,_ver_kl
	LDS  R31,_ver_kl+1
	ST   X,R30
;     933 		
;     934 		rx0buf[rx0len] = ((rx0buf[rx0len]-b) +ver_kl);
	LDS  R30,_rx0len
	LDI  R31,0
	SUBI R30,LOW(-_rx0buf)
	SBCI R31,HIGH(-_rx0buf)
	MOVW R0,R30
	LD   R30,Z
	SUB  R30,R17
	MOV  R26,R30
	LDS  R30,_ver_kl
	LDS  R31,_ver_kl+1
	LDI  R27,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R26,R0
	ST   X,R30
;     935 
;     936 		#ifdef print
;     937 			printf("\n\r");
;     938 			for (a=0;a<rx0len;a++) printf ("%x ", rx0buf[a]);
;     939 		#endif
;     940 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;     941 
;     942 
;     943 //  проверяем совпадение логических адресов
;     944  unsigned char Logic_Address_Identical (unsigned char Logik_Address, unsigned char device)
;     945  {
_Logic_Address_Identical:
;     946 		unsigned char a;
;     947 		
;     948 		for (a=1; a<= int_Devices; a++)				// ищем порт по адресу
	ST   -Y,R16
;	Logik_Address -> Y+2
;	device -> Y+1
;	a -> R16
	LDI  R16,LOW(1)
_0x71:
	LDI  R30,LOW(_int_Devices*2)
	LDI  R31,HIGH(_int_Devices*2)
	LPM  R30,Z
	CP   R30,R16
	BRLO _0x72
;     949 		{
;     950 		 	if (lAddrDevice [a]	== Logik_Address)
	CALL SUBOPT_0x14
	MOV  R26,R30
	LDD  R30,Y+2
	CP   R30,R26
	BRNE _0x73
;     951 		 	{
;     952 		 		if (a != device) return TRUE;		// есть совпадение
	LDD  R30,Y+1
	CP   R30,R16
	BREQ _0x74
	LDI  R30,LOW(1)
	RJMP _0x4E2
;     953 		 	}
_0x74:
;     954 		 }	
_0x73:
	SUBI R16,-1
	RJMP _0x71
_0x72:
;     955 
;     956  		return FALSE;
	LDI  R30,LOW(0)
_0x4E2:
	LDD  R16,Y+0
	ADIW R28,3
	RET
;     957  }
;     958 	
;     959  // проверяем и заполняем внутр. таблицу адресов
;     960 void check_incoming_LOG_ADDR (u8 checking_Device)
;     961 {
_check_incoming_LOG_ADDR:
;     962 		
;     963 		if ( !( Logic_Address_Identical ( rxBuffer[5], checking_Device ) ) )  //есть ли схожий адрес?
	__GETB1MN _rxBuffer,5
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _Logic_Address_Identical
	CPI  R30,0
	BRNE _0x75
;     964 		{
;     965 					#ifdef print
;     966 					printf ("Logic ADDR-%d\r\n",rxBuffer[5]);
;     967 					#endif
;     968 					 lAddrDevice [checking_Device] = rxBuffer[5];
	CALL SUBOPT_0x15
	__GETB1MN _rxBuffer,5
	RJMP _0x4EA
;     969 		}
;     970 		else		 lAddrDevice [checking_Device] = 0;                                                                                
_0x75:
	CALL SUBOPT_0x15
	LDI  R30,LOW(0)
_0x4EA:
	ST   X,R30
;     971 
;     972 // обновляем зеркало портов
;     973 		 if (! lAddrDevice [checking_Device])	reflection_active_PORTS &= ((1 << (checking_Device - 1)) ^ -1);
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_lAddrDevice)
	SBCI R31,HIGH(-_lAddrDevice)
	LD   R30,Z
	CPI  R30,0
	BRNE _0x77
	CALL SUBOPT_0x16
	LDI  R26,LOW(255)
	EOR  R30,R26
	AND  R8,R30
;     974 		 else													reflection_active_PORTS |= (1 << (checking_Device - 1));		
	RJMP _0x78
_0x77:
	CALL SUBOPT_0x16
	OR   R8,R30
;     975 }
_0x78:
_0x4E1:
	ADIW R28,1
	RET
;     976 ///////////////////////////////////////////////////////
;     977 // Секция работы с CF CARD
;     978 
;     979 #include "Coding.h"    
;     980 
;     981 #define FLASH_command 	rx0buf[0]
;     982 #define appendAbon			1						// добавить абонента 
;     983 #define deleteAbon			2						// удалить абонента
;     984 #define pack_for_scremb	3						// пакет кодеру
;     985 #define pack_readAbons	4						// прочитать разрешения абонента
;     986 
;     987 FILE * fu_user = NULL;	//обьявляется переменная для указателя входного файла s userami

	.DSEG
_fu_user:
	.BYTE 0x2
;     988 
;     989 
;     990 // Копируем принятый пакет prog.bin в ЕЕПРОМ 
;     991 void check_fprog (void)
;     992 {

	.CSEG
_check_fprog:
;     993 	u8 temp = 0;
;     994 	eefprog = f_buff_prog; 
	ST   -Y,R16
;	temp -> R16
	LDI  R16,0
	LDI  R30,LOW(_f_buff_prog)
	LDI  R31,HIGH(_f_buff_prog)
	MOVW R4,R30
;     995 		
;     996 	while (temp ++ < len_prog_bin)
_0x7A:
	MOV  R26,R16
	SUBI R16,-1
	CPI  R26,LOW(0x7C)
	BRSH _0x7C
;     997 	{
;     998 		*eefprog ++ = rx0buf [temp];
	CALL SUBOPT_0x17
	MOV  R30,R16
	CALL SUBOPT_0x18
	CALL __EEPROMWRB
;     999 /*		#ifdef print
;    1000 		printf("dann=%02x ",rx0buf [temp]);
;    1001  		#endif       */
;    1002 	}
	RJMP _0x7A
_0x7C:
;    1003 }
	RJMP _0x4E0
;    1004 
;    1005 
;    1006 typedef union
;    1007 {
;    1008 	u32 w;
;    1009 	u8 b[4];
;    1010 } B2DW;
;    1011 
;    1012 // преобразовываем 4байта в 1 слово (32бит)
;    1013 u32 convTOw32 (u8 *pConv)
;    1014 {
_convTOw32:
;    1015 	B2DW out_W;  
;    1016 	
;    1017 	out_W.b[0] = *pConv++;			// 
	SBIW R28,4
;	*pConv -> Y+4
;	out_W -> Y+0
	CALL SUBOPT_0x19
	ST   Y,R30
;    1018 	out_W.b[1] = *pConv++;
	CALL SUBOPT_0x19
	STD  Y+1,R30
;    1019 	out_W.b[2] = *pConv++;
	CALL SUBOPT_0x19
	STD  Y+2,R30
;    1020 	out_W.b[3] = *pConv;        
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R30,X
	STD  Y+3,R30
;    1021 
;    1022 	return out_W.w;
	__GETD1S 0
	RJMP _0x4DF
;    1023 }
;    1024 
;    1025 
;    1026 
;    1027 // форматируем карточку
;    1028 u8 format_CF (void)
;    1029 {  
;    1030 		#ifdef print
;    1031 		printf ("Format CF... ");
;    1032 		#endif
;    1033 	if (fquickformat() == EOF)
;    1034 	{
;    1035 		#ifdef print
;    1036 		printf ("ERROR \r\n");
;    1037 		#endif
;    1038 		 return FALSE; 
;    1039 	 }
;    1040 	else
;    1041 	{
;    1042 		#ifdef print
;    1043 		printf ("OK \r\n");
;    1044 		#endif
;    1045 
;    1046 		 return TRUE;           
;    1047 	 }
;    1048 }                       
;    1049 
;    1050 
;    1051 
;    1052 // добавить / изменить запись
;    1053 u8 append_abons (void)
;    1054 {
_append_abons:
;    1055 	u8 temp;
;    1056 	
;    1057 	for (temp = 0; temp < dann_1_abon; temp++)
	ST   -Y,R16
;	temp -> R16
	LDI  R16,LOW(0)
_0x80:
	CPI  R16,132
	BRSH _0x81
;    1058 	{
;    1059 		if ((fputc (rx0buf[temp+9], fu_user)) == EOF) return FALSE;
	MOV  R30,R16
	LDI  R31,0
	__ADDW1MN _rx0buf,9
	LD   R30,Z
	CALL SUBOPT_0x1A
	BRNE _0x82
	LDI  R30,LOW(0)
	RJMP _0x4E0
;    1060 	}
_0x82:
	SUBI R16,-1
	RJMP _0x80
_0x81:
;    1061 	
;    1062 		#ifdef print
;    1063 		printf ("Append abons \r\n");
;    1064 		#endif
;    1065 
;    1066 	return TRUE;
	LDI  R30,LOW(1)
	RJMP _0x4E0
;    1067 }                                                  
;    1068 
;    1069 // удалить запись                           
;    1070 u8 delete_abons (void)
;    1071 {                    
_delete_abons:
;    1072 	u8 temp;
;    1073 	
;    1074 
;    1075 	for (temp = 0; temp < 4; temp++)
	ST   -Y,R16
;	temp -> R16
	LDI  R16,LOW(0)
_0x84:
	CPI  R16,4
	BRSH _0x85
;    1076 	{
;    1077 		if ((fputc (0xFF, fu_user)) == EOF) return FALSE;
	LDI  R30,LOW(255)
	CALL SUBOPT_0x1A
	BRNE _0x86
	LDI  R30,LOW(0)
	RJMP _0x4E0
;    1078 	}                               
_0x86:
	SUBI R16,-1
	RJMP _0x84
_0x85:
;    1079 	
;    1080 		#ifdef print
;    1081 		printf ("Del abons \r\n");
;    1082 		#endif
;    1083 
;    1084 	
;    1085 	return TRUE;
	LDI  R30,LOW(1)
_0x4E0:
	LD   R16,Y+
	RET
;    1086 }
;    1087 
;    1088 // внести запись о количестве абонентов
;    1089 u8 define_abons (void)
;    1090 {
_define_abons:
;    1091 
;    1092 	if (fseek (fu_user,0,SEEK_SET) != EOF) 
	CALL SUBOPT_0x1B
	BREQ _0x87
;    1093 	{
;    1094 		if ((fputc (rx0buf[1], fu_user)) != EOF) 
	__GETB1MN _rx0buf,1
	CALL SUBOPT_0x1A
	BREQ _0x88
;    1095 			if ((fputc (rx0buf[2], fu_user)) != EOF) 
	__GETB1MN _rx0buf,2
	CALL SUBOPT_0x1A
	BREQ _0x89
;    1096 				if ((fputc (rx0buf[3], fu_user)) != EOF) 
	__GETB1MN _rx0buf,3
	CALL SUBOPT_0x1A
	BREQ _0x8A
;    1097 					if ((fputc (rx0buf[4], fu_user)) != EOF)
	__GETB1MN _rx0buf,4
	CALL SUBOPT_0x1A
	BREQ _0x8B
;    1098 					{
;    1099 						#ifdef print
;    1100 						printf ("WR count abons \r\n");
;    1101 						#endif
;    1102 
;    1103 						return TRUE;
	LDI  R30,LOW(1)
	RET
;    1104 					}
;    1105 	}
_0x8B:
_0x8A:
_0x89:
_0x88:
;    1106 
;    1107 	return FALSE;
_0x87:
	LDI  R30,LOW(0)
	RET
;    1108 
;    1109 }
;    1110 
;    1111 
;    1112 // поиск позиции в файле. 
;    1113 u8 found_location_in_file (u8 *pLoc)
;    1114 {
_found_location_in_file:
;    1115   	u32 position = 0;
;    1116 
;    1117 /*	position = ( 													// позиция в файле
;    1118 					((position | rx0buf[8]) <<24) |
;    1119      				((position | rx0buf[7]) <<16) |
;    1120 					((position | rx0buf[6]) << 8) |
;    1121 					  (position | rx0buf[5]) );  
;    1122   */
;    1123 	position = convTOw32 (pLoc);				// получаем 32 разр указатель на позицию
	SBIW R28,4
	LDI  R24,4
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x8C*2)
	LDI  R31,HIGH(_0x8C*2)
	CALL __INITLOCB
;	*pLoc -> Y+4
;	position -> Y+0
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _convTOw32
	__PUTD1S 0
;    1124 
;    1125 	position = ((position - 1) * dann_1_abon) + 4;		//пропускаем начальные 4 байта
	CALL SUBOPT_0x1C
	__PUTD1S 0
;    1126 
;    1127 	//если надо то добиваем до нужной позиции 0XFF
;    1128 	while  ( ftell (fu_user) < position)
_0x8D:
	CALL SUBOPT_0x1D
	MOVW R26,R30
	MOVW R24,R22
	__GETD1S 0
	CALL __CPD21
	BRSH _0x8F
;    1129 	{
;    1130 		fputc (0xFF,fu_user);							
	LDI  R30,LOW(255)
	CALL SUBOPT_0x1E
;    1131 	}
	RJMP _0x8D
_0x8F:
;    1132 	
;    1133 
;    1134 	if ( ! define_abons()) return FALSE;				// вносим запись о количестве абонентов
	CALL _define_abons
	CPI  R30,0
	BRNE _0x90
	LDI  R30,LOW(0)
	RJMP _0x4DF
;    1135 
;    1136 	if (fseek (fu_user,position,SEEK_SET) == EOF) return FALSE; //смещение
_0x90:
	LDS  R30,_fu_user
	LDS  R31,_fu_user+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 2
	CALL SUBOPT_0x1F
	BRNE _0x91
	LDI  R30,LOW(0)
	RJMP _0x4DF
;    1137 
;    1138 		#ifdef print
;    1139 		printf ("Position found-%x \r\n",position);
;    1140 		#endif
;    1141 
;    1142 	switch (FLASH_command)
_0x91:
	LDS  R30,_rx0buf
;    1143 	{
;    1144 		case appendAbon:
	CPI  R30,LOW(0x1)
	BRNE _0x95
;    1145 				if ( ! append_abons ()) return FALSE;		// добавить/изменить запись
	CALL _append_abons
	CPI  R30,0
	BRNE _0x96
	LDI  R30,LOW(0)
	RJMP _0x4DF
;    1146 				break;
_0x96:
	RJMP _0x94
;    1147 
;    1148 		case deleteAbon:
_0x95:
	CPI  R30,LOW(0x2)
	BRNE _0x99
;    1149 				if ( ! delete_abons ()) return FALSE;		// удалить запись
	CALL _delete_abons
	CPI  R30,0
	BRNE _0x98
	LDI  R30,LOW(0)
	RJMP _0x4DF
;    1150 				break;
_0x98:
	RJMP _0x94
;    1151 
;    1152 		default:
_0x99:
;    1153 				return FALSE;
	LDI  R30,LOW(0)
	RJMP _0x4DF
;    1154 	}
_0x94:
;    1155 
;    1156 	return TRUE;
	LDI  R30,LOW(1)
_0x4DF:
	ADIW R28,6
	RET
;    1157 }
;    1158 
;    1159 // закрываем файл
;    1160 u8 close_prog_bin (void)
;    1161 {
_close_prog_bin:
;    1162 
;    1163 	if (fclose (fu_user) == EOF) return FALSE;											// закрываем файл
	LDS  R30,_fu_user
	LDS  R31,_fu_user+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _fclose
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x9A
	LDI  R30,LOW(0)
	RET
;    1164 
;    1165 	#ifdef print
;    1166 	printf ("File CLOSE \r\n");
;    1167 	#endif
;    1168 
;    1169 	return TRUE;
_0x9A:
	LDI  R30,LOW(1)
	RET
;    1170 	
;    1171 }
;    1172 
;    1173 
;    1174 // Открываем файл для чтения / записи
;    1175 u8 open_user_bin (u8 mode)
;    1176 {
_open_user_bin:
;    1177 	u8 temp = 4;
;    1178 
;    1179 	if (prog_bin_mode != (mode & 0x1)) close_prog_bin ();	// закрываем файл при изменении режима
	ST   -Y,R16
;	mode -> Y+1
;	temp -> R16
	LDI  R16,4
	LDI  R30,0
	SBRC R2,3
	LDI  R30,1
	MOV  R26,R30
	LDD  R30,Y+1
	ANDI R30,LOW(0x1)
	CP   R30,R26
	BREQ _0x9B
	CALL _close_prog_bin
;    1180 	else 
	RJMP _0x9C
_0x9B:
;    1181 	{
;    1182 		if ( ftell(fu_user) != EOF )	return TRUE;					// иначе проверяем есть ли файл и выходим если есть
	CALL SUBOPT_0x1D
	__CPD1N 0xFFFFFFFF
	BREQ _0x9D
	LDI  R30,LOW(1)
	RJMP _0x4DE
;    1183 	}
_0x9D:
_0x9C:
;    1184 
;    1185 	if ( mode == rd_file)
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x9E
;    1186 	{
;    1187 		fu_user = fopenc("user.bin", READ);			
	__POINTW1FN _0,15
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
;    1188 
;    1189 		if (fu_user == NULL)												
	BRNE _0x9F
;    1190 		{
;    1191 			#ifdef print
;    1192 			printf ("Open ERROR! \r\n");
;    1193 			#endif
;    1194 			return FALSE;
	LDI  R30,LOW(0)
	RJMP _0x4DE
;    1195 		}
;    1196 
;    1197 		#ifdef print
;    1198 		printf ("File OPEN read \r\n");
;    1199 		#endif
;    1200 
;    1201 	}
_0x9F:
;    1202 	else
	RJMP _0xA0
_0x9E:
;    1203 	{
;    1204 		fu_user = fopenc("user.bin", APPEND);			
	__POINTW1FN _0,15
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL SUBOPT_0x21
;    1205 
;    1206 		if (fu_user == NULL)												
	BRNE _0xA1
;    1207 		{
;    1208 			#ifdef print
;    1209 			printf ("Create NEW file \r\n");
;    1210 			#endif
;    1211 
;    1212 //			if (fquickformat() == EOF) return FALSE;		//перед созданием файла форматируем карту
;    1213 			fu_user = fcreatec ("user.bin",0);
	__POINTW1FN _0,15
	CALL SUBOPT_0x22
	CALL _fcreatec
	STS  _fu_user,R30
	STS  _fu_user+1,R31
;    1214 
;    1215 			if (fu_user == NULL )                                 // ошибка
	SBIW R30,0
	BRNE _0xA2
;    1216 				return FALSE;
	LDI  R30,LOW(0)
	RJMP _0x4DE
;    1217 
;    1218 			while ( temp--)  	fputc (0x00,fu_user);							// место для количества абонентов
_0xA2:
_0xA3:
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BREQ _0xA5
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1E
;    1219 		}                                             
	RJMP _0xA3
_0xA5:
;    1220         
;    1221 		#ifdef print
;    1222 		printf ("File OPEN write \r\n");
;    1223 		#endif
;    1224 
;    1225 	}
_0xA1:
_0xA0:
;    1226 	
;    1227 	prog_bin_mode = mode & 0x1;
	LDD  R30,Y+1
	BST  R30,0
	BLD  R2,3
;    1228 
;    1229 	return TRUE;
	LDI  R30,LOW(1)
_0x4DE:
	LDD  R16,Y+0
	ADIW R28,2
	RET
;    1230 }
;    1231 
;    1232 
;    1233 //Читаем состояние абонента
;    1234 // Входной параметр - MAC абонета, выходной - указатель на 
;    1235 // сторку с разрешениями
;    1236 u8 read_abons (u32 MACabons)
;    1237 {
_read_abons:
;    1238   	u32 position = 0;			// позиция в файле
;    1239   	u32 pos = 0+1;	
;    1240   	u32 a;			      
;    1241 	u32 	countAbons;
;    1242 
;    1243 
;    1244   	MACabons = (MACabons - 1)*2;
	SBIW R28,16
	LDI  R24,8
	LDI  R26,LOW(8)
	LDI  R27,HIGH(8)
	LDI  R30,LOW(_0xA6*2)
	LDI  R31,HIGH(_0xA6*2)
	CALL __INITLOCB
;	MACabons -> Y+16
;	position -> Y+12
;	pos -> Y+8
;	a -> Y+4
;	countAbons -> Y+0
	__GETD1S 16
	__SUBD1N 1
	CALL __LSLD1
	__PUTD1S 16
;    1245 
;    1246 	if ( open_user_bin (rd_file) )	 		// проверяем файл
	CALL SUBOPT_0x8
	CPI  R30,0
	BRNE PC+3
	JMP _0xA7
;    1247 	{
;    1248 		countAbons = getAbons ();			// количество введенных абонентов	
	CALL _getAbons
	__PUTD1S 0
;    1249 
;    1250 		while ( countAbons --)
_0xA8:
	__GETD1S 0
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	__PUTD1S 0
	__SUBD1N -1
	BRNE PC+3
	JMP _0xAA
;    1251 		{
;    1252 			position = pos++;				// получаем 32 разр указатель на позицию
	__GETD1S 8
	__SUBD1N -1
	__PUTD1S 8
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	__PUTD1S 12
;    1253 			position = ((position - 1) * dann_1_abon) + 4;		//пропускаем начальные 4 байта
	CALL SUBOPT_0x1C
	__PUTD1S 12
;    1254 
;    1255 			if ( fseek (fu_user,position,SEEK_SET) != EOF)  //смещение
	LDS  R30,_fu_user
	LDS  R31,_fu_user+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 14
	CALL SUBOPT_0x1F
	BRNE PC+3
	JMP _0xAB
;    1256 			{
;    1257 					a = fgetc(fu_user);
	CALL SUBOPT_0x23
	CALL __CWD1
	__PUTD1S 4
;    1258 					a |= fgetc(fu_user)*256;
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
;    1259 					a |= fgetc(fu_user)*256*256;
	CALL SUBOPT_0x23
	MOV  R31,R30
	LDI  R30,0
	MOV  R31,R30
	LDI  R30,0
	__GETD2S 4
	CALL __CWD1
	CALL __ORD12
	__PUTD1S 4
;    1260 					a |= fgetc(fu_user)*256*256*256;         
	CALL SUBOPT_0x23
	MOV  R31,R30
	LDI  R30,0
	MOV  R31,R30
	LDI  R30,0
	CALL SUBOPT_0x24
;    1261 
;    1262 					if (a == MACabons)
	__GETD1S 16
	__GETD2S 4
	CALL __CPD12
	BREQ PC+3
	JMP _0xAC
;    1263 					{
;    1264 						StartReply(dann_1_abon);         		// передаем
	LDI  R30,LOW(132)
	ST   -Y,R30
	CALL _StartReply
;    1265 
;    1266 						putchar0(a);						// MAC адрес
	LDD  R30,Y+4
	CALL SUBOPT_0x25
;    1267 						putchar0(a>>8);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x26
;    1268 						putchar0(a>>16);
	__GETD1S 4
	CALL __LSRD16
	CALL SUBOPT_0x25
;    1269 						putchar0(a>>24);
	LDI  R30,LOW(24)
	CALL SUBOPT_0x26
;    1270 
;    1271 	 					for (a = 0; a<(dann_1_abon - 4); a ++)		// данные
	__CLRD1S 4
_0xAE:
	__GETD2S 4
	__CPD2N 0x80
	BRSH _0xAF
;    1272 						{
;    1273 							if (feof(fu_user)) 
	CALL SUBOPT_0x27
	BREQ _0xB0
;    1274 							{
;    1275 								putchar0 (0);
	LDI  R30,LOW(0)
	RJMP _0x4EB
;    1276 								#ifdef print
;    1277 								printf ("Error READ! \r\n");
;    1278 								#endif    
;    1279 							}
;    1280 							else
_0xB0:
;    1281 							{
;    1282 //								#ifdef print
;    1283 //								printf ("%x ",fgetc(fu_user));
;    1284 //								#endif    
;    1285 
;    1286 								putchar0(fgetc(fu_user));
	CALL SUBOPT_0x23
_0x4EB:
	ST   -Y,R30
	CALL _putchar0
;    1287 							}
;    1288 						}
	__GETD1S 4
	__SUBD1N -1
	__PUTD1S 4
	RJMP _0xAE
_0xAF:
;    1289 						EndReply();
	CALL _EndReply
;    1290 						return TRUE;
	LDI  R30,LOW(1)
	RJMP _0x4DD
;    1291 					}
;    1292 			}
_0xAC:
;    1293 		}
_0xAB:
	RJMP _0xA8
_0xAA:
;    1294 	
;    1295 		#ifdef print
;    1296 		printf ("readAbons NOT Found! \r\n");
;    1297 		#endif    
;    1298 
;    1299     }
;    1300 	return FALSE;
_0xA7:
	LDI  R30,LOW(0)
_0x4DD:
	ADIW R28,20
	RET
;    1301 }
;    1302 
;    1303 
;    1304 
;    1305 
;    1306 ///////////////////////////////////////////////////////////////////
;    1307 // Формат входного пакета: 
;    1308 //		1 - номер задания (	1 - добавить абонента, 
;    1309 //										2 - удалить абонента, 
;    1310 //										3 - передается список каналов(кодирован/некодирован)
;    1311 //										4 - прочитать разрешения абонента (передан  4b MAC);
;    1312 //										5 - процесс заливки файла в АРМ процессоре на карточку
;    1313 //										)
;    1314 //		2...5 - максимальное значение номера места;
;    1315 //		6...9 - номер места куда произвести запись;
;    1316 //		10...13 - МАС адрес абонента;
;    1317 //		14...137 - содержимое для передачи в канал;
;    1318 //  Как хранится на карте - 	1...4 - максимальное значение номера места;
;    1319 //												5...8 -  МАС адрес абонента;
;    1320 //												9...132 - содержимое для передачи в канал;
;    1321 
;    1322 void flash_Work (void)
;    1323 {  
_flash_Work:
;    1324 //	u8 status = TRUE;  	
;    1325   
;    1326 	if ( ! CF_card_INI_OK ) Reply(FALSE);	// CF карта не готова 
	SBRC R2,2
	RJMP _0xB2
	CALL SUBOPT_0xB
;    1327 	else
	RJMP _0xB3
_0xB2:
;    1328 	{
;    1329 		switch (FLASH_command)
	LDS  R30,_rx0buf
;    1330 		{
;    1331 			case appendAbon:							// работаем с пакетами юзеров
	CPI  R30,LOW(0x1)
	BREQ _0xB8
;    1332 			case deleteAbon:							// открываем базу. Если файла нет - создаем.
	CPI  R30,LOW(0x2)
	BRNE _0xB9
_0xB8:
;    1333 				#ifdef print
;    1334 				printf ("Rx pack user.bin \r\n");
;    1335 				#endif    
;    1336 				if ( open_user_bin (wr_file) ) 
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _open_user_bin
	CPI  R30,0
	BREQ _0xBA
;    1337 				{
;    1338 					if (found_location_in_file(&rx0buf[5]) )
	__POINTW1MN _rx0buf,5
	ST   -Y,R31
	ST   -Y,R30
	CALL _found_location_in_file
	CPI  R30,0
	BREQ _0xBB
;    1339 					{
;    1340 						open_user_bin (rd_file);							// открываем БД юзеров (prog.bin)
	CALL SUBOPT_0x8
;    1341 					 	Reply (TRUE);                                      // сначала откр. файл а потом передаем. Иначе не успевает
	LDI  R30,LOW(1)
	RJMP _0x4EC
;    1342 					 }
;    1343 					else 
_0xBB:
;    1344 					{
;    1345 						open_user_bin (rd_file);							// открываем БД юзеров (prog.bin)
	CALL SUBOPT_0x8
;    1346 						Reply (FALSE); 
	LDI  R30,LOW(0)
_0x4EC:
	ST   -Y,R30
	CALL _Reply
;    1347 					}
;    1348 				}
;    1349 				else Reply (FALSE);
	RJMP _0xBD
_0xBA:
	CALL SUBOPT_0xB
;    1350 
;    1351 				break;
_0xBD:
	RJMP _0xB6
;    1352 
;    1353 			case pack_for_scremb:  				// работаем с пакетом для кодера
_0xB9:
	CPI  R30,LOW(0x3)
	BRNE _0xBE
;    1354 				#ifdef print
;    1355 				printf ("Rx pack for coder \r\n");
;    1356 				#endif    
;    1357 
;    1358 				check_fprog();
	CALL _check_fprog
;    1359 				Reply(TRUE);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _Reply
;    1360 				break;
	RJMP _0xB6
;    1361 
;    1362 			case pack_readAbons:
_0xBE:
	CPI  R30,LOW(0x4)
	BRNE _0xC1
;    1363 				#ifdef print
;    1364 				printf ("Rx pack readAbons \r\n");
;    1365 				#endif    
;    1366 		
;    1367 				if (! read_abons (convTOw32 (&rx0buf[5]))) Reply (FALSE);                             
	__POINTW1MN _rx0buf,5
	ST   -Y,R31
	ST   -Y,R30
	CALL _convTOw32
	CALL __PUTPARD1
	CALL _read_abons
	CPI  R30,0
	BRNE _0xC0
	CALL SUBOPT_0xB
;    1368 
;    1369 				break;
_0xC0:
;    1370 
;    1371 			default:
_0xC1:
;    1372 				break;
;    1373 		}
_0xB6:
;    1374 	}
_0xB3:
;    1375 
;    1376 
;    1377 /*
;    1378 	// работаем с пакетом для кодера
;    1379 	if (FLASH_command == pack_for_scremb)
;    1380 	{
;    1381 		#ifdef print
;    1382 		printf ("Rx pack for coder \r\n");
;    1383 		#endif    
;    1384 
;    1385 		check_fprog();
;    1386 
;    1387 		return TRUE;		
;    1388 	}
;    1389 
;    1390 	if ( ! CF_card_INI_OK ) return FALSE;		// CF карта не готова 
;    1391 	
;    1392 	if (FLASH_command == pack_readAbons)
;    1393 	{                                                           
;    1394 		#ifdef print
;    1395 		printf ("Rx pack readAbons \r\n");
;    1396 		#endif    
;    1397 		
;    1398 		if (! read_abons ()) return FALSE;                             
;    1399 		else return TRUE;
;    1400 		
;    1401 	}
;    1402 
;    1403 
;    1404 	// работаем с пакетами юзеров
;    1405 	// открываем базу. Если файла нет - создаем.
;    1406 	#ifdef print
;    1407 	printf ("Rx pack user.bin \r\n");
;    1408 	#endif    
;    1409 
;    1410 	if ( !open_prog_bin (wr_file) ) return FALSE;
;    1411 
;    1412 	if (! found_location_in_file(&rx0buf[5]) ) status = FALSE;
;    1413 	else status = TRUE; 
;    1414 
;    1415 	open_prog_bin (rd_file);							// открываем БД юзеров (prog.bin)
;    1416 
;    1417 	return status;	*/
;    1418 }
	RET
;    1419 
;    1420 
;    1421 
;    1422 	
;    1423 /*
;    1424 	Progressive Resources LLC
;    1425                                     
;    1426 			FlashFile
;    1427 	
;    1428 	Version : 	1.32
;    1429 	Date: 		12/31/2003
;    1430 	Author: 	Erick M. Higa
;    1431                                            
;    1432 	Software License
;    1433 	The use of Progressive Resources LLC FlashFile Source Package indicates 
;    1434 	your understanding and acceptance of the following terms and conditions. 
;    1435 	This license shall supersede any verbal or prior verbal or written, statement 
;    1436 	or agreement to the contrary. If you do not understand or accept these terms, 
;    1437 	or your local regulations prohibit "after sale" license agreements or limited 
;    1438 	disclaimers, you must cease and desist using this product immediately.
;    1439 	This product is © Copyright 2003 by Progressive Resources LLC, all rights 
;    1440 	reserved. International copyright laws, international treaties and all other 
;    1441 	applicable national or international laws protect this product. This software 
;    1442 	product and documentation may not, in whole or in part, be copied, photocopied, 
;    1443 	translated, or reduced to any electronic medium or machine readable form, without 
;    1444 	prior consent in writing, from Progressive Resources LLC and according to all 
;    1445 	applicable laws. The sole owner of this product is Progressive Resources LLC.
;    1446 
;    1447 	Operating License
;    1448 	You have the non-exclusive right to use any enclosed product but have no right 
;    1449 	to distribute it as a source code product without the express written permission 
;    1450 	of Progressive Resources LLC. Use over a "local area network" (within the same 
;    1451 	locale) is permitted provided that only a single person, on a single computer 
;    1452 	uses the product at a time. Use over a "wide area network" (outside the same 
;    1453 	locale) is strictly prohibited under any and all circumstances.
;    1454                                            
;    1455 	Liability Disclaimer
;    1456 	This product and/or license is provided as is, without any representation or 
;    1457 	warranty of any kind, either express or implied, including without limitation 
;    1458 	any representations or endorsements regarding the use of, the results of, or 
;    1459 	performance of the product, Its appropriateness, accuracy, reliability, or 
;    1460 	correctness. The user and/or licensee assume the entire risk as to the use of 
;    1461 	this product. Progressive Resources LLC does not assume liability for the use 
;    1462 	of this product beyond the original purchase price of the software. In no event 
;    1463 	will Progressive Resources LLC be liable for additional direct or indirect 
;    1464 	damages including any lost profits, lost savings, or other incidental or 
;    1465 	consequential damages arising from any defects, or the use or inability to 
;    1466 	use these products, even if Progressive Resources LLC have been advised of 
;    1467 	the possibility of such damages.
;    1468 */                                 
;    1469 
;    1470 /*
;    1471 #include _AVR_LIB_
;    1472 #include <stdio.h>
;    1473 
;    1474 #ifndef _file_sys_h_
;    1475 	#include "..\flash\file_sys.h"
;    1476 #endif
;    1477 */
;    1478 	#include <coding.h>
;    1479 
;    1480 unsigned long OCR_REG;

	.DSEG
_OCR_REG:
	.BYTE 0x4
;    1481 unsigned char _FF_buff[512];
__FF_buff:
	.BYTE 0x200
;    1482 unsigned int PT_SecStart;
_PT_SecStart:
	.BYTE 0x2
;    1483 unsigned long BS_jmpBoot;
_BS_jmpBoot:
	.BYTE 0x4
;    1484 unsigned int BPB_BytsPerSec;
_BPB_BytsPerSec:
	.BYTE 0x2
;    1485 unsigned char BPB_SecPerClus;
_BPB_SecPerClus:
	.BYTE 0x1
;    1486 unsigned int BPB_RsvdSecCnt;
_BPB_RsvdSecCnt:
	.BYTE 0x2
;    1487 unsigned char BPB_NumFATs;
_BPB_NumFATs:
	.BYTE 0x1
;    1488 unsigned int BPB_RootEntCnt;
_BPB_RootEntCnt:
	.BYTE 0x2
;    1489 unsigned int BPB_FATSz16;
_BPB_FATSz16:
	.BYTE 0x2
;    1490 unsigned char BPB_FATType;
_BPB_FATType:
	.BYTE 0x1
;    1491 unsigned long BPB_TotSec;
_BPB_TotSec:
	.BYTE 0x4
;    1492 unsigned long BS_VolSerial;
_BS_VolSerial:
	.BYTE 0x4
;    1493 unsigned char BS_VolLab[12];
_BS_VolLab:
	.BYTE 0xC
;    1494 unsigned long _FF_PART_ADDR, _FF_ROOT_ADDR, _FF_DIR_ADDR;
__FF_PART_ADDR:
	.BYTE 0x4
__FF_ROOT_ADDR:
	.BYTE 0x4
__FF_DIR_ADDR:
	.BYTE 0x4
;    1495 unsigned long _FF_FAT1_ADDR, _FF_FAT2_ADDR;
__FF_FAT1_ADDR:
	.BYTE 0x4
__FF_FAT2_ADDR:
	.BYTE 0x4
;    1496 unsigned long _FF_RootDirSectors;
__FF_RootDirSectors:
	.BYTE 0x4
;    1497 unsigned int FirstDataSector;
_FirstDataSector:
	.BYTE 0x2
;    1498 unsigned long FirstSectorofCluster;
_FirstSectorofCluster:
	.BYTE 0x4
;    1499 unsigned char _FF_error;
__FF_error:
	.BYTE 0x1
;    1500 unsigned long _FF_buff_addr;
__FF_buff_addr:
	.BYTE 0x4
;    1501 extern unsigned long clus_0_addr, _FF_n_temp;
;    1502 extern unsigned int c_counter;
;    1503 //extern unsigned char _FF_FULL_PATH[_FF_PATH_LENGTH];
;    1504 
;    1505 unsigned long DataClusTot;
_DataClusTot:
	.BYTE 0x4
;    1506 
;    1507 flash struct CMD
;    1508 {
;    1509 	unsigned int index;
;    1510 	unsigned int tx_data;
;    1511 	unsigned int arg;
;    1512 	unsigned int resp;
;    1513 };
;    1514 
;    1515 flash struct CMD sd_cmd[CMD_TOT] =

	.CSEG
;    1516 {
;    1517 	{CMD0,	0x40,	NO_ARG,		RESP_1},		// GO_IDLE_STATE
;    1518 	{CMD1,	0x41,	NO_ARG,		RESP_1},		// SEND_OP_COND (ACMD41 = 0x69)
;    1519 	{CMD9,	0x49,	NO_ARG,		RESP_1},		// SEND_CSD
;    1520 	{CMD10,	0x4A,	NO_ARG,		RESP_1},		// SEND_CID
;    1521 	{CMD12,	0x4C,	NO_ARG,		RESP_1},		// STOP_TRANSMISSION
;    1522 	{CMD13,	0x4D,	NO_ARG,		RESP_2},		// SEND_STATUS
;    1523 	{CMD16,	0x50,	BLOCK_LEN,	RESP_1},		// SET_BLOCKLEN
;    1524 	{CMD17, 0x51,	DATA_ADDR,	RESP_1},		// READ_SINGLE_BLOCK
;    1525 	{CMD18, 0x52,	DATA_ADDR,	RESP_1},		// READ_MULTIPLE_BLOCK
;    1526 	{CMD24, 0x58,	DATA_ADDR,	RESP_1},		// WRITE_BLOCK
;    1527 	{CMD25, 0x59,	DATA_ADDR,	RESP_1},		// WRITE_MULTIPLE_BLOCK
;    1528 	{CMD27,	0x5B,	NO_ARG,		RESP_1},		// PROGRAM_CSD
;    1529 	{CMD28, 0x5C,	DATA_ADDR,	RESP_1b},		// SET_WRITE_PROT
;    1530 	{CMD29, 0x5D,	DATA_ADDR,	RESP_1b},		// CLR_WRITE_PROT
;    1531 	{CMD30, 0x5E,	DATA_ADDR,	RESP_1},		// SEND_WRITE_PROT
;    1532 	{CMD32,	0x60,	DATA_ADDR,	RESP_1},		// TAG_SECTOR_START
;    1533 	{CMD33,	0x61,	DATA_ADDR,	RESP_1},		// TAG_SECTOR_END
;    1534 	{CMD34,	0x62,	DATA_ADDR,	RESP_1},		// UNTAG_SECTOR
;    1535 	{CMD35,	0x63,	DATA_ADDR,	RESP_1},		// TAG_ERASE_GROUP_START
;    1536 	{CMD36,	0x64,	DATA_ADDR,	RESP_1},		// TAG_ERASE_GROUP_END
;    1537 	{CMD37,	0x65,	DATA_ADDR,	RESP_1},		// TAG_ERASE_GROUP
;    1538 	{CMD38,	0x66,	STUFF_BITS,	RESP_1b},		// ERASE
;    1539 	{CMD42,	0x6A,	STUFF_BITS,	RESP_1b},		// LOCK_UNLOCK
;    1540 	{CMD58,	0x7A,	NO_ARG,		RESP_3},		// READ_OCR
;    1541 	{CMD59,	0x7B,	STUFF_BITS,	RESP_1},		// CRC_ON_OFF
;    1542 	{ACMD41, 0x69,	NO_ARG,		RESP_1}
;    1543 };
;    1544 
;    1545 unsigned char _FF_spi(unsigned char mydata)
;    1546 {
__FF_spi:
;    1547     SPDR = mydata;          //byte 1
	LD   R30,Y
	OUT  0xF,R30
;    1548     while ((SPSR&0x80) == 0); 
_0xC2:
	SBIS 0xE,7
	RJMP _0xC2
;    1549     return SPDR;
	IN   R30,0xF
	RJMP _0x4D7
;    1550 }
;    1551 	
;    1552 unsigned int send_cmd(unsigned char command, unsigned long argument)
;    1553 {
_send_cmd:
;    1554 	unsigned char spi_data_out;
;    1555 	unsigned char response_1;
;    1556 	unsigned long response_2;
;    1557 	unsigned int c, i;
;    1558 	
;    1559 	SD_CS_ON();			// select chip
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
;    1560 	
;    1561 	spi_data_out = sd_cmd[command].tx_data;
	LDD  R26,Y+14
	CLR  R27
	__POINTWRFN 22,23,_sd_cmd,2
	CALL SUBOPT_0x28
	LPM  R16,Z
;    1562 	_FF_spi(spi_data_out);
	ST   -Y,R16
	CALL SUBOPT_0x29
;    1563 	
;    1564 	c = sd_cmd[command].arg;
	__POINTWRFN 22,23,_sd_cmd,4
	CALL SUBOPT_0x28
	CALL __GETW1PF
	MOVW R18,R30
;    1565 	if (c == NO_ARG)
	MOV  R0,R18
	OR   R0,R19
	BRNE _0xC5
;    1566 		for (i=0; i<4; i++)
	__GETWRN 20,21,0
_0xC7:
	__CPWRN 20,21,4
	BRSH _0xC8
;    1567 			_FF_spi(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL __FF_spi
;    1568 	else
	__ADDWRN 20,21,1
	RJMP _0xC7
_0xC8:
	RJMP _0xC9
_0xC5:
;    1569 	{
;    1570 		spi_data_out = (argument & 0xFF000000) >> 24;
	__GETD1S 10
	__ANDD1N 0xFF000000
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(24)
	CALL SUBOPT_0x2A
;    1571 		_FF_spi(spi_data_out);
;    1572 		spi_data_out = (argument & 0x00FF0000) >> 16;
	__ANDD1N 0xFF0000
	CALL __LSRD16
	CALL SUBOPT_0x2B
;    1573 		_FF_spi(spi_data_out);
;    1574 		spi_data_out = (argument & 0x0000FF00) >> 8;
	__GETD1S 10
	__ANDD1N 0xFF00
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(8)
	CALL SUBOPT_0x2A
;    1575 		_FF_spi(spi_data_out);
;    1576 		spi_data_out = (argument & 0x000000FF);
	__ANDD1N 0xFF
	CALL SUBOPT_0x2B
;    1577 		_FF_spi(spi_data_out);
;    1578 	}
_0xC9:
;    1579 	if (command == CMD0)
	LDD  R30,Y+14
	CPI  R30,0
	BRNE _0xCA
;    1580 		spi_data_out = 0x95;		// CRC byte, don't care except for first signal=0x95
	LDI  R16,LOW(149)
;    1581 	else
	RJMP _0xCB
_0xCA:
;    1582 		spi_data_out = 0xFF;
	LDI  R16,LOW(255)
;    1583 	_FF_spi(spi_data_out);
_0xCB:
	ST   -Y,R16
	CALL SUBOPT_0x2C
;    1584 	_FF_spi(0xff);	
	CALL SUBOPT_0x29
;    1585 	c = sd_cmd[command].resp;
	__POINTWRFN 22,23,_sd_cmd,6
	CALL SUBOPT_0x28
	CALL __GETW1PF
	MOVW R18,R30
;    1586 	switch(c)
	MOVW R30,R18
;    1587 	{
;    1588 		case RESP_1:
	SBIW R30,0
	BRNE _0xCF
;    1589 			return (_FF_spi(0xFF));
	CALL SUBOPT_0x2D
	LDI  R31,0
	RJMP _0x4DC
;    1590 			break;
;    1591 		case RESP_1b:
_0xCF:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xD0
;    1592 			response_1 = _FF_spi(0xFF);
	CALL SUBOPT_0x2D
	MOV  R17,R30
;    1593 			response_2 = 0;
	__CLRD1S 6
;    1594 			while (response_2 == 0)
_0xD1:
	__GETD1S 6
	CALL __CPD10
	BRNE _0xD3
;    1595 				response_2 = _FF_spi(0xFF);
	CALL SUBOPT_0x2D
	CLR  R31
	CLR  R22
	CLR  R23
	__PUTD1S 6
;    1596 			return (response_1);
	RJMP _0xD1
_0xD3:
	MOV  R30,R17
	LDI  R31,0
	RJMP _0x4DC
;    1597 			break;
;    1598 		case RESP_2:
_0xD0:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xD4
;    1599 			response_2 = _FF_spi(0xFF);
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2E
;    1600 			response_2 = (response_2 << 8) | _FF_spi(0xFF);
	LDI  R30,LOW(8)
	CALL __LSLD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x2D
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __ORD12
	__PUTD1S 6
;    1601 			return (response_2);
	RJMP _0x4DC
;    1602 			break;
;    1603 		case RESP_3:
_0xD4:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0xCE
;    1604 			response_1 = _FF_spi(0xFF);
	CALL SUBOPT_0x2D
	MOV  R17,R30
;    1605 			OCR_REG = 0;
	LDI  R30,0
	STS  _OCR_REG,R30
	STS  _OCR_REG+1,R30
	STS  _OCR_REG+2,R30
	STS  _OCR_REG+3,R30
;    1606 			response_2 = _FF_spi(0xFF);
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2E
;    1607 			OCR_REG = response_2 << 24;
	LDI  R30,LOW(24)
	CALL __LSLD12
	STS  _OCR_REG,R30
	STS  _OCR_REG+1,R31
	STS  _OCR_REG+2,R22
	STS  _OCR_REG+3,R23
;    1608 			response_2 = _FF_spi(0xFF);
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2F
;    1609 			OCR_REG |= (response_2 << 16);
	CALL __LSLD16
	CALL SUBOPT_0x30
;    1610 			response_2 = _FF_spi(0xFF);
	CALL SUBOPT_0x2E
;    1611 			OCR_REG |= (response_2 << 8);
	LDI  R30,LOW(8)
	CALL __LSLD12
	CALL SUBOPT_0x30
;    1612 			response_2 = _FF_spi(0xFF);
	CALL SUBOPT_0x2F
;    1613 			OCR_REG |= (response_2);
	LDS  R26,_OCR_REG
	LDS  R27,_OCR_REG+1
	LDS  R24,_OCR_REG+2
	LDS  R25,_OCR_REG+3
	CALL __ORD12
	STS  _OCR_REG,R30
	STS  _OCR_REG+1,R31
	STS  _OCR_REG+2,R22
	STS  _OCR_REG+3,R23
;    1614 			return (response_1);
	MOV  R30,R17
	LDI  R31,0
	RJMP _0x4DC
;    1615 			break;
;    1616 	}
_0xCE:
;    1617 	return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x4DC:
	CALL __LOADLOCR6
	ADIW R28,15
	RET
;    1618 }
;    1619 
;    1620 void clear_sd_buff(void)
;    1621 {
_clear_sd_buff:
;    1622 	SD_CS_OFF();
	SBI  0x18,4
;    1623 	_FF_spi(0xFF);
	CALL SUBOPT_0x31
;    1624 	_FF_spi(0xFF);
	CALL __FF_spi
;    1625 }	
	RET
;    1626 
;    1627 unsigned char initialize_media(void)
;    1628 {
_initialize_media:
;    1629 	unsigned char data_temp;
;    1630 	unsigned long n;
;    1631 	
;    1632 	// SPI BUS SETUP
;    1633 	// SPI initialization
;    1634 	// SPI Type: Master
;    1635 	// SPI Clock Rate: 921.600 kHz
;    1636 	// SPI Clock Phase: Cycle Half
;    1637 	// SPI Clock Polarity: Low
;    1638 	// SPI Data Order: MSB First
;    1639 	DDRB |= 0x07;		// Set SS, SCK, and MOSI to Output (If not output, processor will be a slave)
	SBIW R28,4
	ST   -Y,R16
;	data_temp -> R16
;	n -> Y+1
	IN   R30,0x17
	ORI  R30,LOW(0x7)
	OUT  0x17,R30
;    1640 	DDRB &= 0xF7;		// Set MISO to Input
	CBI  0x17,3
;    1641 	CS_DDR_SET();		// Set CS to Output
	SBI  0x17,4
;    1642 	SPCR=0x50;
	CALL SUBOPT_0x32
;    1643 	SPSR=0x00;
	OUT  0xE,R30
;    1644 		
;    1645 	BPB_BytsPerSec = 512;	// Initialize sector size to 512 (all SD cards have a 512 sector size)
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	STS  _BPB_BytsPerSec,R30
	STS  _BPB_BytsPerSec+1,R31
;    1646     _FF_n_temp = 0;
	LDI  R30,0
	STS  __FF_n_temp,R30
	STS  __FF_n_temp+1,R30
	STS  __FF_n_temp+2,R30
	STS  __FF_n_temp+3,R30
;    1647 	if (reset_sd()==0)
	RCALL _reset_sd
	CPI  R30,0
	BRNE _0xD6
;    1648 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x4DB
;    1649 	// delay_ms(50);
;    1650 	for (n=0; ((n<100)||(data_temp==0)) ; n++)
_0xD6:
	__CLRD1S 1
_0xD8:
	__GETD2S 1
	__CPD2N 0x64
	BRLO _0xDA
	CPI  R16,0
	BRNE _0xD9
_0xDA:
;    1651 	{
;    1652 		SD_CS_ON();
	CBI  0x18,4
;    1653 		data_temp = _FF_spi(0xFF);
	CALL SUBOPT_0x2D
	MOV  R16,R30
;    1654 		SD_CS_OFF();
	SBI  0x18,4
;    1655 	}
	CALL SUBOPT_0x33
	RJMP _0xD8
_0xD9:
;    1656 	// delay_ms(50);
;    1657 	for (n=0; n<100; n++)
	__CLRD1S 1
_0xDD:
	__GETD2S 1
	__CPD2N 0x64
	BRSH _0xDE
;    1658 	{
;    1659 		if (init_sd())		// Initialization Succeeded
	RCALL _init_sd
	CPI  R30,0
	BRNE _0xDE
;    1660 			break;
;    1661 		if (n==99)
	__GETD2S 1
	__CPD2N 0x63
	BRNE _0xE0
;    1662 			return (0);
	LDI  R30,LOW(0)
	RJMP _0x4DB
;    1663 	}
_0xE0:
	CALL SUBOPT_0x33
	RJMP _0xDD
_0xDE:
;    1664 
;    1665 	if (_FF_read(0x0)==0)
	__GETD1N 0x0
	CALL SUBOPT_0x34
	BRNE _0xE1
;    1666 	{
;    1667 		#ifdef _DEBUG_ON_
;    1668 			printf("\n\rREAD_ERR"); 		
;    1669 		#endif
;    1670 		_FF_error = INIT_ERR;
	CALL SUBOPT_0x35
;    1671 		return (0);
	RJMP _0x4DB
;    1672 	}
;    1673 	PT_SecStart = ((int) _FF_buff[0x1c7] << 8) | (int) _FF_buff[0x1c6];
_0xE1:
	__GETBRMN 27,__FF_buff,455
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,454
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _PT_SecStart,R30
	STS  _PT_SecStart+1,R31
;    1674 	
;    1675 	if ((((_FF_buff[0]==0xEB)&&(_FF_buff[2]==0x90))||(_FF_buff[0]==0xE9)) && ((_FF_buff[510]==0x55)&&(_FF_buff[511]==0xAA)))
	LDS  R26,__FF_buff
	CPI  R26,LOW(0xEB)
	BRNE _0xE3
	__GETB1MN __FF_buff,2
	CPI  R30,LOW(0x90)
	BREQ _0xE5
_0xE3:
	LDS  R26,__FF_buff
	CPI  R26,LOW(0xE9)
	BRNE _0xE7
_0xE5:
	__GETB1MN __FF_buff,510
	CPI  R30,LOW(0x55)
	BRNE _0xE8
	__GETB1MN __FF_buff,511
	CPI  R30,LOW(0xAA)
	BREQ _0xE9
_0xE8:
	RJMP _0xE7
_0xE9:
	RJMP _0xEA
_0xE7:
	RJMP _0xE2
_0xEA:
;    1676     	PT_SecStart = 0;
	LDI  R30,0
	STS  _PT_SecStart,R30
	STS  _PT_SecStart+1,R30
;    1677  
;    1678 	_FF_PART_ADDR = (long) PT_SecStart * (long) BPB_BytsPerSec;
_0xE2:
	LDS  R30,_PT_SecStart
	LDS  R31,_PT_SecStart+1
	CALL SUBOPT_0x36
	STS  __FF_PART_ADDR,R30
	STS  __FF_PART_ADDR+1,R31
	STS  __FF_PART_ADDR+2,R22
	STS  __FF_PART_ADDR+3,R23
;    1679 
;    1680 	if (PT_SecStart)
	LDS  R30,_PT_SecStart
	LDS  R31,_PT_SecStart+1
	SBIW R30,0
	BREQ _0xEB
;    1681 	{
;    1682 		if (_FF_read(_FF_PART_ADDR)==0)
	LDS  R30,__FF_PART_ADDR
	LDS  R31,__FF_PART_ADDR+1
	LDS  R22,__FF_PART_ADDR+2
	LDS  R23,__FF_PART_ADDR+3
	CALL SUBOPT_0x34
	BRNE _0xEC
;    1683 		{
;    1684 		   	#ifdef _DEBUG_ON_
;    1685 				printf("\n\rREAD_ERR");
;    1686 			#endif
;    1687 			_FF_error = INIT_ERR;
	CALL SUBOPT_0x35
;    1688 			return (0);
	RJMP _0x4DB
;    1689 		}
;    1690 	}
_0xEC:
;    1691 
;    1692  	#ifdef _DEBUG_ON_
;    1693 		printf("\n\rBoot_Sec: [0x%X %X %X] [0x%X] [0x%X]", _FF_buff[0],_FF_buff[1],_FF_buff[2],_FF_buff[510],_FF_buff[511]); 		
;    1694 	#endif
;    1695    	
;    1696     BS_jmpBoot = (((long) _FF_buff[0] << 16) | ((int) _FF_buff[1] << 8) | (int) _FF_buff[2]);    		
_0xEB:
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
;    1697 	BPB_BytsPerSec = ((int) _FF_buff[0xC] << 8) | (int) _FF_buff[0xB];
	__GETBRMN 27,__FF_buff,12
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,11
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _BPB_BytsPerSec,R30
	STS  _BPB_BytsPerSec+1,R31
;    1698     BPB_SecPerClus = _FF_buff[0xD];
	__GETB1MN __FF_buff,13
	STS  _BPB_SecPerClus,R30
;    1699 	BPB_RsvdSecCnt = ((int) _FF_buff[0xF] << 8) | (int) _FF_buff[0xE];	
	__GETBRMN 27,__FF_buff,15
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,14
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _BPB_RsvdSecCnt,R30
	STS  _BPB_RsvdSecCnt+1,R31
;    1700 	BPB_NumFATs = _FF_buff[0x10];
	__GETB1MN __FF_buff,16
	STS  _BPB_NumFATs,R30
;    1701 	BPB_RootEntCnt = ((int) _FF_buff[0x12] << 8) | (int) _FF_buff[0x11];	
	__GETBRMN 27,__FF_buff,18
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,17
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _BPB_RootEntCnt,R30
	STS  _BPB_RootEntCnt+1,R31
;    1702 	BPB_FATSz16 = ((int) _FF_buff[0x17] << 8) | (int) _FF_buff[0x16];
	__GETBRMN 27,__FF_buff,23
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,22
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _BPB_FATSz16,R30
	STS  _BPB_FATSz16+1,R31
;    1703 	BPB_TotSec = ((unsigned int) _FF_buff[0x14] << 8) | (unsigned int) _FF_buff[0x13];
	__GETBRMN 27,__FF_buff,20
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,19
	CALL SUBOPT_0x37
	STS  _BPB_TotSec,R30
	STS  _BPB_TotSec+1,R31
	STS  _BPB_TotSec+2,R22
	STS  _BPB_TotSec+3,R23
;    1704 	if (BPB_TotSec==0)
	CALL __CPD10
	BRNE _0xED
;    1705 		BPB_TotSec = ((unsigned long) _FF_buff[0x23] << 24) | ((unsigned long) _FF_buff[0x22] << 16)
;    1706 					| ((unsigned long) _FF_buff[0x21] << 8) | ((unsigned long) _FF_buff[0x20]);
	__GETB1MN __FF_buff,35
	CALL SUBOPT_0x38
	__GETB1MN __FF_buff,34
	CALL SUBOPT_0x39
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETB1MN __FF_buff,33
	CALL SUBOPT_0x3A
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
;    1707 	BS_VolSerial = ((unsigned long) _FF_buff[0x2A] << 24) | ((unsigned long) _FF_buff[0x29] << 16)
_0xED:
;    1708 				| ((unsigned long) _FF_buff[0x28] << 8) | ((unsigned long) _FF_buff[0x27]);
	__GETB1MN __FF_buff,42
	CALL SUBOPT_0x38
	__GETB1MN __FF_buff,41
	CALL SUBOPT_0x39
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETB1MN __FF_buff,40
	CALL SUBOPT_0x3A
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
;    1709 	for (n=0; n<11; n++)
	__CLRD1S 1
_0xEF:
	__GETD2S 1
	__CPD2N 0xB
	BRSH _0xF0
;    1710 		BS_VolLab[n] = _FF_buff[0x2B+n];
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
;    1711 	BS_VolLab[11] = 0;		// Terminate the string
	CALL SUBOPT_0x33
	RJMP _0xEF
_0xF0:
	LDI  R30,LOW(0)
	__PUTB1MN _BS_VolLab,11
;    1712 	_FF_FAT1_ADDR = _FF_PART_ADDR + ((long) BPB_RsvdSecCnt * (long) BPB_BytsPerSec); 
	LDS  R30,_BPB_RsvdSecCnt
	LDS  R31,_BPB_RsvdSecCnt+1
	CALL SUBOPT_0x36
	LDS  R26,__FF_PART_ADDR
	LDS  R27,__FF_PART_ADDR+1
	LDS  R24,__FF_PART_ADDR+2
	LDS  R25,__FF_PART_ADDR+3
	CALL __ADDD12
	STS  __FF_FAT1_ADDR,R30
	STS  __FF_FAT1_ADDR+1,R31
	STS  __FF_FAT1_ADDR+2,R22
	STS  __FF_FAT1_ADDR+3,R23
;    1713 	_FF_FAT2_ADDR = _FF_FAT1_ADDR + ((long) BPB_FATSz16 * (long) BPB_BytsPerSec);
	LDS  R30,_BPB_FATSz16
	LDS  R31,_BPB_FATSz16+1
	CALL SUBOPT_0x36
	LDS  R26,__FF_FAT1_ADDR
	LDS  R27,__FF_FAT1_ADDR+1
	LDS  R24,__FF_FAT1_ADDR+2
	LDS  R25,__FF_FAT1_ADDR+3
	CALL __ADDD12
	STS  __FF_FAT2_ADDR,R30
	STS  __FF_FAT2_ADDR+1,R31
	STS  __FF_FAT2_ADDR+2,R22
	STS  __FF_FAT2_ADDR+3,R23
;    1714 	_FF_ROOT_ADDR = ((long) BPB_NumFATs * (long) BPB_FATSz16) + (long) BPB_RsvdSecCnt;
	LDS  R30,_BPB_NumFATs
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
	LDS  R30,_BPB_RsvdSecCnt
	LDS  R31,_BPB_RsvdSecCnt+1
	CLR  R22
	CLR  R23
	CALL __ADDD12
	STS  __FF_ROOT_ADDR,R30
	STS  __FF_ROOT_ADDR+1,R31
	STS  __FF_ROOT_ADDR+2,R22
	STS  __FF_ROOT_ADDR+3,R23
;    1715 	_FF_ROOT_ADDR *= BPB_BytsPerSec;
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
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
;    1716 	_FF_ROOT_ADDR += _FF_PART_ADDR;
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
;    1717 	
;    1718 	_FF_RootDirSectors = ((BPB_RootEntCnt * 32) + BPB_BytsPerSec - 1) / BPB_BytsPerSec;
	LDS  R30,_BPB_RootEntCnt
	LDS  R31,_BPB_RootEntCnt+1
	LSL  R30
	ROL  R31
	CALL __LSLW4
	LDS  R26,_BPB_BytsPerSec
	LDS  R27,_BPB_BytsPerSec+1
	ADD  R26,R30
	ADC  R27,R31
	SBIW R26,1
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	CALL __DIVW21U
	CLR  R22
	CLR  R23
	STS  __FF_RootDirSectors,R30
	STS  __FF_RootDirSectors+1,R31
	STS  __FF_RootDirSectors+2,R22
	STS  __FF_RootDirSectors+3,R23
;    1719 	FirstDataSector = (BPB_NumFATs * BPB_FATSz16) + BPB_RsvdSecCnt + _FF_RootDirSectors; 
	LDS  R30,_BPB_FATSz16
	LDS  R31,_BPB_FATSz16+1
	LDS  R26,_BPB_NumFATs
	LDI  R27,0
	CALL __MULW12U
	LDS  R26,_BPB_RsvdSecCnt
	LDS  R27,_BPB_RsvdSecCnt+1
	ADD  R26,R30
	ADC  R27,R31
	LDS  R30,__FF_RootDirSectors
	LDS  R31,__FF_RootDirSectors+1
	LDS  R22,__FF_RootDirSectors+2
	LDS  R23,__FF_RootDirSectors+3
	CLR  R24
	CLR  R25
	CALL __ADDD12
	STS  _FirstDataSector,R30
	STS  _FirstDataSector+1,R31
;    1720 	
;    1721 	DataClusTot = BPB_TotSec - FirstDataSector;
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
;    1722 	DataClusTot /= BPB_SecPerClus;
	LDS  R30,_BPB_SecPerClus
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
;    1723 	clus_0_addr = 0;		// Reset Empty Cluster table location
	LDI  R30,0
	STS  _clus_0_addr,R30
	STS  _clus_0_addr+1,R30
	STS  _clus_0_addr+2,R30
	STS  _clus_0_addr+3,R30
;    1724 	c_counter = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _c_counter,R30
	STS  _c_counter+1,R31
;    1725 	
;    1726 	if (DataClusTot < 4085)				// FAT12
	LDS  R26,_DataClusTot
	LDS  R27,_DataClusTot+1
	LDS  R24,_DataClusTot+2
	LDS  R25,_DataClusTot+3
	__CPD2N 0xFF5
	BRSH _0xF1
;    1727 		BPB_FATType = 0x32;
	LDI  R30,LOW(50)
	STS  _BPB_FATType,R30
;    1728 	else if (DataClusTot < 65525)		// FAT16
	RJMP _0xF2
_0xF1:
	LDS  R26,_DataClusTot
	LDS  R27,_DataClusTot+1
	LDS  R24,_DataClusTot+2
	LDS  R25,_DataClusTot+3
	__CPD2N 0xFFF5
	BRSH _0xF3
;    1729 		BPB_FATType = 0x36;
	LDI  R30,LOW(54)
	STS  _BPB_FATType,R30
;    1730 	else
	RJMP _0xF4
_0xF3:
;    1731 	{
;    1732 		BPB_FATType = 0;
	LDI  R30,LOW(0)
	STS  _BPB_FATType,R30
;    1733 		_FF_error = FAT_ERR;
	LDI  R30,LOW(12)
	STS  __FF_error,R30
;    1734 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x4DB
;    1735 	}
_0xF4:
_0xF2:
;    1736     
;    1737 	_FF_DIR_ADDR = _FF_ROOT_ADDR;		// Set current directory to root address
	LDS  R30,__FF_ROOT_ADDR
	LDS  R31,__FF_ROOT_ADDR+1
	LDS  R22,__FF_ROOT_ADDR+2
	LDS  R23,__FF_ROOT_ADDR+3
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    1738 
;    1739 	_FF_FULL_PATH[0] = 0x5C;	// a '\'
	LDI  R30,LOW(92)
	STS  __FF_FULL_PATH,R30
;    1740 	_FF_FULL_PATH[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN __FF_FULL_PATH,1
;    1741 	
;    1742 	#ifdef _DEBUG_ON_
;    1743 		printf("\n\rPart Address:  %lX", _FF_PART_ADDR);
;    1744 		printf("\n\rBS_jmpBoot:  %lX", BS_jmpBoot);
;    1745 		printf("\n\rBPB_BytsPerSec:  %X", BPB_BytsPerSec);
;    1746 		printf("\n\rBPB_SecPerClus:  %X", BPB_SecPerClus);
;    1747 		printf("\n\rBPB_RsvdSecCnt:  %X", BPB_RsvdSecCnt);
;    1748 		printf("\n\rBPB_NumFATs:  %X", BPB_NumFATs);
;    1749 		printf("\n\rBPB_RootEntCnt:  %X", BPB_RootEntCnt);
;    1750 		printf("\n\rBPB_FATSz16:  %X", BPB_FATSz16);
;    1751 		printf("\n\rBPB_TotSec16:  %lX", BPB_TotSec);
;    1752 		if (BPB_FATType == 0x32)
;    1753 			printf("\n\rBPB_FATType:  FAT12");
;    1754 		else if (BPB_FATType == 0x36)
;    1755 			printf("\n\rBPB_FATType:  FAT16");
;    1756 		else
;    1757 			printf("\n\rBPB_FATType:  FAT ERROR!!");
;    1758 		printf("\n\rClusterCnt:  %lX", DataClusTot);
;    1759 		printf("\n\rROOT_ADDR:  %lX", _FF_ROOT_ADDR);
;    1760 		printf("\n\rFAT2_ADDR:  %lX", _FF_FAT2_ADDR);
;    1761 		printf("\n\rRootDirSectors:  %X", _FF_RootDirSectors);
;    1762 		printf("\n\rFirstDataSector:  %X", FirstDataSector);
;    1763 	#endif
;    1764 	
;    1765 	return (1);	
	LDI  R30,LOW(1)
_0x4DB:
	LDD  R16,Y+0
	ADIW R28,5
	RET
;    1766 }
;    1767 
;    1768 unsigned char spi_speedset(void)
;    1769 {
_spi_speedset:
;    1770 	if (SPCR == 0x50)
	IN   R30,0xD
	CPI  R30,LOW(0x50)
	BRNE _0xF5
;    1771 		SPCR = 0x51;
	LDI  R30,LOW(81)
	OUT  0xD,R30
;    1772 	else if (SPCR == 0x51)
	RJMP _0xF6
_0xF5:
	IN   R30,0xD
	CPI  R30,LOW(0x51)
	BRNE _0xF7
;    1773 		SPCR = 0x52;
	LDI  R30,LOW(82)
	OUT  0xD,R30
;    1774 	else if (SPCR == 0x52)
	RJMP _0xF8
_0xF7:
	IN   R30,0xD
	CPI  R30,LOW(0x52)
	BRNE _0xF9
;    1775 		SPCR = 0x53;
	LDI  R30,LOW(83)
	OUT  0xD,R30
;    1776 	else
	RJMP _0xFA
_0xF9:
;    1777 	{
;    1778 		SPCR = 0x50;
	CALL SUBOPT_0x32
;    1779 		return (0);
	RET
;    1780 	}
_0xFA:
_0xF8:
_0xF6:
;    1781 	return (1);
	LDI  R30,LOW(1)
	RET
;    1782 }
;    1783 
;    1784 unsigned char reset_sd(void)
;    1785 {
_reset_sd:
;    1786 	unsigned char resp, n, c;
;    1787 
;    1788 	#ifdef _DEBUG_ON_
;    1789 		printf("\n\rReset CMD:  ");	
;    1790 	#endif
;    1791 
;    1792 	for (c=0; c<4; c++)		// try reset command 3 times if needed
	CALL __SAVELOCR3
;	resp -> R16
;	n -> R17
;	c -> R18
	LDI  R18,LOW(0)
_0xFC:
	CPI  R18,4
	BRSH _0xFD
;    1793 	{
;    1794 		SD_CS_OFF();
	SBI  0x18,4
;    1795 		for (n=0; n<10; n++)	// initialize clk signal to sync card
	LDI  R17,LOW(0)
_0xFF:
	CPI  R17,10
	BRSH _0x100
;    1796 			_FF_spi(0xFF);
	CALL SUBOPT_0x2D
;    1797 		resp = send_cmd(CMD0,0);
	SUBI R17,-1
	RJMP _0xFF
_0x100:
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3B
;    1798 		for (n=0; n<200; n++)
	LDI  R17,LOW(0)
_0x102:
	CPI  R17,200
	BRSH _0x103
;    1799 		{
;    1800 			if (resp == 0x1)
	CPI  R16,1
	BRNE _0x104
;    1801 			{
;    1802 				SD_CS_OFF();
	SBI  0x18,4
;    1803     			#ifdef _DEBUG_ON_
;    1804 					printf("OK!!!");
;    1805 				#endif
;    1806 				SPCR = 0x50;
	CALL SUBOPT_0x3C
;    1807 				return(1);
	RJMP _0x4DA
;    1808 			}
;    1809 	      	resp = _FF_spi(0xFF);
_0x104:
	CALL SUBOPT_0x2D
	MOV  R16,R30
;    1810 		}
	SUBI R17,-1
	RJMP _0x102
_0x103:
;    1811 		#ifdef _DEBUG_ON_
;    1812 			printf("ERROR!!!");
;    1813 		#endif
;    1814  		if (spi_speedset()==0)
	CALL _spi_speedset
	CPI  R30,0
	BRNE _0x105
;    1815  		{
;    1816 		    SD_CS_OFF();
	SBI  0x18,4
;    1817  			return (0);
	LDI  R30,LOW(0)
	RJMP _0x4DA
;    1818  		}
;    1819 	}
_0x105:
	SUBI R18,-1
	RJMP _0xFC
_0xFD:
;    1820 	return (0);
	LDI  R30,LOW(0)
	RJMP _0x4DA
;    1821 }
;    1822 
;    1823 unsigned char init_sd(void)
;    1824 {
_init_sd:
;    1825 	unsigned char resp;
;    1826 	unsigned int c;
;    1827 	
;    1828 	clear_sd_buff();
	CALL __SAVELOCR3
;	resp -> R16
;	c -> R17,R18
	CALL _clear_sd_buff
;    1829 
;    1830     #ifdef _DEBUG_ON_
;    1831 		printf("\r\nInitialization:  ");
;    1832 	#endif
;    1833     for (c=0; c<1000; c++)
	__GETWRN 17,18,0
_0x107:
	__CPWRN 17,18,1000
	BRSH _0x108
;    1834     {
;    1835     	resp = send_cmd(CMD1, 0);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x3B
;    1836     	if (resp == 0)
	CPI  R16,0
	BREQ _0x108
;    1837     		break;
;    1838    		resp = _FF_spi(0xFF);
	CALL SUBOPT_0x2D
	MOV  R16,R30
;    1839    		if (resp == 0)
	CPI  R16,0
	BREQ _0x108
;    1840    			break;
;    1841    		resp = _FF_spi(0xFF);
	CALL SUBOPT_0x2D
	MOV  R16,R30
;    1842    		if (resp == 0)
	CPI  R16,0
	BREQ _0x108
;    1843    			break;
;    1844 	}
	__ADDWRN 17,18,1
	RJMP _0x107
_0x108:
;    1845    	if (resp == 0)
	CPI  R16,0
	BRNE _0x10C
;    1846 	{
;    1847 		#ifdef _DEBUG_ON_
;    1848    			printf("OK!");
;    1849 	   	#endif
;    1850 		return (1);
	LDI  R30,LOW(1)
	RJMP _0x4DA
;    1851 	}
;    1852 	else
_0x10C:
;    1853 	{
;    1854 		#ifdef _DEBUG_ON_
;    1855    			printf("ERROR-%x  ", resp);
;    1856 	   	#endif
;    1857 		return (0);
	LDI  R30,LOW(0)
;    1858  	}        		
;    1859 }
_0x4DA:
	CALL __LOADLOCR3
	ADIW R28,3
	RET
;    1860 
;    1861 unsigned char _FF_read_disp(unsigned long sd_addr)
;    1862 {
;    1863 	unsigned char resp;
;    1864 	unsigned long n, remainder;
;    1865 	
;    1866 	if (sd_addr % 0x200)
;	sd_addr -> Y+9
;	resp -> R16
;	n -> Y+5
;	remainder -> Y+1
;    1867 	{	// Not a valid read address, return 0
;    1868 		_FF_error = READ_ERR;
;    1869 		return (0);
;    1870 	}
;    1871 
;    1872 	clear_sd_buff();
;    1873 	resp = send_cmd(CMD17, sd_addr);		// Send read request
;    1874 	
;    1875 	while(resp!=0xFE)
;    1876 		resp = _FF_spi(0xFF);
;    1877 	for (n=0; n<512; n++)
;    1878 	{
;    1879 		remainder = n % 0x10;
;    1880 		if (remainder == 0)
;    1881 			printf("\n\r");
;    1882 		_FF_buff[n] = _FF_spi(0xFF);
;    1883 		if (_FF_buff[n]<0x10)
;    1884 			putchar(0x30);
;    1885 		printf("%X ", _FF_buff[n]);
;    1886 	}
;    1887 	_FF_spi(0xFF);
;    1888 	_FF_spi(0xFF);
;    1889 	_FF_spi(0xFF);
;    1890 	SD_CS_OFF();
;    1891 	return (1);
;    1892 }
;    1893 
;    1894 // Read data from a SD card @ address
;    1895 unsigned char _FF_read(unsigned long sd_addr)
;    1896 {
__FF_read:
;    1897 	unsigned char resp;
;    1898 	unsigned long n;
;    1899 //printf("\r\nReadin ADDR [0x%lX]", sd_addr);
;    1900 	
;    1901 	if (sd_addr % BPB_BytsPerSec)
	SBIW R28,4
	ST   -Y,R16
;	sd_addr -> Y+5
;	resp -> R16
;	n -> Y+1
	CALL SUBOPT_0x3D
	BREQ _0x117
;    1902 	{	// Not a valid read address, return 0
;    1903 		_FF_error = READ_ERR;
	CALL SUBOPT_0x3E
;    1904 		return (0);
	RJMP _0x4D9
;    1905 	}
;    1906 		
;    1907 	for (;;)
_0x117:
_0x119:
;    1908 	{
;    1909 		clear_sd_buff();
	CALL _clear_sd_buff
;    1910 		resp = send_cmd(CMD17, sd_addr);	// read block command
	LDI  R30,LOW(7)
	CALL SUBOPT_0x3F
;    1911 		for (n=0; n<1000; n++)
	__CLRD1S 1
_0x11C:
	__GETD2S 1
	__CPD2N 0x3E8
	BRSH _0x11D
;    1912 		{
;    1913 			if (resp==0xFE)
	CPI  R16,254
	BREQ _0x11D
;    1914 			{	// waiting for start byte
;    1915 				break;
;    1916 			}
;    1917 			resp = _FF_spi(0xFF);
	CALL SUBOPT_0x2D
	MOV  R16,R30
;    1918 		}
	CALL SUBOPT_0x33
	RJMP _0x11C
_0x11D:
;    1919 		if (resp==0xFE)
	CPI  R16,254
	BRNE _0x11F
;    1920 		{	// if it is a valid start byte => start reading SD Card
;    1921 			for (n=0; n<BPB_BytsPerSec; n++)
	__CLRD1S 1
_0x121:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	__GETD2S 1
	CLR  R22
	CLR  R23
	CALL __CPD21
	BRSH _0x122
;    1922 				_FF_buff[n] = _FF_spi(0xFF);
	__GETD1S 1
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x2D
	POP  R26
	POP  R27
	ST   X,R30
;    1923 			_FF_spi(0xFF);
	CALL SUBOPT_0x33
	RJMP _0x121
_0x122:
	CALL SUBOPT_0x31
;    1924 			_FF_spi(0xFF);
	CALL SUBOPT_0x2C
;    1925 			_FF_spi(0xFF);
	CALL __FF_spi
;    1926 			SD_CS_OFF();
	SBI  0x18,4
;    1927 			_FF_error = NO_ERR;
	LDI  R30,LOW(0)
	STS  __FF_error,R30
;    1928 			_FF_buff_addr = sd_addr;
	__GETD1S 5
	STS  __FF_buff_addr,R30
	STS  __FF_buff_addr+1,R31
	STS  __FF_buff_addr+2,R22
	STS  __FF_buff_addr+3,R23
;    1929 			SPCR = 0x50;
	CALL SUBOPT_0x3C
;    1930 			return (1);
	RJMP _0x4D9
;    1931 		}
;    1932 
;    1933 		SD_CS_OFF();
_0x11F:
	SBI  0x18,4
;    1934 
;    1935 		if (spi_speedset()==0)
	CALL _spi_speedset
	CPI  R30,0
	BREQ _0x11A
;    1936 			break;
;    1937 	}	
	RJMP _0x119
_0x11A:
;    1938 	_FF_error = READ_ERR;    
	CALL SUBOPT_0x3E
;    1939 	return(0);
_0x4D9:
	LDD  R16,Y+0
	ADIW R28,9
	RET
;    1940 }
;    1941 
;    1942 
;    1943 #ifndef _READ_ONLY_
;    1944 unsigned char _FF_write(unsigned long sd_addr)
;    1945 {
__FF_write:
;    1946 	unsigned char resp, calc, valid_flag;
;    1947 	unsigned int n;
;    1948 	
;    1949 	if ((sd_addr%BPB_BytsPerSec) || (sd_addr <= _FF_PART_ADDR))
	CALL __SAVELOCR5
;	sd_addr -> Y+5
;	resp -> R16
;	calc -> R17
;	valid_flag -> R18
;	n -> R19,R20
	CALL SUBOPT_0x3D
	BRNE _0x125
	LDS  R30,__FF_PART_ADDR
	LDS  R31,__FF_PART_ADDR+1
	LDS  R22,__FF_PART_ADDR+2
	LDS  R23,__FF_PART_ADDR+3
	__GETD2S 5
	CALL __CPD12
	BRLO _0x124
_0x125:
;    1950 	{	// Not a valid write address, return 0
;    1951 		_FF_error = WRITE_ERR;
	CALL SUBOPT_0x40
;    1952 		return (0);
	RJMP _0x4D8
;    1953 	}
;    1954 
;    1955 //printf("\r\nWriting to address:  %lX", sd_addr);
;    1956 	for (;;)
_0x124:
_0x128:
;    1957 	{
;    1958 		clear_sd_buff();
	CALL _clear_sd_buff
;    1959 		resp = send_cmd(CMD24, sd_addr);
	LDI  R30,LOW(9)
	CALL SUBOPT_0x3F
;    1960 		valid_flag = 0;
	LDI  R18,LOW(0)
;    1961 		for (n=0; n<1000; n++)
	__GETWRN 19,20,0
_0x12B:
	__CPWRN 19,20,1000
	BRSH _0x12C
;    1962 		{
;    1963 			if (resp == 0x00)
	CPI  R16,0
	BRNE _0x12D
;    1964 			{
;    1965 				valid_flag = 1;
	LDI  R18,LOW(1)
;    1966 				break;
	RJMP _0x12C
;    1967 			}
;    1968 			resp = _FF_spi(0xFF);
_0x12D:
	CALL SUBOPT_0x2D
	MOV  R16,R30
;    1969 		}
	__ADDWRN 19,20,1
	RJMP _0x12B
_0x12C:
;    1970 	
;    1971 		if (valid_flag)
	CPI  R18,0
	BREQ _0x12E
;    1972 		{
;    1973 			_FF_spi(0xFF);
	CALL SUBOPT_0x2D
;    1974 			_FF_spi(0xFE);					// Start Block Token
	LDI  R30,LOW(254)
	ST   -Y,R30
	CALL __FF_spi
;    1975 			for (n=0; n<BPB_BytsPerSec; n++)		// Write Data in buffer to card
	__GETWRN 19,20,0
_0x130:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	CP   R19,R30
	CPC  R20,R31
	BRSH _0x131
;    1976 				_FF_spi(_FF_buff[n]);
	LDI  R26,LOW(__FF_buff)
	LDI  R27,HIGH(__FF_buff)
	ADD  R26,R19
	ADC  R27,R20
	LD   R30,X
	ST   -Y,R30
	CALL __FF_spi
;    1977 			_FF_spi(0xFF);					// Send 2 blank CRC bytes
	__ADDWRN 19,20,1
	RJMP _0x130
_0x131:
	CALL SUBOPT_0x31
;    1978 			_FF_spi(0xFF);
	CALL SUBOPT_0x2C
;    1979 			resp = _FF_spi(0xFF);			// Response should be 0bXXX00101
	CALL __FF_spi
	MOV  R16,R30
;    1980 			calc = resp | 0xE0;
	MOV  R30,R16
	ORI  R30,LOW(0xE0)
	MOV  R17,R30
;    1981 			if (calc==0xE5)
	CPI  R17,229
	BRNE _0x132
;    1982 			{
;    1983 				while(_FF_spi(0xFF)==0)
_0x133:
	CALL SUBOPT_0x2D
	CPI  R30,0
	BREQ _0x133
;    1984 					;	// Clear Buffer before returning 'OK'
;    1985 				SD_CS_OFF();
	SBI  0x18,4
;    1986 //				SPCR = 0x50;			// Reset SPI bus Speed
;    1987 				_FF_error = NO_ERR;
	LDI  R30,LOW(0)
	STS  __FF_error,R30
;    1988 				return(1);
	LDI  R30,LOW(1)
	RJMP _0x4D8
;    1989 			}
;    1990 		}
_0x132:
;    1991 		SD_CS_OFF(); 
_0x12E:
	SBI  0x18,4
;    1992 
;    1993 		if (spi_speedset()==0)
	CALL _spi_speedset
	CPI  R30,0
	BREQ _0x129
;    1994 			break;
;    1995 		// delay_ms(100);		
;    1996 	}
	RJMP _0x128
_0x129:
;    1997 	_FF_error = WRITE_ERR;
	CALL SUBOPT_0x40
;    1998 	return(0x0);
_0x4D8:
	CALL __LOADLOCR5
	ADIW R28,9
	RET
;    1999 }
;    2000 #endif
;    2001 /*
;    2002 	Progressive Resources LLC
;    2003                                     
;    2004 			FlashFile
;    2005 	
;    2006 	Version : 	1.32
;    2007 	Date: 		12/31/2003
;    2008 	Author: 	Erick M. Higa
;    2009 	
;    2010 	Revision History:
;    2011 	12/31/2003 - EMH - v1.00 
;    2012 			   	 	 - Initial Release
;    2013 	01/19/2004 - EMH - v1.10
;    2014 			   	 	 - fixed FAT access errors by allowing both FAT tables to be updated
;    2015 					 - fixed erase_cluster chain to stop if chain goes to '0'
;    2016 					 - fixed #include's so other non m128 processors could be used
;    2017 					 - fixed fcreate to match 'C' standard for function "creat"
;    2018 					 - fixed fseek so it would not error when in "READ" mode
;    2019 					 - modified SPI interface to use _FF_spi() so it is more universal
;    2020 					   (see the "sd_cmd.c" file for the function used)
;    2021 					 - redifined global variables and #defines for more unique names
;    2022 					 - added string functions fputs, fputsc, & fgets
;    2023 					 - added functions fquickformat, fgetfileinfo, & GetVolID()
;    2024 					 - added directory support
;    2025 					 - modified delays in "sd_cmd.c" to increase transfer speed to max
;    2026 					 - updated "options.h" to include additions, and to make #defines 
;    2027 					   more universal to multiple platforms
;    2028 	01/21/2004 - EMH - v1.20
;    2029 			   	 	 - Added ICC Support to the FlashFileSD
;    2030 					 - fixed card initialization error for MMC/SD's that have only a boot 
;    2031 			   	 	   sector and no partition table
;    2032 					 - Fixed intermittant error on fcreate when creating existing file
;    2033 					 - changed "options.h" to #include all required files
;    2034 	02/19/2004 - EMH - v1.21
;    2035 					 - Replaced all "const" refrances to "flash" to support CodeVision 1.24.1b
;    2036 	03/02/2004 - EMH - v1.22 (unofficial release)
;    2037 					 - Changed Directory Functions to allow for multi-cluster directory entries
;    2038 					 - Added function addr_to_clust() to support long directories
;    2039 					 - Fixed FAT table address calculation to support multiple reserved sectors
;    2040 					   (previously) assumed one reserved sector, if XP formats card sometimes 
;    2041 					   multiple reserved sectors - thanks YW
;    2042 	03/10/2004 - EMH - v1.30
;    2043 					 - Added support for a Compact Flash package
;    2044 					 - Renamed read and write to flash function names for multiple media support	
;    2045 	03/26/2004 - EMH - v1.31
;    2046 					 - Added define for easy MEGA128Dev board setup
;    2047 					 - Changed demo projects so "option.h" is in the project directory	
;    2048 	04/01/2004 - EMH - v1.32
;    2049 					 - Fixed bug in "prev_cluster()" that didn't use updated FAT table address
;    2050 					   calculations.  (effects XP formatted cards see v1.22 notes)
;    2051                                            
;    2052 	Software License
;    2053 	The use of Progressive Resources LLC FlashFile Source Package indicates 
;    2054 	your understanding and acceptance of the following terms and conditions. 
;    2055 	This license shall supersede any verbal or prior verbal or written, statement 
;    2056 	or agreement to the contrary. If you do not understand or accept these terms, 
;    2057 	or your local regulations prohibit "after sale" license agreements or limited 
;    2058 	disclaimers, you must cease and desist using this product immediately.
;    2059 	This product is © Copyright 2003 by Progressive Resources LLC, all rights 
;    2060 	reserved. International copyright laws, international treaties and all other 
;    2061 	applicable national or international laws protect this product. This software 
;    2062 	product and documentation may not, in whole or in part, be copied, photocopied, 
;    2063 	translated, or reduced to any electronic medium or machine readable form, without 
;    2064 	prior consent in writing, from Progressive Resources LLC and according to all 
;    2065 	applicable laws. The sole owner of this product is Progressive Resources LLC.
;    2066 
;    2067 	Operating License
;    2068 	You have the non-exclusive right to use any enclosed product but have no right 
;    2069 	to distribute it as a source code product without the express written permission 
;    2070 	of Progressive Resources LLC. Use over a "local area network" (within the same 
;    2071 	locale) is permitted provided that only a single person, on a single computer 
;    2072 	uses the product at a time. Use over a "wide area network" (outside the same 
;    2073 	locale) is strictly prohibited under any and all circumstances.
;    2074                                            
;    2075 	Liability Disclaimer
;    2076 	This product and/or license is provided as is, without any representation or 
;    2077 	warranty of any kind, either express or implied, including without limitation 
;    2078 	any representations or endorsements regarding the use of, the results of, or 
;    2079 	performance of the product, Its appropriateness, accuracy, reliability, or 
;    2080 	correctness. The user and/or licensee assume the entire risk as to the use of 
;    2081 	this product. Progressive Resources LLC does not assume liability for the use 
;    2082 	of this product beyond the original purchase price of the software. In no event 
;    2083 	will Progressive Resources LLC be liable for additional direct or indirect 
;    2084 	damages including any lost profits, lost savings, or other incidental or 
;    2085 	consequential damages arising from any defects, or the use or inability to 
;    2086 	use these products, even if Progressive Resources LLC have been advised of 
;    2087 	the possibility of such damages.
;    2088 */                                 
;    2089 
;    2090 	#include <coding.h>
;    2091 
;    2092 extern unsigned long OCR_REG;
;    2093 extern unsigned char _FF_buff[512];
;    2094 extern unsigned int PT_SecStart;
;    2095 extern unsigned long BS_jmpBoot;
;    2096 extern unsigned int BPB_BytsPerSec;
;    2097 extern unsigned char BPB_SecPerClus;
;    2098 extern unsigned int BPB_RsvdSecCnt;
;    2099 extern unsigned char BPB_NumFATs;
;    2100 extern unsigned int BPB_RootEntCnt;
;    2101 extern unsigned int BPB_FATSz16;
;    2102 extern unsigned char BPB_FATType;
;    2103 extern unsigned long BPB_TotSec;
;    2104 extern unsigned long BS_VolSerial;
;    2105 extern unsigned char BS_VolLab[12];
;    2106 extern unsigned long _FF_PART_ADDR, _FF_ROOT_ADDR, _FF_DIR_ADDR;
;    2107 extern unsigned long _FF_FAT1_ADDR, _FF_FAT2_ADDR;
;    2108 extern unsigned int FirstDataSector;
;    2109 extern unsigned long FirstSectorofCluster;
;    2110 extern unsigned char _FF_error;
;    2111 extern unsigned long _FF_buff_addr;
;    2112 extern unsigned long DataClusTot;
;    2113 unsigned char rtc_hour, rtc_min, rtc_sec;

	.DSEG
_rtc_hour:
	.BYTE 0x1
_rtc_min:
	.BYTE 0x1
_rtc_sec:
	.BYTE 0x1
;    2114 unsigned char rtc_date, rtc_month;
_rtc_date:
	.BYTE 0x1
_rtc_month:
	.BYTE 0x1
;    2115 unsigned int rtc_year;
_rtc_year:
	.BYTE 0x2
;    2116 unsigned long clus_0_addr, _FF_n_temp;
_clus_0_addr:
	.BYTE 0x4
__FF_n_temp:
	.BYTE 0x4
;    2117 unsigned int c_counter;
_c_counter:
	.BYTE 0x2
;    2118 unsigned char _FF_FULL_PATH[_FF_PATH_LENGTH];
__FF_FULL_PATH:
	.BYTE 0x64
;    2119 unsigned char FILENAME[12];
_FILENAME:
	.BYTE 0xC
;    2120 
;    2121 // Conversion file to change an ASCII valued character into the calculated value
;    2122 unsigned char ascii_to_char(unsigned char ascii_char)
;    2123 {

	.CSEG
;    2124 	unsigned char temp_char;
;    2125 	
;    2126 	if (ascii_char < 0x30)		// invalid, return error
;	ascii_char -> Y+1
;	temp_char -> R16
;    2127 		return (0xFF);
;    2128 	else if (ascii_char < 0x3A)
;    2129 	{	//number, subtract 0x30, retrun value
;    2130 		temp_char = ascii_char - 0x30;
;    2131 		return (temp_char);
;    2132 	}
;    2133 	else if (ascii_char < 0x41)	// invalid, return error
;    2134 		return (0xFF);
;    2135 	else if (ascii_char < 0x47)
;    2136 	{	// lower case a-f, subtract 0x37, return value
;    2137 		temp_char = ascii_char - 0x37;
;    2138 		return (temp_char);
;    2139 	}
;    2140 	else if (ascii_char < 0x61)	// invalid, return error
;    2141 		return (0xFF);
;    2142 	else if (ascii_char < 0x67)
;    2143 	{	// upper case A-F, subtract 0x57, return value
;    2144 		temp_char = ascii_char - 0x57;
;    2145 		return (temp_char);
;    2146 	}
;    2147 	else	// invalid, return error
;    2148 		return (0xFF);
;    2149 }
;    2150 
;    2151 // Function to see if the character is a valid FILENAME character
;    2152 int valid_file_char(unsigned char file_char)
;    2153 {
_valid_file_char:
;    2154 	if (file_char < 0x20)
	LD   R26,Y
	CPI  R26,LOW(0x20)
	BRSH _0x143
;    2155 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4D7
;    2156 	else if ((file_char==0x22) || (file_char==0x2A) || (file_char==0x2B) || (file_char==0x2C) ||
_0x143:
;    2157 			(file_char==0x2E) || (file_char==0x2F) || ((file_char>=0x3A)&&(file_char<=0x3F)) ||
;    2158 			((file_char>=0x5B)&&(file_char<=0x5D)) || (file_char==0x7C) || (file_char==0xE5))
	LD   R26,Y
	CPI  R26,LOW(0x22)
	BREQ _0x146
	CPI  R26,LOW(0x2A)
	BREQ _0x146
	CPI  R26,LOW(0x2B)
	BREQ _0x146
	CPI  R26,LOW(0x2C)
	BREQ _0x146
	CPI  R26,LOW(0x2E)
	BREQ _0x146
	CPI  R26,LOW(0x2F)
	BREQ _0x146
	CPI  R26,LOW(0x3A)
	BRLO _0x147
	CPI  R26,LOW(0x40)
	BRLO _0x146
_0x147:
	LD   R26,Y
	CPI  R26,LOW(0x5B)
	BRLO _0x149
	CPI  R26,LOW(0x5E)
	BRLO _0x146
_0x149:
	LD   R26,Y
	CPI  R26,LOW(0x7C)
	BREQ _0x146
	CPI  R26,LOW(0xE5)
	BRNE _0x145
_0x146:
;    2159 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4D7
;    2160 	else
_0x145:
;    2161 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
;    2162 }
_0x4D7:
	ADIW R28,1
	RET
;    2163 
;    2164 // Function will scan the directory @VALID_ADDR and return a
;    2165 // '0' if successful (w/ VALID_ADDR changing to location of entry avaliable),
;    2166 // and a '-1' if file or folder exists (w/ VALID_ADDR changing to location of
;    2167 // entry of exisiting file/folder) or if no more entry space (VALID_ADDR would
;    2168 // change to 0).
;    2169 int scan_directory(unsigned long *VALID_ADDR, unsigned char *NAME)
;    2170 {
_scan_directory:
;    2171 	unsigned int ent_cntr, ent_max, n, c, dir_clus;
;    2172 	unsigned long temp_addr;
;    2173 	unsigned char *sp, *qp, aval_flag, name_store[14];
;    2174 	
;    2175 	aval_flag = 0;
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
;    2176 	ent_cntr = 0;	// set to 0
	__GETWRN 16,17,0
;    2177 	
;    2178 	qp = NAME;
	LDD  R30,Y+33
	LDD  R31,Y+33+1
	STD  Y+21,R30
	STD  Y+21+1,R31
;    2179 	for (c=0; c<11; c++)
	LDI  R30,0
	STD  Y+31,R30
	STD  Y+31+1,R30
_0x14E:
	LDD  R26,Y+31
	LDD  R27,Y+31+1
	SBIW R26,11
	BRLO PC+3
	JMP _0x14F
;    2180 	{
;    2181 		if (valid_file_char(*qp)==0)
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	CALL SUBOPT_0x41
	BRNE _0x150
;    2182 			name_store[c] = toupper(*qp++);
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
;    2183 		else if (*qp == '.')
	RJMP _0x151
_0x150:
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BRNE _0x152
;    2184 		{
;    2185 			while (c<8)
_0x153:
	LDD  R26,Y+31
	LDD  R27,Y+31+1
	SBIW R26,8
	BRSH _0x155
;    2186 				name_store[c++] = 0x20;
	CALL SUBOPT_0x42
;    2187 			c--;
	RJMP _0x153
_0x155:
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	SBIW R30,1
	STD  Y+31,R30
	STD  Y+31+1,R31
;    2188 			
;    2189 			qp++;
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	ADIW R30,1
	STD  Y+21,R30
	STD  Y+21+1,R31
;    2190 			aval_flag |= 1;
	LDD  R30,Y+20
	ORI  R30,1
	STD  Y+20,R30
;    2191 		}
;    2192 		else if (*qp == 0)
	RJMP _0x156
_0x152:
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	LD   R30,X
	CPI  R30,0
	BRNE _0x157
;    2193 		{
;    2194 			while (c<11)
_0x158:
	LDD  R26,Y+31
	LDD  R27,Y+31+1
	SBIW R26,11
	BRSH _0x15A
;    2195 				name_store[c++] = 0x20;
	CALL SUBOPT_0x42
;    2196 		}
	RJMP _0x158
_0x15A:
;    2197 		else
	RJMP _0x15B
_0x157:
;    2198 		{
;    2199 			*VALID_ADDR = 0;
	CALL SUBOPT_0x43
;    2200 			return (EOF);
	RJMP _0x4D6
;    2201 		}
_0x15B:
_0x156:
_0x151:
;    2202 	}
	CALL SUBOPT_0x44
	RJMP _0x14E
_0x14F:
;    2203 	name_store[11] = 0;
	LDI  R30,LOW(0)
	STD  Y+17,R30
;    2204 	
;    2205 	if (*VALID_ADDR == _FF_ROOT_ADDR)
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __GETD1P
	LDS  R26,__FF_ROOT_ADDR
	LDS  R27,__FF_ROOT_ADDR+1
	LDS  R24,__FF_ROOT_ADDR+2
	LDS  R25,__FF_ROOT_ADDR+3
	CALL __CPD12
	BRNE _0x15C
;    2206 		ent_max = BPB_RootEntCnt;
	__GETWRMN 18,19,0,_BPB_RootEntCnt
;    2207 	else
	RJMP _0x15D
_0x15C:
;    2208 	{
;    2209 		dir_clus = addr_to_clust(*VALID_ADDR);
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __GETD1P
	CALL __PUTPARD1
	RCALL _addr_to_clust
	STD  Y+29,R30
	STD  Y+29+1,R31
;    2210 		if (dir_clus != 0)
	SBIW R30,0
	BREQ _0x15E
;    2211 			aval_flag |= 0x80;
	LDD  R30,Y+20
	ORI  R30,0x80
	STD  Y+20,R30
;    2212 		ent_max = ((long) BPB_BytsPerSec * (long) BPB_SecPerClus) / 0x20;
_0x15E:
	CALL SUBOPT_0x45
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x20
	CALL __DIVD21
	MOVW R18,R30
;    2213     }
_0x15D:
;    2214 	c = 0;
	LDI  R30,0
	STD  Y+31,R30
	STD  Y+31+1,R30
;    2215 	while (ent_cntr < ent_max)	
_0x15F:
	__CPWRR 16,17,18,19
	BRLO PC+3
	JMP _0x161
;    2216 	{
;    2217 		if (_FF_read(*VALID_ADDR+((long)c*BPB_BytsPerSec))==0)
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x46
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	CALL SUBOPT_0x34
	BRNE _0x162
;    2218 			break;
	RJMP _0x161
;    2219 		for (n=0; n<16; n++)
_0x162:
	__GETWRN 20,21,0
_0x164:
	__CPWRN 20,21,16
	BRLO PC+3
	JMP _0x165
;    2220 		{
;    2221 			sp = &_FF_buff[n*0x20];
	CALL SUBOPT_0x47
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	STD  Y+23,R30
	STD  Y+23+1,R31
;    2222 			qp = name_store;
	MOVW R30,R28
	ADIW R30,6
	STD  Y+21,R30
	STD  Y+21+1,R31
;    2223 			if (*sp==0)
	LDD  R26,Y+23
	LDD  R27,Y+23+1
	LD   R30,X
	CPI  R30,0
	BRNE _0x166
;    2224 			{
;    2225 				if ((aval_flag&0x10)==0)
	LDD  R30,Y+20
	ANDI R30,LOW(0x10)
	BRNE _0x167
;    2226 					temp_addr = *VALID_ADDR + ((long) c * BPB_BytsPerSec) + (n * 0x20);
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x46
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD21
	CALL SUBOPT_0x47
	CALL SUBOPT_0x48
;    2227 				*VALID_ADDR = temp_addr;
_0x167:
	CALL SUBOPT_0x49
;    2228 				return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x4D6
;    2229 			}
;    2230 			else if (*sp==0xE5)
_0x166:
	LDD  R26,Y+23
	LDD  R27,Y+23+1
	LD   R26,X
	CPI  R26,LOW(0xE5)
	BRNE _0x169
;    2231 			{
;    2232 				temp_addr = *VALID_ADDR + ((long) c * BPB_BytsPerSec) + (n * 0x20);
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x46
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD21
	CALL SUBOPT_0x47
	CALL SUBOPT_0x48
;    2233 				aval_flag |= 0x10;
	LDD  R30,Y+20
	ORI  R30,0x10
	STD  Y+20,R30
;    2234 			}
;    2235 			else
	RJMP _0x16A
_0x169:
;    2236 			{
;    2237 				if (aval_flag & 0x01)	// file
	LDD  R30,Y+20
	ANDI R30,LOW(0x1)
	BREQ _0x16B
;    2238 				{
;    2239 					if (strncmp(qp, sp, 11)==0)
	CALL SUBOPT_0x4A
	BRNE _0x16C
;    2240 					{
;    2241 						temp_addr = *VALID_ADDR + ((long) c * BPB_BytsPerSec) + (n * 0x20);
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x46
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD21
	CALL SUBOPT_0x47
	CALL SUBOPT_0x48
;    2242 						*VALID_ADDR = temp_addr;
	CALL SUBOPT_0x49
;    2243 						return (EOF);	// file exists @ temp_addr
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4D6
;    2244 					}
;    2245 				}
_0x16C:
;    2246 				else					// folder
	RJMP _0x16D
_0x16B:
;    2247 				{
;    2248 					if ((strncmp(qp, sp, 11)==0)&&(*(sp+11)&0x10))
	CALL SUBOPT_0x4A
	BRNE _0x16F
	LDD  R26,Y+23
	LDD  R27,Y+23+1
	ADIW R26,11
	LD   R30,X
	ANDI R30,LOW(0x10)
	BRNE _0x170
_0x16F:
	RJMP _0x16E
_0x170:
;    2249 					{
;    2250 						temp_addr = *VALID_ADDR + ((long) c * BPB_BytsPerSec) + (n * 0x20);
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x46
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD21
	CALL SUBOPT_0x47
	CALL SUBOPT_0x48
;    2251 						*VALID_ADDR = temp_addr;
	CALL SUBOPT_0x49
;    2252 						return (EOF);	// file exists @ temp_addr
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4D6
;    2253 					}
;    2254 				}
_0x16E:
_0x16D:
;    2255 			}
_0x16A:
;    2256 			ent_cntr++;
	__ADDWRN 16,17,1
;    2257 		}
	__ADDWRN 20,21,1
	RJMP _0x164
_0x165:
;    2258 		c++;
	CALL SUBOPT_0x44
;    2259 		if (ent_cntr == ent_max)
	__CPWRR 18,19,16,17
	BRNE _0x171
;    2260 		{
;    2261 			if (aval_flag & 0x80)		// a folder @ a valid cluster
	LDD  R30,Y+20
	ANDI R30,LOW(0x80)
	BREQ _0x172
;    2262 			{
;    2263 				c = next_cluster(dir_clus, SINGLE);
	LDD  R30,Y+29
	LDD  R31,Y+29+1
	CALL SUBOPT_0x20
	RCALL _next_cluster
	STD  Y+31,R30
	STD  Y+31+1,R31
;    2264 				if (c != EOF)
	LDD  R26,Y+31
	LDD  R27,Y+31+1
	CPI  R26,LOW(0xFFFF)
	LDI  R30,HIGH(0xFFFF)
	CPC  R27,R30
	BREQ _0x173
;    2265 				{	// another dir cluster exists
;    2266 					*VALID_ADDR = clust_to_addr(c);
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _clust_to_addr
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __PUTDP1
;    2267 					dir_clus = c;
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	STD  Y+29,R30
	STD  Y+29+1,R31
;    2268 					ent_cntr = 0;
	__GETWRN 16,17,0
;    2269 					c = 0;
	LDI  R30,0
	STD  Y+31,R30
	STD  Y+31+1,R30
;    2270 				}
;    2271 			}
_0x173:
;    2272 		}
_0x172:
;    2273 	}
_0x171:
	RJMP _0x15F
_0x161:
;    2274 	*VALID_ADDR = 0;
	CALL SUBOPT_0x43
;    2275 	return (EOF);	
_0x4D6:
	CALL __LOADLOCR6
	ADIW R28,37
	RET
;    2276 }
;    2277 
;    2278 #ifdef _DEBUG_ON_
;    2279 // Function to display all files and folders in the root directory, 
;    2280 // with the size of the file in bytes within the [brakets]
;    2281 void read_directory(void)
;    2282 {
;    2283 	unsigned char valid_flag, attribute_temp;
;    2284 	unsigned int c, n, d, m, dir_clus;
;    2285 	unsigned long calc, calc_clus, dir_addr;
;    2286 	
;    2287 	if (_FF_DIR_ADDR != _FF_ROOT_ADDR)
;    2288 	{
;    2289 		dir_clus = addr_to_clust(_FF_DIR_ADDR);
;    2290 		if (dir_clus == 0)
;    2291 			return;
;    2292 	}
;    2293 
;    2294 	printf("\r\nFile Listing for:  ROOT\\");
;    2295 	for (d=0; d<_FF_PATH_LENGTH; d++)
;    2296 	{
;    2297 		if (_FF_FULL_PATH[d])
;    2298 			putchar(_FF_FULL_PATH[d]);
;    2299 		else
;    2300 			break;
;    2301 	}
;    2302 	
;    2303     
;    2304     dir_addr = _FF_DIR_ADDR;
;    2305 	d = 0;
;    2306 	m = 0;
;    2307 	while (d<BPB_RootEntCnt)
;    2308 	{
;    2309     	if (_FF_read(dir_addr+(m*0x200))==0)
;    2310     		break;
;    2311 		for (n=0; n<16; n++)
;    2312 		{
;    2313 			for (c=0; c<11; c++)
;    2314 			{
;    2315 				if (_FF_buff[(n*0x20)]==0)
;    2316 				{
;    2317 					n=16;
;    2318 					d=BPB_RootEntCnt;
;    2319 					valid_flag = 0;
;    2320 					break;
;    2321 				}
;    2322 				valid_flag = 1;
;    2323 				if (valid_file_char(_FF_buff[(n*0x20)+c]))
;    2324 				{
;    2325 					valid_flag = 0;
;    2326 					break;
;    2327 				}
;    2328 		    }   
;    2329 		    if (valid_flag)
;    2330 	  		{
;    2331 		  		calc = (n * 0x20) + 0xB;
;    2332 		  		attribute_temp = _FF_buff[calc];
;    2333 		  		putchar('\n');
;    2334 				putchar('\r');
;    2335 				c = (n * 0x20);
;    2336 			  	calc = ((long) _FF_buff[c+0x1F] << 24) | ((long) _FF_buff[c+0x1E] << 16) |
;    2337 			  			((long) _FF_buff[c+0x1D] << 8) | ((long) _FF_buff[c+0x1C]);
;    2338 			  	calc_clus = ((int) _FF_buff[c+0x1B] << 8) | (int) _FF_buff[c+0x1A];
;    2339 				if (attribute_temp & 0x10)
;    2340 					printf("  [");
;    2341 				else
;    2342 			  		printf("                [%ld] bytes      (%X)\r  ", calc, calc_clus);		  		
;    2343 				for (c=0; c<8; c++)
;    2344 				{
;    2345 					calc = (n * 0x20) + c;
;    2346 					if (_FF_buff[calc]==0x20)
;    2347 						break;
;    2348 					putchar(_FF_buff[calc]);
;    2349 				}
;    2350 				if (attribute_temp & 0x10)
;    2351 				{
;    2352 					printf("]      (%X)", calc_clus);
;    2353 				}
;    2354 				else
;    2355 				{
;    2356 					putchar('.');
;    2357 					for (c=8; c<11; c++)
;    2358 					{
;    2359 						calc = (n * 0x20) + c;
;    2360 						if (_FF_buff[calc]==0x20)
;    2361 							break;
;    2362 						putchar(_FF_buff[calc]);
;    2363 					}
;    2364 				}
;    2365 		  	}
;    2366 		  	d++;		  		
;    2367 		}
;    2368 		m++;
;    2369 		if (_FF_ROOT_ADDR!=_FF_DIR_ADDR)
;    2370 		{
;    2371 		   	if (m==BPB_SecPerClus)
;    2372 		   	{
;    2373 
;    2374 				m = next_cluster(dir_clus, SINGLE);
;    2375 				if (m != EOF)
;    2376 				{	// another dir cluster exists
;    2377 					dir_addr = clust_to_addr(m);
;    2378 					dir_clus = m;
;    2379 					d = 0;
;    2380 					m = 0;
;    2381 				}
;    2382 				else
;    2383 					break;
;    2384 		   		
;    2385 		   	}
;    2386 		}
;    2387 	}
;    2388 	putchar('\n');
;    2389 	putchar('\r');	
;    2390 } 
;    2391 
;    2392 void GetVolID(void)
;    2393 {
;    2394 	printf("\r\n  Volume Serial:  [0x%lX]", BS_VolSerial);
;    2395 	printf("\r\n  Volume Label:  [%s]\r\n", BS_VolLab);
;    2396 }
;    2397 #endif
;    2398 
;    2399 // Convert a cluster number into a read address
;    2400 unsigned long clust_to_addr(unsigned int clust_no)
;    2401 {
_clust_to_addr:
;    2402 	unsigned long clust_addr;
;    2403 	
;    2404 	FirstSectorofCluster = ((clust_no - 2) * (long) BPB_SecPerClus) + (long) FirstDataSector;
	SBIW R28,4
;	clust_no -> Y+4
;	clust_addr -> Y+0
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,2
	LDS  R30,_BPB_SecPerClus
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
;    2405 	clust_addr = (long) FirstSectorofCluster * (long) BPB_BytsPerSec + _FF_PART_ADDR;
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	CLR  R22
	CLR  R23
	LDS  R26,_FirstSectorofCluster
	LDS  R27,_FirstSectorofCluster+1
	LDS  R24,_FirstSectorofCluster+2
	LDS  R25,_FirstSectorofCluster+3
	CALL SUBOPT_0x4B
	__PUTD1S 0
;    2406 
;    2407 	return (clust_addr);
	ADIW R28,6
	RET
;    2408 }
;    2409 
;    2410 // Converts an address into a cluster number
;    2411 unsigned int addr_to_clust(unsigned long clus_addr)
;    2412 {
_addr_to_clust:
;    2413 	if (clus_addr <= _FF_PART_ADDR)
	LDS  R30,__FF_PART_ADDR
	LDS  R31,__FF_PART_ADDR+1
	LDS  R22,__FF_PART_ADDR+2
	LDS  R23,__FF_PART_ADDR+3
	__GETD2S 0
	CALL __CPD12
	BRLO _0x174
;    2414 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x4D5
;    2415 	clus_addr -= _FF_PART_ADDR;
_0x174:
	LDS  R26,__FF_PART_ADDR
	LDS  R27,__FF_PART_ADDR+1
	LDS  R24,__FF_PART_ADDR+2
	LDS  R25,__FF_PART_ADDR+3
	__GETD1S 0
	CALL __SUBD12
	__PUTD1S 0
;    2416 	clus_addr /= BPB_BytsPerSec;
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	__GETD2S 0
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	__PUTD1S 0
;    2417 	if (clus_addr <= (unsigned long) FirstDataSector)
	LDS  R30,_FirstDataSector
	LDS  R31,_FirstDataSector+1
	CLR  R22
	CLR  R23
	__GETD2S 0
	CALL __CPD12
	BRLO _0x175
;    2418 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x4D5
;    2419 	clus_addr -= FirstDataSector;
_0x175:
	LDS  R30,_FirstDataSector
	LDS  R31,_FirstDataSector+1
	__GETD2S 0
	CLR  R22
	CLR  R23
	CALL __SUBD21
	__PUTD2S 0
;    2420 	clus_addr /= BPB_SecPerClus;
	LDS  R30,_BPB_SecPerClus
	__GETD2S 0
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	__PUTD1S 0
;    2421 	clus_addr += 2;
	__ADDD1N 2
	__PUTD1S 0
;    2422 	if (clus_addr > 0xFFFF)
	__GETD2S 0
	__CPD2N 0x10000
	BRLO _0x176
;    2423 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x4D5
;    2424 	
;    2425 	return ((int) clus_addr);	
_0x176:
	LD   R30,Y
	LDD  R31,Y+1
_0x4D5:
	ADIW R28,4
	RET
;    2426 }
;    2427 
;    2428 // Find the cluster that the current cluster is pointing to
;    2429 unsigned int next_cluster(unsigned int current_cluster, unsigned char mode)
;    2430 {
_next_cluster:
;    2431 	unsigned int calc_sec, calc_offset, calc_remainder, next_clust;
;    2432 	unsigned long addr_temp;
;    2433 	
;    2434 	if (current_cluster<=1)		// If cluster is 0 or 1, its the wrong cluster
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
	BRSH _0x177
;    2435 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4D4
;    2436 		
;    2437 	if (BPB_FATType == 0x36)		// if FAT16
_0x177:
	LDS  R26,_BPB_FATType
	CPI  R26,LOW(0x36)
	BREQ PC+3
	JMP _0x178
;    2438 	{
;    2439 		// FAT16 table address calculations
;    2440 		calc_sec = current_cluster / (BPB_BytsPerSec / 2) + BPB_RsvdSecCnt;
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x4D
;    2441 		calc_offset = 2 * (current_cluster % (BPB_BytsPerSec / 2));
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x4E
;    2442 	    
;    2443 	 	addr_temp = _FF_PART_ADDR+(calc_sec*0x200);
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
;    2444 		if (mode==SINGLE)
	LDD  R26,Y+12
	CPI  R26,LOW(0x1)
	BRNE _0x179
;    2445 		{	// This is a single cluster lookup
;    2446 			if (_FF_read(addr_temp)==0)
	CALL SUBOPT_0x34
	BRNE _0x17A
;    2447 				return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4D4
;    2448 		}
_0x17A:
;    2449 		else if ((mode==CHAIN) || (mode==END_CHAIN))
	RJMP _0x17B
_0x179:
	LDD  R26,Y+12
	CPI  R26,LOW(0x0)
	BREQ _0x17D
	CPI  R26,LOW(0x2)
	BRNE _0x17C
_0x17D:
;    2450 		{	// Mupltiple clusters to lookup
;    2451 			if (addr_temp!=_FF_buff_addr)
	LDS  R30,__FF_buff_addr
	LDS  R31,__FF_buff_addr+1
	LDS  R22,__FF_buff_addr+2
	LDS  R23,__FF_buff_addr+3
	__GETD2S 6
	CALL __CPD12
	BREQ _0x17F
;    2452 			{	// Is the address of lookup is different then the current buffere address
;    2453 				#ifndef _READ_ONLY_
;    2454 				if (_FF_buff_addr)	// if the buffer address is 0, don't write
	CALL __CPD10
	BREQ _0x180
;    2455 				{
;    2456 					#ifdef _SECOND_FAT_ON_
;    2457 						if (_FF_buff_addr < _FF_FAT2_ADDR)
	CALL SUBOPT_0x4F
	BRSH _0x181
;    2458 							if (_FF_write(_FF_buff_addr+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
	CALL SUBOPT_0x50
	BRNE _0x182
;    2459 								return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4D4
;    2460 					#endif
;    2461 					if (_FF_write(_FF_buff_addr)==0)	// Save buffer data to card
_0x182:
_0x181:
	CALL SUBOPT_0x51
	BRNE _0x183
;    2462 						return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4D4
;    2463 				}
_0x183:
;    2464 				#endif
;    2465 				if (_FF_read(addr_temp)==0)	// Read new table info
_0x180:
	__GETD1S 6
	CALL SUBOPT_0x34
	BRNE _0x184
;    2466 					return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4D4
;    2467 			}
_0x184:
;    2468 		}
_0x17F:
;    2469 		next_clust = ((int) _FF_buff[calc_offset+1] << 8) | _FF_buff[calc_offset];
_0x17C:
_0x17B:
	MOVW R30,R18
	__ADDW1MN __FF_buff,1
	LD   R31,Z
	LDI  R30,LOW(0)
	MOVW R0,R30
	LDI  R26,LOW(__FF_buff)
	LDI  R27,HIGH(__FF_buff)
	ADD  R26,R18
	ADC  R27,R19
	LD   R30,X
	MOVW R26,R0
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
;    2470 	}
;    2471 	#ifdef _FAT12_ON_
;    2472 	else if (BPB_FATType == 0x32)	// if FAT12
;    2473 	{
;    2474 		// FAT12 table address calculations
;    2475 		calc_offset = (current_cluster * 3) / 2;
;    2476 		calc_remainder = (current_cluster * 3) % 2;
;    2477 		calc_sec = (calc_offset / BPB_BytsPerSec) + BPB_RsvdSecCnt;
;    2478 		calc_offset %= BPB_BytsPerSec;
;    2479 
;    2480 	 	addr_temp = _FF_PART_ADDR+(calc_sec*BPB_BytsPerSec);
;    2481 		if (mode==SINGLE)
;    2482 		{	// This is a single cluster lookup
;    2483 			if (_FF_read(addr_temp)==0)
;    2484 				return(EOF);
;    2485 		}
;    2486 		else if ((mode==CHAIN) || (mode==END_CHAIN))
;    2487 		{	// Mupltiple clusters to lookup
;    2488 			if (addr_temp!=_FF_buff_addr)
;    2489 			{	// Is the address of lookup is different then the current buffere address
;    2490 				#ifndef _READ_ONLY_
;    2491 				if (_FF_buff_addr)	// if the buffer address is 0, don't write
;    2492 				{
;    2493 					#ifdef _SECOND_FAT_ON_
;    2494 						if (_FF_buff_addr < _FF_FAT2_ADDR)
;    2495 							if (_FF_write(_FF_buff_addr+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
;    2496 								return(EOF);
;    2497 					#endif
;    2498 					if (_FF_write(_FF_buff_addr)==0)	// Save buffer data to card
;    2499 						return(EOF);
;    2500 				}
;    2501 				#endif
;    2502 				if (_FF_read(addr_temp)==0)	// Read new table info
;    2503 					return(EOF);
;    2504 			}
;    2505 		}
;    2506 		next_clust = _FF_buff[calc_offset];
;    2507 		if (calc_offset == (BPB_BytsPerSec-1))
;    2508 		{	// Is the FAT12 record accross more than one sector?
;    2509 			addr_temp = _FF_PART_ADDR+((calc_sec+1)*0x200);
;    2510 			if ((mode==CHAIN) || (mode==END_CHAIN))
;    2511 			{	// multiple chain lookup
;    2512 				#ifndef _READ_ONLY_
;    2513 					#ifdef _SECOND_FAT_ON_
;    2514 						if (_FF_buff_addr < _FF_FAT2_ADDR)
;    2515 							if (_FF_write(_FF_buff_addr+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
;    2516 								return(EOF);
;    2517 					#endif
;    2518 				if (_FF_write(_FF_buff_addr)==0)	// Save buffer data to card
;    2519 					return(EOF);
;    2520 				#endif
;    2521 				_FF_buff_addr = addr_temp;		// Save new buffer address
;    2522 			}
;    2523 			if (_FF_read(addr_temp)==0)
;    2524 				return(EOF);
;    2525 			next_clust |= ((int) _FF_buff[0] << 8);
;    2526 		}
;    2527 		else
;    2528 			next_clust |= ((int) _FF_buff[calc_offset+1] << 8);
;    2529 
;    2530 		if (calc_remainder)
;    2531 			next_clust >>= 4;
;    2532 		else
;    2533 			next_clust &= 0x0FFF;
;    2534 			
;    2535 		if (next_clust >= 0xFF8)
;    2536 			next_clust |= 0xF000;			
;    2537 	}
;    2538 	#endif
;    2539 	else		// not FAT12 or FAT16, return 0
	RJMP _0x185
_0x178:
;    2540 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4D4
;    2541 	return (next_clust);
_0x185:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
_0x4D4:
	CALL __LOADLOCR6
	ADIW R28,15
	RET
;    2542 }
;    2543 
;    2544 // Convert a constant string file name into the proper 8.3 FAT format
;    2545 unsigned char *file_name_conversion(unsigned char *current_file)
;    2546 {
_file_name_conversion:
;    2547 	unsigned char n, c;
;    2548 		
;    2549 	c = 0;
	ST   -Y,R17
	ST   -Y,R16
;	*current_file -> Y+2
;	n -> R16
;	c -> R17
	LDI  R17,LOW(0)
;    2550 	
;    2551 	for (n=0; n<14; n++)
	LDI  R16,LOW(0)
_0x187:
	CPI  R16,14
	BRSH _0x188
;    2552 	{
;    2553 		if (valid_file_char(current_file[n])==0)
	CALL SUBOPT_0x52
	CALL _valid_file_char
	SBIW R30,0
	BRNE _0x189
;    2554 			// If the character is valid, save in uppercase to file name buffer
;    2555 			FILENAME[c++] = toupper(current_file[n]);
	MOV  R30,R17
	SUBI R17,-1
	LDI  R31,0
	SUBI R30,LOW(-_FILENAME)
	SBCI R31,HIGH(-_FILENAME)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x52
	CALL _toupper
	POP  R26
	POP  R27
	ST   X,R30
;    2556 		else if (current_file[n]=='.')
	RJMP _0x18A
_0x189:
	CALL SUBOPT_0x53
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BRNE _0x18B
;    2557 			// If it is a period, back fill buffer with [spaces], till 8 characters deep
;    2558 			while (c<8)
_0x18C:
	CPI  R17,8
	BRSH _0x18E
;    2559 				FILENAME[c++] = 0x20;
	MOV  R30,R17
	SUBI R17,-1
	CALL SUBOPT_0x54
;    2560 		else if (current_file[n]==0)
	RJMP _0x18C
_0x18E:
	RJMP _0x18F
_0x18B:
	CALL SUBOPT_0x53
	LD   R30,X
	CPI  R30,0
	BRNE _0x190
;    2561 		{	// If it is NULL, back fill buffer with [spaces], till 11 characters deep
;    2562 			while (c<11)
_0x191:
	CPI  R17,11
	BRSH _0x193
;    2563 				FILENAME[c++] = 0x20;
	MOV  R30,R17
	SUBI R17,-1
	CALL SUBOPT_0x54
;    2564 			break;
	RJMP _0x191
_0x193:
	RJMP _0x188
;    2565 		}
;    2566 		else
_0x190:
;    2567 		{
;    2568 			_FF_error = NAME_ERR;
	LDI  R30,LOW(5)
	STS  __FF_error,R30
;    2569 			return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x4D3
;    2570 		}
_0x18F:
_0x18A:
;    2571 		if (c>=11)
	CPI  R17,11
	BRSH _0x188
;    2572 			break;
;    2573 	}
	SUBI R16,-1
	RJMP _0x187
_0x188:
;    2574 	FILENAME[c] = 0;
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_FILENAME)
	SBCI R27,HIGH(-_FILENAME)
	LDI  R30,LOW(0)
	ST   X,R30
;    2575 	// Return the pointer of the filename
;    2576 	return (FILENAME);		
	LDI  R30,LOW(_FILENAME)
	LDI  R31,HIGH(_FILENAME)
_0x4D3:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
;    2577 }
;    2578 
;    2579 // Find the first cluster that is pointing to clus_no
;    2580 unsigned int prev_cluster(unsigned int clus_no)
;    2581 {
_prev_cluster:
;    2582 	unsigned char read_flag;
;    2583 	unsigned int calc_temp, n, c, n_temp;
;    2584 	unsigned long calc_clus, addr_temp;
;    2585 	
;    2586 	addr_temp = _FF_FAT1_ADDR;
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
;    2587 	c = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+15,R30
	STD  Y+15+1,R31
;    2588 	if ((clus_no==0) && (BPB_FATType==0x36))
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	CALL __CPW02
	BRNE _0x197
	LDS  R26,_BPB_FATType
	CPI  R26,LOW(0x36)
	BREQ _0x198
_0x197:
	RJMP _0x196
_0x198:
;    2589 	{
;    2590 		if (clus_0_addr>addr_temp)
	__GETD1S 5
	LDS  R26,_clus_0_addr
	LDS  R27,_clus_0_addr+1
	LDS  R24,_clus_0_addr+2
	LDS  R25,_clus_0_addr+3
	CALL __CPD12
	BRSH _0x199
;    2591 		{
;    2592 			addr_temp = clus_0_addr;
	LDS  R30,_clus_0_addr
	LDS  R31,_clus_0_addr+1
	LDS  R22,_clus_0_addr+2
	LDS  R23,_clus_0_addr+3
	__PUTD1S 5
;    2593 			c = c_counter;
	LDS  R30,_c_counter
	LDS  R31,_c_counter+1
	STD  Y+15,R30
	STD  Y+15+1,R31
;    2594 		}
;    2595 	}
_0x199:
;    2596 
;    2597 	read_flag = 1;
_0x196:
	LDI  R16,LOW(1)
;    2598 	
;    2599 	while (addr_temp<_FF_FAT2_ADDR)
_0x19A:
	LDS  R30,__FF_FAT2_ADDR
	LDS  R31,__FF_FAT2_ADDR+1
	LDS  R22,__FF_FAT2_ADDR+2
	LDS  R23,__FF_FAT2_ADDR+3
	__GETD2S 5
	CALL __CPD21
	BRLO PC+3
	JMP _0x19C
;    2600 	{
;    2601 		if (BPB_FATType == 0x36)		// if FAT16
	LDS  R26,_BPB_FATType
	CPI  R26,LOW(0x36)
	BREQ PC+3
	JMP _0x19D
;    2602 		{
;    2603 			if (clus_no==0)
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	SBIW R30,0
	BRNE _0x19E
;    2604 			{
;    2605 				clus_0_addr = addr_temp;
	__GETD1S 5
	STS  _clus_0_addr,R30
	STS  _clus_0_addr+1,R31
	STS  _clus_0_addr+2,R22
	STS  _clus_0_addr+3,R23
;    2606 				c_counter = c;
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	STS  _c_counter,R30
	STS  _c_counter+1,R31
;    2607 			}
;    2608 			if (_FF_read(addr_temp)==0)		// Read error ==> break
_0x19E:
	__GETD1S 5
	CALL SUBOPT_0x34
	BRNE _0x19F
;    2609 				return(0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x4D2
;    2610 			if (_FF_n_temp)
_0x19F:
	LDS  R30,__FF_n_temp
	LDS  R31,__FF_n_temp+1
	LDS  R22,__FF_n_temp+2
	LDS  R23,__FF_n_temp+3
	CALL __CPD10
	BREQ _0x1A0
;    2611 			{
;    2612 				n_temp = _FF_n_temp;
	LDS  R30,__FF_n_temp
	LDS  R31,__FF_n_temp+1
	STD  Y+13,R30
	STD  Y+13+1,R31
;    2613 				_FF_n_temp = 0;
	LDI  R30,0
	STS  __FF_n_temp,R30
	STS  __FF_n_temp+1,R30
	STS  __FF_n_temp+2,R30
	STS  __FF_n_temp+3,R30
;    2614 			}
;    2615 			else
	RJMP _0x1A1
_0x1A0:
;    2616 				n_temp = 0;
	LDI  R30,0
	STD  Y+13,R30
	STD  Y+13+1,R30
;    2617 			for (n=n_temp; n<(BPB_BytsPerSec/2); n++)
_0x1A1:
	__GETWRS 19,20,13
_0x1A3:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	LSR  R31
	ROR  R30
	CP   R19,R30
	CPC  R20,R31
	BRLO PC+3
	JMP _0x1A4
;    2618 			{
;    2619 				calc_clus = ((unsigned int) _FF_buff[(n*2)+1] << 8) | ((unsigned int) _FF_buff[n*2]);
	__GETW1R 19,20
	LSL  R30
	ROL  R31
	__ADDW1MN __FF_buff,1
	CALL SUBOPT_0x55
	__GETW1R 19,20
	LSL  R30
	ROL  R31
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	LD   R30,Z
	CALL SUBOPT_0x37
	__PUTD1S 9
;    2620 				calc_temp = (unsigned long) n + (((unsigned long) BPB_BytsPerSec/2) * ((unsigned long) c - 1));
	__GETW1R 19,20
	CLR  R22
	CLR  R23
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
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
;    2621 				if (calc_clus==clus_no)
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	__GETD2S 9
	CLR  R22
	CLR  R23
	CALL __CPD12
	BRNE _0x1A5
;    2622 				{
;    2623 					if (calc_clus==0)
	__GETD1S 9
	CALL __CPD10
	BRNE _0x1A6
;    2624 						_FF_n_temp = n;
	__GETW1R 19,20
	CLR  R22
	CLR  R23
	STS  __FF_n_temp,R30
	STS  __FF_n_temp+1,R31
	STS  __FF_n_temp+2,R22
	STS  __FF_n_temp+3,R23
;    2625 					return(calc_temp);
_0x1A6:
	__GETW1R 17,18
	RJMP _0x4D2
;    2626 				}
;    2627 				else if (calc_temp > DataClusTot)
_0x1A5:
	LDS  R30,_DataClusTot
	LDS  R31,_DataClusTot+1
	LDS  R22,_DataClusTot+2
	LDS  R23,_DataClusTot+3
	__GETW2R 17,18
	CLR  R24
	CLR  R25
	CALL __CPD12
	BRSH _0x1A8
;    2628 				{
;    2629 					_FF_error = DISK_FULL;
	CALL SUBOPT_0x56
;    2630 					return (0);
	RJMP _0x4D2
;    2631 				}
;    2632 			}
_0x1A8:
	__ADDWRN 19,20,1
	RJMP _0x1A3
_0x1A4:
;    2633 			addr_temp += 0x200;
	__GETD1S 5
	__ADDD1N 512
	__PUTD1S 5
;    2634 			c++;
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ADIW R30,1
	STD  Y+15,R30
	STD  Y+15+1,R31
;    2635 		}
;    2636 		#ifdef _FAT12_ON_
;    2637 		else if (BPB_FATType == 0x32)	// if FAT12
;    2638 		{
;    2639 			if (read_flag)
;    2640 			{
;    2641 				if (_FF_read(addr_temp)==0)
;    2642 					return (0);	// if the read fails return 0
;    2643 				read_flag = 0;
;    2644 			}
;    2645 			calc_temp = ((unsigned long) c * 3) / 2;
;    2646 			calc_temp %= BPB_BytsPerSec;
;    2647 			calc_clus = _FF_buff[calc_temp++];
;    2648 			if (calc_temp == BPB_BytsPerSec)
;    2649 			{	// Is the FAT12 record accross a sector?
;    2650 				addr_temp += 0x200;
;    2651 				if (_FF_read(addr_temp)==0)
;    2652 					return (0);
;    2653 				calc_clus |= ((unsigned int) _FF_buff[0] << 8);
;    2654 				calc_temp = 0;
;    2655 			}
;    2656 			else
;    2657 				calc_clus |= ((unsigned int) _FF_buff[calc_temp++] << 8);
;    2658                           	
;    2659 			if (c % 2)
;    2660 				calc_clus >>= 4;
;    2661 			else
;    2662 				calc_clus &= 0x0FFF;
;    2663 			
;    2664 			if (calc_clus == clus_no)
;    2665 				return (c);
;    2666 			else if (c > DataClusTot)
;    2667 			{
;    2668 				_FF_error = DISK_FULL;
;    2669 				return (0);
;    2670 			}
;    2671 			if ((calc_temp == BPB_BytsPerSec) && (c % 2))
;    2672 			{
;    2673 				addr_temp += 0x200;
;    2674 				read_flag = 1;
;    2675 			}                                                           
;    2676 			
;    2677 			c++;			
;    2678 		}
;    2679 		#endif
;    2680 		else
	RJMP _0x1A9
_0x19D:
;    2681 			return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x4D2
;    2682 	}
_0x1A9:
	RJMP _0x19A
_0x19C:
;    2683 	_FF_error = DISK_FULL;
	CALL SUBOPT_0x56
;    2684 	return (0);
_0x4D2:
	CALL __LOADLOCR5
	ADIW R28,19
	RET
;    2685 }
;    2686 
;    2687 #ifndef _READ_ONLY_
;    2688 // Update cluster table to point to new cluster
;    2689 unsigned char write_clus_table(unsigned int current_cluster, unsigned int next_value, unsigned char mode)
;    2690 {
_write_clus_table:
;    2691 	unsigned long addr_temp;
;    2692 	unsigned int calc_sec, calc_offset, calc_temp, calc_remainder;
;    2693 	unsigned char nibble[3];
;    2694 	
;    2695 	if (current_cluster <=1)		// Should never be writing to cluster 0 or 1
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
	BRSH _0x1AA
;    2696 	{
;    2697 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x4D1
;    2698 	}
;    2699 	if (BPB_FATType == 0x36)		// if FAT16
_0x1AA:
	LDS  R26,_BPB_FATType
	CPI  R26,LOW(0x36)
	BREQ PC+3
	JMP _0x1AB
;    2700 	{
;    2701 		calc_sec = current_cluster / (BPB_BytsPerSec / 2) + BPB_RsvdSecCnt;
	CALL SUBOPT_0x57
	CALL SUBOPT_0x4D
;    2702 		calc_offset = 2 * (current_cluster % (BPB_BytsPerSec / 2));
	CALL SUBOPT_0x57
	CALL SUBOPT_0x4E
;    2703 		addr_temp = _FF_PART_ADDR + ((long) calc_sec*0x200);
	CLR  R22
	CLR  R23
	__GETD2N 0x200
	CALL SUBOPT_0x4B
	__PUTD1S 11
;    2704 		if (mode==SINGLE)
	LDD  R26,Y+15
	CPI  R26,LOW(0x1)
	BRNE _0x1AC
;    2705 		{	// Updating a single cluster (like writing or saving a file)
;    2706 			if (_FF_read(addr_temp)==0)
	CALL SUBOPT_0x34
	BRNE _0x1AD
;    2707 				return(0);
	LDI  R30,LOW(0)
	RJMP _0x4D1
;    2708 		}
_0x1AD:
;    2709 		else if ((mode==CHAIN) || (mode==END_CHAIN))
	RJMP _0x1AE
_0x1AC:
	LDD  R26,Y+15
	CPI  R26,LOW(0x0)
	BREQ _0x1B0
	CPI  R26,LOW(0x2)
	BRNE _0x1AF
_0x1B0:
;    2710 		{	// Multiple table access operation
;    2711 			if (addr_temp!=_FF_buff_addr)
	LDS  R30,__FF_buff_addr
	LDS  R31,__FF_buff_addr+1
	LDS  R22,__FF_buff_addr+2
	LDS  R23,__FF_buff_addr+3
	__GETD2S 11
	CALL __CPD12
	BREQ _0x1B2
;    2712 			{	// if the desired address is already in the buffer => skip loading buffer
;    2713 				if (_FF_buff_addr)	// if new table address, write buffered, and load new
	CALL __CPD10
	BREQ _0x1B3
;    2714 				{
;    2715 					#ifdef _SECOND_FAT_ON_
;    2716 						if (_FF_buff_addr < _FF_FAT2_ADDR)
	CALL SUBOPT_0x4F
	BRSH _0x1B4
;    2717 							if (_FF_write(_FF_buff_addr+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
	CALL SUBOPT_0x50
	BRNE _0x1B5
;    2718 								return(0);
	LDI  R30,LOW(0)
	RJMP _0x4D1
;    2719 					#endif
;    2720 					if (_FF_write(_FF_buff_addr)==0)
_0x1B5:
_0x1B4:
	CALL SUBOPT_0x51
	BRNE _0x1B6
;    2721 						return(0);
	LDI  R30,LOW(0)
	RJMP _0x4D1
;    2722 				}
_0x1B6:
;    2723 				if (_FF_read(addr_temp)==0)
_0x1B3:
	__GETD1S 11
	CALL SUBOPT_0x34
	BRNE _0x1B7
;    2724 					return(0);
	LDI  R30,LOW(0)
	RJMP _0x4D1
;    2725 			}
_0x1B7:
;    2726 		}
_0x1B2:
;    2727 				
;    2728 		_FF_buff[calc_offset+1] = (next_value >> 8); 
_0x1AF:
_0x1AE:
	MOVW R30,R18
	__ADDW1MN __FF_buff,1
	MOVW R26,R30
	LDD  R30,Y+17
	ANDI R31,HIGH(0x0)
	ST   X,R30
;    2729 		_FF_buff[calc_offset] = (next_value & 0xFF);
	MOVW R26,R18
	SUBI R26,LOW(-__FF_buff)
	SBCI R27,HIGH(-__FF_buff)
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ANDI R31,HIGH(0xFF)
	ST   X,R30
;    2730 		if ((mode==SINGLE) || (mode==END_CHAIN))
	LDD  R26,Y+15
	CPI  R26,LOW(0x1)
	BREQ _0x1B9
	CPI  R26,LOW(0x2)
	BRNE _0x1B8
_0x1B9:
;    2731 		{
;    2732 			#ifdef _SECOND_FAT_ON_
;    2733 				if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
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
	CALL SUBOPT_0x58
	BRNE _0x1BB
;    2734 					return(0);
	LDI  R30,LOW(0)
	RJMP _0x4D1
;    2735 			#endif
;    2736 			if (_FF_write(addr_temp)==0)
_0x1BB:
	__GETD1S 11
	CALL SUBOPT_0x59
	BRNE _0x1BC
;    2737 			{
;    2738 				return(0);
	LDI  R30,LOW(0)
	RJMP _0x4D1
;    2739 			}
;    2740 		}
_0x1BC:
;    2741 	}
_0x1B8:
;    2742 	#ifdef _FAT12_ON_
;    2743 		else if (BPB_FATType == 0x32)		// if FAT12
;    2744 		{
;    2745 			calc_offset = (current_cluster * 3) / 2;
;    2746 			calc_remainder = (current_cluster * 3) % 2;
;    2747 			calc_sec = calc_offset / BPB_BytsPerSec + BPB_RsvdSecCnt;
;    2748 			calc_offset %= BPB_BytsPerSec;
;    2749 			addr_temp = _FF_PART_ADDR + ((long) calc_sec * (long) BPB_BytsPerSec);
;    2750 
;    2751 			if (mode==SINGLE)
;    2752 			{
;    2753 				if (_FF_read(addr_temp)==0)
;    2754 					return(0);
;    2755  			}
;    2756  			else if ((mode==CHAIN) || (mode==END_CHAIN))
;    2757   			{
;    2758 				if (addr_temp!=_FF_buff_addr)
;    2759 				{
;    2760 					if (_FF_buff_addr)
;    2761 					{
;    2762 					#ifdef _SECOND_FAT_ON_
;    2763 						if (_FF_buff_addr < _FF_FAT2_ADDR)
;    2764 							if (_FF_write(_FF_buff_addr+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
;    2765 								return(0);
;    2766 					#endif
;    2767 						if (_FF_write(_FF_buff_addr)==0)
;    2768 							return(0);
;    2769 					}
;    2770 					if (_FF_read(addr_temp)==0)
;    2771 						return(0);
;    2772 				}
;    2773 			}
;    2774 			nibble[0] = next_value & 0x00F;
;    2775 			nibble[1] = (next_value >> 4) & 0x00F;
;    2776 			nibble[2] = (next_value >> 8) & 0x00F;
;    2777     	
;    2778 			if (calc_offset == (BPB_BytsPerSec-1))
;    2779 			{	// Is the FAT12 record accross a sector?
;    2780 				if (calc_remainder)
;    2781 				{	// Record table uses 1 nibble of last byte
;    2782 					calc_temp = _FF_buff[calc_offset] & 0x0F;	// Mask to add new value
;    2783 					_FF_buff[calc_offset] = calc_temp | (nibble[0] << 4);	// store nibble in correct location
;    2784 					#ifdef _SECOND_FAT_ON_
;    2785 						if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
;    2786 							return(0);
;    2787 					#endif
;    2788 					if (_FF_write(addr_temp)==0)
;    2789 						return(0);
;    2790 					addr_temp += BPB_BytsPerSec;
;    2791 					if (_FF_read(addr_temp)==0)
;    2792 						return(0);	// if the read fails return 0
;    2793 					_FF_buff[0] = (nibble[2] << 4) | nibble[1];
;    2794 					if ((mode==SINGLE) || (mode==END_CHAIN))
;    2795 					{
;    2796 						#ifdef _SECOND_FAT_ON_
;    2797 							if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
;    2798 								return(0);
;    2799 						#endif
;    2800 						if (_FF_write(addr_temp)==0)
;    2801 							return(0);
;    2802 					}
;    2803 				}
;    2804 				else
;    2805 				{	// Record table uses whole last byte
;    2806 					_FF_buff[calc_offset] = (nibble[1] << 4) | nibble[0];
;    2807 					#ifdef _SECOND_FAT_ON_
;    2808 						if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
;    2809 							return(0);
;    2810 					#endif
;    2811 					if (_FF_write(addr_temp)==0)
;    2812 						return(0);
;    2813 					addr_temp += BPB_BytsPerSec;
;    2814 					if (_FF_read(addr_temp)==0)
;    2815 						return(0);	// if the read fails return 0
;    2816 					calc_temp = _FF_buff[0] & 0xF0;		// Mask to add new value
;    2817 					_FF_buff[0] = calc_temp | nibble[2];	// store nibble in correct location
;    2818 					if ((mode==SINGLE) || (mode==END_CHAIN))
;    2819 					{
;    2820 						#ifdef _SECOND_FAT_ON_
;    2821 							if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
;    2822 								return(0);
;    2823 						#endif
;    2824 						if (_FF_write(addr_temp)==0)
;    2825 							return(0);
;    2826 					}
;    2827 				}
;    2828 			}
;    2829 			else
;    2830 			{
;    2831 				if (calc_remainder)
;    2832 				{	// Record table uses 1 nibble of current byte
;    2833 					calc_temp = _FF_buff[calc_offset] & 0x0F;	// Mask to add new value
;    2834 					_FF_buff[calc_offset] = calc_temp | (nibble[0] << 4);	// store nibble in correct location
;    2835 					_FF_buff[calc_offset+1] = (nibble[2] << 4) | nibble[1];
;    2836 					if ((mode==SINGLE) || (mode==END_CHAIN))
;    2837 					{
;    2838 						#ifdef _SECOND_FAT_ON_
;    2839 							if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
;    2840 								return(0);
;    2841 						#endif
;    2842 						if (_FF_write(addr_temp)==0)
;    2843 							return(0);
;    2844 					}
;    2845 				}
;    2846 				else
;    2847 				{	// Record table uses whole current byte
;    2848 					_FF_buff[calc_offset] = (nibble[1] << 4) | nibble[0];
;    2849 					calc_temp = _FF_buff[calc_offset+1] & 0xF0;		// Mask to add new value
;    2850 					_FF_buff[calc_offset+1] = calc_temp | nibble[2];	// store nibble in correct location
;    2851 					if ((mode==SINGLE) || (mode==END_CHAIN))
;    2852 					{
;    2853 						#ifdef _SECOND_FAT_ON_
;    2854 							if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
;    2855 								return(0);
;    2856 						#endif
;    2857 						if (_FF_write(addr_temp)==0)
;    2858 							return(0);
;    2859 					}
;    2860 				}
;    2861 			}
;    2862 		}
;    2863 	#endif
;    2864 	else		// not FAT12 or FAT16, return 0
	RJMP _0x1BD
_0x1AB:
;    2865 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x4D1
;    2866 		
;    2867 	return(1);	
_0x1BD:
	LDI  R30,LOW(1)
_0x4D1:
	CALL __LOADLOCR6
	ADIW R28,20
	RET
;    2868 }
;    2869 #endif
;    2870 
;    2871 #ifndef _READ_ONLY_
;    2872 // Save new entry data to FAT entry
;    2873 unsigned char append_toc(FILE *rp)
;    2874 {
_append_toc:
;    2875 	unsigned long file_data;
;    2876 	unsigned char n;
;    2877 	unsigned char *fp;
;    2878 	unsigned int calc_temp, calc_date;
;    2879 	
;    2880 	if (rp==NULL)
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
	BRNE _0x1BE
;    2881 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x4D0
;    2882 
;    2883 	file_data = rp->length;
_0x1BE:
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	CALL __GETD1P
	__PUTD1S 7
;    2884 	if (_FF_read(rp->entry_sec_addr)==0)
	CALL SUBOPT_0x5A
	CALL __FF_read
	CPI  R30,0
	BRNE _0x1BF
;    2885 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x4D0
;    2886 	
;    2887 	// Update Starting Cluster 
;    2888 	fp = &_FF_buff[rp->entry_offset+0x1a];
_0x1BF:
	CALL SUBOPT_0x5B
	__ADDW1MN __FF_buff,26
	__PUTW1R 17,18
;    2889 	*fp++ = rp->clus_start & 0xFF;
	PUSH R18
	PUSH R17
	__ADDWRN 17,18,1
	CALL SUBOPT_0x5C
	ANDI R31,HIGH(0xFF)
	POP  R26
	POP  R27
	ST   X,R30
;    2890 	*fp++ = rp->clus_start >> 8;
	PUSH R18
	PUSH R17
	__ADDWRN 17,18,1
	CALL SUBOPT_0x5C
	MOV  R30,R31
	LDI  R31,0
	POP  R26
	POP  R27
	ST   X,R30
;    2891 	
;    2892 	// Update the File Size
;    2893 	for (n=0; n<4; n++)
	LDI  R16,LOW(0)
_0x1C1:
	CPI  R16,4
	BRSH _0x1C2
;    2894 	{
;    2895 		*fp = file_data & 0xFF;
	CALL SUBOPT_0x5D
;    2896 		file_data >>= 8;
;    2897 		fp++;
	__ADDWRN 17,18,1
;    2898 	}
	SUBI R16,-1
	RJMP _0x1C1
_0x1C2:
;    2899 	
;    2900 	
;    2901 	fp = &_FF_buff[rp->entry_offset+0x16];
	CALL SUBOPT_0x5B
	__ADDW1MN __FF_buff,22
	__PUTW1R 17,18
;    2902 	#ifdef _RTC_ON_ 	// Date/Time Stamp file w/ RTC
;    2903 		rtc_get_timeNdate(&rtc_hour, &rtc_min, &rtc_sec, &rtc_date, &rtc_month, (int *)&rtc_year);	    			
;    2904 		calc_temp = ((int)rtc_sec&0x1F) | (((int)rtc_min&0x3F)<<5) | (((int)rtc_hour&0x1F)<<11);
;    2905 		*fp++ = calc_temp&0x00FF;	// File create Time 
;    2906 		*fp++ = (calc_temp&0xFF00) >> 8;
;    2907 		calc_date = ((int)rtc_date&0x1F) | (((int)rtc_month&0x0F)<<5) | (((rtc_year-1980)&0x7F)<<9);
;    2908 		*fp++ = calc_date&0x00FF;	// File create Date
;    2909 		*fp++ = (calc_date&0xFF00) >> 8;
;    2910 	#else		// Increment Date Code, no RTC used 
;    2911 		file_data = 0;
	__CLRD1S 7
;    2912 		for (n=0; n<4; n++)
	LDI  R16,LOW(0)
_0x1C4:
	CPI  R16,4
	BRSH _0x1C5
;    2913 		{
;    2914 			file_data <<= 8;
	__GETD2S 7
	LDI  R30,LOW(8)
	CALL __LSLD12
	__PUTD1S 7
;    2915 			file_data |= *fp;
	__GETW2R 17,18
	LD   R30,X
	__GETD2S 7
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __ORD12
	__PUTD1S 7
;    2916 			fp--;
	__SUBWRN 17,18,1
;    2917 		}
	SUBI R16,-1
	RJMP _0x1C4
_0x1C5:
;    2918 		file_data++;
	__GETD1S 7
	__SUBD1N -1
	__PUTD1S 7
;    2919 		for (n=0; n<4; n++)
	LDI  R16,LOW(0)
_0x1C7:
	CPI  R16,4
	BRSH _0x1C8
;    2920 		{
;    2921 			fp++;
	__ADDWRN 17,18,1
;    2922 			*fp = file_data & 0xFF;
	CALL SUBOPT_0x5D
;    2923 			file_data >>=8;
;    2924 		}
	SUBI R16,-1
	RJMP _0x1C7
_0x1C8:
;    2925 	#endif
;    2926 	if (_FF_write(rp->entry_sec_addr)==0)
	CALL SUBOPT_0x5A
	CALL __FF_write
	CPI  R30,0
	BRNE _0x1C9
;    2927 		return(0);
	LDI  R30,LOW(0)
	RJMP _0x4D0
;    2928 	
;    2929 	return(1);
_0x1C9:
	LDI  R30,LOW(1)
_0x4D0:
	CALL __LOADLOCR5
	ADIW R28,13
	RET
;    2930 }
;    2931 #endif
;    2932 
;    2933 #ifndef _READ_ONLY_
;    2934 // Erase a chain of clusters (set table entries to 0 for clusters in chain)
;    2935 unsigned char erase_clus_chain(unsigned int start_clus)
;    2936 {
_erase_clus_chain:
;    2937 	unsigned int clus_temp, clus_use;
;    2938 	
;    2939 	if (start_clus==0)
	CALL __SAVELOCR4
;	start_clus -> Y+4
;	clus_temp -> R16,R17
;	clus_use -> R18,R19
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BRNE _0x1CA
;    2940 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x4CF
;    2941 	clus_use = start_clus;
_0x1CA:
	__GETWRS 18,19,4
;    2942 	_FF_buff_addr = 0;
	LDI  R30,0
	STS  __FF_buff_addr,R30
	STS  __FF_buff_addr+1,R30
	STS  __FF_buff_addr+2,R30
	STS  __FF_buff_addr+3,R30
;    2943 	while(clus_use <= 0xFFF8)
_0x1CB:
	__CPWRN 18,19,65529
	BRSH _0x1CD
;    2944 	{
;    2945 		clus_temp = next_cluster(clus_use, CHAIN);
	CALL SUBOPT_0x5E
	MOVW R16,R30
;    2946 		if ((clus_temp >= 0xFFF8) || (clus_temp == 0))
	__CPWRN 16,17,65528
	BRSH _0x1CF
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRNE _0x1CE
_0x1CF:
;    2947 			break;
	RJMP _0x1CD
;    2948 		if (write_clus_table(clus_use, 0, CHAIN) == 0)
_0x1CE:
	ST   -Y,R19
	ST   -Y,R18
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x22
	CALL _write_clus_table
	CPI  R30,0
	BRNE _0x1D1
;    2949 			return (0);
	LDI  R30,LOW(0)
	RJMP _0x4CF
;    2950 		clus_use = clus_temp;
_0x1D1:
	__MOVEWRR 18,19,16,17
;    2951 	}
	RJMP _0x1CB
_0x1CD:
;    2952 	if (write_clus_table(clus_use, 0, END_CHAIN) == 0)
	ST   -Y,R19
	ST   -Y,R18
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x7
	CALL _write_clus_table
	CPI  R30,0
	BRNE _0x1D2
;    2953 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x4CF
;    2954 	clus_0_addr = 0;
_0x1D2:
	LDI  R30,0
	STS  _clus_0_addr,R30
	STS  _clus_0_addr+1,R30
	STS  _clus_0_addr+2,R30
	STS  _clus_0_addr+3,R30
;    2955 	c_counter = 0;
	LDI  R30,0
	STS  _c_counter,R30
	STS  _c_counter+1,R30
;    2956 	
;    2957 	return (1);	
	LDI  R30,LOW(1)
_0x4CF:
	CALL __LOADLOCR4
	ADIW R28,6
	RET
;    2958 }
;    2959 
;    2960 // Quickformat of a card (erase cluster table and root directory
;    2961 int fquickformat(void)
;    2962 {
;    2963 	long c;
;    2964 	
;    2965 	for (c=0; c<BPB_BytsPerSec; c++)
;	c -> Y+0
;    2966 		_FF_buff[c] = 0;
;    2967 	
;    2968 	c = _FF_FAT1_ADDR + 0x200;
;    2969 	while (c < (_FF_ROOT_ADDR + (0x400 * BPB_SecPerClus)))
;    2970 	{
;    2971 		if (_FF_write(c)==0)
;    2972 		{
;    2973 			_FF_error = WRITE_ERR;
;    2974 			return (EOF);
;    2975 		}
;    2976 		c += 0x200;
;    2977 	}	
;    2978 	_FF_buff[0] = 0xF8;
;    2979 	_FF_buff[1] = 0xFF;
;    2980 	_FF_buff[2] = 0xFF;
;    2981 	if (BPB_FATType == 0x36)
;    2982 		_FF_buff[3] = 0xFF;
;    2983 	if ((_FF_write(_FF_FAT1_ADDR)==0) || (_FF_write(_FF_FAT2_ADDR)==0))
;    2984 	{
;    2985 		_FF_error = WRITE_ERR;
;    2986 		return (EOF);
;    2987 	}
;    2988 	return (0);
;    2989 }
;    2990 #endif
;    2991 
;    2992 // function that checks for directory changes then gets into a working form
;    2993 int _FF_checkdir(char *F_PATH, unsigned long *SAVE_ADDR, char *path_temp)
;    2994 {
__FF_checkdir:
;    2995 	unsigned char *sp, *qp;
;    2996     
;    2997     *SAVE_ADDR = _FF_DIR_ADDR;	// save local dir addr
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
;    2998     
;    2999     qp = F_PATH;
	__GETWRS 18,19,8
;    3000     if (*qp=='\\')
	CALL SUBOPT_0x5F
	BRNE _0x1DE
;    3001     {
;    3002     	_FF_DIR_ADDR = _FF_ROOT_ADDR;
	LDS  R30,__FF_ROOT_ADDR
	LDS  R31,__FF_ROOT_ADDR+1
	LDS  R22,__FF_ROOT_ADDR+2
	LDS  R23,__FF_ROOT_ADDR+3
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3003 		qp++;
	__ADDWRN 18,19,1
;    3004 	}
;    3005 
;    3006 	sp = path_temp;
_0x1DE:
	__GETWRS 16,17,4
;    3007 	while(*qp)
_0x1DF:
	MOVW R26,R18
	LD   R30,X
	CPI  R30,0
	BREQ _0x1E1
;    3008 	{
;    3009 		if ((valid_file_char(*qp)==0) || (*qp=='.'))
	CALL SUBOPT_0x41
	BREQ _0x1E3
	MOVW R26,R18
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BRNE _0x1E2
_0x1E3:
;    3010 			*sp++ = toupper(*qp++);
	PUSH R17
	PUSH R16
	__ADDWRN 16,17,1
	MOVW R26,R18
	__ADDWRN 18,19,1
	CALL SUBOPT_0x60
	POP  R26
	POP  R27
	ST   X,R30
;    3011 		else if (*qp=='\\')
	RJMP _0x1E5
_0x1E2:
	CALL SUBOPT_0x5F
	BRNE _0x1E6
;    3012 		{
;    3013 			*sp = 0;	// terminate string
	CALL SUBOPT_0x61
;    3014 			if (_FF_chdir(path_temp))
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL __FF_chdir
	SBIW R30,0
	BREQ _0x1E7
;    3015 			{
;    3016 				return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4CE
;    3017 			}
;    3018 			sp = path_temp;
_0x1E7:
	__GETWRS 16,17,4
;    3019 			qp++;
	__ADDWRN 18,19,1
;    3020 		}
;    3021 		else
	RJMP _0x1E8
_0x1E6:
;    3022 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4CE
;    3023 	}
_0x1E8:
_0x1E5:
	RJMP _0x1DF
_0x1E1:
;    3024 	
;    3025 	*sp = 0;		// terminate string
	CALL SUBOPT_0x61
;    3026 	return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x4CE:
	CALL __LOADLOCR4
	ADIW R28,10
	RET
;    3027 }
;    3028 
;    3029 #ifndef _READ_ONLY_
;    3030 int mkdir(char *F_PATH)
;    3031 {
;    3032 	unsigned char *sp, *qp;
;    3033 	unsigned char fpath[14];
;    3034 	unsigned int c, calc_temp, clus_temp, calc_time, calc_date;
;    3035 	int s;
;    3036 	unsigned long addr_temp, path_addr_temp;
;    3037     
;    3038     addr_temp = 0;	// save local dir addr
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
;    3039     
;    3040     if (_FF_checkdir(F_PATH, &addr_temp, fpath))
;    3041 	{
;    3042 		_FF_DIR_ADDR = addr_temp;
;    3043 		return (EOF);
;    3044 	}
;    3045     
;    3046 	path_addr_temp = _FF_DIR_ADDR;
;    3047 	s = scan_directory(&path_addr_temp, fpath);
;    3048 	if ((s) || (path_addr_temp==0))
;    3049 	{
;    3050 		_FF_DIR_ADDR = addr_temp;
;    3051 		return (EOF);
;    3052 	}
;    3053 	clus_temp = prev_cluster(0);				
;    3054 	calc_temp = path_addr_temp % BPB_BytsPerSec;
;    3055 	path_addr_temp -= calc_temp;
;    3056 	if (_FF_read(path_addr_temp)==0)	
;    3057 	{
;    3058 		_FF_DIR_ADDR = addr_temp;
;    3059 		return (EOF);
;    3060 	}
;    3061 	
;    3062 	sp = &_FF_buff[calc_temp];
;    3063 	qp = fpath;
;    3064 
;    3065 	for (c=0; c<11; c++)	// Write Folder name
;    3066 	{
;    3067 	 	if (*qp)
;    3068 		 	*sp++ = *qp++;
;    3069 		else 
;    3070 			*sp++ = 0x20;	// '0' pad
;    3071 	}
;    3072 	*sp++ = 0x10;				// Attribute bit auto set to "Directory"
;    3073 	*sp++ = 0;					// Reserved for WinNT
;    3074 	*sp++ = 0;					// Mili-second stamp for create
;    3075 	for (c=0; c<4; c++)			// set create and modify time to '0'
;    3076 		*sp++ = 0;
;    3077 	*sp++ = 0;					// File access date (2 bytes)
;    3078 	*sp++ = 0;
;    3079 	*sp++ = 0;					// 0 for FAT12/16 (2 bytes)
;    3080 	*sp++ = 0;
;    3081 	#ifdef _RTC_ON_
;    3082 		rtc_get_timeNdate(&rtc_hour, &rtc_min, &rtc_sec, &rtc_date, &rtc_month, (int *)&rtc_year);	    			
;    3083 		calc_time = ((int)rtc_sec&0x1F) | (((int)rtc_min&0x3F)<<5) | (((int)rtc_hour&0x1F)<<11);
;    3084 		*sp++ = calc_time&0x00FF;	// File modify Time 
;    3085 		*sp++ = (calc_time&0xFF00) >> 8;
;    3086 		calc_date = ((int)rtc_date&0x1F) | (((int)rtc_month&0x0F)<<5) | (((rtc_year-1980)&0x7F)<<9);
;    3087 		*sp++ = calc_date&0x00FF;	// File modify Date
;    3088 		*sp++ = (calc_date&0xFF00) >> 8;
;    3089 	#else
;    3090 		for (c=0; c<4; c++)			// set file create and modify time to '0'
;    3091 			*sp++ = 0;
;    3092 	#endif
;    3093 	
;    3094 	*sp++ = clus_temp & 0xFF;				// Starting cluster (2 bytes)
;    3095 	*sp++ = (clus_temp >> 8) & 0xFF;
;    3096 	for (c=0; c<4; c++)
;    3097 		*sp++ = 0;			// File length (0 for folder)
;    3098 
;    3099 	
;    3100 	if (_FF_write(path_addr_temp)==0)	// write entry to card
;    3101 	{
;    3102 		_FF_DIR_ADDR = addr_temp;
;    3103 		return (EOF);
;    3104 	}
;    3105 	if (write_clus_table(clus_temp, 0xFFFF, SINGLE)==0)
;    3106 	{
;    3107 		_FF_DIR_ADDR = addr_temp;
;    3108 		return (EOF);
;    3109 	}
;    3110 	if (_FF_read(_FF_DIR_ADDR)==0)	
;    3111 	{
;    3112 		_FF_DIR_ADDR = addr_temp;
;    3113 		return (EOF);
;    3114 	}
;    3115 	if (_FF_DIR_ADDR != _FF_ROOT_ADDR)
;    3116 	{
;    3117 		sp = &_FF_buff[0];
;    3118 		qp = &_FF_buff[0x20];
;    3119 		for (c=0; c<0x20; c++)
;    3120 			*qp++ = *sp++;
;    3121 		_FF_buff[1] = ' ';
;    3122 		for (c=0x3C; c<0x40; c++)
;    3123 			_FF_buff[c] = 0;
;    3124 	}
;    3125 	else
;    3126 	{
;    3127 		for (c=0x01; c<0x0B; c++)
;    3128 			_FF_buff[c] = 0x20;
;    3129 		for (c=0x0C; c<0x20; c++)
;    3130 			_FF_buff[c] = 0;
;    3131 		_FF_buff[0] = '.';
;    3132 		_FF_buff[0x0B] = 0x10;
;    3133 		#ifdef _RTC_ON_
;    3134 			_FF_buff[0x0E] = calc_time&0x00FF;	// File modify Time 
;    3135 			_FF_buff[0x0F] = (calc_time&0xFF00) >> 8;
;    3136 			_FF_buff[0x10] = calc_date&0x00FF;	// File modify Date
;    3137 			_FF_buff[0x11] = (calc_date&0xFF00) >> 8;
;    3138 			_FF_buff[0x16] = calc_time&0x00FF;	// File modify Time 
;    3139 			_FF_buff[0x17] = (calc_time&0xFF00) >> 8;
;    3140 			_FF_buff[0x18] = calc_date&0x00FF;	// File modify Date
;    3141 			_FF_buff[0x19] = (calc_date&0xFF00) >> 8;
;    3142 		#endif
;    3143 		for (c=0x3A; c<0x40; c++)
;    3144 			_FF_buff[c] = 0;
;    3145 	}
;    3146 	for (c=0x22; c<0x2B; c++)
;    3147 		_FF_buff[c] = 0x20;
;    3148 	#ifdef _RTC_ON_
;    3149 		_FF_buff[0x2E] = calc_time&0x00FF;	// File modify Time 
;    3150 		_FF_buff[0x2F] = (calc_time&0xFF00) >> 8;
;    3151 		_FF_buff[0x30] = calc_date&0x00FF;	// File modify Date
;    3152 		_FF_buff[0x31] = (calc_date&0xFF00) >> 8;
;    3153 		_FF_buff[0x36] = calc_time&0x00FF;	// File modify Time 
;    3154 		_FF_buff[0x37] = (calc_time&0xFF00) >> 8;
;    3155 		_FF_buff[0x38] = calc_date&0x00FF;	// File modify Date
;    3156 		_FF_buff[0x39] = (calc_date&0xFF00) >> 8;
;    3157 	#endif
;    3158 	_FF_buff[0x20] = '.';
;    3159 	_FF_buff[0x21] = '.';
;    3160 	_FF_buff[0x2B] = 0x10;
;    3161 
;    3162 	_FF_buff[0x1A] = clus_temp & 0xFF;				// Starting cluster (2 bytes)
;    3163 	_FF_buff[0x1B] = (clus_temp >> 8) & 0xFF;
;    3164 	for (c=0x40; c<BPB_BytsPerSec; c++)
;    3165 		_FF_buff[c] = 0;
;    3166 	path_addr_temp = clust_to_addr(clus_temp);
;    3167 
;    3168 	_FF_DIR_ADDR = addr_temp;	// reset dir addr
;    3169 	if (_FF_write(path_addr_temp)==0)	
;    3170 		return (EOF);
;    3171 	for (c=0; c<0x40; c++)
;    3172 		_FF_buff[c] = 0;
;    3173 	for (c=1; c<BPB_SecPerClus; c++)
;    3174 	{
;    3175 		if (_FF_write(path_addr_temp+((long)c*0x200))==0)	
;    3176 			return (EOF);
;    3177 	}
;    3178 	return (0);		
;    3179 }
;    3180 
;    3181 int rmdir(char *F_PATH)
;    3182 {
;    3183 	unsigned char *sp;
;    3184 	unsigned char fpath[14];
;    3185 	unsigned int c, n, calc_temp, clus_temp;
;    3186 	int s;
;    3187 	unsigned long addr_temp, path_addr_temp;
;    3188 	
;    3189 	addr_temp = 0;	// save local dir addr
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
;    3190     
;    3191     if (_FF_checkdir(F_PATH, &addr_temp, fpath))
;    3192 	{
;    3193 		_FF_DIR_ADDR = addr_temp;
;    3194 		return (EOF);
;    3195 	}
;    3196 	if (fpath[0]==0)
;    3197 	{
;    3198 		_FF_DIR_ADDR = addr_temp;
;    3199 		return (EOF);
;    3200 	}
;    3201 
;    3202     path_addr_temp = _FF_DIR_ADDR;	// save addr for later
;    3203 	
;    3204 	if (_FF_chdir(fpath))	// Change directory to dir to be deleted
;    3205 	{	
;    3206 		_FF_DIR_ADDR = addr_temp;
;    3207 		return (EOF);
;    3208 	}
;    3209 	if ((_FF_DIR_ADDR==_FF_ROOT_ADDR)||(_FF_DIR_ADDR==addr_temp))
;    3210 	{	// if trying to delete root, or current dir error
;    3211 		_FF_DIR_ADDR = addr_temp;
;    3212 		return (EOF);
;    3213 	}
;    3214 	
;    3215 	for (c=0; c<BPB_SecPerClus; c++)
;    3216 	{	// scan through dir to see if it is empty
;    3217 		if (_FF_read(_FF_DIR_ADDR+((long)c*0x200))==0)
;    3218 		{	// read sectors 	
;    3219 			_FF_DIR_ADDR = addr_temp;
;    3220 			return (EOF);
;    3221 		}
;    3222 		for (n=0; n<0x10; n++)
;    3223 		{
;    3224 			if ((c==0)&&(n==0))	// skip first 2 entries 
;    3225 				n=2;
;    3226 			sp = &_FF_buff[n*0x20];
;    3227 			if (*sp==0)
;    3228 			{	// 
;    3229 				c = BPB_SecPerClus;
;    3230 				break;
;    3231 			}
;    3232 			while (valid_file_char(*sp)==0)
;    3233 			{
;    3234 				sp++;
;    3235 				if (sp == &_FF_buff[(n*0x20)+0x0A])
;    3236 				{	// a valid file or folder found
;    3237 					_FF_DIR_ADDR = addr_temp;
;    3238 					return (EOF);
;    3239 				}
;    3240 			}
;    3241 		}
;    3242 	}
;    3243 	// directory empty, delete dir
;    3244 	_FF_DIR_ADDR = path_addr_temp;	// go back to previous directory 
;    3245 
;    3246 	s = scan_directory(&path_addr_temp, fpath);
;    3247 
;    3248 	_FF_DIR_ADDR = addr_temp;	// reset address
;    3249 
;    3250 	if (s == 0)
;    3251 		return (EOF);
;    3252 	
;    3253 	calc_temp = path_addr_temp % BPB_BytsPerSec;
;    3254 	path_addr_temp -= calc_temp;
;    3255 
;    3256 	if (_FF_read(path_addr_temp)==0)	
;    3257 		return (EOF);
;    3258     
;    3259 	clus_temp = ((int) _FF_buff[calc_temp+0x1B] << 8) | _FF_buff[calc_temp+0x1A];
;    3260 	_FF_buff[calc_temp] = 0xE5;
;    3261 	
;    3262 	if (_FF_buff[calc_temp+0x0B]&0x02)
;    3263 		return (EOF);
;    3264 	if (_FF_write(path_addr_temp)==0) 
;    3265 		return (EOF);
;    3266 	if (erase_clus_chain(clus_temp)==0)
;    3267 		return (EOF);
;    3268 	
;    3269     return (0);
;    3270 }
;    3271 #endif
;    3272 
;    3273 int chdirc(char flash *F_PATH)
;    3274 {
;    3275 	unsigned char fpath[_FF_PATH_LENGTH];
;    3276 	int c;
;    3277 	
;    3278 	for (c=0; c<_FF_PATH_LENGTH; c++)
;	*F_PATH -> Y+102
;	fpath -> Y+2
;	c -> R16,R17
;    3279 	{
;    3280 		fpath[c] = F_PATH[c];
;    3281 		if (F_PATH[c]==0)
;    3282 			break;
;    3283 	}
;    3284 	return (chdir(fpath));
;    3285 }
;    3286 
;    3287 int chdir(char *F_PATH)
;    3288 {
;    3289 	unsigned char *qp, *sp, fpath[14], valid_flag;
;    3290 	unsigned int m, n, c, d, calc;
;    3291 	unsigned long addr_temp;
;    3292 
;    3293     
;    3294     addr_temp = 0;	// save local dir addr
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
;    3295     
;    3296 	if ((F_PATH[0]=='\\') && (F_PATH[1]==0))
;    3297 	{
;    3298 		_FF_DIR_ADDR = _FF_ROOT_ADDR;
;    3299 		_FF_FULL_PATH[1] = 0;
;    3300 		return (0);
;    3301 	}
;    3302 	
;    3303     if (_FF_checkdir(F_PATH, &addr_temp, fpath))
;    3304 	{
;    3305 		_FF_DIR_ADDR = addr_temp;
;    3306 		return (EOF);
;    3307 	}
;    3308 	if (fpath[0]==0)
;    3309 		return (EOF);
;    3310 
;    3311 	if ((fpath[0]=='.') && (fpath[1]=='.') && (fpath[2]==0))
;    3312 	{	// trying to get back to prev dir
;    3313 		if (_FF_DIR_ADDR == _FF_ROOT_ADDR)		// already as far back as can go
;    3314 			return (EOF);
;    3315 		if (_FF_read(_FF_DIR_ADDR)==0)
;    3316 			return (EOF);
;    3317 		m = ((unsigned int) _FF_buff[0x3B] << 8) | (unsigned int) _FF_buff[0x3A];
;    3318 		if (m)
;    3319 			_FF_DIR_ADDR = clust_to_addr(m);
;    3320 		else
;    3321 			_FF_DIR_ADDR = _FF_ROOT_ADDR;
;    3322 		
;    3323 					sp = F_PATH;
;    3324 					qp = _FF_FULL_PATH + strlen(_FF_FULL_PATH);
;    3325 					while (*sp)
;    3326 					{
;    3327 						if ((*sp=='.')&&(*(sp+1)=='.'))
;    3328 						{
;    3329 							#ifdef _ICCAVR_
;    3330 								qp = strrchr(_FF_FULL_PATH, '\\');
;    3331 								if (qp==0)
;    3332 								   return (EOF);
;    3333 								*qp = 0;
;    3334 								qp = strrchr(_FF_FULL_PATH, '\\');
;    3335 								if (qp==0)
;    3336 								   return (EOF);
;    3337 								qp++;
;    3338 							#endif
;    3339 							#ifdef _CVAVR_
;    3340 								_FF_FULL_PATH[strrpos(_FF_FULL_PATH, '\\')] = 0;
;    3341 							    c = strrpos(_FF_FULL_PATH, '\\');
;    3342 								if (c==EOF)
;    3343 									return (EOF);
;    3344 								qp = _FF_FULL_PATH + c;
;    3345 							#endif
;    3346 							*qp = 0;
;    3347 							sp += 2;
;    3348 						}
;    3349 						else 
;    3350 							*qp++ = toupper(*sp++);
;    3351 					}
;    3352 					*qp++ = '\\';
;    3353 					*qp = 0;
;    3354 
;    3355 		return (0);
;    3356 	}
;    3357 		
;    3358 	qp = fpath;
;    3359 	sp = fpath;
;    3360 	while(sp < (fpath+11))
;    3361 	{
;    3362 		if (*qp)
;    3363 			*sp++ = toupper(*qp++);
;    3364 		else	// (*qp==0)
;    3365 			*sp++ = 0x20;
;    3366 	}     
;    3367 	*sp = 0;
;    3368 
;    3369 	qp = fpath;
;    3370 	m = 0;
;    3371 	d = 0;
;    3372 	valid_flag = 0;
;    3373 	while (d<BPB_RootEntCnt)
;    3374 	{
;    3375     	_FF_read(_FF_DIR_ADDR+(m*0x200));
;    3376 		for (n=0; n<16; n++)
;    3377 		{
;    3378 			if (_FF_buff[n*0x20] == 0)	// no more entries in dir
;    3379 			{
;    3380 				_FF_DIR_ADDR = addr_temp;
;    3381 				return (EOF);
;    3382 			}
;    3383 			calc = (n*0x20);
;    3384 			for (c=0; c<11; c++)
;    3385 			{	// check for name match
;    3386 				if (fpath[c] == _FF_buff[calc+c])
;    3387 					valid_flag = 1;
;    3388 				else if (fpath[c] == 0)
;    3389 				{
;    3390 					if (_FF_buff[calc+c]==0x20)
;    3391 						break;
;    3392 				}
;    3393 				else
;    3394 				{
;    3395 					valid_flag = 0;	
;    3396 					break;
;    3397 				}
;    3398 		    }   
;    3399 		    if (valid_flag)
;    3400 	  		{
;    3401 	  			if (_FF_buff[calc+0xB] != 0x10)	// not a directory
;    3402 	  				valid_flag = 0;
;    3403 	  			else
;    3404 	  			{
;    3405 	  				c = ((int) _FF_buff[calc+0x1B] << 8) | ((int) _FF_buff[calc+0x1A]);
;    3406 					_FF_DIR_ADDR = clust_to_addr(c);
;    3407 					sp = F_PATH;
;    3408 					if (*sp=='\\')
;    3409 					{	// Restart String @root
;    3410 						qp = _FF_FULL_PATH + 1;
;    3411 						*qp = 0;
;    3412 						sp++;
;    3413 					}
;    3414 					else
;    3415 						qp = _FF_FULL_PATH + strlen(_FF_FULL_PATH);
;    3416 					while (*sp)
;    3417 					{
;    3418 						if ((*sp=='.')&&(*(sp+1)=='.'))
;    3419 						{
;    3420 							#ifdef _ICCAVR_
;    3421 								qp = strrchr(_FF_FULL_PATH, '\\');
;    3422 								if (qp==0)
;    3423 								   return (EOF);
;    3424 								*qp = 0;
;    3425 								qp = strrchr(_FF_FULL_PATH, '\\');
;    3426 								if (qp==0)
;    3427 								   return (EOF);
;    3428 								qp++;
;    3429 							#endif
;    3430 							#ifdef _CVAVR_
;    3431 								_FF_FULL_PATH[strrpos(_FF_FULL_PATH, '\\')] = 0;
;    3432 								c = strrpos(_FF_FULL_PATH, '\\');
;    3433 								if (c==EOF)
;    3434 								   return (EOF);
;    3435 								qp = _FF_FULL_PATH + c;
;    3436 							#endif
;    3437 							*qp = 0;
;    3438 							sp += 2;
;    3439 						}
;    3440 						else 
;    3441 							*qp++ = toupper(*sp++);
;    3442 					}
;    3443 					*qp++ = '\\';
;    3444 					*qp = 0;
;    3445 					return (0);
;    3446 				}
;    3447 			}
;    3448 		  	d++;		  		
;    3449 		}
;    3450 		m++;
;    3451 	}
;    3452 	_FF_DIR_ADDR = addr_temp;
;    3453 	return (EOF);
;    3454 }
;    3455 
;    3456 // Function to change directories one at a time, not effecting the working dir string
;    3457 int _FF_chdir(char *F_PATH)
;    3458 {
__FF_chdir:
;    3459 	unsigned char *qp, *sp, valid_flag, fpath[14];
;    3460 	unsigned int m, n, c, d, calc;
;    3461     
;    3462 	if ((F_PATH[0]=='.') && (F_PATH[1]=='.') && (F_PATH[2]==0))
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
	BRNE _0x272
	LDD  R26,Y+29
	LDD  R27,Y+29+1
	ADIW R26,1
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BRNE _0x272
	LDD  R26,Y+29
	LDD  R27,Y+29+1
	ADIW R26,2
	LD   R26,X
	CPI  R26,LOW(0x0)
	BREQ _0x273
_0x272:
	RJMP _0x271
_0x273:
;    3463 	{	// trying to get back to prev dir
;    3464 		if (_FF_DIR_ADDR == _FF_ROOT_ADDR)		// already as far back as can go
	LDS  R30,__FF_ROOT_ADDR
	LDS  R31,__FF_ROOT_ADDR+1
	LDS  R22,__FF_ROOT_ADDR+2
	LDS  R23,__FF_ROOT_ADDR+3
	LDS  R26,__FF_DIR_ADDR
	LDS  R27,__FF_DIR_ADDR+1
	LDS  R24,__FF_DIR_ADDR+2
	LDS  R25,__FF_DIR_ADDR+3
	CALL __CPD12
	BRNE _0x274
;    3465 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4CD
;    3466 		if (_FF_read(_FF_DIR_ADDR)==0)
_0x274:
	LDS  R30,__FF_DIR_ADDR
	LDS  R31,__FF_DIR_ADDR+1
	LDS  R22,__FF_DIR_ADDR+2
	LDS  R23,__FF_DIR_ADDR+3
	CALL SUBOPT_0x34
	BRNE _0x275
;    3467 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4CD
;    3468 		m = ((unsigned int) _FF_buff[0x3B] << 8) | (unsigned int) _FF_buff[0x3A];
_0x275:
	__GETBRMN 27,__FF_buff,59
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,58
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STD  Y+13,R30
	STD  Y+13+1,R31
;    3469 		if (m)
	SBIW R30,0
	BREQ _0x276
;    3470 			_FF_DIR_ADDR = clust_to_addr(m);
	ST   -Y,R31
	ST   -Y,R30
	CALL _clust_to_addr
	RJMP _0x4ED
;    3471 		else
_0x276:
;    3472 			_FF_DIR_ADDR = _FF_ROOT_ADDR;
	LDS  R30,__FF_ROOT_ADDR
	LDS  R31,__FF_ROOT_ADDR+1
	LDS  R22,__FF_ROOT_ADDR+2
	LDS  R23,__FF_ROOT_ADDR+3
_0x4ED:
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3473 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x4CD
;    3474 	}
;    3475 		
;    3476 	qp = F_PATH;
_0x271:
	__GETWRS 16,17,29
;    3477 	sp = fpath;
	MOVW R30,R28
	ADIW R30,15
	MOVW R18,R30
;    3478 	while(sp < (fpath+11))
_0x278:
	MOVW R30,R28
	ADIW R30,26
	CP   R18,R30
	CPC  R19,R31
	BRSH _0x27A
;    3479 	{
;    3480 		if (valid_file_char(*qp)==0)
	MOVW R26,R16
	CALL SUBOPT_0x41
	BRNE _0x27B
;    3481 			*sp++ = toupper(*qp++);
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	MOVW R26,R16
	__ADDWRN 16,17,1
	CALL SUBOPT_0x60
	POP  R26
	POP  R27
	ST   X,R30
;    3482 		else if (*qp==0)
	RJMP _0x27C
_0x27B:
	MOVW R26,R16
	LD   R30,X
	CPI  R30,0
	BRNE _0x27D
;    3483 			*sp++ = 0x20;
	MOVW R26,R18
	__ADDWRN 18,19,1
	LDI  R30,LOW(32)
	ST   X,R30
;    3484 		else
	RJMP _0x27E
_0x27D:
;    3485 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4CD
;    3486 	}     
_0x27E:
_0x27C:
	RJMP _0x278
_0x27A:
;    3487 	*sp = 0;
	MOVW R26,R18
	LDI  R30,LOW(0)
	ST   X,R30
;    3488 	m = 0;
	LDI  R30,0
	STD  Y+13,R30
	STD  Y+13+1,R30
;    3489 	d = 0;
	LDI  R30,0
	STD  Y+7,R30
	STD  Y+7+1,R30
;    3490 	valid_flag = 0;
	LDI  R20,LOW(0)
;    3491 	while (d<BPB_RootEntCnt)
_0x27F:
	LDS  R30,_BPB_RootEntCnt
	LDS  R31,_BPB_RootEntCnt+1
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CP   R26,R30
	CPC  R27,R31
	BRLO PC+3
	JMP _0x281
;    3492 	{
;    3493     	_FF_read(_FF_DIR_ADDR+(m*0x200));
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	CALL SUBOPT_0x62
	CALL __ADDD12
	CALL __PUTPARD1
	CALL __FF_read
;    3494 		for (n=0; n<16; n++)
	LDI  R30,0
	STD  Y+11,R30
	STD  Y+11+1,R30
_0x283:
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	SBIW R26,16
	BRLO PC+3
	JMP _0x284
;    3495 		{
;    3496 			calc = (n*0x20);
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	LSL  R30
	ROL  R31
	CALL __LSLW4
	STD  Y+5,R30
	STD  Y+5+1,R31
;    3497 			if (_FF_buff[calc] == 0)	// no more entries in dir
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	LD   R30,Z
	CPI  R30,0
	BRNE _0x285
;    3498 				return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4CD
;    3499 			for (c=0; c<11; c++)
_0x285:
	LDI  R30,0
	STD  Y+9,R30
	STD  Y+9+1,R30
_0x287:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	SBIW R26,11
	BRSH _0x288
;    3500 			{	// check for name match
;    3501 				if (fpath[c] == _FF_buff[calc+c])
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
	BRNE _0x289
;    3502 					valid_flag = 1;
	LDI  R20,LOW(1)
;    3503 				else
	RJMP _0x28A
_0x289:
;    3504 				{
;    3505 					valid_flag = 0;	
	LDI  R20,LOW(0)
;    3506 					c = 11;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	STD  Y+9,R30
	STD  Y+9+1,R31
;    3507 				}
_0x28A:
;    3508 		    }   
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ADIW R30,1
	STD  Y+9,R30
	STD  Y+9+1,R31
	RJMP _0x287
_0x288:
;    3509 		    if (valid_flag)
	CPI  R20,0
	BREQ _0x28B
;    3510 	  		{
;    3511 	  			if (_FF_buff[calc+0xB] != 0x10)	// not a directory
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	__ADDW1MN __FF_buff,11
	LD   R30,Z
	CPI  R30,LOW(0x10)
	BREQ _0x28C
;    3512 	  				valid_flag = 0;
	LDI  R20,LOW(0)
;    3513 	  			else
	RJMP _0x28D
_0x28C:
;    3514 	  			{
;    3515 	  				c = ((int) _FF_buff[calc+0x1B] << 8) | ((int) _FF_buff[calc+0x1A]);
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	__ADDW1MN __FF_buff,27
	CALL SUBOPT_0x55
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	__ADDW1MN __FF_buff,26
	CALL SUBOPT_0x63
	STD  Y+9,R30
	STD  Y+9+1,R31
;    3516 					_FF_DIR_ADDR = clust_to_addr(c);
	ST   -Y,R31
	ST   -Y,R30
	CALL _clust_to_addr
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3517 					return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x4CD
;    3518 				}
_0x28D:
;    3519 			}
;    3520 		  	d++;		  		
_0x28B:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
;    3521 		}
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ADIW R30,1
	STD  Y+11,R30
	STD  Y+11+1,R31
	RJMP _0x283
_0x284:
;    3522 		m++;
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ADIW R30,1
	STD  Y+13,R30
	STD  Y+13+1,R31
;    3523 	}
	RJMP _0x27F
_0x281:
;    3524 	return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x4CD:
	CALL __LOADLOCR5
	ADIW R28,31
	RET
;    3525 }
;    3526 
;    3527 #ifndef _SECOND_FAT_ON_
;    3528 // Function that clears the secondary FAT table
;    3529 int clear_second_FAT(void)
;    3530 {
;    3531 	unsigned int c, d;
;    3532 	unsigned long n;
;    3533 	
;    3534 	for (n=1; n<BPB_FATSz16; n++)
;    3535 	{
;    3536 		if (_FF_read(_FF_FAT2_ADDR+(n*0x200))==0)
;    3537 			return (EOF);
;    3538 		for (c=0; c<BPB_BytsPerSec; c++)
;    3539 		{
;    3540 			if (_FF_buff[c] != 0)
;    3541 			{
;    3542 				for (d=0; d<BPB_BytsPerSec; d++)
;    3543 					_FF_buff[d] = 0;
;    3544 				if (_FF_write(_FF_FAT2_ADDR+(n*0x200))==0)
;    3545 					return (EOF);
;    3546 				break;
;    3547 			}
;    3548 		}
;    3549 	}
;    3550 	for (d=2; d<BPB_BytsPerSec; d++)
;    3551 		_FF_buff[d] = 0;
;    3552 	_FF_buff[0] = 0xF8;
;    3553 	_FF_buff[1] = 0xFF;
;    3554 	_FF_buff[2] = 0xFF;
;    3555 	if (BPB_FATType == 0x36)
;    3556 		_FF_buff[3] = 0xFF;
;    3557 	if (_FF_write(_FF_FAT2_ADDR)==0)
;    3558 		return (EOF);
;    3559 	
;    3560 	return (1);
;    3561 }
;    3562 #endif
;    3563  
;    3564 // Open a file, name stored in string fileopen
;    3565 FILE *fopenc(unsigned char flash *NAMEC, unsigned char MODEC)
;    3566 {
_fopenc:
;    3567 	unsigned char c, temp_data[12];
;    3568 	FILE *tp;
;    3569 	
;    3570 	for (c=0; c<12; c++)
	SBIW R28,12
	CALL __SAVELOCR3
;	*NAMEC -> Y+16
;	MODEC -> Y+15
;	c -> R16
;	temp_data -> Y+3
;	*tp -> R17,R18
	LDI  R16,LOW(0)
_0x28F:
	CPI  R16,12
	BRSH _0x290
;    3571 		temp_data[c] = NAMEC[c];
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,3
	CALL SUBOPT_0x64
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LDI  R31,0
	CALL SUBOPT_0x65
;    3572 	
;    3573 	tp = fopen(temp_data, MODEC);
	SUBI R16,-1
	RJMP _0x28F
_0x290:
	MOVW R30,R28
	ADIW R30,3
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	ST   -Y,R30
	RCALL _fopen
	__PUTW1R 17,18
;    3574 	return(tp);
	__GETW1R 17,18
	CALL __LOADLOCR3
	ADIW R28,18
	RET
;    3575 }
;    3576 
;    3577 FILE *fopen(unsigned char *NAME, unsigned char MODE)
;    3578 {
_fopen:
;    3579 	unsigned char fpath[14];
;    3580 	unsigned int c, s, calc_temp;
;    3581 	unsigned char *sp, *qp;
;    3582 	unsigned long addr_temp, path_addr_temp;
;    3583 	FILE *rp;
;    3584 	
;    3585 	#ifdef _READ_ONLY_
;    3586 		if (MODE!=READ)
;    3587 			return (0);
;    3588 	#endif
;    3589 	
;    3590     addr_temp = 0;	// save local dir addr
	CALL SUBOPT_0x66
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
;    3591     
;    3592     if (_FF_checkdir(NAME, &addr_temp, fpath))
	BREQ _0x291
;    3593 	{
;    3594 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x67
;    3595 		return (0);
	RJMP _0x4CC
;    3596 	}
;    3597 	if (fpath[0]==0)
_0x291:
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x292
;    3598 	{
;    3599 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x67
;    3600 		return (0);
	RJMP _0x4CC
;    3601 	}
;    3602     
;    3603 	path_addr_temp = _FF_DIR_ADDR;
_0x292:
	CALL SUBOPT_0x68
;    3604 	s = scan_directory(&path_addr_temp, fpath);
;    3605 	if ((path_addr_temp==0) || (s==0))
	__GETD2S 8
	CALL __CPD02
	BREQ _0x294
	CLR  R0
	CP   R0,R18
	CPC  R0,R19
	BRNE _0x293
_0x294:
;    3606 	{
;    3607 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x67
;    3608 		return (0);
	RJMP _0x4CC
;    3609 	}
;    3610 
;    3611 	rp = 0;
_0x293:
	LDI  R30,0
	STD  Y+6,R30
	STD  Y+6+1,R30
;    3612 	rp = malloc(sizeof(FILE));
	LDI  R30,LOW(553)
	LDI  R31,HIGH(553)
	ST   -Y,R31
	ST   -Y,R30
	CALL _malloc
	CALL SUBOPT_0x69
;    3613 	if (rp == 0)
	BRNE _0x296
;    3614 	{	// Could not allocate requested memory
;    3615 		_FF_error = ALLOC_ERR;
	LDI  R30,LOW(9)
	STS  __FF_error,R30
;    3616 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x67
;    3617 		return (0);
	RJMP _0x4CC
;    3618 	}
;    3619 	rp->length = 0x46344456;
_0x296:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	__GETD1N 0x46344456
	CALL __PUTDP1
;    3620 	rp->clus_start = 0xe4;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,12
	LDI  R30,LOW(228)
	LDI  R31,HIGH(228)
	ST   X+,R30
	ST   X,R31
;    3621 	rp->position = 0x45664446;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-544)
	SBCI R27,HIGH(-544)
	__GETD1N 0x45664446
	CALL __PUTDP1
;    3622 
;    3623 	calc_temp = path_addr_temp % BPB_BytsPerSec;
	CALL SUBOPT_0x6A
;    3624 	path_addr_temp -= calc_temp;
;    3625 	if (_FF_read(path_addr_temp)==0)	
	BRNE _0x297
;    3626 	{
;    3627 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x67
;    3628 		return (0);
	RJMP _0x4CC
;    3629 	}
;    3630 	
;    3631 	// Get the filename into a form we can use to compare
;    3632 	qp = file_name_conversion(fpath);
_0x297:
	CALL SUBOPT_0x6B
;    3633 	if (qp==0)
	BRNE _0x298
;    3634 	{	// If File name entered is NOT valid, return 0
;    3635 		free(rp);
	CALL SUBOPT_0x6C
;    3636 		_FF_DIR_ADDR = addr_temp;
;    3637 		return (0);
	RJMP _0x4CC
;    3638 	}
;    3639 	
;    3640 	sp = &_FF_buff[calc_temp];
_0x298:
	CALL SUBOPT_0x6D
;    3641 
;    3642 	if (s)
	BRNE PC+3
	JMP _0x299
;    3643 	{	// File exists, open 
;    3644 		if (((MODE==WRITE) || (MODE==APPEND)) && (_FF_buff[calc_temp+0x0B]&0x01))
	LDD  R26,Y+34
	CPI  R26,LOW(0x2)
	BREQ _0x29B
	CPI  R26,LOW(0x3)
	BRNE _0x29D
_0x29B:
	MOVW R30,R20
	__ADDW1MN __FF_buff,11
	LD   R30,Z
	ANDI R30,LOW(0x1)
	BRNE _0x29E
_0x29D:
	RJMP _0x29A
_0x29E:
;    3645 		{	// if writing to file verify it is not "READ ONLY"
;    3646 			_FF_error = MODE_ERR;
	CALL SUBOPT_0x6E
;    3647 			free(rp);
;    3648 			_FF_DIR_ADDR = addr_temp;
;    3649 			return (0);
	RJMP _0x4CC
;    3650 		}
;    3651 		for (c=0; c<12; c++)	// Save Filename to Buffer
_0x29A:
	__GETWRN 16,17,0
_0x2A0:
	__CPWRN 16,17,12
	BRSH _0x2A1
;    3652 			rp->name[c] = FILENAME[c];
	MOVW R30,R16
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDI  R26,LOW(_FILENAME)
	LDI  R27,HIGH(_FILENAME)
	CALL SUBOPT_0x6F
;    3653 		// Save Starting Cluster
;    3654 		rp->clus_start = ((int) _FF_buff[calc_temp+0x1B] << 8) | (int) _FF_buff[calc_temp+0x1A];
	__ADDWRN 16,17,1
	RJMP _0x2A0
_0x2A1:
	MOVW R30,R20
	__ADDW1MN __FF_buff,27
	CALL SUBOPT_0x55
	MOVW R30,R20
	__ADDW1MN __FF_buff,26
	CALL SUBOPT_0x63
	__PUTW1SNS 6,12
;    3655 		// Set Current Cluster
;    3656 		rp->clus_current = rp->clus_start;
	CALL SUBOPT_0x70
	__PUTW1SNS 6,14
;    3657 		// Set Previous Cluster to 0 (indicating @start)
;    3658 		rp->clus_prev = 0;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x71
;    3659 		// Save file length
;    3660 		rp->length = 0;
	CALL SUBOPT_0x72
;    3661 		sp = _FF_buff + calc_temp + 0x1F;
	CALL SUBOPT_0x73
;    3662 		for (c=0; c<4; c++)
	__GETWRN 16,17,0
_0x2A3:
	__CPWRN 16,17,4
	BRSH _0x2A4
;    3663 		{
;    3664 			rp->length <<= 8;
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
;    3665 			rp->length |= *sp--;
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
	CALL SUBOPT_0x74
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
;    3666 		}
	__ADDWRN 16,17,1
	RJMP _0x2A3
_0x2A4:
;    3667 		// Set Current Position to 0
;    3668 		rp->position = 0;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-544)
	SBCI R27,HIGH(-544)
	__GETD1N 0x0
	CALL __PUTDP1
;    3669 		#ifndef _READ_ONLY_
;    3670 			if (MODE==WRITE)
	LDD  R26,Y+34
	CPI  R26,LOW(0x2)
	BRNE _0x2A5
;    3671 			{	// Change file to blank
;    3672 				sp = _FF_buff + calc_temp + 0x1F;
	CALL SUBOPT_0x73
;    3673 				for (c=0; c<6; c++)
	__GETWRN 16,17,0
_0x2A7:
	__CPWRN 16,17,6
	BRSH _0x2A8
;    3674 					*sp-- = 0;
	CALL SUBOPT_0x74
	LDI  R30,LOW(0)
	ST   X,R30
;    3675 				if (rp->length)
	__ADDWRN 16,17,1
	RJMP _0x2A7
_0x2A8:
	CALL SUBOPT_0x75
	BREQ _0x2A9
;    3676 				{
;    3677 					if (_FF_write(_FF_DIR_ADDR + (0x200 * s))==0)
	MOVW R30,R18
	CALL SUBOPT_0x62
	CALL SUBOPT_0x58
	BRNE _0x2AA
;    3678 					{
;    3679 						free(rp);
	CALL SUBOPT_0x6C
;    3680 						_FF_DIR_ADDR = addr_temp;
;    3681 						return (0);
	RJMP _0x4CC
;    3682 					}
;    3683 					rp->length = 0;
_0x2AA:
	CALL SUBOPT_0x72
;    3684 					erase_clus_chain(rp->clus_start);
	CALL SUBOPT_0x76
	CALL _erase_clus_chain
;    3685 					rp->clus_start = 0;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,12
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
;    3686 				}
;    3687 			}
_0x2A9:
;    3688 		#endif
;    3689 		// Set and save next cluster #
;    3690 		rp->clus_next = next_cluster(rp->clus_current, SINGLE);
_0x2A5:
	CALL SUBOPT_0x77
	CALL SUBOPT_0x78
	__PUTW1SNS 6,16
;    3691 		if ((rp->length==0) && (rp->clus_start==0))
	CALL SUBOPT_0x75
	BRNE _0x2AC
	CALL SUBOPT_0x70
	SBIW R30,0
	BREQ _0x2AD
_0x2AC:
	RJMP _0x2AB
_0x2AD:
;    3692 		{	// Check for Blank File 
;    3693 			if (MODE==READ)
	LDD  R26,Y+34
	CPI  R26,LOW(0x1)
	BRNE _0x2AE
;    3694 			{	// IF trying to open a blank file to read, ERROR
;    3695 				_FF_error = MODE_ERR;
	CALL SUBOPT_0x6E
;    3696 				free(rp);
;    3697 				_FF_DIR_ADDR = addr_temp;
;    3698 				return (0);
	RJMP _0x4CC
;    3699 			}
;    3700 			//Setup blank FILE characteristics
;    3701 			#ifndef _READ_ONLY_
;    3702 				MODE = WRITE; 
_0x2AE:
	LDI  R30,LOW(2)
	STD  Y+34,R30
;    3703 			#endif
;    3704 		}
;    3705 		// Save the file offset to read entry
;    3706 		rp->entry_sec_addr = path_addr_temp;
_0x2AB:
	__GETD1S 8
	__PUTD1SNS 6,22
;    3707 		rp->entry_offset =  calc_temp;
	MOVW R30,R20
	__PUTW1SNS 6,26
;    3708 		// Set sector offset to 1
;    3709 		rp->sec_offset = 1;
	CALL SUBOPT_0x79
;    3710 		if (MODE==APPEND)
	LDD  R26,Y+34
	CPI  R26,LOW(0x3)
	BRNE _0x2AF
;    3711 		{
;    3712 			if (fseek(rp, 0,SEEK_END)==EOF)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _fseek
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2B0
;    3713 			{
;    3714 				free(rp);
	CALL SUBOPT_0x6C
;    3715 				_FF_DIR_ADDR = addr_temp;
;    3716 				return (0);
	RJMP _0x4CC
;    3717 			}
;    3718 		}
_0x2B0:
;    3719 		else
	RJMP _0x2B1
_0x2AF:
;    3720 		{	// Set pointer to the begining of the file
;    3721 			_FF_read(clust_to_addr(rp->clus_current));
	CALL SUBOPT_0x77
	CALL _clust_to_addr
	CALL __PUTPARD1
	CALL __FF_read
;    3722 			for (c=0; c<BPB_BytsPerSec; c++)
	__GETWRN 16,17,0
_0x2B3:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x2B4
;    3723 				rp->buff[c] = _FF_buff[c];
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x7B
;    3724 			rp->pntr = &rp->buff[0];
	__ADDWRN 16,17,1
	RJMP _0x2B3
_0x2B4:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,28
	__PUTW1SN 6,551
;    3725 		}
_0x2B1:
;    3726 		#ifndef _READ_ONLY_
;    3727 			#ifndef _SECOND_FAT_ON_
;    3728 				if ((MODE==WRITE) || (MODE==APPEND))
;    3729 					clear_second_FAT();
;    3730 			#endif
;    3731     	#endif
;    3732 		rp->mode = MODE;
	LDD  R30,Y+34
	__PUTB1SN 6,548
;    3733 		_FF_error = NO_ERR;
	LDI  R30,LOW(0)
	STS  __FF_error,R30
;    3734 		_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3735 		return(rp);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RJMP _0x4CC
;    3736 	}
;    3737 	else
_0x299:
;    3738 	{                          		
;    3739 		_FF_error = FILE_ERR;
	LDI  R30,LOW(2)
	STS  __FF_error,R30
;    3740 		free(rp);
	CALL SUBOPT_0x6C
;    3741 		_FF_DIR_ADDR = addr_temp;
;    3742 		return(0);
	RJMP _0x4CC
;    3743 	}
;    3744 }
;    3745 
;    3746 #ifndef _READ_ONLY_
;    3747 // Create a file
;    3748 FILE *fcreatec(unsigned char flash *NAMEC, unsigned char MODE)
;    3749 {
_fcreatec:
;    3750 	unsigned char sd_temp[12];
;    3751 	int c;
;    3752 
;    3753 	for (c=0; c<12; c++)
	SBIW R28,12
	ST   -Y,R17
	ST   -Y,R16
;	*NAMEC -> Y+15
;	MODE -> Y+14
;	sd_temp -> Y+2
;	c -> R16,R17
	__GETWRN 16,17,0
_0x2B7:
	__CPWRN 16,17,12
	BRGE _0x2B8
;    3754 		sd_temp[c] = NAMEC[c];
	MOVW R30,R16
	MOVW R26,R28
	ADIW R26,2
	CALL SUBOPT_0x7C
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	CALL SUBOPT_0x65
;    3755 	
;    3756 	return (fcreate(sd_temp, MODE));
	__ADDWRN 16,17,1
	RJMP _0x2B7
_0x2B8:
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
;    3757 }
;    3758 
;    3759 FILE *fcreate(unsigned char *NAME, unsigned char MODE)
;    3760 {
_fcreate:
;    3761 	unsigned char fpath[14];
;    3762 	unsigned int c, s, calc_temp;
;    3763 	unsigned char *sp, *qp;
;    3764 	unsigned long addr_temp, path_addr_temp;
;    3765 	FILE *temp_file_pntr;
;    3766 
;    3767     addr_temp = 0;	// save local dir addr
	CALL SUBOPT_0x66
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
;    3768     
;    3769     if (_FF_checkdir(NAME, &addr_temp, fpath))
	BREQ _0x2B9
;    3770 	{
;    3771 		_FF_error = PATH_ERR;
	LDI  R30,LOW(14)
	STS  __FF_error,R30
;    3772 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x67
;    3773 		return (0);
	RJMP _0x4CC
;    3774 	}
;    3775 	if (fpath[0]==0)
_0x2B9:
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2BA
;    3776 	{
;    3777 		_FF_error = NAME_ERR; 
	CALL SUBOPT_0x7D
;    3778 		_FF_DIR_ADDR = addr_temp;
;    3779 		return (0);
	RJMP _0x4CC
;    3780 	}
;    3781     
;    3782 	path_addr_temp = _FF_DIR_ADDR;
_0x2BA:
	CALL SUBOPT_0x68
;    3783 	s = scan_directory(&path_addr_temp, fpath);
;    3784 	if (path_addr_temp==0)
	__GETD1S 8
	CALL __CPD10
	BRNE _0x2BB
;    3785 	{
;    3786 		_FF_error = NO_ENTRY_AVAL;
	LDI  R30,LOW(15)
	STS  __FF_error,R30
;    3787 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x67
;    3788 		return (0);
	RJMP _0x4CC
;    3789 	}
;    3790 
;    3791 	calc_temp = path_addr_temp % BPB_BytsPerSec;
_0x2BB:
	CALL SUBOPT_0x6A
;    3792 	path_addr_temp -= calc_temp;
;    3793 	if (_FF_read(path_addr_temp)==0)	
	BRNE _0x2BC
;    3794 	{
;    3795 		_FF_error = READ_ERR;
	LDI  R30,LOW(4)
	STS  __FF_error,R30
;    3796 		_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x67
;    3797 		return (0);
	RJMP _0x4CC
;    3798 	}
;    3799 
;    3800 	// Get the filename into a form we can use to compare
;    3801 	qp = file_name_conversion(fpath);
_0x2BC:
	CALL SUBOPT_0x6B
;    3802 	if (qp==0)
	BRNE _0x2BD
;    3803 	{
;    3804 		_FF_error = NAME_ERR; 
	CALL SUBOPT_0x7D
;    3805 		_FF_DIR_ADDR = addr_temp;
;    3806 		return (0);
	RJMP _0x4CC
;    3807 	}
;    3808 	sp = &_FF_buff[calc_temp];
_0x2BD:
	CALL SUBOPT_0x6D
;    3809 	
;    3810 	if (s)
	BREQ _0x2BE
;    3811 	{
;    3812 		if ((_FF_buff[calc_temp+0x0B]&0x1)==1)	// is file read only
	MOVW R30,R20
	__ADDW1MN __FF_buff,11
	LD   R30,Z
	ANDI R30,LOW(0x1)
	CPI  R30,LOW(0x1)
	BRNE _0x2BF
;    3813 		{
;    3814 			_FF_error = READONLY_ERR;
	LDI  R30,LOW(6)
	STS  __FF_error,R30
;    3815 			_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x67
;    3816 			return (0);
	RJMP _0x4CC
;    3817 		}
;    3818 	}
_0x2BF:
;    3819 	else
	RJMP _0x2C0
_0x2BE:
;    3820 	{
;    3821 		for (c=0; c<11; c++)	// Write Filename
	__GETWRN 16,17,0
_0x2C2:
	__CPWRN 16,17,11
	BRSH _0x2C3
;    3822 			*sp++ = *qp++;
	CALL SUBOPT_0x7E
	SBIW R30,1
	MOVW R0,R30
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R30,X+
	STD  Y+16,R26
	STD  Y+16+1,R27
	MOVW R26,R0
	ST   X,R30
;    3823 		*sp = 0x20;				// Attribute bit auto set to "ARCHIVE"
	__ADDWRN 16,17,1
	RJMP _0x2C2
_0x2C3:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDI  R30,LOW(32)
	ST   X,R30
;    3824 		sp++;		
	CALL SUBOPT_0x7E
;    3825 		*sp++ = 0;				// Reserved for WinNT
	CALL SUBOPT_0x7F
;    3826 		*sp++ = 0;				// Mili-second stamp for create
	CALL SUBOPT_0x7F
;    3827 	
;    3828 		#ifdef _RTC_ON_
;    3829 			rtc_get_timeNdate(&rtc_hour, &rtc_min, &rtc_sec, &rtc_date, &rtc_month, (int *)&rtc_year);	    			
;    3830     	    calc_temp = ((int)rtc_sec&0x1F) | (((int)rtc_min&0x3F)<<5) | (((int)rtc_hour&0x1F)<<11);
;    3831 			*sp++ = calc_temp&0x00FF;	// File create Time 
;    3832 			*sp++ = (calc_temp&0xFF00) >> 8;
;    3833 			calc_temp = ((int)rtc_date&0x1F) | (((int)rtc_month&0x0F)<<5) | (((rtc_year-1980)&0x7F)<<9);
;    3834 			*sp++ = calc_temp&0x00FF;	// File create Date
;    3835 			*sp++ = (calc_temp&0xFF00) >> 8;
;    3836 		#else
;    3837 			for (c=0; c<4; c++)
	__GETWRN 16,17,0
_0x2C5:
	__CPWRN 16,17,4
	BRSH _0x2C6
;    3838 				*sp++ = 0;
	CALL SUBOPT_0x7F
;    3839 		#endif
;    3840 
;    3841 		*sp++ = 0;				// File access date (2 bytes)
	__ADDWRN 16,17,1
	RJMP _0x2C5
_0x2C6:
	CALL SUBOPT_0x7F
;    3842 		*sp++ = 0;
	CALL SUBOPT_0x7F
;    3843 		*sp++ = 0;				// 0 for FAT12/16 (2 bytes)
	CALL SUBOPT_0x7F
;    3844 		*sp++ = 0;
	CALL SUBOPT_0x7F
;    3845 		for (c=0; c<4; c++)		// Modify time/date
	__GETWRN 16,17,0
_0x2C8:
	__CPWRN 16,17,4
	BRSH _0x2C9
;    3846 			*sp++ = 0;
	CALL SUBOPT_0x7F
;    3847 		*sp++ = 0;				// Starting cluster (2 bytes)
	__ADDWRN 16,17,1
	RJMP _0x2C8
_0x2C9:
	CALL SUBOPT_0x7F
;    3848 		*sp++ = 0;
	CALL SUBOPT_0x7F
;    3849 		for (c=0; c<4; c++)
	__GETWRN 16,17,0
_0x2CB:
	__CPWRN 16,17,4
	BRSH _0x2CC
;    3850 			*sp++ = 0;			// File length (0 for new)
	CALL SUBOPT_0x7F
;    3851 	
;    3852 		if (_FF_write(path_addr_temp)==0)
	__ADDWRN 16,17,1
	RJMP _0x2CB
_0x2CC:
	__GETD1S 8
	CALL SUBOPT_0x59
	BRNE _0x2CD
;    3853 		{
;    3854 			_FF_error = WRITE_ERR;
	LDI  R30,LOW(3)
	STS  __FF_error,R30
;    3855 			_FF_DIR_ADDR = addr_temp;
	CALL SUBOPT_0x67
;    3856 			return (0);				
	RJMP _0x4CC
;    3857 		}
;    3858 	}
_0x2CD:
_0x2C0:
;    3859 	_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3860 	temp_file_pntr = fopen(NAME, WRITE);
	LDD  R30,Y+35
	LDD  R31,Y+35+1
	CALL SUBOPT_0x7
	CALL _fopen
	CALL SUBOPT_0x69
;    3861 	if (temp_file_pntr == 0)	// Will file open
	BRNE _0x2CE
;    3862 		return (0);				
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x4CC
;    3863 	if (MODE)
_0x2CE:
	LDD  R30,Y+34
	CPI  R30,0
	BREQ _0x2CF
;    3864 	{
;    3865 		if (_FF_read(addr_temp)==0)
	__GETD1S 12
	CALL SUBOPT_0x34
	BRNE _0x2D0
;    3866 		{
;    3867 			_FF_error = READ_ERR;
	LDI  R30,LOW(4)
	STS  __FF_error,R30
;    3868 			return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x4CC
;    3869 		}
;    3870 		_FF_buff[calc_temp+12] |= MODE;		
_0x2D0:
	MOVW R30,R20
	__ADDW1MN __FF_buff,12
	MOVW R0,R30
	LD   R30,Z
	LDD  R26,Y+34
	OR   R30,R26
	MOVW R26,R0
	ST   X,R30
;    3871 		if (_FF_write(addr_temp)==0)
	__GETD1S 12
	CALL SUBOPT_0x59
	BRNE _0x2D1
;    3872 		{
;    3873 			_FF_error = WRITE_ERR;
	LDI  R30,LOW(3)
	STS  __FF_error,R30
;    3874 			return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x4CC
;    3875 		}
;    3876 	}
_0x2D1:
;    3877 	_FF_error = NO_ERR;
_0x2CF:
	LDI  R30,LOW(0)
	STS  __FF_error,R30
;    3878 	return (temp_file_pntr);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
_0x4CC:
	CALL __LOADLOCR6
	ADIW R28,37
	RET
;    3879 }
;    3880 #endif
;    3881 
;    3882 #ifndef _READ_ONLY_
;    3883 // Open a file, name stored in string fileopen
;    3884 int removec(unsigned char flash *NAMEC)
;    3885 {
;    3886 	int c;
;    3887 	unsigned char sd_temp[12];
;    3888 	
;    3889 	for (c=0; c<12; c++)
;	*NAMEC -> Y+14
;	c -> R16,R17
;	sd_temp -> Y+2
;    3890 		sd_temp[c] = NAMEC[c];
;    3891 	
;    3892 	c = remove(sd_temp);
;    3893 	return (c);
;    3894 }
;    3895 
;    3896 // Remove a file from the root directory
;    3897 int remove(unsigned char *NAME)
;    3898 {
;    3899 	unsigned char fpath[14];
;    3900 	unsigned int s, calc_temp;
;    3901 	unsigned long addr_temp, path_addr_temp;
;    3902 	
;    3903 	#ifndef _SECOND_FAT_ON_
;    3904 		clear_second_FAT();
;    3905     #endif
;    3906     
;    3907     addr_temp = 0;	// save local dir addr
;	*NAME -> Y+26
;	fpath -> Y+12
;	s -> R16,R17
;	calc_temp -> R18,R19
;	addr_temp -> Y+8
;	path_addr_temp -> Y+4
;    3908     
;    3909     if (_FF_checkdir(NAME, &addr_temp, fpath))
;    3910 	{
;    3911 		_FF_error = PATH_ERR;
;    3912 		_FF_DIR_ADDR = addr_temp;
;    3913 		return (EOF);
;    3914 	}
;    3915 	if (fpath[0]==0)
;    3916 	{
;    3917 		_FF_error = NAME_ERR; 
;    3918 		_FF_DIR_ADDR = addr_temp;
;    3919 		return (EOF);
;    3920 	}
;    3921     
;    3922 	path_addr_temp = _FF_DIR_ADDR;
;    3923 	s = scan_directory(&path_addr_temp, fpath);
;    3924 	if ((path_addr_temp==0) || (s==0))
;    3925 	{
;    3926 		_FF_error = NO_ENTRY_AVAL;
;    3927 		_FF_DIR_ADDR = addr_temp;
;    3928 		return (EOF);
;    3929 	}
;    3930 	_FF_DIR_ADDR = addr_temp;		// Reset current dir
;    3931 
;    3932 	calc_temp = path_addr_temp % BPB_BytsPerSec;
;    3933 	path_addr_temp -= calc_temp;
;    3934 	if (_FF_read(path_addr_temp)==0)	
;    3935 	{
;    3936 		_FF_error = READ_ERR;
;    3937 		return (EOF);
;    3938 	}
;    3939 	
;    3940 	// Erase entry (put 0xE5 into start of the filename
;    3941 	_FF_buff[calc_temp] = 0xE5;
;    3942 	if (_FF_write(path_addr_temp)==0)
;    3943 	{
;    3944 		_FF_error = WRITE_ERR;
;    3945 		return (EOF);
;    3946 	}
;    3947 	// Save Starting Cluster
;    3948 	calc_temp = ((int) _FF_buff[calc_temp+0x1B] << 8) | (int) _FF_buff[calc_temp+0x1A];
;    3949 	// Destroy cluster chain
;    3950 	if (calc_temp)
;    3951 		if (erase_clus_chain(calc_temp) == 0)
;    3952 			return (EOF);
;    3953 			
;    3954 	return (1);
;    3955 }
;    3956 #endif
;    3957 
;    3958 #ifndef _READ_ONLY_
;    3959 // Rename a file in the Root Directory
;    3960 int rename(unsigned char *NAME_OLD, unsigned char *NAME_NEW)
;    3961 {
;    3962 	unsigned char c;
;    3963 	unsigned int calc_temp;
;    3964 	unsigned long addr_temp, path_addr_temp;
;    3965 	unsigned char *sp, *qp;
;    3966 	unsigned char fpath[14];
;    3967 
;    3968 	// Get the filename into a form we can use to compare
;    3969 	qp = file_name_conversion(NAME_NEW);
;	*NAME_OLD -> Y+31
;	*NAME_NEW -> Y+29
;	c -> R16
;	calc_temp -> R17,R18
;	addr_temp -> Y+25
;	path_addr_temp -> Y+21
;	*sp -> R19,R20
;	*qp -> Y+19
;	fpath -> Y+5
;    3970 	if (qp==0)
;    3971 	{
;    3972 		_FF_error = NAME_ERR;
;    3973 		return (EOF);
;    3974 	}
;    3975 	
;    3976     addr_temp = 0;	// save local dir addr
;    3977     
;    3978     if (_FF_checkdir(NAME_OLD, &addr_temp, fpath))
;    3979 	{
;    3980 		_FF_error = PATH_ERR;
;    3981 		_FF_DIR_ADDR = addr_temp;
;    3982 		return (EOF);
;    3983 	}
;    3984 	if (fpath[0]==0)
;    3985 	{
;    3986 		_FF_error = NAME_ERR; 
;    3987 		_FF_DIR_ADDR = addr_temp;
;    3988 		return (EOF);
;    3989 	}
;    3990 
;    3991 	path_addr_temp = _FF_DIR_ADDR;
;    3992 	calc_temp = scan_directory(&path_addr_temp, NAME_NEW);
;    3993 	if (calc_temp)
;    3994 	{	// does new name alread exist?
;    3995 		_FF_DIR_ADDR = addr_temp;
;    3996 		_FF_error = EXIST_ERR;
;    3997 		return (EOF);
;    3998 	}
;    3999 
;    4000 	path_addr_temp = _FF_DIR_ADDR;
;    4001 	calc_temp = scan_directory(&path_addr_temp, fpath);
;    4002 	if ((path_addr_temp==0) || (calc_temp==0))
;    4003 	{
;    4004 		_FF_DIR_ADDR = addr_temp;
;    4005 		_FF_error = EXIST_ERR;
;    4006 		return (EOF);
;    4007 	}
;    4008 
;    4009 
;    4010 	_FF_DIR_ADDR = addr_temp;		// Reset current dir
;    4011 
;    4012 	calc_temp = path_addr_temp % BPB_BytsPerSec;
;    4013 	path_addr_temp -= calc_temp;
;    4014 	if (_FF_read(path_addr_temp)==0)	
;    4015 	{
;    4016 		_FF_error = READ_ERR;
;    4017 		return (EOF);
;    4018 	}
;    4019 	
;    4020 	// Rename entry
;    4021 	sp = &_FF_buff[calc_temp];
;    4022 	for (c=0; c<11; c++)
;    4023 		*sp++ = *qp++;
;    4024 	if (_FF_write(path_addr_temp)==0)
;    4025 		return (EOF);
;    4026 
;    4027 	return(0);
;    4028 }
;    4029 #endif
;    4030 
;    4031 #ifndef _READ_ONLY_
;    4032 // Save Contents of file, w/o closing
;    4033 int fflush(FILE *rp)	
;    4034 {
_fflush:
;    4035 	unsigned int  n;
;    4036 	unsigned long addr_temp;
;    4037 	
;    4038 	if ((rp==NULL) || (rp->mode==READ))
	CALL SUBOPT_0x80
;	*rp -> Y+6
;	n -> R16,R17
;	addr_temp -> Y+2
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __CPW02
	BREQ _0x2EB
	CALL SUBOPT_0x81
	CPI  R26,LOW(0x1)
	BRNE _0x2EA
_0x2EB:
;    4039 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4CB
;    4040 	
;    4041 	if ((rp->mode==WRITE) || (rp->mode==APPEND))
_0x2EA:
	CALL SUBOPT_0x81
	CPI  R26,LOW(0x2)
	BREQ _0x2EE
	CALL SUBOPT_0x81
	CPI  R26,LOW(0x3)
	BRNE _0x2ED
_0x2EE:
;    4042 	{
;    4043 		addr_temp = (clust_to_addr(rp->clus_current) + ((rp->sec_offset-1)*BPB_BytsPerSec));
	CALL SUBOPT_0x77
	CALL _clust_to_addr
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x82
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x83
;    4044 		for (n=0; n<BPB_BytsPerSec; n++)	// Save file buffer to SD buffer
	__GETWRN 16,17,0
_0x2F1:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x2F2
;    4045 			_FF_buff[n] = rp->buff[n];
	CALL SUBOPT_0x84
	LD   R30,Z
	ST   X,R30
;    4046 		if (_FF_write(addr_temp)==0)	// Write SD buffer to disk
	__ADDWRN 16,17,1
	RJMP _0x2F1
_0x2F2:
	__GETD1S 2
	CALL SUBOPT_0x59
	BRNE _0x2F3
;    4047 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4CB
;    4048 		if (append_toc(rp)==0)	// Update Entry or Error
_0x2F3:
	CALL SUBOPT_0x85
	BRNE _0x2F4
;    4049 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4CB
;    4050 	}
_0x2F4:
;    4051 	
;    4052 	return (0);
_0x2ED:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x4CB:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	RET
;    4053 }
;    4054 #endif		
;    4055 
;    4056 
;    4057 // Close an open file
;    4058 int fclose(FILE *rp)	
;    4059 {
_fclose:
;    4060 	#ifndef _READ_ONLY_
;    4061 	if (rp->mode!=READ)
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0x86
	BREQ _0x2F5
;    4062 		if (fflush(rp)==EOF)
	LD   R30,Y
	LDD  R31,Y+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _fflush
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2F6
;    4063 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4C7
;    4064 	#endif	
;    4065 	// Clear File Structure
;    4066 	free(rp);
_0x2F6:
_0x2F5:
	LD   R30,Y
	LDD  R31,Y+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _free
;    4067 	rp = 0;
	LDI  R30,0
	STD  Y+0,R30
	STD  Y+0+1,R30
;    4068 	return(0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x4C7
;    4069 }
;    4070 
;    4071 int ffreemem(FILE *rp)	
;    4072 {
;    4073 	// Clear File Structure
;    4074 	if (rp==0)
;    4075 		return (EOF);
;    4076 	free(rp);
;    4077 	return(0);
;    4078 }
;    4079 
;    4080 int fget_file_infoc(unsigned char flash *NAMEC, unsigned long *F_SIZE, unsigned char *F_CREATE,
;    4081 				unsigned char *F_MODIFY, unsigned char *F_ATTRIBUTE, unsigned int *F_CLUS_START)
;    4082 {
;    4083 	int c;
;    4084 	unsigned char sd_temp[12];
;    4085 	
;    4086 	for (c=0; c<12; c++)
;	*NAMEC -> Y+24
;	*F_SIZE -> Y+22
;	*F_CREATE -> Y+20
;	*F_MODIFY -> Y+18
;	*F_ATTRIBUTE -> Y+16
;	*F_CLUS_START -> Y+14
;	c -> R16,R17
;	sd_temp -> Y+2
;    4087 		sd_temp[c] = NAMEC[c];
;    4088 	
;    4089 	c = fget_file_info(sd_temp, F_SIZE, F_CREATE, F_MODIFY, F_ATTRIBUTE, F_CLUS_START);
;    4090 	return (c);
;    4091 }
;    4092 
;    4093 int fget_file_info(unsigned char *NAME, unsigned long *F_SIZE, unsigned char *F_CREATE,
;    4094 				unsigned char *F_MODIFY, unsigned char *F_ATTRIBUTE, unsigned int *F_CLUS_START)
;    4095 {
;    4096 	unsigned char n;
;    4097 	unsigned int s, calc_temp;
;    4098 	unsigned long addr_temp, file_calc_temp;
;    4099 	unsigned char *sp, *qp;
;    4100 	
;    4101 	// Get the filename into a form we can use to compare
;    4102 	qp = file_name_conversion(NAME);
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
;    4103 	if (qp==0)
;    4104 	{
;    4105 		_FF_error = NAME_ERR;
;    4106 		return (EOF);
;    4107 	}
;    4108 	
;    4109 	for (s=0; s<BPB_BytsPerSec; s++)
;    4110 	{	// Scan through directory entries to find file
;    4111 		addr_temp = _FF_DIR_ADDR + (0x200 * s);
;    4112 		if (_FF_read(addr_temp)==0)
;    4113 			return (EOF);
;    4114 		for (n=0; n<16; n++)
;    4115 		{
;    4116 			calc_temp = (int) n * 0x20;
;    4117 			qp = &FILENAME[0];
;    4118 			sp = &_FF_buff[calc_temp];
;    4119 			if (*sp == 0)
;    4120 				return (EOF);
;    4121 			if (strncmp(qp, sp, 11)==0)		// Does this entry == Filename
;    4122 			{
;    4123 				*F_ATTRIBUTE = _FF_buff[calc_temp+11];	// Save ATTRIBUTE Byte to location
;    4124 				*F_SIZE = ((long) _FF_buff[calc_temp+31] << 24) | ((long) _FF_buff[calc_temp+30] << 16)
;    4125 							| ((long) _FF_buff[calc_temp+29] << 8) | ((long) _FF_buff[calc_temp+28]);
;    4126 							// Save SIZE of file to location
;    4127                 *F_CLUS_START = ((unsigned int) _FF_buff[calc_temp+27] << 8) | ((unsigned int) _FF_buff[calc_temp+26]);
;    4128 				file_calc_temp = ((unsigned int) _FF_buff[calc_temp+17] << 8) | ((unsigned int) _FF_buff[calc_temp+16]);
;    4129 				qp = F_CREATE;
;    4130 				*qp++ = (((file_calc_temp >> 5) & 0x0F) / 10) + '0';
;    4131 				*qp++ = (((file_calc_temp >> 5) & 0x0F) % 10) + '0';
;    4132 				*qp++ = '/';
;    4133 				*qp++ = ((file_calc_temp & 0x1F) / 10) + '0';
;    4134 				*qp++ = ((file_calc_temp & 0x1F) % 10) + '0';
;    4135 				*qp++ = '/';
;    4136 				file_calc_temp = ((file_calc_temp >> 9) & 0x7F) + 1980;
;    4137 				*qp++ = (file_calc_temp / 1000) + '0';
;    4138 				file_calc_temp %= 1000;
;    4139 				*qp++ = (file_calc_temp / 100) + '0';
;    4140 				file_calc_temp %= 100;
;    4141 				*qp++ = (file_calc_temp / 10) + '0';
;    4142 				*qp++ = (file_calc_temp % 10) + '0';
;    4143 				*qp++ = ' ';
;    4144 				*qp++ = ' ';
;    4145 				file_calc_temp = ((unsigned int) _FF_buff[calc_temp+15] << 8) | ((unsigned int) _FF_buff[calc_temp+14]);
;    4146 				*qp++ = (((file_calc_temp >> 11) & 0x1F) / 10) + '0';
;    4147 				*qp++ = (((file_calc_temp >> 11) & 0x1F) % 10) + '0';
;    4148 				*qp++ = ':';
;    4149 				*qp++ = (((file_calc_temp >> 5) & 0x3F) / 10) + '0';
;    4150 				*qp++ = (((file_calc_temp >> 5) & 0x3F) % 10) + '0';
;    4151 				*qp++ = ':';
;    4152 				*qp++ = (((file_calc_temp & 0x1F) * 2) / 10) + '0';
;    4153 				*qp++ = (((file_calc_temp & 0x1F) * 2) % 10) + '0';
;    4154 				*qp = 0;
;    4155 				
;    4156 				file_calc_temp = ((unsigned int) _FF_buff[calc_temp+25] << 8) | ((unsigned int) _FF_buff[calc_temp+24]);
;    4157 				qp = F_MODIFY;
;    4158 				*qp++ = (((file_calc_temp >> 5) & 0x0F) / 10) + '0';
;    4159 				*qp++ = (((file_calc_temp >> 5) & 0x0F) % 10) + '0';
;    4160 				*qp++ = '/';
;    4161 				*qp++ = ((file_calc_temp & 0x1F) / 10) + '0';
;    4162 				*qp++ = ((file_calc_temp & 0x1F) % 10) + '0';
;    4163 				*qp++ = '/';
;    4164 				file_calc_temp = ((file_calc_temp >> 9) & 0x7F) + 1980;
;    4165 				*qp++ = (file_calc_temp / 1000) + '0';
;    4166 				file_calc_temp %= 1000;
;    4167 				*qp++ = (file_calc_temp / 100) + '0';
;    4168 				file_calc_temp %= 100;
;    4169 				*qp++ = (file_calc_temp / 10) + '0';
;    4170 				*qp++ = (file_calc_temp % 10) + '0';
;    4171 				*qp++ = ' ';
;    4172 				*qp++ = ' ';
;    4173 				file_calc_temp = ((unsigned int) _FF_buff[calc_temp+23] << 8) | ((unsigned int) _FF_buff[calc_temp+22]);
;    4174 				*qp++ = (((file_calc_temp >> 11) & 0x1F) / 10) + '0';
;    4175 				*qp++ = (((file_calc_temp >> 11) & 0x1F) % 10) + '0';
;    4176 				*qp++ = ':';
;    4177 				*qp++ = (((file_calc_temp >> 5) & 0x3F) / 10) + '0';
;    4178 				*qp++ = (((file_calc_temp >> 5) & 0x3F) % 10) + '0';
;    4179 				*qp++ = ':';
;    4180 				*qp++ = (((file_calc_temp & 0x1F) * 2) / 10) + '0';
;    4181 				*qp++ = (((file_calc_temp & 0x1F) * 2) % 10) + '0';
;    4182 				*qp = 0;
;    4183 				
;    4184 				return (0);
;    4185 			}
;    4186 		}                          		
;    4187 	}
;    4188 	_FF_error = FILE_ERR;
;    4189 	return(EOF);
;    4190 }
;    4191 
;    4192 // Get File data and increment file pointer
;    4193 int fgetc(FILE *rp)
;    4194 {
_fgetc:
;    4195 	unsigned char get_data;
;    4196 	unsigned int n;
;    4197 	unsigned long addr_temp;
;    4198 	
;    4199 	if (rp==NULL)
	SBIW R28,4
	CALL __SAVELOCR3
;	*rp -> Y+7
;	get_data -> R16
;	n -> R17,R18
;	addr_temp -> Y+3
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	SBIW R30,0
	BRNE _0x305
;    4200 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4CA
;    4201 
;    4202 	if (rp->position == rp->length)
_0x305:
	CALL SUBOPT_0x87
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
	BRNE _0x306
;    4203 	{
;    4204 		rp->error = POS_ERR;
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CALL SUBOPT_0x88
;    4205 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4CA
;    4206 	}
;    4207 	
;    4208 	get_data = *rp->pntr;
_0x306:
	CALL SUBOPT_0x89
	LD   R16,Z
;    4209 	
;    4210 	if ((rp->pntr)==(&rp->buff[BPB_BytsPerSec-1]))
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	SUBI R26,LOW(-551)
	SBCI R27,HIGH(-551)
	LD   R0,X+
	LD   R1,X
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CALL SUBOPT_0x8A
	BREQ PC+3
	JMP _0x307
;    4211 	{	// Check to see if pointer is at the end of a sector
;    4212 		#ifndef _READ_ONLY_
;    4213 		if ((rp->mode==WRITE) || (rp->mode==APPEND))
	CALL SUBOPT_0x8B
	CPI  R26,LOW(0x2)
	BREQ _0x309
	CALL SUBOPT_0x8B
	CPI  R26,LOW(0x3)
	BRNE _0x308
_0x309:
;    4214 		{	// if in write or append mode, update the current sector before loading next
;    4215 			for (n=0; n<BPB_BytsPerSec; n++)
	__GETWRN 17,18,0
_0x30C:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	CP   R17,R30
	CPC  R18,R31
	BRSH _0x30D
;    4216 				_FF_buff[n] = rp->buff[n];
	__GETW2R 17,18
	SUBI R26,LOW(-__FF_buff)
	SBCI R27,HIGH(-__FF_buff)
	CALL SUBOPT_0x8C
	LD   R30,Z
	ST   X,R30
;    4217 			addr_temp = clust_to_addr(rp->clus_current) + (((rp->sec_offset)-1)*BPB_BytsPerSec);
	__ADDWRN 17,18,1
	RJMP _0x30C
_0x30D:
	CALL SUBOPT_0x8D
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x8E
	SBIW R30,1
	LDS  R26,_BPB_BytsPerSec
	LDS  R27,_BPB_BytsPerSec+1
	CALL __MULW12U
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x8F
;    4218 			if (_FF_write(addr_temp)==0)
	__GETD1S 3
	CALL SUBOPT_0x59
	BRNE _0x30E
;    4219 				return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4CA
;    4220 		}
_0x30E:
;    4221 		#endif
;    4222 		if (rp->sec_offset < BPB_SecPerClus)
_0x308:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	CALL SUBOPT_0x90
	BRSH _0x30F
;    4223 		{	// Goto next sector if not at the end of a cluster
;    4224 			addr_temp = clust_to_addr(rp->clus_current) + (rp->sec_offset*BPB_BytsPerSec);
	CALL SUBOPT_0x8D
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x8E
	LDS  R26,_BPB_BytsPerSec
	LDS  R27,_BPB_BytsPerSec+1
	CALL __MULW12U
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x8F
;    4225 			rp->sec_offset++;
	CALL SUBOPT_0x8E
	ADIW R30,1
	ST   X+,R30
	ST   X,R31
;    4226 		}
;    4227 		else
	RJMP _0x310
_0x30F:
;    4228 		{	// End of Cluster, find next
;    4229 			if (rp->clus_next>=0xFFF8)	// No next cluster, EOF marker
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R26,Z+16
	LDD  R27,Z+17
	CPI  R26,LOW(0xFFF8)
	LDI  R30,HIGH(0xFFF8)
	CPC  R27,R30
	BRLO _0x311
;    4230 			{
;    4231 				rp->EOF_flag = 1;	// Set flag so Putchar knows to get new cluster
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CALL SUBOPT_0x91
;    4232 				rp->position++;		// Only time doing this, position + 1 should equal length
	CALL SUBOPT_0x87
	CALL SUBOPT_0x92
;    4233 				return(get_data);
	RJMP _0x4CA
;    4234 			}
;    4235 			addr_temp = clust_to_addr(rp->clus_next);
_0x311:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R26,Z+16
	LDD  R27,Z+17
	ST   -Y,R27
	ST   -Y,R26
	CALL _clust_to_addr
	__PUTD1S 3
;    4236 			rp->sec_offset = 1;
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CALL SUBOPT_0x93
;    4237 			rp->clus_prev = rp->clus_current;
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ADIW R26,14
	CALL __GETW1P
	__PUTW1SNS 7,18
;    4238 			rp->clus_current = rp->clus_next;
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ADIW R26,16
	CALL __GETW1P
	__PUTW1SNS 7,14
;    4239 			rp->clus_next = next_cluster(rp->clus_current, SINGLE);
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R26,Z+14
	LDD  R27,Z+15
	ST   -Y,R27
	ST   -Y,R26
	CALL SUBOPT_0x78
	__PUTW1SNS 7,16
;    4240 		}
_0x310:
;    4241 		if (_FF_read(addr_temp)==0)
	__GETD1S 3
	CALL SUBOPT_0x34
	BRNE _0x312
;    4242 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4CA
;    4243 		for (n=0; n<BPB_BytsPerSec; n++)
_0x312:
	__GETWRN 17,18,0
_0x314:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	CP   R17,R30
	CPC  R18,R31
	BRSH _0x315
;    4244 			rp->buff[n] = _FF_buff[n];
	CALL SUBOPT_0x8C
	MOVW R0,R30
	LDI  R26,LOW(__FF_buff)
	LDI  R27,HIGH(__FF_buff)
	ADD  R26,R17
	ADC  R27,R18
	CALL SUBOPT_0x94
;    4245 		rp->pntr = &rp->buff[0];
	__ADDWRN 17,18,1
	RJMP _0x314
_0x315:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,28
	__PUTW1SN 7,551
;    4246 	}
;    4247 	else
	RJMP _0x316
_0x307:
;    4248 		rp->pntr++;
	CALL SUBOPT_0x89
	ADIW R30,1
	ST   X+,R30
	ST   X,R31
;    4249 	
;    4250 	rp->position++;	
_0x316:
	CALL SUBOPT_0x87
	CALL SUBOPT_0x92
;    4251 	return(get_data);		
_0x4CA:
	CALL __LOADLOCR3
	ADIW R28,9
	RET
;    4252 }
;    4253 
;    4254 char *fgets(char *buffer, int n, FILE *rp)
;    4255 {
;    4256 	int c, temp_data;
;    4257 	
;    4258 	for (c=0; c<n; c++)
;	*buffer -> Y+8
;	n -> Y+6
;	*rp -> Y+4
;	c -> R16,R17
;	temp_data -> R18,R19
;    4259 	{
;    4260 		temp_data = fgetc(rp);
;    4261 		*buffer = temp_data & 0xFF;
;    4262 		if (temp_data == '\n')
;    4263 			break;
;    4264 		else if (temp_data == EOF)
;    4265 			break;
;    4266 		buffer++;
;    4267 	}
;    4268 	if (c==n)
;    4269 		buffer++;
;    4270 	*buffer-- = '\0';
;    4271 	if (temp_data == EOF)
;    4272 		return (NULL);
;    4273 	return (buffer);
;    4274 }
;    4275 
;    4276 #ifndef _READ_ONLY_
;    4277 // Decrement file pointer, then get file data
;    4278 int ungetc(unsigned char file_data, FILE *rp)
;    4279 {
;    4280 	unsigned int n;
;    4281 	unsigned long addr_temp;
;    4282 	
;    4283 	if ((rp==NULL) || (rp->position==0))
;	file_data -> Y+8
;	*rp -> Y+6
;	n -> R16,R17
;	addr_temp -> Y+2
;    4284 		return (EOF);
;    4285 	if ((rp->mode!=APPEND) && (rp->mode!=WRITE))
;    4286 		return (EOF);	// needs to be in WRITE or APPEND mode
;    4287 
;    4288 	if (((rp->position) == rp->length) && (rp->EOF_flag))
;    4289 	{	// if the file posisition is equal to the length, return data, turn flag off
;    4290 		rp->EOF_flag = 0;
;    4291 		*rp->pntr = file_data;
;    4292 		return (*rp->pntr);
;    4293 	}
;    4294 	if ((rp->pntr)==(&rp->buff[0]))
;    4295 	{	// Check to see if pointer is at the beginning of a Sector
;    4296 		// Update the current sector before loading next
;    4297 		for (n=0; n<BPB_BytsPerSec; n++)
;    4298 			_FF_buff[n] = rp->buff[n];
;    4299 		addr_temp = clust_to_addr(rp->clus_current) + (((rp->sec_offset)-1)*BPB_BytsPerSec);
;    4300 		if (_FF_write(addr_temp)==0)
;    4301 			return (EOF);
;    4302 			
;    4303 		if (rp->sec_offset > 1)
;    4304 		{	// Goto previous sector if not at the beginning of a cluster
;    4305 			addr_temp = clust_to_addr(rp->clus_current) + ((rp->sec_offset-2)*BPB_BytsPerSec);
;    4306 			rp->sec_offset--;
;    4307 		}
;    4308 		else
;    4309 		{	// Beginning of Cluster, find previous
;    4310 			if (rp->clus_start==rp->clus_current)
;    4311 			{	// Positioned @ Beginning of File
;    4312 				_FF_error = SOF_ERR;
;    4313 				return(EOF);
;    4314 			}
;    4315 			rp->sec_offset = BPB_SecPerClus;	// Set sector offset to last sector
;    4316 			rp->clus_next = rp->clus_current;
;    4317 			rp->clus_current = rp->clus_prev;
;    4318 			if (rp->clus_current != rp->clus_start)
;    4319 				rp->clus_prev = prev_cluster(rp->clus_current);
;    4320 			else
;    4321 				rp->clus_prev = 0;
;    4322 			addr_temp = clust_to_addr(rp->clus_current) + (((long) BPB_SecPerClus-1) * (long) BPB_BytsPerSec);
;    4323 		}
;    4324 		_FF_read(addr_temp);
;    4325 		for (n=0; n<BPB_BytsPerSec; n++)
;    4326 			rp->buff[n] = _FF_buff[n];
;    4327 		rp->pntr = &rp->buff[511];
;    4328 	}
;    4329 	else
;    4330 		rp->pntr--;
;    4331 	
;    4332 	rp->position--;
;    4333 	*rp->pntr = file_data;	
;    4334 	return(*rp->pntr);	// Get data	
;    4335 }
;    4336 #endif
;    4337 
;    4338 #ifndef _READ_ONLY_
;    4339 int fputc(unsigned char file_data, FILE *rp)	
;    4340 {
_fputc:
;    4341 	unsigned int n;
;    4342 	unsigned long addr_temp;
;    4343 	
;    4344 	if (rp==NULL)
	CALL SUBOPT_0x80
;	file_data -> Y+8
;	*rp -> Y+6
;	n -> R16,R17
;	addr_temp -> Y+2
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,0
	BRNE _0x336
;    4345 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4C9
;    4346 
;    4347 	if (rp->mode == READ)
_0x336:
	CALL SUBOPT_0x81
	CPI  R26,LOW(0x1)
	BRNE _0x337
;    4348 	{
;    4349 		_FF_error = READONLY_ERR;
	LDI  R30,LOW(6)
	STS  __FF_error,R30
;    4350 		return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4C9
;    4351 	}
;    4352 	if (rp->length == 0)
_0x337:
	CALL SUBOPT_0x75
	BRNE _0x338
;    4353 	{	// Blank file start writing cluster table
;    4354 		rp->clus_start = prev_cluster(0);
	CALL SUBOPT_0x95
	__PUTW1SNS 6,12
;    4355 		rp->clus_next = 0xFFFF;
	CALL SUBOPT_0x96
;    4356 		rp->clus_current = rp->clus_start;
	CALL SUBOPT_0x70
	__PUTW1SNS 6,14
;    4357 		if (write_clus_table(rp->clus_start, rp->clus_next, SINGLE)==0)
	CALL SUBOPT_0x76
	CALL SUBOPT_0x97
	LDI  R30,LOW(1)
	CALL SUBOPT_0x98
	BRNE _0x339
;    4358 		{
;    4359 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4C9
;    4360 		}
;    4361 	}
_0x339:
;    4362 	
;    4363 	if ((rp->position==rp->length) && (rp->EOF_flag))
_0x338:
	CALL SUBOPT_0x99
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x9A
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD12
	BRNE _0x33B
	CALL SUBOPT_0x9B
	BRNE _0x33C
_0x33B:
	RJMP _0x33A
_0x33C:
;    4364 	{	// At end of file, and end of cluster, flagged
;    4365 		rp->clus_prev = rp->clus_current;
	CALL SUBOPT_0x9C
	__PUTW1SNS 6,18
;    4366 		rp->clus_current = prev_cluster(0);	// Find first cluster pointing to '0'
	CALL SUBOPT_0x95
	__PUTW1SNS 6,14
;    4367 		rp->clus_next = 0xFFFF;
	CALL SUBOPT_0x96
;    4368 		rp->sec_offset = 1;
	CALL SUBOPT_0x79
;    4369 		if (write_clus_table(rp->clus_prev, rp->clus_current, CHAIN)==0)
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
	LDI  R30,LOW(0)
	CALL SUBOPT_0x98
	BRNE _0x33D
;    4370 		{
;    4371 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4C9
;    4372 		}
;    4373 		if (write_clus_table(rp->clus_current, rp->clus_next, END_CHAIN)==0)
_0x33D:
	CALL SUBOPT_0x77
	CALL SUBOPT_0x97
	LDI  R30,LOW(2)
	CALL SUBOPT_0x98
	BRNE _0x33E
;    4374 		{
;    4375 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4C9
;    4376 		}
;    4377 		if (append_toc(rp)==0)
_0x33E:
	CALL SUBOPT_0x85
	BRNE _0x33F
;    4378 		{
;    4379 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4C9
;    4380 		}
;    4381 		rp->EOF_flag = 0;
_0x33F:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x9D
;    4382 		rp->pntr = &rp->buff[0];		
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,28
	__PUTW1SN 6,551
;    4383 	}
;    4384 	
;    4385 	*rp->pntr = file_data;
_0x33A:
	CALL SUBOPT_0x9E
	LDD  R26,Y+8
	STD  Z+0,R26
;    4386 	
;    4387 	if (rp->pntr == &rp->buff[BPB_BytsPerSec-1])
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-551)
	SBCI R27,HIGH(-551)
	LD   R0,X+
	LD   R1,X
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x8A
	BREQ PC+3
	JMP _0x340
;    4388 	{	// This is on the Sector Limit
;    4389 		if (rp->position > rp->length)
	CALL SUBOPT_0x99
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x9A
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD12
	BRSH _0x341
;    4390 		{	// ERROR, position should never be greater than length
;    4391 			_FF_error = 0x10;		// file position ERROR
	LDI  R30,LOW(16)
	STS  __FF_error,R30
;    4392 			return (EOF); 
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4C9
;    4393 		}
;    4394 		// Position is at end of a sector?
;    4395 		
;    4396 		addr_temp = (clust_to_addr(rp->clus_current) + ((rp->sec_offset-1)*BPB_BytsPerSec));
_0x341:
	CALL SUBOPT_0x77
	CALL _clust_to_addr
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x82
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x83
;    4397 		for (n=0; n<BPB_BytsPerSec; n++)
	__GETWRN 16,17,0
_0x343:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x344
;    4398 			_FF_buff[n] = rp->buff[n];
	CALL SUBOPT_0x84
	LD   R30,Z
	ST   X,R30
;    4399 		_FF_write(addr_temp);
	__ADDWRN 16,17,1
	RJMP _0x343
_0x344:
	__GETD1S 2
	CALL __PUTPARD1
	CALL __FF_write
;    4400 			// Save MMC buffer to card, set pointer to begining of new buffer
;    4401 		if (rp->sec_offset < BPB_SecPerClus)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL SUBOPT_0x90
	BRSH _0x345
;    4402 		{	// Are there more sectors in this cluster?
;    4403 			addr_temp = clust_to_addr(rp->clus_current) + (rp->sec_offset * BPB_BytsPerSec);
	CALL SUBOPT_0x77
	CALL _clust_to_addr
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x9F
	LDS  R26,_BPB_BytsPerSec
	LDS  R27,_BPB_BytsPerSec+1
	CALL __MULW12U
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x83
;    4404 			rp->sec_offset++;
	CALL SUBOPT_0x9F
	ADIW R30,1
	ST   X+,R30
	ST   X,R31
;    4405 		}
;    4406 		else
	RJMP _0x346
_0x345:
;    4407 		{	// Find next cluster, load first sector into file.buff
;    4408 			if (((rp->clus_next>=0xFFF8)&&(BPB_FATType==0x36)) ||
;    4409 				((rp->clus_next>=0xFF8)&&(BPB_FATType==0x32)))
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+16
	LDD  R27,Z+17
	CPI  R26,LOW(0xFFF8)
	LDI  R30,HIGH(0xFFF8)
	CPC  R27,R30
	BRLO _0x348
	LDS  R26,_BPB_FATType
	CPI  R26,LOW(0x36)
	BREQ _0x34A
_0x348:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+16
	LDD  R27,Z+17
	CPI  R26,LOW(0xFF8)
	LDI  R30,HIGH(0xFF8)
	CPC  R27,R30
	BRLO _0x34B
	LDS  R26,_BPB_FATType
	CPI  R26,LOW(0x32)
	BREQ _0x34A
_0x34B:
	RJMP _0x347
_0x34A:
;    4410 			{	// EOF, need to find new empty cluster
;    4411 				if (rp->position != rp->length)
	CALL SUBOPT_0x99
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x9A
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD12
	BREQ _0x34E
;    4412 				{	// if not equal there's an error
;    4413 					_FF_error = 0x20;		// EOF position error
	LDI  R30,LOW(32)
	STS  __FF_error,R30
;    4414 					return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4C9
;    4415 				}
;    4416 				rp->EOF_flag = 1;
_0x34E:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x91
;    4417 			}
;    4418 			else
	RJMP _0x34F
_0x347:
;    4419 			{	// Not EOF, find next cluster
;    4420 				rp->clus_prev = rp->clus_current;
	CALL SUBOPT_0x9C
	__PUTW1SNS 6,18
;    4421 				rp->clus_current = rp->clus_next;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,16
	CALL __GETW1P
	__PUTW1SNS 6,14
;    4422 				rp->clus_next = next_cluster(rp->clus_current, SINGLE);
	CALL SUBOPT_0x77
	CALL SUBOPT_0x78
	__PUTW1SNS 6,16
;    4423 			}
_0x34F:
;    4424 			rp->sec_offset = 1;
	CALL SUBOPT_0x79
;    4425 			addr_temp = clust_to_addr(rp->clus_current);
	CALL SUBOPT_0x77
	CALL _clust_to_addr
	__PUTD1S 2
;    4426 		}
_0x346:
;    4427 		
;    4428 		if (rp->EOF_flag == 0)
	CALL SUBOPT_0x9B
	BRNE _0x350
;    4429 		{
;    4430 			if (_FF_read(addr_temp)==0)
	__GETD1S 2
	CALL SUBOPT_0x34
	BRNE _0x351
;    4431 				return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4C9
;    4432 			for (n=0; n<512; n++)
_0x351:
	__GETWRN 16,17,0
_0x353:
	__CPWRN 16,17,512
	BRSH _0x354
;    4433 				rp->buff[n] = _FF_buff[n];
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x7B
;    4434 			rp->pntr = &rp->buff[0];	// Set pointer to next location				
	__ADDWRN 16,17,1
	RJMP _0x353
_0x354:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,28
	__PUTW1SN 6,551
;    4435 		}
;    4436 		if (rp->length==rp->position)
_0x350:
	CALL SUBOPT_0x9A
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x99
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD12
	BRNE _0x355
;    4437 			rp->length++;
	CALL SUBOPT_0x9A
	__SUBD1N -1
	CALL __PUTDP1
;    4438 		if (append_toc(rp)==0)
_0x355:
	CALL SUBOPT_0x85
	BRNE _0x356
;    4439 			return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4C9
;    4440 	}
_0x356:
;    4441 	else
	RJMP _0x357
_0x340:
;    4442 	{
;    4443 		rp->pntr++;
	CALL SUBOPT_0x9E
	ADIW R30,1
	ST   X+,R30
	ST   X,R31
;    4444 		if (rp->length==rp->position)
	CALL SUBOPT_0x9A
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x99
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD12
	BRNE _0x358
;    4445 			rp->length++;
	CALL SUBOPT_0x9A
	__SUBD1N -1
	CALL __PUTDP1
;    4446 	}
_0x358:
_0x357:
;    4447 	rp->position++;
	CALL SUBOPT_0x99
	__SUBD1N -1
	CALL __PUTDP1
;    4448 	return(file_data);
	LDD  R30,Y+8
	LDI  R31,0
_0x4C9:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,9
	RET
;    4449 }
;    4450 
;    4451 int fputs(unsigned char *file_data, FILE *rp)
;    4452 {
;    4453 	while(*file_data)
;    4454 		if (fputc(*file_data++,rp) == EOF)
;    4455 			return (EOF);
;    4456 	if (fputc('\r',rp) == EOF)
;    4457 		return (EOF);
;    4458 	if (fputc('\n',rp) == EOF)
;    4459 		return (EOF);
;    4460 	return (0);
;    4461 }
;    4462 
;    4463 int fputsc(flash unsigned char *file_data, FILE *rp)
;    4464 {
;    4465 	while(*file_data)
;    4466 		if (fputc(*file_data++,rp) == EOF)
;    4467 			return (EOF);
;    4468 	if (fputc('\r',rp) == EOF)
;    4469 		return (EOF);
;    4470 	if (fputc('\n',rp) == EOF)
;    4471 		return (EOF);
;    4472 	return (0);
;    4473 }
;    4474 #endif
;    4475 
;    4476 //#ifndef _READ_ONLY_
;    4477 #ifdef _CVAVR_
;    4478 void fprintf(FILE *rp, unsigned char flash *pstr, ...)
;    4479 {
;    4480 	va_list arglist;
;    4481 	unsigned char temp_buff[_FF_MAX_FPRINT], *fp;
;    4482 	
;    4483 	va_start(arglist, pstr);
;	*rp -> Y+106
;	*pstr -> Y+104
;	*arglist -> R16,R17
;	temp_buff -> Y+4
;	*fp -> R18,R19
;    4484 	vsprintf(temp_buff, pstr, arglist);
;    4485 	va_end(arglist);
;    4486 	
;    4487 	fp = temp_buff;
;    4488 	while (*fp)
;    4489 		fputc(*fp++, rp);	
;    4490 }
;    4491 #endif
;    4492 #ifdef _ICCAVR_
;    4493 void fprintf(FILE *rp, unsigned char flash *pstr, long var)
;    4494 {
;    4495 	unsigned char temp_buff[_FF_MAX_FPRINT], *fp;
;    4496 	
;    4497 	csprintf(temp_buff, pstr, var);
;    4498 	
;    4499 	fp = temp_buff;
;    4500 	while (*fp)
;    4501 		fputc(*fp++, rp);	
;    4502 }
;    4503 #endif
;    4504 //#endif
;    4505 
;    4506 // Set file pointer to the end of the file
;    4507 int fend(FILE *rp)
;    4508 {
;    4509 	return (fseek(rp, 0, SEEK_END));	
;    4510 }
;    4511 
;    4512 // Goto position "off_set" of a file
;    4513 int fseek(FILE *rp, unsigned long off_set, unsigned char mode)
;    4514 {
_fseek:
;    4515 	unsigned int n, clus_temp;
;    4516 	unsigned long length_check, addr_calc;
;    4517 	
;    4518 	if (rp==NULL)
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
	BRNE _0x368
;    4519 	{	// ERROR if FILE pointer is NULL
;    4520 		_FF_error = FILE_ERR;
	LDI  R30,LOW(2)
	STS  __FF_error,R30
;    4521 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4C8
;    4522 	}
;    4523 	if (mode==SEEK_CUR)
_0x368:
	LDD  R30,Y+12
	CPI  R30,0
	BRNE _0x369
;    4524 	{	// Trying to position pointer to offset from current position
;    4525 		off_set += rp->position;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SUBI R26,LOW(-544)
	SBCI R27,HIGH(-544)
	CALL __GETD1P
	__GETD2S 13
	CALL __ADDD12
	__PUTD1S 13
;    4526 	}
;    4527 	if (off_set > rp->length)
_0x369:
	CALL SUBOPT_0xA0
	CALL __CPD12
	BRSH _0x36A
;    4528 	{	// trying to position beyond or before file
;    4529 		rp->error = POS_ERR;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	CALL SUBOPT_0x88
;    4530 		_FF_error = POS_ERR;
	CALL SUBOPT_0xA1
;    4531 		return (EOF);
	RJMP _0x4C8
;    4532 	}
;    4533 	if (mode==SEEK_END)
_0x36A:
	LDD  R26,Y+12
	CPI  R26,LOW(0x1)
	BRNE _0x36B
;    4534 	{	// Trying to position pointer to offset from EOF
;    4535 		off_set = rp->length - off_set;
	CALL SUBOPT_0xA0
	CALL __SUBD12
	__PUTD1S 13
;    4536 	}
;    4537 	#ifndef _READ_ONLY_
;    4538 	if (rp->mode != READ)
_0x36B:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	CALL SUBOPT_0x86
	BREQ _0x36C
;    4539 		if (fflush(rp))
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _fflush
	SBIW R30,0
	BREQ _0x36D
;    4540 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4C8
;    4541 	#endif
;    4542 	clus_temp = rp->clus_start;
_0x36D:
_0x36C:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,12
	LD   R18,X+
	LD   R19,X
;    4543 	rp->clus_current = clus_temp;
	MOVW R30,R18
	__PUTW1SNS 17,14
;    4544 	rp->clus_next = next_cluster(clus_temp, SINGLE);
	ST   -Y,R19
	ST   -Y,R18
	CALL SUBOPT_0x78
	__PUTW1SNS 17,16
;    4545 	rp->clus_prev = 0;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	CALL SUBOPT_0x71
;    4546 	
;    4547 	addr_calc = off_set / ((long) BPB_BytsPerSec * (long) BPB_SecPerClus);
	CALL SUBOPT_0x45
	__GETD2S 13
	CALL __DIVD21U
	__PUTD1S 4
;    4548 	length_check = off_set % ((long) BPB_BytsPerSec * (long) BPB_SecPerClus);
	CALL SUBOPT_0x45
	__GETD2S 13
	CALL __MODD21U
	__PUTD1S 8
;    4549 	rp->EOF_flag = 0;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	CALL SUBOPT_0x9D
;    4550 
;    4551 	while (addr_calc)
_0x36E:
	__GETD1S 4
	CALL __CPD10
	BRNE PC+3
	JMP _0x370
;    4552 	{
;    4553 		if (rp->clus_next >= 0xFFF8)
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	LDD  R26,Z+16
	LDD  R27,Z+17
	CPI  R26,LOW(0xFFF8)
	LDI  R30,HIGH(0xFFF8)
	CPC  R27,R30
	BRLO _0x371
;    4554 		{	// trying to position beyond or before file
;    4555 			if ((addr_calc==1) && (length_check==0))
	__GETD2S 4
	__CPD2N 0x1
	BRNE _0x373
	__GETD2S 8
	CALL __CPD02
	BREQ _0x374
_0x373:
	RJMP _0x372
_0x374:
;    4556 			{
;    4557 				rp->EOF_flag = 1;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	CALL SUBOPT_0x91
;    4558 				break;
	RJMP _0x370
;    4559 			}				
;    4560 			rp->error = POS_ERR;
_0x372:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	CALL SUBOPT_0x88
;    4561 			_FF_error = POS_ERR;
	CALL SUBOPT_0xA1
;    4562 			return (EOF);
	RJMP _0x4C8
;    4563 		}
;    4564 		clus_temp = rp->clus_next;
_0x371:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,16
	LD   R18,X+
	LD   R19,X
;    4565 		rp->clus_prev = rp->clus_current;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,14
	CALL __GETW1P
	__PUTW1SNS 17,18
;    4566 		rp->clus_current = clus_temp;
	MOVW R30,R18
	__PUTW1SNS 17,14
;    4567 		rp->clus_next = next_cluster(clus_temp, CHAIN);
	CALL SUBOPT_0x5E
	__PUTW1SNS 17,16
;    4568 		addr_calc--;
	__GETD1S 4
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	__PUTD1S 4
;    4569 	}
	RJMP _0x36E
_0x370:
;    4570 	
;    4571 	addr_calc = clust_to_addr(rp->clus_current);
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	LDD  R26,Z+14
	LDD  R27,Z+15
	ST   -Y,R27
	ST   -Y,R26
	CALL _clust_to_addr
	__PUTD1S 4
;    4572 	rp->sec_offset = 1;			// Reset Reading Sector
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	CALL SUBOPT_0x93
;    4573 	while (length_check >= BPB_BytsPerSec)
_0x375:
	CALL SUBOPT_0xA2
	CALL __CPD21
	BRLO _0x377
;    4574 	{
;    4575 		addr_calc += BPB_BytsPerSec;
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	__GETD2S 4
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1S 4
;    4576 		length_check -= BPB_BytsPerSec;
	CALL SUBOPT_0xA2
	CALL __SUBD21
	__PUTD2S 8
;    4577 		rp->sec_offset++;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,20
	CALL __GETW1P
	ADIW R30,1
	ST   X+,R30
	ST   X,R31
;    4578 	}
	RJMP _0x375
_0x377:
;    4579 	
;    4580 	if (_FF_read(addr_calc)==0)		// Read Current Data Sector
	__GETD1S 4
	CALL SUBOPT_0x34
	BRNE _0x378
;    4581 		return(EOF);		// Read Error  
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4C8
;    4582 		
;    4583 	for (n=0; n<BPB_BytsPerSec; n++)
_0x378:
	__GETWRN 16,17,0
_0x37A:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x37B
;    4584 		rp->buff[n] = _FF_buff[n];
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ADIW R30,28
	ADD  R30,R16
	ADC  R31,R17
	CALL SUBOPT_0x7B
;    4585     
;    4586     if ((rp->EOF_flag == 1) && (length_check == 0))
	__ADDWRN 16,17,1
	RJMP _0x37A
_0x37B:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SUBI R26,LOW(-550)
	SBCI R27,HIGH(-550)
	LD   R26,X
	CPI  R26,LOW(0x1)
	BRNE _0x37D
	__GETD2S 8
	CALL __CPD02
	BREQ _0x37E
_0x37D:
	RJMP _0x37C
_0x37E:
;    4587     	rp->pntr = &rp->buff[BPB_BytsPerSec-1];
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,28
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	SBIW R30,1
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1SN 17,551
;    4588 	rp->pntr = &rp->buff[length_check];
_0x37C:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,28
	__GETD1S 8
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1SN 17,551
;    4589 	rp->position = off_set;
	__GETD1S 13
	__PUTD1SN 17,544
;    4590 		
;    4591 	return (0);	
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x4C8:
	CALL __LOADLOCR4
	ADIW R28,19
	RET
;    4592 }
;    4593 
;    4594 // Return the current position of the file rp with respect to the begining of the file
;    4595 long ftell(FILE *rp)
;    4596 {
_ftell:
;    4597 	if (rp==NULL)
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE _0x37F
;    4598 		return (EOF);
	__GETD1N 0xFFFFFFFF
	RJMP _0x4C7
;    4599 	else
_0x37F:
;    4600 		return (rp->position);
	CALL SUBOPT_0xA3
	RJMP _0x4C7
;    4601 }
;    4602 
;    4603 // Funtion that returns a '1' for @EOF, '0' otherwise
;    4604 int feof(FILE *rp)
;    4605 {
_feof:
;    4606 	if (rp==NULL)
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE _0x381
;    4607 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x4C7
;    4608 	
;    4609 	if (rp->length==rp->position)
_0x381:
	LD   R26,Y
	LDD  R27,Y+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xA3
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD12
	BRNE _0x382
;    4610 		return (1);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x4C7
;    4611 	else
_0x382:
;    4612 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
;    4613 }
_0x4C7:
	ADIW R28,2
	RET
;    4614 		
;    4615 void dump_file_data_hex(FILE *rp)
;    4616 {
;    4617 	unsigned int n, c;
;    4618 	
;    4619 	if (rp==NULL)
;	*rp -> Y+4
;	n -> R16,R17
;	c -> R18,R19
;    4620 		return;
;    4621 
;    4622 	for (n=0; n<0x20; n++)
;    4623 	{   
;    4624 		printf("\n\r");
;    4625 		for (c=0; c<0x10; c++)
;    4626 			printf("%02X ", rp->buff[(n*0x20)+c]);
;    4627 	}
;    4628 }
;    4629 ////////////////////////////////////////////////////////////////////////////
;    4630 // секция формирования пакета закрытия
;    4631 
;    4632 #include "Coding.h"
;    4633 
;    4634 #define koef_pd_kl 		0x7//3//1//3
;    4635 #define Koef_men_kl 	0x7f//07//03//7
;    4636 #define  kolvo_ciklov		0x04			// цикличность передачи циклового пакета
;    4637 //#define Koef_men_kl 0x7f
;    4638 //#define Koef_pd_soft 0x1	//max skorost if 01
;    4639 
;    4640 
;    4641 
;    4642 u8 kluchi_koderu[8] = {0x2,0x45,0x1,0x89,0x6,0x42,0x5,0xf6};//wyh буффер na kluchi

	.DSEG
_kluchi_koderu:
	.BYTE 0x8
;    4643 u8 kluchi_dekoderu[16];//wyh буффер na kluchi
_kluchi_dekoderu:
	.BYTE 0x10
;    4644 
;    4645 u16 gshch1 	=	0xCD;	//shumovoe chislo-jachejka генераторa случайных чисел 1	kluch1  confkluch1;	
_gshch1:
	.BYTE 0x2
;    4646 u16 gshch2	=	0xAE;	//jachejka генераторa случайных чисел 2	kluch2	confkluch2;	
_gshch2:
	.BYTE 0x2
;    4647 u16 gshch3	=	0xBA;	//jachejka генераторa случайных чисел 3 for kazakov
_gshch3:
	.BYTE 0x2
;    4648 u16 gshch4	=	0x35;		//jachejka генераторa случайных чисел 4 dlja maskirovki
_gshch4:
	.BYTE 0x2
;    4649 u16 gshch5	=	0x43;		//jachejka генераторa случайных чисел 5 dlja maskirovki
_gshch5:
	.BYTE 0x2
;    4650 u16 gshch6;					//декодирование файла mask.chm
_gshch6:
	.BYTE 0x2
;    4651 u16 gshch7	=	0x166;	//генерация ключа
_gshch7:
	.BYTE 0x2
;    4652 
;    4653 
;    4654 int confkluch1 = 0xb2;;		//konfiguracija gen klucha1
_confkluch1:
	.BYTE 0x2
;    4655 int confkluch2 = 0xa6;		//konfiguracija gen klucha2
_confkluch2:
	.BYTE 0x2
;    4656 int krutnut		=	0x7;
_krutnut:
	.BYTE 0x2
;    4657 int ver_kl		=	0x7d;
_ver_kl:
	.BYTE 0x2
;    4658 
;    4659 u8	komu;	//=0x25-paket koderu,0x26-paket v liniju
_komu:
	.BYTE 0x1
;    4660 u8 schetchic_paketov_zakrytija = 0;//для 4-го байта пакета
_schetchic_paketov_zakrytija:
	.BYTE 0x1
;    4661 int kolvo_abonentov		=0;
_kolvo_abonentov:
	.BYTE 0x2
;    4662 u8 kolvo_stvolov	=	0;
_kolvo_stvolov:
	.BYTE 0x1
;    4663 
;    4664 u8 scrambCond = TX_g_p_koderu;		// текущее состояние скремблера
_scrambCond:
	.BYTE 0x1
;    4665 
;    4666 u8 N_sektora		=	122;//pri programirovanii
_N_sektora:
	.BYTE 0x1
;    4667 u8 ver_zeleza	=	0;
_ver_zeleza:
	.BYTE 0x1
;    4668 u8 flag_est_obnovlenie_flash	=	1;
_flag_est_obnovlenie_flash:
	.BYTE 0x1
;    4669 u8 flag_est_obnovlenie_eeprom;
_flag_est_obnovlenie_eeprom:
	.BYTE 0x1
;    4670 int l_flash;							//длина флеша для прог.
_l_flash:
	.BYTE 0x2
;    4671 //u8 tip;	
;    4672 u8 pozklucha;
_pozklucha:
	.BYTE 0x1
;    4673 int count_paket	=	0;// счетчик пакетов для организации циклов передачи спец.пакетов
_count_paket:
	.BYTE 0x2
;    4674 u16 schetchic_abonentov;
_schetchic_abonentov:
	.BYTE 0x2
;    4675 #define time_OFF_scremb 2000000		//таймаут между принятым по UART пакету и работой внутр скремблера
;    4676 
;    4677 
;    4678 // При работе с COM портом не работает скремблер 
;    4679 void	scrambOff (void)
;    4680 {

	.CSEG
_scrambOff:
;    4681 		EndTimePack = 0;		// сброс признака
	CLT
	BLD  R2,0
;    4682 		
;    4683 		TCCR3A=0x00;			// делитель до 7.813кГц (128uS)
	CALL SUBOPT_0x13
;    4684 		TCCR3B=0x05;
;    4685 
;    4686 		TCNT3H=(0xFFFF - (time_OFF_scremb/128)) >>8;			// иниц. величины 8с
	LDI  R30,LOW(194)
	STS  137,R30
;    4687 		TCNT3L=0xFFFF - (time_OFF_scremb/128);			// иниц. величины 8с
	LDI  R30,LOW(49910)
	STS  136,R30
;    4688 }
	RET
;    4689 
;    4690 // возвращает число введенных абонентов
;    4691 u32 getAbons (void)
;    4692 { 
_getAbons:
;    4693 	u32 a = 0;
;    4694 
;    4695 				if (fseek (fu_user, 0, SEEK_SET) == EOF) 
	SBIW R28,4
	LDI  R24,4
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x399*2)
	LDI  R31,HIGH(_0x399*2)
	CALL __INITLOCB
;	a -> Y+0
	CALL SUBOPT_0x1B
	BRNE _0x39A
;    4696 				{
;    4697 
;    4698 				#ifdef print
;    4699 				printf("getAbons - ERROR\n\r");
;    4700 	 			#endif
;    4701 
;    4702 					return 0 ;//поставить указатель на начало файла
	__GETD1N 0x0
	RJMP _0x4C6
;    4703 				}
;    4704 
;    4705 				kolvo_abonentov = fgetc(fu_user);
_0x39A:
	CALL SUBOPT_0x23
	STS  _kolvo_abonentov,R30
	STS  _kolvo_abonentov+1,R31
;    4706 				kolvo_abonentov |= fgetc(fu_user)*256;
	CALL SUBOPT_0x23
	CALL SUBOPT_0xA4
;    4707 				kolvo_abonentov |= fgetc(fu_user)*256*256;
	CALL SUBOPT_0x23
	MOV  R31,R30
	LDI  R30,0
	MOV  R31,R30
	LDI  R30,0
	LDS  R26,_kolvo_abonentov
	LDS  R27,_kolvo_abonentov+1
	OR   R30,R26
	OR   R31,R27
	STS  _kolvo_abonentov,R30
	STS  _kolvo_abonentov+1,R31
;    4708 				kolvo_abonentov |= fgetc(fu_user)*256*256*256;         
	CALL SUBOPT_0x23
	MOV  R31,R30
	LDI  R30,0
	MOV  R31,R30
	LDI  R30,0
	CALL SUBOPT_0xA4
;    4709 				
;    4710                 return kolvo_abonentov;
	LDS  R30,_kolvo_abonentov
	LDS  R31,_kolvo_abonentov+1
	CALL __CWD1
	RJMP _0x4C6
;    4711 }
;    4712 
;    4713 
;    4714 u8 scrambling (void)
;    4715 {
_scrambling:
;    4716 		u32 a;
;    4717 		static u8 count_ciklovogo = 0;		// для счета цикловых пакетов  

	.DSEG
_count_ciklovogo_S64:
	.BYTE 0x1

	.CSEG
;    4718 
;    4719 		switch (scrambCond)
	SBIW R28,4
;	a -> Y+0
	LDS  R30,_scrambCond
;    4720 		{
;    4721 			case startScremb:
	CPI  R30,0
	BRNE _0x39E
;    4722 				eefprog=f_buff_prog;            //поставить указатель на начало 
	LDI  R30,LOW(_f_buff_prog)
	LDI  R31,HIGH(_f_buff_prog)
	MOVW R4,R30
;    4723 				kolvo_stvolov= *eefprog++;
	CALL SUBOPT_0x17
	CALL __EEPROMRDB
	STS  _kolvo_stvolov,R30
;    4724 
;    4725 				#ifdef print
;    4726 				printf("kolvo_stvolov=%d \n\r",kolvo_stvolov);
;    4727 		 		#endif
;    4728 
;    4729 				kolvo_abonentov = getAbons();
	CALL _getAbons
	STS  _kolvo_abonentov,R30
	STS  _kolvo_abonentov+1,R31
;    4730 	
;    4731 				#ifdef print
;    4732 				printf("kolvo_abonentov=%d \n\r",kolvo_abonentov);
;    4733 				#endif
;    4734 
;    4735 				schetchic_abonentov = 0;
	LDI  R30,0
	STS  _schetchic_abonentov,R30
	STS  _schetchic_abonentov+1,R30
;    4736 				scrambCond = TX_g_p_razresh;				// переходим к передаче пакетов абонентам
	LDI  R30,LOW(1)
	STS  _scrambCond,R30
;    4737 				break;
	RJMP _0x39D
;    4738 				////////////////////////////////////////////////////////////////////////////////////////////////
;    4739 			case TX_g_p_razresh:
_0x39E:
	CPI  R30,LOW(0x1)
	BRNE _0x39F
;    4740 				if (schetchic_abonentov < kolvo_abonentov)
	LDS  R30,_kolvo_abonentov
	LDS  R31,_kolvo_abonentov+1
	LDS  R26,_schetchic_abonentov
	LDS  R27,_schetchic_abonentov+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x3A0
;    4741 				{
;    4742 					#ifdef print
;    4743 					printf("Generation g_p_razresh No- %d \n\r",schetchic_abonentov);
;    4744 					#endif
;    4745 			 		g_p_razresh();													//генерация пакета разрешений
	RCALL _g_p_razresh
;    4746 			 		schetchic_abonentov++;
	LDS  R30,_schetchic_abonentov
	LDS  R31,_schetchic_abonentov+1
	ADIW R30,1
	STS  _schetchic_abonentov,R30
	STS  _schetchic_abonentov+1,R31
;    4747 					count_paket++;
	LDS  R30,_count_paket
	LDS  R31,_count_paket+1
	ADIW R30,1
	STS  _count_paket,R30
	STS  _count_paket+1,R31
;    4748 
;    4749 					if ((count_paket & koef_pd_kl)==0)						// Генерация 
	LDS  R30,_count_paket
	ANDI R30,LOW(0x7)
	BRNE _0x3A1
;    4750 					{
;    4751 					 	scrambCond = TX_g_p_kluchi;
	LDI  R30,LOW(7)
	STS  _scrambCond,R30
;    4752 					 	break;
	RJMP _0x39D
;    4753 					}
;    4754 				}	
_0x3A1:
;    4755 //				else scrambCond = TX_g_p_flash; 	// переходим к передаче обновления ПО	
;    4756 				else 	scrambCond = TX_g_p_ciklovogo; 	// переходим к передаче  циклового пакета
	RJMP _0x3A2
_0x3A0:
	LDI  R30,LOW(4)
	STS  _scrambCond,R30
;    4757 
;    4758 				break;
_0x3A2:
	RJMP _0x39D
;    4759 				////////////////////////////////////////////////////////////////////////////////////////////////
;    4760 			case TX_g_p_kluchi:                
_0x39F:
	CPI  R30,LOW(0x7)
	BRNE _0x3A3
;    4761 				#ifdef print
;    4762 				printf("Generation g_p_kluch...\n\r ");
;    4763 				#endif
;    4764 				g_p_kluchi();             
	RCALL _g_p_kluchi
;    4765 				if ((count_paket & Koef_men_kl)==0)					// Генерация 
	LDS  R30,_count_paket
	ANDI R30,0x7F
	BRNE _0x3A4
;    4766 				{
;    4767 //					if (count_paket & (Koef_men_kl+1)) scrambCond = TX_men_ver_kl;
;    4768 					if (count_paket & (Koef_men_kl+1)) 
	LDS  R30,_count_paket
	ANDI R30,LOW(0x80)
	BREQ _0x3A5
;    4769 					{
;    4770 						#ifdef print
;    4771 						printf("Generation men_ver_k... \n\r");
;    4772 						#endif
;    4773 					 	men_ver_kl();
	RCALL _men_ver_kl
;    4774 
;    4775 						scrambCond = TX_g_p_razresh; 	
	LDI  R30,LOW(1)
	RJMP _0x4EE
;    4776 					}
;    4777 					else 	scrambCond = TX_g_p_koderu;
_0x3A5:
	LDI  R30,LOW(6)
_0x4EE:
	STS  _scrambCond,R30
;    4778 					break;
	RJMP _0x39D
;    4779 				}
;    4780 
;    4781 				scrambCond = TX_g_p_razresh; 	
_0x3A4:
	LDI  R30,LOW(1)
	STS  _scrambCond,R30
;    4782 				break;                        
	RJMP _0x39D
;    4783 				////////////////////////////////////////////////////////////////////////////////////////////////
;    4784 			case TX_men_ver_kl:			
_0x3A3:
	CPI  R30,LOW(0x5)
	BRNE _0x3A7
;    4785 				#ifdef print
;    4786 				printf("Generation men_ver_k... \n\r");
;    4787 				#endif
;    4788 			 	men_ver_kl();
	RCALL _men_ver_kl
;    4789 
;    4790 				scrambCond = TX_g_p_razresh; 	
	LDI  R30,LOW(1)
	STS  _scrambCond,R30
;    4791 				break;                        
	RJMP _0x39D
;    4792 				////////////////////////////////////////////////////////////////////////////////////////////////
;    4793 			case	TX_g_p_koderu:
_0x3A7:
	CPI  R30,LOW(0x6)
	BRNE _0x3A8
;    4794 				#ifdef print
;    4795 				printf("Generation g_p_koderu... \n\r");
;    4796 				#endif
;    4797 				g_kod();							//подготовка ключей кодеру     
	RCALL _g_kod
;    4798 				g_p_koderu();					//кодирование и передача пакета
	RCALL _g_p_koderu
;    4799 
;    4800 				scrambCond = TX_g_p_flagov; 	
	LDI  R30,LOW(8)
	STS  _scrambCond,R30
;    4801 				break;                        
	RJMP _0x39D
;    4802 				////////////////////////////////////////////////////////////////////////////////////////////////
;    4803 			case TX_g_p_flagov:
_0x3A8:
	CPI  R30,LOW(0x8)
	BRNE _0x3A9
;    4804 				#ifdef print
;    4805 				printf("Generation g_p_flagov... \n\r");
;    4806 				#endif
;    4807 				g_p_flagov();
	RCALL _g_p_flagov
;    4808 
;    4809 				scrambCond = TX_g_p_razresh; 	
	LDI  R30,LOW(1)
	STS  _scrambCond,R30
;    4810 
;    4811 				break;                        
	RJMP _0x39D
;    4812 				////////////////////////////////////////////////////////////////////////////////////////////////
;    4813 /*			case TX_g_p_flash:
;    4814 
;    4815 				scrambCond = TX_g_p_obnovlenie; 	// переходим к передаче обновления ПО	
;    4816 				break;
;    4817 				////////////////////////////////////////////////////////////////////////////////////////////////
;    4818 			case TX_g_p_obnovlenie:
;    4819 				// Генерация 
;    4820 				if ((count_paket & Koef_pd_soft)==0)
;    4821 				{
;    4822 					if (flag_est_obnovlenie_flash==1)
;    4823 					{
;    4824 						#ifdef print
;    4825 						printf("N_sec=%d ...\n\r" ,N_sektora);
;    4826 						#endif
;    4827 //						g_p_progf();				//генерация пакета флэш
;    4828 					}
;    4829 
;    4830 					if (flag_est_obnovlenie_eeprom ==1)
;    4831 					{	
;    4832 			//			g_p_proge(port);//генерация пакета   ЕЕПРОМ
;    4833 						#ifdef print
;    4834 						printf("g_p_proge...\n\r  " );
;    4835 						#endif
;    4836 					}
;    4837 				}	
;    4838 
;    4839 				scrambCond = TX_g_p_ciklovogo; 	// переходим к передаче  циклового пакета
;    4840 				break;*/
;    4841 
;    4842 				////////////////////////////////////////////////////////////////////////////////////////////////
;    4843 			case TX_g_p_ciklovogo:
_0x3A9:
	CPI  R30,LOW(0x4)
	BRNE _0x3AD
;    4844 				#ifdef print
;    4845 				printf("\n\r-------------------------Generation g_p_ciklovogo...-------------------- \n\r");
;    4846 				#endif
;    4847 				if (count_ciklovogo >= kolvo_ciklov)
	LDS  R26,_count_ciklovogo_S64
	CPI  R26,LOW(0x4)
	BRLO _0x3AB
;    4848 				{
;    4849 				  	 	g_p_ciklovogo();
	RCALL _g_p_ciklovogo
;    4850 				  	 	count_ciklovogo = 0;
	LDI  R30,LOW(0)
	RJMP _0x4EF
;    4851 				}                                    
;    4852 				else count_ciklovogo ++; 
_0x3AB:
	LDS  R30,_count_ciklovogo_S64
	SUBI R30,-LOW(1)
_0x4EF:
	STS  _count_ciklovogo_S64,R30
;    4853 
;    4854 				scrambCond = startScremb;	//  переходим к установке стартовых параметров
	LDI  R30,LOW(0)
	STS  _scrambCond,R30
;    4855 				break;
;    4856 
;    4857 			default: break;
_0x3AD:
;    4858 		}
_0x39D:
;    4859 
;    4860 		return TRUE;		
	LDI  R30,LOW(1)
_0x4C6:
	ADIW R28,4
	RET
;    4861 }
;    4862 #include "Coding.h"
;    4863 
;    4864 void ini_kluchej(void)
;    4865 {
;    4866 	confkluch1	=0xb2;	//konfiguracija gen klucha1
;    4867 	confkluch2	=0xa6;	//konfiguracija gen klucha2
;    4868 	krutnut		=0x7;
;    4869 	ver_kl		=0x7d;
;    4870 
;    4871 	kluchi_koderu[0]=0x2;//kl0h
;    4872 	kluchi_koderu[1]=0x45;//kl0l
;    4873 	kluchi_koderu[2]=0x1;//kl1h
;    4874 	kluchi_koderu[3]=0x89;//kl1l
;    4875 	kluchi_koderu[4]=0x6;//kl2h
;    4876 	kluchi_koderu[5]=0x42;//kl2l
;    4877 	kluchi_koderu[6]=0x5;//kl3h
;    4878 	kluchi_koderu[7]=0xf6;//kl3l
;    4879 
;    4880 }
;    4881 
;    4882 void podgotovka_kluch_dekoderu(void)
;    4883 {
_podgotovka_kluch_dekoderu:
;    4884 int a,i;
;    4885 
;    4886 	kluchi_dekoderu[0]=0x55;//confkluch1;
	CALL __SAVELOCR4
;	a -> R16,R17
;	i -> R18,R19
	LDI  R30,LOW(85)
	STS  _kluchi_dekoderu,R30
;    4887 	kluchi_dekoderu[1]=confkluch2;
	__POINTW2MN _kluchi_dekoderu,1
	LDS  R30,_confkluch2
	LDS  R31,_confkluch2+1
	ST   X,R30
;    4888 	kluchi_dekoderu[2]=0x55;//krutnut;
	LDI  R30,LOW(85)
	__PUTB1MN _kluchi_dekoderu,2
;    4889 	kluchi_dekoderu[3]=0x55;//kolvo_abonentov;
	__PUTB1MN _kluchi_dekoderu,3
;    4890 	kluchi_dekoderu[4]=kolvo_stvolov;
	__POINTW2MN _kluchi_dekoderu,4
	LDS  R30,_kolvo_stvolov
	ST   X,R30
;    4891 	kluchi_dekoderu[5]=0x55;//rezerv
	LDI  R30,LOW(85)
	__PUTB1MN _kluchi_dekoderu,5
;    4892 	kluchi_dekoderu[6]=0x55;//rezerv
	__PUTB1MN _kluchi_dekoderu,6
;    4893 
;    4894 
;    4895 	kluchi_dekoderu[7]=kluchi_koderu[0];//f_buff_kluch[86]^f_buff_kluch[225];//kl0h
	LDS  R30,_kluchi_koderu
	__PUTB1MN _kluchi_dekoderu,7
;    4896 	kluchi_dekoderu[8]=kluchi_koderu[1];//	f_buff_kluch[89]^f_buff_kluch[225];//kl0l
	__GETB1MN _kluchi_koderu,1
	__PUTB1MN _kluchi_dekoderu,8
;    4897 	kluchi_dekoderu[9]=kluchi_koderu[2];//f_buff_kluch[131]^f_buff_kluch[225];//kl1h
	__GETB1MN _kluchi_koderu,2
	__PUTB1MN _kluchi_dekoderu,9
;    4898 	kluchi_dekoderu[10]=kluchi_koderu[3];//f_buff_kluch[141]^f_buff_kluch[225];//kl1l
	__GETB1MN _kluchi_koderu,3
	__PUTB1MN _kluchi_dekoderu,10
;    4899 	kluchi_dekoderu[11]=kluchi_koderu[4];//f_buff_kluch[215]^f_buff_kluch[225];//kl2h
	__GETB1MN _kluchi_koderu,4
	__PUTB1MN _kluchi_dekoderu,11
;    4900 	kluchi_dekoderu[12]=kluchi_koderu[5];//f_buff_kluch[241]^f_buff_kluch[225];//kl2l
	__GETB1MN _kluchi_koderu,5
	__PUTB1MN _kluchi_dekoderu,12
;    4901 	kluchi_dekoderu[13]=kluchi_koderu[6];//f_buff_kluch[162]^f_buff_kluch[225];//kl3h
	__GETB1MN _kluchi_koderu,6
	__PUTB1MN _kluchi_dekoderu,13
;    4902 	kluchi_dekoderu[14]=kluchi_koderu[7];//f_buff_kluch[169]^f_buff_kluch[225];//kl3l
	__GETB1MN _kluchi_koderu,7
	__PUTB1MN _kluchi_dekoderu,14
;    4903 
;    4904 	a=0;
	__GETWRN 16,17,0
;    4905 	for (i=0;i<15;i++)
	__GETWRN 18,19,0
_0x3AF:
	__CPWRN 18,19,15
	BRGE _0x3B0
;    4906 	{
;    4907 		a=a+kluchi_dekoderu[i];
	LDI  R26,LOW(_kluchi_dekoderu)
	LDI  R27,HIGH(_kluchi_dekoderu)
	ADD  R26,R18
	ADC  R27,R19
	LD   R30,X
	MOVW R26,R16
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
;    4908 	}
	__ADDWRN 18,19,1
	RJMP _0x3AF
_0x3B0:
;    4909 	a=-1-a;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	SUB  R30,R16
	SBC  R31,R17
	MOVW R16,R30
;    4910 	kluchi_dekoderu[15]=a;
	__PUTBMRN _kluchi_dekoderu,15,16
;    4911 }
	RJMP _0x4C4
;    4912 
;    4913 //генерация ключей
;    4914 void g_kod(void)	
;    4915 {
_g_kod:
;    4916 	if  (ver_kl & 0x80)
	LDS  R30,_ver_kl
	ANDI R30,LOW(0x80)
	BREQ _0x3B1
;    4917 	{
;    4918 	gshum7();
	RCALL _gshum7
;    4919 	kluchi_koderu[0]=gshch7;//f_buff_kluch[86]^f_buff_kluch[225];//kl0h
	LDS  R30,_gshch7
	STS  _kluchi_koderu,R30
;    4920 	gshum7();
	RCALL _gshum7
;    4921 	kluchi_koderu[1]=gshch7;//f_buff_kluch[89]^f_buff_kluch[225];//kl0l
	__POINTW2MN _kluchi_koderu,1
	CALL SUBOPT_0xA5
;    4922 	gshum7();
;    4923 	kluchi_koderu[4]=gshch7;//f_buff_kluch[215]^f_buff_kluch[225];//kl2h
	__POINTW2MN _kluchi_koderu,4
	CALL SUBOPT_0xA5
;    4924 	gshum7();
;    4925 	kluchi_koderu[5]=gshch7;//f_buff_kluch[241]^f_buff_kluch[225];//kl2l
	__POINTW2MN _kluchi_koderu,5
	RJMP _0x4F0
;    4926 	
;    4927 	}
;    4928 	else
_0x3B1:
;    4929 	{
;    4930 	gshum7();
	RCALL _gshum7
;    4931 	kluchi_koderu[2]=gshch7;//f_buff_kluch[131]^f_buff_kluch[225];//kl1h
	__POINTW2MN _kluchi_koderu,2
	CALL SUBOPT_0xA5
;    4932 	gshum7();
;    4933 	kluchi_koderu[3]=gshch7;//f_buff_kluch[141]^f_buff_kluch[225];//kl1l
	__POINTW2MN _kluchi_koderu,3
	CALL SUBOPT_0xA5
;    4934 	gshum7();
;    4935 	kluchi_koderu[6]=gshch7;//f_buff_kluch[162]^f_buff_kluch[225];//kl3h
	__POINTW2MN _kluchi_koderu,6
	CALL SUBOPT_0xA5
;    4936 	gshum7();
;    4937 	kluchi_koderu[7]=gshch7;//f_buff_kluch[169]^f_buff_kluch[225];//kl3l           
	__POINTW2MN _kluchi_koderu,7
_0x4F0:
	LDS  R30,_gshch7
	LDS  R31,_gshch7+1
	ST   X,R30
;    4938 	
;    4939 	}	 
;    4940 	podgotovka_kluch_dekoderu();
	CALL _podgotovka_kluch_dekoderu
;    4941 }
	RET
;    4942 
;    4943 //переключение версии ключей
;    4944 void men_ver_kl(void)	
;    4945 {
_men_ver_kl:
;    4946 	if  (ver_kl & 0x80)
	LDS  R30,_ver_kl
	ANDI R30,LOW(0x80)
	BREQ _0x3B3
;    4947 	{
;    4948 		ver_kl=ver_kl & 0x7f;
	LDS  R30,_ver_kl
	LDS  R31,_ver_kl+1
	ANDI R30,LOW(0x7F)
	ANDI R31,HIGH(0x7F)
	STS  _ver_kl,R30
	STS  _ver_kl+1,R31
;    4949 	}
;    4950 	else
	RJMP _0x3B4
_0x3B3:
;    4951 	{
;    4952 		ver_kl=ver_kl | 0x80;
	LDS  R30,_ver_kl
	ORI  R30,0x80
	STS  _ver_kl,R30
;    4953 	}
_0x3B4:
;    4954 }
	RET
;    4955 
;    4956 	
;    4957 //для закрутки буфера передачи
;    4958 void g_klucha1(void) 
;    4959 {
_g_klucha1:
;    4960 int a,b,i;
;    4961 		a=gshch1 & confkluch1;
	CALL __SAVELOCR6
;	a -> R16,R17
;	b -> R18,R19
;	i -> R20,R21
	LDS  R30,_confkluch1
	LDS  R31,_confkluch1+1
	LDS  R26,_gshch1
	LDS  R27,_gshch1+1
	AND  R30,R26
	AND  R31,R27
	MOVW R16,R30
;    4962 		b=0;
	__GETWRN 18,19,0
;    4963 		for (i=0;i<16;i++)
	__GETWRN 20,21,0
_0x3B6:
	__CPWRN 20,21,16
	BRGE _0x3B7
;    4964 		{
;    4965 			b=b^a;
	__EORWRR 18,19,16,17
;    4966 			b=b & 1;
	__ANDWRN 18,19,1
;    4967 			a>>=1;
	ASR  R17
	ROR  R16
;    4968 		}
	__ADDWRN 20,21,1
	RJMP _0x3B6
_0x3B7:
;    4969 		gshch1<<=1;
	LDS  R30,_gshch1
	LDS  R31,_gshch1+1
	LSL  R30
	ROL  R31
	STS  _gshch1,R30
	STS  _gshch1+1,R31
;    4970 		gshch1=gshch1 | b;	//or
	MOVW R30,R18
	LDS  R26,_gshch1
	LDS  R27,_gshch1+1
	OR   R30,R26
	OR   R31,R27
	STS  _gshch1,R30
	STS  _gshch1+1,R31
;    4971 }
	RJMP _0x4C5
;    4972 
;    4973 //кодирование некоторых параметров лдя совместимости
;    4974 void g_klucha2(void)	
;    4975 {
_g_klucha2:
;    4976 int a,b,i;
;    4977 		a=gshch2 & confkluch2;
	CALL __SAVELOCR6
;	a -> R16,R17
;	b -> R18,R19
;	i -> R20,R21
	LDS  R30,_confkluch2
	LDS  R31,_confkluch2+1
	LDS  R26,_gshch2
	LDS  R27,_gshch2+1
	AND  R30,R26
	AND  R31,R27
	MOVW R16,R30
;    4978 		b=0;
	__GETWRN 18,19,0
;    4979 		for (i=0;i<16;i++)
	__GETWRN 20,21,0
_0x3B9:
	__CPWRN 20,21,16
	BRGE _0x3BA
;    4980 		{
;    4981 			b=b^a;
	__EORWRR 18,19,16,17
;    4982 			b=b & 1;
	__ANDWRN 18,19,1
;    4983 			a>>=1;
	ASR  R17
	ROR  R16
;    4984 		}
	__ADDWRN 20,21,1
	RJMP _0x3B9
_0x3BA:
;    4985 		gshch2<<=1;
	LDS  R30,_gshch2
	LDS  R31,_gshch2+1
	LSL  R30
	ROL  R31
	STS  _gshch2,R30
	STS  _gshch2+1,R31
;    4986 		gshch2=gshch2 | b;	//or
	MOVW R30,R18
	LDS  R26,_gshch2
	LDS  R27,_gshch2+1
	OR   R30,R26
	OR   R31,R27
	STS  _gshch2,R30
	STS  _gshch2+1,R31
;    4987 }
	RJMP _0x4C5
;    4988 
;    4989 
;    4990 //dlja peredachi Kazakovu
;    4991 void gshum3(void)	
;    4992 {
_gshum3:
;    4993 int a,b,i;
;    4994 		a=gshch3 & conf3;
	CALL __SAVELOCR6
;	a -> R16,R17
;	b -> R18,R19
;	i -> R20,R21
	LDS  R30,_gshch3
	LDS  R31,_gshch3+1
	ANDI R30,LOW(0xB8)
	ANDI R31,HIGH(0xB8)
	MOVW R16,R30
;    4995 		b=0;
	__GETWRN 18,19,0
;    4996 		for (i=0;i<16;i++)
	__GETWRN 20,21,0
_0x3BC:
	__CPWRN 20,21,16
	BRGE _0x3BD
;    4997 		{
;    4998 			b=b^a;
	__EORWRR 18,19,16,17
;    4999 			b=b & 1;
	__ANDWRN 18,19,1
;    5000 			a>>=1;
	ASR  R17
	ROR  R16
;    5001 
;    5002 		}
	__ADDWRN 20,21,1
	RJMP _0x3BC
_0x3BD:
;    5003 		gshch3<<=1;
	LDS  R30,_gshch3
	LDS  R31,_gshch3+1
	LSL  R30
	ROL  R31
	STS  _gshch3,R30
	STS  _gshch3+1,R31
;    5004 		gshch3=gshch3 | b;
	MOVW R30,R18
	LDS  R26,_gshch3
	LDS  R27,_gshch3+1
	OR   R30,R26
	OR   R31,R27
	STS  _gshch3,R30
	STS  _gshch3+1,R31
;    5005 }
	RJMP _0x4C5
;    5006 
;    5007 //маскировка пакета в линю
;    5008 void gshum4(void)	
;    5009 {
_gshum4:
;    5010 int a,b,i; 
;    5011 
;    5012 		a=gshch4 & conf4;
	CALL __SAVELOCR6
;	a -> R16,R17
;	b -> R18,R19
;	i -> R20,R21
	LDS  R30,_gshch4
	LDS  R31,_gshch4+1
	ANDI R30,LOW(0x500)
	ANDI R31,HIGH(0x500)
	MOVW R16,R30
;    5013 		b=0;
	__GETWRN 18,19,0
;    5014 		for (i=0;i<16;i++)
	__GETWRN 20,21,0
_0x3BF:
	__CPWRN 20,21,16
	BRGE _0x3C0
;    5015 		{
;    5016 			b=b^a;
	__EORWRR 18,19,16,17
;    5017 			b=b & 1;
	__ANDWRN 18,19,1
;    5018 			a>>=1;
	ASR  R17
	ROR  R16
;    5019 
;    5020 		}
	__ADDWRN 20,21,1
	RJMP _0x3BF
_0x3C0:
;    5021 		gshch4<<=1;
	LDS  R30,_gshch4
	LDS  R31,_gshch4+1
	LSL  R30
	ROL  R31
	STS  _gshch4,R30
	STS  _gshch4+1,R31
;    5022 		gshch4=gshch4 | b;	//or
	MOVW R30,R18
	LDS  R26,_gshch4
	LDS  R27,_gshch4+1
	OR   R30,R26
	OR   R31,R27
	STS  _gshch4,R30
	STS  _gshch4+1,R31
;    5023 }
	RJMP _0x4C5
;    5024 
;    5025 //маскировка пакета Казакову
;    5026 void gshum5(void)		
;    5027 {
_gshum5:
;    5028 int a,b,i;
;    5029 		a=gshch5 & conf5;
	CALL __SAVELOCR6
;	a -> R16,R17
;	b -> R18,R19
;	i -> R20,R21
	LDS  R30,_gshch5
	LDS  R31,_gshch5+1
	ANDI R30,LOW(0x740)
	ANDI R31,HIGH(0x740)
	MOVW R16,R30
;    5030 		b=0;
	__GETWRN 18,19,0
;    5031 		for (i=0;i<16;i++)
	__GETWRN 20,21,0
_0x3C2:
	__CPWRN 20,21,16
	BRGE _0x3C3
;    5032 		{
;    5033 			b=b^a;
	__EORWRR 18,19,16,17
;    5034 			b=b & 1;
	__ANDWRN 18,19,1
;    5035 			a>>=1;
	ASR  R17
	ROR  R16
;    5036 
;    5037 		}
	__ADDWRN 20,21,1
	RJMP _0x3C2
_0x3C3:
;    5038 		gshch5<<=1;
	LDS  R30,_gshch5
	LDS  R31,_gshch5+1
	LSL  R30
	ROL  R31
	STS  _gshch5,R30
	STS  _gshch5+1,R31
;    5039 		gshch5=gshch5 | b;	//or
	MOVW R30,R18
	LDS  R26,_gshch5
	LDS  R27,_gshch5+1
	OR   R30,R26
	OR   R31,R27
	STS  _gshch5,R30
	STS  _gshch5+1,R31
;    5040 }
	RJMP _0x4C5
;    5041 
;    5042 //декодирование файла flash.bin
;    5043 void gshum6(void)		
;    5044 {
;    5045 int a,b,i;
;    5046 		a=gshch6 & conf6;
;	a -> R16,R17
;	b -> R18,R19
;	i -> R20,R21
;    5047 		b=0;
;    5048 		for (i=0;i<16;i++)
;    5049 		{
;    5050 			b=b^a;
;    5051 			b=b & 1;
;    5052 			a>>=1;
;    5053 
;    5054 		}
;    5055 		gshch6<<=1;
;    5056 		gshch6=gshch6 | b;	//or
;    5057 }
;    5058 
;    5059 //генерация ключей
;    5060 //декодирование файла flash.bin при загрузке из файла
;    5061 void gshum7(void)	
;    5062 {
_gshum7:
;    5063 int a,b,i;
;    5064 gshum7st:
	CALL __SAVELOCR6
;	a -> R16,R17
;	b -> R18,R19
;	i -> R20,R21
_0x3C7:
;    5065 		a=gshch7 & conf7;
	LDS  R30,_gshch7
	LDS  R31,_gshch7+1
	ANDI R30,LOW(0x751)
	ANDI R31,HIGH(0x751)
	MOVW R16,R30
;    5066 		b=0;
	__GETWRN 18,19,0
;    5067 		for (i=0;i<16;i++)
	__GETWRN 20,21,0
_0x3C9:
	__CPWRN 20,21,16
	BRGE _0x3CA
;    5068 		{
;    5069 			b=b^a;
	__EORWRR 18,19,16,17
;    5070 			b=b & 1;
	__ANDWRN 18,19,1
;    5071 			a>>=1;
	ASR  R17
	ROR  R16
;    5072 
;    5073 		}
	__ADDWRN 20,21,1
	RJMP _0x3C9
_0x3CA:
;    5074 		gshch7<<=1;
	LDS  R30,_gshch7
	LDS  R31,_gshch7+1
	LSL  R30
	ROL  R31
	STS  _gshch7,R30
	STS  _gshch7+1,R31
;    5075 		gshch7=gshch7 | b;	//or
	MOVW R30,R18
	LDS  R26,_gshch7
	LDS  R27,_gshch7+1
	OR   R30,R26
	OR   R31,R27
	STS  _gshch7,R30
	STS  _gshch7+1,R31
;    5076 		a=gshch7 &0xff;
	ANDI R31,HIGH(0xFF)
	MOVW R16,R30
;    5077 		if (a==0) goto gshum7st;
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x3C7
;    5078 }
	RJMP _0x4C5
;    5079 #include "Coding.h"
;    5080 
;    5081 #define ver_po 2					// Версия данного ПО
;    5082 #define pozkl 26					//позиция ключа для совместимости с ver 1.
;    5083 #define kolvo_sektorov 123     
;    5084 
;    5085 #define	p_progf			1
;    5086 #define	p_koderu		3
;    5087 #define	p_kluchi		5
;    5088 #define p_razresh		6
;    5089 #define p_ciklovogo	8
;    5090 #define	p_flagov		9			//пакет флагов
;    5091 
;    5092 // формируем пакет для передачи в линию
;    5093 void packCRC (void)
;    5094 {
_packCRC:
;    5095 		u16 b, crc=0, temp = Start_point_of_Dann_TX_TWI;
;    5096     
;    5097     	txBuffer[temp++] = PACKHDR;		 	// заголовок
	CALL __SAVELOCR6
;	b -> R16,R17
;	crc -> R18,R19
;	temp -> R20,R21
	LDI  R18,0
	LDI  R19,0
	LDI  R20,2
	LDI  R21,0
	MOVW R30,R20
	__ADDWRN 20,21,1
	CALL SUBOPT_0xA6
;    5098 		txBuffer[temp++] = lbuff+3;            		// длина (+3 - тк. вычлось при приеме)
	MOVW R30,R20
	__ADDWRN 20,21,1
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	MOVW R26,R30
	LDI  R30,LOW(239)
	ST   X,R30
;    5099 //		txBuffer[temp++] = 255;                		// адрес
;    5100 		txBuffer[temp++] =Internal_Packet; 		// адрес
	MOVW R30,R20
	__ADDWRN 20,21,1
	CALL SUBOPT_0xA7
;    5101 		txBuffer[temp++] = PT_SCRDATA ;	 	// тип
	MOVW R30,R20
	__ADDWRN 20,21,1
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	MOVW R26,R30
	LDI  R30,LOW(161)
	ST   X,R30
;    5102 
;    5103 		for (b=0; b<=txBuffer[Start_point_of_Dann_TX_TWI+1]; b++)	crc +=txBuffer[Start_point_of_Dann_TX_TWI+b] ;				
	__GETWRN 16,17,0
_0x3CD:
	__GETB1MN _txBuffer,3
	MOVW R26,R16
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x3CE
	MOVW R30,R16
	__ADDW1MN _txBuffer,2
	CALL SUBOPT_0xA8
;    5104 		txBuffer[Start_point_of_Dann_TX_TWI+lbuff+4] = crc;					// CRC
	__ADDWRN 16,17,1
	RJMP _0x3CD
_0x3CE:
	__PUTBMRN _txBuffer,242,18
;    5105 		
;    5106 		// передача в канал
;    5107 		TWI_operation = SEND_DATA; 
	LDI  R30,LOW(1)
	STS  _TWI_operation,R30
;    5108 		while (! RUN_TWI ( TWI_GEN_CALL, TWI_CMD_MASTER_WRITE,
_0x3CF:
;    5109 								 txBuffer[Start_point_of_Dann_TX_TWI+1] +4 ) );
	LDI  R30,LOW(0)
	CALL SUBOPT_0xA9
	__GETB1MN _txBuffer,3
	CALL SUBOPT_0xAA
	BREQ _0x3CF
;    5110 
;    5111 }
_0x4C5:
	CALL __LOADLOCR6
	ADIW R28,6
	RET
;    5112 
;    5113 
;    5114 
;    5115 
;    5116 //генерация пакета koderu
;    5117 void g_p_koderu(void)
;    5118 {
_g_p_koderu:
;    5119 	u16 i,crc=0;
;    5120 	komu=0x25;	//paket koderu
	CALL __SAVELOCR4
;	i -> R16,R17
;	crc -> R18,R19
	LDI  R18,0
	LDI  R19,0
	LDI  R30,LOW(37)
	STS  _komu,R30
;    5121 
;    5122 	for (i=0;i<lbuff;i++)										// заполняем шумом буфер
	__GETWRN 16,17,0
_0x3D3:
	__CPWRN 16,17,236
	BRSH _0x3D4
;    5123 	{
;    5124 		gshum5();
	CALL _gshum5
;    5125 		buff_kazakovu[i]= gshch5 & 0xff;
	__POINTW1MN _txBuffer,6
	ADD  R30,R16
	ADC  R31,R17
	MOVW R26,R30
	CALL SUBOPT_0xAB
;    5126 		if (buff_kazakovu[i]==0x47) buff_kazakovu[i]=0x78;		//na vsjakij sluchaj
	__POINTW1MN _txBuffer,6
	ADD  R30,R16
	ADC  R31,R17
	LD   R30,Z
	CPI  R30,LOW(0x47)
	BRNE _0x3D5
	__POINTW1MN _txBuffer,6
	ADD  R30,R16
	ADC  R31,R17
	MOVW R26,R30
	LDI  R30,LOW(120)
	ST   X,R30
;    5127 	}
_0x3D5:
	__ADDWRN 16,17,1
	RJMP _0x3D3
_0x3D4:
;    5128 
;    5129 	buff_kazakovu[0]=0x47;								// накладываем полезную информацию сверху
	LDI  R30,LOW(71)
	__PUTB1MN _txBuffer,6
;    5130 	buff_kazakovu[1]=0x1f;	//pid h
	LDI  R30,LOW(31)
	__PUTB1MN _txBuffer,7
;    5131 	buff_kazakovu[2]=0xfe;	//pid l
	LDI  R30,LOW(254)
	__PUTB1MN _txBuffer,8
;    5132 
;    5133 
;    5134 //buff_kazakovu[6]=0;	
;    5135     gshch3=buff_kazakovu[6];
	__GETB1MN _txBuffer,12
	LDI  R31,0
	STS  _gshch3,R30
	STS  _gshch3+1,R31
;    5136 
;    5137 	buff_kazakovu[17]=conf3 ^ buff_kazakovu[6];	//config
	__GETB1MN _txBuffer,12
	LDI  R26,LOW(184)
	EOR  R30,R26
	__PUTB1MN _txBuffer,23
;    5138 	buff_kazakovu[11]=komu^buff_kazakovu[6];	//komu
	__GETB1MN _txBuffer,12
	LDS  R26,_komu
	EOR  R30,R26
	__PUTB1MN _txBuffer,17
;    5139 
;    5140 	for (i = 0; i<124; i ++)
	__GETWRN 16,17,0
_0x3D7:
	__CPWRN 16,17,124
	BRSH _0x3D8
;    5141 	{
;    5142 		gshum3();
	CALL _gshum3
;    5143 		buff_kazakovu[i+32] = f_buff_prog[i+1] ^ gshch3;
	__POINTW2MN _txBuffer,6
	MOVW R30,R16
	ADIW R30,32
	CALL SUBOPT_0x7C
	__ADDW1MN _f_buff_prog,1
	MOVW R26,R30
	CALL __EEPROMRDB
	CALL SUBOPT_0xAC
;    5144 		crc+= f_buff_prog[i+1];
	MOVW R30,R16
	__ADDW1MN _f_buff_prog,1
	MOVW R26,R30
	CALL __EEPROMRDB
	CALL SUBOPT_0xAD
;    5145 	}                                       
	__ADDWRN 16,17,1
	RJMP _0x3D7
_0x3D8:
;    5146 
;    5147 	for (i = 0; i<8; i ++)
	__GETWRN 16,17,0
_0x3DA:
	__CPWRN 16,17,8
	BRSH _0x3DB
;    5148 	{
;    5149 		gshum3();
	CALL _gshum3
;    5150 		buff_kazakovu[i+32+124] = kluchi_koderu[i]^gshch3;
	__POINTW2MN _txBuffer,6
	MOVW R30,R16
	ADIW R30,32
	SUBI R30,LOW(-124)
	SBCI R31,HIGH(-124)
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDI  R26,LOW(_kluchi_koderu)
	LDI  R27,HIGH(_kluchi_koderu)
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	LDS  R30,_gshch3
	LDS  R31,_gshch3+1
	EOR  R30,R26
	MOVW R26,R0
	ST   X,R30
;    5151 		crc+=kluchi_koderu[i];   
	LDI  R26,LOW(_kluchi_koderu)
	LDI  R27,HIGH(_kluchi_koderu)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	CALL SUBOPT_0xAD
;    5152 	}
	__ADDWRN 16,17,1
	RJMP _0x3DA
_0x3DB:
;    5153 
;    5154 	crc = -1 -crc;
	CALL SUBOPT_0xAE
;    5155 	gshum3();
	CALL _gshum3
;    5156 
;    5157 	buff_kazakovu[32+124+8] = crc^gshch3;
	LDS  R30,_gshch3
	LDS  R31,_gshch3+1
	EOR  R30,R18
	EOR  R31,R19
	__PUTB1MN _txBuffer,170
;    5158 
;    5159 	packCRC();
	CALL _packCRC
;    5160 }
_0x4C4:
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;    5161 
;    5162 
;    5163 void g_tx_kazakovu(void)
;    5164 {
_g_tx_kazakovu:
;    5165 	u8 i;
;    5166 
;    5167 	for (i=0;i<lbuff;i++)
	ST   -Y,R16
;	i -> R16
	LDI  R16,LOW(0)
_0x3DD:
	CPI  R16,236
	BRSH _0x3DE
;    5168 	{
;    5169 		gshum5();
	CALL _gshum5
;    5170 		buff_kazakovu[i]= (gshch5) & 0xff;
	__POINTW2MN _txBuffer,6
	CALL SUBOPT_0xAF
	CALL SUBOPT_0xAB
;    5171 		if (buff_kazakovu[i]==0x47) buff_kazakovu[i]=0x78;		//na vsjakij sluchaj
	__POINTW2MN _txBuffer,6
	CALL SUBOPT_0xAF
	LD   R26,X
	CPI  R26,LOW(0x47)
	BRNE _0x3DF
	__POINTW2MN _txBuffer,6
	CALL SUBOPT_0xAF
	LDI  R30,LOW(120)
	ST   X,R30
;    5172 	}
_0x3DF:
	SUBI R16,-1
	RJMP _0x3DD
_0x3DE:
;    5173 
;    5174 	buff_kazakovu[0]=0x47;
	LDI  R30,LOW(71)
	__PUTB1MN _txBuffer,6
;    5175 	buff_kazakovu[1]=0x1f;	//pid h
	LDI  R30,LOW(31)
	__PUTB1MN _txBuffer,7
;    5176 	buff_kazakovu[2]=0xfe;	//pid l
	LDI  R30,LOW(254)
	__PUTB1MN _txBuffer,8
;    5177                                           
;    5178 	gshch3=buff_kazakovu[6];
	__GETB1MN _txBuffer,12
	LDI  R31,0
	STS  _gshch3,R30
	STS  _gshch3+1,R31
;    5179 	buff_kazakovu[17]=conf3 ^ buff_kazakovu[6];	//config
	__GETB1MN _txBuffer,12
	LDI  R26,LOW(184)
	EOR  R30,R26
	__PUTB1MN _txBuffer,23
;    5180 	buff_kazakovu[11]=komu^buff_kazakovu[6];	//komu
	__GETB1MN _txBuffer,12
	LDS  R26,_komu
	EOR  R30,R26
	__PUTB1MN _txBuffer,17
;    5181 
;    5182 	for (i = 0; i<188; i ++)
	LDI  R16,LOW(0)
_0x3E1:
	CPI  R16,188
	BRSH _0x3E2
;    5183 	{
;    5184 		gshum3();
	CALL _gshum3
;    5185 		buff_kazakovu[i+32] =buff_wyh_paket[i]^gshch3;
	__POINTW2MN _txBuffer,6
	MOV  R30,R16
	SUBI R30,-LOW(32)
	LDI  R31,0
	CALL SUBOPT_0x64
	LDI  R31,0
	SUBI R30,LOW(-_buff_wyh_paket)
	SBCI R31,HIGH(-_buff_wyh_paket)
	LD   R30,Z
	CALL SUBOPT_0xAC
;    5186 	}
	SUBI R16,-1
	RJMP _0x3E1
_0x3E2:
;    5187 
;    5188 	// Передаю очередной пакет
;    5189 	packCRC();
	CALL _packCRC
;    5190 	
;    5191 }
	RJMP _0x4BE
;    5192 
;    5193 
;    5194 
;    5195 //генерация маскировочного пакета с помощью gshum4
;    5196 void g_jadra_paketa(u8 tip)	
;    5197 {
_g_jadra_paketa:
;    5198 	int i;
;    5199 
;    5200 	for (i=0;i<lbuff;i++)
	ST   -Y,R17
	ST   -Y,R16
;	tip -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x3E4:
	__CPWRN 16,17,236
	BRGE _0x3E5
;    5201 	{
;    5202 		gshum4();
	CALL _gshum4
;    5203 
;    5204 		buff_wyh_paket[i]=gshch4 & 0xff;
	MOVW R26,R16
	SUBI R26,LOW(-_buff_wyh_paket)
	SBCI R27,HIGH(-_buff_wyh_paket)
	LDS  R30,_gshch4
	LDS  R31,_gshch4+1
	ANDI R31,HIGH(0xFF)
	ST   X,R30
;    5205 		if (buff_wyh_paket[i]==0x47) buff_wyh_paket[i]=0x78;		//na vsjakij sluchaj
	LDI  R26,LOW(_buff_wyh_paket)
	LDI  R27,HIGH(_buff_wyh_paket)
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	CPI  R26,LOW(0x47)
	BRNE _0x3E6
	LDI  R26,LOW(_buff_wyh_paket)
	LDI  R27,HIGH(_buff_wyh_paket)
	ADD  R26,R16
	ADC  R27,R17
	LDI  R30,LOW(120)
	ST   X,R30
;    5206 	}
_0x3E6:
	__ADDWRN 16,17,1
	RJMP _0x3E4
_0x3E5:
;    5207 
;    5208 
;    5209 
;    5210 	buff_wyh_paket[0]=0x47;
	LDI  R30,LOW(71)
	STS  _buff_wyh_paket,R30
;    5211 	buff_wyh_paket[1]=0x1f;	//pid h
	LDI  R30,LOW(31)
	__PUTB1MN _buff_wyh_paket,1
;    5212 	buff_wyh_paket[2]=0xfe;	//pid l
	LDI  R30,LOW(254)
	__PUTB1MN _buff_wyh_paket,2
;    5213 	buff_wyh_paket[3]=schetchic_paketov_zakrytija & 0x0f;
	LDS  R30,_schetchic_paketov_zakrytija
	ANDI R30,LOW(0xF)
	__PUTB1MN _buff_wyh_paket,3
;    5214 	schetchic_paketov_zakrytija++;
	LDS  R30,_schetchic_paketov_zakrytija
	SUBI R30,-LOW(1)
	STS  _schetchic_paketov_zakrytija,R30
;    5215 
;    5216 	#ifdef DEBUG_schetchic_paketov_zakrytija
;    5217 	buff_wyh_paket[8]=schetchic_paketov_zakrytija & 0xff;//
;    5218 	#endif DEBUG_schetchic_paketov_zakrytija
;    5219 
;    5220 	buff_wyh_paket[29]=tip ;//					tip
	LDD  R30,Y+2
	__PUTB1MN _buff_wyh_paket,29
;    5221 
;    5222 	i=ver_kl & 0x80;
	LDS  R30,_ver_kl
	LDS  R31,_ver_kl+1
	ANDI R30,LOW(0x80)
	ANDI R31,HIGH(0x80)
	MOVW R16,R30
;    5223 	buff_wyh_paket[23]=((buff_wyh_paket[23] & 0x7f) | i);//версия ключей
	__GETB1MN _buff_wyh_paket,23
	ANDI R30,0x7F
	MOV  R26,R30
	MOVW R30,R16
	OR   R30,R26
	__PUTB1MN _buff_wyh_paket,23
;    5224 
;    5225 	gshch2=buff_wyh_paket[26];
	__GETB1MN _buff_wyh_paket,26
	LDI  R31,0
	STS  _gshch2,R30
	STS  _gshch2+1,R31
;    5226 	g_klucha2();
	CALL _g_klucha2
;    5227 	buff_wyh_paket[17]=ver_po^gshch2 ;
	LDS  R30,_gshch2
	LDS  R31,_gshch2+1
	LDI  R26,LOW(2)
	LDI  R27,HIGH(2)
	EOR  R30,R26
	__PUTB1MN _buff_wyh_paket,17
;    5228 	
;    5229 	i=buff_wyh_paket[7];
	__GETBRMN 16,_buff_wyh_paket,7
	CLR  R17
;    5230 	i=(i & 0x0f)+171;
	MOVW R30,R16
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	SUBI R30,LOW(-171)
	SBCI R31,HIGH(-171)
	MOVW R16,R30
;    5231 	gshch1=buff_wyh_paket[i];
	LDI  R26,LOW(_buff_wyh_paket)
	LDI  R27,HIGH(_buff_wyh_paket)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	LDI  R31,0
	STS  _gshch1,R30
	STS  _gshch1+1,R31
;    5232 	buff_wyh_paket[10]=confkluch1 ^ gshch1;
	LDS  R26,_confkluch1
	LDS  R27,_confkluch1+1
	EOR  R30,R26
	__PUTB1MN _buff_wyh_paket,10
;    5233 			
;    5234 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x4C1
;    5235 
;    5236 
;    5237 void zakrutbuf(u8 tip)
;    5238 {
_zakrutbuf:
;    5239 	u16 i,a=0;
;    5240 
;    5241 	for (i = 0; i<142; i ++)	a=a+buff_wyh_paket[27+i];	//a - crc
	CALL __SAVELOCR4
;	tip -> Y+4
;	i -> R16,R17
;	a -> R18,R19
	LDI  R18,0
	LDI  R19,0
	__GETWRN 16,17,0
_0x3E8:
	__CPWRN 16,17,142
	BRSH _0x3E9
	MOVW R30,R16
	__ADDW1MN _buff_wyh_paket,27
	CALL SUBOPT_0xA8
;    5242 
;    5243 	a=-1-a;
	__ADDWRN 16,17,1
	RJMP _0x3E8
_0x3E9:
	CALL SUBOPT_0xAE
;    5244 	buff_wyh_paket[27+142]=a;
	__PUTBMRN _buff_wyh_paket,169,18
;    5245 	buff_wyh_paket[27+143]=a/256;	//crc
	__PUTBMRN _buff_wyh_paket,170,19
;    5246 
;    5247 	for (i = 0; i<144; i ++)
	__GETWRN 16,17,0
_0x3EB:
	__CPWRN 16,17,144
	BRSH _0x3EC
;    5248 	{
;    5249 
;    5250 		g_klucha1();
	CALL _g_klucha1
;    5251 		buff_wyh_paket[27+i]=buff_wyh_paket[27+i] ^ gshch1 ^ 0xff;
	MOVW R30,R16
	__ADDW1MN _buff_wyh_paket,27
	MOVW R0,R30
	MOVW R30,R16
	__ADDW1MN _buff_wyh_paket,27
	LD   R30,Z
	MOV  R26,R30
	LDS  R30,_gshch1
	LDS  R31,_gshch1+1
	EOR  R30,R26
	LDI  R26,LOW(255)
	LDI  R27,HIGH(255)
	EOR  R30,R26
	EOR  R31,R27
	MOVW R26,R0
	ST   X,R30
;    5252 	}
	__ADDWRN 16,17,1
	RJMP _0x3EB
_0x3EC:
;    5253 
;    5254 	if (tip==9)	buff_wyh_paket[11]=buff_wyh_paket[26]^0x09;			
	LDD  R26,Y+4
	CPI  R26,LOW(0x9)
	BRNE _0x3ED
	__GETB1MN _buff_wyh_paket,26
	LDI  R26,LOW(9)
	EOR  R30,R26
	__PUTB1MN _buff_wyh_paket,11
;    5255 	else	buff_wyh_paket[11]=buff_wyh_paket[26]^0x56;			
	RJMP _0x3EE
_0x3ED:
	__GETB1MN _buff_wyh_paket,26
	LDI  R26,LOW(86)
	EOR  R30,R26
	__PUTB1MN _buff_wyh_paket,11
;    5256    
;    5257 }
_0x3EE:
	RJMP _0x4BF
;    5258 
;    5259 //пакет передачи флагов закрытия программ ///////////////////
;    5260 void g_p_flagov(void)
;    5261 {
_g_p_flagov:
;    5262 	komu=0x27;					//paket v liniju
	LDI  R30,LOW(39)
	STS  _komu,R30
;    5263 	g_jadra_paketa(p_flagov);			//генерация маскировочного пакета и ключей с помощью gshum4
	LDI  R30,LOW(9)
	ST   -Y,R30
	CALL _g_jadra_paketa
;    5264 	zakrutbuf(p_flagov);
	LDI  R30,LOW(9)
	CALL SUBOPT_0xB0
;    5265 	g_tx_kazakovu();
;    5266 }
	RET
;    5267 
;    5268 
;    5269 
;    5270 //генерация пакета абонентам (user.bin)
;    5271 void g_p_razresh(void)	
;    5272 {
_g_p_razresh:
;    5273 	u16 i; 
;    5274 	u32 position = 0;
;    5275 
;    5276 	komu=0x26;	//paket v liniju
	SBIW R28,4
	LDI  R24,4
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x3EF*2)
	LDI  R31,HIGH(_0x3EF*2)
	CALL __INITLOCB
	CALL SUBOPT_0xB1
;	i -> R16,R17
;	position -> Y+2
;    5277 
;    5278 	g_jadra_paketa(p_razresh);//генерация маскировочного пакета и ключей с помощью gshum4
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _g_jadra_paketa
;    5279 
;    5280 	position = ((u32)schetchic_abonentov * (u32)dann_1_abon) + 4;
	LDS  R30,_schetchic_abonentov
	LDS  R31,_schetchic_abonentov+1
	CLR  R22
	CLR  R23
	__GETD2N 0x84
	CALL __MULD12U
	__ADDD1N 4
	__PUTD1S 2
;    5281 	fseek (fu_user,position,SEEK_SET);	// смещаем относительно текущей позиции
	LDS  R30,_fu_user
	LDS  R31,_fu_user+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 4
	CALL __PUTPARD1
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _fseek
;    5282 
;    5283 	for (i = 0; i<dann_1_abon; i ++)
	__GETWRN 16,17,0
_0x3F1:
	__CPWRN 16,17,132
	BRSH _0x3F2
;    5284 	{
;    5285 		if (feof(fu_user)) 
	CALL SUBOPT_0x27
	BRNE _0x3F2
;    5286 		{
;    5287 			#ifdef print
;    5288 			printf("Error read base from card\n");
;    5289 			#endif
;    5290 			break;
;    5291 		}
;    5292 
;    5293 		buff_wyh_paket[i+32] =fgetc(fu_user);
	MOVW R30,R16
	__ADDW1MN _buff_wyh_paket,32
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x23
	POP  R26
	POP  R27
	ST   X,R30
;    5294 //		#ifdef print
;    5295 //		printf("%x ",buff_wyh_paket[i+32]);
;    5296 //		#endif
;    5297 	
;    5298 	}
	__ADDWRN 16,17,1
	RJMP _0x3F1
_0x3F2:
;    5299 //	#ifdef print
;    5300 //	printf("\n -------------------------------------------------------------- \n ");
;    5301 //	#endif
;    5302 
;    5303 	zakrutbuf(p_razresh);
	LDI  R30,LOW(6)
	CALL SUBOPT_0xB0
;    5304 	g_tx_kazakovu();
;    5305 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
;    5306 
;    5307 //генерация пакета в линию
;    5308 void g_p_kluchi(void)	
;    5309 {
_g_p_kluchi:
;    5310 	u16 i;                            
;    5311 	komu=0x26;						//тип пакета - в линию
	CALL SUBOPT_0xB1
;	i -> R16,R17
;    5312 
;    5313 	g_jadra_paketa(p_kluchi);				//генерация маскировочного пакета и ключей с помощью gshum4
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL _g_jadra_paketa
;    5314 
;    5315 	for (i = 0; i<16; i ++)
	__GETWRN 16,17,0
_0x3F5:
	__CPWRN 16,17,16
	BRSH _0x3F6
;    5316 	{
;    5317 		buff_wyh_paket[32+3*i]=kluchi_dekoderu[i];
	MOVW R30,R16
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MULW12U
	__ADDW1MN _buff_wyh_paket,32
	MOVW R0,R30
	LDI  R26,LOW(_kluchi_dekoderu)
	LDI  R27,HIGH(_kluchi_dekoderu)
	CALL SUBOPT_0x6F
;    5318 	}
	__ADDWRN 16,17,1
	RJMP _0x3F5
_0x3F6:
;    5319 	zakrutbuf(p_kluchi);
	LDI  R30,LOW(5)
	CALL SUBOPT_0xB0
;    5320 	g_tx_kazakovu();
;    5321 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;    5322 
;    5323 //пакет об окончании цикла//////////////////////////////
;    5324 void g_p_ciklovogo(void)
;    5325 {
_g_p_ciklovogo:
;    5326 		komu=0x26;	//paket v liniju
	LDI  R30,LOW(38)
	STS  _komu,R30
;    5327 
;    5328 		g_jadra_paketa(p_ciklovogo);//генерация маскировочного пакета и ключей с помощью gshum4
	LDI  R30,LOW(8)
	ST   -Y,R30
	CALL _g_jadra_paketa
;    5329 		zakrutbuf(p_ciklovogo);
	LDI  R30,LOW(8)
	CALL SUBOPT_0xB0
;    5330 		g_tx_kazakovu();
;    5331 
;    5332 }
	RET
;    5333 
;    5334 // генерация пакета прошивки  FLASH для приемников
;    5335 void g_p_progf(void)	
;    5336 {
;    5337 			u16 i;                            
;    5338 
;    5339 			komu=0x26;	//paket v liniju
;	i -> R16,R17
;    5340 
;    5341 			g_jadra_paketa(p_progf);//генерация маскировочного пакета и ключей с помощью gshum4
;    5342 
;    5343 			buff_wyh_paket[21]=(N_sektora^buff_wyh_paket[pozkl])^0xff ;//for old
;    5344 			buff_wyh_paket[19]=(ver_zeleza^buff_wyh_paket[pozkl])^0xff ;//for old
;    5345 
;    5346 			buff_wyh_paket[28]=N_sektora;
;    5347 			buff_wyh_paket[27]=ver_zeleza;
;    5348 
;    5349 //			fseek (fprogflas,N_sektora*128,SEEK_SET);	// смещаем относительно текущей позиции
;    5350 			fseek (fprogflas,0,SEEK_SET);	// смещаем относительно текущей позиции
;    5351 			for (i = 0; i<dann_1_abon; i ++)
;    5352 			{
;    5353 				if (feof(fprogflas)) 
;    5354 				{
;    5355 //					printf ("file MASK.CHM- ERROR!");
;    5356 					break;
;    5357 				}
;    5358 		
;    5359 			buff_wyh_paket[i+32] =fgetc(fprogflas);
;    5360 			}
;    5361 
;    5362 			zakrutbuf(p_progf);
;    5363 	
;    5364 			if (N_sektora<kolvo_sektorov) 	N_sektora++;
;    5365 			else	N_sektora=0;
;    5366 
;    5367 			g_tx_kazakovu();
;    5368 }
;    5369 /*****************************************************************************
;    5370 *
;    5371 * Atmel Corporation
;    5372 *
;    5373 * File              : TWI_Master.c
;    5374 * Compiler          : IAR EWAAVR 2.28a/3.10c
;    5375 * Revision          : $Revision: 1.13 $
;    5376 * Date              : $Date: 24. mai 2004 11:31:20 $
;    5377 * Updated by        : $Author: ltwa $
;    5378 *
;    5379 * Support mail      : avr@atmel.com
;    5380 *
;    5381 * Supported devices : All devices with a TWI module can be used.
;    5382 *                     The example is written for the ATmega16
;    5383 *
;    5384 * AppNote           : AVR315 - TWI Master Implementation
;    5385 *
;    5386 * Description       : This is a sample driver for the TWI hardware modules.
;    5387 *                     It is interrupt driveren. All functionality is controlled through 
;    5388 *                     passing information to and from functions. Se main.c for samples
;    5389 *                     of how to use the driver.
;    5390 *
;    5391 *
;    5392 ****************************************************************************/
;    5393 
;    5394 #include "TWI_Master.h"
;    5395 
;    5396 
;    5397 static unsigned char TWI_buf[ TWI_BUFFER_SIZE ];    // Transceiver buffer

	.DSEG
_TWI_buf_GA:
	.BYTE 0xFF
;    5398 static unsigned char TWI_msgSize;                   // Number of bytes to be transmitted.
_TWI_msgSize_GA:
	.BYTE 0x1
;    5399 static unsigned char TWI_state = TWI_NO_STATE;      // State byte. Default set to TWI_NO_STATE.
_TWI_state_GA:
	.BYTE 0x1
;    5400 
;    5401 //union TWI_statusReg TWI_statusReg = {0};            // TWI_statusReg is defined in TWI_Master.h
;    5402 
;    5403 /****************************************************************************
;    5404 Call this function to set up the TWI master to its initial standby state.
;    5405 Remember to enable interrupts from the main application after initializing the TWI.
;    5406 ****************************************************************************/
;    5407 void TWI_Master_Initialise(void)
;    5408 {

	.CSEG
_TWI_Master_Initialise:
;    5409   TWBR = TWI_TWBR;                                  // Set bit rate register (Baudrate). Defined in header file.
	LDI  R30,LOW(12)
	STS  112,R30
;    5410 // TWSR = TWI_TWPS;                                  // Not used. Driver presumes prescaler to be 00.
;    5411   TWDR = 0xFF;                                      // Default content = SDA released.
	LDI  R30,LOW(255)
	STS  115,R30
;    5412   TWCR = (1<<TWEN)|                                 // Enable TWI-interface and release TWI pins.
;    5413          (0<<TWIE)|(0<<TWINT)|                      // Disable Interupt.
;    5414          (0<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|           // No Signal requests.
;    5415          (0<<TWWC);                                 //
	LDI  R30,LOW(4)
	STS  116,R30
;    5416 }                                                                                                              
	RET
;    5417 
;    5418 
;    5419     
;    5420 /****************************************************************************
;    5421 Call this function to test if the TWI_ISR is busy transmitting.
;    5422 ****************************************************************************/
;    5423 unsigned char TWI_Transceiver_Busy( void )
;    5424 {
_TWI_Transceiver_Busy:
;    5425   return ( TWCR & (1<<TWIE) );                  // IF TWI Interrupt is enabled then the Transceiver is busy
	LDS  R30,116
	ANDI R30,LOW(0x1)
	RET
;    5426 }
;    5427 
;    5428 /****************************************************************************
;    5429 Call this function to fetch the state information of the previous operation. The function will hold execution (loop)
;    5430 until the TWI_ISR has completed with the previous operation. If there was an error, then the function 
;    5431 will return the TWI State code. 
;    5432 ****************************************************************************/
;    5433 unsigned char TWI_Get_State_Info( void )
;    5434 {
_TWI_Get_State_Info:
;    5435   while ( TWI_Transceiver_Busy() );             // Wait until TWI has completed the transmission.
_0x3FE:
	CALL _TWI_Transceiver_Busy
	CPI  R30,0
	BRNE _0x3FE
;    5436   return ( TWI_state );                         // Return error state.
	LDS  R30,_TWI_state_GA
	RET
;    5437 }
;    5438 
;    5439 /****************************************************************************
;    5440 Call this function to send a prepared message. The first byte must contain the slave address and the
;    5441 read/write bit. Consecutive bytes contain the data to be sent, or empty locations for data to be read
;    5442 from the slave. Also include how many bytes that should be sent/read including the address byte.
;    5443 The function will hold execution (loop) until the TWI_ISR has completed with the previous operation,
;    5444 then initialize the next operation and return.
;    5445 	Данная функция вызывается для отправки подготовленного сообщения. Первый байт
;    5446  должен содержать адрес подчиненного устройства и бит выбора операции чтения/записи. 
;    5447  В последующих байтах содержатся передаваемые данные или пустые позиции для считывания 
;    5448  данных из подчиненного устройства. В параметрах также указывается количество 
;    5449  отправляемых/принимаемых байт с учетом адресного байта. Нахождение в теле функции 
;    5450  задерживается до тех пор, пока TWI_ISR завершит обработку предыдущего задания, а затем 
;    5451  инициализируется следующее действие и выполняется возврат в основную программу.
;    5452 ****************************************************************************/
;    5453 void TWI_Start_Transceiver_With_Data( unsigned char *msg, unsigned char msgSize )
;    5454 {
_TWI_Start_Transceiver_With_Data:
;    5455   unsigned char temp;
;    5456 
;    5457   while ( TWI_Transceiver_Busy() );             // Wait until TWI is ready for next transmission.
	ST   -Y,R16
;	*msg -> Y+2
;	msgSize -> Y+1
;	temp -> R16
_0x401:
	CALL _TWI_Transceiver_Busy
	CPI  R30,0
	BRNE _0x401
;    5458 
;    5459   TWI_msgSize = msgSize;                        // Number of data to transmit.
	LDD  R30,Y+1
	STS  _TWI_msgSize_GA,R30
;    5460   TWI_buf[0]  = msg[0];                         // Store slave address with R/W setting.
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X
	STS  _TWI_buf_GA,R30
;    5461   if (!( msg[0] & (TRUE<<TWI_READ_BIT) ))       // If it is a write operation, then also copy data.
	ANDI R30,LOW(0x1)
	BRNE _0x404
;    5462   {
;    5463     for ( temp = 1; temp < msgSize; temp++ )
	LDI  R16,LOW(1)
_0x406:
	LDD  R30,Y+1
	CP   R16,R30
	BRSH _0x407
;    5464       TWI_buf[ temp ] = msg[ temp ];
	CALL SUBOPT_0xB2
	MOVW R0,R30
	CALL SUBOPT_0x53
	CALL SUBOPT_0x94
;    5465   }
	SUBI R16,-1
	RJMP _0x406
_0x407:
;    5466   TWI_statusReg.all = 0;      
_0x404:
	CALL SUBOPT_0xB3
;    5467   TWI_state         = TWI_NO_STATE ;
;    5468   TWCR = (1<<TWEN)|                             // TWI Interface enabled.
;    5469          (1<<TWIE)|(1<<TWINT)|                  // Enable TWI Interupt and clear the flag.
;    5470          (0<<TWEA)|(1<<TWSTA)|(0<<TWSTO)|       // Initiate a START condition.
;    5471          (0<<TWWC);                             //
;    5472 }
	RJMP _0x4C3
;    5473 
;    5474 /****************************************************************************
;    5475 Call this function to resend the last message. The driver will reuse the data previously put in the transceiver buffers.
;    5476 The function will hold execution (loop) until the TWI_ISR has completed with the previous operation,
;    5477 then initialize the next operation and return.
;    5478 ****************************************************************************/
;    5479 void TWI_Start_Transceiver( void )
;    5480 {
_TWI_Start_Transceiver:
;    5481   while ( TWI_Transceiver_Busy() );             // Wait until TWI is ready for next transmission.
_0x408:
	CALL _TWI_Transceiver_Busy
	CPI  R30,0
	BRNE _0x408
;    5482   TWI_statusReg.all = 0;      
	CALL SUBOPT_0xB3
;    5483   TWI_state         = TWI_NO_STATE ;
;    5484   TWCR = (1<<TWEN)|                             // TWI Interface enabled.
;    5485          (1<<TWIE)|(1<<TWINT)|                  // Enable TWI Interupt and clear the flag.
;    5486          (0<<TWEA)|(1<<TWSTA)|(0<<TWSTO)|       // Initiate a START condition.
;    5487          (0<<TWWC);                             //
;    5488 }
	RET
;    5489 
;    5490 /****************************************************************************
;    5491 Call this function to read out the requested data from the TWI transceiver buffer. I.e. first call
;    5492 TWI_Start_Transceiver to send a request for data to the slave. Then Run this function to collect the
;    5493 data when they have arrived. Include a pointer to where to place the data and the number of bytes
;    5494 requested (including the address field) in the function call. The function will hold execution (loop)
;    5495 until the TWI_ISR has completed with the previous operation, before reading out the data and returning.
;    5496 If there was an error in the previous transmission the function will return the TWI error code.
;    5497 ****************************************************************************/
;    5498 unsigned char TWI_Get_Data_From_Transceiver( unsigned char *msg, unsigned char msgSize )
;    5499 {
_TWI_Get_Data_From_Transceiver:
;    5500   unsigned char i;
;    5501 
;    5502   while ( TWI_Transceiver_Busy() );             // Wait until TWI is ready for next transmission.
	ST   -Y,R16
;	*msg -> Y+2
;	msgSize -> Y+1
;	i -> R16
_0x40B:
	CALL _TWI_Transceiver_Busy
	CPI  R30,0
	BRNE _0x40B
;    5503 
;    5504   if( TWI_statusReg.bits.lastTransOK )               // Last transmission competed successfully.              
	LDS  R30,_TWI_statusReg
	ANDI R30,LOW(0x1)
	BREQ _0x40E
;    5505   {                                             
;    5506     for ( i=0; i<msgSize; i++ )                 // Copy data from Transceiver buffer.
	LDI  R16,LOW(0)
_0x410:
	LDD  R30,Y+1
	CP   R16,R30
	BRSH _0x411
;    5507     {
;    5508       msg[ i ] = TWI_buf[ i ];
	CALL SUBOPT_0x53
	CALL SUBOPT_0xB2
	LD   R30,Z
	ST   X,R30
;    5509     }
	SUBI R16,-1
	RJMP _0x410
_0x411:
;    5510   }
;    5511   return( TWI_statusReg.bits.lastTransOK );                                   
_0x40E:
	LDS  R30,_TWI_statusReg
	ANDI R30,LOW(0x1)
_0x4C3:
	LDD  R16,Y+0
	ADIW R28,4
	RET
;    5512 }
;    5513 
;    5514 // 2 Wire bus interrupt service routine
;    5515 /****************************************************************************
;    5516 This function is the Interrupt Service Routine (ISR), and called when the TWI interrupt is triggered;
;    5517 that is whenever a TWI event has occurred. This function should not be called directly from the main
;    5518 application.
;    5519 ****************************************************************************/
;    5520 interrupt [TWI] void TWI_ISR(void)
;    5521 {
_TWI_ISR:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;    5522   static unsigned char TWI_bufPtr;

	.DSEG
_TWI_bufPtr_S80:
	.BYTE 0x1

	.CSEG
;    5523  
;    5524   switch (TWSR)
	LDS  R30,113
;    5525   {
;    5526     case TWI_START:             // START has been transmitted  
	CPI  R30,LOW(0x8)
	BREQ _0x416
;    5527     case TWI_REP_START:         // Repeated START has been transmitted
	CPI  R30,LOW(0x10)
	BRNE _0x417
_0x416:
;    5528       TWI_bufPtr = 0;                                     // Set buffer pointer to the TWI Address location
	LDI  R30,LOW(0)
	STS  _TWI_bufPtr_S80,R30
;    5529     case TWI_MTX_ADR_ACK:       // SLA+W has been tramsmitted and ACK received
	RJMP _0x418
_0x417:
	CPI  R30,LOW(0x18)
	BRNE _0x419
_0x418:
;    5530     case TWI_MTX_DATA_ACK:      // Data byte has been tramsmitted and ACK received
	RJMP _0x41A
_0x419:
	CPI  R30,LOW(0x28)
	BRNE _0x41B
_0x41A:
;    5531       if (TWI_bufPtr < TWI_msgSize)
	LDS  R30,_TWI_msgSize_GA
	LDS  R26,_TWI_bufPtr_S80
	CP   R26,R30
	BRSH _0x41C
;    5532       {
;    5533         TWDR = TWI_buf[TWI_bufPtr++];
	CALL SUBOPT_0xB4
	LD   R30,Z
	STS  115,R30
;    5534         TWCR = (1<<TWEN)|                                 // TWI Interface enabled
;    5535                (1<<TWIE)|(1<<TWINT)|                      // Enable TWI Interupt and clear the flag to send byte
;    5536                (0<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|           //
;    5537                (0<<TWWC);                                 //  
	LDI  R30,LOW(133)
	RJMP _0x4F1
;    5538       }else                    // Send STOP after last byte
_0x41C:
;    5539       {
;    5540         TWI_statusReg.bits.lastTransOK = TRUE;                 // Set status bits to completed successfully. 
	CALL SUBOPT_0xB5
;    5541         TWCR = (1<<TWEN)|                                 // TWI Interface enabled
;    5542                (0<<TWIE)|(1<<TWINT)|                      // Disable TWI Interrupt and clear the flag
;    5543                (0<<TWEA)|(0<<TWSTA)|(1<<TWSTO)|           // Initiate a STOP condition.
;    5544                (0<<TWWC);                                 //
_0x4F1:
	STS  116,R30
;    5545       }
;    5546       break;
	RJMP _0x414
;    5547     case TWI_MRX_DATA_ACK:      // Data byte has been received and ACK tramsmitted
_0x41B:
	CPI  R30,LOW(0x50)
	BRNE _0x41E
;    5548       TWI_buf[TWI_bufPtr++] = TWDR;
	CALL SUBOPT_0xB4
	MOVW R26,R30
	LDS  R30,115
	ST   X,R30
;    5549     case TWI_MRX_ADR_ACK:       // SLA+R has been tramsmitted and ACK received
	RJMP _0x41F
_0x41E:
	CPI  R30,LOW(0x40)
	BRNE _0x420
_0x41F:
;    5550       if (TWI_bufPtr < (TWI_msgSize-1) )                  // Detect the last byte to NACK it.
	LDS  R30,_TWI_msgSize_GA
	SUBI R30,LOW(1)
	LDS  R26,_TWI_bufPtr_S80
	CP   R26,R30
	BRSH _0x421
;    5551       {
;    5552         TWCR = (1<<TWEN)|                                 // TWI Interface enabled
;    5553                (1<<TWIE)|(1<<TWINT)|                      // Enable TWI Interupt and clear the flag to read next byte
;    5554                (1<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|           // Send ACK after reception
;    5555                (0<<TWWC);                                 //  
	LDI  R30,LOW(197)
	RJMP _0x4F2
;    5556       }else                    // Send NACK after next reception
_0x421:
;    5557       {
;    5558         TWCR = (1<<TWEN)|                                 // TWI Interface enabled
;    5559                (1<<TWIE)|(1<<TWINT)|                      // Enable TWI Interupt and clear the flag to read next byte
;    5560                (0<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|           // Send NACK after reception
;    5561                (0<<TWWC);                                 // 
	LDI  R30,LOW(133)
_0x4F2:
	STS  116,R30
;    5562       }    
;    5563       break; 
	RJMP _0x414
;    5564     case TWI_MRX_DATA_NACK:     // Data byte has been received and NACK tramsmitted
_0x420:
	CPI  R30,LOW(0x58)
	BRNE _0x423
;    5565       TWI_buf[TWI_bufPtr] = TWDR;
	LDS  R26,_TWI_bufPtr_S80
	LDI  R27,0
	SUBI R26,LOW(-_TWI_buf_GA)
	SBCI R27,HIGH(-_TWI_buf_GA)
	LDS  R30,115
	ST   X,R30
;    5566       TWI_statusReg.bits.lastTransOK = TRUE;                 // Set status bits to completed successfully. 
	CALL SUBOPT_0xB5
;    5567       TWCR = (1<<TWEN)|                                 // TWI Interface enabled
;    5568              (0<<TWIE)|(1<<TWINT)|                      // Disable TWI Interrupt and clear the flag
;    5569              (0<<TWEA)|(0<<TWSTA)|(1<<TWSTO)|           // Initiate a STOP condition.
;    5570              (0<<TWWC);                                 //
	RJMP _0x4F3
;    5571       break;      
;    5572     case TWI_ARB_LOST:          // Arbitration lost
_0x423:
	CPI  R30,LOW(0x38)
	BRNE _0x424
;    5573       TWCR = (1<<TWEN)|                                 // TWI Interface enabled
;    5574              (1<<TWIE)|(1<<TWINT)|                      // Enable TWI Interupt and clear the flag
;    5575              (0<<TWEA)|(1<<TWSTA)|(0<<TWSTO)|           // Initiate a (RE)START condition.
;    5576              (0<<TWWC);                                 //
	LDI  R30,LOW(165)
	RJMP _0x4F3
;    5577       break;
;    5578     case TWI_MTX_ADR_NACK:      // SLA+W has been tramsmitted and NACK received
_0x424:
	CPI  R30,LOW(0x20)
	BREQ _0x426
;    5579     case TWI_MRX_ADR_NACK:      // SLA+R has been tramsmitted and NACK received    
	CPI  R30,LOW(0x48)
	BRNE _0x427
_0x426:
;    5580     case TWI_MTX_DATA_NACK:     // Data byte has been tramsmitted and NACK received
	RJMP _0x428
_0x427:
	CPI  R30,LOW(0x30)
	BRNE _0x429
_0x428:
;    5581 //    case TWI_NO_STATE              // No relevant state information available; TWINT = “0”
;    5582     case TWI_BUS_ERROR:         // Bus error due to an illegal START or STOP condition
	RJMP _0x42A
_0x429:
	CPI  R30,0
	BRNE _0x42C
_0x42A:
;    5583     default:     
_0x42C:
;    5584       TWI_state = TWSR;                                 // Store TWSR and automatically sets clears noErrors bit.
	LDS  R30,113
	STS  _TWI_state_GA,R30
;    5585                                                         // Reset TWI Interface
;    5586       TWCR = (1<<TWEN)|                                 // Enable TWI-interface and release TWI pins
;    5587              (0<<TWIE)|(0<<TWINT)|                      // Disable Interupt
;    5588              (0<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|           // No Signal requests
;    5589              (0<<TWWC);                                 //
	LDI  R30,LOW(4)
_0x4F3:
	STS  116,R30
;    5590   }
_0x414:
;    5591 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;    5592 ////////////////////////////////////////////////////////
;    5593 // Функции работы с TWI
;    5594 
;    5595 #include "coding.h"
;    5596 
;    5597 
;    5598 // Считаем CRC пакета
;    5599 unsigned char calc_CRC (unsigned char *Position_in_Packet)
;    5600 {                    
_calc_CRC:
;    5601 	unsigned char CRC = 0, a;                                   
;    5602 
;    5603 	a = *Position_in_Packet ;
	ST   -Y,R17
	ST   -Y,R16
;	*Position_in_Packet -> Y+2
;	CRC -> R16
;	a -> R17
	LDI  R16,0
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R17,X
;    5604 	
;    5605 	while(a--)
_0x42D:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x42F
;    5606 	{
;    5607 		CRC += *Position_in_Packet++;
	CALL SUBOPT_0xB6
	ADD  R16,R30
;    5608 	}
	RJMP _0x42D
_0x42F:
;    5609 
;    5610 	return CRC;
	MOV  R30,R16
	RJMP _0x4C2
;    5611 }
;    5612 
;    5613 
;    5614 // считаем КС принятого пакета. Указатель - на байт длины пакета.
;    5615 unsigned char check_RX_CRC_TWI (unsigned char *Position_in_Packet)
;    5616 {                    
_check_RX_CRC_TWI:
;    5617 	unsigned char CRC = 0, a;		
;    5618 
;    5619 	a = *Position_in_Packet ;
	ST   -Y,R17
	ST   -Y,R16
;	*Position_in_Packet -> Y+2
;	CRC -> R16
;	a -> R17
	LDI  R16,0
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R17,X
;    5620 	
;    5621 	while(a--)
_0x430:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x432
;    5622 	{
;    5623 		CRC += *Position_in_Packet++;
	CALL SUBOPT_0xB6
	ADD  R16,R30
;    5624 	}
	RJMP _0x430
_0x432:
;    5625 
;    5626 	if (CRC == *Position_in_Packet)	
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X
	CP   R30,R16
	BRNE _0x433
;    5627 			return TRUE; 										//Ok
	LDI  R30,LOW(1)
	RJMP _0x4C2
;    5628 
;    5629 	else	return FALSE;                                      // Error
_0x433:
	LDI  R30,LOW(0)
;    5630 }
_0x4C2:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
;    5631 
;    5632 
;    5633 unsigned char TWI_Act_On_Failure_In_Last_Transmission ( unsigned char TWIerrorMsg )
;    5634 {
_TWI_Act_On_Failure_In_Last_Transmission:
;    5635                     // A failure has occurred, use TWIerrorMsg to determine the nature of the failure
;    5636                     // and take appropriate actions.
;    5637                     // Se header file for a list of possible failures messages.
;    5638                     
;    5639                     // Here is a simple sample, where if received a NACK on the slave address,
;    5640                     // then a retransmission will be initiated.
;    5641  
;    5642   if ( (TWIerrorMsg == TWI_MTX_ADR_NACK) | (TWIerrorMsg == TWI_MRX_ADR_NACK) )
	LD   R26,Y
	LDI  R30,LOW(32)
	CALL __EQB12
	MOV  R0,R30
	LDI  R30,LOW(72)
	CALL __EQB12
	OR   R30,R0
	BREQ _0x435
;    5643     TWI_Start_Transceiver();
	CALL _TWI_Start_Transceiver
;    5644     
;    5645   return TWIerrorMsg; 
_0x435:
	LD   R30,Y
	RJMP _0x4C0
;    5646 }
;    5647 
;    5648 
;    5649 // Исполняем команды TWI
;    5650 u8 RUN_TWI (u8 TWI_targetSlaveAddress, u8 TWI_sendCommand,	u8 Count_Bytes )
;    5651 {
_RUN_TWI:
;    5652 
;    5653 	    if ( ! TWI_Transceiver_Busy() )                              
	CALL _TWI_Transceiver_Busy
	CPI  R30,0
	BRNE _0x436
;    5654 	    {
;    5655     	// Check if the last operation was successful
;    5656 	      if ( TWI_statusReg.bits.lastTransOK )
	LDS  R30,_TWI_statusReg
	ANDI R30,LOW(0x1)
	BREQ _0x437
;    5657     	  {
;    5658 			LedGreen ();			// TWI   в норме
	SBI  0x1A,0
	SBI  0x1A,1
	SBI  0x1B,0
	CBI  0x1B,1
;    5659 			
;    5660 	        if (TWI_operation == SEND_DATA)
	LDS  R26,_TWI_operation
	CPI  R26,LOW(0x1)
	BRNE _0x438
;    5661 	        { // Send data to slave
;    5662     	      txBuffer[0] = (TWI_targetSlaveAddress<<TWI_ADR_BITS) | (FALSE<<TWI_READ_BIT);
	LDD  R30,Y+2
	LSL  R30
	STS  _txBuffer,R30
;    5663 			  txBuffer[1] = TWI_sendCommand;             // The first byte is used for commands.
	LDD  R30,Y+1
	__PUTB1MN _txBuffer,1
;    5664 
;    5665         	  TWI_Start_Transceiver_With_Data( txBuffer, Count_Bytes ); 
	CALL SUBOPT_0xB7
;    5666         	}  
;    5667 
;    5668 	        else if (TWI_operation == REQUEST_DATA)
	RJMP _0x439
_0x438:
	LDS  R26,_TWI_operation
	CPI  R26,LOW(0x2)
	BRNE _0x43A
;    5669     	    { // Request data from slave
;    5670         	  txBuffer[0] = (TWI_targetSlaveAddress<<TWI_ADR_BITS) | (TRUE<<TWI_READ_BIT);
	LDD  R30,Y+2
	LSL  R30
	ORI  R30,1
	STS  _txBuffer,R30
;    5671         	  TWI_Start_Transceiver_With_Data( txBuffer, Count_Bytes );
	CALL SUBOPT_0xB7
;    5672 	        }
;    5673 
;    5674     	    else if (TWI_operation == READ_DATA_FROM_BUFFER)
	RJMP _0x43B
_0x43A:
	LDS  R26,_TWI_operation
	CPI  R26,LOW(0x3)
	BRNE _0x43C
;    5675         	{ // Get the received data from the transceiver buffer
;    5676 	          TWI_Get_Data_From_Transceiver( rxBuffer, Count_Bytes ); // число принятых байт с учетом адреса 	
	LDI  R30,LOW(_rxBuffer)
	LDI  R31,HIGH(_rxBuffer)
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _TWI_Get_Data_From_Transceiver
;    5677 	        }
;    5678 			return TRUE;
_0x43C:
_0x43B:
_0x439:
	LDI  R30,LOW(1)
	RJMP _0x4C1
;    5679     	  }
;    5680 	      else // Got an error during the last transmission
_0x437:
;    5681     	  {
;    5682         	// Use TWI status information to detemine cause of failure and take appropriate actions. 
;    5683 	        TWI_Act_On_Failure_In_Last_Transmission( TWI_Get_State_Info( ) );
	CALL _TWI_Get_State_Info
	ST   -Y,R30
	CALL _TWI_Act_On_Failure_In_Last_Transmission
;    5684 			LedRed ();			// авария TWI
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,0
	SBI  0x1B,1
;    5685     	  }
;    5686 	    }
;    5687 		return FALSE;		// идет передача
_0x436:
	LDI  R30,LOW(0)
_0x4C1:
	ADIW R28,3
	RET
;    5688  }
;    5689 
;    5690 
;    5691 //    разблокировка подч.портов
;    5692 	void unlock_Pack (u8 TWI_targetSlaveAddress)
;    5693 	{
_unlock_Pack:
;    5694 		u8 temp = Start_point_of_Dann_TX_TWI;	
;    5695 	
;    5696 		// собираем все 
;    5697 		txBuffer[temp++] = PACKHDR;				// заголовок
	ST   -Y,R16
;	TWI_targetSlaveAddress -> Y+1
;	temp -> R16
	LDI  R16,2
	MOV  R30,R16
	SUBI R16,-1
	LDI  R31,0
	CALL SUBOPT_0xA6
;    5698 		txBuffer[temp++] = 4; 			           		// длина
	MOV  R30,R16
	SUBI R16,-1
	CALL SUBOPT_0xB8
	LDI  R30,LOW(4)
	ST   X,R30
;    5699 		txBuffer[temp++] = Internal_Packet;        	// адрес
	MOV  R30,R16
	SUBI R16,-1
	LDI  R31,0
	CALL SUBOPT_0xA7
;    5700 		txBuffer[temp++] = PT_PORT_UNLOCK; 	// тип
	MOV  R30,R16
	SUBI R16,-1
	CALL SUBOPT_0xB8
	LDI  R30,LOW(174)
	ST   X,R30
;    5701 		txBuffer[temp++] = TRUE;						// данные
	MOV  R30,R16
	SUBI R16,-1
	CALL SUBOPT_0xB8
	LDI  R30,LOW(1)
	ST   X,R30
;    5702 		txBuffer[temp++] = calc_CRC (&txBuffer[Start_point_of_Dann_TX_TWI+1]) + txBuffer[Start_point_of_Dann_TX_TWI];		//CRC
	MOV  R30,R16
	SUBI R16,-1
	LDI  R31,0
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	PUSH R31
	PUSH R30
	__POINTW1MN _txBuffer,3
	ST   -Y,R31
	ST   -Y,R30
	CALL _calc_CRC
	MOV  R26,R30
	__GETB1MN _txBuffer,2
	ADD  R30,R26
	POP  R26
	POP  R27
	ST   X,R30
;    5703 
;    5704 		// передаем
;    5705 		TWI_operation = SEND_DATA; // Set next operation        
	LDI  R30,LOW(1)
	STS  _TWI_operation,R30
;    5706 		while (! RUN_TWI ( TWI_targetSlaveAddress, TWI_CMD_MASTER_WRITE, txBuffer[Start_point_of_Dann_TX_TWI+1] + 4 ) );
_0x43E:
	LDD  R30,Y+1
	CALL SUBOPT_0xA9
	__GETB1MN _txBuffer,3
	CALL SUBOPT_0xAA
	BREQ _0x43E
;    5707 		
;    5708 		#ifdef print
;    5709 		printf ("Unlock PORT %d \r\n",TWI_targetSlaveAddress);
;    5710 		#endif
;    5711 
;    5712      }
	LDD  R16,Y+0
	ADIW R28,2
	RET
;    5713 
;    5714 
;    5715 // пингуем подчиненное для проверки информации. Если приняты данные без ошибок - 
;    5716 // отправляем подтверждение приема.
;    5717 // 
;    5718 unsigned char pingPack (unsigned char TWI_targetSlaveAddress)
;    5719 {
_pingPack:
;    5720 		// пусть готовит данные
;    5721 		TWI_operation = SEND_DATA; // Set next operation        
	LDI  R30,LOW(1)
	STS  _TWI_operation,R30
;    5722 		while (! RUN_TWI ( TWI_targetSlaveAddress, TWI_CMD_MASTER_READ, 2 ) );
_0x441:
	LD   R30,Y
	ST   -Y,R30
	LDI  R30,LOW(32)
	CALL SUBOPT_0xB9
	BREQ _0x441
;    5723    
;    5724 		// принимаю данные
;    5725 		TWI_operation = REQUEST_DATA; // Set next operation        
	LDI  R30,LOW(2)
	STS  _TWI_operation,R30
;    5726 		while (! RUN_TWI (TWI_targetSlaveAddress, 0, 1 ) );
_0x444:
	CALL SUBOPT_0xBA
	ST   -Y,R30
	LDI  R30,LOW(1)
	CALL SUBOPT_0xBB
	BREQ _0x444
;    5727 
;    5728         TWI_operation = READ_DATA_FROM_BUFFER; // Set next operation        
	LDI  R30,LOW(3)
	STS  _TWI_operation,R30
;    5729 		while (! RUN_TWI (TWI_targetSlaveAddress, 0, 2) );
_0x447:
	CALL SUBOPT_0xBA
	CALL SUBOPT_0xB9
	BREQ _0x447
;    5730 		
;    5731 		
;    5732 		// Есть данные на передачу. Принимаем и
;    5733 		// если данные  приняты без ошибок - высылаем подтверждение
;    5734 		
;    5735 		if ( rxBuffer [1] )		
	__GETB1MN _rxBuffer,1
	CPI  R30,0
	BREQ _0x44A
;    5736 		{
;    5737 			// принимаю данные
;    5738 			TWI_operation = REQUEST_DATA; // Set next operation        
	LDI  R30,LOW(2)
	STS  _TWI_operation,R30
;    5739 			while (! RUN_TWI (TWI_targetSlaveAddress, 0, rxBuffer [1]+2 ) );
_0x44B:
	CALL SUBOPT_0xBA
	ST   -Y,R30
	__GETB1MN _rxBuffer,1
	SUBI R30,-LOW(2)
	CALL SUBOPT_0xBB
	BREQ _0x44B
;    5740 
;    5741 	        TWI_operation = READ_DATA_FROM_BUFFER; // Set next operation        
	LDI  R30,LOW(3)
	STS  _TWI_operation,R30
;    5742 			while (! RUN_TWI (TWI_targetSlaveAddress, 0, rxBuffer [1] +2) );
_0x44E:
	CALL SUBOPT_0xBA
	ST   -Y,R30
	__GETB1MN _rxBuffer,1
	SUBI R30,-LOW(2)
	CALL SUBOPT_0xBB
	BREQ _0x44E
;    5743 
;    5744 			// проверяем КС
;    5745 			if ( check_RX_CRC_TWI ( &rxBuffer[1] ) )
	__POINTW1MN _rxBuffer,1
	ST   -Y,R31
	ST   -Y,R30
	CALL _check_RX_CRC_TWI
	CPI  R30,0
	BREQ _0x451
;    5746 			{//  подтверждение приема
;    5747 				TWI_operation = SEND_DATA; // Set next operation        
	LDI  R30,LOW(1)
	STS  _TWI_operation,R30
;    5748 				while (! RUN_TWI (TWI_targetSlaveAddress, TWI_CMD_MASTER_RECIVE_PACK_OK, 2 ) );
_0x452:
	LD   R30,Y
	ST   -Y,R30
	LDI  R30,LOW(33)
	CALL SUBOPT_0xB9
	BREQ _0x452
;    5749 				
;    5750 				return TRUE;
	LDI  R30,LOW(1)
	RJMP _0x4C0
;    5751 			}
;    5752 		                      
;    5753 		}	
_0x451:
;    5754 		return FALSE;
_0x44A:
	LDI  R30,LOW(0)
_0x4C0:
	ADIW R28,1
	RET
;    5755 }	
;    5756  
;    5757  
;    5758 
;    5759 void	Relay_pack_from_UART_to_TWI (u8 TWI_targetSlaveAddress)
;    5760 {    
_Relay_pack_from_UART_to_TWI:
;    5761 		u8 a, b=0, CRC=0, temp = Start_point_of_Dann_TX_TWI;	
;    5762 		
;    5763 //		temp = Start_point_of_Dann_TX_TWI;	
;    5764 	
;    5765 		// собираем все 
;    5766 		txBuffer[temp++] = PACKHDR;				// заголовок
	CALL __SAVELOCR4
;	TWI_targetSlaveAddress -> Y+4
;	a -> R16
;	b -> R17
;	CRC -> R18
;	temp -> R19
	LDI  R17,0
	LDI  R18,0
	LDI  R19,2
	MOV  R30,R19
	SUBI R19,-1
	LDI  R31,0
	CALL SUBOPT_0xA6
;    5767 		txBuffer[temp++] = rx0len+3;            		// длина (+3 - тк. вычлось при приеме)
	MOV  R30,R19
	SUBI R19,-1
	CALL SUBOPT_0xB8
	LDS  R30,_rx0len
	SUBI R30,-LOW(3)
	ST   X,R30
;    5768 		txBuffer[temp++] = rx0addr;                 	// адрес
	MOV  R30,R19
	SUBI R19,-1
	LDI  R31,0
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	MOVW R26,R30
	LDS  R30,_rx0addr
	ST   X,R30
;    5769 		txBuffer[temp++] = rx0type;					// тип
	MOV  R30,R19
	SUBI R19,-1
	LDI  R31,0
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	MOVW R26,R30
	LDS  R30,_rx0type
	ST   X,R30
;    5770 
;    5771 		for (a=0; a<=rx0len;  a++)
	LDI  R16,LOW(0)
_0x456:
	LDS  R30,_rx0len
	CP   R30,R16
	BRLO _0x457
;    5772 		{
;    5773 			txBuffer[temp++] = rx0buf 	[b++];				
	MOV  R30,R19
	SUBI R19,-1
	CALL SUBOPT_0xB8
	MOV  R30,R17
	SUBI R17,-1
	CALL SUBOPT_0x18
	ST   X,R30
;    5774 		}                   
	SUBI R16,-1
	RJMP _0x456
_0x457:
;    5775 
;    5776 		// передаем
;    5777 		TWI_operation = SEND_DATA; // Set next operation        
	LDI  R30,LOW(1)
	STS  _TWI_operation,R30
;    5778 		while (! RUN_TWI ( TWI_targetSlaveAddress, TWI_CMD_MASTER_WRITE, txBuffer[Start_point_of_Dann_TX_TWI+1] + 4 ) );
_0x458:
	LDD  R30,Y+4
	CALL SUBOPT_0xA9
	__GETB1MN _txBuffer,3
	CALL SUBOPT_0xAA
	BREQ _0x458
;    5779 
;    5780 }
	RJMP _0x4BF
;    5781 
;    5782 // Ретрансляция пакета подчиненному процессору
;    5783 // Глобальная передача всем подчиненным
;    5784 //u8	Relay_pack_from_UART_to_TWI_Internal (void)
;    5785 u8	Relay_pack_from_UART_to_TWI_Internal (u8 Target_Reciver_Addr)
;    5786 {    
_Relay_pack_from_UART_to_TWI_Internal:
;    5787 		u8 a, b=1, temp=Start_point_of_Dann_TX_TWI, CRC;
;    5788 //									 Target_Reciver_Addr;
;    5789 
;    5790 //		Target_Reciver_Addr = rx0buf [0]+offset;			// адрес приемника
;    5791 
;    5792 		// пакет ВСЕМ
;    5793 		if ( ( Target_Reciver_Addr == 255 ) || ( Target_Reciver_Addr == 254 )  )
	CALL __SAVELOCR4
;	Target_Reciver_Addr -> Y+4
;	a -> R16
;	b -> R17
;	temp -> R18
;	CRC -> R19
	LDI  R17,1
	LDI  R18,2
	LDD  R26,Y+4
	CPI  R26,LOW(0xFF)
	BREQ _0x45C
	CPI  R26,LOW(0xFE)
	BRNE _0x45B
_0x45C:
;    5794 													  	Target_Reciver_Addr = TWI_GEN_CALL;
	LDI  R30,LOW(0)
	STD  Y+4,R30
;    5795 
;    5796 		// адрес выходит за диапазон рабочих адресов?
;    5797 //	 	if (  Target_Reciver_Addr > int_Devices+offset )  		return FALSE;		
;    5798 	 	if (  Target_Reciver_Addr > int_Devices )  		return FALSE;		
_0x45B:
	LDI  R30,LOW(_int_Devices*2)
	LDI  R31,HIGH(_int_Devices*2)
	LPM  R30,Z
	LDD  R26,Y+4
	CP   R30,R26
	BRSH _0x45E
	LDI  R30,LOW(0)
	RJMP _0x4BF
;    5799 
;    5800 		// собираем все 
;    5801 
;    5802 		txBuffer[temp++] = PACKHDR;				// заголовок
_0x45E:
	MOV  R30,R18
	SUBI R18,-1
	LDI  R31,0
	CALL SUBOPT_0xA6
;    5803 		CRC =  txBuffer[temp - 1];
	CALL SUBOPT_0xBC
	LD   R19,Z
;    5804 		
;    5805 		txBuffer[temp++] = rx0len+1;            		// длина 
	MOV  R30,R18
	SUBI R18,-1
	CALL SUBOPT_0xB8
	LDS  R30,_rx0len
	SUBI R30,-LOW(1)
	ST   X,R30
;    5806         CRC+=  txBuffer[temp - 1];
	CALL SUBOPT_0xBC
	LD   R30,Z
	ADD  R19,R30
;    5807         
;    5808 		if ( ! Target_Reciver_Addr )
	LDD  R30,Y+4
	CPI  R30,0
	BRNE _0x45F
;    5809 		{
;    5810 		 	txBuffer[temp++] = Global_Packet;			// подменяем адрес на глобальный (255).
	MOV  R30,R18
	SUBI R18,-1
	CALL SUBOPT_0xB8
	LDI  R30,LOW(255)
	RJMP _0x4F4
;    5811 		}
;    5812 		else 	txBuffer[temp++] = Internal_Packet;			// подменяем адрес на внутренний. (0).
_0x45F:
	MOV  R30,R18
	SUBI R18,-1
	CALL SUBOPT_0xB8
	LDI  R30,LOW(0)
_0x4F4:
	ST   X,R30
;    5813         CRC+=  txBuffer[temp - 1];
	CALL SUBOPT_0xBC
	LD   R30,Z
	ADD  R19,R30
;    5814 
;    5815 		
;    5816 		for (a=0; a<rx0len-1;  a++)
	LDI  R16,LOW(0)
_0x462:
	LDS  R30,_rx0len
	SUBI R30,LOW(1)
	CP   R16,R30
	BRSH _0x463
;    5817 		{
;    5818 	        CRC+= rx0buf [b];
	MOV  R30,R17
	CALL SUBOPT_0x18
	ADD  R19,R30
;    5819 			txBuffer[temp++] = rx0buf 	[b++];				
	MOV  R30,R18
	SUBI R18,-1
	CALL SUBOPT_0xB8
	MOV  R30,R17
	SUBI R17,-1
	CALL SUBOPT_0x18
	ST   X,R30
;    5820 		}   
	SUBI R16,-1
	RJMP _0x462
_0x463:
;    5821 		
;    5822 		txBuffer[temp++] = CRC;
	MOV  R30,R18
	SUBI R18,-1
	LDI  R31,0
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	ST   Z,R19
;    5823 
;    5824 		// передаем по адресу ретранслируемого пакета. В самом пакете подменяем адрес на 0-
;    5825 		// признак внутреннего пакета  
;    5826 		TWI_operation = SEND_DATA; // Set next operation        
	LDI  R30,LOW(1)
	STS  _TWI_operation,R30
;    5827 		while (! RUN_TWI ( Target_Reciver_Addr, TWI_CMD_MASTER_WRITE,
_0x464:
;    5828 								 txBuffer[Start_point_of_Dann_TX_TWI+1] +4 ) );
	LDD  R30,Y+4
	CALL SUBOPT_0xA9
	__GETB1MN _txBuffer,3
	CALL SUBOPT_0xAA
	BREQ _0x464
;    5829 		return TRUE;					 
	LDI  R30,LOW(1)
_0x4BF:
	CALL __LOADLOCR4
	ADIW R28,5
	RET
;    5830 }
;    5831 
;    5832  // поиск порта  и передача пакета в порт
;    5833 u8 Searching_Port_for_Relay (void)
;    5834 {
_Searching_Port_for_Relay:
;    5835 		u8 a;
;    5836 		
;    5837 		for (a=1; a<= int_Devices; a++)				// ищем порт по адресу
	ST   -Y,R16
;	a -> R16
	LDI  R16,LOW(1)
_0x468:
	LDI  R30,LOW(_int_Devices*2)
	LDI  R31,HIGH(_int_Devices*2)
	LPM  R30,Z
	CP   R30,R16
	BRLO _0x469
;    5838 		{
;    5839 				#ifdef print
;    5840 				printf ("Found PORT-%x, Device-%x\r\n", a, lAddrDevice [a]);
;    5841 				#endif
;    5842 
;    5843 		 	if (lAddrDevice [a]	== rx0addr)
	CALL SUBOPT_0x14
	LDS  R26,_rx0addr
	CP   R30,R26
	BRNE _0x46A
;    5844 		 	{
;    5845 				LedRed();
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,0
	SBI  0x1B,1
;    5846 				Relay_pack_from_UART_to_TWI ( a );
	ST   -Y,R16
	CALL _Relay_pack_from_UART_to_TWI
;    5847 				return TRUE;
	LDI  R30,LOW(1)
	RJMP _0x4BE
;    5848 		 	}
;    5849 		}
_0x46A:
	SUBI R16,-1
	RJMP _0x468
_0x469:
;    5850 
;    5851 		return FALSE;
	LDI  R30,LOW(0)
_0x4BE:
	LD   R16,Y+
	RET
;    5852 }

_getchar:
     sbis usr,rxc
     rjmp _getchar
     in   r30,udr
	RET
_putchar:
     sbis usr,udre
     rjmp _putchar
     ld   r30,y
     out  udr,r30
	ADIW R28,1
	RET
_allocate_block_GD:
	SBIW R28,2
	CALL __SAVELOCR6
	__GETWRN 16,17,3152
	MOVW R26,R16
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x4AA:
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x4AC
	MOVW R26,R16
	CALL __GETW1P
	ADD  R30,R16
	ADC  R31,R17
	ADIW R30,4
	MOVW R20,R30
	RCALL SUBOPT_0xBD
	SBIW R30,0
	BREQ _0x4AD
	__PUTWSR 18,19,6
	RJMP _0x4AE
_0x4AD:
	LDI  R30,LOW(4352)
	LDI  R31,HIGH(4352)
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x4AE:
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
	BRLO _0x4AF
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
	RJMP _0x4BD
_0x4AF:
	__MOVEWRR 16,17,18,19
	RJMP _0x4AA
_0x4AC:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x4BD:
	CALL __LOADLOCR6
	ADIW R28,10
	RET
_find_prev_block_GD:
	CALL __SAVELOCR4
	__GETWRN 16,17,3152
_0x4B0:
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x4B2
	RCALL SUBOPT_0xBD
	MOVW R26,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x4B3
	MOVW R30,R16
	RJMP _0x4BC
_0x4B3:
	__MOVEWRR 16,17,18,19
	RJMP _0x4B0
_0x4B2:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x4BC:
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
	JMP _0x4B4
	SBIW R30,4
	MOVW R16,R30
	ST   -Y,R17
	ST   -Y,R16
	RCALL _find_prev_block_GD
	MOVW R18,R30
	SBIW R30,0
	BREQ _0x4B5
	MOVW R26,R16
	ADIW R26,2
	CALL __GETW1P
	__PUTW1RNS 18,2
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SBIW R30,0
	BREQ _0x4B6
	ST   -Y,R31
	ST   -Y,R30
	RCALL _allocate_block_GD
	MOVW R20,R30
	SBIW R30,0
	BREQ _0x4B7
	MOVW R26,R16
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	MOVW R26,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x4B8
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	STD  Y+8,R30
	STD  Y+8+1,R31
_0x4B8:
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
	RJMP _0x4BB
_0x4B7:
	MOVW R30,R16
	__PUTW1RNS 18,2
_0x4B6:
_0x4B5:
_0x4B4:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x4BB:
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
	BREQ _0x4B9
	ST   -Y,R31
	ST   -Y,R30
	RCALL _allocate_block_GD
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x4BA
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
_0x4BA:
_0x4B9:
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
	RCALL _realloc
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x0:
	ST   -Y,R30
	CALL _putchar0
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _putchar0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x1:
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2:
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL _putchar0
	JMP  _EndReply

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _putchar0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4:
	SUBI R30,-LOW(1)
	ST   -Y,R30
	JMP  _putchar0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x5:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _StartReply

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6:
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _putchar0
	JMP  _EndReply

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x7:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x8:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _open_user_bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x9:
	ANDI R30,LOW(0x1)
	MOV  R26,R30
	MOV  R30,R17
	SUBI R30,LOW(1)
	CALL __LSLB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xA:
	MOV  R30,R17
	SUBI R30,LOW(1)
	LDI  R26,LOW(1)
	CALL __LSLB12
	LDI  R26,LOW(255)
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0xB:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _Reply

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xC:
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _Relay_pack_from_UART_to_TWI
	CLR  R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xD:
	LD   R30,Y
	ST   -Y,R30
	JMP  _putchar0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xE:
	LDS  R30,_rx0ptr
	SUBI R30,-LOW(1)
	STS  _rx0ptr,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_rx0buf)
	SBCI R31,HIGH(-_rx0buf)
	ST   Z,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xF:
	IN   R30,0x37
	ANDI R30,0xEF
	OUT  0x37,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x10:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x11:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x12:
	EOR  R30,R26
	OUT  0x37,R30
	LDS  R30,125
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x13:
	LDI  R30,LOW(0)
	STS  139,R30
	LDI  R30,LOW(5)
	STS  138,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x14:
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_lAddrDevice)
	SBCI R31,HIGH(-_lAddrDevice)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x15:
	LD   R26,Y
	LDI  R27,0
	SUBI R26,LOW(-_lAddrDevice)
	SBCI R27,HIGH(-_lAddrDevice)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x16:
	LD   R30,Y
	SUBI R30,LOW(1)
	LDI  R26,LOW(1)
	CALL __LSLB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x17:
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
	SBIW R30,1
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x18:
	LDI  R31,0
	SUBI R30,LOW(-_rx0buf)
	SBCI R31,HIGH(-_rx0buf)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x19:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R30,X+
	STD  Y+4,R26
	STD  Y+4+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0x1A:
	ST   -Y,R30
	LDS  R30,_fu_user
	LDS  R31,_fu_user+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _fputc
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1B:
	LDS  R30,_fu_user
	LDS  R31,_fu_user+1
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _fseek
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1C:
	__SUBD1N 1
	__GETD2N 0x84
	CALL __MULD12U
	__ADDD1N 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1D:
	LDS  R30,_fu_user
	LDS  R31,_fu_user+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  _ftell

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1E:
	ST   -Y,R30
	LDS  R30,_fu_user
	LDS  R31,_fu_user+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  _fputc

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1F:
	CALL __PUTPARD1
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _fseek
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x20:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x21:
	CALL _fopenc
	STS  _fu_user,R30
	STS  _fu_user+1,R31
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x22:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES
SUBOPT_0x23:
	LDS  R30,_fu_user
	LDS  R31,_fu_user+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  _fgetc

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x24:
	MOV  R31,R30
	LDI  R30,0
	__GETD2S 4
	CALL __CWD1
	CALL __ORD12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x25:
	ST   -Y,R30
	CALL _putchar0
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x26:
	CALL __LSRD12
	ST   -Y,R30
	JMP  _putchar0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x27:
	LDS  R30,_fu_user
	LDS  R31,_fu_user+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _feof
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x28:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __MULW12U
	ADD  R30,R22
	ADC  R31,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x29:
	CALL __FF_spi
	LDD  R26,Y+14
	CLR  R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2A:
	CALL __LSRD12
	MOV  R16,R30
	ST   -Y,R16
	CALL __FF_spi
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2B:
	MOV  R16,R30
	ST   -Y,R16
	JMP  __FF_spi

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0x2C:
	CALL __FF_spi
	LDI  R30,LOW(255)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES
SUBOPT_0x2D:
	LDI  R30,LOW(255)
	ST   -Y,R30
	JMP  __FF_spi

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x2E:
	CLR  R31
	CLR  R22
	CLR  R23
	__PUTD1S 6
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2F:
	CLR  R31
	CLR  R22
	CLR  R23
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x30:
	LDS  R26,_OCR_REG
	LDS  R27,_OCR_REG+1
	LDS  R24,_OCR_REG+2
	LDS  R25,_OCR_REG+3
	CALL __ORD12
	STS  _OCR_REG,R30
	STS  _OCR_REG+1,R31
	STS  _OCR_REG+2,R22
	STS  _OCR_REG+3,R23
	RJMP SUBOPT_0x2D

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x31:
	LDI  R30,LOW(255)
	ST   -Y,R30
	RJMP SUBOPT_0x2C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x32:
	LDI  R30,LOW(80)
	OUT  0xD,R30
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x33:
	__GETD1S 1
	__SUBD1N -1
	__PUTD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES
SUBOPT_0x34:
	CALL __PUTPARD1
	CALL __FF_read
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x35:
	LDI  R30,LOW(1)
	STS  __FF_error,R30
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x36:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	CLR  R22
	CLR  R23
	CALL __MULD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x37:
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	CLR  R22
	CLR  R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x38:
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
SUBOPT_0x39:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __LSLD16
	CALL __ORD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3A:
	CLR  R31
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(8)
	CALL __LSLD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3B:
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	CALL _send_cmd
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3C:
	LDI  R30,LOW(80)
	OUT  0xD,R30
	LDI  R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3D:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	__GETD2S 5
	CLR  R22
	CLR  R23
	CALL __MODD21U
	CALL __CPD10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3E:
	LDI  R30,LOW(4)
	STS  __FF_error,R30
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3F:
	ST   -Y,R30
	__GETD1S 6
	CALL __PUTPARD1
	CALL _send_cmd
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x40:
	LDI  R30,LOW(3)
	STS  __FF_error,R30
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x41:
	LD   R30,X
	ST   -Y,R30
	CALL _valid_file_char
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x42:
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
SUBOPT_0x43:
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	__GETD1N 0x0
	CALL __PUTDP1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x44:
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	ADIW R30,1
	STD  Y+31,R30
	STD  Y+31+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x45:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_BPB_SecPerClus
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __MULD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x46:
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	CLR  R22
	CLR  R23
	CALL __MULD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x47:
	MOVW R30,R20
	LSL  R30
	ROL  R31
	CALL __LSLW4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x48:
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1S 25
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x49:
	__GETD1S 25
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __PUTDP1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4A:
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
SUBOPT_0x4B:
	CALL __MULD12
	LDS  R26,__FF_PART_ADDR
	LDS  R27,__FF_PART_ADDR+1
	LDS  R24,__FF_PART_ADDR+2
	LDS  R25,__FF_PART_ADDR+3
	CALL __ADDD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4C:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	LSR  R31
	ROR  R30
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4D:
	CALL __DIVW21U
	LDS  R26,_BPB_RsvdSecCnt
	LDS  R27,_BPB_RsvdSecCnt+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4E:
	CALL __MODW21U
	LSL  R30
	ROL  R31
	MOVW R18,R30
	MOVW R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4F:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x50:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x51:
	LDS  R30,__FF_buff_addr
	LDS  R31,__FF_buff_addr+1
	LDS  R22,__FF_buff_addr+2
	LDS  R23,__FF_buff_addr+3
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x52:
	MOV  R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R31,0
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x53:
	MOV  R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x54:
	LDI  R31,0
	SUBI R30,LOW(-_FILENAME)
	SBCI R31,HIGH(-_FILENAME)
	MOVW R26,R30
	LDI  R30,LOW(32)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x55:
	LD   R31,Z
	LDI  R30,LOW(0)
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x56:
	LDI  R30,LOW(13)
	STS  __FF_error,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x57:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	LSR  R31
	ROR  R30
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x58:
	CALL __ADDD12
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x59:
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5A:
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	__GETD2Z 22
	CALL __PUTPARD2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5B:
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	ADIW R26,26
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5C:
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	ADIW R26,12
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5D:
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
SUBOPT_0x5E:
	ST   -Y,R19
	ST   -Y,R18
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _next_cluster

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5F:
	MOVW R26,R18
	LD   R26,X
	CPI  R26,LOW(0x5C)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x60:
	LD   R30,X
	ST   -Y,R30
	JMP  _toupper

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x61:
	MOVW R26,R16
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x62:
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
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x63:
	LD   R30,Z
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x64:
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x65:
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x66:
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
SUBOPT_0x67:
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x68:
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
SUBOPT_0x69:
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6A:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
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
	RJMP SUBOPT_0x34

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6B:
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
SUBOPT_0x6C:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _free
	RJMP SUBOPT_0x67

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6D:
	MOVW R30,R20
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	STD  Y+18,R30
	STD  Y+18+1,R31
	MOV  R0,R18
	OR   R0,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6E:
	LDI  R30,LOW(11)
	STS  __FF_error,R30
	RJMP SUBOPT_0x6C

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x6F:
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x70:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,12
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x71:
	ADIW R26,18
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x72:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	__GETD1N 0x0
	CALL __PUTDP1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x73:
	MOVW R30,R20
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	ADIW R30,31
	STD  Y+18,R30
	STD  Y+18+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x74:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	SBIW R26,1
	STD  Y+18,R26
	STD  Y+18+1,R27
	ADIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x75:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	CALL __GETD1P
	CALL __CPD10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x76:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+12
	LDD  R27,Z+13
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES
SUBOPT_0x77:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+14
	LDD  R27,Z+15
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x78:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _next_cluster

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x79:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,20
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x7A:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,28
	ADD  R30,R16
	ADC  R31,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x7B:
	MOVW R0,R30
	LDI  R26,LOW(__FF_buff)
	LDI  R27,HIGH(__FF_buff)
	RJMP SUBOPT_0x6F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x7C:
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOVW R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x7D:
	LDI  R30,LOW(5)
	STS  __FF_error,R30
	RJMP SUBOPT_0x67

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x7E:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES
SUBOPT_0x7F:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,1
	STD  Y+18,R26
	STD  Y+18+1,R27
	SBIW R26,1
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x80:
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x81:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-548)
	SBCI R27,HIGH(-548)
	LD   R26,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x82:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,20
	CALL __GETW1P
	SBIW R30,1
	LDS  R26,_BPB_BytsPerSec
	LDS  R27,_BPB_BytsPerSec+1
	CALL __MULW12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x83:
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x84:
	MOVW R26,R16
	SUBI R26,LOW(-__FF_buff)
	SBCI R27,HIGH(-__FF_buff)
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x85:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _append_toc
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x86:
	SUBI R26,LOW(-548)
	SBCI R27,HIGH(-548)
	LD   R26,X
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x87:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	SUBI R26,LOW(-544)
	SBCI R27,HIGH(-544)
	CALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x88:
	SUBI R26,LOW(-549)
	SBCI R27,HIGH(-549)
	LDI  R30,LOW(10)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x89:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	SUBI R26,LOW(-551)
	SBCI R27,HIGH(-551)
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x8A:
	ADIW R26,28
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	SBIW R30,1
	ADD  R30,R26
	ADC  R31,R27
	CP   R30,R0
	CPC  R31,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x8B:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	SUBI R26,LOW(-548)
	SBCI R27,HIGH(-548)
	LD   R26,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x8C:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,28
	ADD  R30,R17
	ADC  R31,R18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x8D:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	LDD  R26,Z+14
	LDD  R27,Z+15
	ST   -Y,R27
	ST   -Y,R26
	JMP  _clust_to_addr

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x8E:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ADIW R26,20
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x8F:
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1S 3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x90:
	LDD  R26,Z+20
	LDD  R27,Z+21
	LDS  R30,_BPB_SecPerClus
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x91:
	SUBI R26,LOW(-550)
	SBCI R27,HIGH(-550)
	LDI  R30,LOW(1)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x92:
	__SUBD1N -1
	CALL __PUTDP1
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x93:
	ADIW R26,20
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x94:
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x95:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _prev_cluster

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x96:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,16
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x97:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Z+16
	LDD  R27,Z+17
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x98:
	ST   -Y,R30
	CALL _write_clus_table
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0x99:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-544)
	SBCI R27,HIGH(-544)
	CALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES
SUBOPT_0x9A:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	CALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x9B:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-550)
	SBCI R27,HIGH(-550)
	LD   R30,X
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x9C:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,14
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x9D:
	SUBI R26,LOW(-550)
	SBCI R27,HIGH(-550)
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x9E:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-551)
	SBCI R27,HIGH(-551)
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x9F:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,20
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xA0:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	CALL __GETD1P
	__GETD2S 13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xA1:
	LDI  R30,LOW(10)
	STS  __FF_error,R30
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xA2:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	__GETD2S 8
	CLR  R22
	CLR  R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xA3:
	LD   R26,Y
	LDD  R27,Y+1
	SUBI R26,LOW(-544)
	SBCI R27,HIGH(-544)
	CALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xA4:
	MOV  R31,R30
	LDI  R30,0
	LDS  R26,_kolvo_abonentov
	LDS  R27,_kolvo_abonentov+1
	OR   R30,R26
	OR   R31,R27
	STS  _kolvo_abonentov,R30
	STS  _kolvo_abonentov+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0xA5:
	LDS  R30,_gshch7
	LDS  R31,_gshch7+1
	ST   X,R30
	JMP  _gshum7

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0xA6:
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	MOVW R26,R30
	LDI  R30,LOW(113)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xA7:
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	MOVW R26,R30
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xA8:
	LD   R30,Z
	MOVW R26,R18
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0xA9:
	ST   -Y,R30
	LDI  R30,LOW(16)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0xAA:
	SUBI R30,-LOW(4)
	ST   -Y,R30
	CALL _RUN_TWI
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xAB:
	LDS  R30,_gshch5
	LDS  R31,_gshch5+1
	ANDI R31,HIGH(0xFF)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xAC:
	MOV  R26,R30
	LDS  R30,_gshch3
	LDS  R31,_gshch3+1
	EOR  R30,R26
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xAD:
	MOVW R26,R18
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xAE:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	SUB  R30,R18
	SBC  R31,R19
	MOVW R18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xAF:
	MOV  R30,R16
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0xB0:
	ST   -Y,R30
	CALL _zakrutbuf
	JMP  _g_tx_kazakovu

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xB1:
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(38)
	STS  _komu,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xB2:
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_TWI_buf_GA)
	SBCI R31,HIGH(-_TWI_buf_GA)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xB3:
	LDI  R30,LOW(0)
	STS  _TWI_statusReg,R30
	LDI  R30,LOW(248)
	STS  _TWI_state_GA,R30
	LDI  R30,LOW(165)
	STS  116,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xB4:
	LDS  R30,_TWI_bufPtr_S80
	SUBI R30,-LOW(1)
	STS  _TWI_bufPtr_S80,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_TWI_buf_GA)
	SBCI R31,HIGH(-_TWI_buf_GA)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xB5:
	LDS  R30,_TWI_statusReg
	ORI  R30,1
	STS  _TWI_statusReg,R30
	LDI  R30,LOW(148)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xB6:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X+
	STD  Y+2,R26
	STD  Y+2+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xB7:
	LDI  R30,LOW(_txBuffer)
	LDI  R31,HIGH(_txBuffer)
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	JMP  _TWI_Start_Transceiver_With_Data

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES
SUBOPT_0xB8:
	LDI  R31,0
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xB9:
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _RUN_TWI
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0xBA:
	LD   R30,Y
	ST   -Y,R30
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xBB:
	ST   -Y,R30
	CALL _RUN_TWI
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xBC:
	MOV  R30,R18
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xBD:
	MOVW R26,R16
	ADIW R26,2
	CALL __GETW1P
	MOVW R18,R30
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

_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

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

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
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

__LSRD1:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	RET

__LSLD1:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
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

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
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

__EEPROMRDD:
	ADIW R26,2
	RCALL __EEPROMRDW
	MOV  R23,R31
	MOV  R22,R30
	SBIW R26,2

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

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

__EEPROMWRD:
	RCALL __EEPROMWRW
	ADIW R26,2
	MOV  R0,R30
	MOV  R1,R31
	MOV  R30,R22
	MOV  R31,R23
	RCALL __EEPROMWRW
	MOV  R30,R0
	MOV  R31,R1
	SBIW R26,2
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
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

__INITLOCB:
__INITLOCW:
	ADD R26,R28
	ADC R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
