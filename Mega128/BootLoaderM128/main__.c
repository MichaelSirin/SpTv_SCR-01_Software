/*////////////////////////////////////////////////////////////////////////////////////////////////////////
// Монитор - загрузчик FLASH и EEPROM. Работает по TWI
////////////////////////////////////////////////////////////////////////////////////////////////////////
#include "monitor.h" 
#include "CodingM8.h"      
#include "stdio.h"  
#include "string.h"  


eeprom unsigned char device_name[32] =					// Имя устройства
		"BOOT PROGRAM. Mega 128 ";
//eeprom unsigned long my_ser_num = 1;					// Серийный номер устройства
#define  my_ser_num  1					// Серийный номер устройства

const flash unsigned short my_version_high = 1;				// Версия софта 
const flash unsigned short my_version_low = 1;				// Версия софта 

eeprom unsigned char my_addr = TO_MON;					// Мой адрес - изначально TO_MON
    

const   unsigned int scrambling_seed = 333;

//unsigned char pAddr;				// Адрес устройства по шине TWI
//unsigned char adr;									// адрес в пришедшем пакете
unsigned char rxPack;							// принят пакет TWI

// Все для работы с TWI
TWISR TWI_statusReg;   
unsigned char 	TWI_slaveAddress = MY_TWI_ADDRESS;		// Own TWI slave address


bit		TWI_TX_Packet_Present				=		0;					// есть данные на передачу
bit		toReboot										=		0;					// перезагружаем в рабочую программу
bit		toProgramming								=		0;					// нас программируют
	
unsigned char txBufferTWI 			[TWI_Buffer_TX];		// передающий буфер
unsigned char rxBufferTWI	[TWI_BUFFER_SIZE];	// приемный буфер


// Вернуть информацию о мониторе и процессоре
void PrgInfo(void)
{
	// Отправляю ответ
//	#asm("wdr");
	txBufferTWI[Start_Position_for_Reply] = (sizeof(RP_PRGINFO) +1);

	txBufferTWI[Start_Position_for_Reply+1] = (PAGESIZ);     			//мл.
	txBufferTWI[Start_Position_for_Reply+2] = (PAGESIZ>>8);          //ст.

	txBufferTWI[Start_Position_for_Reply+3] = (PRGPAGES);
	txBufferTWI[Start_Position_for_Reply+4] = (PRGPAGES>>8);

	txBufferTWI[Start_Position_for_Reply+5] = (EEPROMSIZ);
	txBufferTWI[Start_Position_for_Reply+6] = (EEPROMSIZ>>8);

	txBufferTWI[Start_Position_for_Reply+7] = (MONITORVERSION);
	txBufferTWI[Start_Position_for_Reply+8] = (MONITORVERSION>>8);
	
	txBufferTWI[Start_Position_for_Reply+9] = calc_CRC( &txBufferTWI[Start_Position_for_Reply] );

	// Перешел в режим программирования - теперь могу долго ждать очередной пакет
	prgmode = 1;
	
	// Обнуляю генератор дешифрующей последовательности
	ResetDescrambling();
}


// Прием слова из буффера
unsigned short GetWordBuff(unsigned char a)
{
	register unsigned short ret;  

	// дискремблируем
	ret = ( rxBufferTWI	[a++] ^ NextSeqByte() );
	ret |= ((unsigned short)rxBufferTWI[a] ^ NextSeqByte() ) << 8;

	return ret;
} 



// Запись в EEPROM
void WriteEeprom(void)
{
	register unsigned short addr;
	register unsigned char  data;

	// Прием адреса и данных	
	#asm ("wdr");

	addr = GetWordBuff(5);
	data = ( rxBufferTWI	[7] ^ NextSeqByte() );


	// Проверяю завершение и корректность пакета
	if (addr < EEPROMSIZ)
	{
		// Пишу в EEPROM
		*((char eeprom *)addr) = data;

		// Проверяю, записалось ли
		if (*((char eeprom *)addr) == data)
		{
			// Сигналю, что все в порядке 
			txBufferTWI[Start_Position_for_Reply] = 2;        				// длина
			txBufferTWI[Start_Position_for_Reply+1] = RES_OK;				//  OK
			txBufferTWI[Start_Position_for_Reply+2] = 2 + RES_OK;		//  CRC

			return;
		}
	}
     
	// Ошибка
	txBufferTWI[Start_Position_for_Reply] = 2;        				// длина
	txBufferTWI[Start_Position_for_Reply+1] = RES_ERR;			//  ошибка
	txBufferTWI[Start_Position_for_Reply+2] = 2 + RES_ERR;		//  CRC

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
	
	//WD пока не включен	
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

	#asm("rjmp 0");      //Mega128 - JMP, Mega8 - RJMP
}

// Реакция на команду перейти в рабочий режим
void ToWorkMode(void)
{

	// Отправляю ответ
	txBufferTWI[0] = 0;        						// подтверждаю прием
//	dannForTX = 1;								// есть данные

	prgmode = 0;
	  
	// На перезагрузку
	toReboot =1;
//	RebootToWork();
}

//-----------------------------------------------------------------------------------------------------------------

// Возвращаю состояние устройства
const char _PT_GETSTATE_[]={19,2,0,"BOOT PROGRAM  ",100,255};

static void GetState(void)
{
	register unsigned char a=Start_Position_for_Reply;

	switch (PT_GETSTATE_page)
	{
		case 0:
			memcpyf(&txBufferTWI[2], _PT_GETSTATE_, _PT_GETSTATE_[0]+1); // 0 пакет
			a+=19;
			break;

		case 1:			
			txBufferTWI[a++] = 5;				 			// длина пакета

			txBufferTWI[a++] = 0;							// № микросхемы
			txBufferTWI[a++] = MY_TWI_ADDRESS;
			txBufferTWI[a++] = 0;

			txBufferTWI[a++] = 255;
			break;

		default:
			txBufferTWI[a++] = 0;				 			// длина пакета
			break;
	} 

	txBufferTWI[a] = calc_CRC( &txBufferTWI[Start_Position_for_Reply] );
} 

// Информация об устройстве:

static void GetInfo(void)
{
		register unsigned char i,a=Start_Position_for_Reply;                    
	
		// 	заполняю буфер
		txBufferTWI[a++] = 40+1;
	
		for ( i = 0; i <32; i ++ )	
				txBufferTWI[a++] = device_name[i];	// Имя устройства

		txBufferTWI[a++] = my_ser_num;        		// Серийный номер
		txBufferTWI[a++] = my_ser_num>>8;    	  	// Серийный номер

		txBufferTWI[a++] = my_ser_num>>16;		// Серийный номер
		txBufferTWI[a++] = my_ser_num>>24;		// Серийный номер
	
		txBufferTWI[a++] =MY_TWI_ADDRESS ; 	// Адрес устройства
        txBufferTWI[a++] =0;     							// Зарезервированный байт
	
		txBufferTWI[a++] = my_version_high;        	// Версия софта
		txBufferTWI[a++] = my_version_low;			// Версия  софта
		
		txBufferTWI[a] = calc_CRC( &txBufferTWI[Start_Position_for_Reply] );

}


void main(void)
{
	// Настраиваю "железо"
	 Initialization_Device(); 

	// Global enable interrupts
	#asm("sei")

	// Ожидание, прием и исполнение команд
	while (1)
	{

	// Опрашиваем наличие программы по таймеру (примерно 2с)
	if ( TIFR & (1 << TOV1) )
	{
		TIFR |= (1<<TOV1);
		TCNT1=0xD2F6;		//примерно 2сек

		// Пытаюсь перегрузиться в рабочий режим	
		RebootToWork();
	}

//		#asm("wdr");
		run_TWI_slave();
		
		// Обрабатываем принятый пакет TWI
		if ( rxPack )
		{
			// Обработка внутренних пакетов
			if ( ( Recived_Address == Internal_Packet ) || ( Recived_Address == Global_Packet ) )		
			{
				switch ( Type_RX_Packet_TWI )
				{
					// возвращаем о себе информацию
					case PT_GETINFO:			
//							GetInfo();
							break;                                     

					// возвращаем состояние						
					case PT_GETSTATE:			
//							GetState();
							break;                      

					// Переход в программирование
					case PT_TOPROG:
							toProgramming = 1;				// ждем пакеты программирования
							// формируем ответ
							txBufferTWI[0] = 1;				 	// длина пакета
							txBufferTWI[1] = 1;				 	// КС

							break;      

					// Вернуть информацию о мониторе и процессоре
					case PT_PRGINFO:	
							PrgInfo();
							break;

					// Записать страницу FLASH							
					case PT_WRFLASH:	

//							TCNT1=0xD2F6;		//примерно 2сек

//							toProgramming = 1;				// ждем пакеты программирования
							WriteFlash();
							break;

					// Записать байт в EEPROM
					case PT_WREEPROM:	

//							TCNT1=0xD2F6;		//примерно 2сек

							WriteEeprom();
							break;
			

					default:
//							toProgramming = 0;		// программируют не нас
				}
				// отправляем ответ
				packPacket (External_Packet);	// даем тип ВНЕШНИЙ
				// переинициализируем таймер
				TCNT1=0xD2F6;		//примерно 2сек
	         }
		
		rxPack = 0;							// пакет обработан
        }          
	}
}*/


