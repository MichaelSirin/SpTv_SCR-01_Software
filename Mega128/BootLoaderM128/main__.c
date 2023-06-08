/*////////////////////////////////////////////////////////////////////////////////////////////////////////
// ������� - ��������� FLASH � EEPROM. �������� �� TWI
////////////////////////////////////////////////////////////////////////////////////////////////////////
#include "monitor.h" 
#include "CodingM8.h"      
#include "stdio.h"  
#include "string.h"  


eeprom unsigned char device_name[32] =					// ��� ����������
		"BOOT PROGRAM. Mega 128 ";
//eeprom unsigned long my_ser_num = 1;					// �������� ����� ����������
#define  my_ser_num  1					// �������� ����� ����������

const flash unsigned short my_version_high = 1;				// ������ ����� 
const flash unsigned short my_version_low = 1;				// ������ ����� 

eeprom unsigned char my_addr = TO_MON;					// ��� ����� - ���������� TO_MON
    

const   unsigned int scrambling_seed = 333;

//unsigned char pAddr;				// ����� ���������� �� ���� TWI
//unsigned char adr;									// ����� � ��������� ������
unsigned char rxPack;							// ������ ����� TWI

// ��� ��� ������ � TWI
TWISR TWI_statusReg;   
unsigned char 	TWI_slaveAddress = MY_TWI_ADDRESS;		// Own TWI slave address


bit		TWI_TX_Packet_Present				=		0;					// ���� ������ �� ��������
bit		toReboot										=		0;					// ������������� � ������� ���������
bit		toProgramming								=		0;					// ��� �������������
	
unsigned char txBufferTWI 			[TWI_Buffer_TX];		// ���������� �����
unsigned char rxBufferTWI	[TWI_BUFFER_SIZE];	// �������� �����


// ������� ���������� � �������� � ����������
void PrgInfo(void)
{
	// ��������� �����
//	#asm("wdr");
	txBufferTWI[Start_Position_for_Reply] = (sizeof(RP_PRGINFO) +1);

	txBufferTWI[Start_Position_for_Reply+1] = (PAGESIZ);     			//��.
	txBufferTWI[Start_Position_for_Reply+2] = (PAGESIZ>>8);          //��.

	txBufferTWI[Start_Position_for_Reply+3] = (PRGPAGES);
	txBufferTWI[Start_Position_for_Reply+4] = (PRGPAGES>>8);

	txBufferTWI[Start_Position_for_Reply+5] = (EEPROMSIZ);
	txBufferTWI[Start_Position_for_Reply+6] = (EEPROMSIZ>>8);

	txBufferTWI[Start_Position_for_Reply+7] = (MONITORVERSION);
	txBufferTWI[Start_Position_for_Reply+8] = (MONITORVERSION>>8);
	
	txBufferTWI[Start_Position_for_Reply+9] = calc_CRC( &txBufferTWI[Start_Position_for_Reply] );

	// ������� � ����� ���������������� - ������ ���� ����� ����� ��������� �����
	prgmode = 1;
	
	// ������� ��������� ����������� ������������������
	ResetDescrambling();
}


// ����� ����� �� �������
unsigned short GetWordBuff(unsigned char a)
{
	register unsigned short ret;  

	// ��������������
	ret = ( rxBufferTWI	[a++] ^ NextSeqByte() );
	ret |= ((unsigned short)rxBufferTWI[a] ^ NextSeqByte() ) << 8;

	return ret;
} 



// ������ � EEPROM
void WriteEeprom(void)
{
	register unsigned short addr;
	register unsigned char  data;

	// ����� ������ � ������	
	#asm ("wdr");

	addr = GetWordBuff(5);
	data = ( rxBufferTWI	[7] ^ NextSeqByte() );


	// �������� ���������� � ������������ ������
	if (addr < EEPROMSIZ)
	{
		// ���� � EEPROM
		*((char eeprom *)addr) = data;

		// ��������, ���������� ��
		if (*((char eeprom *)addr) == data)
		{
			// �������, ��� ��� � ������� 
			txBufferTWI[Start_Position_for_Reply] = 2;        				// �����
			txBufferTWI[Start_Position_for_Reply+1] = RES_OK;				//  OK
			txBufferTWI[Start_Position_for_Reply+2] = 2 + RES_OK;		//  CRC

			return;
		}
	}
     
	// ������
	txBufferTWI[Start_Position_for_Reply] = 2;        				// �����
	txBufferTWI[Start_Position_for_Reply+1] = RES_ERR;			//  ������
	txBufferTWI[Start_Position_for_Reply+2] = 2 + RES_ERR;		//  CRC

} 

// ������ ����� �� FLASH �� ������
#ifdef USE_RAMPZ
	#pragma warn-
	unsigned char FlashByte(FADDRTYPE addr)
	{
	#asm
		ld		r30, y		; �������� Z
		ldd		r31, y+1
		
		in		r23, rampz	; �������� RAMPZ
		
		ldd		r22, y+2	; �������� RAMPZ
		out		rampz, r22
		
		elpm	r24, z		; ����� FLASH
		
		out		rampz, r23	; �������������� RAMPZ

		mov		r30, r24	; ������������ ��������
	#endasm
	}	
	#pragma warn+
#else
	#define FlashByte(a) (*((flash unsigned char *)a))
#endif

// �������� ������� "�������" ���������
unsigned char AppOk(void)
{
	FADDRTYPE addr, lastaddr;
	unsigned short crc, fcrc;
	
	//WD ���� �� �������	
//	#asm("wdr");
	
	lastaddr = ( (FADDRTYPE)FlashByte(PRGPAGES*PAGESIZ - 4) | 
	            ((FADDRTYPE)FlashByte(PRGPAGES*PAGESIZ - 3) << 8))
	            << (ZPAGEMSB + 1);
	            

	if (lastaddr == (0xFFFF << (ZPAGEMSB + 1)))
	{
	        return 0;
	}
	
	for (addr = 0, crc = 0; addr != lastaddr; addr ++)
	{
		crc += FlashByte(addr);
	}

	fcrc = 	 (unsigned short)FlashByte(PRGPAGES*PAGESIZ - 2) | 
			((unsigned short)FlashByte(PRGPAGES*PAGESIZ - 1) << 8);
	
	if (crc != fcrc)
	{
		return 0;
	}
	
	return 1;
}

// ������������ � ������� �����
void RebootToWork(void)
{
	// ��������, ���� �� ���� ���������
	if (!AppOk())
	{
		return;
	}

	#asm("cli");
	IVCREG = 1 << IVCE;
	IVCREG = 0;

	#asm("rjmp 0");      //Mega128 - JMP, Mega8 - RJMP
}

// ������� �� ������� ������� � ������� �����
void ToWorkMode(void)
{

	// ��������� �����
	txBufferTWI[0] = 0;        						// ����������� �����
//	dannForTX = 1;								// ���� ������

	prgmode = 0;
	  
	// �� ������������
	toReboot =1;
//	RebootToWork();
}

//-----------------------------------------------------------------------------------------------------------------

// ��������� ��������� ����������
const char _PT_GETSTATE_[]={19,2,0,"BOOT PROGRAM  ",100,255};

static void GetState(void)
{
	register unsigned char a=Start_Position_for_Reply;

	switch (PT_GETSTATE_page)
	{
		case 0:
			memcpyf(&txBufferTWI[2], _PT_GETSTATE_, _PT_GETSTATE_[0]+1); // 0 �����
			a+=19;
			break;

		case 1:			
			txBufferTWI[a++] = 5;				 			// ����� ������

			txBufferTWI[a++] = 0;							// � ����������
			txBufferTWI[a++] = MY_TWI_ADDRESS;
			txBufferTWI[a++] = 0;

			txBufferTWI[a++] = 255;
			break;

		default:
			txBufferTWI[a++] = 0;				 			// ����� ������
			break;
	} 

	txBufferTWI[a] = calc_CRC( &txBufferTWI[Start_Position_for_Reply] );
} 

// ���������� �� ����������:

static void GetInfo(void)
{
		register unsigned char i,a=Start_Position_for_Reply;                    
	
		// 	�������� �����
		txBufferTWI[a++] = 40+1;
	
		for ( i = 0; i <32; i ++ )	
				txBufferTWI[a++] = device_name[i];	// ��� ����������

		txBufferTWI[a++] = my_ser_num;        		// �������� �����
		txBufferTWI[a++] = my_ser_num>>8;    	  	// �������� �����

		txBufferTWI[a++] = my_ser_num>>16;		// �������� �����
		txBufferTWI[a++] = my_ser_num>>24;		// �������� �����
	
		txBufferTWI[a++] =MY_TWI_ADDRESS ; 	// ����� ����������
        txBufferTWI[a++] =0;     							// ����������������� ����
	
		txBufferTWI[a++] = my_version_high;        	// ������ �����
		txBufferTWI[a++] = my_version_low;			// ������  �����
		
		txBufferTWI[a] = calc_CRC( &txBufferTWI[Start_Position_for_Reply] );

}


void main(void)
{
	// ���������� "������"
	 Initialization_Device(); 

	// Global enable interrupts
	#asm("sei")

	// ��������, ����� � ���������� ������
	while (1)
	{

	// ���������� ������� ��������� �� ������� (�������� 2�)
	if ( TIFR & (1 << TOV1) )
	{
		TIFR |= (1<<TOV1);
		TCNT1=0xD2F6;		//�������� 2���

		// ������� ������������� � ������� �����	
		RebootToWork();
	}

//		#asm("wdr");
		run_TWI_slave();
		
		// ������������ �������� ����� TWI
		if ( rxPack )
		{
			// ��������� ���������� �������
			if ( ( Recived_Address == Internal_Packet ) || ( Recived_Address == Global_Packet ) )		
			{
				switch ( Type_RX_Packet_TWI )
				{
					// ���������� � ���� ����������
					case PT_GETINFO:			
//							GetInfo();
							break;                                     

					// ���������� ���������						
					case PT_GETSTATE:			
//							GetState();
							break;                      

					// ������� � ����������������
					case PT_TOPROG:
							toProgramming = 1;				// ���� ������ ����������������
							// ��������� �����
							txBufferTWI[0] = 1;				 	// ����� ������
							txBufferTWI[1] = 1;				 	// ��

							break;      

					// ������� ���������� � �������� � ����������
					case PT_PRGINFO:	
							PrgInfo();
							break;

					// �������� �������� FLASH							
					case PT_WRFLASH:	

//							TCNT1=0xD2F6;		//�������� 2���

//							toProgramming = 1;				// ���� ������ ����������������
							WriteFlash();
							break;

					// �������� ���� � EEPROM
					case PT_WREEPROM:	

//							TCNT1=0xD2F6;		//�������� 2���

							WriteEeprom();
							break;
			

					default:
//							toProgramming = 0;		// ������������� �� ���
				}
				// ���������� �����
				packPacket (External_Packet);	// ���� ��� �������
				// ������������������ ������
				TCNT1=0xD2F6;		//�������� 2���
	         }
		
		rxPack = 0;							// ����� ���������
        }          
	}
}*/


