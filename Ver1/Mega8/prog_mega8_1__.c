/*****************************************************
This program was produced by the
CodeWizardAVR V1.24.5 Standard
Automatic Program Generator
� Copyright 1998-2005 Pavel Haiduc, HP InfoTech s.r.l.
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
#include <CDdef.h>					// ��� ���������

//unsigned char Count1	=	0,  Count	=	0, lPack = 0;	
unsigned char rxBuffer[256];							// �������� ������
unsigned char txBuffer[256];								// ���������� ������

unsigned char Count1	=	0,  Count	=	0, CRCPackRX = 0;	
unsigned char Count2	=	0,  Count3 =	0; 
unsigned char CountUART = 0, CountUART_1 = 0;      




/*
// ��� ������
static void twi_wait_int (void)
{
	while (!(TWCR & (1<<TWINT))); 
}
  
*/
	// ����� ���������
bit 		ping		 			=		0;									// ������� ��� ������ ������ ����		
bit		dPresent			=		0;									// ������� ������� �����. ����������
bit		time_is_Out		=		0;									// �������� ���� - ���        
bit		startPacket		=		0;									// ������ ������� ������ ������
bit		rxPack				=		0;									// ������ �����																						
bit		txPack				=		0;									// ���� ������ �� ��������
bit 		rxPackUART 		= 		0;									// ������ ����� �� UART
bit 		tstPort				=		0;									// ���� ��������� ������������ ����������
bit 		GlobalAddr 		= 		0;									// ������� ""����������� ������" 
bit		to_Reboot			=		0;									// �� ������������ � ���������
bit		print					=		0;									// ������� �� ������


// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)      
{     
	unsigned char data;
	data = UDR;

	TCNT1H=0x00;						// ������������� ������ ������ ����. ����������
	TCNT1L=0x00;


if ((UCSRA & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	{

	if (!(txPack)) 
	{

	if (!(CountUART)) 		            	// ����� � ������
		{ 
			if (!rxPackUART)           // ���������� ����� �������?
				{
					CountUART_1 = 0;
					txBuffer [CountUART_1++] = data;
					CountUART = data;
				} 
		}
	else
		{                                                  // ���������� ����� ������
			txBuffer[CountUART_1++] = data;
			if (!(--CountUART)) 				// ������ ���� �����
				{
					if (checkCRCtx()) rxPackUART = 1;
				}
		}
     } 
     }
}




// ------------------  ��������� ���������� TWI ---------------------------
// 2 Wire bus interrupt service routine
interrupt [TWI] void twi_isr(void)
{
	// �������� ������ �� ������ ������
         if (TWSR == D_Call ) GlobalAddr =0;								// ��������� �����
         if (TWSR == G_Call ) GlobalAddr =1;	          // �������� ��� ���������� ���������

				if (!(Count1))
						{

							if (!startPacket)
								{						
									switch	(TWDR)
										{
											case startPing: 						// ������ ���� ��� ������ ���-�� ���������
												{ 
													ping = 1;  
													break;
												}
											case startPack: 						// ������ ������� ������ ������
												{ 
													startPacket = 1;	// ������ �������
													Count	= 0;
													rxBuffer [Count++] = TWDR;			// �������� ���� - � ������
													break;
												}
										}
								}
							else 
								{
									Count1 = TWDR;                  // ������ ������        
									rxBuffer [Count++] = TWDR;
								};
								
	    		 		}
				else
						{
							Count1--;
							rxBuffer[Count++]=TWDR;
							if (!(Count1))
								{
									CRCPackRX	= TWDR;												// ��
									startPacket = 0;						// ����� ������ ������
									if (checkCRCrx())	rxPack = 1;	// ��� CRC-ok -������ �����
								}
						}
	    	   
	                

//          // �������� ��� ���������� ���������
//         if (TWSR == G_Call ) 
//                	{
//                		putchar (TWDR);
//                	}    
                


		// ���������� � ����� �������������� ������
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
									txPack = 0;		//����� ���������
print = 0;
								}
						}
         	}

         TWCR = ((1<<TWINT) | (1<<TWEA) | (1<<TWEN) |(1<<TWIE)); //������� ������������� I2C
}
//--------------------------------------------------------------------------------------


// ������������ ����� ���������
#include <CDlayer2.c>
#include <CDlayer3.c>
flash unsigned char device_name[32] =					// ��� ����������
		"Main Program. Port";
eeprom unsigned long my_ser_num = 1;					// �������� ����� ����������
const flash unsigned short my_version = 1;			// ������ ����� 
//eeprom unsigned char my_addr = TO_MON;					// ��� ����� - ���������� TO_MON

