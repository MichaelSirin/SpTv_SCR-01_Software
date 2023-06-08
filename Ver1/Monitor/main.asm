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
;       1 ////////////////////////////////////////////////////////////////////////////////////////////
;       2 // Монитор - загрузчик FLASH и EEPROM
;       3 ////////////////////////////////////////////////////////////////////////////////////////////
;       4 #include "monitor.h" 
;       5 #include "CodingM8.h"      
;       6 #include "stdio.h"  
;       7 #include "string.h"  
;       8 
;       9 flash unsigned char device_name[32] =					// Имя устройства

	.CSEG
;      10 		"Boot Program. Port";
;      11 eeprom unsigned long my_ser_num = 1;					// Серийный номер устройства

	.ESEG
_my_ser_num:
	.DW  0x1
	.DW  0x0
;      12 const flash unsigned short my_version = 1;			// Версия софта 

	.CSEG
;      13 eeprom unsigned char my_addr = TO_MON;					// Мой адрес - изначально TO_MON

	.ESEG
_my_addr:
	.DB  0xFE
;      14     
;      15 
;      16 unsigned char pAddr;				// Адрес устройства по шине TWI

	.DSEG
_pAddr:
	.BYTE 0x1
;      17 unsigned char adr;									// адрес в пришедшем пакете
;      18 unsigned char typePack;							// тип принятого пакета
;      19 
;      20 
;      21 //bit 		ping		 			=		0;					// Признак что прошел первый пинг	
;      22 bit	dannForTX			=		0;					// Есть данные на передачу
;      23 bit	toReboot				=		0;					// перезагружаем в рабочую программу
;      24 	
;      25 unsigned char txBuffer[128];								// передающий буффер
_txBuffer:
	.BYTE 0x80
;      26 unsigned char rxBuffer[128];								// приемный буффер
_rxBuffer:
	.BYTE 0x80
;      27 
;      28 
;      29 // Вернуть информацию о мониторе и процессоре
;      30 void PrgInfo(void)
;      31 {

	.CSEG
_PrgInfo:
;      32 	// Отправляю ответ
;      33 	#asm("wdr");
	wdr
;      34 	txBuffer[0] = (sizeof(RP_PRGINFO));
	LDI  R30,LOW(8)
	STS  _txBuffer,R30
;      35 
;      36 	#asm("wdr");
	wdr
;      37 	txBuffer[1] = (PAGESIZ);     			//мл.
	LDI  R30,LOW(64)
	__PUTB1MN _txBuffer,1
;      38 	txBuffer[2] = (PAGESIZ>>8);          //ст.
	LDI  R30,LOW(0)
	__PUTB1MN _txBuffer,2
;      39 
;      40 	#asm("wdr");
	wdr
;      41 	txBuffer[3] = (PRGPAGES);
	LDI  R30,LOW(96)
	__PUTB1MN _txBuffer,3
;      42 	txBuffer[4] = (PRGPAGES>>8);
	LDI  R30,LOW(0)
	__PUTB1MN _txBuffer,4
;      43 
;      44 	#asm("wdr");
	wdr
;      45 	txBuffer[5] = (EEPROMSIZ);
	LDI  R30,LOW(512)
	__PUTB1MN _txBuffer,5
;      46 	txBuffer[6] = (EEPROMSIZ>>8);
	LDI  R30,LOW(2)
	__PUTB1MN _txBuffer,6
;      47 
;      48 	#asm("wdr");
	wdr
;      49 	txBuffer[7] = (MONITORVERSION);
	LDI  R30,LOW(256)
	__PUTB1MN _txBuffer,7
;      50 	txBuffer[8] = (MONITORVERSION>>8);
	LDI  R30,LOW(1)
	__PUTB1MN _txBuffer,8
;      51 
;      52 	#asm("wdr");
	wdr
;      53 	dannForTX = 1;								// есть данные	
	SET
	BLD  R2,2
;      54 
;      55 	// Перешел в режим программирования - теперь могу долго ждать очередной пакет
;      56 	prgmode = 1;
	BLD  R2,0
;      57 	
;      58 	// Обнуляю генератор дешифрующей последовательности
;      59 	ResetDescrambling();
	RCALL _ResetDescrambling
;      60 }
	RET
;      61 
;      62 // Запись в EEPROM
;      63 void WriteEeprom(void)
;      64 {
_WriteEeprom:
;      65 	register unsigned short addr;
;      66 	register unsigned char  data;
;      67 
;      68 	// Прием адреса и данных	
;      69 	#asm ("wdr");
	RCALL __SAVELOCR3
;	addr -> R16,R17
;	data -> R18
	wdr
;      70 	addr = GetWordBuff(0);
	RCALL SUBOPT_0x0
	RCALL _GetWordBuff
	MOVW R16,R30
;      71 	
;      72 	// Проверяю завершение и корректность пакета
;      73 	if (addr >= EEPROMSIZ)
	__CPWRN 16,17,512
	BRLO _0x3
;      74 	{
;      75 			txBuffer[0] = 1;        				// длина
	RCALL SUBOPT_0x1
;      76 			txBuffer[1] = RES_ERR;			//  ошибка
	__PUTB1MN _txBuffer,1
;      77 			dannForTX = 1;						// есть данные	
	SET
	BLD  R2,2
;      78 
;      79 		return;
	RJMP _0x5A
;      80 	}
;      81 	
;      82 	// Пишу в EEPROM
;      83 	*((char eeprom *)addr) = data;
_0x3:
	MOV  R30,R18
	MOVW R26,R16
	RCALL __EEPROMWRB
;      84 	
;      85 	// Проверяю, записалось ли
;      86 	if (*((char eeprom *)addr) != data)
	MOVW R26,R16
	RCALL __EEPROMRDB
	CP   R18,R30
	BREQ _0x4
;      87 	{
;      88 			txBuffer[0] = 1;        				// длина
	RCALL SUBOPT_0x1
;      89 			txBuffer[1] = RES_ERR;			//  ошибка
	__PUTB1MN _txBuffer,1
;      90 			dannForTX = 1;						// есть данные	
	SET
	BLD  R2,2
;      91 		return;
_0x5A:
	RCALL __LOADLOCR3
	ADIW R28,3
	RET
;      92 	}
;      93 
;      94 	// Сигналю, что все в порядке 
;      95 	#asm ("wdr");                                                        
_0x4:
	wdr
;      96 			txBuffer[0] = 1;        				// длина
	RCALL SUBOPT_0x2
;      97 			txBuffer[1] = RES_OK;			
	__PUTB1MN _txBuffer,1
;      98 			dannForTX = 1;						// есть данные	
	SET
	BLD  R2,2
;      99 }
	RCALL SUBOPT_0x3
	RET
