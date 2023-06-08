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
/*****************************************************************************
*
* Atmel Corporation
*
* File              : TWI_Slave.h
* Compiler          : IAR EWAAVR 2.28a/3.10c
* Revision          : $Revision: 1.6 $
* Date              : $Date: Monday, May 24, 2004 09:32:18 UTC $
* Updated by        : $Author: ltwa $
*
* Support mail      : avr@atmel.com
*
* Supported devices : All devices with a TWI module can be used.
*                     The example is written for the ATmega16
*
* AppNote           : AVR311 - TWI Slave Implementation
*
* Description       : Header file for TWI_slave.c
*                     Include this file in the application.
*
****************************************************************************/
#include <mega8.h> 

/****************************************************************************
  TWI Status/Control register definitions
****************************************************************************/

#define TWI_BUFFER_SIZE 250      // Reserves memory for the drivers transceiver buffer. 
                               // Set this to the largest message size that will be sent including address byte.

/****************************************************************************
  Global definitions
****************************************************************************/
/****************************************************************************
  Global definitions
****************************************************************************/
	typedef  struct
    {
        unsigned char lastTransOK:1;      
        unsigned char RxDataInBuf:1;
        unsigned char genAddressCall:1;                       // TRUE = General call, FALSE = TWI Address;
        unsigned char unusedBits:5;
    } SB;
  
  	typedef union 				                       // Status byte holding flags.
	{
    	unsigned char all;
    	SB bits;
	}  TWISR;

extern  TWISR  TWI_statusReg;        


// ��� �������������
#define  __no_operation() #asm("nop")
#define  __enable_interrupt() #asm("sei")
#define  __disable_interrupt() #asm("cli")


/****************************************************************************
  Function definitions
****************************************************************************/
void TWI_Slave_Initialise( unsigned char );
unsigned char TWI_Transceiver_Busy( void );
unsigned char TWI_Get_State_Info( void );
void TWI_Start_Transceiver_With_Data( unsigned char * , unsigned char );
void TWI_Start_Transceiver( void );
unsigned char TWI_Get_Data_From_Transceiver( unsigned char *, unsigned char );    

void run_TWI_slave ( void );


/****************************************************************************
  Bit and byte definitions
****************************************************************************/
#define TWI_READ_BIT  0   // Bit position for R/W bit in "address byte".
#define TWI_ADR_BITS  1   // Bit position for LSB of the slave address bits in the init byte.
#define TWI_GEN_BIT   0   // Bit position for LSB of the general call bit in the init byte.

#define TRUE          1
#define FALSE         0

/****************************************************************************
  TWI State codes
****************************************************************************/
// General TWI Master staus codes                      
#define TWI_START                  0x08  // START has been transmitted  
#define TWI_REP_START              0x10  // Repeated START has been transmitted
#define TWI_ARB_LOST               0x38  // Arbitration lost

// TWI Master Transmitter staus codes                      
#define TWI_MTX_ADR_ACK            0x18  // SLA+W has been tramsmitted and ACK received
#define TWI_MTX_ADR_NACK           0x20  // SLA+W has been tramsmitted and NACK received 
#define TWI_MTX_DATA_ACK           0x28  // Data byte has been tramsmitted and ACK received
#define TWI_MTX_DATA_NACK          0x30  // Data byte has been tramsmitted and NACK received 

// TWI Master Receiver staus codes  
#define TWI_MRX_ADR_ACK            0x40  // SLA+R has been tramsmitted and ACK received
#define TWI_MRX_ADR_NACK           0x48  // SLA+R has been tramsmitted and NACK received
#define TWI_MRX_DATA_ACK           0x50  // Data byte has been received and ACK tramsmitted
#define TWI_MRX_DATA_NACK          0x58  // Data byte has been received and NACK tramsmitted

// TWI Slave Transmitter staus codes
#define TWI_STX_ADR_ACK            0xA8  // Own SLA+R has been received; ACK has been returned
#define TWI_STX_ADR_ACK_M_ARB_LOST 0xB0  // Arbitration lost in SLA+R/W as Master; own SLA+R has been received; ACK has been returned
#define TWI_STX_DATA_ACK           0xB8  // Data byte in TWDR has been transmitted; ACK has been received
#define TWI_STX_DATA_NACK          0xC0  // Data byte in TWDR has been transmitted; NOT ACK has been received
#define TWI_STX_DATA_ACK_LAST_BYTE 0xC8  // Last data byte in TWDR has been transmitted (TWEA = �0�); ACK has been received

// TWI Slave Receiver staus codes
#define TWI_SRX_ADR_ACK            0x60  // Own SLA+W has been received ACK has been returned
#define TWI_SRX_ADR_ACK_M_ARB_LOST 0x68  // Arbitration lost in SLA+R/W as Master; own SLA+W has been received; ACK has been returned
#define TWI_SRX_GEN_ACK            0x70  // General call address has been received; ACK has been returned
#define TWI_SRX_GEN_ACK_M_ARB_LOST 0x78  // Arbitration lost in SLA+R/W as Master; General call address has been received; ACK has been returned
#define TWI_SRX_ADR_DATA_ACK       0x80  // Previously addressed with own SLA+W; data has been received; ACK has been returned
#define TWI_SRX_ADR_DATA_NACK      0x88  // Previously addressed with own SLA+W; data has been received; NOT ACK has been returned
#define TWI_SRX_GEN_DATA_ACK       0x90  // Previously addressed with general call; data has been received; ACK has been returned
#define TWI_SRX_GEN_DATA_NACK      0x98  // Previously addressed with general call; data has been received; NOT ACK has been returned
#define TWI_SRX_STOP_RESTART       0xA0  // A STOP condition or repeated START condition has been received while still addressed as Slave

// TWI Miscellaneous status codes
#define TWI_NO_STATE               0xF8  // No relevant state information available; TWINT = �0�
#define TWI_BUS_ERROR              0x00  // Bus error due to an illegal START or STOP condition

// ���� TWCR
#define TWINT 7             //���� ���������� ���������� ������
#define TWEA  6             //�������� �� ��� ������ �� �����
#define TWSTA 5             //�������� �����
#define TWSTO 4             //�������� ����
#define TWWC  3             //
#define TWEN  2             //��������� ������ I2C
#define TWIE  0             //����������



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
#include <twi_slave.h >
/*****************************************************************************
*
* Atmel Corporation
*
* File              : TWI_Slave.h
* Compiler          : IAR EWAAVR 2.28a/3.10c
* Revision          : $Revision: 1.6 $
* Date              : $Date: Monday, May 24, 2004 09:32:18 UTC $
* Updated by        : $Author: ltwa $
*
* Support mail      : avr@atmel.com
*
* Supported devices : All devices with a TWI module can be used.
*                     The example is written for the ATmega16
*
* AppNote           : AVR311 - TWI Slave Implementation
*
* Description       : Header file for TWI_slave.c
*                     Include this file in the application.
*
****************************************************************************/
#include <mega8.h> 

