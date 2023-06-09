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
;       5 � Copyright 1998-2005 Pavel Haiduc, HP InfoTech s.r.l.
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
;      32 #include <CDdef.h>					// ��� ���������
;      33 
;      34 //unsigned char Count1	=	0,  Count	=	0, lPack = 0;	
;      35 unsigned char rxBuffer[256];							// �������� ������  TWI
_rxBuffer:
	.BYTE 0x100
;      36 unsigned char txBuffer[64];								// ���������� ������ TWI
_txBuffer:
	.BYTE 0x40
;      37 unsigned char rxBufferUART[64];					// ������������� �������� ������ UART
_rxBufferUART:
	.BYTE 0x40
;      38 
;      39 unsigned char Count1	=	0,  Count	=	0, CRCPackRX = 0;	
;      40 unsigned char Count2	=	0,  Count3 =	0; 
;      41 unsigned char CountUART = 0, CountUART_1 = 0;      
;      42 
;      43 
;      44 
;      45 
;      46 /*
;      47 // ��� ������
;      48 static void twi_wait_int (void)
;      49 {
;      50 	while (!(TWCR & (1<<TWINT))); 
;      51 }
;      52   
;      53 */
;      54 	// ����� ���������
;      55 bit 		ping		 			=		0;									// ������� ��� ������ ������ ����		
;      56 bit		dPresent			=		0;									// ������� ������� �����. ����������
;      57 bit		time_is_Out		=		0;									// �������� ���� - ���        
;      58 bit		startPacket		=		0;									// ������ ������� ������ ������
;      59 bit		rxPack				=		0;									// ������ �����																						
;      60 bit		txPack				=		0;									// ���� ������ �� ��������
;      61 bit 		rxPackUART 		= 		0;									// ������ ����� �� UART
;      62 bit 		tstPort				=		0;									// ���� ��������� ������������ ����������
;      63 bit 		GlobalAddr 		= 		0;									// ������� ""����������� ������" 
;      64 bit		to_Reboot			=		0;									// �� ������������ � ���������
;      65 bit		print					=		0;									// ������� �� ������
;      66 
;      67 
;      68 // USART Receiver interrupt service routine
;      69 interrupt [USART_RXC] void usart_rx_isr(void)      
;      70 {     

	.CSEG
_usart_rx_isr:
	RCALL SUBOPT_0x0
;      71 	unsigned char data;
;      72 	data = UDR;
	ST   -Y,R16
;	data -> R16
	IN   R16,12
;      73 
;      74 	TCNT1H=0x00;						// ������������� ������ ������ ����. ����������
	RCALL SUBOPT_0x1
;      75 	TCNT1L=0x00;
;      76 
;      77 
;      78 if ((UCSRA & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	IN   R30,0xB
	ANDI R30,LOW(0x1C)
	BRNE _0x4
;      79 	{
;      80 
;      81 //	if (!(txPack)) 
;      82 //	{
;      83 
;      84 	if (!(CountUART)) 		            	// ����� � ������
	TST  R11
	BRNE _0x5
;      85 		{ 
;      86 			if (!rxPackUART)           // ���������� ����� �������?
	SBRC R2,6
	RJMP _0x6
;      87 				{
;      88 					CountUART_1 = 0;
	CLR  R12
;      89 					rxBufferUART [CountUART_1++] = data;
	RCALL SUBOPT_0x2
;      90 //					txBuffer [CountUART_1++] = data;
;      91 					CountUART = data;
	MOV  R11,R16
;      92 				} 
;      93 		}
_0x6:
;      94 	else
	RJMP _0x7
_0x5:
;      95 		{                                                  // ���������� ����� ������
;      96 			rxBufferUART[CountUART_1++] = data;
	RCALL SUBOPT_0x2
;      97 //			txBuffer[CountUART_1++] = data;
;      98 			if (!(--CountUART)) 				// ������ ���� �����
	DEC  R11
	BRNE _0x8
;      99 				{
;     100 					if (checkCRCtx()) rxPackUART = 1;
	RCALL _checkCRCtx
	CPI  R30,0
	BREQ _0x9
	SET
	BLD  R2,6
;     101 				}
_0x9:
;     102 //		}
;     103      } 
_0x8:
_0x7:
;     104      }
;     105 }
_0x4:
	LD   R16,Y+
	RCALL SUBOPT_0x3
	RETI
;     106 
;     107 
;     108 
;     109 
;     110 // ------------------  ��������� ���������� TWI ---------------------------
;     111 // 2 Wire bus interrupt service routine
;     112 interrupt [TWI] void twi_isr(void)
;     113 {
_twi_isr:
	RCALL SUBOPT_0x0
;     114 	// �������� ������ �� ������ ������
;     115          if (TWSR == D_Call ) GlobalAddr =0;								// ��������� �����
	IN   R30,0x1
	CPI  R30,LOW(0x80)
	BRNE _0xA
	CLT
	BLD  R3,0
;     116          if (TWSR == G_Call ) GlobalAddr =1;	          // �������� ��� ���������� ���������
_0xA:
	IN   R30,0x1
	CPI  R30,LOW(0x90)
	BRNE _0xB
	SET
	BLD  R3,0
;     117 
;     118 				if (!(Count1))
_0xB:
	TST  R6
	BRNE _0xC
;     119 						{
;     120 
;     121 							if (!startPacket)
	SBRC R2,3
	RJMP _0xD
;     122 								{						
;     123 									switch	(TWDR)
	IN   R30,0x3
;     124 										{
;     125 											case startPing: 						// ������ ���� ��� ������ ���-�� ���������
	CPI  R30,LOW(0xAA)
	BRNE _0x11
;     126 												{ 
;     127 													ping = 1;  
	SET
	BLD  R2,0
;     128 													break;
	RJMP _0x10
;     129 												}
;     130 											case startPack: 						// ������ ������� ������ ������
_0x11:
	CPI  R30,LOW(0x71)
	BRNE _0x10
;     131 												{ 
;     132 													startPacket = 1;	// ������ �������
	SET
	BLD  R2,3
;     133 													Count	= 0;
	CLR  R7
;     134 													rxBuffer [Count++] = TWDR;			// �������� ���� - � ������
	RCALL SUBOPT_0x4
;     135 													break;
;     136 												}
;     137 										}
_0x10:
;     138 								}
;     139 							else 
	RJMP _0x13
_0xD:
;     140 								{
;     141 									Count1 = TWDR;                  // ������ ������        
	IN   R6,3
;     142 									rxBuffer [Count++] = TWDR;
	RCALL SUBOPT_0x4
;     143 								};
_0x13:
;     144 								
;     145 	    		 		}
;     146 				else
	RJMP _0x14
_0xC:
;     147 						{
;     148 							Count1--;
	DEC  R6
;     149 							rxBuffer[Count++]=TWDR;
	RCALL SUBOPT_0x4
;     150 							if (!(Count1))
	TST  R6
	BRNE _0x15
;     151 								{
;     152 									CRCPackRX	= TWDR;												// ��
	IN   R8,3
;     153 									startPacket = 0;						// ����� ������ ������
	CLT
	BLD  R2,3
;     154 									if (checkCRCrx())	rxPack = 1;	// ��� CRC-ok -������ �����
	RCALL _checkCRCrx
	CPI  R30,0
	BREQ _0x16
	SET
	BLD  R2,4
;     155 								}
_0x16:
;     156 						}
_0x15:
_0x14:
;     157 	    	   
;     158 	                
;     159 
;     160 //          // �������� ��� ���������� ���������
;     161 //         if (TWSR == G_Call ) 
;     162 //                	{
;     163 //                		putchar (TWDR);
;     164 //                	}    
;     165                 
;     166 
;     167 
;     168 		// ���������� � ����� �������������� ������
;     169          if ((TWSR == D_Responce)||(TWSR == Addr_Responce))
	IN   R30,0x1
	CPI  R30,LOW(0xB8)
	BREQ _0x18
	IN   R30,0x1
	CPI  R30,LOW(0xA8)
	BRNE _0x17
_0x18:
;     170          	{
;     171 				if (!(Count3))
	TST  R10
	BRNE _0x1A
;     172 						{
;     173 							if (!txPack) TWDR = 0;
	SBRC R2,5
	RJMP _0x1B
	LDI  R30,LOW(0)
	OUT  0x3,R30
;     174 							else 
	RJMP _0x1C
_0x1B:
;     175 								{
;     176 									Count2=0;
	CLR  R9
;     177 									Count3 = txBuffer [0]+1;
	LDS  R30,_txBuffer
	SUBI R30,-LOW(1)
	MOV  R10,R30
;     178 									TWDR = txBuffer [Count2++]; 
	RCALL SUBOPT_0x5
;     179 									Count3--;
;     180 								}
_0x1C:
;     181 						}
;     182 				else
	RJMP _0x1D
_0x1A:
;     183 						{
;     184 							TWDR = txBuffer [ Count2++];
	RCALL SUBOPT_0x5
;     185 							Count3--;
;     186 							if (!(Count3)) 
	TST  R10
	BRNE _0x1E
;     187 								{
;     188 									txPack = 0;		//����� ���������
	CLT
	BLD  R2,5
;     189 								}
;     190 						}
_0x1E:
_0x1D:
;     191          	}
;     192 
;     193          TWCR = ((1<<TWINT) | (1<<TWEA) | (1<<TWEN) |(1<<TWIE)); //������� ������������� I2C
_0x17:
	LDI  R30,LOW(197)
	OUT  0x36,R30
;     194 }
	RCALL SUBOPT_0x3
	RETI
;     195 //--------------------------------------------------------------------------------------
;     196 
;     197 
;     198 // ������������ ����� ���������
;     199 #include <CDlayer2.c>
;     200 #include <CDlayer3.c>
;     201 flash unsigned char device_name[32] =					// ��� ����������
;     202 		"Main Program. Port";
;     203 eeprom unsigned long my_ser_num = 1;					// �������� ����� ����������

	.ESEG
_my_ser_num:
	.DW  0x1
	.DW  0x0
;     204 const flash unsigned short my_version = 1;			// ������ ����� 

	.CSEG
;     205 //eeprom unsigned char my_addr = TO_MON;					// ��� ����� - ���������� TO_MON
;     206 
;     207 //-----------------------------------------------------------------------------------------------------------------
;     208 //-----------------------------------------------------------------------------------------------------------------
;     209 // ������� �� ������� ������� � ������� �����
;     210 void ToWorkMode(void)
;     211 {
_ToWorkMode:
;     212 
;     213 	// ��������� �����
;     214 	txBuffer[0] = 1;        						// ����������� �����
	RCALL SUBOPT_0x6
;     215 	txBuffer[1] = 1;        						// ����������� �����
	__PUTB1MN _txBuffer,1
;     216 
;     217 	txPack = 1;								// ���� ������
	SET
	BLD  R2,5
;     218 }
	RET
;     219 // ���������� ��������� ������ ����������
;     220 static void SetSerial(void)
;     221 {
_SetSerial_G1:
;     222 /*	#define ssp ((RQ_SETSERIAL *)rx0buf)
;     223 	
;     224 	if (my_ser_num)
;     225 	{
;     226 		txBuffer[0] = 2;  			//�����
;     227 		txBuffer[1] = (RES_ERR);		
;     228 		txBuffer[2] = 2;          // ��
;     229 
;     230 		txPack = 1;		// ���� ����� �� ��������
;     231 
;     232 		return;
;     233 	}
;     234 	
;     235 	my_ser_num = ssp->num;*/
;     236 	
;     237 		txBuffer[0] = 2;  			//�����
	RCALL SUBOPT_0x7
;     238 		txBuffer[1] = (RES_OK);		
	LDI  R30,LOW(1)
	__PUTB1MN _txBuffer,1
;     239 		txBuffer[2] = 2+(RES_OK);          // ��
	LDI  R30,LOW(3)
	__PUTB1MN _txBuffer,2
;     240 
;     241 		txPack = 1;		// ���� ����� �� ��������
	SET
	BLD  R2,5
;     242 }
	RET
;     243 
;     244 //  ���������� ������ ����������
;     245 void Setaddr (void)
;     246 	{
_Setaddr:
;     247 		txBuffer[0] = 2;  			//�����
	RCALL SUBOPT_0x7
;     248 		txBuffer[1] = 0;		
	LDI  R30,LOW(0)
	__PUTB1MN _txBuffer,1
;     249 		txBuffer[2] = 2;          // ��
	LDI  R30,LOW(2)
	__PUTB1MN _txBuffer,2
;     250 
;     251 		txPack = 1;		// ���� ����� �� ��������
	SET
	BLD  R2,5
;     252 	}
	RET
;     253 
;     254 // ������������ � ����� ����������������
;     255 static void ToProg(void)
;     256 {
_ToProg_G1:
;     257 	// ��������� �����
;     258 		txBuffer[0] = 1;  			//�����
	RCALL SUBOPT_0x6
;     259 		txBuffer[1] = 1;          // ��
	__PUTB1MN _txBuffer,1
;     260 		
;     261 		txPack = 1;				// ���� ����� �� ��������
	SET
	BLD  R2,5
;     262 		to_Reboot = 1;			//  �� ������������ � ���������
	BLD  R3,1
;     263 //}
;     264   		while (txPack);			// ���� ���� ���������� ����� �
_0x1F:
	SBRC R2,5
	RJMP _0x1F
;     265 //void reboot (void)
;     266 //{		
;     267 //    	delay_ms(25);
;     268 		// �� ������������ � �������
;     269 		IVCREG = 1 << IVCE;
	LDI  R30,LOW(1)
	OUT  0x3B,R30
;     270 		IVCREG = 1 << IVSEL;
	LDI  R30,LOW(2)
	OUT  0x3B,R30
;     271 		#asm("rjmp 0xC00");
	rjmp 0xC00
;     272 }
	RET
;     273 
;     274 
;     275 // ��������� ��������� ����������
;     276 const char _PT_GETSTATE_[]={20,2,0,'P','o','r','t',' ','R','S','-','2','3','2',' ',' ',' ',' ',100,255};
;     277 static void GetState(void)
;     278 {
_GetState_G1:
;     279 	register unsigned char a=0, crc=0;
;     280 
;     281 		if (!(rxBuffer[4]))	
	RCALL __SAVELOCR2
;	a -> R16
;	crc -> R17
	LDI  R16,0
	LDI  R17,0
	__GETB1MN _rxBuffer,4
	CPI  R30,0
	BRNE _0x22
;     282 			{
;     283 				memcpyf(txBuffer, _PT_GETSTATE_, _PT_GETSTATE_[0]+1); // 0 �����
	RCALL SUBOPT_0x8
	LDI  R30,LOW(__PT_GETSTATE_*2)
	LDI  R31,HIGH(__PT_GETSTATE_*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(__PT_GETSTATE_*2)
	LDI  R31,HIGH(__PT_GETSTATE_*2)
	LPM  R30,Z
	RCALL SUBOPT_0x9
	RCALL _memcpyf
;     284 			}
;     285 		else                                                                                                             // 1 �����
	RJMP _0x23
_0x22:
;     286 			{
;     287 				txBuffer[a++] = 5;				 			// ����� ������
	MOV  R30,R16
	SUBI R16,-1
	RCALL SUBOPT_0xA
	LDI  R30,LOW(5)
	RCALL SUBOPT_0xB
;     288 				txBuffer[a++] = 0;
	SUBI R16,-1
	RCALL SUBOPT_0xA
	LDI  R30,LOW(0)
	RCALL SUBOPT_0xB
;     289 				txBuffer[a++] = pAddr;
	SUBI R16,-1
	RCALL SUBOPT_0xC
	ST   Z,R4
;     290 				txBuffer[a++] = lAddr;
	MOV  R30,R16
	SUBI R16,-1
	RCALL SUBOPT_0xC
	ST   Z,R5
;     291 				txBuffer[a++] = 255;
	MOV  R30,R16
	SUBI R16,-1
	RCALL SUBOPT_0xA
	LDI  R30,LOW(255)
	ST   X,R30
;     292 			}
_0x23:
;     293 
;     294 		for (a=0;a<=txBuffer[0]-1;a++) crc += txBuffer[a];	//KC
	LDI  R16,LOW(0)
_0x25:
	RCALL SUBOPT_0xD
	CP   R30,R16
	BRLO _0x26
	MOV  R30,R16
	RCALL SUBOPT_0xC
	LD   R30,Z
	ADD  R17,R30
;     295 
;     296 		txBuffer[a] = crc;
	SUBI R16,-1
	RJMP _0x25
_0x26:
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_txBuffer)
	SBCI R27,HIGH(-_txBuffer)
	ST   X,R17
;     297 		txPack = 1;		// ���� ����� �� ��������
	SET
	BLD  R2,5
;     298 } 
	RJMP _0x6D
;     299 
;     300 // ���������� �� ����������:
;     301 
;     302 static void GetInfo(void)
;     303 {
_GetInfo_G1:
;     304 	register unsigned char i,a=0,crc=0;                    
;     305 	
;     306 	// 	�������� �����
;     307 	txBuffer[0] = 40+1;
	RCALL __SAVELOCR3
;	i -> R16
;	a -> R17
;	crc -> R18
	LDI  R17,0
	LDI  R18,0
	LDI  R30,LOW(41)
	STS  _txBuffer,R30
;     308 	
;     309 	for (i = 0; i < 32; i ++)	// ��� ����������
	LDI  R16,LOW(0)
_0x28:
	CPI  R16,32
	BRSH _0x29
;     310 	{
;     311 		txBuffer[i+1] = device_name[i];
	RCALL SUBOPT_0xE
	__ADDW1MN _txBuffer,1
	MOVW R26,R30
	RCALL SUBOPT_0xE
	SUBI R30,LOW(-_device_name*2)
	SBCI R31,HIGH(-_device_name*2)
	LPM  R30,Z
	ST   X,R30
;     312 	}
	SUBI R16,-1
	RJMP _0x28
_0x29:
;     313 
;     314 		txBuffer[33] = my_ser_num;           // �������� �����
	LDI  R26,LOW(_my_ser_num)
	LDI  R27,HIGH(_my_ser_num)
	RCALL __EEPROMRDD
	__PUTB1MN _txBuffer,33
;     315 		txBuffer[34] = my_ser_num>>8;      // �������� �����
	LDI  R26,LOW(_my_ser_num)
	LDI  R27,HIGH(_my_ser_num)
	RCALL __EEPROMRDD
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(8)
	RCALL __LSRD12
	__PUTB1MN _txBuffer,34
;     316 
;     317 		txBuffer[35] = 0;	// �������� �����
	LDI  R30,LOW(0)
	__PUTB1MN _txBuffer,35
;     318 		txBuffer[36] = 0;	// �������� �����
	__PUTB1MN _txBuffer,36
;     319 	
;     320 		txBuffer[37] =pAddr ;     // ����� ����������
	__PUTBMRN _txBuffer,37,4
;     321 
;     322 		txBuffer[38] =0;     // ����������������� ����
	__PUTB1MN _txBuffer,38
;     323 	
;     324 		txBuffer[39] = my_version;             // ������
	__POINTW2MN _txBuffer,39
	LDI  R30,LOW(_my_version*2)
	LDI  R31,HIGH(_my_version*2)
	RCALL __GETW1PF
	ST   X,R30
;     325 		txBuffer[40] = my_version>>8;		// ������
	LDI  R30,LOW(_my_version*2)
	LDI  R31,HIGH(_my_version*2)
	RCALL __GETW1PF
	MOV  R30,R31
	LDI  R31,0
	__PUTB1MN _txBuffer,40
;     326 		
;     327 		for (a=0;a<=txBuffer[0]-1;a++) crc += txBuffer[a];	//KC
	LDI  R17,LOW(0)
_0x2B:
	RCALL SUBOPT_0xD
	CP   R30,R17
	BRLO _0x2C
	RCALL SUBOPT_0xF
	LD   R30,Z
	ADD  R18,R30
;     328 		txBuffer[41] = crc;
	SUBI R17,-1
	RJMP _0x2B
_0x2C:
	__PUTBMRN _txBuffer,41,18
;     329 	
;     330 
;     331 		txPack = 1;		// ���� ����� �� �������� 
	SET
	BLD  R2,5
;     332 }
	RCALL __LOADLOCR3
	ADIW R28,3
	RET
;     333 
;     334 
;     335 // ��������. ��������� ������ �� ��������
;     336 void _GetLogAddr (void)
;     337 	{
__GetLogAddr:
;     338 	
;     339 		txBuffer[0] = 2;				 			// ����� ������
	RCALL SUBOPT_0x7
;     340 		txBuffer[1] = lAddr;		  			// ���. �����
	__PUTBMRN _txBuffer,1,5
;     341 		txBuffer[2] = 2+lAddr;	 			//��  
	MOV  R30,R5
	SUBI R30,-LOW(2)
	__PUTB1MN _txBuffer,2
;     342 
;     343 		txPack = 1;		// ���� ����� �� ��������
	SET
	BLD  R2,5
;     344 	
;     345 	}  
	RET
;     346 	
;     347 // ���������� ������
;     348 void _OP (unsigned char c)
;     349 	{
;     350 		unsigned char a =0, b;
;     351 
;     352 		txBuffer[0] = c;					// ����� ������
;	c -> Y+2
;	a -> R16
;	b -> R17
;     353 
;     354 		for (b=0;b< txBuffer [0]; b++)
;     355 			{
;     356 				a=a+txBuffer [b];
;     357 			}                            
;     358 			
;     359 		txBuffer [b] = a;					//KC
;     360 
;     361 		txPack = 1;		// ���� ����� �� ��������
;     362 		
;     363 	}
;     364 
;     365 static void give_GETINFO (void)
;     366 {
_give_GETINFO_G1:
;     367 	
;     368 	// 	������� ������  ���� ����������
;     369 			putchar ('q');						// ���������
	LDI  R30,LOW(113)
	RCALL SUBOPT_0x10
;     370 			putchar (3);							// ����� ���� ����� �����
	RCALL SUBOPT_0x11
;     371 			putchar (255);		 				//  ����� (�����������)
	LDI  R30,LOW(255)
	RCALL SUBOPT_0x10
;     372 			putchar (PT_GETINFO);		// ��� ������
	RCALL SUBOPT_0x11
;     373 			putchar ((PT_GETINFO)+(255)+3+('q'));
	LDI  R30,LOW(374)
	RCALL SUBOPT_0x10
;     374 				
;     375 }
	RET
;     376 
;     377 // ������� CRC ��������� �������
;     378 unsigned char checkCRCrx (void)
;     379 	{
_checkCRCrx:
;     380 		unsigned char a =0, b; 
;     381 		for (b=0;b<= rxBuffer [1]; b++)
	RCALL __SAVELOCR2
;	a -> R16
;	b -> R17
	LDI  R16,0
	LDI  R17,LOW(0)
_0x31:
	__GETB1MN _rxBuffer,1
	CP   R30,R17
	BRLO _0x32
;     382 			{
;     383 				a=a+rxBuffer [b];
	MOV  R30,R17
	LDI  R31,0
	RCALL SUBOPT_0x12
	ADD  R16,R30
;     384 			} 
	SUBI R17,-1
	RJMP _0x31
_0x32:
;     385 		if (a == CRCPackRX) return 255;	 	//Ok
	CP   R8,R16
	BRNE _0x33
	LDI  R30,LOW(255)
	RJMP _0x6D
;     386 		else return 0;
_0x33:
	LDI  R30,LOW(0)
	RJMP _0x6D
;     387 	}
;     388 
;     389 // ������� CRC ����������� �������
;     390 unsigned char checkCRCtx (void)
;     391 	{
_checkCRCtx:
;     392 		unsigned char a =0, b;    
;     393 
;     394 		for (b=0;b< txBuffer [0]; b++)
	RCALL __SAVELOCR2
;	a -> R16
;	b -> R17
	LDI  R16,0
	LDI  R17,LOW(0)
_0x36:
	LDS  R30,_txBuffer
	CP   R17,R30
	BRSH _0x37
;     395 			{
;     396 				a=a+txBuffer [b];
	RCALL SUBOPT_0xF
	LD   R30,Z
	ADD  R16,R30
;     397 			} 
	SUBI R17,-1
	RJMP _0x36
_0x37:
;     398 			
;     399 		if (a == txBuffer [b]) 
	RCALL SUBOPT_0xF
	LD   R30,Z
	CP   R30,R16
	BRNE _0x38
;     400 			{
;     401 				return 255;	 	//Ok
	LDI  R30,LOW(255)
	RJMP _0x6D
;     402 			}
;     403 		else return 0;
_0x38:
	LDI  R30,LOW(0)
;     404 	}
_0x6D:
	RCALL __LOADLOCR2P
	RET
;     405 
;     406 // ������������ �������� �����
;     407 void workINpack ( void )
;     408 		{
_workINpack:
;     409 			unsigned char a;
;     410 
;     411 		if (rxBuffer[2]==0)				// ��������� �����. 0-���������.���������-�������������
	ST   -Y,R16
;	a -> R16
	__GETB1MN _rxBuffer,2
	CPI  R30,0
	BRNE _0x3A
;     412 			{
;     413 					switch (rxBuffer[3])
	__GETB1MN _rxBuffer,3
;     414 						{
;     415 							case GetLogAddr:				// ���������� ���. �����
	CPI  R30,LOW(0x1)
	BRNE _0x3E
;     416 									_GetLogAddr ();		
	RCALL __GetLogAddr
;     417 									rxPack = 0;				// ����� ���������
	CLT
	BLD  R2,4
;     418 									break;
	RJMP _0x3D
;     419 
;     420 							case OP:							// ���������� ������
_0x3E:
	CPI  R30,LOW(0x64)
	BRNE _0x40
;     421 									readAddrDevice(); 
	RCALL _readAddrDevice
;     422 									rxPack = 0;				// ����� ���������
	CLT
	BLD  R2,4
;     423 									break;
	RJMP _0x3D
;     424 
;     425 /*							case pingPack :
;     426 //									LedInv();
;     427 
;     428 									if (rxPackUART) 
;     429 										{
;     430 											txPack = 1;		 	// ���� ����� �� ��������
;     431 											rxPackUART = 0;	// ����� ���������
;     432 										}
;     433 									if (to_Reboot) reboot(); 		
;     434 
;     435 									rxPack = 0;					// ����� ���������
;     436 									break; */
;     437 
;     438 							default:
_0x40:
;     439 									rxPack = 0;					// ����� ���������
	CLT
	BLD  R2,4
;     440 										
;     441 						}
_0x3D:
;     442             }
;     443 		else if (rxBuffer[2]==pAddr) 							////////////// ��� �����. ���������� �� ���
	RJMP _0x41
_0x3A:
	__GETB2MN _rxBuffer,2
	CP   R4,R26
	BRNE _0x42
;     444 			{
;     445 					switch (rxBuffer[3])
	__GETB1MN _rxBuffer,3
;     446 						{
;     447 							case PT_GETINFO:			// ���������� � ���� ����������
	CPI  R30,LOW(0x3)
	BRNE _0x46
;     448 //print = 1;
;     449 									GetInfo();
	RCALL _GetInfo_G1
;     450 									rxPack = 0;					// ����� ���������
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
;     455 									rxPack = 0;					// ����� ���������
	CLT
	BLD  R2,4
;     456 									break;
	RJMP _0x45
;     457 
;     458 					 		case PT_TOPROG:       			// ��������� � ����������������
_0x47:
	CPI  R30,LOW(0x7)
	BRNE _0x48
;     459 									ToProg();
	RCALL _ToProg_G1
;     460 									rxPack = 0;					// ����� ���������
	CLT
	BLD  R2,4
;     461 									break;      
	RJMP _0x45
;     462 
;     463 					 		case PT_SETADDR:       			// ��������� � ����������������
_0x48:
	CPI  R30,LOW(0x4)
	BRNE _0x49
;     464 									Setaddr();
	RCALL SUBOPT_0x13
;     465 									rxPack = 0;					// ����� ���������
	BLD  R2,4
;     466 									break;      
	RJMP _0x45
;     467 					 		case PT_SETSERIAL:       			// ��������� � ����������������
_0x49:
	CPI  R30,LOW(0x5)
	BRNE _0x4B
;     468 									SetSerial();
	RCALL SUBOPT_0x14
;     469 									rxPack = 0;					// ����� ���������
	BLD  R2,4
;     470 									break;      
	RJMP _0x45
;     471 
;     472 
;     473 							default:
_0x4B:
;     474 									rxPack = 0;					// ����� ���������
	CLT
	BLD  R2,4
;     475 						}
_0x45:
;     476               }
;     477 		else	if(rxBuffer[2] == TO_MON)					// ������������ ����� �� ������ MONITOR
	RJMP _0x4C
_0x42:
	__GETB1MN _rxBuffer,2
	CPI  R30,LOW(0xFE)
	BRNE _0x4D
;     478 			{
;     479 					switch (rxBuffer[3])
	__GETB1MN _rxBuffer,3
;     480 						{
;     481 					 		case PT_SETADDR:       			// ��������� � ����������������
	CPI  R30,LOW(0x4)
	BRNE _0x51
;     482 									Setaddr();
	RCALL SUBOPT_0x13
;     483 									rxPack = 0;					// ����� ���������
	BLD  R2,4
;     484 									break;      
	RJMP _0x50
;     485 					 		case PT_SETSERIAL:       			// ��������� � ����������������
_0x51:
	CPI  R30,LOW(0x5)
	BRNE _0x52
;     486 									SetSerial();
	RCALL SUBOPT_0x14
;     487 									rxPack = 0;					// ����� ���������
	BLD  R2,4
;     488 									break; 
	RJMP _0x50
;     489 					 		case PT_TOWORK:       			// ��������� � ����������������
_0x52:
	CPI  R30,LOW(0xB)
	BRNE _0x54
;     490 									ToWorkMode();
	RCALL _ToWorkMode
;     491 									rxPack = 0;					// ����� ���������
	CLT
	BLD  R2,4
;     492 									break; 
	RJMP _0x50
;     493 									     
;     494 							default:
_0x54:
;     495 									rxPack = 0;					// ����� ���������
	CLT
	BLD  R2,4
;     496 						}                                                                               
_0x50:
;     497 			}
;     498 		else
	RJMP _0x55
_0x4D:
;     499 				{ 												///////////// ����� �������������. ������ ��� ��������� ��������� TWI
;     500 					if (!(GlobalAddr))
	SBRC R3,0
	RJMP _0x56
;     501 						{
;     502 							for (a = 0;a<= (rxBuffer[1]+1); a++) putchar (rxBuffer [a]);
	LDI  R16,LOW(0)
_0x58:
	__GETB1MN _rxBuffer,1
	SUBI R30,-LOW(1)
	CP   R30,R16
	BRLO _0x59
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x10
;     503         				}
	SUBI R16,-1
	RJMP _0x58
_0x59:
;     504 					rxPack = 0;					// ����� ���������
_0x56:
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
;     508 // ��������� ������, ��������� �� UART
;     509 	void workUARTpack (void)
;     510 		{
_workUARTpack:
;     511 			#asm("cli")
	cli
;     512 			memcpy(txBuffer, rxBufferUART, rxBufferUART[0]+1); // 0 �����
	RCALL SUBOPT_0x8
	LDI  R30,LOW(_rxBufferUART)
	LDI  R31,HIGH(_rxBufferUART)
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_rxBufferUART
	RCALL SUBOPT_0x9
	RCALL _memcpy
;     513 			#asm("sei")
	sei
;     514 
;     515 			txPack = 1;							// ���� ����� �� ��������
	SET
	BLD  R2,5
;     516 			rxPackUART = 0;				// ����� ���������
	CLT
	BLD  R2,6
;     517 		}			
	RET
;     518 		
;     519 
;     520 
;     521 // ----------------------- ��������� ���������� ������� 0 (����-��� RS232) --------
;     522 // Timer 0 overflow interrupt service routine
;     523 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;     524 {
_timer0_ovf_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
;     525 	TCCR0=0x00;										// ������������� ������
	RCALL SUBOPT_0x15
;     526 	time_is_Out =1;		// ������� ������� ��������� ��������
	SET
	BLD  R2,2
;     527 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;     528 //--------------------------------------------------------------------------------------
;     529 
;     530 // ----------------------- ��������� ���������� ������� 1 ( ����� ����������� ������ 10 �) --------
;     531 // Timer 1 overflow interrupt service routine
;     532 interrupt [TIM1_OVF] void timer1_ovf_isr(void)
;     533 {
_timer1_ovf_isr:
	ST   -Y,R30
	IN   R30,SREG
;     534 	tstPort = 1;						// ���� ��������� ���������� ������������ �� ?
	SET
	BLD  R2,7
;     535 }
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;     536 
;     537 
;     538 
;     539 
;     540 
;     541 // ������� ������ ��������
;     542 void timeOutStart (void)
;     543 		{
_timeOutStart:
;     544 			time_is_Out = 0;			// ����� ����� ��������
	CLT
	BLD  R2,2
;     545 			TCNT0=0x00;
	RCALL SUBOPT_0x16
;     546 			TCCR0=0x05;      									// ������� ������
	LDI  R30,LOW(5)
	OUT  0x33,R30
;     547 		}
	RET
;     548 
;     549 // ������� ������ ��������
;     550 void timeOutStop (void)
;     551 		{
_timeOutStop:
;     552 			TCCR0=0x0;      									// ������� �������
	RCALL SUBOPT_0x15
;     553 		}
	RET
;     554 
;     555 // ������� ����������� ����������� ������ ����� � ������
;     556 // �� ��������� ���� (0���) �������� ����������
;     557 void inidevice (void)
;     558 		{                                      
_inidevice:
;     559 		pAddr = ((PINC & 0x7)+1 );			// ���������� ���������� ����� (0-�� ���. �.�. ����. �����)
	IN   R30,0x13
	ANDI R30,LOW(0x7)
	SUBI R30,-LOW(1)
	MOV  R4,R30
;     560 		TWAR = (pAddr<<1)+1;					// ������������� ��� ��� TWI
	RCALL SUBOPT_0x17
;     561 
;     562 //		while (! ping);								// ���� ������ ���� 0���
;     563 
;     564 		}                                  
	RET
;     565 		
;     566 // ����� ����� �� UART. ������������ ����-�����		
;     567 unsigned char havechar(void)
;     568 {
;     569 	timeOutStart ();													// ������� ������
;     570 	while (!( UCSRA & (1 << RXC)))
;     571 		{
;     572    		    if (time_is_Out)	
;     573    		    	{
;     574 	                dPresent = 0;					//  ���������� �� ��������
;     575 					timeOutStop ();				// ������� �������
;     576    			    	return 0;						// ���� ��� ����� �� ��������� �������
;     577    		    	}
;     578 		}
;     579 	timeOutStop ();								// ������� �������
;     580     dPresent = 1;									//������� ������� ������� ����������
;     581 
;     582 	return 255;
;     583 }
;     584 
;     585 
;     586 // ��������� ��� ���������� � ���� RS232
;     587 // ���� ���� ���������� - ���������� ����� � ������ � ������� �������
;     588 // ���� ��� ������ - ��������� �� �����������. ������������ ��������� ����������
;     589 void 	readAddrDevice (void)                                                          
;     590 		{
_readAddrDevice:
;     591 				give_GETINFO();
	RCALL _give_GETINFO_G1
;     592 
;     593 				timeOutStart();
	RCALL _timeOutStart
;     594 				while (!(rxPackUART))					// ���� ������
_0x5E:
	SBRC R2,6
	RJMP _0x60
;     595 				{
;     596 					if (time_is_Out )
	SBRS R2,2
	RJMP _0x61
;     597 						{
;     598 							LedOn();								// ������� ����������� ��� ��������� �����
	CBI  0x12,3
;     599 			                dPresent = 0;			 				//  ���������� �� ��������
	CLT
	BLD  R2,1
;     600 		    	            lAddr = 0;					 			// ����� = 0
	CLR  R5
;     601 							break;
	RJMP _0x60
;     602 						} 
;     603 					else  
_0x61:
;     604 						{
;     605 							LedInv();
	CLT
	SBIS 0x12,3
	SET
	IN   R26,0x12
	BLD  R26,3
	OUT  0x12,R26
;     606 							tstPort = 0;						// ���������� ������������
	CLT
	BLD  R2,7
;     607 							dPresent = 1;						// �������� 
	SET
	BLD  R2,1
;     608 //							lAddr = txBuffer [37];			// �������� ����� �� ��������� �����             
;     609 							lAddr = rxBufferUART [37];			// �������� ����� �� ��������� �����             
	__GETBRMN 5,_rxBufferUART,37
;     610 							LedOff();							// ����� ��������� �������
	SBI  0x12,3
;     611 							
;     612 						}
;     613 					
;     614 				}        
	RJMP _0x5E
_0x60:
;     615 				timeOutStop();
	RCALL _timeOutStop
;     616 								
;     617 				
;     618 //				if (dPresent) txPack = 1;					// ���� ����� �� ��������
;     619 				rxPackUART = 0;							// �������� ����� - � ��������
	CLT
	BLD  R2,6
;     620 		}
	RET
;     621 
;     622 
;     623 void _print (unsigned char data)
;     624 	{
;     625 	unsigned char a=0, crc =0 ;
;     626 				txBuffer[a++] = 3;				 			// ����� ������
;	data -> Y+2
;	a -> R16
;	crc -> R17
;     627 				txBuffer[a++] = 0xaa;		  			// ���. �����
;     628 				txBuffer[a++] = data;		
;     629 
;     630 				for (a=0;a<=txBuffer[0]-1;a++) crc += txBuffer[a];	//KC
;     631 				txBuffer[a] = crc;
;     632 	
;     633 
;     634 				txPack = 1;		// ���� ����� �� �������� 
;     635 
;     636 
;     637 	}
;     638 
;     639 void main(void)
;     640 {
_main:
;     641 // Declare your local variables here
;     642 
;     643 // Input/Output Ports initialization
;     644 
;     645 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
;     646 DDRB=0x00;
	OUT  0x17,R30
;     647 
;     648 PORTC=0x07;
	LDI  R30,LOW(7)
	OUT  0x15,R30
;     649 DDRC=0x00;
	LDI  R30,LOW(0)
	OUT  0x14,R30
;     650 
;     651 PORTD=0x00;
	OUT  0x12,R30
;     652 DDRD=0x1C;
	LDI  R30,LOW(28)
	OUT  0x11,R30
;     653 
;     654 // Timer/Counter 0 initialization
;     655 // Clock source: System Clock
;     656 // Clock value: 7,813 kHz
;     657 TCCR0=0x00;
	RCALL SUBOPT_0x15
;     658 TCNT0=0x00;
	RCALL SUBOPT_0x16
;     659 
;     660 
;     661 // Timer/Counter 1 initialization
;     662 // Clock source: System Clock
;     663 // Clock value: 7,813 kHz
;     664 // Mode: Normal top=FFFFh
;     665 // OC1A output: Discon.
;     666 // OC1B output: Discon.
;     667 // Noise Canceler: On
;     668 // Input Capture on Falling Edge
;     669 // Timer 1 Overflow Interrupt: On
;     670 // Input Capture Interrupt: Off
;     671 // Compare A Match Interrupt: Off
;     672 // Compare B Match Interrupt: Off
;     673 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
;     674 TCCR1B=0x85;
	LDI  R30,LOW(133)
	OUT  0x2E,R30
;     675 TCNT1H=0x00;
	RCALL SUBOPT_0x1
;     676 TCNT1L=0x00;
;     677 ICR1H=0x67;
	LDI  R30,LOW(103)
	OUT  0x27,R30
;     678 ICR1L=0x69;
	LDI  R30,LOW(105)
	OUT  0x26,R30
;     679 OCR1AH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2B,R30
;     680 OCR1AL=0x00;
	OUT  0x2A,R30
;     681 OCR1BH=0x00;
	OUT  0x29,R30
;     682 OCR1BL=0x00;
	OUT  0x28,R30
;     683 
;     684 // Timer/Counter 2 initialization
;     685 // Clock source: System Clock
;     686 // Clock value: Timer 2 Stopped
;     687 // Mode: Normal top=FFh
;     688 // OC2 output: Disconnected
;     689 ASSR=0x00;
	OUT  0x22,R30
;     690 TCCR2=0x00;
	OUT  0x25,R30
;     691 TCNT2=0x00;
	OUT  0x24,R30
;     692 OCR2=0x00;
	OUT  0x23,R30
;     693 
;     694 // External Interrupt(s) initialization
;     695 // INT0: Off
;     696 // INT1: Off
;     697 MCUCR=0x00;
	OUT  0x35,R30
;     698 
;     699 // Timer(s)/Counter(s) Interrupt(s) initialization
;     700 TIMSK=0x05;
	LDI  R30,LOW(5)
	OUT  0x39,R30
;     701 
;     702 
;     703 // USART initialization
;     704 // Communication Parameters: 8 Data, 1 Stop, No Parity
;     705 // USART Receiver: On
;     706 // USART Transmitter: On
;     707 // USART Mode: Asynchronous
;     708 // USART Baud rate: 38400
;     709 UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
;     710 UCSRB=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
;     711 UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
;     712 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
;     713 UBRRL=0x0C;
	LDI  R30,LOW(12)
	OUT  0x9,R30
;     714 
;     715 
;     716 // Analog Comparator initialization
;     717 // Analog Comparator: Off
;     718 // Analog Comparator Input Capture by Timer/Counter 1: Off
;     719 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     720 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;     721 
;     722 // 2 Wire Bus initialization
;     723 // Generate Acknowledge Pulse: On
;     724 // 2 Wire Bus Slave Address: 8h
;     725 // General Call Recognition: On
;     726 // Bit Rate: 400,000 kHz
;     727 TWSR=0x00;
	OUT  0x1,R30
;     728 TWBR=0x02;
	LDI  R30,LOW(2)
	OUT  0x0,R30
;     729 TWAR=(pAddr<<1)+1;
	RCALL SUBOPT_0x17
;     730 TWCR=0x45;
	LDI  R30,LOW(69)
	OUT  0x36,R30
;     731 
;     732 // Global enable interrupts
;     733 #asm("sei")
	sei
;     734 
;     735 	    LedOff();
	SBI  0x12,3
;     736 		inidevice();  						// ���� ������������
	RCALL _inidevice
;     737 	    LedOn();                                                              
	CBI  0x12,3
;     738 while (1)
_0x66:
;     739       {       
;     740 
;     741 //		if ((!(dPresent)) || (tstPort)) readAddrDevice(); 	 	// ���� ��� ���������� - ���� ���
;     742 		if (tstPort) readAddrDevice(); 	 	// ���� ��� ���������� - ���� ���
	SBRC R2,7
	RCALL _readAddrDevice
;     743 		if (rxPack) workINpack();			// ������ ����� TWI 
	SBRC R2,4
	RCALL _workINpack
;     744 		if (rxPackUART) workUARTpack();			// ������������ �������� �����UART
	SBRC R2,6
	RCALL _workUARTpack
;     745 
;     746 
;     747       };
	RJMP _0x66
;     748 }
_0x6C:
	RJMP _0x6C

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
	SUBI R30,LOW(-_rxBufferUART)
	SBCI R31,HIGH(-_rxBufferUART)
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
	DEC  R10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6:
	LDI  R30,LOW(1)
	STS  _txBuffer,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x7:
	LDI  R30,LOW(2)
	STS  _txBuffer,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x8:
	LDI  R30,LOW(_txBuffer)
	LDI  R31,HIGH(_txBuffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x9:
	SUBI R30,-LOW(1)
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xA:
	LDI  R31,0
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xB:
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0xC:
	LDI  R31,0
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xD:
	LDS  R30,_txBuffer
	SUBI R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xE:
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xF:
	MOV  R30,R17
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0x10:
	ST   -Y,R30
	RJMP _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x11:
	LDI  R30,LOW(3)
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x12:
	SUBI R30,LOW(-_rxBuffer)
	SBCI R31,HIGH(-_rxBuffer)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x13:
	RCALL _Setaddr
	CLT
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x14:
	RCALL _SetSerial_G1
	CLT
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x15:
	LDI  R30,LOW(0)
	OUT  0x33,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x16:
	LDI  R30,LOW(0)
	OUT  0x32,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x17:
	MOV  R30,R4
	LSL  R30
	SUBI R30,-LOW(1)
	OUT  0x2,R30
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
