/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Управляющая программа КОДЕРА

#include "Coding.h"

flash unsigned char device_name[32] =					// Имя устройства
		"Port Device v1.0";
eeprom unsigned long my_ser_num = 0;					// Серийный номер устройства
const flash unsigned short my_version = 0x0100;			// Версия софта 
eeprom unsigned char my_addr = TO_MON;					// Мой адрес - изначально TO_MON

unsigned char txBuffer [256];		//буффер передатчика
unsigned char rxBuffer [256];		//буер приемника
unsigned char lAddrDevice	[64];	// храним лог. адреса подключенных устройств
															// 0 ячейка - кол-во портов 232 .1 ячейка содержит лог. адрес порта 1, 2-лог.
															// адрес порта 2 и т. д.
// Переменные для работы с CF Card
/*
typedef struct 				// структура приемного пакета при передаче имени файла
{
	char Ptype;               // тип принятого пакета
	char fname[13];        // имя файла
} strInPack; */

strInPack * str = (strInPack *)(rx0buf);
strDataPack * str1 = (strDataPack *)(rx0buf);

FILE *pntr1; 


typedef struct _chip_port
{
	flash char name[16];
	flash unsigned char addr;
} CHIPPORT;

CHIPPORT cp[] = {
	{"Порт 1", 1},
	{"Порт 2", 2},
	{"Порт 3", 3},
	{"Порт 4", 4}
};

//-----------------------------------------------------------------------------------------------------------------
// Возвращаю состояние устройства
static void GetState(void)
{
	register unsigned char i, n, b;
	
	#define strq  ((RQ_GETSTATE *)rx0buf)

	switch(strq->page)
	{
	case 0:
		StartReply(2 + 16*(sizeof(cp) / sizeof(CHIPPORT)) + 1);

		putchar0(2);               						 // число доступных страниц, включая эту
		putchar0(0);										// зарезервирован
		
		for (n = 0; n < (sizeof(cp) / sizeof(CHIPPORT)); n ++)
		{
			for (i = 0; i < 15; i ++)
			{
				b = cp[n].name[i];
				if (!b)
				{
					break;
				}
				putchar0(b);
			}
			while(i < 15)
			{
				putchar0(' ');
				i++;
			}
			
			putchar0(cp[n].addr);
		}
		
		putchar0(255);

		EndReply();
		return;

	case 1:
	
		StartReply(3 * (sizeof(cp) / sizeof(CHIPPORT)) + 1);
		
		for (n = 0; n < (sizeof(cp) / sizeof(CHIPPORT)); n++)
		{
			putchar0(n);
			putchar0(cp[n].addr);
			putchar0(lAddrDevice [cp[n].addr]);
		}

		putchar0(255);

		EndReply();
		return;
	}
}

//-----------------------------------------------------------------------------------------------------------------
// Информация об устройстве
static void GetInfo(void)
{
	register unsigned char i;
	
	// 	Начинаю передачу ответа
	StartReply(40);
	
	for (i = 0; i < 32; i ++)	// Имя устройства
	{
		putchar0(device_name[i]);
	}

	putword0(my_ser_num);		// Серийный номер
	putword0(my_ser_num >> 16);	
	
	putchar0(my_addr);			// Адрес устройстав

	putchar0(0);				// Зарезервированный байт
	
	putword0(my_version);		// Версия
	
	EndReply();					// Завершаю ответ
}

//-----------------------------------------------------------------------------------------------------------------
// Смена адреса устройства
static void SetAddr(void)
{
	#define sap ((RQ_SETADDR *)rx0buf)
	
	my_addr = sap->addr;
	
	StartReply(1);
	putchar0(RES_OK);
	EndReply();
}

//-----------------------------------------------------------------------------------------------------------------
// Назначение серийного номера устройства
static void SetSerial(void)
{
	#define ssp ((RQ_SETSERIAL *)rx0buf)
	
	if (my_ser_num)
	{
		StartReply(1);
		putchar0(RES_ERR);
		EndReply();
		return;
	}
	
	my_ser_num = ssp->num;
	
	StartReply(1);
	putchar0(RES_OK);
	EndReply();
}

//-----------------------------------------------------------------------------------------------------------------
// Перезагрузка в режим программирования
static void ToProg(void)
{
	// Отправляю ответ
	StartReply(0);
	EndReply();

	// На перезагрузку в монитор
	MCUCR = 1 << IVCE;
	MCUCR = 1 << IVSEL;

	#asm("jmp 0xFC00");
}

//-----------------------------------------------------------------------------------------------------------------
// Железо процессора в исходное состояние
static void HardwareInit(void)
{         
        twi_init ();      
		CommInit();				// Инициализация  COM-порта
		timer_0_Init ();			// Инициализируем таймер 0 (таймаут)
		portInit();					// Выводы - в исходное состояние
        
}

//-----------------------------------------------------------------------------------------------------------------
// Сброс периферии
void ResetPeripherial(void)
{
        CRST = 0;
        delay_ms(10);
        CRST = 1;
        delay_ms(500);     //Ждем пока отработают сброс
}

//-----------------------------------------------------------------------------------------------------------------
// Точка входа в программу
void main(void)
{
unsigned char a;   

//	Пока происходят внутренние работы светодиод - красный. По окончании - зеленый.

    LedRed();               
	HardwareInit();				// Железо процессора
	ResetPeripherial();		// Сбрасываю периферию 

	#asm("sei")

	UCSR0B.3 = 1;		 				// Разрешаю передатчик UART
	delay_ms (3000);					// даем время отработать сброс
	verIntDev();							// Считаем	 количество подчиненных устройств 

// работаем с карточкой...
	while (!(initialize_media()));		// инициализация CF Card   

	while (1)
	{
		LedGreen();

		for (a=1; a<= int_Devices; a++) pingPack (a);	   			// вычитываем у кого что есть

		ReadLogAddr ();				// Вычитываем лог. адреса
	

		// Проверяю, нет ли пакета и принимаю меры, если есть
		if (HaveIncomingPack())
		{
		if ((rx0addr == my_addr) || (rx0addr == TO_ALL))				// адрес мой 
			{
				switch(IncomingPackType())
					{
						case PT_GETSTATE:
								GetState();
								break;
				
						case PT_GETINFO:
								GetInfo();
								break;
				
						case PT_SETADDR:
								SetAddr();
								break;
				
						case PT_SETSERIAL:
								SetSerial();
								break;
				
						case PT_TOPROG:
								ToProg();
								break;      

						case PT_RELAY:           			// ретрансляция пакета при программировании
							    RelayPack();	
                				break;

						case PT_FLASH:								// пакеты для работы с CF Flash
							    flash_Work();	
                				break;
                			
						default:
								DiscardIncomingPack();
								break;
					}
		   }
		else																	// ретранслируем
				{                                                                      
					for (a=1; a<= int_Devices; a++)				// ищем порт по адресу
						{
						 	if (lAddrDevice [a]	== rx0addr)
						 		{
									LedRed();
									recompPack (a);		
									DiscardIncomingPack();        // разрешаем принимать след. пакет
									delay_ms (50);
									pingPack (a);	
									break;
						 		}
						}
				}
		}
	}
}    	

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Управляющая программа КОДЕРА
// Связь с внешним миром

#include "Coding.h"

#define BAUD 38400

/*
////////////////////////////////////////////////////////////////////////////////
// Фазы работы приемопередатчиков
#define RX_HDR	 1		// Принятый байт - заголовок
#define RX_LEN   2		// Принятый байт - длина
#define RX_ADDR  3		// Принятый байт - адрес
#define RX_TYPE  4		// Принятый байт - тип пакета
#define RX_DATA  5		// Принятый байт - байт данных
#define RX_CRC   6		// Принятый байт - CRC
#define RX_OK    7		// Пакет успешно принят и адресован мне
#define RX_TIME  8		// Во время приема произошел тайм-аут
#define RX_ERR   9		// Ошибка CRC приема
#define RX_BUSY 10		// Запрос прочитан, а ответ еще не сформирован
*/
#define UDRE 5
#define DATA_REGISTER_EMPTY (1<<UDRE)

#define RXTIMEOUT 4000	// Тайм-аут приема наружного канала

////////////////////////////////////////////////////////////////////////////////
// Работа с наружным каналом

unsigned char tx0crc;
unsigned char rx0state = RX_HDR;
unsigned char rx0crc;
unsigned char rx0len;
unsigned char rx0addr;
unsigned char rx0type;

#define COMBUFSIZ 255

unsigned char rx0buf[COMBUFSIZ];
unsigned char rx0ptr;

// Передача байта во "внешний" канал
void putchar0(char byt)
{
	while ((UCSR0A & DATA_REGISTER_EMPTY)==0);
	UDR0 = byt;
	tx0crc += byt;
}

// Начало ответа на запрос по внешнему каналу
void StartReply(unsigned char dlen) 
{
//	rx0state = RX_BUSY;					// Запрос обработан
	tx0crc = 0;										// Готовлю CRC
	
	UCSR0B.3 = 1;								// Разрешаю передатчик
	
	putchar0(dlen+1);							// Передаю длину
}

void EndReply(void)
{
	putchar0(tx0crc);							// Контрольная сумма
//	UCSR0B.3 = 0;								// Запрещаю передатчик
	rx0state = RX_HDR;						// Разрешаю прием след. запроса
}

// Прерывание по приему байта из "наружного" канала
interrupt [USART0_RXC] void uart_rx_isr(void)
{
	register unsigned char byt;

	byt = UDR0;									// Принятый байт

	
	switch (rx0state)
	{
	case RX_HDR:								// Должен быть заголовок
		if (byt != PACKHDR)					// Отбрасываю не заголовок
		{
			break;
		}


		rx0state = RX_LEN;					// Перехожу к ожиданию длины
		rx0crc = 0;								// Готовлю подсчет CRC
		
		OCR1A = TCNT1+RXTIMEOUT;	// Взвожу тайм-аут
		TIFR = 0x10;								// Предотвращаю ложное срабатывание
		TIMSK |= 0x10;							// Разрешение прерывания по тайм-ауту
		break;
		
	case RX_LEN:
		rx0len = byt - 3;							// Длина содержимого
		rx0state = RX_ADDR;					// К приему адреса
		break;

	case RX_ADDR:
		rx0addr = byt;							// Адрес
		rx0state = RX_TYPE;					// К приему типа
		break;

	case RX_TYPE:
		rx0type = byt;							// Тип
		rx0ptr = 0;									// Указатель на начало данных
		if (rx0len)
		{
			rx0state = RX_DATA;				// К приему данных
		}
		else
		{
			rx0state = RX_CRC; 				// К приему контрольной суммы
		}
		break;

	case RX_DATA:
		if (rx0ptr > (COMBUFSIZ-1))
		{
			rx0state = RX_HDR;				// Если пакет слишком длинный - отвергаю и иду в начало
			break;
		}
		rx0buf[rx0ptr++] = byt;				// Данные
		if (rx0ptr < rx0len)						// Еще не все ?
		{
			break;
		}
		rx0state = RX_CRC;					// К приему контрольной суммы
		break;

	case RX_CRC:
		if (byt != rx0crc)
		{
			rx0state = RX_HDR;				// Не сошлась CRC - игнорирую пакет и жду следующий
		}
// убрал фильтр адреса
else
{
rx0buf[rx0ptr++] = byt;						// Данные
rx0state = RX_OK;								// Принят пакет, на который нужно ответить
}
/*		else if ((rx0addr == my_addr) || (rx0addr == TO_ALL))
		{
 			rx0buf[rx0ptr++] = byt;			// Данные
    		rx0state = RX_OK;				// Принят пакет, на который нужно ответить
		}
		else
		{
			rx0state = RX_HDR;				// Принят пакет, адресованный не мне - жду следующего
		}*/
		TIMSK &= 0x10 ^ 0xFF;				// Запретить прерывание по тайм-ауту
		break;
		
//	case RX_BUSY:							// Запрос принят, но ответ еще не готов
		break;
		
	default:											// Ошибочное состояние
		rx0state = RX_HDR;					// Перехожу на начало
		break;
	}

	rx0crc += byt;								// Подсчитываю контрольную сумму
}

// Прерывание по сравнению A таймера 1 для подсчета тайм-аута приема "внешнего" канала
interrupt [TIM1_COMPA] void timer1_comp_a_isr(void)
{
	rx0state = RX_HDR;						// По тайм-ауту перехожу к началу приема нового пакета
	TIMSK &= 0x10 ^ 0xFF;					// Больше не генерировать прерываний
}

unsigned char HaveIncomingPack(void)
{
	if (rx0state == RX_OK)	return 255;
	else					return 0;
}

unsigned char IncomingPackType(void)
{
	return rx0type;
}

void DiscardIncomingPack(void)
{
	rx0state = RX_HDR;						// Разрешаю прием следующего пакета
}

// Настройка приемопередатчика
void CommInit(void)
{
	// Подтяжка на TXD
//	DDRD.1 = 0;
//	PORTD.1 = 1;
/*	
// USART0 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART0 Receiver: On
// USART0 Transmitter: On
// USART0 Mode: Asynchronous
// USART0 Baud rate: 38400
UCSR0A=0x00;
UCSR0B=0x18;
UCSR0C=0x06;
UBRR0H=0x00;
UBRR0L=0x0C;
*/


	// Настраиваю UART
	UCSR0A = 0b00000000;
	UCSR0B = 0b10010000;	//0b10011000;
	UCSR0C = 0x86;
	UBRR0L = ((_MCU_CLOCK_FREQUENCY_ / (16 * BAUD)) - 1) & 0xFF;
	UBRR0H = (((_MCU_CLOCK_FREQUENCY_ / (16 * BAUD)) - 1) >> 8) & 0xFF;
	
	// Таймер 1 для подсчета тайм-аутов приема
	TCCR1B  = 0b00000101;
}

void putword0(unsigned short wd)
{
	putchar0(wd);
	putchar0(wd >> 8);
}                                  


// Ретрансляция цикла обмена из внешнего во внутр. канал и обратно
// "Внутренний" канал должен быть свободен

void RelayPack(void)
{
	register unsigned char i,a;
 LedRed();	
	// Передаю запрос
	StartIntReq(rx0len);
	
	// Тело пакета
	for (i = 0; i < rx0len; i ++)
	{
		twi_byte(rx0buf[i]);   
		tx1crc +=(rx0buf[i]);
	}
	
	// Окончание запроса
	EndIntReq();
	DiscardIncomingPack();        // разрешаем принимать след. пакет

	delay_ms (10);						// принимаем ответ

/*	if ((rx0buf[0] == TO_MON) || (rx0buf[0] == TO_MON))       // если пакет послан всем - принимаем ответ по очереди
		{
			for (a=1; a<= int_Devices; a++) pingPack (a);	
		}
	else	pingPack (rx0buf[0]);*/

//	pingPack (4);	

} 
  
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 
// Связь с внешним миром

#include <Coding.h>

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

// Коды статуса
#define	MTX_ADR_ACK		0x18
#define	MRX_ADR_ACK		0x40
#define	MTX_DATA_ACK	0x28
#define	MRX_DATA_NACK	0x58
#define	MRX_DATA_ACK	0x50

// Подготовка аппаратного мастера I2C
void twi_init (void)
{
	TWSR=0x00;
	TWBR=0x20;
	TWAR=0x00;
	TWCR=0x04;
}

// Жду флажка окончания текущей операции
static void twi_wait_int (void)
{

	while (!(TWCR & (1<<TWINT)))
		{
			   if ( flagTWI & ( 1<< time_is_Out))  break;  // выходим по тайм - ауту
		}; 
}

// Стартовое условие
// Возвращает не 0, если все в порядке
unsigned char twi_start (void)
{
	TWCR = ((1<<TWINT)+(1<<TWSTA)+(1<<TWEN));
	
	twi_wait_int();

    if((TWSR != START)&&(TWSR != REP_START))
    {
		return 0;
	}
	
	return 255;
}

// Стоповое условие
void twi_stop (void)
{
	TWCR = ((1<<TWEN)+(1<<TWINT)+(1<<TWSTO));
}

// Передача адреса
// Возвращает не 0, если все в порядке
unsigned char twi_addr (unsigned char addr)
{
	twi_wait_int();

	TWDR = addr;
	TWCR = ((1<<TWINT)+(1<<TWEN));

	twi_wait_int();                 		// Ждем отклик 

	if((TWSR != MTX_ADR_ACK)&&(TWSR != MRX_ADR_ACK))
	{
		return 0;
	}
	return 255;
}

// Передача байта данных
// Возвращает не 0, если все в порядке
unsigned char twi_byte (unsigned char data)
{
	twi_wait_int();

	TWDR = data;
 	TWCR = ((1<<TWINT)+(1<<TWEN));

	twi_wait_int();

	if(TWSR != MTX_DATA_ACK)
	{
		return 0;
	}
		
	return 255;
}

// Чтение байта 
// Возвращает не 0, если все в порядке
unsigned char  twi_read (unsigned char notlast)
{
	timeOut ();									// запускаем тайм аут

	twi_wait_int();   

	if(notlast)     // формируем подтверждение приема
		{
			TWCR = ((1<<TWINT)+(1<<TWEA)+(1<<TWEN));
		}
		else            // НЕ формируем подтверждение приема
		{
			TWCR = ((1<<TWINT)+(1<<TWEN));
		}
 	twi_wait_int();    

 	timeOutStop ();							// останов таймера таймаута   

		return TWDR;
}

// Изменение значения бита порта
static inline void PortBitChange(unsigned char port, unsigned char bnum, unsigned char set)
{
	register unsigned char mask;
	#asm("cli");

	mask = 1 << bnum;		// Маска
	if (!set)
	{
		mask ^= 0xFF;
	}
		
	switch(port)
	{
	case 'B':
		if (set) PORTB |= mask; else PORTB &= mask;
		break;
	case 'C':
		if (set) PORTC |= mask; else PORTC &= mask;
		break;
	case 'D':
		if (set) PORTD |= mask; else PORTD &= mask;
		break;
	}
	
	#asm("sei");
}

