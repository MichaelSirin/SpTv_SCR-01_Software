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
	RJMP _0x57
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
_0x57:
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
	RJMP _0x56
;     158 	}
;     159 	
;     160 	return 1;
_0x9:
	LDI  R30,LOW(1)
_0x56:
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
;     186 //	dannForTX = 1;								// есть данные
;     187 
;     188 	prgmode = 0;
	CLT
	BLD  R2,0
;     189 	  
;     190 	// На перезагрузку
;     191 	toReboot =1;
	SET
	BLD  R2,3
;     192 //	RebootToWork();
;     193 }
	RET
;     194 
;     195 //-----------------------------------------------------------------------------------------------------------------
;     196 
;     197 // Информация об устройстве
;     198 static void GetInfo(void)
;     199 {
_GetInfo_G1:
;     200 	register unsigned char i;
;     201 	
;     202 	// 	заполняю буфер
;     203 	txBuffer[0] = 40;
	ST   -Y,R16
;	i -> R16
	LDI  R30,LOW(40)
	STS  _txBuffer,R30
;     204 	
;     205 	for (i = 0; i < 32; i ++)	// Имя устройства
	LDI  R16,LOW(0)
_0xC:
	CPI  R16,32
	BRSH _0xD
;     206 	{
;     207 		txBuffer[i+1] = device_name[i];
	RCALL SUBOPT_0x7
	__ADDW1MN _txBuffer,1
	MOVW R26,R30
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_device_name*2)
	SBCI R31,HIGH(-_device_name*2)
	LPM  R30,Z
	ST   X,R30
;     208 	}
	SUBI R16,-1
	RJMP _0xC
_0xD:
;     209 
;     210 		txBuffer[33] = my_ser_num;           // Серийный номер
	LDI  R26,LOW(_my_ser_num)
	LDI  R27,HIGH(_my_ser_num)
	RCALL __EEPROMRDD
	__PUTB1MN _txBuffer,33
;     211 		txBuffer[34] = my_ser_num>>8;      // Серийный номер
	LDI  R26,LOW(_my_ser_num)
	LDI  R27,HIGH(_my_ser_num)
	RCALL __EEPROMRDD
	MOVW R26,R30
	MOVW R24,R22
	RCALL SUBOPT_0x8
	__PUTB1MN _txBuffer,34
;     212 
;     213 		txBuffer[35] = 0;	// Серийный номер
	LDI  R30,LOW(0)
	__PUTB1MN _txBuffer,35
;     214 		txBuffer[36] = 0;	// Серийный номер
	__PUTB1MN _txBuffer,36
;     215 	
;     216 		txBuffer[37] =pAddr ;     // Адрес устройстав
	__POINTW2MN _txBuffer,37
	LDS  R30,_pAddr
	ST   X,R30
;     217 
;     218 		txBuffer[38] =0;     // Зарезервированный байт
	LDI  R30,LOW(0)
	__PUTB1MN _txBuffer,38
;     219 	
;     220 		txBuffer[39] = my_version;             // Версия
	__POINTW2MN _txBuffer,39
	LDI  R30,LOW(_my_version*2)
	LDI  R31,HIGH(_my_version*2)
	RCALL __GETW1PF
	ST   X,R30
;     221 		txBuffer[40] = my_version>>8;		// Версия
	LDI  R30,LOW(_my_version*2)
	LDI  R31,HIGH(_my_version*2)
	RCALL __GETW1PF
	MOV  R30,R31
	LDI  R31,0
	__PUTB1MN _txBuffer,40
;     222 	
;     223 		dannForTX = 1;								// есть данные	
	SET
	BLD  R2,2
;     224 
;     225 }
	RJMP _0x55
;     226 
;     227 //-----------------------------------------------------------------------------------------------------------------
;     228 
;     229 // Возвращаю состояние устройства
;     230 const char _PT_GETSTATE_[]={19,0,0,'a','a','a','a','a','a','a','a','a','a','a','a','a','a',' ',100,255};
;     231 static void GetState(void)
;     232 {
_GetState_G1:
;     233 		memcpyf(txBuffer, _PT_GETSTATE_, _PT_GETSTATE_[0]+1);
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
;     234 		dannForTX = 1;								// есть данные	
	SET
	BLD  R2,2
;     235 } 
	RET
