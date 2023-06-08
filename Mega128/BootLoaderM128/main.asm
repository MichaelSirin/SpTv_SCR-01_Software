;CodeVisionAVR C Compiler V1.24.7e Professional
;(C) Copyright 1998-2005 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega128
;Program type           : Boot Loader
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
	.ORG 0xFC00

	.INCLUDE "main.vec"
	.INCLUDE "main.inc"

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	LDI  R31,1
	OUT  RAMPZ,R31

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF THE BOOT LOADER
	OUT  MCUCR,R31
	LDI  R31,2
	OUT  MCUCR,R31
	STS  XMCRB,R30

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
	ELPM R24,Z+
	ELPM R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	ELPM R26,Z+
	ELPM R27,Z+
	ELPM R0,Z+
	ELPM R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	ELPM R0,Z+
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
;       1 /*////////////////////////////////////////////////////////////////////////////////////////////////////////
;       2 // Монитор - загрузчик FLASH и EEPROM. Работает по TWI
;       3 ////////////////////////////////////////////////////////////////////////////////////////////////////////
;       4 #include "monitor.h" 
;       5 #include "CodingM8.h"      
;       6 #include "stdio.h"  
;       7 #include "string.h"  
;       8 
;       9 
;      10 eeprom unsigned char device_name[32] =					// Имя устройства
;      11 		"BOOT PROGRAM. Mega 128 ";
;      12 //eeprom unsigned long my_ser_num = 1;					// Серийный номер устройства
;      13 #define  my_ser_num  1					// Серийный номер устройства
;      14 
;      15 const flash unsigned short my_version_high = 1;				// Версия софта 
;      16 const flash unsigned short my_version_low = 1;				// Версия софта 
;      17 
;      18 eeprom unsigned char my_addr = TO_MON;					// Мой адрес - изначально TO_MON
;      19     
;      20 
;      21 const   unsigned int scrambling_seed = 333;
;      22 
;      23 //unsigned char pAddr;				// Адрес устройства по шине TWI
;      24 //unsigned char adr;									// адрес в пришедшем пакете
;      25 unsigned char rxPack;							// принят пакет TWI
;      26 
;      27 // Все для работы с TWI
;      28 TWISR TWI_statusReg;   
;      29 unsigned char 	TWI_slaveAddress = MY_TWI_ADDRESS;		// Own TWI slave address
;      30 
;      31 
;      32 bit		TWI_TX_Packet_Present				=		0;					// есть данные на передачу
;      33 bit		toReboot										=		0;					// перезагружаем в рабочую программу
;      34 bit		toProgramming								=		0;					// нас программируют
;      35 	
;      36 unsigned char txBufferTWI 			[TWI_Buffer_TX];		// передающий буфер
;      37 unsigned char rxBufferTWI	[TWI_BUFFER_SIZE];	// приемный буфер
;      38 
;      39 
;      40 // Вернуть информацию о мониторе и процессоре
;      41 void PrgInfo(void)
;      42 {
;      43 	// Отправляю ответ
;      44 //	#asm("wdr");
;      45 	txBufferTWI[Start_Position_for_Reply] = (sizeof(RP_PRGINFO) +1);
;      46 
;      47 	txBufferTWI[Start_Position_for_Reply+1] = (PAGESIZ);     			//мл.
;      48 	txBufferTWI[Start_Position_for_Reply+2] = (PAGESIZ>>8);          //ст.
;      49 
;      50 	txBufferTWI[Start_Position_for_Reply+3] = (PRGPAGES);
;      51 	txBufferTWI[Start_Position_for_Reply+4] = (PRGPAGES>>8);
;      52 
;      53 	txBufferTWI[Start_Position_for_Reply+5] = (EEPROMSIZ);
;      54 	txBufferTWI[Start_Position_for_Reply+6] = (EEPROMSIZ>>8);
;      55 
;      56 	txBufferTWI[Start_Position_for_Reply+7] = (MONITORVERSION);
;      57 	txBufferTWI[Start_Position_for_Reply+8] = (MONITORVERSION>>8);
;      58 	
;      59 	txBufferTWI[Start_Position_for_Reply+9] = calc_CRC( &txBufferTWI[Start_Position_for_Reply] );
;      60 
;      61 	// Перешел в режим программирования - теперь могу долго ждать очередной пакет
;      62 	prgmode = 1;
;      63 	
;      64 	// Обнуляю генератор дешифрующей последовательности
;      65 	ResetDescrambling();
;      66 }
;      67 
;      68 
;      69 // Прием слова из буффера
;      70 unsigned short GetWordBuff(unsigned char a)
;      71 {
;      72 	register unsigned short ret;  
;      73 
;      74 	// дискремблируем
;      75 	ret = ( rxBufferTWI	[a++] ^ NextSeqByte() );
;      76 	ret |= ((unsigned short)rxBufferTWI[a] ^ NextSeqByte() ) << 8;
;      77 
;      78 	return ret;
;      79 } 
;      80 
;      81 
;      82 
;      83 // Запись в EEPROM
;      84 void WriteEeprom(void)
;      85 {
;      86 	register unsigned short addr;
;      87 	register unsigned char  data;
;      88 
;      89 	// Прием адреса и данных	
;      90 	#asm ("wdr");
;      91 
;      92 	addr = GetWordBuff(5);
;      93 	data = ( rxBufferTWI	[7] ^ NextSeqByte() );
;      94 
;      95 
;      96 	// Проверяю завершение и корректность пакета
;      97 	if (addr < EEPROMSIZ)
;      98 	{
;      99 		// Пишу в EEPROM
;     100 		*((char eeprom *)addr) = data;
;     101 
;     102 		// Проверяю, записалось ли
;     103 		if (*((char eeprom *)addr) == data)
;     104 		{
;     105 			// Сигналю, что все в порядке 
;     106 			txBufferTWI[Start_Position_for_Reply] = 2;        				// длина
;     107 			txBufferTWI[Start_Position_for_Reply+1] = RES_OK;				//  OK
;     108 			txBufferTWI[Start_Position_for_Reply+2] = 2 + RES_OK;		//  CRC
;     109 
;     110 			return;
;     111 		}
;     112 	}
;     113      
;     114 	// Ошибка
;     115 	txBufferTWI[Start_Position_for_Reply] = 2;        				// длина
;     116 	txBufferTWI[Start_Position_for_Reply+1] = RES_ERR;			//  ошибка
;     117 	txBufferTWI[Start_Position_for_Reply+2] = 2 + RES_ERR;		//  CRC
;     118 
;     119 } 
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
;     150 	FADDRTYPE addr, lastaddr;
;     151 	unsigned short crc, fcrc;
;     152 	
;     153 	//WD пока не включен	
;     154 //	#asm("wdr");
;     155 	
;     156 	lastaddr = ( (FADDRTYPE)FlashByte(PRGPAGES*PAGESIZ - 4) | 
;     157 	            ((FADDRTYPE)FlashByte(PRGPAGES*PAGESIZ - 3) << 8))
;     158 	            << (ZPAGEMSB + 1);
;     159 	            
;     160 
;     161 	if (lastaddr == (0xFFFF << (ZPAGEMSB + 1)))
;     162 	{
;     163 	        return 0;
;     164 	}
;     165 	
;     166 	for (addr = 0, crc = 0; addr != lastaddr; addr ++)
;     167 	{
;     168 		crc += FlashByte(addr);
;     169 	}
;     170 
;     171 	fcrc = 	 (unsigned short)FlashByte(PRGPAGES*PAGESIZ - 2) | 
;     172 			((unsigned short)FlashByte(PRGPAGES*PAGESIZ - 1) << 8);
;     173 	
;     174 	if (crc != fcrc)
;     175 	{
;     176 		return 0;
;     177 	}
;     178 	
;     179 	return 1;
;     180 }
;     181 
;     182 // Перезагрузка в рабочий режим
;     183 void RebootToWork(void)
;     184 {
;     185 	// Проверяю, есть ли куда грузиться
;     186 	if (!AppOk())
;     187 	{
;     188 		return;
;     189 	}
;     190 
;     191 	#asm("cli");
;     192 	IVCREG = 1 << IVCE;
;     193 	IVCREG = 0;
;     194 
;     195 	#asm("rjmp 0");      //Mega128 - JMP, Mega8 - RJMP
;     196 }
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
;     278 	// Настраиваю "железо"
;     279 	 Initialization_Device(); 
;     280 
;     281 	// Global enable interrupts
;     282 	#asm("sei")
;     283 
;     284 	// Ожидание, прием и исполнение команд
;     285 	while (1)
;     286 	{
;     287 
;     288 	// Опрашиваем наличие программы по таймеру (примерно 2с)
;     289 	if ( TIFR & (1 << TOV1) )
;     290 	{
;     291 		TIFR |= (1<<TOV1);
;     292 		TCNT1=0xD2F6;		//примерно 2сек
;     293 
;     294 		// Пытаюсь перегрузиться в рабочий режим	
;     295 		RebootToWork();
;     296 	}
;     297 
;     298 //		#asm("wdr");
;     299 		run_TWI_slave();
;     300 		
;     301 		// Обрабатываем принятый пакет TWI
;     302 		if ( rxPack )
;     303 		{
;     304 			// Обработка внутренних пакетов
;     305 			if ( ( Recived_Address == Internal_Packet ) || ( Recived_Address == Global_Packet ) )		
;     306 			{
;     307 				switch ( Type_RX_Packet_TWI )
;     308 				{
;     309 					// возвращаем о себе информацию
;     310 					case PT_GETINFO:			
;     311 //							GetInfo();
;     312 							break;                                     
;     313 
;     314 					// возвращаем состояние						
;     315 					case PT_GETSTATE:			
;     316 //							GetState();
;     317 							break;                      
;     318 
;     319 					// Переход в программирование
;     320 					case PT_TOPROG:
;     321 							toProgramming = 1;				// ждем пакеты программирования
;     322 							// формируем ответ
;     323 							txBufferTWI[0] = 1;				 	// длина пакета
;     324 							txBufferTWI[1] = 1;				 	// КС
;     325 
;     326 							break;      
;     327 
;     328 					// Вернуть информацию о мониторе и процессоре
;     329 					case PT_PRGINFO:	
;     330 							PrgInfo();
;     331 							break;
;     332 
;     333 					// Записать страницу FLASH							
;     334 					case PT_WRFLASH:	
;     335 
;     336 //							TCNT1=0xD2F6;		//примерно 2сек
;     337 
;     338 //							toProgramming = 1;				// ждем пакеты программирования
;     339 							WriteFlash();
;     340 							break;
;     341 
;     342 					// Записать байт в EEPROM
;     343 					case PT_WREEPROM:	
;     344 
;     345 //							TCNT1=0xD2F6;		//примерно 2сек
;     346 
;     347 							WriteEeprom();
;     348 							break;
;     349 			
;     350 
;     351 					default:
;     352 //							toProgramming = 0;		// программируют не нас
;     353 				}
;     354 				// отправляем ответ
;     355 				packPacket (External_Packet);	// даем тип ВНЕШНИЙ
;     356 				// переинициализируем таймер
;     357 				TCNT1=0xD2F6;		//примерно 2сек
;     358 	         }
;     359 		
;     360 		rxPack = 0;							// пакет обработан
;     361         }          
;     362 	}
;     363 }*/
;     364 
;     365 
;     366 ////////////////////////////////////////////////////////////////////////////////////////////
;     367 // Монитор - загрузчик FLASH и EEPROM
;     368 ////////////////////////////////////////////////////////////////////////////////////////////
;     369 #include "monitor.h"
;     370 
;     371 
;     372 // Вернуть информацию о мониторе и процессоре
;     373 void PrgInfo(void)
;     374 {

	.CSEG
_PrgInfo:
;     375 	// Проверяю завершение пакета
;     376 	if (!PackOk())
	CALL _PackOk
	CPI  R30,0
	BRNE _0x3
;     377 	{
;     378 		return;
	RET
;     379 	}
;     380 	
;     381 	// Отправляю ответ
;     382 	#asm("wdr");
_0x3:
	wdr
;     383 	ReplyStart(sizeof(RP_PRGINFO));
	LDI  R30,LOW(8)
	ST   -Y,R30
	CALL _ReplyStart
;     384 	PutWord(PAGESIZ);
	CALL SUBOPT_0x0
;     385 	PutWord(PRGPAGES);
	LDI  R30,LOW(504)
	LDI  R31,HIGH(504)
	ST   -Y,R31
	ST   -Y,R30
	CALL _PutWord
;     386 	PutWord(EEPROMSIZ);
	LDI  R30,LOW(4096)
	LDI  R31,HIGH(4096)
	ST   -Y,R31
	ST   -Y,R30
	CALL _PutWord
;     387 	PutWord(MONITORVERSION);
	CALL SUBOPT_0x0
;     388 	ReplyEnd();
	CALL _ReplyEnd
;     389 
;     390 	// Перешел в режим программирования - теперь могу долго ждать очередной пакет
;     391 	prgmode = 1;
	SET
	BLD  R2,0
;     392 	
;     393 	// Обнуляю генератор дешифрующей последовательности
;     394 	ResetDescrambling();
	CALL _ResetDescrambling
;     395 }
	RET
