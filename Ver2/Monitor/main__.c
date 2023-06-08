////////////////////////////////////////////////////////////////////////////////////////////
// Монитор - загрузчик FLASH и EEPROM
////////////////////////////////////////////////////////////////////////////////////////////
#include "monitor.h" 
#include "CodingM8.h"      
#include "stdio.h"  
#include "string.h"  

flash unsigned char device_name[32] =					// Имя устройства
		"Boot Program. Port";
eeprom unsigned long my_ser_num = 1;					// Серийный номер устройства
const flash unsigned short my_version = 1;			// Версия софта 
eeprom unsigned char my_addr = TO_MON;					// Мой адрес - изначально TO_MON
    

unsigned char pAddr;				// Адрес устройства по шине TWI
unsigned char adr;									// адрес в пришедшем пакете
unsigned char typePack;							// тип принятого пакета


//bit 		ping		 			=		0;					// Признак что прошел первый пинг	
bit	dannForTX			=		0;					// Есть данные на передачу
bit	toReboot				=		0;					// перезагружаем в рабочую программу
	
unsigned char txBuffer[128];								// передающий буффер
unsigned char rxBuffer[128];								// приемный буффер


// Вернуть информацию о мониторе и процессоре
void PrgInfo(void)
{
	// Отправляю ответ
	#asm("wdr");
	txBuffer[0] = (sizeof(RP_PRGINFO));

	#asm("wdr");
	txBuffer[1] = (PAGESIZ);     			//мл.
	txBuffer[2] = (PAGESIZ>>8);          //ст.

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
	dannForTX = 1;								// есть данные	

	// Перешел в режим программирования - теперь могу долго ждать очередной пакет
	prgmode = 1;
	
	// Обнуляю генератор дешифрующей последовательности
	ResetDescrambling();
}

// Запись в EEPROM
void WriteEeprom(void)
{
	register unsigned short addr;
	register unsigned char  data;

	// Прием адреса и данных	
	#asm ("wdr");
	addr = GetWordBuff(0);
	
	// Проверяю завершение и корректность пакета
	if (addr >= EEPROMSIZ)
	{
			txBuffer[0] = 1;        				// длина
			txBuffer[1] = RES_ERR;			//  ошибка
			dannForTX = 1;						// есть данные	

		return;
	}
	
	// Пишу в EEPROM
	*((char eeprom *)addr) = data;
	
	// Проверяю, записалось ли
	if (*((char eeprom *)addr) != data)
	{
			txBuffer[0] = 1;        				// длина
			txBuffer[1] = RES_ERR;			//  ошибка
			dannForTX = 1;						// есть данные	
		return;
	}

	// Сигналю, что все в порядке 
	#asm ("wdr");                                                        
			txBuffer[0] = 1;        				// длина
			txBuffer[1] = RES_OK;			
			dannForTX = 1;						// есть данные	
}

// Чтение байта из FLASH по адресу
#ifdef USE_RAMPZ
	#pragma warn-
	unsigned char FlashByte(FADDRTYPE addr)
	{
	#asm
		ld		r30, y		; Загружаю Z
		ldd		r31, y+1
		
		in		r23, rampz	; Сохраняю RAMPZ
		
		ldd		r22, y+2	; Переношу RAMPZ
		out		rampz, r22
		
		elpm	r24, z		; Читаю FLASH
		
		out		rampz, r23	; Восстанавливаю RAMPZ

		mov		r30, r24	; Возвращаемое значение
	#endasm
	}	
	#pragma warn+
#else
	#define FlashByte(a) (*((flash unsigned char *)a))
#endif

// Проверка наличия "рабочей" программы
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