;     236 
;     237 
;     238 void main(void)
;     239 {
_main:
;     240 	// Настраиваю "железо"
;     241 	HardwareInit(); 
	RCALL _HardwareInit
;     242 
;     243 	// Это был сброс по вотчдогу?
;     244 	if (MCUCSR & (1 << WDRF))
	IN   R30,0x34
	SBRS R30,3
	RJMP _0xE
;     245 	{
;     246 		MCUCSR &= (1 << WDRF) ^ 0xFF;
	IN   R30,0x34
	ANDI R30,0XF7
	OUT  0x34,R30
;     247 	
;     248 		// Если вылетел по вотчдогу - пытаюсь перегрузиться в рабочий режим	
;     249 		RebootToWork();
	RCALL _RebootToWork
;     250 	}
;     251 	
;     252 	// Ожидание, прием и исполнение команд
;     253 	while (1)
_0xE:
_0xF:
;     254 	{
;     255 		Wait4Hdr();						// Ждем пакет
	RCALL _Wait4Hdr
;     256         if ((adr == pAddr)||(adr == TO_MON )) 	            // работа при внешней адресации
	LDS  R30,_pAddr
	CP   R30,R4
	BREQ _0x13
	LDI  R30,LOW(254)
	CP   R30,R4
	BRNE _0x12
_0x13:
;     257         	{
;     258 				switch(typePack)
	MOV  R30,R5
;     259 					{
;     260 
;     261 						case PT_PRGINFO:	// Вернуть информацию о мониторе и процессоре
	CPI  R30,LOW(0x8)
	BRNE _0x18
;     262 							PrgInfo();
	RCALL _PrgInfo
;     263 							txBuff();
	RCALL _txBuff
;     264 							break;
	RJMP _0x17
;     265 
;     266 						case PT_WRFLASH:	// Записать страницу FLASH
_0x18:
	CPI  R30,LOW(0x9)
	BRNE _0x19
;     267 							WriteFlash();
	RCALL _WriteFlash
;     268 							txBuff();
	RCALL _txBuff
;     269 							break;
	RJMP _0x17
;     270 
;     271 						case PT_WREEPROM:	// Записать байт в EEPROM
_0x19:
	CPI  R30,LOW(0xA)
	BRNE _0x1A
;     272 							WriteEeprom();
	RCALL _WriteEeprom
;     273 							txBuff();
	RCALL _txBuff
;     274 						break;
	RJMP _0x17
;     275 
;     276 						case PT_TOWORK:		// Вернуться в режим работы
_0x1A:
	CPI  R30,LOW(0xB)
	BRNE _0x1B
;     277 							ToWorkMode();			
	RCALL _ToWorkMode
;     278 							txBuff();                         // отвечаем и
	RCALL _txBuff
;     279 							RebootToWork();			// на перезагрузку
	RCALL _RebootToWork
;     280 							break;    
	RJMP _0x17
;     281 
;     282 						case PT_TOPROG:
_0x1B:
	CPI  R30,LOW(0x7)
	BRNE _0x1C
;     283 							txBuffer[0] = 0;        				// мы входим в прораммирование
	RCALL SUBOPT_0x6
;     284 							txBuff();
	RCALL _txBuff
;     285 							break;      
	RJMP _0x17
;     286 
;     287 						case PT_GETINFO:
_0x1C:
	CPI  R30,LOW(0x3)
	BRNE _0x1D
;     288 							GetInfo();
	RCALL _GetInfo_G1
;     289 							txBuff();
	RCALL _txBuff
;     290 							break;
	RJMP _0x17
;     291 
;     292 						case PT_GETSTATE:
_0x1D:
	CPI  R30,LOW(0x1)
	BRNE _0x1F
;     293 							GetState();
	RCALL _GetState_G1
;     294 							txBuff();
	RCALL _txBuff
;     295 							break;
;     296 						
;     297 						default:
_0x1F:
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
	BRNE _0x26
;     307 								txBuffer[0] = 1;				 		// длина пакета
	RCALL SUBOPT_0x1
;     308 								txBuffer[1] = 0;				 		// лог. адрес
	__PUTB1MN _txBuffer,1
;     309 								txBuff ();                           		// передаем
	RCALL _txBuff
;     310 								break;
;     311 
;     312 /*						case pingPack :
;     313 								if (dannForTX) txBuff();
;     314 								else 	twi_byte(0);				  			// длина пакета
;     315 								break;*/
;     316 						default:
_0x26:
;     317 								break;
;     318 					}
;     319         	
;     320 			}
;     321 	}
_0x21:
_0x20:
	RJMP _0xF
;     322 }
_0x27:
	RJMP _0x27
;     323 /////////////////////////////////////////////////////////////////////////////////////////////
;     324 // Что касается "железа" Coding Device (Mega8)
;     325 #include "monitor.h"
;     326 #include "CodingM8.h"        
;     327 
;     328 
;     329 const   unsigned int scrambling_seed = 333;
;     330 
;     331 void HardwareInit(void)
;     332 {
_HardwareInit:
;     333 	// Настройка выводов
;     334 	PORTC=0x07;
	LDI  R30,LOW(7)
	OUT  0x15,R30
;     335 	DDRC=0x00;
	LDI  R30,LOW(0)
	OUT  0x14,R30
;     336 
;     337     // USART initialization
;     338     // Communication Parameters: 8 Data, 1 Stop, No Parity
;     339     // USART Receiver: On
;     340     // USART Transmitter: On
;     341     // USART Mode: Asynchronous
;     342     // USART Baud rate: 38400
;     343     UCSRA=0x00;
	OUT  0xB,R30
;     344     UCSRB=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
;     345     UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
;     346     UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
;     347     UBRRL=0x0C;
	LDI  R30,LOW(12)
	OUT  0x9,R30
;     348 
;     349 
;     350 
;     351 	// Запрещаю компаратор
;     352 	ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     353 	SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;     354 
;     355     //Настройки TWI
;     356     twi_init();             
	RCALL _twi_init
;     357 
;     358 	// Вотчдог
;     359 	WDTCR=0x1F;
	LDI  R30,LOW(31)
	OUT  0x21,R30
;     360 	WDTCR=0x0F;  
	LDI  R30,LOW(15)
	OUT  0x21,R30
;     361 
;     362 }
	RET