////////////////////////////////////////////////////////////////////////////////////////////
// Монитор - загрузчик FLASH и EEPROM
////////////////////////////////////////////////////////////////////////////////////////////
#include "monitor.h"


// Вернуть информацию о мониторе и процессоре
void PrgInfo(void)
{
	// Проверяю завершение пакета
	if (!PackOk())
	{
		return;
	}
	
	// Отправляю ответ
	#asm("wdr");
	ReplyStart(sizeof(RP_PRGINFO));
	PutWord(PAGESIZ);
	PutWord(PRGPAGES);
	PutWord(EEPROMSIZ);
	PutWord(MONITORVERSION);
	ReplyEnd();

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

	DescrambleStart();

	// Прием адреса и данных	
	#asm ("wdr");
	addr = GetWord();
	data = GetByte();
	
	DescrambleStop();

	// Проверяю завершение и корректность пакета
	if (!PackOk() || (addr >= EEPROMSIZ))
	{
		ReplyStart(1);
		PutByte(RES_ERR);
		ReplyEnd();
		return;
	}
	
	// Пишу в EEPROM
	*((char eeprom *)addr) = data;
	
	// Проверяю, записалось ли
	if (*((char eeprom *)addr) != data)
	{
		ReplyStart(1);
		PutByte(RES_ERR);
		ReplyEnd();
		return;
	}

	// Сигналю, что все в порядке 
	ReplyStart(1);
	PutByte(RES_OK);
	ReplyEnd();
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
	bit ha_flag = 0;
	
	#asm("wdr");

	// Считываю число используемых секторов
	lastaddr = ( (FADDRTYPE)FlashByte(PRGPAGES*PAGESIZ - 4) | 
	            ((FADDRTYPE)FlashByte(PRGPAGES*PAGESIZ - 3) << 8));

	// Если FLASH чистый	            
	if (lastaddr == 0xFFFF)
	{
		return 0;
	}

	// Задействована последняя доступная для программирования страница	
	if (lastaddr >= PRGPAGES)
	{
		ha_flag = 1;
	}

	// Умножаю число используемых секторов на размер сектора в байтах	
	lastaddr = lastaddr << (ZPAGEMSB + 1);

	// Если задействована последняя страница
	// исключаю длину и контрольную сумму из подсчета контрольной суммы
	if (ha_flag)
	{
		lastaddr -= 4;
	}
	
	// Подсчитываю текущую контрольную сумму
	for (addr = 0, crc = 0; addr < lastaddr; addr ++)
	{
		crc += FlashByte(addr);
	}

	// Если задействована последняя страница дополняю место длины
	// и контрольной суммы пустым местом
	if (ha_flag)
	{
		crc += 255;
		crc += 255;
		crc += 255;
		crc += 255;
	}

	// Считываю опорную контрольную сумму	
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

	#asm("wdr");
	
	#if (defined _CHIP_ATMEGA128_) || (defined _CHIP_ATMEGA128L_)
		#asm("jmp 0");
	#elif (defined _CHIP_ATMEGA162_) || (defined _CHIP_ATMEGA162L_)
		#asm("jmp 0");
	#else
		#asm("rjmp 0");
	#endif
}

