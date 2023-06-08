;CodeVisionAVR C Compiler V1.24.7e Professional
;(C) Copyright 1998-2005 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega128
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Speed
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External SRAM size     : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 1112 byte(s)
;Promote char to int    : No
;char is unsigned       : Yes
;8 bit enums            : No
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
	LDI  R24,LOW(0xBA8)
	LDI  R25,HIGH(0xBA8)
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
	LDI  R30,LOW(0xCA7)
	OUT  SPL,R30
	LDI  R30,HIGH(0xCA7)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x500)
	LDI  R29,HIGH(0x500)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500
;       1 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;       2 // Управляющая программа КОДЕРА
;       3 
;       4 #include "Coding.h"
;       5 
;       6 flash unsigned char device_name[32] =					// Имя устройства

	.CSEG
;       7 		"Port Device v1.0";
;       8 eeprom unsigned long my_ser_num = 0;					// Серийный номер устройства

	.ESEG
_my_ser_num:
	.DW  0x0
	.DW  0x0
;       9 const flash unsigned short my_version = 0x0100;			// Версия софта 

	.CSEG
;      10 eeprom unsigned char my_addr = TO_MON;					// Мой адрес - изначально TO_MON

	.ESEG
_my_addr:
	.DB  0xFE
;      11 
;      12 unsigned char txBuffer [256];		//буффер передатчика

	.DSEG
_txBuffer:
	.BYTE 0x100
;      13 unsigned char rxBuffer [256];		//буер приемника
_rxBuffer:
	.BYTE 0x100
;      14 unsigned char lAddrDevice	[64];	// храним лог. адреса подключенных устройств
_lAddrDevice:
	.BYTE 0x40
;      15 															// 0 ячейка - кол-во портов 232 .1 ячейка содержит лог. адрес порта 1, 2-лог.
;      16 															// адрес порта 2 и т. д.
;      17 // Переменные для работы с CF Card
;      18 /*
;      19 typedef struct 				// структура приемного пакета при передаче имени файла
;      20 {
;      21 	char Ptype;               // тип принятого пакета
;      22 	char fname[13];        // имя файла
;      23 } strInPack; */
;      24 
;      25 strInPack * str = (strInPack *)(rx0buf);
;      26 strDataPack * str1 = (strDataPack *)(rx0buf);
;      27 
;      28 FILE *pntr1; 
;      29 
;      30 
;      31 typedef struct _chip_port
;      32 {
;      33 	flash char name[16];
;      34 	flash unsigned char addr;
;      35 } CHIPPORT;
;      36 
;      37 CHIPPORT cp[] = {
_cp:
;      38 	{"Порт 1", 1},
_0cp:
	.BYTE 0x10
_1cp:
	.BYTE 0x1
;      39 	{"Порт 2", 2},
_2cp:
	.BYTE 0x10
_3cp:
	.BYTE 0x1
;      40 	{"Порт 3", 3},
_4cp:
	.BYTE 0x10
_5cp:
	.BYTE 0x1
;      41 	{"Порт 4", 4}
_6cp:
	.BYTE 0x10
_7cp:
	.BYTE 0x1
;      42 };
;      43 
;      44 //-----------------------------------------------------------------------------------------------------------------
;      45 // Возвращаю состояние устройства
;      46 static void GetState(void)
;      47 {

	.CSEG
_GetState_G1:
;      48 	register unsigned char i, n, b;
;      49 	
;      50 	#define strq  ((RQ_GETSTATE *)rx0buf)
;      51 
;      52 	switch(strq->page)
	CALL __SAVELOCR3
;	i -> R16
;	n -> R17
;	b -> R18
	LDS  R30,_rx0buf
;      53 	{
;      54 	case 0:
	CPI  R30,0
	BREQ PC+3
	JMP _0xC
;      55 		StartReply(2 + 16*(sizeof(cp) / sizeof(CHIPPORT)) + 1);
	LDI  R30,LOW(67)
	ST   -Y,R30
	RCALL _StartReply
;      56 
;      57 		putchar0(2);               						 // число доступных страниц, включая эту
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _putchar0
;      58 		putchar0(0);										// зарезервирован
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _putchar0
;      59 		
;      60 		for (n = 0; n < (sizeof(cp) / sizeof(CHIPPORT)); n ++)
	LDI  R17,LOW(0)
_0xE:
	CPI  R17,4
	BRSH _0xF
;      61 		{
;      62 			for (i = 0; i < 15; i ++)
	LDI  R16,LOW(0)
_0x11:
	CPI  R16,15
	BRSH _0x12
;      63 			{
;      64 				b = cp[n].name[i];
	MOV  R30,R17
	LDI  R31,0
	LDI  R26,LOW(17)
	LDI  R27,HIGH(17)
	CALL __MULW12U
	SUBI R30,LOW(-_cp)
	SBCI R31,HIGH(-_cp)
	MOVW R26,R30
	MOV  R30,R16
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R18,X
;      65 				if (!b)
	CPI  R18,0
	BREQ _0x12
;      66 				{
;      67 					break;
;      68 				}
;      69 				putchar0(b);
	ST   -Y,R18
	RCALL _putchar0
;      70 			}
	SUBI R16,-1
	RJMP _0x11
_0x12:
;      71 			while(i < 15)
_0x14:
	CPI  R16,15
	BRSH _0x16
;      72 			{
;      73 				putchar0(' ');
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL _putchar0
;      74 				i++;
	SUBI R16,-1
;      75 			}
	RJMP _0x14
_0x16:
;      76 			
;      77 			putchar0(cp[n].addr);
	MOV  R26,R17
	CLR  R27
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	CALL __MULW12U
	__POINTW2MN _cp,16
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ST   -Y,R30
	RCALL _putchar0
;      78 		}
	SUBI R17,-1
	RJMP _0xE
_0xF:
;      79 		
;      80 		putchar0(255);
	LDI  R30,LOW(255)
	ST   -Y,R30
	RCALL _putchar0
;      81 
;      82 		EndReply();
	RCALL _EndReply
;      83 		return;
	RJMP _0x42F
;      84 
;      85 	case 1:
_0xC:
	CPI  R30,LOW(0x1)
	BRNE _0xB
;      86 	
;      87 		StartReply(3 * (sizeof(cp) / sizeof(CHIPPORT)) + 1);
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _StartReply
;      88 		
;      89 		for (n = 0; n < (sizeof(cp) / sizeof(CHIPPORT)); n++)
	LDI  R17,LOW(0)
_0x19:
	CPI  R17,4
	BRSH _0x1A
;      90 		{
;      91 			putchar0(n);
	ST   -Y,R17
	RCALL _putchar0
;      92 			putchar0(cp[n].addr);
	MOV  R26,R17
	CLR  R27
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	CALL __MULW12U
	__POINTW2MN _cp,16
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ST   -Y,R30
	RCALL _putchar0
;      93 			putchar0(lAddrDevice [cp[n].addr]);
	MOV  R26,R17
	CLR  R27
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	CALL __MULW12U
	__POINTW2MN _cp,16
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	LDI  R31,0
	SUBI R30,LOW(-_lAddrDevice)
	SBCI R31,HIGH(-_lAddrDevice)
	LD   R30,Z
	ST   -Y,R30
	RCALL _putchar0
;      94 		}
	SUBI R17,-1
	RJMP _0x19
_0x1A:
;      95 
;      96 		putchar0(255);
	LDI  R30,LOW(255)
	ST   -Y,R30
	RCALL _putchar0
;      97 
;      98 		EndReply();
	RCALL _EndReply
;      99 		return;
;     100 	}
_0xB:
;     101 }
_0x42F:
	CALL __LOADLOCR3
	ADIW R28,3
	RET
;     102 
;     103 //-----------------------------------------------------------------------------------------------------------------
;     104 // Информация об устройстве
;     105 static void GetInfo(void)
;     106 {
_GetInfo_G1:
;     107 	register unsigned char i;
;     108 	
;     109 	// 	Начинаю передачу ответа
;     110 	StartReply(40);
	ST   -Y,R16
;	i -> R16
	LDI  R30,LOW(40)
	ST   -Y,R30
	RCALL _StartReply
;     111 	
;     112 	for (i = 0; i < 32; i ++)	// Имя устройства
	LDI  R16,LOW(0)
_0x1C:
	CPI  R16,32
	BRSH _0x1D
;     113 	{
;     114 		putchar0(device_name[i]);
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_device_name*2)
	SBCI R31,HIGH(-_device_name*2)
	LPM  R30,Z
	ST   -Y,R30
	RCALL _putchar0
;     115 	}
	SUBI R16,-1
	RJMP _0x1C
_0x1D:
;     116 
;     117 	putword0(my_ser_num);		// Серийный номер
	LDI  R26,LOW(_my_ser_num)
	LDI  R27,HIGH(_my_ser_num)
	CALL __EEPROMRDD
	ST   -Y,R31
	ST   -Y,R30
	RCALL _putword0
;     118 	putword0(my_ser_num >> 16);	
	LDI  R26,LOW(_my_ser_num)
	LDI  R27,HIGH(_my_ser_num)
	CALL __EEPROMRDD
	CALL __LSRD16
	ST   -Y,R31
	ST   -Y,R30
	RCALL _putword0
;     119 	
;     120 	putchar0(my_addr);			// Адрес устройстав
	LDI  R26,LOW(_my_addr)
	LDI  R27,HIGH(_my_addr)
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _putchar0
;     121 
;     122 	putchar0(0);				// Зарезервированный байт
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _putchar0
;     123 	
;     124 	putword0(my_version);		// Версия
	LDI  R30,LOW(_my_version*2)
	LDI  R31,HIGH(_my_version*2)
	CALL __GETW1PF
	ST   -Y,R31
	ST   -Y,R30
	RCALL _putword0
;     125 	
;     126 	EndReply();					// Завершаю ответ
	RCALL _EndReply
;     127 }
	LD   R16,Y+
	RET
;     128 
;     129 //-----------------------------------------------------------------------------------------------------------------
;     130 // Смена адреса устройства
;     131 static void SetAddr(void)
;     132 {
_SetAddr_G1:
;     133 	#define sap ((RQ_SETADDR *)rx0buf)
;     134 	
;     135 	my_addr = sap->addr;
	LDS  R30,_rx0buf
	LDI  R26,LOW(_my_addr)
	LDI  R27,HIGH(_my_addr)
	CALL __EEPROMWRB
;     136 	
;     137 	StartReply(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _StartReply
;     138 	putchar0(RES_OK);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _putchar0
;     139 	EndReply();
	RCALL _EndReply
;     140 }
	RET
;     141 
;     142 //-----------------------------------------------------------------------------------------------------------------
;     143 // Назначение серийного номера устройства
;     144 static void SetSerial(void)
;     145 {
_SetSerial_G1:
;     146 	#define ssp ((RQ_SETSERIAL *)rx0buf)
;     147 	
;     148 	if (my_ser_num)
	LDI  R26,LOW(_my_ser_num)
	LDI  R27,HIGH(_my_ser_num)
	CALL __EEPROMRDD
	CALL __CPD10
	BREQ _0x1E
;     149 	{
;     150 		StartReply(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _StartReply
;     151 		putchar0(RES_ERR);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _putchar0
;     152 		EndReply();
	RCALL _EndReply
;     153 		return;
	RET
;     154 	}
;     155 	
;     156 	my_ser_num = ssp->num;
_0x1E:
	LDS  R30,_rx0buf
	LDS  R31,_rx0buf+1
	LDS  R22,_rx0buf+2
	LDS  R23,_rx0buf+3
	LDI  R26,LOW(_my_ser_num)
	LDI  R27,HIGH(_my_ser_num)
	CALL __EEPROMWRD
;     157 	
;     158 	StartReply(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _StartReply
;     159 	putchar0(RES_OK);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _putchar0
;     160 	EndReply();
	RCALL _EndReply
;     161 }
	RET
;     162 
;     163 //-----------------------------------------------------------------------------------------------------------------
;     164 // Перезагрузка в режим программирования
;     165 static void ToProg(void)
;     166 {
_ToProg_G1:
;     167 	// Отправляю ответ
;     168 	StartReply(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _StartReply
;     169 	EndReply();
	RCALL _EndReply
;     170 
;     171 	// На перезагрузку в монитор
;     172 	MCUCR = 1 << IVCE;
	LDI  R30,LOW(1)
	OUT  0x35,R30
;     173 	MCUCR = 1 << IVSEL;
	LDI  R30,LOW(2)
	OUT  0x35,R30
;     174 
;     175 	#asm("jmp 0xFC00");
	jmp 0xFC00
;     176 }
	RET
;     177 
;     178 //-----------------------------------------------------------------------------------------------------------------
;     179 // Железо процессора в исходное состояние
;     180 static void HardwareInit(void)
;     181 {         
_HardwareInit_G1:
;     182         twi_init ();      
	RCALL _twi_init
;     183 		CommInit();				// Инициализация  COM-порта
	RCALL _CommInit
;     184 		timer_0_Init ();			// Инициализируем таймер 0 (таймаут)
	RCALL _timer_0_Init
;     185 		portInit();					// Выводы - в исходное состояние
	RCALL _portInit
;     186         
;     187 }
	RET
;     188 
;     189 //-----------------------------------------------------------------------------------------------------------------
;     190 // Сброс периферии
;     191 void ResetPeripherial(void)
;     192 {
_ResetPeripherial:
;     193         CRST = 0;
	CBI  0x1B,2
;     194         delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
;     195         CRST = 1;
	SBI  0x1B,2
;     196         delay_ms(500);     //Ждем пока отработают сброс
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
;     197 }
	RET
;     198 
;     199 //-----------------------------------------------------------------------------------------------------------------
;     200 // Точка входа в программу
;     201 void main(void)
;     202 {
_main:
;     203 unsigned char a;   
;     204 
;     205 //	Пока происходят внутренние работы светодиод - красный. По окончании - зеленый.
;     206 
;     207     LedRed();               
;	a -> R16
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,0
	SBI  0x1B,1
;     208 	HardwareInit();				// Железо процессора
	CALL _HardwareInit_G1
;     209 	ResetPeripherial();		// Сбрасываю периферию 
	CALL _ResetPeripherial
;     210 
;     211 	#asm("sei")
	sei
;     212 
;     213 	UCSR0B.3 = 1;		 				// Разрешаю передатчик UART
	SBI  0xA,3
;     214 	delay_ms (3000);					// даем время отработать сброс
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
;     215 	verIntDev();							// Считаем	 количество подчиненных устройств 
	RCALL _verIntDev
;     216 
;     217 // работаем с карточкой...
;     218 	while (!(initialize_media()));		// инициализация CF Card   
_0x1F:
	RCALL _initialize_media
	CPI  R30,0
	BREQ _0x1F
;     219 
;     220 	while (1)
_0x22:
;     221 	{
;     222 
;     223 
;     224 		LedGreen();
	SBI  0x1A,0
	SBI  0x1A,1
	SBI  0x1B,0
	CBI  0x1B,1
;     225 		ReadLogAddr ();				// Вычитываем лог. адреса
	RCALL _ReadLogAddr
;     226 
;     227 //		for (a=1; a<= int_Devices; a++) pingPack (a);	
;     228 	
;     229 
;     230 		// Проверяю, нет ли пакета и принимаю меры, если есть
;     231 		if (HaveIncomingPack())
	RCALL _HaveIncomingPack
	CPI  R30,0
	BRNE PC+3
	JMP _0x25
;     232 		{
;     233 		if ((rx0addr == my_addr) || (rx0addr == TO_ALL))				// адрес мой 
	LDI  R26,LOW(_my_addr)
	LDI  R27,HIGH(_my_addr)
	CALL __EEPROMRDB
	LDS  R26,_rx0addr
	CP   R30,R26
	BREQ _0x27
	CPI  R26,LOW(0xFF)
	BRNE _0x26
_0x27:
;     234 			{
;     235 				switch(IncomingPackType())
	RCALL _IncomingPackType
;     236 					{
;     237 						case PT_GETSTATE:
	CPI  R30,LOW(0x1)
	BRNE _0x2C
;     238 								GetState();
	CALL _GetState_G1
;     239 								break;
	RJMP _0x2B
;     240 				
;     241 						case PT_GETINFO:
_0x2C:
	CPI  R30,LOW(0x3)
	BRNE _0x2D
;     242 								GetInfo();
	CALL _GetInfo_G1
;     243 								break;
	RJMP _0x2B
;     244 				
;     245 						case PT_SETADDR:
_0x2D:
	CPI  R30,LOW(0x4)
	BRNE _0x2E
;     246 								SetAddr();
	CALL _SetAddr_G1
;     247 								break;
	RJMP _0x2B
;     248 				
;     249 						case PT_SETSERIAL:
_0x2E:
	CPI  R30,LOW(0x5)
	BRNE _0x2F
;     250 								SetSerial();
	CALL _SetSerial_G1
;     251 								break;
	RJMP _0x2B
;     252 				
;     253 						case PT_TOPROG:
_0x2F:
	CPI  R30,LOW(0x7)
	BRNE _0x30
;     254 								ToProg();
	CALL _ToProg_G1
;     255 								break;      
	RJMP _0x2B
;     256 
;     257 						case PT_RELAY:           			// ретрансляция пакета при программировании
_0x30:
	CPI  R30,LOW(0x6)
	BRNE _0x31
;     258 							    RelayPack();	
	RCALL _RelayPack
;     259                 				break;
	RJMP _0x2B
;     260 
;     261 						case PT_FLASH:								// пакеты для работы с CF Flash
_0x31:
	CPI  R30,LOW(0xB4)
	BRNE _0x33
;     262 							    flash_Work();	
	RCALL _flash_Work
;     263                 				break;
	RJMP _0x2B
;     264                 			
;     265 						default:
_0x33:
;     266 								DiscardIncomingPack();
	RCALL _DiscardIncomingPack
;     267 								break;
;     268 					}
_0x2B:
;     269 		   }
;     270 		else																	// ретранслируем
	RJMP _0x34
_0x26:
;     271 				{                                                                      
;     272 					for (a=1; a<= int_Devices; a++)				// ищем порт по адресу
	LDI  R16,LOW(1)
_0x36:
	LDS  R30,_int_Devices
	CP   R30,R16
	BRLO _0x37
;     273 						{
;     274 						 	if (lAddrDevice [a]	== rx0addr)
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_lAddrDevice)
	SBCI R31,HIGH(-_lAddrDevice)
	LD   R30,Z
	LDS  R26,_rx0addr
	CP   R30,R26
	BRNE _0x38
;     275 						 		{
;     276 									LedRed();
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,0
	SBI  0x1B,1
;     277 									recompPack (a);		
	ST   -Y,R16
	RCALL _recompPack
;     278 									DiscardIncomingPack();        // разрешаем принимать след. пакет
	RCALL _DiscardIncomingPack
;     279 									delay_ms (50);
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
;     280 									pingPack (a);	
	ST   -Y,R16
	RCALL _pingPack
;     281 									break;
	RJMP _0x37
;     282 						 		}
;     283 						}
_0x38:
	SUBI R16,-1
	RJMP _0x36
_0x37:
;     284 				}
_0x34:
;     285 		}
;     286 	}
_0x25:
	RJMP _0x22
;     287 }    	
_0x39:
	RJMP _0x39
;     288 
;     289 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;     290 // Управляющая программа КОДЕРА
;     291 // Связь с внешним миром
;     292 
;     293 #include "Coding.h"
;     294 
;     295 #define BAUD 38400
;     296 
;     297 /*
;     298 ////////////////////////////////////////////////////////////////////////////////
;     299 // Фазы работы приемопередатчиков
;     300 #define RX_HDR	 1		// Принятый байт - заголовок
;     301 #define RX_LEN   2		// Принятый байт - длина
;     302 #define RX_ADDR  3		// Принятый байт - адрес
;     303 #define RX_TYPE  4		// Принятый байт - тип пакета
;     304 #define RX_DATA  5		// Принятый байт - байт данных
;     305 #define RX_CRC   6		// Принятый байт - CRC
;     306 #define RX_OK    7		// Пакет успешно принят и адресован мне
;     307 #define RX_TIME  8		// Во время приема произошел тайм-аут
;     308 #define RX_ERR   9		// Ошибка CRC приема
;     309 #define RX_BUSY 10		// Запрос прочитан, а ответ еще не сформирован
;     310 */
;     311 #define UDRE 5
;     312 #define DATA_REGISTER_EMPTY (1<<UDRE)
;     313 
;     314 #define RXTIMEOUT 4000	// Тайм-аут приема наружного канала
;     315 
;     316 ////////////////////////////////////////////////////////////////////////////////
;     317 // Работа с наружным каналом
;     318 
;     319 unsigned char tx0crc;
;     320 unsigned char rx0state = RX_HDR;

	.DSEG
;     321 unsigned char rx0crc;
;     322 unsigned char rx0len;
;     323 unsigned char rx0addr;
_rx0addr:
	.BYTE 0x1
;     324 unsigned char rx0type;
;     325 
;     326 #define COMBUFSIZ 255
;     327 
;     328 unsigned char rx0buf[COMBUFSIZ];
_rx0buf:
	.BYTE 0xFF
;     329 unsigned char rx0ptr;
_rx0ptr:
	.BYTE 0x1
;     330 
;     331 // Передача байта во "внешний" канал
;     332 void putchar0(char byt)
;     333 {

	.CSEG
_putchar0:
;     334 	while ((UCSR0A & DATA_REGISTER_EMPTY)==0);
_0x3B:
	SBIS 0xB,5
	RJMP _0x3B
;     335 	UDR0 = byt;
	LD   R30,Y
	OUT  0xC,R30
;     336 	tx0crc += byt;
	ADD  R10,R30
;     337 }
	RJMP _0x42E
;     338 
;     339 // Начало ответа на запрос по внешнему каналу
;     340 void StartReply(unsigned char dlen) 
;     341 {
_StartReply:
;     342 //	rx0state = RX_BUSY;					// Запрос обработан
;     343 	tx0crc = 0;										// Готовлю CRC
	CLR  R10
;     344 	
;     345 	UCSR0B.3 = 1;								// Разрешаю передатчик
	SBI  0xA,3
;     346 	
;     347 	putchar0(dlen+1);							// Передаю длину
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   -Y,R30
	CALL _putchar0
;     348 }
	RJMP _0x42E
;     349 
;     350 void EndReply(void)
;     351 {
_EndReply:
;     352 	putchar0(tx0crc);							// Контрольная сумма
	ST   -Y,R10
	CALL _putchar0
;     353 //	UCSR0B.3 = 0;								// Запрещаю передатчик
;     354 	rx0state = RX_HDR;						// Разрешаю прием след. запроса
	LDI  R30,LOW(1)
	MOV  R11,R30
;     355 }
	RET
;     356 
;     357 // Прерывание по приему байта из "наружного" канала
;     358 interrupt [USART0_RXC] void uart_rx_isr(void)
;     359 {
_uart_rx_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;     360 	register unsigned char byt;
;     361 
;     362 	byt = UDR0;									// Принятый байт
	ST   -Y,R16
;	byt -> R16
	IN   R16,12
;     363 
;     364 	
;     365 	switch (rx0state)
	MOV  R30,R11
;     366 	{
;     367 	case RX_HDR:								// Должен быть заголовок
	CPI  R30,LOW(0x1)
	BRNE _0x41
;     368 		if (byt != PACKHDR)					// Отбрасываю не заголовок
	CPI  R16,113
	BREQ _0x42
;     369 		{
;     370 			break;
	RJMP _0x40
;     371 		}
;     372 
;     373 
;     374 		rx0state = RX_LEN;					// Перехожу к ожиданию длины
_0x42:
	LDI  R30,LOW(2)
	MOV  R11,R30
;     375 		rx0crc = 0;								// Готовлю подсчет CRC
	CLR  R12
;     376 		
;     377 		OCR1A = TCNT1+RXTIMEOUT;	// Взвожу тайм-аут
	IN   R30,0x2C
	IN   R31,0x2C+1
	SUBI R30,LOW(-4000)
	SBCI R31,HIGH(-4000)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
;     378 		TIFR = 0x10;								// Предотвращаю ложное срабатывание
	LDI  R30,LOW(16)
	OUT  0x36,R30
;     379 		TIMSK |= 0x10;							// Разрешение прерывания по тайм-ауту
	IN   R30,0x37
	ORI  R30,0x10
	OUT  0x37,R30
;     380 		break;
	RJMP _0x40
;     381 		
;     382 	case RX_LEN:
_0x41:
	CPI  R30,LOW(0x2)
	BRNE _0x43
;     383 		rx0len = byt - 3;							// Длина содержимого
	MOV  R30,R16
	SUBI R30,LOW(3)
	MOV  R13,R30
;     384 		rx0state = RX_ADDR;					// К приему адреса
	LDI  R30,LOW(3)
	RJMP _0x430
;     385 		break;
;     386 
;     387 	case RX_ADDR:
_0x43:
	CPI  R30,LOW(0x3)
	BRNE _0x44
;     388 		rx0addr = byt;							// Адрес
	STS  _rx0addr,R16
;     389 		rx0state = RX_TYPE;					// К приему типа
	LDI  R30,LOW(4)
	RJMP _0x430
;     390 		break;
;     391 
;     392 	case RX_TYPE:
_0x44:
	CPI  R30,LOW(0x4)
	BRNE _0x45
;     393 		rx0type = byt;							// Тип
	MOV  R14,R16
;     394 		rx0ptr = 0;									// Указатель на начало данных
	LDI  R30,LOW(0)
	STS  _rx0ptr,R30
;     395 		if (rx0len)
	TST  R13
	BREQ _0x46
;     396 		{
;     397 			rx0state = RX_DATA;				// К приему данных
	LDI  R30,LOW(5)
	RJMP _0x431
;     398 		}
;     399 		else
_0x46:
;     400 		{
;     401 			rx0state = RX_CRC; 				// К приему контрольной суммы
	LDI  R30,LOW(6)
_0x431:
	MOV  R11,R30
;     402 		}
;     403 		break;
	RJMP _0x40
;     404 
;     405 	case RX_DATA:
_0x45:
	CPI  R30,LOW(0x5)
	BRNE _0x48
;     406 		if (rx0ptr > (COMBUFSIZ-1))
	LDS  R26,_rx0ptr
	CPI  R26,LOW(0xFF)
	BRLO _0x49
;     407 		{
;     408 			rx0state = RX_HDR;				// Если пакет слишком длинный - отвергаю и иду в начало
	RJMP _0x432
;     409 			break;
;     410 		}
;     411 		rx0buf[rx0ptr++] = byt;				// Данные
_0x49:
	LDS  R30,_rx0ptr
	SUBI R30,-LOW(1)
	STS  _rx0ptr,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_rx0buf)
	SBCI R31,HIGH(-_rx0buf)
	ST   Z,R16
;     412 		if (rx0ptr < rx0len)						// Еще не все ?
	LDS  R26,_rx0ptr
	CP   R26,R13
	BRLO _0x40
;     413 		{
;     414 			break;
;     415 		}
;     416 		rx0state = RX_CRC;					// К приему контрольной суммы
	LDI  R30,LOW(6)
	RJMP _0x430
;     417 		break;
;     418 
;     419 	case RX_CRC:
_0x48:
	CPI  R30,LOW(0x6)
	BRNE _0x4E
;     420 		if (byt != rx0crc)
	CP   R12,R16
	BREQ _0x4C
;     421 		{
;     422 			rx0state = RX_HDR;				// Не сошлась CRC - игнорирую пакет и жду следующий
	LDI  R30,LOW(1)
	RJMP _0x433
;     423 		}
;     424 // убрал фильтр адреса
;     425 else
_0x4C:
;     426 {
;     427 rx0buf[rx0ptr++] = byt;						// Данные
	LDS  R30,_rx0ptr
	SUBI R30,-LOW(1)
	STS  _rx0ptr,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_rx0buf)
	SBCI R31,HIGH(-_rx0buf)
	ST   Z,R16
;     428 rx0state = RX_OK;								// Принят пакет, на который нужно ответить
	LDI  R30,LOW(7)
_0x433:
	MOV  R11,R30
;     429 }
;     430 /*		else if ((rx0addr == my_addr) || (rx0addr == TO_ALL))
;     431 		{
;     432  			rx0buf[rx0ptr++] = byt;			// Данные
;     433     		rx0state = RX_OK;				// Принят пакет, на который нужно ответить
;     434 		}
;     435 		else
;     436 		{
;     437 			rx0state = RX_HDR;				// Принят пакет, адресованный не мне - жду следующего
;     438 		}*/
;     439 		TIMSK &= 0x10 ^ 0xFF;				// Запретить прерывание по тайм-ауту
	IN   R30,0x37
	ANDI R30,0xEF
	OUT  0x37,R30
;     440 		break;
	RJMP _0x40
;     441 		
;     442 //	case RX_BUSY:							// Запрос принят, но ответ еще не готов
;     443 		break;
;     444 		
;     445 	default:											// Ошибочное состояние
_0x4E:
;     446 		rx0state = RX_HDR;					// Перехожу на начало
_0x432:
	LDI  R30,LOW(1)
_0x430:
	MOV  R11,R30
;     447 		break;
;     448 	}
_0x40:
;     449 
;     450 	rx0crc += byt;								// Подсчитываю контрольную сумму
	ADD  R12,R16
;     451 }
	LD   R16,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;     452 
;     453 // Прерывание по сравнению A таймера 1 для подсчета тайм-аута приема "внешнего" канала
;     454 interrupt [TIM1_COMPA] void timer1_comp_a_isr(void)
;     455 {
_timer1_comp_a_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
;     456 	rx0state = RX_HDR;						// По тайм-ауту перехожу к началу приема нового пакета
	LDI  R30,LOW(1)
	MOV  R11,R30
;     457 	TIMSK &= 0x10 ^ 0xFF;					// Больше не генерировать прерываний
	IN   R30,0x37
	ANDI R30,0xEF
	OUT  0x37,R30
;     458 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;     459 
;     460 unsigned char HaveIncomingPack(void)
;     461 {
_HaveIncomingPack:
;     462 	if (rx0state == RX_OK)	return 255;
	LDI  R30,LOW(7)
	CP   R30,R11
	BRNE _0x4F
	LDI  R30,LOW(255)
	RET
;     463 	else					return 0;
_0x4F:
	LDI  R30,LOW(0)
	RET
;     464 }
	RET
;     465 
;     466 unsigned char IncomingPackType(void)
;     467 {
_IncomingPackType:
;     468 	return rx0type;
	MOV  R30,R14
	RET
;     469 }
;     470 
;     471 void DiscardIncomingPack(void)
;     472 {
_DiscardIncomingPack:
;     473 	rx0state = RX_HDR;						// Разрешаю прием следующего пакета
	LDI  R30,LOW(1)
	MOV  R11,R30
;     474 }
	RET
;     475 
;     476 // Настройка приемопередатчика
;     477 void CommInit(void)
;     478 {
_CommInit:
;     479 	// Подтяжка на TXD
;     480 //	DDRD.1 = 0;
;     481 //	PORTD.1 = 1;
;     482 /*	
;     483 // USART0 initialization
;     484 // Communication Parameters: 8 Data, 1 Stop, No Parity
;     485 // USART0 Receiver: On
;     486 // USART0 Transmitter: On
;     487 // USART0 Mode: Asynchronous
;     488 // USART0 Baud rate: 38400
;     489 UCSR0A=0x00;
;     490 UCSR0B=0x18;
;     491 UCSR0C=0x06;
;     492 UBRR0H=0x00;
;     493 UBRR0L=0x0C;
;     494 */
;     495 
;     496 
;     497 	// Настраиваю UART
;     498 	UCSR0A = 0b00000000;
	LDI  R30,LOW(0)
	OUT  0xB,R30
;     499 	UCSR0B = 0b10010000;	//0b10011000;
	LDI  R30,LOW(144)
	OUT  0xA,R30
;     500 	UCSR0C = 0x86;
	LDI  R30,LOW(134)
	STS  149,R30
;     501 	UBRR0L = ((_MCU_CLOCK_FREQUENCY_ / (16 * BAUD)) - 1) & 0xFF;
	LDI  R30,LOW(12)
	OUT  0x9,R30
;     502 	UBRR0H = (((_MCU_CLOCK_FREQUENCY_ / (16 * BAUD)) - 1) >> 8) & 0xFF;
	LDI  R30,LOW(0)
	STS  144,R30
;     503 	
;     504 	// Таймер 1 для подсчета тайм-аутов приема
;     505 	TCCR1B  = 0b00000101;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
;     506 }
	RET
;     507 
;     508 void putword0(unsigned short wd)
;     509 {
_putword0:
;     510 	putchar0(wd);
	LD   R30,Y
	ST   -Y,R30
	CALL _putchar0
;     511 	putchar0(wd >> 8);
	LDD  R30,Y+1
	ANDI R31,HIGH(0x0)
	ST   -Y,R30
	CALL _putchar0
;     512 }                                  
	RJMP _0x42D
;     513 
;     514 
;     515 // Ретрансляция цикла обмена из внешнего во внутр. канал и обратно
;     516 // "Внутренний" канал должен быть свободен
;     517 
;     518 void RelayPack(void)
;     519 {
_RelayPack:
;     520 	register unsigned char i,a;
;     521  LedRed();	
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16
;	a -> R17
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,0
	SBI  0x1B,1
;     522 	// Передаю запрос
;     523 	StartIntReq(rx0len);
	ST   -Y,R13
	RCALL _StartIntReq
;     524 	
;     525 	// Тело пакета
;     526 	for (i = 0; i < rx0len; i ++)
	LDI  R16,LOW(0)
_0x52:
	CP   R16,R13
	BRSH _0x53
;     527 	{
;     528 		twi_byte(rx0buf[i]);   
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_rx0buf)
	SBCI R31,HIGH(-_rx0buf)
	LD   R30,Z
	ST   -Y,R30
	RCALL _twi_byte
;     529 		tx1crc +=(rx0buf[i]);
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_rx0buf)
	SBCI R31,HIGH(-_rx0buf)
	LD   R30,Z
	LDS  R26,_tx1crc
	ADD  R30,R26
	STS  _tx1crc,R30
;     530 	}
	SUBI R16,-1
	RJMP _0x52
_0x53:
;     531 	
;     532 	// Окончание запроса
;     533 	EndIntReq();
	RCALL _EndIntReq
;     534 	DiscardIncomingPack();        // разрешаем принимать след. пакет
	CALL _DiscardIncomingPack
;     535 
;     536 	delay_ms (10);						// принимаем ответ
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
;     537 
;     538 /*	if ((rx0buf[0] == TO_MON) || (rx0buf[0] == TO_MON))       // если пакет послан всем - принимаем ответ по очереди
;     539 		{
;     540 			for (a=1; a<= int_Devices; a++) pingPack (a);	
;     541 		}
;     542 	else	pingPack (rx0buf[0]);*/
;     543 
;     544 	pingPack (4);	
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL _pingPack
;     545 
;     546 } 
	RJMP _0x42C
;     547   
;     548 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;     549 // 
;     550 // Связь с внешним миром
;     551 
;     552 #include <Coding.h>
;     553 
;     554 // Биты TWCR
;     555 #define TWINT 7
;     556 #define TWEA  6
;     557 #define TWSTA 5
;     558 #define TWSTO 4
;     559 #define TWWC  3
;     560 #define TWEN  2
;     561 #define TWIE  0
;     562 
;     563 // Состояния
;     564 #define START		0x08
;     565 #define	REP_START	0x10
;     566 
;     567 // Коды статуса
;     568 #define	MTX_ADR_ACK		0x18
;     569 #define	MRX_ADR_ACK		0x40
;     570 #define	MTX_DATA_ACK	0x28
;     571 #define	MRX_DATA_NACK	0x58
;     572 #define	MRX_DATA_ACK	0x50
;     573 
;     574 // Подготовка аппаратного мастера I2C
;     575 void twi_init (void)
;     576 {
_twi_init:
;     577 	TWSR=0x00;
	LDI  R30,LOW(0)
	STS  113,R30
;     578 	TWBR=0x20;
	LDI  R30,LOW(32)
	STS  112,R30
;     579 	TWAR=0x00;
	LDI  R30,LOW(0)
	STS  114,R30
;     580 	TWCR=0x04;
	LDI  R30,LOW(4)
	STS  116,R30
;     581 }
	RET
;     582 
;     583 // Жду флажка окончания текущей операции
;     584 static void twi_wait_int (void)
;     585 {
_twi_wait_int_G3:
;     586 
;     587 	while (!(TWCR & (1<<TWINT)))
_0x54:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BRNE _0x56
;     588 		{
;     589 			   if ( flagTWI & ( 1<< time_is_Out))  break;  // выходим по тайм - ауту
	LDS  R30,_flagTWI
	ANDI R30,LOW(0x1)
	BRNE _0x56
;     590 		}; 
	RJMP _0x54
_0x56:
;     591 }
	RET
;     592 
;     593 // Стартовое условие
;     594 // Возвращает не 0, если все в порядке
;     595 unsigned char twi_start (void)
;     596 {
_twi_start:
;     597 	TWCR = ((1<<TWINT)+(1<<TWSTA)+(1<<TWEN));
	LDI  R30,LOW(164)
	STS  116,R30
;     598 	
;     599 	twi_wait_int();
	CALL _twi_wait_int_G3
;     600 
;     601     if((TWSR != START)&&(TWSR != REP_START))
	LDS  R26,113
	CPI  R26,LOW(0x8)
	BREQ _0x59
	LDS  R26,113
	CPI  R26,LOW(0x10)
	BRNE _0x5A
_0x59:
	RJMP _0x58
_0x5A:
;     602     {
;     603 		return 0;
	LDI  R30,LOW(0)
	RET
;     604 	}
;     605 	
;     606 	return 255;
_0x58:
	LDI  R30,LOW(255)
	RET
;     607 }
;     608 
;     609 // Стоповое условие
;     610 void twi_stop (void)
;     611 {
_twi_stop:
;     612 	TWCR = ((1<<TWEN)+(1<<TWINT)+(1<<TWSTO));
	LDI  R30,LOW(148)
	STS  116,R30
;     613 }
	RET