/****************************************************************************
  TWI Status/Control register definitions
****************************************************************************/

#define TWI_BUFFER_SIZE 250      // Reserves memory for the drivers transceiver buffer. 
                               // Set this to the largest message size that will be sent including address byte.

/****************************************************************************
  Global definitions
****************************************************************************/
/****************************************************************************
  Global definitions
****************************************************************************/
	typedef  struct
    {
        unsigned char lastTransOK:1;      
        unsigned char RxDataInBuf:1;
        unsigned char genAddressCall:1;                       // TRUE = General call, FALSE = TWI Address;
        unsigned char unusedBits:5;
    } SB;
  
  	typedef union 				                       // Status byte holding flags.
	{
    	unsigned char all;
    	SB bits;
	}  TWISR;

extern  TWISR  TWI_statusReg;        


// ��� �������������
#define  __no_operation() #asm("nop")
#define  __enable_interrupt() #asm("sei")
#define  __disable_interrupt() #asm("cli")


/****************************************************************************
  Function definitions
****************************************************************************/
void TWI_Slave_Initialise( unsigned char );
unsigned char TWI_Transceiver_Busy( void );
unsigned char TWI_Get_State_Info( void );
void TWI_Start_Transceiver_With_Data( unsigned char * , unsigned char );
void TWI_Start_Transceiver( void );
unsigned char TWI_Get_Data_From_Transceiver( unsigned char *, unsigned char );    

void run_TWI_slave ( void );


/****************************************************************************
  Bit and byte definitions
****************************************************************************/
#define TWI_READ_BIT  0   // Bit position for R/W bit in "address byte".
#define TWI_ADR_BITS  1   // Bit position for LSB of the slave address bits in the init byte.
#define TWI_GEN_BIT   0   // Bit position for LSB of the general call bit in the init byte.

#define TRUE          1
#define FALSE         0

/****************************************************************************
  TWI State codes
****************************************************************************/
// General TWI Master staus codes                      
#define TWI_START                  0x08  // START has been transmitted  
#define TWI_REP_START              0x10  // Repeated START has been transmitted
#define TWI_ARB_LOST               0x38  // Arbitration lost

// TWI Master Transmitter staus codes                      
#define TWI_MTX_ADR_ACK            0x18  // SLA+W has been tramsmitted and ACK received
#define TWI_MTX_ADR_NACK           0x20  // SLA+W has been tramsmitted and NACK received 
#define TWI_MTX_DATA_ACK           0x28  // Data byte has been tramsmitted and ACK received
#define TWI_MTX_DATA_NACK          0x30  // Data byte has been tramsmitted and NACK received 

// TWI Master Receiver staus codes  
#define TWI_MRX_ADR_ACK            0x40  // SLA+R has been tramsmitted and ACK received
#define TWI_MRX_ADR_NACK           0x48  // SLA+R has been tramsmitted and NACK received
#define TWI_MRX_DATA_ACK           0x50  // Data byte has been received and ACK tramsmitted
#define TWI_MRX_DATA_NACK          0x58  // Data byte has been received and NACK tramsmitted

// TWI Slave Transmitter staus codes
#define TWI_STX_ADR_ACK            0xA8  // Own SLA+R has been received; ACK has been returned
#define TWI_STX_ADR_ACK_M_ARB_LOST 0xB0  // Arbitration lost in SLA+R/W as Master; own SLA+R has been received; ACK has been returned
#define TWI_STX_DATA_ACK           0xB8  // Data byte in TWDR has been transmitted; ACK has been received
#define TWI_STX_DATA_NACK          0xC0  // Data byte in TWDR has been transmitted; NOT ACK has been received
#define TWI_STX_DATA_ACK_LAST_BYTE 0xC8  // Last data byte in TWDR has been transmitted (TWEA = �0�); ACK has been received

// TWI Slave Receiver staus codes
#define TWI_SRX_ADR_ACK            0x60  // Own SLA+W has been received ACK has been returned
#define TWI_SRX_ADR_ACK_M_ARB_LOST 0x68  // Arbitration lost in SLA+R/W as Master; own SLA+W has been received; ACK has been returned
#define TWI_SRX_GEN_ACK            0x70  // General call address has been received; ACK has been returned
#define TWI_SRX_GEN_ACK_M_ARB_LOST 0x78  // Arbitration lost in SLA+R/W as Master; General call address has been received; ACK has been returned
#define TWI_SRX_ADR_DATA_ACK       0x80  // Previously addressed with own SLA+W; data has been received; ACK has been returned
#define TWI_SRX_ADR_DATA_NACK      0x88  // Previously addressed with own SLA+W; data has been received; NOT ACK has been returned
#define TWI_SRX_GEN_DATA_ACK       0x90  // Previously addressed with general call; data has been received; ACK has been returned
#define TWI_SRX_GEN_DATA_NACK      0x98  // Previously addressed with general call; data has been received; NOT ACK has been returned
#define TWI_SRX_STOP_RESTART       0xA0  // A STOP condition or repeated START condition has been received while still addressed as Slave

// TWI Miscellaneous status codes
#define TWI_NO_STATE               0xF8  // No relevant state information available; TWINT = �0�
#define TWI_BUS_ERROR              0x00  // Bus error due to an illegal START or STOP condition

// ���� TWCR
#define TWINT 7             //���� ���������� ���������� ������
#define TWEA  6             //�������� �� ��� ������ �� �����
#define TWSTA 5             //�������� �����
#define TWSTO 4             //�������� ����
#define TWWC  3             //
#define TWEN  2             //��������� ������ I2C
#define TWIE  0             //����������


#include <Scrambling.h >

//#define TWI_Buffer_TX				120			// ����� �� ����� UART/ �������� TWI    

#define from_TWI		0x0						// ���� TWI
#define from_UART	0x1						// ���� UART 
#define START_Timer  1						// ������ 200��
#define STOP_Timer    0   

 #define Start_Position_for_Reply	2		// ��������� ������� ��� ��������� ������
#define Long_TX_Packet_TWI  	txBufferTWI[Start_Position_for_Reply]  // ����� ������������� ������
#define Command_TX_Packet_TWI 	txBufferTWI[Start_Position_for_Reply+1]   // ��� ������������� ������ (�������)
#define CRC_TX_Packet_TWI   			txBufferTWI[Start_Position_for_Reply+Long_TX_Packet_TWI]	// �RC ������������� ������ 


