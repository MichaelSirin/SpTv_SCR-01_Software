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