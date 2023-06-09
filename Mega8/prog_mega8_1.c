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

// Standard Input/Output functions
#include <stdio.h>
#include <delay.h>
#include <string.h>
  
#include "CDdef.h"  				// ��� ���������

unsigned char rxBufferTWI	[TWI_BUFFER_SIZE];				// �������� �����  TWI
unsigned char txBufferTWI	[(TWI_BUFFER_SIZE/2)-25];						// ���������� ����� TWI
unsigned char rxBufferUART	[(TWI_BUFFER_SIZE/2)-25];					// ������������� �������� ����� UART

unsigned char CountUART = 0, CountUART_1 = 0, Relay_Pack_TWI_UART,  Relay_Pack_UART_TWI;
unsigned char Count_For_Timer2 , Packet_Lost ;
 

// ������ ����������
unsigned char lAddr	 	=	 	0x0;				//���������� ����� (���. ������������� ����������)

// ��� ��� ������ � TWI
TWISR TWI_statusReg;   
unsigned char 	TWI_slaveAddress = MY_TWI_ADDRESS;		// Own TWI slave address

// ����� ���������
bit		gate_UART_to_TWI_open	=		1;					// ������������ �� UART � TWI
bit		rxPack								=		0;					// ������ �����																						
bit		TWI_TX_Packet_Present	=		0;					// ���� ������ �� ��������
bit 		rxPackUART 						= 		0;					// ������ ����� �� UART
bit 		Device_Connected				=		0;					// ���� ����� � �����������
bit 		InternalPack 						= 		0;					// ������ ���������� �����
bit		to_Reboot							=		0;					// �� ������������ � ���������
bit		Responce_Time_Out			=		0;					// ����� �������� ��������� ������ �������
//bit		lock_PORT						=		1;					// ������������� COM ����

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)      
{     
	unsigned char data ;
	data = UDR;              

	if ((UCSRA & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	{
		if (!(CountUART)) 		             		// ����� � ������
		{ 
			if (!rxPackUART)           				// ���������� ����� �������?
			{
				CountUART_1 = 0;
				rxBufferUART [CountUART_1++] = data;
				CountUART = data;
			} 
		}
		else
		{                                                  // ���������� ����� ������
			rxBufferUART[CountUART_1++] = data;
			if (!(--CountUART)) 					
					rxPackUART = 1;              // ������ ���� �����
    	} 
	}                
}

void main(void)
{
// Declare your local variables here

	LedOff();
	Initialization_Device();  						// ������������� ������

	// Global enable interrupts
	#asm("sei")

	// Start the TWI transceiver to enable reseption of the first command from the TWI Master.
	txBufferTWI[0] = 0;     					// ������ �� �������� ���
	TWI_Start_Transceiver();

	LedOn();         

	give_GETINFO();		// ���������� ������� ������� � ����
                                                     
    port_state (FALSE);		//��������� ����
#ifdef aaa
    port_state (TRUE);		//��������� ����
#endif    


    
	while (1)
    {     


		run_TWI_slave();

		if ( rxPack )
		{

		 	workINpack();				// ������ ����� TWI 
			rxPack = 0;					// ����� ���������
		}


		// ������������ �������� �����UART
		if ( rxPackUART )
		{
				// ��������� ��
				if (checkCRCrx ( &UART_RX_Len, from_UART ) )
				{
					TCNT1=0x0000;				// ��� ���������� ������ �� ��������� ����� ����. ����������
					LedOff ();						// ������ �����

					workUARTpack();			// ������������ �����
				}       
				
		rxPackUART = 0;						// ����� ��������� 
		}

		// ������� �����. ������ ����������
		if ( Responce_Time_Out ) 
		{
			Responce_OK (FALSE);							
		 	Responce_Time_Out = 0;
			gate_UART_to_TWI_open = FALSE; 

		 }
		 
		//  �� ������������ � ���������
		if ( to_Reboot )
		{             
			if ( ! TWI_TX_Packet_Present )			// ���� ���� ���������� ����� 
			{
				// �� ������������ � �������
				IVCREG = 1 << IVCE;
				IVCREG = 1 << IVSEL;
				#asm("rjmp 0xC00");
			}
		}
     }
}
