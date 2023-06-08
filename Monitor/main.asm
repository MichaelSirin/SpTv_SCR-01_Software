;CodeVisionAVR C Compiler V1.24.7e Professional
;(C) Copyright 1998-2005 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega8
;Program type           : Boot Loader
;Clock frequency        : 4,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External SRAM size     : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : No
;char is unsigned       : Yes
;8 bit enums            : No
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
	.ORG 0xC00

	.INCLUDE "main.vec"
	.INCLUDE "main.inc"

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF THE BOOT LOADER
	LDI  R31,1
	OUT  GICR,R31
	LDI  R31,2
	OUT  GICR,R31
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
;       1 ////////////////////////////////////////////////////////////////////////////////////////////////////////
;       2 // Монитор - загрузчик FLASH и EEPROM. Работает по TWI
;       3 ////////////////////////////////////////////////////////////////////////////////////////////////////////
;       4 #include "monitor.h" 
;       5 #include "CodingM8.h"      
;       6 #include "stdio.h"  
;       7 #include "string.h"  
;       8 
;       9 
;      10 eeprom unsigned char device_name[32] =					// Имя устройства

	.ESEG
_device_name:
;      11 		"BOOT PROGRAM. Mega 8L ";
	.DB  0x42
	.DB  0x4F
	.DB  0x4F
	.DB  0x54
	.DB  0x20
	.DB  0x50
	.DB  0x52
	.DB  0x4F
	.DB  0x47
	.DB  0x52
	.DB  0x41
	.DB  0x4D
	.DB  0x2E
	.DB  0x20
	.DB  0x4D
	.DB  0x65
	.DB  0x67
	.DB  0x61
	.DB  0x20
	.DB  0x38
	.DB  0x4C
	.DB  0x20
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
;      12 //eeprom unsigned long my_ser_num = 1;					// Серийный номер устройства
;      13 #define  my_ser_num  1					// Серийный номер устройства
;      14 
;      15 const flash unsigned short my_version_high = 1;				// Версия софта 

	.CSEG
;      16 const flash unsigned short my_version_low = 1;				// Версия софта 
;      17 
;      18 eeprom unsigned char my_addr = TO_MON;					// Мой адрес - изначально TO_MON

	.ESEG
_my_addr:
	.DB  0xFE
;      19     
;      20 
;      21 const   unsigned int scrambling_seed = 333;

	.CSEG
;      22 
;      23 //unsigned char pAddr;				// Адрес устройства по шине TWI
;      24 //unsigned char adr;									// адрес в пришедшем пакете
;      25 unsigned char rxPack;							// принят пакет TWI
;      26 
;      27 // Все для работы с TWI
;      28 TWISR TWI_statusReg;   

	.DSEG
_TWI_statusReg:
	.BYTE 0x1
;      29 unsigned char 	TWI_slaveAddress = MY_TWI_ADDRESS;		// Own TWI slave address
;      30 
;      31 
;      32 bit		TWI_TX_Packet_Present				=		0;					// есть данные на передачу
;      33 bit		toReboot										=		0;					// перезагружаем в рабочую программу
;      34 bit		toProgramming								=		0;					// нас программируют
;      35 	
;      36 unsigned char txBufferTWI 			[TWI_BUFFER_SIZE/4];		// передающий буфер
_txBufferTWI:
	.BYTE 0x3E
;      37 unsigned char rxBufferTWI	[TWI_BUFFER_SIZE];	// приемный буфер
_rxBufferTWI:
	.BYTE 0xFA
;      38 
;      39 
;      40 // Вернуть информацию о мониторе и процессоре
;      41 void PrgInfo(void)
;      42 {

	.CSEG
_PrgInfo:
;      43 	// Отправляю ответ
;      44 //	#asm("wdr");
;      45 	txBufferTWI[Start_Position_for_Reply] = (sizeof(RP_PRGINFO) +1);
	LDI  R30,LOW(9)
	__PUTB1MN _txBufferTWI,2
;      46 
;      47 	txBufferTWI[Start_Position_for_Reply+1] = (PAGESIZ);     			//мл.
	LDI  R30,LOW(64)
	__PUTB1MN _txBufferTWI,3
;      48 	txBufferTWI[Start_Position_for_Reply+2] = (PAGESIZ>>8);          //ст.
	LDI  R30,LOW(0)
	__PUTB1MN _txBufferTWI,4
;      49 
;      50 	txBufferTWI[Start_Position_for_Reply+3] = (PRGPAGES);
	LDI  R30,LOW(96)
	__PUTB1MN _txBufferTWI,5
;      51 	txBufferTWI[Start_Position_for_Reply+4] = (PRGPAGES>>8);
	LDI  R30,LOW(0)
	__PUTB1MN _txBufferTWI,6
;      52 
;      53 	txBufferTWI[Start_Position_for_Reply+5] = (EEPROMSIZ);
	LDI  R30,LOW(512)
	__PUTB1MN _txBufferTWI,7
;      54 	txBufferTWI[Start_Position_for_Reply+6] = (EEPROMSIZ>>8);
	LDI  R30,LOW(2)
	__PUTB1MN _txBufferTWI,8
;      55 
;      56 	txBufferTWI[Start_Position_for_Reply+7] = (MONITORVERSION);
	LDI  R30,LOW(256)
	__PUTB1MN _txBufferTWI,9
;      57 	txBufferTWI[Start_Position_for_Reply+8] = (MONITORVERSION>>8);
	LDI  R30,LOW(1)
	__PUTB1MN _txBufferTWI,10
;      58 	
;      59 	txBufferTWI[Start_Position_for_Reply+9] = calc_CRC( &txBufferTWI[Start_Position_for_Reply] );
	__POINTW1MN _txBufferTWI,2
	RCALL SUBOPT_0x0
	__PUTB1MN _txBufferTWI,11
;      60 
;      61 	// Перешел в режим программирования - теперь могу долго ждать очередной пакет
;      62 	prgmode = 1;
	SET
	BLD  R2,0
;      63 	
;      64 	// Обнуляю генератор дешифрующей последовательности
;      65 	ResetDescrambling();
	RCALL _ResetDescrambling
;      66 }
	RET
;      67 
;      68 
;      69 // Прием слова из буффера
;      70 unsigned short GetWordBuff(unsigned char a)
;      71 {
_GetWordBuff:
;      72 	register unsigned short ret;  
;      73 
;      74 	// дискремблируем
;      75 	ret = ( rxBufferTWI	[a++] ^ NextSeqByte() );
	RCALL __SAVELOCR2
;	a -> Y+2
;	ret -> R16,R17
	LDD  R30,Y+2
	SUBI R30,-LOW(1)
	STD  Y+2,R30
	SUBI R30,LOW(1)
	RCALL SUBOPT_0x1
	PUSH R30
	RCALL _NextSeqByte
	POP  R26
	EOR  R30,R26
	MOV  R16,R30
	CLR  R17
;      76 	ret |= ((unsigned short)rxBufferTWI[a] ^ NextSeqByte() ) << 8;
	LDD  R30,Y+2
	RCALL SUBOPT_0x1
	LDI  R31,0
	PUSH R31
	PUSH R30
	RCALL _NextSeqByte
	POP  R26
	POP  R27
	LDI  R31,0
	EOR  R26,R30
	EOR  R27,R31
	MOVW R30,R26
	MOV  R31,R30
	LDI  R30,0
	__ORWRR 16,17,30,31
;      77 
;      78 	return ret;
	MOVW R30,R16
	RCALL __LOADLOCR2
	ADIW R28,3
	RET
;      79 } 
;      80 
;      81 
;      82 
;      83 // Запись в EEPROM
;      84 void WriteEeprom(void)
;      85 {
_WriteEeprom:
;      86 	register unsigned short addr;
;      87 	register unsigned char  data;
;      88 
;      89 	// Прием адреса и данных	
;      90 	#asm ("wdr");
	RCALL __SAVELOCR3
;	addr -> R16,R17
;	data -> R18
	wdr
;      91 
;      92 	addr = GetWordBuff(5);
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _GetWordBuff
	MOVW R16,R30
;      93 	data = ( rxBufferTWI	[7] ^ NextSeqByte() );
	RCALL _NextSeqByte
	__GETB2MN _rxBufferTWI,7
	EOR  R30,R26
	MOV  R18,R30
;      94 
;      95 
;      96 	// Проверяю завершение и корректность пакета
;      97 	if (addr < EEPROMSIZ)
	__CPWRN 16,17,512
	BRSH _0x4
;      98 	{
;      99 		// Пишу в EEPROM
;     100 		*((char eeprom *)addr) = data;
	MOV  R30,R18
	MOVW R26,R16
	RCALL __EEPROMWRB
;     101 
;     102 		// Проверяю, записалось ли
;     103 		if (*((char eeprom *)addr) == data)
	MOVW R26,R16
	RCALL __EEPROMRDB
	CP   R18,R30
	BRNE _0x5
;     104 		{
;     105 			// Сигналю, что все в порядке 
;     106 			txBufferTWI[Start_Position_for_Reply] = 2;        				// длина
	LDI  R30,LOW(2)
	__PUTB1MN _txBufferTWI,2
;     107 			txBufferTWI[Start_Position_for_Reply+1] = RES_OK;				//  OK
	LDI  R30,LOW(1)
	__PUTB1MN _txBufferTWI,3
;     108 			txBufferTWI[Start_Position_for_Reply+2] = 2 + RES_OK;		//  CRC
	LDI  R30,LOW(3)
	__PUTB1MN _txBufferTWI,4
;     109 
;     110 			return;
	RJMP _0x79
;     111 		}
;     112 	}
_0x5:
;     113      
;     114 	// Ошибка
;     115 	txBufferTWI[Start_Position_for_Reply] = 2;        				// длина
_0x4:
	LDI  R30,LOW(2)
	__PUTB1MN _txBufferTWI,2
;     116 	txBufferTWI[Start_Position_for_Reply+1] = RES_ERR;			//  ошибка
	LDI  R30,LOW(0)
	__PUTB1MN _txBufferTWI,3
;     117 	txBufferTWI[Start_Position_for_Reply+2] = 2 + RES_ERR;		//  CRC
	LDI  R30,LOW(2)
	__PUTB1MN _txBufferTWI,4
;     118 
;     119 } 
_0x79:
	RCALL __LOADLOCR3
	ADIW R28,3
	RET