;     100 
;     101 // Чтение байта из FLASH по адресу
;     102 #ifdef USE_RAMPZ
;     103 	#pragma warn-
;     104 	unsigned char FlashByte(FADDRTYPE addr)
;     105 	{
;     106 	#asm
;     107 		ld		r30, y		; Загружаю Z
;     108 		ldd		r31, y+1
;     109 		
;     110 		in		r23, rampz	; Сохраняю RAMPZ
;     111 		
;     112 		ldd		r22, y+2	; Переношу RAMPZ
;     113 		out		rampz, r22
;     114 		
;     115 		elpm	r24, z		; Читаю FLASH
;     116 		
;     117 		out		rampz, r23	; Восстанавливаю RAMPZ
;     118 
;     119 		mov		r30, r24	; Возвращаемое значение
;     120 	#endasm
;     121 	}	
;     122 	#pragma warn+
;     123 #else
;     124 	#define FlashByte(a) (*((flash unsigned char *)a))
;     125 #endif
;     126 
;     127 // Проверка наличия "рабочей" программы
;     128 unsigned char AppOk(void)
;     129 {
_AppOk:
;     130 	FADDRTYPE addr, lastaddr;
;     131 	unsigned short crc, fcrc;
;     132 	
;     133 	#asm("wdr");
	SBIW R28,2
	RCALL __SAVELOCR6
;	addr -> R16,R17
;	lastaddr -> R18,R19
;	crc -> R20,R21
;	fcrc -> Y+6
	wdr
;     134 	
;     135 	lastaddr = ( (FADDRTYPE)FlashByte(PRGPAGES*PAGESIZ - 4) | 
;     136 	            ((FADDRTYPE)FlashByte(PRGPAGES*PAGESIZ - 3) << 8))
;     137 	            << (ZPAGEMSB + 1);
	LDI  R30,LOW(6140)
	LDI  R31,HIGH(6140)
	RCALL SUBOPT_0x4
	LDI  R30,LOW(6141)
	LDI  R31,HIGH(6141)
	RCALL SUBOPT_0x5
	RCALL __LSLW2
	RCALL __LSLW4
	MOVW R18,R30
;     138 	            
;     139 
;     140 	if (lastaddr == (0xFFFF << (ZPAGEMSB + 1)))
	MOVW R26,R18
	CLR  R24
	CLR  R25
	__CPD2N 0x3FFFC0
	BRNE _0x5
;     141 	{
;     142 	        return 0;
	LDI  R30,LOW(0)
	RCALL __LOADLOCR6
	ADIW R28,8
	RET
;     143 	}
;     144 	
;     145 	for (addr = 0, crc = 0; addr != lastaddr; addr ++)
_0x5:
	__GETWRN 16,17,0
	__GETWRN 20,21,0
_0x7:
	__CPWRR 18,19,16,17
	BREQ _0x8
;     146 	{
;     147 		crc += FlashByte(addr);
	MOVW R30,R16
	LPM  R30,Z
	MOVW R26,R20
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R20,R30
;     148 	}
	__ADDWRN 16,17,1
	RJMP _0x7
_0x8:
;     149 	
;     150 	#asm("wdr");
	wdr
;     151 	
;     152 	fcrc = 	 (unsigned short)FlashByte(PRGPAGES*PAGESIZ - 2) | 
;     153 			((unsigned short)FlashByte(PRGPAGES*PAGESIZ - 1) << 8);
	LDI  R30,LOW(6142)
	LDI  R31,HIGH(6142)
	RCALL SUBOPT_0x4
	LDI  R30,LOW(6143)
	LDI  R31,HIGH(6143)
	RCALL SUBOPT_0x5
	STD  Y+6,R30
	STD  Y+6+1,R31
;     154 	
;     155 	if (crc != fcrc)
	CP   R30,R20
	CPC  R31,R21
	BREQ _0x9
;     156 	{
;     157 		return 0;
	LDI  R30,LOW(0)
	RJMP _0x59
;     158 	}
;     159 	
;     160 	return 1;
_0x9:
	LDI  R30,LOW(1)
_0x59:
	RCALL __LOADLOCR6
	ADIW R28,8
	RET
;     161 }
;     162 
;     163 // Перезагрузка в рабочий режим
;     164 void RebootToWork(void)
;     165 {
_RebootToWork:
;     166 	// Проверяю, есть ли куда грузиться
;     167 	if (!AppOk())
	RCALL _AppOk
	CPI  R30,0
	BRNE _0xA
;     168 	{
;     169 		return;
	RET
;     170 	}
;     171 
;     172 	#asm("cli");
_0xA:
	cli
;     173 	IVCREG = 1 << IVCE;
	LDI  R30,LOW(1)
	OUT  0x3B,R30
;     174 	IVCREG = 0;
	LDI  R30,LOW(0)
	OUT  0x3B,R30
;     175 
;     176 //	#asm("wdr");
;     177 	#asm("rjmp 0");      //Mega128 - JMP, Mega8 - RJMP
	rjmp 0
;     178 }
	RET
;     179 
;     180 // Реакция на команду перейти в рабочий режим
;     181 void ToWorkMode(void)
;     182 {
_ToWorkMode:
;     183 
;     184 	// Отправляю ответ
;     185 	txBuffer[0] = 0;        						// подтверждаю прием
	RCALL SUBOPT_0x6
;     186 //	txBuffer[1] = 0;
;     187 	dannForTX = 1;								// есть данные
	BLD  R2,2
;     188 
;     189 	prgmode = 0;
	CLT
	BLD  R2,0
;     190 	  
;     191 	// На перезагрузку
;     192 	toReboot =1;
	SET
	BLD  R2,3
;     193 //	RebootToWork();
;     194 }
	RET
;     195 
;     196 //-----------------------------------------------------------------------------------------------------------------
;     197 
;     198 // Информация об устройстве
;     199 static void GetInfo(void)
;     200 {
_GetInfo_G1:
;     201 	register unsigned char i;
;     202 	
;     203 	// 	заполняю буфер
;     204 	txBuffer[0] = 40;
	ST   -Y,R16
;	i -> R16
	LDI  R30,LOW(40)
	STS  _txBuffer,R30
;     205 	
;     206 	for (i = 0; i < 32; i ++)	// Имя устройства
	LDI  R16,LOW(0)
_0xC:
	CPI  R16,32
	BRSH _0xD
;     207 	{
;     208 		txBuffer[i+1] = device_name[i];
	RCALL SUBOPT_0x7
	__ADDW1MN _txBuffer,1
	MOVW R26,R30
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_device_name*2)
	SBCI R31,HIGH(-_device_name*2)
	LPM  R30,Z
	ST   X,R30
;     209 	}
	SUBI R16,-1
	RJMP _0xC
