///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 
// ����� � ������� �����

#include <Coding.h>

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

// ��� ������ ��������� ������� ��������
static void twi_wait_int (void)
{

	while (!(TWCR & (1<<TWINT)))
		{
			   if ( flagTWI & ( 1<< time_is_Out))  break;  // ������� �� ���� - ����
		}; 
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

	twi_wait_int();                 		// ���� ������ 

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
unsigned char  twi_read (unsigned char notlast)
{
	timeOut ();									// ��������� ���� ���

	twi_wait_int();   

	if(notlast)     // ��������� ������������� ������
		{
			TWCR = ((1<<TWINT)+(1<<TWEA)+(1<<TWEN));
		}
		else            // �� ��������� ������������� ������
		{
			TWCR = ((1<<TWINT)+(1<<TWEN));
		}
 	twi_wait_int();    

 	timeOutStop ();							// ������� ������� ��������   

		return TWDR;
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
     
////////////////////////////////////////////////////////////////////////////////
// ������ � ���������� �������

unsigned char tx1crc;
unsigned char rx1state = RX_IDLE;
unsigned char rx1crc;
unsigned char rx1len;
unsigned char rx1buf[256];
unsigned char rx1ptr;

/*// �������� ����� �� "����������" �����
void putword1(unsigned int wd)
{
	putchar1(wd);
	putchar1(wd >> 8);
} */

// ������ ������� �� ���������� �����
void StartIntReq(unsigned char dlen) 
{
	while(1)
	{	
		if (!twi_start())       // C���� ������
		{
			twi_stop();
			continue;
		}

		
		if (!twi_addr(0))       // �������� ���� �����������
		{
			twi_stop();
			continue;
		}
		
		break;
	}


	tx1crc = 0;					// ������� CRC

	twi_byte(PACKHDR);		    // ������� ���������
	tx1crc+=(PACKHDR);

	twi_byte(dlen+1);			// ������� �����
	tx1crc+=(dlen+1);
}

// ���������� ������� �� ���������� �����
void EndIntReq(void)
{
	twi_byte(tx1crc);			// ����������� �����
	twi_stop();                 // C���

	
//	rx1state = RX_LEN;			// ��������� ������ ����� ������

//	OCR1B = TCNT1+RX1TIMEOUT;	// ������ ����-���
//	TIFR = 0x08;				// ������������ ������ ������������
//	TIMSK |= 0x08;				// ���������� ���������� �� ����-����
}

// ����� ����� �� "�����������" ������ TWI
void TWI_rx_isr(void)
{
	register unsigned char byt;
	twi_start();                //���������� ���� ������
    	
    
	byt = UDR1;
	
	switch (rx1state)
	{
	case RX_LEN:				// ������� ����� ������
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

	case RX_DATA:				// ������ ���� ������ ������
//printf("D");
		rx1buf[rx1ptr++] = byt;
		if (rx1ptr < rx1len)	// ��� ��� ?
		{
			break;
		}
		rx1state = RX_CRC;
		break;
		
	case RX_CRC:				// ������� ����������� ����� ������
		if (byt != rx1crc)
		{
			rx1state = RX_ERR;	// �� ������� CRC
//printf("C");
		}
		else
		{
			rx1state = RX_OK;	// ����� ������� ������
//printf("+");
		}

		TIMSK &= 0x08 ^ 0xFF;	// ��������� ���������� �� ����-����
		break;

	default:					// � ��������� ���������� - ������ �� ������
		break;
	}

	rx1crc += byt;				// ����������� ����������� �����
} 

// ���������� �� ��������� B ������� 1 ��� �������� ����-���� ������ "�����������" ������
interrupt [TIM1_COMPB] void timer1_comp_b_isr(void)
{
	rx1state = RX_TIME;		// ��� ����-���
	TIMSK &= 0x08 ^ 0xFF;	// ��������� ���������� �� ����-����
//printf("T");
}

// �������� ��������� "�����������" ������
unsigned char InternalComBusy(void)
{
	if (rx1state != RX_IDLE)	return 1;
	else						return 0;
}

// ������� ���������� ����� ������ �� ������ ������
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

// ���������� ������� ����� ���������� ��������� ��������� �� "�����������" ������ ������
void FreeInternalCom(void)
{
	rx1state = RX_IDLE;
}

// �������� ����� byte �� pAddr
unsigned char txTWIbyte (unsigned char pAddr, unsigned char byte)
	{  

		timeOut ();									// ��������� ���� ���

		if (!twi_start())     		  				// C���� ������
			{
				twi_stop();
			}
		
		if (!twi_addr((pAddr<<1)+0))       // ��������  �� ������ pAddr (�� 0 - ������)
			{
				twi_stop();
			}            
			
		twi_byte(byte);								// �������� ����
		twi_stop();									// ���� ������

		timeOutStop ();							// ������� ������� ��������   
		
	    if ( ! ( flagTWI & ( 1 << time_is_Out))) return 255;
	    	else 
	    		{
					flagTWI  = flagTWI  ^ (1 << time_is_Out);	//����������  �������
					return 0;
	    		}
	}

unsigned char txTWIbuff (unsigned char pAddr)
	{                                                                           
		unsigned char a ;
		
		timeOut ();									// ��������� ���� ���
		if (!twi_start())     		  				// C���� ������
			{
				twi_stop();
			}

		if (!twi_addr((pAddr<<1)+0))       // ��������  �� ������ pAddr (�� 0 - ������)
			{
				twi_stop();
			}            

	twi_wait_int(); 					// ���� ������ �� �����

		for (a=0;a<=txBuffer[1]+1;a++)     //�����+���������
			{		                         
				twi_byte(txBuffer[a]);				// �������� ����
			}		

			twi_stop();									// ���� ������
			timeOutStop ();							// ������� ������� ��������   
		
	    	if ( ! ( flagTWI & ( 1 << time_is_Out))) return 255;
	    		else 
	    			{
						flagTWI  = flagTWI  ^ (1 << time_is_Out);	//����������  �������
						return 0;
		    		}
	}
	

// ���������� � ������
unsigned char rxTWIbuff (unsigned char pAddr)
		{                                                         
		unsigned char a;

		if (!twi_start())     		  				// C���� ������
			{
				twi_stop();
			}

		if (!twi_addr((pAddr<<1)+1))       // ��������  �� ������ pAddr (�� 1 - ������)
			{
				twi_stop();
			}            

		rxBuffer[0] = twi_read(1);				// ������  � ����������  ����� ������������ ������

		for (a=1; a<rxBuffer[0];  a++)
			{
				rxBuffer[a] = twi_read(1);			// �� ����. ���� - ��������� ACK
			}              

				rxBuffer[a] = twi_read(0);			// ����. ���� -  �� ��������� ACK

			twi_stop();									// ���� ������               
			
						// ��������� ������� � CRC
	    	if ( (! ( flagTWI & ( 1 << time_is_Out))) && (rxCRC())) return 255;	//Ok
    		else 
	    			{
						flagTWI  = flagTWI  ^ (1 << time_is_Out);		//����������  �������
						return 0;                                                          // Time Out
		    		}
		}