// Передача таблицы из FLASH в I2C
void i2c_tab (flash unsigned char * tbl, void (* rwfunc)(void))
{
	register unsigned char n, p;
	register flash unsigned char * ptr;
	
	while(1)
	{
		if (rwfunc)			// Если нужно, запускаю ожидание готовности
		{
			(*rwfunc)();
		}
		
		n = *tbl++;
		
		if (!n)				// Если больше нечего передавать ...
		{
			return;
		}

		if (n == 255)		// Если признак бита порта процессора ...
		{
			p = *tbl++;						// Порт B, C или D
			n = *tbl++;						// Номер бита
			PortBitChange(p, n, *tbl++);	// Взвести или сбросить
			continue;						// К следующей строке
		}

		n = n - 2;
		
		ptr = tbl;
		while(1)
		{
			if (!twi_start())
			{
				twi_stop();
				continue;
			}
	
			if (!twi_addr(*tbl++))
			{
				twi_stop();
				tbl = ptr;
				continue;
			}
		
			break;
		}
		
		twi_byte(*tbl++);
		
		while(n--)
		{
			twi_byte(*tbl++);
		}
		
		twi_stop();
	}
}

/*
// Передача в заданный адрес I2C nbytes байт
void i2c_bytes (unsigned char addr, unsigned char sbaddr, unsigned char nbytes, ...)
{
	va_list argptr;
	char byt;
	
	va_start(argptr, nbytes);
	
	while(1)
	{
		if (!twi_start())
		{
			twi_stop();
			continue;
		}
	
		if (!twi_addr(addr))
		{
			twi_stop();
			continue;
		}
		
		break;
	}
	
	twi_byte(sbaddr);

	while(nbytes--)
	{
		byt = va_arg(argptr, char);
		twi_byte(byt);
	}		
	va_end(argptr);
		
	twi_stop();
}
*/

// Передача в заданный адрес I2C таблицы PSI
void i2c_psi_table (
		unsigned char addr,
		unsigned char sbaddr,
		unsigned char tblnum,
		unsigned short pid,
		unsigned char * buf)
{
	unsigned char n;
	
	pid &= 0x1FFF;
	pid |= 0x4000;

	while(1)
	{	
		if (!twi_start())
		{
			twi_stop();
			continue;
		}
		
		if (!twi_addr(addr))
		{
			twi_stop();
			continue;
		}
		
		break;
	}
		
	twi_byte(sbaddr);
	
	twi_byte(tblnum);

	twi_byte(0x47);			// Заголовок пакета
	twi_byte(pid >> 8);	
	twi_byte(pid & 0xFF);	
	twi_byte(0x10);	
	twi_byte(0x00);	
	
	for (n = buf[2] + 3; n != 0; n --)
	{
		twi_byte(*buf++);
	}
	
	twi_stop();
}
     
////////////////////////////////////////////////////////////////////////////////
// Работа с внутренним каналом

unsigned char tx1crc;
unsigned char rx1state = RX_IDLE;
unsigned char rx1crc;
unsigned char rx1len;
unsigned char rx1buf[256];
unsigned char rx1ptr;

/*// Передача байта во "внутренний" канал
void putword1(unsigned int wd)
{
	putchar1(wd);
	putchar1(wd >> 8);
} */

// Начало запроса во внутренний канал
void StartIntReq(unsigned char dlen) 
{
	while(1)
	{	
		if (!twi_start())       // Cтарт пакета
		{
			twi_stop();
			continue;
		}

		
		if (!twi_addr(0))       // Передача всем подчиненным
		{
			twi_stop();
			continue;
		}
		
		break;
	}


	tx1crc = 0;					// Готовлю CRC

	twi_byte(PACKHDR);		    // Передаю заголовок
	tx1crc+=(PACKHDR);

	twi_byte(dlen+1);			// Передаю длину
	tx1crc+=(dlen+1);
}

// Завершение запроса во внутренний канал
void EndIntReq(void)
{
	twi_byte(tx1crc);			// Контрольная сумма
	twi_stop();                 // Cтоп

	
//	rx1state = RX_LEN;			// Приемнику начать прием пакета

//	OCR1B = TCNT1+RX1TIMEOUT;	// Взвожу тайм-аут
//	TIFR = 0x08;				// Предотвращаю ложное срабатывание
//	TIMSK |= 0x08;				// Разрешение прерывания по тайм-ауту
}

// Прием байта из "внутреннего" канала TWI
void TWI_rx_isr(void)
{
	register unsigned char byt;
	twi_start();                //Запрашиваю байт ответа
    	
    
	byt = UDR1;
	
	switch (rx1state)
	{
	case RX_LEN:				// Принята длина пакета
		rx1crc = 0;
		rx1ptr = 0;
		rx1len = byt - 1;
		if (rx1len)
		{
			rx1state = RX_DATA;
		}
		else
		{
			rx1state = RX_CRC;
		}
//printf("L%d", rx1len);
		break;

	case RX_DATA:				// Принят байт данных пакета
//printf("D");
		rx1buf[rx1ptr++] = byt;
		if (rx1ptr < rx1len)	// Уже все ?
		{
			break;
		}
		rx1state = RX_CRC;
		break;
		
	case RX_CRC:				// Принята контрольная сумма пакета
		if (byt != rx1crc)
		{
			rx1state = RX_ERR;	// Не сошлась CRC
//printf("C");
		}
		else
		{
			rx1state = RX_OK;	// Пакет успешно принят
//printf("+");
		}

		TIMSK &= 0x08 ^ 0xFF;	// Запретить прерывание по тайм-ауту
		break;

	default:					// В остальных состояниях - ничего не делать
		break;
	}

	rx1crc += byt;				// Подсчитываю контрольную сумму
} 

// Прерывание по сравнению B таймера 1 для подсчета тайм-аута приема "внутреннего" канала
interrupt [TIM1_COMPB] void timer1_comp_b_isr(void)
{
	rx1state = RX_TIME;		// Был тайм-аут
	TIMSK &= 0x08 ^ 0xFF;	// Запретить прерывание по тайм-ауту
//printf("T");
}

// Проверка занятости "внутреннего" канала
unsigned char InternalComBusy(void)
{
	if (rx1state != RX_IDLE)	return 1;
	else						return 0;
}

// Признак завершения цикла обмена во внутрю канале
unsigned char HaveInternalReply(void)
{
	switch(rx1state)
	{
	case RX_OK:
	case RX_TIME:
	case RX_ERR:
		return rx1state;
	default:
		return 0;
	}
}

// Необходимо вызвать после завершения обработки принятого по "внутреннему" каналу пакета
void FreeInternalCom(void)
{
	rx1state = RX_IDLE;
}

// Передача байта byte по pAddr
unsigned char txTWIbyte (unsigned char pAddr, unsigned char byte)
	{  

		timeOut ();									// запускаем тайм аут

		if (!twi_start())     		  				// Cтарт пакета
			{
				twi_stop();
			}
		
		if (!twi_addr((pAddr<<1)+0))       // Передача  по адресу pAddr (мл 0 - запись)
			{
				twi_stop();
			}            
			
		twi_byte(byte);								// передаем байт
		twi_stop();									// стоп пакета

		timeOutStop ();							// останов таймера таймаута   
		
	    if ( ! ( flagTWI & ( 1 << time_is_Out))) return 255;
	    	else 
	    		{
					flagTWI  = flagTWI  ^ (1 << time_is_Out);	//сбрасываем  признак
					return 0;
	    		}
	}

unsigned char txTWIbuff (unsigned char pAddr)
	{                                                                           
		unsigned char a ;
		
		timeOut ();									// запускаем тайм аут
		if (!twi_start())     		  				// Cтарт пакета
			{
				twi_stop();
			}

		if (!twi_addr((pAddr<<1)+0))       // Передача  по адресу pAddr (мл 0 - запись)
			{
				twi_stop();
			}            

	twi_wait_int(); 					// ждем отклик на адрес

		for (a=0;a<=txBuffer[1]+1;a++)     //длина+заголовок
			{		                         
				twi_byte(txBuffer[a]);				// передаем байт
			}		

			twi_stop();									// стоп пакета
			timeOutStop ();							// останов таймера таймаута   
		
	    	if ( ! ( flagTWI & ( 1 << time_is_Out))) return 255;
	    		else 
	    			{
						flagTWI  = flagTWI  ^ (1 << time_is_Out);	//сбрасываем  признак
						return 0;
		    		}
	}
	

// Вычитываем в буффер
unsigned char rxTWIbuff (unsigned char pAddr)
		{                                                         
		unsigned char a;

		if (!twi_start())     		  				// Cтарт пакета
			{
				twi_stop();
			}

		if (!twi_addr((pAddr<<1)+1))       // Передача  по адресу pAddr (мл 1 - чтение)
			{
				twi_stop();
			}            

		rxBuffer[0] = twi_read(1);				// читаем  и запоминаем  длину принимаемого пакета

		for (a=1; a<rxBuffer[0];  a++)
			{
				rxBuffer[a] = twi_read(1);			// не посл. байт - формируем ACK
			}              

				rxBuffer[a] = twi_read(0);			// посл. байт -  не формируем ACK

			twi_stop();									// стоп пакета               
			
						// Проверяем таймаут и CRC
	    	if ( (! ( flagTWI & ( 1 << time_is_Out))) && (rxCRC())) return 255;	//Ok
    		else 
	    			{
						flagTWI  = flagTWI  ^ (1 << time_is_Out);		//сбрасываем  признак
						return 0;                                                          // Time Out
		    		}
		}
#include "Coding.h"

unsigned char flagTWI				=	0;
unsigned char int_Devices		=	0;			// количество подчиненных устройств



// Инициализация выводов
void portInit (void)
		{
			DDRB.7 = 1;		// testpin
			CS_DDR_SET();	// для CF Card
		}



// -------------------- Функции работы с таймером 0 -------------------------------
///////////////////////////////////////////////////////////////////////////////////////////////
// Timer/Counter 0 initialization ; Clock source: System Clock
// Clock value: 31,250 kHz ;  Mode: Normal top=FFh
///////////////////////////////////////////////////////////////////////////////////////////////
void timer_0_Init  (void)
	{
		ASSR=0x00;
		TCCR0=0x0;        //0x06 -start
		TCNT0=0x01;
		OCR0=0x00;

		TIMSK=0x01;			// Timer(s)/Counter(s) Interrupt(s) initialization
		ETIMSK=0x00;

	}

// запускаем таймер для таймаута
void timeOut (void)
	{
//		flagTWI  = (flagTWI  ^ (1 << time_is_Out));		// сброс признака
		TCNT0=0x0	;														// обнуляем счетчик
		TCCR0 = 0x06;													// пускаем таймер (около 10 мс)
	}

// остановка таймера для таймаута
void timeOutStop (void)
	{
		TCCR0 = 0x0; 						// осттанов таймера (около 10 мс)
	}


// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
		TCCR0 = 0x0;						//останавливаем таймер
		flagTWI  = flagTWI  | (1 << time_is_Out);	 //взводим признак    

}
                                                                                             
// Проверяем количество подчиненных устройств
void verIntDev (void)
	{
		unsigned char a;
		for (a=1; a<10;a++)				// сканируем количество подчиненных устройств 
			{											//  адреса начинаются с 1
				if (!(txTWIbyte ( a, 0xaa))) break;   
			}
        int_Devices = a-1;
		lAddrDevice[0] = lAddrDevice;	// запоминаем кол-во портов 232
	}     
	
// считаем КС принятого пакета
unsigned char rxCRC (void)
	{                    
		unsigned char KS = 0, a;		
			for (a=0; a< rxBuffer [0] ;a++)
				{
					KS =KS+rxBuffer [a];
				}                                     
			if (KS == rxBuffer [a]) return 255; 	//Ok
			else return 0;                                         // Error
		
	}	        

// вычитываем логические адреса устройств
void ReadLogAddr (void)
		{          
		unsigned char b;
		
					txBuffer[0] = 'q';								// заголовок
					txBuffer[1] = 3;		                 		// длина
					txBuffer[2] = 0;                   		// адрес
					txBuffer[3] = GetLogAddr;       		// тип
					txBuffer[4] = 'q'+3+0+GetLogAddr; 		//KC

					txTWIbuff (0);		//передаем всем
//					delay_ms (20);          
					delay_ms (5);          

for (b=1; b<= int_Devices; b++)
	{
//					txTWIbuff (b);		//передаем 
//					delay_ms (10);          
					rxTWIbuff (b);
					lAddrDevice [b] = rxBuffer[1];		// запоминаем лог. адреса портов       
     }
				
}  

// ретранслируем пакет
void		recompPack (unsigned char device)
	{
		unsigned char a, b=0;
					txBuffer[0] = PACKHDR;				// заголовок
					txBuffer[1] = rx0len+3;            		// длина (+3 - тк. вычлось при приеме)
					txBuffer[2] = rx0addr;                 	// адрес
					txBuffer[3] = rx0type;					// тип

					for (a=4; a<=(rx0len+4); a++)
						{
							txBuffer[a] = rx0buf 	[b++];				
						}                   

					txTWIbuff (device);								//передаем 
					delay_ms (10);


	}
	
// пингуем подчиненное для проверки информации
void pingPack (unsigned char device)
	{
	unsigned char a;
			
/*					txBuffer[0] = 'q';									// заголовок
					txBuffer[1] = 3;                 					// длина
					txBuffer[2] = 0;                   				// адрес
					txBuffer[3] = pingPacket;       				// тип
					txBuffer[4] = 'q'+3+0+pingPacket; 		// KC

					txTWIbuff (device);								// передаем 

//					delay_ms (20);          */
//					delay_ms (10);          

					rxTWIbuff (device);                  			// принимаем

					if (rxBuffer[0] )
						{
						UCSR0B.3 = 1;								// Разрешаю передатчик
                            	for (a=0;a<=rxBuffer[0];a++)
									{
										putchar0 (rxBuffer [a]);
									}     
						rx0state = RX_HDR;					// Разрешаю прием след. запроса
						
						}          
	
	
	}
	

	
	


#include "Coding.h"

void flash_Work (void)
	{  
		unsigned char a;
		switch(rx0buf[0])
			{
				case PT_Fcreate: 		// создать и открыть файл
					{       
LedRed();

						pntr1 = fcreate(str->fname, 0); 

						if (!(pntr1)) putchar (0); 						// если не могу создать файл то возращаем 0
						else putchar (0x255);

//						fputc('S', pntr1);      // write an ‘S’ to the file, increment file pointer */ 
//						fputs(str->fname, pntr1);    // add “Hello World!\r\n” to the end of the file 
 
						break;
					}
				case PT_Fopen: 		// открыть файл
					{       
					
						break;
					}

				case PT_Fclose:
					{
LedRed();
					    fclose(pntr1);     							   	// Close          

						if (!(pntr1)) putchar (0); 						// если не могу создать файл то возращаем 0
						else putchar (0x255);
						break;
					}

				case PT_Fremove:
					{
						break;
					}

				case PT_Frename:
					{
						break;
					}

				case PT_Ffseek:
					{
						break;
					}

				case PT_Fformat:
					{
						fquickformat();    			// Delete all information on the card 
						break;
					}

				case PT_Fadd:
					{
LedRed();
//						fputs(str1->dataFlash, pntr1);    // add “Hello World!\r\n” to the end of the file 
//						fprintf(pntr1, "%x",11);  			// output the string to the file

//						strcpyf (a,0x31);
						fflush (pntr1);

						if (!(pntr1)) putchar (0); 						// если не могу создать файл то возращаем 0
						else putchar (0x255);
						break;
					}

    		}
	rx0state = RX_HDR;						// Разрешаю прием след. запроса
	}



	
/*
	Progressive Resources LLC
                                    
			FlashFile
	
	Version : 	1.32
	Date: 		12/31/2003
	Author: 	Erick M. Higa
                                           
	Software License
	The use of Progressive Resources LLC FlashFile Source Package indicates 
	your understanding and acceptance of the following terms and conditions. 
	This license shall supersede any verbal or prior verbal or written, statement 
	or agreement to the contrary. If you do not understand or accept these terms, 
	or your local regulations prohibit "after sale" license agreements or limited 
	disclaimers, you must cease and desist using this product immediately.
	This product is © Copyright 2003 by Progressive Resources LLC, all rights 
	reserved. International copyright laws, international treaties and all other 
	applicable national or international laws protect this product. This software 
	product and documentation may not, in whole or in part, be copied, photocopied, 
	translated, or reduced to any electronic medium or machine readable form, without 
	prior consent in writing, from Progressive Resources LLC and according to all 
	applicable laws. The sole owner of this product is Progressive Resources LLC.

	Operating License
	You have the non-exclusive right to use any enclosed product but have no right 
	to distribute it as a source code product without the express written permission 
	of Progressive Resources LLC. Use over a "local area network" (within the same 
	locale) is permitted provided that only a single person, on a single computer 
	uses the product at a time. Use over a "wide area network" (outside the same 
	locale) is strictly prohibited under any and all circumstances.
                                           
	Liability Disclaimer
	This product and/or license is provided as is, without any representation or 
	warranty of any kind, either express or implied, including without limitation 
	any representations or endorsements regarding the use of, the results of, or 
	performance of the product, Its appropriateness, accuracy, reliability, or 
	correctness. The user and/or licensee assume the entire risk as to the use of 
	this product. Progressive Resources LLC does not assume liability for the use 
	of this product beyond the original purchase price of the software. In no event 
	will Progressive Resources LLC be liable for additional direct or indirect 
	damages including any lost profits, lost savings, or other incidental or 
	consequential damages arising from any defects, or the use or inability to 
	use these products, even if Progressive Resources LLC have been advised of 
	the possibility of such damages.
*/                                 

/*
#include _AVR_LIB_
#include <stdio.h>

#ifndef _file_sys_h_
	#include "..\flash\file_sys.h"
#endif
*/
	#include <coding.h>

