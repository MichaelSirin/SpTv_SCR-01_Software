///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 
// Связь с внешним миром. Slave RECIVER.

#include <CodingM8.h>
#include <stdio.h>
#include "monitor.h"



// Биты TWCR
#define TWINT 7
#define TWEA  6
#define TWSTA 5
#define TWSTO 4
#define TWWC  3
#define TWEN  2
#define TWIE  0

// Состояния
#define START		0x08
#define	REP_START	0x10

// Коды статуса TWI...
//Master TRANSMITTER
#define	MTX_ADR_ACK		0x18
#define	MRX_ADR_ACK	0x40
#define	MTX_DATA_ACK	0x28
#define	MRX_DATA_NACK	0x58
#define	MRX_DATA_ACK	0x50

//Slave RECIVER
#define	SRX_ADR_ACK		0x60    //принят ADR (подчиненный)
#define	SRX_GADR_ACK	0x70    //принят общий ADR (подчиненный)
#define	SRX_DATA_ACK	0x80    //принят DANN (подчиненный)
#define	SRX_GDATA_ACK	0x90    //принят общие DANN (подчиненный)


	// Настраиваю TWI - подчиненный с адр. Addr
    // Bit Rate: 400,000 kHz
    // General Call Recognition: On
void twi_init (void)
{
	// процесс определения физического адреса порта и ответа
	// на первичный пинг (0хАА) главного процессора
	pAddr = ((PINC & 0x7)+1 );			// определяем физический адрес (0-не исп. т.к. Глоб. Вызов)

    TWSR=0x00;
    TWBR=0x02;
    TWAR=(pAddr<<1)+1;                        // Устанавливаем его для TWI
    TWCR=0x45;                          

}


// Жду флажка окончания текущей операции
static void twi_wait_int (void)
{
	while (!(TWCR & (1<<TWINT))); 
}

/* Проверка обращения к данному устройству...
// Возвращает не 0, если было обращение
unsigned char rx_addr (void)
{
	twi_wait_int();        
    if ((TWSR == SRX_ADR_ACK) || (TWSR == SRX_GADR_ACK))
    {
    return 0;                   //поступил адрес/общ.адрес...
    }        
    return 255;
} */


// Прием байта из канала TWI
inline unsigned char ReceiveChar(void)
{
    while (1)
    {
        twi_wait_int();         //ждем байт - данные

        if ((TWSR == SRX_DATA_ACK)||(TWSR == SRX_GDATA_ACK)) 
            {
        	return TWDR;
            }
      TWCR = ((1<<TWINT)+(1<<TWEA)+(1<<TWEN));    //формируем АСК
    }
//        twi_wait_int();         //ждем байт - данные

}

// Прием байта из канала
unsigned char GetByte(void)
{
	register unsigned char ret;
	ret = ReceiveChar();

	TWCR = ((1<<TWINT)+(1<<TWEA)+(1<<TWEN));    //формируем АСК

	pcrc += ret;
	nbyts ++;

	if (descramble)		// Если нужно дешифровать - дешифрую
	{
		ret ^= NextSeqByte();
	}	
	return ret;
}

// Передача байта данных
// Возвращает не 0, если все в порядке
unsigned char twi_byte (unsigned char data)
{
	twi_wait_int();

	TWDR = data;
    TWCR = ((1<<TWINT)+(1<<TWEA)+(1<<TWEN));    //формируем АСК
// 	TWCR = ((1<<TWINT)+(1<<TWEN));

	twi_wait_int();

	if(TWSR != MTX_DATA_ACK)
	{
		return 0;
	}
		
	return 255;
}



// Ожидание заголовка пакета
unsigned char Wait4Hdr(void)
{
    unsigned char a,b;

	#asm("wdr");		// Перед приемом очередного пакета перезапускаю вотчдог
		
	while(1)
	{
//putchar (0xaa);
		if (prgmode)	// Если меня уже спрашивали, то след. пакет можно ждать долго
		{
			while (!(TWCR & (1<<TWINT))) 

//			while(!twi_wait_int())   							//Ждем обращения главного...
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
		
        adr = GetByte();																	
       	 typePack= GetByte();      // Возвращаю тип пакета

if  ((typePack == PT_WRFLASH)||(typePack ==PT_WREEPROM))				// если пакет для флэш то
			{			
			 	DescrambleStart();					// расшифровываем
//				 print = 1;      	 
             }
             
		for (a=0; a<plen-3;a++)
			{
				b=GetByte();
				rxBuffer [a] = b;				// заполняем буффер данными
//if (print) putchar (b);
			}      

			DescrambleStop();

		if (PackOk())	return typePack;			// сверяем КС
		else 	return 0;

	}                             
}





/*
// Принимаем адрес/данные
// Возвращает не 0, если все в порядке
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