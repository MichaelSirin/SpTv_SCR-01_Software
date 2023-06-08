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