;     363 
;     364 #define USR  TWSR                   //статус порта 
;     365 #define UDRE (1 << 5)
;     366 #define UDR  TWDR                   //регистр с принимаемыми/передаваемыми байтами
;     367 #define RXC  (1 << 7)
;     368 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;     369 // 
;     370 // Связь с внешним миром. Slave RECIVER.
;     371 
;     372 #include <CodingM8.h>
;     373 #include <stdio.h>
;     374 #include "monitor.h"
;     375 
;     376 
;     377 
;     378 // Биты TWCR
;     379 #define TWINT 7
;     380 #define TWEA  6
;     381 #define TWSTA 5
;     382 #define TWSTO 4
;     383 #define TWWC  3
;     384 #define TWEN  2
;     385 #define TWIE  0
;     386 
;     387 // Состояния
;     388 #define START		0x08
;     389 #define	REP_START	0x10
;     390 
;     391 // Коды статуса TWI...
;     392 //Master TRANSMITTER
;     393 #define	MTX_ADR_ACK		0x18
;     394 #define	MRX_ADR_ACK	0x40
;     395 #define	MTX_DATA_ACK	0x28
;     396 #define	MRX_DATA_NACK	0x58
;     397 #define	MRX_DATA_ACK	0x50
;     398 
;     399 //Slave RECIVER
;     400 #define	SRX_ADR_ACK		0x60    //принят ADR (подчиненный)
;     401 #define	SRX_GADR_ACK	0x70    //принят общий ADR (подчиненный)
;     402 #define	SRX_DATA_ACK	0x80    //принят DANN (подчиненный)
;     403 #define	SRX_GDATA_ACK	0x90    //принят общие DANN (подчиненный)
;     404 
;     405 //Slave Transmitter
;     406 #define	STX_ADR_ACK		0xA8    //принят ADR (подчиненный передатчик)
;     407 
;     408 
;     409 	// Настраиваю TWI - подчиненный с адр. Addr
;     410     // Bit Rate: 400,000 kHz
;     411     // General Call Recognition: On
;     412 void twi_init (void)
;     413 {
_twi_init:
;     414 	// процесс определения физического адреса порта и ответа
;     415 	// на первичный пинг (0хАА) главного процессора
;     416 	pAddr = ((PINC & 0x7)+1 );			// определяем физический адрес (0-не исп. т.к. Глоб. Вызов)
	IN   R30,0x13
	ANDI R30,LOW(0x7)
	SUBI R30,-LOW(1)
	STS  _pAddr,R30
;     417 
;     418     TWSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x1,R30
;     419     TWBR=0x02;
	LDI  R30,LOW(2)
	OUT  0x0,R30
;     420     TWAR=(pAddr<<1)+1;                        // Устанавливаем его для TWI
	LDS  R30,_pAddr
	LSL  R30
	SUBI R30,-LOW(1)
	OUT  0x2,R30
;     421     TWCR=0x45;                          
	LDI  R30,LOW(69)
	OUT  0x36,R30
;     422 
;     423 }
	RET
;     424 
;     425 
;     426 // Жду флажка окончания текущей операции
;     427 static void twi_wait_int (void)
;     428 {
_twi_wait_int_G3:
;     429 	while (!(TWCR & (1<<TWINT))); 
_0x28:
	RCALL SUBOPT_0xA
	BREQ _0x28
;     430 }
	RET