//-----------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------
// ������� �� ������� ������� � ������� �����
void ToWorkMode(void)
{

	// ��������� �����
	txBuffer[0] = 1;        						// ����������� �����
	txBuffer[1] = 1;        						// ����������� �����

	txPack = 1;								// ���� ������
}
// ���������� ��������� ������ ����������
static void SetSerial(void)
{
/*	#define ssp ((RQ_SETSERIAL *)rx0buf)
	
	if (my_ser_num)
	{
		txBuffer[0] = 2;  			//�����
		txBuffer[1] = (RES_ERR);		
		txBuffer[2] = 2;          // ��

		txPack = 1;		// ���� ����� �� ��������

		return;
	}
	
	my_ser_num = ssp->num;*/
	
		txBuffer[0] = 2;  			//�����
		txBuffer[1] = (RES_OK);		
		txBuffer[2] = 2+(RES_OK);          // ��

		txPack = 1;		// ���� ����� �� ��������
}

//  ���������� ������ ����������
void Setaddr (void)
	{
		txBuffer[0] = 2;  			//�����
		txBuffer[1] = 0;		
		txBuffer[2] = 2;          // ��

		txPack = 1;		// ���� ����� �� ��������
	}

// ������������ � ����� ����������������
static void ToProg(void)
{
	// ��������� �����
		txBuffer[0] = 1;  			//�����
		txBuffer[1] = 1;          // ��
		
		txPack = 1;		// ���� ����� �� ��������
		delay_ms(50);

	// �� ������������ � �������
		IVCREG = 1 << IVCE;
		IVCREG = 1 << IVSEL;
		#asm("rjmp 0xC00");
}


// ��������� ��������� ����������
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
		txPack = 1;		// ���� ����� �� ��������

/*		while (txPack);				// ���� ��������

//		txBuffer[0] = 4;				 			// ����� ������
		txBuffer[1] = 1;
		txBuffer[2] = 1;
		txBuffer[3] = 1;
		txBuffer[4] = 7;//2+lAddr;	 			//��  
print = 1;

		txPack = 1;		// ���� ����� �� ��������*/
		
		
} 

// ���������� �� ����������:

static void GetInfo(void)
{
	register unsigned char i,a,crc=0;                    
//putchar (0x01);		
	
	// 	�������� �����
	txBuffer[0] = 40+1;
	
	for (i = 0; i < 32; i ++)	// ��� ����������
	{
		txBuffer[i+1] = device_name[i];
	}

		txBuffer[33] = my_ser_num;           // �������� �����
		txBuffer[34] = my_ser_num>>8;      // �������� �����

		txBuffer[35] = 0;	// �������� �����
		txBuffer[36] = 0;	// �������� �����
	
		txBuffer[37] =pAddr ;     // ����� ����������

		txBuffer[38] =0;     // ����������������� ����
	
		txBuffer[39] = my_version;             // ������
		txBuffer[40] = my_version>>8;		// ������
		
		for (a=0;a<=txBuffer[0]-1;a++) crc += txBuffer[a];	//KC
		txBuffer[41] = crc;
	

		txPack = 1;		// ���� ����� �� �������� 
//putchar (0x02);		
}


// ��������. ��������� ������ �� ��������
void _GetLogAddr (void)
	{
	
		txBuffer[0] = 2;				 			// ����� ������
		txBuffer[1] = lAddr;		  			// ���. �����
		txBuffer[2] = 2+lAddr;	 			//��  

		txPack = 1;		// ���� ����� �� ��������
	
	}  
	
// ���������� ������
void _OP (unsigned char c)
	{
		unsigned char a =0, b;

		txBuffer[0] = c;					// ����� ������

		for (b=0;b< txBuffer [0]; b++)
			{
				a=a+txBuffer [b];
			}                            
			
		txBuffer [b] = a;					//KC

		txPack = 1;		// ���� ����� �� ��������
		
	}

static void give_GETINFO (void)
{
	
	// 	������� ������  ���� ����������
			putchar ('q');						// ���������
			putchar (3);							// ����� ���� ����� �����
			putchar (255);		 				//  ����� (�����������)
			putchar (PT_GETINFO);		// ��� ������
			putchar ((PT_GETINFO)+(255)+3+('q'));
				
}

// ������� CRC ��������� �������
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

// ������� CRC ����������� �������
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