;     614 
;     615 // Передача адреса
;     616 // Возвращает не 0, если все в порядке
;     617 unsigned char twi_addr (unsigned char addr)
;     618 {
_twi_addr:
;     619 	twi_wait_int();
	CALL _twi_wait_int_G3
;     620 
;     621 	TWDR = addr;
	LD   R30,Y
	STS  115,R30
;     622 	TWCR = ((1<<TWINT)+(1<<TWEN));
	LDI  R30,LOW(132)
	STS  116,R30
;     623 
;     624 	twi_wait_int();                 		// Ждем отклик 
	CALL _twi_wait_int_G3
;     625 
;     626 	if((TWSR != MTX_ADR_ACK)&&(TWSR != MRX_ADR_ACK))
	LDS  R26,113
	CPI  R26,LOW(0x18)
	BREQ _0x5C
	LDS  R26,113
	CPI  R26,LOW(0x40)
	BRNE _0x5D
_0x5C:
	RJMP _0x5B
_0x5D:
;     627 	{
;     628 		return 0;
	LDI  R30,LOW(0)
	RJMP _0x42E
;     629 	}
;     630 	return 255;
_0x5B:
	LDI  R30,LOW(255)
	RJMP _0x42E
;     631 }
;     632 
;     633 // Передача байта данных
;     634 // Возвращает не 0, если все в порядке
;     635 unsigned char twi_byte (unsigned char data)
;     636 {
_twi_byte:
;     637 	twi_wait_int();
	CALL _twi_wait_int_G3
;     638 
;     639 	TWDR = data;
	LD   R30,Y
	STS  115,R30
;     640  	TWCR = ((1<<TWINT)+(1<<TWEN));
	LDI  R30,LOW(132)
	STS  116,R30
;     641 
;     642 	twi_wait_int();
	CALL _twi_wait_int_G3
;     643 
;     644 	if(TWSR != MTX_DATA_ACK)
	LDS  R26,113
	CPI  R26,LOW(0x28)
	BREQ _0x5E
;     645 	{
;     646 		return 0;
	LDI  R30,LOW(0)
	RJMP _0x42E
;     647 	}
;     648 		
;     649 	return 255;
_0x5E:
	LDI  R30,LOW(255)
	RJMP _0x42E
;     650 }
;     651 
;     652 // Чтение байта 
;     653 // Возвращает не 0, если все в порядке
;     654 unsigned char  twi_read (unsigned char notlast)
;     655 {
_twi_read:
;     656 	timeOut ();									// запускаем тайм аут
	RCALL _timeOut
;     657 
;     658 	twi_wait_int();   
	CALL _twi_wait_int_G3
;     659 
;     660 	if(notlast)     // формируем подтверждение приема
	LD   R30,Y
	CPI  R30,0
	BREQ _0x5F
;     661 		{
;     662 			TWCR = ((1<<TWINT)+(1<<TWEA)+(1<<TWEN));
	LDI  R30,LOW(196)
	RJMP _0x434
;     663 		}
;     664 		else            // НЕ формируем подтверждение приема
_0x5F:
;     665 		{
;     666 			TWCR = ((1<<TWINT)+(1<<TWEN));
	LDI  R30,LOW(132)
_0x434:
	STS  116,R30
;     667 		}
;     668  	twi_wait_int();    
	CALL _twi_wait_int_G3
;     669 
;     670  	timeOutStop ();							// останов таймера таймаута   
	RCALL _timeOutStop
;     671 
;     672 		return TWDR;
	LDS  R30,115
	RJMP _0x42E
;     673 }
;     674 
;     675 // Изменение значения бита порта
;     676 static inline void PortBitChange(unsigned char port, unsigned char bnum, unsigned char set)
;     677 {
;     678 	register unsigned char mask;
;     679 	#asm("cli");
;	port -> Y+3
;	bnum -> Y+2
;	set -> Y+1
;	mask -> R16
;     680 
;     681 	mask = 1 << bnum;		// Маска
;     682 	if (!set)
;     683 	{
;     684 		mask ^= 0xFF;
;     685 	}
;     686 		
;     687 	switch(port)
;     688 	{
;     689 	case 'B':
;     690 		if (set) PORTB |= mask; else PORTB &= mask;
;     691 		break;
;     692 	case 'C':
;     693 		if (set) PORTC |= mask; else PORTC &= mask;
;     694 		break;
;     695 	case 'D':
;     696 		if (set) PORTD |= mask; else PORTD &= mask;
;     697 		break;
;     698 	}
;     699 	
;     700 	#asm("sei");
;     701 }
;     702 
;     703 // Передача таблицы из FLASH в I2C
;     704 void i2c_tab (flash unsigned char * tbl, void (* rwfunc)(void))
;     705 {
;     706 	register unsigned char n, p;
;     707 	register flash unsigned char * ptr;
;     708 	
;     709 	while(1)
;	*tbl -> Y+6
;	*rwfunc -> Y+4
;	n -> R16
;	p -> R17
;	*ptr -> R18,R19
;     710 	{
;     711 		if (rwfunc)			// Если нужно, запускаю ожидание готовности
;     712 		{
;     713 			(*rwfunc)();
;     714 		}
;     715 		
;     716 		n = *tbl++;
;     717 		
;     718 		if (!n)				// Если больше нечего передавать ...
;     719 		{
;     720 			return;
;     721 		}
;     722 
;     723 		if (n == 255)		// Если признак бита порта процессора ...
;     724 		{
;     725 			p = *tbl++;						// Порт B, C или D
;     726 			n = *tbl++;						// Номер бита
;     727 			PortBitChange(p, n, *tbl++);	// Взвести или сбросить
;     728 			continue;						// К следующей строке
;     729 		}
;     730 
;     731 		n = n - 2;
;     732 		
;     733 		ptr = tbl;
;     734 		while(1)
;     735 		{
;     736 			if (!twi_start())
;     737 			{
;     738 				twi_stop();
;     739 				continue;
;     740 			}
;     741 	
;     742 			if (!twi_addr(*tbl++))
;     743 			{
;     744 				twi_stop();
;     745 				tbl = ptr;
;     746 				continue;
;     747 			}
;     748 		
;     749 			break;
;     750 		}
;     751 		
;     752 		twi_byte(*tbl++);
;     753 		
;     754 		while(n--)
;     755 		{
;     756 			twi_byte(*tbl++);
;     757 		}
;     758 		
;     759 		twi_stop();
;     760 	}
;     761 }
;     762 
;     763 /*
;     764 // Передача в заданный адрес I2C nbytes байт
;     765 void i2c_bytes (unsigned char addr, unsigned char sbaddr, unsigned char nbytes, ...)
;     766 {
;     767 	va_list argptr;
;     768 	char byt;
;     769 	
;     770 	va_start(argptr, nbytes);
;     771 	
;     772 	while(1)
;     773 	{
;     774 		if (!twi_start())
;     775 		{
;     776 			twi_stop();
;     777 			continue;
;     778 		}
;     779 	
;     780 		if (!twi_addr(addr))
;     781 		{
;     782 			twi_stop();
;     783 			continue;
;     784 		}
;     785 		
;     786 		break;
;     787 	}
;     788 	
;     789 	twi_byte(sbaddr);
;     790 
;     791 	while(nbytes--)
;     792 	{
;     793 		byt = va_arg(argptr, char);
;     794 		twi_byte(byt);
;     795 	}		
;     796 	va_end(argptr);
;     797 		
;     798 	twi_stop();
;     799 }
;     800 */
;     801 
;     802 // Передача в заданный адрес I2C таблицы PSI
;     803 void i2c_psi_table (
;     804 		unsigned char addr,
;     805 		unsigned char sbaddr,
;     806 		unsigned char tblnum,
;     807 		unsigned short pid,
;     808 		unsigned char * buf)
;     809 {
;     810 	unsigned char n;
;     811 	
;     812 	pid &= 0x1FFF;
;	addr -> Y+7
;	sbaddr -> Y+6
;	tblnum -> Y+5
;	pid -> Y+3
;	*buf -> Y+1
;	n -> R16
;     813 	pid |= 0x4000;
;     814 
;     815 	while(1)
;     816 	{	
;     817 		if (!twi_start())
;     818 		{
;     819 			twi_stop();
;     820 			continue;
;     821 		}
;     822 		
;     823 		if (!twi_addr(addr))
;     824 		{
;     825 			twi_stop();
;     826 			continue;
;     827 		}
;     828 		
;     829 		break;
;     830 	}
;     831 		
;     832 	twi_byte(sbaddr);
;     833 	
;     834 	twi_byte(tblnum);
;     835 
;     836 	twi_byte(0x47);			// Заголовок пакета
;     837 	twi_byte(pid >> 8);	
;     838 	twi_byte(pid & 0xFF);	
;     839 	twi_byte(0x10);	
;     840 	twi_byte(0x00);	
;     841 	
;     842 	for (n = buf[2] + 3; n != 0; n --)
;     843 	{
;     844 		twi_byte(*buf++);
;     845 	}
;     846 	
;     847 	twi_stop();
;     848 }
;     849      
;     850 ////////////////////////////////////////////////////////////////////////////////
;     851 // Работа с внутренним каналом
;     852 
;     853 unsigned char tx1crc;

	.DSEG
_tx1crc:
	.BYTE 0x1
;     854 unsigned char rx1state = RX_IDLE;
_rx1state:
	.BYTE 0x1
;     855 unsigned char rx1crc;
_rx1crc:
	.BYTE 0x1
;     856 unsigned char rx1len;
_rx1len:
	.BYTE 0x1
;     857 unsigned char rx1buf[256];
_rx1buf:
	.BYTE 0x100
;     858 unsigned char rx1ptr;
_rx1ptr:
	.BYTE 0x1
;     859 
;     860 /*// Передача байта во "внутренний" канал
;     861 void putword1(unsigned int wd)
;     862 {
;     863 	putchar1(wd);
;     864 	putchar1(wd >> 8);
;     865 } */
;     866 
;     867 // Начало запроса во внутренний канал
;     868 void StartIntReq(unsigned char dlen) 
;     869 {

	.CSEG
_StartIntReq:
;     870 	while(1)
_0x85:
;     871 	{	
;     872 		if (!twi_start())       // Cтарт пакета
	CALL _twi_start
	CPI  R30,0
	BRNE _0x88
;     873 		{
;     874 			twi_stop();
	CALL _twi_stop
;     875 			continue;
	RJMP _0x85
;     876 		}
;     877 
;     878 		
;     879 		if (!twi_addr(0))       // Передача всем подчиненным
_0x88:
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _twi_addr
	CPI  R30,0
	BRNE _0x89
;     880 		{
;     881 			twi_stop();
	CALL _twi_stop
;     882 			continue;
	RJMP _0x85
;     883 		}
;     884 		
;     885 		break;
_0x89:
;     886 	}
;     887 
;     888 
;     889 	tx1crc = 0;					// Готовлю CRC
	LDI  R30,LOW(0)
	STS  _tx1crc,R30
;     890 
;     891 	twi_byte(PACKHDR);		    // Передаю заголовок
	LDI  R30,LOW(113)
	ST   -Y,R30
	CALL _twi_byte
;     892 	tx1crc+=(PACKHDR);
	LDS  R30,_tx1crc
	SUBI R30,-LOW(113)
	STS  _tx1crc,R30
;     893 
;     894 	twi_byte(dlen+1);			// Передаю длину
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   -Y,R30
	CALL _twi_byte
;     895 	tx1crc+=(dlen+1);
	LD   R30,Y
	SUBI R30,-LOW(1)
	LDS  R26,_tx1crc
	ADD  R30,R26
	STS  _tx1crc,R30
;     896 }
_0x42E:
	ADIW R28,1
	RET
;     897 
;     898 // Завершение запроса во внутренний канал
;     899 void EndIntReq(void)
;     900 {
_EndIntReq:
;     901 	twi_byte(tx1crc);			// Контрольная сумма
	LDS  R30,_tx1crc
	ST   -Y,R30
	CALL _twi_byte
;     902 	twi_stop();                 // Cтоп
	CALL _twi_stop
;     903 
;     904 	
;     905 //	rx1state = RX_LEN;			// Приемнику начать прием пакета
;     906 
;     907 //	OCR1B = TCNT1+RX1TIMEOUT;	// Взвожу тайм-аут
;     908 //	TIFR = 0x08;				// Предотвращаю ложное срабатывание
;     909 //	TIMSK |= 0x08;				// Разрешение прерывания по тайм-ауту
;     910 }
	RET
;     911 
;     912 // Прием байта из "внутреннего" канала TWI
;     913 void TWI_rx_isr(void)
;     914 {
;     915 	register unsigned char byt;
;     916 	twi_start();                //Запрашиваю байт ответа
;	byt -> R16
;     917     	
;     918     
;     919 	byt = UDR1;
;     920 	
;     921 	switch (rx1state)
;     922 	{
;     923 	case RX_LEN:				// Принята длина пакета
;     924 		rx1crc = 0;
;     925 		rx1ptr = 0;
;     926 		rx1len = byt - 1;
;     927 		if (rx1len)
;     928 		{
;     929 			rx1state = RX_DATA;
;     930 		}
;     931 		else
;     932 		{
;     933 			rx1state = RX_CRC;
;     934 		}
;     935 //printf("L%d", rx1len);
;     936 		break;
;     937 
;     938 	case RX_DATA:				// Принят байт данных пакета
;     939 //printf("D");
;     940 		rx1buf[rx1ptr++] = byt;
;     941 		if (rx1ptr < rx1len)	// Уже все ?
;     942 		{
;     943 			break;
;     944 		}
;     945 		rx1state = RX_CRC;
;     946 		break;
;     947 		
;     948 	case RX_CRC:				// Принята контрольная сумма пакета
;     949 		if (byt != rx1crc)
;     950 		{
;     951 			rx1state = RX_ERR;	// Не сошлась CRC
;     952 //printf("C");
;     953 		}
;     954 		else
;     955 		{
;     956 			rx1state = RX_OK;	// Пакет успешно принят
;     957 //printf("+");
;     958 		}
;     959 
;     960 		TIMSK &= 0x08 ^ 0xFF;	// Запретить прерывание по тайм-ауту
;     961 		break;
;     962 
;     963 	default:					// В остальных состояниях - ничего не делать
;     964 		break;
;     965 	}
;     966 
;     967 	rx1crc += byt;				// Подсчитываю контрольную сумму
;     968 } 
;     969 
;     970 // Прерывание по сравнению B таймера 1 для подсчета тайм-аута приема "внутреннего" канала
;     971 interrupt [TIM1_COMPB] void timer1_comp_b_isr(void)
;     972 {
_timer1_comp_b_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
;     973 	rx1state = RX_TIME;		// Был тайм-аут
	LDI  R30,LOW(8)
	STS  _rx1state,R30
;     974 	TIMSK &= 0x08 ^ 0xFF;	// Запретить прерывание по тайм-ауту
	IN   R30,0x37
	ANDI R30,0XF7
	OUT  0x37,R30
;     975 //printf("T");
;     976 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;     977 
;     978 // Проверка занятости "внутреннего" канала
;     979 unsigned char InternalComBusy(void)
;     980 {
;     981 	if (rx1state != RX_IDLE)	return 1;
;     982 	else						return 0;
;     983 }
;     984 
;     985 // Признак завершения цикла обмена во внутрю канале
;     986 unsigned char HaveInternalReply(void)
;     987 {
;     988 	switch(rx1state)
;     989 	{
;     990 	case RX_OK:
;     991 	case RX_TIME:
;     992 	case RX_ERR:
;     993 		return rx1state;
;     994 	default:
;     995 		return 0;
;     996 	}
;     997 }
;     998 
;     999 // Необходимо вызвать после завершения обработки принятого по "внутреннему" каналу пакета
;    1000 void FreeInternalCom(void)
;    1001 {
;    1002 	rx1state = RX_IDLE;
;    1003 }
;    1004 
;    1005 // Передача байта byte по pAddr
;    1006 unsigned char txTWIbyte (unsigned char pAddr, unsigned char byte)
;    1007 	{  
_txTWIbyte:
;    1008 
;    1009 		timeOut ();									// запускаем тайм аут
	RCALL _timeOut
;    1010 
;    1011 		if (!twi_start())     		  				// Cтарт пакета
	CALL _twi_start
	CPI  R30,0
	BRNE _0xA1
;    1012 			{
;    1013 				twi_stop();
	CALL _twi_stop
;    1014 			}
;    1015 		
;    1016 		if (!twi_addr((pAddr<<1)+0))       // Передача  по адресу pAddr (мл 0 - запись)
_0xA1:
	LDD  R30,Y+1
	LSL  R30
	ST   -Y,R30
	CALL _twi_addr
	CPI  R30,0
	BRNE _0xA2
;    1017 			{
;    1018 				twi_stop();
	CALL _twi_stop
;    1019 			}            
;    1020 			
;    1021 		twi_byte(byte);								// передаем байт
_0xA2:
	LD   R30,Y
	ST   -Y,R30
	CALL _twi_byte
;    1022 		twi_stop();									// стоп пакета
	CALL _twi_stop
;    1023 
;    1024 		timeOutStop ();							// останов таймера таймаута   
	RCALL _timeOutStop
;    1025 		
;    1026 	    if ( ! ( flagTWI & ( 1 << time_is_Out))) return 255;
	LDS  R30,_flagTWI
	ANDI R30,LOW(0x1)
	BRNE _0xA3
	LDI  R30,LOW(255)
	RJMP _0x42D
;    1027 	    	else 
_0xA3:
;    1028 	    		{
;    1029 					flagTWI  = flagTWI  ^ (1 << time_is_Out);	//сбрасываем  признак
	LDS  R26,_flagTWI
	LDI  R30,LOW(1)
	EOR  R30,R26
	STS  _flagTWI,R30
;    1030 					return 0;
	LDI  R30,LOW(0)
;    1031 	    		}
;    1032 	}
_0x42D:
	ADIW R28,2
	RET
;    1033 
;    1034 unsigned char txTWIbuff (unsigned char pAddr)
;    1035 	{                                                                           
_txTWIbuff:
;    1036 		unsigned char a ;
;    1037 		
;    1038 		timeOut ();									// запускаем тайм аут
	ST   -Y,R16
;	pAddr -> Y+1
;	a -> R16
	RCALL _timeOut
;    1039 		if (!twi_start())     		  				// Cтарт пакета
	CALL _twi_start
	CPI  R30,0
	BRNE _0xA5
;    1040 			{
;    1041 				twi_stop();
	CALL _twi_stop
;    1042 			}
;    1043 
;    1044 		if (!twi_addr((pAddr<<1)+0))       // Передача  по адресу pAddr (мл 0 - запись)
_0xA5:
	LDD  R30,Y+1
	LSL  R30
	ST   -Y,R30
	CALL _twi_addr
	CPI  R30,0
	BRNE _0xA6
;    1045 			{
;    1046 				twi_stop();
	CALL _twi_stop
;    1047 			}            
;    1048 
;    1049 	twi_wait_int(); 					// ждем отклик на адрес
_0xA6:
	CALL _twi_wait_int_G3
;    1050 
;    1051 		for (a=0;a<=txBuffer[1]+1;a++)     //длина+заголовок
	LDI  R16,LOW(0)
_0xA8:
	__GETB1MN _txBuffer,1
	SUBI R30,-LOW(1)
	CP   R30,R16
	BRLO _0xA9
;    1052 			{		                         
;    1053 				twi_byte(txBuffer[a]);				// передаем байт
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	LD   R30,Z
	ST   -Y,R30
	CALL _twi_byte
;    1054 			}		
	SUBI R16,-1
	RJMP _0xA8
_0xA9:
;    1055 
;    1056 			twi_stop();									// стоп пакета
	CALL _twi_stop
;    1057 			timeOutStop ();							// останов таймера таймаута   
	RCALL _timeOutStop
;    1058 		
;    1059 	    	if ( ! ( flagTWI & ( 1 << time_is_Out))) return 255;
	LDS  R30,_flagTWI
	ANDI R30,LOW(0x1)
	BRNE _0xAA
	LDI  R30,LOW(255)
	RJMP _0x42B
;    1060 	    		else 
_0xAA:
;    1061 	    			{
;    1062 						flagTWI  = flagTWI  ^ (1 << time_is_Out);	//сбрасываем  признак
	LDS  R26,_flagTWI
	LDI  R30,LOW(1)
	EOR  R30,R26
	STS  _flagTWI,R30
;    1063 						return 0;
	LDI  R30,LOW(0)
	RJMP _0x42B
;    1064 		    		}
;    1065 	}
;    1066 	
;    1067 
;    1068 // Вычитываем в буффер
;    1069 unsigned char rxTWIbuff (unsigned char pAddr)
;    1070 		{                                                         
_rxTWIbuff:
;    1071 		unsigned char a;
;    1072 
;    1073 		if (!twi_start())     		  				// Cтарт пакета
	ST   -Y,R16
;	pAddr -> Y+1
;	a -> R16
	CALL _twi_start
	CPI  R30,0
	BRNE _0xAC
;    1074 			{
;    1075 				twi_stop();
	CALL _twi_stop
;    1076 			}
;    1077 
;    1078 		if (!twi_addr((pAddr<<1)+1))       // Передача  по адресу pAddr (мл 1 - чтение)
_0xAC:
	LDD  R30,Y+1
	LSL  R30
	SUBI R30,-LOW(1)
	ST   -Y,R30
	CALL _twi_addr
	CPI  R30,0
	BRNE _0xAD
;    1079 			{
;    1080 				twi_stop();
	CALL _twi_stop
;    1081 			}            
;    1082 
;    1083 		rxBuffer[0] = twi_read(1);				// читаем  и запоминаем  длину принимаемого пакета
_0xAD:
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _twi_read
	STS  _rxBuffer,R30
;    1084 
;    1085 		for (a=1; a<rxBuffer[0];  a++)
	LDI  R16,LOW(1)
_0xAF:
	LDS  R30,_rxBuffer
	CP   R16,R30
	BRSH _0xB0
;    1086 			{
;    1087 				rxBuffer[a] = twi_read(1);			// не посл. байт - формируем ACK
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_rxBuffer)
	SBCI R31,HIGH(-_rxBuffer)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _twi_read
	POP  R26
	POP  R27
	ST   X,R30
;    1088 			}              
	SUBI R16,-1
	RJMP _0xAF
_0xB0:
;    1089 
;    1090 				rxBuffer[a] = twi_read(0);			// посл. байт -  не формируем ACK
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_rxBuffer)
	SBCI R31,HIGH(-_rxBuffer)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _twi_read
	POP  R26
	POP  R27
	ST   X,R30
;    1091 
;    1092 			twi_stop();									// стоп пакета               
	CALL _twi_stop
;    1093 			
;    1094 						// Проверяем таймаут и CRC
;    1095 	    	if ( (! ( flagTWI & ( 1 << time_is_Out))) && (rxCRC())) return 255;	//Ok
	LDS  R30,_flagTWI
	ANDI R30,LOW(0x1)
	BRNE _0xB2
	RCALL _rxCRC
	CPI  R30,0
	BRNE _0xB3
_0xB2:
	RJMP _0xB1
_0xB3:
	LDI  R30,LOW(255)
	RJMP _0x42B
;    1096     		else 
_0xB1:
;    1097 	    			{
;    1098 						flagTWI  = flagTWI  ^ (1 << time_is_Out);		//сбрасываем  признак
	LDS  R26,_flagTWI
	LDI  R30,LOW(1)
	EOR  R30,R26
	STS  _flagTWI,R30
;    1099 						return 0;                                                          // Time Out
	LDI  R30,LOW(0)
	RJMP _0x42B
;    1100 		    		}
;    1101 		}
;    1102 #include "Coding.h"
;    1103 
;    1104 unsigned char flagTWI				=	0;

	.DSEG
_flagTWI:
	.BYTE 0x1
;    1105 unsigned char int_Devices		=	0;			// количество подчиненных устройств
_int_Devices:
	.BYTE 0x1
;    1106 
;    1107 
;    1108 
;    1109 // Инициализация выводов
;    1110 void portInit (void)
;    1111 		{

	.CSEG
_portInit:
;    1112 			DDRB.7 = 1;		// testpin
	SBI  0x17,7
;    1113 			CS_DDR_SET();	// для CF Card
	SBI  0x17,4
;    1114 		}
	RET
;    1115 
;    1116 
;    1117 
;    1118 // -------------------- Функции работы с таймером 0 -------------------------------
;    1119 ///////////////////////////////////////////////////////////////////////////////////////////////
;    1120 // Timer/Counter 0 initialization ; Clock source: System Clock
;    1121 // Clock value: 31,250 kHz ;  Mode: Normal top=FFh
;    1122 ///////////////////////////////////////////////////////////////////////////////////////////////
;    1123 void timer_0_Init  (void)
;    1124 	{
_timer_0_Init:
;    1125 		ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;    1126 		TCCR0=0x0;        //0x06 -start
	OUT  0x33,R30
;    1127 		TCNT0=0x01;
	LDI  R30,LOW(1)
	OUT  0x32,R30
;    1128 		OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x31,R30
;    1129 
;    1130 		TIMSK=0x01;			// Timer(s)/Counter(s) Interrupt(s) initialization
	LDI  R30,LOW(1)
	OUT  0x37,R30
;    1131 		ETIMSK=0x00;
	LDI  R30,LOW(0)
	STS  125,R30
;    1132 
;    1133 	}
	RET
;    1134 
;    1135 // запускаем таймер для таймаута
;    1136 void timeOut (void)
;    1137 	{
_timeOut:
;    1138 //		flagTWI  = (flagTWI  ^ (1 << time_is_Out));		// сброс признака
;    1139 		TCNT0=0x0	;														// обнуляем счетчик
	LDI  R30,LOW(0)
	OUT  0x32,R30
;    1140 		TCCR0 = 0x06;													// пускаем таймер (около 10 мс)
	LDI  R30,LOW(6)
	OUT  0x33,R30
;    1141 	}
	RET
;    1142 
;    1143 // остановка таймера для таймаута
;    1144 void timeOutStop (void)
;    1145 	{
_timeOutStop:
;    1146 		TCCR0 = 0x0; 						// осттанов таймера (около 10 мс)
	LDI  R30,LOW(0)
	OUT  0x33,R30
;    1147 	}
	RET
;    1148 
;    1149 
;    1150 // Timer 0 overflow interrupt service routine
;    1151 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;    1152 {
_timer0_ovf_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
;    1153 		TCCR0 = 0x0;						//останавливаем таймер
	LDI  R30,LOW(0)
	OUT  0x33,R30
;    1154 		flagTWI  = flagTWI  | (1 << time_is_Out);	 //взводим признак    
	LDS  R30,_flagTWI
	ORI  R30,1
	STS  _flagTWI,R30
;    1155 
;    1156 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;    1157                                                                                              
;    1158 // Проверяем количество подчиненных устройств
;    1159 void verIntDev (void)
;    1160 	{
_verIntDev:
;    1161 		unsigned char a;
;    1162 		for (a=1; a<10;a++)				// сканируем количество подчиненных устройств 
	ST   -Y,R16
;	a -> R16
	LDI  R16,LOW(1)
_0xB6:
	CPI  R16,10
	BRSH _0xB7
;    1163 			{											//  адреса начинаются с 1
;    1164 				if (!(txTWIbyte ( a, 0xaa))) break;   
	ST   -Y,R16
	LDI  R30,LOW(170)
	ST   -Y,R30
	CALL _txTWIbyte
	CPI  R30,0
	BREQ _0xB7
;    1165 			}
	SUBI R16,-1
	RJMP _0xB6
_0xB7:
;    1166         int_Devices = a-1;
	MOV  R30,R16
	SUBI R30,LOW(1)
	STS  _int_Devices,R30
;    1167 		lAddrDevice[0] = lAddrDevice;	// запоминаем кол-во портов 232
	LDI  R30,LOW(_lAddrDevice)
	LDI  R31,HIGH(_lAddrDevice)
	STS  _lAddrDevice,R30
;    1168 	}     
	RJMP _0x42A
;    1169 	
;    1170 // считаем КС принятого пакета
;    1171 unsigned char rxCRC (void)
;    1172 	{                    
_rxCRC:
;    1173 		unsigned char KS = 0, a;		
;    1174 			for (a=0; a< rxBuffer [0] ;a++)
	ST   -Y,R17
	ST   -Y,R16
;	KS -> R16
;	a -> R17
	LDI  R16,0
	LDI  R17,LOW(0)
_0xBA:
	LDS  R30,_rxBuffer
	CP   R17,R30
	BRSH _0xBB
;    1175 				{
;    1176 					KS =KS+rxBuffer [a];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_rxBuffer)
	SBCI R31,HIGH(-_rxBuffer)
	LD   R30,Z
	ADD  R16,R30
;    1177 				}                                     
	SUBI R17,-1
	RJMP _0xBA
_0xBB:
;    1178 			if (KS == rxBuffer [a]) return 255; 	//Ok
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_rxBuffer)
	SBCI R31,HIGH(-_rxBuffer)
	LD   R30,Z
	CP   R30,R16
	BRNE _0xBC
	LDI  R30,LOW(255)
	RJMP _0x42C
;    1179 			else return 0;                                         // Error
_0xBC:
	LDI  R30,LOW(0)
;    1180 		
;    1181 	}	        
_0x42C:
	LD   R16,Y+
	LD   R17,Y+
	RET
;    1182 
;    1183 // вычитываем логические адреса устройств
;    1184 void ReadLogAddr (void)
;    1185 		{          
_ReadLogAddr:
;    1186 		unsigned char b;
;    1187 		
;    1188 					txBuffer[0] = 'q';								// заголовок
	ST   -Y,R16
;	b -> R16
	LDI  R30,LOW(113)
	STS  _txBuffer,R30
;    1189 					txBuffer[1] = 3;		                 		// длина
	LDI  R30,LOW(3)
	__PUTB1MN _txBuffer,1
;    1190 					txBuffer[2] = 0;                   		// адрес
	LDI  R30,LOW(0)
	__PUTB1MN _txBuffer,2
;    1191 					txBuffer[3] = GetLogAddr;       		// тип
	LDI  R30,LOW(1)
	__PUTB1MN _txBuffer,3
;    1192 					txBuffer[4] = 'q'+3+0+GetLogAddr; 		//KC
	LDI  R30,LOW(117)
	__PUTB1MN _txBuffer,4
;    1193 
;    1194 for (b=1; b<= int_Devices; b++)
	LDI  R16,LOW(1)
_0xBF:
	LDS  R30,_int_Devices
	CP   R30,R16
	BRLO _0xC0
;    1195 	{
;    1196 					txTWIbuff (b);		//передаем 
	ST   -Y,R16
	CALL _txTWIbuff
;    1197 					delay_ms (20);          
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
;    1198 					rxTWIbuff (b);
	ST   -Y,R16
	CALL _rxTWIbuff
;    1199 //putchar (b);
;    1200 //putchar (rxBuffer[1]);					
;    1201 					lAddrDevice [b] = rxBuffer[1];		// запоминаем лог. адреса портов       
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_lAddrDevice)
	SBCI R27,HIGH(-_lAddrDevice)
	__GETB1MN _rxBuffer,1
	ST   X,R30
;    1202      }
	SUBI R16,-1
	RJMP _0xBF
_0xC0:
;    1203 				
;    1204 }  
	RJMP _0x42A
;    1205 
;    1206 // ретранслируем пакет
;    1207 void		recompPack (unsigned char device)
;    1208 	{
_recompPack:
;    1209 		unsigned char a, b=0;
;    1210 					txBuffer[0] = PACKHDR;				// заголовок
	ST   -Y,R17
	ST   -Y,R16
;	device -> Y+2
;	a -> R16
;	b -> R17
	LDI  R17,0
	LDI  R30,LOW(113)
	STS  _txBuffer,R30
;    1211 					txBuffer[1] = rx0len+3;            		// длина (+3 - тк. вычлось при приеме)
	MOV  R30,R13
	SUBI R30,-LOW(3)
	__PUTB1MN _txBuffer,1
;    1212 					txBuffer[2] = rx0addr;                 	// адрес
	__POINTW2MN _txBuffer,2
	LDS  R30,_rx0addr
	ST   X,R30
;    1213 					txBuffer[3] = rx0type;					// тип
	__PUTBMRN _txBuffer,3,14
;    1214 
;    1215 					for (a=4; a<=(rx0len+4); a++)
	LDI  R16,LOW(4)
_0xC2:
	MOV  R30,R13
	SUBI R30,-LOW(4)
	CP   R30,R16
	BRLO _0xC3
;    1216 						{
;    1217 							txBuffer[a] = rx0buf 	[b++];				
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_txBuffer)
	SBCI R27,HIGH(-_txBuffer)
	MOV  R30,R17
	SUBI R17,-1
	LDI  R31,0
	SUBI R30,LOW(-_rx0buf)
	SBCI R31,HIGH(-_rx0buf)
	LD   R30,Z
	ST   X,R30
;    1218 						}                   
	SUBI R16,-1
	RJMP _0xC2
_0xC3:
;    1219 
;    1220 					txTWIbuff (device);								//передаем 
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _txTWIbuff
;    1221 
;    1222 
;    1223 	}
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
;    1224 	
;    1225 // пингуем подчиненное для проверки информации
;    1226 void pingPack (unsigned char device)
;    1227 	{
_pingPack:
;    1228 	unsigned char a;
;    1229 			
;    1230 					txBuffer[0] = 'q';									// заголовок
	ST   -Y,R16
;	device -> Y+1
;	a -> R16
	LDI  R30,LOW(113)
	STS  _txBuffer,R30
;    1231 					txBuffer[1] = 3;                 					// длина
	LDI  R30,LOW(3)
	__PUTB1MN _txBuffer,1
;    1232 					txBuffer[2] = 0;                   				// адрес
	LDI  R30,LOW(0)
	__PUTB1MN _txBuffer,2
;    1233 					txBuffer[3] = pingPacket;       				// тип
	LDI  R30,LOW(2)
	__PUTB1MN _txBuffer,3
;    1234 					txBuffer[4] = 'q'+3+0+pingPacket; 		// KC
	LDI  R30,LOW(118)
	__PUTB1MN _txBuffer,4
;    1235 
;    1236 					txTWIbuff (device);								// передаем 
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _txTWIbuff
;    1237 					delay_ms (20);          
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
;    1238 					rxTWIbuff (device);                  			// принимаем
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _rxTWIbuff
;    1239 
;    1240 					if (rxBuffer[0] )
	LDS  R30,_rxBuffer
	CPI  R30,0
	BREQ _0xC4
;    1241 						{
;    1242 						UCSR0B.3 = 1;								// Разрешаю передатчик
	SBI  0xA,3
;    1243                             	for (a=0;a<=rxBuffer[0];a++)
	LDI  R16,LOW(0)
_0xC6:
	LDS  R30,_rxBuffer
	CP   R30,R16
	BRLO _0xC7
;    1244 									{
;    1245 										putchar0 (rxBuffer [a]);
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_rxBuffer)
	SBCI R31,HIGH(-_rxBuffer)
	LD   R30,Z
	ST   -Y,R30
	CALL _putchar0
;    1246 									}     
	SUBI R16,-1
	RJMP _0xC6
_0xC7:
;    1247 						rx0state = RX_HDR;					// Разрешаю прием след. запроса
	LDI  R30,LOW(1)
	MOV  R11,R30
;    1248 						
;    1249 						}          
;    1250 	
;    1251 	
;    1252 	}
_0xC4:
_0x42B:
	LDD  R16,Y+0
	ADIW R28,2
	RET
;    1253 	
;    1254 
;    1255 	
;    1256 	
;    1257 
;    1258 
;    1259 #include "Coding.h"
;    1260 
;    1261 void flash_Work (void)
;    1262 	{  
_flash_Work:
;    1263 		unsigned char a;
;    1264 		switch(rx0buf[0])
	ST   -Y,R16
;	a -> R16
	LDS  R30,_rx0buf
;    1265 			{
;    1266 				case PT_Fcreate: 		// создать и открыть файл
	CPI  R30,LOW(0x1)
	BRNE _0xCB
;    1267 					{       
;    1268 LedRed();
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,0
	SBI  0x1B,1
;    1269 
;    1270 						pntr1 = fcreate(str->fname, 0); 
	MOVW R30,R4
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _fcreate
	MOVW R8,R30
;    1271 
;    1272 						if (!(pntr1)) putchar (0); 						// если не могу создать файл то возращаем 0
	MOV  R0,R8
	OR   R0,R9
	BRNE _0xCC
	LDI  R30,LOW(0)
	RJMP _0x435
;    1273 						else putchar (0x255);
_0xCC:
	LDI  R30,LOW(597)
_0x435:
	ST   -Y,R30
	CALL _putchar
;    1274 
;    1275 //						fputc('S', pntr1);      // write an ‘S’ to the file, increment file pointer */ 
;    1276 //						fputs(str->fname, pntr1);    // add “Hello World!\r\n” to the end of the file 
;    1277  
;    1278 						break;
	RJMP _0xCA
;    1279 					}
;    1280 				case PT_Fopen: 		// открыть файл
_0xCB:
	CPI  R30,LOW(0x2)
	BREQ _0xCA
;    1281 					{       
;    1282 					
;    1283 						break;
;    1284 					}
;    1285 
;    1286 				case PT_Fclose:
	CPI  R30,LOW(0x3)
	BRNE _0xCF
;    1287 					{
;    1288 LedRed();
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,0
	SBI  0x1B,1
;    1289 					    fclose(pntr1);     							   	// Close          
	ST   -Y,R9
	ST   -Y,R8
	CALL _fclose
;    1290 
;    1291 						if (!(pntr1)) putchar (0); 						// если не могу создать файл то возращаем 0
	MOV  R0,R8
	OR   R0,R9
	BRNE _0xD0
	LDI  R30,LOW(0)
	RJMP _0x436
;    1292 						else putchar (0x255);
_0xD0:
	LDI  R30,LOW(597)
_0x436:
	ST   -Y,R30
	CALL _putchar
;    1293 						break;
	RJMP _0xCA
;    1294 					}
;    1295 
;    1296 				case PT_Fremove:
_0xCF:
	CPI  R30,LOW(0x4)
	BREQ _0xCA
;    1297 					{
;    1298 						break;
;    1299 					}
;    1300 
;    1301 				case PT_Frename:
	CPI  R30,LOW(0x5)
	BREQ _0xCA
;    1302 					{
;    1303 						break;
;    1304 					}
;    1305 
;    1306 				case PT_Ffseek:
	CPI  R30,LOW(0x6)
	BREQ _0xCA
;    1307 					{
;    1308 						break;
;    1309 					}
;    1310 
;    1311 				case PT_Fformat:
	CPI  R30,LOW(0x7)
	BRNE _0xD5
;    1312 					{
;    1313 						fquickformat();    			// Delete all information on the card 
	CALL _fquickformat
;    1314 						break;
	RJMP _0xCA
;    1315 					}
;    1316 
;    1317 				case PT_Fadd:
_0xD5:
	CPI  R30,LOW(0x8)
	BRNE _0xCA
;    1318 					{
;    1319 LedRed();
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,0
	SBI  0x1B,1
;    1320 //						fputs(str1->dataFlash, pntr1);    // add “Hello World!\r\n” to the end of the file 
;    1321 //						fprintf(pntr1, "%x",11);  			// output the string to the file
;    1322 
;    1323 //						strcpyf (a,0x31);
;    1324 						fflush (pntr1);
	ST   -Y,R9
	ST   -Y,R8
	CALL _fflush
;    1325 
;    1326 						if (!(pntr1)) putchar (0); 						// если не могу создать файл то возращаем 0
	MOV  R0,R8
	OR   R0,R9
	BRNE _0xD7
	LDI  R30,LOW(0)
	RJMP _0x437
;    1327 						else putchar (0x255);
_0xD7:
	LDI  R30,LOW(597)
_0x437:
	ST   -Y,R30
	CALL _putchar
;    1328 						break;
;    1329 					}
;    1330 
;    1331     		}
_0xCA:
;    1332 	rx0state = RX_HDR;						// Разрешаю прием след. запроса
	LDI  R30,LOW(1)
	MOV  R11,R30
;    1333 	}
_0x42A:
	LD   R16,Y+
	RET