;     431 
;     432 /* Проверка обращения к данному устройству...
;     433 // Возвращает не 0, если было обращение
;     434 unsigned char rx_addr (void)
;     435 {
;     436 	twi_wait_int();        
;     437     if ((TWSR == SRX_ADR_ACK) || (TWSR == SRX_GADR_ACK))
;     438     {
;     439     return 0;                   //поступил адрес/общ.адрес...
;     440     }        
;     441     return 255;
;     442 } */
;     443 
;     444 
;     445 // Прием байта из канала TWI
;     446 inline unsigned char ReceiveChar(void)
;     447 {
_ReceiveChar:
;     448     while (1)
_0x2B:
;     449     {
;     450         twi_wait_int();         //ждем байт - данные
	RCALL SUBOPT_0xB
;     451 
;     452         if ((TWSR == SRX_DATA_ACK)||(TWSR == SRX_GDATA_ACK)) 
	CPI  R30,LOW(0x80)
	BREQ _0x2F
	IN   R30,0x1
	CPI  R30,LOW(0x90)
	BRNE _0x2E
_0x2F:
;     453             {
;     454         	return TWDR;
	IN   R30,0x3
	RET
;     455             }
;     456         if (TWSR == STX_ADR_ACK)				// хотят прочитать нас
_0x2E:
	IN   R30,0x1
	CPI  R30,LOW(0xA8)
	BRNE _0x31
;     457         	{
;     458 //				if (dannForTX) txBuff();
;     459 //				else
;     460 				 TWDR = 0;
	LDI  R30,LOW(0)
	OUT  0x3,R30
;     461         	}
;     462 
;     463       TWCR = ((1<<TWINT)+(1<<TWEA)+(1<<TWEN));    //формируем АСК
_0x31:
	RCALL SUBOPT_0xC
;     464     }
	RJMP _0x2B
;     465 //        twi_wait_int();         //ждем байт - данные
;     466 
;     467 }
;     468 
;     469 // Прием байта из канала
;     470 unsigned char GetByte(void)
;     471 {
_GetByte:
;     472 	register unsigned char ret;
;     473 	ret = ReceiveChar();
	ST   -Y,R16
;	ret -> R16
	RCALL _ReceiveChar
	MOV  R16,R30
;     474 
;     475 	TWCR = ((1<<TWINT)+(1<<TWEA)+(1<<TWEN));    //формируем АСК
	RCALL SUBOPT_0xC
;     476 
;     477 	pcrc += ret;
	MOV  R30,R16
	RCALL SUBOPT_0xD
;     478 	nbyts ++;
	LDS  R30,_nbyts
	SUBI R30,-LOW(1)
	STS  _nbyts,R30
;     479 
;     480 	if (descramble)		// Если нужно дешифровать - дешифрую
	SBRS R2,1
	RJMP _0x32
;     481 	{
;     482 		ret ^= NextSeqByte();
	RCALL _NextSeqByte
	EOR  R16,R30
;     483 	}	
;     484 	return ret;
_0x32:
	MOV  R30,R16
_0x55:
	LD   R16,Y+
	RET
;     485 }
;     486 
;     487 // Передача байта данных
;     488 // Возвращает не 0, если все в порядке
;     489 unsigned char twi_byte (unsigned char data)
;     490 {
_twi_byte:
;     491 	twi_wait_int();
	RCALL _twi_wait_int_G3
;     492 
;     493 	TWDR = data;
	LD   R30,Y
	OUT  0x3,R30
;     494     TWCR = ((1<<TWINT)+(1<<TWEA)+(1<<TWEN));    //формируем АСК
	RCALL SUBOPT_0xC
;     495 // 	TWCR = ((1<<TWINT)+(1<<TWEN));
;     496 
;     497 	twi_wait_int();
	RCALL SUBOPT_0xB
;     498 
;     499 	if(TWSR != MTX_DATA_ACK)
	CPI  R30,LOW(0x28)
	BREQ _0x33
;     500 	{
;     501 		return 0;
	LDI  R30,LOW(0)
	RJMP _0x54
;     502 	}
;     503 		
;     504 	return 255;
_0x33:
	LDI  R30,LOW(255)
_0x54:
	ADIW R28,1
	RET
;     505 }
;     506 
;     507 
;     508 
;     509 // Ожидание заголовка пакета
;     510 unsigned char Wait4Hdr(void)
;     511 {
_Wait4Hdr:
;     512     unsigned char a,b;
;     513 
;     514 	#asm("wdr");		// Перед приемом очередного пакета перезапускаю вотчдог
	RCALL __SAVELOCR2
;	a -> R16
;	b -> R17
	wdr
;     515 		
;     516 	while(1)
_0x34:
;     517 	{
;     518 //putchar (0xaa);
;     519 		if (prgmode)	// Если меня уже спрашивали, то след. пакет можно ждать долго
	SBRS R2,0
	RJMP _0x37
;     520 		{
;     521 			while (!(TWCR & (1<<TWINT))) 
_0x38:
	RCALL SUBOPT_0xA
	BRNE _0x3A
;     522 
;     523 //			while(!twi_wait_int())   							//Ждем обращения главного...
;     524 			{
;     525 				#asm("wdr");
	wdr
;     526 			}
	RJMP _0x38
_0x3A:
;     527 		}
;     528 
;     529 		pcrc = 0;
_0x37:
	LDI  R30,LOW(0)
	STS  _pcrc,R30
;     530 		if (GetByte() != PACKHDR)	// Жду заголовок
	RCALL _GetByte
	CPI  R30,LOW(0x71)
	BREQ _0x3B
;     531 		{
;     532 			continue;
	RJMP _0x34
;     533 		}
;     534 
;     535 		plen = GetByte();		 	// Длина пакета
_0x3B:
	RCALL _GetByte
	STS  _plen,R30
;     536 		nbyts = 0;  
	LDI  R30,LOW(0)
	STS  _nbyts,R30
;     537 		
;     538         adr = GetByte();																	
	RCALL _GetByte
	MOV  R4,R30
;     539 
;     540        	 typePack= GetByte();      // Возвращаю тип пакета
	RCALL _GetByte
	MOV  R5,R30
;     541            
;     542 if  ((typePack == PT_WRFLASH)||(typePack ==PT_WREEPROM))				// если пакет для флэш то
	LDI  R30,LOW(9)
	CP   R30,R5
	BREQ _0x3D
	LDI  R30,LOW(10)
	CP   R30,R5
	BRNE _0x3C
_0x3D:
;     543 			{			
;     544 			 	DescrambleStart();					// расшифровываем
	SET
	BLD  R2,1
;     545 //				 print = 1;      	 
;     546              }
;     547              
;     548 		for (a=0; a<plen-3;a++)
_0x3C:
	LDI  R16,LOW(0)
_0x40:
	LDS  R30,_plen
	SUBI R30,LOW(3)
	CP   R16,R30
	BRSH _0x41
;     549 			{
;     550 				b=GetByte();
	RCALL _GetByte
	MOV  R17,R30
;     551 				rxBuffer [a] = b;				// заполняем буффер данными
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_rxBuffer)
	SBCI R27,HIGH(-_rxBuffer)
	ST   X,R17
;     552 //if (print) putchar (b);
;     553 			}      
	SUBI R16,-1
	RJMP _0x40
_0x41:
;     554 
;     555 			DescrambleStop();
	CLT
	BLD  R2,1
;     556 
;     557 		if (PackOk())	return typePack;			// сверяем КС
	RCALL _PackOk
	CPI  R30,0
	BREQ _0x42
	MOV  R30,R5
	RJMP _0x53
;     558 		else 	return 0;
_0x42:
	LDI  R30,LOW(0)
;     559 
;     560 	}                             
;     561 }
_0x53:
	RCALL __LOADLOCR2P
	RET