;     120 
;     121 // Чтение байта из FLASH по адресу
;     122 #ifdef USE_RAMPZ
;     123 	#pragma warn-
;     124 	unsigned char FlashByte(FADDRTYPE addr)
;     125 	{
;     126 	#asm
;     127 		ld		r30, y		; Загружаю Z
;     128 		ldd		r31, y+1
;     129 		
;     130 		in		r23, rampz	; Сохраняю RAMPZ
;     131 		
;     132 		ldd		r22, y+2	; Переношу RAMPZ
;     133 		out		rampz, r22
;     134 		
;     135 		elpm	r24, z		; Читаю FLASH
;     136 		
;     137 		out		rampz, r23	; Восстанавливаю RAMPZ
;     138 
;     139 		mov		r30, r24	; Возвращаемое значение
;     140 	#endasm
;     141 	}	
;     142 	#pragma warn+
;     143 #else
;     144 	#define FlashByte(a) (*((flash unsigned char *)a))
;     145 #endif
;     146 
;     147 // Проверка наличия "рабочей" программы
;     148 unsigned char AppOk(void)
;     149 {
_AppOk:
;     150 	FADDRTYPE addr, lastaddr;
;     151 	unsigned short crc, fcrc;
;     152 	
;     153 	//WD пока не включен	
;     154 //	#asm("wdr");
;     155 	
;     156 	lastaddr = ( (FADDRTYPE)FlashByte(PRGPAGES*PAGESIZ - 4) | 
	SBIW R28,2
	RCALL __SAVELOCR6
;	addr -> R16,R17
;	lastaddr -> R18,R19
;	crc -> R20,R21
;	fcrc -> Y+6
;     157 	            ((FADDRTYPE)FlashByte(PRGPAGES*PAGESIZ - 3) << 8))
;     158 	            << (ZPAGEMSB + 1);
	LDI  R30,LOW(6140)
	LDI  R31,HIGH(6140)
	RCALL SUBOPT_0x2
	LDI  R30,LOW(6141)
	LDI  R31,HIGH(6141)
	RCALL SUBOPT_0x3
	RCALL __LSLW2
	RCALL __LSLW4
	MOVW R18,R30
;     159 	            
;     160 
;     161 	if (lastaddr == (0xFFFF << (ZPAGEMSB + 1)))
	MOVW R26,R18
	CLR  R24
	CLR  R25
	__CPD2N 0x3FFFC0
	BRNE _0x6
;     162 	{
;     163 	        return 0;
	LDI  R30,LOW(0)
	RJMP _0x78
;     164 	}
;     165 	
;     166 	for (addr = 0, crc = 0; addr != lastaddr; addr ++)
_0x6:
	__GETWRN 16,17,0
	__GETWRN 20,21,0
_0x8:
	__CPWRR 18,19,16,17
	BREQ _0x9
;     167 	{
;     168 		crc += FlashByte(addr);
	MOVW R30,R16
	LPM  R30,Z
	MOVW R26,R20
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R20,R30
;     169 	}
	__ADDWRN 16,17,1
	RJMP _0x8
_0x9:
;     170 
;     171 	fcrc = 	 (unsigned short)FlashByte(PRGPAGES*PAGESIZ - 2) | 
;     172 			((unsigned short)FlashByte(PRGPAGES*PAGESIZ - 1) << 8);
	LDI  R30,LOW(6142)
	LDI  R31,HIGH(6142)
	RCALL SUBOPT_0x2
	LDI  R30,LOW(6143)
	LDI  R31,HIGH(6143)
	RCALL SUBOPT_0x3
	STD  Y+6,R30
	STD  Y+6+1,R31
;     173 	
;     174 	if (crc != fcrc)
	CP   R30,R20
	CPC  R31,R21
	BREQ _0xA
;     175 	{
;     176 		return 0;
	LDI  R30,LOW(0)
	RJMP _0x78
;     177 	}
;     178 	
;     179 	return 1;
_0xA:
	LDI  R30,LOW(1)
_0x78:
	RCALL __LOADLOCR6
	ADIW R28,8
	RET
;     180 }
;     181 
;     182 // Перезагрузка в рабочий режим
;     183 void RebootToWork(void)
;     184 {
_RebootToWork:
;     185 	// Проверяю, есть ли куда грузиться
;     186 	if (!AppOk())
	RCALL _AppOk
	CPI  R30,0
	BRNE _0xB
;     187 	{
;     188 		return;
	RET
;     189 	}
;     190 
;     191 	#asm("cli");
_0xB:
	cli
;     192 	IVCREG = 1 << IVCE;
	LDI  R30,LOW(1)
	OUT  0x3B,R30
;     193 	IVCREG = 0;
	LDI  R30,LOW(0)
	OUT  0x3B,R30
;     194 
;     195 	#asm("rjmp 0");      //Mega128 - JMP, Mega8 - RJMP
	rjmp 0
;     196 }
	RET
;     197 
;     198 // Реакция на команду перейти в рабочий режим
;     199 void ToWorkMode(void)
;     200 {
;     201 
;     202 	// Отправляю ответ
;     203 	txBufferTWI[0] = 0;        						// подтверждаю прием
;     204 //	dannForTX = 1;								// есть данные
;     205 
;     206 	prgmode = 0;
;     207 	  
;     208 	// На перезагрузку
;     209 	toReboot =1;
;     210 //	RebootToWork();
;     211 }
;     212 
;     213 //-----------------------------------------------------------------------------------------------------------------
;     214 
;     215 // Возвращаю состояние устройства
;     216 const char _PT_GETSTATE_[]={19,2,0,"BOOT PROGRAM  ",100,255};
;     217 
;     218 static void GetState(void)
;     219 {
;     220 	register unsigned char a=Start_Position_for_Reply;
;     221 
;     222 	switch (PT_GETSTATE_page)
;	a -> R16
;     223 	{
;     224 		case 0:
;     225 			memcpyf(&txBufferTWI[2], _PT_GETSTATE_, _PT_GETSTATE_[0]+1); // 0 пакет
;     226 			a+=19;
;     227 			break;
;     228 
;     229 		case 1:			
;     230 			txBufferTWI[a++] = 5;				 			// длина пакета
;     231 
;     232 			txBufferTWI[a++] = 0;							// № микросхемы
;     233 			txBufferTWI[a++] = MY_TWI_ADDRESS;
;     234 			txBufferTWI[a++] = 0;
;     235 
;     236 			txBufferTWI[a++] = 255;
;     237 			break;
;     238 
;     239 		default:
;     240 			txBufferTWI[a++] = 0;				 			// длина пакета
;     241 			break;
;     242 	} 
;     243 
;     244 	txBufferTWI[a] = calc_CRC( &txBufferTWI[Start_Position_for_Reply] );
;     245 } 
;     246 
;     247 // Информация об устройстве:
;     248 
;     249 static void GetInfo(void)
;     250 {
;     251 		register unsigned char i,a=Start_Position_for_Reply;                    
;     252 	
;     253 		// 	заполняю буфер
;     254 		txBufferTWI[a++] = 40+1;
;	i -> R16
;	a -> R17
;     255 	
;     256 		for ( i = 0; i <32; i ++ )	
;     257 				txBufferTWI[a++] = device_name[i];	// Имя устройства
;     258 
;     259 		txBufferTWI[a++] = my_ser_num;        		// Серийный номер
;     260 		txBufferTWI[a++] = my_ser_num>>8;    	  	// Серийный номер
;     261 
;     262 		txBufferTWI[a++] = my_ser_num>>16;		// Серийный номер
;     263 		txBufferTWI[a++] = my_ser_num>>24;		// Серийный номер
;     264 	
;     265 		txBufferTWI[a++] =MY_TWI_ADDRESS ; 	// Адрес устройства
;     266         txBufferTWI[a++] =0;     							// Зарезервированный байт
;     267 	
;     268 		txBufferTWI[a++] = my_version_high;        	// Версия софта
;     269 		txBufferTWI[a++] = my_version_low;			// Версия  софта
;     270 		
;     271 		txBufferTWI[a] = calc_CRC( &txBufferTWI[Start_Position_for_Reply] );
;     272 
;     273 }
;     274 
;     275 
;     276 void main(void)
;     277 {
_main:
;     278 	// Настраиваю "железо"
;     279 	 Initialization_Device(); 
	RCALL _Initialization_Device
;     280 
;     281 	// Global enable interrupts
;     282 	#asm("sei")
	sei
;     283 
;     284 	// Ожидание, прием и исполнение команд
;     285 	while (1)
_0x15:
;     286 	{
;     287 
;     288 	// Опрашиваем наличие программы по таймеру (примерно 2с)
;     289 	if ( TIFR & (1 << TOV1) )
	IN   R30,0x38
	SBRS R30,2
	RJMP _0x18
;     290 	{
;     291 		TIFR |= (1<<TOV1);
	IN   R30,0x38
	ORI  R30,4
	OUT  0x38,R30
;     292 		TCNT1=0xD2F6;		//примерно 2сек
	RCALL SUBOPT_0x4
;     293 
;     294 		// Пытаюсь перегрузиться в рабочий режим	
;     295 		RebootToWork();
	RCALL _RebootToWork
;     296 	}
;     297 
;     298 //		#asm("wdr");
;     299 		run_TWI_slave();
_0x18:
	RCALL _run_TWI_slave
;     300 		
;     301 		// Обрабатываем принятый пакет TWI
;     302 		if ( rxPack )
	TST  R4
	BREQ _0x19
;     303 		{
;     304 			// Обработка внутренних пакетов
;     305 			if ( ( Recived_Address == Internal_Packet ) || ( Recived_Address == Global_Packet ) )		
	__GETB1MN _rxBufferTWI,3
	CPI  R30,0
	BREQ _0x1B
	__GETB1MN _rxBufferTWI,3
	CPI  R30,LOW(0xFF)
	BRNE _0x1A
_0x1B:
;     306 			{
;     307 				switch ( Type_RX_Packet_TWI )
	__GETB1MN _rxBufferTWI,4
;     308 				{
;     309 					// возвращаем о себе информацию
;     310 					case PT_GETINFO:			
	CPI  R30,LOW(0x3)
	BREQ _0x1F
;     311 //							GetInfo();
;     312 							break;                                     
;     313 
;     314 					// возвращаем состояние						
;     315 					case PT_GETSTATE:			
	CPI  R30,LOW(0x1)
	BREQ _0x1F
;     316 //							GetState();
;     317 							break;                      
;     318 
;     319 					// Переход в программирование
;     320 					case PT_TOPROG:
	CPI  R30,LOW(0x7)
	BRNE _0x22
;     321 							toProgramming = 1;				// ждем пакеты программирования
	SET
	BLD  R2,4
;     322 							// формируем ответ
;     323 							txBufferTWI[0] = 1;				 	// длина пакета
	LDI  R30,LOW(1)
	STS  _txBufferTWI,R30
;     324 							txBufferTWI[1] = 1;				 	// КС
	__PUTB1MN _txBufferTWI,1
;     325 
;     326 							break;      
	RJMP _0x1F
;     327 
;     328 					// Вернуть информацию о мониторе и процессоре
;     329 					case PT_PRGINFO:	
_0x22:
	CPI  R30,LOW(0x8)
	BRNE _0x23
;     330 							PrgInfo();
	RCALL _PrgInfo
;     331 							break;
	RJMP _0x1F
;     332 
;     333 					// Записать страницу FLASH							
;     334 					case PT_WRFLASH:	
_0x23:
	CPI  R30,LOW(0x9)
	BRNE _0x24
;     335 
;     336 //							TCNT1=0xD2F6;		//примерно 2сек
;     337 
;     338 //							toProgramming = 1;				// ждем пакеты программирования
;     339 							WriteFlash();
	RCALL _WriteFlash
;     340 							break;
	RJMP _0x1F
;     341 
;     342 					// Записать байт в EEPROM
;     343 					case PT_WREEPROM:	
_0x24:
	CPI  R30,LOW(0xA)
	BRNE _0x26
;     344 
;     345 //							TCNT1=0xD2F6;		//примерно 2сек
;     346 
;     347 							WriteEeprom();
	RCALL _WriteEeprom
;     348 							break;
;     349 			
;     350 
;     351 					default:
_0x26:
;     352 //							toProgramming = 0;		// программируют не нас
;     353 				}
_0x1F:
;     354 				// отправляем ответ
;     355 				packPacket (External_Packet);	// даем тип ВНЕШНИЙ
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _packPacket
;     356 				// переинициализируем таймер
;     357 				TCNT1=0xD2F6;		//примерно 2сек
	RCALL SUBOPT_0x4
;     358 	         }
;     359 		
;     360 		rxPack = 0;							// пакет обработан
_0x1A:
	CLR  R4
;     361         }          
;     362 	}
_0x19:
	RJMP _0x15
;     363 }
_0x27:
	RJMP _0x27
