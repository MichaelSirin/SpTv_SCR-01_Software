/*****************************************************
This program was produced by the
CodeWizardAVR V1.24.5 Standard
Automatic Program Generator
© Copyright 1998-2005 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com
e-mail:office@hpinfotech.com

Project : 
Version : 
Date    : 01.03.2006
Author  : TeleSys Embedded                
Company : FastmanSoft Inc.                
Comments: 


Chip type           : ATmega8
Program type        : Application
Clock frequency     : 8,000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 256
*****************************************************/

#include <mega8.h> 
#include "string.h"  


// Standard Input/Output functions
#include <stdio.h>
#include <delay.h>
#include <CDdef.h>					// мой описатель

//unsigned char Count1	=	0,  Count	=	0, lPack = 0;	
unsigned char rxBuffer[256];							// приемный буффер
unsigned char txBuffer[256];								// передающий буффер

unsigned char Count1	=	0,  Count	=	0, CRCPackRX = 0;	
unsigned char Count2	=	0,  Count3 =	0; 
unsigned char CountUART = 0, CountUART_1 = 0;      




/*
// Жду флажка
static void twi_wait_int (void)
{
	while (!(TWCR & (1<<TWINT))); 
}
  
*/
	// Флаги состояния
bit 		ping		 			=		0;									// Признак что прошел первый пинг		
bit		dPresent			=		0;									// признак наличия подкл. устройства
bit		time_is_Out		=		0;									// Сработал тайм - аут        
bit		startPacket		=		0;									// принят признак старта приема
bit		rxPack				=		0;									// принят пакет																						
bit		txPack				=		0;									// есть данные на передачу
bit 		rxPackUART 		= 		0;									// принят пакет по UART
bit 		tstPort				=		0;									// пора проверить подключенное устройство
bit 		GlobalAddr 		= 		0;									// Признак ""глобального вызова" 
bit		to_Reboot			=		0;									// на перезагрузку в Загрузчик
bit		print					=		0;									// вывести на печать


// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)      
{     
	unsigned char data;
	data = UDR;

	TCNT1H=0x00;						// перезапускаем таймер опроса подч. устройства
	TCNT1L=0x00;


if ((UCSRA & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	{

	if (!(txPack)) 
	{

	if (!(CountUART)) 		            	// Прием с начала
		{ 
			if (!rxPackUART)           // предыдущий пакет передан?
				{
					CountUART_1 = 0;
					txBuffer [CountUART_1++] = data;
					CountUART = data;
				} 
		}
	else
		{                                                  // продолжаем прием пакета
			txBuffer[CountUART_1++] = data;
			if (!(--CountUART)) 				// принят весь пакет
				{
					if (checkCRCtx()) rxPackUART = 1;
				}
		}
     } 
     }
}




// ------------------  Обработка прерывания TWI ---------------------------
// 2 Wire bus interrupt service routine
interrupt [TWI] void twi_isr(void)
{
	// Поступил запрос по нашему адресу
         if (TWSR == D_Call ) GlobalAddr =0;								// локальный адрес
         if (TWSR == G_Call ) GlobalAddr =1;	          // Действия при глобальной адресации

				if (!(Count1))
						{

							if (!startPacket)
								{						
									switch	(TWDR)
										{
											case startPing: 						// принят пинг при опросе кол-ва устройств
												{ 
													ping = 1;  
													break;
												}
											case startPack: 						// принят признак начала пакета
												{ 
													startPacket = 1;	// ставим признак
													Count	= 0;
													rxBuffer [Count++] = TWDR;			// принятый байт - в буффер
													break;
												}
										}
								}
							else 
								{
									Count1 = TWDR;                  // длинна пакета        
									rxBuffer [Count++] = TWDR;
								};
								
	    		 		}
				else
						{
							Count1--;
							rxBuffer[Count++]=TWDR;
							if (!(Count1))
								{
									CRCPackRX	= TWDR;												// КС
									startPacket = 0;						// конец приема пакета
									if (checkCRCrx())	rxPack = 1;	// При CRC-ok -принят пакет
								}
						}
	    	   
	                

//          // Действия при глобальной адресации
//         if (TWSR == G_Call ) 
//                	{
//                		putchar (TWDR);
//                	}    
                


		// отправляем в ответ сформированный буффер
         if ((TWSR == D_Responce)||(TWSR == Addr_Responce))
         	{
				if (!(Count3))
						{
							if (!txPack) TWDR = 0;
							else 
								{
									Count2=0;
									Count3 = txBuffer [0]+1;
									TWDR = txBuffer [Count2++]; 
if (print) putchar (TWDR);									 
									Count3--;
								}
						}
				else
						{
							TWDR = txBuffer [ Count2++];
if (print) putchar (TWDR);									 
							Count3--;
							if (!(Count3)) 
								{
									txPack = 0;		//пакет отправлен
print = 0;
								}
						}
         	}

         TWCR = ((1<<TWINT) | (1<<TWEA) | (1<<TWEN) |(1<<TWIE)); //Импульс подтверждения I2C
}
//--------------------------------------------------------------------------------------


// Подключаемые файлы программы
#include <CDlayer2.c>

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization

PORTB=0x00;
DDRB=0x00;

PORTC=0x07;
DDRC=0x00;

PORTD=0x00;
DDRD=0x1C;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 7,813 kHz
TCCR0=0x00;
TCNT0=0x00;


// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 7,813 kHz
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: On
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x85;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x67;
ICR1L=0x69;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer 2 Stopped
// Mode: Normal top=FFh
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x05;


// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud rate: 38400
UCSRA=0x00;
UCSRB=0x98;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x0C;


// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// 2 Wire Bus initialization
// Generate Acknowledge Pulse: On
// 2 Wire Bus Slave Address: 8h
// General Call Recognition: On
// Bit Rate: 400,000 kHz
TWSR=0x00;
TWBR=0x02;
TWAR=(pAddr<<1)+1;
TWCR=0x45;

// Global enable interrupts
#asm("sei")

	    LedOff();
		inidevice();  						// ждем сканирования
	    LedOn();                                                              
putchar (0xab);		
while (1)
      {       

//		if ((!(dPresent)) || (tstPort)) readAddrDevice(); 	 	// если нет устройства - ищем его
		if (rxPack) workINpack();			// принят пакет TWI 
      };
}
