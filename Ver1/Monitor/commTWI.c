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

// �������� ����� � �����
void PutByte(unsigned char byt)
{
	pcrc += byt;
	nbyts ++;
	
	twi_byte(byt);
}

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

		if (toReboot) RebootToWork();			// �� ������������
		
	}