_0xD:
;     210 
;     211 		txBuffer[33] = my_ser_num;           // Серийный номер
	LDI  R26,LOW(_my_ser_num)
	LDI  R27,HIGH(_my_ser_num)
	RCALL __EEPROMRDD
	__PUTB1MN _txBuffer,33
;     212 		txBuffer[34] = my_ser_num>>8;      // Серийный номер
	LDI  R26,LOW(_my_ser_num)
	LDI  R27,HIGH(_my_ser_num)
	RCALL __EEPROMRDD
	MOVW R26,R30
	MOVW R24,R22
	RCALL SUBOPT_0x8
	__PUTB1MN _txBuffer,34
;     213 
;     214 		txBuffer[35] = 0;	// Серийный номер
	LDI  R30,LOW(0)
	__PUTB1MN _txBuffer,35
;     215 		txBuffer[36] = 0;	// Серийный номер
	__PUTB1MN _txBuffer,36
;     216 	
;     217 		txBuffer[37] =pAddr ;     // Адрес устройстав
	__POINTW2MN _txBuffer,37
	LDS  R30,_pAddr
	ST   X,R30
;     218 
;     219 		txBuffer[38] =0;     // Зарезервированный байт
	LDI  R30,LOW(0)
	__PUTB1MN _txBuffer,38
;     220 	
;     221 		txBuffer[39] = my_version;             // Версия
	__POINTW2MN _txBuffer,39
	LDI  R30,LOW(_my_version*2)
	LDI  R31,HIGH(_my_version*2)
	RCALL __GETW1PF
	ST   X,R30
;     222 		txBuffer[40] = my_version>>8;		// Версия
	LDI  R30,LOW(_my_version*2)
	LDI  R31,HIGH(_my_version*2)
	RCALL __GETW1PF
	MOV  R30,R31
	LDI  R31,0
	__PUTB1MN _txBuffer,40
;     223 	
;     224 		dannForTX = 1;								// есть данные	
	SET
	BLD  R2,2
;     225 
;     226 }
	RJMP _0x58
;     227 
;     228 //-----------------------------------------------------------------------------------------------------------------
;     229 
;     230 // Возвращаю состояние устройства
;     231 const char _PT_GETSTATE_[]={19,0,0,'a','a','a','a','a','a','a','a','a','a','a','a','a','a',' ',100,255};
;     232 static void GetState(void)
;     233 {
_GetState_G1:
;     234 	register unsigned char i, n, b;
;     235 	
;     236 		memcpyf(txBuffer, _PT_GETSTATE_, _PT_GETSTATE_[0]+1);
	RCALL __SAVELOCR3
;	i -> R16
;	n -> R17
;	b -> R18
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
;     237 		dannForTX = 1;								// есть данные	
	SET
	BLD  R2,2
;     238 } 
	RCALL SUBOPT_0x3
	RET
;     239 
;     240 
;     241 
;     242 
;     243 void main(void)
;     244 {
_main:
;     245 	// Настраиваю "железо"
;     246 	HardwareInit(); 
	RCALL _HardwareInit
;     247 
;     248 	// Это был сброс по вотчдогу?
;     249 	if (MCUCSR & (1 << WDRF))
	IN   R30,0x34
	SBRS R30,3
	RJMP _0xE
;     250 	{
;     251 		MCUCSR &= (1 << WDRF) ^ 0xFF;
	IN   R30,0x34
	ANDI R30,0XF7
	OUT  0x34,R30
;     252 	
;     253 		// Если вылетел по вотчдогу - пытаюсь перегрузиться в рабочий режим	
;     254 		RebootToWork();
	RCALL _RebootToWork
;     255 	}
;     256 	
;     257 	// Ожидание, прием и исполнение команд
;     258 	while (1)
_0xE:
_0xF:
;     259 	{
;     260 		Wait4Hdr();						// Ждем пакет
	RCALL _Wait4Hdr
;     261         if ((adr == pAddr)||(adr == TO_MON )) 	            // работа при внешней адресации
	LDS  R30,_pAddr
	CP   R30,R4
	BREQ _0x13
	LDI  R30,LOW(254)
	CP   R30,R4
	BRNE _0x12
_0x13:
;     262         	{
;     263 				switch(typePack)
	MOV  R30,R5
;     264 					{
;     265 						case PT_PRGINFO:	// Вернуть информацию о мониторе и процессоре
	CPI  R30,LOW(0x8)
	BRNE _0x18
;     266 							PrgInfo();
	RCALL _PrgInfo
;     267 							break;
	RJMP _0x17
;     268 						case PT_WRFLASH:	// Записать страницу FLASH
_0x18:
	CPI  R30,LOW(0x9)
	BRNE _0x19
;     269 //putchar (0x14);    
;     270 							WriteFlash();
	RCALL _WriteFlash
;     271 							break;
	RJMP _0x17
;     272 						case PT_WREEPROM:	// Записать байт в EEPROM
_0x19:
	CPI  R30,LOW(0xA)
	BRNE _0x1A
;     273 //putchar (0x15);    
;     274 							WriteEeprom();
	RCALL _WriteEeprom
;     275 							break;
	RJMP _0x17
;     276 						case PT_TOWORK:		// Вернуться в режим работы
_0x1A:
	CPI  R30,LOW(0xB)
	BRNE _0x1B
;     277 putchar (0x16);    
	LDI  R30,LOW(22)
	ST   -Y,R30
	RCALL _putchar
;     278 							ToWorkMode();			
	RCALL _ToWorkMode
;     279 //putchar (0x21);    
;     280 							break;    
	RJMP _0x17
;     281 						case PT_TOPROG:
_0x1B:
	CPI  R30,LOW(0x7)
	BRNE _0x1C
;     282 							txBuffer[0] = 0;        				// мы входим в прораммирование
	RCALL SUBOPT_0x6
;     283 							dannForTX = 1;								// есть данные	
	BLD  R2,2
;     284 							 break;      
	RJMP _0x17
;     285 						case PT_GETINFO:
_0x1C:
	CPI  R30,LOW(0x3)
	BRNE _0x1D
;     286 //putchar (0x17);
;     287 							GetInfo();
	RCALL _GetInfo_G1
;     288 							break;
	RJMP _0x17
;     289 						case PT_GETSTATE:
_0x1D:
	CPI  R30,LOW(0x1)
	BRNE _0x1F
;     290 //putchar (0x20);
;     291 								GetState();
	RCALL _GetState_G1
;     292 								break;
;     293 							
;     294 
;     295 						default:
_0x1F:
;     296 //putchar (0x18);
;     297 //putchar (typePack);    
;     298 							break;
;     299 					}
_0x17:
;     300 
;     301         	}
;     302         else         if (adr==0)											//  команды при внутр. адресе 0
	RJMP _0x20
_0x12:
	TST  R4
	BRNE _0x21
;     303         	{
;     304 				switch(typePack)
	MOV  R30,R5
;     305 					{
;     306 						case GetLogAddr:     						// Отвечаем. Заполняем буффер на передачу
	CPI  R30,LOW(0x1)
	BRNE _0x25
;     307 								twi_byte(0);				  			// длина пакета
	RCALL SUBOPT_0x0
	RCALL _twi_byte
;     308 								txBuffer[0] = 1;				 		// длина пакета
	RCALL SUBOPT_0x1
;     309 								txBuffer[1] = 0;				 		// лог. адрес
	__PUTB1MN _txBuffer,1
;     310 								txBuff ();                           		// передаем
	RCALL _txBuff
;     311 								break;
	RJMP _0x24
;     312 						case pingPack :
_0x25:
	CPI  R30,LOW(0x2)
	BRNE _0x29
;     313 								if (dannForTX) txBuff();
	SBRS R2,2
	RJMP _0x27
	RCALL _txBuff
;     314 								else 	twi_byte(0);				  			// длина пакета
	RJMP _0x28
_0x27:
	RCALL SUBOPT_0x0
	RCALL _twi_byte
;     315 								break;
_0x28:
;     316 						default:
_0x29:
;     317 //putchar (0x19);    
;     318 //putchar (typePack);    
;     319 								break;
;     320 					}
_0x24:
;     321         	
;     322 			}
;     323 	}
_0x21:
_0x20:
	RJMP _0xF
;     324 }
_0x2A:
	RJMP _0x2A
