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
	RJMP _0x432
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
_0x432:
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
;     222 		LedGreen();
	SBI  0x1A,0
	SBI  0x1A,1
	SBI  0x1B,0
	CBI  0x1B,1
;     223 
;     224 		for (a=1; a<= int_Devices; a++) pingPack (a);	   			// вычитываем у кого что есть
	LDI  R16,LOW(1)
_0x26:
	LDS  R30,_int_Devices
	CP   R30,R16
	BRLO _0x27
	ST   -Y,R16
	RCALL _pingPack
;     225 
;     226 		ReadLogAddr ();				// Вычитываем лог. адреса
	SUBI R16,-1
	RJMP _0x26
_0x27:
	RCALL _ReadLogAddr
;     227 	
;     228 
;     229 		// Проверяю, нет ли пакета и принимаю меры, если есть
;     230 		if (HaveIncomingPack())
	RCALL _HaveIncomingPack
	CPI  R30,0
	BRNE PC+3
	JMP _0x28
;     231 		{
;     232 		if ((rx0addr == my_addr) || (rx0addr == TO_ALL))				// адрес мой 
	LDI  R26,LOW(_my_addr)
	LDI  R27,HIGH(_my_addr)
	CALL __EEPROMRDB
	LDS  R26,_rx0addr
	CP   R30,R26
	BREQ _0x2A
	CPI  R26,LOW(0xFF)
	BRNE _0x29
_0x2A:
;     233 			{
;     234 				switch(IncomingPackType())
	RCALL _IncomingPackType
;     235 					{
;     236 						case PT_GETSTATE:
	CPI  R30,LOW(0x1)
	BRNE _0x2F
;     237 								GetState();
	CALL _GetState_G1
;     238 								break;
	RJMP _0x2E
;     239 				
;     240 						case PT_GETINFO:
_0x2F:
	CPI  R30,LOW(0x3)
	BRNE _0x30
;     241 								GetInfo();
	CALL _GetInfo_G1
;     242 								break;
	RJMP _0x2E
;     243 				
;     244 						case PT_SETADDR:
_0x30:
	CPI  R30,LOW(0x4)
	BRNE _0x31
;     245 								SetAddr();
	CALL _SetAddr_G1
;     246 								break;
	RJMP _0x2E
;     247 				
;     248 						case PT_SETSERIAL:
_0x31:
	CPI  R30,LOW(0x5)
	BRNE _0x32
;     249 								SetSerial();
	CALL _SetSerial_G1
;     250 								break;
	RJMP _0x2E
;     251 				
;     252 						case PT_TOPROG:
_0x32:
	CPI  R30,LOW(0x7)
	BRNE _0x33
;     253 								ToProg();
	CALL _ToProg_G1
;     254 								break;      
	RJMP _0x2E
;     255 
;     256 						case PT_RELAY:           			// ретрансляция пакета при программировании
_0x33:
	CPI  R30,LOW(0x6)
	BRNE _0x34
;     257 							    RelayPack();	
	RCALL _RelayPack
;     258                 				break;
	RJMP _0x2E
;     259 
;     260 						case PT_FLASH:								// пакеты для работы с CF Flash
_0x34:
	CPI  R30,LOW(0xB4)
	BRNE _0x36
;     261 							    flash_Work();	
	RCALL _flash_Work
;     262                 				break;
	RJMP _0x2E
;     263                 			
;     264 						default:
_0x36:
;     265 								DiscardIncomingPack();
	RCALL _DiscardIncomingPack
;     266 								break;
;     267 					}
_0x2E:
;     268 		   }
;     269 		else																	// ретранслируем
	RJMP _0x37
_0x29:
;     270 				{                                                                      
;     271 					for (a=1; a<= int_Devices; a++)				// ищем порт по адресу
	LDI  R16,LOW(1)
_0x39:
	LDS  R30,_int_Devices
	CP   R30,R16
	BRLO _0x3A
;     272 						{
;     273 						 	if (lAddrDevice [a]	== rx0addr)
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_lAddrDevice)
	SBCI R31,HIGH(-_lAddrDevice)
	LD   R30,Z
	LDS  R26,_rx0addr
	CP   R30,R26
	BRNE _0x3B
;     274 						 		{
;     275 									LedRed();
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,0
	SBI  0x1B,1
;     276 									recompPack (a);		
	ST   -Y,R16
	RCALL _recompPack
;     277 									DiscardIncomingPack();        // разрешаем принимать след. пакет
	RCALL _DiscardIncomingPack
;     278 									delay_ms (50);
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
;     279 									pingPack (a);	
	ST   -Y,R16
	RCALL _pingPack
;     280 									break;
	RJMP _0x3A
;     281 						 		}
;     282 						}
_0x3B:
	SUBI R16,-1
	RJMP _0x39
_0x3A:
;     283 				}
_0x37:
;     284 		}
;     285 	}
_0x28:
	RJMP _0x22
;     286 }    	
_0x3C:
	RJMP _0x3C
;     287 
;     288 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;     289 // Управляющая программа КОДЕРА
;     290 // Связь с внешним миром
;     291 
;     292 #include "Coding.h"
;     293 
;     294 #define BAUD 38400
;     295 
;     296 /*
;     297 ////////////////////////////////////////////////////////////////////////////////
;     298 // Фазы работы приемопередатчиков
;     299 #define RX_HDR	 1		// Принятый байт - заголовок
;     300 #define RX_LEN   2		// Принятый байт - длина
;     301 #define RX_ADDR  3		// Принятый байт - адрес
;     302 #define RX_TYPE  4		// Принятый байт - тип пакета
;     303 #define RX_DATA  5		// Принятый байт - байт данных
;     304 #define RX_CRC   6		// Принятый байт - CRC
;     305 #define RX_OK    7		// Пакет успешно принят и адресован мне
;     306 #define RX_TIME  8		// Во время приема произошел тайм-аут
;     307 #define RX_ERR   9		// Ошибка CRC приема
;     308 #define RX_BUSY 10		// Запрос прочитан, а ответ еще не сформирован
;     309 */
;     310 #define UDRE 5
;     311 #define DATA_REGISTER_EMPTY (1<<UDRE)
;     312 
;     313 #define RXTIMEOUT 4000	// Тайм-аут приема наружного канала
;     314 
;     315 ////////////////////////////////////////////////////////////////////////////////
;     316 // Работа с наружным каналом
;     317 
;     318 unsigned char tx0crc;
;     319 unsigned char rx0state = RX_HDR;

	.DSEG
;     320 unsigned char rx0crc;
;     321 unsigned char rx0len;
;     322 unsigned char rx0addr;
_rx0addr:
	.BYTE 0x1
;     323 unsigned char rx0type;
;     324 
;     325 #define COMBUFSIZ 255
;     326 
;     327 unsigned char rx0buf[COMBUFSIZ];
_rx0buf:
	.BYTE 0xFF
;     328 unsigned char rx0ptr;
_rx0ptr:
	.BYTE 0x1
;     329 
;     330 // Передача байта во "внешний" канал
;     331 void putchar0(char byt)
;     332 {

	.CSEG
_putchar0:
;     333 	while ((UCSR0A & DATA_REGISTER_EMPTY)==0);
_0x3E:
	SBIS 0xB,5
	RJMP _0x3E
;     334 	UDR0 = byt;
	LD   R30,Y
	OUT  0xC,R30
;     335 	tx0crc += byt;
	ADD  R10,R30
;     336 }
	RJMP _0x431
;     337 
;     338 // Начало ответа на запрос по внешнему каналу
;     339 void StartReply(unsigned char dlen) 
;     340 {
_StartReply:
;     341 //	rx0state = RX_BUSY;					// Запрос обработан
;     342 	tx0crc = 0;										// Готовлю CRC
	CLR  R10
;     343 	
;     344 	UCSR0B.3 = 1;								// Разрешаю передатчик
	SBI  0xA,3
;     345 	
;     346 	putchar0(dlen+1);							// Передаю длину
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   -Y,R30
	CALL _putchar0
;     347 }
	RJMP _0x431
;     348 
;     349 void EndReply(void)
;     350 {
_EndReply:
;     351 	putchar0(tx0crc);							// Контрольная сумма
	ST   -Y,R10
	CALL _putchar0
;     352 //	UCSR0B.3 = 0;								// Запрещаю передатчик
;     353 	rx0state = RX_HDR;						// Разрешаю прием след. запроса
	LDI  R30,LOW(1)
	MOV  R11,R30
;     354 }
	RET
;     355 
;     356 // Прерывание по приему байта из "наружного" канала
;     357 interrupt [USART0_RXC] void uart_rx_isr(void)
;     358 {
_uart_rx_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;     359 	register unsigned char byt;
;     360 
;     361 	byt = UDR0;									// Принятый байт
	ST   -Y,R16
;	byt -> R16
	IN   R16,12
;     362 
;     363 	
;     364 	switch (rx0state)
	MOV  R30,R11
;     365 	{
;     366 	case RX_HDR:								// Должен быть заголовок
	CPI  R30,LOW(0x1)
	BRNE _0x44
;     367 		if (byt != PACKHDR)					// Отбрасываю не заголовок
	CPI  R16,113
	BREQ _0x45
;     368 		{
;     369 			break;
	RJMP _0x43
;     370 		}
;     371 
;     372 
;     373 		rx0state = RX_LEN;					// Перехожу к ожиданию длины
_0x45:
	LDI  R30,LOW(2)
	MOV  R11,R30
;     374 		rx0crc = 0;								// Готовлю подсчет CRC
	CLR  R12
;     375 		
;     376 		OCR1A = TCNT1+RXTIMEOUT;	// Взвожу тайм-аут
	IN   R30,0x2C
	IN   R31,0x2C+1
	SUBI R30,LOW(-4000)
	SBCI R31,HIGH(-4000)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
;     377 		TIFR = 0x10;								// Предотвращаю ложное срабатывание
	LDI  R30,LOW(16)
	OUT  0x36,R30
;     378 		TIMSK |= 0x10;							// Разрешение прерывания по тайм-ауту
	IN   R30,0x37
	ORI  R30,0x10
	OUT  0x37,R30
;     379 		break;
	RJMP _0x43
;     380 		
;     381 	case RX_LEN:
_0x44:
	CPI  R30,LOW(0x2)
	BRNE _0x46
;     382 		rx0len = byt - 3;							// Длина содержимого
	MOV  R30,R16
	SUBI R30,LOW(3)
	MOV  R13,R30
;     383 		rx0state = RX_ADDR;					// К приему адреса
	LDI  R30,LOW(3)
	RJMP _0x433
;     384 		break;
;     385 
;     386 	case RX_ADDR:
_0x46:
	CPI  R30,LOW(0x3)
	BRNE _0x47
;     387 		rx0addr = byt;							// Адрес
	STS  _rx0addr,R16
;     388 		rx0state = RX_TYPE;					// К приему типа
	LDI  R30,LOW(4)
	RJMP _0x433
;     389 		break;
;     390 
;     391 	case RX_TYPE:
_0x47:
	CPI  R30,LOW(0x4)
	BRNE _0x48
;     392 		rx0type = byt;							// Тип
	MOV  R14,R16
;     393 		rx0ptr = 0;									// Указатель на начало данных
	LDI  R30,LOW(0)
	STS  _rx0ptr,R30
;     394 		if (rx0len)
	TST  R13
	BREQ _0x49
;     395 		{
;     396 			rx0state = RX_DATA;				// К приему данных
	LDI  R30,LOW(5)
	RJMP _0x434
;     397 		}
;     398 		else
_0x49:
;     399 		{
;     400 			rx0state = RX_CRC; 				// К приему контрольной суммы
	LDI  R30,LOW(6)
_0x434:
	MOV  R11,R30
;     401 		}
;     402 		break;
	RJMP _0x43
;     403 
;     404 	case RX_DATA:
_0x48:
	CPI  R30,LOW(0x5)
	BRNE _0x4B
;     405 		if (rx0ptr > (COMBUFSIZ-1))
	LDS  R26,_rx0ptr
	CPI  R26,LOW(0xFF)
	BRLO _0x4C
;     406 		{
;     407 			rx0state = RX_HDR;				// Если пакет слишком длинный - отвергаю и иду в начало
	RJMP _0x435
;     408 			break;
;     409 		}
;     410 		rx0buf[rx0ptr++] = byt;				// Данные
_0x4C:
	LDS  R30,_rx0ptr
	SUBI R30,-LOW(1)
	STS  _rx0ptr,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_rx0buf)
	SBCI R31,HIGH(-_rx0buf)
	ST   Z,R16
;     411 		if (rx0ptr < rx0len)						// Еще не все ?
	LDS  R26,_rx0ptr
	CP   R26,R13
	BRLO _0x43
;     412 		{
;     413 			break;
;     414 		}
;     415 		rx0state = RX_CRC;					// К приему контрольной суммы
	LDI  R30,LOW(6)
	RJMP _0x433
;     416 		break;
;     417 
;     418 	case RX_CRC:
_0x4B:
	CPI  R30,LOW(0x6)
	BRNE _0x51
;     419 		if (byt != rx0crc)
	CP   R12,R16
	BREQ _0x4F
;     420 		{
;     421 			rx0state = RX_HDR;				// Не сошлась CRC - игнорирую пакет и жду следующий
	LDI  R30,LOW(1)
	RJMP _0x436
;     422 		}
;     423 // убрал фильтр адреса
;     424 else
_0x4F:
;     425 {
;     426 rx0buf[rx0ptr++] = byt;						// Данные
	LDS  R30,_rx0ptr
	SUBI R30,-LOW(1)
	STS  _rx0ptr,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_rx0buf)
	SBCI R31,HIGH(-_rx0buf)
	ST   Z,R16
;     427 rx0state = RX_OK;								// Принят пакет, на который нужно ответить
	LDI  R30,LOW(7)
_0x436:
	MOV  R11,R30
;     428 }
;     429 /*		else if ((rx0addr == my_addr) || (rx0addr == TO_ALL))
;     430 		{
;     431  			rx0buf[rx0ptr++] = byt;			// Данные
;     432     		rx0state = RX_OK;				// Принят пакет, на который нужно ответить
;     433 		}
;     434 		else
;     435 		{
;     436 			rx0state = RX_HDR;				// Принят пакет, адресованный не мне - жду следующего
;     437 		}*/
;     438 		TIMSK &= 0x10 ^ 0xFF;				// Запретить прерывание по тайм-ауту
	IN   R30,0x37
	ANDI R30,0xEF
	OUT  0x37,R30
;     439 		break;
	RJMP _0x43
;     440 		
;     441 //	case RX_BUSY:							// Запрос принят, но ответ еще не готов
;     442 		break;
;     443 		
;     444 	default:											// Ошибочное состояние
_0x51:
;     445 		rx0state = RX_HDR;					// Перехожу на начало
_0x435:
	LDI  R30,LOW(1)
_0x433:
	MOV  R11,R30
;     446 		break;
;     447 	}
_0x43:
;     448 
;     449 	rx0crc += byt;								// Подсчитываю контрольную сумму
	ADD  R12,R16
;     450 }
	LD   R16,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;     451 
;     452 // Прерывание по сравнению A таймера 1 для подсчета тайм-аута приема "внешнего" канала
;     453 interrupt [TIM1_COMPA] void timer1_comp_a_isr(void)
;     454 {
_timer1_comp_a_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
;     455 	rx0state = RX_HDR;						// По тайм-ауту перехожу к началу приема нового пакета
	LDI  R30,LOW(1)
	MOV  R11,R30
;     456 	TIMSK &= 0x10 ^ 0xFF;					// Больше не генерировать прерываний
	IN   R30,0x37
	ANDI R30,0xEF
	OUT  0x37,R30
;     457 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;     458 
;     459 unsigned char HaveIncomingPack(void)
;     460 {
_HaveIncomingPack:
;     461 	if (rx0state == RX_OK)	return 255;
	LDI  R30,LOW(7)
	CP   R30,R11
	BRNE _0x52
	LDI  R30,LOW(255)
	RET
;     462 	else					return 0;
_0x52:
	LDI  R30,LOW(0)
	RET
;     463 }
	RET
;     464 
;     465 unsigned char IncomingPackType(void)
;     466 {
_IncomingPackType:
;     467 	return rx0type;
	MOV  R30,R14
	RET
;     468 }
;     469 
;     470 void DiscardIncomingPack(void)
;     471 {
_DiscardIncomingPack:
;     472 	rx0state = RX_HDR;						// Разрешаю прием следующего пакета
	LDI  R30,LOW(1)
	MOV  R11,R30
;     473 }
	RET
;     474 
;     475 // Настройка приемопередатчика
;     476 void CommInit(void)
;     477 {
_CommInit:
;     478 	// Подтяжка на TXD
;     479 //	DDRD.1 = 0;
;     480 //	PORTD.1 = 1;
;     481 /*	
;     482 // USART0 initialization
;     483 // Communication Parameters: 8 Data, 1 Stop, No Parity
;     484 // USART0 Receiver: On
;     485 // USART0 Transmitter: On
;     486 // USART0 Mode: Asynchronous
;     487 // USART0 Baud rate: 38400
;     488 UCSR0A=0x00;
;     489 UCSR0B=0x18;
;     490 UCSR0C=0x06;
;     491 UBRR0H=0x00;
;     492 UBRR0L=0x0C;
;     493 */
;     494 
;     495 
;     496 	// Настраиваю UART
;     497 	UCSR0A = 0b00000000;
	LDI  R30,LOW(0)
	OUT  0xB,R30
;     498 	UCSR0B = 0b10010000;	//0b10011000;
	LDI  R30,LOW(144)
	OUT  0xA,R30
;     499 	UCSR0C = 0x86;
	LDI  R30,LOW(134)
	STS  149,R30
;     500 	UBRR0L = ((_MCU_CLOCK_FREQUENCY_ / (16 * BAUD)) - 1) & 0xFF;
	LDI  R30,LOW(12)
	OUT  0x9,R30
;     501 	UBRR0H = (((_MCU_CLOCK_FREQUENCY_ / (16 * BAUD)) - 1) >> 8) & 0xFF;
	LDI  R30,LOW(0)
	STS  144,R30
;     502 	
;     503 	// Таймер 1 для подсчета тайм-аутов приема
;     504 	TCCR1B  = 0b00000101;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
;     505 }
	RET
;     506 
;     507 void putword0(unsigned short wd)
;     508 {
_putword0:
;     509 	putchar0(wd);
	LD   R30,Y
	ST   -Y,R30
	CALL _putchar0
;     510 	putchar0(wd >> 8);
	LDD  R30,Y+1
	ANDI R31,HIGH(0x0)
	ST   -Y,R30
	CALL _putchar0
;     511 }                                  
	RJMP _0x430
;     512 
;     513 
;     514 // Ретрансляция цикла обмена из внешнего во внутр. канал и обратно
;     515 // "Внутренний" канал должен быть свободен
;     516 
;     517 void RelayPack(void)
;     518 {
_RelayPack:
;     519 	register unsigned char i,a;
;     520  LedRed();	
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16
;	a -> R17
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,0
	SBI  0x1B,1
;     521 	// Передаю запрос
;     522 	StartIntReq(rx0len);
	ST   -Y,R13
	RCALL _StartIntReq
;     523 	
;     524 	// Тело пакета
;     525 	for (i = 0; i < rx0len; i ++)
	LDI  R16,LOW(0)
_0x55:
	CP   R16,R13
	BRSH _0x56
;     526 	{
;     527 		twi_byte(rx0buf[i]);   
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_rx0buf)
	SBCI R31,HIGH(-_rx0buf)
	LD   R30,Z
	ST   -Y,R30
	RCALL _twi_byte
;     528 		tx1crc +=(rx0buf[i]);
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_rx0buf)
	SBCI R31,HIGH(-_rx0buf)
	LD   R30,Z
	LDS  R26,_tx1crc
	ADD  R30,R26
	STS  _tx1crc,R30
;     529 	}
	SUBI R16,-1
	RJMP _0x55
_0x56:
;     530 	
;     531 	// Окончание запроса
;     532 	EndIntReq();
	RCALL _EndIntReq
;     533 	DiscardIncomingPack();        // разрешаем принимать след. пакет
	CALL _DiscardIncomingPack
;     534 
;     535 	delay_ms (10);						// принимаем ответ
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
;     536 
;     537 /*	if ((rx0buf[0] == TO_MON) || (rx0buf[0] == TO_MON))       // если пакет послан всем - принимаем ответ по очереди
;     538 		{
;     539 			for (a=1; a<= int_Devices; a++) pingPack (a);	
;     540 		}
;     541 	else	pingPack (rx0buf[0]);*/
;     542 
;     543 //	pingPack (4);	
;     544 
;     545 } 
	RJMP _0x42F
;     546   
;     547 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;     548 // 
;     549 // Связь с внешним миром
;     550 
;     551 #include <Coding.h>
;     552 
;     553 // Биты TWCR
;     554 #define TWINT 7
;     555 #define TWEA  6
;     556 #define TWSTA 5
;     557 #define TWSTO 4
;     558 #define TWWC  3
;     559 #define TWEN  2
;     560 #define TWIE  0
;     561 
;     562 // Состояния
;     563 #define START		0x08
;     564 #define	REP_START	0x10
;     565 
;     566 // Коды статуса
;     567 #define	MTX_ADR_ACK		0x18
;     568 #define	MRX_ADR_ACK		0x40
;     569 #define	MTX_DATA_ACK	0x28
;     570 #define	MRX_DATA_NACK	0x58
;     571 #define	MRX_DATA_ACK	0x50
;     572 
;     573 // Подготовка аппаратного мастера I2C
;     574 void twi_init (void)
;     575 {
_twi_init:
;     576 	TWSR=0x00;
	LDI  R30,LOW(0)
	STS  113,R30
;     577 	TWBR=0x20;
	LDI  R30,LOW(32)
	STS  112,R30
;     578 	TWAR=0x00;
	LDI  R30,LOW(0)
	STS  114,R30
;     579 	TWCR=0x04;
	LDI  R30,LOW(4)
	STS  116,R30
;     580 }
	RET
;     581 
;     582 // Жду флажка окончания текущей операции
;     583 static void twi_wait_int (void)
;     584 {
_twi_wait_int_G3:
;     585 
;     586 	while (!(TWCR & (1<<TWINT)))
_0x57:
	LDS  R30,116
	ANDI R30,LOW(0x80)
	BRNE _0x59
;     587 		{
;     588 			   if ( flagTWI & ( 1<< time_is_Out))  break;  // выходим по тайм - ауту
	LDS  R30,_flagTWI
	ANDI R30,LOW(0x1)
	BRNE _0x59
;     589 		}; 
	RJMP _0x57
_0x59:
;     590 }
	RET
;     591 
;     592 // Стартовое условие
;     593 // Возвращает не 0, если все в порядке
;     594 unsigned char twi_start (void)
;     595 {
_twi_start:
;     596 	TWCR = ((1<<TWINT)+(1<<TWSTA)+(1<<TWEN));
	LDI  R30,LOW(164)
	STS  116,R30
;     597 	
;     598 	twi_wait_int();
	CALL _twi_wait_int_G3
;     599 
;     600     if((TWSR != START)&&(TWSR != REP_START))
	LDS  R26,113
	CPI  R26,LOW(0x8)
	BREQ _0x5C
	LDS  R26,113
	CPI  R26,LOW(0x10)
	BRNE _0x5D
_0x5C:
	RJMP _0x5B
_0x5D:
;     601     {
;     602 		return 0;
	LDI  R30,LOW(0)
	RET
;     603 	}
;     604 	
;     605 	return 255;
_0x5B:
	LDI  R30,LOW(255)
	RET
;     606 }
;     607 
;     608 // Стоповое условие
;     609 void twi_stop (void)
;     610 {
_twi_stop:
;     611 	TWCR = ((1<<TWEN)+(1<<TWINT)+(1<<TWSTO));
	LDI  R30,LOW(148)
	STS  116,R30
;     612 }
	RET
;     613 
;     614 // Передача адреса
;     615 // Возвращает не 0, если все в порядке
;     616 unsigned char twi_addr (unsigned char addr)
;     617 {
_twi_addr:
;     618 	twi_wait_int();
	CALL _twi_wait_int_G3
;     619 
;     620 	TWDR = addr;
	LD   R30,Y
	STS  115,R30
;     621 	TWCR = ((1<<TWINT)+(1<<TWEN));
	LDI  R30,LOW(132)
	STS  116,R30
;     622 
;     623 	twi_wait_int();                 		// Ждем отклик 
	CALL _twi_wait_int_G3
;     624 
;     625 	if((TWSR != MTX_ADR_ACK)&&(TWSR != MRX_ADR_ACK))
	LDS  R26,113
	CPI  R26,LOW(0x18)
	BREQ _0x5F
	LDS  R26,113
	CPI  R26,LOW(0x40)
	BRNE _0x60
_0x5F:
	RJMP _0x5E
_0x60:
;     626 	{
;     627 		return 0;
	LDI  R30,LOW(0)
	RJMP _0x431
;     628 	}
;     629 	return 255;
_0x5E:
	LDI  R30,LOW(255)
	RJMP _0x431
;     630 }
;     631 
;     632 // Передача байта данных
;     633 // Возвращает не 0, если все в порядке
;     634 unsigned char twi_byte (unsigned char data)
;     635 {
_twi_byte:
;     636 	twi_wait_int();
	CALL _twi_wait_int_G3
;     637 
;     638 	TWDR = data;
	LD   R30,Y
	STS  115,R30
;     639  	TWCR = ((1<<TWINT)+(1<<TWEN));
	LDI  R30,LOW(132)
	STS  116,R30
;     640 
;     641 	twi_wait_int();
	CALL _twi_wait_int_G3
;     642 
;     643 	if(TWSR != MTX_DATA_ACK)
	LDS  R26,113
	CPI  R26,LOW(0x28)
	BREQ _0x61
;     644 	{
;     645 		return 0;
	LDI  R30,LOW(0)
	RJMP _0x431
;     646 	}
;     647 		
;     648 	return 255;
_0x61:
	LDI  R30,LOW(255)
	RJMP _0x431
;     649 }
;     650 
;     651 // Чтение байта 
;     652 // Возвращает не 0, если все в порядке
;     653 unsigned char  twi_read (unsigned char notlast)
;     654 {
_twi_read:
;     655 	timeOut ();									// запускаем тайм аут
	RCALL _timeOut
;     656 
;     657 	twi_wait_int();   
	CALL _twi_wait_int_G3
;     658 
;     659 	if(notlast)     // формируем подтверждение приема
	LD   R30,Y
	CPI  R30,0
	BREQ _0x62
;     660 		{
;     661 			TWCR = ((1<<TWINT)+(1<<TWEA)+(1<<TWEN));
	LDI  R30,LOW(196)
	RJMP _0x437
;     662 		}
;     663 		else            // НЕ формируем подтверждение приема
_0x62:
;     664 		{
;     665 			TWCR = ((1<<TWINT)+(1<<TWEN));
	LDI  R30,LOW(132)
_0x437:
	STS  116,R30
;     666 		}
;     667  	twi_wait_int();    
	CALL _twi_wait_int_G3
;     668 
;     669  	timeOutStop ();							// останов таймера таймаута   
	RCALL _timeOutStop
;     670 
;     671 		return TWDR;
	LDS  R30,115
	RJMP _0x431
;     672 }
;     673 
;     674 // Изменение значения бита порта
;     675 static inline void PortBitChange(unsigned char port, unsigned char bnum, unsigned char set)
;     676 {
;     677 	register unsigned char mask;
;     678 	#asm("cli");
;	port -> Y+3
;	bnum -> Y+2
;	set -> Y+1
;	mask -> R16
;     679 
;     680 	mask = 1 << bnum;		// Маска
;     681 	if (!set)
;     682 	{
;     683 		mask ^= 0xFF;
;     684 	}
;     685 		
;     686 	switch(port)
;     687 	{
;     688 	case 'B':
;     689 		if (set) PORTB |= mask; else PORTB &= mask;
;     690 		break;
;     691 	case 'C':
;     692 		if (set) PORTC |= mask; else PORTC &= mask;
;     693 		break;
;     694 	case 'D':
;     695 		if (set) PORTD |= mask; else PORTD &= mask;
;     696 		break;
;     697 	}
;     698 	
;     699 	#asm("sei");
;     700 }
;     701 
;     702 // Передача таблицы из FLASH в I2C
;     703 void i2c_tab (flash unsigned char * tbl, void (* rwfunc)(void))
;     704 {
;     705 	register unsigned char n, p;
;     706 	register flash unsigned char * ptr;
;     707 	
;     708 	while(1)
;	*tbl -> Y+6
;	*rwfunc -> Y+4
;	n -> R16
;	p -> R17
;	*ptr -> R18,R19
;     709 	{
;     710 		if (rwfunc)			// Если нужно, запускаю ожидание готовности
;     711 		{
;     712 			(*rwfunc)();
;     713 		}
;     714 		
;     715 		n = *tbl++;
;     716 		
;     717 		if (!n)				// Если больше нечего передавать ...
;     718 		{
;     719 			return;
;     720 		}
;     721 
;     722 		if (n == 255)		// Если признак бита порта процессора ...
;     723 		{
;     724 			p = *tbl++;						// Порт B, C или D
;     725 			n = *tbl++;						// Номер бита
;     726 			PortBitChange(p, n, *tbl++);	// Взвести или сбросить
;     727 			continue;						// К следующей строке
;     728 		}
;     729 
;     730 		n = n - 2;
;     731 		
;     732 		ptr = tbl;
;     733 		while(1)
;     734 		{
;     735 			if (!twi_start())
;     736 			{
;     737 				twi_stop();
;     738 				continue;
;     739 			}
;     740 	
;     741 			if (!twi_addr(*tbl++))
;     742 			{
;     743 				twi_stop();
;     744 				tbl = ptr;
;     745 				continue;
;     746 			}
;     747 		
;     748 			break;
;     749 		}
;     750 		
;     751 		twi_byte(*tbl++);
;     752 		
;     753 		while(n--)
;     754 		{
;     755 			twi_byte(*tbl++);
;     756 		}
;     757 		
;     758 		twi_stop();
;     759 	}
;     760 }
;     761 
;     762 /*
;     763 // Передача в заданный адрес I2C nbytes байт
;     764 void i2c_bytes (unsigned char addr, unsigned char sbaddr, unsigned char nbytes, ...)
;     765 {
;     766 	va_list argptr;
;     767 	char byt;
;     768 	
;     769 	va_start(argptr, nbytes);
;     770 	
;     771 	while(1)
;     772 	{
;     773 		if (!twi_start())
;     774 		{
;     775 			twi_stop();
;     776 			continue;
;     777 		}
;     778 	
;     779 		if (!twi_addr(addr))
;     780 		{
;     781 			twi_stop();
;     782 			continue;
;     783 		}
;     784 		
;     785 		break;
;     786 	}
;     787 	
;     788 	twi_byte(sbaddr);
;     789 
;     790 	while(nbytes--)
;     791 	{
;     792 		byt = va_arg(argptr, char);
;     793 		twi_byte(byt);
;     794 	}		
;     795 	va_end(argptr);
;     796 		
;     797 	twi_stop();
;     798 }
;     799 */
;     800 
;     801 // Передача в заданный адрес I2C таблицы PSI
;     802 void i2c_psi_table (
;     803 		unsigned char addr,
;     804 		unsigned char sbaddr,
;     805 		unsigned char tblnum,
;     806 		unsigned short pid,
;     807 		unsigned char * buf)
;     808 {
;     809 	unsigned char n;
;     810 	
;     811 	pid &= 0x1FFF;
;	addr -> Y+7
;	sbaddr -> Y+6
;	tblnum -> Y+5
;	pid -> Y+3
;	*buf -> Y+1
;	n -> R16
;     812 	pid |= 0x4000;
;     813 
;     814 	while(1)
;     815 	{	
;     816 		if (!twi_start())
;     817 		{
;     818 			twi_stop();
;     819 			continue;
;     820 		}
;     821 		
;     822 		if (!twi_addr(addr))
;     823 		{
;     824 			twi_stop();
;     825 			continue;
;     826 		}
;     827 		
;     828 		break;
;     829 	}
;     830 		
;     831 	twi_byte(sbaddr);
;     832 	
;     833 	twi_byte(tblnum);
;     834 
;     835 	twi_byte(0x47);			// Заголовок пакета
;     836 	twi_byte(pid >> 8);	
;     837 	twi_byte(pid & 0xFF);	
;     838 	twi_byte(0x10);	
;     839 	twi_byte(0x00);	
;     840 	
;     841 	for (n = buf[2] + 3; n != 0; n --)
;     842 	{
;     843 		twi_byte(*buf++);
;     844 	}
;     845 	
;     846 	twi_stop();
;     847 }
;     848      
;     849 ////////////////////////////////////////////////////////////////////////////////
;     850 // Работа с внутренним каналом
;     851 
;     852 unsigned char tx1crc;

	.DSEG
_tx1crc:
	.BYTE 0x1
;     853 unsigned char rx1state = RX_IDLE;
_rx1state:
	.BYTE 0x1
;     854 unsigned char rx1crc;
_rx1crc:
	.BYTE 0x1
;     855 unsigned char rx1len;
_rx1len:
	.BYTE 0x1
;     856 unsigned char rx1buf[256];
_rx1buf:
	.BYTE 0x100
;     857 unsigned char rx1ptr;
_rx1ptr:
	.BYTE 0x1
;     858 
;     859 /*// Передача байта во "внутренний" канал
;     860 void putword1(unsigned int wd)
;     861 {
;     862 	putchar1(wd);
;     863 	putchar1(wd >> 8);
;     864 } */
;     865 
;     866 // Начало запроса во внутренний канал
;     867 void StartIntReq(unsigned char dlen) 
;     868 {

	.CSEG
_StartIntReq:
;     869 	while(1)
_0x88:
;     870 	{	
;     871 		if (!twi_start())       // Cтарт пакета
	CALL _twi_start
	CPI  R30,0
	BRNE _0x8B
;     872 		{
;     873 			twi_stop();
	CALL _twi_stop
;     874 			continue;
	RJMP _0x88
;     875 		}
;     876 
;     877 		
;     878 		if (!twi_addr(0))       // Передача всем подчиненным
_0x8B:
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _twi_addr
	CPI  R30,0
	BRNE _0x8C
;     879 		{
;     880 			twi_stop();
	CALL _twi_stop
;     881 			continue;
	RJMP _0x88
;     882 		}
;     883 		
;     884 		break;
_0x8C:
;     885 	}
;     886 
;     887 
;     888 	tx1crc = 0;					// Готовлю CRC
	LDI  R30,LOW(0)
	STS  _tx1crc,R30
;     889 
;     890 	twi_byte(PACKHDR);		    // Передаю заголовок
	LDI  R30,LOW(113)
	ST   -Y,R30
	CALL _twi_byte
;     891 	tx1crc+=(PACKHDR);
	LDS  R30,_tx1crc
	SUBI R30,-LOW(113)
	STS  _tx1crc,R30
;     892 
;     893 	twi_byte(dlen+1);			// Передаю длину
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   -Y,R30
	CALL _twi_byte
;     894 	tx1crc+=(dlen+1);
	LD   R30,Y
	SUBI R30,-LOW(1)
	LDS  R26,_tx1crc
	ADD  R30,R26
	STS  _tx1crc,R30
;     895 }
_0x431:
	ADIW R28,1
	RET
