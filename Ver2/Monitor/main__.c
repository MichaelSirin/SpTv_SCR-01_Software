////////////////////////////////////////////////////////////////////////////////////////////
// ������� - ��������� FLASH � EEPROM
////////////////////////////////////////////////////////////////////////////////////////////
#include "monitor.h" 
#include "CodingM8.h"      
#include "stdio.h"  
#include "string.h"  

flash unsigned char device_name[32] =					// ��� ����������
		"Boot Program. Port";
eeprom unsigned long my_ser_num = 1;					// �������� ����� ����������
const flash unsigned short my_version = 1;			// ������ ����� 
eeprom unsigned char my_addr = TO_MON;					// ��� ����� - ���������� TO_MON
    

unsigned char pAddr;				// ����� ���������� �� ���� TWI
unsigned char adr;									// ����� � ��������� ������
unsigned char typePack;							// ��� ��������� ������


//bit 		ping		 			=		0;					// ������� ��� ������ ������ ����	
bit	dannForTX			=		0;					// ���� ������ �� ��������
bit	toReboot				=		0;					// ������������� � ������� ���������
	
unsigned char txBuffer[128];								// ���������� ������
unsigned char rxBuffer[128];								// �������� ������


// ������� ���������� � �������� � ����������
void PrgInfo(void)
{
	// ��������� �����
	#asm("wdr");
	txBuffer[0] = (sizeof(RP_PRGINFO));

	#asm("wdr");
	txBuffer[1] = (PAGESIZ);     			//��.
	txBuffer[2] = (PAGESIZ>>8);          //��.

	#asm("wdr");
	txBuffer[3] = (PRGPAGES);
	txBuffer[4] = (PRGPAGES>>8);

	#asm("wdr");
	txBuffer[5] = (EEPROMSIZ);
	txBuffer[6] = (EEPROMSIZ>>8);

	#asm("wdr");
	txBuffer[7] = (MONITORVERSION);
	txBuffer[8] = (MONITORVERSION>>8);

	#asm("wdr");
	dannForTX = 1;								// ���� ������	

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

	// ����� ������ � ������	
	#asm ("wdr");
	addr = GetWordBuff(0);
	
	// �������� ���������� � ������������ ������
	if (addr >= EEPROMSIZ)
	{
			txBuffer[0] = 1;        				// �����
			txBuffer[1] = RES_ERR;			//  ������
			dannForTX = 1;						// ���� ������	

		return;
	}
	
	// ���� � EEPROM
	*((char eeprom *)addr) = data;
	
	// ��������, ���������� ��
	if (*((char eeprom *)addr) != data)
	{
			txBuffer[0] = 1;        				// �����
			txBuffer[1] = RES_ERR;			//  ������
			dannForTX = 1;						// ���� ������	
		return;
	}

	// �������, ��� ��� � ������� 
	#asm ("wdr");                                                        
			txBuffer[0] = 1;        				// �����
			txBuffer[1] = RES_OK;			
			dannForTX = 1;						// ���� ������	
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
	
	#asm("wdr");
	
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
	
	#asm("wdr");
	
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

//	#asm("wdr");
	#asm("rjmp 0");      //Mega128 - JMP, Mega8 - RJMP
}

// ������� �� ������� ������� � ������� �����
void ToWorkMode(void)
{

	// ��������� �����
	txBuffer[0] = 0;        						// ����������� �����
//	dannForTX = 1;								// ���� ������

	prgmode = 0;
	  
	// �� ������������
	toReboot =1;
//	RebootToWork();
}

//-----------------------------------------------------------------------------------------------------------------

// ���������� �� ����������
static void GetInfo(void)
{
	register unsigned char i;
	
	// 	�������� �����
	txBuffer[0] = 40;
	
	for (i = 0; i < 32; i ++)	// ��� ����������
	{
		txBuffer[i+1] = device_name[i];
	}

		txBuffer[33] = my_ser_num;           // �������� �����
		txBuffer[34] = my_ser_num>>8;      // �������� �����

		txBuffer[35] = 0;	// �������� �����
		txBuffer[36] = 0;	// �������� �����
	
		txBuffer[37] =pAddr ;     // ����� ����������

		txBuffer[38] =0;     // ����������������� ����
	
		txBuffer[39] = my_version;             // ������
		txBuffer[40] = my_version>>8;		// ������
	
		dannForTX = 1;								// ���� ������	

}