;     325 /////////////////////////////////////////////////////////////////////////////////////////////
;     326 // Что касается "железа" Coding Device (Mega8)
;     327 #include "monitor.h"
;     328 #include "CodingM8.h"        
;     329 
;     330 
;     331 const   unsigned int scrambling_seed = 333;
;     332 
;     333 void HardwareInit(void)
;     334 {
_HardwareInit:
;     335 	// Настройка выводов
;     336 	PORTC=0x07;
	LDI  R30,LOW(7)
	OUT  0x15,R30
;     337 	DDRC=0x00;
	LDI  R30,LOW(0)
	OUT  0x14,R30
;     338 
;     339     // USART initialization
;     340     // Communication Parameters: 8 Data, 1 Stop, No Parity
;     341     // USART Receiver: On
;     342     // USART Transmitter: On
;     343     // USART Mode: Asynchronous
;     344     // USART Baud rate: 38400
;     345     UCSRA=0x00;
	OUT  0xB,R30
;     346     UCSRB=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
;     347     UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
;     348     UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
;     349     UBRRL=0x0C;
	LDI  R30,LOW(12)
	OUT  0x9,R30
;     350 
;     351 
;     352 
;     353 	// Запрещаю компаратор
;     354 	ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     355 	SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;     356 
;     357     //Настройки TWI
;     358     twi_init();             
	RCALL _twi_init
;     359 
;     360 	// Вотчдог
;     361 	WDTCR=0x1F;
	LDI  R30,LOW(31)
	OUT  0x21,R30
;     362 	WDTCR=0x0F;  
	LDI  R30,LOW(15)
	OUT  0x21,R30
;     363 
;     364 }
	RET
;     365 
;     366 #define USR  TWSR                   //статус порта 
;     367 #define UDRE (1 << 5)
;     368 #define UDR  TWDR                   //регистр с принимаемыми/передаваемыми байтами
;     369 #define RXC  (1 << 7)
;     370 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;     371 // 
;     372 // Связь с внешним миром. Slave RECIVER.
;     373 
;     374 #include <CodingM8.h>
;     375 #include <stdio.h>
;     376 #include "monitor.h"
;     377 
;     378 
;     379 
;     380 // Биты TWCR
;     381 #define TWINT 7
;     382 #define TWEA  6
;     383 #define TWSTA 5
;     384 #define TWSTO 4
;     385 #define TWWC  3
;     386 #define TWEN  2
;     387 #define TWIE  0
;     388 
;     389 // Состояния
;     390 #define START		0x08
;     391 #define	REP_START	0x10
;     392 
;     393 // Коды статуса TWI...
;     394 //Master TRANSMITTER
;     395 #define	MTX_ADR_ACK		0x18
;     396 #define	MRX_ADR_ACK	0x40
;     397 #define	MTX_DATA_ACK	0x28
;     398 #define	MRX_DATA_NACK	0x58
;     399 #define	MRX_DATA_ACK	0x50
;     400 
;     401 //Slave RECIVER
;     402 #define	SRX_ADR_ACK		0x60    //принят ADR (подчиненный)
;     403 #define	SRX_GADR_ACK	0x70    //принят общий ADR (подчиненный)
;     404 #define	SRX_DATA_ACK	0x80    //принят DANN (подчиненный)
;     405 #define	SRX_GDATA_ACK	0x90    //принят общие DANN (подчиненный)
;     406 
;     407 
;     408 	// Настраиваю TWI - подчиненный с адр. Addr
;     409     // Bit Rate: 400,000 kHz
;     410     // General Call Recognition: On
;     411 void twi_init (void)
;     412 {
_twi_init:
;     413 	// процесс определения физического адреса порта и ответа
;     414 	// на первичный пинг (0хАА) главного процессора
;     415 	pAddr = ((PINC & 0x7)+1 );			// определяем физический адрес (0-не исп. т.к. Глоб. Вызов)
	IN   R30,0x13
	ANDI R30,LOW(0x7)
	SUBI R30,-LOW(1)
	STS  _pAddr,R30
;     416 
;     417     TWSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x1,R30
;     418     TWBR=0x02;
	LDI  R30,LOW(2)
	OUT  0x0,R30
;     419     TWAR=(pAddr<<1)+1;                        // Устанавливаем его для TWI
	LDS  R30,_pAddr
	LSL  R30
	SUBI R30,-LOW(1)
	OUT  0x2,R30
;     420     TWCR=0x45;                          
	LDI  R30,LOW(69)
	OUT  0x36,R30
;     421 
;     422 }
	RET
;     423 
;     424 
;     425 // Жду флажка окончания текущей операции
;     426 static void twi_wait_int (void)
;     427 {
_twi_wait_int_G3:
;     428 	while (!(TWCR & (1<<TWINT))); 
_0x2B:
	RCALL SUBOPT_0xA
	BREQ _0x2B
;     429 }
	RET
