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
;      25 #include <mega8.h> 
;      26 #include "string.h"  
;      27 
;      28 
;      29 // Standard Input/Output functions
;      30 #include <stdio.h>
;      31 #include <delay.h>
;      32 #include <CDdef.h>					// мой описатель
;      33 
;      34 //unsigned char Count1	=	0,  Count	=	0, lPack = 0;	
;      35 unsigned char rxBuffer[256];							// приемный буффер
_rxBuffer:
	.BYTE 0x100
;      36 unsigned char txBuffer[256];								// передающий буффер
_txBuffer:
	.BYTE 0x100
;      37 
;      38 unsigned char Count1	=	0,  Count	=	0, CRCPackRX = 0;	
;      39 unsigned char Count2	=	0,  Count3 =	0; 
;      40 unsigned char CountUART = 0, CountUART_1 = 0;      
;      41 
;      42 
;      43 
;      44 
;      45 /*
;      46 // Жду флажка
;      47 static void twi_wait_int (void)
;      48 {
;      49 	while (!(TWCR & (1<<TWINT))); 
;      50 }
;      51   
;      52 */
;      53 	// Флаги состояния
;      54 bit 		ping		 			=		0;									// Признак что прошел первый пинг		
;      55 bit		dPresent			=		0;									// признак наличия подкл. устройства
;      56 bit		time_is_Out		=		0;									// Сработал тайм - аут        
;      57 bit		startPacket		=		0;									// принят признак старта приема
;      58 bit		rxPack				=		0;									// принят пакет																						
;      59 bit		txPack				=		0;									// есть данные на передачу
;      60 bit 		rxPackUART 		= 		0;									// принят пакет по UART
;      61 bit 		tstPort				=		0;									// пора проверить подключенное устройство
;      62 bit 		GlobalAddr 		= 		0;									// Признак ""глобального вызова" 
;      63 bit		to_Reboot			=		0;									// на перезагрузку в Загрузчик
;      64 bit		print					=		0;									// вывести на печать
;      65 
;      66 
;      67 // USART Receiver interrupt service routine
;      68 interrupt [USART_RXC] void usart_rx_isr(void)      
;      69 {     

	.CSEG
_usart_rx_isr:
	RCALL SUBOPT_0x0
;      70 	unsigned char data;
;      71 	data = UDR;
	ST   -Y,R16
;	data -> R16
	IN   R16,12
;      72 
;      73 	TCNT1H=0x00;						// перезапускаем таймер опроса подч. устройства
	RCALL SUBOPT_0x1
;      74 	TCNT1L=0x00;
;      75 
;      76 
;      77 if ((UCSRA & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	IN   R30,0xB
	ANDI R30,LOW(0x1C)
	BRNE _0x4
;      78 	{
;      79 
;      80 	if (!(txPack)) 
	SBRC R2,5
	RJMP _0x5
;      81 	{
;      82 
;      83 	if (!(CountUART)) 		            	// Прием с начала
	TST  R11
	BRNE _0x6
;      84 		{ 
;      85 			if (!rxPackUART)           // предыдущий пакет передан?
	SBRC R2,6
	RJMP _0x7
;      86 				{
;      87 					CountUART_1 = 0;
	CLR  R12
;      88 					txBuffer [CountUART_1++] = data;
	RCALL SUBOPT_0x2
;      89 					CountUART = data;
	MOV  R11,R16
;      90 				} 
;      91 		}
_0x7:
;      92 	else
	RJMP _0x8
_0x6:
;      93 		{                                                  // продолжаем прием пакета
;      94 			txBuffer[CountUART_1++] = data;
	RCALL SUBOPT_0x2
;      95 			if (!(--CountUART)) 				// принят весь пакет
	DEC  R11
	BRNE _0x9
;      96 				{
;      97 					if (checkCRCtx()) rxPackUART = 1;
	RCALL _checkCRCtx
	CPI  R30,0
	BREQ _0xA
	SET
	BLD  R2,6
;      98 				}
_0xA:
;      99 		}
_0x9:
_0x8:
;     100      } 
;     101      }
_0x5:
;     102 }
_0x4:
	LD   R16,Y+
	RCALL SUBOPT_0x3
	RETI
;     103 
;     104 
;     105 
;     106 
;     107 // ------------------  Обработка прерывания TWI ---------------------------
;     108 // 2 Wire bus interrupt service routine
;     109 interrupt [TWI] void twi_isr(void)
;     110 {
_twi_isr:
	RCALL SUBOPT_0x0
;     111 	// Поступил запрос по нашему адресу
;     112          if (TWSR == D_Call ) GlobalAddr =0;								// локальный адрес
	IN   R30,0x1
	CPI  R30,LOW(0x80)
	BRNE _0xB
	CLT
	BLD  R3,0
;     113          if (TWSR == G_Call ) GlobalAddr =1;	          // Действия при глобальной адресации
_0xB:
	IN   R30,0x1
	CPI  R30,LOW(0x90)
	BRNE _0xC
	SET
	BLD  R3,0
;     114 
;     115 				if (!(Count1))
_0xC:
	TST  R6
	BRNE _0xD
;     116 						{
;     117 
;     118 							if (!startPacket)
	SBRC R2,3
	RJMP _0xE
;     119 								{						
;     120 									switch	(TWDR)
	IN   R30,0x3
;     121 										{
;     122 											case startPing: 						// принят пинг при опросе кол-ва устройств
	CPI  R30,LOW(0xAA)
	BRNE _0x12
;     123 												{ 
;     124 													ping = 1;  
	SET
	BLD  R2,0
;     125 													break;
	RJMP _0x11
;     126 												}
;     127 											case startPack: 						// принят признак начала пакета
_0x12:
	CPI  R30,LOW(0x71)
	BRNE _0x11
;     128 												{ 
;     129 													startPacket = 1;	// ставим признак
	SET
	BLD  R2,3
;     130 													Count	= 0;
	CLR  R7
;     131 													rxBuffer [Count++] = TWDR;			// принятый байт - в буффер
	RCALL SUBOPT_0x4
;     132 													break;
;     133 												}
;     134 										}
_0x11:
;     135 								}
;     136 							else 
	RJMP _0x14
_0xE:
;     137 								{
;     138 									Count1 = TWDR;                  // длинна пакета        
	IN   R6,3
;     139 									rxBuffer [Count++] = TWDR;
	RCALL SUBOPT_0x4
;     140 								};
_0x14:
;     141 								
;     142 	    		 		}
;     143 				else
	RJMP _0x15
_0xD:
;     144 						{
;     145 							Count1--;
	DEC  R6
;     146 							rxBuffer[Count++]=TWDR;
	RCALL SUBOPT_0x4
;     147 							if (!(Count1))
	TST  R6
	BRNE _0x16
;     148 								{
;     149 									CRCPackRX	= TWDR;												// КС
	IN   R8,3
;     150 									startPacket = 0;						// конец приема пакета
	CLT
	BLD  R2,3
;     151 									if (checkCRCrx())	rxPack = 1;	// При CRC-ok -принят пакет
	RCALL _checkCRCrx
	CPI  R30,0
	BREQ _0x17
	SET
	BLD  R2,4
;     152 								}
_0x17:
;     153 						}
_0x16:
_0x15:
;     154 	    	   
;     155 	                
;     156 
;     157 //          // Действия при глобальной адресации
;     158 //         if (TWSR == G_Call ) 
;     159 //                	{
;     160 //                		putchar (TWDR);
;     161 //                	}    
;     162                 
;     163 
;     164 
;     165 		// отправляем в ответ сформированный буффер
;     166          if ((TWSR == D_Responce)||(TWSR == Addr_Responce))
	IN   R30,0x1
	CPI  R30,LOW(0xB8)
	BREQ _0x19
	IN   R30,0x1
	CPI  R30,LOW(0xA8)
	BRNE _0x18
_0x19:
;     167          	{
;     168 				if (!(Count3))
	TST  R10
	BRNE _0x1B
;     169 						{
;     170 							if (!txPack) TWDR = 0;
	SBRC R2,5
	RJMP _0x1C
	LDI  R30,LOW(0)
	OUT  0x3,R30
;     171 							else 
	RJMP _0x1D
_0x1C:
;     172 								{
;     173 									Count2=0;
	CLR  R9
;     174 									Count3 = txBuffer [0]+1;
	LDS  R30,_txBuffer
	SUBI R30,-LOW(1)
	MOV  R10,R30
;     175 									TWDR = txBuffer [Count2++]; 
	RCALL SUBOPT_0x5
;     176 if (print) putchar (TWDR);									 
	SBRC R3,2
	RCALL SUBOPT_0x6
;     177 									Count3--;
	DEC  R10
;     178 								}
_0x1D:
;     179 						}
;     180 				else
	RJMP _0x1F
_0x1B:
;     181 						{
;     182 							TWDR = txBuffer [ Count2++];
	RCALL SUBOPT_0x5
;     183 if (print) putchar (TWDR);									 
	SBRC R3,2
	RCALL SUBOPT_0x6
;     184 							Count3--;
	DEC  R10
;     185 							if (!(Count3)) 
	TST  R10
	BRNE _0x21
;     186 								{
;     187 									txPack = 0;		//пакет отправлен
	CLT
	BLD  R2,5
;     188 print = 0;
	BLD  R3,2
;     189 								}
;     190 						}
_0x21:
_0x1F:
;     191          	}
;     192 
;     193          TWCR = ((1<<TWINT) | (1<<TWEA) | (1<<TWEN) |(1<<TWIE)); //Импульс подтверждения I2C
_0x18:
	LDI  R30,LOW(197)
	OUT  0x36,R30
;     194 }
	RCALL SUBOPT_0x3
	RETI
;     195 //--------------------------------------------------------------------------------------
;     196 
;     197 
;     198 // Подключаемые файлы программы
;     199 #include <CDlayer2.c>
;     200 #include <CDlayer3.c>
;     201 flash unsigned char device_name[32] =					// Имя устройства
;     202 		"Main Program. Port";
;     203 eeprom unsigned long my_ser_num = 1;					// Серийный номер устройства

	.ESEG
_my_ser_num:
	.DW  0x1
	.DW  0x0
;     204 const flash unsigned short my_version = 1;			// Версия софта 

	.CSEG
;     205 //eeprom unsigned char my_addr = TO_MON;					// Мой адрес - изначально TO_MON
;     206 
;     207 //-----------------------------------------------------------------------------------------------------------------
;     208 //-----------------------------------------------------------------------------------------------------------------
;     209 // Реакция на команду перейти в рабочий режим
;     210 void ToWorkMode(void)
;     211 {
_ToWorkMode:
;     212 
;     213 	// Отправляю ответ
;     214 	txBuffer[0] = 1;        						// подтверждаю прием
	RCALL SUBOPT_0x7
;     215 	txBuffer[1] = 1;        						// подтверждаю прием
	__PUTB1MN _txBuffer,1
;     216 
;     217 	txPack = 1;								// есть данные
	SET
	BLD  R2,5
;     218 }
	RET
;     219 // Назначение серийного номера устройства
;     220 static void SetSerial(void)
;     221 {
_SetSerial_G1:
;     222 /*	#define ssp ((RQ_SETSERIAL *)rx0buf)
;     223 	
;     224 	if (my_ser_num)
;     225 	{
;     226 		txBuffer[0] = 2;  			//длина
;     227 		txBuffer[1] = (RES_ERR);		
;     228 		txBuffer[2] = 2;          // КС
;     229 
;     230 		txPack = 1;		// есть пакет на передачу
;     231 
;     232 		return;
;     233 	}
;     234 	
;     235 	my_ser_num = ssp->num;*/
;     236 	
;     237 		txBuffer[0] = 2;  			//длина
	RCALL SUBOPT_0x8
;     238 		txBuffer[1] = (RES_OK);		
	LDI  R30,LOW(1)
	__PUTB1MN _txBuffer,1
;     239 		txBuffer[2] = 2+(RES_OK);          // КС
	LDI  R30,LOW(3)
	__PUTB1MN _txBuffer,2
;     240 
;     241 		txPack = 1;		// есть пакет на передачу
	SET
	BLD  R2,5
;     242 }
	RET
;     243 
;     244 //  Назначение адреса устройства
;     245 void Setaddr (void)
;     246 	{
_Setaddr:
;     247 		txBuffer[0] = 2;  			//длина
	RCALL SUBOPT_0x8
;     248 		txBuffer[1] = 0;		
	LDI  R30,LOW(0)
	__PUTB1MN _txBuffer,1
;     249 		txBuffer[2] = 2;          // КС
	LDI  R30,LOW(2)
	__PUTB1MN _txBuffer,2
;     250 
;     251 		txPack = 1;		// есть пакет на передачу
	SET
	BLD  R2,5
;     252 	}
	RET
;     253 
;     254 // Перезагрузка в режим программирования
;     255 static void ToProg(void)
;     256 {
_ToProg_G1:
;     257 	// Отправляю ответ
;     258 		txBuffer[0] = 1;  			//длина
	RCALL SUBOPT_0x7
;     259 		txBuffer[1] = 1;          // КС
	__PUTB1MN _txBuffer,1
;     260 		
;     261 		txPack = 1;		// есть пакет на передачу
	SET
	BLD  R2,5
;     262 		delay_ms(50);
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
;     263 
;     264 	// На перезагрузку в монитор
;     265 		IVCREG = 1 << IVCE;
	LDI  R30,LOW(1)
	OUT  0x3B,R30
;     266 		IVCREG = 1 << IVSEL;
	LDI  R30,LOW(2)
	OUT  0x3B,R30
;     267 		#asm("rjmp 0xC00");
	rjmp 0xC00
;     268 }
	RET
;     269 
;     270 
;     271 // Возвращаю состояние устройства
;     272 const char _PT_GETSTATE_[]={20,1,0,'a','a','a','a','a','a','a','a','a','a','a','a','a','a',' ',100,255};
;     273 static void GetState(void)
;     274 {
_GetState_G1:
;     275 	register unsigned char a, crc=0;
;     276 	
;     277 		memcpyf(txBuffer, _PT_GETSTATE_, _PT_GETSTATE_[0]+1);
	RCALL __SAVELOCR2
;	a -> R16
;	crc -> R17
	LDI  R17,0
	LDI  R30,LOW(_txBuffer)
	LDI  R31,HIGH(_txBuffer)
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x9
	LPM  R30,Z
	SUBI R30,-LOW(1)
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RCALL _memcpyf
;     278 		for (a=0;a<=txBuffer[0]-1;a++) 
	LDI  R16,LOW(0)
_0x23:
	RCALL SUBOPT_0xA
	CP   R30,R16
	BRLO _0x24
;     279 			{
;     280 				crc += txBuffer[a];	//KC
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xC
	ADD  R17,R30
;     281 			};
	SUBI R16,-1
	RJMP _0x23
_0x24:
;     282 		txBuffer[a] = crc;
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_txBuffer)
	SBCI R27,HIGH(-_txBuffer)
	ST   X,R17
;     283 print = 1;
	SET
	BLD  R3,2
;     284 		txPack = 1;		// есть пакет на передачу
	BLD  R2,5
;     285 
;     286 /*		while (txPack);				// ждем передачи
;     287 
;     288 //		txBuffer[0] = 4;				 			// длина пакета
;     289 		txBuffer[1] = 1;
;     290 		txBuffer[2] = 1;
;     291 		txBuffer[3] = 1;
;     292 		txBuffer[4] = 7;//2+lAddr;	 			//КС  
;     293 print = 1;
;     294 
;     295 		txPack = 1;		// есть пакет на передачу*/
;     296 		
;     297 		
;     298 } 
	RJMP _0x68
;     299 
;     300 // Информация об устройстве:
;     301 
;     302 static void GetInfo(void)
;     303 {
_GetInfo_G1:
;     304 	register unsigned char i,a,crc=0;                    
;     305 //putchar (0x01);		
;     306 	
;     307 	// 	заполняю буфер
;     308 	txBuffer[0] = 40+1;
	RCALL __SAVELOCR3
;	i -> R16
;	a -> R17
;	crc -> R18
	LDI  R18,0
	LDI  R30,LOW(41)
	STS  _txBuffer,R30
;     309 	
;     310 	for (i = 0; i < 32; i ++)	// Имя устройства
	LDI  R16,LOW(0)
_0x26:
	CPI  R16,32
	BRSH _0x27
;     311 	{
;     312 		txBuffer[i+1] = device_name[i];
	RCALL SUBOPT_0xB
	__ADDW1MN _txBuffer,1
	MOVW R26,R30
	RCALL SUBOPT_0xB
	SUBI R30,LOW(-_device_name*2)
	SBCI R31,HIGH(-_device_name*2)
	LPM  R30,Z
	ST   X,R30
;     313 	}
	SUBI R16,-1
	RJMP _0x26
_0x27:
;     314 
;     315 		txBuffer[33] = my_ser_num;           // Серийный номер
	LDI  R26,LOW(_my_ser_num)
	LDI  R27,HIGH(_my_ser_num)
	RCALL __EEPROMRDD
	__PUTB1MN _txBuffer,33
;     316 		txBuffer[34] = my_ser_num>>8;      // Серийный номер
	LDI  R26,LOW(_my_ser_num)
	LDI  R27,HIGH(_my_ser_num)
	RCALL __EEPROMRDD
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(8)
	RCALL __LSRD12
	__PUTB1MN _txBuffer,34
;     317 
;     318 		txBuffer[35] = 0;	// Серийный номер
	LDI  R30,LOW(0)
	__PUTB1MN _txBuffer,35
;     319 		txBuffer[36] = 0;	// Серийный номер
	__PUTB1MN _txBuffer,36
;     320 	
;     321 		txBuffer[37] =pAddr ;     // Адрес устройстав
	__PUTBMRN _txBuffer,37,4
;     322 
;     323 		txBuffer[38] =0;     // Зарезервированный байт
	__PUTB1MN _txBuffer,38
;     324 	
;     325 		txBuffer[39] = my_version;             // Версия
	__POINTW2MN _txBuffer,39
	LDI  R30,LOW(_my_version*2)
	LDI  R31,HIGH(_my_version*2)
	RCALL __GETW1PF
	ST   X,R30
;     326 		txBuffer[40] = my_version>>8;		// Версия
	LDI  R30,LOW(_my_version*2)
	LDI  R31,HIGH(_my_version*2)
	RCALL __GETW1PF
	MOV  R30,R31
	LDI  R31,0
	__PUTB1MN _txBuffer,40
;     327 		
;     328 		for (a=0;a<=txBuffer[0]-1;a++) crc += txBuffer[a];	//KC
	LDI  R17,LOW(0)
_0x29:
	RCALL SUBOPT_0xA
	CP   R30,R17
	BRLO _0x2A
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xC
	ADD  R18,R30
;     329 		txBuffer[41] = crc;
	SUBI R17,-1
	RJMP _0x29
_0x2A:
	__PUTBMRN _txBuffer,41,18
;     330 	
;     331 
;     332 		txPack = 1;		// есть пакет на передачу 
	SET
	BLD  R2,5
;     333 //putchar (0x02);		
;     334 }
	RCALL __LOADLOCR3
	ADIW R28,3
	RET
;     335 
;     336 
;     337 // Отвечаем. Заполняем буффер на передачу
;     338 void _GetLogAddr (void)
;     339 	{
__GetLogAddr:
;     340 	
;     341 		txBuffer[0] = 2;				 			// длина пакета
	RCALL SUBOPT_0x8
;     342 		txBuffer[1] = lAddr;		  			// лог. адрес
	__PUTBMRN _txBuffer,1,5
;     343 		txBuffer[2] = 2+lAddr;	 			//КС  
	MOV  R30,R5
	SUBI R30,-LOW(2)
	__PUTB1MN _txBuffer,2
;     344 
;     345 		txPack = 1;		// есть пакет на передачу
	SET
	BLD  R2,5
;     346 	
;     347 	}  
	RET
;     348 	
;     349 // Отладочные пакеты
;     350 void _OP (unsigned char c)
;     351 	{
;     352 		unsigned char a =0, b;
;     353 
;     354 		txBuffer[0] = c;					// длина пакета
;	c -> Y+2
;	a -> R16
;	b -> R17
;     355 
;     356 		for (b=0;b< txBuffer [0]; b++)
;     357 			{
;     358 				a=a+txBuffer [b];
;     359 			}                            
;     360 			
;     361 		txBuffer [b] = a;					//KC
;     362 
;     363 		txPack = 1;		// есть пакет на передачу
;     364 		
;     365 	}
;     366 
;     367 static void give_GETINFO (void)
;     368 {
_give_GETINFO_G1:
;     369 	
;     370 	// 	Начинаю запрос  типа устройства
;     371 			putchar ('q');						// заголовок
	LDI  R30,LOW(113)
	RCALL SUBOPT_0xE
;     372 			putchar (3);							// число байт после этого
	RCALL SUBOPT_0xF
;     373 			putchar (255);		 				//  адрес (циркулярный)
	LDI  R30,LOW(255)
	RCALL SUBOPT_0xE
;     374 			putchar (PT_GETINFO);		// тип пакета
	RCALL SUBOPT_0xF
;     375 			putchar ((PT_GETINFO)+(255)+3+('q'));
	LDI  R30,LOW(374)
	RCALL SUBOPT_0xE
;     376 				
;     377 }
	RET
;     378 
;     379 // Подсчет CRC приемного буффера
;     380 unsigned char checkCRCrx (void)
;     381 	{
_checkCRCrx:
;     382 		unsigned char a =0, b; 
;     383 		for (b=0;b<= rxBuffer [1]; b++)
	RCALL __SAVELOCR2
;	a -> R16
;	b -> R17
	LDI  R16,0
	LDI  R17,LOW(0)
_0x2F:
	__GETB1MN _rxBuffer,1
	CP   R30,R17
	BRLO _0x30
;     384 			{
;     385 				a=a+rxBuffer [b];
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x10
	ADD  R16,R30
;     386 			} 
	SUBI R17,-1
	RJMP _0x2F
_0x30:
;     387 		if (a == CRCPackRX) return 255;	 	//Ok
	CP   R8,R16
	BRNE _0x31
	LDI  R30,LOW(255)
	RJMP _0x68
;     388 		else return 0;
_0x31:
	LDI  R30,LOW(0)
	RJMP _0x68
;     389 	}
;     390 
;     391 // Подсчет CRC передающего буффера
;     392 unsigned char checkCRCtx (void)
;     393 	{
_checkCRCtx:
;     394 		unsigned char a =0, b;    
;     395 
;     396 		for (b=0;b< txBuffer [0]; b++)
	RCALL __SAVELOCR2
;	a -> R16
;	b -> R17
	LDI  R16,0
	LDI  R17,LOW(0)
_0x34:
	LDS  R30,_txBuffer
	CP   R17,R30
	BRSH _0x35
;     397 			{
;     398 				a=a+txBuffer [b];
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xC
	ADD  R16,R30
;     399 			} 
	SUBI R17,-1
	RJMP _0x34
_0x35:
;     400 			
;     401 		if (a == txBuffer [b]) 
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xC
	CP   R30,R16
	BRNE _0x36
;     402 			{
;     403 				return 255;	 	//Ok
	LDI  R30,LOW(255)
	RJMP _0x68
;     404 			}
;     405 		else return 0;
_0x36:
	LDI  R30,LOW(0)
;     406 	}
_0x68:
	RCALL __LOADLOCR2P
	RET
;     407 
;     408 // Обрабатываем входящий пакет
;     409 void workINpack ( void )
;     410 		{
_workINpack:
;     411 			unsigned char a;
;     412 
;     413 		if (rxBuffer[2]==0)				// проверяем адрес. 0-обработка.Остальное-ретранслируем
	ST   -Y,R16
;	a -> R16
	__GETB1MN _rxBuffer,2
	CPI  R30,0
	BRNE _0x38
;     414 			{
;     415 					switch (rxBuffer[3])
	__GETB1MN _rxBuffer,3
;     416 						{
;     417 							case GetLogAddr:				// возвращаем лог. адрес
	CPI  R30,LOW(0x1)
	BRNE _0x3C
;     418 									_GetLogAddr ();		
	RCALL __GetLogAddr
;     419 									rxPack = 0;				// пакет обработан
	CLT
	BLD  R2,4
;     420 									break;
	RJMP _0x3B
;     421 
;     422 							case OP:							// отладочные пакеты
_0x3C:
	CPI  R30,LOW(0x64)
	BRNE _0x3D
;     423 									readAddrDevice(); 
	RCALL _readAddrDevice
;     424 									rxPack = 0;				// пакет обработан
	CLT
	BLD  R2,4
;     425 									break;
	RJMP _0x3B
;     426 
;     427 							case pingPack :
_0x3D:
	CPI  R30,LOW(0x2)
	BRNE _0x40
;     428 									LedInv();
	CLT
	SBIS 0x12,3
	SET
	IN   R26,0x12
	BLD  R26,3
	OUT  0x12,R26
;     429 
;     430 									if (rxPackUART) 
	SBRS R2,6
	RJMP _0x3F
;     431 										{
;     432 											txPack = 1;		 	// есть пакет на передачу
	SET
	BLD  R2,5
;     433 											rxPackUART = 0;	// пакет обработан
	CLT
	BLD  R2,6
;     434 										}
;     435 									rxPack = 0;					// пакет обработан
_0x3F:
	CLT
	BLD  R2,4
;     436 									break; 
	RJMP _0x3B
;     437 
;     438 							default:
_0x40:
;     439 									rxPack = 0;					// пакет обработан
	CLT
	BLD  R2,4
;     440 										
;     441 						}
_0x3B:
;     442             }
;     443 		else if (rxBuffer[2]==pAddr) 							////////////// Мой адрес. Обращаются ко мне
	RJMP _0x41
_0x38:
	__GETB2MN _rxBuffer,2
	CP   R4,R26
	BRNE _0x42
;     444 			{
;     445 					switch (rxBuffer[3])
	__GETB1MN _rxBuffer,3
;     446 						{
;     447 							case PT_GETINFO:			// возвращаем о себе информацию
	CPI  R30,LOW(0x3)
	BRNE _0x46
;     448 //print = 1;
;     449 									GetInfo();
	RCALL _GetInfo_G1
;     450 									rxPack = 0;					// пакет обработан
	CLT
	BLD  R2,4
;     451 									break;           
	RJMP _0x45
;     452 
;     453 							case PT_GETSTATE:
_0x46:
	CPI  R30,LOW(0x1)
	BRNE _0x47
;     454 									GetState();
	RCALL _GetState_G1
;     455 									rxPack = 0;					// пакет обработан
	CLT
	BLD  R2,4
;     456 									break;
	RJMP _0x45
;     457 
;     458 					 		case PT_TOPROG:       			// переходим в программирование
_0x47:
	CPI  R30,LOW(0x7)
	BRNE _0x48
;     459 									ToProg();
	RCALL _ToProg_G1
;     460 									rxPack = 0;					// пакет обработан
	CLT
	BLD  R2,4
;     461 									break;      
	RJMP _0x45
;     462 
;     463 					 		case PT_SETADDR:       			// переходим в программирование
_0x48:
	CPI  R30,LOW(0x4)
	BRNE _0x49
;     464 									Setaddr();
	RCALL SUBOPT_0x11
;     465 									rxPack = 0;					// пакет обработан
	BLD  R2,4
;     466 									break;      
	RJMP _0x45
;     467 					 		case PT_SETSERIAL:       			// переходим в программирование
_0x49:
	CPI  R30,LOW(0x5)
	BRNE _0x4B
;     468 									SetSerial();
	RCALL SUBOPT_0x12
;     469 									rxPack = 0;					// пакет обработан
	BLD  R2,4
;     470 									break;      
	RJMP _0x45
;     471 
;     472 
;     473 							default:
_0x4B:
;     474 									rxPack = 0;					// пакет обработан
	CLT
	BLD  R2,4
;     475 						}
_0x45:
;     476               }
;     477 		else	if(rxBuffer[2] == TO_MON)					// обрабатываем пакет по адресу MONITOR
	RJMP _0x4C
_0x42:
	__GETB1MN _rxBuffer,2
	CPI  R30,LOW(0xFE)
	BRNE _0x4D
;     478 			{
;     479 					switch (rxBuffer[3])
	__GETB1MN _rxBuffer,3
;     480 						{
;     481 					 		case PT_SETADDR:       			// переходим в программирование
	CPI  R30,LOW(0x4)
	BRNE _0x51
;     482 									Setaddr();
	RCALL SUBOPT_0x11
;     483 									rxPack = 0;					// пакет обработан
	BLD  R2,4
;     484 									break;      
	RJMP _0x50
;     485 					 		case PT_SETSERIAL:       			// переходим в программирование
_0x51:
	CPI  R30,LOW(0x5)
	BRNE _0x52
;     486 									SetSerial();
	RCALL SUBOPT_0x12
;     487 									rxPack = 0;					// пакет обработан
	BLD  R2,4
;     488 									break; 
	RJMP _0x50
;     489 					 		case PT_TOWORK:       			// переходим в программирование
_0x52:
	CPI  R30,LOW(0xB)
	BRNE _0x54
;     490 									ToWorkMode();
	RCALL _ToWorkMode
;     491 									rxPack = 0;					// пакет обработан
	CLT
	BLD  R2,4
;     492 									break; 
	RJMP _0x50
;     493 									     
;     494 							default:
_0x54:
;     495 									rxPack = 0;					// пакет обработан
	CLT
	BLD  R2,4
;     496 						}
_0x50:
;     497 			}
;     498 		else
	RJMP _0x55
_0x4D:
;     499 				{ 												///////////// иначе ретранслируем
;     500 					for (a = 0;a<= (rxBuffer[1]+1); a++)
	LDI  R16,LOW(0)
_0x57:
	__GETB1MN _rxBuffer,1
	SUBI R30,-LOW(1)
	CP   R30,R16
	BRLO _0x58
;     501 						{
;     502 							putchar (rxBuffer [a]);
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xE
;     503 						}
	SUBI R16,-1
	RJMP _0x57
_0x58:
;     504 					rxPack = 0;					// пакет обработан
	CLT
	BLD  R2,4
;     505 				}
_0x55:
_0x4C:
_0x41:
;     506 			}	
	LD   R16,Y+
	RET
;     507 
;     508 // Обработка пакета, принятого по UART
;     509 	void workUARTpack (void)
;     510 		{
;     511 			LedInv();
;     512 
;     513 			txPack = 1;							// есть пакет на передачу
;     514 			rxPackUART = 0;				// пакет обработан
;     515 		}			
;     516 		
;     517 
;     518 
;     519 // ----------------------- Обработка прерывания таймера 0 (тайм-аут RS232) --------
;     520 // Timer 0 overflow interrupt service routine
;     521 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;     522 {
_timer0_ovf_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
;     523 	TCCR0=0x00;										// Останавливаем таймер
	RCALL SUBOPT_0x13
;     524 	time_is_Out =1;		// взводим признак окончания таймаута
	SET
	BLD  R2,2
;     525 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;     526 //--------------------------------------------------------------------------------------
;     527 
;     528 // ----------------------- Обработка прерывания таймера 1 ( опрос подключения каждые 10 с) --------
;     529 // Timer 1 overflow interrupt service routine
;     530 interrupt [TIM1_OVF] void timer1_ovf_isr(void)
;     531 {
_timer1_ovf_isr:
	ST   -Y,R30
	IN   R30,SREG
;     532 	tstPort = 1;						// пора проверить устройство присутствует ли ?
	SET
	BLD  R2,7
;     533 }
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;     534 
;     535 
;     536 
;     537 
;     538 
;     539 // Пускаем таймер таймаута
;     540 void timeOutStart (void)
;     541 		{
_timeOutStart:
;     542 			time_is_Out = 0;			// сброс флага таймаута
	CLT
	BLD  R2,2
;     543 			TCNT0=0x00;
	RCALL SUBOPT_0x14
;     544 			TCCR0=0x05;      									// пускаем таймер
	LDI  R30,LOW(5)
	OUT  0x33,R30
;     545 		}
	RET
;     546 
;     547 // Пускаем таймер таймаута
;     548 void timeOutStop (void)
;     549 		{
_timeOutStop:
;     550 			TCCR0=0x0;      									// останов таймера
	RCALL SUBOPT_0x13
;     551 		}
	RET
;     552 
;     553 // процесс определения физического адреса порта и ответа
;     554 // на первичный пинг (0хАА) главного процессора
;     555 void inidevice (void)
;     556 		{                                      
_inidevice:
;     557 		pAddr = ((PINC & 0x7)+1 );			// определяем физический адрес (0-не исп. т.к. Глоб. Вызов)
	IN   R30,0x13
	ANDI R30,LOW(0x7)
	SUBI R30,-LOW(1)
	MOV  R4,R30
;     558 		TWAR = (pAddr<<1)+1;					// Устанавливаем его для TWI
	RCALL SUBOPT_0x15
;     559 
;     560 //		while (! ping);								// ждем первый пинг 0хАА
;     561 
;     562 		}                                  
	RET
;     563 		
;     564 // Прием байта из UART. Контролируем тайм-аутом		
;     565 unsigned char havechar(void)
;     566 {
;     567 	timeOutStart ();													// пускаем таймер
;     568 	while (!( UCSRA & (1 << RXC)))
;     569 		{
;     570    		    if (time_is_Out)	
;     571    		    	{
;     572 	                dPresent = 0;					//  устройство не ответило
;     573 					timeOutStop ();				// останов таймера
;     574    			    	return 0;						// если нет байта то проверяем таймаут
;     575    		    	}
;     576 		}
;     577 	timeOutStop ();								// останов таймера
;     578     dPresent = 1;									//взводим признак наличия устройства
;     579 
;     580 	return 255;
;     581 }
;     582 
;     583 
;     584 // Проверяем что подключено к пору RS232
;     585 // Если есть устройство - определяем адрес и вносим в таблицу адресов
;     586 // Если нет ничего - сканируем до обнаружения. Сопровождаем морганием светодиода
;     587 void 	readAddrDevice (void)                                                          
;     588 		{
_readAddrDevice:
;     589 				give_GETINFO();
	RCALL _give_GETINFO_G1
;     590 
;     591 				timeOutStart();
	RCALL _timeOutStart
;     592 				while (!(rxPackUART))					// ждем отклик
_0x5D:
	SBRC R2,6
	RJMP _0x5F
;     593 				{
;     594 					if (time_is_Out )
	SBRS R2,2
	RJMP _0x60
;     595 						{
;     596 							LedOn();								// моргаем светодиодом при проблемах связи
	CBI  0x12,3
;     597 			                dPresent = 0;			 			//  устройство не ответило
	CLT
	BLD  R2,1
;     598 		    	            lAddr = 0;					 			// Адрес = 0
	CLR  R5
;     599 							break;
	RJMP _0x5F
;     600 						} 
;     601 					else  
_0x60:
;     602 						{
;     603 							dPresent = 1;						// ответило 
	SET
	BLD  R2,1
;     604 							lAddr = txBuffer [37];			// вынимаем адрес из принятого пакта             
	__GETBRMN 5,_txBuffer,37
;     605 							LedOff();							// тушим индикатор проблем
	SBI  0x12,3
;     606 
;     607 							tstPort = 0;						// устройство присутствует
	CLT
	BLD  R2,7
;     608 						}
;     609 					
;     610 				}        
	RJMP _0x5D
_0x5F:
;     611 				timeOutStop();
	RCALL _timeOutStop
;     612 								
;     613 				
;     614 				if (dPresent) txPack = 1;					// есть пакет на передачу
	SBRS R2,1
	RJMP _0x62
	SET
	BLD  R2,5
;     615 				rxPackUART = 0;							// принятый пакет - в отправке
_0x62:
	CLT
	BLD  R2,6
;     616 		}
	RET
;     617 
;     618 void main(void)
;     619 {
_main:
;     620 // Declare your local variables here
;     621 
;     622 // Input/Output Ports initialization
;     623 
;     624 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
;     625 DDRB=0x00;
	OUT  0x17,R30
;     626 
;     627 PORTC=0x07;
	LDI  R30,LOW(7)
	OUT  0x15,R30
;     628 DDRC=0x00;
	LDI  R30,LOW(0)
	OUT  0x14,R30
;     629 
;     630 PORTD=0x00;
	OUT  0x12,R30
;     631 DDRD=0x1C;
	LDI  R30,LOW(28)
	OUT  0x11,R30
;     632 
;     633 // Timer/Counter 0 initialization
;     634 // Clock source: System Clock
;     635 // Clock value: 7,813 kHz
;     636 TCCR0=0x00;
	RCALL SUBOPT_0x13
;     637 TCNT0=0x00;
	RCALL SUBOPT_0x14
;     638 
;     639 
;     640 // Timer/Counter 1 initialization
;     641 // Clock source: System Clock
;     642 // Clock value: 7,813 kHz
;     643 // Mode: Normal top=FFFFh
;     644 // OC1A output: Discon.
;     645 // OC1B output: Discon.
;     646 // Noise Canceler: On
;     647 // Input Capture on Falling Edge
;     648 // Timer 1 Overflow Interrupt: On
;     649 // Input Capture Interrupt: Off
;     650 // Compare A Match Interrupt: Off
;     651 // Compare B Match Interrupt: Off
;     652 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
;     653 TCCR1B=0x85;
	LDI  R30,LOW(133)
	OUT  0x2E,R30
;     654 TCNT1H=0x00;
	RCALL SUBOPT_0x1
;     655 TCNT1L=0x00;
;     656 ICR1H=0x67;
	LDI  R30,LOW(103)
	OUT  0x27,R30
;     657 ICR1L=0x69;
	LDI  R30,LOW(105)
	OUT  0x26,R30
;     658 OCR1AH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2B,R30
;     659 OCR1AL=0x00;
	OUT  0x2A,R30
;     660 OCR1BH=0x00;
	OUT  0x29,R30
;     661 OCR1BL=0x00;
	OUT  0x28,R30
;     662 
;     663 // Timer/Counter 2 initialization
;     664 // Clock source: System Clock
;     665 // Clock value: Timer 2 Stopped
;     666 // Mode: Normal top=FFh
;     667 // OC2 output: Disconnected
;     668 ASSR=0x00;
	OUT  0x22,R30
;     669 TCCR2=0x00;
	OUT  0x25,R30
;     670 TCNT2=0x00;
	OUT  0x24,R30
;     671 OCR2=0x00;
	OUT  0x23,R30
;     672 
;     673 // External Interrupt(s) initialization
;     674 // INT0: Off
;     675 // INT1: Off
;     676 MCUCR=0x00;
	OUT  0x35,R30
;     677 
;     678 // Timer(s)/Counter(s) Interrupt(s) initialization
;     679 TIMSK=0x05;
	LDI  R30,LOW(5)
	OUT  0x39,R30
;     680 
;     681 
;     682 // USART initialization
;     683 // Communication Parameters: 8 Data, 1 Stop, No Parity
;     684 // USART Receiver: On
;     685 // USART Transmitter: On
;     686 // USART Mode: Asynchronous
;     687 // USART Baud rate: 38400
;     688 UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
;     689 UCSRB=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
;     690 UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
;     691 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
;     692 UBRRL=0x0C;
	LDI  R30,LOW(12)
	OUT  0x9,R30
;     693 
;     694 
;     695 // Analog Comparator initialization
;     696 // Analog Comparator: Off
;     697 // Analog Comparator Input Capture by Timer/Counter 1: Off
;     698 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     699 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;     700 
;     701 // 2 Wire Bus initialization
;     702 // Generate Acknowledge Pulse: On
;     703 // 2 Wire Bus Slave Address: 8h
;     704 // General Call Recognition: On
;     705 // Bit Rate: 400,000 kHz
;     706 TWSR=0x00;
	OUT  0x1,R30
;     707 TWBR=0x02;
	LDI  R30,LOW(2)
	OUT  0x0,R30
;     708 TWAR=(pAddr<<1)+1;
	RCALL SUBOPT_0x15
;     709 TWCR=0x45;
	LDI  R30,LOW(69)
	OUT  0x36,R30
;     710 
;     711 // Global enable interrupts
;     712 #asm("sei")
	sei
;     713 
;     714 	    LedOff();
	SBI  0x12,3
;     715 		inidevice();  						// ждем сканирования
	RCALL _inidevice
;     716 	    LedOn();                                                              
	CBI  0x12,3
;     717 putchar (0xab);		
	LDI  R30,LOW(171)
	RCALL SUBOPT_0xE
;     718 while (1)
_0x63:
;     719       {       
;     720 
;     721 //		if ((!(dPresent)) || (tstPort)) readAddrDevice(); 	 	// если нет устройства - ищем его
;     722 		if (rxPack) workINpack();			// принят пакет TWI 
	SBRC R2,4
	RCALL _workINpack
;     723       };
	RJMP _0x63
;     724 }
_0x67:
	RJMP _0x67

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
SUBOPT_0x1:
	LDI  R30,LOW(0)
	OUT  0x2D,R30
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2:
	MOV  R30,R12
	INC  R12
	LDI  R31,0
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	ST   Z,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x4:
	MOV  R30,R7
	INC  R7
	LDI  R31,0
	SUBI R30,LOW(-_rxBuffer)
	SBCI R31,HIGH(-_rxBuffer)
	MOVW R26,R30
	IN   R30,0x3
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5:
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	LD   R30,Z
	OUT  0x3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6:
	IN   R30,0x3
	ST   -Y,R30
	RJMP _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x7:
	LDI  R30,LOW(1)
	STS  _txBuffer,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x8:
	LDI  R30,LOW(2)
	STS  _txBuffer,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x9:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(__PT_GETSTATE_*2)
	LDI  R31,HIGH(__PT_GETSTATE_*2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xA:
	LDS  R30,_txBuffer
	SUBI R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0xB:
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0xC:
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0xD:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES
SUBOPT_0xE:
	ST   -Y,R30
	RJMP _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xF:
	LDI  R30,LOW(3)
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x10:
	SUBI R30,LOW(-_rxBuffer)
	SBCI R31,HIGH(-_rxBuffer)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x11:
	RCALL _Setaddr
	CLT
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x12:
	RCALL _SetSerial_G1
	CLT
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x13:
	LDI  R30,LOW(0)
	OUT  0x33,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x14:
	LDI  R30,LOW(0)
	OUT  0x32,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x15:
	MOV  R30,R4
	LSL  R30
	SUBI R30,-LOW(1)
	OUT  0x2,R30
	RET

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

__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR3:
	LDD  R18,Y+2
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