////////////////////////////////////////////////////////////////////////////////////////////
// ������� - ��������� FLASH � EEPROM
////////////////////////////////////////////////////////////////////////////////////////////
#include "monitor.h"


// ������� ���������� � �������� � ����������
void PrgInfo(void)
{
	// �������� ���������� ������
	if (!PackOk())
	{
		return;
	}
	
	// ��������� �����
	#asm("wdr");
	ReplyStart(sizeof(RP_PRGINFO));
	PutWord(PAGESIZ);
	PutWord(PRGPAGES);
	PutWord(EEPROMSIZ);
	PutWord(MONITORVERSION);
	ReplyEnd();

	// ������� � ����� ���������������� - ������ ���� ����� ����� ��������� �����
	prgmode = 1;
	
	// ������� ��������� ����������� ������������������
	ResetDescrambling();
}

// ������ � EEPROM
void WriteEeprom(void)
{
	register unsigned short addr;
	register unsigned char  data;

	DescrambleStart();

	// ����� ������ � ������	
	#asm ("wdr");
	addr = GetWord();
	data = GetByte();
	
	DescrambleStop();

	// �������� ���������� � ������������ ������
	if (!PackOk() || (addr >= EEPROMSIZ))
	{
		ReplyStart(1);
		PutByte(RES_ERR);
		ReplyEnd();
		return;
	}
	
	// ���� � EEPROM
	*((char eeprom *)addr) = data;
	
	// ��������, ���������� ��
	if (*((char eeprom *)addr) != data)
	{
		ReplyStart(1);
		PutByte(RES_ERR);
		ReplyEnd();
		return;
	}

	// �������, ��� ��� � ������� 
	ReplyStart(1);
	PutByte(RES_OK);
	ReplyEnd();
}

