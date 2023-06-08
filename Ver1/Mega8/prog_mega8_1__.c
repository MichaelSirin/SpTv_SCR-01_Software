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
#include <CDlayer3.c>
flash unsigned char device_name[32] =					// Имя устройства
		"Main Program. Port";
eeprom unsigned long my_ser_num = 1;					// Серийный номер устройства
const flash unsigned short my_version = 1;			// Версия софта 
//eeprom unsigned char my_addr = TO_MON;					// Мой адрес - изначально TO_MON

//-----------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------
// Реакция на команду перейти в рабочий режим
void ToWorkMode(void)
{

	// Отправляю ответ
	txBuffer[0] = 1;        						// подтверждаю прием
	txBuffer[1] = 1;        						// подтверждаю прием

	txPack = 1;								// есть данные
}
// Назначение серийного номера устройства
static void SetSerial(void)
{
/*	#define ssp ((RQ_SETSERIAL *)rx0buf)
	
	if (my_ser_num)
	{
		txBuffer[0] = 2;  			//длина
		txBuffer[1] = (RES_ERR);		
		txBuffer[2] = 2;          // КС

		txPack = 1;		// есть пакет на передачу

		return;
	}
	
	my_ser_num = ssp->num;*/
	
		txBuffer[0] = 2;  			//длина
		txBuffer[1] = (RES_OK);		
		txBuffer[2] = 2+(RES_OK);          // КС

		txPack = 1;		// есть пакет на передачу
}

//  Назначение адреса устройства
void Setaddr (void)
	{
		txBuffer[0] = 2;  			//длина
		txBuffer[1] = 0;		
		txBuffer[2] = 2;          // КС

		txPack = 1;		// есть пакет на передачу
	}

// Перезагрузка в режим программирования
static void ToProg(void)
{
	// Отправляю ответ
		txBuffer[0] = 1;  			//длина
		txBuffer[1] = 1;          // КС
		
		txPack = 1;		// есть пакет на передачу
		delay_ms(50);

	// На перезагрузку в монитор
		IVCREG = 1 << IVCE;
		IVCREG = 1 << IVSEL;
		#asm("rjmp 0xC00");
}


// Возвращаю состояние устройства
const char _PT_GETSTATE_[]={20,1,0,'a','a','a','a','a','a','a','a','a','a','a','a','a','a',' ',100,255};
static void GetState(void)
{
	register unsigned char a, crc=0;
	
		memcpyf(txBuffer, _PT_GETSTATE_, _PT_GETSTATE_[0]+1);
		for (a=0;a<=txBuffer[0]-1;a++) 
			{
				crc += txBuffer[a];	//KC
			};
		txBuffer[a] = crc;
print = 1;
		txPack = 1;		// есть пакет на передачу

/*		while (txPack);				// ждем передачи

//		txBuffer[0] = 4;				 			// длина пакета
		txBuffer[1] = 1;
		txBuffer[2] = 1;
		txBuffer[3] = 1;
		txBuffer[4] = 7;//2+lAddr;	 			//КС  
print = 1;

		txPack = 1;		// есть пакет на передачу*/
		
		
} 

// Информация об устройстве:

static void GetInfo(void)
{
	register unsigned char i,a,crc=0;                    
//putchar (0x01);		
	
	// 	заполняю буфер
	txBuffer[0] = 40+1;
	
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
		
		for (a=0;a<=txBuffer[0]-1;a++) crc += txBuffer[a];	//KC
		txBuffer[41] = crc;
	

		txPack = 1;		// есть пакет на передачу 
//putchar (0x02);		
}


// Отвечаем. Заполняем буффер на передачу
void _GetLogAddr (void)
	{
	
		txBuffer[0] = 2;				 			// длина пакета
		txBuffer[1] = lAddr;		  			// лог. адрес
		txBuffer[2] = 2+lAddr;	 			//КС  

		txPack = 1;		// есть пакет на передачу
	
	}  
	
// Отладочные пакеты
void _OP (unsigned char c)
	{
		unsigned char a =0, b;

		txBuffer[0] = c;					// длина пакета

		for (b=0;b< txBuffer [0]; b++)
			{
				a=a+txBuffer [b];
			}                            
			
		txBuffer [b] = a;					//KC

		txPack = 1;		// есть пакет на передачу
		
	}

static void give_GETINFO (void)
{
	
	// 	Начинаю запрос  типа устройства
			putchar ('q');						// заголовок
			putchar (3);							// число байт после этого
			putchar (255);		 				//  адрес (циркулярный)
			putchar (PT_GETINFO);		// тип пакета
			putchar ((PT_GETINFO)+(255)+3+('q'));
				
}

// Подсчет CRC приемного буффера
unsigned char checkCRCrx (void)
	{
		unsigned char a =0, b; 
		for (b=0;b<= rxBuffer [1]; b++)
			{
				a=a+rxBuffer [b];
			} 
		if (a == CRCPackRX) return 255;	 	//Ok
		else return 0;
	}

// Подсчет CRC передающего буффера
unsigned char checkCRCtx (void)
	{
		unsigned char a =0, b;    

		for (b=0;b< txBuffer [0]; b++)
			{
				a=a+txBuffer [b];
			} 
			
		if (a == txBuffer [b]) 
			{
				return 255;	 	//Ok
			}
		else return 0;
	}