;     396 
;     397 // Запись в EEPROM
;     398 void WriteEeprom(void)
;     399 {
_WriteEeprom:
;     400 	register unsigned short addr;
;     401 	register unsigned char  data;
;     402 
;     403 	DescrambleStart();
	CALL __SAVELOCR3
;	addr -> R16,R17
;	data -> R18
	SET
	BLD  R2,1
;     404 
;     405 	// Прием адреса и данных	
;     406 	#asm ("wdr");
	wdr
;     407 	addr = GetWord();
	CALL _GetWord
	MOVW R16,R30
;     408 	data = GetByte();
	CALL _GetByte
	MOV  R18,R30
;     409 	
;     410 	DescrambleStop();
	CLT
	BLD  R2,1
;     411 
;     412 	// Проверяю завершение и корректность пакета
;     413 	if (!PackOk() || (addr >= EEPROMSIZ))
	CALL _PackOk
	CPI  R30,0
	BREQ _0x5
	__CPWRN 16,17,4096
	BRLO _0x4
_0x5:
;     414 	{
;     415 		ReplyStart(1);
	CALL SUBOPT_0x1
;     416 		PutByte(RES_ERR);
;     417 		ReplyEnd();
;     418 		return;
	RJMP _0x4D
;     419 	}
;     420 	
;     421 	// Пишу в EEPROM
;     422 	*((char eeprom *)addr) = data;
_0x4:
	MOV  R30,R18
	MOVW R26,R16
	CALL __EEPROMWRB
;     423 	
;     424 	// Проверяю, записалось ли
;     425 	if (*((char eeprom *)addr) != data)
	MOVW R26,R16
	CALL __EEPROMRDB
	CP   R18,R30
	BREQ _0x7
;     426 	{
;     427 		ReplyStart(1);
	CALL SUBOPT_0x1
;     428 		PutByte(RES_ERR);
;     429 		ReplyEnd();
;     430 		return;
	RJMP _0x4D
;     431 	}
;     432 
;     433 	// Сигналю, что все в порядке 
;     434 	ReplyStart(1);
_0x7:
	CALL SUBOPT_0x2
;     435 	PutByte(RES_OK);
;     436 	ReplyEnd();
;     437 }
_0x4D:
	CALL __LOADLOCR3
	ADIW R28,3
	RET
