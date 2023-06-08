///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 
// Связь с мнешним миром

#include <mega128.h>

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

// Жду флажка
static void twi_wait_int (void)
{
	while (!(TWCR & (1<<TWINT))); 
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

	twi_wait_int();

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
unsigned char twi_read (unsigned char * pByt, unsigned char notlast)
{
	twi_wait_int();

	if(notlast)
	{
		TWCR = ((1<<TWINT)+(1<<TWEA)+(1<<TWEN));
	}
	else
	{
		TWCR = ((1<<TWINT)+(1<<TWEN));
	}

	twi_wait_int();

	*pByt = TWDR;

 	if(((TWSR == MRX_DATA_NACK)&&(notlast == 0))||(TWSR == MRX_DATA_ACK))
 	{
		return 255;
	}
	
	return 0;
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