;     562 
;     563 
;     564 
;     565 
;     566 
;     567 /*
;     568 // Принимаем адрес/данные
;     569 // Возвращает не 0, если все в порядке
;     570 unsigned char twi_addr (unsigned char addr)
;     571 {
;     572 	twi_wait_int();
;     573 
;     574 	TWDR = addr;
;     575 	TWCR = ((1<<TWINT)+(1<<TWEN));
;     576 
;     577 	twi_wait_int();
;     578 
;     579 	if((TWSR != MTX_ADR_ACK)&&(TWSR != MRX_ADR_ACK))
;     580 	{
;     581 		return 0;
;     582 	}
;     583 	return 255;
;     584 } */
;     585 // Обмен пакетами с хостом
;     586 #include "monitor.h"   
;     587 #include "CodingM8.h"
;     588 
;     589         
;     590    
;     591 
;     592 unsigned char pcrc;	// Контрольная сумма

	.DSEG
_pcrc:
	.BYTE 0x1
;     593 unsigned char plen;	// Длина пакета
_plen:
	.BYTE 0x1
;     594 unsigned char nbyts;	// Число принятых или переданых байт
_nbyts:
	.BYTE 0x1
;     595 bit prgmode  = 0;		// Находимся в режиме программирования
;     596 
;     597 
;     598 // Прием слова из буффера
;     599 unsigned short GetWordBuff(unsigned char a)
;     600 {

	.CSEG
_GetWordBuff:
;     601 	register unsigned short ret;  
;     602 
;     603 	ret = 	rxBuffer	[a++];
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
;     604 	ret |= ((unsigned short)rxBuffer[a]) << 8;
	LDD  R30,Y+2
	RCALL SUBOPT_0xE
	LD   R31,Z
	LDI  R30,LOW(0)
	__ORWRR 16,17,30,31
;     605 	
;     606 	return ret;
	MOVW R30,R16
	RCALL __LOADLOCR2
	ADIW R28,3
	RET
;     607 } 
;     608 
;     609 /*// Передача байта в кан\ал
;     610 void PutByte(unsigned char byt)
;     611 {
;     612 	pcrc += byt;
;     613 	nbyts ++;
;     614 	
;     615 	twi_byte(byt);
;     616 } */
;     617 
;     618 // Контроль успешного завершения приема пакета
;     619 unsigned char PackOk(void)
;     620 {
_PackOk:
;     621 	register unsigned char crc;
;     622 
;     623 	// Сверяю контрольную сумму	
;     624 	crc = pcrc;
	ST   -Y,R16
;	crc -> R16
	LDS  R16,_pcrc
;     625 	if (GetByte() != crc)
	RCALL _GetByte
	CP   R16,R30
	BREQ _0x44
;     626 	{
;     627 		return 0;
	LDI  R30,LOW(0)
	RJMP _0x52
;     628 	}
;     629 
;     630 	// Сверяю длину пакета	
;     631 	if (nbyts != plen)
_0x44:
	LDS  R30,_plen
	LDS  R26,_nbyts
	CP   R30,R26
	BREQ _0x45
;     632 	{
;     633 		return 0;
	LDI  R30,LOW(0)
	RJMP _0x52
;     634 	}
;     635 	
;     636 	return 1;
_0x45:
	LDI  R30,LOW(1)
	RJMP _0x52
;     637 }
;     638 
;     639 // Начало передачи ответного пакета
;     640 void ReplyStart(unsigned char bytes)
;     641 {
_ReplyStart:
;     642 	plen = bytes + 1;
	LD   R30,Y
	SUBI R30,-LOW(1)
	STS  _plen,R30
;     643 	pcrc = plen;
	STS  _pcrc,R30
;     644 
;     645 	twi_byte(plen);
	LDS  R30,_plen
	RCALL SUBOPT_0xF
;     646 }
	ADIW R28,1
	RET