// ������ ����� �� FLASH �� ������
#ifdef USE_RAMPZ
	#pragma warn-
	unsigned char FlashByte(FADDRTYPE addr)
	{
	#asm
		ld		r30, y		; �������� Z
		ldd		r31, y+1
		in		r23, rampz	; �������� RAMPZ
		ldd		r22, y+2	; �������� RAMPZ
		out		rampz, r22
		elpm	r24, z		; ����� FLASH
		out		rampz, r23	; �������������� RAMPZ
		mov		r30, r24	; ������������ ��������
	#endasm
	}	
	#pragma warn+
#else
	#define FlashByte(a) (*((flash unsigned char *)a))
#endif

// �������� ������� "�������" ���������
unsigned char AppOk(void)
{
	FADDRTYPE addr, lastaddr;
	unsigned short crc, fcrc;
	bit ha_flag = 0;
	
	#asm("wdr");

	// �������� ����� ������������ ��������
	lastaddr = ( (FADDRTYPE)FlashByte(PRGPAGES*PAGESIZ - 4) | 
	            ((FADDRTYPE)FlashByte(PRGPAGES*PAGESIZ - 3) << 8));

	// ���� FLASH ������	            
	if (lastaddr == 0xFFFF)
	{
		return 0;
	}

	// ������������� ��������� ��������� ��� ���������������� ��������	
	if (lastaddr >= PRGPAGES)
	{
		ha_flag = 1;
	}

	// ������� ����� ������������ �������� �� ������ ������� � ������	
	lastaddr = lastaddr << (ZPAGEMSB + 1);

	// ���� ������������� ��������� ��������
	// �������� ����� � ����������� ����� �� �������� ����������� �����
	if (ha_flag)
	{
		lastaddr -= 4;
	}
	
	// ����������� ������� ����������� �����
	for (addr = 0, crc = 0; addr < lastaddr; addr ++)
	{
		crc += FlashByte(addr);
	}

	// ���� ������������� ��������� �������� �������� ����� �����
	// � ����������� ����� ������ ������
	if (ha_flag)
	{
		crc += 255;
		crc += 255;
		crc += 255;
		crc += 255;
	}

	// �������� ������� ����������� �����	
	fcrc = 	 (unsigned short)FlashByte(PRGPAGES*PAGESIZ - 2) | 
			((unsigned short)FlashByte(PRGPAGES*PAGESIZ - 1) << 8);
	
	if (crc != fcrc)
	{
		return 0;
	}
	
	return 1;
}