#define TWI_RX_Command 	 	rxBufferTWI[0]  // ������� TWI
#define Heading_RX_Packet  	rxBufferTWI[1]  // ��������� ������
#define Long_RX_Packet_TWI  	rxBufferTWI[2]  // ����� ��������� ������
#define Recived_Address 			rxBufferTWI[3]  // ����� � �������� ������
#define Type_RX_Packet_TWI 	rxBufferTWI[4]  // ��� ��������� ������ 
#define PT_GETSTATE_page		rxBufferTWI[5]	// ����� �������� � ������ GETSTATE	
#define CRC_RX_Packet_TWI   rxBufferTWI[ rxBufferTWI[2]+2]	// CRC ��������� ������

// ���� �������, ������������ � CD

#define GetLogAddr					1		// ���� ���������� ����� 
//#define pingPack						2		// ��� ������� �� ������� ���������� �� ��������
#define Responce_GEN_CALL	3		// ����� �� GEN CALL   
#define Responce_GEN_CALL_internal	4	// ������ ��� �����. ����������

#define Internal_Packet		0x00			// ������ ����������� �����������
#define External_Packet 	0x01			// ������ ���������������
#define Global_Packet		0xFF			// ���������� �����

	
// �������, ������������ �� TWI
#define TWI_CMD_MASTER_WRITE 					0x10
#define TWI_CMD_MASTER_READ  						0x20      
#define TWI_CMD_MASTER_RECIVE_PACK_OK 	0x21
#define TWI_CMD_MASTER_REQUEST_CRC 		0x22       

// �������
unsigned char TWI_Act_On_Failure_In_Last_Transmission ( unsigned char TWIerrorMsg );
void run_TWI_slave ( void ); 
unsigned char calc_CRC (unsigned char *Position_in_Packet); // ������� CRC ������������� ������
void packPacket (unsigned char type);






// ������������� ������. ����������� �������.
// 
void Initialization_Device (void)
{                                      
		PORTC=0x07;

		#ifndef BOOT_PROGRAM

		DDRD=0x1C;

		// External Interrupt(s) initialization
		// INT0: Off
		// INT1: Off
		MCUCR=0x00;

		// Analog Comparator initialization
		// Analog Comparator: Off
		// Analog Comparator Input Capture by Timer/Counter 1: Off
		ACSR=0x80;
		SFIOR=0x00;

		// �������������� ������� 
		// Timer/Counter 0 initialization; Clock value: 7,813 kHz; 
		TCCR0=0x00;
		TCNT0=0x00;   


		//Timer/Counter 2 initialization; Clock value: 7,813 kHz
		// Mode: Normal top=FFh;
		// ������� �������� ��������� ������ ��� GEN_CALL (200 ms)
		ASSR=0x00;
		TCCR2=0x00;
		TCNT2=0x00;
		OCR2=0x00;     
		
		// Timer/Counter 1 initialization
		// Clock source: System Clock; Clock value: 7,813 kHz
		// Mode: Normal top=FFFFh; ������� ������ ���������� RS-232
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

		// Timer(s)/Counter(s) Interrupt(s) initialization
		TIMSK=0x45;

		#else

		// Timer/Counter 1 initialization
		// Clock source: System Clock; Clock value: 7,813 kHz
		// Mode: Normal top=FFFFh; ������� ������ ���������� RS-232
		TCCR1B=0x05;
		TCNT1=0xD2F6;		//�������� 2���

		// �������
//		WDTCR=0x1F;
//		WDTCR=0x0F;              
		#endif

		

		// USART initialization
		// Communication Parameters: 8 Data, 1 Stop, No Parity
		// USART Receiver: On
		// USART Transmitter: On
		// USART Mode: Asynchronous
		// USART Baud rate: 38400
//		UCSRA=0x00;
		UCSRB=0x98;
		UCSRC=0x86;
//		UBRRH=0x00;
		UBRRL=0x0C;

		// Initialise TWI module for slave operation. Include address and/or enable General Call.
		// ������ ���� �����
		TWI_slaveAddress += (PINC & 0b00000111);
		TWI_Slave_Initialise( (TWI_slaveAddress<<TWI_ADR_BITS) | (TRUE<<TWI_GEN_BIT) ); 
 }                                  


// ������� CRC ������������� ������
unsigned char calc_CRC (unsigned char *Position_in_Packet)
{                    
	unsigned char CRC = 0, a;                                   

	a = *Position_in_Packet ;
	
	while(a--)
	{
		CRC += *Position_in_Packet++;
	}

	return CRC;
}

// �������� ������ �� �������...
void packPacket (unsigned char type)
{
		txBufferTWI[0] = txBufferTWI[Start_Position_for_Reply]+3;				// �����
		txBufferTWI[1] = type;																	// ���

		txBufferTWI[txBufferTWI[0]] = calc_CRC( &txBufferTWI[0] );           //CRC
		TWI_TX_Packet_Present = 1;		// ���� ����� �� ��������
}


// ������� �� ��������� ������. ��������� - �� ������ ������.
unsigned char checkCRCrx (unsigned char *Position_in_Packet, unsigned char Incoming_PORT)
{                    
	unsigned char CRC=0 , a;		
	
	// �� TWI - �������� ������� � ���������
    if ( Incoming_PORT == from_TWI ) CRC = *Position_in_Packet ++;  // ��������� ������
    
	// �� UART - �������� ������� � �����
	a = *Position_in_Packet ;
	
	while(a--)
	{
		CRC += *Position_in_Packet++;
	}

	if (CRC == *Position_in_Packet)	
			return TRUE; 										//Ok

	else	return FALSE;                                      // Error
}


unsigned char TWI_Act_On_Failure_In_Last_Transmission ( unsigned char TWIerrorMsg )
{
                    // A failure has occurred, use TWIerrorMsg to determine the nature of the failure
                    // and take appropriate actions.
                    // Se header file for a list of possible failures messages.
  
                    // This very simple example puts the error code on PORTB and restarts the transceiver with
                    // all the same data in the transmission buffers.
//  PORTB = TWIerrorMsg;
  TWI_Start_Transceiver();
                    
  return TWIerrorMsg; 
}