;     438 
;     439 // Чтение байта из FLASH по адресу
;     440 #ifdef USE_RAMPZ
;     441 	#pragma warn-
;     442 	unsigned char FlashByte(FADDRTYPE addr)
;     443 	{
_FlashByte:
;     444 	#asm
;     445 		ld		r30, y		; Загружаю Z
		ld		r30, y		; Загружаю Z
;     446 		ldd		r31, y+1
		ldd		r31, y+1
;     447 		in		r23, rampz	; Сохраняю RAMPZ
		in		r23, rampz	; Сохраняю RAMPZ
;     448 		ldd		r22, y+2	; Переношу RAMPZ
		ldd		r22, y+2	; Переношу RAMPZ
;     449 		out		rampz, r22
		out		rampz, r22
;     450 		elpm	r24, z		; Читаю FLASH
		elpm	r24, z		; Читаю FLASH
;     451 		out		rampz, r23	; Восстанавливаю RAMPZ
		out		rampz, r23	; Восстанавливаю RAMPZ
;     452 		mov		r30, r24	; Возвращаемое значение
		mov		r30, r24	; Возвращаемое значение
;     453 	#endasm
;     454 	}	
	ADIW R28,4
	RET
;     455 	#pragma warn+
;     456 #else
;     457 	#define FlashByte(a) (*((flash unsigned char *)a))
;     458 #endif
;     459 
;     460 // Проверка наличия "рабочей" программы
;     461 unsigned char AppOk(void)
;     462 {
_AppOk:
	PUSH R15
;     463 	FADDRTYPE addr, lastaddr;
;     464 	unsigned short crc, fcrc;
;     465 	bit ha_flag = 0;
;     466 	
;     467 	#asm("wdr");
	SBIW R28,8
	CALL __SAVELOCR4
;	addr -> Y+8
;	lastaddr -> Y+4
;	crc -> R16,R17
;	fcrc -> R18,R19
;	ha_flag -> R15.0
	CLR  R15
	wdr
;     468 
;     469 	// Считываю число используемых секторов
;     470 	lastaddr = ( (FADDRTYPE)FlashByte(PRGPAGES*PAGESIZ - 4) | 
;     471 	            ((FADDRTYPE)FlashByte(PRGPAGES*PAGESIZ - 3) << 8));
	__GETD1N 0x1F7FC
	CALL SUBOPT_0x3
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1N 0x1F7FD
	CALL SUBOPT_0x3
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(8)
	CALL __LSLD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ORD12
	__PUTD1S 4
;     472 
;     473 	// Если FLASH чистый	            
;     474 	if (lastaddr == 0xFFFF)
	__GETD2S 4
	__CPD2N 0xFFFF
	BRNE _0x8
;     475 	{
;     476 		return 0;
;	addr -> Y+8
;	lastaddr -> Y+4
;	ha_flag -> R15.0
	LDI  R30,LOW(0)
	RJMP _0x4C
;     477 	}
;     478 
;     479 	// Задействована последняя доступная для программирования страница	
;     480 	if (lastaddr >= PRGPAGES)
_0x8:
	__GETD2S 4
	__CPD2N 0x1F8
	BRLO _0x9
;     481 	{
;     482 		ha_flag = 1;
;	addr -> Y+8
;	lastaddr -> Y+4
;	ha_flag -> R15.0
	SET
	BLD  R15,0
;     483 	}
;     484 
;     485 	// Умножаю число используемых секторов на размер сектора в байтах	
;     486 	lastaddr = lastaddr << (ZPAGEMSB + 1);
_0x9:
	__GETD2S 4
	LDI  R30,LOW(8)
	CALL __LSLD12
	__PUTD1S 4
;     487 
;     488 	// Если задействована последняя страница
;     489 	// исключаю длину и контрольную сумму из подсчета контрольной суммы
;     490 	if (ha_flag)
	SBRS R15,0
	RJMP _0xA
;     491 	{
;     492 		lastaddr -= 4;
;	addr -> Y+8
;	lastaddr -> Y+4
;	ha_flag -> R15.0
	__GETD1S 4
	__SUBD1N 4
	__PUTD1S 4
;     493 	}
;     494 	
;     495 	// Подсчитываю текущую контрольную сумму
;     496 	for (addr = 0, crc = 0; addr < lastaddr; addr ++)
_0xA:
	__CLRD1S 8
	__GETWRN 16,17,0
_0xC:
	__GETD1S 4
	__GETD2S 8
	CALL __CPD21
	BRSH _0xD
;     497 	{
;     498 		crc += FlashByte(addr);
;	addr -> Y+8
;	lastaddr -> Y+4
;	ha_flag -> R15.0
	__GETD1S 8
	CALL __PUTPARD1
	CALL _FlashByte
	MOVW R26,R16
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
;     499 	}
	__GETD1S 8
	__SUBD1N -1
	__PUTD1S 8
	RJMP _0xC
_0xD:
;     500 
;     501 	// Если задействована последняя страница дополняю место длины
;     502 	// и контрольной суммы пустым местом
;     503 	if (ha_flag)
	SBRS R15,0
	RJMP _0xE
;     504 	{
;     505 		crc += 255;
;	addr -> Y+8
;	lastaddr -> Y+4
;	ha_flag -> R15.0
	__ADDWRN 16,17,255
;     506 		crc += 255;
	__ADDWRN 16,17,255
;     507 		crc += 255;
	__ADDWRN 16,17,255
;     508 		crc += 255;
	__ADDWRN 16,17,255
;     509 	}
;     510 
;     511 	// Считываю опорную контрольную сумму	
;     512 	fcrc = 	 (unsigned short)FlashByte(PRGPAGES*PAGESIZ - 2) | 
_0xE:
;     513 			((unsigned short)FlashByte(PRGPAGES*PAGESIZ - 1) << 8);
	__GETD1N 0x1F7FE
	CALL __PUTPARD1
	CALL _FlashByte
	LDI  R31,0
	PUSH R31
	PUSH R30
	__GETD1N 0x1F7FF
	CALL __PUTPARD1
	CALL _FlashByte
	MOV  R31,R30
	LDI  R30,0
	POP  R26
	POP  R27
	OR   R30,R26
	OR   R31,R27
	MOVW R18,R30
;     514 	
;     515 	if (crc != fcrc)
	__CPWRR 18,19,16,17
	BREQ _0xF
;     516 	{
;     517 		return 0;
;	addr -> Y+8
;	lastaddr -> Y+4
;	ha_flag -> R15.0
	LDI  R30,LOW(0)
	RJMP _0x4C
;     518 	}
;     519 	
;     520 	return 1;
_0xF:
	LDI  R30,LOW(1)
_0x4C:
	CALL __LOADLOCR4
	ADIW R28,12
	POP  R15
	RET
;     521 }
;     522 
;     523 // Перезагрузка в рабочий режим
;     524 void RebootToWork(void)
;     525 {
_RebootToWork:
;     526 	// Проверяю, есть ли куда грузиться
;     527 	if (!AppOk())
	CALL _AppOk
	CPI  R30,0
	BRNE _0x10
;     528 	{
;     529 		return;
	RET
;     530 	}
;     531 
;     532 	#asm("cli");
_0x10:
	cli
;     533 	IVCREG = 1 << IVCE;
	LDI  R30,LOW(1)
	OUT  0x35,R30
;     534 	IVCREG = 0;
	LDI  R30,LOW(0)
	OUT  0x35,R30
;     535 
;     536 	#asm("wdr");
	wdr
;     537 	
;     538 	#if (defined _CHIP_ATMEGA128_) || (defined _CHIP_ATMEGA128L_)
;     539 		#asm("jmp 0");
	jmp 0
;     540 	#elif (defined _CHIP_ATMEGA162_) || (defined _CHIP_ATMEGA162L_)
;     541 		#asm("jmp 0");
;     542 	#else
;     543 		#asm("rjmp 0");
;     544 	#endif
;     545 }
	RET