unsigned long OCR_REG;
unsigned char _FF_buff[512];
unsigned int PT_SecStart;
unsigned long BS_jmpBoot;
unsigned int BPB_BytsPerSec;
unsigned char BPB_SecPerClus;
unsigned int BPB_RsvdSecCnt;
unsigned char BPB_NumFATs;
unsigned int BPB_RootEntCnt;
unsigned int BPB_FATSz16;
unsigned char BPB_FATType;
unsigned long BPB_TotSec;
unsigned long BS_VolSerial;
unsigned char BS_VolLab[12];
unsigned long _FF_PART_ADDR, _FF_ROOT_ADDR, _FF_DIR_ADDR;
unsigned long _FF_FAT1_ADDR, _FF_FAT2_ADDR;
unsigned long _FF_RootDirSectors;
unsigned int FirstDataSector;
unsigned long FirstSectorofCluster;
unsigned char _FF_error;
unsigned long _FF_buff_addr;
extern unsigned long clus_0_addr, _FF_n_temp;
extern unsigned int c_counter;
//extern unsigned char _FF_FULL_PATH[_FF_PATH_LENGTH];

unsigned long DataClusTot;

flash struct CMD
{
	unsigned int index;
	unsigned int tx_data;
	unsigned int arg;
	unsigned int resp;
};

flash struct CMD sd_cmd[CMD_TOT] =
{
	{CMD0,	0x40,	NO_ARG,		RESP_1},		// GO_IDLE_STATE
	{CMD1,	0x41,	NO_ARG,		RESP_1},		// SEND_OP_COND (ACMD41 = 0x69)
	{CMD9,	0x49,	NO_ARG,		RESP_1},		// SEND_CSD
	{CMD10,	0x4A,	NO_ARG,		RESP_1},		// SEND_CID
	{CMD12,	0x4C,	NO_ARG,		RESP_1},		// STOP_TRANSMISSION
	{CMD13,	0x4D,	NO_ARG,		RESP_2},		// SEND_STATUS
	{CMD16,	0x50,	BLOCK_LEN,	RESP_1},		// SET_BLOCKLEN
	{CMD17, 0x51,	DATA_ADDR,	RESP_1},		// READ_SINGLE_BLOCK
	{CMD18, 0x52,	DATA_ADDR,	RESP_1},		// READ_MULTIPLE_BLOCK
	{CMD24, 0x58,	DATA_ADDR,	RESP_1},		// WRITE_BLOCK
	{CMD25, 0x59,	DATA_ADDR,	RESP_1},		// WRITE_MULTIPLE_BLOCK
	{CMD27,	0x5B,	NO_ARG,		RESP_1},		// PROGRAM_CSD
	{CMD28, 0x5C,	DATA_ADDR,	RESP_1b},		// SET_WRITE_PROT
	{CMD29, 0x5D,	DATA_ADDR,	RESP_1b},		// CLR_WRITE_PROT
	{CMD30, 0x5E,	DATA_ADDR,	RESP_1},		// SEND_WRITE_PROT
	{CMD32,	0x60,	DATA_ADDR,	RESP_1},		// TAG_SECTOR_START
	{CMD33,	0x61,	DATA_ADDR,	RESP_1},		// TAG_SECTOR_END
	{CMD34,	0x62,	DATA_ADDR,	RESP_1},		// UNTAG_SECTOR
	{CMD35,	0x63,	DATA_ADDR,	RESP_1},		// TAG_ERASE_GROUP_START
	{CMD36,	0x64,	DATA_ADDR,	RESP_1},		// TAG_ERASE_GROUP_END
	{CMD37,	0x65,	DATA_ADDR,	RESP_1},		// TAG_ERASE_GROUP
	{CMD38,	0x66,	STUFF_BITS,	RESP_1b},		// ERASE
	{CMD42,	0x6A,	STUFF_BITS,	RESP_1b},		// LOCK_UNLOCK
	{CMD58,	0x7A,	NO_ARG,		RESP_3},		// READ_OCR
	{CMD59,	0x7B,	STUFF_BITS,	RESP_1},		// CRC_ON_OFF
	{ACMD41, 0x69,	NO_ARG,		RESP_1}
};

unsigned char _FF_spi(unsigned char mydata)
{
    SPDR = mydata;          //byte 1
    while ((SPSR&0x80) == 0); 
    return SPDR;
}
	
unsigned int send_cmd(unsigned char command, unsigned long argument)
{
	unsigned char spi_data_out;
	unsigned char response_1;
	unsigned long response_2;
	unsigned int c, i;
	
	SD_CS_ON();			// select chip
	
	spi_data_out = sd_cmd[command].tx_data;
	_FF_spi(spi_data_out);
	
	c = sd_cmd[command].arg;
	if (c == NO_ARG)
		for (i=0; i<4; i++)
			_FF_spi(0);
	else
	{
		spi_data_out = (argument & 0xFF000000) >> 24;
		_FF_spi(spi_data_out);
		spi_data_out = (argument & 0x00FF0000) >> 16;
		_FF_spi(spi_data_out);
		spi_data_out = (argument & 0x0000FF00) >> 8;
		_FF_spi(spi_data_out);
		spi_data_out = (argument & 0x000000FF);
		_FF_spi(spi_data_out);
	}
	if (command == CMD0)
		spi_data_out = 0x95;		// CRC byte, don't care except for first signal=0x95
	else
		spi_data_out = 0xFF;
	_FF_spi(spi_data_out);
	_FF_spi(0xff);	
	c = sd_cmd[command].resp;
	switch(c)
	{
		case RESP_1:
			return (_FF_spi(0xFF));
			break;
		case RESP_1b:
			response_1 = _FF_spi(0xFF);
			response_2 = 0;
			while (response_2 == 0)
				response_2 = _FF_spi(0xFF);
			return (response_1);
			break;
		case RESP_2:
			response_2 = _FF_spi(0xFF);
			response_2 = (response_2 << 8) | _FF_spi(0xFF);
			return (response_2);
			break;
		case RESP_3:
			response_1 = _FF_spi(0xFF);
			OCR_REG = 0;
			response_2 = _FF_spi(0xFF);
			OCR_REG = response_2 << 24;
			response_2 = _FF_spi(0xFF);
			OCR_REG |= (response_2 << 16);
			response_2 = _FF_spi(0xFF);
			OCR_REG |= (response_2 << 8);
			response_2 = _FF_spi(0xFF);
			OCR_REG |= (response_2);
			return (response_1);
			break;
	}
	return (0);
}

void clear_sd_buff(void)
{
	SD_CS_OFF();
	_FF_spi(0xFF);
	_FF_spi(0xFF);
}	

unsigned char initialize_media(void)
{
	unsigned char data_temp;
	unsigned long n;
	
	// SPI BUS SETUP
	// SPI initialization
	// SPI Type: Master
	// SPI Clock Rate: 921.600 kHz
	// SPI Clock Phase: Cycle Half
	// SPI Clock Polarity: Low
	// SPI Data Order: MSB First
	DDRB |= 0x07;		// Set SS, SCK, and MOSI to Output (If not output, processor will be a slave)
	DDRB &= 0xF7;		// Set MISO to Input
	CS_DDR_SET();		// Set CS to Output
	SPCR=0x50;
	SPSR=0x00;
		
	BPB_BytsPerSec = 512;	// Initialize sector size to 512 (all SD cards have a 512 sector size)
    _FF_n_temp = 0;
	if (reset_sd()==0)
		return (0);
	// delay_ms(50);
	for (n=0; ((n<100)||(data_temp==0)) ; n++)
	{
		SD_CS_ON();
		data_temp = _FF_spi(0xFF);
		SD_CS_OFF();
	}
	// delay_ms(50);
	for (n=0; n<100; n++)
	{
		if (init_sd())		// Initialization Succeeded
			break;
		if (n==99)
			return (0);
	}

	if (_FF_read(0x0)==0)
	{
		#ifdef _DEBUG_ON_
			printf("\n\rREAD_ERR"); 		
		#endif
		_FF_error = INIT_ERR;
		return (0);
	}
	PT_SecStart = ((int) _FF_buff[0x1c7] << 8) | (int) _FF_buff[0x1c6];
	
	if ((((_FF_buff[0]==0xEB)&&(_FF_buff[2]==0x90))||(_FF_buff[0]==0xE9)) && ((_FF_buff[510]==0x55)&&(_FF_buff[511]==0xAA)))
    	PT_SecStart = 0;
 
	_FF_PART_ADDR = (long) PT_SecStart * (long) BPB_BytsPerSec;

	if (PT_SecStart)
	{
		if (_FF_read(_FF_PART_ADDR)==0)
		{
		   	#ifdef _DEBUG_ON_
				printf("\n\rREAD_ERR");
			#endif
			_FF_error = INIT_ERR;
			return (0);
		}
	}

 	#ifdef _DEBUG_ON_
		printf("\n\rBoot_Sec: [0x%X %X %X] [0x%X] [0x%X]", _FF_buff[0],_FF_buff[1],_FF_buff[2],_FF_buff[510],_FF_buff[511]); 		
	#endif
   	
    BS_jmpBoot = (((long) _FF_buff[0] << 16) | ((int) _FF_buff[1] << 8) | (int) _FF_buff[2]);    		
	BPB_BytsPerSec = ((int) _FF_buff[0xC] << 8) | (int) _FF_buff[0xB];
    BPB_SecPerClus = _FF_buff[0xD];
	BPB_RsvdSecCnt = ((int) _FF_buff[0xF] << 8) | (int) _FF_buff[0xE];	
	BPB_NumFATs = _FF_buff[0x10];
	BPB_RootEntCnt = ((int) _FF_buff[0x12] << 8) | (int) _FF_buff[0x11];	
	BPB_FATSz16 = ((int) _FF_buff[0x17] << 8) | (int) _FF_buff[0x16];
	BPB_TotSec = ((unsigned int) _FF_buff[0x14] << 8) | (unsigned int) _FF_buff[0x13];
	if (BPB_TotSec==0)
		BPB_TotSec = ((unsigned long) _FF_buff[0x23] << 24) | ((unsigned long) _FF_buff[0x22] << 16)
					| ((unsigned long) _FF_buff[0x21] << 8) | ((unsigned long) _FF_buff[0x20]);
	BS_VolSerial = ((unsigned long) _FF_buff[0x2A] << 24) | ((unsigned long) _FF_buff[0x29] << 16)
				| ((unsigned long) _FF_buff[0x28] << 8) | ((unsigned long) _FF_buff[0x27]);
	for (n=0; n<11; n++)
		BS_VolLab[n] = _FF_buff[0x2B+n];
	BS_VolLab[11] = 0;		// Terminate the string
	_FF_FAT1_ADDR = _FF_PART_ADDR + ((long) BPB_RsvdSecCnt * (long) BPB_BytsPerSec); 
	_FF_FAT2_ADDR = _FF_FAT1_ADDR + ((long) BPB_FATSz16 * (long) BPB_BytsPerSec);
	_FF_ROOT_ADDR = ((long) BPB_NumFATs * (long) BPB_FATSz16) + (long) BPB_RsvdSecCnt;
	_FF_ROOT_ADDR *= BPB_BytsPerSec;
	_FF_ROOT_ADDR += _FF_PART_ADDR;
	
	_FF_RootDirSectors = ((BPB_RootEntCnt * 32) + BPB_BytsPerSec - 1) / BPB_BytsPerSec;
	FirstDataSector = (BPB_NumFATs * BPB_FATSz16) + BPB_RsvdSecCnt + _FF_RootDirSectors; 
	
	DataClusTot = BPB_TotSec - FirstDataSector;
	DataClusTot /= BPB_SecPerClus;
	clus_0_addr = 0;		// Reset Empty Cluster table location
	c_counter = 1;
	
	if (DataClusTot < 4085)				// FAT12
		BPB_FATType = 0x32;
	else if (DataClusTot < 65525)		// FAT16
		BPB_FATType = 0x36;
	else
	{
		BPB_FATType = 0;
		_FF_error = FAT_ERR;
		return (0);
	}
    
	_FF_DIR_ADDR = _FF_ROOT_ADDR;		// Set current directory to root address

	_FF_FULL_PATH[0] = 0x5C;	// a '\'
	_FF_FULL_PATH[1] = 0;
	
	#ifdef _DEBUG_ON_
		printf("\n\rPart Address:  %lX", _FF_PART_ADDR);
		printf("\n\rBS_jmpBoot:  %lX", BS_jmpBoot);
		printf("\n\rBPB_BytsPerSec:  %X", BPB_BytsPerSec);
		printf("\n\rBPB_SecPerClus:  %X", BPB_SecPerClus);
		printf("\n\rBPB_RsvdSecCnt:  %X", BPB_RsvdSecCnt);
		printf("\n\rBPB_NumFATs:  %X", BPB_NumFATs);
		printf("\n\rBPB_RootEntCnt:  %X", BPB_RootEntCnt);
		printf("\n\rBPB_FATSz16:  %X", BPB_FATSz16);
		printf("\n\rBPB_TotSec16:  %lX", BPB_TotSec);
		if (BPB_FATType == 0x32)
			printf("\n\rBPB_FATType:  FAT12");
		else if (BPB_FATType == 0x36)
			printf("\n\rBPB_FATType:  FAT16");
		else
			printf("\n\rBPB_FATType:  FAT ERROR!!");
		printf("\n\rClusterCnt:  %lX", DataClusTot);
		printf("\n\rROOT_ADDR:  %lX", _FF_ROOT_ADDR);
		printf("\n\rFAT2_ADDR:  %lX", _FF_FAT2_ADDR);
		printf("\n\rRootDirSectors:  %X", _FF_RootDirSectors);
		printf("\n\rFirstDataSector:  %X", FirstDataSector);
	#endif
	
	return (1);	
}

unsigned char spi_speedset(void)
{
	if (SPCR == 0x50)
		SPCR = 0x51;
	else if (SPCR == 0x51)
		SPCR = 0x52;
	else if (SPCR == 0x52)
		SPCR = 0x53;
	else
	{
		SPCR = 0x50;
		return (0);
	}
	return (1);
}

unsigned char reset_sd(void)
{
	unsigned char resp, n, c;

	#ifdef _DEBUG_ON_
		printf("\n\rReset CMD:  ");	
	#endif

	for (c=0; c<4; c++)		// try reset command 3 times if needed
	{
		SD_CS_OFF();
		for (n=0; n<10; n++)	// initialize clk signal to sync card
			_FF_spi(0xFF);
		resp = send_cmd(CMD0,0);
		for (n=0; n<200; n++)
		{
			if (resp == 0x1)
			{
				SD_CS_OFF();
    			#ifdef _DEBUG_ON_
					printf("OK!!!");
				#endif
				SPCR = 0x50;
				return(1);
			}
	      	resp = _FF_spi(0xFF);
		}
		#ifdef _DEBUG_ON_
			printf("ERROR!!!");
		#endif
 		if (spi_speedset()==0)
 		{
		    SD_CS_OFF();
 			return (0);
 		}
	}
	return (0);
}

unsigned char init_sd(void)
{
	unsigned char resp;
	unsigned int c;
	
	clear_sd_buff();

    #ifdef _DEBUG_ON_
		printf("\r\nInitialization:  ");
	#endif
    for (c=0; c<1000; c++)
    {
    	resp = send_cmd(CMD1, 0);
    	if (resp == 0)
    		break;
   		resp = _FF_spi(0xFF);
   		if (resp == 0)
   			break;
   		resp = _FF_spi(0xFF);
   		if (resp == 0)
   			break;
	}
   	if (resp == 0)
	{
		#ifdef _DEBUG_ON_
   			printf("OK!");
	   	#endif
		return (1);
	}
	else
	{
		#ifdef _DEBUG_ON_
   			printf("ERROR-%x  ", resp);
	   	#endif
		return (0);
 	}        		
}

unsigned char _FF_read_disp(unsigned long sd_addr)
{
	unsigned char resp;
	unsigned long n, remainder;
	
	if (sd_addr % 0x200)
	{	// Not a valid read address, return 0
		_FF_error = READ_ERR;
		return (0);
	}

	clear_sd_buff();
	resp = send_cmd(CMD17, sd_addr);		// Send read request
	
	while(resp!=0xFE)
		resp = _FF_spi(0xFF);
	for (n=0; n<512; n++)
	{
		remainder = n % 0x10;
		if (remainder == 0)
			printf("\n\r");
		_FF_buff[n] = _FF_spi(0xFF);
		if (_FF_buff[n]<0x10)
			putchar(0x30);
		printf("%X ", _FF_buff[n]);
	}
	_FF_spi(0xFF);
	_FF_spi(0xFF);
	_FF_spi(0xFF);
	SD_CS_OFF();
	return (1);
}

// Read data from a SD card @ address
unsigned char _FF_read(unsigned long sd_addr)
{
	unsigned char resp;
	unsigned long n;
//printf("\r\nReadin ADDR [0x%lX]", sd_addr);
	
	if (sd_addr % BPB_BytsPerSec)
	{	// Not a valid read address, return 0
		_FF_error = READ_ERR;
		return (0);
	}
		
	for (;;)
	{
		clear_sd_buff();
		resp = send_cmd(CMD17, sd_addr);	// read block command
		for (n=0; n<1000; n++)
		{
			if (resp==0xFE)
			{	// waiting for start byte
				break;
			}
			resp = _FF_spi(0xFF);
		}
		if (resp==0xFE)
		{	// if it is a valid start byte => start reading SD Card
			for (n=0; n<BPB_BytsPerSec; n++)
				_FF_buff[n] = _FF_spi(0xFF);
			_FF_spi(0xFF);
			_FF_spi(0xFF);
			_FF_spi(0xFF);
			SD_CS_OFF();
			_FF_error = NO_ERR;
			_FF_buff_addr = sd_addr;
			SPCR = 0x50;
			return (1);
		}

		SD_CS_OFF();

		if (spi_speedset()==0)
			break;
	}	
	_FF_error = READ_ERR;    
	return(0);
}