;    1334 
;    1335 
;    1336 
;    1337 	
;    1338 /*
;    1339 	Progressive Resources LLC
;    1340                                     
;    1341 			FlashFile
;    1342 	
;    1343 	Version : 	1.32
;    1344 	Date: 		12/31/2003
;    1345 	Author: 	Erick M. Higa
;    1346                                            
;    1347 	Software License
;    1348 	The use of Progressive Resources LLC FlashFile Source Package indicates 
;    1349 	your understanding and acceptance of the following terms and conditions. 
;    1350 	This license shall supersede any verbal or prior verbal or written, statement 
;    1351 	or agreement to the contrary. If you do not understand or accept these terms, 
;    1352 	or your local regulations prohibit "after sale" license agreements or limited 
;    1353 	disclaimers, you must cease and desist using this product immediately.
;    1354 	This product is © Copyright 2003 by Progressive Resources LLC, all rights 
;    1355 	reserved. International copyright laws, international treaties and all other 
;    1356 	applicable national or international laws protect this product. This software 
;    1357 	product and documentation may not, in whole or in part, be copied, photocopied, 
;    1358 	translated, or reduced to any electronic medium or machine readable form, without 
;    1359 	prior consent in writing, from Progressive Resources LLC and according to all 
;    1360 	applicable laws. The sole owner of this product is Progressive Resources LLC.
;    1361 
;    1362 	Operating License
;    1363 	You have the non-exclusive right to use any enclosed product but have no right 
;    1364 	to distribute it as a source code product without the express written permission 
;    1365 	of Progressive Resources LLC. Use over a "local area network" (within the same 
;    1366 	locale) is permitted provided that only a single person, on a single computer 
;    1367 	uses the product at a time. Use over a "wide area network" (outside the same 
;    1368 	locale) is strictly prohibited under any and all circumstances.
;    1369                                            
;    1370 	Liability Disclaimer
;    1371 	This product and/or license is provided as is, without any representation or 
;    1372 	warranty of any kind, either express or implied, including without limitation 
;    1373 	any representations or endorsements regarding the use of, the results of, or 
;    1374 	performance of the product, Its appropriateness, accuracy, reliability, or 
;    1375 	correctness. The user and/or licensee assume the entire risk as to the use of 
;    1376 	this product. Progressive Resources LLC does not assume liability for the use 
;    1377 	of this product beyond the original purchase price of the software. In no event 
;    1378 	will Progressive Resources LLC be liable for additional direct or indirect 
;    1379 	damages including any lost profits, lost savings, or other incidental or 
;    1380 	consequential damages arising from any defects, or the use or inability to 
;    1381 	use these products, even if Progressive Resources LLC have been advised of 
;    1382 	the possibility of such damages.
;    1383 */                                 
;    1384 
;    1385 /*
;    1386 #include _AVR_LIB_
;    1387 #include <stdio.h>
;    1388 
;    1389 #ifndef _file_sys_h_
;    1390 	#include "..\flash\file_sys.h"
;    1391 #endif
;    1392 */
;    1393 	#include <coding.h>
;    1394 
;    1395 unsigned long OCR_REG;

	.DSEG
_OCR_REG:
	.BYTE 0x4
;    1396 unsigned char _FF_buff[512];
__FF_buff:
	.BYTE 0x200
;    1397 unsigned int PT_SecStart;
_PT_SecStart:
	.BYTE 0x2
;    1398 unsigned long BS_jmpBoot;
_BS_jmpBoot:
	.BYTE 0x4
;    1399 unsigned int BPB_BytsPerSec;
_BPB_BytsPerSec:
	.BYTE 0x2
;    1400 unsigned char BPB_SecPerClus;
_BPB_SecPerClus:
	.BYTE 0x1
;    1401 unsigned int BPB_RsvdSecCnt;
_BPB_RsvdSecCnt:
	.BYTE 0x2
;    1402 unsigned char BPB_NumFATs;
_BPB_NumFATs:
	.BYTE 0x1
;    1403 unsigned int BPB_RootEntCnt;
_BPB_RootEntCnt:
	.BYTE 0x2
;    1404 unsigned int BPB_FATSz16;
_BPB_FATSz16:
	.BYTE 0x2
;    1405 unsigned char BPB_FATType;
_BPB_FATType:
	.BYTE 0x1
;    1406 unsigned long BPB_TotSec;
_BPB_TotSec:
	.BYTE 0x4
;    1407 unsigned long BS_VolSerial;
_BS_VolSerial:
	.BYTE 0x4
;    1408 unsigned char BS_VolLab[12];
_BS_VolLab:
	.BYTE 0xC
;    1409 unsigned long _FF_PART_ADDR, _FF_ROOT_ADDR, _FF_DIR_ADDR;
__FF_PART_ADDR:
	.BYTE 0x4
__FF_ROOT_ADDR:
	.BYTE 0x4
__FF_DIR_ADDR:
	.BYTE 0x4
;    1410 unsigned long _FF_FAT1_ADDR, _FF_FAT2_ADDR;
__FF_FAT1_ADDR:
	.BYTE 0x4
__FF_FAT2_ADDR:
	.BYTE 0x4
;    1411 unsigned long _FF_RootDirSectors;
__FF_RootDirSectors:
	.BYTE 0x4
;    1412 unsigned int FirstDataSector;
_FirstDataSector:
	.BYTE 0x2
;    1413 unsigned long FirstSectorofCluster;
_FirstSectorofCluster:
	.BYTE 0x4
;    1414 unsigned char _FF_error;
__FF_error:
	.BYTE 0x1
;    1415 unsigned long _FF_buff_addr;
__FF_buff_addr:
	.BYTE 0x4
;    1416 extern unsigned long clus_0_addr, _FF_n_temp;
;    1417 extern unsigned int c_counter;
;    1418 //extern unsigned char _FF_FULL_PATH[_FF_PATH_LENGTH];
;    1419 
;    1420 unsigned long DataClusTot;
_DataClusTot:
	.BYTE 0x4
;    1421 
;    1422 flash struct CMD
;    1423 {
;    1424 	unsigned int index;
;    1425 	unsigned int tx_data;
;    1426 	unsigned int arg;
;    1427 	unsigned int resp;
;    1428 };
;    1429 
;    1430 flash struct CMD sd_cmd[CMD_TOT] =

	.CSEG