// ������������ � ������� �����
void RebootToWork(void)
{
	// ��������, ���� �� ���� ���������
	if (!AppOk())
	{
		return;
	}

	#asm("cli");
	IVCREG = 1 << IVCE;
	IVCREG = 0;

	#asm("wdr");
	
	#if (defined _CHIP_ATMEGA128_) || (defined _CHIP_ATMEGA128L_)
		#asm("jmp 0");
	#elif (defined _CHIP_ATMEGA162_) || (defined _CHIP_ATMEGA162L_)
		#asm("jmp 0");
	#else
		#asm("rjmp 0");
	#endif
}

// ������� �� ������� ������� � ������� �����
void ToWorkMode(void)
{
	// �������� ���������� ������
	if (!PackOk())
	{
		return;
	}
	
	// ��������� �����
	ReplyStart(0);
	ReplyEnd();

	prgmode = 0;
	  
	// �� ������������
	RebootToWork();
}

void main(void)
{
	// ��� ��� ����� �� ��������?
	if (MCUCSR & (1 << WDRF))
	{
		MCUCSR &= (1 << WDRF) ^ 0xFF;
	
		// ���� ������� �� �������� - ������� ������������� � ������� �����	
		RebootToWork();
	}
	
	// ���������� "������"
	HardwareInit();

	// ��������, ����� � ���������� ������
	while (1)
	{
		switch(Wait4Hdr())
		{
		case PT_PRGINFO:	// ������� ���������� � �������� � ����������  
			PrgInfo();
			break;
		case PT_WRFLASH:	// �������� �������� FLASH
//putchar2('2');
			WriteFlash();
			break;
		case PT_WREEPROM:	// �������� ���� � EEPROM
			WriteEeprom();
			break;
		case PT_TOWORK:		// ��������� � ����� ������
			ToWorkMode();			
			break;
		default:
			break;
		}
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////
// ��� �������� "������" I2CxCOM
#include "monitor.h"
                                    
#define LedRed() {DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 0, PORTA.1 = 1;}
#define LedGreen() {DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 1, PORTA.1 = 0;}
#define LedOff() {DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 1, PORTA.1 = 1;}

#define BAUD 38400		// �������� ������ �� COM-�����
const unsigned int scrambling_seed = 333;

void HardwareInit(void)
{
	// ���������� UART
//	UCSR0A = 0x00;
	UCSR0B = 0x10; //0x18; //�������� ���.
	UCSR0C = 0x06;
	UBRR0L = ((_MCU_CLOCK_FREQUENCY_ / (16 * BAUD)) - 1) & 0xFF;
	UBRR0H = (((_MCU_CLOCK_FREQUENCY_ / (16 * BAUD)) - 1) >> 8) & 0xFF;

	// �������� ����������
//	ACSR=0x80;
//	SFIOR=0x00;

	// �������
	WDTCR=0x1F;
	WDTCR=0x0F;
}

#define USR  UCSR0A
#define UDRE (1 << 5)
#define UDR  UDR0
#define RXC  (1 << 7)

// �������� ����� � �����
inline void XmitChar(unsigned char byt)
{
	while(!(USR & UDRE));
	UDR = byt;
}

// ������� ��������� �����
unsigned char HaveRxChar(void)
{
	return USR & RXC;
}

// ����� ����� �� ������
inline unsigned char ReceiveChar(void)
{
	while(!HaveRxChar());
	return UDR;
}
// ����� �������� � ������
#include "monitor.h"      

#define LedRed() {DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 0, PORTA.1 = 1;}
#define LedGreen() {DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 1, PORTA.1 = 0;}
#define LedOff() {DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 1, PORTA.1 = 1;}

unsigned char pcrc;	// ����������� �����
unsigned char plen;	// ����� ������
unsigned char nbyts;	// ����� �������� ��� ��������� ����
bit prgmode  = 0;		// ��������� � ������ ����������������

#define BAUD 38400
#define DTXDDR 	DDRC.0		// ����� ������������ UART   (35pin, �� ������� - 16)
#define DTXPIN	PORTC.0		// ����� ������������ UART


// ����� ����� �� ������
unsigned char GetByte(void)
{
	register unsigned char ret;
	
	ret = ReceiveChar();
	
	pcrc += ret;
	nbyts ++;

	if (descramble)		// ���� ����� ����������� - ��������
	{
		ret ^= NextSeqByte();
	}	
	return ret;
}

// ����� ����� �� ������
unsigned short GetWord(void)
{
	register unsigned short ret;
	
	ret = GetByte();
	ret |= ((unsigned short)GetByte()) << 8;
	
	return ret;
}

// �������� ����� � �����
void PutByte(unsigned char byt)
{
	pcrc += byt;
	nbyts ++;
	
	XmitChar(byt);
}

// �������� ����� � �����
void PutWord(unsigned short w)
{
	PutByte(w & 0xFF);
	PutByte(w >> 8);
}

// �������� ��������� ������
unsigned char Wait4Hdr(void)
{
	#asm("wdr");		// ����� ������� ���������� �����	� ������������ �������
		
	while(1)
	{
		if (prgmode)	// ���� ���� ��� ����������, �� ����. ����� ����� ����� �����
		{
			while(!HaveRxChar())
			{
				#asm("wdr");
			}
		}
		
		pcrc = 0;
		
		if (GetByte() != PACKHDR)	// ��� ���������
		{
			continue;
		}
		
		plen = GetByte();		 	// ����� ������
		
		nbyts = 0;


		if (GetByte() != TO_MON)	// ������ �����
		{
			continue;
		}
		return GetByte();			// ��������� ��� ������
	}
}

// �������� ��������� ���������� ������ ������
unsigned char PackOk(void)
{
	register unsigned char crc;

/*
	// ������ ����������� �����	
	crc = pcrc;
	if (GetByte() != crc)
	{
		return 0;
	}

	// ������ ����� ������	
	if (nbyts != plen)
	{
		return 0;
	}
	
	return 1;*/

	// ������ ����������� �����	
	crc = pcrc;
	if (GetByte() == crc)
	{
		if (nbyts == plen)
		{                       
			return 1;
		}
			
	}
	return 0;

}

// ������ �������� ��������� ������
void ReplyStart(unsigned char bytes)
{
	plen = bytes + 1;
	pcrc = 0;
	
	ReplyXmitterEnable();	// �������� ����������

	PutByte(plen);
}

// ���������� �������� ��������� ������
void ReplyEnd(void)
{
	PutByte(pcrc);
	ReplyXmitterDisable();	// �������� ����������
}

//--------------------------------------------------------------------------------------------
// "�����������" UART
void dtxdl(void)
{
	int i;
	for (i = 0; i < 15; i ++)
	{
		#asm("nop")
	}
}

void putchar2(char c)
{
	register unsigned char b;
	
	#asm("cli")
	
	DTXDDR = 1;
	DTXPIN = 0;
	dtxdl();
	
	for (b = 0; b < 8; b ++)
	{
		if (c & 1)
		{
			DTXPIN = 1;
		}
		else
		{
			DTXPIN = 0;
		}
             
		c >>= 1;
		dtxdl();
	}

	DTXPIN = 1;
	dtxdl();
	dtxdl();
	
	#asm("sei")
}

//--------------------------------------------------------------------------------------
// ������� ��� ������ � FLASH

#include "monitor.h"

#if (defined _CHIP_ATMEGA128L_) || (defined _CHIP_ATMEGA128_)
	#asm
		.equ	SPMCSR = 0x68
		.equ	SPMREG = SPMCSR
	#endasm
#elif (defined _CHIP_ATMEGA8_) || (defined _CHIP_ATMEGA8L_) || (defined _CHIP_ATMEGA8515_) || (defined _CHIP_ATMEGA8515L_) || (defined _CHIP_ATMEGA162_) || (defined _CHIP_ATMEGA162L_)
	#asm
		.equ	SPMCR  = 0x37
		.equ	SPMREG = SPMCR
	#endasm
#else
	#error ��������� ��� ����� ���������� ��� �� ��������
#endif

#asm
	.equ	SPMEN  = 0	; ���� ��������
	.equ	PGERS  = 1
	.equ	PGWRT  = 2
	.equ	BLBSET = 3
	.equ	RWWSRE = 4
	.equ	RWWSB  = 6
	.equ	SPMIE  = 7
	;--------------------------------------------------
	; �������� ���������� SPM. ������ R23
	spmWait:
#endasm
#ifdef USE_MEM_SPM
	#asm
		lds		r23, SPMREG
	#endasm
#else
	#asm
		in		r23, SPMREG
	#endasm
#endif
#asm
		andi	r23, (1 << SPMEN)
		brne	spmWait	
		ret
	;--------------------------------------------------
	; ������ SPM.
	spmSPM:
		in		r24, SREG	; �������� ���������
		cli					; �������� ����������
#endasm
#ifdef USE_RAMPZ
	#asm
		in		r25, RAMPZ	; �������� RAMPZ
	#endasm
#endif
#asm
		ld		r30, y		; �����
		ldd		r31, y+1
#endasm
#ifdef USE_RAMPZ
	#asm
		ldd		r26, y+2	; 3-� ���� ������ - � RAMPZ
		out		RAMPZ, r26
	#endasm
#endif
#asm
		rcall	spmWait		; ��� ���������� ���������� �������� (�� ������ ������)
#endasm
#ifdef USE_MEM_SPM
	#asm
		sts SPMREG, r22		; ������� ������, ��� ������
	#endasm
#else
	#asm
		out SPMREG, r22		; ������� ������, ��� ����
	#endasm
#endif
#asm
		spm					; ������ �� ����������
		nop
		nop
		nop
		nop
		rcall	spmWait		; ��� ����������
#endasm
#ifdef USE_RAMPZ
	#asm
		out		RAMPZ, r25	; �������������� ���������
	#endasm
#endif
#asm
		out		SREG, r24
		ret
#endasm

#pragma warn-
void ResetTempBuffer (FADDRTYPE addr)
{
	#asm
		ldi		r22, (1 << RWWSRE) | (1 << SPMEN)
		rcall	spmSPM
	#endasm
}

void FillTempBuffer (unsigned short data, FADDRTYPE addr)
{
	#ifdef USE_RAMPZ
		#asm
			ldd		r0, y+4			; ������
			ldd		r1,	y+5
		#endasm
	#else
		#asm
			ldd		r0, y+2			; ������
			ldd		r1,	y+3
		#endasm
	#endif
	#asm
		ldi		r22, (1 << SPMEN)	; �������
		rcall	spmSPM				; �� ����������
	#endasm
}

void PageErase (FADDRTYPE  addr)
{
	#asm
		ldi		r22, (1 << PGERS) | (1 << SPMEN)
		rcall	spmSPM
	#endasm
}

void PageWrite (FADDRTYPE addr)
{
	#asm
		ldi		r22, (1 << PGWRT) | (1 << SPMEN)
		rcall	spmSPM
	#endasm
}
#pragma warn+

// ������ �������� FLASH
void WriteFlash(void)
{
	FADDRTYPE faddr;
	
	// ����� - �����������
	DescrambleStart();
	
	// ������� ����� ��������
	#asm ("wdr");
	faddr = GetWord();
	
	if (faddr >= PRGPAGES)
	{
		while(1);	// ���� ������������ ����� �������� - ������������ ������ � ����� �� ��������
	}	

	// ������� ����� ������ ��������
	faddr <<= (ZPAGEMSB + 1);
	
	// �������� ������ � ������������� �����
	#asm ("wdr");
	ResetTempBuffer(faddr);
	do {
		#asm ("wdr");
		FillTempBuffer(GetWord(), faddr);
		faddr += 2;
	#if PAGESIZ < 255
		// ���� �������� ������� ���������� � ����� - ������ ��� ���������� ��������
		} while (faddr & (PAGESIZ-1));	
	#else
		// ���� �������� ������� - ��� ��������������� � 2 ������
		} while (nbyts < (plen-1));		// �� ���������� ������ ������� ������
		DescrambleStop();
	
		// �������� ���������� ������
		if (!PackOk())
		{
			ReplyStart(1);
			PutByte(RES_ERR);
			ReplyEnd();
			return;
		}
		
		// �������, ��� ��� � ������� � ����� �������� ���������
		#asm ("wdr");
		ReplyStart(1);
		PutByte(RES_OK);
		ReplyEnd();
		
		// ��� ������ ����� � �������� ��������
		while(Wait4Hdr() != PT_WRFLASH);
		DescrambleStart();
		do {
			#asm ("wdr");
			FillTempBuffer(GetWord(), faddr);
			faddr += 2;
		} while (nbyts < (plen-1));		// �� ���������� ������ ������� ������
	#endif
		DescrambleStop();
	
	// �������� ���������� ������
	if (!PackOk())
	{
		ReplyStart(1);
		PutByte(RES_ERR);
		ReplyEnd();
		return;
	}
	
	// �������������� ����� ������ ��������
	faddr -= PAGESIZ;

	// ������ ��������
	#asm ("wdr");
	PageErase(faddr);
	
	// ��������� ��������
	#asm ("wdr");
	PageWrite(faddr);

	// �������, ��� ��� � ������� � ����� �������� ���������
	#asm ("wdr");
	ReplyStart(1);
	PutByte(RES_OK);
	ReplyEnd();
}
///////////////////////////////////////////////////////////////////////////////////////////
// ������������ ��������������� ������

unsigned long int next_rand = 1;
unsigned char rand_cnt = 31;

// ��������� ��������������� ������������������.
// �� ������ ����� IAR-������ ���������

bit descramble = 0;					// ������� ������������� ������������

unsigned char NextSeqByte(void)	// ��������� ���� ����������� ������������������
{
	next_rand = next_rand * 1103515245 + 12345;
	next_rand >>= 8;
	
	rand_cnt += 101;
		
	return rand_cnt ^ (unsigned char)next_rand;
}

void ResetDescrambling(void)		// ���������� ���������� ����������� ������������������
{
	next_rand = scrambling_seed;
	rand_cnt = 31;
	descramble = 0;
}