#ifndef _READ_ONLY_
unsigned char _FF_write(unsigned long sd_addr)
{
	unsigned char resp, calc, valid_flag;
	unsigned int n;
	
	if ((sd_addr%BPB_BytsPerSec) || (sd_addr <= _FF_PART_ADDR))
	{	// Not a valid write address, return 0
		_FF_error = WRITE_ERR;
		return (0);
	}

//printf("\r\nWriting to address:  %lX", sd_addr);
	for (;;)
	{
		clear_sd_buff();
		resp = send_cmd(CMD24, sd_addr);
		valid_flag = 0;
		for (n=0; n<1000; n++)
		{
			if (resp == 0x00)
			{
				valid_flag = 1;
				break;
			}
			resp = _FF_spi(0xFF);
		}
	
		if (valid_flag)
		{
			_FF_spi(0xFF);
			_FF_spi(0xFE);					// Start Block Token
			for (n=0; n<BPB_BytsPerSec; n++)		// Write Data in buffer to card
				_FF_spi(_FF_buff[n]);
			_FF_spi(0xFF);					// Send 2 blank CRC bytes
			_FF_spi(0xFF);
			resp = _FF_spi(0xFF);			// Response should be 0bXXX00101
			calc = resp | 0xE0;
			if (calc==0xE5)
			{
				while(_FF_spi(0xFF)==0)
					;	// Clear Buffer before returning 'OK'
				SD_CS_OFF();
//				SPCR = 0x50;			// Reset SPI bus Speed
				_FF_error = NO_ERR;
				return(1);
			}
		}
		SD_CS_OFF(); 

		if (spi_speedset()==0)
			break;
		// delay_ms(100);		
	}
	_FF_error = WRITE_ERR;
	return(0x0);
}
#endif
/*
	Progressive Resources LLC
                                    
			FlashFile
	
	Version : 	1.32
	Date: 		12/31/2003
	Author: 	Erick M. Higa
	
	Revision History:
	12/31/2003 - EMH - v1.00 
			   	 	 - Initial Release
	01/19/2004 - EMH - v1.10
			   	 	 - fixed FAT access errors by allowing both FAT tables to be updated
					 - fixed erase_cluster chain to stop if chain goes to '0'
					 - fixed #include's so other non m128 processors could be used
					 - fixed fcreate to match 'C' standard for function "creat"
					 - fixed fseek so it would not error when in "READ" mode
					 - modified SPI interface to use _FF_spi() so it is more universal
					   (see the "sd_cmd.c" file for the function used)
					 - redifined global variables and #defines for more unique names
					 - added string functions fputs, fputsc, & fgets
					 - added functions fquickformat, fgetfileinfo, & GetVolID()
					 - added directory support
					 - modified delays in "sd_cmd.c" to increase transfer speed to max
					 - updated "options.h" to include additions, and to make #defines 
					   more universal to multiple platforms
	01/21/2004 - EMH - v1.20
			   	 	 - Added ICC Support to the FlashFileSD
					 - fixed card initialization error for MMC/SD's that have only a boot 
			   	 	   sector and no partition table
					 - Fixed intermittant error on fcreate when creating existing file
					 - changed "options.h" to #include all required files
	02/19/2004 - EMH - v1.21
					 - Replaced all "const" refrances to "flash" to support CodeVision 1.24.1b
	03/02/2004 - EMH - v1.22 (unofficial release)
					 - Changed Directory Functions to allow for multi-cluster directory entries
					 - Added function addr_to_clust() to support long directories
					 - Fixed FAT table address calculation to support multiple reserved sectors
					   (previously) assumed one reserved sector, if XP formats card sometimes 
					   multiple reserved sectors - thanks YW
	03/10/2004 - EMH - v1.30
					 - Added support for a Compact Flash package
					 - Renamed read and write to flash function names for multiple media support	
	03/26/2004 - EMH - v1.31
					 - Added define for easy MEGA128Dev board setup
					 - Changed demo projects so "option.h" is in the project directory	
	04/01/2004 - EMH - v1.32
					 - Fixed bug in "prev_cluster()" that didn't use updated FAT table address
					   calculations.  (effects XP formatted cards see v1.22 notes)
                                           
	Software License
	The use of Progressive Resources LLC FlashFile Source Package indicates 
	your understanding and acceptance of the following terms and conditions. 
	This license shall supersede any verbal or prior verbal or written, statement 
	or agreement to the contrary. If you do not understand or accept these terms, 
	or your local regulations prohibit "after sale" license agreements or limited 
	disclaimers, you must cease and desist using this product immediately.
	This product is © Copyright 2003 by Progressive Resources LLC, all rights 
	reserved. International copyright laws, international treaties and all other 
	applicable national or international laws protect this product. This software 
	product and documentation may not, in whole or in part, be copied, photocopied, 
	translated, or reduced to any electronic medium or machine readable form, without 
	prior consent in writing, from Progressive Resources LLC and according to all 
	applicable laws. The sole owner of this product is Progressive Resources LLC.

	Operating License
	You have the non-exclusive right to use any enclosed product but have no right 
	to distribute it as a source code product without the express written permission 
	of Progressive Resources LLC. Use over a "local area network" (within the same 
	locale) is permitted provided that only a single person, on a single computer 
	uses the product at a time. Use over a "wide area network" (outside the same 
	locale) is strictly prohibited under any and all circumstances.
                                           
	Liability Disclaimer
	This product and/or license is provided as is, without any representation or 
	warranty of any kind, either express or implied, including without limitation 
	any representations or endorsements regarding the use of, the results of, or 
	performance of the product, Its appropriateness, accuracy, reliability, or 
	correctness. The user and/or licensee assume the entire risk as to the use of 
	this product. Progressive Resources LLC does not assume liability for the use 
	of this product beyond the original purchase price of the software. In no event 
	will Progressive Resources LLC be liable for additional direct or indirect 
	damages including any lost profits, lost savings, or other incidental or 
	consequential damages arising from any defects, or the use or inability to 
	use these products, even if Progressive Resources LLC have been advised of 
	the possibility of such damages.
*/                                 

	#include <coding.h>

extern unsigned long OCR_REG;
extern unsigned char _FF_buff[512];
extern unsigned int PT_SecStart;
extern unsigned long BS_jmpBoot;
extern unsigned int BPB_BytsPerSec;
extern unsigned char BPB_SecPerClus;
extern unsigned int BPB_RsvdSecCnt;
extern unsigned char BPB_NumFATs;
extern unsigned int BPB_RootEntCnt;
extern unsigned int BPB_FATSz16;
extern unsigned char BPB_FATType;
extern unsigned long BPB_TotSec;
extern unsigned long BS_VolSerial;
extern unsigned char BS_VolLab[12];
extern unsigned long _FF_PART_ADDR, _FF_ROOT_ADDR, _FF_DIR_ADDR;
extern unsigned long _FF_FAT1_ADDR, _FF_FAT2_ADDR;
extern unsigned int FirstDataSector;
extern unsigned long FirstSectorofCluster;
extern unsigned char _FF_error;
extern unsigned long _FF_buff_addr;
extern unsigned long DataClusTot;
unsigned char rtc_hour, rtc_min, rtc_sec;
unsigned char rtc_date, rtc_month;
unsigned int rtc_year;
unsigned long clus_0_addr, _FF_n_temp;
unsigned int c_counter;
unsigned char _FF_FULL_PATH[_FF_PATH_LENGTH];
unsigned char FILENAME[12];

// Conversion file to change an ASCII valued character into the calculated value
unsigned char ascii_to_char(unsigned char ascii_char)
{
	unsigned char temp_char;
	
	if (ascii_char < 0x30)		// invalid, return error
		return (0xFF);
	else if (ascii_char < 0x3A)
	{	//number, subtract 0x30, retrun value
		temp_char = ascii_char - 0x30;
		return (temp_char);
	}
	else if (ascii_char < 0x41)	// invalid, return error
		return (0xFF);
	else if (ascii_char < 0x47)
	{	// lower case a-f, subtract 0x37, return value
		temp_char = ascii_char - 0x37;
		return (temp_char);
	}
	else if (ascii_char < 0x61)	// invalid, return error
		return (0xFF);
	else if (ascii_char < 0x67)
	{	// upper case A-F, subtract 0x57, return value
		temp_char = ascii_char - 0x57;
		return (temp_char);
	}
	else	// invalid, return error
		return (0xFF);
}

// Function to see if the character is a valid FILENAME character
int valid_file_char(unsigned char file_char)
{
	if (file_char < 0x20)
		return (EOF);
	else if ((file_char==0x22) || (file_char==0x2A) || (file_char==0x2B) || (file_char==0x2C) ||
			(file_char==0x2E) || (file_char==0x2F) || ((file_char>=0x3A)&&(file_char<=0x3F)) ||
			((file_char>=0x5B)&&(file_char<=0x5D)) || (file_char==0x7C) || (file_char==0xE5))
		return (EOF);
	else
		return (0);
}

// Function will scan the directory @VALID_ADDR and return a
// '0' if successful (w/ VALID_ADDR changing to location of entry avaliable),
// and a '-1' if file or folder exists (w/ VALID_ADDR changing to location of
// entry of exisiting file/folder) or if no more entry space (VALID_ADDR would
// change to 0).
int scan_directory(unsigned long *VALID_ADDR, unsigned char *NAME)
{
	unsigned int ent_cntr, ent_max, n, c, dir_clus;
	unsigned long temp_addr;
	unsigned char *sp, *qp, aval_flag, name_store[14];
	
	aval_flag = 0;
	ent_cntr = 0;	// set to 0
	
	qp = NAME;
	for (c=0; c<11; c++)
	{
		if (valid_file_char(*qp)==0)
			name_store[c] = toupper(*qp++);
		else if (*qp == '.')
		{
			while (c<8)
				name_store[c++] = 0x20;
			c--;
			
			qp++;
			aval_flag |= 1;
		}
		else if (*qp == 0)
		{
			while (c<11)
				name_store[c++] = 0x20;
		}
		else
		{
			*VALID_ADDR = 0;
			return (EOF);
		}
	}
	name_store[11] = 0;
	
	if (*VALID_ADDR == _FF_ROOT_ADDR)
		ent_max = BPB_RootEntCnt;
	else
	{
		dir_clus = addr_to_clust(*VALID_ADDR);
		if (dir_clus != 0)
			aval_flag |= 0x80;
		ent_max = ((long) BPB_BytsPerSec * (long) BPB_SecPerClus) / 0x20;
    }
	c = 0;
	while (ent_cntr < ent_max)	
	{
		if (_FF_read(*VALID_ADDR+((long)c*BPB_BytsPerSec))==0)
			break;
		for (n=0; n<16; n++)
		{
			sp = &_FF_buff[n*0x20];
			qp = name_store;
			if (*sp==0)
			{
				if ((aval_flag&0x10)==0)
					temp_addr = *VALID_ADDR + ((long) c * BPB_BytsPerSec) + (n * 0x20);
				*VALID_ADDR = temp_addr;
				return (0);
			}
			else if (*sp==0xE5)
			{
				temp_addr = *VALID_ADDR + ((long) c * BPB_BytsPerSec) + (n * 0x20);
				aval_flag |= 0x10;
			}
			else
			{
				if (aval_flag & 0x01)	// file
				{
					if (strncmp(qp, sp, 11)==0)
					{
						temp_addr = *VALID_ADDR + ((long) c * BPB_BytsPerSec) + (n * 0x20);
						*VALID_ADDR = temp_addr;
						return (EOF);	// file exists @ temp_addr
					}
				}
				else					// folder
				{
					if ((strncmp(qp, sp, 11)==0)&&(*(sp+11)&0x10))
					{
						temp_addr = *VALID_ADDR + ((long) c * BPB_BytsPerSec) + (n * 0x20);
						*VALID_ADDR = temp_addr;
						return (EOF);	// file exists @ temp_addr
					}
				}
			}
			ent_cntr++;
		}
		c++;
		if (ent_cntr == ent_max)
		{
			if (aval_flag & 0x80)		// a folder @ a valid cluster
			{
				c = next_cluster(dir_clus, SINGLE);
				if (c != EOF)
				{	// another dir cluster exists
					*VALID_ADDR = clust_to_addr(c);
					dir_clus = c;
					ent_cntr = 0;
					c = 0;
				}
			}
		}
	}
	*VALID_ADDR = 0;
	return (EOF);	
}

#ifdef _DEBUG_ON_
// Function to display all files and folders in the root directory, 
// with the size of the file in bytes within the [brakets]
void read_directory(void)
{
	unsigned char valid_flag, attribute_temp;
	unsigned int c, n, d, m, dir_clus;
	unsigned long calc, calc_clus, dir_addr;
	
	if (_FF_DIR_ADDR != _FF_ROOT_ADDR)
	{
		dir_clus = addr_to_clust(_FF_DIR_ADDR);
		if (dir_clus == 0)
			return;
	}

	printf("\r\nFile Listing for:  ROOT\\");
	for (d=0; d<_FF_PATH_LENGTH; d++)
	{
		if (_FF_FULL_PATH[d])
			putchar(_FF_FULL_PATH[d]);
		else
			break;
	}
	
    
    dir_addr = _FF_DIR_ADDR;
	d = 0;
	m = 0;
	while (d<BPB_RootEntCnt)
	{
    	if (_FF_read(dir_addr+(m*0x200))==0)
    		break;
		for (n=0; n<16; n++)
		{
			for (c=0; c<11; c++)
			{
				if (_FF_buff[(n*0x20)]==0)
				{
					n=16;
					d=BPB_RootEntCnt;
					valid_flag = 0;
					break;
				}
				valid_flag = 1;
				if (valid_file_char(_FF_buff[(n*0x20)+c]))
				{
					valid_flag = 0;
					break;
				}
		    }   
		    if (valid_flag)
	  		{
		  		calc = (n * 0x20) + 0xB;
		  		attribute_temp = _FF_buff[calc];
		  		putchar('\n');
				putchar('\r');
				c = (n * 0x20);
			  	calc = ((long) _FF_buff[c+0x1F] << 24) | ((long) _FF_buff[c+0x1E] << 16) |
			  			((long) _FF_buff[c+0x1D] << 8) | ((long) _FF_buff[c+0x1C]);
			  	calc_clus = ((int) _FF_buff[c+0x1B] << 8) | (int) _FF_buff[c+0x1A];
				if (attribute_temp & 0x10)
					printf("  [");
				else
			  		printf("                [%ld] bytes      (%X)\r  ", calc, calc_clus);		  		
				for (c=0; c<8; c++)
				{
					calc = (n * 0x20) + c;
					if (_FF_buff[calc]==0x20)
						break;
					putchar(_FF_buff[calc]);
				}
				if (attribute_temp & 0x10)
				{
					printf("]      (%X)", calc_clus);
				}
				else
				{
					putchar('.');
					for (c=8; c<11; c++)
					{
						calc = (n * 0x20) + c;
						if (_FF_buff[calc]==0x20)
							break;
						putchar(_FF_buff[calc]);
					}
				}
		  	}
		  	d++;		  		
		}
		m++;
		if (_FF_ROOT_ADDR!=_FF_DIR_ADDR)
		{
		   	if (m==BPB_SecPerClus)
		   	{

				m = next_cluster(dir_clus, SINGLE);
				if (m != EOF)
				{	// another dir cluster exists
					dir_addr = clust_to_addr(m);
					dir_clus = m;
					d = 0;
					m = 0;
				}
				else
					break;
		   		
		   	}
		}
	}
	putchar('\n');
	putchar('\r');	
} 

void GetVolID(void)
{
	printf("\r\n  Volume Serial:  [0x%lX]", BS_VolSerial);
	printf("\r\n  Volume Label:  [%s]\r\n", BS_VolLab);
}
#endif

// Convert a cluster number into a read address
unsigned long clust_to_addr(unsigned int clust_no)
{
	unsigned long clust_addr;
	
	FirstSectorofCluster = ((clust_no - 2) * (long) BPB_SecPerClus) + (long) FirstDataSector;
	clust_addr = (long) FirstSectorofCluster * (long) BPB_BytsPerSec + _FF_PART_ADDR;

	return (clust_addr);
}

// Converts an address into a cluster number
unsigned int addr_to_clust(unsigned long clus_addr)
{
	if (clus_addr <= _FF_PART_ADDR)
		return (0);
	clus_addr -= _FF_PART_ADDR;
	clus_addr /= BPB_BytsPerSec;
	if (clus_addr <= (unsigned long) FirstDataSector)
		return (0);
	clus_addr -= FirstDataSector;
	clus_addr /= BPB_SecPerClus;
	clus_addr += 2;
	if (clus_addr > 0xFFFF)
		return (0);
	
	return ((int) clus_addr);	
}