;     546 
;     547 // Реакция на команду перейти в рабочий режим
;     548 void ToWorkMode(void)
;     549 {
_ToWorkMode:
;     550 	// Проверяю завершение пакета
;     551 	if (!PackOk())
	RCALL _PackOk
	CPI  R30,0
	BRNE _0x11
;     552 	{
;     553 		return;
	RET
;     554 	}
;     555 	
;     556 	// Отправляю ответ
;     557 	ReplyStart(0);
_0x11:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _ReplyStart
;     558 	ReplyEnd();
	RCALL _ReplyEnd
;     559 
;     560 	prgmode = 0;
	CLT
	BLD  R2,0
;     561 	  
;     562 	// На перезагрузку
;     563 	RebootToWork();
	CALL _RebootToWork
;     564 }
	RET
;     565 
;     566 void main(void)
;     567 {
_main:
;     568 	// Это был сброс по вотчдогу?
;     569 	if (MCUCSR & (1 << WDRF))
	IN   R30,0x34
	SBRS R30,3
	RJMP _0x12
;     570 	{
;     571 		MCUCSR &= (1 << WDRF) ^ 0xFF;
	IN   R30,0x34
	ANDI R30,0XF7
	OUT  0x34,R30
;     572 	
;     573 		// Если вылетел по вотчдогу - пытаюсь перегрузиться в рабочий режим	
;     574 		RebootToWork();
	CALL _RebootToWork
;     575 	}
;     576 	
;     577 	// Настраиваю "железо"
;     578 	HardwareInit();
_0x12:
	RCALL _HardwareInit
;     579 
;     580 	// Ожидание, прием и исполнение команд
;     581 	while (1)
_0x13:
;     582 	{
;     583 		switch(Wait4Hdr())
	RCALL _Wait4Hdr
;     584 		{
;     585 		case PT_PRGINFO:	// Вернуть информацию о мониторе и процессоре  
	CPI  R30,LOW(0x8)
	BRNE _0x19
;     586 			PrgInfo();
	CALL _PrgInfo
;     587 			break;
	RJMP _0x18
;     588 		case PT_WRFLASH:	// Записать страницу FLASH
_0x19:
	CPI  R30,LOW(0x9)
	BRNE _0x1A
;     589 //putchar2('2');
;     590 			WriteFlash();
	CALL _WriteFlash
;     591 			break;
	RJMP _0x18
;     592 		case PT_WREEPROM:	// Записать байт в EEPROM
_0x1A:
	CPI  R30,LOW(0xA)
	BRNE _0x1B
;     593 			WriteEeprom();
	CALL _WriteEeprom
;     594 			break;
	RJMP _0x18
;     595 		case PT_TOWORK:		// Вернуться в режим работы
_0x1B:
	CPI  R30,LOW(0xB)
	BRNE _0x1D
;     596 			ToWorkMode();			
	CALL _ToWorkMode
;     597 			break;
;     598 		default:
_0x1D:
;     599 			break;
;     600 		}
_0x18:
;     601 	}
	RJMP _0x13
;     602 }
_0x1E:
	RJMP _0x1E