;     430 
;     431 /* Проверка обращения к данному устройству...
;     432 // Возвращает не 0, если было обращение
;     433 unsigned char rx_addr (void)
;     434 {
;     435 	twi_wait_int();        
;     436     if ((TWSR == SRX_ADR_ACK) || (TWSR == SRX_GADR_ACK))
;     437     {
;     438     return 0;                   //поступил адрес/общ.адрес...
;     439     }        
;     440     return 255;
;     441 } */
;     442 
;     443 
;     444 // Прием байта из канала TWI
;     445 inline unsigned char ReceiveChar(void)
;     446 {
_ReceiveChar:
;     447     while (1)
_0x2E:
;     448     {
;     449         twi_wait_int();         //ждем байт - данные
	RCALL SUBOPT_0xB
;     450 
;     451         if ((TWSR == SRX_DATA_ACK)||(TWSR == SRX_GDATA_ACK)) 
	CPI  R30,LOW(0x80)
	BREQ _0x32
	IN   R30,0x1
	CPI  R30,LOW(0x90)
	BRNE _0x31
_0x32:
;     452             {
;     453         	return TWDR;
	IN   R30,0x3
	RET
;     454             }
;     455       TWCR = ((1<<TWINT)+(1<<TWEA)+(1<<TWEN));    //формируем АСК
_0x31:
	RCALL SUBOPT_0xC
;     456     }
	RJMP _0x2E
;     457 //        twi_wait_int();         //ждем байт - данные
;     458 
;     459 }
;     460 
;     461 // Прием байта из канала
;     462 unsigned char GetByte(void)
;     463 {
_GetByte:
;     464 	register unsigned char ret;
;     465 	ret = ReceiveChar();
	ST   -Y,R16
;	ret -> R16
	RCALL _ReceiveChar
	MOV  R16,R30
;     466 
;     467 	TWCR = ((1<<TWINT)+(1<<TWEA)+(1<<TWEN));    //формируем АСК
	RCALL SUBOPT_0xC
;     468 
;     469 	pcrc += ret;
	MOV  R30,R16
	RCALL SUBOPT_0xD
;     470 	nbyts ++;
	LDS  R30,_nbyts
	SUBI R30,-LOW(1)
	STS  _nbyts,R30
;     471 
;     472 	if (descramble)		// Если нужно дешифровать - дешифрую
	SBRS R2,1
	RJMP _0x34
;     473 	{
;     474 		ret ^= NextSeqByte();
	RCALL _NextSeqByte
	EOR  R16,R30
;     475 	}	
;     476 	return ret;
_0x34:
	MOV  R30,R16
_0x58:
	LD   R16,Y+
	RET
;     477 }
;     478 
;     479 // Передача байта данных
;     480 // Возвращает не 0, если все в порядке
;     481 unsigned char twi_byte (unsigned char data)
;     482 {
_twi_byte:
;     483 	twi_wait_int();
	RCALL _twi_wait_int_G3
;     484 
;     485 	TWDR = data;
	LD   R30,Y
	OUT  0x3,R30
;     486     TWCR = ((1<<TWINT)+(1<<TWEA)+(1<<TWEN));    //формируем АСК
	RCALL SUBOPT_0xC
;     487 // 	TWCR = ((1<<TWINT)+(1<<TWEN));
;     488 
;     489 	twi_wait_int();
	RCALL SUBOPT_0xB
;     490 
;     491 	if(TWSR != MTX_DATA_ACK)
	CPI  R30,LOW(0x28)
	BREQ _0x35
;     492 	{
;     493 		return 0;
	LDI  R30,LOW(0)
	RJMP _0x57
;     494 	}
;     495 		
;     496 	return 255;
_0x35:
	LDI  R30,LOW(255)
_0x57:
	ADIW R28,1
	RET
;     497 }
;     498 
;     499 
;     500 
;     501 // Ожидание заголовка пакета
;     502 unsigned char Wait4Hdr(void)
;     503 {
_Wait4Hdr:
;     504     unsigned char a,b;
;     505 
;     506 	#asm("wdr");		// Перед приемом очередного пакета перезапускаю вотчдог
	RCALL __SAVELOCR2
;	a -> R16
;	b -> R17
	wdr
;     507 		
;     508 	while(1)
_0x36:
;     509 	{
;     510 //putchar (0xaa);
;     511 		if (prgmode)	// Если меня уже спрашивали, то след. пакет можно ждать долго
	SBRS R2,0
	RJMP _0x39
;     512 		{
;     513 			while (!(TWCR & (1<<TWINT))) 
_0x3A:
	RCALL SUBOPT_0xA
	BRNE _0x3C
;     514 
;     515 //			while(!twi_wait_int())   							//Ждем обращения главного...
;     516 			{
;     517 				#asm("wdr");
	wdr
;     518 			}
	RJMP _0x3A
_0x3C:
;     519 		}
;     520 
;     521 		pcrc = 0;
_0x39:
	LDI  R30,LOW(0)
	STS  _pcrc,R30
;     522 		if (GetByte() != PACKHDR)	// Жду заголовок
	RCALL _GetByte
	CPI  R30,LOW(0x71)
	BREQ _0x3D
;     523 		{
;     524 			continue;
	RJMP _0x36
;     525 		}
;     526 
;     527 		plen = GetByte();		 	// Длина пакета
_0x3D:
	RCALL _GetByte
	STS  _plen,R30
;     528 		nbyts = 0;  
	LDI  R30,LOW(0)
	STS  _nbyts,R30
;     529 		
;     530         adr = GetByte();																	
	RCALL _GetByte
	MOV  R4,R30
;     531        	 typePack= GetByte();      // Возвращаю тип пакета
	RCALL _GetByte
	MOV  R5,R30
;     532 
;     533 if  ((typePack == PT_WRFLASH)||(typePack ==PT_WREEPROM))				// если пакет для флэш то
	LDI  R30,LOW(9)
	CP   R30,R5
	BREQ _0x3F
	LDI  R30,LOW(10)
	CP   R30,R5
	BRNE _0x3E
_0x3F:
;     534 			{			
;     535 			 	DescrambleStart();					// расшифровываем
	SET
	BLD  R2,1
;     536 //				 print = 1;      	 
;     537              }
;     538              
;     539 		for (a=0; a<plen-3;a++)
_0x3E:
	LDI  R16,LOW(0)
_0x42:
	LDS  R30,_plen
	SUBI R30,LOW(3)
	CP   R16,R30
	BRSH _0x43
;     540 			{
;     541 				b=GetByte();
	RCALL _GetByte
	MOV  R17,R30
;     542 				rxBuffer [a] = b;				// заполняем буффер данными
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_rxBuffer)
	SBCI R27,HIGH(-_rxBuffer)
	ST   X,R17
;     543 //if (print) putchar (b);
;     544 			}      
	SUBI R16,-1
	RJMP _0x42
_0x43:
;     545 
;     546 			DescrambleStop();
	CLT
	BLD  R2,1
;     547 
;     548 		if (PackOk())	return typePack;			// сверяем КС
	RCALL _PackOk
	CPI  R30,0
	BREQ _0x44
	MOV  R30,R5
	RJMP _0x56
;     549 		else 	return 0;
_0x44:
	LDI  R30,LOW(0)
;     550 
;     551 	}                             
;     552 }
_0x56:
	RCALL __LOADLOCR2P
	RET