;     896 
;     897 // Завершение запроса во внутренний канал
;     898 void EndIntReq(void)
;     899 {
_EndIntReq:
;     900 	twi_byte(tx1crc);			// Контрольная сумма
	LDS  R30,_tx1crc
	ST   -Y,R30
	CALL _twi_byte
;     901 	twi_stop();                 // Cтоп
	CALL _twi_stop
;     902 
;     903 	
;     904 //	rx1state = RX_LEN;			// Приемнику начать прием пакета
;     905 
;     906 //	OCR1B = TCNT1+RX1TIMEOUT;	// Взвожу тайм-аут
;     907 //	TIFR = 0x08;				// Предотвращаю ложное срабатывание
;     908 //	TIMSK |= 0x08;				// Разрешение прерывания по тайм-ауту
;     909 }
	RET
;     910 
;     911 // Прием байта из "внутреннего" канала TWI
;     912 void TWI_rx_isr(void)
;     913 {
;     914 	register unsigned char byt;
;     915 	twi_start();                //Запрашиваю байт ответа
;	byt -> R16
;     916     	
;     917     
;     918 	byt = UDR1;
;     919 	
;     920 	switch (rx1state)
;     921 	{
;     922 	case RX_LEN:				// Принята длина пакета
;     923 		rx1crc = 0;
;     924 		rx1ptr = 0;
;     925 		rx1len = byt - 1;
;     926 		if (rx1len)
;     927 		{
;     928 			rx1state = RX_DATA;
;     929 		}
;     930 		else
;     931 		{
;     932 			rx1state = RX_CRC;
;     933 		}
;     934 //printf("L%d", rx1len);
;     935 		break;
;     936 
;     937 	case RX_DATA:				// Принят байт данных пакета
;     938 //printf("D");
;     939 		rx1buf[rx1ptr++] = byt;
;     940 		if (rx1ptr < rx1len)	// Уже все ?
;     941 		{
;     942 			break;
;     943 		}
;     944 		rx1state = RX_CRC;
;     945 		break;
;     946 		
;     947 	case RX_CRC:				// Принята контрольная сумма пакета
;     948 		if (byt != rx1crc)
;     949 		{
;     950 			rx1state = RX_ERR;	// Не сошлась CRC
;     951 //printf("C");
;     952 		}
;     953 		else
;     954 		{
;     955 			rx1state = RX_OK;	// Пакет успешно принят
;     956 //printf("+");
;     957 		}
;     958 
;     959 		TIMSK &= 0x08 ^ 0xFF;	// Запретить прерывание по тайм-ауту
;     960 		break;
;     961 
;     962 	default:					// В остальных состояниях - ничего не делать
;     963 		break;
;     964 	}
;     965 
;     966 	rx1crc += byt;				// Подсчитываю контрольную сумму
;     967 } 
;     968 
;     969 // Прерывание по сравнению B таймера 1 для подсчета тайм-аута приема "внутреннего" канала
;     970 interrupt [TIM1_COMPB] void timer1_comp_b_isr(void)
;     971 {
_timer1_comp_b_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
;     972 	rx1state = RX_TIME;		// Был тайм-аут
	LDI  R30,LOW(8)
	STS  _rx1state,R30
;     973 	TIMSK &= 0x08 ^ 0xFF;	// Запретить прерывание по тайм-ауту
	IN   R30,0x37
	ANDI R30,0XF7
	OUT  0x37,R30
;     974 //printf("T");
;     975 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;     976 
;     977 // Проверка занятости "внутреннего" канала
;     978 unsigned char InternalComBusy(void)
;     979 {
;     980 	if (rx1state != RX_IDLE)	return 1;
;     981 	else						return 0;
;     982 }
;     983 
;     984 // Признак завершения цикла обмена во внутрю канале
;     985 unsigned char HaveInternalReply(void)
;     986 {
;     987 	switch(rx1state)
;     988 	{
;     989 	case RX_OK:
;     990 	case RX_TIME:
;     991 	case RX_ERR:
;     992 		return rx1state;
;     993 	default:
;     994 		return 0;
;     995 	}
;     996 }
;     997 
;     998 // Необходимо вызвать после завершения обработки принятого по "внутреннему" каналу пакета
;     999 void FreeInternalCom(void)
;    1000 {
;    1001 	rx1state = RX_IDLE;
;    1002 }
;    1003 
;    1004 // Передача байта byte по pAddr
;    1005 unsigned char txTWIbyte (unsigned char pAddr, unsigned char byte)
;    1006 	{  
_txTWIbyte:
;    1007 
;    1008 		timeOut ();									// запускаем тайм аут
	RCALL _timeOut
;    1009 
;    1010 		if (!twi_start())     		  				// Cтарт пакета
	CALL _twi_start
	CPI  R30,0
	BRNE _0xA4
;    1011 			{
;    1012 				twi_stop();
	CALL _twi_stop
;    1013 			}
;    1014 		
;    1015 		if (!twi_addr((pAddr<<1)+0))       // Передача  по адресу pAddr (мл 0 - запись)
_0xA4:
	LDD  R30,Y+1
	LSL  R30
	ST   -Y,R30
	CALL _twi_addr
	CPI  R30,0
	BRNE _0xA5
;    1016 			{
;    1017 				twi_stop();
	CALL _twi_stop
;    1018 			}            
;    1019 			
;    1020 		twi_byte(byte);								// передаем байт
_0xA5:
	LD   R30,Y
	ST   -Y,R30
	CALL _twi_byte
;    1021 		twi_stop();									// стоп пакета
	CALL _twi_stop
;    1022 
;    1023 		timeOutStop ();							// останов таймера таймаута   
	RCALL _timeOutStop
;    1024 		
;    1025 	    if ( ! ( flagTWI & ( 1 << time_is_Out))) return 255;
	LDS  R30,_flagTWI
	ANDI R30,LOW(0x1)
	BRNE _0xA6
	LDI  R30,LOW(255)
	RJMP _0x430
;    1026 	    	else 
_0xA6:
;    1027 	    		{
;    1028 					flagTWI  = flagTWI  ^ (1 << time_is_Out);	//сбрасываем  признак
	LDS  R26,_flagTWI
	LDI  R30,LOW(1)
	EOR  R30,R26
	STS  _flagTWI,R30
;    1029 					return 0;
	LDI  R30,LOW(0)
;    1030 	    		}
;    1031 	}
_0x430:
	ADIW R28,2
	RET
;    1032 
;    1033 unsigned char txTWIbuff (unsigned char pAddr)
;    1034 	{                                                                           
_txTWIbuff:
;    1035 		unsigned char a ;
;    1036 		
;    1037 		timeOut ();									// запускаем тайм аут
	ST   -Y,R16
;	pAddr -> Y+1
;	a -> R16
	RCALL _timeOut
;    1038 		if (!twi_start())     		  				// Cтарт пакета
	CALL _twi_start
	CPI  R30,0
	BRNE _0xA8
;    1039 			{
;    1040 				twi_stop();
	CALL _twi_stop
;    1041 			}
;    1042 
;    1043 		if (!twi_addr((pAddr<<1)+0))       // Передача  по адресу pAddr (мл 0 - запись)
_0xA8:
	LDD  R30,Y+1
	LSL  R30
	ST   -Y,R30
	CALL _twi_addr
	CPI  R30,0
	BRNE _0xA9
;    1044 			{
;    1045 				twi_stop();
	CALL _twi_stop
;    1046 			}            
;    1047 
;    1048 	twi_wait_int(); 					// ждем отклик на адрес
_0xA9:
	CALL _twi_wait_int_G3
;    1049 
;    1050 		for (a=0;a<=txBuffer[1]+1;a++)     //длина+заголовок
	LDI  R16,LOW(0)
_0xAB:
	__GETB1MN _txBuffer,1
	SUBI R30,-LOW(1)
	CP   R30,R16
	BRLO _0xAC
;    1051 			{		                         
;    1052 				twi_byte(txBuffer[a]);				// передаем байт
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	LD   R30,Z
	ST   -Y,R30
	CALL _twi_byte
;    1053 			}		
	SUBI R16,-1
	RJMP _0xAB
_0xAC:
;    1054 
;    1055 			twi_stop();									// стоп пакета
	CALL _twi_stop
;    1056 			timeOutStop ();							// останов таймера таймаута   
	RCALL _timeOutStop
;    1057 		
;    1058 	    	if ( ! ( flagTWI & ( 1 << time_is_Out))) return 255;
	LDS  R30,_flagTWI
	ANDI R30,LOW(0x1)
	BRNE _0xAD
	LDI  R30,LOW(255)
	RJMP _0x42E
;    1059 	    		else 
_0xAD:
;    1060 	    			{
;    1061 						flagTWI  = flagTWI  ^ (1 << time_is_Out);	//сбрасываем  признак
	LDS  R26,_flagTWI
	LDI  R30,LOW(1)
	EOR  R30,R26
	STS  _flagTWI,R30
;    1062 						return 0;
	LDI  R30,LOW(0)
	RJMP _0x42E
;    1063 		    		}
;    1064 	}
;    1065 	
;    1066 
;    1067 // Вычитываем в буффер
;    1068 unsigned char rxTWIbuff (unsigned char pAddr)
;    1069 		{                                                         
_rxTWIbuff:
;    1070 		unsigned char a;
;    1071 
;    1072 		if (!twi_start())     		  				// Cтарт пакета
	ST   -Y,R16
;	pAddr -> Y+1
;	a -> R16
	CALL _twi_start
	CPI  R30,0
	BRNE _0xAF
;    1073 			{
;    1074 				twi_stop();
	CALL _twi_stop
;    1075 			}
;    1076 
;    1077 		if (!twi_addr((pAddr<<1)+1))       // Передача  по адресу pAddr (мл 1 - чтение)
_0xAF:
	LDD  R30,Y+1
	LSL  R30
	SUBI R30,-LOW(1)
	ST   -Y,R30
	CALL _twi_addr
	CPI  R30,0
	BRNE _0xB0
;    1078 			{
;    1079 				twi_stop();
	CALL _twi_stop
;    1080 			}            
;    1081 
;    1082 		rxBuffer[0] = twi_read(1);				// читаем  и запоминаем  длину принимаемого пакета
_0xB0:
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _twi_read
	STS  _rxBuffer,R30
;    1083 
;    1084 		for (a=1; a<rxBuffer[0];  a++)
	LDI  R16,LOW(1)
_0xB2:
	LDS  R30,_rxBuffer
	CP   R16,R30
	BRSH _0xB3
;    1085 			{
;    1086 				rxBuffer[a] = twi_read(1);			// не посл. байт - формируем ACK
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
;    1087 			}              
	SUBI R16,-1
	RJMP _0xB2
_0xB3:
;    1088 
;    1089 				rxBuffer[a] = twi_read(0);			// посл. байт -  не формируем ACK
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
;    1090 
;    1091 			twi_stop();									// стоп пакета               
	CALL _twi_stop
;    1092 			
;    1093 						// Проверяем таймаут и CRC
;    1094 	    	if ( (! ( flagTWI & ( 1 << time_is_Out))) && (rxCRC())) return 255;	//Ok
	LDS  R30,_flagTWI
	ANDI R30,LOW(0x1)
	BRNE _0xB5
	RCALL _rxCRC
	CPI  R30,0
	BRNE _0xB6
_0xB5:
	RJMP _0xB4
_0xB6:
	LDI  R30,LOW(255)
	RJMP _0x42E
;    1095     		else 
_0xB4:
;    1096 	    			{
;    1097 						flagTWI  = flagTWI  ^ (1 << time_is_Out);		//сбрасываем  признак
	LDS  R26,_flagTWI
	LDI  R30,LOW(1)
	EOR  R30,R26
	STS  _flagTWI,R30
;    1098 						return 0;                                                          // Time Out
	LDI  R30,LOW(0)
	RJMP _0x42E
;    1099 		    		}
;    1100 		}
;    1101 #include "Coding.h"
;    1102 
;    1103 unsigned char flagTWI				=	0;

	.DSEG
_flagTWI:
	.BYTE 0x1
;    1104 unsigned char int_Devices		=	0;			// количество подчиненных устройств
_int_Devices:
	.BYTE 0x1
;    1105 
;    1106 
;    1107 
;    1108 // Инициализация выводов
;    1109 void portInit (void)
;    1110 		{

	.CSEG
_portInit:
;    1111 			DDRB.7 = 1;		// testpin
	SBI  0x17,7
;    1112 			CS_DDR_SET();	// для CF Card
	SBI  0x17,4
;    1113 		}
	RET
;    1114 
;    1115 
;    1116 
;    1117 // -------------------- Функции работы с таймером 0 -------------------------------
;    1118 ///////////////////////////////////////////////////////////////////////////////////////////////
;    1119 // Timer/Counter 0 initialization ; Clock source: System Clock
;    1120 // Clock value: 31,250 kHz ;  Mode: Normal top=FFh
;    1121 ///////////////////////////////////////////////////////////////////////////////////////////////
;    1122 void timer_0_Init  (void)
;    1123 	{
_timer_0_Init:
;    1124 		ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;    1125 		TCCR0=0x0;        //0x06 -start
	OUT  0x33,R30
;    1126 		TCNT0=0x01;
	LDI  R30,LOW(1)
	OUT  0x32,R30
;    1127 		OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x31,R30
;    1128 
;    1129 		TIMSK=0x01;			// Timer(s)/Counter(s) Interrupt(s) initialization
	LDI  R30,LOW(1)
	OUT  0x37,R30
;    1130 		ETIMSK=0x00;
	LDI  R30,LOW(0)
	STS  125,R30
;    1131 
;    1132 	}
	RET
;    1133 
;    1134 // запускаем таймер для таймаута
;    1135 void timeOut (void)
;    1136 	{
_timeOut:
;    1137 //		flagTWI  = (flagTWI  ^ (1 << time_is_Out));		// сброс признака
;    1138 		TCNT0=0x0	;														// обнуляем счетчик
	LDI  R30,LOW(0)
	OUT  0x32,R30
;    1139 		TCCR0 = 0x06;													// пускаем таймер (около 10 мс)
	LDI  R30,LOW(6)
	OUT  0x33,R30
;    1140 	}
	RET
;    1141 
;    1142 // остановка таймера для таймаута
;    1143 void timeOutStop (void)
;    1144 	{
_timeOutStop:
;    1145 		TCCR0 = 0x0; 						// осттанов таймера (около 10 мс)
	LDI  R30,LOW(0)
	OUT  0x33,R30
;    1146 	}
	RET
;    1147 
;    1148 
;    1149 // Timer 0 overflow interrupt service routine
;    1150 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;    1151 {
_timer0_ovf_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
;    1152 		TCCR0 = 0x0;						//останавливаем таймер
	LDI  R30,LOW(0)
	OUT  0x33,R30
;    1153 		flagTWI  = flagTWI  | (1 << time_is_Out);	 //взводим признак    
	LDS  R30,_flagTWI
	ORI  R30,1
	STS  _flagTWI,R30
;    1154 
;    1155 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;    1156                                                                                              
;    1157 // Проверяем количество подчиненных устройств
;    1158 void verIntDev (void)
;    1159 	{
_verIntDev:
;    1160 		unsigned char a;
;    1161 		for (a=1; a<10;a++)				// сканируем количество подчиненных устройств 
	ST   -Y,R16
;	a -> R16
	LDI  R16,LOW(1)
_0xB9:
	CPI  R16,10
	BRSH _0xBA
;    1162 			{											//  адреса начинаются с 1
;    1163 				if (!(txTWIbyte ( a, 0xaa))) break;   
	ST   -Y,R16
	LDI  R30,LOW(170)
	ST   -Y,R30
	CALL _txTWIbyte
	CPI  R30,0
	BREQ _0xBA
;    1164 			}
	SUBI R16,-1
	RJMP _0xB9
_0xBA:
;    1165         int_Devices = a-1;
	MOV  R30,R16
	SUBI R30,LOW(1)
	STS  _int_Devices,R30
;    1166 		lAddrDevice[0] = lAddrDevice;	// запоминаем кол-во портов 232
	LDI  R30,LOW(_lAddrDevice)
	LDI  R31,HIGH(_lAddrDevice)
	STS  _lAddrDevice,R30
;    1167 	}     
	RJMP _0x42D
;    1168 	
;    1169 // считаем КС принятого пакета
;    1170 unsigned char rxCRC (void)
;    1171 	{                    
_rxCRC:
;    1172 		unsigned char KS = 0, a;		
;    1173 			for (a=0; a< rxBuffer [0] ;a++)
	ST   -Y,R17
	ST   -Y,R16
;	KS -> R16
;	a -> R17
	LDI  R16,0
	LDI  R17,LOW(0)
_0xBD:
	LDS  R30,_rxBuffer
	CP   R17,R30
	BRSH _0xBE
;    1174 				{
;    1175 					KS =KS+rxBuffer [a];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_rxBuffer)
	SBCI R31,HIGH(-_rxBuffer)
	LD   R30,Z
	ADD  R16,R30
;    1176 				}                                     
	SUBI R17,-1
	RJMP _0xBD
_0xBE:
;    1177 			if (KS == rxBuffer [a]) return 255; 	//Ok
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_rxBuffer)
	SBCI R31,HIGH(-_rxBuffer)
	LD   R30,Z
	CP   R30,R16
	BRNE _0xBF
	LDI  R30,LOW(255)
	RJMP _0x42F
;    1178 			else return 0;                                         // Error
_0xBF:
	LDI  R30,LOW(0)
;    1179 		
;    1180 	}	        
_0x42F:
	LD   R16,Y+
	LD   R17,Y+
	RET
;    1181 
;    1182 // вычитываем логические адреса устройств
;    1183 void ReadLogAddr (void)
;    1184 		{          
_ReadLogAddr:
;    1185 		unsigned char b;
;    1186 		
;    1187 					txBuffer[0] = 'q';								// заголовок
	ST   -Y,R16
;	b -> R16
	LDI  R30,LOW(113)
	STS  _txBuffer,R30
;    1188 					txBuffer[1] = 3;		                 		// длина
	LDI  R30,LOW(3)
	__PUTB1MN _txBuffer,1
;    1189 					txBuffer[2] = 0;                   		// адрес
	LDI  R30,LOW(0)
	__PUTB1MN _txBuffer,2
;    1190 					txBuffer[3] = GetLogAddr;       		// тип
	LDI  R30,LOW(1)
	__PUTB1MN _txBuffer,3
;    1191 					txBuffer[4] = 'q'+3+0+GetLogAddr; 		//KC
	LDI  R30,LOW(117)
	__PUTB1MN _txBuffer,4
;    1192 
;    1193 					txTWIbuff (0);		//передаем всем
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _txTWIbuff
;    1194 //					delay_ms (20);          
;    1195 					delay_ms (5);          
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
;    1196 
;    1197 for (b=1; b<= int_Devices; b++)
	LDI  R16,LOW(1)
_0xC2:
	LDS  R30,_int_Devices
	CP   R30,R16
	BRLO _0xC3
;    1198 	{
;    1199 //					txTWIbuff (b);		//передаем 
;    1200 //					delay_ms (10);          
;    1201 					rxTWIbuff (b);
	ST   -Y,R16
	CALL _rxTWIbuff
;    1202 					lAddrDevice [b] = rxBuffer[1];		// запоминаем лог. адреса портов       
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_lAddrDevice)
	SBCI R27,HIGH(-_lAddrDevice)
	__GETB1MN _rxBuffer,1
	ST   X,R30
;    1203      }
	SUBI R16,-1
	RJMP _0xC2
_0xC3:
;    1204 				
;    1205 }  
	RJMP _0x42D
;    1206 
;    1207 // ретранслируем пакет
;    1208 void		recompPack (unsigned char device)
;    1209 	{
_recompPack:
;    1210 		unsigned char a, b=0;
;    1211 					txBuffer[0] = PACKHDR;				// заголовок
	ST   -Y,R17
	ST   -Y,R16
;	device -> Y+2
;	a -> R16
;	b -> R17
	LDI  R17,0
	LDI  R30,LOW(113)
	STS  _txBuffer,R30
;    1212 					txBuffer[1] = rx0len+3;            		// длина (+3 - тк. вычлось при приеме)
	MOV  R30,R13
	SUBI R30,-LOW(3)
	__PUTB1MN _txBuffer,1
;    1213 					txBuffer[2] = rx0addr;                 	// адрес
	__POINTW2MN _txBuffer,2
	LDS  R30,_rx0addr
	ST   X,R30
;    1214 					txBuffer[3] = rx0type;					// тип
	__PUTBMRN _txBuffer,3,14
;    1215 
;    1216 					for (a=4; a<=(rx0len+4); a++)
	LDI  R16,LOW(4)
_0xC5:
	MOV  R30,R13
	SUBI R30,-LOW(4)
	CP   R30,R16
	BRLO _0xC6
;    1217 						{
;    1218 							txBuffer[a] = rx0buf 	[b++];				
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
;    1219 						}                   
	SUBI R16,-1
	RJMP _0xC5
_0xC6:
;    1220 
;    1221 					txTWIbuff (device);								//передаем 
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _txTWIbuff
;    1222 					delay_ms (10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
;    1223 
;    1224 
;    1225 	}
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
;    1226 	
;    1227 // пингуем подчиненное для проверки информации
;    1228 void pingPack (unsigned char device)
;    1229 	{
_pingPack:
;    1230 	unsigned char a;
;    1231 			
;    1232 /*					txBuffer[0] = 'q';									// заголовок
;    1233 					txBuffer[1] = 3;                 					// длина
;    1234 					txBuffer[2] = 0;                   				// адрес
;    1235 					txBuffer[3] = pingPacket;       				// тип
;    1236 					txBuffer[4] = 'q'+3+0+pingPacket; 		// KC
;    1237 
;    1238 					txTWIbuff (device);								// передаем 
;    1239 
;    1240 //					delay_ms (20);          */
;    1241 //					delay_ms (10);          
;    1242 
;    1243 					rxTWIbuff (device);                  			// принимаем
	ST   -Y,R16
;	device -> Y+1
;	a -> R16
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _rxTWIbuff
;    1244 
;    1245 					if (rxBuffer[0] )
	LDS  R30,_rxBuffer
	CPI  R30,0
	BREQ _0xC7
;    1246 						{
;    1247 						UCSR0B.3 = 1;								// Разрешаю передатчик
	SBI  0xA,3
;    1248                             	for (a=0;a<=rxBuffer[0];a++)
	LDI  R16,LOW(0)
_0xC9:
	LDS  R30,_rxBuffer
	CP   R30,R16
	BRLO _0xCA
;    1249 									{
;    1250 										putchar0 (rxBuffer [a]);
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_rxBuffer)
	SBCI R31,HIGH(-_rxBuffer)
	LD   R30,Z
	ST   -Y,R30
	CALL _putchar0
;    1251 									}     
	SUBI R16,-1
	RJMP _0xC9
_0xCA:
;    1252 						rx0state = RX_HDR;					// Разрешаю прием след. запроса
	LDI  R30,LOW(1)
	MOV  R11,R30
;    1253 						
;    1254 						}          
;    1255 	
;    1256 	
;    1257 	}
_0xC7:
_0x42E:
	LDD  R16,Y+0
	ADIW R28,2
	RET
;    1258 	
;    1259 
;    1260 	
;    1261 	
;    1262 
;    1263 
;    1264 #include "Coding.h"
;    1265 
;    1266 void flash_Work (void)
;    1267 	{  
_flash_Work:
;    1268 		unsigned char a;
;    1269 		switch(rx0buf[0])
	ST   -Y,R16
;	a -> R16
	LDS  R30,_rx0buf
;    1270 			{
;    1271 				case PT_Fcreate: 		// создать и открыть файл
	CPI  R30,LOW(0x1)
	BRNE _0xCE
;    1272 					{       
;    1273 LedRed();
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,0
	SBI  0x1B,1
;    1274 
;    1275 						pntr1 = fcreate(str->fname, 0); 
	MOVW R30,R4
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _fcreate
	MOVW R8,R30
;    1276 
;    1277 						if (!(pntr1)) putchar (0); 						// если не могу создать файл то возращаем 0
	MOV  R0,R8
	OR   R0,R9
	BRNE _0xCF
	LDI  R30,LOW(0)
	RJMP _0x438
;    1278 						else putchar (0x255);
_0xCF:
	LDI  R30,LOW(597)
_0x438:
	ST   -Y,R30
	CALL _putchar
;    1279 
;    1280 //						fputc('S', pntr1);      // write an ‘S’ to the file, increment file pointer */ 
;    1281 //						fputs(str->fname, pntr1);    // add “Hello World!\r\n” to the end of the file 
;    1282  
;    1283 						break;
	RJMP _0xCD
;    1284 					}
;    1285 				case PT_Fopen: 		// открыть файл
_0xCE:
	CPI  R30,LOW(0x2)
	BREQ _0xCD
;    1286 					{       
;    1287 					
;    1288 						break;
;    1289 					}
;    1290 
;    1291 				case PT_Fclose:
	CPI  R30,LOW(0x3)
	BRNE _0xD2
;    1292 					{
;    1293 LedRed();
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,0
	SBI  0x1B,1
;    1294 					    fclose(pntr1);     							   	// Close          
	ST   -Y,R9
	ST   -Y,R8
	CALL _fclose
;    1295 
;    1296 						if (!(pntr1)) putchar (0); 						// если не могу создать файл то возращаем 0
	MOV  R0,R8
	OR   R0,R9
	BRNE _0xD3
	LDI  R30,LOW(0)
	RJMP _0x439
;    1297 						else putchar (0x255);
_0xD3:
	LDI  R30,LOW(597)
_0x439:
	ST   -Y,R30
	CALL _putchar
;    1298 						break;
	RJMP _0xCD
;    1299 					}
;    1300 
;    1301 				case PT_Fremove:
_0xD2:
	CPI  R30,LOW(0x4)
	BREQ _0xCD
;    1302 					{
;    1303 						break;
;    1304 					}
;    1305 
;    1306 				case PT_Frename:
	CPI  R30,LOW(0x5)
	BREQ _0xCD
;    1307 					{
;    1308 						break;
;    1309 					}
;    1310 
;    1311 				case PT_Ffseek:
	CPI  R30,LOW(0x6)
	BREQ _0xCD
;    1312 					{
;    1313 						break;
;    1314 					}
;    1315 
;    1316 				case PT_Fformat:
	CPI  R30,LOW(0x7)
	BRNE _0xD8
;    1317 					{
;    1318 						fquickformat();    			// Delete all information on the card 
	CALL _fquickformat
;    1319 						break;
	RJMP _0xCD
;    1320 					}
;    1321 
;    1322 				case PT_Fadd:
_0xD8:
	CPI  R30,LOW(0x8)
	BRNE _0xCD
;    1323 					{
;    1324 LedRed();
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,0
	SBI  0x1B,1
;    1325 //						fputs(str1->dataFlash, pntr1);    // add “Hello World!\r\n” to the end of the file 
;    1326 //						fprintf(pntr1, "%x",11);  			// output the string to the file
;    1327 
;    1328 //						strcpyf (a,0x31);
;    1329 						fflush (pntr1);
	ST   -Y,R9
	ST   -Y,R8
	CALL _fflush
;    1330 
;    1331 						if (!(pntr1)) putchar (0); 						// если не могу создать файл то возращаем 0
	MOV  R0,R8
	OR   R0,R9
	BRNE _0xDA
	LDI  R30,LOW(0)
	RJMP _0x43A
;    1332 						else putchar (0x255);
_0xDA:
	LDI  R30,LOW(597)
_0x43A:
	ST   -Y,R30
	CALL _putchar
;    1333 						break;
;    1334 					}
;    1335 
;    1336     		}
_0xCD:
;    1337 	rx0state = RX_HDR;						// Разрешаю прием след. запроса
	LDI  R30,LOW(1)
	MOV  R11,R30
;    1338 	}
_0x42D:
	LD   R16,Y+
	RET
;    1339 
;    1340 
;    1341 
;    1342 	
;    1343 /*
;    1344 	Progressive Resources LLC
;    1345                                     
;    1346 			FlashFile
;    1347 	
;    1348 	Version : 	1.32
;    1349 	Date: 		12/31/2003
;    1350 	Author: 	Erick M. Higa
;    1351                                            
;    1352 	Software License
;    1353 	The use of Progressive Resources LLC FlashFile Source Package indicates 
;    1354 	your understanding and acceptance of the following terms and conditions. 
;    1355 	This license shall supersede any verbal or prior verbal or written, statement 
;    1356 	or agreement to the contrary. If you do not understand or accept these terms, 
;    1357 	or your local regulations prohibit "after sale" license agreements or limited 
;    1358 	disclaimers, you must cease and desist using this product immediately.
;    1359 	This product is © Copyright 2003 by Progressive Resources LLC, all rights 
;    1360 	reserved. International copyright laws, international treaties and all other 
;    1361 	applicable national or international laws protect this product. This software 
;    1362 	product and documentation may not, in whole or in part, be copied, photocopied, 
;    1363 	translated, or reduced to any electronic medium or machine readable form, without 
;    1364 	prior consent in writing, from Progressive Resources LLC and according to all 
;    1365 	applicable laws. The sole owner of this product is Progressive Resources LLC.
;    1366 
;    1367 	Operating License
;    1368 	You have the non-exclusive right to use any enclosed product but have no right 
;    1369 	to distribute it as a source code product without the express written permission 
;    1370 	of Progressive Resources LLC. Use over a "local area network" (within the same 
;    1371 	locale) is permitted provided that only a single person, on a single computer 
;    1372 	uses the product at a time. Use over a "wide area network" (outside the same 
;    1373 	locale) is strictly prohibited under any and all circumstances.
;    1374                                            
;    1375 	Liability Disclaimer
;    1376 	This product and/or license is provided as is, without any representation or 
;    1377 	warranty of any kind, either express or implied, including without limitation 
;    1378 	any representations or endorsements regarding the use of, the results of, or 
;    1379 	performance of the product, Its appropriateness, accuracy, reliability, or 
;    1380 	correctness. The user and/or licensee assume the entire risk as to the use of 
;    1381 	this product. Progressive Resources LLC does not assume liability for the use 
;    1382 	of this product beyond the original purchase price of the software. In no event 
;    1383 	will Progressive Resources LLC be liable for additional direct or indirect 
;    1384 	damages including any lost profits, lost savings, or other incidental or 
;    1385 	consequential damages arising from any defects, or the use or inability to 
;    1386 	use these products, even if Progressive Resources LLC have been advised of 
;    1387 	the possibility of such damages.
;    1388 */                                 
;    1389 
;    1390 /*
;    1391 #include _AVR_LIB_
;    1392 #include <stdio.h>
;    1393 
;    1394 #ifndef _file_sys_h_
;    1395 	#include "..\flash\file_sys.h"
;    1396 #endif
;    1397 */
;    1398 	#include <coding.h>
;    1399 
;    1400 unsigned long OCR_REG;

	.DSEG
_OCR_REG:
	.BYTE 0x4
;    1401 unsigned char _FF_buff[512];
__FF_buff:
	.BYTE 0x200
;    1402 unsigned int PT_SecStart;
_PT_SecStart:
	.BYTE 0x2
;    1403 unsigned long BS_jmpBoot;
_BS_jmpBoot:
	.BYTE 0x4
;    1404 unsigned int BPB_BytsPerSec;
_BPB_BytsPerSec:
	.BYTE 0x2
;    1405 unsigned char BPB_SecPerClus;
_BPB_SecPerClus:
	.BYTE 0x1
;    1406 unsigned int BPB_RsvdSecCnt;
_BPB_RsvdSecCnt:
	.BYTE 0x2
;    1407 unsigned char BPB_NumFATs;
_BPB_NumFATs:
	.BYTE 0x1
;    1408 unsigned int BPB_RootEntCnt;
_BPB_RootEntCnt:
	.BYTE 0x2
;    1409 unsigned int BPB_FATSz16;
_BPB_FATSz16:
	.BYTE 0x2
;    1410 unsigned char BPB_FATType;
_BPB_FATType:
	.BYTE 0x1
;    1411 unsigned long BPB_TotSec;
_BPB_TotSec:
	.BYTE 0x4
;    1412 unsigned long BS_VolSerial;
_BS_VolSerial:
	.BYTE 0x4
;    1413 unsigned char BS_VolLab[12];
_BS_VolLab:
	.BYTE 0xC
;    1414 unsigned long _FF_PART_ADDR, _FF_ROOT_ADDR, _FF_DIR_ADDR;
__FF_PART_ADDR:
	.BYTE 0x4
__FF_ROOT_ADDR:
	.BYTE 0x4
__FF_DIR_ADDR:
	.BYTE 0x4
;    1415 unsigned long _FF_FAT1_ADDR, _FF_FAT2_ADDR;
__FF_FAT1_ADDR:
	.BYTE 0x4
__FF_FAT2_ADDR:
	.BYTE 0x4
;    1416 unsigned long _FF_RootDirSectors;
__FF_RootDirSectors:
	.BYTE 0x4
;    1417 unsigned int FirstDataSector;
_FirstDataSector:
	.BYTE 0x2
;    1418 unsigned long FirstSectorofCluster;
_FirstSectorofCluster:
	.BYTE 0x4
;    1419 unsigned char _FF_error;
__FF_error:
	.BYTE 0x1
;    1420 unsigned long _FF_buff_addr;
__FF_buff_addr:
	.BYTE 0x4
;    1421 extern unsigned long clus_0_addr, _FF_n_temp;
;    1422 extern unsigned int c_counter;
;    1423 //extern unsigned char _FF_FULL_PATH[_FF_PATH_LENGTH];
;    1424 
;    1425 unsigned long DataClusTot;
_DataClusTot:
	.BYTE 0x4
;    1426 
;    1427 flash struct CMD
;    1428 {
;    1429 	unsigned int index;
;    1430 	unsigned int tx_data;
;    1431 	unsigned int arg;
;    1432 	unsigned int resp;
;    1433 };
;    1434 
;    1435 flash struct CMD sd_cmd[CMD_TOT] =

	.CSEG