;     364 
;     365 
;     366 
;     367 
;     368 /*		else if ( Recived_Address == MY_TWI_ADDRESS ) 							////////////// Мой адрес. Обращаются ко мне
;     369 		{
;     370 			switch ( Type_RX_Packet_TWI )
;     371 			{
;     372 		 		case PT_TOPROG:       			// переходим в программирование
;     373 						ToProg();
;     374 						rxPack = 0;					// пакет обработан
;     375 						break;      
;     376 
;     377 		 		case PT_SETADDR:       			// переходим в программирование
;     378 						Setaddr();
;     379 						rxPack = 0;					// пакет обработан
;     380 						break;      
;     381 
;     382 		 		case PT_SETSERIAL:       			// переходим в программирование
;     383 						SetSerial();
;     384 						rxPack = 0;					// пакет обработан
;     385 						break;      
;     386 
;     387 
;     388 				default:
;     389 						rxPack = 0;					// пакет обработан
;     390 			}
;     391        	}
;     392 		    else	if( Recived_Address == TO_MON)					// обрабатываем пакет по адресу MONITOR
;     393 			{
;     394 				switch ( Type_RX_Packet_TWI )
;     395 				{
;     396 		 			case PT_SETADDR:       			// переходим в программирование
;     397 //							Setaddr();
;     398 							rxPack = 0;					// пакет обработан
;     399 							break;      
;     400 
;     401 			 		case PT_SETSERIAL:       			// переходим в программирование
;     402 //							SetSerial();
;     403 							rxPack = 0;					// пакет обработан
;     404 							break; 
;     405 
;     406 			 		case PT_TOWORK:       			// переходим в программирование
;     407 							ToWorkMode();
;     408 							rxPack = 0;					// пакет обработан
;     409 							break; 
;     410 									     
;     411 					default:
;     412 							rxPack = 0;					// пакет обработан
;     413 				}                                                                               
;     414 			}
;     415 	
;     416 
;     417 
;     418 
;     419 /*
;     420 //		Wait4Hdr();						// Ждем пакет
;     421         if ((adr == pAddr)||(adr == TO_MON )) 	            // работа при внешней адресации
;     422         	{
;     423 				switch(typePack)
;     424 					{
;     425 
;     426 						case PT_PRGINFO:	// Вернуть информацию о мониторе и процессоре
;     427 							PrgInfo();
;     428 							txBuff();
;     429 							break;
;     430 
;     431 						case PT_WRFLASH:	// Записать страницу FLASH
;     432 							WriteFlash();
;     433 							txBuff();
;     434 							break;
;     435 
;     436 						case PT_WREEPROM:	// Записать байт в EEPROM
;     437 							WriteEeprom();
;     438 							txBuff();
;     439 						break;
;     440 
;     441 						case PT_TOWORK:		// Вернуться в режим работы
;     442 							ToWorkMode();			
;     443 							txBuff();                         // отвечаем и
;     444 							RebootToWork();			// на перезагрузку
;     445 							break;    
;     446 
;     447 						case PT_TOPROG:
;     448 							txBuffer[0] = 0;        				// мы входим в прораммирование
;     449 							txBuff();
;     450 							break;      
;     451 
;     452 						case PT_GETINFO:
;     453 							GetInfo();
;     454 							txBuff();
;     455 							break;
;     456 
;     457 						case PT_GETSTATE:
;     458 							GetState();
;     459 							txBuff();
;     460 							break;
;     461 						
;     462 						default:
;     463 							break;
;     464 					}
;     465 
;     466         	}
;     467         else         if (adr==0)											//  команды при внутр. адресе 0
;     468         	{
;     469 				switch(typePack)
;     470 					{
;     471 						case GetLogAddr:     						// Отвечаем. Заполняем буффер на передачу
;     472 								txBuffer[0] = 1;				 		// длина пакета
;     473 								txBuffer[1] = 0;				 		// лог. адрес
;     474 								txBuff ();                           		// передаем
;     475 								break;
;     476 
;     477 /*						case pingPack :
;     478 								if (dannForTX) txBuff();
;     479 								else 	twi_byte(0);				  			// длина пакета
;     480 								break;
;     481 						default:
;     482 								break;
;     483 					}
;     484         	
;     485 			}*/
;     486 /*****************************************************************************
;     487 *
;     488 * Atmel Corporation
;     489 *
;     490 * File              : TWI_Slave.c
;     491 * Compiler          : IAR EWAAVR 2.28a/3.10c
;     492 * Revision          : $Revision: 1.7 $
;     493 * Date              : $Date: Thursday, August 05, 2004 09:22:50 UTC $
;     494 * Updated by        : $Author: lholsen $
;     495 *
;     496 * Support mail      : avr@atmel.com
;     497 *
;     498 * Supported devices : All devices with a TWI module can be used.
;     499 *                     The example is written for the ATmega16
;     500 *
;     501 * AppNote           : AVR311 - TWI Slave Implementation
;     502 *
;     503 * Description       : This is sample driver to AVRs TWI module. 
;     504 *                     It is interupt driveren. All functionality is controlled through 
;     505 *                     passing information to and from functions. Se main.c for samples
;     506 *                     of how to use the driver.
;     507 *
;     508 ****************************************************************************/
;     509 #include "TWI_slave.h"
;     510  
;     511 static unsigned char TWI_buf[TWI_BUFFER_SIZE];     // Transceiver buffer. Set the size in the header file

	.DSEG
_TWI_buf_G2:
	.BYTE 0xFA
;     512 static unsigned char TWI_msgSize  = 0;             // Number of bytes to be transmitted.
_TWI_msgSize_G2:
	.BYTE 0x1
;     513 static unsigned char TWI_state    = TWI_NO_STATE;  // State byte. Default set to TWI_NO_STATE.
_TWI_state_G2:
	.BYTE 0x1