;     553 
;     554 
;     555 
;     556 
;     557 
;     558 /*
;     559 // Принимаем адрес/данные
;     560 // Возвращает не 0, если все в порядке
;     561 unsigned char twi_addr (unsigned char addr)
;     562 {
;     563 	twi_wait_int();
;     564 
;     565 	TWDR = addr;
;     566 	TWCR = ((1<<TWINT)+(1<<TWEN));
;     567 
;     568 	twi_wait_int();
;     569 
;     570 	if((TWSR != MTX_ADR_ACK)&&(TWSR != MRX_ADR_ACK))
;     571 	{
;     572 		return 0;
;     573 	}
;     574 	return 255;
;     575 } */
;     576 // Обмен пакетами с хостом
;     577 #include "monitor.h"   
;     578 #include "CodingM8.h"
;     579 
;     580         
;     581    
;     582 
;     583 unsigned char pcrc;	// Контрольная сумма

	.DSEG
_pcrc:
	.BYTE 0x1
;     584 unsigned char plen;	// Длина пакета
_plen:
	.BYTE 0x1
;     585 unsigned char nbyts;	// Число принятых или переданых байт
_nbyts:
	.BYTE 0x1
;     586 bit prgmode  = 0;		// Находимся в режиме программирования
;     587 
;     588 
;     589 // Прием слова из буффера
;     590 unsigned short GetWordBuff(unsigned char a)
;     591 {

	.CSEG
_GetWordBuff:
;     592 	register unsigned short ret;  
;     593 
;     594 	ret = 	rxBuffer	[a++];
	RCALL __SAVELOCR2
;	a -> Y+2
;	ret -> R16,R17
	LDD  R30,Y+2
	SUBI R30,-LOW(1)
	STD  Y+2,R30
	SUBI R30,LOW(1)
	RCALL SUBOPT_0xE
	LD   R16,Z
	CLR  R17
;     595 	ret |= ((unsigned short)rxBuffer[a]) << 8;
	LDD  R30,Y+2
	RCALL SUBOPT_0xE
	LD   R31,Z
	LDI  R30,LOW(0)
	__ORWRR 16,17,30,31
;     596 	
;     597 	return ret;
	MOVW R30,R16
	RCALL __LOADLOCR2
	ADIW R28,3
	RET
;     598 } 
;     599 
;     600 // Передача байта в канал
;     601 void PutByte(unsigned char byt)
;     602 {
;     603 	pcrc += byt;
;     604 	nbyts ++;
;     605 	
;     606 	twi_byte(byt);
;     607 }
;     608 
;     609 // Контроль успешного завершения приема пакета
;     610 unsigned char PackOk(void)
;     611 {
_PackOk:
;     612 	register unsigned char crc;
;     613 
;     614 	// Сверяю контрольную сумму	
;     615 	crc = pcrc;
	ST   -Y,R16
;	crc -> R16
	LDS  R16,_pcrc
;     616 	if (GetByte() != crc)
	RCALL _GetByte
	CP   R16,R30
	BREQ _0x46
;     617 	{
;     618 		return 0;
	LDI  R30,LOW(0)
	RJMP _0x55
;     619 	}
;     620 
;     621 	// Сверяю длину пакета	
;     622 	if (nbyts != plen)
_0x46:
	LDS  R30,_plen
	LDS  R26,_nbyts
	CP   R30,R26
	BREQ _0x47
;     623 	{
;     624 		return 0;
	LDI  R30,LOW(0)
	RJMP _0x55
;     625 	}
;     626 	
;     627 	return 1;
_0x47:
	LDI  R30,LOW(1)
	RJMP _0x55
;     628 }
;     629 
;     630 // Начало передачи ответного пакета
;     631 void ReplyStart(unsigned char bytes)
;     632 {
_ReplyStart:
;     633 	plen = bytes + 1;
	LD   R30,Y
	SUBI R30,-LOW(1)
	STS  _plen,R30
;     634 	pcrc = plen;
	STS  _pcrc,R30
;     635 
;     636 	twi_byte(plen);
	LDS  R30,_plen
	RCALL SUBOPT_0xF
;     637 }
	ADIW R28,1
	RET
;     638 
;     639 // Передача содержимого буфера в канал TWI
;     640 void txBuff (void)
;     641 	{
_txBuff:
;     642 		unsigned char a;
;     643 
;     644 		twi_byte(0);				  			// 
	ST   -Y,R16
;	a -> R16
	RCALL SUBOPT_0x0
	RCALL _twi_byte
;     645 		
;     646 		ReplyStart (txBuffer[0] );	 	// передаем длину
	LDS  R30,_txBuffer
	ST   -Y,R30
	RCALL _ReplyStart
;     647 
;     648 		for (a=1; a<txBuffer[0]+1;a++)
	LDI  R16,LOW(1)
_0x49:
	LDS  R30,_txBuffer
	SUBI R30,-LOW(1)
	CP   R16,R30
	BRSH _0x4A
;     649 			{       
;     650 			     	twi_byte(txBuffer[a]);
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xF
;     651 			     	pcrc+= txBuffer[a];
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xD
;     652 			}
	SUBI R16,-1
	RJMP _0x49
_0x4A:
;     653 		twi_byte(pcrc);						//передаем КС
	LDS  R30,_pcrc
	RCALL SUBOPT_0xF
;     654 
;     655 		dannForTX = 0;								// передали данные	
	CLT
	BLD  R2,2
;     656 
;     657 		if (toReboot) RebootToWork();			// на перезагрузку
	SBRC R2,3
	RCALL _RebootToWork
;     658 		
;     659 	}
_0x55:
	LD   R16,Y+
	RET
;     660 
;     661 ///////////////////////////////////////////////////////////////////////////////////////////
;     662 // Дешифрование программирующих данных
;     663 
;     664 unsigned long int next_rand = 1;

	.DSEG
_next_rand:
	.BYTE 0x4
