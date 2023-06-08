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

static inline void NhardwareInit(void)
{
/*
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
*/
}

void main(void)
{
	HardwareInit();			// Железо процессора
	CommInit();				// Работа с COM-портом

	#asm("sei")

	while (1)
	{
		// Проверяю, нет ли пакета и принимаю меры, если есть
		if (HaveIncomingPack())
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
			
			default:
				DiscardIncomingPack();
				break;
			}
		}
	}

/*
// Declare your local variables here 
        unsigned char   long_packet,
                        address_packet,
                        type_packet,
                        k;
        

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
*/
}