;     514 
;     515 //union TWISR TWI_statusReg = {0};           // TWI_statusReg is defined in TWI_Slave.h
;     516 
;     517 /****************************************************************************
;     518 Call this function to set up the TWI slave to its initial standby state.
;     519 Remember to enable interrupts from the main application after initializing the TWI.
;     520 Pass both the slave address and the requrements for triggering on a general call in the
;     521 same byte. Use e.g. this notation when calling this function:
;     522 TWI_Slave_Initialise( (TWI_slaveAddress<<TWI_ADR_BITS) | (TRUE<<TWI_GEN_BIT) );
;     523 The TWI module is configured to NACK on any requests. Use a TWI_Start_Transceiver function to 
;     524 start the TWI.
;     525 ****************************************************************************/
;     526 void TWI_Slave_Initialise( unsigned char TWI_ownAddress )
;     527 {

	.CSEG
_TWI_Slave_Initialise:
;     528   TWAR = TWI_ownAddress;                            // Set own TWI slave address. Accept TWI General Calls.
	LD   R30,Y
	OUT  0x2,R30
;     529 
;     530   TWDR = 0xFF;                                      // Default content = SDA released.
	LDI  R30,LOW(255)
	OUT  0x3,R30
;     531   TWCR = (1<<TWEN)|                                 // Enable TWI-interface and release TWI pins.
;     532          (0<<TWIE)|(0<<TWINT)|                      // Disable TWI Interupt.
;     533          (0<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|           // Do not ACK on any requests, yet.
;     534          (0<<TWWC);                                 //
	LDI  R30,LOW(4)
	OUT  0x36,R30
;     535 }    
	RJMP _0x75
;     536 
;     537 /****************************************************************************
;     538 Call this function to test if the TWI_ISR is busy transmitting.
;     539 ****************************************************************************/
;     540 unsigned char TWI_Transceiver_Busy( void )
;     541 {
_TWI_Transceiver_Busy:
;     542   return ( TWCR & (1<<TWIE) );                  // IF TWI interrupt is enabled then the Transceiver is busy
	IN   R30,0x36
	ANDI R30,LOW(0x1)
	RET
;     543 }
;     544 
;     545 /****************************************************************************
;     546 Call this function to fetch the state information of the previous operation. The function will hold execution (loop)
;     547 until the TWI_ISR has completed with the previous operation. If there was an error, then the function 
;     548 will return the TWI State code. 
;     549 ****************************************************************************/
;     550 unsigned char TWI_Get_State_Info( void )
;     551 {
_TWI_Get_State_Info:
;     552   while ( TWI_Transceiver_Busy() );             // Wait until TWI has completed the transmission.
_0x29:
	RCALL SUBOPT_0x5
	BRNE _0x29
;     553   return ( TWI_state );                         // Return error state. 
	LDS  R30,_TWI_state_G2
	RET
;     554 }
;     555 
;     556 /****************************************************************************
;     557 Call this function to send a prepared message, or start the Transceiver for reception. Include
;     558 a pointer to the data to be sent if a SLA+W is received. The data will be copied to the TWI buffer. 
;     559 Also include how many bytes that should be sent. Note that unlike the similar Master function, the
;     560 Address byte is not included in the message buffers.
;     561 The function will hold execution (loop) until the TWI_ISR has completed with the previous operation,
;     562 then initialize the next operation and return.
;     563 ****************************************************************************/
;     564 void TWI_Start_Transceiver_With_Data( unsigned char *msg, unsigned char msgSize )
;     565 {
_TWI_Start_Transceiver_With_Data:
;     566   unsigned char temp;
;     567 
;     568   while ( TWI_Transceiver_Busy() );             // Wait until TWI is ready for next transmission.
	ST   -Y,R16
;	*msg -> Y+2
;	msgSize -> Y+1
;	temp -> R16
_0x2C:
	RCALL SUBOPT_0x5
	BRNE _0x2C
;     569 
;     570   TWI_msgSize = msgSize;                        // Number of data to transmit.
	LDD  R30,Y+1
	STS  _TWI_msgSize_G2,R30
;     571   for ( temp = 0; temp < msgSize; temp++ )      // Copy data that may be transmitted if the TWI Master requests data.
	LDI  R16,LOW(0)
_0x30:
	RCALL SUBOPT_0x6
	BRSH _0x31
;     572     TWI_buf[ temp ] = msg[ temp ];
	RCALL SUBOPT_0x7
	MOVW R0,R30
	RCALL SUBOPT_0x8
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
;     573 
;     574   TWI_statusReg.all = 0;      
	SUBI R16,-1
	RJMP _0x30
_0x31:
	RCALL SUBOPT_0x9
;     575   TWI_state         = TWI_NO_STATE ;
;     576   TWCR = (1<<TWEN)|                             // TWI Interface enabled.
;     577          (1<<TWIE)|(1<<TWINT)|                  // Enable TWI Interupt and clear the flag.
;     578          (1<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|       // Prepare to ACK next time the Slave is addressed.
;     579          (0<<TWWC);                             //
;     580 }
	RJMP _0x77
;     581 
;     582 /****************************************************************************
;     583 Call this function to start the Transceiver without specifing new transmission data. Usefull for restarting
;     584 a transmission, or just starting the transceiver for reception. The driver will reuse the data previously put
;     585 in the transceiver buffers. The function will hold execution (loop) until the TWI_ISR has completed with the 
;     586 previous operation, then initialize the next operation and return.
;     587 ****************************************************************************/
;     588 void TWI_Start_Transceiver( void )
;     589 {
_TWI_Start_Transceiver:
;     590   while ( TWI_Transceiver_Busy() );             // Wait until TWI is ready for next transmission.
_0x32:
	RCALL SUBOPT_0x5
	BRNE _0x32
;     591   TWI_statusReg.all = 0;      
	RCALL SUBOPT_0x9
;     592   TWI_state         = TWI_NO_STATE ;
;     593   TWCR = (1<<TWEN)|                             // TWI Interface enabled.
;     594          (1<<TWIE)|(1<<TWINT)|                  // Enable TWI Interupt and clear the flag.
;     595          (1<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|       // Prepare to ACK next time the Slave is addressed.
;     596          (0<<TWWC);                             //
;     597 }
	RET
;     598 /****************************************************************************
;     599 Call this function to read out the received data from the TWI transceiver buffer. I.e. first call
;     600 TWI_Start_Transceiver to get the TWI Transceiver to fetch data. Then Run this function to collect the
;     601 data when they have arrived. Include a pointer to where to place the data and the number of bytes
;     602 to fetch in the function call. The function will hold execution (loop) until the TWI_ISR has completed 
;     603 with the previous operation, before reading out the data and returning.
;     604 If there was an error in the previous transmission the function will return the TWI State code.
;     605 ****************************************************************************/
;     606 unsigned char TWI_Get_Data_From_Transceiver( unsigned char *msg, unsigned char msgSize )
;     607 {
_TWI_Get_Data_From_Transceiver:
;     608   unsigned char i;
;     609 
;     610   while ( TWI_Transceiver_Busy() );             // Wait until TWI is ready for next transmission.
	ST   -Y,R16
;	*msg -> Y+2
;	msgSize -> Y+1
;	i -> R16
_0x35:
	RCALL SUBOPT_0x5
	BRNE _0x35
;     611 
;     612   if( TWI_statusReg.bits.lastTransOK )               // Last transmission competed successfully.              
	RCALL SUBOPT_0xA
	BREQ _0x38
;     613   {                                             
;     614     for ( i=0; i<msgSize; i++ )                 // Copy data from Transceiver buffer.
	LDI  R16,LOW(0)
_0x3A:
	RCALL SUBOPT_0x6
	BRSH _0x3B
;     615     {
;     616       msg[ i ] = TWI_buf[ i ];
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x7
	LD   R30,Z
	ST   X,R30
;     617     }
	SUBI R16,-1
	RJMP _0x3A
_0x3B:
;     618     TWI_statusReg.bits.RxDataInBuf = FALSE;          // Slave Receive data has been read from buffer.
	LDS  R30,_TWI_statusReg
	ANDI R30,0xFD
	STS  _TWI_statusReg,R30
;     619   }
;     620   return( TWI_statusReg.bits.lastTransOK );                                   
_0x38:
	RCALL SUBOPT_0xA
_0x77:
	LDD  R16,Y+0
	ADIW R28,4
	RET
;     621 }
;     622 
;     623 // ********** Interrupt Handlers ********** //
;     624 /****************************************************************************
;     625 This function is the Interrupt Service Routine (ISR), and called when the TWI interrupt is triggered;
;     626 that is whenever a TWI event has occurred. This function should not be called directly from the main
;     627 application.
;     628 ****************************************************************************/
;     629 // 2 Wire bus interrupt service routine
;     630 interrupt [TWI] void TWI_ISR(void)
;     631 {
_TWI_ISR:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;     632   static unsigned char TWI_bufPtr;

	.DSEG

	.CSEG
;     633 
;     634 switch (TWSR)
	IN   R30,0x1
;     635   {
;     636     case TWI_STX_ADR_ACK:            // Own SLA+R has been received; ACK has been returned
	CPI  R30,LOW(0xA8)
	BRNE _0x3F
;     637 //    case TWI_STX_ADR_ACK_M_ARB_LOST: // Arbitration lost in SLA+R/W as Master; own SLA+R has been received; ACK has been returned
;     638       TWI_bufPtr   = 0;                                 // Set buffer pointer to first data location
	CLR  R6
;     639 #ifdef aaa
;     640 	PORTD.3=0; 
;     641 #endif    
;     642 
;     643     case TWI_STX_DATA_ACK:           // Data byte in TWDR has been transmitted; ACK has been received
	RJMP _0x40
_0x3F:
	CPI  R30,LOW(0xB8)
	BRNE _0x41
_0x40:
;     644       TWDR = TWI_buf[TWI_bufPtr++];
	RCALL SUBOPT_0xB
	LD   R30,Z
	OUT  0x3,R30
;     645       TWCR = (1<<TWEN)|                                 // TWI Interface enabled
;     646              (1<<TWIE)|(1<<TWINT)|                      // Enable TWI Interupt and clear the flag to send byte
;     647              (1<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|           // 
;     648              (0<<TWWC);                                 //  
	LDI  R30,LOW(197)
	RJMP _0x7A
;     649       break;
;     650 
;     651     case TWI_STX_DATA_NACK:          // Data byte in TWDR has been transmitted; NACK has been received. 
_0x41:
	CPI  R30,LOW(0xC0)
	BRNE _0x42
;     652                                      // I.e. this could be the end of the transmission.
;     653       if (TWI_bufPtr == TWI_msgSize) // Have we transceived all expected data?
	LDS  R30,_TWI_msgSize_G2
	CP   R30,R6
	BRNE _0x43
;     654       {
;     655         TWI_statusReg.bits.lastTransOK = TRUE;               // Set status bits to completed successfully. 
	RCALL SUBOPT_0xC
;     656       }else                          // Master has sent a NACK before all data where sent.
	RJMP _0x44
_0x43:
;     657       {
;     658         TWI_state = TWSR;                               // Store TWI State as errormessage.      
	RCALL SUBOPT_0xD
;     659       }        
_0x44:
;     660                                                         // Put TWI Transceiver in passive mode.
;     661       TWCR = (1<<TWEN)|                                 // Enable TWI-interface and release TWI pins
;     662              (0<<TWIE)|(0<<TWINT)|                      // Disable Interupt
;     663              (0<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|           // Do not acknowledge on any new requests.
;     664              (0<<TWWC);                                 //
	RJMP _0x7B
;     665       break;     
;     666 
;     667     case TWI_SRX_GEN_ACK:            // General call address has been received; ACK has been returned
_0x42:
	CPI  R30,LOW(0x70)
	BRNE _0x45
;     668 //    case TWI_SRX_GEN_ACK_M_ARB_LOST: // Arbitration lost in SLA+R/W as Master; General call address has been received; ACK has been returned
;     669       TWI_statusReg.bits.genAddressCall = TRUE;
	LDS  R30,_TWI_statusReg
	ORI  R30,4
	STS  _TWI_statusReg,R30
;     670 
;     671     case TWI_SRX_ADR_ACK:            // Own SLA+W has been received ACK has been returned
	RJMP _0x46
_0x45:
	CPI  R30,LOW(0x60)
	BRNE _0x47
_0x46:
;     672 //    case TWI_SRX_ADR_ACK_M_ARB_LOST: // Arbitration lost in SLA+R/W as Master; own SLA+W has been received; ACK has been returned    
;     673                                                         // Dont need to clear TWI_S_statusRegister.generalAddressCall due to that it is the default state.
;     674       TWI_statusReg.bits.RxDataInBuf = TRUE;      
	LDS  R30,_TWI_statusReg
	ORI  R30,2
	STS  _TWI_statusReg,R30
;     675       TWI_bufPtr   = 0;                                 // Set buffer pointer to first data location
	CLR  R6
;     676                                                         // Reset the TWI Interupt to wait for a new event.
;     677       TWCR = (1<<TWEN)|                                 // TWI Interface enabled
;     678              (1<<TWIE)|(1<<TWINT)|                      // Enable TWI Interupt and clear the flag to send byte
;     679              (1<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|           // Expect ACK on this transmission
;     680              (0<<TWWC);                                 //      
	LDI  R30,LOW(197)
	RJMP _0x7A
;     681       break;
;     682 
;     683     case TWI_SRX_ADR_DATA_ACK:       // Previously addressed with own SLA+W; data has been received; ACK has been returned
_0x47:
	CPI  R30,LOW(0x80)
	BREQ _0x49
;     684     case TWI_SRX_GEN_DATA_ACK:       // Previously addressed with general call; data has been received; ACK has been returned
	CPI  R30,LOW(0x90)
	BRNE _0x4A
_0x49:
;     685       TWI_buf[TWI_bufPtr++]     = TWDR;
	RCALL SUBOPT_0xB
	MOVW R26,R30
	IN   R30,0x3
	ST   X,R30
;     686       TWI_statusReg.bits.lastTransOK = TRUE;                 // Set flag transmission successfull.       
	RCALL SUBOPT_0xC
;     687                                                         // Reset the TWI Interupt to wait for a new event.
;     688       TWCR = (1<<TWEN)|                                 // TWI Interface enabled
;     689              (1<<TWIE)|(1<<TWINT)|                      // Enable TWI Interupt and clear the flag to send byte
;     690              (1<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|           // Send ACK after next reception
;     691              (0<<TWWC);                                 //  
	LDI  R30,LOW(197)
	RJMP _0x7A
;     692       break;
;     693 
;     694     case TWI_SRX_STOP_RESTART:       // A STOP condition or repeated START condition has been received while still addressed as Slave    
_0x4A:
	CPI  R30,LOW(0xA0)
	BRNE _0x4B
;     695 	                                                       // Put TWI Transceiver in passive mode.
;     696       TWCR = (1<<TWEN)|                                 // Enable TWI-interface and release TWI pins
;     697              (0<<TWIE)|(0<<TWINT)|                      // Disable Interupt
;     698              (0<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|           // Do not acknowledge on any new requests.
;     699              (0<<TWWC);                                 //
	RJMP _0x7B
;     700         #ifdef aaa
;     701 	PORTD.3=1; 
;     702 #endif    
;     703       break;           
;     704 
;     705     case TWI_SRX_ADR_DATA_NACK:      // Previously addressed with own SLA+W; data has been received; NOT ACK has been returned
_0x4B:
	CPI  R30,LOW(0x88)
	BREQ _0x4D
;     706     case TWI_SRX_GEN_DATA_NACK:      // Previously addressed with general call; data has been received; NOT ACK has been returned
	CPI  R30,LOW(0x98)
	BRNE _0x4E
_0x4D:
;     707     case TWI_STX_DATA_ACK_LAST_BYTE: // Last data byte in TWDR has been transmitted (TWEA = “0”); ACK has been received
	RJMP _0x4F
_0x4E:
	CPI  R30,LOW(0xC8)
	BRNE _0x50
_0x4F:
;     708 //    case TWI_NO_STATE              // No relevant state information available; TWINT = “0”
;     709     case TWI_BUS_ERROR:         // Bus error due to an illegal START or STOP condition
	RJMP _0x51
_0x50:
	CPI  R30,0
	BRNE _0x53
_0x51:
;     710 
;     711     default:     
_0x53:
;     712       TWI_state = TWSR;                                 // Store TWI State as errormessage, operation also clears the Success bit.      
	RCALL SUBOPT_0xD
;     713       TWCR = (1<<TWEN)|                                 // Enable TWI-interface and release TWI pins
;     714              (0<<TWIE)|(0<<TWINT)|                      // Disable Interupt
;     715              (0<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|           // Do not acknowledge on any new requests.
;     716              (0<<TWWC);                                 //
_0x7B:
	LDI  R30,LOW(4)
_0x7A:
	OUT  0x36,R30
;     717 
;     718   } 
;     719 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;     720 #include <twi_slave.h >
;     721 /*****************************************************************************
;     722 *
;     723 * Atmel Corporation
;     724 *
;     725 * File              : TWI_Slave.h
;     726 * Compiler          : IAR EWAAVR 2.28a/3.10c
;     727 * Revision          : $Revision: 1.6 $
;     728 * Date              : $Date: Monday, May 24, 2004 09:32:18 UTC $
;     729 * Updated by        : $Author: ltwa $
;     730 *
;     731 * Support mail      : avr@atmel.com
;     732 *
;     733 * Supported devices : All devices with a TWI module can be used.
;     734 *                     The example is written for the ATmega16
;     735 *
;     736 * AppNote           : AVR311 - TWI Slave Implementation
;     737 *
;     738 * Description       : Header file for TWI_slave.c
;     739 *                     Include this file in the application.
;     740 *
;     741 ****************************************************************************/
;     742 #include <mega8.h> 
;     743 
;     744 /****************************************************************************
;     745   TWI Status/Control register definitions
;     746 ****************************************************************************/
;     747 
;     748 #define TWI_BUFFER_SIZE 250      // Reserves memory for the drivers transceiver buffer. 
;     749                                // Set this to the largest message size that will be sent including address byte.
;     750 
;     751 /****************************************************************************
;     752   Global definitions
;     753 ****************************************************************************/
;     754 /****************************************************************************
;     755   Global definitions
;     756 ****************************************************************************/
;     757 	typedef  struct
;     758     {
;     759         unsigned char lastTransOK:1;      
;     760         unsigned char RxDataInBuf:1;
;     761         unsigned char genAddressCall:1;                       // TRUE = General call, FALSE = TWI Address;
;     762         unsigned char unusedBits:5;
;     763     } SB;
;     764   
;     765   	typedef union 				                       // Status byte holding flags.
;     766 	{
;     767     	unsigned char all;
;     768     	SB bits;
;     769 	}  TWISR;
;     770 
;     771 extern  TWISR  TWI_statusReg;        
;     772 
;     773 
;     774 // Для совместимости
;     775 #define  __no_operation() #asm("nop")
;     776 #define  __enable_interrupt() #asm("sei")
;     777 #define  __disable_interrupt() #asm("cli")
;     778 
;     779 
;     780 /****************************************************************************
;     781   Function definitions
;     782 ****************************************************************************/
;     783 void TWI_Slave_Initialise( unsigned char );
;     784 unsigned char TWI_Transceiver_Busy( void );
;     785 unsigned char TWI_Get_State_Info( void );
;     786 void TWI_Start_Transceiver_With_Data( unsigned char * , unsigned char );
;     787 void TWI_Start_Transceiver( void );
;     788 unsigned char TWI_Get_Data_From_Transceiver( unsigned char *, unsigned char );    
;     789 
;     790 void run_TWI_slave ( void );
;     791 
;     792 
;     793 /****************************************************************************
;     794   Bit and byte definitions
;     795 ****************************************************************************/
;     796 #define TWI_READ_BIT  0   // Bit position for R/W bit in "address byte".
;     797 #define TWI_ADR_BITS  1   // Bit position for LSB of the slave address bits in the init byte.
;     798 #define TWI_GEN_BIT   0   // Bit position for LSB of the general call bit in the init byte.
;     799 
;     800 #define TRUE          1
;     801 #define FALSE         0
;     802 
;     803 /****************************************************************************
;     804   TWI State codes
;     805 ****************************************************************************/
;     806 // General TWI Master staus codes                      
;     807 #define TWI_START                  0x08  // START has been transmitted  
;     808 #define TWI_REP_START              0x10  // Repeated START has been transmitted
;     809 #define TWI_ARB_LOST               0x38  // Arbitration lost
;     810 
;     811 // TWI Master Transmitter staus codes                      
;     812 #define TWI_MTX_ADR_ACK            0x18  // SLA+W has been tramsmitted and ACK received
;     813 #define TWI_MTX_ADR_NACK           0x20  // SLA+W has been tramsmitted and NACK received 
;     814 #define TWI_MTX_DATA_ACK           0x28  // Data byte has been tramsmitted and ACK received
;     815 #define TWI_MTX_DATA_NACK          0x30  // Data byte has been tramsmitted and NACK received 
;     816 
;     817 // TWI Master Receiver staus codes  
;     818 #define TWI_MRX_ADR_ACK            0x40  // SLA+R has been tramsmitted and ACK received
;     819 #define TWI_MRX_ADR_NACK           0x48  // SLA+R has been tramsmitted and NACK received
;     820 #define TWI_MRX_DATA_ACK           0x50  // Data byte has been received and ACK tramsmitted
;     821 #define TWI_MRX_DATA_NACK          0x58  // Data byte has been received and NACK tramsmitted
;     822 
;     823 // TWI Slave Transmitter staus codes
;     824 #define TWI_STX_ADR_ACK            0xA8  // Own SLA+R has been received; ACK has been returned
;     825 #define TWI_STX_ADR_ACK_M_ARB_LOST 0xB0  // Arbitration lost in SLA+R/W as Master; own SLA+R has been received; ACK has been returned
;     826 #define TWI_STX_DATA_ACK           0xB8  // Data byte in TWDR has been transmitted; ACK has been received
;     827 #define TWI_STX_DATA_NACK          0xC0  // Data byte in TWDR has been transmitted; NOT ACK has been received
;     828 #define TWI_STX_DATA_ACK_LAST_BYTE 0xC8  // Last data byte in TWDR has been transmitted (TWEA = “0”); ACK has been received
;     829 
;     830 // TWI Slave Receiver staus codes
;     831 #define TWI_SRX_ADR_ACK            0x60  // Own SLA+W has been received ACK has been returned
;     832 #define TWI_SRX_ADR_ACK_M_ARB_LOST 0x68  // Arbitration lost in SLA+R/W as Master; own SLA+W has been received; ACK has been returned
;     833 #define TWI_SRX_GEN_ACK            0x70  // General call address has been received; ACK has been returned
;     834 #define TWI_SRX_GEN_ACK_M_ARB_LOST 0x78  // Arbitration lost in SLA+R/W as Master; General call address has been received; ACK has been returned
;     835 #define TWI_SRX_ADR_DATA_ACK       0x80  // Previously addressed with own SLA+W; data has been received; ACK has been returned
;     836 #define TWI_SRX_ADR_DATA_NACK      0x88  // Previously addressed with own SLA+W; data has been received; NOT ACK has been returned
;     837 #define TWI_SRX_GEN_DATA_ACK       0x90  // Previously addressed with general call; data has been received; ACK has been returned
;     838 #define TWI_SRX_GEN_DATA_NACK      0x98  // Previously addressed with general call; data has been received; NOT ACK has been returned
;     839 #define TWI_SRX_STOP_RESTART       0xA0  // A STOP condition or repeated START condition has been received while still addressed as Slave
;     840 
;     841 // TWI Miscellaneous status codes
;     842 #define TWI_NO_STATE               0xF8  // No relevant state information available; TWINT = “0”
;     843 #define TWI_BUS_ERROR              0x00  // Bus error due to an illegal START or STOP condition
;     844 
;     845 // Биты TWCR
;     846 #define TWINT 7             //Флаг прерывания выполнения задачи
;     847 #define TWEA  6             //Генерить ли бит ответа на вызов
;     848 #define TWSTA 5             //Генерить СТАРТ
;     849 #define TWSTO 4             //Генерить СТОП
;     850 #define TWWC  3             //
;     851 #define TWEN  2             //Разрешаем работу I2C
;     852 #define TWIE  0             //Прерывание
;     853 
;     854 
;     855 #include <Scrambling.h >
;     856 
;     857 //#define TWI_Buffer_TX				120			// Буфер на прием UART/ передача TWI    
;     858 
;     859 #define from_TWI		0x0						// порт TWI
;     860 #define from_UART	0x1						// порт UART 
;     861 #define START_Timer  1						// таймер 200мс
;     862 #define STOP_Timer    0   
;     863 
;     864  #define Start_Position_for_Reply	2		// стартовая позиция для ответного пакета
;     865 #define Long_TX_Packet_TWI  	txBufferTWI[Start_Position_for_Reply]  // длина передаваемого пакета
;     866 #define Command_TX_Packet_TWI 	txBufferTWI[Start_Position_for_Reply+1]   // тип передаваемого пакета (команда)
;     867 #define CRC_TX_Packet_TWI   			txBufferTWI[Start_Position_for_Reply+Long_TX_Packet_TWI]	// СRC передаваемого пакета 
;     868 
;     869 
;     870 #define TWI_RX_Command 	 	rxBufferTWI[0]  // команда TWI
;     871 #define Heading_RX_Packet  	rxBufferTWI[1]  // заголовок пакета
;     872 #define Long_RX_Packet_TWI  	rxBufferTWI[2]  // длина принятого пакета
;     873 #define Recived_Address 			rxBufferTWI[3]  // адрес в принятом пакете
;     874 #define Type_RX_Packet_TWI 	rxBufferTWI[4]  // тип принятого пакета 
;     875 #define PT_GETSTATE_page		rxBufferTWI[5]	// номер страницы в пакете GETSTATE	
;     876 #define CRC_RX_Packet_TWI   rxBufferTWI[ rxBufferTWI[2]+2]	// CRC принятого пакета
;     877 
;     878 // Типы пакетов, используемых в CD
;     879 
;     880 #define GetLogAddr					1		// дать логический адрес 
;     881 //#define pingPack						2		// нас пингуют на наличие информации на передачу
;     882 #define Responce_GEN_CALL	3		// ответ на GEN CALL   
;     883 #define Responce_GEN_CALL_internal	4	// ответы для внутр. скремблера
;     884 
;     885 #define Internal_Packet		0x00			// пакеты внутреннего пользования
;     886 #define External_Packet 	0x01			// пакеты ретранслируемые
;     887 #define Global_Packet		0xFF			// глобальный пакет
;     888 
;     889 	
;     890 // Команды, передаваемые по TWI
;     891 #define TWI_CMD_MASTER_WRITE 					0x10
;     892 #define TWI_CMD_MASTER_READ  						0x20      
;     893 #define TWI_CMD_MASTER_RECIVE_PACK_OK 	0x21
;     894 #define TWI_CMD_MASTER_REQUEST_CRC 		0x22       
;     895 
;     896 // Функции
;     897 unsigned char TWI_Act_On_Failure_In_Last_Transmission ( unsigned char TWIerrorMsg );
;     898 void run_TWI_slave ( void ); 
;     899 unsigned char calc_CRC (unsigned char *Position_in_Packet); // Считаем CRC передаваемого пакета
;     900 void packPacket (unsigned char type);
;     901 
;     902 
;     903 
;     904 
;     905 
;     906 
;     907 // Инициализация железа. Определение адресов.
;     908 // 
;     909 void Initialization_Device (void)
;     910 {                                      
_Initialization_Device:
;     911 		PORTC=0x07;
	LDI  R30,LOW(7)
	OUT  0x15,R30
;     912 
;     913 		#ifndef BOOT_PROGRAM
;     914 
;     915 		DDRD=0x1C;
;     916 
;     917 		// External Interrupt(s) initialization
;     918 		// INT0: Off
;     919 		// INT1: Off
;     920 		MCUCR=0x00;
;     921 
;     922 		// Analog Comparator initialization
;     923 		// Analog Comparator: Off
;     924 		// Analog Comparator Input Capture by Timer/Counter 1: Off
;     925 		ACSR=0x80;
;     926 		SFIOR=0x00;
;     927 
;     928 		// Инициализируем таймера 
;     929 		// Timer/Counter 0 initialization; Clock value: 7,813 kHz; 
;     930 		TCCR0=0x00;
;     931 		TCNT0=0x00;   
;     932 
;     933 
;     934 		//Timer/Counter 2 initialization; Clock value: 7,813 kHz
;     935 		// Mode: Normal top=FFh;
;     936 		// Таймаут ожидания ответного пакета при GEN_CALL (200 ms)
;     937 		ASSR=0x00;
;     938 		TCCR2=0x00;
;     939 		TCNT2=0x00;
;     940 		OCR2=0x00;     
;     941 		
;     942 		// Timer/Counter 1 initialization
;     943 		// Clock source: System Clock; Clock value: 7,813 kHz
;     944 		// Mode: Normal top=FFFFh; Таймаут опроса устройства RS-232
;     945 		TCCR1A=0x00;
;     946 		TCCR1B=0x85;
;     947 		TCNT1H=0x00;
;     948 		TCNT1L=0x00;
;     949 		ICR1H=0x67;
;     950 		ICR1L=0x69;
;     951 		OCR1AH=0x00;
;     952 		OCR1AL=0x00;
;     953 		OCR1BH=0x00;
;     954 		OCR1BL=0x00;
;     955 
;     956 		// Timer(s)/Counter(s) Interrupt(s) initialization
;     957 		TIMSK=0x45;
;     958 
;     959 		#else
;     960 
;     961 		// Timer/Counter 1 initialization
;     962 		// Clock source: System Clock; Clock value: 7,813 kHz
;     963 		// Mode: Normal top=FFFFh; Таймаут опроса устройства RS-232
;     964 		TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
;     965 		TCNT1=0xD2F6;		//примерно 2сек
	RCALL SUBOPT_0x4
;     966 
;     967 		// Вотчдог
;     968 //		WDTCR=0x1F;
;     969 //		WDTCR=0x0F;              
;     970 		#endif
;     971 
;     972 		
;     973 
;     974 		// USART initialization
;     975 		// Communication Parameters: 8 Data, 1 Stop, No Parity
;     976 		// USART Receiver: On
;     977 		// USART Transmitter: On
;     978 		// USART Mode: Asynchronous
;     979 		// USART Baud rate: 38400
;     980 //		UCSRA=0x00;
;     981 		UCSRB=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
;     982 		UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
;     983 //		UBRRH=0x00;
;     984 		UBRRL=0x0C;
	LDI  R30,LOW(12)
	OUT  0x9,R30
;     985 
;     986 		// Initialise TWI module for slave operation. Include address and/or enable General Call.
;     987 		// Читаем свой адрес
;     988 		TWI_slaveAddress += (PINC & 0b00000111);
	IN   R30,0x13
	ANDI R30,LOW(0x7)
	ADD  R5,R30
;     989 		TWI_Slave_Initialise( (TWI_slaveAddress<<TWI_ADR_BITS) | (TRUE<<TWI_GEN_BIT) ); 
	MOV  R30,R5
	LSL  R30
	ORI  R30,1
	ST   -Y,R30
	RCALL _TWI_Slave_Initialise
;     990  }                                  
	RET
;     991 
;     992 
;     993 // Считаем CRC передаваемого пакета
;     994 unsigned char calc_CRC (unsigned char *Position_in_Packet)
;     995 {                    
_calc_CRC:
;     996 	unsigned char CRC = 0, a;                                   
;     997 
;     998 	a = *Position_in_Packet ;
	RCALL __SAVELOCR2
;	*Position_in_Packet -> Y+2
;	CRC -> R16
;	a -> R17
	LDI  R16,0
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R17,X
;     999 	
;    1000 	while(a--)
_0x54:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x56
;    1001 	{
;    1002 		CRC += *Position_in_Packet++;
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X+
	STD  Y+2,R26
	STD  Y+2+1,R27
	ADD  R16,R30
;    1003 	}
	RJMP _0x54
_0x56:
;    1004 
;    1005 	return CRC;
	MOV  R30,R16
	RCALL __LOADLOCR2
	ADIW R28,4
	RET
;    1006 }
;    1007 
;    1008 // Упаковка пакета во внешний...
;    1009 void packPacket (unsigned char type)
;    1010 {
_packPacket:
;    1011 		txBufferTWI[0] = txBufferTWI[Start_Position_for_Reply]+3;				// ДЛИНА
	__GETB1MN _txBufferTWI,2
	SUBI R30,-LOW(3)
	STS  _txBufferTWI,R30
;    1012 		txBufferTWI[1] = type;																	// ТИП
	LD   R30,Y
	__PUTB1MN _txBufferTWI,1
;    1013 
;    1014 		txBufferTWI[txBufferTWI[0]] = calc_CRC( &txBufferTWI[0] );           //CRC
	LDS  R30,_txBufferTWI
	LDI  R31,0
	SUBI R30,LOW(-_txBufferTWI)
	SBCI R31,HIGH(-_txBufferTWI)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(_txBufferTWI)
	LDI  R31,HIGH(_txBufferTWI)
	RCALL SUBOPT_0x0
	POP  R26
	POP  R27
	ST   X,R30
;    1015 		TWI_TX_Packet_Present = 1;		// есть пакет на передачу
	SET
	BLD  R2,2
;    1016 }
	RJMP _0x75
;    1017 
;    1018 
;    1019 // считаем КС принятого пакета. Указатель - на начало пакета.
;    1020 unsigned char checkCRCrx (unsigned char *Position_in_Packet, unsigned char Incoming_PORT)
;    1021 {                    
_checkCRCrx:
;    1022 	unsigned char CRC=0 , a;		
;    1023 	
;    1024 	// Из TWI - начинаем считать с заголовка
;    1025     if ( Incoming_PORT == from_TWI ) CRC = *Position_in_Packet ++;  // заголовок пакета
	RCALL __SAVELOCR2
;	*Position_in_Packet -> Y+3
;	Incoming_PORT -> Y+2
;	CRC -> R16
;	a -> R17
	LDI  R16,0
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0x57
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LD   R16,X+
	STD  Y+3,R26
	STD  Y+3+1,R27
;    1026     
;    1027 	// Из UART - начинаем считать с длины
;    1028 	a = *Position_in_Packet ;
_0x57:
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LD   R17,X
;    1029 	
;    1030 	while(a--)
_0x58:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x5A
;    1031 	{
;    1032 		CRC += *Position_in_Packet++;
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LD   R30,X+
	STD  Y+3,R26
	STD  Y+3+1,R27
	ADD  R16,R30
;    1033 	}
	RJMP _0x58
_0x5A:
;    1034 
;    1035 	if (CRC == *Position_in_Packet)	
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LD   R30,X
	CP   R30,R16
	BRNE _0x5B
;    1036 			return TRUE; 										//Ok
	LDI  R30,LOW(1)
	RJMP _0x76
;    1037 
;    1038 	else	return FALSE;                                      // Error
_0x5B:
	LDI  R30,LOW(0)
;    1039 }
_0x76:
	RCALL __LOADLOCR2
	ADIW R28,5
	RET
;    1040 
;    1041 
;    1042 unsigned char TWI_Act_On_Failure_In_Last_Transmission ( unsigned char TWIerrorMsg )
;    1043 {
_TWI_Act_On_Failure_In_Last_Transmission:
;    1044                     // A failure has occurred, use TWIerrorMsg to determine the nature of the failure
;    1045                     // and take appropriate actions.
;    1046                     // Se header file for a list of possible failures messages.
;    1047   
;    1048                     // This very simple example puts the error code on PORTB and restarts the transceiver with
;    1049                     // all the same data in the transmission buffers.
;    1050 //  PORTB = TWIerrorMsg;
;    1051   TWI_Start_Transceiver();
	RCALL _TWI_Start_Transceiver
;    1052                     
;    1053   return TWIerrorMsg; 
	LD   R30,Y
_0x75:
	ADIW R28,1
	RET
;    1054 }
;    1055 
;    1056 
;    1057 void run_TWI_slave ( void )
;    1058 {
_run_TWI_slave:
;    1059   // This example is made to work together with the AVR315 TWI Master application note. In adition to connecting the TWI
;    1060   // pins, also connect PORTB to the LEDS. The code reads a message as a TWI slave and acts according to if it is a 
;    1061   // general call, or an address call. If it is an address call, then the first byte is considered a command byte and
;    1062   // it then responds differently according to the commands.
;    1063 
;    1064     // Check if the TWI Transceiver has completed an operation.
;    1065     if ( ! TWI_Transceiver_Busy() )                              
	RCALL SUBOPT_0x5
	BREQ PC+2
	RJMP _0x5D
;    1066     {
;    1067     // Check if the last operation was successful
;    1068       if ( TWI_statusReg.bits.lastTransOK )
	RCALL SUBOPT_0xA
	BREQ _0x5E
;    1069       {
;    1070     // Check if the last operation was a reception
;    1071         if ( TWI_statusReg.bits.RxDataInBuf )
	LDS  R30,_TWI_statusReg
	ANDI R30,LOW(0x2)
	BREQ _0x5F
;    1072         {
;    1073           TWI_Get_Data_From_Transceiver(rxBufferTWI, 3);         
	RCALL SUBOPT_0xE
	LDI  R30,LOW(3)
	RCALL SUBOPT_0xF
;    1074     // Check if the last operation was a reception as General Call 
;    1075 	// Глобальный адрес пока отдельно не анализирую
;    1076           if ( TWI_statusReg.bits.genAddressCall )
	LDS  R30,_TWI_statusReg
	ANDI R30,LOW(0x4)
	BREQ _0x60
;    1077           {
;    1078 /*				#ifndef BOOT_PROGRAM
;    1079 					if ( Device_Connected )
;    1080 							Wait_Responce ( START_Timer );  
;    1081 				#endif	*/
;    1082           }
;    1083 
;    1084 		  // Ends up here if the last operation was a reception as Slave Address Match                  
;    1085 /*          else
;    1086           {*/
;    1087 			switch ( TWI_RX_Command )
_0x60:
	LDS  R30,_rxBufferTWI
;    1088 			{
;    1089 				case  TWI_CMD_MASTER_WRITE:
	CPI  R30,LOW(0x10)
	BRNE _0x64
;    1090 						// дочитываем принятые данные	
;    1091 						TWI_Get_Data_From_Transceiver(rxBufferTWI, Long_RX_Packet_TWI+3 );
	RCALL SUBOPT_0xE
	__GETB1MN _rxBufferTWI,2
	SUBI R30,-LOW(3)
	RCALL SUBOPT_0xF
;    1092 						// проверяем КС  
;    1093 						if ( checkCRCrx ( &Heading_RX_Packet , from_TWI ) )
	__POINTW1MN _rxBufferTWI,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _checkCRCrx
	CPI  R30,0
	BREQ _0x65
;    1094 								rxPack = 1;	 
	LDI  R30,LOW(1)
	MOV  R4,R30
;    1095 #ifdef aaa
;    1096     putchar (0xaa);
;    1097 #endif    
;    1098 						break;
_0x65:
	RJMP _0x63
;    1099 
;    1100 
;    1101 				case  TWI_CMD_MASTER_READ:
_0x64:
	CPI  R30,LOW(0x20)
	BRNE _0x66
;    1102                          // новых пакетов нет
;    1103 						if ( ! TWI_TX_Packet_Present)
	SBRC R2,2
	RJMP _0x67
;    1104 						{
;    1105 								txBufferTWI[0] = 0;
	LDI  R30,LOW(0)
	STS  _txBufferTWI,R30
;    1106 
;    1107 						}
;    1108 
;    1109 #ifdef aaa
;    1110     putchar (0xac);
;    1111 	txBufferTWI[0] = 0;
;    1112 #endif    
;    1113 						TWI_Start_Transceiver_With_Data( txBufferTWI, txBufferTWI[0]+1 );           
_0x67:
	RJMP _0x7C
;    1114 						break;
;    1115 
;    1116 				case  TWI_CMD_MASTER_RECIVE_PACK_OK:
_0x66:
	CPI  R30,LOW(0x21)
	BRNE _0x69
;    1117 						TWI_TX_Packet_Present = 0;			// мастер принял пакет без ошибок
	CLT
	BLD  R2,2
;    1118 						txBufferTWI[0] = 0;     					// данных на передачу нет
;    1119                         
;    1120 						TWI_Start_Transceiver_With_Data( txBufferTWI, txBufferTWI[0]+1 );           
;    1121 						break;
;    1122 
;    1123 
;    1124 				default:	
_0x69:
;    1125 						txBufferTWI[0] = 0;     	// передаем пустой пакет
_0x7D:
	LDI  R30,LOW(0)
	STS  _txBufferTWI,R30
;    1126 
;    1127 						TWI_Start_Transceiver_With_Data( txBufferTWI, txBufferTWI[0]+1 );           
_0x7C:
	LDI  R30,LOW(_txBufferTWI)
	LDI  R31,HIGH(_txBufferTWI)
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_txBufferTWI
	SUBI R30,-LOW(1)
	ST   -Y,R30
	RCALL _TWI_Start_Transceiver_With_Data
;    1128 //			}
;    1129           }
_0x63:
;    1130         }
;    1131 
;    1132     // Check if the TWI Transceiver has already been started.
;    1133     // If not then restart it to prepare it for new receptions.             
;    1134         if ( ! TWI_Transceiver_Busy() )
_0x5F:
	RCALL SUBOPT_0x5
	BRNE _0x6A
;    1135         {
;    1136           TWI_Start_Transceiver();
	RCALL _TWI_Start_Transceiver
;    1137         }      
;    1138       }
_0x6A:
;    1139     // Ends up here if the last operation completed unsuccessfully
;    1140       else
	RJMP _0x6B
_0x5E:
;    1141       {
;    1142         TWI_Act_On_Failure_In_Last_Transmission( TWI_Get_State_Info() );
	RCALL _TWI_Get_State_Info
	ST   -Y,R30
	RCALL _TWI_Act_On_Failure_In_Last_Transmission
;    1143       }
_0x6B:
;    1144     }
;    1145   }
_0x5D:
	RET
;    1146 //--------------------------------------------------------------------------------------
;    1147 // Функции для работы с FLASH
;    1148 
;    1149 #include "CodingM8.h"      
;    1150 #include "monitor.h"
;    1151 
;    1152 #if (defined _CHIP_ATMEGA128L_) || (defined _CHIP_ATMEGA128_)
;    1153 	#asm
;    1154 		.equ	SPMCSR = 0x68
;    1155 		.equ	SPMREG = SPMCSR
;    1156 	#endasm
;    1157 #elif (defined _CHIP_ATMEGA8_) || (defined _CHIP_ATMEGA8L_) || (defined _CHIP_ATMEGA8515_) || (defined _CHIP_ATMEGA8515L_) || (defined _CHIP_ATMEGA162_) || (defined _CHIP_ATMEGA162L_)
;    1158 	#asm
;    1159 		.equ	SPMCR  = 0x37
		.equ	SPMCR  = 0x37
;    1160 		.equ	SPMREG = SPMCR
		.equ	SPMREG = SPMCR
;    1161 	#endasm
;    1162 #else
;    1163 	#error Поддержка для этого процессора еще не написана
;    1164 #endif
;    1165 
;    1166 #asm
;    1167 	.equ	SPMEN  = 0	; Биты регистра
	.equ	SPMEN  = 0	; Биты регистра
;    1168 	.equ	PGERS  = 1
	.equ	PGERS  = 1
;    1169 	.equ	PGWRT  = 2
	.equ	PGWRT  = 2
;    1170 	.equ	BLBSET = 3
	.equ	BLBSET = 3
;    1171 	.equ	RWWSRE = 4
	.equ	RWWSRE = 4
;    1172 	.equ	RWWSB  = 6
	.equ	RWWSB  = 6
;    1173 	.equ	SPMIE  = 7
	.equ	SPMIE  = 7
;    1174 	;--------------------------------------------------
	;--------------------------------------------------
;    1175 	; Ожидание завершения SPM. Портит R23
	; Ожидание завершения SPM. Портит R23
;    1176 	spmWait:
	spmWait:
;    1177 #endasm
;    1178 #ifdef USE_MEM_SPM
;    1179 	#asm
;    1180 		lds		r23, SPMREG
;    1181 	#endasm
;    1182 #else
;    1183 	#asm
;    1184 		in		r23, SPMREG
		in		r23, SPMREG
;    1185 	#endasm
;    1186 #endif
;    1187 #asm
;    1188 		andi	r23, (1 << SPMEN)
		andi	r23, (1 << SPMEN)
;    1189 		brne	spmWait	
		brne	spmWait	
;    1190 		ret
		ret
;    1191 	;--------------------------------------------------
	;--------------------------------------------------
;    1192 	; Запуск SPM.
	; Запуск SPM.
;    1193 	spmSPM:
	spmSPM:
;    1194 		in		r24, SREG	; Сохраняю состояние
		in		r24, SREG	; Сохраняю состояние
;    1195 		cli					; Запрещаю прерывания
		cli					; Запрещаю прерывания
;    1196 #endasm
;    1197 #ifdef USE_RAMPZ
;    1198 	#asm
;    1199 		in		r25, RAMPZ	; Сохраняю RAMPZ
;    1200 	#endasm
;    1201 #endif
;    1202 #asm
;    1203 		ld		r30, y		; Адрес
		ld		r30, y		; Адрес
;    1204 		ldd		r31, y+1
		ldd		r31, y+1
;    1205 #endasm
;    1206 #ifdef USE_RAMPZ
;    1207 	#asm
;    1208 		ldd		r26, y+2	; 3-й байт адреса - в RAMPZ
;    1209 		out		RAMPZ, r26
;    1210 	#endasm
;    1211 #endif
;    1212 #asm
;    1213 		rcall	spmWait		; Жду завершения предидущей операции (на всякий случай)
		rcall	spmWait		; Жду завершения предидущей операции (на всякий случай)
;    1214 #endasm
;    1215 #ifdef USE_MEM_SPM
;    1216 	#asm
;    1217 		sts SPMREG, r22		; Регистр команд, как память
;    1218 	#endasm
;    1219 #else
;    1220 	#asm
;    1221 		out SPMREG, r22		; Регистр команд, как порт
		out SPMREG, r22		; Регистр команд, как порт
;    1222 	#endasm
;    1223 #endif
;    1224 #asm
;    1225 		spm					; Запуск на выполнение
		spm					; Запуск на выполнение
;    1226 		nop
		nop
;    1227 		nop
		nop
;    1228 		nop
		nop
;    1229 		nop
		nop
;    1230 		rcall	spmWait		; Жду завершения
		rcall	spmWait		; Жду завершения
;    1231 #endasm
;    1232 #ifdef USE_RAMPZ
;    1233 	#asm
;    1234 		out		RAMPZ, r25	; Восстанавливаю состояние
;    1235 	#endasm
;    1236 #endif
;    1237 #asm
;    1238 		out		SREG, r24
		out		SREG, r24
;    1239 		ret
		ret
;    1240 #endasm
;    1241 
;    1242 #pragma warn-
;    1243 void ResetTempBuffer (FADDRTYPE addr)
;    1244 {
_ResetTempBuffer:
;    1245 	#asm
;    1246 		ldi		r22, (1 << RWWSRE) | (1 << SPMEN)
		ldi		r22, (1 << RWWSRE) | (1 << SPMEN)
;    1247 		rcall	spmSPM
		rcall	spmSPM
;    1248 	#endasm
;    1249 }
	ADIW R28,2
	RET
;    1250 
;    1251 void FillTempBuffer (unsigned short data, FADDRTYPE addr)
;    1252 {
_FillTempBuffer:
;    1253 	#ifdef USE_RAMPZ
;    1254 		#asm
;    1255 			ldd		r0, y+4			; Данные
;    1256 			ldd		r1,	y+5
;    1257 		#endasm
;    1258 	#else
;    1259 		#asm
;    1260 			ldd		r0, y+2			; Данные
			ldd		r0, y+2			; Данные
;    1261 			ldd		r1,	y+3
			ldd		r1,	y+3
;    1262 		#endasm
;    1263 	#endif
;    1264 	#asm
;    1265 		ldi		r22, (1 << SPMEN)	; Команда
		ldi		r22, (1 << SPMEN)	; Команда
;    1266 		rcall	spmSPM				; На выполнение
		rcall	spmSPM				; На выполнение
;    1267 	#endasm
;    1268 }
	ADIW R28,4
	RET
;    1269 
;    1270 void PageErase (FADDRTYPE  addr)
;    1271 {
_PageErase:
;    1272 	#asm
;    1273 		ldi		r22, (1 << PGERS) | (1 << SPMEN)
		ldi		r22, (1 << PGERS) | (1 << SPMEN)
;    1274 		rcall	spmSPM
		rcall	spmSPM
;    1275 	#endasm
;    1276 }
	ADIW R28,2
	RET
;    1277 
;    1278 void PageWrite (FADDRTYPE addr)
;    1279 {
_PageWrite:
;    1280 	#asm
;    1281 		ldi		r22, (1 << PGWRT) | (1 << SPMEN)
		ldi		r22, (1 << PGWRT) | (1 << SPMEN)
;    1282 		rcall	spmSPM
		rcall	spmSPM
;    1283 	#endasm
;    1284 }
	ADIW R28,2
	RET
;    1285 #pragma warn+
;    1286 
;    1287 void PageAccess (void)
;    1288 {
_PageAccess:
;    1289 	#asm
;    1290 		ldi		r22, (1 << RWWSRE) | (1 << SPMEN)
		ldi		r22, (1 << RWWSRE) | (1 << SPMEN)
;    1291 		rcall	spmSPM
		rcall	spmSPM
;    1292 	#endasm
;    1293 }
	RET
;    1294 
;    1295 // Запись страницы FLASH
;    1296 void WriteFlash(void)
;    1297 {
_WriteFlash:
;    1298 	unsigned char a = 5;
;    1299 	FADDRTYPE faddr;
;    1300 
;    1301 	// Получаю номер страницы
;    1302 	#asm ("wdr");
	RCALL __SAVELOCR3
;	a -> R16
;	faddr -> R17,R18
	LDI  R16,5
	wdr
;    1303 	faddr = GetWordBuff(a);
	RCALL SUBOPT_0x10
	__PUTW1R 17,18
;    1304 	a+=2;							// вычитали 2 байта
	SUBI R16,-LOW(2)
;    1305 	
;    1306 	if (faddr >= PRGPAGES)
	__CPWRN 17,18,96
	BRLO _0x6C
;    1307 	{
;    1308 		while(1);	// Если неправильный номер страницы - непоправимая ошибка и вылет по вотчдогу
_0x6D:
	RJMP _0x6D
;    1309 	}	            
;    1310 	
;    1311 
;    1312 	// Получаю адрес начала страницы
;    1313 	faddr <<= (ZPAGEMSB + 1);
_0x6C:
	__GETW2R 17,18
	LDI  R30,LOW(6)
	RCALL __LSLW12
	__PUTW1R 17,18
;    1314 	
;    1315 	// Загрузка данных в промежуточный буфер
;    1316 	#asm ("wdr");
	wdr
;    1317 	ResetTempBuffer(faddr);
	ST   -Y,R18
	ST   -Y,R17
	RCALL _ResetTempBuffer
;    1318 	do{
_0x71:
;    1319 			FillTempBuffer(GetWordBuff(a), faddr);			// 
	RCALL SUBOPT_0x10
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R18
	ST   -Y,R17
	RCALL _FillTempBuffer
;    1320 			a+=2;
	SUBI R16,-LOW(2)
;    1321 			faddr += 2;
	__ADDWRN 17,18,2
;    1322     	}while (faddr & (PAGESIZ-1)) ;	
	MOV  R30,R17
	ANDI R30,LOW(0x3F)
	BRNE _0x71
;    1323 
;    1324 		// Сигналю, что все в порядке и можно посылать следующий
;    1325 //		#asm ("wdr");
;    1326 //		txBufferTWI[0] = 2;                   		// длина
;    1327 //		txBufferTWI[1] = RES_OK;
;    1328 //		txBufferTWI[2] = 2 + RES_OK;         // КС*/
;    1329 
;    1330 	// Восстанавливаю адрес начала страницы
;    1331 	faddr -= PAGESIZ;
	__SUBWRN 17,18,64
;    1332 
;    1333 	// Стираю страницу
;    1334 //	#asm ("wdr");
;    1335 	PageErase(faddr);
	ST   -Y,R18
	ST   -Y,R17
	RCALL _PageErase
;    1336 	
;    1337 	// Записываю страницу
;    1338 	#asm ("wdr");
	wdr
;    1339 	PageWrite(faddr);
	ST   -Y,R18
	ST   -Y,R17
	RCALL _PageWrite
;    1340 
;    1341 	// Разрешить адресацию области RWW
;    1342 	#asm ("wdr");
	wdr
;    1343 	PageAccess();
	RCALL _PageAccess
;    1344 
;    1345 	// Сигналю, что все в порядке и можно посылать следующий
;    1346 //	#asm ("wdr");
;    1347 		txBufferTWI[Start_Position_for_Reply] = 2;                   		// длина
	LDI  R30,LOW(2)
	__PUTB1MN _txBufferTWI,2
;    1348 		txBufferTWI[Start_Position_for_Reply+1] = RES_OK;
	LDI  R30,LOW(1)
	__PUTB1MN _txBufferTWI,3
;    1349 		txBufferTWI[Start_Position_for_Reply+2] = 2 + RES_OK;         // КС*/
	LDI  R30,LOW(3)
	__PUTB1MN _txBufferTWI,4
;    1350 }
	RCALL __LOADLOCR3
	ADIW R28,3
	RET
;    1351  
;    1352 ///////////////////////////////////////////////////////////////////////////////////////////
;    1353 // Дешифрование программирующих данных
;    1354 
;    1355 unsigned long int next_rand = 1;

	.DSEG
_next_rand:
	.BYTE 0x4
;    1356 unsigned char rand_cnt = 31;
;    1357 
;    1358 // Генератор псевдослучайной последовательности.
;    1359 // За основу взяты IAR-овские исходники
;    1360 
;    1361 bit descramble = 0;					// Признак необходимости дешифрования
;    1362 
;    1363 unsigned char NextSeqByte(void)	// Очередной байт дешифрующей последовательности
;    1364 {

	.CSEG
_NextSeqByte:
;    1365 	next_rand = next_rand * 1103515245 + 12345;
	LDS  R26,_next_rand
	LDS  R27,_next_rand+1
	LDS  R24,_next_rand+2
	LDS  R25,_next_rand+3
	__GETD1N 0x41C64E6D
	RCALL __MULD12U
	__ADDD1N 12345
	STS  _next_rand,R30
	STS  _next_rand+1,R31
	STS  _next_rand+2,R22
	STS  _next_rand+3,R23
;    1366 	next_rand >>= 8;
	LDS  R26,_next_rand
	LDS  R27,_next_rand+1
	LDS  R24,_next_rand+2
	LDS  R25,_next_rand+3
	LDI  R30,LOW(8)
	RCALL __LSRD12
	STS  _next_rand,R30
	STS  _next_rand+1,R31
	STS  _next_rand+2,R22
	STS  _next_rand+3,R23
;    1367 	
;    1368 	rand_cnt += 101;
	LDI  R30,LOW(101)
	ADD  R7,R30
;    1369 		
;    1370 	return rand_cnt ^ (unsigned char)next_rand;
	LDS  R30,_next_rand
	EOR  R30,R7
	RET
;    1371 }
;    1372 
;    1373 void ResetDescrambling(void)		// Перезапуск генератора дешифрующей последовательности
;    1374 {
_ResetDescrambling:
;    1375 	next_rand = scrambling_seed;
	LDI  R30,LOW(_scrambling_seed*2)
	LDI  R31,HIGH(_scrambling_seed*2)
	RCALL __GETW1PF
	CLR  R22
	CLR  R23
	STS  _next_rand,R30
	STS  _next_rand+1,R31
	STS  _next_rand+2,R22
	STS  _next_rand+3,R23
;    1376 	rand_cnt = 31;
	LDI  R30,LOW(31)
	MOV  R7,R30
;    1377 	descramble = 0;
	CLT
	BLD  R2,1
;    1378 }
	RET

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
	ST   -Y,R31
	ST   -Y,R30
	RJMP _calc_CRC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1:
	LDI  R31,0
	SUBI R30,LOW(-_rxBufferTWI)
	SBCI R31,HIGH(-_rxBufferTWI)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2:
	LPM  R30,Z
	LDI  R31,0
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3:
	LPM  R30,Z
	MOV  R31,R30
	LDI  R30,0
	OR   R30,R26
	OR   R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x4:
	LDI  R30,LOW(54006)
	LDI  R31,HIGH(54006)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0x5:
	RCALL _TWI_Transceiver_Busy
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6:
	LDD  R30,Y+1
	CP   R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x7:
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_TWI_buf_G2)
	SBCI R31,HIGH(-_TWI_buf_G2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x8:
	MOV  R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x9:
	LDI  R30,LOW(0)
	STS  _TWI_statusReg,R30
	LDI  R30,LOW(248)
	STS  _TWI_state_G2,R30
	LDI  R30,LOW(197)
	OUT  0x36,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xA:
	LDS  R30,_TWI_statusReg
	ANDI R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xB:
	MOV  R30,R6
	INC  R6
	LDI  R31,0
	SUBI R30,LOW(-_TWI_buf_G2)
	SBCI R31,HIGH(-_TWI_buf_G2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xC:
	LDS  R30,_TWI_statusReg
	ORI  R30,1
	STS  _TWI_statusReg,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xD:
	IN   R30,0x1
	STS  _TWI_state_G2,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xE:
	LDI  R30,LOW(_rxBufferTWI)
	LDI  R31,HIGH(_rxBufferTWI)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xF:
	ST   -Y,R30
	RJMP _TWI_Get_Data_From_Transceiver

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x10:
	ST   -Y,R16
	RJMP _GetWordBuff

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

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
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

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
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