;     665 unsigned char rand_cnt = 31;
;     666 
;     667 // Генератор псевдослучайной последовательности.
;     668 // За основу взяты IAR-овские исходники
;     669 
;     670 bit descramble = 0;					// Признак необходимости дешифрования
;     671 
;     672 unsigned char NextSeqByte(void)	// Очередной байт дешифрующей последовательности
;     673 {

	.CSEG
_NextSeqByte:
;     674 	next_rand = next_rand * 1103515245 + 12345;
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
;     675 	next_rand >>= 8;
	LDS  R26,_next_rand
	LDS  R27,_next_rand+1
	LDS  R24,_next_rand+2
	LDS  R25,_next_rand+3
	RCALL SUBOPT_0x8
	STS  _next_rand,R30
	STS  _next_rand+1,R31
	STS  _next_rand+2,R22
	STS  _next_rand+3,R23
;     676 	
;     677 	rand_cnt += 101;
	LDI  R30,LOW(101)
	ADD  R6,R30
;     678 		
;     679 	return rand_cnt ^ (unsigned char)next_rand;
	LDS  R30,_next_rand
	EOR  R30,R6
	RET
;     680 }
;     681 
;     682 void ResetDescrambling(void)		// Перезапуск генератора дешифрующей последовательности
;     683 {
_ResetDescrambling:
;     684 	next_rand = scrambling_seed;
	LDI  R30,LOW(_scrambling_seed*2)
	LDI  R31,HIGH(_scrambling_seed*2)
	RCALL __GETW1PF
	CLR  R22
	CLR  R23
	STS  _next_rand,R30
	STS  _next_rand+1,R31
	STS  _next_rand+2,R22
	STS  _next_rand+3,R23
;     685 	rand_cnt = 31;
	LDI  R30,LOW(31)
	MOV  R6,R30
;     686 	descramble = 0;
	CLT
	BLD  R2,1
;     687 }
	RET
;     688 //--------------------------------------------------------------------------------------
;     689 // Функции для работы с FLASH
;     690 
;     691 #include "monitor.h"
;     692 
;     693 #if (defined _CHIP_ATMEGA128L_) || (defined _CHIP_ATMEGA128_)
;     694 	#asm
;     695 		.equ	SPMCSR = 0x68
;     696 		.equ	SPMREG = SPMCSR
;     697 	#endasm
;     698 #elif (defined _CHIP_ATMEGA8_) || (defined _CHIP_ATMEGA8L_) || (defined _CHIP_ATMEGA8515_) || (defined _CHIP_ATMEGA8515L_) || (defined _CHIP_ATMEGA162_) || (defined _CHIP_ATMEGA162L_)
;     699 	#asm
;     700 		.equ	SPMCR  = 0x37
		.equ	SPMCR  = 0x37
;     701 		.equ	SPMREG = SPMCR
		.equ	SPMREG = SPMCR
;     702 	#endasm
;     703 #else
;     704 	#error Поддержка для этого процессора еще не написана
;     705 #endif
;     706 
;     707 #asm
;     708 	.equ	SPMEN  = 0	; Биты регистра
	.equ	SPMEN  = 0	; Биты регистра
;     709 	.equ	PGERS  = 1
	.equ	PGERS  = 1
;     710 	.equ	PGWRT  = 2
	.equ	PGWRT  = 2
;     711 	.equ	BLBSET = 3
	.equ	BLBSET = 3
;     712 	.equ	RWWSRE = 4
	.equ	RWWSRE = 4
;     713 	.equ	RWWSB  = 6
	.equ	RWWSB  = 6
;     714 	.equ	SPMIE  = 7
	.equ	SPMIE  = 7
;     715 	;--------------------------------------------------
	;--------------------------------------------------
;     716 	; Ожидание завершения SPM. Портит R23
	; Ожидание завершения SPM. Портит R23
;     717 	spmWait:
	spmWait:
;     718 #endasm
;     719 #ifdef USE_MEM_SPM
;     720 	#asm
;     721 		lds		r23, SPMREG
;     722 	#endasm
;     723 #else
;     724 	#asm
;     725 		in		r23, SPMREG
		in		r23, SPMREG
;     726 	#endasm
;     727 #endif
;     728 #asm
;     729 		andi	r23, (1 << SPMEN)
		andi	r23, (1 << SPMEN)
;     730 		brne	spmWait	
		brne	spmWait	
;     731 		ret
		ret
;     732 	;--------------------------------------------------
	;--------------------------------------------------
;     733 	; Запуск SPM.
	; Запуск SPM.
;     734 	spmSPM:
	spmSPM:
;     735 		in		r24, SREG	; Сохраняю состояние
		in		r24, SREG	; Сохраняю состояние
;     736 		cli					; Запрещаю прерывания
		cli					; Запрещаю прерывания
;     737 #endasm
;     738 #ifdef USE_RAMPZ
;     739 	#asm
;     740 		in		r25, RAMPZ	; Сохраняю RAMPZ
;     741 	#endasm
;     742 #endif
;     743 #asm
;     744 		ld		r30, y		; Адрес
		ld		r30, y		; Адрес
;     745 		ldd		r31, y+1
		ldd		r31, y+1
;     746 #endasm
;     747 #ifdef USE_RAMPZ
;     748 	#asm
;     749 		ldd		r26, y+2	; 3-й байт адреса - в RAMPZ
;     750 		out		RAMPZ, r26
;     751 	#endasm
;     752 #endif
;     753 #asm
;     754 		rcall	spmWait		; Жду завершения предидущей операции (на всякий случай)
		rcall	spmWait		; Жду завершения предидущей операции (на всякий случай)
;     755 #endasm
;     756 #ifdef USE_MEM_SPM
;     757 	#asm
;     758 		sts SPMREG, r22		; Регистр команд, как память
;     759 	#endasm
;     760 #else
;     761 	#asm
;     762 		out SPMREG, r22		; Регистр команд, как порт
		out SPMREG, r22		; Регистр команд, как порт
;     763 	#endasm
;     764 #endif
;     765 #asm
;     766 		spm					; Запуск на выполнение
		spm					; Запуск на выполнение
;     767 		nop
		nop
;     768 		nop
		nop
;     769 		nop
		nop
;     770 		nop
		nop
;     771 		rcall	spmWait		; Жду завершения
		rcall	spmWait		; Жду завершения
;     772 #endasm
;     773 #ifdef USE_RAMPZ
;     774 	#asm
;     775 		out		RAMPZ, r25	; Восстанавливаю состояние
;     776 	#endasm
;     777 #endif
;     778 #asm
;     779 		out		SREG, r24
		out		SREG, r24
;     780 		ret
		ret
;     781 #endasm
;     782 
;     783 #pragma warn-
;     784 void ResetTempBuffer (FADDRTYPE addr)
;     785 {
_ResetTempBuffer:
;     786 	#asm
;     787 		ldi		r22, (1 << RWWSRE) | (1 << SPMEN)
		ldi		r22, (1 << RWWSRE) | (1 << SPMEN)
;     788 		rcall	spmSPM
		rcall	spmSPM
;     789 	#endasm
;     790 }
	ADIW R28,2
	RET
