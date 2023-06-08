////////////////////////////////////////////////////////////////////////////////////////////////////////
// Монитор - загрузчик FLASH и EEPROM. Работает по TWI
////////////////////////////////////////////////////////////////////////////////////////////////////////
#include "monitor.h" 
#include "CodingM8.h"      
#include "stdio.h"  
#include "string.h"  


eeprom unsigned char device_name[32] =					// Имя устройства
		"BOOT PROGRAM. Mega 8L ";
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
	
unsigned char txBufferTWI 			[TWI_BUFFER_SIZE/4];		// передающий буфер
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
}




/*		else if ( Recived_Address == MY_TWI_ADDRESS ) 							////////////// Мой адрес. Обращаются ко мне
		{
			switch ( Type_RX_Packet_TWI )
			{
		 		case PT_TOPROG:       			// переходим в программирование
						ToProg();
						rxPack = 0;					// пакет обработан
						break;      

		 		case PT_SETADDR:       			// переходим в программирование
						Setaddr();
						rxPack = 0;					// пакет обработан
						break;      

		 		case PT_SETSERIAL:       			// переходим в программирование
						SetSerial();
						rxPack = 0;					// пакет обработан
						break;      


				default:
						rxPack = 0;					// пакет обработан
			}
       	}
		    else	if( Recived_Address == TO_MON)					// обрабатываем пакет по адресу MONITOR
			{
				switch ( Type_RX_Packet_TWI )
				{
		 			case PT_SETADDR:       			// переходим в программирование
//							Setaddr();
							rxPack = 0;					// пакет обработан
							break;      

			 		case PT_SETSERIAL:       			// переходим в программирование
//							SetSerial();
							rxPack = 0;					// пакет обработан
							break; 

			 		case PT_TOWORK:       			// переходим в программирование
							ToWorkMode();
							rxPack = 0;					// пакет обработан
							break; 
									     
					default:
							rxPack = 0;					// пакет обработан
				}                                                                               
			}
	



/*
//		Wait4Hdr();						// Ждем пакет
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
								break;
						default:
								break;
					}
        	
			}*/
