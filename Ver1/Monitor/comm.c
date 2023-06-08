// ����� �������� � ������
#include "monitor.h"      

#define LedRed() {DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 0, PORTA.1 = 1;}
#define LedGreen() {DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 1, PORTA.1 = 0;}
#define LedOff() {DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 1, PORTA.1 = 1;}

unsigned char pcrc;	// ����������� �����
unsigned char plen;	// ����� ������
unsigned char nbyts;	// ����� �������� ��� ��������� ����
bit prgmode  = 0;		// ��������� � ������ ����������������

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
	#asm("wdr");		// ����� ������� ���������� ������ ������������ �������
		
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