;     603 /////////////////////////////////////////////////////////////////////////////////////////////
;     604 // Что касается "железа" I2CxCOM
;     605 #include "monitor.h"
;     606                                     
;     607 #define LedRed() {DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 0, PORTA.1 = 1;}
;     608 #define LedGreen() {DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 1, PORTA.1 = 0;}
;     609 #define LedOff() {DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 1, PORTA.1 = 1;}
;     610 
;     611 #define BAUD 38400		// Скорость обмена по COM-порту
;     612 const unsigned int scrambling_seed = 333;
;     613 
;     614 void HardwareInit(void)
;     615 {
_HardwareInit:
;     616 	// Настраиваю UART
;     617 //	UCSR0A = 0x00;
;     618 	UCSR0B = 0x10; //0x18; //приемник вкл.
	LDI  R30,LOW(16)
	OUT  0xA,R30
;     619 	UCSR0C = 0x06;
	LDI  R30,LOW(6)
	STS  149,R30
;     620 	UBRR0L = ((_MCU_CLOCK_FREQUENCY_ / (16 * BAUD)) - 1) & 0xFF;
	LDI  R30,LOW(12)
	OUT  0x9,R30
;     621 	UBRR0H = (((_MCU_CLOCK_FREQUENCY_ / (16 * BAUD)) - 1) >> 8) & 0xFF;
	LDI  R30,LOW(0)
	STS  144,R30
;     622 
;     623 	// Запрещаю компаратор
;     624 //	ACSR=0x80;
;     625 //	SFIOR=0x00;
;     626 
;     627 	// Вотчдог
;     628 	WDTCR=0x1F;
	LDI  R30,LOW(31)
	OUT  0x21,R30
;     629 	WDTCR=0x0F;
	LDI  R30,LOW(15)
	OUT  0x21,R30
;     630 }
	RET
;     631 
;     632 #define USR  UCSR0A
;     633 #define UDRE (1 << 5)
;     634 #define UDR  UDR0
;     635 #define RXC  (1 << 7)
;     636 
;     637 // Передача байта в канал
;     638 inline void XmitChar(unsigned char byt)
;     639 {
_XmitChar:
;     640 	while(!(USR & UDRE));
_0x1F:
	SBIS 0xB,5
	RJMP _0x1F
;     641 	UDR = byt;
	LD   R30,Y
	OUT  0xC,R30
;     642 }
	RJMP _0x4B
;     643 
;     644 // Наличие принятого байта
;     645 unsigned char HaveRxChar(void)
;     646 {
_HaveRxChar:
;     647 	return USR & RXC;
	IN   R30,0xB
	ANDI R30,LOW(0x80)
	RET
;     648 }
;     649 
;     650 // Прием байта из канала
;     651 inline unsigned char ReceiveChar(void)
;     652 {
_ReceiveChar:
;     653 	while(!HaveRxChar());
_0x22:
	CALL _HaveRxChar
	CPI  R30,0
	BREQ _0x22
;     654 	return UDR;
	IN   R30,0xC
	RET
;     655 }
;     656 // Обмен пакетами с хостом
;     657 #include "monitor.h"      
;     658 
;     659 #define LedRed() {DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 0, PORTA.1 = 1;}
;     660 #define LedGreen() {DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 1, PORTA.1 = 0;}
;     661 #define LedOff() {DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 1, PORTA.1 = 1;}
;     662 
;     663 unsigned char pcrc;	// Контрольная сумма
;     664 unsigned char plen;	// Длина пакета

	.DSEG
_plen:
	.BYTE 0x1
;     665 unsigned char nbyts;	// Число принятых или переданых байт
_nbyts:
	.BYTE 0x1
;     666 bit prgmode  = 0;		// Находимся в режиме программирования
;     667 
;     668 #define BAUD 38400
;     669 #define DTXDDR 	DDRC.0		// вывод программного UART   (35pin, на стороне - 16)
;     670 #define DTXPIN	PORTC.0		// вывод программного UART
;     671 
;     672 
;     673 // Прием байта из канала
;     674 unsigned char GetByte(void)
;     675 {

	.CSEG
_GetByte:
;     676 	register unsigned char ret;
;     677 	
;     678 	ret = ReceiveChar();
	ST   -Y,R16
;	ret -> R16
	CALL _ReceiveChar
	MOV  R16,R30
;     679 	
;     680 	pcrc += ret;
	ADD  R4,R16
;     681 	nbyts ++;
	CALL SUBOPT_0x4
;     682 
;     683 	if (descramble)		// Если нужно дешифровать - дешифрую
	SBRS R2,1
	RJMP _0x25
;     684 	{
;     685 		ret ^= NextSeqByte();
	CALL _NextSeqByte
	EOR  R16,R30
;     686 	}	
;     687 	return ret;
_0x25:
	MOV  R30,R16
	LD   R16,Y+
	RET
;     688 }
;     689 
;     690 // Прием слова из канала
;     691 unsigned short GetWord(void)
;     692 {
_GetWord:
;     693 	register unsigned short ret;
;     694 	
;     695 	ret = GetByte();
	ST   -Y,R17
	ST   -Y,R16
;	ret -> R16,R17
	CALL _GetByte
	MOV  R16,R30
	CLR  R17
;     696 	ret |= ((unsigned short)GetByte()) << 8;
	CALL _GetByte
	MOV  R31,R30
	LDI  R30,0
	__ORWRR 16,17,30,31
;     697 	
;     698 	return ret;
	MOVW R30,R16
	LD   R16,Y+
	LD   R17,Y+
	RET
;     699 }
;     700 
;     701 // Передача байта в канал
;     702 void PutByte(unsigned char byt)
;     703 {
_PutByte:
;     704 	pcrc += byt;
	LD   R30,Y
	ADD  R4,R30
;     705 	nbyts ++;
	CALL SUBOPT_0x4
;     706 	
;     707 	XmitChar(byt);
	LD   R30,Y
	ST   -Y,R30
	CALL _XmitChar
;     708 }
_0x4B:
	ADIW R28,1
	RET
;     709 
;     710 // Передача слова в канал
;     711 void PutWord(unsigned short w)
;     712 {
_PutWord:
;     713 	PutByte(w & 0xFF);
	LD   R30,Y
	LDD  R31,Y+1
	ANDI R31,HIGH(0xFF)
	ST   -Y,R30
	CALL _PutByte
;     714 	PutByte(w >> 8);
	LDD  R30,Y+1
	ANDI R31,HIGH(0x0)
	ST   -Y,R30
	CALL _PutByte
;     715 }
	ADIW R28,2
	RET