// Реакция на команду перейти в рабочий режим
void ToWorkMode(void)
{
	// Проверяю завершение пакета
	if (!PackOk())
	{
		return;
	}
	
	// Отправляю ответ
	ReplyStart(0);
	ReplyEnd();

	prgmode = 0;
	  
	// На перезагрузку
	RebootToWork();
}

void main(void)
{
	// Это был сброс по вотчдогу?
	if (MCUCSR & (1 << WDRF))
	{
		MCUCSR &= (1 << WDRF) ^ 0xFF;
	
		// Если вылетел по вотчдогу - пытаюсь перегрузиться в рабочий режим	
		RebootToWork();
	}
	
	// Настраиваю "железо"
	HardwareInit();

	// Ожидание, прием и исполнение команд
	while (1)
	{
		switch(Wait4Hdr())
		{
		case PT_PRGINFO:	// Вернуть информацию о мониторе и процессоре  
			PrgInfo();
			break;
		case PT_WRFLASH:	// Записать страницу FLASH
//putchar2('2');
			WriteFlash();
			break;
		case PT_WREEPROM:	// Записать байт в EEPROM
			WriteEeprom();
			break;
		case PT_TOWORK:		// Вернуться в режим работы
			ToWorkMode();			
			break;
		default:
			break;
		}
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////
// Что касается "железа" I2CxCOM
#include "monitor.h"
                                    
#define LedRed() {DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 0, PORTA.1 = 1;}
#define LedGreen() {DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 1, PORTA.1 = 0;}
#define LedOff() {DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 1, PORTA.1 = 1;}

#define BAUD 38400		// Скорость обмена по COM-порту
const unsigned int scrambling_seed = 333;

void HardwareInit(void)
{
	// Настраиваю UART
//	UCSR0A = 0x00;
	UCSR0B = 0x10; //0x18; //приемник вкл.
	UCSR0C = 0x06;
	UBRR0L = ((_MCU_CLOCK_FREQUENCY_ / (16 * BAUD)) - 1) & 0xFF;
	UBRR0H = (((_MCU_CLOCK_FREQUENCY_ / (16 * BAUD)) - 1) >> 8) & 0xFF;

	// Запрещаю компаратор
//	ACSR=0x80;
//	SFIOR=0x00;

	// Вотчдог
	WDTCR=0x1F;
	WDTCR=0x0F;
}

#define USR  UCSR0A
#define UDRE (1 << 5)
#define UDR  UDR0
#define RXC  (1 << 7)

// Передача байта в канал
inline void XmitChar(unsigned char byt)
{
	while(!(USR & UDRE));
	UDR = byt;
}

// Наличие принятого байта
unsigned char HaveRxChar(void)
{
	return USR & RXC;
}

// Прием байта из канала
inline unsigned char ReceiveChar(void)
{
	while(!HaveRxChar());
	return UDR;
}
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

// Запись страницы FLASH
void WriteFlash(void)
{
	FADDRTYPE faddr;
	
	// Далее - дешифровать
	DescrambleStart();
	
	// Получаю номер страницы
	#asm ("wdr");
	faddr = GetWord();
	
	if (faddr >= PRGPAGES)
	{
		while(1);	// Если неправильный номер страницы - непоправимая ошибка и вылет по вотчдогу
	}	

	// Получаю адрес начала страницы
	faddr <<= (ZPAGEMSB + 1);
	
	// Загрузка данных в промежуточный буфер
	#asm ("wdr");
	ResetTempBuffer(faddr);
	do {
		#asm ("wdr");
		FillTempBuffer(GetWord(), faddr);
		faddr += 2;
	#if PAGESIZ < 255
		// Если страница целиком помещается в пакет - просто жду завершения страницы
		} while (faddr & (PAGESIZ-1));	
	#else
		// Если страница большая - она расфасовывается в 2 пакета
		} while (nbyts < (plen-1));		// До завершения приема первого пакета
		DescrambleStop();
	
		// Проверяю завершение пакета
		if (!PackOk())
		{
			ReplyStart(1);
			PutByte(RES_ERR);
			ReplyEnd();
			return;
		}
		
		// Сигналю, что все в порядке и можно посылать следующий
		#asm ("wdr");
		ReplyStart(1);
		PutByte(RES_OK);
		ReplyEnd();
		
		// Жду второй пакет с остатком страницы
		while(Wait4Hdr() != PT_WRFLASH);
		DescrambleStart();
		do {
			#asm ("wdr");
			FillTempBuffer(GetWord(), faddr);
			faddr += 2;
		} while (nbyts < (plen-1));		// До завершения приема второго пакета
	#endif
		DescrambleStop();
	
	// Проверяю завершение пакета
	if (!PackOk())
	{
		ReplyStart(1);
		PutByte(RES_ERR);
		ReplyEnd();
		return;
	}
	
	// Восстанавливаю адрес начала страницы
	faddr -= PAGESIZ;

	// Стираю страницу
	#asm ("wdr");
	PageErase(faddr);
	
	// Записываю страницу
	#asm ("wdr");
	PageWrite(faddr);

	// Сигналю, что все в порядке и можно посылать следующий
	#asm ("wdr");
	ReplyStart(1);
	PutByte(RES_OK);
	ReplyEnd();
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
