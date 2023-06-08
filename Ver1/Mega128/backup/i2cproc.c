///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 
// ����� � ������� �����

#include <mega128.h>

// ���� TWCR
#define TWINT 7
#define TWEA  6
#define TWSTA 5
#define TWSTO 4
#define TWWC  3
#define TWEN  2
#define TWIE  0

// ���������
#define START		0x08
#define	REP_START	0x10

// ���� �������
#define	MTX_ADR_ACK		0x18
#define	MRX_ADR_ACK		0x40
#define	MTX_DATA_ACK	0x28
#define	MRX_DATA_NACK	0x58
#define	MRX_DATA_ACK	0x50

// ���������� ����������� ������� I2C
void twi_init (void)
{
	TWSR=0x00;
	TWBR=0x20;
	TWAR=0x00;
	TWCR=0x04;
}

// ��� ������
static void twi_wait_int (void)
{
	while (!(TWCR & (1<<TWINT))); 
}

// ��������� �������
// ���������� �� 0, ���� ��� � �������
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

// �������� �������
void twi_stop (void)
{
	TWCR = ((1<<TWEN)+(1<<TWINT)+(1<<TWSTO));
}

// �������� ������
// ���������� �� 0, ���� ��� � �������
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

// �������� ����� ������
// ���������� �� 0, ���� ��� � �������
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

// ������ �����
// ���������� �� 0, ���� ��� � �������
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

// ��������� �������� ���� �����
static inline void PortBitChange(unsigned char port, unsigned char bnum, unsigned char set)
{
	register unsigned char mask;
	#asm("cli");

	mask = 1 << bnum;		// �����
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

// �������� ������� �� FLASH � I2C
void i2c_tab (flash unsigned char * tbl, void (* rwfunc)(void))
{
	register unsigned char n, p;
	register flash unsigned char * ptr;
	
	while(1)
	{
		if (rwfunc)			// ���� �����, �������� �������� ����������
		{
			(*rwfunc)();
		}
		
		n = *tbl++;
		
		if (!n)				// ���� ������ ������ ���������� ...
		{
			return;
		}

		if (n == 255)		// ���� ������� ���� ����� ���������� ...
		{
			p = *tbl++;						// ���� B, C ��� D
			n = *tbl++;						// ����� ����
			PortBitChange(p, n, *tbl++);	// ������� ��� ��������
			continue;						// � ��������� ������
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
// �������� � �������� ����� I2C nbytes ����
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

// �������� � �������� ����� I2C ������� PSI
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

	twi_byte(0x47);			// ��������� ������
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