// Перезагрузка в рабочий режим
void RebootToWork(void)
{
	// Проверяю, есть ли куда грузиться
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

// Реакция на команду перейти в рабочий режим
void ToWorkMode(void)
{

	// Отправляю ответ
	txBuffer[0] = 0;        						// подтверждаю прием
//	dannForTX = 1;								// есть данные

	prgmode = 0;
	  
	// На перезагрузку
	toReboot =1;
//	RebootToWork();
}

//-----------------------------------------------------------------------------------------------------------------

// Информация об устройстве
static void GetInfo(void)
{
	register unsigned char i;
	
	// 	заполняю буфер
	txBuffer[0] = 40;
	
	for (i = 0; i < 32; i ++)	// Имя устройства
	{
		txBuffer[i+1] = device_name[i];
	}

		txBuffer[33] = my_ser_num;           // Серийный номер
		txBuffer[34] = my_ser_num>>8;      // Серийный номер

		txBuffer[35] = 0;	// Серийный номер
		txBuffer[36] = 0;	// Серийный номер
	
		txBuffer[37] =pAddr ;     // Адрес устройстав

		txBuffer[38] =0;     // Зарезервированный байт
	
		txBuffer[39] = my_version;             // Версия
		txBuffer[40] = my_version>>8;		// Версия
	
		dannForTX = 1;								// есть данные	

}

//-----------------------------------------------------------------------------------------------------------------

// Возвращаю состояние устройства
const char _PT_GETSTATE_[]={19,0,0,'a','a','a','a','a','a','a','a','a','a','a','a','a','a',' ',100,255};
static void GetState(void)
{
		memcpyf(txBuffer, _PT_GETSTATE_, _PT_GETSTATE_[0]+1);
		dannForTX = 1;								// есть данные	
} 


void main(void)
{
	// Настраиваю "железо"
	HardwareInit(); 

	// Это был сброс по вотчдогу?
	if (MCUCSR & (1 << WDRF))
	{
		MCUCSR &= (1 << WDRF) ^ 0xFF;
	
		// Если вылетел по вотчдогу - пытаюсь перегрузиться в рабочий режим	
		RebootToWork();
	}
	
	// Ожидание, прием и исполнение команд
	while (1)
	{
		Wait4Hdr();						// Ждем пакет
        if ((adr == pAddr)||(adr == TO_MON )) 	            // работа при внешней адресации
        	{
				switch(typePack)
					{

						case PT_PRGINFO:	// Вернуть информацию о мониторе и процессоре
							PrgInfo();
							txBuff();
							break;

						case PT_WRFLASH:	// Записать страницу FLASH
							WriteFlash();
							txBuff();
							break;

						case PT_WREEPROM:	// Записать байт в EEPROM
							WriteEeprom();
							txBuff();
						break;

						case PT_TOWORK:		// Вернуться в режим работы
							ToWorkMode();			
							txBuff();                         // отвечаем и
							RebootToWork();			// на перезагрузку
							break;    

						case PT_TOPROG:
							txBuffer[0] = 0;        				// мы входим в прораммирование
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
        else         if (adr==0)											//  команды при внутр. адресе 0
        	{
				switch(typePack)
					{
						case GetLogAddr:     						// Отвечаем. Заполняем буффер на передачу
								txBuffer[0] = 1;				 		// длина пакета
								txBuffer[1] = 0;				 		// лог. адрес
								txBuff ();                           		// передаем
								break;

/*						case pingPack :
								if (dannForTX) txBuff();
								else 	twi_byte(0);				  			// длина пакета
								break;*/
						default:
								break;
					}
        	
			}
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////
// Что касается "железа" Coding Device (Mega8)
#include "monitor.h"
#include "CodingM8.h"        


const   unsigned int scrambling_seed = 333;

void HardwareInit(void)
{
	// Настройка выводов
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



	// Запрещаю компаратор
	ACSR=0x80;
	SFIOR=0x00;

    //Настройки TWI
    twi_init();             

	// Вотчдог
	WDTCR=0x1F;
	WDTCR=0x0F;  

}

#define USR  TWSR                   //статус порта 
#define UDRE (1 << 5)
#define UDR  TWDR                   //регистр с принимаемыми/передаваемыми байтами
#define RXC  (1 << 7)
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

//Slave Transmitter
#define	STX_ADR_ACK		0xA8    //принят ADR (подчиненный передатчик)


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
        if (TWSR == STX_ADR_ACK)				// хотят прочитать нас
        	{
//				if (dannForTX) txBuff();
//				else
				 TWDR = 0;
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
// Обмен пакетами с хостом
#include "monitor.h"   
#include "CodingM8.h"

        
   

unsigned char pcrc;	// Контрольная сумма
unsigned char plen;	// Длина пакета
unsigned char nbyts;	// Число принятых или переданых байт
bit prgmode  = 0;		// Находимся в режиме программирования


// Прием слова из буффера
unsigned short GetWordBuff(unsigned char a)
{
	register unsigned short ret;  

	ret = 	rxBuffer	[a++];
	ret |= ((unsigned short)rxBuffer[a]) << 8;
	
	return ret;
} 

/*// Передача байта в кан\ал
void PutByte(unsigned char byt)
{
	pcrc += byt;
	nbyts ++;
	
	twi_byte(byt);
} */

// Контроль успешного завершения приема пакета
unsigned char PackOk(void)
{
	register unsigned char crc;

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
	
	return 1;
}

// Начало передачи ответного пакета
void ReplyStart(unsigned char bytes)
{
	plen = bytes + 1;
	pcrc = plen;

	twi_byte(plen);
}

// Передача содержимого буфера в канал TWI
void txBuff (void)
	{
		unsigned char a;

		twi_byte(0);				  			// 
		
		ReplyStart (txBuffer[0] );	 	// передаем длину

		for (a=1; a<txBuffer[0]+1;a++)
			{       
			     	twi_byte(txBuffer[a]);
			     	pcrc+= txBuffer[a];
			}
		twi_byte(pcrc);						//передаем КС

		dannForTX = 0;								// передали данные	

//		if (toReboot) RebootToWork();			// на перезагрузку
		
	}

///////////////////////////////////////////////////////////////////////////////////////////
// Дешифрование программирующих данных

unsigned long int next_rand = 1;
unsigned char rand_cnt = 31;

// Генератор псевдослучайной последовательности.
// За основу взяты IAR-овские исходники

bit descramble = 0;					// Признак необходимости дешифрования

unsigned char NextSeqByte(void)	// Очередной байт дешифрующей последовательности
{
	next_rand = next_rand * 1103515245 + 12345;
	next_rand >>= 8;
	
	rand_cnt += 101;
		
	return rand_cnt ^ (unsigned char)next_rand;
}

void ResetDescrambling(void)		// Перезапуск генератора дешифрующей последовательности
{
	next_rand = scrambling_seed;
	rand_cnt = 31;
	descramble = 0;
}
//--------------------------------------------------------------------------------------
// Функции для работы с FLASH

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
	#error Поддержка для этого процессора еще не написана
#endif

#asm
	.equ	SPMEN  = 0	; Биты регистра
	.equ	PGERS  = 1
	.equ	PGWRT  = 2
	.equ	BLBSET = 3
	.equ	RWWSRE = 4
	.equ	RWWSB  = 6
	.equ	SPMIE  = 7
	;--------------------------------------------------
	; Ожидание завершения SPM. Портит R23
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
	; Запуск SPM.
	spmSPM:
		in		r24, SREG	; Сохраняю состояние
		cli					; Запрещаю прерывания
#endasm
#ifdef USE_RAMPZ
	#asm
		in		r25, RAMPZ	; Сохраняю RAMPZ
	#endasm
#endif
#asm
		ld		r30, y		; Адрес
		ldd		r31, y+1
#endasm
#ifdef USE_RAMPZ
	#asm
		ldd		r26, y+2	; 3-й байт адреса - в RAMPZ
		out		RAMPZ, r26
	#endasm
#endif
#asm
		rcall	spmWait		; Жду завершения предидущей операции (на всякий случай)
#endasm
#ifdef USE_MEM_SPM
	#asm
		sts SPMREG, r22		; Регистр команд, как память
	#endasm
#else
	#asm
		out SPMREG, r22		; Регистр команд, как порт
	#endasm
#endif
#asm
		spm					; Запуск на выполнение
		nop
		nop
		nop
		nop
		rcall	spmWait		; Жду завершения
#endasm
#ifdef USE_RAMPZ
	#asm
		out		RAMPZ, r25	; Восстанавливаю состояние
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
			ldd		r0, y+4			; Данные
			ldd		r1,	y+5
		#endasm
	#else
		#asm
			ldd		r0, y+2			; Данные
			ldd		r1,	y+3
		#endasm
	#endif
	#asm
		ldi		r22, (1 << SPMEN)	; Команда
		rcall	spmSPM				; На выполнение
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

// Запись страницы FLASH
void WriteFlash(void)
{
	unsigned char a=0;
//	int temp;
	FADDRTYPE faddr;
	
	// Получаю номер страницы
	#asm ("wdr");
	faddr = GetWordBuff(a);
	a+=2;							// вычитали 2 байта
	
	if (faddr >= PRGPAGES)
	{
		while(1);	// Если неправильный номер страницы - непоправимая ошибка и вылет по вотчдогу
	}	            
	

	// Получаю адрес начала страницы
	faddr <<= (ZPAGEMSB + 1);
	
	// Загрузка данных в промежуточный буфер
	#asm ("wdr");
	ResetTempBuffer(faddr);
	do{
			FillTempBuffer(GetWordBuff(a), faddr);			// 
			a+=2;
			faddr += 2;
    	}while (faddr & (PAGESIZ-1)) ;	

		// Сигналю, что все в порядке и можно посылать следующий
		#asm ("wdr");
		txBuffer[0] = 1;                   		// длина
		txBuffer[1] = RES_OK;
		dannForTX = 1;							// есть данные	

	// Восстанавливаю адрес начала страницы
	faddr -= PAGESIZ;

	// Стираю страницу
	#asm ("wdr");
	PageErase(faddr);
	
	// Записываю страницу
	#asm ("wdr");
	PageWrite(faddr);

	// Разрешить адресацию области RWW
	#asm ("wdr");
	PageAccess();

/*	// Сигналю, что все в порядке и можно посылать следующий
	#asm ("wdr");
		txBuffer[0] = 1;                   		// длина
		txBuffer[1] = RES_OK;
		dannForTX = 1;							// есть данные	*/

}
 