// Find the cluster that the current cluster is pointing to
unsigned int next_cluster(unsigned int current_cluster, unsigned char mode)
{
	unsigned int calc_sec, calc_offset, calc_remainder, next_clust;
	unsigned long addr_temp;
	
	if (current_cluster<=1)		// If cluster is 0 or 1, its the wrong cluster
		return (EOF);
		
	if (BPB_FATType == 0x36)		// if FAT16
	{
		// FAT16 table address calculations
		calc_sec = current_cluster / (BPB_BytsPerSec / 2) + BPB_RsvdSecCnt;
		calc_offset = 2 * (current_cluster % (BPB_BytsPerSec / 2));
	    
	 	addr_temp = _FF_PART_ADDR+(calc_sec*0x200);
		if (mode==SINGLE)
		{	// This is a single cluster lookup
			if (_FF_read(addr_temp)==0)
				return(EOF);
		}
		else if ((mode==CHAIN) || (mode==END_CHAIN))
		{	// Mupltiple clusters to lookup
			if (addr_temp!=_FF_buff_addr)
			{	// Is the address of lookup is different then the current buffere address
				#ifndef _READ_ONLY_
				if (_FF_buff_addr)	// if the buffer address is 0, don't write
				{
					#ifdef _SECOND_FAT_ON_
						if (_FF_buff_addr < _FF_FAT2_ADDR)
							if (_FF_write(_FF_buff_addr+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
								return(EOF);
					#endif
					if (_FF_write(_FF_buff_addr)==0)	// Save buffer data to card
						return(EOF);
				}
				#endif
				if (_FF_read(addr_temp)==0)	// Read new table info
					return(EOF);
			}
		}
		next_clust = ((int) _FF_buff[calc_offset+1] << 8) | _FF_buff[calc_offset];
	}
	#ifdef _FAT12_ON_
	else if (BPB_FATType == 0x32)	// if FAT12
	{
		// FAT12 table address calculations
		calc_offset = (current_cluster * 3) / 2;
		calc_remainder = (current_cluster * 3) % 2;
		calc_sec = (calc_offset / BPB_BytsPerSec) + BPB_RsvdSecCnt;
		calc_offset %= BPB_BytsPerSec;

	 	addr_temp = _FF_PART_ADDR+(calc_sec*BPB_BytsPerSec);
		if (mode==SINGLE)
		{	// This is a single cluster lookup
			if (_FF_read(addr_temp)==0)
				return(EOF);
		}
		else if ((mode==CHAIN) || (mode==END_CHAIN))
		{	// Mupltiple clusters to lookup
			if (addr_temp!=_FF_buff_addr)
			{	// Is the address of lookup is different then the current buffere address
				#ifndef _READ_ONLY_
				if (_FF_buff_addr)	// if the buffer address is 0, don't write
				{
					#ifdef _SECOND_FAT_ON_
						if (_FF_buff_addr < _FF_FAT2_ADDR)
							if (_FF_write(_FF_buff_addr+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
								return(EOF);
					#endif
					if (_FF_write(_FF_buff_addr)==0)	// Save buffer data to card
						return(EOF);
				}
				#endif
				if (_FF_read(addr_temp)==0)	// Read new table info
					return(EOF);
			}
		}
		next_clust = _FF_buff[calc_offset];
		if (calc_offset == (BPB_BytsPerSec-1))
		{	// Is the FAT12 record accross more than one sector?
			addr_temp = _FF_PART_ADDR+((calc_sec+1)*0x200);
			if ((mode==CHAIN) || (mode==END_CHAIN))
			{	// multiple chain lookup
				#ifndef _READ_ONLY_
					#ifdef _SECOND_FAT_ON_
						if (_FF_buff_addr < _FF_FAT2_ADDR)
							if (_FF_write(_FF_buff_addr+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
								return(EOF);
					#endif
				if (_FF_write(_FF_buff_addr)==0)	// Save buffer data to card
					return(EOF);
				#endif
				_FF_buff_addr = addr_temp;		// Save new buffer address
			}
			if (_FF_read(addr_temp)==0)
				return(EOF);
			next_clust |= ((int) _FF_buff[0] << 8);
		}
		else
			next_clust |= ((int) _FF_buff[calc_offset+1] << 8);

		if (calc_remainder)
			next_clust >>= 4;
		else
			next_clust &= 0x0FFF;
			
		if (next_clust >= 0xFF8)
			next_clust |= 0xF000;			
	}
	#endif
	else		// not FAT12 or FAT16, return 0
		return (EOF);
	return (next_clust);
}

// Convert a constant string file name into the proper 8.3 FAT format
unsigned char *file_name_conversion(unsigned char *current_file)
{
	unsigned char n, c;
		
	c = 0;
	
	for (n=0; n<14; n++)
	{
		if (valid_file_char(current_file[n])==0)
			// If the character is valid, save in uppercase to file name buffer
			FILENAME[c++] = toupper(current_file[n]);
		else if (current_file[n]=='.')
			// If it is a period, back fill buffer with [spaces], till 8 characters deep
			while (c<8)
				FILENAME[c++] = 0x20;
		else if (current_file[n]==0)
		{	// If it is NULL, back fill buffer with [spaces], till 11 characters deep
			while (c<11)
				FILENAME[c++] = 0x20;
			break;
		}
		else
		{
			_FF_error = NAME_ERR;
			return (0);
		}
		if (c>=11)
			break;
	}
	FILENAME[c] = 0;
	// Return the pointer of the filename
	return (FILENAME);		
}

// Find the first cluster that is pointing to clus_no
unsigned int prev_cluster(unsigned int clus_no)
{
	unsigned char read_flag;
	unsigned int calc_temp, n, c, n_temp;
	unsigned long calc_clus, addr_temp;
	
	addr_temp = _FF_FAT1_ADDR;
	c = 1;
	if ((clus_no==0) && (BPB_FATType==0x36))
	{
		if (clus_0_addr>addr_temp)
		{
			addr_temp = clus_0_addr;
			c = c_counter;
		}
	}

	read_flag = 1;
	
	while (addr_temp<_FF_FAT2_ADDR)
	{
		if (BPB_FATType == 0x36)		// if FAT16
		{
			if (clus_no==0)
			{
				clus_0_addr = addr_temp;
				c_counter = c;
			}
			if (_FF_read(addr_temp)==0)		// Read error ==> break
				return(0);
			if (_FF_n_temp)
			{
				n_temp = _FF_n_temp;
				_FF_n_temp = 0;
			}
			else
				n_temp = 0;
			for (n=n_temp; n<(BPB_BytsPerSec/2); n++)
			{
				calc_clus = ((unsigned int) _FF_buff[(n*2)+1] << 8) | ((unsigned int) _FF_buff[n*2]);
				calc_temp = (unsigned long) n + (((unsigned long) BPB_BytsPerSec/2) * ((unsigned long) c - 1));
				if (calc_clus==clus_no)
				{
					if (calc_clus==0)
						_FF_n_temp = n;
					return(calc_temp);
				}
				else if (calc_temp > DataClusTot)
				{
					_FF_error = DISK_FULL;
					return (0);
				}
			}
			addr_temp += 0x200;
			c++;
		}
		#ifdef _FAT12_ON_
		else if (BPB_FATType == 0x32)	// if FAT12
		{
			if (read_flag)
			{
				if (_FF_read(addr_temp)==0)
					return (0);	// if the read fails return 0
				read_flag = 0;
			}
			calc_temp = ((unsigned long) c * 3) / 2;
			calc_temp %= BPB_BytsPerSec;
			calc_clus = _FF_buff[calc_temp++];
			if (calc_temp == BPB_BytsPerSec)
			{	// Is the FAT12 record accross a sector?
				addr_temp += 0x200;
				if (_FF_read(addr_temp)==0)
					return (0);
				calc_clus |= ((unsigned int) _FF_buff[0] << 8);
				calc_temp = 0;
			}
			else
				calc_clus |= ((unsigned int) _FF_buff[calc_temp++] << 8);
                          	
			if (c % 2)
				calc_clus >>= 4;
			else
				calc_clus &= 0x0FFF;
			
			if (calc_clus == clus_no)
				return (c);
			else if (c > DataClusTot)
			{
				_FF_error = DISK_FULL;
				return (0);
			}
			if ((calc_temp == BPB_BytsPerSec) && (c % 2))
			{
				addr_temp += 0x200;
				read_flag = 1;
			}                                                           
			
			c++;			
		}
		#endif
		else
			return (0);
	}
	_FF_error = DISK_FULL;
	return (0);
}

#ifndef _READ_ONLY_
// Update cluster table to point to new cluster
unsigned char write_clus_table(unsigned int current_cluster, unsigned int next_value, unsigned char mode)
{
	unsigned long addr_temp;
	unsigned int calc_sec, calc_offset, calc_temp, calc_remainder;
	unsigned char nibble[3];
	
	if (current_cluster <=1)		// Should never be writing to cluster 0 or 1
	{
		return (0);
	}
	if (BPB_FATType == 0x36)		// if FAT16
	{
		calc_sec = current_cluster / (BPB_BytsPerSec / 2) + BPB_RsvdSecCnt;
		calc_offset = 2 * (current_cluster % (BPB_BytsPerSec / 2));
		addr_temp = _FF_PART_ADDR + ((long) calc_sec*0x200);
		if (mode==SINGLE)
		{	// Updating a single cluster (like writing or saving a file)
			if (_FF_read(addr_temp)==0)
				return(0);
		}
		else if ((mode==CHAIN) || (mode==END_CHAIN))
		{	// Multiple table access operation
			if (addr_temp!=_FF_buff_addr)
			{	// if the desired address is already in the buffer => skip loading buffer
				if (_FF_buff_addr)	// if new table address, write buffered, and load new
				{
					#ifdef _SECOND_FAT_ON_
						if (_FF_buff_addr < _FF_FAT2_ADDR)
							if (_FF_write(_FF_buff_addr+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
								return(0);
					#endif
					if (_FF_write(_FF_buff_addr)==0)
						return(0);
				}
				if (_FF_read(addr_temp)==0)
					return(0);
			}
		}
				
		_FF_buff[calc_offset+1] = (next_value >> 8); 
		_FF_buff[calc_offset] = (next_value & 0xFF);
		if ((mode==SINGLE) || (mode==END_CHAIN))
		{
			#ifdef _SECOND_FAT_ON_
				if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
					return(0);
			#endif
			if (_FF_write(addr_temp)==0)
			{
				return(0);
			}
		}
	}
	#ifdef _FAT12_ON_
		else if (BPB_FATType == 0x32)		// if FAT12
		{
			calc_offset = (current_cluster * 3) / 2;
			calc_remainder = (current_cluster * 3) % 2;
			calc_sec = calc_offset / BPB_BytsPerSec + BPB_RsvdSecCnt;
			calc_offset %= BPB_BytsPerSec;
			addr_temp = _FF_PART_ADDR + ((long) calc_sec * (long) BPB_BytsPerSec);

			if (mode==SINGLE)
			{
				if (_FF_read(addr_temp)==0)
					return(0);
 			}
 			else if ((mode==CHAIN) || (mode==END_CHAIN))
  			{
				if (addr_temp!=_FF_buff_addr)
				{
					if (_FF_buff_addr)
					{
					#ifdef _SECOND_FAT_ON_
						if (_FF_buff_addr < _FF_FAT2_ADDR)
							if (_FF_write(_FF_buff_addr+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
								return(0);
					#endif
						if (_FF_write(_FF_buff_addr)==0)
							return(0);
					}
					if (_FF_read(addr_temp)==0)
						return(0);
				}
			}
			nibble[0] = next_value & 0x00F;
			nibble[1] = (next_value >> 4) & 0x00F;
			nibble[2] = (next_value >> 8) & 0x00F;
    	
			if (calc_offset == (BPB_BytsPerSec-1))
			{	// Is the FAT12 record accross a sector?
				if (calc_remainder)
				{	// Record table uses 1 nibble of last byte
					calc_temp = _FF_buff[calc_offset] & 0x0F;	// Mask to add new value
					_FF_buff[calc_offset] = calc_temp | (nibble[0] << 4);	// store nibble in correct location
					#ifdef _SECOND_FAT_ON_
						if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
							return(0);
					#endif
					if (_FF_write(addr_temp)==0)
						return(0);
					addr_temp += BPB_BytsPerSec;
					if (_FF_read(addr_temp)==0)
						return(0);	// if the read fails return 0
					_FF_buff[0] = (nibble[2] << 4) | nibble[1];
					if ((mode==SINGLE) || (mode==END_CHAIN))
					{
						#ifdef _SECOND_FAT_ON_
							if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
								return(0);
						#endif
						if (_FF_write(addr_temp)==0)
							return(0);
					}
				}
				else
				{	// Record table uses whole last byte
					_FF_buff[calc_offset] = (nibble[1] << 4) | nibble[0];
					#ifdef _SECOND_FAT_ON_
						if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
							return(0);
					#endif
					if (_FF_write(addr_temp)==0)
						return(0);
					addr_temp += BPB_BytsPerSec;
					if (_FF_read(addr_temp)==0)
						return(0);	// if the read fails return 0
					calc_temp = _FF_buff[0] & 0xF0;		// Mask to add new value
					_FF_buff[0] = calc_temp | nibble[2];	// store nibble in correct location
					if ((mode==SINGLE) || (mode==END_CHAIN))
					{
						#ifdef _SECOND_FAT_ON_
							if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
								return(0);
						#endif
						if (_FF_write(addr_temp)==0)
							return(0);
					}
				}
			}
			else
			{
				if (calc_remainder)
				{	// Record table uses 1 nibble of current byte
					calc_temp = _FF_buff[calc_offset] & 0x0F;	// Mask to add new value
					_FF_buff[calc_offset] = calc_temp | (nibble[0] << 4);	// store nibble in correct location
					_FF_buff[calc_offset+1] = (nibble[2] << 4) | nibble[1];
					if ((mode==SINGLE) || (mode==END_CHAIN))
					{
						#ifdef _SECOND_FAT_ON_
							if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
								return(0);
						#endif
						if (_FF_write(addr_temp)==0)
							return(0);
					}
				}
				else
				{	// Record table uses whole current byte
					_FF_buff[calc_offset] = (nibble[1] << 4) | nibble[0];
					calc_temp = _FF_buff[calc_offset+1] & 0xF0;		// Mask to add new value
					_FF_buff[calc_offset+1] = calc_temp | nibble[2];	// store nibble in correct location
					if ((mode==SINGLE) || (mode==END_CHAIN))
					{
						#ifdef _SECOND_FAT_ON_
							if (_FF_write(addr_temp+(_FF_FAT2_ADDR-_FF_FAT1_ADDR))==0)
								return(0);
						#endif
						if (_FF_write(addr_temp)==0)
							return(0);
					}
				}
			}
		}
	#endif
	else		// not FAT12 or FAT16, return 0
		return (0);
		
	return(1);	
}
#endif

#ifndef _READ_ONLY_
// Save new entry data to FAT entry
unsigned char append_toc(FILE *rp)
{
	unsigned long file_data;
	unsigned char n;
	unsigned char *fp;
	unsigned int calc_temp, calc_date;
	
	if (rp==NULL)
		return (0);

	file_data = rp->length;
	if (_FF_read(rp->entry_sec_addr)==0)
		return (0);
	
	// Update Starting Cluster 
	fp = &_FF_buff[rp->entry_offset+0x1a];
	*fp++ = rp->clus_start & 0xFF;
	*fp++ = rp->clus_start >> 8;
	
	// Update the File Size
	for (n=0; n<4; n++)
	{
		*fp = file_data & 0xFF;
		file_data >>= 8;
		fp++;
	}
	
	
	fp = &_FF_buff[rp->entry_offset+0x16];
	#ifdef _RTC_ON_ 	// Date/Time Stamp file w/ RTC
		rtc_get_timeNdate(&rtc_hour, &rtc_min, &rtc_sec, &rtc_date, &rtc_month, (int *)&rtc_year);	    			
		calc_temp = ((int)rtc_sec&0x1F) | (((int)rtc_min&0x3F)<<5) | (((int)rtc_hour&0x1F)<<11);
		*fp++ = calc_temp&0x00FF;	// File create Time 
		*fp++ = (calc_temp&0xFF00) >> 8;
		calc_date = ((int)rtc_date&0x1F) | (((int)rtc_month&0x0F)<<5) | (((rtc_year-1980)&0x7F)<<9);
		*fp++ = calc_date&0x00FF;	// File create Date
		*fp++ = (calc_date&0xFF00) >> 8;
	#else		// Increment Date Code, no RTC used 
		file_data = 0;
		for (n=0; n<4; n++)
		{
			file_data <<= 8;
			file_data |= *fp;
			fp--;
		}
		file_data++;
		for (n=0; n<4; n++)
		{
			fp++;
			*fp = file_data & 0xFF;
			file_data >>=8;
		}
	#endif
	if (_FF_write(rp->entry_sec_addr)==0)
		return(0);
	
	return(1);
}
#endif

#ifndef _READ_ONLY_
// Erase a chain of clusters (set table entries to 0 for clusters in chain)
unsigned char erase_clus_chain(unsigned int start_clus)
{
	unsigned int clus_temp, clus_use;
	
	if (start_clus==0)
		return (0);
	clus_use = start_clus;
	_FF_buff_addr = 0;
	while(clus_use <= 0xFFF8)
	{
		clus_temp = next_cluster(clus_use, CHAIN);
		if ((clus_temp >= 0xFFF8) || (clus_temp == 0))
			break;
		if (write_clus_table(clus_use, 0, CHAIN) == 0)
			return (0);
		clus_use = clus_temp;
	}
	if (write_clus_table(clus_use, 0, END_CHAIN) == 0)
		return (0);
	clus_0_addr = 0;
	c_counter = 0;
	
	return (1);	
}

// Quickformat of a card (erase cluster table and root directory
int fquickformat(void)
{
	long c;
	
	for (c=0; c<BPB_BytsPerSec; c++)
		_FF_buff[c] = 0;
	
	c = _FF_FAT1_ADDR + 0x200;
	while (c < (_FF_ROOT_ADDR + (0x400 * BPB_SecPerClus)))
	{
		if (_FF_write(c)==0)
		{
			_FF_error = WRITE_ERR;
			return (EOF);
		}
		c += 0x200;
	}	
	_FF_buff[0] = 0xF8;
	_FF_buff[1] = 0xFF;
	_FF_buff[2] = 0xFF;
	if (BPB_FATType == 0x36)
		_FF_buff[3] = 0xFF;
	if ((_FF_write(_FF_FAT1_ADDR)==0) || (_FF_write(_FF_FAT2_ADDR)==0))
	{
		_FF_error = WRITE_ERR;
		return (EOF);
	}
	return (0);
}
#endif

// function that checks for directory changes then gets into a working form
int _FF_checkdir(char *F_PATH, unsigned long *SAVE_ADDR, char *path_temp)
{
	unsigned char *sp, *qp;
    
    *SAVE_ADDR = _FF_DIR_ADDR;	// save local dir addr
    
    qp = F_PATH;
    if (*qp=='\\')
    {
    	_FF_DIR_ADDR = _FF_ROOT_ADDR;
		qp++;
	}

	sp = path_temp;
	while(*qp)
	{
		if ((valid_file_char(*qp)==0) || (*qp=='.'))
			*sp++ = toupper(*qp++);
		else if (*qp=='\\')
		{
			*sp = 0;	// terminate string
			if (_FF_chdir(path_temp))
			{
				return (EOF);
			}
			sp = path_temp;
			qp++;
		}
		else
			return (EOF);
	}
	
	*sp = 0;		// terminate string
	return (0);
}

#ifndef _READ_ONLY_
int mkdir(char *F_PATH)
{
	unsigned char *sp, *qp;
	unsigned char fpath[14];
	unsigned int c, calc_temp, clus_temp, calc_time, calc_date;
	int s;
	unsigned long addr_temp, path_addr_temp;
    
    addr_temp = 0;	// save local dir addr
    
    if (_FF_checkdir(F_PATH, &addr_temp, fpath))
	{
		_FF_DIR_ADDR = addr_temp;
		return (EOF);
	}
    
	path_addr_temp = _FF_DIR_ADDR;
	s = scan_directory(&path_addr_temp, fpath);
	if ((s) || (path_addr_temp==0))
	{
		_FF_DIR_ADDR = addr_temp;
		return (EOF);
	}
	clus_temp = prev_cluster(0);				
	calc_temp = path_addr_temp % BPB_BytsPerSec;
	path_addr_temp -= calc_temp;
	if (_FF_read(path_addr_temp)==0)	
	{
		_FF_DIR_ADDR = addr_temp;
		return (EOF);
	}
	
	sp = &_FF_buff[calc_temp];
	qp = fpath;

	for (c=0; c<11; c++)	// Write Folder name
	{
	 	if (*qp)
		 	*sp++ = *qp++;
		else 
			*sp++ = 0x20;	// '0' pad
	}
	*sp++ = 0x10;				// Attribute bit auto set to "Directory"
	*sp++ = 0;					// Reserved for WinNT
	*sp++ = 0;					// Mili-second stamp for create
	for (c=0; c<4; c++)			// set create and modify time to '0'
		*sp++ = 0;
	*sp++ = 0;					// File access date (2 bytes)
	*sp++ = 0;
	*sp++ = 0;					// 0 for FAT12/16 (2 bytes)
	*sp++ = 0;
	#ifdef _RTC_ON_
		rtc_get_timeNdate(&rtc_hour, &rtc_min, &rtc_sec, &rtc_date, &rtc_month, (int *)&rtc_year);	    			
		calc_time = ((int)rtc_sec&0x1F) | (((int)rtc_min&0x3F)<<5) | (((int)rtc_hour&0x1F)<<11);
		*sp++ = calc_time&0x00FF;	// File modify Time 
		*sp++ = (calc_time&0xFF00) >> 8;
		calc_date = ((int)rtc_date&0x1F) | (((int)rtc_month&0x0F)<<5) | (((rtc_year-1980)&0x7F)<<9);
		*sp++ = calc_date&0x00FF;	// File modify Date
		*sp++ = (calc_date&0xFF00) >> 8;
	#else
		for (c=0; c<4; c++)			// set file create and modify time to '0'
			*sp++ = 0;
	#endif
	
	*sp++ = clus_temp & 0xFF;				// Starting cluster (2 bytes)
	*sp++ = (clus_temp >> 8) & 0xFF;
	for (c=0; c<4; c++)
		*sp++ = 0;			// File length (0 for folder)

	
	if (_FF_write(path_addr_temp)==0)	// write entry to card
	{
		_FF_DIR_ADDR = addr_temp;
		return (EOF);
	}
	if (write_clus_table(clus_temp, 0xFFFF, SINGLE)==0)
	{
		_FF_DIR_ADDR = addr_temp;
		return (EOF);
	}
	if (_FF_read(_FF_DIR_ADDR)==0)	
	{
		_FF_DIR_ADDR = addr_temp;
		return (EOF);
	}
	if (_FF_DIR_ADDR != _FF_ROOT_ADDR)
	{
		sp = &_FF_buff[0];
		qp = &_FF_buff[0x20];
		for (c=0; c<0x20; c++)
			*qp++ = *sp++;
		_FF_buff[1] = ' ';
		for (c=0x3C; c<0x40; c++)
			_FF_buff[c] = 0;
	}
	else
	{
		for (c=0x01; c<0x0B; c++)
			_FF_buff[c] = 0x20;
		for (c=0x0C; c<0x20; c++)
			_FF_buff[c] = 0;
		_FF_buff[0] = '.';
		_FF_buff[0x0B] = 0x10;
		#ifdef _RTC_ON_
			_FF_buff[0x0E] = calc_time&0x00FF;	// File modify Time 
			_FF_buff[0x0F] = (calc_time&0xFF00) >> 8;
			_FF_buff[0x10] = calc_date&0x00FF;	// File modify Date
			_FF_buff[0x11] = (calc_date&0xFF00) >> 8;
			_FF_buff[0x16] = calc_time&0x00FF;	// File modify Time 
			_FF_buff[0x17] = (calc_time&0xFF00) >> 8;
			_FF_buff[0x18] = calc_date&0x00FF;	// File modify Date
			_FF_buff[0x19] = (calc_date&0xFF00) >> 8;
		#endif
		for (c=0x3A; c<0x40; c++)
			_FF_buff[c] = 0;
	}
	for (c=0x22; c<0x2B; c++)
		_FF_buff[c] = 0x20;
	#ifdef _RTC_ON_
		_FF_buff[0x2E] = calc_time&0x00FF;	// File modify Time 
		_FF_buff[0x2F] = (calc_time&0xFF00) >> 8;
		_FF_buff[0x30] = calc_date&0x00FF;	// File modify Date
		_FF_buff[0x31] = (calc_date&0xFF00) >> 8;
		_FF_buff[0x36] = calc_time&0x00FF;	// File modify Time 
		_FF_buff[0x37] = (calc_time&0xFF00) >> 8;
		_FF_buff[0x38] = calc_date&0x00FF;	// File modify Date
		_FF_buff[0x39] = (calc_date&0xFF00) >> 8;
	#endif
	_FF_buff[0x20] = '.';
	_FF_buff[0x21] = '.';
	_FF_buff[0x2B] = 0x10;

	_FF_buff[0x1A] = clus_temp & 0xFF;				// Starting cluster (2 bytes)
	_FF_buff[0x1B] = (clus_temp >> 8) & 0xFF;
	for (c=0x40; c<BPB_BytsPerSec; c++)
		_FF_buff[c] = 0;
	path_addr_temp = clust_to_addr(clus_temp);

	_FF_DIR_ADDR = addr_temp;	// reset dir addr
	if (_FF_write(path_addr_temp)==0)	
		return (EOF);
	for (c=0; c<0x40; c++)
		_FF_buff[c] = 0;
	for (c=1; c<BPB_SecPerClus; c++)
	{
		if (_FF_write(path_addr_temp+((long)c*0x200))==0)	
			return (EOF);
	}
	return (0);		
}

int rmdir(char *F_PATH)
{
	unsigned char *sp;
	unsigned char fpath[14];
	unsigned int c, n, calc_temp, clus_temp;
	int s;
	unsigned long addr_temp, path_addr_temp;
	
	addr_temp = 0;	// save local dir addr
    
    if (_FF_checkdir(F_PATH, &addr_temp, fpath))
	{
		_FF_DIR_ADDR = addr_temp;
		return (EOF);
	}
	if (fpath[0]==0)
	{
		_FF_DIR_ADDR = addr_temp;
		return (EOF);
	}

    path_addr_temp = _FF_DIR_ADDR;	// save addr for later
	
	if (_FF_chdir(fpath))	// Change directory to dir to be deleted
	{	
		_FF_DIR_ADDR = addr_temp;
		return (EOF);
	}
	if ((_FF_DIR_ADDR==_FF_ROOT_ADDR)||(_FF_DIR_ADDR==addr_temp))
	{	// if trying to delete root, or current dir error
		_FF_DIR_ADDR = addr_temp;
		return (EOF);
	}
	
	for (c=0; c<BPB_SecPerClus; c++)
	{	// scan through dir to see if it is empty
		if (_FF_read(_FF_DIR_ADDR+((long)c*0x200))==0)
		{	// read sectors 	
			_FF_DIR_ADDR = addr_temp;
			return (EOF);
		}
		for (n=0; n<0x10; n++)
		{
			if ((c==0)&&(n==0))	// skip first 2 entries 
				n=2;
			sp = &_FF_buff[n*0x20];
			if (*sp==0)
			{	// 
				c = BPB_SecPerClus;
				break;
			}
			while (valid_file_char(*sp)==0)
			{
				sp++;
				if (sp == &_FF_buff[(n*0x20)+0x0A])
				{	// a valid file or folder found
					_FF_DIR_ADDR = addr_temp;
					return (EOF);
				}
			}
		}
	}
	// directory empty, delete dir
	_FF_DIR_ADDR = path_addr_temp;	// go back to previous directory 

	s = scan_directory(&path_addr_temp, fpath);

	_FF_DIR_ADDR = addr_temp;	// reset address

	if (s == 0)
		return (EOF);
	
	calc_temp = path_addr_temp % BPB_BytsPerSec;
	path_addr_temp -= calc_temp;

	if (_FF_read(path_addr_temp)==0)	
		return (EOF);
    
	clus_temp = ((int) _FF_buff[calc_temp+0x1B] << 8) | _FF_buff[calc_temp+0x1A];
	_FF_buff[calc_temp] = 0xE5;
	
	if (_FF_buff[calc_temp+0x0B]&0x02)
		return (EOF);
	if (_FF_write(path_addr_temp)==0) 
		return (EOF);
	if (erase_clus_chain(clus_temp)==0)
		return (EOF);
	
    return (0);
}
#endif

int chdirc(char flash *F_PATH)
{
	unsigned char fpath[_FF_PATH_LENGTH];
	int c;
	
	for (c=0; c<_FF_PATH_LENGTH; c++)
	{
		fpath[c] = F_PATH[c];
		if (F_PATH[c]==0)
			break;
	}
	return (chdir(fpath));
}

int chdir(char *F_PATH)
{
	unsigned char *qp, *sp, fpath[14], valid_flag;
	unsigned int m, n, c, d, calc;
	unsigned long addr_temp;

    
    addr_temp = 0;	// save local dir addr
    
	if ((F_PATH[0]=='\\') && (F_PATH[1]==0))
	{
		_FF_DIR_ADDR = _FF_ROOT_ADDR;
		_FF_FULL_PATH[1] = 0;
		return (0);
	}
	
    if (_FF_checkdir(F_PATH, &addr_temp, fpath))
	{
		_FF_DIR_ADDR = addr_temp;
		return (EOF);
	}
	if (fpath[0]==0)
		return (EOF);

	if ((fpath[0]=='.') && (fpath[1]=='.') && (fpath[2]==0))
	{	// trying to get back to prev dir
		if (_FF_DIR_ADDR == _FF_ROOT_ADDR)		// already as far back as can go
			return (EOF);
		if (_FF_read(_FF_DIR_ADDR)==0)
			return (EOF);
		m = ((unsigned int) _FF_buff[0x3B] << 8) | (unsigned int) _FF_buff[0x3A];
		if (m)
			_FF_DIR_ADDR = clust_to_addr(m);
		else
			_FF_DIR_ADDR = _FF_ROOT_ADDR;
		
					sp = F_PATH;
					qp = _FF_FULL_PATH + strlen(_FF_FULL_PATH);
					while (*sp)
					{
						if ((*sp=='.')&&(*(sp+1)=='.'))
						{
							#ifdef _ICCAVR_
								qp = strrchr(_FF_FULL_PATH, '\\');
								if (qp==0)
								   return (EOF);
								*qp = 0;
								qp = strrchr(_FF_FULL_PATH, '\\');
								if (qp==0)
								   return (EOF);
								qp++;
							#endif
							#ifdef _CVAVR_
								_FF_FULL_PATH[strrpos(_FF_FULL_PATH, '\\')] = 0;
							    c = strrpos(_FF_FULL_PATH, '\\');
								if (c==EOF)
									return (EOF);
								qp = _FF_FULL_PATH + c;
							#endif
							*qp = 0;
							sp += 2;
						}
						else 
							*qp++ = toupper(*sp++);
					}
					*qp++ = '\\';
					*qp = 0;

		return (0);
	}
		
	qp = fpath;
	sp = fpath;
	while(sp < (fpath+11))
	{
		if (*qp)
			*sp++ = toupper(*qp++);
		else	// (*qp==0)
			*sp++ = 0x20;
	}     
	*sp = 0;

	qp = fpath;
	m = 0;
	d = 0;
	valid_flag = 0;
	while (d<BPB_RootEntCnt)
	{
    	_FF_read(_FF_DIR_ADDR+(m*0x200));
		for (n=0; n<16; n++)
		{
			if (_FF_buff[n*0x20] == 0)	// no more entries in dir
			{
				_FF_DIR_ADDR = addr_temp;
				return (EOF);
			}
			calc = (n*0x20);
			for (c=0; c<11; c++)
			{	// check for name match
				if (fpath[c] == _FF_buff[calc+c])
					valid_flag = 1;
				else if (fpath[c] == 0)
				{
					if (_FF_buff[calc+c]==0x20)
						break;
				}
				else
				{
					valid_flag = 0;	
					break;
				}
		    }   
		    if (valid_flag)
	  		{
	  			if (_FF_buff[calc+0xB] != 0x10)	// not a directory
	  				valid_flag = 0;
	  			else
	  			{
	  				c = ((int) _FF_buff[calc+0x1B] << 8) | ((int) _FF_buff[calc+0x1A]);
					_FF_DIR_ADDR = clust_to_addr(c);
					sp = F_PATH;
					if (*sp=='\\')
					{	// Restart String @root
						qp = _FF_FULL_PATH + 1;
						*qp = 0;
						sp++;
					}
					else
						qp = _FF_FULL_PATH + strlen(_FF_FULL_PATH);
					while (*sp)
					{
						if ((*sp=='.')&&(*(sp+1)=='.'))
						{
							#ifdef _ICCAVR_
								qp = strrchr(_FF_FULL_PATH, '\\');
								if (qp==0)
								   return (EOF);
								*qp = 0;
								qp = strrchr(_FF_FULL_PATH, '\\');
								if (qp==0)
								   return (EOF);
								qp++;
							#endif
							#ifdef _CVAVR_
								_FF_FULL_PATH[strrpos(_FF_FULL_PATH, '\\')] = 0;
								c = strrpos(_FF_FULL_PATH, '\\');
								if (c==EOF)
								   return (EOF);
								qp = _FF_FULL_PATH + c;
							#endif
							*qp = 0;
							sp += 2;
						}
						else 
							*qp++ = toupper(*sp++);
					}
					*qp++ = '\\';
					*qp = 0;
					return (0);
				}
			}
		  	d++;		  		
		}
		m++;
	}
	_FF_DIR_ADDR = addr_temp;
	return (EOF);
}

// Function to change directories one at a time, not effecting the working dir string
int _FF_chdir(char *F_PATH)
{
	unsigned char *qp, *sp, valid_flag, fpath[14];
	unsigned int m, n, c, d, calc;
    
	if ((F_PATH[0]=='.') && (F_PATH[1]=='.') && (F_PATH[2]==0))
	{	// trying to get back to prev dir
		if (_FF_DIR_ADDR == _FF_ROOT_ADDR)		// already as far back as can go
			return (EOF);
		if (_FF_read(_FF_DIR_ADDR)==0)
			return (EOF);
		m = ((unsigned int) _FF_buff[0x3B] << 8) | (unsigned int) _FF_buff[0x3A];
		if (m)
			_FF_DIR_ADDR = clust_to_addr(m);
		else
			_FF_DIR_ADDR = _FF_ROOT_ADDR;
		return (0);
	}
		
	qp = F_PATH;
	sp = fpath;
	while(sp < (fpath+11))
	{
		if (valid_file_char(*qp)==0)
			*sp++ = toupper(*qp++);
		else if (*qp==0)
			*sp++ = 0x20;
		else
			return (EOF);
	}     
	*sp = 0;
	m = 0;
	d = 0;
	valid_flag = 0;
	while (d<BPB_RootEntCnt)
	{
    	_FF_read(_FF_DIR_ADDR+(m*0x200));
		for (n=0; n<16; n++)
		{
			calc = (n*0x20);
			if (_FF_buff[calc] == 0)	// no more entries in dir
				return (EOF);
			for (c=0; c<11; c++)
			{	// check for name match
				if (fpath[c] == _FF_buff[calc+c])
					valid_flag = 1;
				else
				{
					valid_flag = 0;	
					c = 11;
				}
		    }   
		    if (valid_flag)
	  		{
	  			if (_FF_buff[calc+0xB] != 0x10)	// not a directory
	  				valid_flag = 0;
	  			else
	  			{
	  				c = ((int) _FF_buff[calc+0x1B] << 8) | ((int) _FF_buff[calc+0x1A]);
					_FF_DIR_ADDR = clust_to_addr(c);
					return (0);
				}
			}
		  	d++;		  		
		}
		m++;
	}
	return (EOF);
}

#ifndef _SECOND_FAT_ON_
// Function that clears the secondary FAT table
int clear_second_FAT(void)
{
	unsigned int c, d;
	unsigned long n;
	
	for (n=1; n<BPB_FATSz16; n++)
	{
		if (_FF_read(_FF_FAT2_ADDR+(n*0x200))==0)
			return (EOF);
		for (c=0; c<BPB_BytsPerSec; c++)
		{
			if (_FF_buff[c] != 0)
			{
				for (d=0; d<BPB_BytsPerSec; d++)
					_FF_buff[d] = 0;
				if (_FF_write(_FF_FAT2_ADDR+(n*0x200))==0)
					return (EOF);
				break;
			}
		}
	}
	for (d=2; d<BPB_BytsPerSec; d++)
		_FF_buff[d] = 0;
	_FF_buff[0] = 0xF8;
	_FF_buff[1] = 0xFF;
	_FF_buff[2] = 0xFF;
	if (BPB_FATType == 0x36)
		_FF_buff[3] = 0xFF;
	if (_FF_write(_FF_FAT2_ADDR)==0)
		return (EOF);
	
	return (1);
}
#endif
 
// Open a file, name stored in string fileopen
FILE *fopenc(unsigned char flash *NAMEC, unsigned char MODEC)
{
	unsigned char c, temp_data[12];
	FILE *tp;
	
	for (c=0; c<12; c++)
		temp_data[c] = NAMEC[c];
	
	tp = fopen(temp_data, MODEC);
	return(tp);
}

FILE *fopen(unsigned char *NAME, unsigned char MODE)
{
	unsigned char fpath[14];
	unsigned int c, s, calc_temp;
	unsigned char *sp, *qp;
	unsigned long addr_temp, path_addr_temp;
	FILE *rp;
	
	#ifdef _READ_ONLY_
		if (MODE!=READ)
			return (0);
	#endif
	
    addr_temp = 0;	// save local dir addr
    
    if (_FF_checkdir(NAME, &addr_temp, fpath))
	{
		_FF_DIR_ADDR = addr_temp;
		return (0);
	}
	if (fpath[0]==0)
	{
		_FF_DIR_ADDR = addr_temp;
		return (0);
	}
    
	path_addr_temp = _FF_DIR_ADDR;
	s = scan_directory(&path_addr_temp, fpath);
	if ((path_addr_temp==0) || (s==0))
	{
		_FF_DIR_ADDR = addr_temp;
		return (0);
	}

	rp = 0;
	rp = malloc(sizeof(FILE));
	if (rp == 0)
	{	// Could not allocate requested memory
		_FF_error = ALLOC_ERR;
		_FF_DIR_ADDR = addr_temp;
		return (0);
	}
	rp->length = 0x46344456;
	rp->clus_start = 0xe4;
	rp->position = 0x45664446;

	calc_temp = path_addr_temp % BPB_BytsPerSec;
	path_addr_temp -= calc_temp;
	if (_FF_read(path_addr_temp)==0)	
	{
		_FF_DIR_ADDR = addr_temp;
		return (0);
	}
	
	// Get the filename into a form we can use to compare
	qp = file_name_conversion(fpath);
	if (qp==0)
	{	// If File name entered is NOT valid, return 0
		free(rp);
		_FF_DIR_ADDR = addr_temp;
		return (0);
	}
	
	sp = &_FF_buff[calc_temp];

	if (s)
	{	// File exists, open 
		if (((MODE==WRITE) || (MODE==APPEND)) && (_FF_buff[calc_temp+0x0B]&0x01))
		{	// if writing to file verify it is not "READ ONLY"
			_FF_error = MODE_ERR;
			free(rp);
			_FF_DIR_ADDR = addr_temp;
			return (0);
		}
		for (c=0; c<12; c++)	// Save Filename to Buffer
			rp->name[c] = FILENAME[c];
		// Save Starting Cluster
		rp->clus_start = ((int) _FF_buff[calc_temp+0x1B] << 8) | (int) _FF_buff[calc_temp+0x1A];
		// Set Current Cluster
		rp->clus_current = rp->clus_start;
		// Set Previous Cluster to 0 (indicating @start)
		rp->clus_prev = 0;
		// Save file length
		rp->length = 0;
		sp = _FF_buff + calc_temp + 0x1F;
		for (c=0; c<4; c++)
		{
			rp->length <<= 8;
			rp->length |= *sp--;
		}
		// Set Current Position to 0
		rp->position = 0;
		#ifndef _READ_ONLY_
			if (MODE==WRITE)
			{	// Change file to blank
				sp = _FF_buff + calc_temp + 0x1F;
				for (c=0; c<6; c++)
					*sp-- = 0;
				if (rp->length)
				{
					if (_FF_write(_FF_DIR_ADDR + (0x200 * s))==0)
					{
						free(rp);
						_FF_DIR_ADDR = addr_temp;
						return (0);
					}
					rp->length = 0;
					erase_clus_chain(rp->clus_start);
					rp->clus_start = 0;
				}
			}
		#endif
		// Set and save next cluster #
		rp->clus_next = next_cluster(rp->clus_current, SINGLE);
		if ((rp->length==0) && (rp->clus_start==0))
		{	// Check for Blank File 
			if (MODE==READ)
			{	// IF trying to open a blank file to read, ERROR
				_FF_error = MODE_ERR;
				free(rp);
				_FF_DIR_ADDR = addr_temp;
				return (0);
			}
			//Setup blank FILE characteristics
			#ifndef _READ_ONLY_
				MODE = WRITE; 
			#endif
		}
		// Save the file offset to read entry
		rp->entry_sec_addr = path_addr_temp;
		rp->entry_offset =  calc_temp;
		// Set sector offset to 1
		rp->sec_offset = 1;
		if (MODE==APPEND)
		{
			if (fseek(rp, 0,SEEK_END)==EOF)
			{
				free(rp);
				_FF_DIR_ADDR = addr_temp;
				return (0);
			}
		}
		else
		{	// Set pointer to the begining of the file
			_FF_read(clust_to_addr(rp->clus_current));
			for (c=0; c<BPB_BytsPerSec; c++)
				rp->buff[c] = _FF_buff[c];
			rp->pntr = &rp->buff[0];
		}
		#ifndef _READ_ONLY_
			#ifndef _SECOND_FAT_ON_
				if ((MODE==WRITE) || (MODE==APPEND))
					clear_second_FAT();
			#endif
    	#endif
		rp->mode = MODE;
		_FF_error = NO_ERR;
		_FF_DIR_ADDR = addr_temp;
		return(rp);
	}
	else
	{                          		
		_FF_error = FILE_ERR;
		free(rp);
		_FF_DIR_ADDR = addr_temp;
		return(0);
	}
}

#ifndef _READ_ONLY_
// Create a file
FILE *fcreatec(unsigned char flash *NAMEC, unsigned char MODE)
{
	unsigned char sd_temp[12];
	int c;

	for (c=0; c<12; c++)
		sd_temp[c] = NAMEC[c];
	
	return (fcreate(sd_temp, MODE));
}

FILE *fcreate(unsigned char *NAME, unsigned char MODE)
{
	unsigned char fpath[14];
	unsigned int c, s, calc_temp;
	unsigned char *sp, *qp;
	unsigned long addr_temp, path_addr_temp;
	FILE *temp_file_pntr;

    addr_temp = 0;	// save local dir addr
    
    if (_FF_checkdir(NAME, &addr_temp, fpath))
	{
		_FF_error = PATH_ERR;
		_FF_DIR_ADDR = addr_temp;
		return (0);
	}
	if (fpath[0]==0)
	{
		_FF_error = NAME_ERR; 
		_FF_DIR_ADDR = addr_temp;
		return (0);
	}
    
	path_addr_temp = _FF_DIR_ADDR;
	s = scan_directory(&path_addr_temp, fpath);
	if (path_addr_temp==0)
	{
		_FF_error = NO_ENTRY_AVAL;
		_FF_DIR_ADDR = addr_temp;
		return (0);
	}

	calc_temp = path_addr_temp % BPB_BytsPerSec;
	path_addr_temp -= calc_temp;
	if (_FF_read(path_addr_temp)==0)	
	{
		_FF_error = READ_ERR;
		_FF_DIR_ADDR = addr_temp;
		return (0);
	}

	// Get the filename into a form we can use to compare
	qp = file_name_conversion(fpath);
	if (qp==0)
	{
		_FF_error = NAME_ERR; 
		_FF_DIR_ADDR = addr_temp;
		return (0);
	}
	sp = &_FF_buff[calc_temp];
	
	if (s)
	{
		if ((_FF_buff[calc_temp+0x0B]&0x1)==1)	// is file read only
		{
			_FF_error = READONLY_ERR;
			_FF_DIR_ADDR = addr_temp;
			return (0);
		}
	}
	else
	{
		for (c=0; c<11; c++)	// Write Filename
			*sp++ = *qp++;
		*sp = 0x20;				// Attribute bit auto set to "ARCHIVE"
		sp++;		
		*sp++ = 0;				// Reserved for WinNT
		*sp++ = 0;				// Mili-second stamp for create
	
		#ifdef _RTC_ON_
			rtc_get_timeNdate(&rtc_hour, &rtc_min, &rtc_sec, &rtc_date, &rtc_month, (int *)&rtc_year);	    			
    	    calc_temp = ((int)rtc_sec&0x1F) | (((int)rtc_min&0x3F)<<5) | (((int)rtc_hour&0x1F)<<11);
			*sp++ = calc_temp&0x00FF;	// File create Time 
			*sp++ = (calc_temp&0xFF00) >> 8;
			calc_temp = ((int)rtc_date&0x1F) | (((int)rtc_month&0x0F)<<5) | (((rtc_year-1980)&0x7F)<<9);
			*sp++ = calc_temp&0x00FF;	// File create Date
			*sp++ = (calc_temp&0xFF00) >> 8;
		#else
			for (c=0; c<4; c++)
				*sp++ = 0;
		#endif

		*sp++ = 0;				// File access date (2 bytes)
		*sp++ = 0;
		*sp++ = 0;				// 0 for FAT12/16 (2 bytes)
		*sp++ = 0;
		for (c=0; c<4; c++)		// Modify time/date
			*sp++ = 0;
		*sp++ = 0;				// Starting cluster (2 bytes)
		*sp++ = 0;
		for (c=0; c<4; c++)
			*sp++ = 0;			// File length (0 for new)
	
		if (_FF_write(path_addr_temp)==0)
		{
			_FF_error = WRITE_ERR;
			_FF_DIR_ADDR = addr_temp;
			return (0);				
		}
	}
	_FF_DIR_ADDR = addr_temp;
	temp_file_pntr = fopen(NAME, WRITE);
	if (temp_file_pntr == 0)	// Will file open
		return (0);				
	if (MODE)
	{
		if (_FF_read(addr_temp)==0)
		{
			_FF_error = READ_ERR;
			return (0);
		}
		_FF_buff[calc_temp+12] |= MODE;		
		if (_FF_write(addr_temp)==0)
		{
			_FF_error = WRITE_ERR;
			return (0);
		}
	}
	_FF_error = NO_ERR;
	return (temp_file_pntr);
}
#endif

#ifndef _READ_ONLY_
// Open a file, name stored in string fileopen
int removec(unsigned char flash *NAMEC)
{
	int c;
	unsigned char sd_temp[12];
	
	for (c=0; c<12; c++)
		sd_temp[c] = NAMEC[c];
	
	c = remove(sd_temp);
	return (c);
}

// Remove a file from the root directory
int remove(unsigned char *NAME)
{
	unsigned char fpath[14];
	unsigned int s, calc_temp;
	unsigned long addr_temp, path_addr_temp;
	
	#ifndef _SECOND_FAT_ON_
		clear_second_FAT();
    #endif
    
    addr_temp = 0;	// save local dir addr
    
    if (_FF_checkdir(NAME, &addr_temp, fpath))
	{
		_FF_error = PATH_ERR;
		_FF_DIR_ADDR = addr_temp;
		return (EOF);
	}
	if (fpath[0]==0)
	{
		_FF_error = NAME_ERR; 
		_FF_DIR_ADDR = addr_temp;
		return (EOF);
	}
    
	path_addr_temp = _FF_DIR_ADDR;
	s = scan_directory(&path_addr_temp, fpath);
	if ((path_addr_temp==0) || (s==0))
	{
		_FF_error = NO_ENTRY_AVAL;
		_FF_DIR_ADDR = addr_temp;
		return (EOF);
	}
	_FF_DIR_ADDR = addr_temp;		// Reset current dir

	calc_temp = path_addr_temp % BPB_BytsPerSec;
	path_addr_temp -= calc_temp;
	if (_FF_read(path_addr_temp)==0)	
	{
		_FF_error = READ_ERR;
		return (EOF);
	}
	
	// Erase entry (put 0xE5 into start of the filename
	_FF_buff[calc_temp] = 0xE5;
	if (_FF_write(path_addr_temp)==0)
	{
		_FF_error = WRITE_ERR;
		return (EOF);
	}
	// Save Starting Cluster
	calc_temp = ((int) _FF_buff[calc_temp+0x1B] << 8) | (int) _FF_buff[calc_temp+0x1A];
	// Destroy cluster chain
	if (calc_temp)
		if (erase_clus_chain(calc_temp) == 0)
			return (EOF);
			
	return (1);
}
#endif

#ifndef _READ_ONLY_
// Rename a file in the Root Directory
int rename(unsigned char *NAME_OLD, unsigned char *NAME_NEW)
{
	unsigned char c;
	unsigned int calc_temp;
	unsigned long addr_temp, path_addr_temp;
	unsigned char *sp, *qp;
	unsigned char fpath[14];

	// Get the filename into a form we can use to compare
	qp = file_name_conversion(NAME_NEW);
	if (qp==0)
	{
		_FF_error = NAME_ERR;
		return (EOF);
	}
	
    addr_temp = 0;	// save local dir addr
    
    if (_FF_checkdir(NAME_OLD, &addr_temp, fpath))
	{
		_FF_error = PATH_ERR;
		_FF_DIR_ADDR = addr_temp;
		return (EOF);
	}
	if (fpath[0]==0)
	{
		_FF_error = NAME_ERR; 
		_FF_DIR_ADDR = addr_temp;
		return (EOF);
	}

	path_addr_temp = _FF_DIR_ADDR;
	calc_temp = scan_directory(&path_addr_temp, NAME_NEW);
	if (calc_temp)
	{	// does new name alread exist?
		_FF_DIR_ADDR = addr_temp;
		_FF_error = EXIST_ERR;
		return (EOF);
	}

	path_addr_temp = _FF_DIR_ADDR;
	calc_temp = scan_directory(&path_addr_temp, fpath);
	if ((path_addr_temp==0) || (calc_temp==0))
	{
		_FF_DIR_ADDR = addr_temp;
		_FF_error = EXIST_ERR;
		return (EOF);
	}


	_FF_DIR_ADDR = addr_temp;		// Reset current dir

	calc_temp = path_addr_temp % BPB_BytsPerSec;
	path_addr_temp -= calc_temp;
	if (_FF_read(path_addr_temp)==0)	
	{
		_FF_error = READ_ERR;
		return (EOF);
	}
	
	// Rename entry
	sp = &_FF_buff[calc_temp];
	for (c=0; c<11; c++)
		*sp++ = *qp++;
	if (_FF_write(path_addr_temp)==0)
		return (EOF);

	return(0);
}
#endif

#ifndef _READ_ONLY_
// Save Contents of file, w/o closing
int fflush(FILE *rp)	
{
	unsigned int  n;
	unsigned long addr_temp;
	
	if ((rp==NULL) || (rp->mode==READ))
		return (EOF);
	
	if ((rp->mode==WRITE) || (rp->mode==APPEND))
	{
		addr_temp = (clust_to_addr(rp->clus_current) + ((rp->sec_offset-1)*BPB_BytsPerSec));
		for (n=0; n<BPB_BytsPerSec; n++)	// Save file buffer to SD buffer
			_FF_buff[n] = rp->buff[n];
		if (_FF_write(addr_temp)==0)	// Write SD buffer to disk
			return (EOF);
		if (append_toc(rp)==0)	// Update Entry or Error
			return (EOF);
	}
	
	return (0);
}
#endif		


// Close an open file
int fclose(FILE *rp)	
{
	#ifndef _READ_ONLY_
	if (rp->mode!=READ)
		if (fflush(rp)==EOF)
			return (EOF);
	#endif	
	// Clear File Structure
	free(rp);
	rp = 0;
	return(0);
}

int ffreemem(FILE *rp)	
{
	// Clear File Structure
	if (rp==0)
		return (EOF);
	free(rp);
	return(0);
}

int fget_file_infoc(unsigned char flash *NAMEC, unsigned long *F_SIZE, unsigned char *F_CREATE,
				unsigned char *F_MODIFY, unsigned char *F_ATTRIBUTE, unsigned int *F_CLUS_START)
{
	int c;
	unsigned char sd_temp[12];
	
	for (c=0; c<12; c++)
		sd_temp[c] = NAMEC[c];
	
	c = fget_file_info(sd_temp, F_SIZE, F_CREATE, F_MODIFY, F_ATTRIBUTE, F_CLUS_START);
	return (c);
}

int fget_file_info(unsigned char *NAME, unsigned long *F_SIZE, unsigned char *F_CREATE,
				unsigned char *F_MODIFY, unsigned char *F_ATTRIBUTE, unsigned int *F_CLUS_START)
{
	unsigned char n;
	unsigned int s, calc_temp;
	unsigned long addr_temp, file_calc_temp;
	unsigned char *sp, *qp;
	
	// Get the filename into a form we can use to compare
	qp = file_name_conversion(NAME);
	if (qp==0)
	{
		_FF_error = NAME_ERR;
		return (EOF);
	}
	
	for (s=0; s<BPB_BytsPerSec; s++)
	{	// Scan through directory entries to find file
		addr_temp = _FF_DIR_ADDR + (0x200 * s);
		if (_FF_read(addr_temp)==0)
			return (EOF);
		for (n=0; n<16; n++)
		{
			calc_temp = (int) n * 0x20;
			qp = &FILENAME[0];
			sp = &_FF_buff[calc_temp];
			if (*sp == 0)
				return (EOF);
			if (strncmp(qp, sp, 11)==0)		// Does this entry == Filename
			{
				*F_ATTRIBUTE = _FF_buff[calc_temp+11];	// Save ATTRIBUTE Byte to location
				*F_SIZE = ((long) _FF_buff[calc_temp+31] << 24) | ((long) _FF_buff[calc_temp+30] << 16)
							| ((long) _FF_buff[calc_temp+29] << 8) | ((long) _FF_buff[calc_temp+28]);
							// Save SIZE of file to location
                *F_CLUS_START = ((unsigned int) _FF_buff[calc_temp+27] << 8) | ((unsigned int) _FF_buff[calc_temp+26]);
				file_calc_temp = ((unsigned int) _FF_buff[calc_temp+17] << 8) | ((unsigned int) _FF_buff[calc_temp+16]);
				qp = F_CREATE;
				*qp++ = (((file_calc_temp >> 5) & 0x0F) / 10) + '0';
				*qp++ = (((file_calc_temp >> 5) & 0x0F) % 10) + '0';
				*qp++ = '/';
				*qp++ = ((file_calc_temp & 0x1F) / 10) + '0';
				*qp++ = ((file_calc_temp & 0x1F) % 10) + '0';
				*qp++ = '/';
				file_calc_temp = ((file_calc_temp >> 9) & 0x7F) + 1980;
				*qp++ = (file_calc_temp / 1000) + '0';
				file_calc_temp %= 1000;
				*qp++ = (file_calc_temp / 100) + '0';
				file_calc_temp %= 100;
				*qp++ = (file_calc_temp / 10) + '0';
				*qp++ = (file_calc_temp % 10) + '0';
				*qp++ = ' ';
				*qp++ = ' ';
				file_calc_temp = ((unsigned int) _FF_buff[calc_temp+15] << 8) | ((unsigned int) _FF_buff[calc_temp+14]);
				*qp++ = (((file_calc_temp >> 11) & 0x1F) / 10) + '0';
				*qp++ = (((file_calc_temp >> 11) & 0x1F) % 10) + '0';
				*qp++ = ':';
				*qp++ = (((file_calc_temp >> 5) & 0x3F) / 10) + '0';
				*qp++ = (((file_calc_temp >> 5) & 0x3F) % 10) + '0';
				*qp++ = ':';
				*qp++ = (((file_calc_temp & 0x1F) * 2) / 10) + '0';
				*qp++ = (((file_calc_temp & 0x1F) * 2) % 10) + '0';
				*qp = 0;
				
				file_calc_temp = ((unsigned int) _FF_buff[calc_temp+25] << 8) | ((unsigned int) _FF_buff[calc_temp+24]);
				qp = F_MODIFY;
				*qp++ = (((file_calc_temp >> 5) & 0x0F) / 10) + '0';
				*qp++ = (((file_calc_temp >> 5) & 0x0F) % 10) + '0';
				*qp++ = '/';
				*qp++ = ((file_calc_temp & 0x1F) / 10) + '0';
				*qp++ = ((file_calc_temp & 0x1F) % 10) + '0';
				*qp++ = '/';
				file_calc_temp = ((file_calc_temp >> 9) & 0x7F) + 1980;
				*qp++ = (file_calc_temp / 1000) + '0';
				file_calc_temp %= 1000;
				*qp++ = (file_calc_temp / 100) + '0';
				file_calc_temp %= 100;
				*qp++ = (file_calc_temp / 10) + '0';
				*qp++ = (file_calc_temp % 10) + '0';
				*qp++ = ' ';
				*qp++ = ' ';
				file_calc_temp = ((unsigned int) _FF_buff[calc_temp+23] << 8) | ((unsigned int) _FF_buff[calc_temp+22]);
				*qp++ = (((file_calc_temp >> 11) & 0x1F) / 10) + '0';
				*qp++ = (((file_calc_temp >> 11) & 0x1F) % 10) + '0';
				*qp++ = ':';
				*qp++ = (((file_calc_temp >> 5) & 0x3F) / 10) + '0';
				*qp++ = (((file_calc_temp >> 5) & 0x3F) % 10) + '0';
				*qp++ = ':';
				*qp++ = (((file_calc_temp & 0x1F) * 2) / 10) + '0';
				*qp++ = (((file_calc_temp & 0x1F) * 2) % 10) + '0';
				*qp = 0;
				
				return (0);
			}
		}                          		
	}
	_FF_error = FILE_ERR;
	return(EOF);
}

// Get File data and increment file pointer
int fgetc(FILE *rp)
{
	unsigned char get_data;
	unsigned int n;
	unsigned long addr_temp;
	
	if (rp==NULL)
		return (EOF);

	if (rp->position == rp->length)
	{
		rp->error = POS_ERR;
		return (EOF);
	}
	
	get_data = *rp->pntr;
	
	if ((rp->pntr)==(&rp->buff[BPB_BytsPerSec-1]))
	{	// Check to see if pointer is at the end of a sector
		#ifndef _READ_ONLY_
		if ((rp->mode==WRITE) || (rp->mode==APPEND))
		{	// if in write or append mode, update the current sector before loading next
			for (n=0; n<BPB_BytsPerSec; n++)
				_FF_buff[n] = rp->buff[n];
			addr_temp = clust_to_addr(rp->clus_current) + (((rp->sec_offset)-1)*BPB_BytsPerSec);
			if (_FF_write(addr_temp)==0)
				return (EOF);
		}
		#endif
		if (rp->sec_offset < BPB_SecPerClus)
		{	// Goto next sector if not at the end of a cluster
			addr_temp = clust_to_addr(rp->clus_current) + (rp->sec_offset*BPB_BytsPerSec);
			rp->sec_offset++;
		}
		else
		{	// End of Cluster, find next
			if (rp->clus_next>=0xFFF8)	// No next cluster, EOF marker
			{
				rp->EOF_flag = 1;	// Set flag so Putchar knows to get new cluster
				rp->position++;		// Only time doing this, position + 1 should equal length
				return(get_data);
			}
			addr_temp = clust_to_addr(rp->clus_next);
			rp->sec_offset = 1;
			rp->clus_prev = rp->clus_current;
			rp->clus_current = rp->clus_next;
			rp->clus_next = next_cluster(rp->clus_current, SINGLE);
		}
		if (_FF_read(addr_temp)==0)
			return (EOF);
		for (n=0; n<BPB_BytsPerSec; n++)
			rp->buff[n] = _FF_buff[n];
		rp->pntr = &rp->buff[0];
	}
	else
		rp->pntr++;
	
	rp->position++;	
	return(get_data);		
}

char *fgets(char *buffer, int n, FILE *rp)
{
	int c, temp_data;
	
	for (c=0; c<n; c++)
	{
		temp_data = fgetc(rp);
		*buffer = temp_data & 0xFF;
		if (temp_data == '\n')
			break;
		else if (temp_data == EOF)
			break;
		buffer++;
	}
	if (c==n)
		buffer++;
	*buffer-- = '\0';
	if (temp_data == EOF)
		return (NULL);
	return (buffer);
}

#ifndef _READ_ONLY_
// Decrement file pointer, then get file data
int ungetc(unsigned char file_data, FILE *rp)
{
	unsigned int n;
	unsigned long addr_temp;
	
	if ((rp==NULL) || (rp->position==0))
		return (EOF);
	if ((rp->mode!=APPEND) && (rp->mode!=WRITE))
		return (EOF);	// needs to be in WRITE or APPEND mode

	if (((rp->position) == rp->length) && (rp->EOF_flag))
	{	// if the file posisition is equal to the length, return data, turn flag off
		rp->EOF_flag = 0;
		*rp->pntr = file_data;
		return (*rp->pntr);
	}
	if ((rp->pntr)==(&rp->buff[0]))
	{	// Check to see if pointer is at the beginning of a Sector
		// Update the current sector before loading next
		for (n=0; n<BPB_BytsPerSec; n++)
			_FF_buff[n] = rp->buff[n];
		addr_temp = clust_to_addr(rp->clus_current) + (((rp->sec_offset)-1)*BPB_BytsPerSec);
		if (_FF_write(addr_temp)==0)
			return (EOF);
			
		if (rp->sec_offset > 1)
		{	// Goto previous sector if not at the beginning of a cluster
			addr_temp = clust_to_addr(rp->clus_current) + ((rp->sec_offset-2)*BPB_BytsPerSec);
			rp->sec_offset--;
		}
		else
		{	// Beginning of Cluster, find previous
			if (rp->clus_start==rp->clus_current)
			{	// Positioned @ Beginning of File
				_FF_error = SOF_ERR;
				return(EOF);
			}
			rp->sec_offset = BPB_SecPerClus;	// Set sector offset to last sector
			rp->clus_next = rp->clus_current;
			rp->clus_current = rp->clus_prev;
			if (rp->clus_current != rp->clus_start)
				rp->clus_prev = prev_cluster(rp->clus_current);
			else
				rp->clus_prev = 0;
			addr_temp = clust_to_addr(rp->clus_current) + (((long) BPB_SecPerClus-1) * (long) BPB_BytsPerSec);
		}
		_FF_read(addr_temp);
		for (n=0; n<BPB_BytsPerSec; n++)
			rp->buff[n] = _FF_buff[n];
		rp->pntr = &rp->buff[511];
	}
	else
		rp->pntr--;
	
	rp->position--;
	*rp->pntr = file_data;	
	return(*rp->pntr);	// Get data	
}
#endif

#ifndef _READ_ONLY_
int fputc(unsigned char file_data, FILE *rp)	
{
	unsigned int n;
	unsigned long addr_temp;
	
	if (rp==NULL)
		return (EOF);

	if (rp->mode == READ)
	{
		_FF_error = READONLY_ERR;
		return(EOF);
	}
	if (rp->length == 0)
	{	// Blank file start writing cluster table
		rp->clus_start = prev_cluster(0);
		rp->clus_next = 0xFFFF;
		rp->clus_current = rp->clus_start;
		if (write_clus_table(rp->clus_start, rp->clus_next, SINGLE)==0)
		{
			return (EOF);
		}
	}
	
	if ((rp->position==rp->length) && (rp->EOF_flag))
	{	// At end of file, and end of cluster, flagged
		rp->clus_prev = rp->clus_current;
		rp->clus_current = prev_cluster(0);	// Find first cluster pointing to '0'
		rp->clus_next = 0xFFFF;
		rp->sec_offset = 1;
		if (write_clus_table(rp->clus_prev, rp->clus_current, CHAIN)==0)
		{
			return (EOF);
		}
		if (write_clus_table(rp->clus_current, rp->clus_next, END_CHAIN)==0)
		{
			return (EOF);
		}
		if (append_toc(rp)==0)
		{
			return (EOF);
		}
		rp->EOF_flag = 0;
		rp->pntr = &rp->buff[0];		
	}
	
	*rp->pntr = file_data;
	
	if (rp->pntr == &rp->buff[BPB_BytsPerSec-1])
	{	// This is on the Sector Limit
		if (rp->position > rp->length)
		{	// ERROR, position should never be greater than length
			_FF_error = 0x10;		// file position ERROR
			return (EOF); 
		}
		// Position is at end of a sector?
		
		addr_temp = (clust_to_addr(rp->clus_current) + ((rp->sec_offset-1)*BPB_BytsPerSec));
		for (n=0; n<BPB_BytsPerSec; n++)
			_FF_buff[n] = rp->buff[n];
		_FF_write(addr_temp);
			// Save MMC buffer to card, set pointer to begining of new buffer
		if (rp->sec_offset < BPB_SecPerClus)
		{	// Are there more sectors in this cluster?
			addr_temp = clust_to_addr(rp->clus_current) + (rp->sec_offset * BPB_BytsPerSec);
			rp->sec_offset++;
		}
		else
		{	// Find next cluster, load first sector into file.buff
			if (((rp->clus_next>=0xFFF8)&&(BPB_FATType==0x36)) ||
				((rp->clus_next>=0xFF8)&&(BPB_FATType==0x32)))
			{	// EOF, need to find new empty cluster
				if (rp->position != rp->length)
				{	// if not equal there's an error
					_FF_error = 0x20;		// EOF position error
					return (EOF);
				}
				rp->EOF_flag = 1;
			}
			else
			{	// Not EOF, find next cluster
				rp->clus_prev = rp->clus_current;
				rp->clus_current = rp->clus_next;
				rp->clus_next = next_cluster(rp->clus_current, SINGLE);
			}
			rp->sec_offset = 1;
			addr_temp = clust_to_addr(rp->clus_current);
		}
		
		if (rp->EOF_flag == 0)
		{
			if (_FF_read(addr_temp)==0)
				return(EOF);
			for (n=0; n<512; n++)
				rp->buff[n] = _FF_buff[n];
			rp->pntr = &rp->buff[0];	// Set pointer to next location				
		}
		if (rp->length==rp->position)
			rp->length++;
		if (append_toc(rp)==0)
			return(EOF);
	}
	else
	{
		rp->pntr++;
		if (rp->length==rp->position)
			rp->length++;
	}
	rp->position++;
	return(file_data);
}

int fputs(unsigned char *file_data, FILE *rp)
{
	while(*file_data)
		if (fputc(*file_data++,rp) == EOF)
			return (EOF);
	if (fputc('\r',rp) == EOF)
		return (EOF);
	if (fputc('\n',rp) == EOF)
		return (EOF);
	return (0);
}

int fputsc(flash unsigned char *file_data, FILE *rp)
{
	while(*file_data)
		if (fputc(*file_data++,rp) == EOF)
			return (EOF);
	if (fputc('\r',rp) == EOF)
		return (EOF);
	if (fputc('\n',rp) == EOF)
		return (EOF);
	return (0);
}
#endif

//#ifndef _READ_ONLY_
#ifdef _CVAVR_
void fprintf(FILE *rp, unsigned char flash *pstr, ...)
{
	va_list arglist;
	unsigned char temp_buff[_FF_MAX_FPRINT], *fp;
	
	va_start(arglist, pstr);
	vsprintf(temp_buff, pstr, arglist);
	va_end(arglist);
	
	fp = temp_buff;
	while (*fp)
		fputc(*fp++, rp);	
}
#endif
#ifdef _ICCAVR_
void fprintf(FILE *rp, unsigned char flash *pstr, long var)
{
	unsigned char temp_buff[_FF_MAX_FPRINT], *fp;
	
	csprintf(temp_buff, pstr, var);
	
	fp = temp_buff;
	while (*fp)
		fputc(*fp++, rp);	
}
#endif
//#endif

// Set file pointer to the end of the file
int fend(FILE *rp)
{
	return (fseek(rp, 0, SEEK_END));	
}

// Goto position "off_set" of a file
int fseek(FILE *rp, unsigned long off_set, unsigned char mode)
{
	unsigned int n, clus_temp;
	unsigned long length_check, addr_calc;
	
	if (rp==NULL)
	{	// ERROR if FILE pointer is NULL
		_FF_error = FILE_ERR;
		return (EOF);
	}
	if (mode==SEEK_CUR)
	{	// Trying to position pointer to offset from current position
		off_set += rp->position;
	}
	if (off_set > rp->length)
	{	// trying to position beyond or before file
		rp->error = POS_ERR;
		_FF_error = POS_ERR;
		return (EOF);
	}
	if (mode==SEEK_END)
	{	// Trying to position pointer to offset from EOF
		off_set = rp->length - off_set;
	}
	#ifndef _READ_ONLY_
	if (rp->mode != READ)
		if (fflush(rp))
			return (EOF);
	#endif
	clus_temp = rp->clus_start;
	rp->clus_current = clus_temp;
	rp->clus_next = next_cluster(clus_temp, SINGLE);
	rp->clus_prev = 0;
	
	addr_calc = off_set / ((long) BPB_BytsPerSec * (long) BPB_SecPerClus);
	length_check = off_set % ((long) BPB_BytsPerSec * (long) BPB_SecPerClus);
	rp->EOF_flag = 0;

	while (addr_calc)
	{
		if (rp->clus_next >= 0xFFF8)
		{	// trying to position beyond or before file
			if ((addr_calc==1) && (length_check==0))
			{
				rp->EOF_flag = 1;
				break;
			}				
			rp->error = POS_ERR;
			_FF_error = POS_ERR;
			return (EOF);
		}
		clus_temp = rp->clus_next;
		rp->clus_prev = rp->clus_current;
		rp->clus_current = clus_temp;
		rp->clus_next = next_cluster(clus_temp, CHAIN);
		addr_calc--;
	}
	
	addr_calc = clust_to_addr(rp->clus_current);
	rp->sec_offset = 1;			// Reset Reading Sector
	while (length_check >= BPB_BytsPerSec)
	{
		addr_calc += BPB_BytsPerSec;
		length_check -= BPB_BytsPerSec;
		rp->sec_offset++;
	}
	
	if (_FF_read(addr_calc)==0)		// Read Current Data Sector
		return(EOF);		// Read Error  
		
	for (n=0; n<BPB_BytsPerSec; n++)
		rp->buff[n] = _FF_buff[n];
    
    if ((rp->EOF_flag == 1) && (length_check == 0))
    	rp->pntr = &rp->buff[BPB_BytsPerSec-1];
	rp->pntr = &rp->buff[length_check];
	rp->position = off_set;
		
	return (0);	
}

// Return the current position of the file rp with respect to the begining of the file
long ftell(FILE *rp)
{
	if (rp==NULL)
		return (EOF);
	else
		return (rp->position);
}

// Funtion that returns a '1' for @EOF, '0' otherwise
int feof(FILE *rp)
{
	if (rp==NULL)
		return (EOF);
	
	if (rp->length==rp->position)
		return (1);
	else
		return (0);
}
		
void dump_file_data_hex(FILE *rp)
{
	unsigned int n, c;
	
	if (rp==NULL)
		return;

	for (n=0; n<0x20; n++)
	{   
		printf("\n\r");
		for (c=0; c<0x10; c++)
			printf("%02X ", rp->buff[(n*0x20)+c]);
	}
}

void dump_file_data_view(FILE *rp)
{
	unsigned int n;
	
	if (rp==NULL)
		return;

	printf("\n\r");
	for (n=0; n<512; n++)
		putchar(rp->buff[n]);
}