;     791 
;     792 void FillTempBuffer (unsigned short data, FADDRTYPE addr)
;     793 {
_FillTempBuffer:
;     794 	#ifdef USE_RAMPZ
;     795 		#asm
;     796 			ldd		r0, y+4			; Данные
;     797 			ldd		r1,	y+5
;     798 		#endasm
;     799 	#else
;     800 		#asm
;     801 			ldd		r0, y+2			; Данные
			ldd		r0, y+2			; Данные
;     802 			ldd		r1,	y+3
			ldd		r1,	y+3
;     803 		#endasm
;     804 	#endif
;     805 	#asm
;     806 		ldi		r22, (1 << SPMEN)	; Команда
		ldi		r22, (1 << SPMEN)	; Команда
;     807 		rcall	spmSPM				; На выполнение
		rcall	spmSPM				; На выполнение
;     808 	#endasm
;     809 }
	ADIW R28,4
	RET
;     810 
;     811 void PageErase (FADDRTYPE  addr)
;     812 {
_PageErase:
;     813 	#asm
;     814 		ldi		r22, (1 << PGERS) | (1 << SPMEN)
		ldi		r22, (1 << PGERS) | (1 << SPMEN)
;     815 		rcall	spmSPM
		rcall	spmSPM
;     816 	#endasm
;     817 }
	ADIW R28,2
	RET
;     818 
;     819 void PageWrite (FADDRTYPE addr)
;     820 {
_PageWrite:
;     821 	#asm
;     822 		ldi		r22, (1 << PGWRT) | (1 << SPMEN)
		ldi		r22, (1 << PGWRT) | (1 << SPMEN)
;     823 		rcall	spmSPM
		rcall	spmSPM
;     824 	#endasm
;     825 }
	ADIW R28,2
	RET
;     826 #pragma warn+
;     827 
;     828 void PageAccess (void)
;     829 {
_PageAccess:
;     830 	#asm
;     831 		ldi		r22, (1 << RWWSRE) | (1 << SPMEN)
		ldi		r22, (1 << RWWSRE) | (1 << SPMEN)
;     832 		rcall	spmSPM
		rcall	spmSPM
;     833 	#endasm
;     834 }
	RET
;     835 
;     836 // Запись страницы FLASH
;     837 void WriteFlash(void)
;     838 {
_WriteFlash:
;     839 	unsigned char a=0;
;     840 	int temp;
;     841 	FADDRTYPE faddr;
;     842 	
;     843 	// Получаю номер страницы
;     844 	#asm ("wdr");
	RCALL __SAVELOCR5
;	a -> R16
;	temp -> R17,R18
;	faddr -> R19,R20
	LDI  R16,0
	wdr
;     845 	faddr = GetWordBuff(a);
	RCALL SUBOPT_0x11
	__PUTW1R 19,20
;     846 	a+=2;							// вычитали 2 байта
	SUBI R16,-LOW(2)
;     847 	
;     848 	if (faddr >= PRGPAGES)
	__CPWRN 19,20,96
	BRLO _0x4E
;     849 	{
;     850 		while(1);	// Если неправильный номер страницы - непоправимая ошибка и вылет по вотчдогу
_0x4F:
	RJMP _0x4F
;     851 	}	            
;     852 	
;     853 
;     854 	// Получаю адрес начала страницы
;     855 	faddr <<= (ZPAGEMSB + 1);
_0x4E:
	__GETW2R 19,20
	LDI  R30,LOW(6)
	RCALL __LSLW12
	__PUTW1R 19,20
;     856 	
;     857 	// Загрузка данных в промежуточный буфер
;     858 	#asm ("wdr");
	wdr
;     859 	ResetTempBuffer(faddr);
	ST   -Y,R20
	ST   -Y,R19
	RCALL _ResetTempBuffer
;     860 	do{
_0x53:
;     861 			FillTempBuffer(GetWordBuff(a), faddr);			// 
	RCALL SUBOPT_0x11
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R20
	ST   -Y,R19
	RCALL _FillTempBuffer
;     862 			a+=2;
	SUBI R16,-LOW(2)
;     863 			faddr += 2;
	__ADDWRN 19,20,2
;     864     	}while (faddr & (PAGESIZ-1)) ;	
	MOV  R30,R19
	ANDI R30,LOW(0x3F)
	BRNE _0x53
;     865 
;     866 		// Сигналю, что все в порядке и можно посылать следующий
;     867 		#asm ("wdr");
	wdr
;     868 		txBuffer[0] = 1;                   		// длина
	RCALL SUBOPT_0x2
;     869 		txBuffer[1] = RES_OK;
	__PUTB1MN _txBuffer,1
;     870 		dannForTX = 1;							// есть данные	
	SET
	BLD  R2,2
;     871 
;     872 	// Восстанавливаю адрес начала страницы
;     873 	faddr -= PAGESIZ;
	__SUBWRN 19,20,64
;     874 
;     875 	// Стираю страницу
;     876 	#asm ("wdr");
	wdr
;     877 	PageErase(faddr);
	ST   -Y,R20
	ST   -Y,R19
	RCALL _PageErase
;     878 	
;     879 	// Записываю страницу
;     880 	#asm ("wdr");
	wdr
;     881 	PageWrite(faddr);
	ST   -Y,R20
	ST   -Y,R19
	RCALL _PageWrite
;     882 
;     883 	// Разрешить адресацию области RWW
;     884 	#asm ("wdr");
	wdr
;     885 	PageAccess();
	RCALL _PageAccess
;     886 
;     887 /*	// Сигналю, что все в порядке и можно посылать следующий
;     888 	#asm ("wdr");
;     889 		txBuffer[0] = 1;                   		// длина
;     890 		txBuffer[1] = RES_OK;
;     891 		dannForTX = 1;							// есть данные	*/
;     892 
;     893 }
	RCALL __LOADLOCR5
	ADIW R28,5
	RET
;     894  

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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x0:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x1:
	LDI  R30,LOW(1)
	STS  _txBuffer,R30
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2:
	LDI  R30,LOW(1)
	STS  _txBuffer,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3:
	RCALL __LOADLOCR3
	ADIW R28,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4:
	LPM  R30,Z
	LDI  R31,0
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5:
	LPM  R30,Z
	MOV  R31,R30
	LDI  R30,0
	OR   R30,R26
	OR   R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6:
	LDI  R30,LOW(0)
	STS  _txBuffer,R30
	SET
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x7:
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x8:
	LDI  R30,LOW(8)
	RCALL __LSRD12
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
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xB:
	RCALL _twi_wait_int_G3
	IN   R30,0x1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xC:
	LDI  R30,LOW(196)
	OUT  0x36,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xD:
	LDS  R26,_pcrc
	ADD  R30,R26
	STS  _pcrc,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xE:
	LDI  R31,0
	SUBI R30,LOW(-_rxBuffer)
	SBCI R31,HIGH(-_rxBuffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xF:
	ST   -Y,R30
	RJMP _twi_byte

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x10:
	SUBI R30,LOW(-_txBuffer)
	SBCI R31,HIGH(-_txBuffer)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x11:
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

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
