;CodeVisionAVR C Compiler V1.24.7e Professional
;(C) Copyright 1998-2005 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

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

	.INCLUDE "i2c_mega128.vec"
	.INCLUDE "i2c_mega128.inc"

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
;       1 /*****************************************************
;       2 /Управляющая программа контроллера Д2Т
;       3 
;       4 Project : I2C_interface
;       5 Version : 1
;       6 Date    : 24.02.2006
;       7 Author  : Michael           
;       8 Company : Sp-Tv       
;       9 Comments: 
;      10 Программа для MEGA128
;      11 
;      12 
;      13 Chip type           : ATmega128
;      14 Program type        : Application
;      15 Clock frequency     : 8,000000 MHz
;      16 Memory model        : Small
;      17 External SRAM size  : 0
;      18 Data Stack size     : 1024
;      19 *****************************************************/
;      20 #include <mega128.h>
;      21 
;      22 #include "I2C_mega128.h"                //Подключаем настройки выводов
;      23                         
;      24 
;      25 #define CRST PORTA.2                             //Вывод Reset для подчиненных устройств
;      26 
;      27 //Адреса
;      28 #define Addr 0x0                                 //Адрес подчиненного устройства
;      29 
;      30 //Переменные
;      31 
;      32 
;      33 #define RXB8 1
;      34 #define TXB8 0
;      35 #define UPE 2
;      36 #define OVR 3
;      37 #define FE 4
;      38 #define UDRE 5
;      39 #define RXC 7
;      40 
;      41 #define FRAMING_ERROR (1<<FE)
;      42 #define PARITY_ERROR (1<<UPE)
;      43 #define DATA_OVERRUN (1<<OVR)
;      44 #define DATA_REGISTER_EMPTY (1<<UDRE)
;      45 #define RX_COMPLETE (1<<RXC)
;      46 
;      47 // USART0 Receiver buffer
;      48 #define RX_BUFFER_SIZE0 256
;      49 char rx_buffer0[RX_BUFFER_SIZE0];
_rx_buffer0:
	.BYTE 0x100
;      50 
;      51 #if RX_BUFFER_SIZE0<256
;      52 unsigned char rx_wr_index0,rx_rd_index0,rx_counter0;
;      53 #else
;      54 unsigned int rx_wr_index0,rx_rd_index0,rx_counter0;
;      55 #endif
;      56 
;      57 //////////////////////////////////////////////////////////////////////////
;      58 /// Биты сигнализации
;      59 
;      60 bit rx_buffer_overflow0;        // This flag is set on USART0 Receiver buffer overflow
;      61 bit rx_USART_packet = 0;        // Флаг получения полного пакета по UART
;      62 bit rx_USART_starting = 0;      // Признак процесса приема пакета по USART
;      63 
;      64 // USART0 Receiver interrupt service routine
;      65 interrupt [USART0_RXC] void usart0_rx_isr(void)
;      66 {

	.CSEG
_usart0_rx_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;      67 char status,data;
;      68 status=UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R16
;	data -> R17
	IN   R16,11
;      69 data=UDR0;
	IN   R17,12
;      70 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R16
	ANDI R30,LOW(0x1C)
	BRNE _0x3
;      71    {
;      72    if (rx_USART_starting == 0) 
	SBRC R2,2
	RJMP _0x4
;      73         {
;      74         if (data != 'q') {return;}              //проверяем заголовок пакета  
	CPI  R17,113
	BREQ _0x5
	RJMP _0x4F
;      75 //        rx_USART_starting = 1;
;      76         }
_0x5:
;      77    rx_buffer0[rx_wr_index0]=data;
_0x4:
	MOVW R26,R4
	SUBI R26,LOW(-_rx_buffer0)
	SBCI R27,HIGH(-_rx_buffer0)
	ST   X,R17
;      78    if (++rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
	CPI  R30,LOW(0x100)
	LDI  R26,HIGH(0x100)
	CPC  R31,R26
	BRNE _0x6
	CLR  R4
	CLR  R5
;      79    if (++rx_counter0 == RX_BUFFER_SIZE0)
_0x6:
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	CPI  R30,LOW(0x100)
	LDI  R26,HIGH(0x100)
	CPC  R31,R26
	BRNE _0x7
;      80       {
;      81       rx_counter0=0;
	CLR  R8
	CLR  R9
;      82       rx_buffer_overflow0=1;  
	SET
	BLD  R2,0
;      83       };
_0x7:
;      84     
;      85   }; 
_0x3:
;      86 }
_0x4F:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;      87 
;      88 #ifndef _DEBUG_TERMINAL_IO_
;      89 // Get a character from the USART0 Receiver buffer
;      90 #define _ALTERNATE_GETCHAR_
;      91 #pragma used+
;      92 char getchar(void)
;      93 {
;      94 char data;
;      95 while (rx_counter0==0);
;	data -> R16
;      96 data=rx_buffer0[rx_rd_index0];
;      97 if (++rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
;      98 #asm("cli")
;      99 --rx_counter0;
;     100 #asm("sei")
;     101 return data;
;     102 }
;     103 #pragma used-
;     104 #endif
;     105 
;     106 // Standard Input/Output functions
;     107 #include <stdio.h>
;     108 #include <delay.h>
;     109 
;     110 // 2 Wire bus interrupt service routine
;     111 interrupt [TWI] void twi_isr(void)
;     112 {
_twi_isr:
;     113 // Place your code here
;     114 
;     115 }
	RETI
;     116 
;     117 
;     118 
;     119 
;     120 // Declare your global variables here
;     121 
;     122 void twi_init(void);
;     123 unsigned char twi_start (void);
;     124 void twi_stop (void);        
;     125 unsigned char twi_addr (unsigned char addr);
;     126 unsigned char twi_byte (unsigned char data); 
;     127 
;     128 
;     129 ///////////////////////////////////////////////
;     130 //Reset подчиненных устройств
;     131 void Reset (void)
;     132         {
;     133         CRST = 0;
;     134         delay_ms(10);
;     135         CRST = 1;
;     136         delay_ms(250);     //Ждем пока отработают сброс
;     137         }
;     138 
;     139 eeprom unsigned char dummy = 33;

	.ESEG
_dummy:
	.DB  0x21
;     140 
;     141 static inline void NhardwareInit(void)
;     142 {

	.CSEG
;     143 /*
;     144 // Input/Output Ports initialization
;     145 
;     146 PORTA=0x01;     //два мл. бита - светодиод
;     147 DDRA=0x07;
;     148 
;     149 PORTB=0x00;
;     150 DDRB=0x00;
;     151 
;     152 PORTC=0x00;
;     153 DDRC=0x00;
;     154 
;     155 PORTD=0x00;
;     156 DDRD=0x00;
;     157 
;     158 PORTE=0x00;
;     159 DDRE=0x00;
;     160 
;     161 PORTF=0x00;
;     162 DDRF=0x00;
;     163 
;     164 PORTG=0x00;
;     165 DDRG=0x00;
;     166 
;     167 // Timer/Counter 0 initialization
;     168 // Clock source: System Clock
;     169 // Clock value: Timer 0 Stopped
;     170 // Mode: Normal top=FFh
;     171 // OC0 output: Disconnected
;     172 ASSR=0x00;
;     173 TCCR0=0x00;
;     174 TCNT0=0x00;
;     175 OCR0=0x00;
;     176 
;     177 // Timer/Counter 1 initialization
;     178 // Clock source: System Clock
;     179 // Clock value: Timer 1 Stopped
;     180 TCCR1A=0x00;
;     181 TCCR1B=0x00;
;     182 TCNT1H=0x00;
;     183 TCNT1L=0x00;
;     184 ICR1H=0x00;
;     185 ICR1L=0x00;
;     186 OCR1AH=0x00;
;     187 OCR1AL=0x00;
;     188 OCR1BH=0x00;
;     189 OCR1BL=0x00;
;     190 OCR1CH=0x00;
;     191 OCR1CL=0x00;
;     192 
;     193 // Timer/Counter 2 initialization
;     194 TCCR2=0x00;
;     195 TCNT2=0x00;
;     196 OCR2=0x00;
;     197 
;     198 // Timer/Counter 3 initialization
;     199 TCCR3A=0x00;
;     200 TCCR3B=0x00;
;     201 TCNT3H=0x00;
;     202 TCNT3L=0x00;
;     203 ICR3H=0x00;
;     204 ICR3L=0x00;
;     205 OCR3AH=0x00;
;     206 OCR3AL=0x00;
;     207 OCR3BH=0x00;
;     208 OCR3BL=0x00;
;     209 OCR3CH=0x00;
;     210 OCR3CL=0x00;
;     211 
;     212 // External Interrupt(s) initialization
;     213 // Все Off
;     214 EICRA=0x00;
;     215 EICRB=0x00;
;     216 EIMSK=0x00;
;     217 
;     218 // Timer(s)/Counter(s) Interrupt(s) initialization
;     219 TIMSK=0x00;
;     220 ETIMSK=0x00;
;     221 
;     222 // USART0 initialization
;     223 // Communication Parameters: 8 Data, 1 Stop, No Parity
;     224 // USART0 Receiver: On
;     225 // USART0 Transmitter: On
;     226 // USART0 Mode: Asynchronous
;     227 // USART0 Baud rate: 38400
;     228 UCSR0A=0x00;
;     229 UCSR0B=0x98;
;     230 UCSR0C=0x06;
;     231 UBRR0H=0x00;
;     232 UBRR0L=0x0C;
;     233 
;     234 // Analog Comparator initialization
;     235 ACSR=0x80;
;     236 SFIOR=0x00;
;     237 */
;     238 }
;     239 
;     240 void main(void)
;     241 {
_main:
;     242 	HardwareInit();			// Железо процессора
;     243 	CommInit();				// Работа с COM-портом
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
;     244 
;     245 	#asm("sei")
	sei
;     246 
;     247 	while (1)
;     248 	{
;     249 		// Проверяю, нет ли пакета и принимаю меры, если есть
;     250 		if (HaveIncomingPack())
	SBIW R30,0
	BREQ _0xF
;     251 		{
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0xF:
;     252 			switch(IncomingPackType())
;     253 			{
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
;     254 			case PT_GETSTATE:
;     255 				GetState();
;     256 				break;
	RJMP _0xE
;     257 				
;     258 			case PT_GETINFO:
;     259 				GetInfo();
;     260 				break;
;     261 				
;     262 			case PT_SETADDR:
;     263 				SetAddr();
;     264 				break;
;     265 				
;     266 			case PT_SETSERIAL:
_0x16:
	CALL __CPD10
	BRNE _0x17
;     267 				SetSerial();
;     268 				break;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0xE
;     269 				
;     270 			case PT_TOPROG:
_0x17:
	CALL __CPD10
	BREQ PC+3
	JMP _0x18
;     271 				ToProg();
;     272 				break;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
;     273 			
;     274 			default:
;     275 				DiscardIncomingPack();
;     276 				break;
;     277 			}
;     278 		}
;     279 	}
_0xE:
;     280 
;     281 /*
;     282 // Declare your local variables here 
;     283         unsigned char   long_packet,
;     284                         address_packet,
;     285                         type_packet,
;     286                         k;
;     287         
;     288 
;     289    twi_init ();             // Инициализируем I2C
;     290    Reset ();                //Даем сброс всем подчиненным устройствам    
;     291    
;     292 
;     293 // Global enable interrupts
;     294 #asm("sei")
;     295                 LedGreen();                     // Первоначальные установки...   
;     296                 long_packet = 0;                // обнуляем признаки принимаемого по USART пакета                
;     297                 address_packet = 0;
;     298                 type_packet = 0;
;     299         
;     300 while (1)
;     301       {
;     302                
;     303                 k = getchar ();
;     304 
;     305 //        if (rx_buffer_overflow0 == 1)
;     306         {
;     307        
;     308                 LedRed();                             //Старт...  
;     309                  if (!twi_start())                    
;     310                         {
;     311                         twi_stop();        
;     312                         continue;
;     313      		        }
;     314 
;     315 		if (!twi_addr((Addr<<1)&0b11111110))
;     316         		{
;     317                         twi_stop();        
;     318                         continue;
;     319                         }
;     320 
;     321 
;     322 		if (!twi_byte (k))
;     323 		        {
;     324                         twi_stop();        
;     325                         continue;
;     326 	                }
;     327 
;     328         	twi_stop();
;     329 
;     330                 LedGreen();                     // ОК.
;     331 
;     332          }
;     333       
;     334       }
;     335 */
;     336 }
_0x1A:
	RJMP _0x1A
;     337 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;     338 // 
;     339 // Связь с мнешним миром
;     340 
;     341 #include <mega128.h>
;     342 
;     343 // Биты TWCR
;     344 #define TWINT 7
;     345 #define TWEA  6
;     346 #define TWSTA 5
;     347 #define TWSTO 4
;     348 #define TWWC  3
;     349 #define TWEN  2
;     350 #define TWIE  0
;     351 
;     352 // Состояния
;     353 #define START		0x08
;     354 #define	REP_START	0x10
;     355 
;     356 // Коды статуса
;     357 #define	MTX_ADR_ACK		0x18
;     358 #define	MRX_ADR_ACK		0x40
;     359 #define	MTX_DATA_ACK	0x28
;     360 #define	MRX_DATA_NACK	0x58
;     361 #define	MRX_DATA_ACK	0x50
;     362 
;     363 // Подготовка аппаратного мастера I2C
;     364 void twi_init (void)
;     365 {
;     366 	TWSR=0x00;
;     367 	TWBR=0x20;
;     368 	TWAR=0x00;
;     369 	TWCR=0x04;
;     370 }
;     371 
;     372 // Жду флажка
;     373 static void twi_wait_int (void)
;     374 {
;     375 	while (!(TWCR & (1<<TWINT))); 
;     376 }
;     377 
;     378 // Стартовое условие
;     379 // Возвращает не 0, если все в порядке
;     380 unsigned char twi_start (void)
;     381 {
;     382 	TWCR = ((1<<TWINT)+(1<<TWSTA)+(1<<TWEN));
;     383 	
;     384 	twi_wait_int();
;     385 
;     386     if((TWSR != START)&&(TWSR != REP_START))
;     387     {
;     388 		return 0;
;     389 	}
;     390 	
;     391 	return 255;
;     392 }
;     393 
;     394 // Стоповое условие
;     395 void twi_stop (void)
;     396 {
;     397 	TWCR = ((1<<TWEN)+(1<<TWINT)+(1<<TWSTO));
;     398 }
;     399 
;     400 // Передача адреса
;     401 // Возвращает не 0, если все в порядке
;     402 unsigned char twi_addr (unsigned char addr)
;     403 {
;     404 	twi_wait_int();
;     405 
;     406 	TWDR = addr;
;     407 	TWCR = ((1<<TWINT)+(1<<TWEN));
;     408 
;     409 	twi_wait_int();
;     410 
;     411 	if((TWSR != MTX_ADR_ACK)&&(TWSR != MRX_ADR_ACK))
;     412 	{
;     413 		return 0;
;     414 	}
;     415 	return 255;
;     416 }
;     417 
;     418 // Передача байта данных
;     419 // Возвращает не 0, если все в порядке
;     420 unsigned char twi_byte (unsigned char data)
;     421 {
;     422 	twi_wait_int();
;     423 
;     424 	TWDR = data;
;     425  	TWCR = ((1<<TWINT)+(1<<TWEN));
;     426 
;     427 	twi_wait_int();
;     428 
;     429 	if(TWSR != MTX_DATA_ACK)
;     430 	{
;     431 		return 0;
;     432 	}
;     433 		
;     434 	return 255;
;     435 }
;     436 
;     437 // Чтение байта
;     438 // Возвращает не 0, если все в порядке
;     439 unsigned char twi_read (unsigned char * pByt, unsigned char notlast)
;     440 {
;     441 	twi_wait_int();
;     442 
;     443 	if(notlast)
;     444 	{
;     445 		TWCR = ((1<<TWINT)+(1<<TWEA)+(1<<TWEN));
;     446 	}
;     447 	else
;     448 	{
;     449 		TWCR = ((1<<TWINT)+(1<<TWEN));
;     450 	}
;     451 
;     452 	twi_wait_int();
;     453 
;     454 	*pByt = TWDR;
;     455 
;     456  	if(((TWSR == MRX_DATA_NACK)&&(notlast == 0))||(TWSR == MRX_DATA_ACK))
;     457  	{
;     458 		return 255;
;     459 	}
;     460 	
;     461 	return 0;
;     462 }
;     463 
;     464 // Изменение значения бита порта
;     465 static inline void PortBitChange(unsigned char port, unsigned char bnum, unsigned char set)
;     466 {
;     467 	register unsigned char mask;
;     468 	#asm("cli");
;	port -> Y+3
;	bnum -> Y+2
;	set -> Y+1
;	mask -> R16
;     469 
;     470 	mask = 1 << bnum;		// Маска
;     471 	if (!set)
;     472 	{
;     473 		mask ^= 0xFF;
;     474 	}
;     475 		
;     476 	switch(port)
;     477 	{
;     478 	case 'B':
;     479 		if (set) PORTB |= mask; else PORTB &= mask;
;     480 		break;
;     481 	case 'C':
;     482 		if (set) PORTC |= mask; else PORTC &= mask;
;     483 		break;
;     484 	case 'D':
;     485 		if (set) PORTD |= mask; else PORTD &= mask;
;     486 		break;
;     487 	}
;     488 	
;     489 	#asm("sei");
;     490 }
;     491 
;     492 // Передача таблицы из FLASH в I2C
;     493 void i2c_tab (flash unsigned char * tbl, void (* rwfunc)(void))
;     494 {
;     495 	register unsigned char n, p;
;     496 	register flash unsigned char * ptr;
;     497 	
;     498 	while(1)
;	*tbl -> Y+6
;	*rwfunc -> Y+4
;	n -> R16
;	p -> R17
;	*ptr -> R18,R19
;     499 	{
;     500 		if (rwfunc)			// Если нужно, запускаю ожидание готовности
;     501 		{
;     502 			(*rwfunc)();
;     503 		}
;     504 		
;     505 		n = *tbl++;
;     506 		
;     507 		if (!n)				// Если больше нечего передавать ...
;     508 		{
;     509 			return;
;     510 		}
;     511 
;     512 		if (n == 255)		// Если признак бита порта процессора ...
;     513 		{
;     514 			p = *tbl++;						// Порт B, C или D
;     515 			n = *tbl++;						// Номер бита
;     516 			PortBitChange(p, n, *tbl++);	// Взвести или сбросить
;     517 			continue;						// К следующей строке
;     518 		}
;     519 
;     520 		n = n - 2;
;     521 		
;     522 		ptr = tbl;
;     523 		while(1)
;     524 		{
;     525 			if (!twi_start())
;     526 			{
;     527 				twi_stop();
;     528 				continue;
;     529 			}
;     530 	
;     531 			if (!twi_addr(*tbl++))
;     532 			{
;     533 				twi_stop();
;     534 				tbl = ptr;
;     535 				continue;
;     536 			}
;     537 		
;     538 			break;
;     539 		}
;     540 		
;     541 		twi_byte(*tbl++);
;     542 		
;     543 		while(n--)
;     544 		{
;     545 			twi_byte(*tbl++);
;     546 		}
;     547 		
;     548 		twi_stop();
;     549 	}
;     550 }
;     551 
;     552 /*
;     553 // Передача в заданный адрес I2C nbytes байт
;     554 void i2c_bytes (unsigned char addr, unsigned char sbaddr, unsigned char nbytes, ...)
;     555 {
;     556 	va_list argptr;
;     557 	char byt;
;     558 	
;     559 	va_start(argptr, nbytes);
;     560 	
;     561 	while(1)
;     562 	{
;     563 		if (!twi_start())
;     564 		{
;     565 			twi_stop();
;     566 			continue;
;     567 		}
;     568 	
;     569 		if (!twi_addr(addr))
;     570 		{
;     571 			twi_stop();
;     572 			continue;
;     573 		}
;     574 		
;     575 		break;
;     576 	}
;     577 	
;     578 	twi_byte(sbaddr);
;     579 
;     580 	while(nbytes--)
;     581 	{
;     582 		byt = va_arg(argptr, char);
;     583 		twi_byte(byt);
;     584 	}		
;     585 	va_end(argptr);
;     586 		
;     587 	twi_stop();
;     588 }
;     589 */
;     590 
;     591 // Передача в заданный адрес I2C таблицы PSI
;     592 void i2c_psi_table (
;     593 		unsigned char addr,
;     594 		unsigned char sbaddr,
;     595 		unsigned char tblnum,
;     596 		unsigned short pid,
;     597 		unsigned char * buf)
;     598 {
;     599 	unsigned char n;
;     600 	
;     601 	pid &= 0x1FFF;
;	addr -> Y+7
;	sbaddr -> Y+6
;	tblnum -> Y+5
;	pid -> Y+3
;	*buf -> Y+1
;	n -> R16
;     602 	pid |= 0x4000;
;     603 
;     604 	while(1)
;     605 	{	
;     606 		if (!twi_start())
;     607 		{
;     608 			twi_stop();
;     609 			continue;
;     610 		}
;     611 		
;     612 		if (!twi_addr(addr))
;     613 		{
;     614 			twi_stop();
;     615 			continue;
;     616 		}
;     617 		
;     618 		break;
;     619 	}
;     620 		
;     621 	twi_byte(sbaddr);
;     622 	
;     623 	twi_byte(tblnum);
;     624 
;     625 	twi_byte(0x47);			// Заголовок пакета
;     626 	twi_byte(pid >> 8);	
;     627 	twi_byte(pid & 0xFF);	
;     628 	twi_byte(0x10);	
;     629 	twi_byte(0x00);	
;     630 	
;     631 	for (n = buf[2] + 3; n != 0; n --)
;     632 	{
;     633 		twi_byte(*buf++);
;     634 	}
;     635 	
;     636 	twi_stop();
;     637 }

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

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
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
