/*****************************************************
/Управляющая программа контроллера Д2Т

Project : I2C_interface
Version : 1
Date    : 24.02.2006
Author  : Michael           
Company : Sp-Tv       
Comments: 
Программа для MEGA128


Chip type           : ATmega128
Program type        : Application
Clock frequency     : 8,000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 1024
*****************************************************/
#include <mega128.h>

#include "I2C_mega128.h"                //Подключаем настройки выводов
                        

#define CRST PORTA.2                             //Вывод Reset для подчиненных устройств

//Адреса
#define Addr 0x0                                 //Адрес подчиненного устройства

//Переменные


#define RXB8 1
#define TXB8 0
#define UPE 2
#define OVR 3
#define FE 4
#define UDRE 5
#define RXC 7

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART0 Receiver buffer
#define RX_BUFFER_SIZE0 256
char rx_buffer0[RX_BUFFER_SIZE0];

#if RX_BUFFER_SIZE0<256
unsigned char rx_wr_index0,rx_rd_index0,rx_counter0;
#else
unsigned int rx_wr_index0,rx_rd_index0,rx_counter0;
#endif

//////////////////////////////////////////////////////////////////////////
/// Биты сигнализации

bit rx_buffer_overflow0;        // This flag is set on USART0 Receiver buffer overflow
bit rx_USART_packet = 0;        // Флаг получения полного пакета по UART
bit rx_USART_starting = 0;      // Признак процесса приема пакета по USART

// USART0 Receiver interrupt service routine
interrupt [USART0_RXC] void usart0_rx_isr(void)
{
char status,data;
status=UCSR0A;
data=UDR0;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   if (rx_USART_starting == 0) 
        {
        if (data != 'q') {return;}              //проверяем заголовок пакета  
//        rx_USART_starting = 1;
        }
   rx_buffer0[rx_wr_index0]=data;
   if (++rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
   if (++rx_counter0 == RX_BUFFER_SIZE0)
      {
      rx_counter0=0;
      rx_buffer_overflow0=1;  
      };
    
  }; 
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART0 Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter0==0);
data=rx_buffer0[rx_rd_index0];
if (++rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
#asm("cli")
--rx_counter0;
#asm("sei")
return data;
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>
#include <delay.h>

// 2 Wire bus interrupt service routine
interrupt [TWI] void twi_isr(void)
{
// Place your code here

}




// Declare your global variables here

void twi_init(void);
unsigned char twi_start (void);
void twi_stop (void);        
unsigned char twi_addr (unsigned char addr);
unsigned char twi_byte (unsigned char data); 


///////////////////////////////////////////////
//Reset подчиненных устройств
void Reset (void)
        {
        CRST = 0;
        delay_ms(10);
        CRST = 1;
        delay_ms(250);     //Ждем пока отработают сброс
        }

eeprom unsigned char dummy = 33;

void main(void)
{
// Declare your local variables here 
        unsigned char   long_packet,
                        address_packet,
                        type_packet,
                        k;
        
// Input/Output Ports initialization

PORTA=0x01;     //два мл. бита - светодиод
DDRA=0x07;

PORTB=0x00;
DDRB=0x00;

PORTC=0x00;
DDRC=0x00;

PORTD=0x00;
DDRD=0x00;

PORTE=0x00;
DDRE=0x00;

PORTF=0x00;
DDRF=0x00;

PORTG=0x00;
DDRG=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=FFh
// OC0 output: Disconnected
ASSR=0x00;
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer 1 Stopped
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
OCR1CH=0x00;
OCR1CL=0x00;

// Timer/Counter 2 initialization
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// Timer/Counter 3 initialization
TCCR3A=0x00;
TCCR3B=0x00;
TCNT3H=0x00;
TCNT3L=0x00;
ICR3H=0x00;
ICR3L=0x00;
OCR3AH=0x00;
OCR3AL=0x00;
OCR3BH=0x00;
OCR3BL=0x00;
OCR3CH=0x00;
OCR3CL=0x00;

// External Interrupt(s) initialization
// Все Off
EICRA=0x00;
EICRB=0x00;
EIMSK=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;
ETIMSK=0x00;

// USART0 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART0 Receiver: On
// USART0 Transmitter: On
// USART0 Mode: Asynchronous
// USART0 Baud rate: 38400
UCSR0A=0x00;
UCSR0B=0x98;
UCSR0C=0x06;
UBRR0H=0x00;
UBRR0L=0x0C;

// Analog Comparator initialization
ACSR=0x80;
SFIOR=0x00;

   twi_init ();             // Инициализируем I2C
   Reset ();                //Даем сброс всем подчиненным устройствам    
   

// Global enable interrupts
#asm("sei")
                LedGreen();                     // Первоначальные установки...   
                long_packet = 0;                // обнуляем признаки принимаемого по USART пакета                
                address_packet = 0;
                type_packet = 0;
        
while (1)
      {
               
                k = getchar ();

//        if (rx_buffer_overflow0 == 1)
        {
       
                LedRed();                             //Старт...  
                 if (!twi_start())                    
                        {
                        twi_stop();        
                        continue;
     		        }

		if (!twi_addr((Addr<<1)&0b11111110))
        		{
                        twi_stop();        
                        continue;
                        }


		if (!twi_byte (k))
		        {
                        twi_stop();        
                        continue;
	                }

        	twi_stop();

                LedGreen();                     // ОК.

         }
      
      }
}
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