;     716 
;     717 // Ожидание заголовка пакета
;     718 unsigned char Wait4Hdr(void)
;     719 {
_Wait4Hdr:
;     720 	#asm("wdr");		// Перед приемом очередного пакет	а перезапускаю вотчдог
	wdr
;     721 		
;     722 	while(1)
_0x26:
;     723 	{
;     724 		if (prgmode)	// Если меня уже спрашивали, то след. пакет можно ждать долго
	SBRS R2,0
	RJMP _0x29
;     725 		{
;     726 			while(!HaveRxChar())
_0x2A:
	CALL _HaveRxChar
	CPI  R30,0
	BREQ PC+3
	JMP _0x2C
;     727 			{
;     728 				#asm("wdr");
	wdr
;     729 			}
	JMP  _0x2A
_0x2C:
;     730 		}
;     731 		
;     732 		pcrc = 0;
_0x29:
	CLR  R4
;     733 		
;     734 		if (GetByte() != PACKHDR)	// Жду заголовок
	CALL _GetByte
	CPI  R30,LOW(0x71)
	BREQ _0x2D
;     735 		{
;     736 			continue;
	JMP  _0x26
;     737 		}
;     738 		
;     739 		plen = GetByte();		 	// Длина пакета
_0x2D:
	CALL _GetByte
	STS  _plen,R30
;     740 		
;     741 		nbyts = 0;
	LDI  R30,LOW(0)
	STS  _nbyts,R30
;     742 
;     743 
;     744 		if (GetByte() != TO_MON)	// Сличаю адрес
	CALL _GetByte
	CPI  R30,LOW(0xFE)
	BREQ _0x2E
;     745 		{
;     746 			continue;
	JMP  _0x26
;     747 		}
;     748 		return GetByte();			// Возвращаю тип пакета
_0x2E:
	CALL _GetByte
	RET
;     749 	}
	JMP  _0x26
;     750 }
;     751 
;     752 // Контроль успешного завершения приема пакета
;     753 unsigned char PackOk(void)
;     754 {
_PackOk:
;     755 	register unsigned char crc;
;     756 
;     757 /*
;     758 	// Сверяю контрольную сумму	
;     759 	crc = pcrc;
;     760 	if (GetByte() != crc)
;     761 	{
;     762 		return 0;
;     763 	}
;     764 
;     765 	// Сверяю длину пакета	
;     766 	if (nbyts != plen)
;     767 	{
;     768 		return 0;
;     769 	}
;     770 	
;     771 	return 1;*/
;     772 
;     773 	// Сверяю контрольную сумму	
;     774 	crc = pcrc;
	ST   -Y,R16
;	crc -> R16
	MOV  R16,R4
;     775 	if (GetByte() == crc)
	CALL _GetByte
	CP   R16,R30
	BRNE _0x2F
;     776 	{
;     777 		if (nbyts == plen)
	LDS  R30,_plen
	LDS  R26,_nbyts
	CP   R30,R26
	BRNE _0x30
;     778 		{                       
;     779 			return 1;
	LDI  R30,LOW(1)
	RJMP _0x4A
;     780 		}
;     781 			
;     782 	}
_0x30:
;     783 	return 0;
_0x2F:
	LDI  R30,LOW(0)
_0x4A:
	LD   R16,Y+
	RET
;     784 
;     785 }
;     786 
;     787 // Начало передачи ответного пакета
;     788 void ReplyStart(unsigned char bytes)
;     789 {
_ReplyStart:
;     790 	plen = bytes + 1;
	LD   R30,Y
	SUBI R30,-LOW(1)
	STS  _plen,R30
;     791 	pcrc = 0;
	CLR  R4
;     792 	
;     793 	ReplyXmitterEnable();	// Разрешаю передатчик
	SBI  0xA,3
;     794 
;     795 	PutByte(plen);
	ST   -Y,R30
	CALL _PutByte
;     796 }
	ADIW R28,1
	RET
;     797 
;     798 // Завершение передачи ответного пакета
;     799 void ReplyEnd(void)
;     800 {
_ReplyEnd:
;     801 	PutByte(pcrc);
	ST   -Y,R4
	CALL _PutByte
;     802 	ReplyXmitterDisable();	// Запрещаю передатчик
	CBI  0xA,3
;     803 }
	RET
;     804 
;     805 //--------------------------------------------------------------------------------------------
;     806 // "программный" UART
;     807 void dtxdl(void)
;     808 {
;     809 	int i;
;     810 	for (i = 0; i < 15; i ++)
;	i -> R16,R17
;     811 	{
;     812 		#asm("nop")
;     813 	}
;     814 }
;     815 
;     816 void putchar2(char c)
;     817 {
;     818 	register unsigned char b;
;     819 	
;     820 	#asm("cli")
;	c -> Y+1
;	b -> R16
;     821 	
;     822 	DTXDDR = 1;
;     823 	DTXPIN = 0;
;     824 	dtxdl();
;     825 	
;     826 	for (b = 0; b < 8; b ++)
;     827 	{
;     828 		if (c & 1)
;     829 		{
;     830 			DTXPIN = 1;
;     831 		}
;     832 		else
;     833 		{
;     834 			DTXPIN = 0;
;     835 		}
;     836              
;     837 		c >>= 1;
;     838 		dtxdl();
;     839 	}
;     840 
;     841 	DTXPIN = 1;
;     842 	dtxdl();
;     843 	dtxdl();
;     844 	
;     845 	#asm("sei")
;     846 }
;     847 
;     848 //--------------------------------------------------------------------------------------
;     849 // Функции для работы с FLASH
;     850 
;     851 #include "monitor.h"
;     852 
;     853 #if (defined _CHIP_ATMEGA128L_) || (defined _CHIP_ATMEGA128_)
;     854 	#asm
;     855 		.equ	SPMCSR = 0x68
		.equ	SPMCSR = 0x68
;     856 		.equ	SPMREG = SPMCSR
		.equ	SPMREG = SPMCSR
;     857 	#endasm
;     858 #elif (defined _CHIP_ATMEGA8_) || (defined _CHIP_ATMEGA8L_) || (defined _CHIP_ATMEGA8515_) || (defined _CHIP_ATMEGA8515L_) || (defined _CHIP_ATMEGA162_) || (defined _CHIP_ATMEGA162L_)
;     859 	#asm
;     860 		.equ	SPMCR  = 0x37
;     861 		.equ	SPMREG = SPMCR
;     862 	#endasm
;     863 #else
;     864 	#error Поддержка для этого процессора еще не написана
;     865 #endif
;     866 
;     867 #asm
;     868 	.equ	SPMEN  = 0	; Биты регистра
	.equ	SPMEN  = 0	; Биты регистра
;     869 	.equ	PGERS  = 1
	.equ	PGERS  = 1
;     870 	.equ	PGWRT  = 2
	.equ	PGWRT  = 2
;     871 	.equ	BLBSET = 3
	.equ	BLBSET = 3
;     872 	.equ	RWWSRE = 4
	.equ	RWWSRE = 4
;     873 	.equ	RWWSB  = 6
	.equ	RWWSB  = 6
;     874 	.equ	SPMIE  = 7
	.equ	SPMIE  = 7
;     875 	;--------------------------------------------------
	;--------------------------------------------------
;     876 	; Ожидание завершения SPM. Портит R23
	; Ожидание завершения SPM. Портит R23
;     877 	spmWait:
	spmWait:
;     878 #endasm
;     879 #ifdef USE_MEM_SPM
;     880 	#asm
;     881 		lds		r23, SPMREG
		lds		r23, SPMREG
;     882 	#endasm
;     883 #else
;     884 	#asm
;     885 		in		r23, SPMREG
;     886 	#endasm
;     887 #endif
;     888 #asm
;     889 		andi	r23, (1 << SPMEN)
		andi	r23, (1 << SPMEN)
;     890 		brne	spmWait	
		brne	spmWait	