void run_TWI_slave ( void )
{
  // This example is made to work together with the AVR315 TWI Master application note. In adition to connecting the TWI
  // pins, also connect PORTB to the LEDS. The code reads a message as a TWI slave and acts according to if it is a 
  // general call, or an address call. If it is an address call, then the first byte is considered a command byte and
  // it then responds differently according to the commands.

    // Check if the TWI Transceiver has completed an operation.
    if ( ! TWI_Transceiver_Busy() )                              
    {
    // Check if the last operation was successful
      if ( TWI_statusReg.bits.lastTransOK )
      {
    // Check if the last operation was a reception
        if ( TWI_statusReg.bits.RxDataInBuf )
        {
          TWI_Get_Data_From_Transceiver(rxBufferTWI, 3);         
    // Check if the last operation was a reception as General Call 
	// ���������� ����� ���� �������� �� ����������
          if ( TWI_statusReg.bits.genAddressCall )
          {
/*				#ifndef BOOT_PROGRAM
					if ( Device_Connected )
							Wait_Responce ( START_Timer );  
				#endif	*/
          }

		  // Ends up here if the last operation was a reception as Slave Address Match                  
/*          else
          {*/
			switch ( TWI_RX_Command )
			{
				case  TWI_CMD_MASTER_WRITE:
						// ���������� �������� ������	
						TWI_Get_Data_From_Transceiver(rxBufferTWI, Long_RX_Packet_TWI+3 );
						// ��������� ��  
						if ( checkCRCrx ( &Heading_RX_Packet , from_TWI ) )
								rxPack = 1;	 
#ifdef aaa
    putchar (0xaa);
#endif    
						break;


				case  TWI_CMD_MASTER_READ:
                         // ����� ������� ���
						if ( ! TWI_TX_Packet_Present)
						{
								txBufferTWI[0] = 0;

						}

#ifdef aaa
    putchar (0xac);
	txBufferTWI[0] = 0;
#endif    
						TWI_Start_Transceiver_With_Data( txBufferTWI, txBufferTWI[0]+1 );           
						break;

				case  TWI_CMD_MASTER_RECIVE_PACK_OK:
						TWI_TX_Packet_Present = 0;			// ������ ������ ����� ��� ������
						txBufferTWI[0] = 0;     					// ������ �� �������� ���
                        
						TWI_Start_Transceiver_With_Data( txBufferTWI, txBufferTWI[0]+1 );           
						break;


				default:	
						txBufferTWI[0] = 0;     	// �������� ������ �����

						TWI_Start_Transceiver_With_Data( txBufferTWI, txBufferTWI[0]+1 );           
//			}
          }
        }

    // Check if the TWI Transceiver has already been started.
    // If not then restart it to prepare it for new receptions.             
        if ( ! TWI_Transceiver_Busy() )
        {
          TWI_Start_Transceiver();
        }      
      }
    // Ends up here if the last operation completed unsuccessfully
      else
      {
        TWI_Act_On_Failure_In_Last_Transmission( TWI_Get_State_Info() );
      }
    }
  }
/*****************************************************************************
*
* Atmel Corporation
*
* File              : TWI_Slave.c
* Compiler          : IAR EWAAVR 2.28a/3.10c
* Revision          : $Revision: 1.7 $
* Date              : $Date: Thursday, August 05, 2004 09:22:50 UTC $
* Updated by        : $Author: lholsen $
*
* Support mail      : avr@atmel.com
*
* Supported devices : All devices with a TWI module can be used.
*                     The example is written for the ATmega16
*
* AppNote           : AVR311 - TWI Slave Implementation
*
* Description       : This is sample driver to AVRs TWI module. 
*                     It is interupt driveren. All functionality is controlled through 
*                     passing information to and from functions. Se main.c for samples
*                     of how to use the driver.
*
****************************************************************************/
#include "TWI_slave.h"
 
static unsigned char TWI_buf[TWI_BUFFER_SIZE];     // Transceiver buffer. Set the size in the header file
static unsigned char TWI_msgSize  = 0;             // Number of bytes to be transmitted.
static unsigned char TWI_state    = TWI_NO_STATE;  // State byte. Default set to TWI_NO_STATE.

//union TWISR TWI_statusReg = {0};           // TWI_statusReg is defined in TWI_Slave.h

