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