;    1431 {
;    1432 	{CMD0,	0x40,	NO_ARG,		RESP_1},		// GO_IDLE_STATE
;    1433 	{CMD1,	0x41,	NO_ARG,		RESP_1},		// SEND_OP_COND (ACMD41 = 0x69)
;    1434 	{CMD9,	0x49,	NO_ARG,		RESP_1},		// SEND_CSD
;    1435 	{CMD10,	0x4A,	NO_ARG,		RESP_1},		// SEND_CID
;    1436 	{CMD12,	0x4C,	NO_ARG,		RESP_1},		// STOP_TRANSMISSION
;    1437 	{CMD13,	0x4D,	NO_ARG,		RESP_2},		// SEND_STATUS
;    1438 	{CMD16,	0x50,	BLOCK_LEN,	RESP_1},		// SET_BLOCKLEN
;    1439 	{CMD17, 0x51,	DATA_ADDR,	RESP_1},		// READ_SINGLE_BLOCK
;    1440 	{CMD18, 0x52,	DATA_ADDR,	RESP_1},		// READ_MULTIPLE_BLOCK
;    1441 	{CMD24, 0x58,	DATA_ADDR,	RESP_1},		// WRITE_BLOCK
;    1442 	{CMD25, 0x59,	DATA_ADDR,	RESP_1},		// WRITE_MULTIPLE_BLOCK
;    1443 	{CMD27,	0x5B,	NO_ARG,		RESP_1},		// PROGRAM_CSD
;    1444 	{CMD28, 0x5C,	DATA_ADDR,	RESP_1b},		// SET_WRITE_PROT
;    1445 	{CMD29, 0x5D,	DATA_ADDR,	RESP_1b},		// CLR_WRITE_PROT
;    1446 	{CMD30, 0x5E,	DATA_ADDR,	RESP_1},		// SEND_WRITE_PROT
;    1447 	{CMD32,	0x60,	DATA_ADDR,	RESP_1},		// TAG_SECTOR_START
;    1448 	{CMD33,	0x61,	DATA_ADDR,	RESP_1},		// TAG_SECTOR_END
;    1449 	{CMD34,	0x62,	DATA_ADDR,	RESP_1},		// UNTAG_SECTOR
;    1450 	{CMD35,	0x63,	DATA_ADDR,	RESP_1},		// TAG_ERASE_GROUP_START
;    1451 	{CMD36,	0x64,	DATA_ADDR,	RESP_1},		// TAG_ERASE_GROUP_END
;    1452 	{CMD37,	0x65,	DATA_ADDR,	RESP_1},		// TAG_ERASE_GROUP
;    1453 	{CMD38,	0x66,	STUFF_BITS,	RESP_1b},		// ERASE
;    1454 	{CMD42,	0x6A,	STUFF_BITS,	RESP_1b},		// LOCK_UNLOCK
;    1455 	{CMD58,	0x7A,	NO_ARG,		RESP_3},		// READ_OCR
;    1456 	{CMD59,	0x7B,	STUFF_BITS,	RESP_1},		// CRC_ON_OFF
;    1457 	{ACMD41, 0x69,	NO_ARG,		RESP_1}
;    1458 };
;    1459 
;    1460 unsigned char _FF_spi(unsigned char mydata)
;    1461 {
__FF_spi:
;    1462     SPDR = mydata;          //byte 1
	LD   R30,Y
	OUT  0xF,R30
;    1463     while ((SPSR&0x80) == 0); 
_0xD9:
	SBIS 0xE,7
	RJMP _0xD9
;    1464     return SPDR;
	IN   R30,0xF
	RJMP _0x424
;    1465 }
;    1466 	
;    1467 unsigned int send_cmd(unsigned char command, unsigned long argument)
;    1468 {
_send_cmd:
;    1469 	unsigned char spi_data_out;
;    1470 	unsigned char response_1;
;    1471 	unsigned long response_2;
;    1472 	unsigned int c, i;
;    1473 	
;    1474 	SD_CS_ON();			// select chip
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
;    1475 	
;    1476 	spi_data_out = sd_cmd[command].tx_data;
	LDD  R26,Y+14
	CLR  R27
	__POINTWRFN 22,23,_sd_cmd,2
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __MULW12U
	ADD  R30,R22
	ADC  R31,R23
	LPM  R16,Z
;    1477 	_FF_spi(spi_data_out);
	ST   -Y,R16
	CALL __FF_spi
;    1478 	
;    1479 	c = sd_cmd[command].arg;
	LDD  R26,Y+14
	CLR  R27
	__POINTWRFN 22,23,_sd_cmd,4
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __MULW12U
	ADD  R30,R22
	ADC  R31,R23
	CALL __GETW1PF
	MOVW R18,R30
;    1480 	if (c == NO_ARG)
	MOV  R0,R18
	OR   R0,R19
	BRNE _0xDC
;    1481 		for (i=0; i<4; i++)
	__GETWRN 20,21,0
_0xDE:
	__CPWRN 20,21,4
	BRSH _0xDF
;    1482 			_FF_spi(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL __FF_spi
;    1483 	else
	__ADDWRN 20,21,1
	RJMP _0xDE
_0xDF:
	RJMP _0xE0
_0xDC:
;    1484 	{
;    1485 		spi_data_out = (argument & 0xFF000000) >> 24;
	__GETD1S 10
	__ANDD1N 0xFF000000
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(24)
	CALL __LSRD12
	MOV  R16,R30
;    1486 		_FF_spi(spi_data_out);
	ST   -Y,R16
	CALL __FF_spi
;    1487 		spi_data_out = (argument & 0x00FF0000) >> 16;
	__GETD1S 10
	__ANDD1N 0xFF0000
	CALL __LSRD16
	MOV  R16,R30
;    1488 		_FF_spi(spi_data_out);
	ST   -Y,R16
	CALL __FF_spi
;    1489 		spi_data_out = (argument & 0x0000FF00) >> 8;
	__GETD1S 10
	__ANDD1N 0xFF00
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(8)
	CALL __LSRD12
	MOV  R16,R30
;    1490 		_FF_spi(spi_data_out);
	ST   -Y,R16
	CALL __FF_spi
;    1491 		spi_data_out = (argument & 0x000000FF);
	__GETD1S 10
	__ANDD1N 0xFF
	MOV  R16,R30
;    1492 		_FF_spi(spi_data_out);
	ST   -Y,R16
	CALL __FF_spi
;    1493 	}
_0xE0:
;    1494 	if (command == CMD0)
	LDD  R30,Y+14
	CPI  R30,0
	BRNE _0xE1
;    1495 		spi_data_out = 0x95;		// CRC byte, don't care except for first signal=0x95
	LDI  R16,LOW(149)
;    1496 	else
	RJMP _0xE2
_0xE1:
;    1497 		spi_data_out = 0xFF;
	LDI  R16,LOW(255)
;    1498 	_FF_spi(spi_data_out);
_0xE2:
	ST   -Y,R16
	CALL __FF_spi
;    1499 	_FF_spi(0xff);	
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
;    1500 	c = sd_cmd[command].resp;
	LDD  R26,Y+14
	CLR  R27
	__POINTWRFN 22,23,_sd_cmd,6
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __MULW12U
	ADD  R30,R22
	ADC  R31,R23
	CALL __GETW1PF
	MOVW R18,R30
;    1501 	switch(c)
	MOVW R30,R18
;    1502 	{
;    1503 		case RESP_1:
	SBIW R30,0
	BRNE _0xE6
;    1504 			return (_FF_spi(0xFF));
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	LDI  R31,0
	RJMP _0x429
;    1505 			break;
;    1506 		case RESP_1b:
_0xE6:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xE7
;    1507 			response_1 = _FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	MOV  R17,R30
;    1508 			response_2 = 0;
	__CLRD1S 6
;    1509 			while (response_2 == 0)
_0xE8:
	__GETD1S 6
	CALL __CPD10
	BRNE _0xEA
;    1510 				response_2 = _FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	CLR  R31
	CLR  R22
	CLR  R23
	__PUTD1S 6
;    1511 			return (response_1);
	RJMP _0xE8
_0xEA:
	MOV  R30,R17
	LDI  R31,0
	RJMP _0x429
;    1512 			break;
;    1513 		case RESP_2:
_0xE7:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xEB
;    1514 			response_2 = _FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	CLR  R31
	CLR  R22
	CLR  R23
	__PUTD1S 6
;    1515 			response_2 = (response_2 << 8) | _FF_spi(0xFF);
	__GETD2S 6
	LDI  R30,LOW(8)
	CALL __LSLD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __ORD12
	__PUTD1S 6
;    1516 			return (response_2);
	RJMP _0x429
;    1517 			break;
;    1518 		case RESP_3:
_0xEB:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0xE5
;    1519 			response_1 = _FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	MOV  R17,R30
;    1520 			OCR_REG = 0;
	LDI  R30,0
	STS  _OCR_REG,R30
	STS  _OCR_REG+1,R30
	STS  _OCR_REG+2,R30
	STS  _OCR_REG+3,R30
;    1521 			response_2 = _FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	CLR  R31
	CLR  R22
	CLR  R23
	__PUTD1S 6
;    1522 			OCR_REG = response_2 << 24;
	__GETD2S 6
	LDI  R30,LOW(24)
	CALL __LSLD12
	STS  _OCR_REG,R30
	STS  _OCR_REG+1,R31
	STS  _OCR_REG+2,R22
	STS  _OCR_REG+3,R23
;    1523 			response_2 = _FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	CLR  R31
	CLR  R22
	CLR  R23
	__PUTD1S 6
;    1524 			OCR_REG |= (response_2 << 16);
	CALL __LSLD16
	LDS  R26,_OCR_REG
	LDS  R27,_OCR_REG+1
	LDS  R24,_OCR_REG+2
	LDS  R25,_OCR_REG+3
	CALL __ORD12
	STS  _OCR_REG,R30
	STS  _OCR_REG+1,R31
	STS  _OCR_REG+2,R22
	STS  _OCR_REG+3,R23
;    1525 			response_2 = _FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	CLR  R31
	CLR  R22
	CLR  R23
	__PUTD1S 6
;    1526 			OCR_REG |= (response_2 << 8);
	__GETD2S 6
	LDI  R30,LOW(8)
	CALL __LSLD12
	LDS  R26,_OCR_REG
	LDS  R27,_OCR_REG+1
	LDS  R24,_OCR_REG+2
	LDS  R25,_OCR_REG+3
	CALL __ORD12
	STS  _OCR_REG,R30
	STS  _OCR_REG+1,R31
	STS  _OCR_REG+2,R22
	STS  _OCR_REG+3,R23
;    1527 			response_2 = _FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	CLR  R31
	CLR  R22
	CLR  R23
	__PUTD1S 6
;    1528 			OCR_REG |= (response_2);
	LDS  R26,_OCR_REG
	LDS  R27,_OCR_REG+1
	LDS  R24,_OCR_REG+2
	LDS  R25,_OCR_REG+3
	CALL __ORD12
	STS  _OCR_REG,R30
	STS  _OCR_REG+1,R31
	STS  _OCR_REG+2,R22
	STS  _OCR_REG+3,R23
;    1529 			return (response_1);
	MOV  R30,R17
	LDI  R31,0
	RJMP _0x429
;    1530 			break;
;    1531 	}
_0xE5:
;    1532 	return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x429:
	CALL __LOADLOCR6
	ADIW R28,15
	RET
;    1533 }
;    1534 
;    1535 void clear_sd_buff(void)
;    1536 {
_clear_sd_buff:
;    1537 	SD_CS_OFF();
	SBI  0x18,4
;    1538 	_FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
;    1539 	_FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
;    1540 }	
	RET
;    1541 
;    1542 unsigned char initialize_media(void)
;    1543 {
_initialize_media:
;    1544 	unsigned char data_temp;
;    1545 	unsigned long n;
;    1546 	
;    1547 	// SPI BUS SETUP
;    1548 	// SPI initialization
;    1549 	// SPI Type: Master
;    1550 	// SPI Clock Rate: 921.600 kHz
;    1551 	// SPI Clock Phase: Cycle Half
;    1552 	// SPI Clock Polarity: Low
;    1553 	// SPI Data Order: MSB First
;    1554 	DDRB |= 0x07;		// Set SS, SCK, and MOSI to Output (If not output, processor will be a slave)
	SBIW R28,4
	ST   -Y,R16
;	data_temp -> R16
;	n -> Y+1
	IN   R30,0x17
	ORI  R30,LOW(0x7)
	OUT  0x17,R30
;    1555 	DDRB &= 0xF7;		// Set MISO to Input
	CBI  0x17,3
;    1556 	CS_DDR_SET();		// Set CS to Output
	SBI  0x17,4
;    1557 	SPCR=0x50;
	LDI  R30,LOW(80)
	OUT  0xD,R30
;    1558 	SPSR=0x00;
	LDI  R30,LOW(0)
	OUT  0xE,R30
;    1559 		
;    1560 	BPB_BytsPerSec = 512;	// Initialize sector size to 512 (all SD cards have a 512 sector size)
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	STS  _BPB_BytsPerSec,R30
	STS  _BPB_BytsPerSec+1,R31
;    1561     _FF_n_temp = 0;
	LDI  R30,0
	STS  __FF_n_temp,R30
	STS  __FF_n_temp+1,R30
	STS  __FF_n_temp+2,R30
	STS  __FF_n_temp+3,R30
;    1562 	if (reset_sd()==0)
	RCALL _reset_sd
	CPI  R30,0
	BRNE _0xED
;    1563 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x428
;    1564 	// delay_ms(50);
;    1565 	for (n=0; ((n<100)||(data_temp==0)) ; n++)
_0xED:
	__CLRD1S 1
_0xEF:
	__GETD2S 1
	__CPD2N 0x64
	BRLO _0xF1
	CPI  R16,0
	BRNE _0xF0
_0xF1:
;    1566 	{
;    1567 		SD_CS_ON();
	CBI  0x18,4
;    1568 		data_temp = _FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	MOV  R16,R30
;    1569 		SD_CS_OFF();
	SBI  0x18,4
;    1570 	}
	__GETD1S 1
	__SUBD1N -1
	__PUTD1S 1
	RJMP _0xEF
_0xF0:
;    1571 	// delay_ms(50);
;    1572 	for (n=0; n<100; n++)
	__CLRD1S 1
_0xF4:
	__GETD2S 1
	__CPD2N 0x64
	BRSH _0xF5
;    1573 	{
;    1574 		if (init_sd())		// Initialization Succeeded
	RCALL _init_sd
	CPI  R30,0
	BRNE _0xF5
;    1575 			break;
;    1576 		if (n==99)
	__GETD2S 1
	__CPD2N 0x63
	BRNE _0xF7
;    1577 			return (0);
	LDI  R30,LOW(0)
	RJMP _0x428
;    1578 	}
_0xF7:
	__GETD1S 1
	__SUBD1N -1
	__PUTD1S 1
	RJMP _0xF4
_0xF5:
;    1579 
;    1580 	if (_FF_read(0x0)==0)
	__GETD1N 0x0
	CALL __PUTPARD1
	RCALL __FF_read
	CPI  R30,0
	BRNE _0xF8
;    1581 	{
;    1582 		#ifdef _DEBUG_ON_
;    1583 			printf("\n\rREAD_ERR"); 		
;    1584 		#endif
;    1585 		_FF_error = INIT_ERR;
	LDI  R30,LOW(1)
	STS  __FF_error,R30
;    1586 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x428
;    1587 	}
;    1588 	PT_SecStart = ((int) _FF_buff[0x1c7] << 8) | (int) _FF_buff[0x1c6];
_0xF8:
	__GETBRMN 27,__FF_buff,455
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,454
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _PT_SecStart,R30
	STS  _PT_SecStart+1,R31
;    1589 	
;    1590 	if ((((_FF_buff[0]==0xEB)&&(_FF_buff[2]==0x90))||(_FF_buff[0]==0xE9)) && ((_FF_buff[510]==0x55)&&(_FF_buff[511]==0xAA)))
	LDS  R26,__FF_buff
	CPI  R26,LOW(0xEB)
	BRNE _0xFA
	__GETB1MN __FF_buff,2
	CPI  R30,LOW(0x90)
	BREQ _0xFC
_0xFA:
	LDS  R26,__FF_buff
	CPI  R26,LOW(0xE9)
	BRNE _0xFE
_0xFC:
	__GETB1MN __FF_buff,510
	CPI  R30,LOW(0x55)
	BRNE _0xFF
	__GETB1MN __FF_buff,511
	CPI  R30,LOW(0xAA)
	BREQ _0x100
_0xFF:
	RJMP _0xFE
_0x100:
	RJMP _0x101
_0xFE:
	RJMP _0xF9
_0x101:
;    1591     	PT_SecStart = 0;
	LDI  R30,0
	STS  _PT_SecStart,R30
	STS  _PT_SecStart+1,R30
;    1592  
;    1593 	_FF_PART_ADDR = (long) PT_SecStart * (long) BPB_BytsPerSec;
_0xF9:
	LDS  R30,_PT_SecStart
	LDS  R31,_PT_SecStart+1
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	CLR  R22
	CLR  R23
	CALL __MULD12
	STS  __FF_PART_ADDR,R30
	STS  __FF_PART_ADDR+1,R31
	STS  __FF_PART_ADDR+2,R22
	STS  __FF_PART_ADDR+3,R23
;    1594 
;    1595 	if (PT_SecStart)
	LDS  R30,_PT_SecStart
	LDS  R31,_PT_SecStart+1
	SBIW R30,0
	BREQ _0x102
;    1596 	{
;    1597 		if (_FF_read(_FF_PART_ADDR)==0)
	LDS  R30,__FF_PART_ADDR
	LDS  R31,__FF_PART_ADDR+1
	LDS  R22,__FF_PART_ADDR+2
	LDS  R23,__FF_PART_ADDR+3
	CALL __PUTPARD1
	RCALL __FF_read
	CPI  R30,0
	BRNE _0x103
;    1598 		{
;    1599 		   	#ifdef _DEBUG_ON_
;    1600 				printf("\n\rREAD_ERR");
;    1601 			#endif
;    1602 			_FF_error = INIT_ERR;
	LDI  R30,LOW(1)
	STS  __FF_error,R30
;    1603 			return (0);
	LDI  R30,LOW(0)
	RJMP _0x428
;    1604 		}
;    1605 	}
_0x103:
;    1606 
;    1607  	#ifdef _DEBUG_ON_
;    1608 		printf("\n\rBoot_Sec: [0x%X %X %X] [0x%X] [0x%X]", _FF_buff[0],_FF_buff[1],_FF_buff[2],_FF_buff[510],_FF_buff[511]); 		
;    1609 	#endif
;    1610    	
;    1611     BS_jmpBoot = (((long) _FF_buff[0] << 16) | ((int) _FF_buff[1] << 8) | (int) _FF_buff[2]);    		
_0x102:
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
;    1612 	BPB_BytsPerSec = ((int) _FF_buff[0xC] << 8) | (int) _FF_buff[0xB];
	__GETBRMN 27,__FF_buff,12
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,11
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _BPB_BytsPerSec,R30
	STS  _BPB_BytsPerSec+1,R31
;    1613     BPB_SecPerClus = _FF_buff[0xD];
	__GETB1MN __FF_buff,13
	STS  _BPB_SecPerClus,R30
;    1614 	BPB_RsvdSecCnt = ((int) _FF_buff[0xF] << 8) | (int) _FF_buff[0xE];	
	__GETBRMN 27,__FF_buff,15
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,14
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _BPB_RsvdSecCnt,R30
	STS  _BPB_RsvdSecCnt+1,R31
;    1615 	BPB_NumFATs = _FF_buff[0x10];
	__GETB1MN __FF_buff,16
	STS  _BPB_NumFATs,R30
;    1616 	BPB_RootEntCnt = ((int) _FF_buff[0x12] << 8) | (int) _FF_buff[0x11];	
	__GETBRMN 27,__FF_buff,18
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,17
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _BPB_RootEntCnt,R30
	STS  _BPB_RootEntCnt+1,R31
;    1617 	BPB_FATSz16 = ((int) _FF_buff[0x17] << 8) | (int) _FF_buff[0x16];
	__GETBRMN 27,__FF_buff,23
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,22
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _BPB_FATSz16,R30
	STS  _BPB_FATSz16+1,R31
;    1618 	BPB_TotSec = ((unsigned int) _FF_buff[0x14] << 8) | (unsigned int) _FF_buff[0x13];
	__GETBRMN 27,__FF_buff,20
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,19
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	CLR  R22
	CLR  R23
	STS  _BPB_TotSec,R30
	STS  _BPB_TotSec+1,R31
	STS  _BPB_TotSec+2,R22
	STS  _BPB_TotSec+3,R23
;    1619 	if (BPB_TotSec==0)
	CALL __CPD10
	BRNE _0x104
;    1620 		BPB_TotSec = ((unsigned long) _FF_buff[0x23] << 24) | ((unsigned long) _FF_buff[0x22] << 16)
;    1621 					| ((unsigned long) _FF_buff[0x21] << 8) | ((unsigned long) _FF_buff[0x20]);
	__GETB1MN __FF_buff,35
	CLR  R31
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(24)
	CALL __LSLD12
	MOVW R26,R30
	MOVW R24,R22
	__GETB1MN __FF_buff,34
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __LSLD16
	CALL __ORD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETB1MN __FF_buff,33
	CLR  R31
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(8)
	CALL __LSLD12
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
;    1622 	BS_VolSerial = ((unsigned long) _FF_buff[0x2A] << 24) | ((unsigned long) _FF_buff[0x29] << 16)
_0x104:
;    1623 				| ((unsigned long) _FF_buff[0x28] << 8) | ((unsigned long) _FF_buff[0x27]);
	__GETB1MN __FF_buff,42
	CLR  R31
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(24)
	CALL __LSLD12
	MOVW R26,R30
	MOVW R24,R22
	__GETB1MN __FF_buff,41
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __LSLD16
	CALL __ORD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETB1MN __FF_buff,40
	CLR  R31
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(8)
	CALL __LSLD12
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
;    1624 	for (n=0; n<11; n++)
	__CLRD1S 1
_0x106:
	__GETD2S 1
	__CPD2N 0xB
	BRSH _0x107
;    1625 		BS_VolLab[n] = _FF_buff[0x2B+n];
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
;    1626 	BS_VolLab[11] = 0;		// Terminate the string
	__GETD1S 1
	__SUBD1N -1
	__PUTD1S 1
	RJMP _0x106
_0x107:
	LDI  R30,LOW(0)
	__PUTB1MN _BS_VolLab,11
;    1627 	_FF_FAT1_ADDR = _FF_PART_ADDR + ((long) BPB_RsvdSecCnt * (long) BPB_BytsPerSec); 
	LDS  R30,_BPB_RsvdSecCnt
	LDS  R31,_BPB_RsvdSecCnt+1
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	CLR  R22
	CLR  R23
	CALL __MULD12
	LDS  R26,__FF_PART_ADDR
	LDS  R27,__FF_PART_ADDR+1
	LDS  R24,__FF_PART_ADDR+2
	LDS  R25,__FF_PART_ADDR+3
	CALL __ADDD12
	STS  __FF_FAT1_ADDR,R30
	STS  __FF_FAT1_ADDR+1,R31
	STS  __FF_FAT1_ADDR+2,R22
	STS  __FF_FAT1_ADDR+3,R23
;    1628 	_FF_FAT2_ADDR = _FF_FAT1_ADDR + ((long) BPB_FATSz16 * (long) BPB_BytsPerSec);
	LDS  R30,_BPB_FATSz16
	LDS  R31,_BPB_FATSz16+1
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	CLR  R22
	CLR  R23
	CALL __MULD12
	LDS  R26,__FF_FAT1_ADDR
	LDS  R27,__FF_FAT1_ADDR+1
	LDS  R24,__FF_FAT1_ADDR+2
	LDS  R25,__FF_FAT1_ADDR+3
	CALL __ADDD12
	STS  __FF_FAT2_ADDR,R30
	STS  __FF_FAT2_ADDR+1,R31
	STS  __FF_FAT2_ADDR+2,R22
	STS  __FF_FAT2_ADDR+3,R23
;    1629 	_FF_ROOT_ADDR = ((long) BPB_NumFATs * (long) BPB_FATSz16) + (long) BPB_RsvdSecCnt;
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
;    1630 	_FF_ROOT_ADDR *= BPB_BytsPerSec;
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
;    1631 	_FF_ROOT_ADDR += _FF_PART_ADDR;
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
;    1632 	
;    1633 	_FF_RootDirSectors = ((BPB_RootEntCnt * 32) + BPB_BytsPerSec - 1) / BPB_BytsPerSec;
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
;    1634 	FirstDataSector = (BPB_NumFATs * BPB_FATSz16) + BPB_RsvdSecCnt + _FF_RootDirSectors; 
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
;    1635 	
;    1636 	DataClusTot = BPB_TotSec - FirstDataSector;
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
;    1637 	DataClusTot /= BPB_SecPerClus;
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
;    1638 	clus_0_addr = 0;		// Reset Empty Cluster table location
	LDI  R30,0
	STS  _clus_0_addr,R30
	STS  _clus_0_addr+1,R30
	STS  _clus_0_addr+2,R30
	STS  _clus_0_addr+3,R30
;    1639 	c_counter = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _c_counter,R30
	STS  _c_counter+1,R31
;    1640 	
;    1641 	if (DataClusTot < 4085)				// FAT12
	LDS  R26,_DataClusTot
	LDS  R27,_DataClusTot+1
	LDS  R24,_DataClusTot+2
	LDS  R25,_DataClusTot+3
	__CPD2N 0xFF5
	BRSH _0x108
;    1642 		BPB_FATType = 0x32;
	LDI  R30,LOW(50)
	STS  _BPB_FATType,R30
;    1643 	else if (DataClusTot < 65525)		// FAT16
	RJMP _0x109
_0x108:
	LDS  R26,_DataClusTot
	LDS  R27,_DataClusTot+1
	LDS  R24,_DataClusTot+2
	LDS  R25,_DataClusTot+3
	__CPD2N 0xFFF5
	BRSH _0x10A
;    1644 		BPB_FATType = 0x36;
	LDI  R30,LOW(54)
	STS  _BPB_FATType,R30
;    1645 	else
	RJMP _0x10B
_0x10A:
;    1646 	{
;    1647 		BPB_FATType = 0;
	LDI  R30,LOW(0)
	STS  _BPB_FATType,R30
;    1648 		_FF_error = FAT_ERR;
	LDI  R30,LOW(12)
	STS  __FF_error,R30
;    1649 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x428
;    1650 	}
_0x10B:
_0x109:
;    1651     
;    1652 	_FF_DIR_ADDR = _FF_ROOT_ADDR;		// Set current directory to root address
	LDS  R30,__FF_ROOT_ADDR
	LDS  R31,__FF_ROOT_ADDR+1
	LDS  R22,__FF_ROOT_ADDR+2
	LDS  R23,__FF_ROOT_ADDR+3
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    1653 
;    1654 	_FF_FULL_PATH[0] = 0x5C;	// a '\'
	LDI  R30,LOW(92)
	STS  __FF_FULL_PATH,R30
;    1655 	_FF_FULL_PATH[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN __FF_FULL_PATH,1
;    1656 	
;    1657 	#ifdef _DEBUG_ON_
;    1658 		printf("\n\rPart Address:  %lX", _FF_PART_ADDR);
;    1659 		printf("\n\rBS_jmpBoot:  %lX", BS_jmpBoot);
;    1660 		printf("\n\rBPB_BytsPerSec:  %X", BPB_BytsPerSec);
;    1661 		printf("\n\rBPB_SecPerClus:  %X", BPB_SecPerClus);
;    1662 		printf("\n\rBPB_RsvdSecCnt:  %X", BPB_RsvdSecCnt);
;    1663 		printf("\n\rBPB_NumFATs:  %X", BPB_NumFATs);
;    1664 		printf("\n\rBPB_RootEntCnt:  %X", BPB_RootEntCnt);
;    1665 		printf("\n\rBPB_FATSz16:  %X", BPB_FATSz16);
;    1666 		printf("\n\rBPB_TotSec16:  %lX", BPB_TotSec);
;    1667 		if (BPB_FATType == 0x32)
;    1668 			printf("\n\rBPB_FATType:  FAT12");
;    1669 		else if (BPB_FATType == 0x36)
;    1670 			printf("\n\rBPB_FATType:  FAT16");
;    1671 		else
;    1672 			printf("\n\rBPB_FATType:  FAT ERROR!!");
;    1673 		printf("\n\rClusterCnt:  %lX", DataClusTot);
;    1674 		printf("\n\rROOT_ADDR:  %lX", _FF_ROOT_ADDR);
;    1675 		printf("\n\rFAT2_ADDR:  %lX", _FF_FAT2_ADDR);
;    1676 		printf("\n\rRootDirSectors:  %X", _FF_RootDirSectors);
;    1677 		printf("\n\rFirstDataSector:  %X", FirstDataSector);
;    1678 	#endif
;    1679 	
;    1680 	return (1);	
	LDI  R30,LOW(1)
_0x428:
	LDD  R16,Y+0
	ADIW R28,5
	RET
;    1681 }
;    1682 
;    1683 unsigned char spi_speedset(void)
;    1684 {
_spi_speedset:
;    1685 	if (SPCR == 0x50)
	IN   R30,0xD
	CPI  R30,LOW(0x50)
	BRNE _0x10C
;    1686 		SPCR = 0x51;
	LDI  R30,LOW(81)
	OUT  0xD,R30
;    1687 	else if (SPCR == 0x51)
	RJMP _0x10D
_0x10C:
	IN   R30,0xD
	CPI  R30,LOW(0x51)
	BRNE _0x10E
;    1688 		SPCR = 0x52;
	LDI  R30,LOW(82)
	OUT  0xD,R30
;    1689 	else if (SPCR == 0x52)
	RJMP _0x10F
_0x10E:
	IN   R30,0xD
	CPI  R30,LOW(0x52)
	BRNE _0x110
;    1690 		SPCR = 0x53;
	LDI  R30,LOW(83)
	OUT  0xD,R30
;    1691 	else
	RJMP _0x111
_0x110:
;    1692 	{
;    1693 		SPCR = 0x50;
	LDI  R30,LOW(80)
	OUT  0xD,R30
;    1694 		return (0);
	LDI  R30,LOW(0)
	RET
;    1695 	}
_0x111:
_0x10F:
_0x10D:
;    1696 	return (1);
	LDI  R30,LOW(1)
	RET
;    1697 }
;    1698 
;    1699 unsigned char reset_sd(void)
;    1700 {
_reset_sd:
;    1701 	unsigned char resp, n, c;
;    1702 
;    1703 	#ifdef _DEBUG_ON_
;    1704 		printf("\n\rReset CMD:  ");	
;    1705 	#endif
;    1706 
;    1707 	for (c=0; c<4; c++)		// try reset command 3 times if needed
	CALL __SAVELOCR3
;	resp -> R16
;	n -> R17
;	c -> R18
	LDI  R18,LOW(0)
_0x113:
	CPI  R18,4
	BRSH _0x114
;    1708 	{
;    1709 		SD_CS_OFF();
	SBI  0x18,4
;    1710 		for (n=0; n<10; n++)	// initialize clk signal to sync card
	LDI  R17,LOW(0)
_0x116:
	CPI  R17,10
	BRSH _0x117
;    1711 			_FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
;    1712 		resp = send_cmd(CMD0,0);
	SUBI R17,-1
	RJMP _0x116
_0x117:
	LDI  R30,LOW(0)
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	CALL _send_cmd
	MOV  R16,R30
;    1713 		for (n=0; n<200; n++)
	LDI  R17,LOW(0)
_0x119:
	CPI  R17,200
	BRSH _0x11A
;    1714 		{
;    1715 			if (resp == 0x1)
	CPI  R16,1
	BRNE _0x11B
;    1716 			{
;    1717 				SD_CS_OFF();
	SBI  0x18,4
;    1718     			#ifdef _DEBUG_ON_
;    1719 					printf("OK!!!");
;    1720 				#endif
;    1721 				SPCR = 0x50;
	LDI  R30,LOW(80)
	OUT  0xD,R30
;    1722 				return(1);
	LDI  R30,LOW(1)
	RJMP _0x427
;    1723 			}
;    1724 	      	resp = _FF_spi(0xFF);
_0x11B:
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	MOV  R16,R30
;    1725 		}
	SUBI R17,-1
	RJMP _0x119
_0x11A:
;    1726 		#ifdef _DEBUG_ON_
;    1727 			printf("ERROR!!!");
;    1728 		#endif
;    1729  		if (spi_speedset()==0)
	CALL _spi_speedset
	CPI  R30,0
	BRNE _0x11C
;    1730  		{
;    1731 		    SD_CS_OFF();
	SBI  0x18,4
;    1732  			return (0);
	LDI  R30,LOW(0)
	RJMP _0x427
;    1733  		}
;    1734 	}
_0x11C:
	SUBI R18,-1
	RJMP _0x113
_0x114:
;    1735 	return (0);
	LDI  R30,LOW(0)
	RJMP _0x427
;    1736 }
;    1737 
;    1738 unsigned char init_sd(void)
;    1739 {
_init_sd:
;    1740 	unsigned char resp;
;    1741 	unsigned int c;
;    1742 	
;    1743 	clear_sd_buff();
	CALL __SAVELOCR3
;	resp -> R16
;	c -> R17,R18
	CALL _clear_sd_buff
;    1744 
;    1745     #ifdef _DEBUG_ON_
;    1746 		printf("\r\nInitialization:  ");
;    1747 	#endif
;    1748     for (c=0; c<1000; c++)
	__GETWRN 17,18,0
_0x11E:
	__CPWRN 17,18,1000
	BRSH _0x11F
;    1749     {
;    1750     	resp = send_cmd(CMD1, 0);
	LDI  R30,LOW(1)
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	CALL _send_cmd
	MOV  R16,R30
;    1751     	if (resp == 0)
	CPI  R16,0
	BREQ _0x11F
;    1752     		break;
;    1753    		resp = _FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	MOV  R16,R30
;    1754    		if (resp == 0)
	CPI  R16,0
	BREQ _0x11F
;    1755    			break;
;    1756    		resp = _FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	MOV  R16,R30
;    1757    		if (resp == 0)
	CPI  R16,0
	BREQ _0x11F
;    1758    			break;
;    1759 	}
	__ADDWRN 17,18,1
	RJMP _0x11E
_0x11F:
;    1760    	if (resp == 0)
	CPI  R16,0
	BRNE _0x123
;    1761 	{
;    1762 		#ifdef _DEBUG_ON_
;    1763    			printf("OK!");
;    1764 	   	#endif
;    1765 		return (1);
	LDI  R30,LOW(1)
	RJMP _0x427
;    1766 	}
;    1767 	else
_0x123:
;    1768 	{
;    1769 		#ifdef _DEBUG_ON_
;    1770    			printf("ERROR-%x  ", resp);
;    1771 	   	#endif
;    1772 		return (0);
	LDI  R30,LOW(0)
;    1773  	}        		
;    1774 }
_0x427:
	CALL __LOADLOCR3
	ADIW R28,3
	RET
;    1775 
;    1776 unsigned char _FF_read_disp(unsigned long sd_addr)
;    1777 {
;    1778 	unsigned char resp;
;    1779 	unsigned long n, remainder;
;    1780 	
;    1781 	if (sd_addr % 0x200)
;	sd_addr -> Y+9
;	resp -> R16
;	n -> Y+5
;	remainder -> Y+1
;    1782 	{	// Not a valid read address, return 0
;    1783 		_FF_error = READ_ERR;
;    1784 		return (0);
;    1785 	}
;    1786 
;    1787 	clear_sd_buff();
;    1788 	resp = send_cmd(CMD17, sd_addr);		// Send read request
;    1789 	
;    1790 	while(resp!=0xFE)
;    1791 		resp = _FF_spi(0xFF);
;    1792 	for (n=0; n<512; n++)
;    1793 	{
;    1794 		remainder = n % 0x10;
;    1795 		if (remainder == 0)
;    1796 			printf("\n\r");
;    1797 		_FF_buff[n] = _FF_spi(0xFF);
;    1798 		if (_FF_buff[n]<0x10)
;    1799 			putchar(0x30);
;    1800 		printf("%X ", _FF_buff[n]);
;    1801 	}
;    1802 	_FF_spi(0xFF);
;    1803 	_FF_spi(0xFF);
;    1804 	_FF_spi(0xFF);
;    1805 	SD_CS_OFF();
;    1806 	return (1);
;    1807 }
;    1808 
;    1809 // Read data from a SD card @ address
;    1810 unsigned char _FF_read(unsigned long sd_addr)
;    1811 {
__FF_read:
;    1812 	unsigned char resp;
;    1813 	unsigned long n;
;    1814 //printf("\r\nReadin ADDR [0x%lX]", sd_addr);
;    1815 	
;    1816 	if (sd_addr % BPB_BytsPerSec)
	SBIW R28,4
	ST   -Y,R16
;	sd_addr -> Y+5
;	resp -> R16
;	n -> Y+1
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	__GETD2S 5
	CLR  R22
	CLR  R23
	CALL __MODD21U
	CALL __CPD10
	BREQ _0x12E
;    1817 	{	// Not a valid read address, return 0
;    1818 		_FF_error = READ_ERR;
	LDI  R30,LOW(4)
	STS  __FF_error,R30
;    1819 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x426
;    1820 	}
;    1821 		
;    1822 	for (;;)
_0x12E:
_0x130:
;    1823 	{
;    1824 		clear_sd_buff();
	CALL _clear_sd_buff
;    1825 		resp = send_cmd(CMD17, sd_addr);	// read block command
	LDI  R30,LOW(7)
	ST   -Y,R30
	__GETD1S 6
	CALL __PUTPARD1
	CALL _send_cmd
	MOV  R16,R30
;    1826 		for (n=0; n<1000; n++)
	__CLRD1S 1
_0x133:
	__GETD2S 1
	__CPD2N 0x3E8
	BRSH _0x134
;    1827 		{
;    1828 			if (resp==0xFE)
	CPI  R16,254
	BREQ _0x134
;    1829 			{	// waiting for start byte
;    1830 				break;
;    1831 			}
;    1832 			resp = _FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	MOV  R16,R30
;    1833 		}
	__GETD1S 1
	__SUBD1N -1
	__PUTD1S 1
	RJMP _0x133
_0x134:
;    1834 		if (resp==0xFE)
	CPI  R16,254
	BREQ PC+3
	JMP _0x136
;    1835 		{	// if it is a valid start byte => start reading SD Card
;    1836 			for (n=0; n<BPB_BytsPerSec; n++)
	__CLRD1S 1
_0x138:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	__GETD2S 1
	CLR  R22
	CLR  R23
	CALL __CPD21
	BRSH _0x139
;    1837 				_FF_buff[n] = _FF_spi(0xFF);
	__GETD1S 1
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	POP  R26
	POP  R27
	ST   X,R30
;    1838 			_FF_spi(0xFF);
	__GETD1S 1
	__SUBD1N -1
	__PUTD1S 1
	RJMP _0x138
_0x139:
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
;    1839 			_FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
;    1840 			_FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
;    1841 			SD_CS_OFF();
	SBI  0x18,4
;    1842 			_FF_error = NO_ERR;
	LDI  R30,LOW(0)
	STS  __FF_error,R30
;    1843 			_FF_buff_addr = sd_addr;
	__GETD1S 5
	STS  __FF_buff_addr,R30
	STS  __FF_buff_addr+1,R31
	STS  __FF_buff_addr+2,R22
	STS  __FF_buff_addr+3,R23
;    1844 			SPCR = 0x50;
	LDI  R30,LOW(80)
	OUT  0xD,R30
;    1845 			return (1);
	LDI  R30,LOW(1)
	RJMP _0x426
;    1846 		}
;    1847 
;    1848 		SD_CS_OFF();
_0x136:
	SBI  0x18,4
;    1849 
;    1850 		if (spi_speedset()==0)
	CALL _spi_speedset
	CPI  R30,0
	BREQ _0x131
;    1851 			break;
;    1852 	}	
	RJMP _0x130
_0x131:
;    1853 	_FF_error = READ_ERR;    
	LDI  R30,LOW(4)
	STS  __FF_error,R30
;    1854 	return(0);
	LDI  R30,LOW(0)
_0x426:
	LDD  R16,Y+0
	ADIW R28,9
	RET
;    1855 }
;    1856 
;    1857 
;    1858 #ifndef _READ_ONLY_
;    1859 unsigned char _FF_write(unsigned long sd_addr)
;    1860 {
__FF_write:
;    1861 	unsigned char resp, calc, valid_flag;
;    1862 	unsigned int n;
;    1863 	
;    1864 	if ((sd_addr%BPB_BytsPerSec) || (sd_addr <= _FF_PART_ADDR))
	CALL __SAVELOCR5
;	sd_addr -> Y+5
;	resp -> R16
;	calc -> R17
;	valid_flag -> R18
;	n -> R19,R20
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	__GETD2S 5
	CLR  R22
	CLR  R23
	CALL __MODD21U
	CALL __CPD10
	BRNE _0x13C
	LDS  R30,__FF_PART_ADDR
	LDS  R31,__FF_PART_ADDR+1
	LDS  R22,__FF_PART_ADDR+2
	LDS  R23,__FF_PART_ADDR+3
	__GETD2S 5
	CALL __CPD12
	BRLO _0x13B
_0x13C:
;    1865 	{	// Not a valid write address, return 0
;    1866 		_FF_error = WRITE_ERR;
	LDI  R30,LOW(3)
	STS  __FF_error,R30
;    1867 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x425
;    1868 	}
;    1869 
;    1870 //printf("\r\nWriting to address:  %lX", sd_addr);
;    1871 	for (;;)
_0x13B:
_0x13F:
;    1872 	{
;    1873 		clear_sd_buff();
	CALL _clear_sd_buff
;    1874 		resp = send_cmd(CMD24, sd_addr);
	LDI  R30,LOW(9)
	ST   -Y,R30
	__GETD1S 6
	CALL __PUTPARD1
	CALL _send_cmd
	MOV  R16,R30
;    1875 		valid_flag = 0;
	LDI  R18,LOW(0)
;    1876 		for (n=0; n<1000; n++)
	__GETWRN 19,20,0
_0x142:
	__CPWRN 19,20,1000
	BRSH _0x143
;    1877 		{
;    1878 			if (resp == 0x00)
	CPI  R16,0
	BRNE _0x144
;    1879 			{
;    1880 				valid_flag = 1;
	LDI  R18,LOW(1)
;    1881 				break;
	RJMP _0x143
;    1882 			}
;    1883 			resp = _FF_spi(0xFF);
_0x144:
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	MOV  R16,R30
;    1884 		}
	__ADDWRN 19,20,1
	RJMP _0x142
_0x143:
;    1885 	
;    1886 		if (valid_flag)
	CPI  R18,0
	BREQ _0x145
;    1887 		{
;    1888 			_FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
;    1889 			_FF_spi(0xFE);					// Start Block Token
	LDI  R30,LOW(254)
	ST   -Y,R30
	CALL __FF_spi
;    1890 			for (n=0; n<BPB_BytsPerSec; n++)		// Write Data in buffer to card
	__GETWRN 19,20,0
_0x147:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	CP   R19,R30
	CPC  R20,R31
	BRSH _0x148
;    1891 				_FF_spi(_FF_buff[n]);
	LDI  R26,LOW(__FF_buff)
	LDI  R27,HIGH(__FF_buff)
	ADD  R26,R19
	ADC  R27,R20
	LD   R30,X
	ST   -Y,R30
	CALL __FF_spi
;    1892 			_FF_spi(0xFF);					// Send 2 blank CRC bytes
	__ADDWRN 19,20,1
	RJMP _0x147
_0x148:
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
;    1893 			_FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
;    1894 			resp = _FF_spi(0xFF);			// Response should be 0bXXX00101
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	MOV  R16,R30
;    1895 			calc = resp | 0xE0;
	MOV  R30,R16
	ORI  R30,LOW(0xE0)
	MOV  R17,R30
;    1896 			if (calc==0xE5)
	CPI  R17,229
	BRNE _0x149
;    1897 			{
;    1898 				while(_FF_spi(0xFF)==0)
_0x14A:
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	CPI  R30,0
	BREQ _0x14A
;    1899 					;	// Clear Buffer before returning 'OK'
;    1900 				SD_CS_OFF();
	SBI  0x18,4
;    1901 //				SPCR = 0x50;			// Reset SPI bus Speed
;    1902 				_FF_error = NO_ERR;
	LDI  R30,LOW(0)
	STS  __FF_error,R30
;    1903 				return(1);
	LDI  R30,LOW(1)
	RJMP _0x425
;    1904 			}
;    1905 		}
_0x149:
;    1906 		SD_CS_OFF(); 
_0x145:
	SBI  0x18,4
;    1907 
;    1908 		if (spi_speedset()==0)
	CALL _spi_speedset
	CPI  R30,0
	BREQ _0x140
;    1909 			break;
;    1910 		// delay_ms(100);		
;    1911 	}
	RJMP _0x13F
_0x140:
;    1912 	_FF_error = WRITE_ERR;
	LDI  R30,LOW(3)
	STS  __FF_error,R30
;    1913 	return(0x0);
	LDI  R30,LOW(0)
_0x425:
	CALL __LOADLOCR5
	ADIW R28,9
	RET
;    1914 }
;    1915 #endif
;    1916 /*
;    1917 	Progressive Resources LLC
;    1918                                     
;    1919 			FlashFile
;    1920 	
;    1921 	Version : 	1.32
;    1922 	Date: 		12/31/2003
;    1923 	Author: 	Erick M. Higa
;    1924 	
;    1925 	Revision History:
;    1926 	12/31/2003 - EMH - v1.00 
;    1927 			   	 	 - Initial Release
;    1928 	01/19/2004 - EMH - v1.10
;    1929 			   	 	 - fixed FAT access errors by allowing both FAT tables to be updated
;    1930 					 - fixed erase_cluster chain to stop if chain goes to '0'
;    1931 					 - fixed #include's so other non m128 processors could be used
;    1932 					 - fixed fcreate to match 'C' standard for function "creat"
;    1933 					 - fixed fseek so it would not error when in "READ" mode
;    1934 					 - modified SPI interface to use _FF_spi() so it is more universal
;    1935 					   (see the "sd_cmd.c" file for the function used)
;    1936 					 - redifined global variables and #defines for more unique names
;    1937 					 - added string functions fputs, fputsc, & fgets
;    1938 					 - added functions fquickformat, fgetfileinfo, & GetVolID()
;    1939 					 - added directory support
;    1940 					 - modified delays in "sd_cmd.c" to increase transfer speed to max
;    1941 					 - updated "options.h" to include additions, and to make #defines 
;    1942 					   more universal to multiple platforms
;    1943 	01/21/2004 - EMH - v1.20
;    1944 			   	 	 - Added ICC Support to the FlashFileSD
;    1945 					 - fixed card initialization error for MMC/SD's that have only a boot 
;    1946 			   	 	   sector and no partition table
;    1947 					 - Fixed intermittant error on fcreate when creating existing file
;    1948 					 - changed "options.h" to #include all required files
;    1949 	02/19/2004 - EMH - v1.21
;    1950 					 - Replaced all "const" refrances to "flash" to support CodeVision 1.24.1b
;    1951 	03/02/2004 - EMH - v1.22 (unofficial release)
;    1952 					 - Changed Directory Functions to allow for multi-cluster directory entries
;    1953 					 - Added function addr_to_clust() to support long directories
;    1954 					 - Fixed FAT table address calculation to support multiple reserved sectors
;    1955 					   (previously) assumed one reserved sector, if XP formats card sometimes 
;    1956 					   multiple reserved sectors - thanks YW
;    1957 	03/10/2004 - EMH - v1.30
;    1958 					 - Added support for a Compact Flash package
;    1959 					 - Renamed read and write to flash function names for multiple media support	
;    1960 	03/26/2004 - EMH - v1.31
;    1961 					 - Added define for easy MEGA128Dev board setup
;    1962 					 - Changed demo projects so "option.h" is in the project directory	
;    1963 	04/01/2004 - EMH - v1.32
;    1964 					 - Fixed bug in "prev_cluster()" that didn't use updated FAT table address
;    1965 					   calculations.  (effects XP formatted cards see v1.22 notes)
;    1966                                            
;    1967 	Software License
;    1968 	The use of Progressive Resources LLC FlashFile Source Package indicates 
;    1969 	your understanding and acceptance of the following terms and conditions. 
;    1970 	This license shall supersede any verbal or prior verbal or written, statement 
;    1971 	or agreement to the contrary. If you do not understand or accept these terms, 
;    1972 	or your local regulations prohibit "after sale" license agreements or limited 
;    1973 	disclaimers, you must cease and desist using this product immediately.
;    1974 	This product is © Copyright 2003 by Progressive Resources LLC, all rights 
;    1975 	reserved. International copyright laws, international treaties and all other 
;    1976 	applicable national or international laws protect this product. This software 
;    1977 	product and documentation may not, in whole or in part, be copied, photocopied, 
;    1978 	translated, or reduced to any electronic medium or machine readable form, without 
;    1979 	prior consent in writing, from Progressive Resources LLC and according to all 
;    1980 	applicable laws. The sole owner of this product is Progressive Resources LLC.
;    1981 
;    1982 	Operating License
;    1983 	You have the non-exclusive right to use any enclosed product but have no right 
;    1984 	to distribute it as a source code product without the express written permission 
;    1985 	of Progressive Resources LLC. Use over a "local area network" (within the same 
;    1986 	locale) is permitted provided that only a single person, on a single computer 
;    1987 	uses the product at a time. Use over a "wide area network" (outside the same 
;    1988 	locale) is strictly prohibited under any and all circumstances.
;    1989                                            
;    1990 	Liability Disclaimer
;    1991 	This product and/or license is provided as is, without any representation or 
;    1992 	warranty of any kind, either express or implied, including without limitation 
;    1993 	any representations or endorsements regarding the use of, the results of, or 
;    1994 	performance of the product, Its appropriateness, accuracy, reliability, or 
;    1995 	correctness. The user and/or licensee assume the entire risk as to the use of 
;    1996 	this product. Progressive Resources LLC does not assume liability for the use 
;    1997 	of this product beyond the original purchase price of the software. In no event 
;    1998 	will Progressive Resources LLC be liable for additional direct or indirect 
;    1999 	damages including any lost profits, lost savings, or other incidental or 
;    2000 	consequential damages arising from any defects, or the use or inability to 
;    2001 	use these products, even if Progressive Resources LLC have been advised of 
;    2002 	the possibility of such damages.
;    2003 */                                 
;    2004 
;    2005 	#include <coding.h>
;    2006 
;    2007 extern unsigned long OCR_REG;
;    2008 extern unsigned char _FF_buff[512];
;    2009 extern unsigned int PT_SecStart;
;    2010 extern unsigned long BS_jmpBoot;
;    2011 extern unsigned int BPB_BytsPerSec;
;    2012 extern unsigned char BPB_SecPerClus;
;    2013 extern unsigned int BPB_RsvdSecCnt;
;    2014 extern unsigned char BPB_NumFATs;
;    2015 extern unsigned int BPB_RootEntCnt;
;    2016 extern unsigned int BPB_FATSz16;
;    2017 extern unsigned char BPB_FATType;
;    2018 extern unsigned long BPB_TotSec;
;    2019 extern unsigned long BS_VolSerial;
;    2020 extern unsigned char BS_VolLab[12];
;    2021 extern unsigned long _FF_PART_ADDR, _FF_ROOT_ADDR, _FF_DIR_ADDR;
;    2022 extern unsigned long _FF_FAT1_ADDR, _FF_FAT2_ADDR;
;    2023 extern unsigned int FirstDataSector;
;    2024 extern unsigned long FirstSectorofCluster;
;    2025 extern unsigned char _FF_error;
;    2026 extern unsigned long _FF_buff_addr;
;    2027 extern unsigned long DataClusTot;
;    2028 unsigned char rtc_hour, rtc_min, rtc_sec;

	.DSEG
_rtc_hour:
	.BYTE 0x1
_rtc_min:
	.BYTE 0x1
_rtc_sec:
	.BYTE 0x1
;    2029 unsigned char rtc_date, rtc_month;
_rtc_date:
	.BYTE 0x1
_rtc_month:
	.BYTE 0x1
;    2030 unsigned int rtc_year;
_rtc_year:
	.BYTE 0x2
;    2031 unsigned long clus_0_addr, _FF_n_temp;
_clus_0_addr:
	.BYTE 0x4
__FF_n_temp:
	.BYTE 0x4
;    2032 unsigned int c_counter;
_c_counter:
	.BYTE 0x2
;    2033 unsigned char _FF_FULL_PATH[_FF_PATH_LENGTH];
__FF_FULL_PATH:
	.BYTE 0x64
;    2034 unsigned char FILENAME[12];
_FILENAME:
	.BYTE 0xC
;    2035 
;    2036 // Conversion file to change an ASCII valued character into the calculated value
;    2037 unsigned char ascii_to_char(unsigned char ascii_char)
;    2038 {

	.CSEG
;    2039 	unsigned char temp_char;
;    2040 	
;    2041 	if (ascii_char < 0x30)		// invalid, return error
;	ascii_char -> Y+1
;	temp_char -> R16
;    2042 		return (0xFF);
;    2043 	else if (ascii_char < 0x3A)
;    2044 	{	//number, subtract 0x30, retrun value
;    2045 		temp_char = ascii_char - 0x30;
;    2046 		return (temp_char);
;    2047 	}
;    2048 	else if (ascii_char < 0x41)	// invalid, return error
;    2049 		return (0xFF);
;    2050 	else if (ascii_char < 0x47)
;    2051 	{	// lower case a-f, subtract 0x37, return value
;    2052 		temp_char = ascii_char - 0x37;
;    2053 		return (temp_char);
;    2054 	}
;    2055 	else if (ascii_char < 0x61)	// invalid, return error
;    2056 		return (0xFF);
;    2057 	else if (ascii_char < 0x67)
;    2058 	{	// upper case A-F, subtract 0x57, return value
;    2059 		temp_char = ascii_char - 0x57;
;    2060 		return (temp_char);
;    2061 	}
;    2062 	else	// invalid, return error
;    2063 		return (0xFF);
;    2064 }
;    2065 
;    2066 // Function to see if the character is a valid FILENAME character
;    2067 int valid_file_char(unsigned char file_char)
;    2068 {
_valid_file_char:
;    2069 	if (file_char < 0x20)
	LD   R26,Y
	CPI  R26,LOW(0x20)
	BRSH _0x15A
;    2070 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x424
;    2071 	else if ((file_char==0x22) || (file_char==0x2A) || (file_char==0x2B) || (file_char==0x2C) ||
_0x15A:
;    2072 			(file_char==0x2E) || (file_char==0x2F) || ((file_char>=0x3A)&&(file_char<=0x3F)) ||
;    2073 			((file_char>=0x5B)&&(file_char<=0x5D)) || (file_char==0x7C) || (file_char==0xE5))
	LD   R26,Y
	CPI  R26,LOW(0x22)
	BREQ _0x15D
	CPI  R26,LOW(0x2A)
	BREQ _0x15D
	CPI  R26,LOW(0x2B)
	BREQ _0x15D
	CPI  R26,LOW(0x2C)
	BREQ _0x15D
	CPI  R26,LOW(0x2E)
	BREQ _0x15D
	CPI  R26,LOW(0x2F)
	BREQ _0x15D
	CPI  R26,LOW(0x3A)
	BRLO _0x15E
	CPI  R26,LOW(0x40)
	BRLO _0x15D
_0x15E:
	LD   R26,Y
	CPI  R26,LOW(0x5B)
	BRLO _0x160
	CPI  R26,LOW(0x5E)
	BRLO _0x15D
_0x160:
	LD   R26,Y
	CPI  R26,LOW(0x7C)
	BREQ _0x15D
	CPI  R26,LOW(0xE5)
	BRNE _0x15C
_0x15D:
;    2074 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x424
;    2075 	else
_0x15C:
;    2076 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
;    2077 }
_0x424:
	ADIW R28,1
	RET
;    2078 
;    2079 // Function will scan the directory @VALID_ADDR and return a
;    2080 // '0' if successful (w/ VALID_ADDR changing to location of entry avaliable),
;    2081 // and a '-1' if file or folder exists (w/ VALID_ADDR changing to location of
;    2082 // entry of exisiting file/folder) or if no more entry space (VALID_ADDR would
;    2083 // change to 0).
;    2084 int scan_directory(unsigned long *VALID_ADDR, unsigned char *NAME)
;    2085 {
_scan_directory:
;    2086 	unsigned int ent_cntr, ent_max, n, c, dir_clus;
;    2087 	unsigned long temp_addr;
;    2088 	unsigned char *sp, *qp, aval_flag, name_store[14];
;    2089 	
;    2090 	aval_flag = 0;
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
;    2091 	ent_cntr = 0;	// set to 0
	__GETWRN 16,17,0
;    2092 	
;    2093 	qp = NAME;
	LDD  R30,Y+33
	LDD  R31,Y+33+1
	STD  Y+21,R30
	STD  Y+21+1,R31
;    2094 	for (c=0; c<11; c++)
	LDI  R30,0
	STD  Y+31,R30
	STD  Y+31+1,R30
_0x165:
	LDD  R26,Y+31
	LDD  R27,Y+31+1
	SBIW R26,11
	BRLO PC+3
	JMP _0x166
;    2095 	{
;    2096 		if (valid_file_char(*qp)==0)
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	LD   R30,X
	ST   -Y,R30
	CALL _valid_file_char
	SBIW R30,0
	BRNE _0x167
;    2097 			name_store[c] = toupper(*qp++);
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
;    2098 		else if (*qp == '.')
	RJMP _0x168
_0x167:
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BRNE _0x169
;    2099 		{
;    2100 			while (c<8)
_0x16A:
	LDD  R26,Y+31
	LDD  R27,Y+31+1
	SBIW R26,8
	BRSH _0x16C
;    2101 				name_store[c++] = 0x20;
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
;    2102 			c--;
	RJMP _0x16A
_0x16C:
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	SBIW R30,1
	STD  Y+31,R30
	STD  Y+31+1,R31
;    2103 			
;    2104 			qp++;
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	ADIW R30,1
	STD  Y+21,R30
	STD  Y+21+1,R31
;    2105 			aval_flag |= 1;
	LDD  R30,Y+20
	ORI  R30,1
	STD  Y+20,R30
;    2106 		}
;    2107 		else if (*qp == 0)
	RJMP _0x16D
_0x169:
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	LD   R30,X
	CPI  R30,0
	BRNE _0x16E
;    2108 		{
;    2109 			while (c<11)
_0x16F:
	LDD  R26,Y+31
	LDD  R27,Y+31+1
	SBIW R26,11
	BRSH _0x171
;    2110 				name_store[c++] = 0x20;
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
;    2111 		}
	RJMP _0x16F
_0x171:
;    2112 		else
	RJMP _0x172
_0x16E:
;    2113 		{
;    2114 			*VALID_ADDR = 0;
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	__GETD1N 0x0
	CALL __PUTDP1
;    2115 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x423
;    2116 		}
_0x172:
_0x16D:
_0x168:
;    2117 	}
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	ADIW R30,1
	STD  Y+31,R30
	STD  Y+31+1,R31
	RJMP _0x165
_0x166:
;    2118 	name_store[11] = 0;
	LDI  R30,LOW(0)
	STD  Y+17,R30
;    2119 	
;    2120 	if (*VALID_ADDR == _FF_ROOT_ADDR)
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __GETD1P
	LDS  R26,__FF_ROOT_ADDR
	LDS  R27,__FF_ROOT_ADDR+1
	LDS  R24,__FF_ROOT_ADDR+2
	LDS  R25,__FF_ROOT_ADDR+3
	CALL __CPD12
	BRNE _0x173
;    2121 		ent_max = BPB_RootEntCnt;
	__GETWRMN 18,19,0,_BPB_RootEntCnt
;    2122 	else
	RJMP _0x174
_0x173:
;    2123 	{
;    2124 		dir_clus = addr_to_clust(*VALID_ADDR);
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __GETD1P
	CALL __PUTPARD1
	RCALL _addr_to_clust
	STD  Y+29,R30
	STD  Y+29+1,R31
;    2125 		if (dir_clus != 0)
	SBIW R30,0
	BREQ _0x175
;    2126 			aval_flag |= 0x80;
	LDD  R30,Y+20
	ORI  R30,0x80
	STD  Y+20,R30
;    2127 		ent_max = ((long) BPB_BytsPerSec * (long) BPB_SecPerClus) / 0x20;
_0x175:
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
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x20
	CALL __DIVD21
	MOVW R18,R30
;    2128     }
_0x174:
;    2129 	c = 0;
	LDI  R30,0
	STD  Y+31,R30
	STD  Y+31+1,R30
;    2130 	while (ent_cntr < ent_max)	
_0x176:
	__CPWRR 16,17,18,19
	BRLO PC+3
	JMP _0x178
;    2131 	{
;    2132 		if (_FF_read(*VALID_ADDR+((long)c*BPB_BytsPerSec))==0)
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
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
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	CALL __PUTPARD1
	CALL __FF_read
	CPI  R30,0
	BRNE _0x179
;    2133 			break;
	RJMP _0x178
;    2134 		for (n=0; n<16; n++)
_0x179:
	__GETWRN 20,21,0
_0x17B:
	__CPWRN 20,21,16
	BRLO PC+3
	JMP _0x17C
;    2135 		{
;    2136 			sp = &_FF_buff[n*0x20];
	MOVW R30,R20
	LSL  R30
	ROL  R31
	CALL __LSLW4
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	STD  Y+23,R30
	STD  Y+23+1,R31
;    2137 			qp = name_store;
	MOVW R30,R28
	ADIW R30,6
	STD  Y+21,R30
	STD  Y+21+1,R31
;    2138 			if (*sp==0)
	LDD  R26,Y+23
	LDD  R27,Y+23+1
	LD   R30,X
	CPI  R30,0
	BRNE _0x17D
;    2139 			{
;    2140 				if ((aval_flag&0x10)==0)
	LDD  R30,Y+20
	ANDI R30,LOW(0x10)
	BRNE _0x17E
;    2141 					temp_addr = *VALID_ADDR + ((long) c * BPB_BytsPerSec) + (n * 0x20);
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
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
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD21
	MOVW R30,R20
	LSL  R30
	ROL  R31
	CALL __LSLW4
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1S 25
;    2142 				*VALID_ADDR = temp_addr;
_0x17E:
	__GETD1S 25
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __PUTDP1
;    2143 				return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x423
;    2144 			}
;    2145 			else if (*sp==0xE5)
_0x17D:
	LDD  R26,Y+23
	LDD  R27,Y+23+1
	LD   R26,X
	CPI  R26,LOW(0xE5)
	BRNE _0x180
;    2146 			{
;    2147 				temp_addr = *VALID_ADDR + ((long) c * BPB_BytsPerSec) + (n * 0x20);
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
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
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD21
	MOVW R30,R20
	LSL  R30
	ROL  R31
	CALL __LSLW4
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1S 25
;    2148 				aval_flag |= 0x10;
	LDD  R30,Y+20
	ORI  R30,0x10
	STD  Y+20,R30
;    2149 			}
;    2150 			else
	RJMP _0x181
_0x180:
;    2151 			{
;    2152 				if (aval_flag & 0x01)	// file
	LDD  R30,Y+20
	ANDI R30,LOW(0x1)
	BRNE PC+3
	JMP _0x182
;    2153 				{
;    2154 					if (strncmp(qp, sp, 11)==0)
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
	BRNE _0x183
;    2155 					{
;    2156 						temp_addr = *VALID_ADDR + ((long) c * BPB_BytsPerSec) + (n * 0x20);
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
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
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD21
	MOVW R30,R20
	LSL  R30
	ROL  R31
	CALL __LSLW4
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1S 25
;    2157 						*VALID_ADDR = temp_addr;
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __PUTDP1
;    2158 						return (EOF);	// file exists @ temp_addr
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x423
;    2159 					}
;    2160 				}
_0x183:
;    2161 				else					// folder
	RJMP _0x184
_0x182:
;    2162 				{
;    2163 					if ((strncmp(qp, sp, 11)==0)&&(*(sp+11)&0x10))
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
	BRNE _0x186
	LDD  R26,Y+23
	LDD  R27,Y+23+1
	ADIW R26,11
	LD   R30,X
	ANDI R30,LOW(0x10)
	BRNE _0x187
_0x186:
	RJMP _0x185
_0x187:
;    2164 					{
;    2165 						temp_addr = *VALID_ADDR + ((long) c * BPB_BytsPerSec) + (n * 0x20);
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
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
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD21
	MOVW R30,R20
	LSL  R30
	ROL  R31
	CALL __LSLW4
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1S 25
;    2166 						*VALID_ADDR = temp_addr;
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __PUTDP1
;    2167 						return (EOF);	// file exists @ temp_addr
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x423
;    2168 					}
;    2169 				}
_0x185:
_0x184:
;    2170 			}
_0x181:
;    2171 			ent_cntr++;
	__ADDWRN 16,17,1
;    2172 		}
	__ADDWRN 20,21,1
	RJMP _0x17B
_0x17C:
;    2173 		c++;
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	ADIW R30,1
	STD  Y+31,R30
	STD  Y+31+1,R31
;    2174 		if (ent_cntr == ent_max)
	__CPWRR 18,19,16,17
	BRNE _0x188
;    2175 		{
;    2176 			if (aval_flag & 0x80)		// a folder @ a valid cluster
	LDD  R30,Y+20
	ANDI R30,LOW(0x80)
	BREQ _0x189
;    2177 			{
;    2178 				c = next_cluster(dir_clus, SINGLE);
	LDD  R30,Y+29
	LDD  R31,Y+29+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _next_cluster
	STD  Y+31,R30
	STD  Y+31+1,R31
;    2179 				if (c != EOF)
	LDD  R26,Y+31
	LDD  R27,Y+31+1
	CPI  R26,LOW(0xFFFF)
	LDI  R30,HIGH(0xFFFF)
	CPC  R27,R30
	BREQ _0x18A
;    2180 				{	// another dir cluster exists
;    2181 					*VALID_ADDR = clust_to_addr(c);
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _clust_to_addr
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __PUTDP1
;    2182 					dir_clus = c;
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	STD  Y+29,R30
	STD  Y+29+1,R31
;    2183 					ent_cntr = 0;
	__GETWRN 16,17,0
;    2184 					c = 0;
	LDI  R30,0
	STD  Y+31,R30
	STD  Y+31+1,R30
;    2185 				}
;    2186 			}
_0x18A:
;    2187 		}
_0x189:
;    2188 	}
_0x188:
	RJMP _0x176
_0x178:
;    2189 	*VALID_ADDR = 0;
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	__GETD1N 0x0
	CALL __PUTDP1
;    2190 	return (EOF);	
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x423:
	CALL __LOADLOCR6
	ADIW R28,37
	RET
;    2191 }
;    2192 
;    2193 #ifdef _DEBUG_ON_
;    2194 // Function to display all files and folders in the root directory, 
;    2195 // with the size of the file in bytes within the [brakets]
;    2196 void read_directory(void)
;    2197 {
;    2198 	unsigned char valid_flag, attribute_temp;
;    2199 	unsigned int c, n, d, m, dir_clus;
;    2200 	unsigned long calc, calc_clus, dir_addr;
;    2201 	
;    2202 	if (_FF_DIR_ADDR != _FF_ROOT_ADDR)
;    2203 	{
;    2204 		dir_clus = addr_to_clust(_FF_DIR_ADDR);
;    2205 		if (dir_clus == 0)
;    2206 			return;
;    2207 	}
;    2208 
;    2209 	printf("\r\nFile Listing for:  ROOT\\");
;    2210 	for (d=0; d<_FF_PATH_LENGTH; d++)
;    2211 	{
;    2212 		if (_FF_FULL_PATH[d])
;    2213 			putchar(_FF_FULL_PATH[d]);
;    2214 		else
;    2215 			break;
;    2216 	}
;    2217 	
;    2218     
;    2219     dir_addr = _FF_DIR_ADDR;
;    2220 	d = 0;
;    2221 	m = 0;
;    2222 	while (d<BPB_RootEntCnt)
;    2223 	{
;    2224     	if (_FF_read(dir_addr+(m*0x200))==0)
;    2225     		break;
;    2226 		for (n=0; n<16; n++)
;    2227 		{
;    2228 			for (c=0; c<11; c++)
;    2229 			{
;    2230 				if (_FF_buff[(n*0x20)]==0)
;    2231 				{
;    2232 					n=16;
;    2233 					d=BPB_RootEntCnt;
;    2234 					valid_flag = 0;
;    2235 					break;
;    2236 				}
;    2237 				valid_flag = 1;
;    2238 				if (valid_file_char(_FF_buff[(n*0x20)+c]))
;    2239 				{
;    2240 					valid_flag = 0;
;    2241 					break;
;    2242 				}
;    2243 		    }   
;    2244 		    if (valid_flag)
;    2245 	  		{
;    2246 		  		calc = (n * 0x20) + 0xB;
;    2247 		  		attribute_temp = _FF_buff[calc];
;    2248 		  		putchar('\n');
;    2249 				putchar('\r');
;    2250 				c = (n * 0x20);
;    2251 			  	calc = ((long) _FF_buff[c+0x1F] << 24) | ((long) _FF_buff[c+0x1E] << 16) |
;    2252 			  			((long) _FF_buff[c+0x1D] << 8) | ((long) _FF_buff[c+0x1C]);
;    2253 			  	calc_clus = ((int) _FF_buff[c+0x1B] << 8) | (int) _FF_buff[c+0x1A];
;    2254 				if (attribute_temp & 0x10)
;    2255 					printf("  [");
;    2256 				else
;    2257 			  		printf("                [%ld] bytes      (%X)\r  ", calc, calc_clus);		  		
;    2258 				for (c=0; c<8; c++)
;    2259 				{
;    2260 					calc = (n * 0x20) + c;
;    2261 					if (_FF_buff[calc]==0x20)
;    2262 						break;
;    2263 					putchar(_FF_buff[calc]);
;    2264 				}
;    2265 				if (attribute_temp & 0x10)
;    2266 				{
;    2267 					printf("]      (%X)", calc_clus);
;    2268 				}
;    2269 				else
;    2270 				{
;    2271 					putchar('.');
;    2272 					for (c=8; c<11; c++)
;    2273 					{
;    2274 						calc = (n * 0x20) + c;
;    2275 						if (_FF_buff[calc]==0x20)
;    2276 							break;
;    2277 						putchar(_FF_buff[calc]);
;    2278 					}
;    2279 				}
;    2280 		  	}
;    2281 		  	d++;		  		
;    2282 		}
;    2283 		m++;
;    2284 		if (_FF_ROOT_ADDR!=_FF_DIR_ADDR)
;    2285 		{
;    2286 		   	if (m==BPB_SecPerClus)
;    2287 		   	{
;    2288 
;    2289 				m = next_cluster(dir_clus, SINGLE);
;    2290 				if (m != EOF)
;    2291 				{	// another dir cluster exists
;    2292 					dir_addr = clust_to_addr(m);
;    2293 					dir_clus = m;
;    2294 					d = 0;
;    2295 					m = 0;
;    2296 				}
;    2297 				else
;    2298 					break;
;    2299 		   		
;    2300 		   	}
;    2301 		}
;    2302 	}
;    2303 	putchar('\n');
;    2304 	putchar('\r');	
;    2305 } 
;    2306 
;    2307 void GetVolID(void)
;    2308 {
;    2309 	printf("\r\n  Volume Serial:  [0x%lX]", BS_VolSerial);
;    2310 	printf("\r\n  Volume Label:  [%s]\r\n", BS_VolLab);
;    2311 }
;    2312 #endif
;    2313 
;    2314 // Convert a cluster number into a read address
;    2315 unsigned long clust_to_addr(unsigned int clust_no)
;    2316 {
_clust_to_addr:
;    2317 	unsigned long clust_addr;
;    2318 	
;    2319 	FirstSectorofCluster = ((clust_no - 2) * (long) BPB_SecPerClus) + (long) FirstDataSector;
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
;    2320 	clust_addr = (long) FirstSectorofCluster * (long) BPB_BytsPerSec + _FF_PART_ADDR;
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	CLR  R22
	CLR  R23
	LDS  R26,_FirstSectorofCluster
	LDS  R27,_FirstSectorofCluster+1
	LDS  R24,_FirstSectorofCluster+2
	LDS  R25,_FirstSectorofCluster+3
	CALL __MULD12
	LDS  R26,__FF_PART_ADDR
	LDS  R27,__FF_PART_ADDR+1
	LDS  R24,__FF_PART_ADDR+2
	LDS  R25,__FF_PART_ADDR+3
	CALL __ADDD12
	__PUTD1S 0
;    2321 
;    2322 	return (clust_addr);
	ADIW R28,6
	RET
;    2323 }
;    2324 
;    2325 // Converts an address into a cluster number
;    2326 unsigned int addr_to_clust(unsigned long clus_addr)
;    2327 {
_addr_to_clust:
;    2328 	if (clus_addr <= _FF_PART_ADDR)
	LDS  R30,__FF_PART_ADDR
	LDS  R31,__FF_PART_ADDR+1
	LDS  R22,__FF_PART_ADDR+2
	LDS  R23,__FF_PART_ADDR+3
	__GETD2S 0
	CALL __CPD12
	BRLO _0x18B
;    2329 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41E
;    2330 	clus_addr -= _FF_PART_ADDR;
_0x18B:
	LDS  R26,__FF_PART_ADDR
	LDS  R27,__FF_PART_ADDR+1
	LDS  R24,__FF_PART_ADDR+2
	LDS  R25,__FF_PART_ADDR+3
	__GETD1S 0
	CALL __SUBD12
	__PUTD1S 0
;    2331 	clus_addr /= BPB_BytsPerSec;
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	__GETD2S 0
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	__PUTD1S 0
;    2332 	if (clus_addr <= (unsigned long) FirstDataSector)
	LDS  R30,_FirstDataSector
	LDS  R31,_FirstDataSector+1
	CLR  R22
	CLR  R23
	__GETD2S 0
	CALL __CPD12
	BRLO _0x18C
;    2333 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41E
;    2334 	clus_addr -= FirstDataSector;
_0x18C:
	LDS  R30,_FirstDataSector
	LDS  R31,_FirstDataSector+1
	__GETD2S 0
	CLR  R22
	CLR  R23
	CALL __SUBD21
	__PUTD2S 0
;    2335 	clus_addr /= BPB_SecPerClus;
	LDS  R30,_BPB_SecPerClus
	__GETD2S 0
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	__PUTD1S 0
;    2336 	clus_addr += 2;
	__ADDD1N 2
	__PUTD1S 0
;    2337 	if (clus_addr > 0xFFFF)
	__GETD2S 0
	__CPD2N 0x10000
	BRLO _0x18D
;    2338 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41E
;    2339 	
;    2340 	return ((int) clus_addr);	
_0x18D:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x41E
;    2341 }
;    2342 
;    2343 // Find the cluster that the current cluster is pointing to
;    2344 unsigned int next_cluster(unsigned int current_cluster, unsigned char mode)
;    2345 {
_next_cluster:
;    2346 	unsigned int calc_sec, calc_offset, calc_remainder, next_clust;
;    2347 	unsigned long addr_temp;
;    2348 	
;    2349 	if (current_cluster<=1)		// If cluster is 0 or 1, its the wrong cluster
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
	BRSH _0x18E
;    2350 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x422
;    2351 		
;    2352 	if (BPB_FATType == 0x36)		// if FAT16
_0x18E:
	LDS  R26,_BPB_FATType
	CPI  R26,LOW(0x36)
	BREQ PC+3
	JMP _0x18F
;    2353 	{
;    2354 		// FAT16 table address calculations
;    2355 		calc_sec = current_cluster / (BPB_BytsPerSec / 2) + BPB_RsvdSecCnt;
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	LSR  R31
	ROR  R30
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	CALL __DIVW21U
	LDS  R26,_BPB_RsvdSecCnt
	LDS  R27,_BPB_RsvdSecCnt+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
;    2356 		calc_offset = 2 * (current_cluster % (BPB_BytsPerSec / 2));
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	LSR  R31
	ROR  R30
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	CALL __MODW21U
	LSL  R30
	ROL  R31
	MOVW R18,R30
;    2357 	    
;    2358 	 	addr_temp = _FF_PART_ADDR+(calc_sec*0x200);
	MOVW R30,R16
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
;    2359 		if (mode==SINGLE)
	LDD  R26,Y+12
	CPI  R26,LOW(0x1)
	BRNE _0x190
;    2360 		{	// This is a single cluster lookup
;    2361 			if (_FF_read(addr_temp)==0)
	CALL __PUTPARD1
	CALL __FF_read
	CPI  R30,0
	BRNE _0x191
;    2362 				return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x422
;    2363 		}
_0x191:
;    2364 		else if ((mode==CHAIN) || (mode==END_CHAIN))
	RJMP _0x192
_0x190:
	LDD  R26,Y+12
	CPI  R26,LOW(0x0)
	BREQ _0x194
	CPI  R26,LOW(0x2)
	BREQ _0x194
	RJMP _0x193
_0x194:
;    2365 		{	// Mupltiple clusters to lookup
;    2366 			if (addr_temp!=_FF_buff_addr)
	LDS  R30,__FF_buff_addr
	LDS  R31,__FF_buff_addr+1
	LDS  R22,__FF_buff_addr+2
	LDS  R23,__FF_buff_addr+3
	__GETD2S 6
	CALL __CPD12
	BRNE PC+3
	JMP _0x196
;    2367 			{	// Is the address of lookup is different then the current buffere address
;    2368 				#ifndef _READ_ONLY_
;    2369 				if (_FF_buff_addr)	// if the buffer address is 0, don't write
	CALL __CPD10
	BRNE PC+3
	JMP _0x197
;    2370 				{
;    2371 					#ifdef _SECOND_FAT_ON_
;    2372 						if (_FF_buff_addr < _FF_FAT2_ADDR)
	LDS  R30,__FF_FAT2_ADDR
	LDS  R31,__FF_FAT2_ADDR+1
	LDS  R22,__FF_FAT2_ADDR+2
	LDS  R23,__FF_FAT2_ADDR+3
	LDS  R26,__FF_buff_addr
	LDS  R27,__FF_buff_addr+1
	LDS  R24,__FF_buff_addr+2
	LDS  R25,__FF_buff_addr+3
	CALL __CPD21
	BRSH _0x198
;    2373 							if (_FF_write(_FF_buff_addr+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
	LDS  R26,__FF_FAT1_ADDR
	LDS  R27,__FF_FAT1_ADDR+1
	LDS  R24,__FF_FAT1_ADDR+2
	LDS  R25,__FF_FAT1_ADDR+3
	CALL __SUBD12
	LDS  R26,__FF_buff_addr
	LDS  R27,__FF_buff_addr+1
	LDS  R24,__FF_buff_addr+2
	LDS  R25,__FF_buff_addr+3
	CALL __ADDD12
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	BRNE _0x199
;    2374 								return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x422
;    2375 					#endif
;    2376 					if (_FF_write(_FF_buff_addr)==0)	// Save buffer data to card
_0x199:
_0x198:
	LDS  R30,__FF_buff_addr
	LDS  R31,__FF_buff_addr+1
	LDS  R22,__FF_buff_addr+2
	LDS  R23,__FF_buff_addr+3
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	BRNE _0x19A
;    2377 						return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x422
;    2378 				}
_0x19A:
;    2379 				#endif
;    2380 				if (_FF_read(addr_temp)==0)	// Read new table info
_0x197:
	__GETD1S 6
	CALL __PUTPARD1
	CALL __FF_read
	CPI  R30,0
	BRNE _0x19B
;    2381 					return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x422
;    2382 			}
_0x19B:
;    2383 		}
_0x196:
;    2384 		next_clust = ((int) _FF_buff[calc_offset+1] << 8) | _FF_buff[calc_offset];
_0x193:
_0x192:
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
;    2385 	}
;    2386 	#ifdef _FAT12_ON_
;    2387 	else if (BPB_FATType == 0x32)	// if FAT12
;    2388 	{
;    2389 		// FAT12 table address calculations
;    2390 		calc_offset = (current_cluster * 3) / 2;
;    2391 		calc_remainder = (current_cluster * 3) % 2;
;    2392 		calc_sec = (calc_offset / BPB_BytsPerSec) + BPB_RsvdSecCnt;
;    2393 		calc_offset %= BPB_BytsPerSec;
;    2394 
;    2395 	 	addr_temp = _FF_PART_ADDR+(calc_sec*BPB_BytsPerSec);
;    2396 		if (mode==SINGLE)
;    2397 		{	// This is a single cluster lookup
;    2398 			if (_FF_read(addr_temp)==0)
;    2399 				return(EOF);
;    2400 		}
;    2401 		else if ((mode==CHAIN) || (mode==END_CHAIN))
;    2402 		{	// Mupltiple clusters to lookup
;    2403 			if (addr_temp!=_FF_buff_addr)
;    2404 			{	// Is the address of lookup is different then the current buffere address
;    2405 				#ifndef _READ_ONLY_
;    2406 				if (_FF_buff_addr)	// if the buffer address is 0, don't write
;    2407 				{
;    2408 					#ifdef _SECOND_FAT_ON_
;    2409 						if (_FF_buff_addr < _FF_FAT2_ADDR)
;    2410 							if (_FF_write(_FF_buff_addr+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
;    2411 								return(EOF);
;    2412 					#endif
;    2413 					if (_FF_write(_FF_buff_addr)==0)	// Save buffer data to card
;    2414 						return(EOF);
;    2415 				}
;    2416 				#endif
;    2417 				if (_FF_read(addr_temp)==0)	// Read new table info
;    2418 					return(EOF);
;    2419 			}
;    2420 		}
;    2421 		next_clust = _FF_buff[calc_offset];
;    2422 		if (calc_offset == (BPB_BytsPerSec-1))
;    2423 		{	// Is the FAT12 record accross more than one sector?
;    2424 			addr_temp = _FF_PART_ADDR+((calc_sec+1)*0x200);
;    2425 			if ((mode==CHAIN) || (mode==END_CHAIN))
;    2426 			{	// multiple chain lookup
;    2427 				#ifndef _READ_ONLY_
;    2428 					#ifdef _SECOND_FAT_ON_
;    2429 						if (_FF_buff_addr < _FF_FAT2_ADDR)
;    2430 							if (_FF_write(_FF_buff_addr+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
;    2431 								return(EOF);
;    2432 					#endif
;    2433 				if (_FF_write(_FF_buff_addr)==0)	// Save buffer data to card
;    2434 					return(EOF);
;    2435 				#endif
;    2436 				_FF_buff_addr = addr_temp;		// Save new buffer address
;    2437 			}
;    2438 			if (_FF_read(addr_temp)==0)
;    2439 				return(EOF);
;    2440 			next_clust |= ((int) _FF_buff[0] << 8);
;    2441 		}
;    2442 		else
;    2443 			next_clust |= ((int) _FF_buff[calc_offset+1] << 8);
;    2444 
;    2445 		if (calc_remainder)
;    2446 			next_clust >>= 4;
;    2447 		else
;    2448 			next_clust &= 0x0FFF;
;    2449 			
;    2450 		if (next_clust >= 0xFF8)
;    2451 			next_clust |= 0xF000;			
;    2452 	}
;    2453 	#endif
;    2454 	else		// not FAT12 or FAT16, return 0
	RJMP _0x19C
_0x18F:
;    2455 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x422
;    2456 	return (next_clust);
_0x19C:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
_0x422:
	CALL __LOADLOCR6
	ADIW R28,15
	RET
;    2457 }
;    2458 
;    2459 // Convert a constant string file name into the proper 8.3 FAT format
;    2460 unsigned char *file_name_conversion(unsigned char *current_file)
;    2461 {
_file_name_conversion:
;    2462 	unsigned char n, c;
;    2463 		
;    2464 	c = 0;
	ST   -Y,R17
	ST   -Y,R16
;	*current_file -> Y+2
;	n -> R16
;	c -> R17
	LDI  R17,LOW(0)
;    2465 	
;    2466 	for (n=0; n<14; n++)
	LDI  R16,LOW(0)
_0x19E:
	CPI  R16,14
	BRLO PC+3
	JMP _0x19F
;    2467 	{
;    2468 		if (valid_file_char(current_file[n])==0)
	MOV  R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ST   -Y,R30
	CALL _valid_file_char
	SBIW R30,0
	BRNE _0x1A0
;    2469 			// If the character is valid, save in uppercase to file name buffer
;    2470 			FILENAME[c++] = toupper(current_file[n]);
	MOV  R30,R17
	SUBI R17,-1
	LDI  R31,0
	SUBI R30,LOW(-_FILENAME)
	SBCI R31,HIGH(-_FILENAME)
	PUSH R31
	PUSH R30
	MOV  R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ST   -Y,R30
	CALL _toupper
	POP  R26
	POP  R27
	ST   X,R30
;    2471 		else if (current_file[n]=='.')
	RJMP _0x1A1
_0x1A0:
	MOV  R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BRNE _0x1A2
;    2472 			// If it is a period, back fill buffer with [spaces], till 8 characters deep
;    2473 			while (c<8)
_0x1A3:
	CPI  R17,8
	BRSH _0x1A5
;    2474 				FILENAME[c++] = 0x20;
	MOV  R30,R17
	SUBI R17,-1
	LDI  R31,0
	SUBI R30,LOW(-_FILENAME)
	SBCI R31,HIGH(-_FILENAME)
	MOVW R26,R30
	LDI  R30,LOW(32)
	ST   X,R30
;    2475 		else if (current_file[n]==0)
	RJMP _0x1A3
_0x1A5:
	RJMP _0x1A6
_0x1A2:
	MOV  R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CPI  R30,0
	BRNE _0x1A7
;    2476 		{	// If it is NULL, back fill buffer with [spaces], till 11 characters deep
;    2477 			while (c<11)
_0x1A8:
	CPI  R17,11
	BRSH _0x1AA
;    2478 				FILENAME[c++] = 0x20;
	MOV  R30,R17
	SUBI R17,-1
	LDI  R31,0
	SUBI R30,LOW(-_FILENAME)
	SBCI R31,HIGH(-_FILENAME)
	MOVW R26,R30
	LDI  R30,LOW(32)
	ST   X,R30
;    2479 			break;
	RJMP _0x1A8
_0x1AA:
	RJMP _0x19F
;    2480 		}
;    2481 		else
_0x1A7:
;    2482 		{
;    2483 			_FF_error = NAME_ERR;
	LDI  R30,LOW(5)
	STS  __FF_error,R30
;    2484 			return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x41E
;    2485 		}
_0x1A6:
_0x1A1:
;    2486 		if (c>=11)
	CPI  R17,11
	BRSH _0x19F
;    2487 			break;
;    2488 	}
	SUBI R16,-1
	RJMP _0x19E
_0x19F:
;    2489 	FILENAME[c] = 0;
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_FILENAME)
	SBCI R27,HIGH(-_FILENAME)
	LDI  R30,LOW(0)
	ST   X,R30
;    2490 	// Return the pointer of the filename
;    2491 	return (FILENAME);		
	LDI  R30,LOW(_FILENAME)
	LDI  R31,HIGH(_FILENAME)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x41E
;    2492 }
;    2493 
;    2494 // Find the first cluster that is pointing to clus_no
;    2495 unsigned int prev_cluster(unsigned int clus_no)
;    2496 {
;    2497 	unsigned char read_flag;
;    2498 	unsigned int calc_temp, n, c, n_temp;
;    2499 	unsigned long calc_clus, addr_temp;
;    2500 	
;    2501 	addr_temp = _FF_FAT1_ADDR;
;	clus_no -> Y+17
;	read_flag -> R16
;	calc_temp -> R17,R18
;	n -> R19,R20
;	c -> Y+15
;	n_temp -> Y+13
;	calc_clus -> Y+9
;	addr_temp -> Y+5
;    2502 	c = 1;
;    2503 	if ((clus_no==0) && (BPB_FATType==0x36))
;    2504 	{
;    2505 		if (clus_0_addr>addr_temp)
;    2506 		{
;    2507 			addr_temp = clus_0_addr;
;    2508 			c = c_counter;
;    2509 		}
;    2510 	}
;    2511 
;    2512 	read_flag = 1;
;    2513 	
;    2514 	while (addr_temp<_FF_FAT2_ADDR)
;    2515 	{
;    2516 		if (BPB_FATType == 0x36)		// if FAT16
;    2517 		{
;    2518 			if (clus_no==0)
;    2519 			{
;    2520 				clus_0_addr = addr_temp;
;    2521 				c_counter = c;
;    2522 			}
;    2523 			if (_FF_read(addr_temp)==0)		// Read error ==> break
;    2524 				return(0);
;    2525 			if (_FF_n_temp)
;    2526 			{
;    2527 				n_temp = _FF_n_temp;
;    2528 				_FF_n_temp = 0;
;    2529 			}
;    2530 			else
;    2531 				n_temp = 0;
;    2532 			for (n=n_temp; n<(BPB_BytsPerSec/2); n++)
;    2533 			{
;    2534 				calc_clus = ((unsigned int) _FF_buff[(n*2)+1] << 8) | ((unsigned int) _FF_buff[n*2]);
;    2535 				calc_temp = (unsigned long) n + (((unsigned long) BPB_BytsPerSec/2) * ((unsigned long) c - 1));
;    2536 				if (calc_clus==clus_no)
;    2537 				{
;    2538 					if (calc_clus==0)
;    2539 						_FF_n_temp = n;
;    2540 					return(calc_temp);
;    2541 				}
;    2542 				else if (calc_temp > DataClusTot)
;    2543 				{
;    2544 					_FF_error = DISK_FULL;
;    2545 					return (0);
;    2546 				}
;    2547 			}
;    2548 			addr_temp += 0x200;
;    2549 			c++;
;    2550 		}
;    2551 		#ifdef _FAT12_ON_
;    2552 		else if (BPB_FATType == 0x32)	// if FAT12
;    2553 		{
;    2554 			if (read_flag)
;    2555 			{
;    2556 				if (_FF_read(addr_temp)==0)
;    2557 					return (0);	// if the read fails return 0
;    2558 				read_flag = 0;
;    2559 			}
;    2560 			calc_temp = ((unsigned long) c * 3) / 2;
;    2561 			calc_temp %= BPB_BytsPerSec;
;    2562 			calc_clus = _FF_buff[calc_temp++];
;    2563 			if (calc_temp == BPB_BytsPerSec)
;    2564 			{	// Is the FAT12 record accross a sector?
;    2565 				addr_temp += 0x200;
;    2566 				if (_FF_read(addr_temp)==0)
;    2567 					return (0);
;    2568 				calc_clus |= ((unsigned int) _FF_buff[0] << 8);
;    2569 				calc_temp = 0;
;    2570 			}
;    2571 			else
;    2572 				calc_clus |= ((unsigned int) _FF_buff[calc_temp++] << 8);
;    2573                           	
;    2574 			if (c % 2)
;    2575 				calc_clus >>= 4;
;    2576 			else
;    2577 				calc_clus &= 0x0FFF;
;    2578 			
;    2579 			if (calc_clus == clus_no)
;    2580 				return (c);
;    2581 			else if (c > DataClusTot)
;    2582 			{
;    2583 				_FF_error = DISK_FULL;
;    2584 				return (0);
;    2585 			}
;    2586 			if ((calc_temp == BPB_BytsPerSec) && (c % 2))
;    2587 			{
;    2588 				addr_temp += 0x200;
;    2589 				read_flag = 1;
;    2590 			}                                                           
;    2591 			
;    2592 			c++;			
;    2593 		}
;    2594 		#endif
;    2595 		else
;    2596 			return (0);
;    2597 	}
;    2598 	_FF_error = DISK_FULL;
;    2599 	return (0);
;    2600 }
;    2601 
;    2602 #ifndef _READ_ONLY_
;    2603 // Update cluster table to point to new cluster
;    2604 unsigned char write_clus_table(unsigned int current_cluster, unsigned int next_value, unsigned char mode)
;    2605 {
_write_clus_table:
;    2606 	unsigned long addr_temp;
;    2607 	unsigned int calc_sec, calc_offset, calc_temp, calc_remainder;
;    2608 	unsigned char nibble[3];
;    2609 	
;    2610 	if (current_cluster <=1)		// Should never be writing to cluster 0 or 1
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
	BRSH _0x1C1
;    2611 	{
;    2612 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x421
;    2613 	}
;    2614 	if (BPB_FATType == 0x36)		// if FAT16
_0x1C1:
	LDS  R26,_BPB_FATType
	CPI  R26,LOW(0x36)
	BREQ PC+3
	JMP _0x1C2
;    2615 	{
;    2616 		calc_sec = current_cluster / (BPB_BytsPerSec / 2) + BPB_RsvdSecCnt;
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	LSR  R31
	ROR  R30
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	CALL __DIVW21U
	LDS  R26,_BPB_RsvdSecCnt
	LDS  R27,_BPB_RsvdSecCnt+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
;    2617 		calc_offset = 2 * (current_cluster % (BPB_BytsPerSec / 2));
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	LSR  R31
	ROR  R30
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	CALL __MODW21U
	LSL  R30
	ROL  R31
	MOVW R18,R30
;    2618 		addr_temp = _FF_PART_ADDR + ((long) calc_sec*0x200);
	MOVW R30,R16
	CLR  R22
	CLR  R23
	__GETD2N 0x200
	CALL __MULD12
	LDS  R26,__FF_PART_ADDR
	LDS  R27,__FF_PART_ADDR+1
	LDS  R24,__FF_PART_ADDR+2
	LDS  R25,__FF_PART_ADDR+3
	CALL __ADDD12
	__PUTD1S 11
;    2619 		if (mode==SINGLE)
	LDD  R26,Y+15
	CPI  R26,LOW(0x1)
	BRNE _0x1C3
;    2620 		{	// Updating a single cluster (like writing or saving a file)
;    2621 			if (_FF_read(addr_temp)==0)
	CALL __PUTPARD1
	CALL __FF_read
	CPI  R30,0
	BRNE _0x1C4
;    2622 				return(0);
	LDI  R30,LOW(0)
	RJMP _0x421
;    2623 		}
_0x1C4:
;    2624 		else if ((mode==CHAIN) || (mode==END_CHAIN))
	RJMP _0x1C5
_0x1C3:
	LDD  R26,Y+15
	CPI  R26,LOW(0x0)
	BREQ _0x1C7
	CPI  R26,LOW(0x2)
	BREQ _0x1C7
	RJMP _0x1C6
_0x1C7:
;    2625 		{	// Multiple table access operation
;    2626 			if (addr_temp!=_FF_buff_addr)
	LDS  R30,__FF_buff_addr
	LDS  R31,__FF_buff_addr+1
	LDS  R22,__FF_buff_addr+2
	LDS  R23,__FF_buff_addr+3
	__GETD2S 11
	CALL __CPD12
	BRNE PC+3
	JMP _0x1C9
;    2627 			{	// if the desired address is already in the buffer => skip loading buffer
;    2628 				if (_FF_buff_addr)	// if new table address, write buffered, and load new
	CALL __CPD10
	BRNE PC+3
	JMP _0x1CA
;    2629 				{
;    2630 					#ifdef _SECOND_FAT_ON_
;    2631 						if (_FF_buff_addr < _FF_FAT2_ADDR)
	LDS  R30,__FF_FAT2_ADDR
	LDS  R31,__FF_FAT2_ADDR+1
	LDS  R22,__FF_FAT2_ADDR+2
	LDS  R23,__FF_FAT2_ADDR+3
	LDS  R26,__FF_buff_addr
	LDS  R27,__FF_buff_addr+1
	LDS  R24,__FF_buff_addr+2
	LDS  R25,__FF_buff_addr+3
	CALL __CPD21
	BRSH _0x1CB
;    2632 							if (_FF_write(_FF_buff_addr+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
	LDS  R26,__FF_FAT1_ADDR
	LDS  R27,__FF_FAT1_ADDR+1
	LDS  R24,__FF_FAT1_ADDR+2
	LDS  R25,__FF_FAT1_ADDR+3
	CALL __SUBD12
	LDS  R26,__FF_buff_addr
	LDS  R27,__FF_buff_addr+1
	LDS  R24,__FF_buff_addr+2
	LDS  R25,__FF_buff_addr+3
	CALL __ADDD12
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	BRNE _0x1CC
;    2633 								return(0);
	LDI  R30,LOW(0)
	RJMP _0x421
;    2634 					#endif
;    2635 					if (_FF_write(_FF_buff_addr)==0)
_0x1CC:
_0x1CB:
	LDS  R30,__FF_buff_addr
	LDS  R31,__FF_buff_addr+1
	LDS  R22,__FF_buff_addr+2
	LDS  R23,__FF_buff_addr+3
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	BRNE _0x1CD
;    2636 						return(0);
	LDI  R30,LOW(0)
	RJMP _0x421
;    2637 				}
_0x1CD:
;    2638 				if (_FF_read(addr_temp)==0)
_0x1CA:
	__GETD1S 11
	CALL __PUTPARD1
	CALL __FF_read
	CPI  R30,0
	BRNE _0x1CE
;    2639 					return(0);
	LDI  R30,LOW(0)
	RJMP _0x421
;    2640 			}
_0x1CE:
;    2641 		}
_0x1C9:
;    2642 				
;    2643 		_FF_buff[calc_offset+1] = (next_value >> 8); 
_0x1C6:
_0x1C5:
	MOVW R30,R18
	__ADDW1MN __FF_buff,1
	MOVW R26,R30
	LDD  R30,Y+17
	ANDI R31,HIGH(0x0)
	ST   X,R30
;    2644 		_FF_buff[calc_offset] = (next_value & 0xFF);
	MOVW R26,R18
	SUBI R26,LOW(-__FF_buff)
	SBCI R27,HIGH(-__FF_buff)
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ANDI R31,HIGH(0xFF)
	ST   X,R30
;    2645 		if ((mode==SINGLE) || (mode==END_CHAIN))
	LDD  R26,Y+15
	CPI  R26,LOW(0x1)
	BREQ _0x1D0
	CPI  R26,LOW(0x2)
	BRNE _0x1CF
_0x1D0:
;    2646 		{
;    2647 			#ifdef _SECOND_FAT_ON_
;    2648 				if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
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
	BRNE _0x1D2
;    2649 					return(0);
	LDI  R30,LOW(0)
	RJMP _0x421
;    2650 			#endif
;    2651 			if (_FF_write(addr_temp)==0)
_0x1D2:
	__GETD1S 11
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	BRNE _0x1D3
;    2652 			{
;    2653 				return(0);
	LDI  R30,LOW(0)
	RJMP _0x421
;    2654 			}
;    2655 		}
_0x1D3:
;    2656 	}
_0x1CF:
;    2657 	#ifdef _FAT12_ON_
;    2658 		else if (BPB_FATType == 0x32)		// if FAT12
;    2659 		{
;    2660 			calc_offset = (current_cluster * 3) / 2;
;    2661 			calc_remainder = (current_cluster * 3) % 2;
;    2662 			calc_sec = calc_offset / BPB_BytsPerSec + BPB_RsvdSecCnt;
;    2663 			calc_offset %= BPB_BytsPerSec;
;    2664 			addr_temp = _FF_PART_ADDR + ((long) calc_sec * (long) BPB_BytsPerSec);
;    2665 
;    2666 			if (mode==SINGLE)
;    2667 			{
;    2668 				if (_FF_read(addr_temp)==0)
;    2669 					return(0);
;    2670  			}
;    2671  			else if ((mode==CHAIN) || (mode==END_CHAIN))
;    2672   			{
;    2673 				if (addr_temp!=_FF_buff_addr)
;    2674 				{
;    2675 					if (_FF_buff_addr)
;    2676 					{
;    2677 					#ifdef _SECOND_FAT_ON_
;    2678 						if (_FF_buff_addr < _FF_FAT2_ADDR)
;    2679 							if (_FF_write(_FF_buff_addr+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
;    2680 								return(0);
;    2681 					#endif
;    2682 						if (_FF_write(_FF_buff_addr)==0)
;    2683 							return(0);
;    2684 					}
;    2685 					if (_FF_read(addr_temp)==0)
;    2686 						return(0);
;    2687 				}
;    2688 			}
;    2689 			nibble[0] = next_value & 0x00F;
;    2690 			nibble[1] = (next_value >> 4) & 0x00F;
;    2691 			nibble[2] = (next_value >> 8) & 0x00F;
;    2692     	
;    2693 			if (calc_offset == (BPB_BytsPerSec-1))
;    2694 			{	// Is the FAT12 record accross a sector?
;    2695 				if (calc_remainder)
;    2696 				{	// Record table uses 1 nibble of last byte
;    2697 					calc_temp = _FF_buff[calc_offset] & 0x0F;	// Mask to add new value
;    2698 					_FF_buff[calc_offset] = calc_temp | (nibble[0] << 4);	// store nibble in correct location
;    2699 					#ifdef _SECOND_FAT_ON_
;    2700 						if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
;    2701 							return(0);
;    2702 					#endif
;    2703 					if (_FF_write(addr_temp)==0)
;    2704 						return(0);
;    2705 					addr_temp += BPB_BytsPerSec;
;    2706 					if (_FF_read(addr_temp)==0)
;    2707 						return(0);	// if the read fails return 0
;    2708 					_FF_buff[0] = (nibble[2] << 4) | nibble[1];
;    2709 					if ((mode==SINGLE) || (mode==END_CHAIN))
;    2710 					{
;    2711 						#ifdef _SECOND_FAT_ON_
;    2712 							if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
;    2713 								return(0);
;    2714 						#endif
;    2715 						if (_FF_write(addr_temp)==0)
;    2716 							return(0);
;    2717 					}
;    2718 				}
;    2719 				else
;    2720 				{	// Record table uses whole last byte
;    2721 					_FF_buff[calc_offset] = (nibble[1] << 4) | nibble[0];
;    2722 					#ifdef _SECOND_FAT_ON_
;    2723 						if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
;    2724 							return(0);
;    2725 					#endif
;    2726 					if (_FF_write(addr_temp)==0)
;    2727 						return(0);
;    2728 					addr_temp += BPB_BytsPerSec;
;    2729 					if (_FF_read(addr_temp)==0)
;    2730 						return(0);	// if the read fails return 0
;    2731 					calc_temp = _FF_buff[0] & 0xF0;		// Mask to add new value
;    2732 					_FF_buff[0] = calc_temp | nibble[2];	// store nibble in correct location
;    2733 					if ((mode==SINGLE) || (mode==END_CHAIN))
;    2734 					{
;    2735 						#ifdef _SECOND_FAT_ON_
;    2736 							if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
;    2737 								return(0);
;    2738 						#endif
;    2739 						if (_FF_write(addr_temp)==0)
;    2740 							return(0);
;    2741 					}
;    2742 				}
;    2743 			}
;    2744 			else
;    2745 			{
;    2746 				if (calc_remainder)
;    2747 				{	// Record table uses 1 nibble of current byte
;    2748 					calc_temp = _FF_buff[calc_offset] & 0x0F;	// Mask to add new value
;    2749 					_FF_buff[calc_offset] = calc_temp | (nibble[0] << 4);	// store nibble in correct location
;    2750 					_FF_buff[calc_offset+1] = (nibble[2] << 4) | nibble[1];
;    2751 					if ((mode==SINGLE) || (mode==END_CHAIN))
;    2752 					{
;    2753 						#ifdef _SECOND_FAT_ON_
;    2754 							if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
;    2755 								return(0);
;    2756 						#endif
;    2757 						if (_FF_write(addr_temp)==0)
;    2758 							return(0);
;    2759 					}
;    2760 				}
;    2761 				else
;    2762 				{	// Record table uses whole current byte
;    2763 					_FF_buff[calc_offset] = (nibble[1] << 4) | nibble[0];
;    2764 					calc_temp = _FF_buff[calc_offset+1] & 0xF0;		// Mask to add new value
;    2765 					_FF_buff[calc_offset+1] = calc_temp | nibble[2];	// store nibble in correct location
;    2766 					if ((mode==SINGLE) || (mode==END_CHAIN))
;    2767 					{
;    2768 						#ifdef _SECOND_FAT_ON_
;    2769 							if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
;    2770 								return(0);
;    2771 						#endif
;    2772 						if (_FF_write(addr_temp)==0)
;    2773 							return(0);
;    2774 					}
;    2775 				}
;    2776 			}
;    2777 		}
;    2778 	#endif
;    2779 	else		// not FAT12 or FAT16, return 0
	RJMP _0x1D4
_0x1C2:
;    2780 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x421
;    2781 		
;    2782 	return(1);	
_0x1D4:
	LDI  R30,LOW(1)
_0x421:
	CALL __LOADLOCR6
	ADIW R28,20
	RET
;    2783 }
;    2784 #endif
;    2785 
;    2786 #ifndef _READ_ONLY_
;    2787 // Save new entry data to FAT entry
;    2788 unsigned char append_toc(FILE *rp)
;    2789 {
_append_toc:
;    2790 	unsigned long file_data;
;    2791 	unsigned char n;
;    2792 	unsigned char *fp;
;    2793 	unsigned int calc_temp, calc_date;
;    2794 	
;    2795 	if (rp==NULL)
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
	BRNE _0x1D5
;    2796 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x420
;    2797 
;    2798 	file_data = rp->length;
_0x1D5:
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	CALL __GETD1P
	__PUTD1S 7
;    2799 	if (_FF_read(rp->entry_sec_addr)==0)
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	__GETD2Z 22
	CALL __PUTPARD2
	CALL __FF_read
	CPI  R30,0
	BRNE _0x1D6
;    2800 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x420
;    2801 	
;    2802 	// Update Starting Cluster 
;    2803 	fp = &_FF_buff[rp->entry_offset+0x1a];
_0x1D6:
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	ADIW R26,26
	CALL __GETW1P
	__ADDW1MN __FF_buff,26
	__PUTW1R 17,18
;    2804 	*fp++ = rp->clus_start & 0xFF;
	PUSH R18
	PUSH R17
	__ADDWRN 17,18,1
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	ADIW R26,12
	CALL __GETW1P
	ANDI R31,HIGH(0xFF)
	POP  R26
	POP  R27
	ST   X,R30
;    2805 	*fp++ = rp->clus_start >> 8;
	PUSH R18
	PUSH R17
	__ADDWRN 17,18,1
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	ADIW R26,12
	CALL __GETW1P
	MOV  R30,R31
	LDI  R31,0
	POP  R26
	POP  R27
	ST   X,R30
;    2806 	
;    2807 	// Update the File Size
;    2808 	for (n=0; n<4; n++)
	LDI  R16,LOW(0)
_0x1D8:
	CPI  R16,4
	BRSH _0x1D9
;    2809 	{
;    2810 		*fp = file_data & 0xFF;
	__GETD1S 7
	__ANDD1N 0xFF
	__GETW2R 17,18
	ST   X,R30
;    2811 		file_data >>= 8;
	__GETD2S 7
	LDI  R30,LOW(8)
	CALL __LSRD12
	__PUTD1S 7
;    2812 		fp++;
	__ADDWRN 17,18,1
;    2813 	}
	SUBI R16,-1
	RJMP _0x1D8
_0x1D9:
;    2814 	
;    2815 	
;    2816 	fp = &_FF_buff[rp->entry_offset+0x16];
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	ADIW R26,26
	CALL __GETW1P
	__ADDW1MN __FF_buff,22
	__PUTW1R 17,18
;    2817 	#ifdef _RTC_ON_ 	// Date/Time Stamp file w/ RTC
;    2818 		rtc_get_timeNdate(&rtc_hour, &rtc_min, &rtc_sec, &rtc_date, &rtc_month, (int *)&rtc_year);	    			
;    2819 		calc_temp = ((int)rtc_sec&0x1F) | (((int)rtc_min&0x3F)<<5) | (((int)rtc_hour&0x1F)<<11);
;    2820 		*fp++ = calc_temp&0x00FF;	// File create Time 
;    2821 		*fp++ = (calc_temp&0xFF00) >> 8;
;    2822 		calc_date = ((int)rtc_date&0x1F) | (((int)rtc_month&0x0F)<<5) | (((rtc_year-1980)&0x7F)<<9);
;    2823 		*fp++ = calc_date&0x00FF;	// File create Date
;    2824 		*fp++ = (calc_date&0xFF00) >> 8;
;    2825 	#else		// Increment Date Code, no RTC used 
;    2826 		file_data = 0;
	__CLRD1S 7
;    2827 		for (n=0; n<4; n++)
	LDI  R16,LOW(0)
_0x1DB:
	CPI  R16,4
	BRSH _0x1DC
;    2828 		{
;    2829 			file_data <<= 8;
	__GETD2S 7
	LDI  R30,LOW(8)
	CALL __LSLD12
	__PUTD1S 7
;    2830 			file_data |= *fp;
	__GETW2R 17,18
	LD   R30,X
	__GETD2S 7
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __ORD12
	__PUTD1S 7
;    2831 			fp--;
	__SUBWRN 17,18,1
;    2832 		}
	SUBI R16,-1
	RJMP _0x1DB
_0x1DC:
;    2833 		file_data++;
	__GETD1S 7
	__SUBD1N -1
	__PUTD1S 7
;    2834 		for (n=0; n<4; n++)
	LDI  R16,LOW(0)
_0x1DE:
	CPI  R16,4
	BRSH _0x1DF
;    2835 		{
;    2836 			fp++;
	__ADDWRN 17,18,1
;    2837 			*fp = file_data & 0xFF;
	__GETD1S 7
	__ANDD1N 0xFF
	__GETW2R 17,18
	ST   X,R30
;    2838 			file_data >>=8;
	__GETD2S 7
	LDI  R30,LOW(8)
	CALL __LSRD12
	__PUTD1S 7
;    2839 		}
	SUBI R16,-1
	RJMP _0x1DE
_0x1DF:
;    2840 	#endif
;    2841 	if (_FF_write(rp->entry_sec_addr)==0)
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	__GETD2Z 22
	CALL __PUTPARD2
	CALL __FF_write
	CPI  R30,0
	BRNE _0x1E0
;    2842 		return(0);
	LDI  R30,LOW(0)
	RJMP _0x420
;    2843 	
;    2844 	return(1);
_0x1E0:
	LDI  R30,LOW(1)
_0x420:
	CALL __LOADLOCR5
	ADIW R28,13
	RET
;    2845 }
;    2846 #endif
;    2847 
;    2848 #ifndef _READ_ONLY_
;    2849 // Erase a chain of clusters (set table entries to 0 for clusters in chain)
;    2850 unsigned char erase_clus_chain(unsigned int start_clus)
;    2851 {
_erase_clus_chain:
;    2852 	unsigned int clus_temp, clus_use;
;    2853 	
;    2854 	if (start_clus==0)
	CALL __SAVELOCR4
;	start_clus -> Y+4
;	clus_temp -> R16,R17
;	clus_use -> R18,R19
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BRNE _0x1E1
;    2855 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x41F
;    2856 	clus_use = start_clus;
_0x1E1:
	__GETWRS 18,19,4
;    2857 	_FF_buff_addr = 0;
	LDI  R30,0
	STS  __FF_buff_addr,R30
	STS  __FF_buff_addr+1,R30
	STS  __FF_buff_addr+2,R30
	STS  __FF_buff_addr+3,R30
;    2858 	while(clus_use <= 0xFFF8)
_0x1E2:
	__CPWRN 18,19,65529
	BRSH _0x1E4
;    2859 	{
;    2860 		clus_temp = next_cluster(clus_use, CHAIN);
	ST   -Y,R19
	ST   -Y,R18
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _next_cluster
	MOVW R16,R30
;    2861 		if ((clus_temp >= 0xFFF8) || (clus_temp == 0))
	__CPWRN 16,17,65528
	BRSH _0x1E6
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRNE _0x1E5
_0x1E6:
;    2862 			break;
	RJMP _0x1E4
;    2863 		if (write_clus_table(clus_use, 0, CHAIN) == 0)
_0x1E5:
	ST   -Y,R19
	ST   -Y,R18
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R30
	CALL _write_clus_table
	CPI  R30,0
	BRNE _0x1E8
;    2864 			return (0);
	LDI  R30,LOW(0)
	RJMP _0x41F
;    2865 		clus_use = clus_temp;
_0x1E8:
	__MOVEWRR 18,19,16,17
;    2866 	}
	RJMP _0x1E2
_0x1E4:
;    2867 	if (write_clus_table(clus_use, 0, END_CHAIN) == 0)
	ST   -Y,R19
	ST   -Y,R18
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _write_clus_table
	CPI  R30,0
	BRNE _0x1E9
;    2868 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x41F
;    2869 	clus_0_addr = 0;
_0x1E9:
	LDI  R30,0
	STS  _clus_0_addr,R30
	STS  _clus_0_addr+1,R30
	STS  _clus_0_addr+2,R30
	STS  _clus_0_addr+3,R30
;    2870 	c_counter = 0;
	LDI  R30,0
	STS  _c_counter,R30
	STS  _c_counter+1,R30
;    2871 	
;    2872 	return (1);	
	LDI  R30,LOW(1)
_0x41F:
	CALL __LOADLOCR4
	ADIW R28,6
	RET
;    2873 }
;    2874 
;    2875 // Quickformat of a card (erase cluster table and root directory
;    2876 int fquickformat(void)
;    2877 {
_fquickformat:
;    2878 	long c;
;    2879 	
;    2880 	for (c=0; c<BPB_BytsPerSec; c++)
	SBIW R28,4
;	c -> Y+0
	__CLRD1S 0
_0x1EB:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	__GETD2S 0
	CLR  R22
	CLR  R23
	CALL __CPD21
	BRGE _0x1EC
;    2881 		_FF_buff[c] = 0;
	__GETD1S 0
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	MOVW R26,R30
	LDI  R30,LOW(0)
	ST   X,R30
;    2882 	
;    2883 	c = _FF_FAT1_ADDR + 0x200;
	__GETD1S 0
	__SUBD1N -1
	__PUTD1S 0
	RJMP _0x1EB
_0x1EC:
	LDS  R30,__FF_FAT1_ADDR
	LDS  R31,__FF_FAT1_ADDR+1
	LDS  R22,__FF_FAT1_ADDR+2
	LDS  R23,__FF_FAT1_ADDR+3
	__ADDD1N 512
	__PUTD1S 0
;    2884 	while (c < (_FF_ROOT_ADDR + (0x400 * BPB_SecPerClus)))
_0x1ED:
	LDS  R30,_BPB_SecPerClus
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
	BRSH _0x1EF
;    2885 	{
;    2886 		if (_FF_write(c)==0)
	__GETD1S 0
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	BRNE _0x1F0
;    2887 		{
;    2888 			_FF_error = WRITE_ERR;
	LDI  R30,LOW(3)
	STS  __FF_error,R30
;    2889 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x41E
;    2890 		}
;    2891 		c += 0x200;
_0x1F0:
	__GETD1S 0
	__ADDD1N 512
	__PUTD1S 0
;    2892 	}	
	RJMP _0x1ED
_0x1EF:
;    2893 	_FF_buff[0] = 0xF8;
	LDI  R30,LOW(248)
	STS  __FF_buff,R30
;    2894 	_FF_buff[1] = 0xFF;
	LDI  R30,LOW(255)
	__PUTB1MN __FF_buff,1
;    2895 	_FF_buff[2] = 0xFF;
	__PUTB1MN __FF_buff,2
;    2896 	if (BPB_FATType == 0x36)
	LDS  R26,_BPB_FATType
	CPI  R26,LOW(0x36)
	BRNE _0x1F1
;    2897 		_FF_buff[3] = 0xFF;
	__PUTB1MN __FF_buff,3
;    2898 	if ((_FF_write(_FF_FAT1_ADDR)==0) || (_FF_write(_FF_FAT2_ADDR)==0))
_0x1F1:
	LDS  R30,__FF_FAT1_ADDR
	LDS  R31,__FF_FAT1_ADDR+1
	LDS  R22,__FF_FAT1_ADDR+2
	LDS  R23,__FF_FAT1_ADDR+3
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	BREQ _0x1F3
	LDS  R30,__FF_FAT2_ADDR
	LDS  R31,__FF_FAT2_ADDR+1
	LDS  R22,__FF_FAT2_ADDR+2
	LDS  R23,__FF_FAT2_ADDR+3
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	BRNE _0x1F2
_0x1F3:
;    2899 	{
;    2900 		_FF_error = WRITE_ERR;
	LDI  R30,LOW(3)
	STS  __FF_error,R30
;    2901 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x41E
;    2902 	}
;    2903 	return (0);
_0x1F2:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x41E:
	ADIW R28,4
	RET
;    2904 }
;    2905 #endif
;    2906 
;    2907 // function that checks for directory changes then gets into a working form
;    2908 int _FF_checkdir(char *F_PATH, unsigned long *SAVE_ADDR, char *path_temp)
;    2909 {
__FF_checkdir:
;    2910 	unsigned char *sp, *qp;
;    2911     
;    2912     *SAVE_ADDR = _FF_DIR_ADDR;	// save local dir addr
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
;    2913     
;    2914     qp = F_PATH;
	__GETWRS 18,19,8
;    2915     if (*qp=='\\')
	MOVW R26,R18
	LD   R26,X
	CPI  R26,LOW(0x5C)
	BRNE _0x1F5
;    2916     {
;    2917     	_FF_DIR_ADDR = _FF_ROOT_ADDR;
	LDS  R30,__FF_ROOT_ADDR
	LDS  R31,__FF_ROOT_ADDR+1
	LDS  R22,__FF_ROOT_ADDR+2
	LDS  R23,__FF_ROOT_ADDR+3
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    2918 		qp++;
	__ADDWRN 18,19,1
;    2919 	}
;    2920 
;    2921 	sp = path_temp;
_0x1F5:
	__GETWRS 16,17,4
;    2922 	while(*qp)
_0x1F6:
	MOVW R26,R18
	LD   R30,X
	CPI  R30,0
	BREQ _0x1F8
;    2923 	{
;    2924 		if ((valid_file_char(*qp)==0) || (*qp=='.'))
	ST   -Y,R30
	CALL _valid_file_char
	SBIW R30,0
	BREQ _0x1FA
	MOVW R26,R18
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BRNE _0x1F9
_0x1FA:
;    2925 			*sp++ = toupper(*qp++);
	PUSH R17
	PUSH R16
	__ADDWRN 16,17,1
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R30,X
	ST   -Y,R30
	CALL _toupper
	POP  R26
	POP  R27
	ST   X,R30
;    2926 		else if (*qp=='\\')
	RJMP _0x1FC
_0x1F9:
	MOVW R26,R18
	LD   R26,X
	CPI  R26,LOW(0x5C)
	BRNE _0x1FD
;    2927 		{
;    2928 			*sp = 0;	// terminate string
	MOVW R26,R16
	LDI  R30,LOW(0)
	ST   X,R30
;    2929 			if (_FF_chdir(path_temp))
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL __FF_chdir
	SBIW R30,0
	BREQ _0x1FE
;    2930 			{
;    2931 				return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x41D
;    2932 			}
;    2933 			sp = path_temp;
_0x1FE:
	__GETWRS 16,17,4
;    2934 			qp++;
	__ADDWRN 18,19,1
;    2935 		}
;    2936 		else
	RJMP _0x1FF
_0x1FD:
;    2937 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x41D
;    2938 	}
_0x1FF:
_0x1FC:
	RJMP _0x1F6
_0x1F8:
;    2939 	
;    2940 	*sp = 0;		// terminate string
	MOVW R26,R16
	LDI  R30,LOW(0)
	ST   X,R30
;    2941 	return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x41D:
	CALL __LOADLOCR4
	ADIW R28,10
	RET
;    2942 }
;    2943 
;    2944 #ifndef _READ_ONLY_
;    2945 int mkdir(char *F_PATH)
;    2946 {
;    2947 	unsigned char *sp, *qp;
;    2948 	unsigned char fpath[14];
;    2949 	unsigned int c, calc_temp, clus_temp, calc_time, calc_date;
;    2950 	int s;
;    2951 	unsigned long addr_temp, path_addr_temp;
;    2952     
;    2953     addr_temp = 0;	// save local dir addr
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
;    2954     
;    2955     if (_FF_checkdir(F_PATH, &addr_temp, fpath))
;    2956 	{
;    2957 		_FF_DIR_ADDR = addr_temp;
;    2958 		return (EOF);
;    2959 	}
;    2960     
;    2961 	path_addr_temp = _FF_DIR_ADDR;
;    2962 	s = scan_directory(&path_addr_temp, fpath);
;    2963 	if ((s) || (path_addr_temp==0))
;    2964 	{
;    2965 		_FF_DIR_ADDR = addr_temp;
;    2966 		return (EOF);
;    2967 	}
;    2968 	clus_temp = prev_cluster(0);				
;    2969 	calc_temp = path_addr_temp % BPB_BytsPerSec;
;    2970 	path_addr_temp -= calc_temp;
;    2971 	if (_FF_read(path_addr_temp)==0)	
;    2972 	{
;    2973 		_FF_DIR_ADDR = addr_temp;
;    2974 		return (EOF);
;    2975 	}
;    2976 	
;    2977 	sp = &_FF_buff[calc_temp];
;    2978 	qp = fpath;
;    2979 
;    2980 	for (c=0; c<11; c++)	// Write Folder name
;    2981 	{
;    2982 	 	if (*qp)
;    2983 		 	*sp++ = *qp++;
;    2984 		else 
;    2985 			*sp++ = 0x20;	// '0' pad
;    2986 	}
;    2987 	*sp++ = 0x10;				// Attribute bit auto set to "Directory"
;    2988 	*sp++ = 0;					// Reserved for WinNT
;    2989 	*sp++ = 0;					// Mili-second stamp for create
;    2990 	for (c=0; c<4; c++)			// set create and modify time to '0'
;    2991 		*sp++ = 0;
;    2992 	*sp++ = 0;					// File access date (2 bytes)
;    2993 	*sp++ = 0;
;    2994 	*sp++ = 0;					// 0 for FAT12/16 (2 bytes)
;    2995 	*sp++ = 0;
;    2996 	#ifdef _RTC_ON_
;    2997 		rtc_get_timeNdate(&rtc_hour, &rtc_min, &rtc_sec, &rtc_date, &rtc_month, (int *)&rtc_year);	    			
;    2998 		calc_time = ((int)rtc_sec&0x1F) | (((int)rtc_min&0x3F)<<5) | (((int)rtc_hour&0x1F)<<11);
;    2999 		*sp++ = calc_time&0x00FF;	// File modify Time 
;    3000 		*sp++ = (calc_time&0xFF00) >> 8;
;    3001 		calc_date = ((int)rtc_date&0x1F) | (((int)rtc_month&0x0F)<<5) | (((rtc_year-1980)&0x7F)<<9);
;    3002 		*sp++ = calc_date&0x00FF;	// File modify Date
;    3003 		*sp++ = (calc_date&0xFF00) >> 8;
;    3004 	#else
;    3005 		for (c=0; c<4; c++)			// set file create and modify time to '0'
;    3006 			*sp++ = 0;
;    3007 	#endif
;    3008 	
;    3009 	*sp++ = clus_temp & 0xFF;				// Starting cluster (2 bytes)
;    3010 	*sp++ = (clus_temp >> 8) & 0xFF;
;    3011 	for (c=0; c<4; c++)
;    3012 		*sp++ = 0;			// File length (0 for folder)
;    3013 
;    3014 	
;    3015 	if (_FF_write(path_addr_temp)==0)	// write entry to card
;    3016 	{
;    3017 		_FF_DIR_ADDR = addr_temp;
;    3018 		return (EOF);
;    3019 	}
;    3020 	if (write_clus_table(clus_temp, 0xFFFF, SINGLE)==0)
;    3021 	{
;    3022 		_FF_DIR_ADDR = addr_temp;
;    3023 		return (EOF);
;    3024 	}
;    3025 	if (_FF_read(_FF_DIR_ADDR)==0)	
;    3026 	{
;    3027 		_FF_DIR_ADDR = addr_temp;
;    3028 		return (EOF);
;    3029 	}
;    3030 	if (_FF_DIR_ADDR != _FF_ROOT_ADDR)
;    3031 	{
;    3032 		sp = &_FF_buff[0];
;    3033 		qp = &_FF_buff[0x20];
;    3034 		for (c=0; c<0x20; c++)
;    3035 			*qp++ = *sp++;
;    3036 		_FF_buff[1] = ' ';
;    3037 		for (c=0x3C; c<0x40; c++)
;    3038 			_FF_buff[c] = 0;
;    3039 	}
;    3040 	else
;    3041 	{
;    3042 		for (c=0x01; c<0x0B; c++)
;    3043 			_FF_buff[c] = 0x20;
;    3044 		for (c=0x0C; c<0x20; c++)
;    3045 			_FF_buff[c] = 0;
;    3046 		_FF_buff[0] = '.';
;    3047 		_FF_buff[0x0B] = 0x10;
;    3048 		#ifdef _RTC_ON_
;    3049 			_FF_buff[0x0E] = calc_time&0x00FF;	// File modify Time 
;    3050 			_FF_buff[0x0F] = (calc_time&0xFF00) >> 8;
;    3051 			_FF_buff[0x10] = calc_date&0x00FF;	// File modify Date
;    3052 			_FF_buff[0x11] = (calc_date&0xFF00) >> 8;
;    3053 			_FF_buff[0x16] = calc_time&0x00FF;	// File modify Time 
;    3054 			_FF_buff[0x17] = (calc_time&0xFF00) >> 8;
;    3055 			_FF_buff[0x18] = calc_date&0x00FF;	// File modify Date
;    3056 			_FF_buff[0x19] = (calc_date&0xFF00) >> 8;
;    3057 		#endif
;    3058 		for (c=0x3A; c<0x40; c++)
;    3059 			_FF_buff[c] = 0;
;    3060 	}
;    3061 	for (c=0x22; c<0x2B; c++)
;    3062 		_FF_buff[c] = 0x20;
;    3063 	#ifdef _RTC_ON_
;    3064 		_FF_buff[0x2E] = calc_time&0x00FF;	// File modify Time 
;    3065 		_FF_buff[0x2F] = (calc_time&0xFF00) >> 8;
;    3066 		_FF_buff[0x30] = calc_date&0x00FF;	// File modify Date
;    3067 		_FF_buff[0x31] = (calc_date&0xFF00) >> 8;
;    3068 		_FF_buff[0x36] = calc_time&0x00FF;	// File modify Time 
;    3069 		_FF_buff[0x37] = (calc_time&0xFF00) >> 8;
;    3070 		_FF_buff[0x38] = calc_date&0x00FF;	// File modify Date
;    3071 		_FF_buff[0x39] = (calc_date&0xFF00) >> 8;
;    3072 	#endif
;    3073 	_FF_buff[0x20] = '.';
;    3074 	_FF_buff[0x21] = '.';
;    3075 	_FF_buff[0x2B] = 0x10;
;    3076 
;    3077 	_FF_buff[0x1A] = clus_temp & 0xFF;				// Starting cluster (2 bytes)
;    3078 	_FF_buff[0x1B] = (clus_temp >> 8) & 0xFF;
;    3079 	for (c=0x40; c<BPB_BytsPerSec; c++)
;    3080 		_FF_buff[c] = 0;
;    3081 	path_addr_temp = clust_to_addr(clus_temp);
;    3082 
;    3083 	_FF_DIR_ADDR = addr_temp;	// reset dir addr
;    3084 	if (_FF_write(path_addr_temp)==0)	
;    3085 		return (EOF);
;    3086 	for (c=0; c<0x40; c++)
;    3087 		_FF_buff[c] = 0;
;    3088 	for (c=1; c<BPB_SecPerClus; c++)
;    3089 	{
;    3090 		if (_FF_write(path_addr_temp+((long)c*0x200))==0)	
;    3091 			return (EOF);
;    3092 	}
;    3093 	return (0);		
;    3094 }
;    3095 
;    3096 int rmdir(char *F_PATH)
;    3097 {
;    3098 	unsigned char *sp;
;    3099 	unsigned char fpath[14];
;    3100 	unsigned int c, n, calc_temp, clus_temp;
;    3101 	int s;
;    3102 	unsigned long addr_temp, path_addr_temp;
;    3103 	
;    3104 	addr_temp = 0;	// save local dir addr
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
;    3105     
;    3106     if (_FF_checkdir(F_PATH, &addr_temp, fpath))
;    3107 	{
;    3108 		_FF_DIR_ADDR = addr_temp;
;    3109 		return (EOF);
;    3110 	}
;    3111 	if (fpath[0]==0)
;    3112 	{
;    3113 		_FF_DIR_ADDR = addr_temp;
;    3114 		return (EOF);
;    3115 	}
;    3116 
;    3117     path_addr_temp = _FF_DIR_ADDR;	// save addr for later
;    3118 	
;    3119 	if (_FF_chdir(fpath))	// Change directory to dir to be deleted
;    3120 	{	
;    3121 		_FF_DIR_ADDR = addr_temp;
;    3122 		return (EOF);
;    3123 	}
;    3124 	if ((_FF_DIR_ADDR==_FF_ROOT_ADDR)||(_FF_DIR_ADDR==addr_temp))
;    3125 	{	// if trying to delete root, or current dir error
;    3126 		_FF_DIR_ADDR = addr_temp;
;    3127 		return (EOF);
;    3128 	}
;    3129 	
;    3130 	for (c=0; c<BPB_SecPerClus; c++)
;    3131 	{	// scan through dir to see if it is empty
;    3132 		if (_FF_read(_FF_DIR_ADDR+((long)c*0x200))==0)
;    3133 		{	// read sectors 	
;    3134 			_FF_DIR_ADDR = addr_temp;
;    3135 			return (EOF);
;    3136 		}
;    3137 		for (n=0; n<0x10; n++)
;    3138 		{
;    3139 			if ((c==0)&&(n==0))	// skip first 2 entries 
;    3140 				n=2;
;    3141 			sp = &_FF_buff[n*0x20];
;    3142 			if (*sp==0)
;    3143 			{	// 
;    3144 				c = BPB_SecPerClus;
;    3145 				break;
;    3146 			}
;    3147 			while (valid_file_char(*sp)==0)
;    3148 			{
;    3149 				sp++;
;    3150 				if (sp == &_FF_buff[(n*0x20)+0x0A])
;    3151 				{	// a valid file or folder found
;    3152 					_FF_DIR_ADDR = addr_temp;
;    3153 					return (EOF);
;    3154 				}
;    3155 			}
;    3156 		}
;    3157 	}
;    3158 	// directory empty, delete dir
;    3159 	_FF_DIR_ADDR = path_addr_temp;	// go back to previous directory 
;    3160 
;    3161 	s = scan_directory(&path_addr_temp, fpath);
;    3162 
;    3163 	_FF_DIR_ADDR = addr_temp;	// reset address
;    3164 
;    3165 	if (s == 0)
;    3166 		return (EOF);
;    3167 	
;    3168 	calc_temp = path_addr_temp % BPB_BytsPerSec;
;    3169 	path_addr_temp -= calc_temp;
;    3170 
;    3171 	if (_FF_read(path_addr_temp)==0)	
;    3172 		return (EOF);
;    3173     
;    3174 	clus_temp = ((int) _FF_buff[calc_temp+0x1B] << 8) | _FF_buff[calc_temp+0x1A];
;    3175 	_FF_buff[calc_temp] = 0xE5;
;    3176 	
;    3177 	if (_FF_buff[calc_temp+0x0B]&0x02)
;    3178 		return (EOF);
;    3179 	if (_FF_write(path_addr_temp)==0) 
;    3180 		return (EOF);
;    3181 	if (erase_clus_chain(clus_temp)==0)
;    3182 		return (EOF);
;    3183 	
;    3184     return (0);
;    3185 }
;    3186 #endif
;    3187 
;    3188 int chdirc(char flash *F_PATH)
;    3189 {
;    3190 	unsigned char fpath[_FF_PATH_LENGTH];
;    3191 	int c;
;    3192 	
;    3193 	for (c=0; c<_FF_PATH_LENGTH; c++)
;	*F_PATH -> Y+102
;	fpath -> Y+2
;	c -> R16,R17
;    3194 	{
;    3195 		fpath[c] = F_PATH[c];
;    3196 		if (F_PATH[c]==0)
;    3197 			break;
;    3198 	}
;    3199 	return (chdir(fpath));
;    3200 }
;    3201 
;    3202 int chdir(char *F_PATH)
;    3203 {
;    3204 	unsigned char *qp, *sp, fpath[14], valid_flag;
;    3205 	unsigned int m, n, c, d, calc;
;    3206 	unsigned long addr_temp;
;    3207 
;    3208     
;    3209     addr_temp = 0;	// save local dir addr
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
;    3210     
;    3211 	if ((F_PATH[0]=='\\') && (F_PATH[1]==0))
;    3212 	{
;    3213 		_FF_DIR_ADDR = _FF_ROOT_ADDR;
;    3214 		_FF_FULL_PATH[1] = 0;
;    3215 		return (0);
;    3216 	}
;    3217 	
;    3218     if (_FF_checkdir(F_PATH, &addr_temp, fpath))
;    3219 	{
;    3220 		_FF_DIR_ADDR = addr_temp;
;    3221 		return (EOF);
;    3222 	}
;    3223 	if (fpath[0]==0)
;    3224 		return (EOF);
;    3225 
;    3226 	if ((fpath[0]=='.') && (fpath[1]=='.') && (fpath[2]==0))
;    3227 	{	// trying to get back to prev dir
;    3228 		if (_FF_DIR_ADDR == _FF_ROOT_ADDR)		// already as far back as can go
;    3229 			return (EOF);
;    3230 		if (_FF_read(_FF_DIR_ADDR)==0)
;    3231 			return (EOF);
;    3232 		m = ((unsigned int) _FF_buff[0x3B] << 8) | (unsigned int) _FF_buff[0x3A];
;    3233 		if (m)
;    3234 			_FF_DIR_ADDR = clust_to_addr(m);
;    3235 		else
;    3236 			_FF_DIR_ADDR = _FF_ROOT_ADDR;
;    3237 		
;    3238 					sp = F_PATH;
;    3239 					qp = _FF_FULL_PATH + strlen(_FF_FULL_PATH);
;    3240 					while (*sp)
;    3241 					{
;    3242 						if ((*sp=='.')&&(*(sp+1)=='.'))
;    3243 						{
;    3244 							#ifdef _ICCAVR_
;    3245 								qp = strrchr(_FF_FULL_PATH, '\\');
;    3246 								if (qp==0)
;    3247 								   return (EOF);
;    3248 								*qp = 0;
;    3249 								qp = strrchr(_FF_FULL_PATH, '\\');
;    3250 								if (qp==0)
;    3251 								   return (EOF);
;    3252 								qp++;
;    3253 							#endif
;    3254 							#ifdef _CVAVR_
;    3255 								_FF_FULL_PATH[strrpos(_FF_FULL_PATH, '\\')] = 0;
;    3256 							    c = strrpos(_FF_FULL_PATH, '\\');
;    3257 								if (c==EOF)
;    3258 									return (EOF);
;    3259 								qp = _FF_FULL_PATH + c;
;    3260 							#endif
;    3261 							*qp = 0;
;    3262 							sp += 2;
;    3263 						}
;    3264 						else 
;    3265 							*qp++ = toupper(*sp++);
;    3266 					}
;    3267 					*qp++ = '\\';
;    3268 					*qp = 0;
;    3269 
;    3270 		return (0);
;    3271 	}
;    3272 		
;    3273 	qp = fpath;
;    3274 	sp = fpath;
;    3275 	while(sp < (fpath+11))
;    3276 	{
;    3277 		if (*qp)
;    3278 			*sp++ = toupper(*qp++);
;    3279 		else	// (*qp==0)
;    3280 			*sp++ = 0x20;
;    3281 	}     
;    3282 	*sp = 0;
;    3283 
;    3284 	qp = fpath;
;    3285 	m = 0;
;    3286 	d = 0;
;    3287 	valid_flag = 0;
;    3288 	while (d<BPB_RootEntCnt)
;    3289 	{
;    3290     	_FF_read(_FF_DIR_ADDR+(m*0x200));
;    3291 		for (n=0; n<16; n++)
;    3292 		{
;    3293 			if (_FF_buff[n*0x20] == 0)	// no more entries in dir
;    3294 			{
;    3295 				_FF_DIR_ADDR = addr_temp;
;    3296 				return (EOF);
;    3297 			}
;    3298 			calc = (n*0x20);
;    3299 			for (c=0; c<11; c++)
;    3300 			{	// check for name match
;    3301 				if (fpath[c] == _FF_buff[calc+c])
;    3302 					valid_flag = 1;
;    3303 				else if (fpath[c] == 0)
;    3304 				{
;    3305 					if (_FF_buff[calc+c]==0x20)
;    3306 						break;
;    3307 				}
;    3308 				else
;    3309 				{
;    3310 					valid_flag = 0;	
;    3311 					break;
;    3312 				}
;    3313 		    }   
;    3314 		    if (valid_flag)
;    3315 	  		{
;    3316 	  			if (_FF_buff[calc+0xB] != 0x10)	// not a directory
;    3317 	  				valid_flag = 0;
;    3318 	  			else
;    3319 	  			{
;    3320 	  				c = ((int) _FF_buff[calc+0x1B] << 8) | ((int) _FF_buff[calc+0x1A]);
;    3321 					_FF_DIR_ADDR = clust_to_addr(c);
;    3322 					sp = F_PATH;
;    3323 					if (*sp=='\\')
;    3324 					{	// Restart String @root
;    3325 						qp = _FF_FULL_PATH + 1;
;    3326 						*qp = 0;
;    3327 						sp++;
;    3328 					}
;    3329 					else
;    3330 						qp = _FF_FULL_PATH + strlen(_FF_FULL_PATH);
;    3331 					while (*sp)
;    3332 					{
;    3333 						if ((*sp=='.')&&(*(sp+1)=='.'))
;    3334 						{
;    3335 							#ifdef _ICCAVR_
;    3336 								qp = strrchr(_FF_FULL_PATH, '\\');
;    3337 								if (qp==0)
;    3338 								   return (EOF);
;    3339 								*qp = 0;
;    3340 								qp = strrchr(_FF_FULL_PATH, '\\');
;    3341 								if (qp==0)
;    3342 								   return (EOF);
;    3343 								qp++;
;    3344 							#endif
;    3345 							#ifdef _CVAVR_
;    3346 								_FF_FULL_PATH[strrpos(_FF_FULL_PATH, '\\')] = 0;
;    3347 								c = strrpos(_FF_FULL_PATH, '\\');
;    3348 								if (c==EOF)
;    3349 								   return (EOF);
;    3350 								qp = _FF_FULL_PATH + c;
;    3351 							#endif
;    3352 							*qp = 0;
;    3353 							sp += 2;
;    3354 						}
;    3355 						else 
;    3356 							*qp++ = toupper(*sp++);
;    3357 					}
;    3358 					*qp++ = '\\';
;    3359 					*qp = 0;
;    3360 					return (0);
;    3361 				}
;    3362 			}
;    3363 		  	d++;		  		
;    3364 		}
;    3365 		m++;
;    3366 	}
;    3367 	_FF_DIR_ADDR = addr_temp;
;    3368 	return (EOF);
;    3369 }
;    3370 
;    3371 // Function to change directories one at a time, not effecting the working dir string
;    3372 int _FF_chdir(char *F_PATH)
;    3373 {
__FF_chdir:
;    3374 	unsigned char *qp, *sp, valid_flag, fpath[14];
;    3375 	unsigned int m, n, c, d, calc;
;    3376     
;    3377 	if ((F_PATH[0]=='.') && (F_PATH[1]=='.') && (F_PATH[2]==0))
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
	BRNE _0x289
	LDD  R26,Y+29
	LDD  R27,Y+29+1
	ADIW R26,1
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BRNE _0x289
	LDD  R26,Y+29
	LDD  R27,Y+29+1
	ADIW R26,2
	LD   R26,X
	CPI  R26,LOW(0x0)
	BREQ _0x28A
_0x289:
	RJMP _0x288
_0x28A:
;    3378 	{	// trying to get back to prev dir
;    3379 		if (_FF_DIR_ADDR == _FF_ROOT_ADDR)		// already as far back as can go
	LDS  R30,__FF_ROOT_ADDR
	LDS  R31,__FF_ROOT_ADDR+1
	LDS  R22,__FF_ROOT_ADDR+2
	LDS  R23,__FF_ROOT_ADDR+3
	LDS  R26,__FF_DIR_ADDR
	LDS  R27,__FF_DIR_ADDR+1
	LDS  R24,__FF_DIR_ADDR+2
	LDS  R25,__FF_DIR_ADDR+3
	CALL __CPD12
	BRNE _0x28B
;    3380 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x41C
;    3381 		if (_FF_read(_FF_DIR_ADDR)==0)
_0x28B:
	LDS  R30,__FF_DIR_ADDR
	LDS  R31,__FF_DIR_ADDR+1
	LDS  R22,__FF_DIR_ADDR+2
	LDS  R23,__FF_DIR_ADDR+3
	CALL __PUTPARD1
	CALL __FF_read
	CPI  R30,0
	BRNE _0x28C
;    3382 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x41C
;    3383 		m = ((unsigned int) _FF_buff[0x3B] << 8) | (unsigned int) _FF_buff[0x3A];
_0x28C:
	__GETBRMN 27,__FF_buff,59
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,58
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STD  Y+13,R30
	STD  Y+13+1,R31
;    3384 		if (m)
	SBIW R30,0
	BREQ _0x28D
;    3385 			_FF_DIR_ADDR = clust_to_addr(m);
	ST   -Y,R31
	ST   -Y,R30
	CALL _clust_to_addr
	RJMP _0x438
;    3386 		else
_0x28D:
;    3387 			_FF_DIR_ADDR = _FF_ROOT_ADDR;
	LDS  R30,__FF_ROOT_ADDR
	LDS  R31,__FF_ROOT_ADDR+1
	LDS  R22,__FF_ROOT_ADDR+2
	LDS  R23,__FF_ROOT_ADDR+3
_0x438:
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3388 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41C
;    3389 	}
;    3390 		
;    3391 	qp = F_PATH;
_0x288:
	__GETWRS 16,17,29
;    3392 	sp = fpath;
	MOVW R30,R28
	ADIW R30,15
	MOVW R18,R30
;    3393 	while(sp < (fpath+11))
_0x28F:
	MOVW R30,R28
	ADIW R30,26
	CP   R18,R30
	CPC  R19,R31
	BRSH _0x291
;    3394 	{
;    3395 		if (valid_file_char(*qp)==0)
	MOVW R26,R16
	LD   R30,X
	ST   -Y,R30
	CALL _valid_file_char
	SBIW R30,0
	BRNE _0x292
;    3396 			*sp++ = toupper(*qp++);
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	MOVW R26,R16
	__ADDWRN 16,17,1
	LD   R30,X
	ST   -Y,R30
	CALL _toupper
	POP  R26
	POP  R27
	ST   X,R30
;    3397 		else if (*qp==0)
	RJMP _0x293
_0x292:
	MOVW R26,R16
	LD   R30,X
	CPI  R30,0
	BRNE _0x294
;    3398 			*sp++ = 0x20;
	MOVW R26,R18
	__ADDWRN 18,19,1
	LDI  R30,LOW(32)
	ST   X,R30
;    3399 		else
	RJMP _0x295
_0x294:
;    3400 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x41C
;    3401 	}     
_0x295:
_0x293:
	RJMP _0x28F
_0x291:
;    3402 	*sp = 0;
	MOVW R26,R18
	LDI  R30,LOW(0)
	ST   X,R30
;    3403 	m = 0;
	LDI  R30,0
	STD  Y+13,R30
	STD  Y+13+1,R30
;    3404 	d = 0;
	LDI  R30,0
	STD  Y+7,R30
	STD  Y+7+1,R30
;    3405 	valid_flag = 0;
	LDI  R20,LOW(0)
;    3406 	while (d<BPB_RootEntCnt)
_0x296:
	LDS  R30,_BPB_RootEntCnt
	LDS  R31,_BPB_RootEntCnt+1
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CP   R26,R30
	CPC  R27,R31
	BRLO PC+3
	JMP _0x298
;    3407 	{
;    3408     	_FF_read(_FF_DIR_ADDR+(m*0x200));
	LDD  R30,Y+13
	LDD  R31,Y+13+1
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
	CALL __FF_read
;    3409 		for (n=0; n<16; n++)
	LDI  R30,0
	STD  Y+11,R30
	STD  Y+11+1,R30
_0x29A:
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	SBIW R26,16
	BRLO PC+3
	JMP _0x29B
;    3410 		{
;    3411 			calc = (n*0x20);
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	LSL  R30
	ROL  R31
	CALL __LSLW4
	STD  Y+5,R30
	STD  Y+5+1,R31
;    3412 			if (_FF_buff[calc] == 0)	// no more entries in dir
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	LD   R30,Z
	CPI  R30,0
	BRNE _0x29C
;    3413 				return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x41C
;    3414 			for (c=0; c<11; c++)
_0x29C:
	LDI  R30,0
	STD  Y+9,R30
	STD  Y+9+1,R30
_0x29E:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	SBIW R26,11
	BRSH _0x29F
;    3415 			{	// check for name match
;    3416 				if (fpath[c] == _FF_buff[calc+c])
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
	BRNE _0x2A0
;    3417 					valid_flag = 1;
	LDI  R20,LOW(1)
;    3418 				else
	RJMP _0x2A1
_0x2A0:
;    3419 				{
;    3420 					valid_flag = 0;	
	LDI  R20,LOW(0)
;    3421 					c = 11;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	STD  Y+9,R30
	STD  Y+9+1,R31
;    3422 				}
_0x2A1:
;    3423 		    }   
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ADIW R30,1
	STD  Y+9,R30
	STD  Y+9+1,R31
	RJMP _0x29E
_0x29F:
;    3424 		    if (valid_flag)
	CPI  R20,0
	BREQ _0x2A2
;    3425 	  		{
;    3426 	  			if (_FF_buff[calc+0xB] != 0x10)	// not a directory
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	__ADDW1MN __FF_buff,11
	LD   R30,Z
	CPI  R30,LOW(0x10)
	BREQ _0x2A3
;    3427 	  				valid_flag = 0;
	LDI  R20,LOW(0)
;    3428 	  			else
	RJMP _0x2A4
_0x2A3:
;    3429 	  			{
;    3430 	  				c = ((int) _FF_buff[calc+0x1B] << 8) | ((int) _FF_buff[calc+0x1A]);
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	__ADDW1MN __FF_buff,27
	LD   R31,Z
	LDI  R30,LOW(0)
	MOVW R26,R30
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	__ADDW1MN __FF_buff,26
	LD   R30,Z
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STD  Y+9,R30
	STD  Y+9+1,R31
;    3431 					_FF_DIR_ADDR = clust_to_addr(c);
	ST   -Y,R31
	ST   -Y,R30
	CALL _clust_to_addr
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3432 					return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41C
;    3433 				}
_0x2A4:
;    3434 			}
;    3435 		  	d++;		  		
_0x2A2:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
;    3436 		}
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ADIW R30,1
	STD  Y+11,R30
	STD  Y+11+1,R31
	RJMP _0x29A
_0x29B:
;    3437 		m++;
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ADIW R30,1
	STD  Y+13,R30
	STD  Y+13+1,R31
;    3438 	}
	RJMP _0x296
_0x298:
;    3439 	return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x41C:
	CALL __LOADLOCR5
	ADIW R28,31
	RET
;    3440 }
;    3441 
;    3442 #ifndef _SECOND_FAT_ON_
;    3443 // Function that clears the secondary FAT table
;    3444 int clear_second_FAT(void)
;    3445 {
;    3446 	unsigned int c, d;
;    3447 	unsigned long n;
;    3448 	
;    3449 	for (n=1; n<BPB_FATSz16; n++)
;    3450 	{
;    3451 		if (_FF_read(_FF_FAT2_ADDR+(n*0x200))==0)
;    3452 			return (EOF);
;    3453 		for (c=0; c<BPB_BytsPerSec; c++)
;    3454 		{
;    3455 			if (_FF_buff[c] != 0)
;    3456 			{
;    3457 				for (d=0; d<BPB_BytsPerSec; d++)
;    3458 					_FF_buff[d] = 0;
;    3459 				if (_FF_write(_FF_FAT2_ADDR+(n*0x200))==0)
;    3460 					return (EOF);
;    3461 				break;
;    3462 			}
;    3463 		}
;    3464 	}
;    3465 	for (d=2; d<BPB_BytsPerSec; d++)
;    3466 		_FF_buff[d] = 0;
;    3467 	_FF_buff[0] = 0xF8;
;    3468 	_FF_buff[1] = 0xFF;
;    3469 	_FF_buff[2] = 0xFF;
;    3470 	if (BPB_FATType == 0x36)
;    3471 		_FF_buff[3] = 0xFF;
;    3472 	if (_FF_write(_FF_FAT2_ADDR)==0)
;    3473 		return (EOF);
;    3474 	
;    3475 	return (1);
;    3476 }
;    3477 #endif
;    3478  
;    3479 // Open a file, name stored in string fileopen
;    3480 FILE *fopenc(unsigned char flash *NAMEC, unsigned char MODEC)
;    3481 {
;    3482 	unsigned char c, temp_data[12];
;    3483 	FILE *tp;
;    3484 	
;    3485 	for (c=0; c<12; c++)
;	*NAMEC -> Y+16
;	MODEC -> Y+15
;	c -> R16
;	temp_data -> Y+3
;	*tp -> R17,R18
;    3486 		temp_data[c] = NAMEC[c];
;    3487 	
;    3488 	tp = fopen(temp_data, MODEC);
;    3489 	return(tp);
;    3490 }
;    3491 
;    3492 FILE *fopen(unsigned char *NAME, unsigned char MODE)
;    3493 {
_fopen:
;    3494 	unsigned char fpath[14];
;    3495 	unsigned int c, s, calc_temp;
;    3496 	unsigned char *sp, *qp;
;    3497 	unsigned long addr_temp, path_addr_temp;
;    3498 	FILE *rp;
;    3499 	
;    3500 	#ifdef _READ_ONLY_
;    3501 		if (MODE!=READ)
;    3502 			return (0);
;    3503 	#endif
;    3504 	
;    3505     addr_temp = 0;	// save local dir addr
	SBIW R28,28
	CALL __SAVELOCR6
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
	__CLRD1S 12
;    3506     
;    3507     if (_FF_checkdir(NAME, &addr_temp, fpath))
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
	BREQ _0x2A8
;    3508 	{
;    3509 		_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3510 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41B
;    3511 	}
;    3512 	if (fpath[0]==0)
_0x2A8:
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2A9
;    3513 	{
;    3514 		_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3515 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41B
;    3516 	}
;    3517     
;    3518 	path_addr_temp = _FF_DIR_ADDR;
_0x2A9:
	LDS  R30,__FF_DIR_ADDR
	LDS  R31,__FF_DIR_ADDR+1
	LDS  R22,__FF_DIR_ADDR+2
	LDS  R23,__FF_DIR_ADDR+3
	__PUTD1S 8
;    3519 	s = scan_directory(&path_addr_temp, fpath);
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
;    3520 	if ((path_addr_temp==0) || (s==0))
	__GETD2S 8
	CALL __CPD02
	BREQ _0x2AB
	CLR  R0
	CP   R0,R18
	CPC  R0,R19
	BRNE _0x2AA
_0x2AB:
;    3521 	{
;    3522 		_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3523 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41B
;    3524 	}
;    3525 
;    3526 	rp = 0;
_0x2AA:
	LDI  R30,0
	STD  Y+6,R30
	STD  Y+6+1,R30
;    3527 	rp = malloc(sizeof(FILE));
	LDI  R30,LOW(553)
	LDI  R31,HIGH(553)
	ST   -Y,R31
	ST   -Y,R30
	CALL _malloc
	STD  Y+6,R30
	STD  Y+6+1,R31
;    3528 	if (rp == 0)
	SBIW R30,0
	BRNE _0x2AD
;    3529 	{	// Could not allocate requested memory
;    3530 		_FF_error = ALLOC_ERR;
	LDI  R30,LOW(9)
	STS  __FF_error,R30
;    3531 		_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3532 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41B
;    3533 	}
;    3534 	rp->length = 0x46344456;
_0x2AD:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	__GETD1N 0x46344456
	CALL __PUTDP1
;    3535 	rp->clus_start = 0xe4;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,12
	LDI  R30,LOW(228)
	LDI  R31,HIGH(228)
	ST   X+,R30
	ST   X,R31
;    3536 	rp->position = 0x45664446;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-544)
	SBCI R27,HIGH(-544)
	__GETD1N 0x45664446
	CALL __PUTDP1
;    3537 
;    3538 	calc_temp = path_addr_temp % BPB_BytsPerSec;
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	__GETD2S 8
	CLR  R22
	CLR  R23
	CALL __MODD21U
	MOVW R20,R30
;    3539 	path_addr_temp -= calc_temp;
	MOVW R30,R20
	__GETD2S 8
	CLR  R22
	CLR  R23
	CALL __SUBD21
	__PUTD2S 8
;    3540 	if (_FF_read(path_addr_temp)==0)	
	__GETD1S 8
	CALL __PUTPARD1
	CALL __FF_read
	CPI  R30,0
	BRNE _0x2AE
;    3541 	{
;    3542 		_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3543 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41B
;    3544 	}
;    3545 	
;    3546 	// Get the filename into a form we can use to compare
;    3547 	qp = file_name_conversion(fpath);
_0x2AE:
	MOVW R30,R28
	ADIW R30,20
	ST   -Y,R31
	ST   -Y,R30
	CALL _file_name_conversion
	STD  Y+16,R30
	STD  Y+16+1,R31
;    3548 	if (qp==0)
	SBIW R30,0
	BRNE _0x2AF
;    3549 	{	// If File name entered is NOT valid, return 0
;    3550 		free(rp);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _free
;    3551 		_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3552 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41B
;    3553 	}
;    3554 	
;    3555 	sp = &_FF_buff[calc_temp];
_0x2AF:
	MOVW R30,R20
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	STD  Y+18,R30
	STD  Y+18+1,R31
;    3556 
;    3557 	if (s)
	MOV  R0,R18
	OR   R0,R19
	BRNE PC+3
	JMP _0x2B0
;    3558 	{	// File exists, open 
;    3559 		if (((MODE==WRITE) || (MODE==APPEND)) && (_FF_buff[calc_temp+0x0B]&0x01))
	LDD  R26,Y+34
	CPI  R26,LOW(0x2)
	BREQ _0x2B2
	CPI  R26,LOW(0x3)
	BRNE _0x2B4
_0x2B2:
	MOVW R30,R20
	__ADDW1MN __FF_buff,11
	LD   R30,Z
	ANDI R30,LOW(0x1)
	BRNE _0x2B5
_0x2B4:
	RJMP _0x2B1
_0x2B5:
;    3560 		{	// if writing to file verify it is not "READ ONLY"
;    3561 			_FF_error = MODE_ERR;
	LDI  R30,LOW(11)
	STS  __FF_error,R30
;    3562 			free(rp);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _free
;    3563 			_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3564 			return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41B
;    3565 		}
;    3566 		for (c=0; c<12; c++)	// Save Filename to Buffer
_0x2B1:
	__GETWRN 16,17,0
_0x2B7:
	__CPWRN 16,17,12
	BRSH _0x2B8
;    3567 			rp->name[c] = FILENAME[c];
	MOVW R30,R16
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDI  R26,LOW(_FILENAME)
	LDI  R27,HIGH(_FILENAME)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
;    3568 		// Save Starting Cluster
;    3569 		rp->clus_start = ((int) _FF_buff[calc_temp+0x1B] << 8) | (int) _FF_buff[calc_temp+0x1A];
	__ADDWRN 16,17,1
	RJMP _0x2B7
_0x2B8:
	MOVW R30,R20
	__ADDW1MN __FF_buff,27
	LD   R31,Z
	LDI  R30,LOW(0)
	MOVW R26,R30
	MOVW R30,R20
	__ADDW1MN __FF_buff,26
	LD   R30,Z
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	__PUTW1SNS 6,12
;    3570 		// Set Current Cluster
;    3571 		rp->clus_current = rp->clus_start;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,12
	CALL __GETW1P
	__PUTW1SNS 6,14
;    3572 		// Set Previous Cluster to 0 (indicating @start)
;    3573 		rp->clus_prev = 0;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,18
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
;    3574 		// Save file length
;    3575 		rp->length = 0;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	__GETD1N 0x0
	CALL __PUTDP1
;    3576 		sp = _FF_buff + calc_temp + 0x1F;
	MOVW R30,R20
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	ADIW R30,31
	STD  Y+18,R30
	STD  Y+18+1,R31
;    3577 		for (c=0; c<4; c++)
	__GETWRN 16,17,0
_0x2BA:
	__CPWRN 16,17,4
	BRSH _0x2BB
;    3578 		{
;    3579 			rp->length <<= 8;
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
;    3580 			rp->length |= *sp--;
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
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	SBIW R26,1
	STD  Y+18,R26
	STD  Y+18+1,R27
	ADIW R26,1
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
;    3581 		}
	__ADDWRN 16,17,1
	RJMP _0x2BA
_0x2BB:
;    3582 		// Set Current Position to 0
;    3583 		rp->position = 0;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-544)
	SBCI R27,HIGH(-544)
	__GETD1N 0x0
	CALL __PUTDP1
;    3584 		#ifndef _READ_ONLY_
;    3585 			if (MODE==WRITE)
	LDD  R26,Y+34
	CPI  R26,LOW(0x2)
	BREQ PC+3
	JMP _0x2BC
;    3586 			{	// Change file to blank
;    3587 				sp = _FF_buff + calc_temp + 0x1F;
	MOVW R30,R20
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	ADIW R30,31
	STD  Y+18,R30
	STD  Y+18+1,R31
;    3588 				for (c=0; c<6; c++)
	__GETWRN 16,17,0
_0x2BE:
	__CPWRN 16,17,6
	BRSH _0x2BF
;    3589 					*sp-- = 0;
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	SBIW R26,1
	STD  Y+18,R26
	STD  Y+18+1,R27
	ADIW R26,1
	LDI  R30,LOW(0)
	ST   X,R30
;    3590 				if (rp->length)
	__ADDWRN 16,17,1
	RJMP _0x2BE
_0x2BF:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	CALL __GETD1P
	CALL __CPD10
	BRNE PC+3
	JMP _0x2C0
;    3591 				{
;    3592 					if (_FF_write(_FF_DIR_ADDR + (0x200 * s))==0)
	MOVW R30,R18
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
	CALL __FF_write
	CPI  R30,0
	BRNE _0x2C1
;    3593 					{
;    3594 						free(rp);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _free
;    3595 						_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3596 						return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41B
;    3597 					}
;    3598 					rp->length = 0;
_0x2C1:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	__GETD1N 0x0
	CALL __PUTDP1
;    3599 					erase_clus_chain(rp->clus_start);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+12
	LDD  R27,Z+13
	ST   -Y,R27
	ST   -Y,R26
	CALL _erase_clus_chain
;    3600 					rp->clus_start = 0;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,12
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
;    3601 				}
;    3602 			}
_0x2C0:
;    3603 		#endif
;    3604 		// Set and save next cluster #
;    3605 		rp->clus_next = next_cluster(rp->clus_current, SINGLE);
_0x2BC:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+14
	LDD  R27,Z+15
	ST   -Y,R27
	ST   -Y,R26
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _next_cluster
	__PUTW1SNS 6,16
;    3606 		if ((rp->length==0) && (rp->clus_start==0))
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	CALL __GETD1P
	CALL __CPD10
	BRNE _0x2C3
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,12
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2C4
_0x2C3:
	RJMP _0x2C2
_0x2C4:
;    3607 		{	// Check for Blank File 
;    3608 			if (MODE==READ)
	LDD  R26,Y+34
	CPI  R26,LOW(0x1)
	BRNE _0x2C5
;    3609 			{	// IF trying to open a blank file to read, ERROR
;    3610 				_FF_error = MODE_ERR;
	LDI  R30,LOW(11)
	STS  __FF_error,R30
;    3611 				free(rp);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _free
;    3612 				_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3613 				return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41B
;    3614 			}
;    3615 			//Setup blank FILE characteristics
;    3616 			#ifndef _READ_ONLY_
;    3617 				MODE = WRITE; 
_0x2C5:
	LDI  R30,LOW(2)
	STD  Y+34,R30
;    3618 			#endif
;    3619 		}
;    3620 		// Save the file offset to read entry
;    3621 		rp->entry_sec_addr = path_addr_temp;
_0x2C2:
	__GETD1S 8
	__PUTD1SNS 6,22
;    3622 		rp->entry_offset =  calc_temp;
	MOVW R30,R20
	__PUTW1SNS 6,26
;    3623 		// Set sector offset to 1
;    3624 		rp->sec_offset = 1;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,20
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
;    3625 		if (MODE==APPEND)
	LDD  R26,Y+34
	CPI  R26,LOW(0x3)
	BRNE _0x2C6
;    3626 		{
;    3627 			if (fseek(rp, 0,SEEK_END)==EOF)
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
	BRNE _0x2C7
;    3628 			{
;    3629 				free(rp);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _free
;    3630 				_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3631 				return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41B
;    3632 			}
;    3633 		}
_0x2C7:
;    3634 		else
	RJMP _0x2C8
_0x2C6:
;    3635 		{	// Set pointer to the begining of the file
;    3636 			_FF_read(clust_to_addr(rp->clus_current));
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+14
	LDD  R27,Z+15
	ST   -Y,R27
	ST   -Y,R26
	CALL _clust_to_addr
	CALL __PUTPARD1
	CALL __FF_read
;    3637 			for (c=0; c<BPB_BytsPerSec; c++)
	__GETWRN 16,17,0
_0x2CA:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x2CB
;    3638 				rp->buff[c] = _FF_buff[c];
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,28
	ADD  R30,R16
	ADC  R31,R17
	MOVW R0,R30
	LDI  R26,LOW(__FF_buff)
	LDI  R27,HIGH(__FF_buff)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
;    3639 			rp->pntr = &rp->buff[0];
	__ADDWRN 16,17,1
	RJMP _0x2CA
_0x2CB:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,28
	__PUTW1SN 6,551
;    3640 		}
_0x2C8:
;    3641 		#ifndef _READ_ONLY_
;    3642 			#ifndef _SECOND_FAT_ON_
;    3643 				if ((MODE==WRITE) || (MODE==APPEND))
;    3644 					clear_second_FAT();
;    3645 			#endif
;    3646     	#endif
;    3647 		rp->mode = MODE;
	LDD  R30,Y+34
	__PUTB1SN 6,548
;    3648 		_FF_error = NO_ERR;
	LDI  R30,LOW(0)
	STS  __FF_error,R30
;    3649 		_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3650 		return(rp);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RJMP _0x41B
;    3651 	}
;    3652 	else
_0x2B0:
;    3653 	{                          		
;    3654 		_FF_error = FILE_ERR;
	LDI  R30,LOW(2)
	STS  __FF_error,R30
;    3655 		free(rp);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _free
;    3656 		_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3657 		return(0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41B
;    3658 	}
;    3659 }
;    3660 
;    3661 #ifndef _READ_ONLY_
;    3662 // Create a file
;    3663 FILE *fcreatec(unsigned char flash *NAMEC, unsigned char MODE)
;    3664 {
;    3665 	unsigned char sd_temp[12];
;    3666 	int c;
;    3667 
;    3668 	for (c=0; c<12; c++)
;	*NAMEC -> Y+15
;	MODE -> Y+14
;	sd_temp -> Y+2
;	c -> R16,R17
;    3669 		sd_temp[c] = NAMEC[c];
;    3670 	
;    3671 	return (fcreate(sd_temp, MODE));
;    3672 }
;    3673 
;    3674 FILE *fcreate(unsigned char *NAME, unsigned char MODE)
;    3675 {
_fcreate:
;    3676 	unsigned char fpath[14];
;    3677 	unsigned int c, s, calc_temp;
;    3678 	unsigned char *sp, *qp;
;    3679 	unsigned long addr_temp, path_addr_temp;
;    3680 	FILE *temp_file_pntr;
;    3681 
;    3682     addr_temp = 0;	// save local dir addr
	SBIW R28,28
	CALL __SAVELOCR6
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
	__CLRD1S 12
;    3683     
;    3684     if (_FF_checkdir(NAME, &addr_temp, fpath))
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
	BREQ _0x2D0
;    3685 	{
;    3686 		_FF_error = PATH_ERR;
	LDI  R30,LOW(14)
	STS  __FF_error,R30
;    3687 		_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3688 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41B
;    3689 	}
;    3690 	if (fpath[0]==0)
_0x2D0:
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2D1
;    3691 	{
;    3692 		_FF_error = NAME_ERR; 
	LDI  R30,LOW(5)
	STS  __FF_error,R30
;    3693 		_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3694 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41B
;    3695 	}
;    3696     
;    3697 	path_addr_temp = _FF_DIR_ADDR;
_0x2D1:
	LDS  R30,__FF_DIR_ADDR
	LDS  R31,__FF_DIR_ADDR+1
	LDS  R22,__FF_DIR_ADDR+2
	LDS  R23,__FF_DIR_ADDR+3
	__PUTD1S 8
;    3698 	s = scan_directory(&path_addr_temp, fpath);
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
;    3699 	if (path_addr_temp==0)
	__GETD1S 8
	CALL __CPD10
	BRNE _0x2D2
;    3700 	{
;    3701 		_FF_error = NO_ENTRY_AVAL;
	LDI  R30,LOW(15)
	STS  __FF_error,R30
;    3702 		_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3703 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41B
;    3704 	}
;    3705 
;    3706 	calc_temp = path_addr_temp % BPB_BytsPerSec;
_0x2D2:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	__GETD2S 8
	CLR  R22
	CLR  R23
	CALL __MODD21U
	MOVW R20,R30
;    3707 	path_addr_temp -= calc_temp;
	MOVW R30,R20
	__GETD2S 8
	CLR  R22
	CLR  R23
	CALL __SUBD21
	__PUTD2S 8
;    3708 	if (_FF_read(path_addr_temp)==0)	
	__GETD1S 8
	CALL __PUTPARD1
	CALL __FF_read
	CPI  R30,0
	BRNE _0x2D3
;    3709 	{
;    3710 		_FF_error = READ_ERR;
	LDI  R30,LOW(4)
	STS  __FF_error,R30
;    3711 		_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3712 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41B
;    3713 	}
;    3714 
;    3715 	// Get the filename into a form we can use to compare
;    3716 	qp = file_name_conversion(fpath);
_0x2D3:
	MOVW R30,R28
	ADIW R30,20
	ST   -Y,R31
	ST   -Y,R30
	CALL _file_name_conversion
	STD  Y+16,R30
	STD  Y+16+1,R31
;    3717 	if (qp==0)
	SBIW R30,0
	BRNE _0x2D4
;    3718 	{
;    3719 		_FF_error = NAME_ERR; 
	LDI  R30,LOW(5)
	STS  __FF_error,R30
;    3720 		_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3721 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41B
;    3722 	}
;    3723 	sp = &_FF_buff[calc_temp];
_0x2D4:
	MOVW R30,R20
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	STD  Y+18,R30
	STD  Y+18+1,R31
;    3724 	
;    3725 	if (s)
	MOV  R0,R18
	OR   R0,R19
	BREQ _0x2D5
;    3726 	{
;    3727 		if ((_FF_buff[calc_temp+0x0B]&0x1)==1)	// is file read only
	MOVW R30,R20
	__ADDW1MN __FF_buff,11
	LD   R30,Z
	ANDI R30,LOW(0x1)
	CPI  R30,LOW(0x1)
	BRNE _0x2D6
;    3728 		{
;    3729 			_FF_error = READONLY_ERR;
	LDI  R30,LOW(6)
	STS  __FF_error,R30
;    3730 			_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3731 			return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41B
;    3732 		}
;    3733 	}
_0x2D6:
;    3734 	else
	RJMP _0x2D7
_0x2D5:
;    3735 	{
;    3736 		for (c=0; c<11; c++)	// Write Filename
	__GETWRN 16,17,0
_0x2D9:
	__CPWRN 16,17,11
	BRSH _0x2DA
;    3737 			*sp++ = *qp++;
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	MOVW R0,R30
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R30,X+
	STD  Y+16,R26
	STD  Y+16+1,R27
	MOVW R26,R0
	ST   X,R30
;    3738 		*sp = 0x20;				// Attribute bit auto set to "ARCHIVE"
	__ADDWRN 16,17,1
	RJMP _0x2D9
_0x2DA:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDI  R30,LOW(32)
	ST   X,R30
;    3739 		sp++;		
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
;    3740 		*sp++ = 0;				// Reserved for WinNT
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,1
	STD  Y+18,R26
	STD  Y+18+1,R27
	SBIW R26,1
	LDI  R30,LOW(0)
	ST   X,R30
;    3741 		*sp++ = 0;				// Mili-second stamp for create
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,1
	STD  Y+18,R26
	STD  Y+18+1,R27
	SBIW R26,1
	ST   X,R30
;    3742 	
;    3743 		#ifdef _RTC_ON_
;    3744 			rtc_get_timeNdate(&rtc_hour, &rtc_min, &rtc_sec, &rtc_date, &rtc_month, (int *)&rtc_year);	    			
;    3745     	    calc_temp = ((int)rtc_sec&0x1F) | (((int)rtc_min&0x3F)<<5) | (((int)rtc_hour&0x1F)<<11);
;    3746 			*sp++ = calc_temp&0x00FF;	// File create Time 
;    3747 			*sp++ = (calc_temp&0xFF00) >> 8;
;    3748 			calc_temp = ((int)rtc_date&0x1F) | (((int)rtc_month&0x0F)<<5) | (((rtc_year-1980)&0x7F)<<9);
;    3749 			*sp++ = calc_temp&0x00FF;	// File create Date
;    3750 			*sp++ = (calc_temp&0xFF00) >> 8;
;    3751 		#else
;    3752 			for (c=0; c<4; c++)
	__GETWRN 16,17,0
_0x2DC:
	__CPWRN 16,17,4
	BRSH _0x2DD
;    3753 				*sp++ = 0;
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,1
	STD  Y+18,R26
	STD  Y+18+1,R27
	SBIW R26,1
	LDI  R30,LOW(0)
	ST   X,R30
;    3754 		#endif
;    3755 
;    3756 		*sp++ = 0;				// File access date (2 bytes)
	__ADDWRN 16,17,1
	RJMP _0x2DC
_0x2DD:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,1
	STD  Y+18,R26
	STD  Y+18+1,R27
	SBIW R26,1
	LDI  R30,LOW(0)
	ST   X,R30
;    3757 		*sp++ = 0;
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,1
	STD  Y+18,R26
	STD  Y+18+1,R27
	SBIW R26,1
	ST   X,R30
;    3758 		*sp++ = 0;				// 0 for FAT12/16 (2 bytes)
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,1
	STD  Y+18,R26
	STD  Y+18+1,R27
	SBIW R26,1
	ST   X,R30
;    3759 		*sp++ = 0;
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,1
	STD  Y+18,R26
	STD  Y+18+1,R27
	SBIW R26,1
	ST   X,R30
;    3760 		for (c=0; c<4; c++)		// Modify time/date
	__GETWRN 16,17,0
_0x2DF:
	__CPWRN 16,17,4
	BRSH _0x2E0
;    3761 			*sp++ = 0;
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,1
	STD  Y+18,R26
	STD  Y+18+1,R27
	SBIW R26,1
	LDI  R30,LOW(0)
	ST   X,R30
;    3762 		*sp++ = 0;				// Starting cluster (2 bytes)
	__ADDWRN 16,17,1
	RJMP _0x2DF
_0x2E0:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,1
	STD  Y+18,R26
	STD  Y+18+1,R27
	SBIW R26,1
	LDI  R30,LOW(0)
	ST   X,R30
;    3763 		*sp++ = 0;
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,1
	STD  Y+18,R26
	STD  Y+18+1,R27
	SBIW R26,1
	ST   X,R30
;    3764 		for (c=0; c<4; c++)
	__GETWRN 16,17,0
_0x2E2:
	__CPWRN 16,17,4
	BRSH _0x2E3
;    3765 			*sp++ = 0;			// File length (0 for new)
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,1
	STD  Y+18,R26
	STD  Y+18+1,R27
	SBIW R26,1
	LDI  R30,LOW(0)
	ST   X,R30
;    3766 	
;    3767 		if (_FF_write(path_addr_temp)==0)
	__ADDWRN 16,17,1
	RJMP _0x2E2
_0x2E3:
	__GETD1S 8
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	BRNE _0x2E4
;    3768 		{
;    3769 			_FF_error = WRITE_ERR;
	LDI  R30,LOW(3)
	STS  __FF_error,R30
;    3770 			_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3771 			return (0);				
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41B
;    3772 		}
;    3773 	}
_0x2E4:
_0x2D7:
;    3774 	_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3775 	temp_file_pntr = fopen(NAME, WRITE);
	LDD  R30,Y+35
	LDD  R31,Y+35+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _fopen
	STD  Y+6,R30
	STD  Y+6+1,R31
;    3776 	if (temp_file_pntr == 0)	// Will file open
	SBIW R30,0
	BRNE _0x2E5
;    3777 		return (0);				
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41B
;    3778 	if (MODE)
_0x2E5:
	LDD  R30,Y+34
	CPI  R30,0
	BREQ _0x2E6
;    3779 	{
;    3780 		if (_FF_read(addr_temp)==0)
	__GETD1S 12
	CALL __PUTPARD1
	CALL __FF_read
	CPI  R30,0
	BRNE _0x2E7
;    3781 		{
;    3782 			_FF_error = READ_ERR;
	LDI  R30,LOW(4)
	STS  __FF_error,R30
;    3783 			return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41B
;    3784 		}
;    3785 		_FF_buff[calc_temp+12] |= MODE;		
_0x2E7:
	MOVW R30,R20
	__ADDW1MN __FF_buff,12
	MOVW R0,R30
	LD   R30,Z
	LDD  R26,Y+34
	OR   R30,R26
	MOVW R26,R0
	ST   X,R30
;    3786 		if (_FF_write(addr_temp)==0)
	__GETD1S 12
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	BRNE _0x2E8
;    3787 		{
;    3788 			_FF_error = WRITE_ERR;
	LDI  R30,LOW(3)
	STS  __FF_error,R30
;    3789 			return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41B
;    3790 		}
;    3791 	}
_0x2E8:
;    3792 	_FF_error = NO_ERR;
_0x2E6:
	LDI  R30,LOW(0)
	STS  __FF_error,R30
;    3793 	return (temp_file_pntr);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
_0x41B:
	CALL __LOADLOCR6
	ADIW R28,37
	RET
;    3794 }
;    3795 #endif
;    3796 
;    3797 #ifndef _READ_ONLY_
;    3798 // Open a file, name stored in string fileopen
;    3799 int removec(unsigned char flash *NAMEC)
;    3800 {
;    3801 	int c;
;    3802 	unsigned char sd_temp[12];
;    3803 	
;    3804 	for (c=0; c<12; c++)
;	*NAMEC -> Y+14
;	c -> R16,R17
;	sd_temp -> Y+2
;    3805 		sd_temp[c] = NAMEC[c];
;    3806 	
;    3807 	c = remove(sd_temp);
;    3808 	return (c);
;    3809 }
;    3810 
;    3811 // Remove a file from the root directory
;    3812 int remove(unsigned char *NAME)
;    3813 {
;    3814 	unsigned char fpath[14];
;    3815 	unsigned int s, calc_temp;
;    3816 	unsigned long addr_temp, path_addr_temp;
;    3817 	
;    3818 	#ifndef _SECOND_FAT_ON_
;    3819 		clear_second_FAT();
;    3820     #endif
;    3821     
;    3822     addr_temp = 0;	// save local dir addr
;	*NAME -> Y+26
;	fpath -> Y+12
;	s -> R16,R17
;	calc_temp -> R18,R19
;	addr_temp -> Y+8
;	path_addr_temp -> Y+4
;    3823     
;    3824     if (_FF_checkdir(NAME, &addr_temp, fpath))
;    3825 	{
;    3826 		_FF_error = PATH_ERR;
;    3827 		_FF_DIR_ADDR = addr_temp;
;    3828 		return (EOF);
;    3829 	}
;    3830 	if (fpath[0]==0)
;    3831 	{
;    3832 		_FF_error = NAME_ERR; 
;    3833 		_FF_DIR_ADDR = addr_temp;
;    3834 		return (EOF);
;    3835 	}
;    3836     
;    3837 	path_addr_temp = _FF_DIR_ADDR;
;    3838 	s = scan_directory(&path_addr_temp, fpath);
;    3839 	if ((path_addr_temp==0) || (s==0))
;    3840 	{
;    3841 		_FF_error = NO_ENTRY_AVAL;
;    3842 		_FF_DIR_ADDR = addr_temp;
;    3843 		return (EOF);
;    3844 	}
;    3845 	_FF_DIR_ADDR = addr_temp;		// Reset current dir
;    3846 
;    3847 	calc_temp = path_addr_temp % BPB_BytsPerSec;
;    3848 	path_addr_temp -= calc_temp;
;    3849 	if (_FF_read(path_addr_temp)==0)	
;    3850 	{
;    3851 		_FF_error = READ_ERR;
;    3852 		return (EOF);
;    3853 	}
;    3854 	
;    3855 	// Erase entry (put 0xE5 into start of the filename
;    3856 	_FF_buff[calc_temp] = 0xE5;
;    3857 	if (_FF_write(path_addr_temp)==0)
;    3858 	{
;    3859 		_FF_error = WRITE_ERR;
;    3860 		return (EOF);
;    3861 	}
;    3862 	// Save Starting Cluster
;    3863 	calc_temp = ((int) _FF_buff[calc_temp+0x1B] << 8) | (int) _FF_buff[calc_temp+0x1A];
;    3864 	// Destroy cluster chain
;    3865 	if (calc_temp)
;    3866 		if (erase_clus_chain(calc_temp) == 0)
;    3867 			return (EOF);
;    3868 			
;    3869 	return (1);
;    3870 }
;    3871 #endif
;    3872 
;    3873 #ifndef _READ_ONLY_
;    3874 // Rename a file in the Root Directory
;    3875 int rename(unsigned char *NAME_OLD, unsigned char *NAME_NEW)
;    3876 {
;    3877 	unsigned char c;
;    3878 	unsigned int calc_temp;
;    3879 	unsigned long addr_temp, path_addr_temp;
;    3880 	unsigned char *sp, *qp;
;    3881 	unsigned char fpath[14];
;    3882 
;    3883 	// Get the filename into a form we can use to compare
;    3884 	qp = file_name_conversion(NAME_NEW);
;	*NAME_OLD -> Y+31
;	*NAME_NEW -> Y+29
;	c -> R16
;	calc_temp -> R17,R18
;	addr_temp -> Y+25
;	path_addr_temp -> Y+21
;	*sp -> R19,R20
;	*qp -> Y+19
;	fpath -> Y+5
;    3885 	if (qp==0)
;    3886 	{
;    3887 		_FF_error = NAME_ERR;
;    3888 		return (EOF);
;    3889 	}
;    3890 	
;    3891     addr_temp = 0;	// save local dir addr
;    3892     
;    3893     if (_FF_checkdir(NAME_OLD, &addr_temp, fpath))
;    3894 	{
;    3895 		_FF_error = PATH_ERR;
;    3896 		_FF_DIR_ADDR = addr_temp;
;    3897 		return (EOF);
;    3898 	}
;    3899 	if (fpath[0]==0)
;    3900 	{
;    3901 		_FF_error = NAME_ERR; 
;    3902 		_FF_DIR_ADDR = addr_temp;
;    3903 		return (EOF);
;    3904 	}
;    3905 
;    3906 	path_addr_temp = _FF_DIR_ADDR;
;    3907 	calc_temp = scan_directory(&path_addr_temp, NAME_NEW);
;    3908 	if (calc_temp)
;    3909 	{	// does new name alread exist?
;    3910 		_FF_DIR_ADDR = addr_temp;
;    3911 		_FF_error = EXIST_ERR;
;    3912 		return (EOF);
;    3913 	}
;    3914 
;    3915 	path_addr_temp = _FF_DIR_ADDR;
;    3916 	calc_temp = scan_directory(&path_addr_temp, fpath);
;    3917 	if ((path_addr_temp==0) || (calc_temp==0))
;    3918 	{
;    3919 		_FF_DIR_ADDR = addr_temp;
;    3920 		_FF_error = EXIST_ERR;
;    3921 		return (EOF);
;    3922 	}
;    3923 
;    3924 
;    3925 	_FF_DIR_ADDR = addr_temp;		// Reset current dir
;    3926 
;    3927 	calc_temp = path_addr_temp % BPB_BytsPerSec;
;    3928 	path_addr_temp -= calc_temp;
;    3929 	if (_FF_read(path_addr_temp)==0)	
;    3930 	{
;    3931 		_FF_error = READ_ERR;
;    3932 		return (EOF);
;    3933 	}
;    3934 	
;    3935 	// Rename entry
;    3936 	sp = &_FF_buff[calc_temp];
;    3937 	for (c=0; c<11; c++)
;    3938 		*sp++ = *qp++;
;    3939 	if (_FF_write(path_addr_temp)==0)
;    3940 		return (EOF);
;    3941 
;    3942 	return(0);
;    3943 }
;    3944 #endif
;    3945 
;    3946 #ifndef _READ_ONLY_
;    3947 // Save Contents of file, w/o closing
;    3948 int fflush(FILE *rp)	
;    3949 {
_fflush:
;    3950 	unsigned int  n;
;    3951 	unsigned long addr_temp;
;    3952 	
;    3953 	if ((rp==NULL) || (rp->mode==READ))
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
;	*rp -> Y+6
;	n -> R16,R17
;	addr_temp -> Y+2
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __CPW02
	BREQ _0x302
	SUBI R26,LOW(-548)
	SBCI R27,HIGH(-548)
	LD   R26,X
	CPI  R26,LOW(0x1)
	BRNE _0x301
_0x302:
;    3954 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x41A
;    3955 	
;    3956 	if ((rp->mode==WRITE) || (rp->mode==APPEND))
_0x301:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-548)
	SBCI R27,HIGH(-548)
	LD   R26,X
	CPI  R26,LOW(0x2)
	BREQ _0x305
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-548)
	SBCI R27,HIGH(-548)
	LD   R26,X
	CPI  R26,LOW(0x3)
	BREQ _0x305
	RJMP _0x304
_0x305:
;    3957 	{
;    3958 		addr_temp = (clust_to_addr(rp->clus_current) + ((rp->sec_offset-1)*BPB_BytsPerSec));
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+14
	LDD  R27,Z+15
	ST   -Y,R27
	ST   -Y,R26
	CALL _clust_to_addr
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,20
	CALL __GETW1P
	SBIW R30,1
	LDS  R26,_BPB_BytsPerSec
	LDS  R27,_BPB_BytsPerSec+1
	CALL __MULW12U
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1S 2
;    3959 		for (n=0; n<BPB_BytsPerSec; n++)	// Save file buffer to SD buffer
	__GETWRN 16,17,0
_0x308:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x309
;    3960 			_FF_buff[n] = rp->buff[n];
	MOVW R26,R16
	SUBI R26,LOW(-__FF_buff)
	SBCI R27,HIGH(-__FF_buff)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,28
	ADD  R30,R16
	ADC  R31,R17
	LD   R30,Z
	ST   X,R30
;    3961 		if (_FF_write(addr_temp)==0)	// Write SD buffer to disk
	__ADDWRN 16,17,1
	RJMP _0x308
_0x309:
	__GETD1S 2
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	BRNE _0x30A
;    3962 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x41A
;    3963 		if (append_toc(rp)==0)	// Update Entry or Error
_0x30A:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _append_toc
	CPI  R30,0
	BRNE _0x30B
;    3964 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x41A
;    3965 	}
_0x30B:
;    3966 	
;    3967 	return (0);
_0x304:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x41A:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	RET
;    3968 }
;    3969 #endif		
;    3970 
;    3971 
;    3972 // Close an open file
;    3973 int fclose(FILE *rp)	
;    3974 {
_fclose:
;    3975 	#ifndef _READ_ONLY_
;    3976 	if (rp->mode!=READ)
	LD   R26,Y
	LDD  R27,Y+1
	SUBI R26,LOW(-548)
	SBCI R27,HIGH(-548)
	LD   R26,X
	CPI  R26,LOW(0x1)
	BREQ _0x30C
;    3977 		if (fflush(rp)==EOF)
	LD   R30,Y
	LDD  R31,Y+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _fflush
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x30D
;    3978 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x419
;    3979 	#endif	
;    3980 	// Clear File Structure
;    3981 	free(rp);
_0x30D:
_0x30C:
	LD   R30,Y
	LDD  R31,Y+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _free
;    3982 	rp = 0;
	LDI  R30,0
	STD  Y+0,R30
	STD  Y+0+1,R30
;    3983 	return(0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x419:
	ADIW R28,2
	RET
;    3984 }
;    3985 
;    3986 int ffreemem(FILE *rp)	
;    3987 {
;    3988 	// Clear File Structure
;    3989 	if (rp==0)
;    3990 		return (EOF);
;    3991 	free(rp);
;    3992 	return(0);
;    3993 }
;    3994 
;    3995 int fget_file_infoc(unsigned char flash *NAMEC, unsigned long *F_SIZE, unsigned char *F_CREATE,
;    3996 				unsigned char *F_MODIFY, unsigned char *F_ATTRIBUTE, unsigned int *F_CLUS_START)
;    3997 {
;    3998 	int c;
;    3999 	unsigned char sd_temp[12];
;    4000 	
;    4001 	for (c=0; c<12; c++)
;	*NAMEC -> Y+24
;	*F_SIZE -> Y+22
;	*F_CREATE -> Y+20
;	*F_MODIFY -> Y+18
;	*F_ATTRIBUTE -> Y+16
;	*F_CLUS_START -> Y+14
;	c -> R16,R17
;	sd_temp -> Y+2
;    4002 		sd_temp[c] = NAMEC[c];
;    4003 	
;    4004 	c = fget_file_info(sd_temp, F_SIZE, F_CREATE, F_MODIFY, F_ATTRIBUTE, F_CLUS_START);
;    4005 	return (c);
;    4006 }
;    4007 
;    4008 int fget_file_info(unsigned char *NAME, unsigned long *F_SIZE, unsigned char *F_CREATE,
;    4009 				unsigned char *F_MODIFY, unsigned char *F_ATTRIBUTE, unsigned int *F_CLUS_START)
;    4010 {
;    4011 	unsigned char n;
;    4012 	unsigned int s, calc_temp;
;    4013 	unsigned long addr_temp, file_calc_temp;
;    4014 	unsigned char *sp, *qp;
;    4015 	
;    4016 	// Get the filename into a form we can use to compare
;    4017 	qp = file_name_conversion(NAME);
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
;    4018 	if (qp==0)
;    4019 	{
;    4020 		_FF_error = NAME_ERR;
;    4021 		return (EOF);
;    4022 	}
;    4023 	
;    4024 	for (s=0; s<BPB_BytsPerSec; s++)
;    4025 	{	// Scan through directory entries to find file
;    4026 		addr_temp = _FF_DIR_ADDR + (0x200 * s);
;    4027 		if (_FF_read(addr_temp)==0)
;    4028 			return (EOF);
;    4029 		for (n=0; n<16; n++)
;    4030 		{
;    4031 			calc_temp = (int) n * 0x20;
;    4032 			qp = &FILENAME[0];
;    4033 			sp = &_FF_buff[calc_temp];
;    4034 			if (*sp == 0)
;    4035 				return (EOF);
;    4036 			if (strncmp(qp, sp, 11)==0)		// Does this entry == Filename
;    4037 			{
;    4038 				*F_ATTRIBUTE = _FF_buff[calc_temp+11];	// Save ATTRIBUTE Byte to location
;    4039 				*F_SIZE = ((long) _FF_buff[calc_temp+31] << 24) | ((long) _FF_buff[calc_temp+30] << 16)
;    4040 							| ((long) _FF_buff[calc_temp+29] << 8) | ((long) _FF_buff[calc_temp+28]);
;    4041 							// Save SIZE of file to location
;    4042                 *F_CLUS_START = ((unsigned int) _FF_buff[calc_temp+27] << 8) | ((unsigned int) _FF_buff[calc_temp+26]);
;    4043 				file_calc_temp = ((unsigned int) _FF_buff[calc_temp+17] << 8) | ((unsigned int) _FF_buff[calc_temp+16]);
;    4044 				qp = F_CREATE;
;    4045 				*qp++ = (((file_calc_temp >> 5) & 0x0F) / 10) + '0';
;    4046 				*qp++ = (((file_calc_temp >> 5) & 0x0F) % 10) + '0';
;    4047 				*qp++ = '/';
;    4048 				*qp++ = ((file_calc_temp & 0x1F) / 10) + '0';
;    4049 				*qp++ = ((file_calc_temp & 0x1F) % 10) + '0';
;    4050 				*qp++ = '/';
;    4051 				file_calc_temp = ((file_calc_temp >> 9) & 0x7F) + 1980;
;    4052 				*qp++ = (file_calc_temp / 1000) + '0';
;    4053 				file_calc_temp %= 1000;
;    4054 				*qp++ = (file_calc_temp / 100) + '0';
;    4055 				file_calc_temp %= 100;
;    4056 				*qp++ = (file_calc_temp / 10) + '0';
;    4057 				*qp++ = (file_calc_temp % 10) + '0';
;    4058 				*qp++ = ' ';
;    4059 				*qp++ = ' ';
;    4060 				file_calc_temp = ((unsigned int) _FF_buff[calc_temp+15] << 8) | ((unsigned int) _FF_buff[calc_temp+14]);
;    4061 				*qp++ = (((file_calc_temp >> 11) & 0x1F) / 10) + '0';
;    4062 				*qp++ = (((file_calc_temp >> 11) & 0x1F) % 10) + '0';
;    4063 				*qp++ = ':';
;    4064 				*qp++ = (((file_calc_temp >> 5) & 0x3F) / 10) + '0';
;    4065 				*qp++ = (((file_calc_temp >> 5) & 0x3F) % 10) + '0';
;    4066 				*qp++ = ':';
;    4067 				*qp++ = (((file_calc_temp & 0x1F) * 2) / 10) + '0';
;    4068 				*qp++ = (((file_calc_temp & 0x1F) * 2) % 10) + '0';
;    4069 				*qp = 0;
;    4070 				
;    4071 				file_calc_temp = ((unsigned int) _FF_buff[calc_temp+25] << 8) | ((unsigned int) _FF_buff[calc_temp+24]);
;    4072 				qp = F_MODIFY;
;    4073 				*qp++ = (((file_calc_temp >> 5) & 0x0F) / 10) + '0';
;    4074 				*qp++ = (((file_calc_temp >> 5) & 0x0F) % 10) + '0';
;    4075 				*qp++ = '/';
;    4076 				*qp++ = ((file_calc_temp & 0x1F) / 10) + '0';
;    4077 				*qp++ = ((file_calc_temp & 0x1F) % 10) + '0';
;    4078 				*qp++ = '/';
;    4079 				file_calc_temp = ((file_calc_temp >> 9) & 0x7F) + 1980;
;    4080 				*qp++ = (file_calc_temp / 1000) + '0';
;    4081 				file_calc_temp %= 1000;
;    4082 				*qp++ = (file_calc_temp / 100) + '0';
;    4083 				file_calc_temp %= 100;
;    4084 				*qp++ = (file_calc_temp / 10) + '0';
;    4085 				*qp++ = (file_calc_temp % 10) + '0';
;    4086 				*qp++ = ' ';
;    4087 				*qp++ = ' ';
;    4088 				file_calc_temp = ((unsigned int) _FF_buff[calc_temp+23] << 8) | ((unsigned int) _FF_buff[calc_temp+22]);
;    4089 				*qp++ = (((file_calc_temp >> 11) & 0x1F) / 10) + '0';
;    4090 				*qp++ = (((file_calc_temp >> 11) & 0x1F) % 10) + '0';
;    4091 				*qp++ = ':';
;    4092 				*qp++ = (((file_calc_temp >> 5) & 0x3F) / 10) + '0';
;    4093 				*qp++ = (((file_calc_temp >> 5) & 0x3F) % 10) + '0';
;    4094 				*qp++ = ':';
;    4095 				*qp++ = (((file_calc_temp & 0x1F) * 2) / 10) + '0';
;    4096 				*qp++ = (((file_calc_temp & 0x1F) * 2) % 10) + '0';
;    4097 				*qp = 0;
;    4098 				
;    4099 				return (0);
;    4100 			}
;    4101 		}                          		
;    4102 	}
;    4103 	_FF_error = FILE_ERR;
;    4104 	return(EOF);
;    4105 }
;    4106 
;    4107 // Get File data and increment file pointer
;    4108 int fgetc(FILE *rp)
;    4109 {
;    4110 	unsigned char get_data;
;    4111 	unsigned int n;
;    4112 	unsigned long addr_temp;
;    4113 	
;    4114 	if (rp==NULL)
;	*rp -> Y+7
;	get_data -> R16
;	n -> R17,R18
;	addr_temp -> Y+3
;    4115 		return (EOF);
;    4116 
;    4117 	if (rp->position == rp->length)
;    4118 	{
;    4119 		rp->error = POS_ERR;
;    4120 		return (EOF);
;    4121 	}
;    4122 	
;    4123 	get_data = *rp->pntr;
;    4124 	
;    4125 	if ((rp->pntr)==(&rp->buff[BPB_BytsPerSec-1]))
;    4126 	{	// Check to see if pointer is at the end of a sector
;    4127 		#ifndef _READ_ONLY_
;    4128 		if ((rp->mode==WRITE) || (rp->mode==APPEND))
;    4129 		{	// if in write or append mode, update the current sector before loading next
;    4130 			for (n=0; n<BPB_BytsPerSec; n++)
;    4131 				_FF_buff[n] = rp->buff[n];
;    4132 			addr_temp = clust_to_addr(rp->clus_current) + (((rp->sec_offset)-1)*BPB_BytsPerSec);
;    4133 			if (_FF_write(addr_temp)==0)
;    4134 				return (EOF);
;    4135 		}
;    4136 		#endif
;    4137 		if (rp->sec_offset < BPB_SecPerClus)
;    4138 		{	// Goto next sector if not at the end of a cluster
;    4139 			addr_temp = clust_to_addr(rp->clus_current) + (rp->sec_offset*BPB_BytsPerSec);
;    4140 			rp->sec_offset++;
;    4141 		}
;    4142 		else
;    4143 		{	// End of Cluster, find next
;    4144 			if (rp->clus_next>=0xFFF8)	// No next cluster, EOF marker
;    4145 			{
;    4146 				rp->EOF_flag = 1;	// Set flag so Putchar knows to get new cluster
;    4147 				rp->position++;		// Only time doing this, position + 1 should equal length
;    4148 				return(get_data);
;    4149 			}
;    4150 			addr_temp = clust_to_addr(rp->clus_next);
;    4151 			rp->sec_offset = 1;
;    4152 			rp->clus_prev = rp->clus_current;
;    4153 			rp->clus_current = rp->clus_next;
;    4154 			rp->clus_next = next_cluster(rp->clus_current, SINGLE);
;    4155 		}
;    4156 		if (_FF_read(addr_temp)==0)
;    4157 			return (EOF);
;    4158 		for (n=0; n<BPB_BytsPerSec; n++)
;    4159 			rp->buff[n] = _FF_buff[n];
;    4160 		rp->pntr = &rp->buff[0];
;    4161 	}
;    4162 	else
;    4163 		rp->pntr++;
;    4164 	
;    4165 	rp->position++;	
;    4166 	return(get_data);		
;    4167 }
;    4168 
;    4169 char *fgets(char *buffer, int n, FILE *rp)
;    4170 {
;    4171 	int c, temp_data;
;    4172 	
;    4173 	for (c=0; c<n; c++)
;	*buffer -> Y+8
;	n -> Y+6
;	*rp -> Y+4
;	c -> R16,R17
;	temp_data -> R18,R19
;    4174 	{
;    4175 		temp_data = fgetc(rp);
;    4176 		*buffer = temp_data & 0xFF;
;    4177 		if (temp_data == '\n')
;    4178 			break;
;    4179 		else if (temp_data == EOF)
;    4180 			break;
;    4181 		buffer++;
;    4182 	}
;    4183 	if (c==n)
;    4184 		buffer++;
;    4185 	*buffer-- = '\0';
;    4186 	if (temp_data == EOF)
;    4187 		return (NULL);
;    4188 	return (buffer);
;    4189 }
;    4190 
;    4191 #ifndef _READ_ONLY_
;    4192 // Decrement file pointer, then get file data
;    4193 int ungetc(unsigned char file_data, FILE *rp)
;    4194 {
;    4195 	unsigned int n;
;    4196 	unsigned long addr_temp;
;    4197 	
;    4198 	if ((rp==NULL) || (rp->position==0))
;	file_data -> Y+8
;	*rp -> Y+6
;	n -> R16,R17
;	addr_temp -> Y+2
;    4199 		return (EOF);
;    4200 	if ((rp->mode!=APPEND) && (rp->mode!=WRITE))
;    4201 		return (EOF);	// needs to be in WRITE or APPEND mode
;    4202 
;    4203 	if (((rp->position) == rp->length) && (rp->EOF_flag))
;    4204 	{	// if the file posisition is equal to the length, return data, turn flag off
;    4205 		rp->EOF_flag = 0;
;    4206 		*rp->pntr = file_data;
;    4207 		return (*rp->pntr);
;    4208 	}
;    4209 	if ((rp->pntr)==(&rp->buff[0]))
;    4210 	{	// Check to see if pointer is at the beginning of a Sector
;    4211 		// Update the current sector before loading next
;    4212 		for (n=0; n<BPB_BytsPerSec; n++)
;    4213 			_FF_buff[n] = rp->buff[n];
;    4214 		addr_temp = clust_to_addr(rp->clus_current) + (((rp->sec_offset)-1)*BPB_BytsPerSec);
;    4215 		if (_FF_write(addr_temp)==0)
;    4216 			return (EOF);
;    4217 			
;    4218 		if (rp->sec_offset > 1)
;    4219 		{	// Goto previous sector if not at the beginning of a cluster
;    4220 			addr_temp = clust_to_addr(rp->clus_current) + ((rp->sec_offset-2)*BPB_BytsPerSec);
;    4221 			rp->sec_offset--;
;    4222 		}
;    4223 		else
;    4224 		{	// Beginning of Cluster, find previous
;    4225 			if (rp->clus_start==rp->clus_current)
;    4226 			{	// Positioned @ Beginning of File
;    4227 				_FF_error = SOF_ERR;
;    4228 				return(EOF);
;    4229 			}
;    4230 			rp->sec_offset = BPB_SecPerClus;	// Set sector offset to last sector
;    4231 			rp->clus_next = rp->clus_current;
;    4232 			rp->clus_current = rp->clus_prev;
;    4233 			if (rp->clus_current != rp->clus_start)
;    4234 				rp->clus_prev = prev_cluster(rp->clus_current);
;    4235 			else
;    4236 				rp->clus_prev = 0;
;    4237 			addr_temp = clust_to_addr(rp->clus_current) + (((long) BPB_SecPerClus-1) * (long) BPB_BytsPerSec);
;    4238 		}
;    4239 		_FF_read(addr_temp);
;    4240 		for (n=0; n<BPB_BytsPerSec; n++)
;    4241 			rp->buff[n] = _FF_buff[n];
;    4242 		rp->pntr = &rp->buff[511];
;    4243 	}
;    4244 	else
;    4245 		rp->pntr--;
;    4246 	
;    4247 	rp->position--;
;    4248 	*rp->pntr = file_data;	
;    4249 	return(*rp->pntr);	// Get data	
;    4250 }
;    4251 #endif
;    4252 
;    4253 #ifndef _READ_ONLY_
;    4254 int fputc(unsigned char file_data, FILE *rp)	
;    4255 {
;    4256 	unsigned int n;
;    4257 	unsigned long addr_temp;
;    4258 	
;    4259 	if (rp==NULL)
;	file_data -> Y+8
;	*rp -> Y+6
;	n -> R16,R17
;	addr_temp -> Y+2
;    4260 		return (EOF);
;    4261 
;    4262 	if (rp->mode == READ)
;    4263 	{
;    4264 		_FF_error = READONLY_ERR;
;    4265 		return(EOF);
;    4266 	}
;    4267 	if (rp->length == 0)
;    4268 	{	// Blank file start writing cluster table
;    4269 		rp->clus_start = prev_cluster(0);
;    4270 		rp->clus_next = 0xFFFF;
;    4271 		rp->clus_current = rp->clus_start;
;    4272 		if (write_clus_table(rp->clus_start, rp->clus_next, SINGLE)==0)
;    4273 		{
;    4274 			return (EOF);
;    4275 		}
;    4276 	}
;    4277 	
;    4278 	if ((rp->position==rp->length) && (rp->EOF_flag))
;    4279 	{	// At end of file, and end of cluster, flagged
;    4280 		rp->clus_prev = rp->clus_current;
;    4281 		rp->clus_current = prev_cluster(0);	// Find first cluster pointing to '0'
;    4282 		rp->clus_next = 0xFFFF;
;    4283 		rp->sec_offset = 1;
;    4284 		if (write_clus_table(rp->clus_prev, rp->clus_current, CHAIN)==0)
;    4285 		{
;    4286 			return (EOF);
;    4287 		}
;    4288 		if (write_clus_table(rp->clus_current, rp->clus_next, END_CHAIN)==0)
;    4289 		{
;    4290 			return (EOF);
;    4291 		}
;    4292 		if (append_toc(rp)==0)
;    4293 		{
;    4294 			return (EOF);
;    4295 		}
;    4296 		rp->EOF_flag = 0;
;    4297 		rp->pntr = &rp->buff[0];		
;    4298 	}
;    4299 	
;    4300 	*rp->pntr = file_data;
;    4301 	
;    4302 	if (rp->pntr == &rp->buff[BPB_BytsPerSec-1])
;    4303 	{	// This is on the Sector Limit
;    4304 		if (rp->position > rp->length)
;    4305 		{	// ERROR, position should never be greater than length
;    4306 			_FF_error = 0x10;		// file position ERROR
;    4307 			return (EOF); 
;    4308 		}
;    4309 		// Position is at end of a sector?
;    4310 		
;    4311 		addr_temp = (clust_to_addr(rp->clus_current) + ((rp->sec_offset-1)*BPB_BytsPerSec));
;    4312 		for (n=0; n<BPB_BytsPerSec; n++)
;    4313 			_FF_buff[n] = rp->buff[n];
;    4314 		_FF_write(addr_temp);
;    4315 			// Save MMC buffer to card, set pointer to begining of new buffer
;    4316 		if (rp->sec_offset < BPB_SecPerClus)
;    4317 		{	// Are there more sectors in this cluster?
;    4318 			addr_temp = clust_to_addr(rp->clus_current) + (rp->sec_offset * BPB_BytsPerSec);
;    4319 			rp->sec_offset++;
;    4320 		}
;    4321 		else
;    4322 		{	// Find next cluster, load first sector into file.buff
;    4323 			if (((rp->clus_next>=0xFFF8)&&(BPB_FATType==0x36)) ||
;    4324 				((rp->clus_next>=0xFF8)&&(BPB_FATType==0x32)))
;    4325 			{	// EOF, need to find new empty cluster
;    4326 				if (rp->position != rp->length)
;    4327 				{	// if not equal there's an error
;    4328 					_FF_error = 0x20;		// EOF position error
;    4329 					return (EOF);
;    4330 				}
;    4331 				rp->EOF_flag = 1;
;    4332 			}
;    4333 			else
;    4334 			{	// Not EOF, find next cluster
;    4335 				rp->clus_prev = rp->clus_current;
;    4336 				rp->clus_current = rp->clus_next;
;    4337 				rp->clus_next = next_cluster(rp->clus_current, SINGLE);
;    4338 			}
;    4339 			rp->sec_offset = 1;
;    4340 			addr_temp = clust_to_addr(rp->clus_current);
;    4341 		}
;    4342 		
;    4343 		if (rp->EOF_flag == 0)
;    4344 		{
;    4345 			if (_FF_read(addr_temp)==0)
;    4346 				return(EOF);
;    4347 			for (n=0; n<512; n++)
;    4348 				rp->buff[n] = _FF_buff[n];
;    4349 			rp->pntr = &rp->buff[0];	// Set pointer to next location				
;    4350 		}
;    4351 		if (rp->length==rp->position)
;    4352 			rp->length++;
;    4353 		if (append_toc(rp)==0)
;    4354 			return(EOF);
;    4355 	}
;    4356 	else
;    4357 	{
;    4358 		rp->pntr++;
;    4359 		if (rp->length==rp->position)
;    4360 			rp->length++;
;    4361 	}
;    4362 	rp->position++;
;    4363 	return(file_data);
;    4364 }
;    4365 
;    4366 int fputs(unsigned char *file_data, FILE *rp)
;    4367 {
;    4368 	while(*file_data)
;    4369 		if (fputc(*file_data++,rp) == EOF)
;    4370 			return (EOF);
;    4371 	if (fputc('\r',rp) == EOF)
;    4372 		return (EOF);
;    4373 	if (fputc('\n',rp) == EOF)
;    4374 		return (EOF);
;    4375 	return (0);
;    4376 }
;    4377 
;    4378 int fputsc(flash unsigned char *file_data, FILE *rp)
;    4379 {
;    4380 	while(*file_data)
;    4381 		if (fputc(*file_data++,rp) == EOF)
;    4382 			return (EOF);
;    4383 	if (fputc('\r',rp) == EOF)
;    4384 		return (EOF);
;    4385 	if (fputc('\n',rp) == EOF)
;    4386 		return (EOF);
;    4387 	return (0);
;    4388 }
;    4389 #endif
;    4390 
;    4391 //#ifndef _READ_ONLY_
;    4392 #ifdef _CVAVR_
;    4393 void fprintf(FILE *rp, unsigned char flash *pstr, ...)
;    4394 {
;    4395 	va_list arglist;
;    4396 	unsigned char temp_buff[_FF_MAX_FPRINT], *fp;
;    4397 	
;    4398 	va_start(arglist, pstr);
;	*rp -> Y+106
;	*pstr -> Y+104
;	*arglist -> R16,R17
;	temp_buff -> Y+4
;	*fp -> R18,R19
;    4399 	vsprintf(temp_buff, pstr, arglist);
;    4400 	va_end(arglist);
;    4401 	
;    4402 	fp = temp_buff;
;    4403 	while (*fp)
;    4404 		fputc(*fp++, rp);	
;    4405 }
;    4406 #endif
;    4407 #ifdef _ICCAVR_
;    4408 void fprintf(FILE *rp, unsigned char flash *pstr, long var)
;    4409 {
;    4410 	unsigned char temp_buff[_FF_MAX_FPRINT], *fp;
;    4411 	
;    4412 	csprintf(temp_buff, pstr, var);
;    4413 	
;    4414 	fp = temp_buff;
;    4415 	while (*fp)
;    4416 		fputc(*fp++, rp);	
;    4417 }
;    4418 #endif
;    4419 //#endif
;    4420 
;    4421 // Set file pointer to the end of the file
;    4422 int fend(FILE *rp)
;    4423 {
;    4424 	return (fseek(rp, 0, SEEK_END));	
;    4425 }
;    4426 
;    4427 // Goto position "off_set" of a file
;    4428 int fseek(FILE *rp, unsigned long off_set, unsigned char mode)
;    4429 {
_fseek:
;    4430 	unsigned int n, clus_temp;
;    4431 	unsigned long length_check, addr_calc;
;    4432 	
;    4433 	if (rp==NULL)
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
	BRNE _0x37F
;    4434 	{	// ERROR if FILE pointer is NULL
;    4435 		_FF_error = FILE_ERR;
	LDI  R30,LOW(2)
	STS  __FF_error,R30
;    4436 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x418
;    4437 	}
;    4438 	if (mode==SEEK_CUR)
_0x37F:
	LDD  R30,Y+12
	CPI  R30,0
	BRNE _0x380
;    4439 	{	// Trying to position pointer to offset from current position
;    4440 		off_set += rp->position;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SUBI R26,LOW(-544)
	SBCI R27,HIGH(-544)
	CALL __GETD1P
	__GETD2S 13
	CALL __ADDD12
	__PUTD1S 13
;    4441 	}
;    4442 	if (off_set > rp->length)
_0x380:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	CALL __GETD1P
	__GETD2S 13
	CALL __CPD12
	BRSH _0x381
;    4443 	{	// trying to position beyond or before file
;    4444 		rp->error = POS_ERR;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SUBI R26,LOW(-549)
	SBCI R27,HIGH(-549)
	LDI  R30,LOW(10)
	ST   X,R30
;    4445 		_FF_error = POS_ERR;
	STS  __FF_error,R30
;    4446 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x418
;    4447 	}
;    4448 	if (mode==SEEK_END)
_0x381:
	LDD  R26,Y+12
	CPI  R26,LOW(0x1)
	BRNE _0x382
;    4449 	{	// Trying to position pointer to offset from EOF
;    4450 		off_set = rp->length - off_set;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	CALL __GETD1P
	__GETD2S 13
	CALL __SUBD12
	__PUTD1S 13
;    4451 	}
;    4452 	#ifndef _READ_ONLY_
;    4453 	if (rp->mode != READ)
_0x382:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SUBI R26,LOW(-548)
	SBCI R27,HIGH(-548)
	LD   R26,X
	CPI  R26,LOW(0x1)
	BREQ _0x383
;    4454 		if (fflush(rp))
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _fflush
	SBIW R30,0
	BREQ _0x384
;    4455 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x418
;    4456 	#endif
;    4457 	clus_temp = rp->clus_start;
_0x384:
_0x383:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,12
	LD   R18,X+
	LD   R19,X
;    4458 	rp->clus_current = clus_temp;
	MOVW R30,R18
	__PUTW1SNS 17,14
;    4459 	rp->clus_next = next_cluster(clus_temp, SINGLE);
	ST   -Y,R19
	ST   -Y,R18
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _next_cluster
	__PUTW1SNS 17,16
;    4460 	rp->clus_prev = 0;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,18
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
;    4461 	
;    4462 	addr_calc = off_set / ((long) BPB_BytsPerSec * (long) BPB_SecPerClus);
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
	__GETD2S 13
	CALL __DIVD21U
	__PUTD1S 4
;    4463 	length_check = off_set % ((long) BPB_BytsPerSec * (long) BPB_SecPerClus);
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
	__GETD2S 13
	CALL __MODD21U
	__PUTD1S 8
;    4464 	rp->EOF_flag = 0;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SUBI R26,LOW(-550)
	SBCI R27,HIGH(-550)
	LDI  R30,LOW(0)
	ST   X,R30
;    4465 
;    4466 	while (addr_calc)
_0x385:
	__GETD1S 4
	CALL __CPD10
	BRNE PC+3
	JMP _0x387
;    4467 	{
;    4468 		if (rp->clus_next >= 0xFFF8)
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	LDD  R26,Z+16
	LDD  R27,Z+17
	CPI  R26,LOW(0xFFF8)
	LDI  R30,HIGH(0xFFF8)
	CPC  R27,R30
	BRLO _0x388
;    4469 		{	// trying to position beyond or before file
;    4470 			if ((addr_calc==1) && (length_check==0))
	__GETD2S 4
	__CPD2N 0x1
	BRNE _0x38A
	__GETD2S 8
	CALL __CPD02
	BREQ _0x38B
_0x38A:
	RJMP _0x389
_0x38B:
;    4471 			{
;    4472 				rp->EOF_flag = 1;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SUBI R26,LOW(-550)
	SBCI R27,HIGH(-550)
	LDI  R30,LOW(1)
	ST   X,R30
;    4473 				break;
	RJMP _0x387
;    4474 			}				
;    4475 			rp->error = POS_ERR;
_0x389:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SUBI R26,LOW(-549)
	SBCI R27,HIGH(-549)
	LDI  R30,LOW(10)
	ST   X,R30
;    4476 			_FF_error = POS_ERR;
	STS  __FF_error,R30
;    4477 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x418
;    4478 		}
;    4479 		clus_temp = rp->clus_next;
_0x388:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,16
	LD   R18,X+
	LD   R19,X
;    4480 		rp->clus_prev = rp->clus_current;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,14
	CALL __GETW1P
	__PUTW1SNS 17,18
;    4481 		rp->clus_current = clus_temp;
	MOVW R30,R18
	__PUTW1SNS 17,14
;    4482 		rp->clus_next = next_cluster(clus_temp, CHAIN);
	ST   -Y,R19
	ST   -Y,R18
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _next_cluster
	__PUTW1SNS 17,16
;    4483 		addr_calc--;
	__GETD1S 4
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	__PUTD1S 4
;    4484 	}
	RJMP _0x385
_0x387:
;    4485 	
;    4486 	addr_calc = clust_to_addr(rp->clus_current);
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	LDD  R26,Z+14
	LDD  R27,Z+15
	ST   -Y,R27
	ST   -Y,R26
	CALL _clust_to_addr
	__PUTD1S 4
;    4487 	rp->sec_offset = 1;			// Reset Reading Sector
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,20
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
;    4488 	while (length_check >= BPB_BytsPerSec)
_0x38C:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	__GETD2S 8
	CLR  R22
	CLR  R23
	CALL __CPD21
	BRLO _0x38E
;    4489 	{
;    4490 		addr_calc += BPB_BytsPerSec;
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	__GETD2S 4
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1S 4
;    4491 		length_check -= BPB_BytsPerSec;
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	__GETD2S 8
	CLR  R22
	CLR  R23
	CALL __SUBD21
	__PUTD2S 8
;    4492 		rp->sec_offset++;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,20
	CALL __GETW1P
	ADIW R30,1
	ST   X+,R30
	ST   X,R31
;    4493 	}
	RJMP _0x38C
_0x38E:
;    4494 	
;    4495 	if (_FF_read(addr_calc)==0)		// Read Current Data Sector
	__GETD1S 4
	CALL __PUTPARD1
	CALL __FF_read
	CPI  R30,0
	BRNE _0x38F
;    4496 		return(EOF);		// Read Error  
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x418
;    4497 		
;    4498 	for (n=0; n<BPB_BytsPerSec; n++)
_0x38F:
	__GETWRN 16,17,0
_0x391:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x392
;    4499 		rp->buff[n] = _FF_buff[n];
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ADIW R30,28
	ADD  R30,R16
	ADC  R31,R17
	MOVW R0,R30
	LDI  R26,LOW(__FF_buff)
	LDI  R27,HIGH(__FF_buff)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
;    4500     
;    4501     if ((rp->EOF_flag == 1) && (length_check == 0))
	__ADDWRN 16,17,1
	RJMP _0x391
_0x392:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SUBI R26,LOW(-550)
	SBCI R27,HIGH(-550)
	LD   R26,X
	CPI  R26,LOW(0x1)
	BRNE _0x394
	__GETD2S 8
	CALL __CPD02
	BREQ _0x395
_0x394:
	RJMP _0x393
_0x395:
;    4502     	rp->pntr = &rp->buff[BPB_BytsPerSec-1];
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,28
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	SBIW R30,1
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1SN 17,551
;    4503 	rp->pntr = &rp->buff[length_check];
_0x393:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,28
	__GETD1S 8
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1SN 17,551
;    4504 	rp->position = off_set;
	__GETD1S 13
	__PUTD1SN 17,544
;    4505 		
;    4506 	return (0);	
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x418:
	CALL __LOADLOCR4
	ADIW R28,19
	RET
;    4507 }
;    4508 
;    4509 // Return the current position of the file rp with respect to the begining of the file
;    4510 long ftell(FILE *rp)
;    4511 {
;    4512 	if (rp==NULL)
;    4513 		return (EOF);
;    4514 	else
;    4515 		return (rp->position);
;    4516 }
;    4517 
;    4518 // Funtion that returns a '1' for @EOF, '0' otherwise
;    4519 int feof(FILE *rp)
;    4520 {
;    4521 	if (rp==NULL)
;    4522 		return (EOF);
;    4523 	
;    4524 	if (rp->length==rp->position)
;    4525 		return (1);
;    4526 	else
;    4527 		return (0);
;    4528 }
;    4529 		
;    4530 void dump_file_data_hex(FILE *rp)
;    4531 {
;    4532 	unsigned int n, c;
;    4533 	
;    4534 	if (rp==NULL)
;	*rp -> Y+4
;	n -> R16,R17
;	c -> R18,R19
;    4535 		return;
;    4536 
;    4537 	for (n=0; n<0x20; n++)
;    4538 	{   
;    4539 		printf("\n\r");
;    4540 		for (c=0; c<0x10; c++)
;    4541 			printf("%02X ", rp->buff[(n*0x20)+c]);
;    4542 	}
;    4543 }
;    4544 
;    4545 void dump_file_data_view(FILE *rp)
;    4546 {
;    4547 	unsigned int n;
;    4548 	
;    4549 	if (rp==NULL)
;	*rp -> Y+2
;	n -> R16,R17
;    4550 		return;
;    4551 
;    4552 	printf("\n\r");
;    4553 	for (n=0; n<512; n++)
;    4554 		putchar(rp->buff[n]);
;    4555 }
;    4556 

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
_allocate_block_G9:
	SBIW R28,2
	CALL __SAVELOCR6
	__GETWRN 16,17,3240
	MOVW R26,R16
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x404:
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x406
	MOVW R26,R16
	CALL __GETW1P
	ADD  R30,R16
	ADC  R31,R17
	ADIW R30,4
	MOVW R20,R30
	ADIW R26,2
	CALL __GETW1P
	MOVW R18,R30
	SBIW R30,0
	BREQ _0x407
	__PUTWSR 18,19,6
	RJMP _0x408
_0x407:
	LDI  R30,LOW(4352)
	LDI  R31,HIGH(4352)
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x408:
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
	BRLO _0x409
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
	RJMP _0x417
_0x409:
	__MOVEWRR 16,17,18,19
	RJMP _0x404
_0x406:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x417:
	CALL __LOADLOCR6
	ADIW R28,10
	RET
_find_prev_block_G9:
	CALL __SAVELOCR4
	__GETWRN 16,17,3240
_0x40A:
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x40C
	MOVW R26,R16
	ADIW R26,2
	CALL __GETW1P
	MOVW R18,R30
	MOVW R26,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x40D
	MOVW R30,R16
	RJMP _0x416
_0x40D:
	__MOVEWRR 16,17,18,19
	RJMP _0x40A
_0x40C:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x416:
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
	JMP _0x40E
	SBIW R30,4
	MOVW R16,R30
	ST   -Y,R17
	ST   -Y,R16
	RCALL _find_prev_block_G9
	MOVW R18,R30
	SBIW R30,0
	BREQ _0x40F
	MOVW R26,R16
	ADIW R26,2
	CALL __GETW1P
	__PUTW1RNS 18,2
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SBIW R30,0
	BREQ _0x410
	ST   -Y,R31
	ST   -Y,R30
	RCALL _allocate_block_G9
	MOVW R20,R30
	SBIW R30,0
	BREQ _0x411
	MOVW R26,R16
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	MOVW R26,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x412
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	STD  Y+8,R30
	STD  Y+8+1,R31
_0x412:
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
	RJMP _0x415
_0x411:
	MOVW R30,R16
	__PUTW1RNS 18,2
_0x410:
_0x40F:
_0x40E:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x415:
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
	BREQ _0x413
	ST   -Y,R31
	ST   -Y,R30
	RCALL _allocate_block_G9
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x414
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
_0x414:
_0x413:
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

;END OF CODE MARKER
__END_OF_CODE:
