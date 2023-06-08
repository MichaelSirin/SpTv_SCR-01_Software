;CodeVisionAVR C Compiler V1.24.7e Professional
;(C) Copyright 1998-2005 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External SRAM size     : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : No
;char is unsigned       : Yes
;8 bit enums            : Yes
;Word align FLASH struct: No
;Enhanced core instructions    : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

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
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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

	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_adc_noise_red=0x10
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70

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
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	RCALL __EEPROMRDW
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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

	.INCLUDE "prog_mega8_1.vec"
	.INCLUDE "prog_mega8_1.inc"

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

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
	LDI  R24,LOW(0x400)
	LDI  R25,HIGH(0x400)
	LDI  R26,0x60
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
	LDI  R30,LOW(0x45F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x45F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x160)
	LDI  R29,HIGH(0x160)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160
;       1 /*****************************************************
;       2 This program was produced by the
;       3 CodeWizardAVR V1.24.5 Standard
;       4 Automatic Program Generator
;       5 © Copyright 1998-2005 Pavel Haiduc, HP InfoTech s.r.l.
;       6 http://www.hpinfotech.com
;       7 e-mail:office@hpinfotech.com
;       8 
;       9 Project : 
;      10 Version : 
;      11 Date    : 01.03.2006
;      12 Author  : TeleSys Embedded                
;      13 Company : FastmanSoft Inc.                
;      14 Comments: 
;      15 
;      16 
;      17 Chip type           : ATmega8
;      18 Program type        : Application
;      19 Clock frequency     : 8,000000 MHz
;      20 Memory model        : Small
;      21 External SRAM size  : 0
;      22 Data Stack size     : 256
;      23 *****************************************************/
;      24 
;      25 // Standard Input/Output functions
;      26 #include <stdio.h>
;      27 #include <delay.h>
;      28 #include <string.h>
;      29   
;      30 #include "CDdef.h"  				// мой описатель
;      31 /*****************************************************************************
;      32 *
;      33 * Atmel Corporation
;      34 *
;      35 * File              : TWI_Slave.h
;      36 * Compiler          : IAR EWAAVR 2.28a/3.10c
;      37 * Revision          : $Revision: 1.6 $
;      38 * Date              : $Date: Monday, May 24, 2004 09:32:18 UTC $
;      39 * Updated by        : $Author: ltwa $
;      40 *
;      41 * Support mail      : avr@atmel.com
;      42 *
;      43 * Supported devices : All devices with a TWI module can be used.
;      44 *                     The example is written for the ATmega16
;      45 *
;      46 * AppNote           : AVR311 - TWI Slave Implementation
;      47 *
;      48 * Description       : Header file for TWI_slave.c
;      49 *                     Include this file in the application.
;      50 *
;      51 ****************************************************************************/
;      52 #include <mega8.h> 
;      53 
;      54 /****************************************************************************
;      55   TWI Status/Control register definitions
;      56 ****************************************************************************/
;      57 
;      58 #define TWI_BUFFER_SIZE 250      // Reserves memory for the drivers transceiver buffer. 
;      59                                // Set this to the largest message size that will be sent including address byte.
;      60 
;      61 /****************************************************************************
;      62   Global definitions
;      63 ****************************************************************************/
;      64 /****************************************************************************
;      65   Global definitions
;      66 ****************************************************************************/
;      67 	typedef  struct
;      68     {
;      69         unsigned char lastTransOK:1;      
;      70         unsigned char RxDataInBuf:1;
;      71         unsigned char genAddressCall:1;                       // TRUE = General call, FALSE = TWI Address;
;      72         unsigned char unusedBits:5;
;      73     } SB;
;      74   
;      75   	typedef union 				                       // Status byte holding flags.
;      76 	{
;      77     	unsigned char all;
;      78     	SB bits;
;      79 	}  TWISR;
;      80 
;      81 extern  TWISR  TWI_statusReg;        
;      82 
;      83 
;      84 // Для совместимости
;      85 #define  __no_operation() #asm("nop")
;      86 #define  __enable_interrupt() #asm("sei")
;      87 #define  __disable_interrupt() #asm("cli")
;      88 
;      89 
;      90 /****************************************************************************
;      91   Function definitions
;      92 ****************************************************************************/
;      93 void TWI_Slave_Initialise( unsigned char );
;      94 unsigned char TWI_Transceiver_Busy( void );
;      95 unsigned char TWI_Get_State_Info( void );
;      96 void TWI_Start_Transceiver_With_Data( unsigned char * , unsigned char );
;      97 void TWI_Start_Transceiver( void );
;      98 unsigned char TWI_Get_Data_From_Transceiver( unsigned char *, unsigned char );    
;      99 
;     100 void run_TWI_slave ( void );
;     101 
;     102 
;     103 /****************************************************************************
;     104   Bit and byte definitions
;     105 ****************************************************************************/
;     106 #define TWI_READ_BIT  0   // Bit position for R/W bit in "address byte".
;     107 #define TWI_ADR_BITS  1   // Bit position for LSB of the slave address bits in the init byte.
;     108 #define TWI_GEN_BIT   0   // Bit position for LSB of the general call bit in the init byte.
;     109 
;     110 #define TRUE          1
;     111 #define FALSE         0
;     112 
;     113 /****************************************************************************
;     114   TWI State codes
;     115 ****************************************************************************/
;     116 // General TWI Master staus codes                      
;     117 #define TWI_START                  0x08  // START has been transmitted  
;     118 #define TWI_REP_START              0x10  // Repeated START has been transmitted
;     119 #define TWI_ARB_LOST               0x38  // Arbitration lost
;     120 
;     121 // TWI Master Transmitter staus codes                      
;     122 #define TWI_MTX_ADR_ACK            0x18  // SLA+W has been tramsmitted and ACK received
;     123 #define TWI_MTX_ADR_NACK           0x20  // SLA+W has been tramsmitted and NACK received 
;     124 #define TWI_MTX_DATA_ACK           0x28  // Data byte has been tramsmitted and ACK received
;     125 #define TWI_MTX_DATA_NACK          0x30  // Data byte has been tramsmitted and NACK received 
;     126 
;     127 // TWI Master Receiver staus codes  
;     128 #define TWI_MRX_ADR_ACK            0x40  // SLA+R has been tramsmitted and ACK received
;     129 #define TWI_MRX_ADR_NACK           0x48  // SLA+R has been tramsmitted and NACK received
;     130 #define TWI_MRX_DATA_ACK           0x50  // Data byte has been received and ACK tramsmitted
;     131 #define TWI_MRX_DATA_NACK          0x58  // Data byte has been received and NACK tramsmitted
;     132 
;     133 // TWI Slave Transmitter staus codes
;     134 #define TWI_STX_ADR_ACK            0xA8  // Own SLA+R has been received; ACK has been returned
;     135 #define TWI_STX_ADR_ACK_M_ARB_LOST 0xB0  // Arbitration lost in SLA+R/W as Master; own SLA+R has been received; ACK has been returned
;     136 #define TWI_STX_DATA_ACK           0xB8  // Data byte in TWDR has been transmitted; ACK has been received
;     137 #define TWI_STX_DATA_NACK          0xC0  // Data byte in TWDR has been transmitted; NOT ACK has been received
;     138 #define TWI_STX_DATA_ACK_LAST_BYTE 0xC8  // Last data byte in TWDR has been transmitted (TWEA = “0”); ACK has been received
;     139 
;     140 // TWI Slave Receiver staus codes
;     141 #define TWI_SRX_ADR_ACK            0x60  // Own SLA+W has been received ACK has been returned
;     142 #define TWI_SRX_ADR_ACK_M_ARB_LOST 0x68  // Arbitration lost in SLA+R/W as Master; own SLA+W has been received; ACK has been returned
;     143 #define TWI_SRX_GEN_ACK            0x70  // General call address has been received; ACK has been returned
;     144 #define TWI_SRX_GEN_ACK_M_ARB_LOST 0x78  // Arbitration lost in SLA+R/W as Master; General call address has been received; ACK has been returned
;     145 #define TWI_SRX_ADR_DATA_ACK       0x80  // Previously addressed with own SLA+W; data has been received; ACK has been returned
;     146 #define TWI_SRX_ADR_DATA_NACK      0x88  // Previously addressed with own SLA+W; data has been received; NOT ACK has been returned
;     147 #define TWI_SRX_GEN_DATA_ACK       0x90  // Previously addressed with general call; data has been received; ACK has been returned
;     148 #define TWI_SRX_GEN_DATA_NACK      0x98  // Previously addressed with general call; data has been received; NOT ACK has been returned
;     149 #define TWI_SRX_STOP_RESTART       0xA0  // A STOP condition or repeated START condition has been received while still addressed as Slave
;     150 
;     151 // TWI Miscellaneous status codes
;     152 #define TWI_NO_STATE               0xF8  // No relevant state information available; TWINT = “0”
;     153 #define TWI_BUS_ERROR              0x00  // Bus error due to an illegal START or STOP condition
;     154 
;     155 // Биты TWCR
;     156 #define TWINT 7             //Флаг прерывания выполнения задачи
;     157 #define TWEA  6             //Генерить ли бит ответа на вызов
;     158 #define TWSTA 5             //Генерить СТАРТ
;     159 #define TWSTO 4             //Генерить СТОП
;     160 #define TWWC  3             //
;     161 #define TWEN  2             //Разрешаем работу I2C
;     162 #define TWIE  0             //Прерывание
;     163 
;     164 
;     165 
;     166 unsigned char rxBufferTWI	[TWI_BUFFER_SIZE];				// приемный буфер  TWI
_rxBufferTWI:
	.BYTE 0xFA
;     167 unsigned char txBufferTWI	[(TWI_BUFFER_SIZE/2)-25];						// передающий буфер TWI
_txBufferTWI:
	.BYTE 0x64
;     168 unsigned char rxBufferUART	[(TWI_BUFFER_SIZE/2)-25];					// накапливающий приемный буфер UART
_rxBufferUART:
	.BYTE 0x64
;     169 
;     170 unsigned char CountUART = 0, CountUART_1 = 0, Relay_Pack_TWI_UART,  Relay_Pack_UART_TWI;
;     171 unsigned char Count_For_Timer2 , Packet_Lost ;
;     172  
;     173 
;     174 // Адреса устройства
;     175 unsigned char lAddr	 	=	 	0x0;				//Логический адрес (адр. подключенного устройства)
;     176 
;     177 // Все для работы с TWI
;     178 TWISR TWI_statusReg;   
_TWI_statusReg:
	.BYTE 0x1
;     179 unsigned char 	TWI_slaveAddress = MY_TWI_ADDRESS;		// Own TWI slave address
;     180 
;     181 // Флаги состояния
;     182 bit		gate_UART_to_TWI_open	=		1;					// ретрансляция из UART в TWI
;     183 bit		rxPack								=		0;					// принят пакет																						
;     184 bit		TWI_TX_Packet_Present	=		0;					// есть данные на передачу
;     185 bit 		rxPackUART 						= 		0;					// принят пакет по UART
;     186 bit 		Device_Connected				=		0;					// есть связь с подчиненным
;     187 bit 		InternalPack 						= 		0;					// принят внутренний пакет
;     188 bit		to_Reboot							=		0;					// на перезагрузку в Загрузчик
;     189 bit		Responce_Time_Out			=		0;					// время ожидания ответного пакета истекло
;     190 //bit		lock_PORT						=		1;					// заблокировать COM порт
;     191 
;     192 // USART Receiver interrupt service routine
;     193 interrupt [USART_RXC] void usart_rx_isr(void)      
;     194 {     

	.CSEG
_usart_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;     195 	unsigned char data ;
;     196 	data = UDR;              
	ST   -Y,R16
;	data -> R16
	IN   R16,12
;     197 
;     198 	if ((UCSRA & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	IN   R30,0xB
	ANDI R30,LOW(0x1C)
	BRNE _0x4
;     199 	{
;     200 		if (!(CountUART)) 		             		// Прием с начала
	TST  R4
	BRNE _0x5
;     201 		{ 
;     202 			if (!rxPackUART)           				// предыдущий пакет передан?
	SBRC R2,3
	RJMP _0x6
;     203 			{
;     204 				CountUART_1 = 0;
	CLR  R5
;     205 				rxBufferUART [CountUART_1++] = data;
	RCALL SUBOPT_0x0
;     206 				CountUART = data;
	MOV  R4,R16
;     207 			} 
;     208 		}
_0x6:
;     209 		else
	RJMP _0x7
_0x5:
;     210 		{                                                  // продолжаем прием пакета
;     211 			rxBufferUART[CountUART_1++] = data;
	RCALL SUBOPT_0x0
;     212 			if (!(--CountUART)) 					
	DEC  R4
	BRNE _0x8
;     213 					rxPackUART = 1;              // принят весь пакет
	SET
	BLD  R2,3
;     214     	} 
_0x8:
_0x7:
;     215 	}                
;     216 }
_0x4:
	LD   R16,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;     217 
;     218 void main(void)
;     219 {
_main:
;     220 // Declare your local variables here
;     221 
;     222 	LedOff();
	SBI  0x12,3
;     223 	Initialization_Device();  						// инициализация железа
	RCALL _Initialization_Device
;     224 
;     225 	// Global enable interrupts
;     226 	#asm("sei")
	sei
;     227 
;     228 	// Start the TWI transceiver to enable reseption of the first command from the TWI Master.
;     229 	txBufferTWI[0] = 0;     					// данных на передачу нет
	RCALL SUBOPT_0x1
;     230 	TWI_Start_Transceiver();
	RCALL _TWI_Start_Transceiver
;     231 
;     232 	LedOn();         
	CBI  0x12,3
;     233 
;     234 	give_GETINFO();		// отправляем посылку запроса в порт
	RCALL _give_GETINFO
;     235                                                      
;     236     port_state (FALSE);		//блокируем порт
	RCALL SUBOPT_0x2
	RCALL _port_state
;     237 #ifdef aaa
;     238     port_state (TRUE);		//блокируем порт
;     239 #endif    
;     240 
;     241 
;     242     
;     243 	while (1)
_0x9:
;     244     {     
;     245 
;     246 
;     247 		run_TWI_slave();
	RCALL _run_TWI_slave
;     248 
;     249 		if ( rxPack )
	SBRS R2,1
	RJMP _0xC
;     250 		{
;     251 
;     252 		 	workINpack();				// принят пакет TWI 
	RCALL _workINpack
;     253 			rxPack = 0;					// пакет обработан
	CLT
	BLD  R2,1
;     254 		}
;     255 
;     256 
;     257 		// обрабатываем принятый пакетUART
;     258 		if ( rxPackUART )
_0xC:
	SBRS R2,3
	RJMP _0xD
;     259 		{
;     260 				// проверяем КС
;     261 				if (checkCRCrx ( &UART_RX_Len, from_UART ) )
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
	BREQ _0xE
;     262 				{
;     263 					TCNT1=0x0000;				// при правильном обмене не проверяем адрес подч. устройства
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
;     264 					LedOff ();						// пришел ответ
	SBI  0x12,3
;     265 
;     266 					workUARTpack();			// обрабатываем пакет
	RCALL _workUARTpack
;     267 				}       
;     268 				
;     269 		rxPackUART = 0;						// пакет обработан 
_0xE:
	CLT
	BLD  R2,3
;     270 		}
;     271 
;     272 		// Таймаут истек. Ошибка устройства
;     273 		if ( Responce_Time_Out ) 
_0xD:
	SBRS R2,7
	RJMP _0xF
;     274 		{
;     275 			Responce_OK (FALSE);							
	RCALL SUBOPT_0x2
	RCALL _Responce_OK
;     276 		 	Responce_Time_Out = 0;
	CLT
	BLD  R2,7
;     277 			gate_UART_to_TWI_open = FALSE; 
	BLD  R2,0
;     278 
;     279 		 }
;     280 		 
;     281 		//  на перезагрузку в загрузчик
;     282 		if ( to_Reboot )
_0xF:
	SBRS R2,6
	RJMP _0x10
;     283 		{             
;     284 			if ( ! TWI_TX_Packet_Present )			// ждем пока вычитается ответ 
	SBRC R2,2
	RJMP _0x11
;     285 			{
;     286 				// На перезагрузку в монитор
;     287 				IVCREG = 1 << IVCE;
	LDI  R30,LOW(1)
	OUT  0x3B,R30
;     288 				IVCREG = 1 << IVSEL;
	LDI  R30,LOW(2)
	OUT  0x3B,R30
;     289 				#asm("rjmp 0xC00");
	rjmp 0xC00
;     290 			}
;     291 		}
_0x11:
;     292      }
_0x10:
	RJMP _0x9
;     293 }
_0x12:
	RJMP _0x12
;     294 #include <twi_slave.h >
;     295 /*****************************************************************************
;     296 *
;     297 * Atmel Corporation
;     298 *
;     299 * File              : TWI_Slave.h
;     300 * Compiler          : IAR EWAAVR 2.28a/3.10c
;     301 * Revision          : $Revision: 1.6 $
;     302 * Date              : $Date: Monday, May 24, 2004 09:32:18 UTC $
;     303 * Updated by        : $Author: ltwa $
;     304 *
;     305 * Support mail      : avr@atmel.com
;     306 *
;     307 * Supported devices : All devices with a TWI module can be used.
;     308 *                     The example is written for the ATmega16
;     309 *
;     310 * AppNote           : AVR311 - TWI Slave Implementation
;     311 *
;     312 * Description       : Header file for TWI_slave.c
;     313 *                     Include this file in the application.
;     314 *
;     315 ****************************************************************************/
;     316 #include <mega8.h> 
;     317 
;     318 /****************************************************************************
;     319   TWI Status/Control register definitions
;     320 ****************************************************************************/
;     321 
;     322 #define TWI_BUFFER_SIZE 250      // Reserves memory for the drivers transceiver buffer. 
;     323                                // Set this to the largest message size that will be sent including address byte.
;     324 
;     325 /****************************************************************************
;     326   Global definitions
;     327 ****************************************************************************/
;     328 /****************************************************************************
;     329   Global definitions
;     330 ****************************************************************************/
;     331 	typedef  struct
;     332     {
;     333         unsigned char lastTransOK:1;      
;     334         unsigned char RxDataInBuf:1;
;     335         unsigned char genAddressCall:1;                       // TRUE = General call, FALSE = TWI Address;
;     336         unsigned char unusedBits:5;
;     337     } SB;
;     338   
;     339   	typedef union 				                       // Status byte holding flags.
;     340 	{
;     341     	unsigned char all;
;     342     	SB bits;
;     343 	}  TWISR;
;     344 
;     345 extern  TWISR  TWI_statusReg;        
;     346 
;     347 
;     348 // Для совместимости
;     349 #define  __no_operation() #asm("nop")
;     350 #define  __enable_interrupt() #asm("sei")
;     351 #define  __disable_interrupt() #asm("cli")
;     352 
;     353 
;     354 /****************************************************************************
;     355   Function definitions
;     356 ****************************************************************************/
;     357 void TWI_Slave_Initialise( unsigned char );
;     358 unsigned char TWI_Transceiver_Busy( void );
;     359 unsigned char TWI_Get_State_Info( void );
;     360 void TWI_Start_Transceiver_With_Data( unsigned char * , unsigned char );
;     361 void TWI_Start_Transceiver( void );
;     362 unsigned char TWI_Get_Data_From_Transceiver( unsigned char *, unsigned char );    
;     363 
;     364 void run_TWI_slave ( void );
;     365 
;     366 
;     367 /****************************************************************************
;     368   Bit and byte definitions
;     369 ****************************************************************************/
;     370 #define TWI_READ_BIT  0   // Bit position for R/W bit in "address byte".
;     371 #define TWI_ADR_BITS  1   // Bit position for LSB of the slave address bits in the init byte.
;     372 #define TWI_GEN_BIT   0   // Bit position for LSB of the general call bit in the init byte.
;     373 
;     374 #define TRUE          1
;     375 #define FALSE         0
;     376 
;     377 /****************************************************************************
;     378   TWI State codes
;     379 ****************************************************************************/
;     380 // General TWI Master staus codes                      
;     381 #define TWI_START                  0x08  // START has been transmitted  
;     382 #define TWI_REP_START              0x10  // Repeated START has been transmitted
;     383 #define TWI_ARB_LOST               0x38  // Arbitration lost
;     384 
;     385 // TWI Master Transmitter staus codes                      
;     386 #define TWI_MTX_ADR_ACK            0x18  // SLA+W has been tramsmitted and ACK received
;     387 #define TWI_MTX_ADR_NACK           0x20  // SLA+W has been tramsmitted and NACK received 
;     388 #define TWI_MTX_DATA_ACK           0x28  // Data byte has been tramsmitted and ACK received
;     389 #define TWI_MTX_DATA_NACK          0x30  // Data byte has been tramsmitted and NACK received 
;     390 
;     391 // TWI Master Receiver staus codes  
;     392 #define TWI_MRX_ADR_ACK            0x40  // SLA+R has been tramsmitted and ACK received
;     393 #define TWI_MRX_ADR_NACK           0x48  // SLA+R has been tramsmitted and NACK received
;     394 #define TWI_MRX_DATA_ACK           0x50  // Data byte has been received and ACK tramsmitted
;     395 #define TWI_MRX_DATA_NACK          0x58  // Data byte has been received and NACK tramsmitted
;     396 
;     397 // TWI Slave Transmitter staus codes
;     398 #define TWI_STX_ADR_ACK            0xA8  // Own SLA+R has been received; ACK has been returned
;     399 #define TWI_STX_ADR_ACK_M_ARB_LOST 0xB0  // Arbitration lost in SLA+R/W as Master; own SLA+R has been received; ACK has been returned
;     400 #define TWI_STX_DATA_ACK           0xB8  // Data byte in TWDR has been transmitted; ACK has been received
;     401 #define TWI_STX_DATA_NACK          0xC0  // Data byte in TWDR has been transmitted; NOT ACK has been received
;     402 #define TWI_STX_DATA_ACK_LAST_BYTE 0xC8  // Last data byte in TWDR has been transmitted (TWEA = “0”); ACK has been received
;     403 
;     404 // TWI Slave Receiver staus codes
;     405 #define TWI_SRX_ADR_ACK            0x60  // Own SLA+W has been received ACK has been returned
;     406 #define TWI_SRX_ADR_ACK_M_ARB_LOST 0x68  // Arbitration lost in SLA+R/W as Master; own SLA+W has been received; ACK has been returned
;     407 #define TWI_SRX_GEN_ACK            0x70  // General call address has been received; ACK has been returned
;     408 #define TWI_SRX_GEN_ACK_M_ARB_LOST 0x78  // Arbitration lost in SLA+R/W as Master; General call address has been received; ACK has been returned
;     409 #define TWI_SRX_ADR_DATA_ACK       0x80  // Previously addressed with own SLA+W; data has been received; ACK has been returned
;     410 #define TWI_SRX_ADR_DATA_NACK      0x88  // Previously addressed with own SLA+W; data has been received; NOT ACK has been returned
;     411 #define TWI_SRX_GEN_DATA_ACK       0x90  // Previously addressed with general call; data has been received; ACK has been returned
;     412 #define TWI_SRX_GEN_DATA_NACK      0x98  // Previously addressed with general call; data has been received; NOT ACK has been returned
;     413 #define TWI_SRX_STOP_RESTART       0xA0  // A STOP condition or repeated START condition has been received while still addressed as Slave
;     414 
;     415 // TWI Miscellaneous status codes
;     416 #define TWI_NO_STATE               0xF8  // No relevant state information available; TWINT = “0”
;     417 #define TWI_BUS_ERROR              0x00  // Bus error due to an illegal START or STOP condition
;     418 
;     419 // Биты TWCR
;     420 #define TWINT 7             //Флаг прерывания выполнения задачи
;     421 #define TWEA  6             //Генерить ли бит ответа на вызов
;     422 #define TWSTA 5             //Генерить СТАРТ
;     423 #define TWSTO 4             //Генерить СТОП
;     424 #define TWWC  3             //
;     425 #define TWEN  2             //Разрешаем работу I2C
;     426 #define TWIE  0             //Прерывание
;     427 
;     428 
;     429 #include <Scrambling.h >
;     430 
;     431 //#define TWI_Buffer_TX				120			// Буфер на прием UART/ передача TWI    
;     432 
;     433 #define from_TWI		0x0						// порт TWI
;     434 #define from_UART	0x1						// порт UART 
;     435 #define START_Timer  1						// таймер 200мс
;     436 #define STOP_Timer    0   
;     437 
;     438  #define Start_Position_for_Reply	2		// стартовая позиция для ответного пакета
;     439 #define Long_TX_Packet_TWI  	txBufferTWI[Start_Position_for_Reply]  // длина передаваемого пакета
;     440 #define Command_TX_Packet_TWI 	txBufferTWI[Start_Position_for_Reply+1]   // тип передаваемого пакета (команда)
;     441 #define CRC_TX_Packet_TWI   			txBufferTWI[Start_Position_for_Reply+Long_TX_Packet_TWI]	// СRC передаваемого пакета 
;     442 
;     443 
;     444 #define TWI_RX_Command 	 	rxBufferTWI[0]  // команда TWI
;     445 #define Heading_RX_Packet  	rxBufferTWI[1]  // заголовок пакета
;     446 #define Long_RX_Packet_TWI  	rxBufferTWI[2]  // длина принятого пакета
;     447 #define Recived_Address 			rxBufferTWI[3]  // адрес в принятом пакете
;     448 #define Type_RX_Packet_TWI 	rxBufferTWI[4]  // тип принятого пакета 
;     449 #define PT_GETSTATE_page		rxBufferTWI[5]	// номер страницы в пакете GETSTATE	
;     450 #define CRC_RX_Packet_TWI   rxBufferTWI[ rxBufferTWI[2]+2]	// CRC принятого пакета
;     451 
;     452 // Типы пакетов, используемых в CD
;     453 
;     454 #define GetLogAddr					1		// дать логический адрес 
;     455 //#define pingPack						2		// нас пингуют на наличие информации на передачу
;     456 #define Responce_GEN_CALL	3		// ответ на GEN CALL   
;     457 #define Responce_GEN_CALL_internal	4	// ответы для внутр. скремблера
;     458 
;     459 #define Internal_Packet		0x00			// пакеты внутреннего пользования
;     460 #define External_Packet 	0x01			// пакеты ретранслируемые
;     461 #define Global_Packet		0xFF			// глобальный пакет
;     462 
;     463 	
;     464 // Команды, передаваемые по TWI
;     465 #define TWI_CMD_MASTER_WRITE 					0x10
;     466 #define TWI_CMD_MASTER_READ  						0x20      
;     467 #define TWI_CMD_MASTER_RECIVE_PACK_OK 	0x21
;     468 #define TWI_CMD_MASTER_REQUEST_CRC 		0x22       
;     469 
;     470 // Функции
;     471 unsigned char TWI_Act_On_Failure_In_Last_Transmission ( unsigned char TWIerrorMsg );
;     472 void run_TWI_slave ( void ); 
;     473 unsigned char calc_CRC (unsigned char *Position_in_Packet); // Считаем CRC передаваемого пакета
;     474 void packPacket (unsigned char type);
;     475 
;     476 
;     477 
;     478 
;     479 
;     480 
;     481 // Инициализация железа. Определение адресов.
;     482 // 
;     483 void Initialization_Device (void)
;     484 {                                      
_Initialization_Device:
;     485 		PORTC=0x07;
	LDI  R30,LOW(7)
	OUT  0x15,R30
;     486 
;     487 		#ifndef BOOT_PROGRAM
;     488 
;     489 		DDRD=0x1C;
	LDI  R30,LOW(28)
	OUT  0x11,R30
;     490 
;     491 		// External Interrupt(s) initialization
;     492 		// INT0: Off
;     493 		// INT1: Off
;     494 		MCUCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
;     495 
;     496 		// Analog Comparator initialization
;     497 		// Analog Comparator: Off
;     498 		// Analog Comparator Input Capture by Timer/Counter 1: Off
;     499 		ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     500 		SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;     501 
;     502 		// Инициализируем таймера 
;     503 		// Timer/Counter 0 initialization; Clock value: 7,813 kHz; 
;     504 		TCCR0=0x00;
	RCALL SUBOPT_0x6
;     505 		TCNT0=0x00;   
	LDI  R30,LOW(0)
	OUT  0x32,R30
;     506 
;     507 
;     508 		//Timer/Counter 2 initialization; Clock value: 7,813 kHz
;     509 		// Mode: Normal top=FFh;
;     510 		// Таймаут ожидания ответного пакета при GEN_CALL (200 ms)
;     511 		ASSR=0x00;
	OUT  0x22,R30
;     512 		TCCR2=0x00;
	OUT  0x25,R30
;     513 		TCNT2=0x00;
	RCALL SUBOPT_0x7
;     514 		OCR2=0x00;     
	LDI  R30,LOW(0)
	OUT  0x23,R30
;     515 		
;     516 		// Timer/Counter 1 initialization
;     517 		// Clock source: System Clock; Clock value: 7,813 kHz
;     518 		// Mode: Normal top=FFFFh; Таймаут опроса устройства RS-232
;     519 		TCCR1A=0x00;
	OUT  0x2F,R30
;     520 		TCCR1B=0x85;
	LDI  R30,LOW(133)
	OUT  0x2E,R30
;     521 		TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
;     522 		TCNT1L=0x00;
	OUT  0x2C,R30
;     523 		ICR1H=0x67;
	LDI  R30,LOW(103)
	OUT  0x27,R30
;     524 		ICR1L=0x69;
	LDI  R30,LOW(105)
	OUT  0x26,R30
;     525 		OCR1AH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2B,R30
;     526 		OCR1AL=0x00;
	OUT  0x2A,R30
;     527 		OCR1BH=0x00;
	OUT  0x29,R30
;     528 		OCR1BL=0x00;
	OUT  0x28,R30
;     529 
;     530 		// Timer(s)/Counter(s) Interrupt(s) initialization
;     531 		TIMSK=0x45;
	LDI  R30,LOW(69)
	OUT  0x39,R30
;     532 
;     533 		#else
;     534 
;     535 		// Timer/Counter 1 initialization
;     536 		// Clock source: System Clock; Clock value: 7,813 kHz
;     537 		// Mode: Normal top=FFFFh; Таймаут опроса устройства RS-232
;     538 		TCCR1B=0x05;
;     539 		TCNT1=0xD2F6;		//примерно 2сек
;     540 
;     541 		// Вотчдог
;     542 //		WDTCR=0x1F;
;     543 //		WDTCR=0x0F;              
;     544 		#endif
;     545 
;     546 		
;     547 
;     548 		// USART initialization
;     549 		// Communication Parameters: 8 Data, 1 Stop, No Parity
;     550 		// USART Receiver: On
;     551 		// USART Transmitter: On
;     552 		// USART Mode: Asynchronous
;     553 		// USART Baud rate: 38400
;     554 //		UCSRA=0x00;
;     555 		UCSRB=0x98;
	RCALL SUBOPT_0x8
;     556 		UCSRC=0x86;
;     557 //		UBRRH=0x00;
;     558 		UBRRL=0x0C;
	OUT  0x9,R30
;     559 
;     560 		// Initialise TWI module for slave operation. Include address and/or enable General Call.
;     561 		// Читаем свой адрес
;     562 		TWI_slaveAddress += (PINC & 0b00000111);
	IN   R30,0x13
	ANDI R30,LOW(0x7)
	ADD  R11,R30
;     563 		TWI_Slave_Initialise( (TWI_slaveAddress<<TWI_ADR_BITS) | (TRUE<<TWI_GEN_BIT) ); 
	MOV  R30,R11
	LSL  R30
	ORI  R30,1
	ST   -Y,R30
	RCALL _TWI_Slave_Initialise
;     564  }                                  
	RET
;     565 
;     566 
;     567 // Считаем CRC передаваемого пакета
;     568 unsigned char calc_CRC (unsigned char *Position_in_Packet)
;     569 {                    
_calc_CRC:
;     570 	unsigned char CRC = 0, a;                                   
;     571 
;     572 	a = *Position_in_Packet ;
	RCALL __SAVELOCR2
;	*Position_in_Packet -> Y+2
;	CRC -> R16
;	a -> R17
	LDI  R16,0
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R17,X
;     573 	
;     574 	while(a--)
_0x13:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x15
;     575 	{
;     576 		CRC += *Position_in_Packet++;
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X+
	STD  Y+2,R26
	STD  Y+2+1,R27
	ADD  R16,R30
;     577 	}
	RJMP _0x13
_0x15:
;     578 
;     579 	return CRC;
	MOV  R30,R16
	RCALL __LOADLOCR2
	ADIW R28,4
	RET
;     580 }
;     581 
;     582 // Упаковка пакета во внешний...
;     583 void packPacket (unsigned char type)
;     584 {
_packPacket:
;     585 		txBufferTWI[0] = txBufferTWI[Start_Position_for_Reply]+3;				// ДЛИНА
	__GETB1MN _txBufferTWI,2
	SUBI R30,-LOW(3)
	STS  _txBufferTWI,R30
;     586 		txBufferTWI[1] = type;																	// ТИП
	LD   R30,Y
	__PUTB1MN _txBufferTWI,1
;     587 
;     588 		txBufferTWI[txBufferTWI[0]] = calc_CRC( &txBufferTWI[0] );           //CRC
	LDS  R30,_txBufferTWI
	RCALL SUBOPT_0x9
	PUSH R31
	PUSH R30
	LDI  R30,LOW(_txBufferTWI)
	LDI  R31,HIGH(_txBufferTWI)
	RCALL SUBOPT_0xA
	POP  R26
	POP  R27
	RCALL SUBOPT_0xB
;     589 		TWI_TX_Packet_Present = 1;		// есть пакет на передачу
	BLD  R2,2
;     590 }
	RJMP _0x85
;     591 
;     592 
;     593 // считаем КС принятого пакета. Указатель - на начало пакета.
;     594 unsigned char checkCRCrx (unsigned char *Position_in_Packet, unsigned char Incoming_PORT)
;     595 {                    
_checkCRCrx:
;     596 	unsigned char CRC=0 , a;		
;     597 	
;     598 	// Из TWI - начинаем считать с заголовка
;     599     if ( Incoming_PORT == from_TWI ) CRC = *Position_in_Packet ++;  // заголовок пакета
	RCALL __SAVELOCR2
;	*Position_in_Packet -> Y+3
;	Incoming_PORT -> Y+2
;	CRC -> R16
;	a -> R17
	LDI  R16,0
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0x16
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LD   R16,X+
	STD  Y+3,R26
	STD  Y+3+1,R27
;     600     
;     601 	// Из UART - начинаем считать с длины
;     602 	a = *Position_in_Packet ;
_0x16:
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LD   R17,X
;     603 	
;     604 	while(a--)
_0x17:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x19
;     605 	{
;     606 		CRC += *Position_in_Packet++;
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LD   R30,X+
	STD  Y+3,R26
	STD  Y+3+1,R27
	ADD  R16,R30
;     607 	}
	RJMP _0x17
_0x19:
;     608 
;     609 	if (CRC == *Position_in_Packet)	
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LD   R30,X
	CP   R30,R16
	BRNE _0x1A
;     610 			return TRUE; 										//Ok
	LDI  R30,LOW(1)
	RJMP _0x88
;     611 
;     612 	else	return FALSE;                                      // Error
_0x1A:
	LDI  R30,LOW(0)
;     613 }
_0x88:
	RCALL __LOADLOCR2
	ADIW R28,5
	RET
;     614 
;     615 
;     616 unsigned char TWI_Act_On_Failure_In_Last_Transmission ( unsigned char TWIerrorMsg )
;     617 {
_TWI_Act_On_Failure_In_Last_Transmission:
;     618                     // A failure has occurred, use TWIerrorMsg to determine the nature of the failure
;     619                     // and take appropriate actions.
;     620                     // Se header file for a list of possible failures messages.
;     621   
;     622                     // This very simple example puts the error code on PORTB and restarts the transceiver with
;     623                     // all the same data in the transmission buffers.
;     624 //  PORTB = TWIerrorMsg;
;     625   TWI_Start_Transceiver();
	RCALL _TWI_Start_Transceiver
;     626                     
;     627   return TWIerrorMsg; 
	LD   R30,Y
	RJMP _0x85
;     628 }
;     629 
;     630 
;     631 void run_TWI_slave ( void )
;     632 {
_run_TWI_slave:
;     633   // This example is made to work together with the AVR315 TWI Master application note. In adition to connecting the TWI
;     634   // pins, also connect PORTB to the LEDS. The code reads a message as a TWI slave and acts according to if it is a 
;     635   // general call, or an address call. If it is an address call, then the first byte is considered a command byte and
;     636   // it then responds differently according to the commands.
;     637 
;     638     // Check if the TWI Transceiver has completed an operation.
;     639     if ( ! TWI_Transceiver_Busy() )                              
	RCALL SUBOPT_0xC
	BRNE _0x1C
;     640     {
;     641     // Check if the last operation was successful
;     642       if ( TWI_statusReg.bits.lastTransOK )
	RCALL SUBOPT_0xD
	BREQ _0x1D
;     643       {
;     644     // Check if the last operation was a reception
;     645         if ( TWI_statusReg.bits.RxDataInBuf )
	LDS  R30,_TWI_statusReg
	ANDI R30,LOW(0x2)
	BREQ _0x1E
;     646         {
;     647           TWI_Get_Data_From_Transceiver(rxBufferTWI, 3);         
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xF
	RCALL _TWI_Get_Data_From_Transceiver
;     648     // Check if the last operation was a reception as General Call 
;     649 	// Глобальный адрес пока отдельно не анализирую
;     650           if ( TWI_statusReg.bits.genAddressCall )
	LDS  R30,_TWI_statusReg
	ANDI R30,LOW(0x4)
	BREQ _0x1F
;     651           {
;     652 /*				#ifndef BOOT_PROGRAM
;     653 					if ( Device_Connected )
;     654 							Wait_Responce ( START_Timer );  
;     655 				#endif	*/
;     656           }
;     657 
;     658 		  // Ends up here if the last operation was a reception as Slave Address Match                  
;     659 /*          else
;     660           {*/
;     661 			switch ( TWI_RX_Command )
_0x1F:
	LDS  R30,_rxBufferTWI
;     662 			{
;     663 				case  TWI_CMD_MASTER_WRITE:
	CPI  R30,LOW(0x10)
	BRNE _0x23
;     664 						// дочитываем принятые данные	
;     665 						TWI_Get_Data_From_Transceiver(rxBufferTWI, Long_RX_Packet_TWI+3 );
	RCALL SUBOPT_0xE
	__GETB1MN _rxBufferTWI,2
	SUBI R30,-LOW(3)
	ST   -Y,R30
	RCALL _TWI_Get_Data_From_Transceiver
;     666 						// проверяем КС  
;     667 						if ( checkCRCrx ( &Heading_RX_Packet , from_TWI ) )
	__POINTW1MN _rxBufferTWI,1
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x5
	BREQ _0x24
;     668 								rxPack = 1;	 
	SET
	BLD  R2,1
;     669 #ifdef aaa
;     670     putchar (0xaa);
;     671 #endif    
;     672 						break;
_0x24:
	RJMP _0x22
;     673 
;     674 
;     675 				case  TWI_CMD_MASTER_READ:
_0x23:
	CPI  R30,LOW(0x20)
	BRNE _0x25
;     676                          // новых пакетов нет
;     677 						if ( ! TWI_TX_Packet_Present)
	SBRS R2,2
;     678 						{
;     679 								txBufferTWI[0] = 0;
	RCALL SUBOPT_0x1
;     680 
;     681 						}
;     682 
;     683 #ifdef aaa
;     684     putchar (0xac);
;     685 	txBufferTWI[0] = 0;
;     686 #endif    
;     687 						TWI_Start_Transceiver_With_Data( txBufferTWI, txBufferTWI[0]+1 );           
	RJMP _0x89
;     688 						break;
;     689 
;     690 				case  TWI_CMD_MASTER_RECIVE_PACK_OK:
_0x25:
	CPI  R30,LOW(0x21)
	BRNE _0x28
;     691 						TWI_TX_Packet_Present = 0;			// мастер принял пакет без ошибок
	CLT
	BLD  R2,2
;     692 						txBufferTWI[0] = 0;     					// данных на передачу нет
;     693                         
;     694 						TWI_Start_Transceiver_With_Data( txBufferTWI, txBufferTWI[0]+1 );           
;     695 						break;
;     696 
;     697 
;     698 				default:	
_0x28:
;     699 						txBufferTWI[0] = 0;     	// передаем пустой пакет
_0x8A:
	LDI  R30,LOW(0)
	STS  _txBufferTWI,R30
;     700 
;     701 						TWI_Start_Transceiver_With_Data( txBufferTWI, txBufferTWI[0]+1 );           
_0x89:
	LDI  R30,LOW(_txBufferTWI)
	LDI  R31,HIGH(_txBufferTWI)
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_txBufferTWI
	SUBI R30,-LOW(1)
	ST   -Y,R30
	RCALL _TWI_Start_Transceiver_With_Data
;     702 //			}
;     703           }
_0x22:
;     704         }
;     705 
;     706     // Check if the TWI Transceiver has already been started.
;     707     // If not then restart it to prepare it for new receptions.             
;     708         if ( ! TWI_Transceiver_Busy() )
_0x1E:
	RCALL SUBOPT_0xC
	BRNE _0x29
;     709         {
;     710           TWI_Start_Transceiver();
	RCALL _TWI_Start_Transceiver
;     711         }      
;     712       }
_0x29:
;     713     // Ends up here if the last operation completed unsuccessfully
;     714       else
	RJMP _0x2A
_0x1D:
;     715       {
;     716         TWI_Act_On_Failure_In_Last_Transmission( TWI_Get_State_Info() );
	RCALL _TWI_Get_State_Info
	ST   -Y,R30
	RCALL _TWI_Act_On_Failure_In_Last_Transmission
;     717       }
_0x2A:
;     718     }
;     719   }
_0x1C:
	RET
;     720 /*****************************************************************************
;     721 *
;     722 * Atmel Corporation
;     723 *
;     724 * File              : TWI_Slave.c
;     725 * Compiler          : IAR EWAAVR 2.28a/3.10c
;     726 * Revision          : $Revision: 1.7 $
;     727 * Date              : $Date: Thursday, August 05, 2004 09:22:50 UTC $
;     728 * Updated by        : $Author: lholsen $
;     729 *
;     730 * Support mail      : avr@atmel.com
;     731 *
;     732 * Supported devices : All devices with a TWI module can be used.
;     733 *                     The example is written for the ATmega16
;     734 *
;     735 * AppNote           : AVR311 - TWI Slave Implementation
;     736 *
;     737 * Description       : This is sample driver to AVRs TWI module. 
;     738 *                     It is interupt driveren. All functionality is controlled through 
;     739 *                     passing information to and from functions. Se main.c for samples
;     740 *                     of how to use the driver.
;     741 *
;     742 ****************************************************************************/
;     743 #include "TWI_slave.h"
;     744  
;     745 static unsigned char TWI_buf[TWI_BUFFER_SIZE];     // Transceiver buffer. Set the size in the header file

	.DSEG
_TWI_buf_G3:
	.BYTE 0xFA
;     746 static unsigned char TWI_msgSize  = 0;             // Number of bytes to be transmitted.
_TWI_msgSize_G3:
	.BYTE 0x1
;     747 static unsigned char TWI_state    = TWI_NO_STATE;  // State byte. Default set to TWI_NO_STATE.
_TWI_state_G3:
	.BYTE 0x1
;     748 
;     749 //union TWISR TWI_statusReg = {0};           // TWI_statusReg is defined in TWI_Slave.h
;     750 
;     751 /****************************************************************************
;     752 Call this function to set up the TWI slave to its initial standby state.
;     753 Remember to enable interrupts from the main application after initializing the TWI.
;     754 Pass both the slave address and the requrements for triggering on a general call in the
;     755 same byte. Use e.g. this notation when calling this function:
;     756 TWI_Slave_Initialise( (TWI_slaveAddress<<TWI_ADR_BITS) | (TRUE<<TWI_GEN_BIT) );
;     757 The TWI module is configured to NACK on any requests. Use a TWI_Start_Transceiver function to 
;     758 start the TWI.
;     759 ****************************************************************************/
;     760 void TWI_Slave_Initialise( unsigned char TWI_ownAddress )
;     761 {

	.CSEG
_TWI_Slave_Initialise:
;     762   TWAR = TWI_ownAddress;                            // Set own TWI slave address. Accept TWI General Calls.
	LD   R30,Y
	OUT  0x2,R30
;     763 
;     764   TWDR = 0xFF;                                      // Default content = SDA released.
	LDI  R30,LOW(255)
	OUT  0x3,R30
;     765   TWCR = (1<<TWEN)|                                 // Enable TWI-interface and release TWI pins.
;     766          (0<<TWIE)|(0<<TWINT)|                      // Disable TWI Interupt.
;     767          (0<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|           // Do not ACK on any requests, yet.
;     768          (0<<TWWC);                                 //
	LDI  R30,LOW(4)
	OUT  0x36,R30
;     769 }    
	RJMP _0x85
;     770 
;     771 /****************************************************************************
;     772 Call this function to test if the TWI_ISR is busy transmitting.
;     773 ****************************************************************************/
;     774 unsigned char TWI_Transceiver_Busy( void )
;     775 {
_TWI_Transceiver_Busy:
;     776   return ( TWCR & (1<<TWIE) );                  // IF TWI interrupt is enabled then the Transceiver is busy
	IN   R30,0x36
	ANDI R30,LOW(0x1)
	RET
;     777 }
;     778 
;     779 /****************************************************************************
;     780 Call this function to fetch the state information of the previous operation. The function will hold execution (loop)
;     781 until the TWI_ISR has completed with the previous operation. If there was an error, then the function 
;     782 will return the TWI State code. 
;     783 ****************************************************************************/
;     784 unsigned char TWI_Get_State_Info( void )
;     785 {
_TWI_Get_State_Info:
;     786   while ( TWI_Transceiver_Busy() );             // Wait until TWI has completed the transmission.
_0x2C:
	RCALL SUBOPT_0xC
	BRNE _0x2C
;     787   return ( TWI_state );                         // Return error state. 
	LDS  R30,_TWI_state_G3
	RET
;     788 }
;     789 
;     790 /****************************************************************************
;     791 Call this function to send a prepared message, or start the Transceiver for reception. Include
;     792 a pointer to the data to be sent if a SLA+W is received. The data will be copied to the TWI buffer. 
;     793 Also include how many bytes that should be sent. Note that unlike the similar Master function, the
;     794 Address byte is not included in the message buffers.
;     795 The function will hold execution (loop) until the TWI_ISR has completed with the previous operation,
;     796 then initialize the next operation and return.
;     797 ****************************************************************************/
;     798 void TWI_Start_Transceiver_With_Data( unsigned char *msg, unsigned char msgSize )
;     799 {
_TWI_Start_Transceiver_With_Data:
;     800   unsigned char temp;
;     801 
;     802   while ( TWI_Transceiver_Busy() );             // Wait until TWI is ready for next transmission.
	ST   -Y,R16
;	*msg -> Y+2
;	msgSize -> Y+1
;	temp -> R16
_0x2F:
	RCALL SUBOPT_0xC
	BRNE _0x2F
;     803 
;     804   TWI_msgSize = msgSize;                        // Number of data to transmit.
	LDD  R30,Y+1
	STS  _TWI_msgSize_G3,R30
;     805   for ( temp = 0; temp < msgSize; temp++ )      // Copy data that may be transmitted if the TWI Master requests data.
	LDI  R16,LOW(0)
_0x33:
	RCALL SUBOPT_0x10
	BRSH _0x34
;     806     TWI_buf[ temp ] = msg[ temp ];
	RCALL SUBOPT_0x11
	MOVW R0,R30
	RCALL SUBOPT_0x12
	LD   R30,X
	RCALL SUBOPT_0x13
;     807 
;     808   TWI_statusReg.all = 0;      
	SUBI R16,-1
	RJMP _0x33
_0x34:
	RCALL SUBOPT_0x14
;     809   TWI_state         = TWI_NO_STATE ;
;     810   TWCR = (1<<TWEN)|                             // TWI Interface enabled.
;     811          (1<<TWIE)|(1<<TWINT)|                  // Enable TWI Interupt and clear the flag.
;     812          (1<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|       // Prepare to ACK next time the Slave is addressed.
;     813          (0<<TWWC);                             //
;     814 }
	RJMP _0x87
;     815 
;     816 /****************************************************************************
;     817 Call this function to start the Transceiver without specifing new transmission data. Usefull for restarting
;     818 a transmission, or just starting the transceiver for reception. The driver will reuse the data previously put
;     819 in the transceiver buffers. The function will hold execution (loop) until the TWI_ISR has completed with the 
;     820 previous operation, then initialize the next operation and return.
;     821 ****************************************************************************/
;     822 void TWI_Start_Transceiver( void )
;     823 {
_TWI_Start_Transceiver:
;     824   while ( TWI_Transceiver_Busy() );             // Wait until TWI is ready for next transmission.
_0x35:
	RCALL SUBOPT_0xC
	BRNE _0x35
;     825   TWI_statusReg.all = 0;      
	RCALL SUBOPT_0x14
;     826   TWI_state         = TWI_NO_STATE ;
;     827   TWCR = (1<<TWEN)|                             // TWI Interface enabled.
;     828          (1<<TWIE)|(1<<TWINT)|                  // Enable TWI Interupt and clear the flag.
;     829          (1<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|       // Prepare to ACK next time the Slave is addressed.
;     830          (0<<TWWC);                             //
;     831 }
	RET
;     832 /****************************************************************************
;     833 Call this function to read out the received data from the TWI transceiver buffer. I.e. first call
;     834 TWI_Start_Transceiver to get the TWI Transceiver to fetch data. Then Run this function to collect the
;     835 data when they have arrived. Include a pointer to where to place the data and the number of bytes
;     836 to fetch in the function call. The function will hold execution (loop) until the TWI_ISR has completed 
;     837 with the previous operation, before reading out the data and returning.
;     838 If there was an error in the previous transmission the function will return the TWI State code.
;     839 ****************************************************************************/
;     840 unsigned char TWI_Get_Data_From_Transceiver( unsigned char *msg, unsigned char msgSize )
;     841 {
_TWI_Get_Data_From_Transceiver:
;     842   unsigned char i;
;     843 
;     844   while ( TWI_Transceiver_Busy() );             // Wait until TWI is ready for next transmission.
	ST   -Y,R16
;	*msg -> Y+2
;	msgSize -> Y+1
;	i -> R16
_0x38:
	RCALL SUBOPT_0xC
	BRNE _0x38
;     845 
;     846   if( TWI_statusReg.bits.lastTransOK )               // Last transmission competed successfully.              
	RCALL SUBOPT_0xD
	BREQ _0x3B
;     847   {                                             
;     848     for ( i=0; i<msgSize; i++ )                 // Copy data from Transceiver buffer.
	LDI  R16,LOW(0)
_0x3D:
	RCALL SUBOPT_0x10
	BRSH _0x3E
;     849     {
;     850       msg[ i ] = TWI_buf[ i ];
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x11
	LD   R30,Z
	ST   X,R30
;     851     }
	SUBI R16,-1
	RJMP _0x3D
_0x3E:
;     852     TWI_statusReg.bits.RxDataInBuf = FALSE;          // Slave Receive data has been read from buffer.
	LDS  R30,_TWI_statusReg
	ANDI R30,0xFD
	STS  _TWI_statusReg,R30
;     853   }
;     854   return( TWI_statusReg.bits.lastTransOK );                                   
_0x3B:
	RCALL SUBOPT_0xD
_0x87:
	LDD  R16,Y+0
	ADIW R28,4
	RET
;     855 }
;     856 
;     857 // ********** Interrupt Handlers ********** //
;     858 /****************************************************************************
;     859 This function is the Interrupt Service Routine (ISR), and called when the TWI interrupt is triggered;
;     860 that is whenever a TWI event has occurred. This function should not be called directly from the main
;     861 application.
;     862 ****************************************************************************/
;     863 // 2 Wire bus interrupt service routine
;     864 interrupt [TWI] void TWI_ISR(void)
;     865 {
_TWI_ISR:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;     866   static unsigned char TWI_bufPtr;

	.DSEG

	.CSEG
;     867 
;     868 switch (TWSR)
	IN   R30,0x1
;     869   {
;     870     case TWI_STX_ADR_ACK:            // Own SLA+R has been received; ACK has been returned
	CPI  R30,LOW(0xA8)
	BRNE _0x42
;     871 //    case TWI_STX_ADR_ACK_M_ARB_LOST: // Arbitration lost in SLA+R/W as Master; own SLA+R has been received; ACK has been returned
;     872       TWI_bufPtr   = 0;                                 // Set buffer pointer to first data location
	CLR  R12
;     873 #ifdef aaa
;     874 	PORTD.3=0; 
;     875 #endif    
;     876 
;     877     case TWI_STX_DATA_ACK:           // Data byte in TWDR has been transmitted; ACK has been received
	RJMP _0x43
_0x42:
	CPI  R30,LOW(0xB8)
	BRNE _0x44
_0x43:
;     878       TWDR = TWI_buf[TWI_bufPtr++];
	RCALL SUBOPT_0x15
	LD   R30,Z
	OUT  0x3,R30
;     879       TWCR = (1<<TWEN)|                                 // TWI Interface enabled
;     880              (1<<TWIE)|(1<<TWINT)|                      // Enable TWI Interupt and clear the flag to send byte
;     881              (1<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|           // 
;     882              (0<<TWWC);                                 //  
	LDI  R30,LOW(197)
	RJMP _0x8B
;     883       break;
;     884 
;     885     case TWI_STX_DATA_NACK:          // Data byte in TWDR has been transmitted; NACK has been received. 
_0x44:
	CPI  R30,LOW(0xC0)
	BRNE _0x45
;     886                                      // I.e. this could be the end of the transmission.
;     887       if (TWI_bufPtr == TWI_msgSize) // Have we transceived all expected data?
	LDS  R30,_TWI_msgSize_G3
	CP   R30,R12
	BRNE _0x46
;     888       {
;     889         TWI_statusReg.bits.lastTransOK = TRUE;               // Set status bits to completed successfully. 
	RCALL SUBOPT_0x16
;     890       }else                          // Master has sent a NACK before all data where sent.
	RJMP _0x47
_0x46:
;     891       {
;     892         TWI_state = TWSR;                               // Store TWI State as errormessage.      
	RCALL SUBOPT_0x17
;     893       }        
_0x47:
;     894                                                         // Put TWI Transceiver in passive mode.
;     895       TWCR = (1<<TWEN)|                                 // Enable TWI-interface and release TWI pins
;     896              (0<<TWIE)|(0<<TWINT)|                      // Disable Interupt
;     897              (0<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|           // Do not acknowledge on any new requests.
;     898              (0<<TWWC);                                 //
	RJMP _0x8C
;     899       break;     
;     900 
;     901     case TWI_SRX_GEN_ACK:            // General call address has been received; ACK has been returned
_0x45:
	CPI  R30,LOW(0x70)
	BRNE _0x48
;     902 //    case TWI_SRX_GEN_ACK_M_ARB_LOST: // Arbitration lost in SLA+R/W as Master; General call address has been received; ACK has been returned
;     903       TWI_statusReg.bits.genAddressCall = TRUE;
	LDS  R30,_TWI_statusReg
	ORI  R30,4
	STS  _TWI_statusReg,R30
;     904 
;     905     case TWI_SRX_ADR_ACK:            // Own SLA+W has been received ACK has been returned
	RJMP _0x49
_0x48:
	CPI  R30,LOW(0x60)
	BRNE _0x4A
_0x49:
;     906 //    case TWI_SRX_ADR_ACK_M_ARB_LOST: // Arbitration lost in SLA+R/W as Master; own SLA+W has been received; ACK has been returned    
;     907                                                         // Dont need to clear TWI_S_statusRegister.generalAddressCall due to that it is the default state.
;     908       TWI_statusReg.bits.RxDataInBuf = TRUE;      
	LDS  R30,_TWI_statusReg
	ORI  R30,2
	STS  _TWI_statusReg,R30
;     909       TWI_bufPtr   = 0;                                 // Set buffer pointer to first data location
	CLR  R12
;     910                                                         // Reset the TWI Interupt to wait for a new event.
;     911       TWCR = (1<<TWEN)|                                 // TWI Interface enabled
;     912              (1<<TWIE)|(1<<TWINT)|                      // Enable TWI Interupt and clear the flag to send byte
;     913              (1<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|           // Expect ACK on this transmission
;     914              (0<<TWWC);                                 //      
	LDI  R30,LOW(197)
	RJMP _0x8B
;     915       break;
;     916 
;     917     case TWI_SRX_ADR_DATA_ACK:       // Previously addressed with own SLA+W; data has been received; ACK has been returned
_0x4A:
	CPI  R30,LOW(0x80)
	BREQ _0x4C
;     918     case TWI_SRX_GEN_DATA_ACK:       // Previously addressed with general call; data has been received; ACK has been returned
	CPI  R30,LOW(0x90)
	BRNE _0x4D
_0x4C:
;     919       TWI_buf[TWI_bufPtr++]     = TWDR;
	RCALL SUBOPT_0x15
	MOVW R26,R30
	IN   R30,0x3
	ST   X,R30
;     920       TWI_statusReg.bits.lastTransOK = TRUE;                 // Set flag transmission successfull.       
	RCALL SUBOPT_0x16
;     921                                                         // Reset the TWI Interupt to wait for a new event.
;     922       TWCR = (1<<TWEN)|                                 // TWI Interface enabled
;     923              (1<<TWIE)|(1<<TWINT)|                      // Enable TWI Interupt and clear the flag to send byte
;     924              (1<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|           // Send ACK after next reception
;     925              (0<<TWWC);                                 //  
	LDI  R30,LOW(197)
	RJMP _0x8B
;     926       break;
;     927 
;     928     case TWI_SRX_STOP_RESTART:       // A STOP condition or repeated START condition has been received while still addressed as Slave    
_0x4D:
	CPI  R30,LOW(0xA0)
	BRNE _0x4E
;     929 	                                                       // Put TWI Transceiver in passive mode.
;     930       TWCR = (1<<TWEN)|                                 // Enable TWI-interface and release TWI pins
;     931              (0<<TWIE)|(0<<TWINT)|                      // Disable Interupt
;     932              (0<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|           // Do not acknowledge on any new requests.
;     933              (0<<TWWC);                                 //
	RJMP _0x8C
;     934         #ifdef aaa
;     935 	PORTD.3=1; 
;     936 #endif    
;     937       break;           
;     938 
;     939     case TWI_SRX_ADR_DATA_NACK:      // Previously addressed with own SLA+W; data has been received; NOT ACK has been returned
_0x4E:
	CPI  R30,LOW(0x88)
	BREQ _0x50
;     940     case TWI_SRX_GEN_DATA_NACK:      // Previously addressed with general call; data has been received; NOT ACK has been returned
	CPI  R30,LOW(0x98)
	BRNE _0x51
_0x50:
;     941     case TWI_STX_DATA_ACK_LAST_BYTE: // Last data byte in TWDR has been transmitted (TWEA = “0”); ACK has been received
	RJMP _0x52
_0x51:
	CPI  R30,LOW(0xC8)
	BRNE _0x53
_0x52:
;     942 //    case TWI_NO_STATE              // No relevant state information available; TWINT = “0”
;     943     case TWI_BUS_ERROR:         // Bus error due to an illegal START or STOP condition
	RJMP _0x54
_0x53:
	CPI  R30,0
	BRNE _0x56
_0x54:
;     944 
;     945     default:     
_0x56:
;     946       TWI_state = TWSR;                                 // Store TWI State as errormessage, operation also clears the Success bit.      
	RCALL SUBOPT_0x17
;     947       TWCR = (1<<TWEN)|                                 // Enable TWI-interface and release TWI pins
;     948              (0<<TWIE)|(0<<TWINT)|                      // Disable Interupt
;     949              (0<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|           // Do not acknowledge on any new requests.
;     950              (0<<TWWC);                                 //
_0x8C:
	LDI  R30,LOW(4)
_0x8B:
	OUT  0x36,R30
;     951 
;     952   } 
;     953 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;     954 #include "CDdef.h"  
;     955 /*****************************************************************************
;     956 *
;     957 * Atmel Corporation
;     958 *
;     959 * File              : TWI_Slave.h
;     960 * Compiler          : IAR EWAAVR 2.28a/3.10c
;     961 * Revision          : $Revision: 1.6 $
;     962 * Date              : $Date: Monday, May 24, 2004 09:32:18 UTC $
;     963 * Updated by        : $Author: ltwa $
;     964 *
;     965 * Support mail      : avr@atmel.com
;     966 *
;     967 * Supported devices : All devices with a TWI module can be used.
;     968 *                     The example is written for the ATmega16
;     969 *
;     970 * AppNote           : AVR311 - TWI Slave Implementation
;     971 *
;     972 * Description       : Header file for TWI_slave.c
;     973 *                     Include this file in the application.
;     974 *
;     975 ****************************************************************************/
;     976 #include <mega8.h> 
;     977 
;     978 /****************************************************************************
;     979   TWI Status/Control register definitions
;     980 ****************************************************************************/
;     981 
;     982 #define TWI_BUFFER_SIZE 250      // Reserves memory for the drivers transceiver buffer. 
;     983                                // Set this to the largest message size that will be sent including address byte.
;     984 
;     985 /****************************************************************************
;     986   Global definitions
;     987 ****************************************************************************/
;     988 /****************************************************************************
;     989   Global definitions
;     990 ****************************************************************************/
;     991 	typedef  struct
;     992     {
;     993         unsigned char lastTransOK:1;      
;     994         unsigned char RxDataInBuf:1;
;     995         unsigned char genAddressCall:1;                       // TRUE = General call, FALSE = TWI Address;
;     996         unsigned char unusedBits:5;
;     997     } SB;
;     998   
;     999   	typedef union 				                       // Status byte holding flags.
;    1000 	{
;    1001     	unsigned char all;
;    1002     	SB bits;
;    1003 	}  TWISR;
;    1004 
;    1005 extern  TWISR  TWI_statusReg;        
;    1006 
;    1007 
;    1008 // Для совместимости
;    1009 #define  __no_operation() #asm("nop")
;    1010 #define  __enable_interrupt() #asm("sei")
;    1011 #define  __disable_interrupt() #asm("cli")
;    1012 
;    1013 
;    1014 /****************************************************************************
;    1015   Function definitions
;    1016 ****************************************************************************/
;    1017 void TWI_Slave_Initialise( unsigned char );
;    1018 unsigned char TWI_Transceiver_Busy( void );
;    1019 unsigned char TWI_Get_State_Info( void );
;    1020 void TWI_Start_Transceiver_With_Data( unsigned char * , unsigned char );
;    1021 void TWI_Start_Transceiver( void );
;    1022 unsigned char TWI_Get_Data_From_Transceiver( unsigned char *, unsigned char );    
;    1023 
;    1024 void run_TWI_slave ( void );
;    1025 
;    1026 
;    1027 /****************************************************************************
;    1028   Bit and byte definitions
;    1029 ****************************************************************************/
;    1030 #define TWI_READ_BIT  0   // Bit position for R/W bit in "address byte".
;    1031 #define TWI_ADR_BITS  1   // Bit position for LSB of the slave address bits in the init byte.
;    1032 #define TWI_GEN_BIT   0   // Bit position for LSB of the general call bit in the init byte.
;    1033 
;    1034 #define TRUE          1
;    1035 #define FALSE         0
;    1036 
;    1037 /****************************************************************************
;    1038   TWI State codes
;    1039 ****************************************************************************/
;    1040 // General TWI Master staus codes                      
;    1041 #define TWI_START                  0x08  // START has been transmitted  
;    1042 #define TWI_REP_START              0x10  // Repeated START has been transmitted
;    1043 #define TWI_ARB_LOST               0x38  // Arbitration lost
;    1044 
;    1045 // TWI Master Transmitter staus codes                      
;    1046 #define TWI_MTX_ADR_ACK            0x18  // SLA+W has been tramsmitted and ACK received
;    1047 #define TWI_MTX_ADR_NACK           0x20  // SLA+W has been tramsmitted and NACK received 
;    1048 #define TWI_MTX_DATA_ACK           0x28  // Data byte has been tramsmitted and ACK received
;    1049 #define TWI_MTX_DATA_NACK          0x30  // Data byte has been tramsmitted and NACK received 
;    1050 
;    1051 // TWI Master Receiver staus codes  
;    1052 #define TWI_MRX_ADR_ACK            0x40  // SLA+R has been tramsmitted and ACK received
;    1053 #define TWI_MRX_ADR_NACK           0x48  // SLA+R has been tramsmitted and NACK received
;    1054 #define TWI_MRX_DATA_ACK           0x50  // Data byte has been received and ACK tramsmitted
;    1055 #define TWI_MRX_DATA_NACK          0x58  // Data byte has been received and NACK tramsmitted
;    1056 
;    1057 // TWI Slave Transmitter staus codes
;    1058 #define TWI_STX_ADR_ACK            0xA8  // Own SLA+R has been received; ACK has been returned
;    1059 #define TWI_STX_ADR_ACK_M_ARB_LOST 0xB0  // Arbitration lost in SLA+R/W as Master; own SLA+R has been received; ACK has been returned
;    1060 #define TWI_STX_DATA_ACK           0xB8  // Data byte in TWDR has been transmitted; ACK has been received
;    1061 #define TWI_STX_DATA_NACK          0xC0  // Data byte in TWDR has been transmitted; NOT ACK has been received
;    1062 #define TWI_STX_DATA_ACK_LAST_BYTE 0xC8  // Last data byte in TWDR has been transmitted (TWEA = “0”); ACK has been received
;    1063 
;    1064 // TWI Slave Receiver staus codes
;    1065 #define TWI_SRX_ADR_ACK            0x60  // Own SLA+W has been received ACK has been returned
;    1066 #define TWI_SRX_ADR_ACK_M_ARB_LOST 0x68  // Arbitration lost in SLA+R/W as Master; own SLA+W has been received; ACK has been returned
;    1067 #define TWI_SRX_GEN_ACK            0x70  // General call address has been received; ACK has been returned
;    1068 #define TWI_SRX_GEN_ACK_M_ARB_LOST 0x78  // Arbitration lost in SLA+R/W as Master; General call address has been received; ACK has been returned
;    1069 #define TWI_SRX_ADR_DATA_ACK       0x80  // Previously addressed with own SLA+W; data has been received; ACK has been returned
;    1070 #define TWI_SRX_ADR_DATA_NACK      0x88  // Previously addressed with own SLA+W; data has been received; NOT ACK has been returned
;    1071 #define TWI_SRX_GEN_DATA_ACK       0x90  // Previously addressed with general call; data has been received; ACK has been returned
;    1072 #define TWI_SRX_GEN_DATA_NACK      0x98  // Previously addressed with general call; data has been received; NOT ACK has been returned
;    1073 #define TWI_SRX_STOP_RESTART       0xA0  // A STOP condition or repeated START condition has been received while still addressed as Slave
;    1074 
;    1075 // TWI Miscellaneous status codes
;    1076 #define TWI_NO_STATE               0xF8  // No relevant state information available; TWINT = “0”
;    1077 #define TWI_BUS_ERROR              0x00  // Bus error due to an illegal START or STOP condition
;    1078 
;    1079 // Биты TWCR
;    1080 #define TWINT 7             //Флаг прерывания выполнения задачи
;    1081 #define TWEA  6             //Генерить ли бит ответа на вызов
;    1082 #define TWSTA 5             //Генерить СТАРТ
;    1083 #define TWSTO 4             //Генерить СТОП
;    1084 #define TWWC  3             //
;    1085 #define TWEN  2             //Разрешаем работу I2C
;    1086 #define TWIE  0             //Прерывание
;    1087 
;    1088 
;    1089 
;    1090 flash unsigned char device_name[32] =					// Имя устройства
;    1091 		"Main Program. Mega 8L ";
;    1092 eeprom unsigned long my_ser_num = 1;					// Серийный номер устройства

	.ESEG
_my_ser_num:
	.DW  0x1
	.DW  0x0
;    1093 const flash unsigned short my_version_high = 1;				// Версия софта 

	.CSEG
;    1094 const flash unsigned short my_version_low = 2;				// Версия софта 
;    1095 //eeprom unsigned char my_addr = TO_MON;					// Мой адрес - изначально TO_MON
;    1096 
;    1097 //-----------------------------------------------------------------------------------------------------------------
;    1098 
;    1099 // ----------------------- Обработка прерывания таймера 0 (тайм-аут RS232) --------
;    1100 // Timer 0 overflow interrupt service routine
;    1101 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;    1102 {
_timer0_ovf_isr:
	ST   -Y,R30
;    1103 	TCCR0=0x00;										// Останавливаем таймер
	RCALL SUBOPT_0x6
;    1104 }
	LD   R30,Y+
	RETI
;    1105 //--------------------------------------------------------------------------------------
;    1106 
;    1107 // Посылаем запрос адреса устройства
;    1108  void give_GETINFO (void)
;    1109 {
_give_GETINFO:
;    1110 	// 	запрос  типа устройства
;    1111 			putchar ('q');						// заголовок
	LDI  R30,LOW(113)
	RCALL SUBOPT_0x18
;    1112 			putchar (3);							// число байт после этого
	RCALL _putchar
;    1113 			putchar (255);		 				//  адрес (циркулярный)
	LDI  R30,LOW(255)
	RCALL SUBOPT_0x18
;    1114 			putchar (PT_GETINFO);		// тип пакета
	RCALL _putchar
;    1115 			putchar ((PT_GETINFO)+(255)+3+('q'));
	LDI  R30,LOW(374)
	RCALL SUBOPT_0x19
;    1116 			
;    1117 			CountUART = 0;				// ожидаем ответный пакет  
	CLR  R4
;    1118 
;    1119 }
	RET
;    1120 
;    1121 // ----------------------- Обработка прерывания таймера 1 ( опрос подключения каждые 8 с) --------
;    1122 // Timer 1 overflow interrupt service routine
;    1123 interrupt [TIM1_OVF] void timer1_ovf_isr(void)
;    1124 {
_timer1_ovf_isr:
	RCALL SUBOPT_0x1A
;    1125 		if (! (Device_Connected) )
	SBRC R2,4
	RJMP _0x57
;    1126 		{
;    1127 			lAddr = 0;						// ничего не подключено             
	CLR  R10
;    1128 			_GetLogAddr ();				// cообщаем свой логический адрес
	RCALL __GetLogAddr
;    1129 		}
;    1130 
;    1131 		Device_Connected = 0;						// пора проверить устройство присутствует ли ?           
_0x57:
	CLT
	BLD  R2,4
;    1132 
;    1133 		give_GETINFO();		// отправляем посылку запроса
	RCALL _give_GETINFO
;    1134 #ifdef aaa
;    1135     putchar (0xac);
;    1136 	putchar (TWDR);
;    1137 	putchar (TWSR);
;    1138 #endif    
;    1139 
;    1140 }
	RCALL SUBOPT_0x1B
	RETI
;    1141 
;    1142 // отправляем ответ на GEN CALL
;    1143 void	Responce_OK (u8 Status)
;    1144 {    
_Responce_OK:
;    1145 
;    1146 		Long_TX_Packet_TWI = 2;				 		// длина пакета
	LDI  R30,LOW(2)
	__PUTB1MN _txBufferTWI,2
;    1147 
;    1148 				Command_TX_Packet_TWI = Responce_GEN_CALL_internal;	
	LDI  R30,LOW(4)
	__PUTB1MN _txBufferTWI,3
;    1149 
;    1150 	// ответ не пришел
;    1151 	if ( Status == FALSE )
	RCALL SUBOPT_0x1C
	BRNE _0x58
;    1152 	{
;    1153 		Packet_Lost ++;								// потеряли пакет
	INC  R9
;    1154 		txBufferTWI[Start_Position_for_Reply+2] = FALSE;		  				// содержимое
	LDI  R30,LOW(0)
	__PUTB1MN _txBufferTWI,4
;    1155 	}
;    1156 	// ответ пришел
;    1157 	else
	RJMP _0x59
_0x58:
;    1158 		txBufferTWI[Start_Position_for_Reply+2] = rxBufferUART[1];		// содержимое
	__GETB1MN _rxBufferUART,1
	__PUTB1MN _txBufferTWI,4
;    1159 
;    1160 		packPacket (Internal_Packet);	// даем тип ВНУТРЕННИЙ
_0x59:
	RCALL SUBOPT_0x2
	RCALL _packPacket
;    1161 }
	RJMP _0x85
;    1162 
;    1163 // Ждем ответа при глоб. адресации. Работает с таймером 2.
;    1164 void Wait_Responce ( unsigned char Status )
;    1165 {
_Wait_Responce:
;    1166 			Count_For_Timer2 = 0;                                  
	CLR  R8
;    1167 
;    1168 			TCNT2=0x00;			
	RCALL SUBOPT_0x7
;    1169 			if ( Status == START_Timer )
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x5A
;    1170 			{
;    1171 			 	Responce_Time_Out = 0;								
	CLT
	BLD  R2,7
;    1172 			 	TCCR2=0x07;       // пуск
	LDI  R30,LOW(7)
	RJMP _0x8D
;    1173 			}
;    1174 			else 		
_0x5A:
;    1175 				TCCR2=0x00;       // стоп
	LDI  R30,LOW(0)
_0x8D:
	OUT  0x25,R30
;    1176 
;    1177 }
	RJMP _0x85
;    1178 // ----------------------- Обработка прерывания таймера 2 ------------------------
;    1179 // Ждем подтверждение передачи пакета кодирования ( ожидание ответа устройства - 200мс)
;    1180 // Timer 2 overflow interrupt service routine
;    1181 interrupt [TIM2_OVF] void timer2_ovf_isr(void)
;    1182 {
_timer2_ovf_isr:
	RCALL SUBOPT_0x1A
;    1183 		Count_For_Timer2 ++;
	INC  R8
;    1184 
;    1185 		if (Count_For_Timer2 > 4 )
	LDI  R30,LOW(4)
	CP   R30,R8
	BRSH _0x5C
;    1186 		{
;    1187 			Responce_Time_Out = 1;				// время ожидания ответного пакета истекло
	SET
	BLD  R2,7
;    1188 			Wait_Responce ( STOP_Timer );				// стоп
	RCALL SUBOPT_0x2
	RCALL _Wait_Responce
;    1189 		}                                   
;    1190 }
_0x5C:
	RCALL SUBOPT_0x1B
	RETI
;    1191 
;    1192 
;    1193 //-----------------------------------------------------------------------------------------------------------------
;    1194 // Реакция на команду перейти в рабочий режим
;    1195 void ToWorkMode(void)
;    1196 {
_ToWorkMode:
;    1197 	// Отправляю ответ
;    1198 	Long_TX_Packet_TWI = 1;        						// подтверждаю прием
	LDI  R30,LOW(1)
	__PUTB1MN _txBufferTWI,2
;    1199 	txBufferTWI[Start_Position_for_Reply+1] = 1;        						// подтверждаю прием
	__PUTB1MN _txBufferTWI,3
;    1200 
;    1201 	packPacket (External_Packet);	// даем тип ВНЕШНИЙ
	RCALL SUBOPT_0x4
	RCALL _packPacket
;    1202 }
	RET
;    1203 // Назначение серийного номера устройства
;    1204 static void SetSerial(void)
;    1205 {
_SetSerial_G4:
;    1206 		Long_TX_Packet_TWI = 2;  			//длина
	LDI  R30,LOW(2)
	__PUTB1MN _txBufferTWI,2
;    1207 		txBufferTWI[Start_Position_for_Reply+1] = (RES_OK);		
	LDI  R30,LOW(1)
	__PUTB1MN _txBufferTWI,3
;    1208 		txBufferTWI[Start_Position_for_Reply+2] = 2+(RES_OK);          // КС
	LDI  R30,LOW(3)
	__PUTB1MN _txBufferTWI,4
;    1209 
;    1210 		packPacket (External_Packet);	// даем тип ВНЕШНИЙ
	RCALL SUBOPT_0x4
	RCALL _packPacket
;    1211 }
	RET
;    1212 
;    1213 //  Назначение адреса устройства
;    1214 void Setaddr (void)
;    1215 	{
_Setaddr:
;    1216 			Long_TX_Packet_TWI = 2;  			//длина
	LDI  R30,LOW(2)
	__PUTB1MN _txBufferTWI,2
;    1217 			txBufferTWI[Start_Position_for_Reply+1] = 0;		
	LDI  R30,LOW(0)
	__PUTB1MN _txBufferTWI,3
;    1218 			txBufferTWI[Start_Position_for_Reply+2] = 2;          // КС
	LDI  R30,LOW(2)
	__PUTB1MN _txBufferTWI,4
;    1219 
;    1220 			packPacket (External_Packet);	// даем тип ВНЕШНИЙ
	RCALL SUBOPT_0x4
	RCALL _packPacket
;    1221 	}
	RET
;    1222 
;    1223 // Перезагрузка в режим программирования
;    1224 static void ToProg(void)
;    1225 {
_ToProg_G4:
;    1226 			// Отправляю ответ
;    1227 			Long_TX_Packet_TWI = 1;  			//длина
	LDI  R30,LOW(1)
	__PUTB1MN _txBufferTWI,2
;    1228 			txBufferTWI[Start_Position_for_Reply+1] = 1;          // КС
	__PUTB1MN _txBufferTWI,3
;    1229 		
;    1230 			packPacket (External_Packet);	// даем тип ВНЕШНИЙ
	RCALL SUBOPT_0x4
	RCALL _packPacket
;    1231 			to_Reboot = 1;			//  на перезагрузку в загрузчик
	SET
	BLD  R2,6
;    1232 }		
	RET
;    1233 
;    1234 
;    1235 // Возвращаю состояние устройства
;    1236 const char _PT_GETSTATE_[]={67,2,0,"Connected Dev.",100,"RelayTWI->UART",100,
;    1237 														"RelayUART->TWI",100,"Packet LOST   ",100,255};
;    1238 
;    1239 static void GetState(void)
;    1240 {
_GetState_G4:
;    1241 	register unsigned char a=Start_Position_for_Reply;
;    1242 
;    1243 	switch (PT_GETSTATE_page)
	ST   -Y,R16
;	a -> R16
	LDI  R16,2
	__GETB1MN _rxBufferTWI,5
;    1244 	{
;    1245 		case 0:
	CPI  R30,0
	BRNE _0x60
;    1246 			memcpyf(&txBufferTWI[Start_Position_for_Reply], _PT_GETSTATE_, _PT_GETSTATE_[0]+1); // 0 пакет
	__POINTW1MN _txBufferTWI,2
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1D
	LPM  R30,Z
	RCALL SUBOPT_0x1E
	RCALL _memcpyf
;    1247 			break;
	RJMP _0x5F
;    1248 
;    1249 		case 1:			
_0x60:
	CPI  R30,LOW(0x1)
	BRNE _0x62
;    1250 			txBufferTWI[a++] = 14;				 			// длина пакета
	MOV  R30,R16
	SUBI R16,-1
	RCALL SUBOPT_0x9
	MOVW R26,R30
	LDI  R30,LOW(14)
	RCALL SUBOPT_0x1F
;    1251 
;    1252 			txBufferTWI[a++] = 0;							// № микросхемы
	SUBI R16,-1
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x1F
;    1253 			txBufferTWI[a++] = TWI_slaveAddress;
	SUBI R16,-1
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x21
;    1254 			txBufferTWI[a++] = lAddr;
	SUBI R16,-1
	RCALL SUBOPT_0x9
	ST   Z,R10
;    1255 
;    1256 			txBufferTWI[a++] = 1;							// № микросхемы
	MOV  R30,R16
	SUBI R16,-1
	RCALL SUBOPT_0x9
	MOVW R26,R30
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x1F
;    1257 			txBufferTWI[a++] = TWI_slaveAddress;
	SUBI R16,-1
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x21
;    1258 			txBufferTWI[a++] =  Relay_Pack_TWI_UART;
	SUBI R16,-1
	RCALL SUBOPT_0x9
	ST   Z,R6
;    1259 
;    1260 			txBufferTWI[a++] = 2;							// № микросхемы
	MOV  R30,R16
	SUBI R16,-1
	RCALL SUBOPT_0x9
	MOVW R26,R30
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x1F
;    1261 			txBufferTWI[a++] = TWI_slaveAddress;
	SUBI R16,-1
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x21
;    1262 			txBufferTWI[a++] =  Relay_Pack_UART_TWI;
	SUBI R16,-1
	RCALL SUBOPT_0x9
	ST   Z,R7
;    1263 
;    1264 			txBufferTWI[a++] = 3;							// № микросхемы
	MOV  R30,R16
	SUBI R16,-1
	RCALL SUBOPT_0x9
	MOVW R26,R30
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x1F
;    1265 			txBufferTWI[a++] = TWI_slaveAddress;
	SUBI R16,-1
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x21
;    1266 			txBufferTWI[a++] =  Packet_Lost;
	SUBI R16,-1
	RCALL SUBOPT_0x9
	ST   Z,R9
;    1267 
;    1268 			txBufferTWI[a++] = 255;
	MOV  R30,R16
	SUBI R16,-1
	RCALL SUBOPT_0x9
	MOVW R26,R30
	LDI  R30,LOW(255)
	RJMP _0x8E
;    1269 			break;
;    1270 
;    1271 		default:
_0x62:
;    1272 			txBufferTWI[a++] = 0;				 			// длина пакета
	MOV  R30,R16
	SUBI R16,-1
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x20
_0x8E:
	ST   X,R30
;    1273 			break;
;    1274 	} 
_0x5F:
;    1275 
;    1276 	//KC
;    1277 	txBufferTWI[txBufferTWI[Start_Position_for_Reply]+2] = calc_CRC( &txBufferTWI[Start_Position_for_Reply] );
	__GETB1MN _txBufferTWI,2
	LDI  R31,0
	__ADDW1MN _txBufferTWI,2
	PUSH R31
	PUSH R30
	__POINTW1MN _txBufferTWI,2
	RCALL SUBOPT_0xA
	POP  R26
	POP  R27
	RCALL SUBOPT_0x22
;    1278 
;    1279 	packPacket (External_Packet);	// даем тип ВНЕШНИЙ
	RCALL _packPacket
;    1280 } 
	RJMP _0x86
;    1281 
;    1282 // Информация об устройстве:
;    1283 
;    1284 static void GetInfo(void)
;    1285 {
_GetInfo_G4:
;    1286 		register unsigned char i,a=Start_Position_for_Reply;                    
;    1287 	
;    1288 		// 	заполняю буфер
;    1289 		txBufferTWI[a++] = 40+1;
	RCALL __SAVELOCR2
;	i -> R16
;	a -> R17
	LDI  R17,2
	MOV  R30,R17
	SUBI R17,-1
	RCALL SUBOPT_0x9
	MOVW R26,R30
	LDI  R30,LOW(41)
	ST   X,R30
;    1290 	
;    1291 		for ( i = 0; i <32; i ++ )	
	LDI  R16,LOW(0)
_0x64:
	CPI  R16,32
	BRSH _0x65
;    1292 				txBufferTWI[a++] = device_name[i];	// Имя устройства
	MOV  R30,R17
	SUBI R17,-1
	RCALL SUBOPT_0x9
	MOVW R26,R30
	RCALL SUBOPT_0x23
	SUBI R30,LOW(-_device_name*2)
	SBCI R31,HIGH(-_device_name*2)
	LPM  R30,Z
	ST   X,R30
;    1293 
;    1294 		txBufferTWI[a++] = my_ser_num;         	 	// Серийный номер
	SUBI R16,-1
	RJMP _0x64
_0x65:
	MOV  R30,R17
	SUBI R17,-1
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x13
;    1295 		txBufferTWI[a++] = my_ser_num>>8;    	  	// Серийный номер
	MOV  R30,R17
	SUBI R17,-1
	RCALL SUBOPT_0x24
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x26
	LDI  R30,LOW(8)
	RCALL __LSRD12
	POP  R26
	POP  R27
	RCALL SUBOPT_0x27
;    1296 
;    1297 		txBufferTWI[a++] = my_ser_num>>16;		// Серийный номер
	SUBI R17,-1
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x25
	RCALL __LSRD16
	RCALL SUBOPT_0x13
;    1298 		txBufferTWI[a++] = my_ser_num>>24;		// Серийный номер
	MOV  R30,R17
	SUBI R17,-1
	RCALL SUBOPT_0x24
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x26
	LDI  R30,LOW(24)
	RCALL __LSRD12
	POP  R26
	POP  R27
	RCALL SUBOPT_0x27
;    1299 	
;    1300 		txBufferTWI[a++] =TWI_slaveAddress ;    	// Адрес устройства
	SUBI R17,-1
	RCALL SUBOPT_0x9
	ST   Z,R11
;    1301         txBufferTWI[a++] =0;     							// Зарезервированный байт
	MOV  R30,R17
	SUBI R17,-1
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x27
;    1302 	
;    1303 		txBufferTWI[a++] = my_version_high;			// Версия софта
	SUBI R17,-1
	RCALL SUBOPT_0x9
	MOVW R26,R30
	LDI  R30,LOW(_my_version_high*2)
	LDI  R31,HIGH(_my_version_high*2)
	RCALL __GETW1PF
	RCALL SUBOPT_0x27
;    1304 		txBufferTWI[a++] = my_version_low;			// Версия  софта
	SUBI R17,-1
	RCALL SUBOPT_0x9
	MOVW R26,R30
	LDI  R30,LOW(_my_version_low*2)
	LDI  R31,HIGH(_my_version_low*2)
	RCALL __GETW1PF
	ST   X,R30
;    1305 		
;    1306 		//KC
;    1307 		txBufferTWI[txBufferTWI[Start_Position_for_Reply]+2] = calc_CRC( &txBufferTWI[Start_Position_for_Reply] );
	__GETB1MN _txBufferTWI,2
	LDI  R31,0
	__ADDW1MN _txBufferTWI,2
	PUSH R31
	PUSH R30
	__POINTW1MN _txBufferTWI,2
	RCALL SUBOPT_0xA
	POP  R26
	POP  R27
	RCALL SUBOPT_0x22
;    1308 		packPacket (External_Packet);					// даем тип ВНЕШНИЙ
	RCALL _packPacket
;    1309 }
	RCALL __LOADLOCR2P
	RET
;    1310 
;    1311 
;    1312 // Отвечаем. Заполняем буфер на передачу
;    1313 void _GetLogAddr (void)
;    1314 {
__GetLogAddr:
;    1315 
;    1316 		Long_TX_Packet_TWI = 2;				 					// длина пакета
	LDI  R30,LOW(2)
	__PUTB1MN _txBufferTWI,2
;    1317 		txBufferTWI[Start_Position_for_Reply+1] = GetLogAddr;		 				// тип пакета
	LDI  R30,LOW(1)
	__PUTB1MN _txBufferTWI,3
;    1318 		txBufferTWI[Start_Position_for_Reply+2] = lAddr;		  						// содержимое
	__PUTBMRN _txBufferTWI,4,10
;    1319 
;    1320 		packPacket (Internal_Packet);					// даем тип ВНУТРЕННИЙ
	RCALL SUBOPT_0x2
	RCALL _packPacket
;    1321 }  
	RET
;    1322 	
;    1323 // ретрансляция из TWI в UART
;    1324 void relayTWI_to_UART (void)
;    1325 {       
_relayTWI_to_UART:
;    1326 		u8 a;
;    1327 		
;    1328 		if ( Device_Connected )
	ST   -Y,R16
;	a -> R16
	SBRS R2,4
	RJMP _0x66
;    1329 		{
;    1330 			Wait_Responce ( START_Timer );  
	RCALL SUBOPT_0x4
	RCALL _Wait_Responce
;    1331 
;    1332 			for ( a = 1;a<= Long_RX_Packet_TWI+2; a++ )	
	LDI  R16,LOW(1)
_0x68:
	__GETB1MN _rxBufferTWI,2
	SUBI R30,-LOW(2)
	CP   R30,R16
	BRLO _0x69
;    1333 					putchar ( rxBufferTWI[a] ); 
	RCALL SUBOPT_0x23
	SUBI R30,LOW(-_rxBufferTWI)
	SBCI R31,HIGH(-_rxBufferTWI)
	LD   R30,Z
	RCALL SUBOPT_0x19
;    1334 
;    1335 			Relay_Pack_TWI_UART++;			//счетчик статистики
	SUBI R16,-1
	RJMP _0x68
_0x69:
	INC  R6
;    1336 			LedOn ();										// отправили пакет	
	CBI  0x12,3
;    1337 			gate_UART_to_TWI_open = TRUE;	// открываем обратную ретрансляцию		
	SET
	BLD  R2,0
;    1338 		}
;    1339 
;    1340 }
_0x66:
_0x86:
	LD   R16,Y+
	RET
;    1341 
;    1342 // Включаем-выключаем UART
;    1343 void    port_state (u8 state)
;    1344 {
_port_state:
;    1345 	if (state == FALSE) 
	RCALL SUBOPT_0x1C
	BRNE _0x6A
;    1346 	{     
;    1347 		UCSRB=0x0;					
	LDI  R30,LOW(0)
	OUT  0xA,R30
;    1348 		UCSRC=0x0;
	OUT  0x20,R30
;    1349 		UBRRL=0x0;
	RJMP _0x8F
;    1350 	}
;    1351 	else
_0x6A:
;    1352 	{
;    1353 		UCSRB=0x98;				
	RCALL SUBOPT_0x8
;    1354 		UCSRC=0x86;
;    1355 		UBRRL=0x0C;
_0x8F:
	OUT  0x9,R30
;    1356 	}
;    1357 }
_0x85:
	ADIW R28,1
	RET
;    1358 
;    1359 
;    1360 // Обрабатываем принятый пакет TWI
;    1361 void workINpack ( void )
;    1362 		{
_workINpack:
;    1363 
;    1364 		// Обработка внутренних пакетов
;    1365 		if ( Recived_Address == Internal_Packet )		
	__GETB1MN _rxBufferTWI,3
	CPI  R30,0
	BRNE _0x6C
;    1366 		{
;    1367 				#ifdef DEBUG
;    1368 				putchar2 (0x04);
;    1369 				#endif
;    1370 			switch ( Type_RX_Packet_TWI )
	__GETB1MN _rxBufferTWI,4
;    1371 			{
;    1372 				case PT_GETINFO:			// возвращаем о себе информацию
	CPI  R30,LOW(0x3)
	BRNE _0x70
;    1373 						GetInfo();
	RCALL _GetInfo_G4
;    1374 						break;                                     
	RJMP _0x6F
;    1375 						
;    1376 				case PT_GETSTATE:				// возвращаем состояние
_0x70:
	CPI  R30,LOW(0x1)
	BRNE _0x71
;    1377 						GetState();
	RCALL _GetState_G4
;    1378 						break;
	RJMP _0x6F
;    1379 
;    1380 		 		case PT_TOPROG:       			// переходим в программирование
_0x71:
	CPI  R30,LOW(0x7)
	BRNE _0x72
;    1381 						ToProg();
	RCALL _ToProg_G4
;    1382 						break;      
	RJMP _0x6F
;    1383 
;    1384 		 		case PT_PORT_UNLOCK:      // разрешаем UART
_0x72:
	CPI  R30,LOW(0xAE)
	BRNE _0x73
;    1385 						port_state(TRUE);
	RCALL SUBOPT_0x4
	RCALL _port_state
;    1386 						break;
	RJMP _0x6F
;    1387 
;    1388 		 		case PT_SCRDATA:       		// пакет внутреннего скремблера
_0x73:
	CPI  R30,LOW(0xA1)
	BRNE _0x75
;    1389 						Recived_Address = 255;			//меняем адрес и КС
	LDI  R30,LOW(255)
	__PUTB1MN _rxBufferTWI,3
;    1390 						CRC_RX_Packet_TWI = calc_CRC( &Long_RX_Packet_TWI )+Heading_RX_Packet;
	__GETB1MN _rxBufferTWI,2
	LDI  R31,0
	__ADDW1MN _rxBufferTWI,2
	PUSH R31
	PUSH R30
	__POINTW1MN _rxBufferTWI,2
	RCALL SUBOPT_0xA
	MOV  R26,R30
	__GETB1MN _rxBufferTWI,1
	ADD  R30,R26
	POP  R26
	POP  R27
	RCALL SUBOPT_0xB
;    1391 
;    1392 						InternalPack = TRUE;
	BLD  R2,5
;    1393 						relayTWI_to_UART ();
	RCALL _relayTWI_to_UART
;    1394 						break;
;    1395 
;    1396 				default:
_0x75:
;    1397 						break;
;    1398 
;    1399 			}
_0x6F:
;    1400          }
;    1401 	    else	if( Recived_Address == TO_MON)					// обрабатываем пакет по адресу MONITOR
	RJMP _0x76
_0x6C:
	__GETB1MN _rxBufferTWI,3
	CPI  R30,LOW(0xFE)
	BRNE _0x77
;    1402 		{
;    1403 			switch ( Type_RX_Packet_TWI )
	__GETB1MN _rxBufferTWI,4
;    1404 			{
;    1405 		 		case PT_SETADDR:       			// переходим в программирование
	CPI  R30,LOW(0x4)
	BRNE _0x7B
;    1406 						Setaddr();
	RCALL _Setaddr
;    1407 						break;      
	RJMP _0x7A
;    1408 
;    1409 		 		case PT_SETSERIAL:       			// переходим в программирование
_0x7B:
	CPI  R30,LOW(0x5)
	BRNE _0x7C
;    1410 						SetSerial();
	RCALL _SetSerial_G4
;    1411 						break; 
	RJMP _0x7A
;    1412 
;    1413 		 		case PT_TOWORK:       			// переходим в программирование
_0x7C:
	CPI  R30,LOW(0xB)
	BRNE _0x7E
;    1414 						ToWorkMode();
	RCALL _ToWorkMode
;    1415 						break;
;    1416 
;    1417 
;    1418 				default: 
_0x7E:
;    1419 						break;
;    1420 									     
;    1421 			}                                                                               
_0x7A:
;    1422 		}
;    1423 		// иначе ретранслируем
;    1424 		// только при подключенном устройстве и разблок. порт
;    1425 		else
	RJMP _0x7F
_0x77:
;    1426 		{ 													
;    1427 				relayTWI_to_UART ();
	RCALL _relayTWI_to_UART
;    1428 		}
_0x7F:
_0x76:
;    1429 }	
	RET
;    1430 
;    1431 // Обработка пакета, принятого по UART        
;    1432 // Принятый пакет упаковывается во внешний:
;    1433 //    ДЛИНА_ТИП_ПРИНЯТЫЙ ПАКЕТ_КС(включая ДЛИНА)
;    1434 
;    1435 void workUARTpack (void)
;    1436 {
_workUARTpack:
;    1437 	if (! Device_Connected ) 						// получен первый пакет           
	SBRC R2,4
	RJMP _0x80
;    1438 	{
;    1439 		lAddr = rxBufferUART [37];			// вынимаем адрес из принятого пакта             
	__GETBRMN 10,_rxBufferUART,37
;    1440 		_GetLogAddr ();							// cообщаем свой логический адрес
	RCALL __GetLogAddr
;    1441 		Device_Connected = 1;				// Устройство ответило 
	SET
	BLD  R2,4
;    1442 		LedOff();									// тушим индикатор проблем
	SBI  0x12,3
;    1443 
;    1444 	}
;    1445 	else
	RJMP _0x81
_0x80:
;    1446 	{
;    1447 			#ifdef DEBUG
;    1448 			putchar2 (0x01);
;    1449 			#endif
;    1450 
;    1451 		if (gate_UART_to_TWI_open == TRUE)
	SBRS R2,0
	RJMP _0x82
;    1452 		{
;    1453 			Wait_Responce ( STOP_Timer );  	// останавливаем таймер
	RCALL SUBOPT_0x2
	RCALL _Wait_Responce
;    1454 
;    1455 			if (InternalPack == TRUE)
	SBRS R2,5
	RJMP _0x83
;    1456 			{
;    1457 				#ifdef DEBUG
;    1458 				putchar2 (0x02);
;    1459 				#endif
;    1460 				Responce_OK ( TRUE );					// отправляем ответ
	RCALL SUBOPT_0x4
	RCALL _Responce_OK
;    1461 			}				
;    1462 			else
	RJMP _0x84
_0x83:
;    1463 			{
;    1464 				#ifdef DEBUG
;    1465 				putchar2 (0x03);
;    1466 				#endif
;    1467 					memcpy(&txBufferTWI[Start_Position_for_Reply], rxBufferUART, rxBufferUART[0]+1); 	// пакет принятый
	__POINTW1MN _txBufferTWI,2
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x3
	LDS  R30,_rxBufferUART
	RCALL SUBOPT_0x1E
	RCALL _memcpy
;    1468 					packPacket (External_Packet);		// даем тип ВНЕШНИЙ
	RCALL SUBOPT_0x4
	RCALL _packPacket
;    1469 			}
_0x84:
;    1470 
;    1471 			InternalPack = FALSE;
	CLT
	BLD  R2,5
;    1472 			Relay_Pack_UART_TWI++;			//счетчик статистики						
	INC  R7
;    1473 		}
;    1474 	}
_0x82:
_0x81:
;    1475 }	
	RET
;    1476 	
;    1477 
;    1478 	//--------------------------------------------------------------------------------------------
;    1479 // "программный" UART
;    1480 #ifdef DEBUG
;    1481 void dtxdl(void)
;    1482 {
;    1483 	int i;
;    1484 	for (i = 0; i < 17; i ++)
;    1485 	{
;    1486 		#asm("nop")
;    1487 	}
;    1488 }
;    1489 
;    1490 void putchar2(char c)
;    1491 {
;    1492 	register unsigned char b;
;    1493 	
;    1494 	#asm("cli")
;    1495 	
;    1496 	DTXDDR = 1;
;    1497 //	DRXDDR = 0;
;    1498 	DTXPIN = 0;
;    1499 	dtxdl();
;    1500 	
;    1501 	for (b = 0; b < 8; b ++)
;    1502 	{
;    1503 		if (c & 1)
;    1504 		{
;    1505 			DTXPIN = 1;
;    1506 		}
;    1507 		else
;    1508 		{
;    1509 			DTXPIN = 0;
;    1510 		}
;    1511              
;    1512 		c >>= 1;
;    1513 		dtxdl();
;    1514 	}
;    1515 
;    1516 	DTXPIN = 1;
;    1517 	dtxdl();
;    1518 	dtxdl();
;    1519 	
;    1520 	#asm("sei")
;    1521 }
;    1522 #endif DEBUG
;    1523 	

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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x0:
	MOV  R30,R5
	INC  R5
	LDI  R31,0
	SUBI R30,LOW(-_rxBufferUART)
	SBCI R31,HIGH(-_rxBufferUART)
	ST   Z,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1:
	LDI  R30,LOW(0)
	STS  _txBufferTWI,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES
SUBOPT_0x2:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3:
	LDI  R30,LOW(_rxBufferUART)
	LDI  R31,HIGH(_rxBufferUART)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES
SUBOPT_0x4:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5:
	RCALL _checkCRCrx
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6:
	LDI  R30,LOW(0)
	OUT  0x33,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x7:
	LDI  R30,LOW(0)
	OUT  0x24,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x8:
	LDI  R30,LOW(152)
	OUT  0xA,R30
	LDI  R30,LOW(134)
	OUT  0x20,R30
	LDI  R30,LOW(12)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES
SUBOPT_0x9:
	LDI  R31,0
	SUBI R30,LOW(-_txBufferTWI)
	SBCI R31,HIGH(-_txBufferTWI)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0xA:
	ST   -Y,R31
	ST   -Y,R30
	RJMP _calc_CRC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xB:
	ST   X,R30
	SET
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0xC:
	RCALL _TWI_Transceiver_Busy
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xD:
	LDS  R30,_TWI_statusReg
	ANDI R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xE:
	LDI  R30,LOW(_rxBufferTWI)
	LDI  R31,HIGH(_rxBufferTWI)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xF:
	LDI  R30,LOW(3)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x10:
	LDD  R30,Y+1
	CP   R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x11:
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_TWI_buf_G3)
	SBCI R31,HIGH(-_TWI_buf_G3)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x12:
	MOV  R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x13:
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x14:
	LDI  R30,LOW(0)
	STS  _TWI_statusReg,R30
	LDI  R30,LOW(248)
	STS  _TWI_state_G3,R30
	LDI  R30,LOW(197)
	OUT  0x36,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x15:
	MOV  R30,R12
	INC  R12
	LDI  R31,0
	SUBI R30,LOW(-_TWI_buf_G3)
	SBCI R31,HIGH(-_TWI_buf_G3)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x16:
	LDS  R30,_TWI_statusReg
	ORI  R30,1
	STS  _TWI_statusReg,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x17:
	IN   R30,0x1
	STS  _TWI_state_G3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x18:
	ST   -Y,R30
	RCALL _putchar
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x19:
	ST   -Y,R30
	RJMP _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1A:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1B:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1C:
	LD   R30,Y
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1D:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(__PT_GETSTATE_*2)
	LDI  R31,HIGH(__PT_GETSTATE_*2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1E:
	SUBI R30,-LOW(1)
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x1F:
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x20:
	MOVW R26,R30
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x21:
	ST   Z,R11
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x22:
	ST   X,R30
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x23:
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x24:
	LDI  R26,LOW(_txBufferTWI)
	LDI  R27,HIGH(_txBufferTWI)
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x25:
	MOVW R0,R30
	LDI  R26,LOW(_my_ser_num)
	LDI  R27,HIGH(_my_ser_num)
	RCALL __EEPROMRDD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x26:
	LDI  R26,LOW(_my_ser_num)
	LDI  R27,HIGH(_my_ser_num)
	RCALL __EEPROMRDD
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x27:
	ST   X,R30
	MOV  R30,R17
	RET

_memcpy:
	ldd  r25,y+1
	ld   r24,y
	adiw r24,0
	breq __memcpy1
	ldd  r27,y+5
	ldd  r26,y+4
	ldd  r31,y+3
	ldd  r30,y+2
__memcpy0:
	ld   r22,z+
	st   x+,r22
	sbiw r24,1
	brne __memcpy0
__memcpy1:
	ldd  r31,y+5
	ldd  r30,y+4
	adiw r28,6
	ret

_memcpyf:
	ldd  r25,y+1
	ld   r24,y
	adiw r24,0
	breq __memcpyf1
	ldd  r27,y+5
	ldd  r26,y+4
	ldd  r31,y+3
	ldd  r30,y+2
__memcpyf0:
	lpm  r0,z+
	st   x+,r0
	sbiw r24,1
	brne __memcpyf0
__memcpyf1:
	ldd  r31,y+5
	ldd  r30,y+4
	adiw r28,6
	ret

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

__LSRD16:
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
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

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
