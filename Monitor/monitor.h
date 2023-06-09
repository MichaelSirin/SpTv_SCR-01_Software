#ifndef _MONITOR_H_
#define _MONITOR_H_

// � ����������� �� �����������
#if defined __CODEVISIONAVR__
// � ����������� �� ���� ����������
#if (defined _CHIP_ATMEGA128_) || (defined _CHIP_ATMEGA128L_)
	#include <mega128.h>

	#define ZPAGEMSB	7				// ����� �������� ���� ������ ������ ��������
	#define FLASHSIZ	(128*1024)		// ������ FLASH � ������
	#define EEPROMSIZ	4096			// ������ EEPROM � ������

    #define IVCREG MCUCR
	#define IVCE   0
	#define IVSEL  1
	
	#define WDRF   3
	
	#define FADDRTYPE unsigned long	// ��� ���������� ��� ��������� ����� FLASH
	#define USE_RAMPZ
	#define USE_MEM_SPM

	#define ReplyXmitterEnable()  UCSR0B.3=1	// �������� ����������
	#define ReplyXmitterDisable() UCSR0B.3=0	// �������� ����������

#elif (defined _CHIP_ATMEGA8_) || (defined _CHIP_ATMEGA8L_)
	#include <mega8.h>

	#define ZPAGEMSB	5				// ����� �������� ���� ������ ������ ��������
	#define FLASHSIZ	8192			// ������ FLASH � ������
	#define EEPROMSIZ	512				// ������ EEPROM � ������

    #define IVCREG GICR
	#define IVCE   0
	#define IVSEL  1
	
	#define WDRF   3

	#define FADDRTYPE unsigned short		// ��� ���������� ��� ��������� ����� FLASH
//	#define USE_RAMPZ
//	#define USE_MEM_SPM

	#define ReplyXmitterEnable()  UCSRB.3=1	// �������� ����������
	#define ReplyXmitterDisable() UCSRB.3=0	// �������� ����������

#elif (defined _CHIP_ATMEGA8515_) || (defined _CHIP_ATMEGA8515L_)
	#include <mega8515.h>

	#define ZPAGEMSB	5					// ����� �������� ���� ������ ������ ��������
	#define FLASHSIZ	8192				// ������ FLASH � ������
	#define EEPROMSIZ	512					// ������ EEPROM � ������

    #define IVCREG GICR
	#define IVCE   0
	#define IVSEL  1
	
	#define WDRF   3

	#define FADDRTYPE unsigned short		// ��� ���������� ��� ��������� ����� FLASH
//	#define USE_RAMPZ
//	#define USE_MEM_SPM

	#define ReplyXmitterEnable()  UCSRB.3=1	// �������� ����������
	#define ReplyXmitterDisable() UCSRB.3=0	// �������� ����������

#elif (defined _CHIP_ATMEGA162_) || (defined _CHIP_ATMEGA162L_)
	#include <mega162.h>

	#define ZPAGEMSB	6					// ����� �������� ���� ������ ������ ��������
	#define FLASHSIZ	16384				// ������ FLASH � ������
	#define EEPROMSIZ	512					// ������ EEPROM � ������

    #define IVCREG GICR
	#define IVCE   0
	#define IVSEL  1
	
	#define WDRF   3

	#define FADDRTYPE unsigned short		// ��� ���������� ��� ��������� ����� FLASH
//	#define USE_RAMPZ
//	#define USE_MEM_SPM

	#define ReplyXmitterEnable()  UCSR0B.3=1	// �������� ����������
	#define ReplyXmitterDisable() UCSR0B.3=0	// �������� ����������
	
	#define UCSRA UCSR0A
	#define UCSRB UCSR0B
	#define UCSRC UCSR0C
	#define UBRRL UBRR0L
	#define UBRRH UBRR0H
	#define UDR UDR0
#else
	#error ��������� ��� ����� ���������� ��� �� ��������
#endif

#define PAGESIZ (1 << (ZPAGEMSB+1))	// ������ �������� FLASH � ������

#ifndef MONSIZ
	#error ���������� ������ ������ �������� � ������ � Project->Configure->C Compiler->Globally define
#endif
#endif //__CODEVISIONAVR__

#define PAGES (FLASHSIZ/PAGESIZ)	// ����� ����� ������� FLASH
#define MONPAGES (MONSIZ/PAGESIZ)	// ����� ������� FLASH, ������� ���������
#define PRGPAGES (PAGES - MONPAGES)	// ����� ������� FLASH, ��������� ��� ����������������

// ������ � ���� ������ ����� � ������
#include <comm.h>

#define MONITORVERSION 0x0100

// ��������� ������� � ����������
void WriteFlash(void);
unsigned char PackOk(void);
void ReplyStart(unsigned char bytes);
void PutWord(unsigned short w);
unsigned short GetWord(void);
void ReplyEnd(void);
extern bit prgmode;
unsigned char GetByte(void);
void PutByte(unsigned char byt);
unsigned char Wait4Hdr(void);
extern unsigned char nbyts;
extern unsigned char plen;
void HardwareInit(void);
//void XmitChar(unsigned char byt);
//unsigned char ReceiveChar(void);
//unsigned char HaveRxChar(void);
extern bit descramble;
#define DescrambleStart() {descramble=1;}
#define DescrambleStop() {descramble=0;}
unsigned char NextSeqByte(void);
void ResetDescrambling(void);
extern const unsigned int scrambling_seed;    
void putchar2(char c);

#if (defined DEBUG_LED)
	void Dlc(void);
#endif

#endif // _MONITOR_H_