;     647 
;     648 // Передача содержимого буфера в канал TWI
;     649 void txBuff (void)
;     650 	{
_txBuff:
;     651 		unsigned char a;
;     652 
;     653 		twi_byte(0);				  			// 
	ST   -Y,R16
;	a -> R16
	RCALL SUBOPT_0x0
	RCALL _twi_byte
;     654 		
;     655 		ReplyStart (txBuffer[0] );	 	// передаем длину
	LDS  R30,_txBuffer
	ST   -Y,R30
	RCALL _ReplyStart
;     656 
;     657 		for (a=1; a<txBuffer[0]+1;a++)
	LDI  R16,LOW(1)
_0x47:
	LDS  R30,_txBuffer
	SUBI R30,-LOW(1)
	CP   R16,R30
	BRSH _0x48
;     658 			{       
;     659 			     	twi_byte(txBuffer[a]);
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xF
;     660 			     	pcrc+= txBuffer[a];
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xD
;     661 			}
	SUBI R16,-1
	RJMP _0x47
_0x48:
;     662 		twi_byte(pcrc);						//передаем КС
	LDS  R30,_pcrc
	RCALL SUBOPT_0xF
;     663 
;     664 		dannForTX = 0;								// передали данные	
	CLT
	BLD  R2,2
;     665 
;     666 //		if (toReboot) RebootToWork();			// на перезагрузку
;     667 		
;     668 	}
_0x52:
	LD   R16,Y+
	RET
;     669 
;     670 ///////////////////////////////////////////////////////////////////////////////////////////
;     671 // Дешифрование программирующих данных
;     672 
;     673 unsigned long int next_rand = 1;

	.DSEG
_next_rand:
	.BYTE 0x4
;     674 unsigned char rand_cnt = 31;
;     675 
;     676 // Генератор псевдослучайной последовательности.
;     677 // За основу взяты IAR-овские исходники
;     678 
;     679 bit descramble = 0;					// Признак необходимости дешифрования
;     680 
;     681 unsigned char NextSeqByte(void)	// Очередной байт дешифрующей последовательности
;     682 {

	.CSEG
_NextSeqByte:
;     683 	next_rand = next_rand * 1103515245 + 12345;
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
;     684 	next_rand >>= 8;
	LDS  R26,_next_rand
	LDS  R27,_next_rand+1
	LDS  R24,_next_rand+2
	LDS  R25,_next_rand+3
	RCALL SUBOPT_0x8
	STS  _next_rand,R30
	STS  _next_rand+1,R31
	STS  _next_rand+2,R22
	STS  _next_rand+3,R23
;     685 	
;     686 	rand_cnt += 101;
	LDI  R30,LOW(101)
	ADD  R6,R30
;     687 		
;     688 	return rand_cnt ^ (unsigned char)next_rand;
	LDS  R30,_next_rand
	EOR  R30,R6
	RET
;     689 }
;     690 
;     691 void ResetDescrambling(void)		// Перезапуск генератора дешифрующей последовательности
;     692 {
_ResetDescrambling:
;     693 	next_rand = scrambling_seed;
	LDI  R30,LOW(_scrambling_seed*2)
	LDI  R31,HIGH(_scrambling_seed*2)
	RCALL __GETW1PF
	CLR  R22
	CLR  R23
	STS  _next_rand,R30
	STS  _next_rand+1,R31
	STS  _next_rand+2,R22
	STS  _next_rand+3,R23
;     694 	rand_cnt = 31;
	LDI  R30,LOW(31)
	MOV  R6,R30
;     695 	descramble = 0;
	CLT
	BLD  R2,1
;     696 }
	RET
;     697 //--------------------------------------------------------------------------------------
;     698 // Функции для работы с FLASH
;     699 
;     700 #include "monitor.h"
;     701 
;     702 #if (defined _CHIP_ATMEGA128L_) || (defined _CHIP_ATMEGA128_)
;     703 	#asm
;     704 		.equ	SPMCSR = 0x68
;     705 		.equ	SPMREG = SPMCSR
;     706 	#endasm
;     707 #elif (defined _CHIP_ATMEGA8_) || (defined _CHIP_ATMEGA8L_) || (defined _CHIP_ATMEGA8515_) || (defined _CHIP_ATMEGA8515L_) || (defined _CHIP_ATMEGA162_) || (defined _CHIP_ATMEGA162L_)
;     708 	#asm
;     709 		.equ	SPMCR  = 0x37
		.equ	SPMCR  = 0x37
;     710 		.equ	SPMREG = SPMCR
		.equ	SPMREG = SPMCR