;    1436 {
;    1437 	{CMD0,	0x40,	NO_ARG,		RESP_1},		// GO_IDLE_STATE
;    1438 	{CMD1,	0x41,	NO_ARG,		RESP_1},		// SEND_OP_COND (ACMD41 = 0x69)
;    1439 	{CMD9,	0x49,	NO_ARG,		RESP_1},		// SEND_CSD
;    1440 	{CMD10,	0x4A,	NO_ARG,		RESP_1},		// SEND_CID
;    1441 	{CMD12,	0x4C,	NO_ARG,		RESP_1},		// STOP_TRANSMISSION
;    1442 	{CMD13,	0x4D,	NO_ARG,		RESP_2},		// SEND_STATUS
;    1443 	{CMD16,	0x50,	BLOCK_LEN,	RESP_1},		// SET_BLOCKLEN
;    1444 	{CMD17, 0x51,	DATA_ADDR,	RESP_1},		// READ_SINGLE_BLOCK
;    1445 	{CMD18, 0x52,	DATA_ADDR,	RESP_1},		// READ_MULTIPLE_BLOCK
;    1446 	{CMD24, 0x58,	DATA_ADDR,	RESP_1},		// WRITE_BLOCK
;    1447 	{CMD25, 0x59,	DATA_ADDR,	RESP_1},		// WRITE_MULTIPLE_BLOCK
;    1448 	{CMD27,	0x5B,	NO_ARG,		RESP_1},		// PROGRAM_CSD
;    1449 	{CMD28, 0x5C,	DATA_ADDR,	RESP_1b},		// SET_WRITE_PROT
;    1450 	{CMD29, 0x5D,	DATA_ADDR,	RESP_1b},		// CLR_WRITE_PROT
;    1451 	{CMD30, 0x5E,	DATA_ADDR,	RESP_1},		// SEND_WRITE_PROT
;    1452 	{CMD32,	0x60,	DATA_ADDR,	RESP_1},		// TAG_SECTOR_START
;    1453 	{CMD33,	0x61,	DATA_ADDR,	RESP_1},		// TAG_SECTOR_END
;    1454 	{CMD34,	0x62,	DATA_ADDR,	RESP_1},		// UNTAG_SECTOR
;    1455 	{CMD35,	0x63,	DATA_ADDR,	RESP_1},		// TAG_ERASE_GROUP_START
;    1456 	{CMD36,	0x64,	DATA_ADDR,	RESP_1},		// TAG_ERASE_GROUP_END
;    1457 	{CMD37,	0x65,	DATA_ADDR,	RESP_1},		// TAG_ERASE_GROUP
;    1458 	{CMD38,	0x66,	STUFF_BITS,	RESP_1b},		// ERASE
;    1459 	{CMD42,	0x6A,	STUFF_BITS,	RESP_1b},		// LOCK_UNLOCK
;    1460 	{CMD58,	0x7A,	NO_ARG,		RESP_3},		// READ_OCR
;    1461 	{CMD59,	0x7B,	STUFF_BITS,	RESP_1},		// CRC_ON_OFF
;    1462 	{ACMD41, 0x69,	NO_ARG,		RESP_1}
;    1463 };
;    1464 
;    1465 unsigned char _FF_spi(unsigned char mydata)
;    1466 {
__FF_spi:
;    1467     SPDR = mydata;          //byte 1
	LD   R30,Y
	OUT  0xF,R30
;    1468     while ((SPSR&0x80) == 0); 
_0xDC:
	SBIS 0xE,7
	RJMP _0xDC
;    1469     return SPDR;
	IN   R30,0xF
	RJMP _0x427
;    1470 }
;    1471 	
;    1472 unsigned int send_cmd(unsigned char command, unsigned long argument)
;    1473 {
_send_cmd:
;    1474 	unsigned char spi_data_out;
;    1475 	unsigned char response_1;
;    1476 	unsigned long response_2;
;    1477 	unsigned int c, i;
;    1478 	
;    1479 	SD_CS_ON();			// select chip
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
;    1480 	
;    1481 	spi_data_out = sd_cmd[command].tx_data;
	LDD  R26,Y+14
	CLR  R27
	__POINTWRFN 22,23,_sd_cmd,2
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __MULW12U
	ADD  R30,R22
	ADC  R31,R23
	LPM  R16,Z
;    1482 	_FF_spi(spi_data_out);
	ST   -Y,R16
	CALL __FF_spi
;    1483 	
;    1484 	c = sd_cmd[command].arg;
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
;    1485 	if (c == NO_ARG)
	MOV  R0,R18
	OR   R0,R19
	BRNE _0xDF
;    1486 		for (i=0; i<4; i++)
	__GETWRN 20,21,0
_0xE1:
	__CPWRN 20,21,4
	BRSH _0xE2
;    1487 			_FF_spi(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL __FF_spi
;    1488 	else
	__ADDWRN 20,21,1
	RJMP _0xE1
_0xE2:
	RJMP _0xE3
_0xDF:
;    1489 	{
;    1490 		spi_data_out = (argument & 0xFF000000) >> 24;
	__GETD1S 10
	__ANDD1N 0xFF000000
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(24)
	CALL __LSRD12
	MOV  R16,R30
;    1491 		_FF_spi(spi_data_out);
	ST   -Y,R16
	CALL __FF_spi
;    1492 		spi_data_out = (argument & 0x00FF0000) >> 16;
	__GETD1S 10
	__ANDD1N 0xFF0000
	CALL __LSRD16
	MOV  R16,R30
;    1493 		_FF_spi(spi_data_out);
	ST   -Y,R16
	CALL __FF_spi
;    1494 		spi_data_out = (argument & 0x0000FF00) >> 8;
	__GETD1S 10
	__ANDD1N 0xFF00
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(8)
	CALL __LSRD12
	MOV  R16,R30
;    1495 		_FF_spi(spi_data_out);
	ST   -Y,R16
	CALL __FF_spi
;    1496 		spi_data_out = (argument & 0x000000FF);
	__GETD1S 10
	__ANDD1N 0xFF
	MOV  R16,R30
;    1497 		_FF_spi(spi_data_out);
	ST   -Y,R16
	CALL __FF_spi
;    1498 	}
_0xE3:
;    1499 	if (command == CMD0)
	LDD  R30,Y+14
	CPI  R30,0
	BRNE _0xE4
;    1500 		spi_data_out = 0x95;		// CRC byte, don't care except for first signal=0x95
	LDI  R16,LOW(149)
;    1501 	else
	RJMP _0xE5
_0xE4:
;    1502 		spi_data_out = 0xFF;
	LDI  R16,LOW(255)
;    1503 	_FF_spi(spi_data_out);
_0xE5:
	ST   -Y,R16
	CALL __FF_spi
;    1504 	_FF_spi(0xff);	
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
;    1505 	c = sd_cmd[command].resp;
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
;    1506 	switch(c)
	MOVW R30,R18
;    1507 	{
;    1508 		case RESP_1:
	SBIW R30,0
	BRNE _0xE9
;    1509 			return (_FF_spi(0xFF));
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	LDI  R31,0
	RJMP _0x42C
;    1510 			break;
;    1511 		case RESP_1b:
_0xE9:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xEA
;    1512 			response_1 = _FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	MOV  R17,R30
;    1513 			response_2 = 0;
	__CLRD1S 6
;    1514 			while (response_2 == 0)
_0xEB:
	__GETD1S 6
	CALL __CPD10
	BRNE _0xED
;    1515 				response_2 = _FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	CLR  R31
	CLR  R22
	CLR  R23
	__PUTD1S 6
;    1516 			return (response_1);
	RJMP _0xEB
_0xED:
	MOV  R30,R17
	LDI  R31,0
	RJMP _0x42C
;    1517 			break;
;    1518 		case RESP_2:
_0xEA:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xEE
;    1519 			response_2 = _FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	CLR  R31
	CLR  R22
	CLR  R23
	__PUTD1S 6
;    1520 			response_2 = (response_2 << 8) | _FF_spi(0xFF);
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
;    1521 			return (response_2);
	RJMP _0x42C
;    1522 			break;
;    1523 		case RESP_3:
_0xEE:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0xE8
;    1524 			response_1 = _FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	MOV  R17,R30
;    1525 			OCR_REG = 0;
	LDI  R30,0
	STS  _OCR_REG,R30
	STS  _OCR_REG+1,R30
	STS  _OCR_REG+2,R30
	STS  _OCR_REG+3,R30
;    1526 			response_2 = _FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	CLR  R31
	CLR  R22
	CLR  R23
	__PUTD1S 6
;    1527 			OCR_REG = response_2 << 24;
	__GETD2S 6
	LDI  R30,LOW(24)
	CALL __LSLD12
	STS  _OCR_REG,R30
	STS  _OCR_REG+1,R31
	STS  _OCR_REG+2,R22
	STS  _OCR_REG+3,R23
;    1528 			response_2 = _FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	CLR  R31
	CLR  R22
	CLR  R23
	__PUTD1S 6
;    1529 			OCR_REG |= (response_2 << 16);
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
;    1530 			response_2 = _FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	CLR  R31
	CLR  R22
	CLR  R23
	__PUTD1S 6
;    1531 			OCR_REG |= (response_2 << 8);
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
;    1532 			response_2 = _FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	CLR  R31
	CLR  R22
	CLR  R23
	__PUTD1S 6
;    1533 			OCR_REG |= (response_2);
	LDS  R26,_OCR_REG
	LDS  R27,_OCR_REG+1
	LDS  R24,_OCR_REG+2
	LDS  R25,_OCR_REG+3
	CALL __ORD12
	STS  _OCR_REG,R30
	STS  _OCR_REG+1,R31
	STS  _OCR_REG+2,R22
	STS  _OCR_REG+3,R23
;    1534 			return (response_1);
	MOV  R30,R17
	LDI  R31,0
	RJMP _0x42C
;    1535 			break;
;    1536 	}
_0xE8:
;    1537 	return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x42C:
	CALL __LOADLOCR6
	ADIW R28,15
	RET
;    1538 }
;    1539 
;    1540 void clear_sd_buff(void)
;    1541 {
_clear_sd_buff:
;    1542 	SD_CS_OFF();
	SBI  0x18,4
;    1543 	_FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
;    1544 	_FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
;    1545 }	
	RET
;    1546 
;    1547 unsigned char initialize_media(void)
;    1548 {
_initialize_media:
;    1549 	unsigned char data_temp;
;    1550 	unsigned long n;
;    1551 	
;    1552 	// SPI BUS SETUP
;    1553 	// SPI initialization
;    1554 	// SPI Type: Master
;    1555 	// SPI Clock Rate: 921.600 kHz
;    1556 	// SPI Clock Phase: Cycle Half
;    1557 	// SPI Clock Polarity: Low
;    1558 	// SPI Data Order: MSB First
;    1559 	DDRB |= 0x07;		// Set SS, SCK, and MOSI to Output (If not output, processor will be a slave)
	SBIW R28,4
	ST   -Y,R16
;	data_temp -> R16
;	n -> Y+1
	IN   R30,0x17
	ORI  R30,LOW(0x7)
	OUT  0x17,R30
;    1560 	DDRB &= 0xF7;		// Set MISO to Input
	CBI  0x17,3
;    1561 	CS_DDR_SET();		// Set CS to Output
	SBI  0x17,4
;    1562 	SPCR=0x50;
	LDI  R30,LOW(80)
	OUT  0xD,R30
;    1563 	SPSR=0x00;
	LDI  R30,LOW(0)
	OUT  0xE,R30
;    1564 		
;    1565 	BPB_BytsPerSec = 512;	// Initialize sector size to 512 (all SD cards have a 512 sector size)
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	STS  _BPB_BytsPerSec,R30
	STS  _BPB_BytsPerSec+1,R31
;    1566     _FF_n_temp = 0;
	LDI  R30,0
	STS  __FF_n_temp,R30
	STS  __FF_n_temp+1,R30
	STS  __FF_n_temp+2,R30
	STS  __FF_n_temp+3,R30
;    1567 	if (reset_sd()==0)
	RCALL _reset_sd
	CPI  R30,0
	BRNE _0xF0
;    1568 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x42B
;    1569 	// delay_ms(50);
;    1570 	for (n=0; ((n<100)||(data_temp==0)) ; n++)
_0xF0:
	__CLRD1S 1
_0xF2:
	__GETD2S 1
	__CPD2N 0x64
	BRLO _0xF4
	CPI  R16,0
	BRNE _0xF3
_0xF4:
;    1571 	{
;    1572 		SD_CS_ON();
	CBI  0x18,4
;    1573 		data_temp = _FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	MOV  R16,R30
;    1574 		SD_CS_OFF();
	SBI  0x18,4
;    1575 	}
	__GETD1S 1
	__SUBD1N -1
	__PUTD1S 1
	RJMP _0xF2
_0xF3:
;    1576 	// delay_ms(50);
;    1577 	for (n=0; n<100; n++)
	__CLRD1S 1
_0xF7:
	__GETD2S 1
	__CPD2N 0x64
	BRSH _0xF8
;    1578 	{
;    1579 		if (init_sd())		// Initialization Succeeded
	RCALL _init_sd
	CPI  R30,0
	BRNE _0xF8
;    1580 			break;
;    1581 		if (n==99)
	__GETD2S 1
	__CPD2N 0x63
	BRNE _0xFA
;    1582 			return (0);
	LDI  R30,LOW(0)
	RJMP _0x42B
;    1583 	}
_0xFA:
	__GETD1S 1
	__SUBD1N -1
	__PUTD1S 1
	RJMP _0xF7
_0xF8:
;    1584 
;    1585 	if (_FF_read(0x0)==0)
	__GETD1N 0x0
	CALL __PUTPARD1
	RCALL __FF_read
	CPI  R30,0
	BRNE _0xFB
;    1586 	{
;    1587 		#ifdef _DEBUG_ON_
;    1588 			printf("\n\rREAD_ERR"); 		
;    1589 		#endif
;    1590 		_FF_error = INIT_ERR;
	LDI  R30,LOW(1)
	STS  __FF_error,R30
;    1591 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x42B
;    1592 	}
;    1593 	PT_SecStart = ((int) _FF_buff[0x1c7] << 8) | (int) _FF_buff[0x1c6];
_0xFB:
	__GETBRMN 27,__FF_buff,455
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,454
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _PT_SecStart,R30
	STS  _PT_SecStart+1,R31
;    1594 	
;    1595 	if ((((_FF_buff[0]==0xEB)&&(_FF_buff[2]==0x90))||(_FF_buff[0]==0xE9)) && ((_FF_buff[510]==0x55)&&(_FF_buff[511]==0xAA)))
	LDS  R26,__FF_buff
	CPI  R26,LOW(0xEB)
	BRNE _0xFD
	__GETB1MN __FF_buff,2
	CPI  R30,LOW(0x90)
	BREQ _0xFF
_0xFD:
	LDS  R26,__FF_buff
	CPI  R26,LOW(0xE9)
	BRNE _0x101
_0xFF:
	__GETB1MN __FF_buff,510
	CPI  R30,LOW(0x55)
	BRNE _0x102
	__GETB1MN __FF_buff,511
	CPI  R30,LOW(0xAA)
	BREQ _0x103
_0x102:
	RJMP _0x101
_0x103:
	RJMP _0x104
_0x101:
	RJMP _0xFC
_0x104:
;    1596     	PT_SecStart = 0;
	LDI  R30,0
	STS  _PT_SecStart,R30
	STS  _PT_SecStart+1,R30
;    1597  
;    1598 	_FF_PART_ADDR = (long) PT_SecStart * (long) BPB_BytsPerSec;
_0xFC:
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
;    1599 
;    1600 	if (PT_SecStart)
	LDS  R30,_PT_SecStart
	LDS  R31,_PT_SecStart+1
	SBIW R30,0
	BREQ _0x105
;    1601 	{
;    1602 		if (_FF_read(_FF_PART_ADDR)==0)
	LDS  R30,__FF_PART_ADDR
	LDS  R31,__FF_PART_ADDR+1
	LDS  R22,__FF_PART_ADDR+2
	LDS  R23,__FF_PART_ADDR+3
	CALL __PUTPARD1
	RCALL __FF_read
	CPI  R30,0
	BRNE _0x106
;    1603 		{
;    1604 		   	#ifdef _DEBUG_ON_
;    1605 				printf("\n\rREAD_ERR");
;    1606 			#endif
;    1607 			_FF_error = INIT_ERR;
	LDI  R30,LOW(1)
	STS  __FF_error,R30
;    1608 			return (0);
	LDI  R30,LOW(0)
	RJMP _0x42B
;    1609 		}
;    1610 	}
_0x106:
;    1611 
;    1612  	#ifdef _DEBUG_ON_
;    1613 		printf("\n\rBoot_Sec: [0x%X %X %X] [0x%X] [0x%X]", _FF_buff[0],_FF_buff[1],_FF_buff[2],_FF_buff[510],_FF_buff[511]); 		
;    1614 	#endif
;    1615    	
;    1616     BS_jmpBoot = (((long) _FF_buff[0] << 16) | ((int) _FF_buff[1] << 8) | (int) _FF_buff[2]);    		
_0x105:
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
;    1617 	BPB_BytsPerSec = ((int) _FF_buff[0xC] << 8) | (int) _FF_buff[0xB];
	__GETBRMN 27,__FF_buff,12
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,11
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _BPB_BytsPerSec,R30
	STS  _BPB_BytsPerSec+1,R31
;    1618     BPB_SecPerClus = _FF_buff[0xD];
	__GETB1MN __FF_buff,13
	STS  _BPB_SecPerClus,R30
;    1619 	BPB_RsvdSecCnt = ((int) _FF_buff[0xF] << 8) | (int) _FF_buff[0xE];	
	__GETBRMN 27,__FF_buff,15
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,14
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _BPB_RsvdSecCnt,R30
	STS  _BPB_RsvdSecCnt+1,R31
;    1620 	BPB_NumFATs = _FF_buff[0x10];
	__GETB1MN __FF_buff,16
	STS  _BPB_NumFATs,R30
;    1621 	BPB_RootEntCnt = ((int) _FF_buff[0x12] << 8) | (int) _FF_buff[0x11];	
	__GETBRMN 27,__FF_buff,18
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,17
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _BPB_RootEntCnt,R30
	STS  _BPB_RootEntCnt+1,R31
;    1622 	BPB_FATSz16 = ((int) _FF_buff[0x17] << 8) | (int) _FF_buff[0x16];
	__GETBRMN 27,__FF_buff,23
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,22
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STS  _BPB_FATSz16,R30
	STS  _BPB_FATSz16+1,R31
;    1623 	BPB_TotSec = ((unsigned int) _FF_buff[0x14] << 8) | (unsigned int) _FF_buff[0x13];
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
;    1624 	if (BPB_TotSec==0)
	CALL __CPD10
	BRNE _0x107
;    1625 		BPB_TotSec = ((unsigned long) _FF_buff[0x23] << 24) | ((unsigned long) _FF_buff[0x22] << 16)
;    1626 					| ((unsigned long) _FF_buff[0x21] << 8) | ((unsigned long) _FF_buff[0x20]);
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
;    1627 	BS_VolSerial = ((unsigned long) _FF_buff[0x2A] << 24) | ((unsigned long) _FF_buff[0x29] << 16)
_0x107:
;    1628 				| ((unsigned long) _FF_buff[0x28] << 8) | ((unsigned long) _FF_buff[0x27]);
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
;    1629 	for (n=0; n<11; n++)
	__CLRD1S 1
_0x109:
	__GETD2S 1
	__CPD2N 0xB
	BRSH _0x10A
;    1630 		BS_VolLab[n] = _FF_buff[0x2B+n];
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
;    1631 	BS_VolLab[11] = 0;		// Terminate the string
	__GETD1S 1
	__SUBD1N -1
	__PUTD1S 1
	RJMP _0x109
_0x10A:
	LDI  R30,LOW(0)
	__PUTB1MN _BS_VolLab,11
;    1632 	_FF_FAT1_ADDR = _FF_PART_ADDR + ((long) BPB_RsvdSecCnt * (long) BPB_BytsPerSec); 
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
;    1633 	_FF_FAT2_ADDR = _FF_FAT1_ADDR + ((long) BPB_FATSz16 * (long) BPB_BytsPerSec);
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
;    1634 	_FF_ROOT_ADDR = ((long) BPB_NumFATs * (long) BPB_FATSz16) + (long) BPB_RsvdSecCnt;
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
;    1635 	_FF_ROOT_ADDR *= BPB_BytsPerSec;
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
;    1636 	_FF_ROOT_ADDR += _FF_PART_ADDR;
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
;    1637 	
;    1638 	_FF_RootDirSectors = ((BPB_RootEntCnt * 32) + BPB_BytsPerSec - 1) / BPB_BytsPerSec;
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
;    1639 	FirstDataSector = (BPB_NumFATs * BPB_FATSz16) + BPB_RsvdSecCnt + _FF_RootDirSectors; 
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
;    1640 	
;    1641 	DataClusTot = BPB_TotSec - FirstDataSector;
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
;    1642 	DataClusTot /= BPB_SecPerClus;
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
;    1643 	clus_0_addr = 0;		// Reset Empty Cluster table location
	LDI  R30,0
	STS  _clus_0_addr,R30
	STS  _clus_0_addr+1,R30
	STS  _clus_0_addr+2,R30
	STS  _clus_0_addr+3,R30
;    1644 	c_counter = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _c_counter,R30
	STS  _c_counter+1,R31
;    1645 	
;    1646 	if (DataClusTot < 4085)				// FAT12
	LDS  R26,_DataClusTot
	LDS  R27,_DataClusTot+1
	LDS  R24,_DataClusTot+2
	LDS  R25,_DataClusTot+3
	__CPD2N 0xFF5
	BRSH _0x10B
;    1647 		BPB_FATType = 0x32;
	LDI  R30,LOW(50)
	STS  _BPB_FATType,R30
;    1648 	else if (DataClusTot < 65525)		// FAT16
	RJMP _0x10C
_0x10B:
	LDS  R26,_DataClusTot
	LDS  R27,_DataClusTot+1
	LDS  R24,_DataClusTot+2
	LDS  R25,_DataClusTot+3
	__CPD2N 0xFFF5
	BRSH _0x10D
;    1649 		BPB_FATType = 0x36;
	LDI  R30,LOW(54)
	STS  _BPB_FATType,R30
;    1650 	else
	RJMP _0x10E
_0x10D:
;    1651 	{
;    1652 		BPB_FATType = 0;
	LDI  R30,LOW(0)
	STS  _BPB_FATType,R30
;    1653 		_FF_error = FAT_ERR;
	LDI  R30,LOW(12)
	STS  __FF_error,R30
;    1654 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x42B
;    1655 	}
_0x10E:
_0x10C:
;    1656     
;    1657 	_FF_DIR_ADDR = _FF_ROOT_ADDR;		// Set current directory to root address
	LDS  R30,__FF_ROOT_ADDR
	LDS  R31,__FF_ROOT_ADDR+1
	LDS  R22,__FF_ROOT_ADDR+2
	LDS  R23,__FF_ROOT_ADDR+3
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    1658 
;    1659 	_FF_FULL_PATH[0] = 0x5C;	// a '\'
	LDI  R30,LOW(92)
	STS  __FF_FULL_PATH,R30
;    1660 	_FF_FULL_PATH[1] = 0;
	LDI  R30,LOW(0)
	__PUTB1MN __FF_FULL_PATH,1
;    1661 	
;    1662 	#ifdef _DEBUG_ON_
;    1663 		printf("\n\rPart Address:  %lX", _FF_PART_ADDR);
;    1664 		printf("\n\rBS_jmpBoot:  %lX", BS_jmpBoot);
;    1665 		printf("\n\rBPB_BytsPerSec:  %X", BPB_BytsPerSec);
;    1666 		printf("\n\rBPB_SecPerClus:  %X", BPB_SecPerClus);
;    1667 		printf("\n\rBPB_RsvdSecCnt:  %X", BPB_RsvdSecCnt);
;    1668 		printf("\n\rBPB_NumFATs:  %X", BPB_NumFATs);
;    1669 		printf("\n\rBPB_RootEntCnt:  %X", BPB_RootEntCnt);
;    1670 		printf("\n\rBPB_FATSz16:  %X", BPB_FATSz16);
;    1671 		printf("\n\rBPB_TotSec16:  %lX", BPB_TotSec);
;    1672 		if (BPB_FATType == 0x32)
;    1673 			printf("\n\rBPB_FATType:  FAT12");
;    1674 		else if (BPB_FATType == 0x36)
;    1675 			printf("\n\rBPB_FATType:  FAT16");
;    1676 		else
;    1677 			printf("\n\rBPB_FATType:  FAT ERROR!!");
;    1678 		printf("\n\rClusterCnt:  %lX", DataClusTot);
;    1679 		printf("\n\rROOT_ADDR:  %lX", _FF_ROOT_ADDR);
;    1680 		printf("\n\rFAT2_ADDR:  %lX", _FF_FAT2_ADDR);
;    1681 		printf("\n\rRootDirSectors:  %X", _FF_RootDirSectors);
;    1682 		printf("\n\rFirstDataSector:  %X", FirstDataSector);
;    1683 	#endif
;    1684 	
;    1685 	return (1);	
	LDI  R30,LOW(1)
_0x42B:
	LDD  R16,Y+0
	ADIW R28,5
	RET
;    1686 }
;    1687 
;    1688 unsigned char spi_speedset(void)
;    1689 {
_spi_speedset:
;    1690 	if (SPCR == 0x50)
	IN   R30,0xD
	CPI  R30,LOW(0x50)
	BRNE _0x10F
;    1691 		SPCR = 0x51;
	LDI  R30,LOW(81)
	OUT  0xD,R30
;    1692 	else if (SPCR == 0x51)
	RJMP _0x110
_0x10F:
	IN   R30,0xD
	CPI  R30,LOW(0x51)
	BRNE _0x111
;    1693 		SPCR = 0x52;
	LDI  R30,LOW(82)
	OUT  0xD,R30
;    1694 	else if (SPCR == 0x52)
	RJMP _0x112
_0x111:
	IN   R30,0xD
	CPI  R30,LOW(0x52)
	BRNE _0x113
;    1695 		SPCR = 0x53;
	LDI  R30,LOW(83)
	OUT  0xD,R30
;    1696 	else
	RJMP _0x114
_0x113:
;    1697 	{
;    1698 		SPCR = 0x50;
	LDI  R30,LOW(80)
	OUT  0xD,R30
;    1699 		return (0);
	LDI  R30,LOW(0)
	RET
;    1700 	}
_0x114:
_0x112:
_0x110:
;    1701 	return (1);
	LDI  R30,LOW(1)
	RET
;    1702 }
;    1703 
;    1704 unsigned char reset_sd(void)
;    1705 {
_reset_sd:
;    1706 	unsigned char resp, n, c;
;    1707 
;    1708 	#ifdef _DEBUG_ON_
;    1709 		printf("\n\rReset CMD:  ");	
;    1710 	#endif
;    1711 
;    1712 	for (c=0; c<4; c++)		// try reset command 3 times if needed
	CALL __SAVELOCR3
;	resp -> R16
;	n -> R17
;	c -> R18
	LDI  R18,LOW(0)
_0x116:
	CPI  R18,4
	BRSH _0x117
;    1713 	{
;    1714 		SD_CS_OFF();
	SBI  0x18,4
;    1715 		for (n=0; n<10; n++)	// initialize clk signal to sync card
	LDI  R17,LOW(0)
_0x119:
	CPI  R17,10
	BRSH _0x11A
;    1716 			_FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
;    1717 		resp = send_cmd(CMD0,0);
	SUBI R17,-1
	RJMP _0x119
_0x11A:
	LDI  R30,LOW(0)
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	CALL _send_cmd
	MOV  R16,R30
;    1718 		for (n=0; n<200; n++)
	LDI  R17,LOW(0)
_0x11C:
	CPI  R17,200
	BRSH _0x11D
;    1719 		{
;    1720 			if (resp == 0x1)
	CPI  R16,1
	BRNE _0x11E
;    1721 			{
;    1722 				SD_CS_OFF();
	SBI  0x18,4
;    1723     			#ifdef _DEBUG_ON_
;    1724 					printf("OK!!!");
;    1725 				#endif
;    1726 				SPCR = 0x50;
	LDI  R30,LOW(80)
	OUT  0xD,R30
;    1727 				return(1);
	LDI  R30,LOW(1)
	RJMP _0x42A
;    1728 			}
;    1729 	      	resp = _FF_spi(0xFF);
_0x11E:
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	MOV  R16,R30
;    1730 		}
	SUBI R17,-1
	RJMP _0x11C
_0x11D:
;    1731 		#ifdef _DEBUG_ON_
;    1732 			printf("ERROR!!!");
;    1733 		#endif
;    1734  		if (spi_speedset()==0)
	CALL _spi_speedset
	CPI  R30,0
	BRNE _0x11F
;    1735  		{
;    1736 		    SD_CS_OFF();
	SBI  0x18,4
;    1737  			return (0);
	LDI  R30,LOW(0)
	RJMP _0x42A
;    1738  		}
;    1739 	}
_0x11F:
	SUBI R18,-1
	RJMP _0x116
_0x117:
;    1740 	return (0);
	LDI  R30,LOW(0)
	RJMP _0x42A
;    1741 }
;    1742 
;    1743 unsigned char init_sd(void)
;    1744 {
_init_sd:
;    1745 	unsigned char resp;
;    1746 	unsigned int c;
;    1747 	
;    1748 	clear_sd_buff();
	CALL __SAVELOCR3
;	resp -> R16
;	c -> R17,R18
	CALL _clear_sd_buff
;    1749 
;    1750     #ifdef _DEBUG_ON_
;    1751 		printf("\r\nInitialization:  ");
;    1752 	#endif
;    1753     for (c=0; c<1000; c++)
	__GETWRN 17,18,0
_0x121:
	__CPWRN 17,18,1000
	BRSH _0x122
;    1754     {
;    1755     	resp = send_cmd(CMD1, 0);
	LDI  R30,LOW(1)
	ST   -Y,R30
	__GETD1N 0x0
	CALL __PUTPARD1
	CALL _send_cmd
	MOV  R16,R30
;    1756     	if (resp == 0)
	CPI  R16,0
	BREQ _0x122
;    1757     		break;
;    1758    		resp = _FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	MOV  R16,R30
;    1759    		if (resp == 0)
	CPI  R16,0
	BREQ _0x122
;    1760    			break;
;    1761    		resp = _FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	MOV  R16,R30
;    1762    		if (resp == 0)
	CPI  R16,0
	BREQ _0x122
;    1763    			break;
;    1764 	}
	__ADDWRN 17,18,1
	RJMP _0x121
_0x122:
;    1765    	if (resp == 0)
	CPI  R16,0
	BRNE _0x126
;    1766 	{
;    1767 		#ifdef _DEBUG_ON_
;    1768    			printf("OK!");
;    1769 	   	#endif
;    1770 		return (1);
	LDI  R30,LOW(1)
	RJMP _0x42A
;    1771 	}
;    1772 	else
_0x126:
;    1773 	{
;    1774 		#ifdef _DEBUG_ON_
;    1775    			printf("ERROR-%x  ", resp);
;    1776 	   	#endif
;    1777 		return (0);
	LDI  R30,LOW(0)
;    1778  	}        		
;    1779 }
_0x42A:
	CALL __LOADLOCR3
	ADIW R28,3
	RET
;    1780 
;    1781 unsigned char _FF_read_disp(unsigned long sd_addr)
;    1782 {
;    1783 	unsigned char resp;
;    1784 	unsigned long n, remainder;
;    1785 	
;    1786 	if (sd_addr % 0x200)
;	sd_addr -> Y+9
;	resp -> R16
;	n -> Y+5
;	remainder -> Y+1
;    1787 	{	// Not a valid read address, return 0
;    1788 		_FF_error = READ_ERR;
;    1789 		return (0);
;    1790 	}
;    1791 
;    1792 	clear_sd_buff();
;    1793 	resp = send_cmd(CMD17, sd_addr);		// Send read request
;    1794 	
;    1795 	while(resp!=0xFE)
;    1796 		resp = _FF_spi(0xFF);
;    1797 	for (n=0; n<512; n++)
;    1798 	{
;    1799 		remainder = n % 0x10;
;    1800 		if (remainder == 0)
;    1801 			printf("\n\r");
;    1802 		_FF_buff[n] = _FF_spi(0xFF);
;    1803 		if (_FF_buff[n]<0x10)
;    1804 			putchar(0x30);
;    1805 		printf("%X ", _FF_buff[n]);
;    1806 	}
;    1807 	_FF_spi(0xFF);
;    1808 	_FF_spi(0xFF);
;    1809 	_FF_spi(0xFF);
;    1810 	SD_CS_OFF();
;    1811 	return (1);
;    1812 }
;    1813 
;    1814 // Read data from a SD card @ address
;    1815 unsigned char _FF_read(unsigned long sd_addr)
;    1816 {
__FF_read:
;    1817 	unsigned char resp;
;    1818 	unsigned long n;
;    1819 //printf("\r\nReadin ADDR [0x%lX]", sd_addr);
;    1820 	
;    1821 	if (sd_addr % BPB_BytsPerSec)
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
	BREQ _0x131
;    1822 	{	// Not a valid read address, return 0
;    1823 		_FF_error = READ_ERR;
	LDI  R30,LOW(4)
	STS  __FF_error,R30
;    1824 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x429
;    1825 	}
;    1826 		
;    1827 	for (;;)
_0x131:
_0x133:
;    1828 	{
;    1829 		clear_sd_buff();
	CALL _clear_sd_buff
;    1830 		resp = send_cmd(CMD17, sd_addr);	// read block command
	LDI  R30,LOW(7)
	ST   -Y,R30
	__GETD1S 6
	CALL __PUTPARD1
	CALL _send_cmd
	MOV  R16,R30
;    1831 		for (n=0; n<1000; n++)
	__CLRD1S 1
_0x136:
	__GETD2S 1
	__CPD2N 0x3E8
	BRSH _0x137
;    1832 		{
;    1833 			if (resp==0xFE)
	CPI  R16,254
	BREQ _0x137
;    1834 			{	// waiting for start byte
;    1835 				break;
;    1836 			}
;    1837 			resp = _FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	MOV  R16,R30
;    1838 		}
	__GETD1S 1
	__SUBD1N -1
	__PUTD1S 1
	RJMP _0x136
_0x137:
;    1839 		if (resp==0xFE)
	CPI  R16,254
	BREQ PC+3
	JMP _0x139
;    1840 		{	// if it is a valid start byte => start reading SD Card
;    1841 			for (n=0; n<BPB_BytsPerSec; n++)
	__CLRD1S 1
_0x13B:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	__GETD2S 1
	CLR  R22
	CLR  R23
	CALL __CPD21
	BRSH _0x13C
;    1842 				_FF_buff[n] = _FF_spi(0xFF);
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
;    1843 			_FF_spi(0xFF);
	__GETD1S 1
	__SUBD1N -1
	__PUTD1S 1
	RJMP _0x13B
_0x13C:
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
;    1844 			_FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
;    1845 			_FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
;    1846 			SD_CS_OFF();
	SBI  0x18,4
;    1847 			_FF_error = NO_ERR;
	LDI  R30,LOW(0)
	STS  __FF_error,R30
;    1848 			_FF_buff_addr = sd_addr;
	__GETD1S 5
	STS  __FF_buff_addr,R30
	STS  __FF_buff_addr+1,R31
	STS  __FF_buff_addr+2,R22
	STS  __FF_buff_addr+3,R23
;    1849 			SPCR = 0x50;
	LDI  R30,LOW(80)
	OUT  0xD,R30
;    1850 			return (1);
	LDI  R30,LOW(1)
	RJMP _0x429
;    1851 		}
;    1852 
;    1853 		SD_CS_OFF();
_0x139:
	SBI  0x18,4
;    1854 
;    1855 		if (spi_speedset()==0)
	CALL _spi_speedset
	CPI  R30,0
	BREQ _0x134
;    1856 			break;
;    1857 	}	
	RJMP _0x133
_0x134:
;    1858 	_FF_error = READ_ERR;    
	LDI  R30,LOW(4)
	STS  __FF_error,R30
;    1859 	return(0);
	LDI  R30,LOW(0)
_0x429:
	LDD  R16,Y+0
	ADIW R28,9
	RET
;    1860 }
;    1861 
;    1862 
;    1863 #ifndef _READ_ONLY_
;    1864 unsigned char _FF_write(unsigned long sd_addr)
;    1865 {
__FF_write:
;    1866 	unsigned char resp, calc, valid_flag;
;    1867 	unsigned int n;
;    1868 	
;    1869 	if ((sd_addr%BPB_BytsPerSec) || (sd_addr <= _FF_PART_ADDR))
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
	BRNE _0x13F
	LDS  R30,__FF_PART_ADDR
	LDS  R31,__FF_PART_ADDR+1
	LDS  R22,__FF_PART_ADDR+2
	LDS  R23,__FF_PART_ADDR+3
	__GETD2S 5
	CALL __CPD12
	BRLO _0x13E
_0x13F:
;    1870 	{	// Not a valid write address, return 0
;    1871 		_FF_error = WRITE_ERR;
	LDI  R30,LOW(3)
	STS  __FF_error,R30
;    1872 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x428
;    1873 	}
;    1874 
;    1875 //printf("\r\nWriting to address:  %lX", sd_addr);
;    1876 	for (;;)
_0x13E:
_0x142:
;    1877 	{
;    1878 		clear_sd_buff();
	CALL _clear_sd_buff
;    1879 		resp = send_cmd(CMD24, sd_addr);
	LDI  R30,LOW(9)
	ST   -Y,R30
	__GETD1S 6
	CALL __PUTPARD1
	CALL _send_cmd
	MOV  R16,R30
;    1880 		valid_flag = 0;
	LDI  R18,LOW(0)
;    1881 		for (n=0; n<1000; n++)
	__GETWRN 19,20,0
_0x145:
	__CPWRN 19,20,1000
	BRSH _0x146
;    1882 		{
;    1883 			if (resp == 0x00)
	CPI  R16,0
	BRNE _0x147
;    1884 			{
;    1885 				valid_flag = 1;
	LDI  R18,LOW(1)
;    1886 				break;
	RJMP _0x146
;    1887 			}
;    1888 			resp = _FF_spi(0xFF);
_0x147:
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	MOV  R16,R30
;    1889 		}
	__ADDWRN 19,20,1
	RJMP _0x145
_0x146:
;    1890 	
;    1891 		if (valid_flag)
	CPI  R18,0
	BREQ _0x148
;    1892 		{
;    1893 			_FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
;    1894 			_FF_spi(0xFE);					// Start Block Token
	LDI  R30,LOW(254)
	ST   -Y,R30
	CALL __FF_spi
;    1895 			for (n=0; n<BPB_BytsPerSec; n++)		// Write Data in buffer to card
	__GETWRN 19,20,0
_0x14A:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	CP   R19,R30
	CPC  R20,R31
	BRSH _0x14B
;    1896 				_FF_spi(_FF_buff[n]);
	LDI  R26,LOW(__FF_buff)
	LDI  R27,HIGH(__FF_buff)
	ADD  R26,R19
	ADC  R27,R20
	LD   R30,X
	ST   -Y,R30
	CALL __FF_spi
;    1897 			_FF_spi(0xFF);					// Send 2 blank CRC bytes
	__ADDWRN 19,20,1
	RJMP _0x14A
_0x14B:
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
;    1898 			_FF_spi(0xFF);
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
;    1899 			resp = _FF_spi(0xFF);			// Response should be 0bXXX00101
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	MOV  R16,R30
;    1900 			calc = resp | 0xE0;
	MOV  R30,R16
	ORI  R30,LOW(0xE0)
	MOV  R17,R30
;    1901 			if (calc==0xE5)
	CPI  R17,229
	BRNE _0x14C
;    1902 			{
;    1903 				while(_FF_spi(0xFF)==0)
_0x14D:
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL __FF_spi
	CPI  R30,0
	BREQ _0x14D
;    1904 					;	// Clear Buffer before returning 'OK'
;    1905 				SD_CS_OFF();
	SBI  0x18,4
;    1906 //				SPCR = 0x50;			// Reset SPI bus Speed
;    1907 				_FF_error = NO_ERR;
	LDI  R30,LOW(0)
	STS  __FF_error,R30
;    1908 				return(1);
	LDI  R30,LOW(1)
	RJMP _0x428
;    1909 			}
;    1910 		}
_0x14C:
;    1911 		SD_CS_OFF(); 
_0x148:
	SBI  0x18,4
;    1912 
;    1913 		if (spi_speedset()==0)
	CALL _spi_speedset
	CPI  R30,0
	BREQ _0x143
;    1914 			break;
;    1915 		// delay_ms(100);		
;    1916 	}
	RJMP _0x142
_0x143:
;    1917 	_FF_error = WRITE_ERR;
	LDI  R30,LOW(3)
	STS  __FF_error,R30
;    1918 	return(0x0);
	LDI  R30,LOW(0)
_0x428:
	CALL __LOADLOCR5
	ADIW R28,9
	RET
;    1919 }
;    1920 #endif
;    1921 /*
;    1922 	Progressive Resources LLC
;    1923                                     
;    1924 			FlashFile
;    1925 	
;    1926 	Version : 	1.32
;    1927 	Date: 		12/31/2003
;    1928 	Author: 	Erick M. Higa
;    1929 	
;    1930 	Revision History:
;    1931 	12/31/2003 - EMH - v1.00 
;    1932 			   	 	 - Initial Release
;    1933 	01/19/2004 - EMH - v1.10
;    1934 			   	 	 - fixed FAT access errors by allowing both FAT tables to be updated
;    1935 					 - fixed erase_cluster chain to stop if chain goes to '0'
;    1936 					 - fixed #include's so other non m128 processors could be used
;    1937 					 - fixed fcreate to match 'C' standard for function "creat"
;    1938 					 - fixed fseek so it would not error when in "READ" mode
;    1939 					 - modified SPI interface to use _FF_spi() so it is more universal
;    1940 					   (see the "sd_cmd.c" file for the function used)
;    1941 					 - redifined global variables and #defines for more unique names
;    1942 					 - added string functions fputs, fputsc, & fgets
;    1943 					 - added functions fquickformat, fgetfileinfo, & GetVolID()
;    1944 					 - added directory support
;    1945 					 - modified delays in "sd_cmd.c" to increase transfer speed to max
;    1946 					 - updated "options.h" to include additions, and to make #defines 
;    1947 					   more universal to multiple platforms
;    1948 	01/21/2004 - EMH - v1.20
;    1949 			   	 	 - Added ICC Support to the FlashFileSD
;    1950 					 - fixed card initialization error for MMC/SD's that have only a boot 
;    1951 			   	 	   sector and no partition table
;    1952 					 - Fixed intermittant error on fcreate when creating existing file
;    1953 					 - changed "options.h" to #include all required files
;    1954 	02/19/2004 - EMH - v1.21
;    1955 					 - Replaced all "const" refrances to "flash" to support CodeVision 1.24.1b
;    1956 	03/02/2004 - EMH - v1.22 (unofficial release)
;    1957 					 - Changed Directory Functions to allow for multi-cluster directory entries
;    1958 					 - Added function addr_to_clust() to support long directories
;    1959 					 - Fixed FAT table address calculation to support multiple reserved sectors
;    1960 					   (previously) assumed one reserved sector, if XP formats card sometimes 
;    1961 					   multiple reserved sectors - thanks YW
;    1962 	03/10/2004 - EMH - v1.30
;    1963 					 - Added support for a Compact Flash package
;    1964 					 - Renamed read and write to flash function names for multiple media support	
;    1965 	03/26/2004 - EMH - v1.31
;    1966 					 - Added define for easy MEGA128Dev board setup
;    1967 					 - Changed demo projects so "option.h" is in the project directory	
;    1968 	04/01/2004 - EMH - v1.32
;    1969 					 - Fixed bug in "prev_cluster()" that didn't use updated FAT table address
;    1970 					   calculations.  (effects XP formatted cards see v1.22 notes)
;    1971                                            
;    1972 	Software License
;    1973 	The use of Progressive Resources LLC FlashFile Source Package indicates 
;    1974 	your understanding and acceptance of the following terms and conditions. 
;    1975 	This license shall supersede any verbal or prior verbal or written, statement 
;    1976 	or agreement to the contrary. If you do not understand or accept these terms, 
;    1977 	or your local regulations prohibit "after sale" license agreements or limited 
;    1978 	disclaimers, you must cease and desist using this product immediately.
;    1979 	This product is © Copyright 2003 by Progressive Resources LLC, all rights 
;    1980 	reserved. International copyright laws, international treaties and all other 
;    1981 	applicable national or international laws protect this product. This software 
;    1982 	product and documentation may not, in whole or in part, be copied, photocopied, 
;    1983 	translated, or reduced to any electronic medium or machine readable form, without 
;    1984 	prior consent in writing, from Progressive Resources LLC and according to all 
;    1985 	applicable laws. The sole owner of this product is Progressive Resources LLC.
;    1986 
;    1987 	Operating License
;    1988 	You have the non-exclusive right to use any enclosed product but have no right 
;    1989 	to distribute it as a source code product without the express written permission 
;    1990 	of Progressive Resources LLC. Use over a "local area network" (within the same 
;    1991 	locale) is permitted provided that only a single person, on a single computer 
;    1992 	uses the product at a time. Use over a "wide area network" (outside the same 
;    1993 	locale) is strictly prohibited under any and all circumstances.
;    1994                                            
;    1995 	Liability Disclaimer
;    1996 	This product and/or license is provided as is, without any representation or 
;    1997 	warranty of any kind, either express or implied, including without limitation 
;    1998 	any representations or endorsements regarding the use of, the results of, or 
;    1999 	performance of the product, Its appropriateness, accuracy, reliability, or 
;    2000 	correctness. The user and/or licensee assume the entire risk as to the use of 
;    2001 	this product. Progressive Resources LLC does not assume liability for the use 
;    2002 	of this product beyond the original purchase price of the software. In no event 
;    2003 	will Progressive Resources LLC be liable for additional direct or indirect 
;    2004 	damages including any lost profits, lost savings, or other incidental or 
;    2005 	consequential damages arising from any defects, or the use or inability to 
;    2006 	use these products, even if Progressive Resources LLC have been advised of 
;    2007 	the possibility of such damages.
;    2008 */                                 
;    2009 
;    2010 	#include <coding.h>
;    2011 
;    2012 extern unsigned long OCR_REG;
;    2013 extern unsigned char _FF_buff[512];
;    2014 extern unsigned int PT_SecStart;
;    2015 extern unsigned long BS_jmpBoot;
;    2016 extern unsigned int BPB_BytsPerSec;
;    2017 extern unsigned char BPB_SecPerClus;
;    2018 extern unsigned int BPB_RsvdSecCnt;
;    2019 extern unsigned char BPB_NumFATs;
;    2020 extern unsigned int BPB_RootEntCnt;
;    2021 extern unsigned int BPB_FATSz16;
;    2022 extern unsigned char BPB_FATType;
;    2023 extern unsigned long BPB_TotSec;
;    2024 extern unsigned long BS_VolSerial;
;    2025 extern unsigned char BS_VolLab[12];
;    2026 extern unsigned long _FF_PART_ADDR, _FF_ROOT_ADDR, _FF_DIR_ADDR;
;    2027 extern unsigned long _FF_FAT1_ADDR, _FF_FAT2_ADDR;
;    2028 extern unsigned int FirstDataSector;
;    2029 extern unsigned long FirstSectorofCluster;
;    2030 extern unsigned char _FF_error;
;    2031 extern unsigned long _FF_buff_addr;
;    2032 extern unsigned long DataClusTot;
;    2033 unsigned char rtc_hour, rtc_min, rtc_sec;

	.DSEG
_rtc_hour:
	.BYTE 0x1
_rtc_min:
	.BYTE 0x1
_rtc_sec:
	.BYTE 0x1
;    2034 unsigned char rtc_date, rtc_month;
_rtc_date:
	.BYTE 0x1
_rtc_month:
	.BYTE 0x1
;    2035 unsigned int rtc_year;
_rtc_year:
	.BYTE 0x2
;    2036 unsigned long clus_0_addr, _FF_n_temp;
_clus_0_addr:
	.BYTE 0x4
__FF_n_temp:
	.BYTE 0x4
;    2037 unsigned int c_counter;
_c_counter:
	.BYTE 0x2
;    2038 unsigned char _FF_FULL_PATH[_FF_PATH_LENGTH];
__FF_FULL_PATH:
	.BYTE 0x64
;    2039 unsigned char FILENAME[12];
_FILENAME:
	.BYTE 0xC
;    2040 
;    2041 // Conversion file to change an ASCII valued character into the calculated value
;    2042 unsigned char ascii_to_char(unsigned char ascii_char)
;    2043 {

	.CSEG
;    2044 	unsigned char temp_char;
;    2045 	
;    2046 	if (ascii_char < 0x30)		// invalid, return error
;	ascii_char -> Y+1
;	temp_char -> R16
;    2047 		return (0xFF);
;    2048 	else if (ascii_char < 0x3A)
;    2049 	{	//number, subtract 0x30, retrun value
;    2050 		temp_char = ascii_char - 0x30;
;    2051 		return (temp_char);
;    2052 	}
;    2053 	else if (ascii_char < 0x41)	// invalid, return error
;    2054 		return (0xFF);
;    2055 	else if (ascii_char < 0x47)
;    2056 	{	// lower case a-f, subtract 0x37, return value
;    2057 		temp_char = ascii_char - 0x37;
;    2058 		return (temp_char);
;    2059 	}
;    2060 	else if (ascii_char < 0x61)	// invalid, return error
;    2061 		return (0xFF);
;    2062 	else if (ascii_char < 0x67)
;    2063 	{	// upper case A-F, subtract 0x57, return value
;    2064 		temp_char = ascii_char - 0x57;
;    2065 		return (temp_char);
;    2066 	}
;    2067 	else	// invalid, return error
;    2068 		return (0xFF);
;    2069 }
;    2070 
;    2071 // Function to see if the character is a valid FILENAME character
;    2072 int valid_file_char(unsigned char file_char)
;    2073 {
_valid_file_char:
;    2074 	if (file_char < 0x20)
	LD   R26,Y
	CPI  R26,LOW(0x20)
	BRSH _0x15D
;    2075 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x427
;    2076 	else if ((file_char==0x22) || (file_char==0x2A) || (file_char==0x2B) || (file_char==0x2C) ||
_0x15D:
;    2077 			(file_char==0x2E) || (file_char==0x2F) || ((file_char>=0x3A)&&(file_char<=0x3F)) ||
;    2078 			((file_char>=0x5B)&&(file_char<=0x5D)) || (file_char==0x7C) || (file_char==0xE5))
	LD   R26,Y
	CPI  R26,LOW(0x22)
	BREQ _0x160
	CPI  R26,LOW(0x2A)
	BREQ _0x160
	CPI  R26,LOW(0x2B)
	BREQ _0x160
	CPI  R26,LOW(0x2C)
	BREQ _0x160
	CPI  R26,LOW(0x2E)
	BREQ _0x160
	CPI  R26,LOW(0x2F)
	BREQ _0x160
	CPI  R26,LOW(0x3A)
	BRLO _0x161
	CPI  R26,LOW(0x40)
	BRLO _0x160
_0x161:
	LD   R26,Y
	CPI  R26,LOW(0x5B)
	BRLO _0x163
	CPI  R26,LOW(0x5E)
	BRLO _0x160
_0x163:
	LD   R26,Y
	CPI  R26,LOW(0x7C)
	BREQ _0x160
	CPI  R26,LOW(0xE5)
	BRNE _0x15F
_0x160:
;    2079 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x427
;    2080 	else
_0x15F:
;    2081 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
;    2082 }
_0x427:
	ADIW R28,1
	RET
;    2083 
;    2084 // Function will scan the directory @VALID_ADDR and return a
;    2085 // '0' if successful (w/ VALID_ADDR changing to location of entry avaliable),
;    2086 // and a '-1' if file or folder exists (w/ VALID_ADDR changing to location of
;    2087 // entry of exisiting file/folder) or if no more entry space (VALID_ADDR would
;    2088 // change to 0).
;    2089 int scan_directory(unsigned long *VALID_ADDR, unsigned char *NAME)
;    2090 {
_scan_directory:
;    2091 	unsigned int ent_cntr, ent_max, n, c, dir_clus;
;    2092 	unsigned long temp_addr;
;    2093 	unsigned char *sp, *qp, aval_flag, name_store[14];
;    2094 	
;    2095 	aval_flag = 0;
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
;    2096 	ent_cntr = 0;	// set to 0
	__GETWRN 16,17,0
;    2097 	
;    2098 	qp = NAME;
	LDD  R30,Y+33
	LDD  R31,Y+33+1
	STD  Y+21,R30
	STD  Y+21+1,R31
;    2099 	for (c=0; c<11; c++)
	LDI  R30,0
	STD  Y+31,R30
	STD  Y+31+1,R30
_0x168:
	LDD  R26,Y+31
	LDD  R27,Y+31+1
	SBIW R26,11
	BRLO PC+3
	JMP _0x169
;    2100 	{
;    2101 		if (valid_file_char(*qp)==0)
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	LD   R30,X
	ST   -Y,R30
	CALL _valid_file_char
	SBIW R30,0
	BRNE _0x16A
;    2102 			name_store[c] = toupper(*qp++);
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
;    2103 		else if (*qp == '.')
	RJMP _0x16B
_0x16A:
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BRNE _0x16C
;    2104 		{
;    2105 			while (c<8)
_0x16D:
	LDD  R26,Y+31
	LDD  R27,Y+31+1
	SBIW R26,8
	BRSH _0x16F
;    2106 				name_store[c++] = 0x20;
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
;    2107 			c--;
	RJMP _0x16D
_0x16F:
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	SBIW R30,1
	STD  Y+31,R30
	STD  Y+31+1,R31
;    2108 			
;    2109 			qp++;
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	ADIW R30,1
	STD  Y+21,R30
	STD  Y+21+1,R31
;    2110 			aval_flag |= 1;
	LDD  R30,Y+20
	ORI  R30,1
	STD  Y+20,R30
;    2111 		}
;    2112 		else if (*qp == 0)
	RJMP _0x170
_0x16C:
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	LD   R30,X
	CPI  R30,0
	BRNE _0x171
;    2113 		{
;    2114 			while (c<11)
_0x172:
	LDD  R26,Y+31
	LDD  R27,Y+31+1
	SBIW R26,11
	BRSH _0x174
;    2115 				name_store[c++] = 0x20;
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
;    2116 		}
	RJMP _0x172
_0x174:
;    2117 		else
	RJMP _0x175
_0x171:
;    2118 		{
;    2119 			*VALID_ADDR = 0;
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	__GETD1N 0x0
	CALL __PUTDP1
;    2120 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x426
;    2121 		}
_0x175:
_0x170:
_0x16B:
;    2122 	}
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	ADIW R30,1
	STD  Y+31,R30
	STD  Y+31+1,R31
	RJMP _0x168
_0x169:
;    2123 	name_store[11] = 0;
	LDI  R30,LOW(0)
	STD  Y+17,R30
;    2124 	
;    2125 	if (*VALID_ADDR == _FF_ROOT_ADDR)
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __GETD1P
	LDS  R26,__FF_ROOT_ADDR
	LDS  R27,__FF_ROOT_ADDR+1
	LDS  R24,__FF_ROOT_ADDR+2
	LDS  R25,__FF_ROOT_ADDR+3
	CALL __CPD12
	BRNE _0x176
;    2126 		ent_max = BPB_RootEntCnt;
	__GETWRMN 18,19,0,_BPB_RootEntCnt
;    2127 	else
	RJMP _0x177
_0x176:
;    2128 	{
;    2129 		dir_clus = addr_to_clust(*VALID_ADDR);
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __GETD1P
	CALL __PUTPARD1
	RCALL _addr_to_clust
	STD  Y+29,R30
	STD  Y+29+1,R31
;    2130 		if (dir_clus != 0)
	SBIW R30,0
	BREQ _0x178
;    2131 			aval_flag |= 0x80;
	LDD  R30,Y+20
	ORI  R30,0x80
	STD  Y+20,R30
;    2132 		ent_max = ((long) BPB_BytsPerSec * (long) BPB_SecPerClus) / 0x20;
_0x178:
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
;    2133     }
_0x177:
;    2134 	c = 0;
	LDI  R30,0
	STD  Y+31,R30
	STD  Y+31+1,R30
;    2135 	while (ent_cntr < ent_max)	
_0x179:
	__CPWRR 16,17,18,19
	BRLO PC+3
	JMP _0x17B
;    2136 	{
;    2137 		if (_FF_read(*VALID_ADDR+((long)c*BPB_BytsPerSec))==0)
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
	BRNE _0x17C
;    2138 			break;
	RJMP _0x17B
;    2139 		for (n=0; n<16; n++)
_0x17C:
	__GETWRN 20,21,0
_0x17E:
	__CPWRN 20,21,16
	BRLO PC+3
	JMP _0x17F
;    2140 		{
;    2141 			sp = &_FF_buff[n*0x20];
	MOVW R30,R20
	LSL  R30
	ROL  R31
	CALL __LSLW4
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	STD  Y+23,R30
	STD  Y+23+1,R31
;    2142 			qp = name_store;
	MOVW R30,R28
	ADIW R30,6
	STD  Y+21,R30
	STD  Y+21+1,R31
;    2143 			if (*sp==0)
	LDD  R26,Y+23
	LDD  R27,Y+23+1
	LD   R30,X
	CPI  R30,0
	BRNE _0x180
;    2144 			{
;    2145 				if ((aval_flag&0x10)==0)
	LDD  R30,Y+20
	ANDI R30,LOW(0x10)
	BRNE _0x181
;    2146 					temp_addr = *VALID_ADDR + ((long) c * BPB_BytsPerSec) + (n * 0x20);
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
;    2147 				*VALID_ADDR = temp_addr;
_0x181:
	__GETD1S 25
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __PUTDP1
;    2148 				return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x426
;    2149 			}
;    2150 			else if (*sp==0xE5)
_0x180:
	LDD  R26,Y+23
	LDD  R27,Y+23+1
	LD   R26,X
	CPI  R26,LOW(0xE5)
	BRNE _0x183
;    2151 			{
;    2152 				temp_addr = *VALID_ADDR + ((long) c * BPB_BytsPerSec) + (n * 0x20);
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
;    2153 				aval_flag |= 0x10;
	LDD  R30,Y+20
	ORI  R30,0x10
	STD  Y+20,R30
;    2154 			}
;    2155 			else
	RJMP _0x184
_0x183:
;    2156 			{
;    2157 				if (aval_flag & 0x01)	// file
	LDD  R30,Y+20
	ANDI R30,LOW(0x1)
	BRNE PC+3
	JMP _0x185
;    2158 				{
;    2159 					if (strncmp(qp, sp, 11)==0)
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
;    2160 					{
;    2161 						temp_addr = *VALID_ADDR + ((long) c * BPB_BytsPerSec) + (n * 0x20);
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
;    2162 						*VALID_ADDR = temp_addr;
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __PUTDP1
;    2163 						return (EOF);	// file exists @ temp_addr
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x426
;    2164 					}
;    2165 				}
_0x186:
;    2166 				else					// folder
	RJMP _0x187
_0x185:
;    2167 				{
;    2168 					if ((strncmp(qp, sp, 11)==0)&&(*(sp+11)&0x10))
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
	BRNE _0x189
	LDD  R26,Y+23
	LDD  R27,Y+23+1
	ADIW R26,11
	LD   R30,X
	ANDI R30,LOW(0x10)
	BRNE _0x18A
_0x189:
	RJMP _0x188
_0x18A:
;    2169 					{
;    2170 						temp_addr = *VALID_ADDR + ((long) c * BPB_BytsPerSec) + (n * 0x20);
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
;    2171 						*VALID_ADDR = temp_addr;
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __PUTDP1
;    2172 						return (EOF);	// file exists @ temp_addr
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x426
;    2173 					}
;    2174 				}
_0x188:
_0x187:
;    2175 			}
_0x184:
;    2176 			ent_cntr++;
	__ADDWRN 16,17,1
;    2177 		}
	__ADDWRN 20,21,1
	RJMP _0x17E
_0x17F:
;    2178 		c++;
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	ADIW R30,1
	STD  Y+31,R30
	STD  Y+31+1,R31
;    2179 		if (ent_cntr == ent_max)
	__CPWRR 18,19,16,17
	BRNE _0x18B
;    2180 		{
;    2181 			if (aval_flag & 0x80)		// a folder @ a valid cluster
	LDD  R30,Y+20
	ANDI R30,LOW(0x80)
	BREQ _0x18C
;    2182 			{
;    2183 				c = next_cluster(dir_clus, SINGLE);
	LDD  R30,Y+29
	LDD  R31,Y+29+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _next_cluster
	STD  Y+31,R30
	STD  Y+31+1,R31
;    2184 				if (c != EOF)
	LDD  R26,Y+31
	LDD  R27,Y+31+1
	CPI  R26,LOW(0xFFFF)
	LDI  R30,HIGH(0xFFFF)
	CPC  R27,R30
	BREQ _0x18D
;    2185 				{	// another dir cluster exists
;    2186 					*VALID_ADDR = clust_to_addr(c);
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _clust_to_addr
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	CALL __PUTDP1
;    2187 					dir_clus = c;
	LDD  R30,Y+31
	LDD  R31,Y+31+1
	STD  Y+29,R30
	STD  Y+29+1,R31
;    2188 					ent_cntr = 0;
	__GETWRN 16,17,0
;    2189 					c = 0;
	LDI  R30,0
	STD  Y+31,R30
	STD  Y+31+1,R30
;    2190 				}
;    2191 			}
_0x18D:
;    2192 		}
_0x18C:
;    2193 	}
_0x18B:
	RJMP _0x179
_0x17B:
;    2194 	*VALID_ADDR = 0;
	LDD  R26,Y+35
	LDD  R27,Y+35+1
	__GETD1N 0x0
	CALL __PUTDP1
;    2195 	return (EOF);	
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x426:
	CALL __LOADLOCR6
	ADIW R28,37
	RET
;    2196 }
;    2197 
;    2198 #ifdef _DEBUG_ON_
;    2199 // Function to display all files and folders in the root directory, 
;    2200 // with the size of the file in bytes within the [brakets]
;    2201 void read_directory(void)
;    2202 {
;    2203 	unsigned char valid_flag, attribute_temp;
;    2204 	unsigned int c, n, d, m, dir_clus;
;    2205 	unsigned long calc, calc_clus, dir_addr;
;    2206 	
;    2207 	if (_FF_DIR_ADDR != _FF_ROOT_ADDR)
;    2208 	{
;    2209 		dir_clus = addr_to_clust(_FF_DIR_ADDR);
;    2210 		if (dir_clus == 0)
;    2211 			return;
;    2212 	}
;    2213 
;    2214 	printf("\r\nFile Listing for:  ROOT\\");
;    2215 	for (d=0; d<_FF_PATH_LENGTH; d++)
;    2216 	{
;    2217 		if (_FF_FULL_PATH[d])
;    2218 			putchar(_FF_FULL_PATH[d]);
;    2219 		else
;    2220 			break;
;    2221 	}
;    2222 	
;    2223     
;    2224     dir_addr = _FF_DIR_ADDR;
;    2225 	d = 0;
;    2226 	m = 0;
;    2227 	while (d<BPB_RootEntCnt)
;    2228 	{
;    2229     	if (_FF_read(dir_addr+(m*0x200))==0)
;    2230     		break;
;    2231 		for (n=0; n<16; n++)
;    2232 		{
;    2233 			for (c=0; c<11; c++)
;    2234 			{
;    2235 				if (_FF_buff[(n*0x20)]==0)
;    2236 				{
;    2237 					n=16;
;    2238 					d=BPB_RootEntCnt;
;    2239 					valid_flag = 0;
;    2240 					break;
;    2241 				}
;    2242 				valid_flag = 1;
;    2243 				if (valid_file_char(_FF_buff[(n*0x20)+c]))
;    2244 				{
;    2245 					valid_flag = 0;
;    2246 					break;
;    2247 				}
;    2248 		    }   
;    2249 		    if (valid_flag)
;    2250 	  		{
;    2251 		  		calc = (n * 0x20) + 0xB;
;    2252 		  		attribute_temp = _FF_buff[calc];
;    2253 		  		putchar('\n');
;    2254 				putchar('\r');
;    2255 				c = (n * 0x20);
;    2256 			  	calc = ((long) _FF_buff[c+0x1F] << 24) | ((long) _FF_buff[c+0x1E] << 16) |
;    2257 			  			((long) _FF_buff[c+0x1D] << 8) | ((long) _FF_buff[c+0x1C]);
;    2258 			  	calc_clus = ((int) _FF_buff[c+0x1B] << 8) | (int) _FF_buff[c+0x1A];
;    2259 				if (attribute_temp & 0x10)
;    2260 					printf("  [");
;    2261 				else
;    2262 			  		printf("                [%ld] bytes      (%X)\r  ", calc, calc_clus);		  		
;    2263 				for (c=0; c<8; c++)
;    2264 				{
;    2265 					calc = (n * 0x20) + c;
;    2266 					if (_FF_buff[calc]==0x20)
;    2267 						break;
;    2268 					putchar(_FF_buff[calc]);
;    2269 				}
;    2270 				if (attribute_temp & 0x10)
;    2271 				{
;    2272 					printf("]      (%X)", calc_clus);
;    2273 				}
;    2274 				else
;    2275 				{
;    2276 					putchar('.');
;    2277 					for (c=8; c<11; c++)
;    2278 					{
;    2279 						calc = (n * 0x20) + c;
;    2280 						if (_FF_buff[calc]==0x20)
;    2281 							break;
;    2282 						putchar(_FF_buff[calc]);
;    2283 					}
;    2284 				}
;    2285 		  	}
;    2286 		  	d++;		  		
;    2287 		}
;    2288 		m++;
;    2289 		if (_FF_ROOT_ADDR!=_FF_DIR_ADDR)
;    2290 		{
;    2291 		   	if (m==BPB_SecPerClus)
;    2292 		   	{
;    2293 
;    2294 				m = next_cluster(dir_clus, SINGLE);
;    2295 				if (m != EOF)
;    2296 				{	// another dir cluster exists
;    2297 					dir_addr = clust_to_addr(m);
;    2298 					dir_clus = m;
;    2299 					d = 0;
;    2300 					m = 0;
;    2301 				}
;    2302 				else
;    2303 					break;
;    2304 		   		
;    2305 		   	}
;    2306 		}
;    2307 	}
;    2308 	putchar('\n');
;    2309 	putchar('\r');	
;    2310 } 
;    2311 
;    2312 void GetVolID(void)
;    2313 {
;    2314 	printf("\r\n  Volume Serial:  [0x%lX]", BS_VolSerial);
;    2315 	printf("\r\n  Volume Label:  [%s]\r\n", BS_VolLab);
;    2316 }
;    2317 #endif
;    2318 
;    2319 // Convert a cluster number into a read address
;    2320 unsigned long clust_to_addr(unsigned int clust_no)
;    2321 {
_clust_to_addr:
;    2322 	unsigned long clust_addr;
;    2323 	
;    2324 	FirstSectorofCluster = ((clust_no - 2) * (long) BPB_SecPerClus) + (long) FirstDataSector;
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
;    2325 	clust_addr = (long) FirstSectorofCluster * (long) BPB_BytsPerSec + _FF_PART_ADDR;
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
;    2326 
;    2327 	return (clust_addr);
	ADIW R28,6
	RET
;    2328 }
;    2329 
;    2330 // Converts an address into a cluster number
;    2331 unsigned int addr_to_clust(unsigned long clus_addr)
;    2332 {
_addr_to_clust:
;    2333 	if (clus_addr <= _FF_PART_ADDR)
	LDS  R30,__FF_PART_ADDR
	LDS  R31,__FF_PART_ADDR+1
	LDS  R22,__FF_PART_ADDR+2
	LDS  R23,__FF_PART_ADDR+3
	__GETD2S 0
	CALL __CPD12
	BRLO _0x18E
;    2334 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x421
;    2335 	clus_addr -= _FF_PART_ADDR;
_0x18E:
	LDS  R26,__FF_PART_ADDR
	LDS  R27,__FF_PART_ADDR+1
	LDS  R24,__FF_PART_ADDR+2
	LDS  R25,__FF_PART_ADDR+3
	__GETD1S 0
	CALL __SUBD12
	__PUTD1S 0
;    2336 	clus_addr /= BPB_BytsPerSec;
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	__GETD2S 0
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	__PUTD1S 0
;    2337 	if (clus_addr <= (unsigned long) FirstDataSector)
	LDS  R30,_FirstDataSector
	LDS  R31,_FirstDataSector+1
	CLR  R22
	CLR  R23
	__GETD2S 0
	CALL __CPD12
	BRLO _0x18F
;    2338 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x421
;    2339 	clus_addr -= FirstDataSector;
_0x18F:
	LDS  R30,_FirstDataSector
	LDS  R31,_FirstDataSector+1
	__GETD2S 0
	CLR  R22
	CLR  R23
	CALL __SUBD21
	__PUTD2S 0
;    2340 	clus_addr /= BPB_SecPerClus;
	LDS  R30,_BPB_SecPerClus
	__GETD2S 0
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	__PUTD1S 0
;    2341 	clus_addr += 2;
	__ADDD1N 2
	__PUTD1S 0
;    2342 	if (clus_addr > 0xFFFF)
	__GETD2S 0
	__CPD2N 0x10000
	BRLO _0x190
;    2343 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x421
;    2344 	
;    2345 	return ((int) clus_addr);	
_0x190:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x421
;    2346 }
;    2347 
;    2348 // Find the cluster that the current cluster is pointing to
;    2349 unsigned int next_cluster(unsigned int current_cluster, unsigned char mode)
;    2350 {
_next_cluster:
;    2351 	unsigned int calc_sec, calc_offset, calc_remainder, next_clust;
;    2352 	unsigned long addr_temp;
;    2353 	
;    2354 	if (current_cluster<=1)		// If cluster is 0 or 1, its the wrong cluster
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
	BRSH _0x191
;    2355 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x425
;    2356 		
;    2357 	if (BPB_FATType == 0x36)		// if FAT16
_0x191:
	LDS  R26,_BPB_FATType
	CPI  R26,LOW(0x36)
	BREQ PC+3
	JMP _0x192
;    2358 	{
;    2359 		// FAT16 table address calculations
;    2360 		calc_sec = current_cluster / (BPB_BytsPerSec / 2) + BPB_RsvdSecCnt;
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
;    2361 		calc_offset = 2 * (current_cluster % (BPB_BytsPerSec / 2));
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
;    2362 	    
;    2363 	 	addr_temp = _FF_PART_ADDR+(calc_sec*0x200);
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
;    2364 		if (mode==SINGLE)
	LDD  R26,Y+12
	CPI  R26,LOW(0x1)
	BRNE _0x193
;    2365 		{	// This is a single cluster lookup
;    2366 			if (_FF_read(addr_temp)==0)
	CALL __PUTPARD1
	CALL __FF_read
	CPI  R30,0
	BRNE _0x194
;    2367 				return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x425
;    2368 		}
_0x194:
;    2369 		else if ((mode==CHAIN) || (mode==END_CHAIN))
	RJMP _0x195
_0x193:
	LDD  R26,Y+12
	CPI  R26,LOW(0x0)
	BREQ _0x197
	CPI  R26,LOW(0x2)
	BREQ _0x197
	RJMP _0x196
_0x197:
;    2370 		{	// Mupltiple clusters to lookup
;    2371 			if (addr_temp!=_FF_buff_addr)
	LDS  R30,__FF_buff_addr
	LDS  R31,__FF_buff_addr+1
	LDS  R22,__FF_buff_addr+2
	LDS  R23,__FF_buff_addr+3
	__GETD2S 6
	CALL __CPD12
	BRNE PC+3
	JMP _0x199
;    2372 			{	// Is the address of lookup is different then the current buffere address
;    2373 				#ifndef _READ_ONLY_
;    2374 				if (_FF_buff_addr)	// if the buffer address is 0, don't write
	CALL __CPD10
	BRNE PC+3
	JMP _0x19A
;    2375 				{
;    2376 					#ifdef _SECOND_FAT_ON_
;    2377 						if (_FF_buff_addr < _FF_FAT2_ADDR)
	LDS  R30,__FF_FAT2_ADDR
	LDS  R31,__FF_FAT2_ADDR+1
	LDS  R22,__FF_FAT2_ADDR+2
	LDS  R23,__FF_FAT2_ADDR+3
	LDS  R26,__FF_buff_addr
	LDS  R27,__FF_buff_addr+1
	LDS  R24,__FF_buff_addr+2
	LDS  R25,__FF_buff_addr+3
	CALL __CPD21
	BRSH _0x19B
;    2378 							if (_FF_write(_FF_buff_addr+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
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
	BRNE _0x19C
;    2379 								return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x425
;    2380 					#endif
;    2381 					if (_FF_write(_FF_buff_addr)==0)	// Save buffer data to card
_0x19C:
_0x19B:
	LDS  R30,__FF_buff_addr
	LDS  R31,__FF_buff_addr+1
	LDS  R22,__FF_buff_addr+2
	LDS  R23,__FF_buff_addr+3
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	BRNE _0x19D
;    2382 						return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x425
;    2383 				}
_0x19D:
;    2384 				#endif
;    2385 				if (_FF_read(addr_temp)==0)	// Read new table info
_0x19A:
	__GETD1S 6
	CALL __PUTPARD1
	CALL __FF_read
	CPI  R30,0
	BRNE _0x19E
;    2386 					return(EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x425
;    2387 			}
_0x19E:
;    2388 		}
_0x199:
;    2389 		next_clust = ((int) _FF_buff[calc_offset+1] << 8) | _FF_buff[calc_offset];
_0x196:
_0x195:
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
;    2390 	}
;    2391 	#ifdef _FAT12_ON_
;    2392 	else if (BPB_FATType == 0x32)	// if FAT12
;    2393 	{
;    2394 		// FAT12 table address calculations
;    2395 		calc_offset = (current_cluster * 3) / 2;
;    2396 		calc_remainder = (current_cluster * 3) % 2;
;    2397 		calc_sec = (calc_offset / BPB_BytsPerSec) + BPB_RsvdSecCnt;
;    2398 		calc_offset %= BPB_BytsPerSec;
;    2399 
;    2400 	 	addr_temp = _FF_PART_ADDR+(calc_sec*BPB_BytsPerSec);
;    2401 		if (mode==SINGLE)
;    2402 		{	// This is a single cluster lookup
;    2403 			if (_FF_read(addr_temp)==0)
;    2404 				return(EOF);
;    2405 		}
;    2406 		else if ((mode==CHAIN) || (mode==END_CHAIN))
;    2407 		{	// Mupltiple clusters to lookup
;    2408 			if (addr_temp!=_FF_buff_addr)
;    2409 			{	// Is the address of lookup is different then the current buffere address
;    2410 				#ifndef _READ_ONLY_
;    2411 				if (_FF_buff_addr)	// if the buffer address is 0, don't write
;    2412 				{
;    2413 					#ifdef _SECOND_FAT_ON_
;    2414 						if (_FF_buff_addr < _FF_FAT2_ADDR)
;    2415 							if (_FF_write(_FF_buff_addr+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
;    2416 								return(EOF);
;    2417 					#endif
;    2418 					if (_FF_write(_FF_buff_addr)==0)	// Save buffer data to card
;    2419 						return(EOF);
;    2420 				}
;    2421 				#endif
;    2422 				if (_FF_read(addr_temp)==0)	// Read new table info
;    2423 					return(EOF);
;    2424 			}
;    2425 		}
;    2426 		next_clust = _FF_buff[calc_offset];
;    2427 		if (calc_offset == (BPB_BytsPerSec-1))
;    2428 		{	// Is the FAT12 record accross more than one sector?
;    2429 			addr_temp = _FF_PART_ADDR+((calc_sec+1)*0x200);
;    2430 			if ((mode==CHAIN) || (mode==END_CHAIN))
;    2431 			{	// multiple chain lookup
;    2432 				#ifndef _READ_ONLY_
;    2433 					#ifdef _SECOND_FAT_ON_
;    2434 						if (_FF_buff_addr < _FF_FAT2_ADDR)
;    2435 							if (_FF_write(_FF_buff_addr+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
;    2436 								return(EOF);
;    2437 					#endif
;    2438 				if (_FF_write(_FF_buff_addr)==0)	// Save buffer data to card
;    2439 					return(EOF);
;    2440 				#endif
;    2441 				_FF_buff_addr = addr_temp;		// Save new buffer address
;    2442 			}
;    2443 			if (_FF_read(addr_temp)==0)
;    2444 				return(EOF);
;    2445 			next_clust |= ((int) _FF_buff[0] << 8);
;    2446 		}
;    2447 		else
;    2448 			next_clust |= ((int) _FF_buff[calc_offset+1] << 8);
;    2449 
;    2450 		if (calc_remainder)
;    2451 			next_clust >>= 4;
;    2452 		else
;    2453 			next_clust &= 0x0FFF;
;    2454 			
;    2455 		if (next_clust >= 0xFF8)
;    2456 			next_clust |= 0xF000;			
;    2457 	}
;    2458 	#endif
;    2459 	else		// not FAT12 or FAT16, return 0
	RJMP _0x19F
_0x192:
;    2460 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x425
;    2461 	return (next_clust);
_0x19F:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
_0x425:
	CALL __LOADLOCR6
	ADIW R28,15
	RET
;    2462 }
;    2463 
;    2464 // Convert a constant string file name into the proper 8.3 FAT format
;    2465 unsigned char *file_name_conversion(unsigned char *current_file)
;    2466 {
_file_name_conversion:
;    2467 	unsigned char n, c;
;    2468 		
;    2469 	c = 0;
	ST   -Y,R17
	ST   -Y,R16
;	*current_file -> Y+2
;	n -> R16
;	c -> R17
	LDI  R17,LOW(0)
;    2470 	
;    2471 	for (n=0; n<14; n++)
	LDI  R16,LOW(0)
_0x1A1:
	CPI  R16,14
	BRLO PC+3
	JMP _0x1A2
;    2472 	{
;    2473 		if (valid_file_char(current_file[n])==0)
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
	BRNE _0x1A3
;    2474 			// If the character is valid, save in uppercase to file name buffer
;    2475 			FILENAME[c++] = toupper(current_file[n]);
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
;    2476 		else if (current_file[n]=='.')
	RJMP _0x1A4
_0x1A3:
	MOV  R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BRNE _0x1A5
;    2477 			// If it is a period, back fill buffer with [spaces], till 8 characters deep
;    2478 			while (c<8)
_0x1A6:
	CPI  R17,8
	BRSH _0x1A8
;    2479 				FILENAME[c++] = 0x20;
	MOV  R30,R17
	SUBI R17,-1
	LDI  R31,0
	SUBI R30,LOW(-_FILENAME)
	SBCI R31,HIGH(-_FILENAME)
	MOVW R26,R30
	LDI  R30,LOW(32)
	ST   X,R30
;    2480 		else if (current_file[n]==0)
	RJMP _0x1A6
_0x1A8:
	RJMP _0x1A9
_0x1A5:
	MOV  R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CPI  R30,0
	BRNE _0x1AA
;    2481 		{	// If it is NULL, back fill buffer with [spaces], till 11 characters deep
;    2482 			while (c<11)
_0x1AB:
	CPI  R17,11
	BRSH _0x1AD
;    2483 				FILENAME[c++] = 0x20;
	MOV  R30,R17
	SUBI R17,-1
	LDI  R31,0
	SUBI R30,LOW(-_FILENAME)
	SBCI R31,HIGH(-_FILENAME)
	MOVW R26,R30
	LDI  R30,LOW(32)
	ST   X,R30
;    2484 			break;
	RJMP _0x1AB
_0x1AD:
	RJMP _0x1A2
;    2485 		}
;    2486 		else
_0x1AA:
;    2487 		{
;    2488 			_FF_error = NAME_ERR;
	LDI  R30,LOW(5)
	STS  __FF_error,R30
;    2489 			return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x421
;    2490 		}
_0x1A9:
_0x1A4:
;    2491 		if (c>=11)
	CPI  R17,11
	BRSH _0x1A2
;    2492 			break;
;    2493 	}
	SUBI R16,-1
	RJMP _0x1A1
_0x1A2:
;    2494 	FILENAME[c] = 0;
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_FILENAME)
	SBCI R27,HIGH(-_FILENAME)
	LDI  R30,LOW(0)
	ST   X,R30
;    2495 	// Return the pointer of the filename
;    2496 	return (FILENAME);		
	LDI  R30,LOW(_FILENAME)
	LDI  R31,HIGH(_FILENAME)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x421
;    2497 }
;    2498 
;    2499 // Find the first cluster that is pointing to clus_no
;    2500 unsigned int prev_cluster(unsigned int clus_no)
;    2501 {
;    2502 	unsigned char read_flag;
;    2503 	unsigned int calc_temp, n, c, n_temp;
;    2504 	unsigned long calc_clus, addr_temp;
;    2505 	
;    2506 	addr_temp = _FF_FAT1_ADDR;
;	clus_no -> Y+17
;	read_flag -> R16
;	calc_temp -> R17,R18
;	n -> R19,R20
;	c -> Y+15
;	n_temp -> Y+13
;	calc_clus -> Y+9
;	addr_temp -> Y+5
;    2507 	c = 1;
;    2508 	if ((clus_no==0) && (BPB_FATType==0x36))
;    2509 	{
;    2510 		if (clus_0_addr>addr_temp)
;    2511 		{
;    2512 			addr_temp = clus_0_addr;
;    2513 			c = c_counter;
;    2514 		}
;    2515 	}
;    2516 
;    2517 	read_flag = 1;
;    2518 	
;    2519 	while (addr_temp<_FF_FAT2_ADDR)
;    2520 	{
;    2521 		if (BPB_FATType == 0x36)		// if FAT16
;    2522 		{
;    2523 			if (clus_no==0)
;    2524 			{
;    2525 				clus_0_addr = addr_temp;
;    2526 				c_counter = c;
;    2527 			}
;    2528 			if (_FF_read(addr_temp)==0)		// Read error ==> break
;    2529 				return(0);
;    2530 			if (_FF_n_temp)
;    2531 			{
;    2532 				n_temp = _FF_n_temp;
;    2533 				_FF_n_temp = 0;
;    2534 			}
;    2535 			else
;    2536 				n_temp = 0;
;    2537 			for (n=n_temp; n<(BPB_BytsPerSec/2); n++)
;    2538 			{
;    2539 				calc_clus = ((unsigned int) _FF_buff[(n*2)+1] << 8) | ((unsigned int) _FF_buff[n*2]);
;    2540 				calc_temp = (unsigned long) n + (((unsigned long) BPB_BytsPerSec/2) * ((unsigned long) c - 1));
;    2541 				if (calc_clus==clus_no)
;    2542 				{
;    2543 					if (calc_clus==0)
;    2544 						_FF_n_temp = n;
;    2545 					return(calc_temp);
;    2546 				}
;    2547 				else if (calc_temp > DataClusTot)
;    2548 				{
;    2549 					_FF_error = DISK_FULL;
;    2550 					return (0);
;    2551 				}
;    2552 			}
;    2553 			addr_temp += 0x200;
;    2554 			c++;
;    2555 		}
;    2556 		#ifdef _FAT12_ON_
;    2557 		else if (BPB_FATType == 0x32)	// if FAT12
;    2558 		{
;    2559 			if (read_flag)
;    2560 			{
;    2561 				if (_FF_read(addr_temp)==0)
;    2562 					return (0);	// if the read fails return 0
;    2563 				read_flag = 0;
;    2564 			}
;    2565 			calc_temp = ((unsigned long) c * 3) / 2;
;    2566 			calc_temp %= BPB_BytsPerSec;
;    2567 			calc_clus = _FF_buff[calc_temp++];
;    2568 			if (calc_temp == BPB_BytsPerSec)
;    2569 			{	// Is the FAT12 record accross a sector?
;    2570 				addr_temp += 0x200;
;    2571 				if (_FF_read(addr_temp)==0)
;    2572 					return (0);
;    2573 				calc_clus |= ((unsigned int) _FF_buff[0] << 8);
;    2574 				calc_temp = 0;
;    2575 			}
;    2576 			else
;    2577 				calc_clus |= ((unsigned int) _FF_buff[calc_temp++] << 8);
;    2578                           	
;    2579 			if (c % 2)
;    2580 				calc_clus >>= 4;
;    2581 			else
;    2582 				calc_clus &= 0x0FFF;
;    2583 			
;    2584 			if (calc_clus == clus_no)
;    2585 				return (c);
;    2586 			else if (c > DataClusTot)
;    2587 			{
;    2588 				_FF_error = DISK_FULL;
;    2589 				return (0);
;    2590 			}
;    2591 			if ((calc_temp == BPB_BytsPerSec) && (c % 2))
;    2592 			{
;    2593 				addr_temp += 0x200;
;    2594 				read_flag = 1;
;    2595 			}                                                           
;    2596 			
;    2597 			c++;			
;    2598 		}
;    2599 		#endif
;    2600 		else
;    2601 			return (0);
;    2602 	}
;    2603 	_FF_error = DISK_FULL;
;    2604 	return (0);
;    2605 }
;    2606 
;    2607 #ifndef _READ_ONLY_
;    2608 // Update cluster table to point to new cluster
;    2609 unsigned char write_clus_table(unsigned int current_cluster, unsigned int next_value, unsigned char mode)
;    2610 {
_write_clus_table:
;    2611 	unsigned long addr_temp;
;    2612 	unsigned int calc_sec, calc_offset, calc_temp, calc_remainder;
;    2613 	unsigned char nibble[3];
;    2614 	
;    2615 	if (current_cluster <=1)		// Should never be writing to cluster 0 or 1
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
	BRSH _0x1C4
;    2616 	{
;    2617 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x424
;    2618 	}
;    2619 	if (BPB_FATType == 0x36)		// if FAT16
_0x1C4:
	LDS  R26,_BPB_FATType
	CPI  R26,LOW(0x36)
	BREQ PC+3
	JMP _0x1C5
;    2620 	{
;    2621 		calc_sec = current_cluster / (BPB_BytsPerSec / 2) + BPB_RsvdSecCnt;
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
;    2622 		calc_offset = 2 * (current_cluster % (BPB_BytsPerSec / 2));
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
;    2623 		addr_temp = _FF_PART_ADDR + ((long) calc_sec*0x200);
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
;    2624 		if (mode==SINGLE)
	LDD  R26,Y+15
	CPI  R26,LOW(0x1)
	BRNE _0x1C6
;    2625 		{	// Updating a single cluster (like writing or saving a file)
;    2626 			if (_FF_read(addr_temp)==0)
	CALL __PUTPARD1
	CALL __FF_read
	CPI  R30,0
	BRNE _0x1C7
;    2627 				return(0);
	LDI  R30,LOW(0)
	RJMP _0x424
;    2628 		}
_0x1C7:
;    2629 		else if ((mode==CHAIN) || (mode==END_CHAIN))
	RJMP _0x1C8
_0x1C6:
	LDD  R26,Y+15
	CPI  R26,LOW(0x0)
	BREQ _0x1CA
	CPI  R26,LOW(0x2)
	BREQ _0x1CA
	RJMP _0x1C9
_0x1CA:
;    2630 		{	// Multiple table access operation
;    2631 			if (addr_temp!=_FF_buff_addr)
	LDS  R30,__FF_buff_addr
	LDS  R31,__FF_buff_addr+1
	LDS  R22,__FF_buff_addr+2
	LDS  R23,__FF_buff_addr+3
	__GETD2S 11
	CALL __CPD12
	BRNE PC+3
	JMP _0x1CC
;    2632 			{	// if the desired address is already in the buffer => skip loading buffer
;    2633 				if (_FF_buff_addr)	// if new table address, write buffered, and load new
	CALL __CPD10
	BRNE PC+3
	JMP _0x1CD
;    2634 				{
;    2635 					#ifdef _SECOND_FAT_ON_
;    2636 						if (_FF_buff_addr < _FF_FAT2_ADDR)
	LDS  R30,__FF_FAT2_ADDR
	LDS  R31,__FF_FAT2_ADDR+1
	LDS  R22,__FF_FAT2_ADDR+2
	LDS  R23,__FF_FAT2_ADDR+3
	LDS  R26,__FF_buff_addr
	LDS  R27,__FF_buff_addr+1
	LDS  R24,__FF_buff_addr+2
	LDS  R25,__FF_buff_addr+3
	CALL __CPD21
	BRSH _0x1CE
;    2637 							if (_FF_write(_FF_buff_addr+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
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
	BRNE _0x1CF
;    2638 								return(0);
	LDI  R30,LOW(0)
	RJMP _0x424
;    2639 					#endif
;    2640 					if (_FF_write(_FF_buff_addr)==0)
_0x1CF:
_0x1CE:
	LDS  R30,__FF_buff_addr
	LDS  R31,__FF_buff_addr+1
	LDS  R22,__FF_buff_addr+2
	LDS  R23,__FF_buff_addr+3
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	BRNE _0x1D0
;    2641 						return(0);
	LDI  R30,LOW(0)
	RJMP _0x424
;    2642 				}
_0x1D0:
;    2643 				if (_FF_read(addr_temp)==0)
_0x1CD:
	__GETD1S 11
	CALL __PUTPARD1
	CALL __FF_read
	CPI  R30,0
	BRNE _0x1D1
;    2644 					return(0);
	LDI  R30,LOW(0)
	RJMP _0x424
;    2645 			}
_0x1D1:
;    2646 		}
_0x1CC:
;    2647 				
;    2648 		_FF_buff[calc_offset+1] = (next_value >> 8); 
_0x1C9:
_0x1C8:
	MOVW R30,R18
	__ADDW1MN __FF_buff,1
	MOVW R26,R30
	LDD  R30,Y+17
	ANDI R31,HIGH(0x0)
	ST   X,R30
;    2649 		_FF_buff[calc_offset] = (next_value & 0xFF);
	MOVW R26,R18
	SUBI R26,LOW(-__FF_buff)
	SBCI R27,HIGH(-__FF_buff)
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ANDI R31,HIGH(0xFF)
	ST   X,R30
;    2650 		if ((mode==SINGLE) || (mode==END_CHAIN))
	LDD  R26,Y+15
	CPI  R26,LOW(0x1)
	BREQ _0x1D3
	CPI  R26,LOW(0x2)
	BRNE _0x1D2
_0x1D3:
;    2651 		{
;    2652 			#ifdef _SECOND_FAT_ON_
;    2653 				if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
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
	BRNE _0x1D5
;    2654 					return(0);
	LDI  R30,LOW(0)
	RJMP _0x424
;    2655 			#endif
;    2656 			if (_FF_write(addr_temp)==0)
_0x1D5:
	__GETD1S 11
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	BRNE _0x1D6
;    2657 			{
;    2658 				return(0);
	LDI  R30,LOW(0)
	RJMP _0x424
;    2659 			}
;    2660 		}
_0x1D6:
;    2661 	}
_0x1D2:
;    2662 	#ifdef _FAT12_ON_
;    2663 		else if (BPB_FATType == 0x32)		// if FAT12
;    2664 		{
;    2665 			calc_offset = (current_cluster * 3) / 2;
;    2666 			calc_remainder = (current_cluster * 3) % 2;
;    2667 			calc_sec = calc_offset / BPB_BytsPerSec + BPB_RsvdSecCnt;
;    2668 			calc_offset %= BPB_BytsPerSec;
;    2669 			addr_temp = _FF_PART_ADDR + ((long) calc_sec * (long) BPB_BytsPerSec);
;    2670 
;    2671 			if (mode==SINGLE)
;    2672 			{
;    2673 				if (_FF_read(addr_temp)==0)
;    2674 					return(0);
;    2675  			}
;    2676  			else if ((mode==CHAIN) || (mode==END_CHAIN))
;    2677   			{
;    2678 				if (addr_temp!=_FF_buff_addr)
;    2679 				{
;    2680 					if (_FF_buff_addr)
;    2681 					{
;    2682 					#ifdef _SECOND_FAT_ON_
;    2683 						if (_FF_buff_addr < _FF_FAT2_ADDR)
;    2684 							if (_FF_write(_FF_buff_addr+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
;    2685 								return(0);
;    2686 					#endif
;    2687 						if (_FF_write(_FF_buff_addr)==0)
;    2688 							return(0);
;    2689 					}
;    2690 					if (_FF_read(addr_temp)==0)
;    2691 						return(0);
;    2692 				}
;    2693 			}
;    2694 			nibble[0] = next_value & 0x00F;
;    2695 			nibble[1] = (next_value >> 4) & 0x00F;
;    2696 			nibble[2] = (next_value >> 8) & 0x00F;
;    2697     	
;    2698 			if (calc_offset == (BPB_BytsPerSec-1))
;    2699 			{	// Is the FAT12 record accross a sector?
;    2700 				if (calc_remainder)
;    2701 				{	// Record table uses 1 nibble of last byte
;    2702 					calc_temp = _FF_buff[calc_offset] & 0x0F;	// Mask to add new value
;    2703 					_FF_buff[calc_offset] = calc_temp | (nibble[0] << 4);	// store nibble in correct location
;    2704 					#ifdef _SECOND_FAT_ON_
;    2705 						if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
;    2706 							return(0);
;    2707 					#endif
;    2708 					if (_FF_write(addr_temp)==0)
;    2709 						return(0);
;    2710 					addr_temp += BPB_BytsPerSec;
;    2711 					if (_FF_read(addr_temp)==0)
;    2712 						return(0);	// if the read fails return 0
;    2713 					_FF_buff[0] = (nibble[2] << 4) | nibble[1];
;    2714 					if ((mode==SINGLE) || (mode==END_CHAIN))
;    2715 					{
;    2716 						#ifdef _SECOND_FAT_ON_
;    2717 							if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
;    2718 								return(0);
;    2719 						#endif
;    2720 						if (_FF_write(addr_temp)==0)
;    2721 							return(0);
;    2722 					}
;    2723 				}
;    2724 				else
;    2725 				{	// Record table uses whole last byte
;    2726 					_FF_buff[calc_offset] = (nibble[1] << 4) | nibble[0];
;    2727 					#ifdef _SECOND_FAT_ON_
;    2728 						if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
;    2729 							return(0);
;    2730 					#endif
;    2731 					if (_FF_write(addr_temp)==0)
;    2732 						return(0);
;    2733 					addr_temp += BPB_BytsPerSec;
;    2734 					if (_FF_read(addr_temp)==0)
;    2735 						return(0);	// if the read fails return 0
;    2736 					calc_temp = _FF_buff[0] & 0xF0;		// Mask to add new value
;    2737 					_FF_buff[0] = calc_temp | nibble[2];	// store nibble in correct location
;    2738 					if ((mode==SINGLE) || (mode==END_CHAIN))
;    2739 					{
;    2740 						#ifdef _SECOND_FAT_ON_
;    2741 							if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
;    2742 								return(0);
;    2743 						#endif
;    2744 						if (_FF_write(addr_temp)==0)
;    2745 							return(0);
;    2746 					}
;    2747 				}
;    2748 			}
;    2749 			else
;    2750 			{
;    2751 				if (calc_remainder)
;    2752 				{	// Record table uses 1 nibble of current byte
;    2753 					calc_temp = _FF_buff[calc_offset] & 0x0F;	// Mask to add new value
;    2754 					_FF_buff[calc_offset] = calc_temp | (nibble[0] << 4);	// store nibble in correct location
;    2755 					_FF_buff[calc_offset+1] = (nibble[2] << 4) | nibble[1];
;    2756 					if ((mode==SINGLE) || (mode==END_CHAIN))
;    2757 					{
;    2758 						#ifdef _SECOND_FAT_ON_
;    2759 							if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
;    2760 								return(0);
;    2761 						#endif
;    2762 						if (_FF_write(addr_temp)==0)
;    2763 							return(0);
;    2764 					}
;    2765 				}
;    2766 				else
;    2767 				{	// Record table uses whole current byte
;    2768 					_FF_buff[calc_offset] = (nibble[1] << 4) | nibble[0];
;    2769 					calc_temp = _FF_buff[calc_offset+1] & 0xF0;		// Mask to add new value
;    2770 					_FF_buff[calc_offset+1] = calc_temp | nibble[2];	// store nibble in correct location
;    2771 					if ((mode==SINGLE) || (mode==END_CHAIN))
;    2772 					{
;    2773 						#ifdef _SECOND_FAT_ON_
;    2774 							if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
;    2775 								return(0);
;    2776 						#endif
;    2777 						if (_FF_write(addr_temp)==0)
;    2778 							return(0);
;    2779 					}
;    2780 				}
;    2781 			}
;    2782 		}
;    2783 	#endif
;    2784 	else		// not FAT12 or FAT16, return 0
	RJMP _0x1D7
_0x1C5:
;    2785 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x424
;    2786 		
;    2787 	return(1);	
_0x1D7:
	LDI  R30,LOW(1)
_0x424:
	CALL __LOADLOCR6
	ADIW R28,20
	RET
;    2788 }
;    2789 #endif
;    2790 
;    2791 #ifndef _READ_ONLY_
;    2792 // Save new entry data to FAT entry
;    2793 unsigned char append_toc(FILE *rp)
;    2794 {
_append_toc:
;    2795 	unsigned long file_data;
;    2796 	unsigned char n;
;    2797 	unsigned char *fp;
;    2798 	unsigned int calc_temp, calc_date;
;    2799 	
;    2800 	if (rp==NULL)
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
	BRNE _0x1D8
;    2801 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x423
;    2802 
;    2803 	file_data = rp->length;
_0x1D8:
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	CALL __GETD1P
	__PUTD1S 7
;    2804 	if (_FF_read(rp->entry_sec_addr)==0)
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	__GETD2Z 22
	CALL __PUTPARD2
	CALL __FF_read
	CPI  R30,0
	BRNE _0x1D9
;    2805 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x423
;    2806 	
;    2807 	// Update Starting Cluster 
;    2808 	fp = &_FF_buff[rp->entry_offset+0x1a];
_0x1D9:
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	ADIW R26,26
	CALL __GETW1P
	__ADDW1MN __FF_buff,26
	__PUTW1R 17,18
;    2809 	*fp++ = rp->clus_start & 0xFF;
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
;    2810 	*fp++ = rp->clus_start >> 8;
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
;    2811 	
;    2812 	// Update the File Size
;    2813 	for (n=0; n<4; n++)
	LDI  R16,LOW(0)
_0x1DB:
	CPI  R16,4
	BRSH _0x1DC
;    2814 	{
;    2815 		*fp = file_data & 0xFF;
	__GETD1S 7
	__ANDD1N 0xFF
	__GETW2R 17,18
	ST   X,R30
;    2816 		file_data >>= 8;
	__GETD2S 7
	LDI  R30,LOW(8)
	CALL __LSRD12
	__PUTD1S 7
;    2817 		fp++;
	__ADDWRN 17,18,1
;    2818 	}
	SUBI R16,-1
	RJMP _0x1DB
_0x1DC:
;    2819 	
;    2820 	
;    2821 	fp = &_FF_buff[rp->entry_offset+0x16];
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	ADIW R26,26
	CALL __GETW1P
	__ADDW1MN __FF_buff,22
	__PUTW1R 17,18
;    2822 	#ifdef _RTC_ON_ 	// Date/Time Stamp file w/ RTC
;    2823 		rtc_get_timeNdate(&rtc_hour, &rtc_min, &rtc_sec, &rtc_date, &rtc_month, (int *)&rtc_year);	    			
;    2824 		calc_temp = ((int)rtc_sec&0x1F) | (((int)rtc_min&0x3F)<<5) | (((int)rtc_hour&0x1F)<<11);
;    2825 		*fp++ = calc_temp&0x00FF;	// File create Time 
;    2826 		*fp++ = (calc_temp&0xFF00) >> 8;
;    2827 		calc_date = ((int)rtc_date&0x1F) | (((int)rtc_month&0x0F)<<5) | (((rtc_year-1980)&0x7F)<<9);
;    2828 		*fp++ = calc_date&0x00FF;	// File create Date
;    2829 		*fp++ = (calc_date&0xFF00) >> 8;
;    2830 	#else		// Increment Date Code, no RTC used 
;    2831 		file_data = 0;
	__CLRD1S 7
;    2832 		for (n=0; n<4; n++)
	LDI  R16,LOW(0)
_0x1DE:
	CPI  R16,4
	BRSH _0x1DF
;    2833 		{
;    2834 			file_data <<= 8;
	__GETD2S 7
	LDI  R30,LOW(8)
	CALL __LSLD12
	__PUTD1S 7
;    2835 			file_data |= *fp;
	__GETW2R 17,18
	LD   R30,X
	__GETD2S 7
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __ORD12
	__PUTD1S 7
;    2836 			fp--;
	__SUBWRN 17,18,1
;    2837 		}
	SUBI R16,-1
	RJMP _0x1DE
_0x1DF:
;    2838 		file_data++;
	__GETD1S 7
	__SUBD1N -1
	__PUTD1S 7
;    2839 		for (n=0; n<4; n++)
	LDI  R16,LOW(0)
_0x1E1:
	CPI  R16,4
	BRSH _0x1E2
;    2840 		{
;    2841 			fp++;
	__ADDWRN 17,18,1
;    2842 			*fp = file_data & 0xFF;
	__GETD1S 7
	__ANDD1N 0xFF
	__GETW2R 17,18
	ST   X,R30
;    2843 			file_data >>=8;
	__GETD2S 7
	LDI  R30,LOW(8)
	CALL __LSRD12
	__PUTD1S 7
;    2844 		}
	SUBI R16,-1
	RJMP _0x1E1
_0x1E2:
;    2845 	#endif
;    2846 	if (_FF_write(rp->entry_sec_addr)==0)
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	__GETD2Z 22
	CALL __PUTPARD2
	CALL __FF_write
	CPI  R30,0
	BRNE _0x1E3
;    2847 		return(0);
	LDI  R30,LOW(0)
	RJMP _0x423
;    2848 	
;    2849 	return(1);
_0x1E3:
	LDI  R30,LOW(1)
_0x423:
	CALL __LOADLOCR5
	ADIW R28,13
	RET
;    2850 }
;    2851 #endif
;    2852 
;    2853 #ifndef _READ_ONLY_
;    2854 // Erase a chain of clusters (set table entries to 0 for clusters in chain)
;    2855 unsigned char erase_clus_chain(unsigned int start_clus)
;    2856 {
_erase_clus_chain:
;    2857 	unsigned int clus_temp, clus_use;
;    2858 	
;    2859 	if (start_clus==0)
	CALL __SAVELOCR4
;	start_clus -> Y+4
;	clus_temp -> R16,R17
;	clus_use -> R18,R19
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BRNE _0x1E4
;    2860 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x422
;    2861 	clus_use = start_clus;
_0x1E4:
	__GETWRS 18,19,4
;    2862 	_FF_buff_addr = 0;
	LDI  R30,0
	STS  __FF_buff_addr,R30
	STS  __FF_buff_addr+1,R30
	STS  __FF_buff_addr+2,R30
	STS  __FF_buff_addr+3,R30
;    2863 	while(clus_use <= 0xFFF8)
_0x1E5:
	__CPWRN 18,19,65529
	BRSH _0x1E7
;    2864 	{
;    2865 		clus_temp = next_cluster(clus_use, CHAIN);
	ST   -Y,R19
	ST   -Y,R18
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _next_cluster
	MOVW R16,R30
;    2866 		if ((clus_temp >= 0xFFF8) || (clus_temp == 0))
	__CPWRN 16,17,65528
	BRSH _0x1E9
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRNE _0x1E8
_0x1E9:
;    2867 			break;
	RJMP _0x1E7
;    2868 		if (write_clus_table(clus_use, 0, CHAIN) == 0)
_0x1E8:
	ST   -Y,R19
	ST   -Y,R18
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R30
	CALL _write_clus_table
	CPI  R30,0
	BRNE _0x1EB
;    2869 			return (0);
	LDI  R30,LOW(0)
	RJMP _0x422
;    2870 		clus_use = clus_temp;
_0x1EB:
	__MOVEWRR 18,19,16,17
;    2871 	}
	RJMP _0x1E5
_0x1E7:
;    2872 	if (write_clus_table(clus_use, 0, END_CHAIN) == 0)
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
	BRNE _0x1EC
;    2873 		return (0);
	LDI  R30,LOW(0)
	RJMP _0x422
;    2874 	clus_0_addr = 0;
_0x1EC:
	LDI  R30,0
	STS  _clus_0_addr,R30
	STS  _clus_0_addr+1,R30
	STS  _clus_0_addr+2,R30
	STS  _clus_0_addr+3,R30
;    2875 	c_counter = 0;
	LDI  R30,0
	STS  _c_counter,R30
	STS  _c_counter+1,R30
;    2876 	
;    2877 	return (1);	
	LDI  R30,LOW(1)
_0x422:
	CALL __LOADLOCR4
	ADIW R28,6
	RET
;    2878 }
;    2879 
;    2880 // Quickformat of a card (erase cluster table and root directory
;    2881 int fquickformat(void)
;    2882 {
_fquickformat:
;    2883 	long c;
;    2884 	
;    2885 	for (c=0; c<BPB_BytsPerSec; c++)
	SBIW R28,4
;	c -> Y+0
	__CLRD1S 0
_0x1EE:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	__GETD2S 0
	CLR  R22
	CLR  R23
	CALL __CPD21
	BRGE _0x1EF
;    2886 		_FF_buff[c] = 0;
	__GETD1S 0
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	MOVW R26,R30
	LDI  R30,LOW(0)
	ST   X,R30
;    2887 	
;    2888 	c = _FF_FAT1_ADDR + 0x200;
	__GETD1S 0
	__SUBD1N -1
	__PUTD1S 0
	RJMP _0x1EE
_0x1EF:
	LDS  R30,__FF_FAT1_ADDR
	LDS  R31,__FF_FAT1_ADDR+1
	LDS  R22,__FF_FAT1_ADDR+2
	LDS  R23,__FF_FAT1_ADDR+3
	__ADDD1N 512
	__PUTD1S 0
;    2889 	while (c < (_FF_ROOT_ADDR + (0x400 * BPB_SecPerClus)))
_0x1F0:
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
	BRSH _0x1F2
;    2890 	{
;    2891 		if (_FF_write(c)==0)
	__GETD1S 0
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	BRNE _0x1F3
;    2892 		{
;    2893 			_FF_error = WRITE_ERR;
	LDI  R30,LOW(3)
	STS  __FF_error,R30
;    2894 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x421
;    2895 		}
;    2896 		c += 0x200;
_0x1F3:
	__GETD1S 0
	__ADDD1N 512
	__PUTD1S 0
;    2897 	}	
	RJMP _0x1F0
_0x1F2:
;    2898 	_FF_buff[0] = 0xF8;
	LDI  R30,LOW(248)
	STS  __FF_buff,R30
;    2899 	_FF_buff[1] = 0xFF;
	LDI  R30,LOW(255)
	__PUTB1MN __FF_buff,1
;    2900 	_FF_buff[2] = 0xFF;
	__PUTB1MN __FF_buff,2
;    2901 	if (BPB_FATType == 0x36)
	LDS  R26,_BPB_FATType
	CPI  R26,LOW(0x36)
	BRNE _0x1F4
;    2902 		_FF_buff[3] = 0xFF;
	__PUTB1MN __FF_buff,3
;    2903 	if ((_FF_write(_FF_FAT1_ADDR)==0) || (_FF_write(_FF_FAT2_ADDR)==0))
_0x1F4:
	LDS  R30,__FF_FAT1_ADDR
	LDS  R31,__FF_FAT1_ADDR+1
	LDS  R22,__FF_FAT1_ADDR+2
	LDS  R23,__FF_FAT1_ADDR+3
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	BREQ _0x1F6
	LDS  R30,__FF_FAT2_ADDR
	LDS  R31,__FF_FAT2_ADDR+1
	LDS  R22,__FF_FAT2_ADDR+2
	LDS  R23,__FF_FAT2_ADDR+3
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	BRNE _0x1F5
_0x1F6:
;    2904 	{
;    2905 		_FF_error = WRITE_ERR;
	LDI  R30,LOW(3)
	STS  __FF_error,R30
;    2906 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x421
;    2907 	}
;    2908 	return (0);
_0x1F5:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x421:
	ADIW R28,4
	RET
;    2909 }
;    2910 #endif
;    2911 
;    2912 // function that checks for directory changes then gets into a working form
;    2913 int _FF_checkdir(char *F_PATH, unsigned long *SAVE_ADDR, char *path_temp)
;    2914 {
__FF_checkdir:
;    2915 	unsigned char *sp, *qp;
;    2916     
;    2917     *SAVE_ADDR = _FF_DIR_ADDR;	// save local dir addr
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
;    2918     
;    2919     qp = F_PATH;
	__GETWRS 18,19,8
;    2920     if (*qp=='\\')
	MOVW R26,R18
	LD   R26,X
	CPI  R26,LOW(0x5C)
	BRNE _0x1F8
;    2921     {
;    2922     	_FF_DIR_ADDR = _FF_ROOT_ADDR;
	LDS  R30,__FF_ROOT_ADDR
	LDS  R31,__FF_ROOT_ADDR+1
	LDS  R22,__FF_ROOT_ADDR+2
	LDS  R23,__FF_ROOT_ADDR+3
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    2923 		qp++;
	__ADDWRN 18,19,1
;    2924 	}
;    2925 
;    2926 	sp = path_temp;
_0x1F8:
	__GETWRS 16,17,4
;    2927 	while(*qp)
_0x1F9:
	MOVW R26,R18
	LD   R30,X
	CPI  R30,0
	BREQ _0x1FB
;    2928 	{
;    2929 		if ((valid_file_char(*qp)==0) || (*qp=='.'))
	ST   -Y,R30
	CALL _valid_file_char
	SBIW R30,0
	BREQ _0x1FD
	MOVW R26,R18
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BRNE _0x1FC
_0x1FD:
;    2930 			*sp++ = toupper(*qp++);
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
;    2931 		else if (*qp=='\\')
	RJMP _0x1FF
_0x1FC:
	MOVW R26,R18
	LD   R26,X
	CPI  R26,LOW(0x5C)
	BRNE _0x200
;    2932 		{
;    2933 			*sp = 0;	// terminate string
	MOVW R26,R16
	LDI  R30,LOW(0)
	ST   X,R30
;    2934 			if (_FF_chdir(path_temp))
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL __FF_chdir
	SBIW R30,0
	BREQ _0x201
;    2935 			{
;    2936 				return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x420
;    2937 			}
;    2938 			sp = path_temp;
_0x201:
	__GETWRS 16,17,4
;    2939 			qp++;
	__ADDWRN 18,19,1
;    2940 		}
;    2941 		else
	RJMP _0x202
_0x200:
;    2942 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x420
;    2943 	}
_0x202:
_0x1FF:
	RJMP _0x1F9
_0x1FB:
;    2944 	
;    2945 	*sp = 0;		// terminate string
	MOVW R26,R16
	LDI  R30,LOW(0)
	ST   X,R30
;    2946 	return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x420:
	CALL __LOADLOCR4
	ADIW R28,10
	RET
;    2947 }
;    2948 
;    2949 #ifndef _READ_ONLY_
;    2950 int mkdir(char *F_PATH)
;    2951 {
;    2952 	unsigned char *sp, *qp;
;    2953 	unsigned char fpath[14];
;    2954 	unsigned int c, calc_temp, clus_temp, calc_time, calc_date;
;    2955 	int s;
;    2956 	unsigned long addr_temp, path_addr_temp;
;    2957     
;    2958     addr_temp = 0;	// save local dir addr
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
;    2959     
;    2960     if (_FF_checkdir(F_PATH, &addr_temp, fpath))
;    2961 	{
;    2962 		_FF_DIR_ADDR = addr_temp;
;    2963 		return (EOF);
;    2964 	}
;    2965     
;    2966 	path_addr_temp = _FF_DIR_ADDR;
;    2967 	s = scan_directory(&path_addr_temp, fpath);
;    2968 	if ((s) || (path_addr_temp==0))
;    2969 	{
;    2970 		_FF_DIR_ADDR = addr_temp;
;    2971 		return (EOF);
;    2972 	}
;    2973 	clus_temp = prev_cluster(0);				
;    2974 	calc_temp = path_addr_temp % BPB_BytsPerSec;
;    2975 	path_addr_temp -= calc_temp;
;    2976 	if (_FF_read(path_addr_temp)==0)	
;    2977 	{
;    2978 		_FF_DIR_ADDR = addr_temp;
;    2979 		return (EOF);
;    2980 	}
;    2981 	
;    2982 	sp = &_FF_buff[calc_temp];
;    2983 	qp = fpath;
;    2984 
;    2985 	for (c=0; c<11; c++)	// Write Folder name
;    2986 	{
;    2987 	 	if (*qp)
;    2988 		 	*sp++ = *qp++;
;    2989 		else 
;    2990 			*sp++ = 0x20;	// '0' pad
;    2991 	}
;    2992 	*sp++ = 0x10;				// Attribute bit auto set to "Directory"
;    2993 	*sp++ = 0;					// Reserved for WinNT
;    2994 	*sp++ = 0;					// Mili-second stamp for create
;    2995 	for (c=0; c<4; c++)			// set create and modify time to '0'
;    2996 		*sp++ = 0;
;    2997 	*sp++ = 0;					// File access date (2 bytes)
;    2998 	*sp++ = 0;
;    2999 	*sp++ = 0;					// 0 for FAT12/16 (2 bytes)
;    3000 	*sp++ = 0;
;    3001 	#ifdef _RTC_ON_
;    3002 		rtc_get_timeNdate(&rtc_hour, &rtc_min, &rtc_sec, &rtc_date, &rtc_month, (int *)&rtc_year);	    			
;    3003 		calc_time = ((int)rtc_sec&0x1F) | (((int)rtc_min&0x3F)<<5) | (((int)rtc_hour&0x1F)<<11);
;    3004 		*sp++ = calc_time&0x00FF;	// File modify Time 
;    3005 		*sp++ = (calc_time&0xFF00) >> 8;
;    3006 		calc_date = ((int)rtc_date&0x1F) | (((int)rtc_month&0x0F)<<5) | (((rtc_year-1980)&0x7F)<<9);
;    3007 		*sp++ = calc_date&0x00FF;	// File modify Date
;    3008 		*sp++ = (calc_date&0xFF00) >> 8;
;    3009 	#else
;    3010 		for (c=0; c<4; c++)			// set file create and modify time to '0'
;    3011 			*sp++ = 0;
;    3012 	#endif
;    3013 	
;    3014 	*sp++ = clus_temp & 0xFF;				// Starting cluster (2 bytes)
;    3015 	*sp++ = (clus_temp >> 8) & 0xFF;
;    3016 	for (c=0; c<4; c++)
;    3017 		*sp++ = 0;			// File length (0 for folder)
;    3018 
;    3019 	
;    3020 	if (_FF_write(path_addr_temp)==0)	// write entry to card
;    3021 	{
;    3022 		_FF_DIR_ADDR = addr_temp;
;    3023 		return (EOF);
;    3024 	}
;    3025 	if (write_clus_table(clus_temp, 0xFFFF, SINGLE)==0)
;    3026 	{
;    3027 		_FF_DIR_ADDR = addr_temp;
;    3028 		return (EOF);
;    3029 	}
;    3030 	if (_FF_read(_FF_DIR_ADDR)==0)	
;    3031 	{
;    3032 		_FF_DIR_ADDR = addr_temp;
;    3033 		return (EOF);
;    3034 	}
;    3035 	if (_FF_DIR_ADDR != _FF_ROOT_ADDR)
;    3036 	{
;    3037 		sp = &_FF_buff[0];
;    3038 		qp = &_FF_buff[0x20];
;    3039 		for (c=0; c<0x20; c++)
;    3040 			*qp++ = *sp++;
;    3041 		_FF_buff[1] = ' ';
;    3042 		for (c=0x3C; c<0x40; c++)
;    3043 			_FF_buff[c] = 0;
;    3044 	}
;    3045 	else
;    3046 	{
;    3047 		for (c=0x01; c<0x0B; c++)
;    3048 			_FF_buff[c] = 0x20;
;    3049 		for (c=0x0C; c<0x20; c++)
;    3050 			_FF_buff[c] = 0;
;    3051 		_FF_buff[0] = '.';
;    3052 		_FF_buff[0x0B] = 0x10;
;    3053 		#ifdef _RTC_ON_
;    3054 			_FF_buff[0x0E] = calc_time&0x00FF;	// File modify Time 
;    3055 			_FF_buff[0x0F] = (calc_time&0xFF00) >> 8;
;    3056 			_FF_buff[0x10] = calc_date&0x00FF;	// File modify Date
;    3057 			_FF_buff[0x11] = (calc_date&0xFF00) >> 8;
;    3058 			_FF_buff[0x16] = calc_time&0x00FF;	// File modify Time 
;    3059 			_FF_buff[0x17] = (calc_time&0xFF00) >> 8;
;    3060 			_FF_buff[0x18] = calc_date&0x00FF;	// File modify Date
;    3061 			_FF_buff[0x19] = (calc_date&0xFF00) >> 8;
;    3062 		#endif
;    3063 		for (c=0x3A; c<0x40; c++)
;    3064 			_FF_buff[c] = 0;
;    3065 	}
;    3066 	for (c=0x22; c<0x2B; c++)
;    3067 		_FF_buff[c] = 0x20;
;    3068 	#ifdef _RTC_ON_
;    3069 		_FF_buff[0x2E] = calc_time&0x00FF;	// File modify Time 
;    3070 		_FF_buff[0x2F] = (calc_time&0xFF00) >> 8;
;    3071 		_FF_buff[0x30] = calc_date&0x00FF;	// File modify Date
;    3072 		_FF_buff[0x31] = (calc_date&0xFF00) >> 8;
;    3073 		_FF_buff[0x36] = calc_time&0x00FF;	// File modify Time 
;    3074 		_FF_buff[0x37] = (calc_time&0xFF00) >> 8;
;    3075 		_FF_buff[0x38] = calc_date&0x00FF;	// File modify Date
;    3076 		_FF_buff[0x39] = (calc_date&0xFF00) >> 8;
;    3077 	#endif
;    3078 	_FF_buff[0x20] = '.';
;    3079 	_FF_buff[0x21] = '.';
;    3080 	_FF_buff[0x2B] = 0x10;
;    3081 
;    3082 	_FF_buff[0x1A] = clus_temp & 0xFF;				// Starting cluster (2 bytes)
;    3083 	_FF_buff[0x1B] = (clus_temp >> 8) & 0xFF;
;    3084 	for (c=0x40; c<BPB_BytsPerSec; c++)
;    3085 		_FF_buff[c] = 0;
;    3086 	path_addr_temp = clust_to_addr(clus_temp);
;    3087 
;    3088 	_FF_DIR_ADDR = addr_temp;	// reset dir addr
;    3089 	if (_FF_write(path_addr_temp)==0)	
;    3090 		return (EOF);
;    3091 	for (c=0; c<0x40; c++)
;    3092 		_FF_buff[c] = 0;
;    3093 	for (c=1; c<BPB_SecPerClus; c++)
;    3094 	{
;    3095 		if (_FF_write(path_addr_temp+((long)c*0x200))==0)	
;    3096 			return (EOF);
;    3097 	}
;    3098 	return (0);		
;    3099 }
;    3100 
;    3101 int rmdir(char *F_PATH)
;    3102 {
;    3103 	unsigned char *sp;
;    3104 	unsigned char fpath[14];
;    3105 	unsigned int c, n, calc_temp, clus_temp;
;    3106 	int s;
;    3107 	unsigned long addr_temp, path_addr_temp;
;    3108 	
;    3109 	addr_temp = 0;	// save local dir addr
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
;    3110     
;    3111     if (_FF_checkdir(F_PATH, &addr_temp, fpath))
;    3112 	{
;    3113 		_FF_DIR_ADDR = addr_temp;
;    3114 		return (EOF);
;    3115 	}
;    3116 	if (fpath[0]==0)
;    3117 	{
;    3118 		_FF_DIR_ADDR = addr_temp;
;    3119 		return (EOF);
;    3120 	}
;    3121 
;    3122     path_addr_temp = _FF_DIR_ADDR;	// save addr for later
;    3123 	
;    3124 	if (_FF_chdir(fpath))	// Change directory to dir to be deleted
;    3125 	{	
;    3126 		_FF_DIR_ADDR = addr_temp;
;    3127 		return (EOF);
;    3128 	}
;    3129 	if ((_FF_DIR_ADDR==_FF_ROOT_ADDR)||(_FF_DIR_ADDR==addr_temp))
;    3130 	{	// if trying to delete root, or current dir error
;    3131 		_FF_DIR_ADDR = addr_temp;
;    3132 		return (EOF);
;    3133 	}
;    3134 	
;    3135 	for (c=0; c<BPB_SecPerClus; c++)
;    3136 	{	// scan through dir to see if it is empty
;    3137 		if (_FF_read(_FF_DIR_ADDR+((long)c*0x200))==0)
;    3138 		{	// read sectors 	
;    3139 			_FF_DIR_ADDR = addr_temp;
;    3140 			return (EOF);
;    3141 		}
;    3142 		for (n=0; n<0x10; n++)
;    3143 		{
;    3144 			if ((c==0)&&(n==0))	// skip first 2 entries 
;    3145 				n=2;
;    3146 			sp = &_FF_buff[n*0x20];
;    3147 			if (*sp==0)
;    3148 			{	// 
;    3149 				c = BPB_SecPerClus;
;    3150 				break;
;    3151 			}
;    3152 			while (valid_file_char(*sp)==0)
;    3153 			{
;    3154 				sp++;
;    3155 				if (sp == &_FF_buff[(n*0x20)+0x0A])
;    3156 				{	// a valid file or folder found
;    3157 					_FF_DIR_ADDR = addr_temp;
;    3158 					return (EOF);
;    3159 				}
;    3160 			}
;    3161 		}
;    3162 	}
;    3163 	// directory empty, delete dir
;    3164 	_FF_DIR_ADDR = path_addr_temp;	// go back to previous directory 
;    3165 
;    3166 	s = scan_directory(&path_addr_temp, fpath);
;    3167 
;    3168 	_FF_DIR_ADDR = addr_temp;	// reset address
;    3169 
;    3170 	if (s == 0)
;    3171 		return (EOF);
;    3172 	
;    3173 	calc_temp = path_addr_temp % BPB_BytsPerSec;
;    3174 	path_addr_temp -= calc_temp;
;    3175 
;    3176 	if (_FF_read(path_addr_temp)==0)	
;    3177 		return (EOF);
;    3178     
;    3179 	clus_temp = ((int) _FF_buff[calc_temp+0x1B] << 8) | _FF_buff[calc_temp+0x1A];
;    3180 	_FF_buff[calc_temp] = 0xE5;
;    3181 	
;    3182 	if (_FF_buff[calc_temp+0x0B]&0x02)
;    3183 		return (EOF);
;    3184 	if (_FF_write(path_addr_temp)==0) 
;    3185 		return (EOF);
;    3186 	if (erase_clus_chain(clus_temp)==0)
;    3187 		return (EOF);
;    3188 	
;    3189     return (0);
;    3190 }
;    3191 #endif
;    3192 
;    3193 int chdirc(char flash *F_PATH)
;    3194 {
;    3195 	unsigned char fpath[_FF_PATH_LENGTH];
;    3196 	int c;
;    3197 	
;    3198 	for (c=0; c<_FF_PATH_LENGTH; c++)
;	*F_PATH -> Y+102
;	fpath -> Y+2
;	c -> R16,R17
;    3199 	{
;    3200 		fpath[c] = F_PATH[c];
;    3201 		if (F_PATH[c]==0)
;    3202 			break;
;    3203 	}
;    3204 	return (chdir(fpath));
;    3205 }
;    3206 
;    3207 int chdir(char *F_PATH)
;    3208 {
;    3209 	unsigned char *qp, *sp, fpath[14], valid_flag;
;    3210 	unsigned int m, n, c, d, calc;
;    3211 	unsigned long addr_temp;
;    3212 
;    3213     
;    3214     addr_temp = 0;	// save local dir addr
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
;    3215     
;    3216 	if ((F_PATH[0]=='\\') && (F_PATH[1]==0))
;    3217 	{
;    3218 		_FF_DIR_ADDR = _FF_ROOT_ADDR;
;    3219 		_FF_FULL_PATH[1] = 0;
;    3220 		return (0);
;    3221 	}
;    3222 	
;    3223     if (_FF_checkdir(F_PATH, &addr_temp, fpath))
;    3224 	{
;    3225 		_FF_DIR_ADDR = addr_temp;
;    3226 		return (EOF);
;    3227 	}
;    3228 	if (fpath[0]==0)
;    3229 		return (EOF);
;    3230 
;    3231 	if ((fpath[0]=='.') && (fpath[1]=='.') && (fpath[2]==0))
;    3232 	{	// trying to get back to prev dir
;    3233 		if (_FF_DIR_ADDR == _FF_ROOT_ADDR)		// already as far back as can go
;    3234 			return (EOF);
;    3235 		if (_FF_read(_FF_DIR_ADDR)==0)
;    3236 			return (EOF);
;    3237 		m = ((unsigned int) _FF_buff[0x3B] << 8) | (unsigned int) _FF_buff[0x3A];
;    3238 		if (m)
;    3239 			_FF_DIR_ADDR = clust_to_addr(m);
;    3240 		else
;    3241 			_FF_DIR_ADDR = _FF_ROOT_ADDR;
;    3242 		
;    3243 					sp = F_PATH;
;    3244 					qp = _FF_FULL_PATH + strlen(_FF_FULL_PATH);
;    3245 					while (*sp)
;    3246 					{
;    3247 						if ((*sp=='.')&&(*(sp+1)=='.'))
;    3248 						{
;    3249 							#ifdef _ICCAVR_
;    3250 								qp = strrchr(_FF_FULL_PATH, '\\');
;    3251 								if (qp==0)
;    3252 								   return (EOF);
;    3253 								*qp = 0;
;    3254 								qp = strrchr(_FF_FULL_PATH, '\\');
;    3255 								if (qp==0)
;    3256 								   return (EOF);
;    3257 								qp++;
;    3258 							#endif
;    3259 							#ifdef _CVAVR_
;    3260 								_FF_FULL_PATH[strrpos(_FF_FULL_PATH, '\\')] = 0;
;    3261 							    c = strrpos(_FF_FULL_PATH, '\\');
;    3262 								if (c==EOF)
;    3263 									return (EOF);
;    3264 								qp = _FF_FULL_PATH + c;
;    3265 							#endif
;    3266 							*qp = 0;
;    3267 							sp += 2;
;    3268 						}
;    3269 						else 
;    3270 							*qp++ = toupper(*sp++);
;    3271 					}
;    3272 					*qp++ = '\\';
;    3273 					*qp = 0;
;    3274 
;    3275 		return (0);
;    3276 	}
;    3277 		
;    3278 	qp = fpath;
;    3279 	sp = fpath;
;    3280 	while(sp < (fpath+11))
;    3281 	{
;    3282 		if (*qp)
;    3283 			*sp++ = toupper(*qp++);
;    3284 		else	// (*qp==0)
;    3285 			*sp++ = 0x20;
;    3286 	}     
;    3287 	*sp = 0;
;    3288 
;    3289 	qp = fpath;
;    3290 	m = 0;
;    3291 	d = 0;
;    3292 	valid_flag = 0;
;    3293 	while (d<BPB_RootEntCnt)
;    3294 	{
;    3295     	_FF_read(_FF_DIR_ADDR+(m*0x200));
;    3296 		for (n=0; n<16; n++)
;    3297 		{
;    3298 			if (_FF_buff[n*0x20] == 0)	// no more entries in dir
;    3299 			{
;    3300 				_FF_DIR_ADDR = addr_temp;
;    3301 				return (EOF);
;    3302 			}
;    3303 			calc = (n*0x20);
;    3304 			for (c=0; c<11; c++)
;    3305 			{	// check for name match
;    3306 				if (fpath[c] == _FF_buff[calc+c])
;    3307 					valid_flag = 1;
;    3308 				else if (fpath[c] == 0)
;    3309 				{
;    3310 					if (_FF_buff[calc+c]==0x20)
;    3311 						break;
;    3312 				}
;    3313 				else
;    3314 				{
;    3315 					valid_flag = 0;	
;    3316 					break;
;    3317 				}
;    3318 		    }   
;    3319 		    if (valid_flag)
;    3320 	  		{
;    3321 	  			if (_FF_buff[calc+0xB] != 0x10)	// not a directory
;    3322 	  				valid_flag = 0;
;    3323 	  			else
;    3324 	  			{
;    3325 	  				c = ((int) _FF_buff[calc+0x1B] << 8) | ((int) _FF_buff[calc+0x1A]);
;    3326 					_FF_DIR_ADDR = clust_to_addr(c);
;    3327 					sp = F_PATH;
;    3328 					if (*sp=='\\')
;    3329 					{	// Restart String @root
;    3330 						qp = _FF_FULL_PATH + 1;
;    3331 						*qp = 0;
;    3332 						sp++;
;    3333 					}
;    3334 					else
;    3335 						qp = _FF_FULL_PATH + strlen(_FF_FULL_PATH);
;    3336 					while (*sp)
;    3337 					{
;    3338 						if ((*sp=='.')&&(*(sp+1)=='.'))
;    3339 						{
;    3340 							#ifdef _ICCAVR_
;    3341 								qp = strrchr(_FF_FULL_PATH, '\\');
;    3342 								if (qp==0)
;    3343 								   return (EOF);
;    3344 								*qp = 0;
;    3345 								qp = strrchr(_FF_FULL_PATH, '\\');
;    3346 								if (qp==0)
;    3347 								   return (EOF);
;    3348 								qp++;
;    3349 							#endif
;    3350 							#ifdef _CVAVR_
;    3351 								_FF_FULL_PATH[strrpos(_FF_FULL_PATH, '\\')] = 0;
;    3352 								c = strrpos(_FF_FULL_PATH, '\\');
;    3353 								if (c==EOF)
;    3354 								   return (EOF);
;    3355 								qp = _FF_FULL_PATH + c;
;    3356 							#endif
;    3357 							*qp = 0;
;    3358 							sp += 2;
;    3359 						}
;    3360 						else 
;    3361 							*qp++ = toupper(*sp++);
;    3362 					}
;    3363 					*qp++ = '\\';
;    3364 					*qp = 0;
;    3365 					return (0);
;    3366 				}
;    3367 			}
;    3368 		  	d++;		  		
;    3369 		}
;    3370 		m++;
;    3371 	}
;    3372 	_FF_DIR_ADDR = addr_temp;
;    3373 	return (EOF);
;    3374 }
;    3375 
;    3376 // Function to change directories one at a time, not effecting the working dir string
;    3377 int _FF_chdir(char *F_PATH)
;    3378 {
__FF_chdir:
;    3379 	unsigned char *qp, *sp, valid_flag, fpath[14];
;    3380 	unsigned int m, n, c, d, calc;
;    3381     
;    3382 	if ((F_PATH[0]=='.') && (F_PATH[1]=='.') && (F_PATH[2]==0))
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
	BRNE _0x28C
	LDD  R26,Y+29
	LDD  R27,Y+29+1
	ADIW R26,1
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BRNE _0x28C
	LDD  R26,Y+29
	LDD  R27,Y+29+1
	ADIW R26,2
	LD   R26,X
	CPI  R26,LOW(0x0)
	BREQ _0x28D
_0x28C:
	RJMP _0x28B
_0x28D:
;    3383 	{	// trying to get back to prev dir
;    3384 		if (_FF_DIR_ADDR == _FF_ROOT_ADDR)		// already as far back as can go
	LDS  R30,__FF_ROOT_ADDR
	LDS  R31,__FF_ROOT_ADDR+1
	LDS  R22,__FF_ROOT_ADDR+2
	LDS  R23,__FF_ROOT_ADDR+3
	LDS  R26,__FF_DIR_ADDR
	LDS  R27,__FF_DIR_ADDR+1
	LDS  R24,__FF_DIR_ADDR+2
	LDS  R25,__FF_DIR_ADDR+3
	CALL __CPD12
	BRNE _0x28E
;    3385 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x41F
;    3386 		if (_FF_read(_FF_DIR_ADDR)==0)
_0x28E:
	LDS  R30,__FF_DIR_ADDR
	LDS  R31,__FF_DIR_ADDR+1
	LDS  R22,__FF_DIR_ADDR+2
	LDS  R23,__FF_DIR_ADDR+3
	CALL __PUTPARD1
	CALL __FF_read
	CPI  R30,0
	BRNE _0x28F
;    3387 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x41F
;    3388 		m = ((unsigned int) _FF_buff[0x3B] << 8) | (unsigned int) _FF_buff[0x3A];
_0x28F:
	__GETBRMN 27,__FF_buff,59
	LDI  R26,LOW(0)
	__GETB1MN __FF_buff,58
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STD  Y+13,R30
	STD  Y+13+1,R31
;    3389 		if (m)
	SBIW R30,0
	BREQ _0x290
;    3390 			_FF_DIR_ADDR = clust_to_addr(m);
	ST   -Y,R31
	ST   -Y,R30
	CALL _clust_to_addr
	RJMP _0x43B
;    3391 		else
_0x290:
;    3392 			_FF_DIR_ADDR = _FF_ROOT_ADDR;
	LDS  R30,__FF_ROOT_ADDR
	LDS  R31,__FF_ROOT_ADDR+1
	LDS  R22,__FF_ROOT_ADDR+2
	LDS  R23,__FF_ROOT_ADDR+3
_0x43B:
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3393 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41F
;    3394 	}
;    3395 		
;    3396 	qp = F_PATH;
_0x28B:
	__GETWRS 16,17,29
;    3397 	sp = fpath;
	MOVW R30,R28
	ADIW R30,15
	MOVW R18,R30
;    3398 	while(sp < (fpath+11))
_0x292:
	MOVW R30,R28
	ADIW R30,26
	CP   R18,R30
	CPC  R19,R31
	BRSH _0x294
;    3399 	{
;    3400 		if (valid_file_char(*qp)==0)
	MOVW R26,R16
	LD   R30,X
	ST   -Y,R30
	CALL _valid_file_char
	SBIW R30,0
	BRNE _0x295
;    3401 			*sp++ = toupper(*qp++);
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
;    3402 		else if (*qp==0)
	RJMP _0x296
_0x295:
	MOVW R26,R16
	LD   R30,X
	CPI  R30,0
	BRNE _0x297
;    3403 			*sp++ = 0x20;
	MOVW R26,R18
	__ADDWRN 18,19,1
	LDI  R30,LOW(32)
	ST   X,R30
;    3404 		else
	RJMP _0x298
_0x297:
;    3405 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x41F
;    3406 	}     
_0x298:
_0x296:
	RJMP _0x292
_0x294:
;    3407 	*sp = 0;
	MOVW R26,R18
	LDI  R30,LOW(0)
	ST   X,R30
;    3408 	m = 0;
	LDI  R30,0
	STD  Y+13,R30
	STD  Y+13+1,R30
;    3409 	d = 0;
	LDI  R30,0
	STD  Y+7,R30
	STD  Y+7+1,R30
;    3410 	valid_flag = 0;
	LDI  R20,LOW(0)
;    3411 	while (d<BPB_RootEntCnt)
_0x299:
	LDS  R30,_BPB_RootEntCnt
	LDS  R31,_BPB_RootEntCnt+1
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CP   R26,R30
	CPC  R27,R31
	BRLO PC+3
	JMP _0x29B
;    3412 	{
;    3413     	_FF_read(_FF_DIR_ADDR+(m*0x200));
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
;    3414 		for (n=0; n<16; n++)
	LDI  R30,0
	STD  Y+11,R30
	STD  Y+11+1,R30
_0x29D:
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	SBIW R26,16
	BRLO PC+3
	JMP _0x29E
;    3415 		{
;    3416 			calc = (n*0x20);
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	LSL  R30
	ROL  R31
	CALL __LSLW4
	STD  Y+5,R30
	STD  Y+5+1,R31
;    3417 			if (_FF_buff[calc] == 0)	// no more entries in dir
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	LD   R30,Z
	CPI  R30,0
	BRNE _0x29F
;    3418 				return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x41F
;    3419 			for (c=0; c<11; c++)
_0x29F:
	LDI  R30,0
	STD  Y+9,R30
	STD  Y+9+1,R30
_0x2A1:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	SBIW R26,11
	BRSH _0x2A2
;    3420 			{	// check for name match
;    3421 				if (fpath[c] == _FF_buff[calc+c])
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
	BRNE _0x2A3
;    3422 					valid_flag = 1;
	LDI  R20,LOW(1)
;    3423 				else
	RJMP _0x2A4
_0x2A3:
;    3424 				{
;    3425 					valid_flag = 0;	
	LDI  R20,LOW(0)
;    3426 					c = 11;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	STD  Y+9,R30
	STD  Y+9+1,R31
;    3427 				}
_0x2A4:
;    3428 		    }   
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ADIW R30,1
	STD  Y+9,R30
	STD  Y+9+1,R31
	RJMP _0x2A1
_0x2A2:
;    3429 		    if (valid_flag)
	CPI  R20,0
	BREQ _0x2A5
;    3430 	  		{
;    3431 	  			if (_FF_buff[calc+0xB] != 0x10)	// not a directory
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	__ADDW1MN __FF_buff,11
	LD   R30,Z
	CPI  R30,LOW(0x10)
	BREQ _0x2A6
;    3432 	  				valid_flag = 0;
	LDI  R20,LOW(0)
;    3433 	  			else
	RJMP _0x2A7
_0x2A6:
;    3434 	  			{
;    3435 	  				c = ((int) _FF_buff[calc+0x1B] << 8) | ((int) _FF_buff[calc+0x1A]);
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
;    3436 					_FF_DIR_ADDR = clust_to_addr(c);
	ST   -Y,R31
	ST   -Y,R30
	CALL _clust_to_addr
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3437 					return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41F
;    3438 				}
_0x2A7:
;    3439 			}
;    3440 		  	d++;		  		
_0x2A5:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
;    3441 		}
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ADIW R30,1
	STD  Y+11,R30
	STD  Y+11+1,R31
	RJMP _0x29D
_0x29E:
;    3442 		m++;
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ADIW R30,1
	STD  Y+13,R30
	STD  Y+13+1,R31
;    3443 	}
	RJMP _0x299
_0x29B:
;    3444 	return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
_0x41F:
	CALL __LOADLOCR5
	ADIW R28,31
	RET
;    3445 }
;    3446 
;    3447 #ifndef _SECOND_FAT_ON_
;    3448 // Function that clears the secondary FAT table
;    3449 int clear_second_FAT(void)
;    3450 {
;    3451 	unsigned int c, d;
;    3452 	unsigned long n;
;    3453 	
;    3454 	for (n=1; n<BPB_FATSz16; n++)
;    3455 	{
;    3456 		if (_FF_read(_FF_FAT2_ADDR+(n*0x200))==0)
;    3457 			return (EOF);
;    3458 		for (c=0; c<BPB_BytsPerSec; c++)
;    3459 		{
;    3460 			if (_FF_buff[c] != 0)
;    3461 			{
;    3462 				for (d=0; d<BPB_BytsPerSec; d++)
;    3463 					_FF_buff[d] = 0;
;    3464 				if (_FF_write(_FF_FAT2_ADDR+(n*0x200))==0)
;    3465 					return (EOF);
;    3466 				break;
;    3467 			}
;    3468 		}
;    3469 	}
;    3470 	for (d=2; d<BPB_BytsPerSec; d++)
;    3471 		_FF_buff[d] = 0;
;    3472 	_FF_buff[0] = 0xF8;
;    3473 	_FF_buff[1] = 0xFF;
;    3474 	_FF_buff[2] = 0xFF;
;    3475 	if (BPB_FATType == 0x36)
;    3476 		_FF_buff[3] = 0xFF;
;    3477 	if (_FF_write(_FF_FAT2_ADDR)==0)
;    3478 		return (EOF);
;    3479 	
;    3480 	return (1);
;    3481 }
;    3482 #endif
;    3483  
;    3484 // Open a file, name stored in string fileopen
;    3485 FILE *fopenc(unsigned char flash *NAMEC, unsigned char MODEC)
;    3486 {
;    3487 	unsigned char c, temp_data[12];
;    3488 	FILE *tp;
;    3489 	
;    3490 	for (c=0; c<12; c++)
;	*NAMEC -> Y+16
;	MODEC -> Y+15
;	c -> R16
;	temp_data -> Y+3
;	*tp -> R17,R18
;    3491 		temp_data[c] = NAMEC[c];
;    3492 	
;    3493 	tp = fopen(temp_data, MODEC);
;    3494 	return(tp);
;    3495 }
;    3496 
;    3497 FILE *fopen(unsigned char *NAME, unsigned char MODE)
;    3498 {
_fopen:
;    3499 	unsigned char fpath[14];
;    3500 	unsigned int c, s, calc_temp;
;    3501 	unsigned char *sp, *qp;
;    3502 	unsigned long addr_temp, path_addr_temp;
;    3503 	FILE *rp;
;    3504 	
;    3505 	#ifdef _READ_ONLY_
;    3506 		if (MODE!=READ)
;    3507 			return (0);
;    3508 	#endif
;    3509 	
;    3510     addr_temp = 0;	// save local dir addr
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
;    3511     
;    3512     if (_FF_checkdir(NAME, &addr_temp, fpath))
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
	BREQ _0x2AB
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
	RJMP _0x41E
;    3516 	}
;    3517 	if (fpath[0]==0)
_0x2AB:
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2AC
;    3518 	{
;    3519 		_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3520 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41E
;    3521 	}
;    3522     
;    3523 	path_addr_temp = _FF_DIR_ADDR;
_0x2AC:
	LDS  R30,__FF_DIR_ADDR
	LDS  R31,__FF_DIR_ADDR+1
	LDS  R22,__FF_DIR_ADDR+2
	LDS  R23,__FF_DIR_ADDR+3
	__PUTD1S 8
;    3524 	s = scan_directory(&path_addr_temp, fpath);
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
;    3525 	if ((path_addr_temp==0) || (s==0))
	__GETD2S 8
	CALL __CPD02
	BREQ _0x2AE
	CLR  R0
	CP   R0,R18
	CPC  R0,R19
	BRNE _0x2AD
_0x2AE:
;    3526 	{
;    3527 		_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3528 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41E
;    3529 	}
;    3530 
;    3531 	rp = 0;
_0x2AD:
	LDI  R30,0
	STD  Y+6,R30
	STD  Y+6+1,R30
;    3532 	rp = malloc(sizeof(FILE));
	LDI  R30,LOW(553)
	LDI  R31,HIGH(553)
	ST   -Y,R31
	ST   -Y,R30
	CALL _malloc
	STD  Y+6,R30
	STD  Y+6+1,R31
;    3533 	if (rp == 0)
	SBIW R30,0
	BRNE _0x2B0
;    3534 	{	// Could not allocate requested memory
;    3535 		_FF_error = ALLOC_ERR;
	LDI  R30,LOW(9)
	STS  __FF_error,R30
;    3536 		_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3537 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41E
;    3538 	}
;    3539 	rp->length = 0x46344456;
_0x2B0:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	__GETD1N 0x46344456
	CALL __PUTDP1
;    3540 	rp->clus_start = 0xe4;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,12
	LDI  R30,LOW(228)
	LDI  R31,HIGH(228)
	ST   X+,R30
	ST   X,R31
;    3541 	rp->position = 0x45664446;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-544)
	SBCI R27,HIGH(-544)
	__GETD1N 0x45664446
	CALL __PUTDP1
;    3542 
;    3543 	calc_temp = path_addr_temp % BPB_BytsPerSec;
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	__GETD2S 8
	CLR  R22
	CLR  R23
	CALL __MODD21U
	MOVW R20,R30
;    3544 	path_addr_temp -= calc_temp;
	MOVW R30,R20
	__GETD2S 8
	CLR  R22
	CLR  R23
	CALL __SUBD21
	__PUTD2S 8
;    3545 	if (_FF_read(path_addr_temp)==0)	
	__GETD1S 8
	CALL __PUTPARD1
	CALL __FF_read
	CPI  R30,0
	BRNE _0x2B1
;    3546 	{
;    3547 		_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3548 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41E
;    3549 	}
;    3550 	
;    3551 	// Get the filename into a form we can use to compare
;    3552 	qp = file_name_conversion(fpath);
_0x2B1:
	MOVW R30,R28
	ADIW R30,20
	ST   -Y,R31
	ST   -Y,R30
	CALL _file_name_conversion
	STD  Y+16,R30
	STD  Y+16+1,R31
;    3553 	if (qp==0)
	SBIW R30,0
	BRNE _0x2B2
;    3554 	{	// If File name entered is NOT valid, return 0
;    3555 		free(rp);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _free
;    3556 		_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3557 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41E
;    3558 	}
;    3559 	
;    3560 	sp = &_FF_buff[calc_temp];
_0x2B2:
	MOVW R30,R20
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	STD  Y+18,R30
	STD  Y+18+1,R31
;    3561 
;    3562 	if (s)
	MOV  R0,R18
	OR   R0,R19
	BRNE PC+3
	JMP _0x2B3
;    3563 	{	// File exists, open 
;    3564 		if (((MODE==WRITE) || (MODE==APPEND)) && (_FF_buff[calc_temp+0x0B]&0x01))
	LDD  R26,Y+34
	CPI  R26,LOW(0x2)
	BREQ _0x2B5
	CPI  R26,LOW(0x3)
	BRNE _0x2B7
_0x2B5:
	MOVW R30,R20
	__ADDW1MN __FF_buff,11
	LD   R30,Z
	ANDI R30,LOW(0x1)
	BRNE _0x2B8
_0x2B7:
	RJMP _0x2B4
_0x2B8:
;    3565 		{	// if writing to file verify it is not "READ ONLY"
;    3566 			_FF_error = MODE_ERR;
	LDI  R30,LOW(11)
	STS  __FF_error,R30
;    3567 			free(rp);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _free
;    3568 			_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3569 			return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41E
;    3570 		}
;    3571 		for (c=0; c<12; c++)	// Save Filename to Buffer
_0x2B4:
	__GETWRN 16,17,0
_0x2BA:
	__CPWRN 16,17,12
	BRSH _0x2BB
;    3572 			rp->name[c] = FILENAME[c];
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
;    3573 		// Save Starting Cluster
;    3574 		rp->clus_start = ((int) _FF_buff[calc_temp+0x1B] << 8) | (int) _FF_buff[calc_temp+0x1A];
	__ADDWRN 16,17,1
	RJMP _0x2BA
_0x2BB:
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
;    3575 		// Set Current Cluster
;    3576 		rp->clus_current = rp->clus_start;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,12
	CALL __GETW1P
	__PUTW1SNS 6,14
;    3577 		// Set Previous Cluster to 0 (indicating @start)
;    3578 		rp->clus_prev = 0;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,18
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
;    3579 		// Save file length
;    3580 		rp->length = 0;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	__GETD1N 0x0
	CALL __PUTDP1
;    3581 		sp = _FF_buff + calc_temp + 0x1F;
	MOVW R30,R20
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	ADIW R30,31
	STD  Y+18,R30
	STD  Y+18+1,R31
;    3582 		for (c=0; c<4; c++)
	__GETWRN 16,17,0
_0x2BD:
	__CPWRN 16,17,4
	BRSH _0x2BE
;    3583 		{
;    3584 			rp->length <<= 8;
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
;    3585 			rp->length |= *sp--;
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
;    3586 		}
	__ADDWRN 16,17,1
	RJMP _0x2BD
_0x2BE:
;    3587 		// Set Current Position to 0
;    3588 		rp->position = 0;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-544)
	SBCI R27,HIGH(-544)
	__GETD1N 0x0
	CALL __PUTDP1
;    3589 		#ifndef _READ_ONLY_
;    3590 			if (MODE==WRITE)
	LDD  R26,Y+34
	CPI  R26,LOW(0x2)
	BREQ PC+3
	JMP _0x2BF
;    3591 			{	// Change file to blank
;    3592 				sp = _FF_buff + calc_temp + 0x1F;
	MOVW R30,R20
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	ADIW R30,31
	STD  Y+18,R30
	STD  Y+18+1,R31
;    3593 				for (c=0; c<6; c++)
	__GETWRN 16,17,0
_0x2C1:
	__CPWRN 16,17,6
	BRSH _0x2C2
;    3594 					*sp-- = 0;
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	SBIW R26,1
	STD  Y+18,R26
	STD  Y+18+1,R27
	ADIW R26,1
	LDI  R30,LOW(0)
	ST   X,R30
;    3595 				if (rp->length)
	__ADDWRN 16,17,1
	RJMP _0x2C1
_0x2C2:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	CALL __GETD1P
	CALL __CPD10
	BRNE PC+3
	JMP _0x2C3
;    3596 				{
;    3597 					if (_FF_write(_FF_DIR_ADDR + (0x200 * s))==0)
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
	BRNE _0x2C4
;    3598 					{
;    3599 						free(rp);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _free
;    3600 						_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3601 						return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41E
;    3602 					}
;    3603 					rp->length = 0;
_0x2C4:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	__GETD1N 0x0
	CALL __PUTDP1
;    3604 					erase_clus_chain(rp->clus_start);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+12
	LDD  R27,Z+13
	ST   -Y,R27
	ST   -Y,R26
	CALL _erase_clus_chain
;    3605 					rp->clus_start = 0;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,12
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
;    3606 				}
;    3607 			}
_0x2C3:
;    3608 		#endif
;    3609 		// Set and save next cluster #
;    3610 		rp->clus_next = next_cluster(rp->clus_current, SINGLE);
_0x2BF:
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
;    3611 		if ((rp->length==0) && (rp->clus_start==0))
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	CALL __GETD1P
	CALL __CPD10
	BRNE _0x2C6
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,12
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2C7
_0x2C6:
	RJMP _0x2C5
_0x2C7:
;    3612 		{	// Check for Blank File 
;    3613 			if (MODE==READ)
	LDD  R26,Y+34
	CPI  R26,LOW(0x1)
	BRNE _0x2C8
;    3614 			{	// IF trying to open a blank file to read, ERROR
;    3615 				_FF_error = MODE_ERR;
	LDI  R30,LOW(11)
	STS  __FF_error,R30
;    3616 				free(rp);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _free
;    3617 				_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3618 				return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41E
;    3619 			}
;    3620 			//Setup blank FILE characteristics
;    3621 			#ifndef _READ_ONLY_
;    3622 				MODE = WRITE; 
_0x2C8:
	LDI  R30,LOW(2)
	STD  Y+34,R30
;    3623 			#endif
;    3624 		}
;    3625 		// Save the file offset to read entry
;    3626 		rp->entry_sec_addr = path_addr_temp;
_0x2C5:
	__GETD1S 8
	__PUTD1SNS 6,22
;    3627 		rp->entry_offset =  calc_temp;
	MOVW R30,R20
	__PUTW1SNS 6,26
;    3628 		// Set sector offset to 1
;    3629 		rp->sec_offset = 1;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,20
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
;    3630 		if (MODE==APPEND)
	LDD  R26,Y+34
	CPI  R26,LOW(0x3)
	BRNE _0x2C9
;    3631 		{
;    3632 			if (fseek(rp, 0,SEEK_END)==EOF)
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
	BRNE _0x2CA
;    3633 			{
;    3634 				free(rp);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _free
;    3635 				_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3636 				return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41E
;    3637 			}
;    3638 		}
_0x2CA:
;    3639 		else
	RJMP _0x2CB
_0x2C9:
;    3640 		{	// Set pointer to the begining of the file
;    3641 			_FF_read(clust_to_addr(rp->clus_current));
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Z+14
	LDD  R27,Z+15
	ST   -Y,R27
	ST   -Y,R26
	CALL _clust_to_addr
	CALL __PUTPARD1
	CALL __FF_read
;    3642 			for (c=0; c<BPB_BytsPerSec; c++)
	__GETWRN 16,17,0
_0x2CD:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x2CE
;    3643 				rp->buff[c] = _FF_buff[c];
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
;    3644 			rp->pntr = &rp->buff[0];
	__ADDWRN 16,17,1
	RJMP _0x2CD
_0x2CE:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,28
	__PUTW1SN 6,551
;    3645 		}
_0x2CB:
;    3646 		#ifndef _READ_ONLY_
;    3647 			#ifndef _SECOND_FAT_ON_
;    3648 				if ((MODE==WRITE) || (MODE==APPEND))
;    3649 					clear_second_FAT();
;    3650 			#endif
;    3651     	#endif
;    3652 		rp->mode = MODE;
	LDD  R30,Y+34
	__PUTB1SN 6,548
;    3653 		_FF_error = NO_ERR;
	LDI  R30,LOW(0)
	STS  __FF_error,R30
;    3654 		_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3655 		return(rp);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RJMP _0x41E
;    3656 	}
;    3657 	else
_0x2B3:
;    3658 	{                          		
;    3659 		_FF_error = FILE_ERR;
	LDI  R30,LOW(2)
	STS  __FF_error,R30
;    3660 		free(rp);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _free
;    3661 		_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3662 		return(0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41E
;    3663 	}
;    3664 }
;    3665 
;    3666 #ifndef _READ_ONLY_
;    3667 // Create a file
;    3668 FILE *fcreatec(unsigned char flash *NAMEC, unsigned char MODE)
;    3669 {
;    3670 	unsigned char sd_temp[12];
;    3671 	int c;
;    3672 
;    3673 	for (c=0; c<12; c++)
;	*NAMEC -> Y+15
;	MODE -> Y+14
;	sd_temp -> Y+2
;	c -> R16,R17
;    3674 		sd_temp[c] = NAMEC[c];
;    3675 	
;    3676 	return (fcreate(sd_temp, MODE));
;    3677 }
;    3678 
;    3679 FILE *fcreate(unsigned char *NAME, unsigned char MODE)
;    3680 {
_fcreate:
;    3681 	unsigned char fpath[14];
;    3682 	unsigned int c, s, calc_temp;
;    3683 	unsigned char *sp, *qp;
;    3684 	unsigned long addr_temp, path_addr_temp;
;    3685 	FILE *temp_file_pntr;
;    3686 
;    3687     addr_temp = 0;	// save local dir addr
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
;    3688     
;    3689     if (_FF_checkdir(NAME, &addr_temp, fpath))
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
	BREQ _0x2D3
;    3690 	{
;    3691 		_FF_error = PATH_ERR;
	LDI  R30,LOW(14)
	STS  __FF_error,R30
;    3692 		_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3693 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41E
;    3694 	}
;    3695 	if (fpath[0]==0)
_0x2D3:
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2D4
;    3696 	{
;    3697 		_FF_error = NAME_ERR; 
	LDI  R30,LOW(5)
	STS  __FF_error,R30
;    3698 		_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3699 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41E
;    3700 	}
;    3701     
;    3702 	path_addr_temp = _FF_DIR_ADDR;
_0x2D4:
	LDS  R30,__FF_DIR_ADDR
	LDS  R31,__FF_DIR_ADDR+1
	LDS  R22,__FF_DIR_ADDR+2
	LDS  R23,__FF_DIR_ADDR+3
	__PUTD1S 8
;    3703 	s = scan_directory(&path_addr_temp, fpath);
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
;    3704 	if (path_addr_temp==0)
	__GETD1S 8
	CALL __CPD10
	BRNE _0x2D5
;    3705 	{
;    3706 		_FF_error = NO_ENTRY_AVAL;
	LDI  R30,LOW(15)
	STS  __FF_error,R30
;    3707 		_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3708 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41E
;    3709 	}
;    3710 
;    3711 	calc_temp = path_addr_temp % BPB_BytsPerSec;
_0x2D5:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	__GETD2S 8
	CLR  R22
	CLR  R23
	CALL __MODD21U
	MOVW R20,R30
;    3712 	path_addr_temp -= calc_temp;
	MOVW R30,R20
	__GETD2S 8
	CLR  R22
	CLR  R23
	CALL __SUBD21
	__PUTD2S 8
;    3713 	if (_FF_read(path_addr_temp)==0)	
	__GETD1S 8
	CALL __PUTPARD1
	CALL __FF_read
	CPI  R30,0
	BRNE _0x2D6
;    3714 	{
;    3715 		_FF_error = READ_ERR;
	LDI  R30,LOW(4)
	STS  __FF_error,R30
;    3716 		_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3717 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41E
;    3718 	}
;    3719 
;    3720 	// Get the filename into a form we can use to compare
;    3721 	qp = file_name_conversion(fpath);
_0x2D6:
	MOVW R30,R28
	ADIW R30,20
	ST   -Y,R31
	ST   -Y,R30
	CALL _file_name_conversion
	STD  Y+16,R30
	STD  Y+16+1,R31
;    3722 	if (qp==0)
	SBIW R30,0
	BRNE _0x2D7
;    3723 	{
;    3724 		_FF_error = NAME_ERR; 
	LDI  R30,LOW(5)
	STS  __FF_error,R30
;    3725 		_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3726 		return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41E
;    3727 	}
;    3728 	sp = &_FF_buff[calc_temp];
_0x2D7:
	MOVW R30,R20
	SUBI R30,LOW(-__FF_buff)
	SBCI R31,HIGH(-__FF_buff)
	STD  Y+18,R30
	STD  Y+18+1,R31
;    3729 	
;    3730 	if (s)
	MOV  R0,R18
	OR   R0,R19
	BREQ _0x2D8
;    3731 	{
;    3732 		if ((_FF_buff[calc_temp+0x0B]&0x1)==1)	// is file read only
	MOVW R30,R20
	__ADDW1MN __FF_buff,11
	LD   R30,Z
	ANDI R30,LOW(0x1)
	CPI  R30,LOW(0x1)
	BRNE _0x2D9
;    3733 		{
;    3734 			_FF_error = READONLY_ERR;
	LDI  R30,LOW(6)
	STS  __FF_error,R30
;    3735 			_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3736 			return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41E
;    3737 		}
;    3738 	}
_0x2D9:
;    3739 	else
	RJMP _0x2DA
_0x2D8:
;    3740 	{
;    3741 		for (c=0; c<11; c++)	// Write Filename
	__GETWRN 16,17,0
_0x2DC:
	__CPWRN 16,17,11
	BRSH _0x2DD
;    3742 			*sp++ = *qp++;
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
;    3743 		*sp = 0x20;				// Attribute bit auto set to "ARCHIVE"
	__ADDWRN 16,17,1
	RJMP _0x2DC
_0x2DD:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDI  R30,LOW(32)
	ST   X,R30
;    3744 		sp++;		
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
;    3745 		*sp++ = 0;				// Reserved for WinNT
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,1
	STD  Y+18,R26
	STD  Y+18+1,R27
	SBIW R26,1
	LDI  R30,LOW(0)
	ST   X,R30
;    3746 		*sp++ = 0;				// Mili-second stamp for create
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,1
	STD  Y+18,R26
	STD  Y+18+1,R27
	SBIW R26,1
	ST   X,R30
;    3747 	
;    3748 		#ifdef _RTC_ON_
;    3749 			rtc_get_timeNdate(&rtc_hour, &rtc_min, &rtc_sec, &rtc_date, &rtc_month, (int *)&rtc_year);	    			
;    3750     	    calc_temp = ((int)rtc_sec&0x1F) | (((int)rtc_min&0x3F)<<5) | (((int)rtc_hour&0x1F)<<11);
;    3751 			*sp++ = calc_temp&0x00FF;	// File create Time 
;    3752 			*sp++ = (calc_temp&0xFF00) >> 8;
;    3753 			calc_temp = ((int)rtc_date&0x1F) | (((int)rtc_month&0x0F)<<5) | (((rtc_year-1980)&0x7F)<<9);
;    3754 			*sp++ = calc_temp&0x00FF;	// File create Date
;    3755 			*sp++ = (calc_temp&0xFF00) >> 8;
;    3756 		#else
;    3757 			for (c=0; c<4; c++)
	__GETWRN 16,17,0
_0x2DF:
	__CPWRN 16,17,4
	BRSH _0x2E0
;    3758 				*sp++ = 0;
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,1
	STD  Y+18,R26
	STD  Y+18+1,R27
	SBIW R26,1
	LDI  R30,LOW(0)
	ST   X,R30
;    3759 		#endif
;    3760 
;    3761 		*sp++ = 0;				// File access date (2 bytes)
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
;    3762 		*sp++ = 0;
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,1
	STD  Y+18,R26
	STD  Y+18+1,R27
	SBIW R26,1
	ST   X,R30
;    3763 		*sp++ = 0;				// 0 for FAT12/16 (2 bytes)
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,1
	STD  Y+18,R26
	STD  Y+18+1,R27
	SBIW R26,1
	ST   X,R30
;    3764 		*sp++ = 0;
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,1
	STD  Y+18,R26
	STD  Y+18+1,R27
	SBIW R26,1
	ST   X,R30
;    3765 		for (c=0; c<4; c++)		// Modify time/date
	__GETWRN 16,17,0
_0x2E2:
	__CPWRN 16,17,4
	BRSH _0x2E3
;    3766 			*sp++ = 0;
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,1
	STD  Y+18,R26
	STD  Y+18+1,R27
	SBIW R26,1
	LDI  R30,LOW(0)
	ST   X,R30
;    3767 		*sp++ = 0;				// Starting cluster (2 bytes)
	__ADDWRN 16,17,1
	RJMP _0x2E2
_0x2E3:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,1
	STD  Y+18,R26
	STD  Y+18+1,R27
	SBIW R26,1
	LDI  R30,LOW(0)
	ST   X,R30
;    3768 		*sp++ = 0;
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,1
	STD  Y+18,R26
	STD  Y+18+1,R27
	SBIW R26,1
	ST   X,R30
;    3769 		for (c=0; c<4; c++)
	__GETWRN 16,17,0
_0x2E5:
	__CPWRN 16,17,4
	BRSH _0x2E6
;    3770 			*sp++ = 0;			// File length (0 for new)
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	ADIW R26,1
	STD  Y+18,R26
	STD  Y+18+1,R27
	SBIW R26,1
	LDI  R30,LOW(0)
	ST   X,R30
;    3771 	
;    3772 		if (_FF_write(path_addr_temp)==0)
	__ADDWRN 16,17,1
	RJMP _0x2E5
_0x2E6:
	__GETD1S 8
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	BRNE _0x2E7
;    3773 		{
;    3774 			_FF_error = WRITE_ERR;
	LDI  R30,LOW(3)
	STS  __FF_error,R30
;    3775 			_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3776 			return (0);				
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41E
;    3777 		}
;    3778 	}
_0x2E7:
_0x2DA:
;    3779 	_FF_DIR_ADDR = addr_temp;
	__GETD1S 12
	STS  __FF_DIR_ADDR,R30
	STS  __FF_DIR_ADDR+1,R31
	STS  __FF_DIR_ADDR+2,R22
	STS  __FF_DIR_ADDR+3,R23
;    3780 	temp_file_pntr = fopen(NAME, WRITE);
	LDD  R30,Y+35
	LDD  R31,Y+35+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _fopen
	STD  Y+6,R30
	STD  Y+6+1,R31
;    3781 	if (temp_file_pntr == 0)	// Will file open
	SBIW R30,0
	BRNE _0x2E8
;    3782 		return (0);				
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41E
;    3783 	if (MODE)
_0x2E8:
	LDD  R30,Y+34
	CPI  R30,0
	BREQ _0x2E9
;    3784 	{
;    3785 		if (_FF_read(addr_temp)==0)
	__GETD1S 12
	CALL __PUTPARD1
	CALL __FF_read
	CPI  R30,0
	BRNE _0x2EA
;    3786 		{
;    3787 			_FF_error = READ_ERR;
	LDI  R30,LOW(4)
	STS  __FF_error,R30
;    3788 			return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41E
;    3789 		}
;    3790 		_FF_buff[calc_temp+12] |= MODE;		
_0x2EA:
	MOVW R30,R20
	__ADDW1MN __FF_buff,12
	MOVW R0,R30
	LD   R30,Z
	LDD  R26,Y+34
	OR   R30,R26
	MOVW R26,R0
	ST   X,R30
;    3791 		if (_FF_write(addr_temp)==0)
	__GETD1S 12
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	BRNE _0x2EB
;    3792 		{
;    3793 			_FF_error = WRITE_ERR;
	LDI  R30,LOW(3)
	STS  __FF_error,R30
;    3794 			return (0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x41E
;    3795 		}
;    3796 	}
_0x2EB:
;    3797 	_FF_error = NO_ERR;
_0x2E9:
	LDI  R30,LOW(0)
	STS  __FF_error,R30
;    3798 	return (temp_file_pntr);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
_0x41E:
	CALL __LOADLOCR6
	ADIW R28,37
	RET
;    3799 }
;    3800 #endif
;    3801 
;    3802 #ifndef _READ_ONLY_
;    3803 // Open a file, name stored in string fileopen
;    3804 int removec(unsigned char flash *NAMEC)
;    3805 {
;    3806 	int c;
;    3807 	unsigned char sd_temp[12];
;    3808 	
;    3809 	for (c=0; c<12; c++)
;	*NAMEC -> Y+14
;	c -> R16,R17
;	sd_temp -> Y+2
;    3810 		sd_temp[c] = NAMEC[c];
;    3811 	
;    3812 	c = remove(sd_temp);
;    3813 	return (c);
;    3814 }
;    3815 
;    3816 // Remove a file from the root directory
;    3817 int remove(unsigned char *NAME)
;    3818 {
;    3819 	unsigned char fpath[14];
;    3820 	unsigned int s, calc_temp;
;    3821 	unsigned long addr_temp, path_addr_temp;
;    3822 	
;    3823 	#ifndef _SECOND_FAT_ON_
;    3824 		clear_second_FAT();
;    3825     #endif
;    3826     
;    3827     addr_temp = 0;	// save local dir addr
;	*NAME -> Y+26
;	fpath -> Y+12
;	s -> R16,R17
;	calc_temp -> R18,R19
;	addr_temp -> Y+8
;	path_addr_temp -> Y+4
;    3828     
;    3829     if (_FF_checkdir(NAME, &addr_temp, fpath))
;    3830 	{
;    3831 		_FF_error = PATH_ERR;
;    3832 		_FF_DIR_ADDR = addr_temp;
;    3833 		return (EOF);
;    3834 	}
;    3835 	if (fpath[0]==0)
;    3836 	{
;    3837 		_FF_error = NAME_ERR; 
;    3838 		_FF_DIR_ADDR = addr_temp;
;    3839 		return (EOF);
;    3840 	}
;    3841     
;    3842 	path_addr_temp = _FF_DIR_ADDR;
;    3843 	s = scan_directory(&path_addr_temp, fpath);
;    3844 	if ((path_addr_temp==0) || (s==0))
;    3845 	{
;    3846 		_FF_error = NO_ENTRY_AVAL;
;    3847 		_FF_DIR_ADDR = addr_temp;
;    3848 		return (EOF);
;    3849 	}
;    3850 	_FF_DIR_ADDR = addr_temp;		// Reset current dir
;    3851 
;    3852 	calc_temp = path_addr_temp % BPB_BytsPerSec;
;    3853 	path_addr_temp -= calc_temp;
;    3854 	if (_FF_read(path_addr_temp)==0)	
;    3855 	{
;    3856 		_FF_error = READ_ERR;
;    3857 		return (EOF);
;    3858 	}
;    3859 	
;    3860 	// Erase entry (put 0xE5 into start of the filename
;    3861 	_FF_buff[calc_temp] = 0xE5;
;    3862 	if (_FF_write(path_addr_temp)==0)
;    3863 	{
;    3864 		_FF_error = WRITE_ERR;
;    3865 		return (EOF);
;    3866 	}
;    3867 	// Save Starting Cluster
;    3868 	calc_temp = ((int) _FF_buff[calc_temp+0x1B] << 8) | (int) _FF_buff[calc_temp+0x1A];
;    3869 	// Destroy cluster chain
;    3870 	if (calc_temp)
;    3871 		if (erase_clus_chain(calc_temp) == 0)
;    3872 			return (EOF);
;    3873 			
;    3874 	return (1);
;    3875 }
;    3876 #endif
;    3877 
;    3878 #ifndef _READ_ONLY_
;    3879 // Rename a file in the Root Directory
;    3880 int rename(unsigned char *NAME_OLD, unsigned char *NAME_NEW)
;    3881 {
;    3882 	unsigned char c;
;    3883 	unsigned int calc_temp;
;    3884 	unsigned long addr_temp, path_addr_temp;
;    3885 	unsigned char *sp, *qp;
;    3886 	unsigned char fpath[14];
;    3887 
;    3888 	// Get the filename into a form we can use to compare
;    3889 	qp = file_name_conversion(NAME_NEW);
;	*NAME_OLD -> Y+31
;	*NAME_NEW -> Y+29
;	c -> R16
;	calc_temp -> R17,R18
;	addr_temp -> Y+25
;	path_addr_temp -> Y+21
;	*sp -> R19,R20
;	*qp -> Y+19
;	fpath -> Y+5
;    3890 	if (qp==0)
;    3891 	{
;    3892 		_FF_error = NAME_ERR;
;    3893 		return (EOF);
;    3894 	}
;    3895 	
;    3896     addr_temp = 0;	// save local dir addr
;    3897     
;    3898     if (_FF_checkdir(NAME_OLD, &addr_temp, fpath))
;    3899 	{
;    3900 		_FF_error = PATH_ERR;
;    3901 		_FF_DIR_ADDR = addr_temp;
;    3902 		return (EOF);
;    3903 	}
;    3904 	if (fpath[0]==0)
;    3905 	{
;    3906 		_FF_error = NAME_ERR; 
;    3907 		_FF_DIR_ADDR = addr_temp;
;    3908 		return (EOF);
;    3909 	}
;    3910 
;    3911 	path_addr_temp = _FF_DIR_ADDR;
;    3912 	calc_temp = scan_directory(&path_addr_temp, NAME_NEW);
;    3913 	if (calc_temp)
;    3914 	{	// does new name alread exist?
;    3915 		_FF_DIR_ADDR = addr_temp;
;    3916 		_FF_error = EXIST_ERR;
;    3917 		return (EOF);
;    3918 	}
;    3919 
;    3920 	path_addr_temp = _FF_DIR_ADDR;
;    3921 	calc_temp = scan_directory(&path_addr_temp, fpath);
;    3922 	if ((path_addr_temp==0) || (calc_temp==0))
;    3923 	{
;    3924 		_FF_DIR_ADDR = addr_temp;
;    3925 		_FF_error = EXIST_ERR;
;    3926 		return (EOF);
;    3927 	}
;    3928 
;    3929 
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
;    3940 	// Rename entry
;    3941 	sp = &_FF_buff[calc_temp];
;    3942 	for (c=0; c<11; c++)
;    3943 		*sp++ = *qp++;
;    3944 	if (_FF_write(path_addr_temp)==0)
;    3945 		return (EOF);
;    3946 
;    3947 	return(0);
;    3948 }
;    3949 #endif
;    3950 
;    3951 #ifndef _READ_ONLY_
;    3952 // Save Contents of file, w/o closing
;    3953 int fflush(FILE *rp)	
;    3954 {
_fflush:
;    3955 	unsigned int  n;
;    3956 	unsigned long addr_temp;
;    3957 	
;    3958 	if ((rp==NULL) || (rp->mode==READ))
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
;	*rp -> Y+6
;	n -> R16,R17
;	addr_temp -> Y+2
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __CPW02
	BREQ _0x305
	SUBI R26,LOW(-548)
	SBCI R27,HIGH(-548)
	LD   R26,X
	CPI  R26,LOW(0x1)
	BRNE _0x304
_0x305:
;    3959 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x41D
;    3960 	
;    3961 	if ((rp->mode==WRITE) || (rp->mode==APPEND))
_0x304:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-548)
	SBCI R27,HIGH(-548)
	LD   R26,X
	CPI  R26,LOW(0x2)
	BREQ _0x308
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUBI R26,LOW(-548)
	SBCI R27,HIGH(-548)
	LD   R26,X
	CPI  R26,LOW(0x3)
	BREQ _0x308
	RJMP _0x307
_0x308:
;    3962 	{
;    3963 		addr_temp = (clust_to_addr(rp->clus_current) + ((rp->sec_offset-1)*BPB_BytsPerSec));
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
;    3964 		for (n=0; n<BPB_BytsPerSec; n++)	// Save file buffer to SD buffer
	__GETWRN 16,17,0
_0x30B:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x30C
;    3965 			_FF_buff[n] = rp->buff[n];
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
;    3966 		if (_FF_write(addr_temp)==0)	// Write SD buffer to disk
	__ADDWRN 16,17,1
	RJMP _0x30B
_0x30C:
	__GETD1S 2
	CALL __PUTPARD1
	CALL __FF_write
	CPI  R30,0
	BRNE _0x30D
;    3967 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x41D
;    3968 		if (append_toc(rp)==0)	// Update Entry or Error
_0x30D:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _append_toc
	CPI  R30,0
	BRNE _0x30E
;    3969 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x41D
;    3970 	}
_0x30E:
;    3971 	
;    3972 	return (0);
_0x307:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x41D:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	RET
;    3973 }
;    3974 #endif		
;    3975 
;    3976 
;    3977 // Close an open file
;    3978 int fclose(FILE *rp)	
;    3979 {
_fclose:
;    3980 	#ifndef _READ_ONLY_
;    3981 	if (rp->mode!=READ)
	LD   R26,Y
	LDD  R27,Y+1
	SUBI R26,LOW(-548)
	SBCI R27,HIGH(-548)
	LD   R26,X
	CPI  R26,LOW(0x1)
	BREQ _0x30F
;    3982 		if (fflush(rp)==EOF)
	LD   R30,Y
	LDD  R31,Y+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _fflush
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x310
;    3983 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x41C
;    3984 	#endif	
;    3985 	// Clear File Structure
;    3986 	free(rp);
_0x310:
_0x30F:
	LD   R30,Y
	LDD  R31,Y+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _free
;    3987 	rp = 0;
	LDI  R30,0
	STD  Y+0,R30
	STD  Y+0+1,R30
;    3988 	return(0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x41C:
	ADIW R28,2
	RET
;    3989 }
;    3990 
;    3991 int ffreemem(FILE *rp)	
;    3992 {
;    3993 	// Clear File Structure
;    3994 	if (rp==0)
;    3995 		return (EOF);
;    3996 	free(rp);
;    3997 	return(0);
;    3998 }
;    3999 
;    4000 int fget_file_infoc(unsigned char flash *NAMEC, unsigned long *F_SIZE, unsigned char *F_CREATE,
;    4001 				unsigned char *F_MODIFY, unsigned char *F_ATTRIBUTE, unsigned int *F_CLUS_START)
;    4002 {
;    4003 	int c;
;    4004 	unsigned char sd_temp[12];
;    4005 	
;    4006 	for (c=0; c<12; c++)
;	*NAMEC -> Y+24
;	*F_SIZE -> Y+22
;	*F_CREATE -> Y+20
;	*F_MODIFY -> Y+18
;	*F_ATTRIBUTE -> Y+16
;	*F_CLUS_START -> Y+14
;	c -> R16,R17
;	sd_temp -> Y+2
;    4007 		sd_temp[c] = NAMEC[c];
;    4008 	
;    4009 	c = fget_file_info(sd_temp, F_SIZE, F_CREATE, F_MODIFY, F_ATTRIBUTE, F_CLUS_START);
;    4010 	return (c);
;    4011 }
;    4012 
;    4013 int fget_file_info(unsigned char *NAME, unsigned long *F_SIZE, unsigned char *F_CREATE,
;    4014 				unsigned char *F_MODIFY, unsigned char *F_ATTRIBUTE, unsigned int *F_CLUS_START)
;    4015 {
;    4016 	unsigned char n;
;    4017 	unsigned int s, calc_temp;
;    4018 	unsigned long addr_temp, file_calc_temp;
;    4019 	unsigned char *sp, *qp;
;    4020 	
;    4021 	// Get the filename into a form we can use to compare
;    4022 	qp = file_name_conversion(NAME);
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
;    4023 	if (qp==0)
;    4024 	{
;    4025 		_FF_error = NAME_ERR;
;    4026 		return (EOF);
;    4027 	}
;    4028 	
;    4029 	for (s=0; s<BPB_BytsPerSec; s++)
;    4030 	{	// Scan through directory entries to find file
;    4031 		addr_temp = _FF_DIR_ADDR + (0x200 * s);
;    4032 		if (_FF_read(addr_temp)==0)
;    4033 			return (EOF);
;    4034 		for (n=0; n<16; n++)
;    4035 		{
;    4036 			calc_temp = (int) n * 0x20;
;    4037 			qp = &FILENAME[0];
;    4038 			sp = &_FF_buff[calc_temp];
;    4039 			if (*sp == 0)
;    4040 				return (EOF);
;    4041 			if (strncmp(qp, sp, 11)==0)		// Does this entry == Filename
;    4042 			{
;    4043 				*F_ATTRIBUTE = _FF_buff[calc_temp+11];	// Save ATTRIBUTE Byte to location
;    4044 				*F_SIZE = ((long) _FF_buff[calc_temp+31] << 24) | ((long) _FF_buff[calc_temp+30] << 16)
;    4045 							| ((long) _FF_buff[calc_temp+29] << 8) | ((long) _FF_buff[calc_temp+28]);
;    4046 							// Save SIZE of file to location
;    4047                 *F_CLUS_START = ((unsigned int) _FF_buff[calc_temp+27] << 8) | ((unsigned int) _FF_buff[calc_temp+26]);
;    4048 				file_calc_temp = ((unsigned int) _FF_buff[calc_temp+17] << 8) | ((unsigned int) _FF_buff[calc_temp+16]);
;    4049 				qp = F_CREATE;
;    4050 				*qp++ = (((file_calc_temp >> 5) & 0x0F) / 10) + '0';
;    4051 				*qp++ = (((file_calc_temp >> 5) & 0x0F) % 10) + '0';
;    4052 				*qp++ = '/';
;    4053 				*qp++ = ((file_calc_temp & 0x1F) / 10) + '0';
;    4054 				*qp++ = ((file_calc_temp & 0x1F) % 10) + '0';
;    4055 				*qp++ = '/';
;    4056 				file_calc_temp = ((file_calc_temp >> 9) & 0x7F) + 1980;
;    4057 				*qp++ = (file_calc_temp / 1000) + '0';
;    4058 				file_calc_temp %= 1000;
;    4059 				*qp++ = (file_calc_temp / 100) + '0';
;    4060 				file_calc_temp %= 100;
;    4061 				*qp++ = (file_calc_temp / 10) + '0';
;    4062 				*qp++ = (file_calc_temp % 10) + '0';
;    4063 				*qp++ = ' ';
;    4064 				*qp++ = ' ';
;    4065 				file_calc_temp = ((unsigned int) _FF_buff[calc_temp+15] << 8) | ((unsigned int) _FF_buff[calc_temp+14]);
;    4066 				*qp++ = (((file_calc_temp >> 11) & 0x1F) / 10) + '0';
;    4067 				*qp++ = (((file_calc_temp >> 11) & 0x1F) % 10) + '0';
;    4068 				*qp++ = ':';
;    4069 				*qp++ = (((file_calc_temp >> 5) & 0x3F) / 10) + '0';
;    4070 				*qp++ = (((file_calc_temp >> 5) & 0x3F) % 10) + '0';
;    4071 				*qp++ = ':';
;    4072 				*qp++ = (((file_calc_temp & 0x1F) * 2) / 10) + '0';
;    4073 				*qp++ = (((file_calc_temp & 0x1F) * 2) % 10) + '0';
;    4074 				*qp = 0;
;    4075 				
;    4076 				file_calc_temp = ((unsigned int) _FF_buff[calc_temp+25] << 8) | ((unsigned int) _FF_buff[calc_temp+24]);
;    4077 				qp = F_MODIFY;
;    4078 				*qp++ = (((file_calc_temp >> 5) & 0x0F) / 10) + '0';
;    4079 				*qp++ = (((file_calc_temp >> 5) & 0x0F) % 10) + '0';
;    4080 				*qp++ = '/';
;    4081 				*qp++ = ((file_calc_temp & 0x1F) / 10) + '0';
;    4082 				*qp++ = ((file_calc_temp & 0x1F) % 10) + '0';
;    4083 				*qp++ = '/';
;    4084 				file_calc_temp = ((file_calc_temp >> 9) & 0x7F) + 1980;
;    4085 				*qp++ = (file_calc_temp / 1000) + '0';
;    4086 				file_calc_temp %= 1000;
;    4087 				*qp++ = (file_calc_temp / 100) + '0';
;    4088 				file_calc_temp %= 100;
;    4089 				*qp++ = (file_calc_temp / 10) + '0';
;    4090 				*qp++ = (file_calc_temp % 10) + '0';
;    4091 				*qp++ = ' ';
;    4092 				*qp++ = ' ';
;    4093 				file_calc_temp = ((unsigned int) _FF_buff[calc_temp+23] << 8) | ((unsigned int) _FF_buff[calc_temp+22]);
;    4094 				*qp++ = (((file_calc_temp >> 11) & 0x1F) / 10) + '0';
;    4095 				*qp++ = (((file_calc_temp >> 11) & 0x1F) % 10) + '0';
;    4096 				*qp++ = ':';
;    4097 				*qp++ = (((file_calc_temp >> 5) & 0x3F) / 10) + '0';
;    4098 				*qp++ = (((file_calc_temp >> 5) & 0x3F) % 10) + '0';
;    4099 				*qp++ = ':';
;    4100 				*qp++ = (((file_calc_temp & 0x1F) * 2) / 10) + '0';
;    4101 				*qp++ = (((file_calc_temp & 0x1F) * 2) % 10) + '0';
;    4102 				*qp = 0;
;    4103 				
;    4104 				return (0);
;    4105 			}
;    4106 		}                          		
;    4107 	}
;    4108 	_FF_error = FILE_ERR;
;    4109 	return(EOF);
;    4110 }
;    4111 
;    4112 // Get File data and increment file pointer
;    4113 int fgetc(FILE *rp)
;    4114 {
;    4115 	unsigned char get_data;
;    4116 	unsigned int n;
;    4117 	unsigned long addr_temp;
;    4118 	
;    4119 	if (rp==NULL)
;	*rp -> Y+7
;	get_data -> R16
;	n -> R17,R18
;	addr_temp -> Y+3
;    4120 		return (EOF);
;    4121 
;    4122 	if (rp->position == rp->length)
;    4123 	{
;    4124 		rp->error = POS_ERR;
;    4125 		return (EOF);
;    4126 	}
;    4127 	
;    4128 	get_data = *rp->pntr;
;    4129 	
;    4130 	if ((rp->pntr)==(&rp->buff[BPB_BytsPerSec-1]))
;    4131 	{	// Check to see if pointer is at the end of a sector
;    4132 		#ifndef _READ_ONLY_
;    4133 		if ((rp->mode==WRITE) || (rp->mode==APPEND))
;    4134 		{	// if in write or append mode, update the current sector before loading next
;    4135 			for (n=0; n<BPB_BytsPerSec; n++)
;    4136 				_FF_buff[n] = rp->buff[n];
;    4137 			addr_temp = clust_to_addr(rp->clus_current) + (((rp->sec_offset)-1)*BPB_BytsPerSec);
;    4138 			if (_FF_write(addr_temp)==0)
;    4139 				return (EOF);
;    4140 		}
;    4141 		#endif
;    4142 		if (rp->sec_offset < BPB_SecPerClus)
;    4143 		{	// Goto next sector if not at the end of a cluster
;    4144 			addr_temp = clust_to_addr(rp->clus_current) + (rp->sec_offset*BPB_BytsPerSec);
;    4145 			rp->sec_offset++;
;    4146 		}
;    4147 		else
;    4148 		{	// End of Cluster, find next
;    4149 			if (rp->clus_next>=0xFFF8)	// No next cluster, EOF marker
;    4150 			{
;    4151 				rp->EOF_flag = 1;	// Set flag so Putchar knows to get new cluster
;    4152 				rp->position++;		// Only time doing this, position + 1 should equal length
;    4153 				return(get_data);
;    4154 			}
;    4155 			addr_temp = clust_to_addr(rp->clus_next);
;    4156 			rp->sec_offset = 1;
;    4157 			rp->clus_prev = rp->clus_current;
;    4158 			rp->clus_current = rp->clus_next;
;    4159 			rp->clus_next = next_cluster(rp->clus_current, SINGLE);
;    4160 		}
;    4161 		if (_FF_read(addr_temp)==0)
;    4162 			return (EOF);
;    4163 		for (n=0; n<BPB_BytsPerSec; n++)
;    4164 			rp->buff[n] = _FF_buff[n];
;    4165 		rp->pntr = &rp->buff[0];
;    4166 	}
;    4167 	else
;    4168 		rp->pntr++;
;    4169 	
;    4170 	rp->position++;	
;    4171 	return(get_data);		
;    4172 }
;    4173 
;    4174 char *fgets(char *buffer, int n, FILE *rp)
;    4175 {
;    4176 	int c, temp_data;
;    4177 	
;    4178 	for (c=0; c<n; c++)
;	*buffer -> Y+8
;	n -> Y+6
;	*rp -> Y+4
;	c -> R16,R17
;	temp_data -> R18,R19
;    4179 	{
;    4180 		temp_data = fgetc(rp);
;    4181 		*buffer = temp_data & 0xFF;
;    4182 		if (temp_data == '\n')
;    4183 			break;
;    4184 		else if (temp_data == EOF)
;    4185 			break;
;    4186 		buffer++;
;    4187 	}
;    4188 	if (c==n)
;    4189 		buffer++;
;    4190 	*buffer-- = '\0';
;    4191 	if (temp_data == EOF)
;    4192 		return (NULL);
;    4193 	return (buffer);
;    4194 }
;    4195 
;    4196 #ifndef _READ_ONLY_
;    4197 // Decrement file pointer, then get file data
;    4198 int ungetc(unsigned char file_data, FILE *rp)
;    4199 {
;    4200 	unsigned int n;
;    4201 	unsigned long addr_temp;
;    4202 	
;    4203 	if ((rp==NULL) || (rp->position==0))
;	file_data -> Y+8
;	*rp -> Y+6
;	n -> R16,R17
;	addr_temp -> Y+2
;    4204 		return (EOF);
;    4205 	if ((rp->mode!=APPEND) && (rp->mode!=WRITE))
;    4206 		return (EOF);	// needs to be in WRITE or APPEND mode
;    4207 
;    4208 	if (((rp->position) == rp->length) && (rp->EOF_flag))
;    4209 	{	// if the file posisition is equal to the length, return data, turn flag off
;    4210 		rp->EOF_flag = 0;
;    4211 		*rp->pntr = file_data;
;    4212 		return (*rp->pntr);
;    4213 	}
;    4214 	if ((rp->pntr)==(&rp->buff[0]))
;    4215 	{	// Check to see if pointer is at the beginning of a Sector
;    4216 		// Update the current sector before loading next
;    4217 		for (n=0; n<BPB_BytsPerSec; n++)
;    4218 			_FF_buff[n] = rp->buff[n];
;    4219 		addr_temp = clust_to_addr(rp->clus_current) + (((rp->sec_offset)-1)*BPB_BytsPerSec);
;    4220 		if (_FF_write(addr_temp)==0)
;    4221 			return (EOF);
;    4222 			
;    4223 		if (rp->sec_offset > 1)
;    4224 		{	// Goto previous sector if not at the beginning of a cluster
;    4225 			addr_temp = clust_to_addr(rp->clus_current) + ((rp->sec_offset-2)*BPB_BytsPerSec);
;    4226 			rp->sec_offset--;
;    4227 		}
;    4228 		else
;    4229 		{	// Beginning of Cluster, find previous
;    4230 			if (rp->clus_start==rp->clus_current)
;    4231 			{	// Positioned @ Beginning of File
;    4232 				_FF_error = SOF_ERR;
;    4233 				return(EOF);
;    4234 			}
;    4235 			rp->sec_offset = BPB_SecPerClus;	// Set sector offset to last sector
;    4236 			rp->clus_next = rp->clus_current;
;    4237 			rp->clus_current = rp->clus_prev;
;    4238 			if (rp->clus_current != rp->clus_start)
;    4239 				rp->clus_prev = prev_cluster(rp->clus_current);
;    4240 			else
;    4241 				rp->clus_prev = 0;
;    4242 			addr_temp = clust_to_addr(rp->clus_current) + (((long) BPB_SecPerClus-1) * (long) BPB_BytsPerSec);
;    4243 		}
;    4244 		_FF_read(addr_temp);
;    4245 		for (n=0; n<BPB_BytsPerSec; n++)
;    4246 			rp->buff[n] = _FF_buff[n];
;    4247 		rp->pntr = &rp->buff[511];
;    4248 	}
;    4249 	else
;    4250 		rp->pntr--;
;    4251 	
;    4252 	rp->position--;
;    4253 	*rp->pntr = file_data;	
;    4254 	return(*rp->pntr);	// Get data	
;    4255 }
;    4256 #endif
;    4257 
;    4258 #ifndef _READ_ONLY_
;    4259 int fputc(unsigned char file_data, FILE *rp)	
;    4260 {
;    4261 	unsigned int n;
;    4262 	unsigned long addr_temp;
;    4263 	
;    4264 	if (rp==NULL)
;	file_data -> Y+8
;	*rp -> Y+6
;	n -> R16,R17
;	addr_temp -> Y+2
;    4265 		return (EOF);
;    4266 
;    4267 	if (rp->mode == READ)
;    4268 	{
;    4269 		_FF_error = READONLY_ERR;
;    4270 		return(EOF);
;    4271 	}
;    4272 	if (rp->length == 0)
;    4273 	{	// Blank file start writing cluster table
;    4274 		rp->clus_start = prev_cluster(0);
;    4275 		rp->clus_next = 0xFFFF;
;    4276 		rp->clus_current = rp->clus_start;
;    4277 		if (write_clus_table(rp->clus_start, rp->clus_next, SINGLE)==0)
;    4278 		{
;    4279 			return (EOF);
;    4280 		}
;    4281 	}
;    4282 	
;    4283 	if ((rp->position==rp->length) && (rp->EOF_flag))
;    4284 	{	// At end of file, and end of cluster, flagged
;    4285 		rp->clus_prev = rp->clus_current;
;    4286 		rp->clus_current = prev_cluster(0);	// Find first cluster pointing to '0'
;    4287 		rp->clus_next = 0xFFFF;
;    4288 		rp->sec_offset = 1;
;    4289 		if (write_clus_table(rp->clus_prev, rp->clus_current, CHAIN)==0)
;    4290 		{
;    4291 			return (EOF);
;    4292 		}
;    4293 		if (write_clus_table(rp->clus_current, rp->clus_next, END_CHAIN)==0)
;    4294 		{
;    4295 			return (EOF);
;    4296 		}
;    4297 		if (append_toc(rp)==0)
;    4298 		{
;    4299 			return (EOF);
;    4300 		}
;    4301 		rp->EOF_flag = 0;
;    4302 		rp->pntr = &rp->buff[0];		
;    4303 	}
;    4304 	
;    4305 	*rp->pntr = file_data;
;    4306 	
;    4307 	if (rp->pntr == &rp->buff[BPB_BytsPerSec-1])
;    4308 	{	// This is on the Sector Limit
;    4309 		if (rp->position > rp->length)
;    4310 		{	// ERROR, position should never be greater than length
;    4311 			_FF_error = 0x10;		// file position ERROR
;    4312 			return (EOF); 
;    4313 		}
;    4314 		// Position is at end of a sector?
;    4315 		
;    4316 		addr_temp = (clust_to_addr(rp->clus_current) + ((rp->sec_offset-1)*BPB_BytsPerSec));
;    4317 		for (n=0; n<BPB_BytsPerSec; n++)
;    4318 			_FF_buff[n] = rp->buff[n];
;    4319 		_FF_write(addr_temp);
;    4320 			// Save MMC buffer to card, set pointer to begining of new buffer
;    4321 		if (rp->sec_offset < BPB_SecPerClus)
;    4322 		{	// Are there more sectors in this cluster?
;    4323 			addr_temp = clust_to_addr(rp->clus_current) + (rp->sec_offset * BPB_BytsPerSec);
;    4324 			rp->sec_offset++;
;    4325 		}
;    4326 		else
;    4327 		{	// Find next cluster, load first sector into file.buff
;    4328 			if (((rp->clus_next>=0xFFF8)&&(BPB_FATType==0x36)) ||
;    4329 				((rp->clus_next>=0xFF8)&&(BPB_FATType==0x32)))
;    4330 			{	// EOF, need to find new empty cluster
;    4331 				if (rp->position != rp->length)
;    4332 				{	// if not equal there's an error
;    4333 					_FF_error = 0x20;		// EOF position error
;    4334 					return (EOF);
;    4335 				}
;    4336 				rp->EOF_flag = 1;
;    4337 			}
;    4338 			else
;    4339 			{	// Not EOF, find next cluster
;    4340 				rp->clus_prev = rp->clus_current;
;    4341 				rp->clus_current = rp->clus_next;
;    4342 				rp->clus_next = next_cluster(rp->clus_current, SINGLE);
;    4343 			}
;    4344 			rp->sec_offset = 1;
;    4345 			addr_temp = clust_to_addr(rp->clus_current);
;    4346 		}
;    4347 		
;    4348 		if (rp->EOF_flag == 0)
;    4349 		{
;    4350 			if (_FF_read(addr_temp)==0)
;    4351 				return(EOF);
;    4352 			for (n=0; n<512; n++)
;    4353 				rp->buff[n] = _FF_buff[n];
;    4354 			rp->pntr = &rp->buff[0];	// Set pointer to next location				
;    4355 		}
;    4356 		if (rp->length==rp->position)
;    4357 			rp->length++;
;    4358 		if (append_toc(rp)==0)
;    4359 			return(EOF);
;    4360 	}
;    4361 	else
;    4362 	{
;    4363 		rp->pntr++;
;    4364 		if (rp->length==rp->position)
;    4365 			rp->length++;
;    4366 	}
;    4367 	rp->position++;
;    4368 	return(file_data);
;    4369 }
;    4370 
;    4371 int fputs(unsigned char *file_data, FILE *rp)
;    4372 {
;    4373 	while(*file_data)
;    4374 		if (fputc(*file_data++,rp) == EOF)
;    4375 			return (EOF);
;    4376 	if (fputc('\r',rp) == EOF)
;    4377 		return (EOF);
;    4378 	if (fputc('\n',rp) == EOF)
;    4379 		return (EOF);
;    4380 	return (0);
;    4381 }
;    4382 
;    4383 int fputsc(flash unsigned char *file_data, FILE *rp)
;    4384 {
;    4385 	while(*file_data)
;    4386 		if (fputc(*file_data++,rp) == EOF)
;    4387 			return (EOF);
;    4388 	if (fputc('\r',rp) == EOF)
;    4389 		return (EOF);
;    4390 	if (fputc('\n',rp) == EOF)
;    4391 		return (EOF);
;    4392 	return (0);
;    4393 }
;    4394 #endif
;    4395 
;    4396 //#ifndef _READ_ONLY_
;    4397 #ifdef _CVAVR_
;    4398 void fprintf(FILE *rp, unsigned char flash *pstr, ...)
;    4399 {
;    4400 	va_list arglist;
;    4401 	unsigned char temp_buff[_FF_MAX_FPRINT], *fp;
;    4402 	
;    4403 	va_start(arglist, pstr);
;	*rp -> Y+106
;	*pstr -> Y+104
;	*arglist -> R16,R17
;	temp_buff -> Y+4
;	*fp -> R18,R19
;    4404 	vsprintf(temp_buff, pstr, arglist);
;    4405 	va_end(arglist);
;    4406 	
;    4407 	fp = temp_buff;
;    4408 	while (*fp)
;    4409 		fputc(*fp++, rp);	
;    4410 }
;    4411 #endif
;    4412 #ifdef _ICCAVR_
;    4413 void fprintf(FILE *rp, unsigned char flash *pstr, long var)
;    4414 {
;    4415 	unsigned char temp_buff[_FF_MAX_FPRINT], *fp;
;    4416 	
;    4417 	csprintf(temp_buff, pstr, var);
;    4418 	
;    4419 	fp = temp_buff;
;    4420 	while (*fp)
;    4421 		fputc(*fp++, rp);	
;    4422 }
;    4423 #endif
;    4424 //#endif
;    4425 
;    4426 // Set file pointer to the end of the file
;    4427 int fend(FILE *rp)
;    4428 {
;    4429 	return (fseek(rp, 0, SEEK_END));	
;    4430 }
;    4431 
;    4432 // Goto position "off_set" of a file
;    4433 int fseek(FILE *rp, unsigned long off_set, unsigned char mode)
;    4434 {
_fseek:
;    4435 	unsigned int n, clus_temp;
;    4436 	unsigned long length_check, addr_calc;
;    4437 	
;    4438 	if (rp==NULL)
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
	BRNE _0x382
;    4439 	{	// ERROR if FILE pointer is NULL
;    4440 		_FF_error = FILE_ERR;
	LDI  R30,LOW(2)
	STS  __FF_error,R30
;    4441 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x41B
;    4442 	}
;    4443 	if (mode==SEEK_CUR)
_0x382:
	LDD  R30,Y+12
	CPI  R30,0
	BRNE _0x383
;    4444 	{	// Trying to position pointer to offset from current position
;    4445 		off_set += rp->position;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SUBI R26,LOW(-544)
	SBCI R27,HIGH(-544)
	CALL __GETD1P
	__GETD2S 13
	CALL __ADDD12
	__PUTD1S 13
;    4446 	}
;    4447 	if (off_set > rp->length)
_0x383:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	CALL __GETD1P
	__GETD2S 13
	CALL __CPD12
	BRSH _0x384
;    4448 	{	// trying to position beyond or before file
;    4449 		rp->error = POS_ERR;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SUBI R26,LOW(-549)
	SBCI R27,HIGH(-549)
	LDI  R30,LOW(10)
	ST   X,R30
;    4450 		_FF_error = POS_ERR;
	STS  __FF_error,R30
;    4451 		return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x41B
;    4452 	}
;    4453 	if (mode==SEEK_END)
_0x384:
	LDD  R26,Y+12
	CPI  R26,LOW(0x1)
	BRNE _0x385
;    4454 	{	// Trying to position pointer to offset from EOF
;    4455 		off_set = rp->length - off_set;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SUBI R26,LOW(-540)
	SBCI R27,HIGH(-540)
	CALL __GETD1P
	__GETD2S 13
	CALL __SUBD12
	__PUTD1S 13
;    4456 	}
;    4457 	#ifndef _READ_ONLY_
;    4458 	if (rp->mode != READ)
_0x385:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SUBI R26,LOW(-548)
	SBCI R27,HIGH(-548)
	LD   R26,X
	CPI  R26,LOW(0x1)
	BREQ _0x386
;    4459 		if (fflush(rp))
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _fflush
	SBIW R30,0
	BREQ _0x387
;    4460 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x41B
;    4461 	#endif
;    4462 	clus_temp = rp->clus_start;
_0x387:
_0x386:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,12
	LD   R18,X+
	LD   R19,X
;    4463 	rp->clus_current = clus_temp;
	MOVW R30,R18
	__PUTW1SNS 17,14
;    4464 	rp->clus_next = next_cluster(clus_temp, SINGLE);
	ST   -Y,R19
	ST   -Y,R18
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _next_cluster
	__PUTW1SNS 17,16
;    4465 	rp->clus_prev = 0;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,18
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
;    4466 	
;    4467 	addr_calc = off_set / ((long) BPB_BytsPerSec * (long) BPB_SecPerClus);
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
;    4468 	length_check = off_set % ((long) BPB_BytsPerSec * (long) BPB_SecPerClus);
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
;    4469 	rp->EOF_flag = 0;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SUBI R26,LOW(-550)
	SBCI R27,HIGH(-550)
	LDI  R30,LOW(0)
	ST   X,R30
;    4470 
;    4471 	while (addr_calc)
_0x388:
	__GETD1S 4
	CALL __CPD10
	BRNE PC+3
	JMP _0x38A
;    4472 	{
;    4473 		if (rp->clus_next >= 0xFFF8)
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	LDD  R26,Z+16
	LDD  R27,Z+17
	CPI  R26,LOW(0xFFF8)
	LDI  R30,HIGH(0xFFF8)
	CPC  R27,R30
	BRLO _0x38B
;    4474 		{	// trying to position beyond or before file
;    4475 			if ((addr_calc==1) && (length_check==0))
	__GETD2S 4
	__CPD2N 0x1
	BRNE _0x38D
	__GETD2S 8
	CALL __CPD02
	BREQ _0x38E
_0x38D:
	RJMP _0x38C
_0x38E:
;    4476 			{
;    4477 				rp->EOF_flag = 1;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SUBI R26,LOW(-550)
	SBCI R27,HIGH(-550)
	LDI  R30,LOW(1)
	ST   X,R30
;    4478 				break;
	RJMP _0x38A
;    4479 			}				
;    4480 			rp->error = POS_ERR;
_0x38C:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SUBI R26,LOW(-549)
	SBCI R27,HIGH(-549)
	LDI  R30,LOW(10)
	ST   X,R30
;    4481 			_FF_error = POS_ERR;
	STS  __FF_error,R30
;    4482 			return (EOF);
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x41B
;    4483 		}
;    4484 		clus_temp = rp->clus_next;
_0x38B:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,16
	LD   R18,X+
	LD   R19,X
;    4485 		rp->clus_prev = rp->clus_current;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,14
	CALL __GETW1P
	__PUTW1SNS 17,18
;    4486 		rp->clus_current = clus_temp;
	MOVW R30,R18
	__PUTW1SNS 17,14
;    4487 		rp->clus_next = next_cluster(clus_temp, CHAIN);
	ST   -Y,R19
	ST   -Y,R18
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _next_cluster
	__PUTW1SNS 17,16
;    4488 		addr_calc--;
	__GETD1S 4
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
	__PUTD1S 4
;    4489 	}
	RJMP _0x388
_0x38A:
;    4490 	
;    4491 	addr_calc = clust_to_addr(rp->clus_current);
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	LDD  R26,Z+14
	LDD  R27,Z+15
	ST   -Y,R27
	ST   -Y,R26
	CALL _clust_to_addr
	__PUTD1S 4
;    4492 	rp->sec_offset = 1;			// Reset Reading Sector
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,20
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
;    4493 	while (length_check >= BPB_BytsPerSec)
_0x38F:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	__GETD2S 8
	CLR  R22
	CLR  R23
	CALL __CPD21
	BRLO _0x391
;    4494 	{
;    4495 		addr_calc += BPB_BytsPerSec;
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	__GETD2S 4
	CLR  R22
	CLR  R23
	CALL __ADDD12
	__PUTD1S 4
;    4496 		length_check -= BPB_BytsPerSec;
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	__GETD2S 8
	CLR  R22
	CLR  R23
	CALL __SUBD21
	__PUTD2S 8
;    4497 		rp->sec_offset++;
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,20
	CALL __GETW1P
	ADIW R30,1
	ST   X+,R30
	ST   X,R31
;    4498 	}
	RJMP _0x38F
_0x391:
;    4499 	
;    4500 	if (_FF_read(addr_calc)==0)		// Read Current Data Sector
	__GETD1S 4
	CALL __PUTPARD1
	CALL __FF_read
	CPI  R30,0
	BRNE _0x392
;    4501 		return(EOF);		// Read Error  
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x41B
;    4502 		
;    4503 	for (n=0; n<BPB_BytsPerSec; n++)
_0x392:
	__GETWRN 16,17,0
_0x394:
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x395
;    4504 		rp->buff[n] = _FF_buff[n];
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
;    4505     
;    4506     if ((rp->EOF_flag == 1) && (length_check == 0))
	__ADDWRN 16,17,1
	RJMP _0x394
_0x395:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SUBI R26,LOW(-550)
	SBCI R27,HIGH(-550)
	LD   R26,X
	CPI  R26,LOW(0x1)
	BRNE _0x397
	__GETD2S 8
	CALL __CPD02
	BREQ _0x398
_0x397:
	RJMP _0x396
_0x398:
;    4507     	rp->pntr = &rp->buff[BPB_BytsPerSec-1];
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,28
	LDS  R30,_BPB_BytsPerSec
	LDS  R31,_BPB_BytsPerSec+1
	SBIW R30,1
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1SN 17,551
;    4508 	rp->pntr = &rp->buff[length_check];
_0x396:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADIW R26,28
	__GETD1S 8
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1SN 17,551
;    4509 	rp->position = off_set;
	__GETD1S 13
	__PUTD1SN 17,544
;    4510 		
;    4511 	return (0);	
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x41B:
	CALL __LOADLOCR4
	ADIW R28,19
	RET
;    4512 }
;    4513 
;    4514 // Return the current position of the file rp with respect to the begining of the file
;    4515 long ftell(FILE *rp)
;    4516 {
;    4517 	if (rp==NULL)
;    4518 		return (EOF);
;    4519 	else
;    4520 		return (rp->position);
;    4521 }
;    4522 
;    4523 // Funtion that returns a '1' for @EOF, '0' otherwise
;    4524 int feof(FILE *rp)
;    4525 {
;    4526 	if (rp==NULL)
;    4527 		return (EOF);
;    4528 	
;    4529 	if (rp->length==rp->position)
;    4530 		return (1);
;    4531 	else
;    4532 		return (0);
;    4533 }
;    4534 		
;    4535 void dump_file_data_hex(FILE *rp)
;    4536 {
;    4537 	unsigned int n, c;
;    4538 	
;    4539 	if (rp==NULL)
;	*rp -> Y+4
;	n -> R16,R17
;	c -> R18,R19
;    4540 		return;
;    4541 
;    4542 	for (n=0; n<0x20; n++)
;    4543 	{   
;    4544 		printf("\n\r");
;    4545 		for (c=0; c<0x10; c++)
;    4546 			printf("%02X ", rp->buff[(n*0x20)+c]);
;    4547 	}
;    4548 }
;    4549 
;    4550 void dump_file_data_view(FILE *rp)
;    4551 {
;    4552 	unsigned int n;
;    4553 	
;    4554 	if (rp==NULL)
;	*rp -> Y+2
;	n -> R16,R17
;    4555 		return;
;    4556 
;    4557 	printf("\n\r");
;    4558 	for (n=0; n<512; n++)
;    4559 		putchar(rp->buff[n]);
;    4560 }
;    4561 

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
_0x407:
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x409
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
	BREQ _0x40A
	__PUTWSR 18,19,6
	RJMP _0x40B
_0x40A:
	LDI  R30,LOW(4352)
	LDI  R31,HIGH(4352)
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x40B:
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
	BRLO _0x40C
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
	RJMP _0x41A
_0x40C:
	__MOVEWRR 16,17,18,19
	RJMP _0x407
_0x409:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x41A:
	CALL __LOADLOCR6
	ADIW R28,10
	RET
_find_prev_block_G9:
	CALL __SAVELOCR4
	__GETWRN 16,17,3240
_0x40D:
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x40F
	MOVW R26,R16
	ADIW R26,2
	CALL __GETW1P
	MOVW R18,R30
	MOVW R26,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x410
	MOVW R30,R16
	RJMP _0x419
_0x410:
	__MOVEWRR 16,17,18,19
	RJMP _0x40D
_0x40F:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x419:
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
	JMP _0x411
	SBIW R30,4
	MOVW R16,R30
	ST   -Y,R17
	ST   -Y,R16
	RCALL _find_prev_block_G9
	MOVW R18,R30
	SBIW R30,0
	BREQ _0x412
	MOVW R26,R16
	ADIW R26,2
	CALL __GETW1P
	__PUTW1RNS 18,2
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SBIW R30,0
	BREQ _0x413
	ST   -Y,R31
	ST   -Y,R30
	RCALL _allocate_block_G9
	MOVW R20,R30
	SBIW R30,0
	BREQ _0x414
	MOVW R26,R16
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	MOVW R26,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x415
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	STD  Y+8,R30
	STD  Y+8+1,R31
_0x415:
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
	RJMP _0x418
_0x414:
	MOVW R30,R16
	__PUTW1RNS 18,2
_0x413:
_0x412:
_0x411:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x418:
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
	BREQ _0x416
	ST   -Y,R31
	ST   -Y,R30
	RCALL _allocate_block_G9
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x417
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _memset
_0x417:
_0x416:
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
