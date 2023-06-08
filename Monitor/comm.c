// Обмен пакетами с хостом
#include "monitor.h"      

#define LedRed() {DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 0, PORTA.1 = 1;}
#define LedGreen() {DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 1, PORTA.1 = 0;}
#define LedOff() {DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 1, PORTA.1 = 1;}

unsigned char pcrc;	// Контрольная сумма
unsigned char plen;	// Длина пакета
unsigned char nbyts;	// Число принятых или переданых байт
bit prgmode  = 0;		// Находимся в режиме программирования

#define BAUD 38400
#define DTXDDR 	DDRC.0		// вывод программного UART   (35pin, на стороне - 16)
#define DTXPIN	PORTC.0		// вывод программного UART


// Прием байта из канала
unsigned char GetByte(void)
{
	register unsigned char ret;
	
	ret = ReceiveChar();
	
	pcrc += ret;
	nbyts ++;

	if (descramble)		// Если нужно дешифровать - дешифрую
	{
		ret ^= NextSeqByte();
	}	
	return ret;
}

// Прием слова из канала
unsigned short GetWord(void)
{
	register unsigned short ret;
	
	ret = GetByte();
	ret |= ((unsigned short)GetByte()) << 8;
	
	return ret;
}

// Передача байта в канал
void PutByte(unsigned char byt)
{
	pcrc += byt;
	nbyts ++;
	
	XmitChar(byt);
}

// Передача слова в канал
void PutWord(unsigned short w)
{
	PutByte(w & 0xFF);
	PutByte(w >> 8);
}

// Ожидание заголовка пакета
unsigned char Wait4Hdr(void)
{
	#asm("wdr");		// Перед приемом очередного пакет	а перезапускаю вотчдог
		
	while(1)
	{
		if (prgmode)	// Если меня уже спрашивали, то след. пакет можно ждать долго
		{
			while(!HaveRxChar())
			{
				#asm("wdr");
			}
		}
		
		pcrc = 0;
		
		if (GetByte() != PACKHDR)	// Жду заголовок
		{
			continue;
		}
		
		plen = GetByte();		 	// Длина пакета
		
		nbyts = 0;


		if (GetByte() != TO_MON)	// Сличаю адрес
		{
			continue;
		}
		return GetByte();			// Возвращаю тип пакета
	}
}

// Контроль успешного завершения приема пакета
unsigned char PackOk(void)
{
	register unsigned char crc;

/*
	// Сверяю контрольную сумму	
	crc = pcrc;
	if (GetByte() != crc)
	{
		return 0;
	}

	// Сверяю длину пакета	
	if (nbyts != plen)
	{
		return 0;
	}
	
	return 1;*/

	// Сверяю контрольную сумму	
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

// Начало передачи ответного пакета
void ReplyStart(unsigned char bytes)
{
	plen = bytes + 1;
	pcrc = 0;
	
	ReplyXmitterEnable();	// Разрешаю передатчик

	PutByte(plen);
}

// Завершение передачи ответного пакета
void ReplyEnd(void)
{
	PutByte(pcrc);
	ReplyXmitterDisable();	// Запрещаю передатчик
}

//--------------------------------------------------------------------------------------------
// "программный" UART
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