;     711 	#endasm
;     712 #else
;     713 	#error Поддержка для этого процессора еще не написана
;     714 #endif
;     715 
;     716 #asm
;     717 	.equ	SPMEN  = 0	; Биты регистра
	.equ	SPMEN  = 0	; Биты регистра
;     718 	.equ	PGERS  = 1
	.equ	PGERS  = 1
;     719 	.equ	PGWRT  = 2
	.equ	PGWRT  = 2
;     720 	.equ	BLBSET = 3
	.equ	BLBSET = 3
;     721 	.equ	RWWSRE = 4
	.equ	RWWSRE = 4
;     722 	.equ	RWWSB  = 6
	.equ	RWWSB  = 6
;     723 	.equ	SPMIE  = 7
	.equ	SPMIE  = 7
;     724 	;--------------------------------------------------
	;--------------------------------------------------
;     725 	; Ожидание завершения SPM. Портит R23
	; Ожидание завершения SPM. Портит R23
;     726 	spmWait:
	spmWait:
;     727 #endasm
;     728 #ifdef USE_MEM_SPM
;     729 	#asm
;     730 		lds		r23, SPMREG
;     731 	#endasm
;     732 #else
;     733 	#asm
;     734 		in		r23, SPMREG
		in		r23, SPMREG
;     735 	#endasm
;     736 #endif
;     737 #asm
;     738 		andi	r23, (1 << SPMEN)
		andi	r23, (1 << SPMEN)
;     739 		brne	spmWait	
		brne	spmWait	
;     740 		ret
		ret
;     741 	;--------------------------------------------------
	;--------------------------------------------------
;     742 	; Запуск SPM.
	; Запуск SPM.
;     743 	spmSPM:
	spmSPM:
;     744 		in		r24, SREG	; Сохраняю состояние
		in		r24, SREG	; Сохраняю состояние
;     745 		cli					; Запрещаю прерывания
		cli					; Запрещаю прерывания
;     746 #endasm
;     747 #ifdef USE_RAMPZ
;     748 	#asm
;     749 		in		r25, RAMPZ	; Сохраняю RAMPZ
;     750 	#endasm
;     751 #endif
;     752 #asm
;     753 		ld		r30, y		; Адрес
		ld		r30, y		; Адрес
;     754 		ldd		r31, y+1
		ldd		r31, y+1
;     755 #endasm
;     756 #ifdef USE_RAMPZ
;     757 	#asm
;     758 		ldd		r26, y+2	; 3-й байт адреса - в RAMPZ
;     759 		out		RAMPZ, r26
;     760 	#endasm
;     761 #endif
;     762 #asm
;     763 		rcall	spmWait		; Жду завершения предидущей операции (на всякий случай)
		rcall	spmWait		; Жду завершения предидущей операции (на всякий случай)
;     764 #endasm
;     765 #ifdef USE_MEM_SPM
;     766 	#asm
;     767 		sts SPMREG, r22		; Регистр команд, как память
;     768 	#endasm
;     769 #else
;     770 	#asm
;     771 		out SPMREG, r22		; Регистр команд, как порт
		out SPMREG, r22		; Регистр команд, как порт
;     772 	#endasm
;     773 #endif
;     774 #asm
;     775 		spm					; Запуск на выполнение
		spm					; Запуск на выполнение
;     776 		nop
		nop
;     777 		nop
		nop
;     778 		nop
		nop
;     779 		nop
		nop
;     780 		rcall	spmWait		; Жду завершения
		rcall	spmWait		; Жду завершения
;     781 #endasm
;     782 #ifdef USE_RAMPZ
;     783 	#asm
;     784 		out		RAMPZ, r25	; Восстанавливаю состояние
;     785 	#endasm
;     786 #endif
;     787 #asm
;     788 		out		SREG, r24
		out		SREG, r24
;     789 		ret
		ret
;     790 #endasm
;     791 
;     792 #pragma warn-
;     793 void ResetTempBuffer (FADDRTYPE addr)
;     794 {
_ResetTempBuffer:
;     795 	#asm
;     796 		ldi		r22, (1 << RWWSRE) | (1 << SPMEN)
		ldi		r22, (1 << RWWSRE) | (1 << SPMEN)
;     797 		rcall	spmSPM
		rcall	spmSPM
;     798 	#endasm
;     799 }
	ADIW R28,2
	RET
;     800 
;     801 void FillTempBuffer (unsigned short data, FADDRTYPE addr)
;     802 {
_FillTempBuffer:
;     803 	#ifdef USE_RAMPZ
;     804 		#asm
;     805 			ldd		r0, y+4			; Данные
;     806 			ldd		r1,	y+5
;     807 		#endasm
;     808 	#else
;     809 		#asm
;     810 			ldd		r0, y+2			; Данные
			ldd		r0, y+2			; Данные
;     811 			ldd		r1,	y+3
			ldd		r1,	y+3
;     812 		#endasm
;     813 	#endif
;     814 	#asm
;     815 		ldi		r22, (1 << SPMEN)	; Команда
		ldi		r22, (1 << SPMEN)	; Команда
;     816 		rcall	spmSPM				; На выполнение
		rcall	spmSPM				; На выполнение
;     817 	#endasm
;     818 }
	ADIW R28,4
	RET