//-----------------------------------------------------------------------------------------------------------------

// ��������� ��������� ����������
const char _PT_GETSTATE_[]={19,0,0,'a','a','a','a','a','a','a','a','a','a','a','a','a','a',' ',100,255};
static void GetState(void)
{
		memcpyf(txBuffer, _PT_GETSTATE_, _PT_GETSTATE_[0]+1);
		dannForTX = 1;								// ���� ������	
} 


void main(void)
{
	// ���������� "������"
	HardwareInit(); 

	// ��� ��� ����� �� ��������?
	if (MCUCSR & (1 << WDRF))
	{
		MCUCSR &= (1 << WDRF) ^ 0xFF;
	
		// ���� ������� �� �������� - ������� ������������� � ������� �����	
		RebootToWork();
	}
	
	// ��������, ����� � ���������� ������
	while (1)
	{
		Wait4Hdr();						// ���� �����
        if ((adr == pAddr)||(adr == TO_MON )) 	            // ������ ��� ������� ���������
        	{
				switch(typePack)
					{

						case PT_PRGINFO:	// ������� ���������� � �������� � ����������
							PrgInfo();
							txBuff();
							break;

						case PT_WRFLASH:	// �������� �������� FLASH
							WriteFlash();
							txBuff();
							break;

						case PT_WREEPROM:	// �������� ���� � EEPROM
							WriteEeprom();
							txBuff();
						break;

						case PT_TOWORK:		// ��������� � ����� ������
							ToWorkMode();			
							txBuff();                         // �������� �
							RebootToWork();			// �� ������������
							break;    

						case PT_TOPROG:
							txBuffer[0] = 0;        				// �� ������ � ���������������
							txBuff();
							break;      

						case PT_GETINFO:
							GetInfo();
							txBuff();
							break;

						case PT_GETSTATE:
							GetState();
							txBuff();
							break;
						
						default:
							break;
					}

        	}
        else         if (adr==0)											//  ������� ��� �����. ������ 0
        	{
				switch(typePack)
					{
						case GetLogAddr:     						// ��������. ��������� ������ �� ��������
								txBuffer[0] = 1;				 		// ����� ������
								txBuffer[1] = 0;				 		// ���. �����
								txBuff ();                           		// ��������
								break;

/*						case pingPack :
								if (dannForTX) txBuff();
								else 	twi_byte(0);				  			// ����� ������
								break;*/
						default:
								break;
					}
        	
			}
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////
// ��� �������� "������" Coding Device (Mega8)
#include "monitor.h"
#include "CodingM8.h"        


const   unsigned int scrambling_seed = 333;

void HardwareInit(void)
{
	// ��������� �������
	PORTC=0x07;
	DDRC=0x00;

    // USART initialization
    // Communication Parameters: 8 Data, 1 Stop, No Parity
    // USART Receiver: On
    // USART Transmitter: On
    // USART Mode: Asynchronous
    // USART Baud rate: 38400
    UCSRA=0x00;
    UCSRB=0x18;
    UCSRC=0x86;
    UBRRH=0x00;
    UBRRL=0x0C;



	// �������� ����������
	ACSR=0x80;
	SFIOR=0x00;

    //��������� TWI
    twi_init();             

	// �������
	WDTCR=0x1F;
	WDTCR=0x0F;  

}

#define USR  TWSR                   //������ ����� 
#define UDRE (1 << 5)
#define UDR  TWDR                   //������� � ������������/������������� �������
#define RXC  (1 << 7)
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 
// ����� � ������� �����. Slave RECIVER.

#include <CodingM8.h>
#include <stdio.h>
#include "monitor.h"



// ���� TWCR
#define TWINT 7
#define TWEA  6
#define TWSTA 5
#define TWSTO 4
#define TWWC  3
#define TWEN  2
#define TWIE  0

// ���������
#define START		0x08
#define	REP_START	0x10

// ���� ������� TWI...
//Master TRANSMITTER
#define	MTX_ADR_ACK		0x18
#define	MRX_ADR_ACK	0x40
#define	MTX_DATA_ACK	0x28
#define	MRX_DATA_NACK	0x58
#define	MRX_DATA_ACK	0x50

//Slave RECIVER
#define	SRX_ADR_ACK		0x60    //������ ADR (�����������)
#define	SRX_GADR_ACK	0x70    //������ ����� ADR (�����������)
#define	SRX_DATA_ACK	0x80    //������ DANN (�����������)
#define	SRX_GDATA_ACK	0x90    //������ ����� DANN (�����������)

//Slave Transmitter
#define	STX_ADR_ACK		0xA8    //������ ADR (����������� ����������)


	// ���������� TWI - ����������� � ���. Addr
    // Bit Rate: 400,000 kHz
    // General Call Recognition: On
void twi_init (void)
{
	// ������� ����������� ����������� ������ ����� � ������
	// �� ��������� ���� (0���) �������� ����������
	pAddr = ((PINC & 0x7)+1 );			// ���������� ���������� ����� (0-�� ���. �.�. ����. �����)

    TWSR=0x00;
    TWBR=0x02;
    TWAR=(pAddr<<1)+1;                        // ������������� ��� ��� TWI
    TWCR=0x45;                          

}


// ��� ������ ��������� ������� ��������
static void twi_wait_int (void)
{
	while (!(TWCR & (1<<TWINT))); 
}

/* �������� ��������� � ������� ����������...
// ���������� �� 0, ���� ���� ���������
unsigned char rx_addr (void)
{
	twi_wait_int();        
    if ((TWSR == SRX_ADR_ACK) || (TWSR == SRX_GADR_ACK))
    {
    return 0;                   //�������� �����/���.�����...
    }        
    return 255;
} */


// ����� ����� �� ������ TWI
inline unsigned char ReceiveChar(void)
{
    while (1)
    {
        twi_wait_int();         //���� ���� - ������

        if ((TWSR == SRX_DATA_ACK)||(TWSR == SRX_GDATA_ACK)) 
            {
        	return TWDR;
            }
        if (TWSR == STX_ADR_ACK)				// ����� ��������� ���
        	{
//				if (dannForTX) txBuff();
//				else
				 TWDR = 0;
        	}

      TWCR = ((1<<TWINT)+(1<<TWEA)+(1<<TWEN));    //��������� ���
    }
//        twi_wait_int();         //���� ���� - ������

}

// ����� ����� �� ������
unsigned char GetByte(void)
{
	register unsigned char ret;
	ret = ReceiveChar();

	TWCR = ((1<<TWINT)+(1<<TWEA)+(1<<TWEN));    //��������� ���

	pcrc += ret;
	nbyts ++;

	if (descramble)		// ���� ����� ����������� - ��������
	{
		ret ^= NextSeqByte();
	}	
	return ret;
}

// �������� ����� ������
// ���������� �� 0, ���� ��� � �������
unsigned char twi_byte (unsigned char data)
{
	twi_wait_int();

	TWDR = data;
    TWCR = ((1<<TWINT)+(1<<TWEA)+(1<<TWEN));    //��������� ���
// 	TWCR = ((1<<TWINT)+(1<<TWEN));

	twi_wait_int();

	if(TWSR != MTX_DATA_ACK)
	{
		return 0;
	}
		
	return 255;
}



// �������� ��������� ������
unsigned char Wait4Hdr(void)
{
    unsigned char a,b;

	#asm("wdr");		// ����� ������� ���������� ������ ������������ �������
		
	while(1)
	{
//putchar (0xaa);
		if (prgmode)	// ���� ���� ��� ����������, �� ����. ����� ����� ����� �����
		{
			while (!(TWCR & (1<<TWINT))) 

//			while(!twi_wait_int())   							//���� ��������� ��������...
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
		
        adr = GetByte();																	

       	 typePack= GetByte();      // ��������� ��� ������
           
if  ((typePack == PT_WRFLASH)||(typePack ==PT_WREEPROM))				// ���� ����� ��� ���� ��
			{			
			 	DescrambleStart();					// ��������������
//				 print = 1;      	 
             }
             
		for (a=0; a<plen-3;a++)
			{
				b=GetByte();
				rxBuffer [a] = b;				// ��������� ������ �������
//if (print) putchar (b);
			}      

			DescrambleStop();

		if (PackOk())	return typePack;			// ������� ��
		else 	return 0;

	}                             
}





/*
// ��������� �����/������
// ���������� �� 0, ���� ��� � �������
unsigned char twi_addr (unsigned char addr)
{
	twi_wait_int();

	TWDR = addr;
	TWCR = ((1<<TWINT)+(1<<TWEN));

	twi_wait_int();

	if((TWSR != MTX_ADR_ACK)&&(TWSR != MRX_ADR_ACK))
	{
		return 0;
	}
	return 255;
} */
// ����� �������� � ������
#include "monitor.h"   
#include "CodingM8.h"

        
   

unsigned char pcrc;	// ����������� �����
unsigned char plen;	// ����� ������
unsigned char nbyts;	// ����� �������� ��� ��������� ����
bit prgmode  = 0;		// ��������� � ������ ����������������


// ����� ����� �� �������
unsigned short GetWordBuff(unsigned char a)
{
	register unsigned short ret;  

	ret = 	rxBuffer	[a++];
	ret |= ((unsigned short)rxBuffer[a]) << 8;
	
	return ret;
} 

/*// �������� ����� � ���\��
void PutByte(unsigned char byt)
{
	pcrc += byt;
	nbyts ++;
	
	twi_byte(byt);
} */

// �������� ��������� ���������� ������ ������
unsigned char PackOk(void)
{
	register unsigned char crc;

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
	
	return 1;
}

// ������ �������� ��������� ������
void ReplyStart(unsigned char bytes)
{
	plen = bytes + 1;
	pcrc = plen;

	twi_byte(plen);
}

// �������� ����������� ������ � ����� TWI
void txBuff (void)
	{
		unsigned char a;

		twi_byte(0);				  			// 
		
		ReplyStart (txBuffer[0] );	 	// �������� �����

		for (a=1; a<txBuffer[0]+1;a++)
			{       
			     	twi_byte(txBuffer[a]);
			     	pcrc+= txBuffer[a];
			}
		twi_byte(pcrc);						//�������� ��

		dannForTX = 0;								// �������� ������	

//		if (toReboot) RebootToWork();			// �� ������������
		
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

void PageAccess (void)
{
	#asm
		ldi		r22, (1 << RWWSRE) | (1 << SPMEN)
		rcall	spmSPM
	#endasm
}

// ������ �������� FLASH
void WriteFlash(void)
{
	unsigned char a=0;
//	int temp;
	FADDRTYPE faddr;
	
	// ������� ����� ��������
	#asm ("wdr");
	faddr = GetWordBuff(a);
	a+=2;							// �������� 2 �����
	
	if (faddr >= PRGPAGES)
	{
		while(1);	// ���� ������������ ����� �������� - ������������ ������ � ����� �� ��������
	}	            
	

	// ������� ����� ������ ��������
	faddr <<= (ZPAGEMSB + 1);
	
	// �������� ������ � ������������� �����
	#asm ("wdr");
	ResetTempBuffer(faddr);
	do{
			FillTempBuffer(GetWordBuff(a), faddr);			// 
			a+=2;
			faddr += 2;
    	}while (faddr & (PAGESIZ-1)) ;	

		// �������, ��� ��� � ������� � ����� �������� ���������
		#asm ("wdr");
		txBuffer[0] = 1;                   		// �����
		txBuffer[1] = RES_OK;
		dannForTX = 1;							// ���� ������	

	// �������������� ����� ������ ��������
	faddr -= PAGESIZ;

	// ������ ��������
	#asm ("wdr");
	PageErase(faddr);
	
	// ��������� ��������
	#asm ("wdr");
	PageWrite(faddr);

	// ��������� ��������� ������� RWW
	#asm ("wdr");
	PageAccess();

/*	// �������, ��� ��� � ������� � ����� �������� ���������
	#asm ("wdr");
		txBuffer[0] = 1;                   		// �����
		txBuffer[1] = RES_OK;
		dannForTX = 1;							// ���� ������	*/

}
 
