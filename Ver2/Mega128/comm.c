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
  