;     819 
;     820 void PageErase (FADDRTYPE  addr)
;     821 {
_PageErase:
;     822 	#asm
;     823 		ldi		r22, (1 << PGERS) | (1 << SPMEN)
		ldi		r22, (1 << PGERS) | (1 << SPMEN)
;     824 		rcall	spmSPM
		rcall	spmSPM
;     825 	#endasm
;     826 }
	ADIW R28,2
	RET
;     827 
;     828 void PageWrite (FADDRTYPE addr)
;     829 {
_PageWrite:
;     830 	#asm
;     831 		ldi		r22, (1 << PGWRT) | (1 << SPMEN)
		ldi		r22, (1 << PGWRT) | (1 << SPMEN)
;     832 		rcall	spmSPM
		rcall	spmSPM
;     833 	#endasm
;     834 }
	ADIW R28,2
	RET
;     835 #pragma warn+
;     836 
;     837 void PageAccess (void)
;     838 {
_PageAccess:
;     839 	#asm
;     840 		ldi		r22, (1 << RWWSRE) | (1 << SPMEN)
		ldi		r22, (1 << RWWSRE) | (1 << SPMEN)
;     841 		rcall	spmSPM
		rcall	spmSPM
;     842 	#endasm
;     843 }
	RET
;     844 
;     845 // Запись страницы FLASH
;     846 void WriteFlash(void)
;     847 {
_WriteFlash:
;     848 	unsigned char a=0;
;     849 //	int temp;
;     850 	FADDRTYPE faddr;
;     851 	
;     852 	// Получаю номер страницы
;     853 	#asm ("wdr");
	RCALL __SAVELOCR3
;	a -> R16
;	faddr -> R17,R18
	LDI  R16,0
	wdr
;     854 	faddr = GetWordBuff(a);
	RCALL SUBOPT_0x11
	__PUTW1R 17,18
;     855 	a+=2;							// вычитали 2 байта
	SUBI R16,-LOW(2)
;     856 	
;     857 	if (faddr >= PRGPAGES)
	__CPWRN 17,18,96
	BRLO _0x4B
;     858 	{
;     859 		while(1);	// Если неправильный номер страницы - непоправимая ошибка и вылет по вотчдогу
_0x4C:
	RJMP _0x4C
;     860 	}	            
;     861 	
;     862 
;     863 	// Получаю адрес начала страницы
;     864 	faddr <<= (ZPAGEMSB + 1);
_0x4B:
	__GETW2R 17,18
	LDI  R30,LOW(6)
	RCALL __LSLW12
	__PUTW1R 17,18
;     865 	
;     866 	// Загрузка данных в промежуточный буфер
;     867 	#asm ("wdr");
	wdr
;     868 	ResetTempBuffer(faddr);
	ST   -Y,R18
	ST   -Y,R17
	RCALL _ResetTempBuffer
;     869 	do{
_0x50:
;     870 			FillTempBuffer(GetWordBuff(a), faddr);			// 
	RCALL SUBOPT_0x11
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R18
	ST   -Y,R17
	RCALL _FillTempBuffer
;     871 			a+=2;
	SUBI R16,-LOW(2)
;     872 			faddr += 2;
	__ADDWRN 17,18,2
;     873     	}while (faddr & (PAGESIZ-1)) ;	
	MOV  R30,R17
	ANDI R30,LOW(0x3F)
	BRNE _0x50
;     874 
;     875 		// Сигналю, что все в порядке и можно посылать следующий
;     876 		#asm ("wdr");
	wdr
;     877 		txBuffer[0] = 1;                   		// длина
	RCALL SUBOPT_0x2
;     878 		txBuffer[1] = RES_OK;
	__PUTB1MN _txBuffer,1
;     879 		dannForTX = 1;							// есть данные	
	SET
	BLD  R2,2
;     880 
;     881 	// Восстанавливаю адрес начала страницы
;     882 	faddr -= PAGESIZ;
	__SUBWRN 17,18,64
;     883 
;     884 	// Стираю страницу
;     885 	#asm ("wdr");
	wdr
;     886 	PageErase(faddr);
	ST   -Y,R18
	ST   -Y,R17
	RCALL _PageErase
;     887 	
;     888 	// Записываю страницу
;     889 	#asm ("wdr");
	wdr
;     890 	PageWrite(faddr);
	ST   -Y,R18
	ST   -Y,R17
	RCALL _PageWrite
;     891 
;     892 	// Разрешить адресацию области RWW
;     893 	#asm ("wdr");
	wdr
;     894 	PageAccess();
	RCALL _PageAccess
;     895 
;     896 /*	// Сигналю, что все в порядке и можно посылать следующий
;     897 	#asm ("wdr");
;     898 		txBuffer[0] = 1;                   		// длина
;     899 		txBuffer[1] = RES_OK;
;     900 		dannForTX = 1;							// есть данные	*/
;     901 
;     902 }
	RCALL SUBOPT_0x3
	RET
;     903  

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