// Обрабатываем входящий пакет
void workINpack ( void )
		{
			unsigned char a;

		if (rxBuffer[2]==0)				// проверяем адрес. 0-обработка.Остальное-ретранслируем
			{
					switch (rxBuffer[3])
						{
							case GetLogAddr:				// возвращаем лог. адрес
									_GetLogAddr ();		
									rxPack = 0;				// пакет обработан
									break;

							case OP:							// отладочные пакеты
									readAddrDevice(); 
									rxPack = 0;				// пакет обработан
									break;

							case pingPack :
									LedInv();

									if (rxPackUART) 
										{
											txPack = 1;		 	// есть пакет на передачу
											rxPackUART = 0;	// пакет обработан
										}
									rxPack = 0;					// пакет обработан
									break; 

							default:
									rxPack = 0;					// пакет обработан
										
						}
            }
		else if (rxBuffer[2]==pAddr) 							////////////// Мой адрес. Обращаются ко мне
			{
					switch (rxBuffer[3])
						{
							case PT_GETINFO:			// возвращаем о себе информацию
//print = 1;
									GetInfo();
									rxPack = 0;					// пакет обработан
									break;           

							case PT_GETSTATE:
									GetState();
									rxPack = 0;					// пакет обработан
									break;

					 		case PT_TOPROG:       			// переходим в программирование
									ToProg();
									rxPack = 0;					// пакет обработан
									break;      

					 		case PT_SETADDR:       			// переходим в программирование
									Setaddr();
									rxPack = 0;					// пакет обработан
									break;      
					 		case PT_SETSERIAL:       			// переходим в программирование
									SetSerial();
									rxPack = 0;					// пакет обработан
									break;      


							default:
									rxPack = 0;					// пакет обработан
						}
              }
		else	if(rxBuffer[2] == TO_MON)					// обрабатываем пакет по адресу MONITOR
			{
					switch (rxBuffer[3])
						{
					 		case PT_SETADDR:       			// переходим в программирование
									Setaddr();
									rxPack = 0;					// пакет обработан
									break;      
					 		case PT_SETSERIAL:       			// переходим в программирование
									SetSerial();
									rxPack = 0;					// пакет обработан
									break; 
					 		case PT_TOWORK:       			// переходим в программирование
									ToWorkMode();
									rxPack = 0;					// пакет обработан
									break; 
									     
							default:
									rxPack = 0;					// пакет обработан
						}
			}
		else
				{ 												///////////// иначе ретранслируем
					for (a = 0;a<= (rxBuffer[1]+1); a++)
						{
							putchar (rxBuffer [a]);
						}
					rxPack = 0;					// пакет обработан
				}
			}	

// Обработка пакета, принятого по UART
	void workUARTpack (void)
		{
			LedInv();

			txPack = 1;							// есть пакет на передачу
			rxPackUART = 0;				// пакет обработан
		}			
		


// ----------------------- Обработка прерывания таймера 0 (тайм-аут RS232) --------
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
	TCCR0=0x00;										// Останавливаем таймер
	time_is_Out =1;		// взводим признак окончания таймаута
}
//--------------------------------------------------------------------------------------

// ----------------------- Обработка прерывания таймера 1 ( опрос подключения каждые 10 с) --------
// Timer 1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
	tstPort = 1;						// пора проверить устройство присутствует ли ?
}





// Пускаем таймер таймаута
void timeOutStart (void)
		{
			time_is_Out = 0;			// сброс флага таймаута
			TCNT0=0x00;
			TCCR0=0x05;      									// пускаем таймер
		}

// Пускаем таймер таймаута
void timeOutStop (void)
		{
			TCCR0=0x0;      									// останов таймера
		}

// процесс определения физического адреса порта и ответа
// на первичный пинг (0хАА) главного процессора
void inidevice (void)
		{                                      
		pAddr = ((PINC & 0x7)+1 );			// определяем физический адрес (0-не исп. т.к. Глоб. Вызов)
		TWAR = (pAddr<<1)+1;					// Устанавливаем его для TWI

//		while (! ping);								// ждем первый пинг 0хАА

		}                                  
		
// Прием байта из UART. Контролируем тайм-аутом		
unsigned char havechar(void)
{
	timeOutStart ();													// пускаем таймер
	while (!( UCSRA & (1 << RXC)))
		{
   		    if (time_is_Out)	
   		    	{
	                dPresent = 0;					//  устройство не ответило
					timeOutStop ();				// останов таймера
   			    	return 0;						// если нет байта то проверяем таймаут
   		    	}
		}
	timeOutStop ();								// останов таймера
    dPresent = 1;									//взводим признак наличия устройства

	return 255;
}


// Проверяем что подключено к пору RS232
// Если есть устройство - определяем адрес и вносим в таблицу адресов
// Если нет ничего - сканируем до обнаружения. Сопровождаем морганием светодиода
void 	readAddrDevice (void)                                                          
		{
				give_GETINFO();

				timeOutStart();
				while (!(rxPackUART))					// ждем отклик
				{
					if (time_is_Out )
						{
							LedOn();								// моргаем светодиодом при проблемах связи
			                dPresent = 0;			 			//  устройство не ответило
		    	            lAddr = 0;					 			// Адрес = 0
							break;
						} 
					else  
						{
							dPresent = 1;						// ответило 
							lAddr = txBuffer [37];			// вынимаем адрес из принятого пакта             
							LedOff();							// тушим индикатор проблем

							tstPort = 0;						// устройство присутствует
						}
					
				}        
				timeOutStop();
								
				
				if (dPresent) txPack = 1;					// есть пакет на передачу
				rxPackUART = 0;							// принятый пакет - в отправке
		}

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