;     891 		ret
		ret
;     892 	;--------------------------------------------------
	;--------------------------------------------------
;     893 	; Запуск SPM.
	; Запуск SPM.
;     894 	spmSPM:
	spmSPM:
;     895 		in		r24, SREG	; Сохраняю состояние
		in		r24, SREG	; Сохраняю состояние
;     896 		cli					; Запрещаю прерывания
		cli					; Запрещаю прерывания
;     897 #endasm
;     898 #ifdef USE_RAMPZ
;     899 	#asm
;     900 		in		r25, RAMPZ	; Сохраняю RAMPZ
		in		r25, RAMPZ	; Сохраняю RAMPZ
;     901 	#endasm
;     902 #endif
;     903 #asm
;     904 		ld		r30, y		; Адрес
		ld		r30, y		; Адрес
;     905 		ldd		r31, y+1
		ldd		r31, y+1
;     906 #endasm
;     907 #ifdef USE_RAMPZ
;     908 	#asm
;     909 		ldd		r26, y+2	; 3-й байт адреса - в RAMPZ
		ldd		r26, y+2	; 3-й байт адреса - в RAMPZ
;     910 		out		RAMPZ, r26
		out		RAMPZ, r26
;     911 	#endasm
;     912 #endif
;     913 #asm
;     914 		rcall	spmWait		; Жду завершения предидущей операции (на всякий случай)
		rcall	spmWait		; Жду завершения предидущей операции (на всякий случай)
;     915 #endasm
;     916 #ifdef USE_MEM_SPM
;     917 	#asm
;     918 		sts SPMREG, r22		; Регистр команд, как память
		sts SPMREG, r22		; Регистр команд, как память
;     919 	#endasm
;     920 #else
;     921 	#asm
;     922 		out SPMREG, r22		; Регистр команд, как порт
;     923 	#endasm
;     924 #endif
;     925 #asm
;     926 		spm					; Запуск на выполнение
		spm					; Запуск на выполнение
;     927 		nop
		nop
;     928 		nop
		nop
;     929 		nop
		nop
;     930 		nop
		nop
;     931 		rcall	spmWait		; Жду завершения
		rcall	spmWait		; Жду завершения
;     932 #endasm
;     933 #ifdef USE_RAMPZ
;     934 	#asm
;     935 		out		RAMPZ, r25	; Восстанавливаю состояние
		out		RAMPZ, r25	; Восстанавливаю состояние
;     936 	#endasm
;     937 #endif
;     938 #asm
;     939 		out		SREG, r24
		out		SREG, r24
;     940 		ret
		ret
;     941 #endasm
;     942 
;     943 #pragma warn-
;     944 void ResetTempBuffer (FADDRTYPE addr)
;     945 {
_ResetTempBuffer:
;     946 	#asm
;     947 		ldi		r22, (1 << RWWSRE) | (1 << SPMEN)
		ldi		r22, (1 << RWWSRE) | (1 << SPMEN)
;     948 		rcall	spmSPM
		rcall	spmSPM
;     949 	#endasm
;     950 }
	ADIW R28,4
	RET
;     951 
;     952 void FillTempBuffer (unsigned short data, FADDRTYPE addr)
;     953 {
_FillTempBuffer:
;     954 	#ifdef USE_RAMPZ
;     955 		#asm
;     956 			ldd		r0, y+4			; Данные
			ldd		r0, y+4			; Данные
;     957 			ldd		r1,	y+5
			ldd		r1,	y+5
;     958 		#endasm
;     959 	#else
;     960 		#asm
;     961 			ldd		r0, y+2			; Данные
;     962 			ldd		r1,	y+3
;     963 		#endasm
;     964 	#endif
;     965 	#asm
;     966 		ldi		r22, (1 << SPMEN)	; Команда
		ldi		r22, (1 << SPMEN)	; Команда
;     967 		rcall	spmSPM				; На выполнение
		rcall	spmSPM				; На выполнение
;     968 	#endasm
;     969 }
	ADIW R28,6
	RET
;     970 
;     971 void PageErase (FADDRTYPE  addr)
;     972 {
_PageErase:
;     973 	#asm
;     974 		ldi		r22, (1 << PGERS) | (1 << SPMEN)
		ldi		r22, (1 << PGERS) | (1 << SPMEN)
;     975 		rcall	spmSPM
		rcall	spmSPM
;     976 	#endasm
;     977 }
	ADIW R28,4
	RET
;     978 
;     979 void PageWrite (FADDRTYPE addr)
;     980 {
_PageWrite:
;     981 	#asm
;     982 		ldi		r22, (1 << PGWRT) | (1 << SPMEN)
		ldi		r22, (1 << PGWRT) | (1 << SPMEN)
;     983 		rcall	spmSPM
		rcall	spmSPM
;     984 	#endasm
;     985 }
	ADIW R28,4
	RET
;     986 #pragma warn+
;     987 
;     988 // Запись страницы FLASH
;     989 void WriteFlash(void)
;     990 {
_WriteFlash:
;     991 	FADDRTYPE faddr;
;     992 	
;     993 	// Далее - дешифровать
;     994 	DescrambleStart();
	SBIW R28,4
;	faddr -> Y+0
	SET
	BLD  R2,1
;     995 	
;     996 	// Получаю номер страницы
;     997 	#asm ("wdr");
	wdr
;     998 	faddr = GetWord();
	CALL _GetWord
	CLR  R22
	CLR  R23
	__PUTD1S 0
;     999 	
;    1000 	if (faddr >= PRGPAGES)
	__GETD2S 0
	__CPD2N 0x1F8
	BRLO _0x39
;    1001 	{
;    1002 		while(1);	// Если неправильный номер страницы - непоправимая ошибка и вылет по вотчдогу
_0x3A:
	RJMP _0x3A
;    1003 	}	
;    1004 
;    1005 	// Получаю адрес начала страницы
;    1006 	faddr <<= (ZPAGEMSB + 1);
_0x39:
	__GETD2S 0
	LDI  R30,LOW(8)
	CALL __LSLD12
	__PUTD1S 0
;    1007 	
;    1008 	// Загрузка данных в промежуточный буфер
;    1009 	#asm ("wdr");
	wdr
;    1010 	ResetTempBuffer(faddr);
	__GETD1S 0
	CALL __PUTPARD1
	CALL _ResetTempBuffer
;    1011 	do {
_0x3E:
;    1012 		#asm ("wdr");
	wdr
;    1013 		FillTempBuffer(GetWord(), faddr);
	RCALL SUBOPT_0x5
;    1014 		faddr += 2;
;    1015 	#if PAGESIZ < 255
;    1016 		// Если страница целиком помещается в пакет - просто жду завершения страницы
;    1017 		} while (faddr & (PAGESIZ-1));	
;    1018 	#else
;    1019 		// Если страница большая - она расфасовывается в 2 пакета
;    1020 		} while (nbyts < (plen-1));		// До завершения приема первого пакета
	RCALL SUBOPT_0x6
	BRSH PC+3
	JMP _0x3E