// ������������ �������� �����
void workINpack ( void )
		{
			unsigned char a;

		if (rxBuffer[2]==0)				// ��������� �����. 0-���������.���������-�������������
			{
					switch (rxBuffer[3])
						{
							case GetLogAddr:				// ���������� ���. �����
									_GetLogAddr ();		
									rxPack = 0;				// ����� ���������
									break;

							case OP:							// ���������� ������
									readAddrDevice(); 
									rxPack = 0;				// ����� ���������
									break;

							case pingPack :
									LedInv();

									if (rxPackUART) 
										{
											txPack = 1;		 	// ���� ����� �� ��������
											rxPackUART = 0;	// ����� ���������
										}
									rxPack = 0;					// ����� ���������
									break; 

							default:
									rxPack = 0;					// ����� ���������
										
						}
            }
		else if (rxBuffer[2]==pAddr) 							////////////// ��� �����. ���������� �� ���
			{
					switch (rxBuffer[3])
						{
							case PT_GETINFO:			// ���������� � ���� ����������
//print = 1;
									GetInfo();
									rxPack = 0;					// ����� ���������
									break;           

							case PT_GETSTATE:
									GetState();
									rxPack = 0;					// ����� ���������
									break;

					 		case PT_TOPROG:       			// ��������� � ����������������
									ToProg();
									rxPack = 0;					// ����� ���������
									break;      

					 		case PT_SETADDR:       			// ��������� � ����������������
									Setaddr();
									rxPack = 0;					// ����� ���������
									break;      
					 		case PT_SETSERIAL:       			// ��������� � ����������������
									SetSerial();
									rxPack = 0;					// ����� ���������
									break;      


							default:
									rxPack = 0;					// ����� ���������
						}
              }
		else	if(rxBuffer[2] == TO_MON)					// ������������ ����� �� ������ MONITOR
			{
					switch (rxBuffer[3])
						{
					 		case PT_SETADDR:       			// ��������� � ����������������
									Setaddr();
									rxPack = 0;					// ����� ���������
									break;      
					 		case PT_SETSERIAL:       			// ��������� � ����������������
									SetSerial();
									rxPack = 0;					// ����� ���������
									break; 
					 		case PT_TOWORK:       			// ��������� � ����������������
									ToWorkMode();
									rxPack = 0;					// ����� ���������
									break; 
									     
							default:
									rxPack = 0;					// ����� ���������
						}
			}
		else
				{ 												///////////// ����� �������������
					for (a = 0;a<= (rxBuffer[1]+1); a++)
						{
							putchar (rxBuffer [a]);
						}
					rxPack = 0;					// ����� ���������
				}
			}	

// ��������� ������, ��������� �� UART
	void workUARTpack (void)
		{
			LedInv();

			txPack = 1;							// ���� ����� �� ��������
			rxPackUART = 0;				// ����� ���������
		}			
		


// ----------------------- ��������� ���������� ������� 0 (����-��� RS232) --------
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
	TCCR0=0x00;										// ������������� ������
	time_is_Out =1;		// ������� ������� ��������� ��������
}
//--------------------------------------------------------------------------------------

// ----------------------- ��������� ���������� ������� 1 ( ����� ����������� ������ 10 �) --------
// Timer 1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
	tstPort = 1;						// ���� ��������� ���������� ������������ �� ?
}





// ������� ������ ��������
void timeOutStart (void)
		{
			time_is_Out = 0;			// ����� ����� ��������
			TCNT0=0x00;
			TCCR0=0x05;      									// ������� ������
		}

// ������� ������ ��������
void timeOutStop (void)
		{
			TCCR0=0x0;      									// ������� �������
		}

// ������� ����������� ����������� ������ ����� � ������
// �� ��������� ���� (0���) �������� ����������
void inidevice (void)
		{                                      
		pAddr = ((PINC & 0x7)+1 );			// ���������� ���������� ����� (0-�� ���. �.�. ����. �����)
		TWAR = (pAddr<<1)+1;					// ������������� ��� ��� TWI

//		while (! ping);								// ���� ������ ���� 0���

		}                                  
		
// ����� ����� �� UART. ������������ ����-�����		
unsigned char havechar(void)
{
	timeOutStart ();													// ������� ������
	while (!( UCSRA & (1 << RXC)))
		{
   		    if (time_is_Out)	
   		    	{
	                dPresent = 0;					//  ���������� �� ��������
					timeOutStop ();				// ������� �������
   			    	return 0;						// ���� ��� ����� �� ��������� �������
   		    	}
		}
	timeOutStop ();								// ������� �������
    dPresent = 1;									//������� ������� ������� ����������

	return 255;
}


// ��������� ��� ���������� � ���� RS232
// ���� ���� ���������� - ���������� ����� � ������ � ������� �������
// ���� ��� ������ - ��������� �� �����������. ������������ ��������� ����������
void 	readAddrDevice (void)                                                          
		{
				give_GETINFO();

				timeOutStart();
				while (!(rxPackUART))					// ���� ������
				{
					if (time_is_Out )
						{
							LedOn();								// ������� ����������� ��� ��������� �����
			                dPresent = 0;			 			//  ���������� �� ��������
		    	            lAddr = 0;					 			// ����� = 0
							break;
						} 
					else  
						{
							dPresent = 1;						// �������� 
							lAddr = txBuffer [37];			// �������� ����� �� ��������� �����             
							LedOff();							// ����� ��������� �������

							tstPort = 0;						// ���������� ������������
						}
					
				}        
				timeOutStop();
								
				
				if (dPresent) txPack = 1;					// ���� ����� �� ��������
				rxPackUART = 0;							// �������� ����� - � ��������
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
		inidevice();  						// ���� ������������
	    LedOn();                                                              
putchar (0xab);		
while (1)
      {       

//		if ((!(dPresent)) || (tstPort)) readAddrDevice(); 	 	// ���� ��� ���������� - ���� ���
		if (rxPack) workINpack();			// ������ ����� TWI 
      };
}