/****************************************************************************
Call this function to set up the TWI slave to its initial standby state.
Remember to enable interrupts from the main application after initializing the TWI.
Pass both the slave address and the requrements for triggering on a general call in the
same byte. Use e.g. this notation when calling this function:
TWI_Slave_Initialise( (TWI_slaveAddress<<TWI_ADR_BITS) | (TRUE<<TWI_GEN_BIT) );
The TWI module is configured to NACK on any requests. Use a TWI_Start_Transceiver function to 
start the TWI.
****************************************************************************/
void TWI_Slave_Initialise( unsigned char TWI_ownAddress )
{
  TWAR = TWI_ownAddress;                            // Set own TWI slave address. Accept TWI General Calls.

  TWDR = 0xFF;                                      // Default content = SDA released.
  TWCR = (1<<TWEN)|                                 // Enable TWI-interface and release TWI pins.
         (0<<TWIE)|(0<<TWINT)|                      // Disable TWI Interupt.
         (0<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|           // Do not ACK on any requests, yet.
         (0<<TWWC);                                 //
}    

/****************************************************************************
Call this function to test if the TWI_ISR is busy transmitting.
****************************************************************************/
unsigned char TWI_Transceiver_Busy( void )
{
  return ( TWCR & (1<<TWIE) );                  // IF TWI interrupt is enabled then the Transceiver is busy
}

/****************************************************************************
Call this function to fetch the state information of the previous operation. The function will hold execution (loop)
until the TWI_ISR has completed with the previous operation. If there was an error, then the function 
will return the TWI State code. 
****************************************************************************/
unsigned char TWI_Get_State_Info( void )
{
  while ( TWI_Transceiver_Busy() );             // Wait until TWI has completed the transmission.
  return ( TWI_state );                         // Return error state. 
}

/****************************************************************************
Call this function to send a prepared message, or start the Transceiver for reception. Include
a pointer to the data to be sent if a SLA+W is received. The data will be copied to the TWI buffer. 
Also include how many bytes that should be sent. Note that unlike the similar Master function, the
Address byte is not included in the message buffers.
The function will hold execution (loop) until the TWI_ISR has completed with the previous operation,
then initialize the next operation and return.
****************************************************************************/
void TWI_Start_Transceiver_With_Data( unsigned char *msg, unsigned char msgSize )
{
  unsigned char temp;

  while ( TWI_Transceiver_Busy() );             // Wait until TWI is ready for next transmission.

  TWI_msgSize = msgSize;                        // Number of data to transmit.
  for ( temp = 0; temp < msgSize; temp++ )      // Copy data that may be transmitted if the TWI Master requests data.
    TWI_buf[ temp ] = msg[ temp ];

  TWI_statusReg.all = 0;      
  TWI_state         = TWI_NO_STATE ;
  TWCR = (1<<TWEN)|                             // TWI Interface enabled.
         (1<<TWIE)|(1<<TWINT)|                  // Enable TWI Interupt and clear the flag.
         (1<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|       // Prepare to ACK next time the Slave is addressed.
         (0<<TWWC);                             //
}

/****************************************************************************
Call this function to start the Transceiver without specifing new transmission data. Usefull for restarting
a transmission, or just starting the transceiver for reception. The driver will reuse the data previously put
in the transceiver buffers. The function will hold execution (loop) until the TWI_ISR has completed with the 
previous operation, then initialize the next operation and return.
****************************************************************************/
void TWI_Start_Transceiver( void )
{
  while ( TWI_Transceiver_Busy() );             // Wait until TWI is ready for next transmission.
  TWI_statusReg.all = 0;      
  TWI_state         = TWI_NO_STATE ;
  TWCR = (1<<TWEN)|                             // TWI Interface enabled.
         (1<<TWIE)|(1<<TWINT)|                  // Enable TWI Interupt and clear the flag.
         (1<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|       // Prepare to ACK next time the Slave is addressed.
         (0<<TWWC);                             //
}
/****************************************************************************
Call this function to read out the received data from the TWI transceiver buffer. I.e. first call
TWI_Start_Transceiver to get the TWI Transceiver to fetch data. Then Run this function to collect the
data when they have arrived. Include a pointer to where to place the data and the number of bytes
to fetch in the function call. The function will hold execution (loop) until the TWI_ISR has completed 
with the previous operation, before reading out the data and returning.
If there was an error in the previous transmission the function will return the TWI State code.
****************************************************************************/
unsigned char TWI_Get_Data_From_Transceiver( unsigned char *msg, unsigned char msgSize )
{
  unsigned char i;

  while ( TWI_Transceiver_Busy() );             // Wait until TWI is ready for next transmission.

  if( TWI_statusReg.bits.lastTransOK )               // Last transmission competed successfully.              
  {                                             
    for ( i=0; i<msgSize; i++ )                 // Copy data from Transceiver buffer.
    {
      msg[ i ] = TWI_buf[ i ];
    }
    TWI_statusReg.bits.RxDataInBuf = FALSE;          // Slave Receive data has been read from buffer.
  }
  return( TWI_statusReg.bits.lastTransOK );                                   
}

// ********** Interrupt Handlers ********** //
/****************************************************************************
This function is the Interrupt Service Routine (ISR), and called when the TWI interrupt is triggered;
that is whenever a TWI event has occurred. This function should not be called directly from the main
application.
****************************************************************************/
// 2 Wire bus interrupt service routine
interrupt [TWI] void TWI_ISR(void)
{
  static unsigned char TWI_bufPtr;

switch (TWSR)
  {
    case TWI_STX_ADR_ACK:            // Own SLA+R has been received; ACK has been returned
//    case TWI_STX_ADR_ACK_M_ARB_LOST: // Arbitration lost in SLA+R/W as Master; own SLA+R has been received; ACK has been returned
      TWI_bufPtr   = 0;                                 // Set buffer pointer to first data location
#ifdef aaa
	PORTD.3=0; 
#endif    

    case TWI_STX_DATA_ACK:           // Data byte in TWDR has been transmitted; ACK has been received
      TWDR = TWI_buf[TWI_bufPtr++];
      TWCR = (1<<TWEN)|                                 // TWI Interface enabled
             (1<<TWIE)|(1<<TWINT)|                      // Enable TWI Interupt and clear the flag to send byte
             (1<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|           // 
             (0<<TWWC);                                 //  
      break;

    case TWI_STX_DATA_NACK:          // Data byte in TWDR has been transmitted; NACK has been received. 
                                     // I.e. this could be the end of the transmission.
      if (TWI_bufPtr == TWI_msgSize) // Have we transceived all expected data?
      {
        TWI_statusReg.bits.lastTransOK = TRUE;               // Set status bits to completed successfully. 
      }else                          // Master has sent a NACK before all data where sent.
      {
        TWI_state = TWSR;                               // Store TWI State as errormessage.      
      }        
                                                        // Put TWI Transceiver in passive mode.
      TWCR = (1<<TWEN)|                                 // Enable TWI-interface and release TWI pins
             (0<<TWIE)|(0<<TWINT)|                      // Disable Interupt
             (0<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|           // Do not acknowledge on any new requests.
             (0<<TWWC);                                 //
      break;     

    case TWI_SRX_GEN_ACK:            // General call address has been received; ACK has been returned
//    case TWI_SRX_GEN_ACK_M_ARB_LOST: // Arbitration lost in SLA+R/W as Master; General call address has been received; ACK has been returned
      TWI_statusReg.bits.genAddressCall = TRUE;

    case TWI_SRX_ADR_ACK:            // Own SLA+W has been received ACK has been returned
//    case TWI_SRX_ADR_ACK_M_ARB_LOST: // Arbitration lost in SLA+R/W as Master; own SLA+W has been received; ACK has been returned    
                                                        // Dont need to clear TWI_S_statusRegister.generalAddressCall due to that it is the default state.
      TWI_statusReg.bits.RxDataInBuf = TRUE;      
      TWI_bufPtr   = 0;                                 // Set buffer pointer to first data location
                                                        // Reset the TWI Interupt to wait for a new event.
      TWCR = (1<<TWEN)|                                 // TWI Interface enabled
             (1<<TWIE)|(1<<TWINT)|                      // Enable TWI Interupt and clear the flag to send byte
             (1<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|           // Expect ACK on this transmission
             (0<<TWWC);                                 //      
      break;

    case TWI_SRX_ADR_DATA_ACK:       // Previously addressed with own SLA+W; data has been received; ACK has been returned
    case TWI_SRX_GEN_DATA_ACK:       // Previously addressed with general call; data has been received; ACK has been returned
      TWI_buf[TWI_bufPtr++]     = TWDR;
      TWI_statusReg.bits.lastTransOK = TRUE;                 // Set flag transmission successfull.       
                                                        // Reset the TWI Interupt to wait for a new event.
      TWCR = (1<<TWEN)|                                 // TWI Interface enabled
             (1<<TWIE)|(1<<TWINT)|                      // Enable TWI Interupt and clear the flag to send byte
             (1<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|           // Send ACK after next reception
             (0<<TWWC);                                 //  
      break;

    case TWI_SRX_STOP_RESTART:       // A STOP condition or repeated START condition has been received while still addressed as Slave    
	                                                       // Put TWI Transceiver in passive mode.
      TWCR = (1<<TWEN)|                                 // Enable TWI-interface and release TWI pins
             (0<<TWIE)|(0<<TWINT)|                      // Disable Interupt
             (0<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|           // Do not acknowledge on any new requests.
             (0<<TWWC);                                 //
        #ifdef aaa
	PORTD.3=1; 
#endif    
      break;           

    case TWI_SRX_ADR_DATA_NACK:      // Previously addressed with own SLA+W; data has been received; NOT ACK has been returned
    case TWI_SRX_GEN_DATA_NACK:      // Previously addressed with general call; data has been received; NOT ACK has been returned
    case TWI_STX_DATA_ACK_LAST_BYTE: // Last data byte in TWDR has been transmitted (TWEA = �0�); ACK has been received
//    case TWI_NO_STATE              // No relevant state information available; TWINT = �0�
    case TWI_BUS_ERROR:         // Bus error due to an illegal START or STOP condition

    default:     
      TWI_state = TWSR;                                 // Store TWI State as errormessage, operation also clears the Success bit.      
      TWCR = (1<<TWEN)|                                 // Enable TWI-interface and release TWI pins
             (0<<TWIE)|(0<<TWINT)|                      // Disable Interupt
             (0<<TWEA)|(0<<TWSTA)|(0<<TWSTO)|           // Do not acknowledge on any new requests.
             (0<<TWWC);                                 //

  } 
}
#include "CDdef.h"  
/*****************************************************************************
*
* Atmel Corporation
*
* File              : TWI_Slave.h
* Compiler          : IAR EWAAVR 2.28a/3.10c
* Revision          : $Revision: 1.6 $
* Date              : $Date: Monday, May 24, 2004 09:32:18 UTC $
* Updated by        : $Author: ltwa $
*
* Support mail      : avr@atmel.com
*
* Supported devices : All devices with a TWI module can be used.
*                     The example is written for the ATmega16
*
* AppNote           : AVR311 - TWI Slave Implementation
*
* Description       : Header file for TWI_slave.c
*                     Include this file in the application.
*
****************************************************************************/
#include <mega8.h> 

/****************************************************************************
  TWI Status/Control register definitions
****************************************************************************/

#define TWI_BUFFER_SIZE 250      // Reserves memory for the drivers transceiver buffer. 
                               // Set this to the largest message size that will be sent including address byte.

/****************************************************************************
  Global definitions
****************************************************************************/
/****************************************************************************
  Global definitions
****************************************************************************/
	typedef  struct
    {
        unsigned char lastTransOK:1;      
        unsigned char RxDataInBuf:1;
        unsigned char genAddressCall:1;                       // TRUE = General call, FALSE = TWI Address;
        unsigned char unusedBits:5;
    } SB;
  
  	typedef union 				                       // Status byte holding flags.
	{
    	unsigned char all;
    	SB bits;
	}  TWISR;

extern  TWISR  TWI_statusReg;        


// ��� �������������
#define  __no_operation() #asm("nop")
#define  __enable_interrupt() #asm("sei")
#define  __disable_interrupt() #asm("cli")


/****************************************************************************
  Function definitions
****************************************************************************/
void TWI_Slave_Initialise( unsigned char );
unsigned char TWI_Transceiver_Busy( void );
unsigned char TWI_Get_State_Info( void );
void TWI_Start_Transceiver_With_Data( unsigned char * , unsigned char );
void TWI_Start_Transceiver( void );
unsigned char TWI_Get_Data_From_Transceiver( unsigned char *, unsigned char );    

void run_TWI_slave ( void );


/****************************************************************************
  Bit and byte definitions
****************************************************************************/
#define TWI_READ_BIT  0   // Bit position for R/W bit in "address byte".
#define TWI_ADR_BITS  1   // Bit position for LSB of the slave address bits in the init byte.
#define TWI_GEN_BIT   0   // Bit position for LSB of the general call bit in the init byte.

#define TRUE          1
#define FALSE         0

/****************************************************************************
  TWI State codes
****************************************************************************/
// General TWI Master staus codes                      
#define TWI_START                  0x08  // START has been transmitted  
#define TWI_REP_START              0x10  // Repeated START has been transmitted
#define TWI_ARB_LOST               0x38  // Arbitration lost

// TWI Master Transmitter staus codes                      
#define TWI_MTX_ADR_ACK            0x18  // SLA+W has been tramsmitted and ACK received
#define TWI_MTX_ADR_NACK           0x20  // SLA+W has been tramsmitted and NACK received 
#define TWI_MTX_DATA_ACK           0x28  // Data byte has been tramsmitted and ACK received
#define TWI_MTX_DATA_NACK          0x30  // Data byte has been tramsmitted and NACK received 

// TWI Master Receiver staus codes  
#define TWI_MRX_ADR_ACK            0x40  // SLA+R has been tramsmitted and ACK received
#define TWI_MRX_ADR_NACK           0x48  // SLA+R has been tramsmitted and NACK received
#define TWI_MRX_DATA_ACK           0x50  // Data byte has been received and ACK tramsmitted
#define TWI_MRX_DATA_NACK          0x58  // Data byte has been received and NACK tramsmitted

// TWI Slave Transmitter staus codes
#define TWI_STX_ADR_ACK            0xA8  // Own SLA+R has been received; ACK has been returned
#define TWI_STX_ADR_ACK_M_ARB_LOST 0xB0  // Arbitration lost in SLA+R/W as Master; own SLA+R has been received; ACK has been returned
#define TWI_STX_DATA_ACK           0xB8  // Data byte in TWDR has been transmitted; ACK has been received
#define TWI_STX_DATA_NACK          0xC0  // Data byte in TWDR has been transmitted; NOT ACK has been received
#define TWI_STX_DATA_ACK_LAST_BYTE 0xC8  // Last data byte in TWDR has been transmitted (TWEA = �0�); ACK has been received

// TWI Slave Receiver staus codes
#define TWI_SRX_ADR_ACK            0x60  // Own SLA+W has been received ACK has been returned
#define TWI_SRX_ADR_ACK_M_ARB_LOST 0x68  // Arbitration lost in SLA+R/W as Master; own SLA+W has been received; ACK has been returned
#define TWI_SRX_GEN_ACK            0x70  // General call address has been received; ACK has been returned
#define TWI_SRX_GEN_ACK_M_ARB_LOST 0x78  // Arbitration lost in SLA+R/W as Master; General call address has been received; ACK has been returned
#define TWI_SRX_ADR_DATA_ACK       0x80  // Previously addressed with own SLA+W; data has been received; ACK has been returned
#define TWI_SRX_ADR_DATA_NACK      0x88  // Previously addressed with own SLA+W; data has been received; NOT ACK has been returned
#define TWI_SRX_GEN_DATA_ACK       0x90  // Previously addressed with general call; data has been received; ACK has been returned
#define TWI_SRX_GEN_DATA_NACK      0x98  // Previously addressed with general call; data has been received; NOT ACK has been returned
#define TWI_SRX_STOP_RESTART       0xA0  // A STOP condition or repeated START condition has been received while still addressed as Slave

// TWI Miscellaneous status codes
#define TWI_NO_STATE               0xF8  // No relevant state information available; TWINT = �0�
#define TWI_BUS_ERROR              0x00  // Bus error due to an illegal START or STOP condition

// ���� TWCR
#define TWINT 7             //���� ���������� ���������� ������
#define TWEA  6             //�������� �� ��� ������ �� �����
#define TWSTA 5             //�������� �����
#define TWSTO 4             //�������� ����
#define TWWC  3             //
#define TWEN  2             //��������� ������ I2C
#define TWIE  0             //����������



flash unsigned char device_name[32] =					// ��� ����������
		"Main Program. Mega 8L ";
eeprom unsigned long my_ser_num = 1;					// �������� ����� ����������
const flash unsigned short my_version_high = 1;				// ������ ����� 
const flash unsigned short my_version_low = 2;				// ������ ����� 
//eeprom unsigned char my_addr = TO_MON;					// ��� ����� - ���������� TO_MON

//-----------------------------------------------------------------------------------------------------------------

// ----------------------- ��������� ���������� ������� 0 (����-��� RS232) --------
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
	TCCR0=0x00;										// ������������� ������
}
//--------------------------------------------------------------------------------------

// �������� ������ ������ ����������
 void give_GETINFO (void)
{
	// 	������  ���� ����������
			putchar ('q');						// ���������
			putchar (3);							// ����� ���� ����� �����
			putchar (255);		 				//  ����� (�����������)
			putchar (PT_GETINFO);		// ��� ������
			putchar ((PT_GETINFO)+(255)+3+('q'));
			
			CountUART = 0;				// ������� �������� �����  

}

// ----------------------- ��������� ���������� ������� 1 ( ����� ����������� ������ 8 �) --------
// Timer 1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
		if (! (Device_Connected) )
		{
			lAddr = 0;						// ������ �� ����������             
			_GetLogAddr ();				// c������� ���� ���������� �����
		}

		Device_Connected = 0;						// ���� ��������� ���������� ������������ �� ?           

		give_GETINFO();		// ���������� ������� �������
#ifdef aaa
    putchar (0xac);
	putchar (TWDR);
	putchar (TWSR);
#endif    

}

// ���������� ����� �� GEN CALL
void	Responce_OK (u8 Status)
{    

		Long_TX_Packet_TWI = 2;				 		// ����� ������

				Command_TX_Packet_TWI = Responce_GEN_CALL_internal;	

	// ����� �� ������
	if ( Status == FALSE )
	{
		Packet_Lost ++;								// �������� �����
		txBufferTWI[Start_Position_for_Reply+2] = FALSE;		  				// ����������
	}
	// ����� ������
	else
		txBufferTWI[Start_Position_for_Reply+2] = rxBufferUART[1];		// ����������

		packPacket (Internal_Packet);	// ���� ��� ����������
}

// ���� ������ ��� ����. ���������. �������� � �������� 2.
void Wait_Responce ( unsigned char Status )
{
			Count_For_Timer2 = 0;                                  

			TCNT2=0x00;			
			if ( Status == START_Timer )
			{
			 	Responce_Time_Out = 0;								
			 	TCCR2=0x07;       // ����
			}
			else 		
				TCCR2=0x00;       // ����

}
// ----------------------- ��������� ���������� ������� 2 ------------------------
// ���� ������������� �������� ������ ����������� ( �������� ������ ���������� - 200��)
// Timer 2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
		Count_For_Timer2 ++;

		if (Count_For_Timer2 > 4 )
		{
			Responce_Time_Out = 1;				// ����� �������� ��������� ������ �������
			Wait_Responce ( STOP_Timer );				// ����
		}                                   
}


//-----------------------------------------------------------------------------------------------------------------
// ������� �� ������� ������� � ������� �����
void ToWorkMode(void)
{
	// ��������� �����
	Long_TX_Packet_TWI = 1;        						// ����������� �����
	txBufferTWI[Start_Position_for_Reply+1] = 1;        						// ����������� �����

	packPacket (External_Packet);	// ���� ��� �������
}
// ���������� ��������� ������ ����������
static void SetSerial(void)
{
		Long_TX_Packet_TWI = 2;  			//�����
		txBufferTWI[Start_Position_for_Reply+1] = (RES_OK);		
		txBufferTWI[Start_Position_for_Reply+2] = 2+(RES_OK);          // ��

		packPacket (External_Packet);	// ���� ��� �������
}

//  ���������� ������ ����������
void Setaddr (void)
	{
			Long_TX_Packet_TWI = 2;  			//�����
			txBufferTWI[Start_Position_for_Reply+1] = 0;		
			txBufferTWI[Start_Position_for_Reply+2] = 2;          // ��

			packPacket (External_Packet);	// ���� ��� �������
	}

// ������������ � ����� ����������������
static void ToProg(void)
{
			// ��������� �����
			Long_TX_Packet_TWI = 1;  			//�����
			txBufferTWI[Start_Position_for_Reply+1] = 1;          // ��
		
			packPacket (External_Packet);	// ���� ��� �������
			to_Reboot = 1;			//  �� ������������ � ���������
}		


// ��������� ��������� ����������
const char _PT_GETSTATE_[]={67,2,0,"Connected Dev.",100,"RelayTWI->UART",100,
														"RelayUART->TWI",100,"Packet LOST   ",100,255};

static void GetState(void)
{
	register unsigned char a=Start_Position_for_Reply;

	switch (PT_GETSTATE_page)
	{
		case 0:
			memcpyf(&txBufferTWI[Start_Position_for_Reply], _PT_GETSTATE_, _PT_GETSTATE_[0]+1); // 0 �����
			break;

		case 1:			
			txBufferTWI[a++] = 14;				 			// ����� ������

			txBufferTWI[a++] = 0;							// � ����������
			txBufferTWI[a++] = TWI_slaveAddress;
			txBufferTWI[a++] = lAddr;

			txBufferTWI[a++] = 1;							// � ����������
			txBufferTWI[a++] = TWI_slaveAddress;
			txBufferTWI[a++] =  Relay_Pack_TWI_UART;

			txBufferTWI[a++] = 2;							// � ����������
			txBufferTWI[a++] = TWI_slaveAddress;
			txBufferTWI[a++] =  Relay_Pack_UART_TWI;

			txBufferTWI[a++] = 3;							// � ����������
			txBufferTWI[a++] = TWI_slaveAddress;
			txBufferTWI[a++] =  Packet_Lost;

			txBufferTWI[a++] = 255;
			break;

		default:
			txBufferTWI[a++] = 0;				 			// ����� ������
			break;
	} 

	//KC
	txBufferTWI[txBufferTWI[Start_Position_for_Reply]+2] = calc_CRC( &txBufferTWI[Start_Position_for_Reply] );

	packPacket (External_Packet);	// ���� ��� �������
} 

// ���������� �� ����������:

static void GetInfo(void)
{
		register unsigned char i,a=Start_Position_for_Reply;                    
	
		// 	�������� �����
		txBufferTWI[a++] = 40+1;
	
		for ( i = 0; i <32; i ++ )	
				txBufferTWI[a++] = device_name[i];	// ��� ����������

		txBufferTWI[a++] = my_ser_num;         	 	// �������� �����
		txBufferTWI[a++] = my_ser_num>>8;    	  	// �������� �����

		txBufferTWI[a++] = my_ser_num>>16;		// �������� �����
		txBufferTWI[a++] = my_ser_num>>24;		// �������� �����
	
		txBufferTWI[a++] =TWI_slaveAddress ;    	// ����� ����������
        txBufferTWI[a++] =0;     							// ����������������� ����
	
		txBufferTWI[a++] = my_version_high;			// ������ �����
		txBufferTWI[a++] = my_version_low;			// ������  �����
		
		//KC
		txBufferTWI[txBufferTWI[Start_Position_for_Reply]+2] = calc_CRC( &txBufferTWI[Start_Position_for_Reply] );
		packPacket (External_Packet);					// ���� ��� �������
}


// ��������. ��������� ����� �� ��������
void _GetLogAddr (void)
{

		Long_TX_Packet_TWI = 2;				 					// ����� ������
		txBufferTWI[Start_Position_for_Reply+1] = GetLogAddr;		 				// ��� ������
		txBufferTWI[Start_Position_for_Reply+2] = lAddr;		  						// ����������

		packPacket (Internal_Packet);					// ���� ��� ����������
}  
	
// ������������ �� TWI � UART
void relayTWI_to_UART (void)
{       
		u8 a;
		
		if ( Device_Connected )
		{
			Wait_Responce ( START_Timer );  

			for ( a = 1;a<= Long_RX_Packet_TWI+2; a++ )	
					putchar ( rxBufferTWI[a] ); 

			Relay_Pack_TWI_UART++;			//������� ����������
			LedOn ();										// ��������� �����	
			gate_UART_to_TWI_open = TRUE;	// ��������� �������� ������������		
		}

}

// ��������-��������� UART
void    port_state (u8 state)
{
	if (state == FALSE) 
	{     
		UCSRB=0x0;					
		UCSRC=0x0;
		UBRRL=0x0;
	}
	else
	{
		UCSRB=0x98;				
		UCSRC=0x86;
		UBRRL=0x0C;
	}
}


// ������������ �������� ����� TWI
void workINpack ( void )
		{

		// ��������� ���������� �������
		if ( Recived_Address == Internal_Packet )		
		{
				#ifdef DEBUG
				putchar2 (0x04);
				#endif
			switch ( Type_RX_Packet_TWI )
			{
				case PT_GETINFO:			// ���������� � ���� ����������
						GetInfo();
						break;                                     
						
				case PT_GETSTATE:				// ���������� ���������
						GetState();
						break;

		 		case PT_TOPROG:       			// ��������� � ����������������
						ToProg();
						break;      

		 		case PT_PORT_UNLOCK:      // ��������� UART
						port_state(TRUE);
						break;

		 		case PT_SCRDATA:       		// ����� ����������� ����������
						Recived_Address = 255;			//������ ����� � ��
						CRC_RX_Packet_TWI = calc_CRC( &Long_RX_Packet_TWI )+Heading_RX_Packet;

						InternalPack = TRUE;
						relayTWI_to_UART ();
						break;

				default:
						break;

			}
         }
	    else	if( Recived_Address == TO_MON)					// ������������ ����� �� ������ MONITOR
		{
			switch ( Type_RX_Packet_TWI )
			{
		 		case PT_SETADDR:       			// ��������� � ����������������
						Setaddr();
						break;      

		 		case PT_SETSERIAL:       			// ��������� � ����������������
						SetSerial();
						break; 

		 		case PT_TOWORK:       			// ��������� � ����������������
						ToWorkMode();
						break;


				default: 
						break;
									     
			}                                                                               
		}
		// ����� �������������
		// ������ ��� ������������ ���������� � �������. ����
		else
		{ 													
				relayTWI_to_UART ();
		}
}	

// ��������� ������, ��������� �� UART        
// �������� ����� ������������� �� �������:
//    �����_���_�������� �����_��(������� �����)

void workUARTpack (void)
{
	if (! Device_Connected ) 						// ������� ������ �����           
	{
		lAddr = rxBufferUART [37];			// �������� ����� �� ��������� �����             
		_GetLogAddr ();							// c������� ���� ���������� �����
		Device_Connected = 1;				// ���������� �������� 
		LedOff();									// ����� ��������� �������

	}
	else
	{
			#ifdef DEBUG
			putchar2 (0x01);
			#endif

		if (gate_UART_to_TWI_open == TRUE)
		{
			Wait_Responce ( STOP_Timer );  	// ������������� ������

			if (InternalPack == TRUE)
			{
				#ifdef DEBUG
				putchar2 (0x02);
				#endif
				Responce_OK ( TRUE );					// ���������� �����
			}				
			else
			{
				#ifdef DEBUG
				putchar2 (0x03);
				#endif
					memcpy(&txBufferTWI[Start_Position_for_Reply], rxBufferUART, rxBufferUART[0]+1); 	// ����� ��������
					packPacket (External_Packet);		// ���� ��� �������
			}

			InternalPack = FALSE;
			Relay_Pack_UART_TWI++;			//������� ����������						
		}
	}
}	
	

	//--------------------------------------------------------------------------------------------
// "�����������" UART
#ifdef DEBUG
void dtxdl(void)
{
	int i;
	for (i = 0; i < 17; i ++)
	{
		#asm("nop")
	}
}

void putchar2(char c)
{
	register unsigned char b;
	
	#asm("cli")
	
	DTXDDR = 1;
//	DRXDDR = 0;
	DTXPIN = 0;
	dtxdl();
	
	for (b = 0; b < 8; b ++)
	{
		if (c & 1)
		{
			DTXPIN = 1;
		}
		else
		{
			DTXPIN = 0;
		}
             
		c >>= 1;
		dtxdl();
	}

	DTXPIN = 1;
	dtxdl();
	dtxdl();
	
	#asm("sei")
}
#endif DEBUG
	