;    1021 		DescrambleStop();
	CLT
	BLD  R2,1
;    1022 	
;    1023 		// Проверяю завершение пакета
;    1024 		if (!PackOk())
	CALL _PackOk
	CPI  R30,0
	BRNE _0x40
;    1025 		{
;    1026 			ReplyStart(1);
	RCALL SUBOPT_0x1
;    1027 			PutByte(RES_ERR);
;    1028 			ReplyEnd();
;    1029 			return;
	ADIW R28,4
	RET
;    1030 		}
;    1031 		
;    1032 		// Сигналю, что все в порядке и можно посылать следующий
;    1033 		#asm ("wdr");
_0x40:
	wdr
;    1034 		ReplyStart(1);
	RCALL SUBOPT_0x2
;    1035 		PutByte(RES_OK);
;    1036 		ReplyEnd();
;    1037 		
;    1038 		// Жду второй пакет с остатком страницы
;    1039 		while(Wait4Hdr() != PT_WRFLASH);
_0x41:
	CALL _Wait4Hdr
	CPI  R30,LOW(0x9)
	BRNE _0x41
;    1040 		DescrambleStart();
	SET
	BLD  R2,1
;    1041 		do {
_0x45:
;    1042 			#asm ("wdr");
	wdr
;    1043 			FillTempBuffer(GetWord(), faddr);
	RCALL SUBOPT_0x5
;    1044 			faddr += 2;
;    1045 		} while (nbyts < (plen-1));		// До завершения приема второго пакета
	RCALL SUBOPT_0x6
	BRSH PC+3
	JMP _0x45
;    1046 	#endif
;    1047 		DescrambleStop();
	CLT
	BLD  R2,1
;    1048 	
;    1049 	// Проверяю завершение пакета
;    1050 	if (!PackOk())
	CALL _PackOk
	CPI  R30,0
	BRNE _0x47
;    1051 	{
;    1052 		ReplyStart(1);
	RCALL SUBOPT_0x1
;    1053 		PutByte(RES_ERR);
;    1054 		ReplyEnd();
;    1055 		return;
	ADIW R28,4
	RET
;    1056 	}
;    1057 	
;    1058 	// Восстанавливаю адрес начала страницы
;    1059 	faddr -= PAGESIZ;
_0x47:
	__GETD1S 0
	__SUBD1N 256
	__PUTD1S 0
;    1060 
;    1061 	// Стираю страницу
;    1062 	#asm ("wdr");
	wdr
;    1063 	PageErase(faddr);
	__GETD1S 0
	CALL __PUTPARD1
	CALL _PageErase
;    1064 	
;    1065 	// Записываю страницу
;    1066 	#asm ("wdr");
	wdr
;    1067 	PageWrite(faddr);
	__GETD1S 0
	CALL __PUTPARD1
	CALL _PageWrite
;    1068 
;    1069 	// Сигналю, что все в порядке и можно посылать следующий
;    1070 	#asm ("wdr");
	wdr
;    1071 	ReplyStart(1);
	RCALL SUBOPT_0x2
;    1072 	PutByte(RES_OK);
;    1073 	ReplyEnd();
;    1074 }
	ADIW R28,4
	RET
;    1075 ///////////////////////////////////////////////////////////////////////////////////////////
;    1076 // Дешифрование программирующих данных
;    1077 
;    1078 unsigned long int next_rand = 1;

	.DSEG
_next_rand:
	.BYTE 0x4
;    1079 unsigned char rand_cnt = 31;
;    1080 
;    1081 // Генератор псевдослучайной последовательности.
;    1082 // За основу взяты IAR-овские исходники
;    1083 
;    1084 bit descramble = 0;					// Признак необходимости дешифрования
;    1085 
;    1086 unsigned char NextSeqByte(void)	// Очередной байт дешифрующей последовательности
;    1087 {

	.CSEG
_NextSeqByte:
;    1088 	next_rand = next_rand * 1103515245 + 12345;
	LDS  R26,_next_rand
	LDS  R27,_next_rand+1
	LDS  R24,_next_rand+2
	LDS  R25,_next_rand+3
	__GETD1N 0x41C64E6D
	CALL __MULD12U
	__ADDD1N 12345
	STS  _next_rand,R30
	STS  _next_rand+1,R31
	STS  _next_rand+2,R22
	STS  _next_rand+3,R23
;    1089 	next_rand >>= 8;
	LDS  R26,_next_rand
	LDS  R27,_next_rand+1
	LDS  R24,_next_rand+2
	LDS  R25,_next_rand+3
	LDI  R30,LOW(8)
	CALL __LSRD12
	STS  _next_rand,R30
	STS  _next_rand+1,R31
	STS  _next_rand+2,R22
	STS  _next_rand+3,R23
;    1090 	
;    1091 	rand_cnt += 101;
	LDI  R30,LOW(101)
	ADD  R5,R30
;    1092 		
;    1093 	return rand_cnt ^ (unsigned char)next_rand;
	LDS  R30,_next_rand
	EOR  R30,R5
	RET
;    1094 }
;    1095 
;    1096 void ResetDescrambling(void)		// Перезапуск генератора дешифрующей последовательности
;    1097 {
_ResetDescrambling:
;    1098 	next_rand = scrambling_seed;
	LDI  R30,LOW(_scrambling_seed*2)
	LDI  R31,HIGH(_scrambling_seed*2)
	CALL __GETW1PF
	CLR  R22
	CLR  R23
	STS  _next_rand,R30
	STS  _next_rand+1,R31
	STS  _next_rand+2,R22
	STS  _next_rand+3,R23
;    1099 	rand_cnt = 31;
	LDI  R30,LOW(31)
	MOV  R5,R30
;    1100 	descramble = 0;
	CLT
	BLD  R2,1
;    1101 }
	RET


;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x0:
	LDI  R30,LOW(256)
	LDI  R31,HIGH(256)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _PutWord

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x1:
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _ReplyStart
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _PutByte
	JMP  _ReplyEnd

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x2:
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _ReplyStart
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _PutByte
	JMP  _ReplyEnd

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3:
	CALL __PUTPARD1
	CALL _FlashByte
	CLR  R31
	CLR  R22
	CLR  R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4:
	LDS  R30,_nbyts
	SUBI R30,-LOW(1)
	STS  _nbyts,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5:
	CALL _GetWord
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 2
	CALL __PUTPARD1
	CALL _FillTempBuffer
	__GETD1S 0
	__ADDD1N 2
	__PUTD1S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6:
	LDS  R30,_plen
	SUBI R30,LOW(1)
	LDS  R26,_nbyts
	CP   R26,R30
	RET

__ORD12:
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
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
	ELPM R0,Z+
	ELPM R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
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

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
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
