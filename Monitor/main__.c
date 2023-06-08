////////////////////////////////////////////////////////////////////////////////////////////////////////
// ������� - ��������� FLASH � EEPROM. �������� �� TWI
////////////////////////////////////////////////////////////////////////////////////////////////////////
#include "monitor.h" 
#include "CodingM8.h"      
#include "stdio.h"  
#include "string.h"  


eeprom unsigned char device_name[32] =					// ��� ����������
		"BOOT PROGRAM. Mega 8L ";
//eeprom unsigned long my_ser_num = 1;					// �������� ����� ����������
#define  my_ser_num  1					// �������� ����� ����������

const flash unsigned short my_version_high = 1;				// ������ ����� 
const flash unsigned short my_version_low = 1;				// ������ ����� 

eeprom unsigned char my_addr = TO_MON;					// ��� ����� - ���������� TO_MON
    

const   unsigned int scrambling_seed = 333;

//unsigned char pAddr;				// ����� ���������� �� ���� TWI
//unsigned char adr;									// ����� � ��������� ������
unsigned char rxPack;							// ������ ����� TWI

// ��� ��� ������ � TWI
TWISR TWI_statusReg;   
unsigned char 	TWI_slaveAddress = MY_TWI_ADDRESS;		// Own TWI slave address


bit		TWI_TX_Packet_Present				=		0;					// ���� ������ �� ��������
bit		toReboot										=		0;					// ������������� � ������� ���������
bit		toProgramming								=		0;					// ��� �������������
	
unsigned char txBufferTWI 			[TWI_BUFFER_SIZE/4];		// ���������� �����
unsigned char rxBufferTWI	[TWI_BUFFER_SIZE];	// �������� �����


// ������� ���������� � �������� � ����������
void PrgInfo(void)
{
	// ��������� �����
//	#asm("wdr");
	txBufferTWI[Start_Position_for_Reply] = (sizeof(RP_PRGINFO) +1);

	txBufferTWI[Start_Position_for_Reply+1] = (PAGESIZ);     			//��.
	txBufferTWI[Start_Position_for_Reply+2] = (PAGESIZ>>8);          //��.

	txBufferTWI[Start_Position_for_Reply+3] = (PRGPAGES);
	txBufferTWI[Start_Position_for_Reply+4] = (PRGPAGES>>8);

	txBufferTWI[Start_Position_for_Reply+5] = (EEPROMSIZ);
	txBufferTWI[Start_Position_for_Reply+6] = (EEPROMSIZ>>8);

	txBufferTWI[Start_Position_for_Reply+7] = (MONITORVERSION);
	txBufferTWI[Start_Position_for_Reply+8] = (MONITORVERSION>>8);
	
	txBufferTWI[Start_Position_for_Reply+9] = calc_CRC( &txBufferTWI[Start_Position_for_Reply] );

	// ������� � ����� ���������������� - ������ ���� ����� ����� ��������� �����
	prgmode = 1;
	
	// ������� ��������� ����������� ������������������
	ResetDescrambling();
}


// ����� ����� �� �������
unsigned short GetWordBuff(unsigned char a)
{
	register unsigned short ret;  

	// ��������������
	ret = ( rxBufferTWI	[a++] ^ NextSeqByte() );
	ret |= ((unsigned short)rxBufferTWI[a] ^ NextSeqByte() ) << 8;

	return ret;
} 



// ������ � EEPROM
void WriteEeprom(void)
{
	register unsigned short addr;
	register unsigned char  data;

	// ����� ������ � ������	
	#asm ("wdr");

	addr = GetWordBuff(5);
	data = ( rxBufferTWI	[7] ^ NextSeqByte() );


	// �������� ���������� � ������������ ������
	if (addr < EEPROMSIZ)
	{
		// ���� � EEPROM
		*((char eeprom *)addr) = data;

		// ��������, ���������� ��
		if (*((char eeprom *)addr) == data)
		{
			// �������, ��� ��� � ������� 
			txBufferTWI[Start_Position_for_Reply] = 2;        				// �����
			txBufferTWI[Start_Position_for_Reply+1] = RES_OK;				//  OK
			txBufferTWI[Start_Position_for_Reply+2] = 2 + RES_OK;		//  CRC

			return;
		}
	}
     
	// ������
	txBufferTWI[Start_Position_for_Reply] = 2;        				// �����
	txBufferTWI[Start_Position_for_Reply+1] = RES_ERR;			//  ������
	txBufferTWI[Start_Position_for_Reply+2] = 2 + RES_ERR;		//  CRC

} 

// ������ ����� �� FLASH �� ������
#ifdef USE_RAMPZ
	#pragma warn-
	unsigned char FlashByte(FADDRTYPE addr)
	{
	#asm
		ld		r30, y		; �������� Z
		ldd		r31, y+1
		
		in		r23, rampz	; �������� RAMPZ
		
		ldd		r22, y+2	; �������� RAMPZ
		out		rampz, r22
		
		elpm	r24, z		; ����� FLASH
		
		out		rampz, r23	; �������������� RAMPZ

		mov		r30, r24	; ������������ ��������
	#endasm
	}	
	#pragma warn+
#else
	#define FlashByte(a) (*((flash unsigned char *)a))
#endif

// �������� ������� "�������" ���������
unsigned char AppOk(void)
{
	FADDRTYPE addr, lastaddr;
	unsigned short crc, fcrc;
	
	//WD ���� �� �������	
//	#asm("wdr");
	
	lastaddr = ( (FADDRTYPE)FlashByte(PRGPAGES*PAGESIZ - 4) | 
	            ((FADDRTYPE)FlashByte(PRGPAGES*PAGESIZ - 3) << 8))
	            << (ZPAGEMSB + 1);
	            

	if (lastaddr == (0xFFFF << (ZPAGEMSB + 1)))
	{
	        return 0;
	}
	
	for (addr = 0, crc = 0; addr != lastaddr; addr ++)
	{
		crc += FlashByte(addr);
	}

	fcrc = 	 (unsigned short)FlashByte(PRGPAGES*PAGESIZ - 2) | 
			((unsigned short)FlashByte(PRGPAGES*PAGESIZ - 1) << 8);
	
	if (crc != fcrc)
	{
		return 0;
	}
	
	return 1;
}

// ������������ � ������� �����
void RebootToWork(void)
{
	// ��������, ���� �� ���� ���������
	if (!AppOk())
	{
		return;
	}

	#asm("cli");
	IVCREG = 1 << IVCE;
	IVCREG = 0;

	#asm("rjmp 0");      //Mega128 - JMP, Mega8 - RJMP
}

// ������� �� ������� ������� � ������� �����
void ToWorkMode(void)
{

	// ��������� �����
	txBufferTWI[0] = 0;        						// ����������� �����
//	dannForTX = 1;								// ���� ������

	prgmode = 0;
	  
	// �� ������������
	toReboot =1;
//	RebootToWork();
}

//-----------------------------------------------------------------------------------------------------------------

// ��������� ��������� ����������
const char _PT_GETSTATE_[]={19,2,0,"BOOT PROGRAM  ",100,255};

static void GetState(void)
{
	register unsigned char a=Start_Position_for_Reply;

	switch (PT_GETSTATE_page)
	{
		case 0:
			memcpyf(&txBufferTWI[2], _PT_GETSTATE_, _PT_GETSTATE_[0]+1); // 0 �����
			a+=19;
			break;

		case 1:			
			txBufferTWI[a++] = 5;				 			// ����� ������

			txBufferTWI[a++] = 0;							// � ����������
			txBufferTWI[a++] = MY_TWI_ADDRESS;
			txBufferTWI[a++] = 0;

			txBufferTWI[a++] = 255;
			break;

		default:
			txBufferTWI[a++] = 0;				 			// ����� ������
			break;
	} 

	txBufferTWI[a] = calc_CRC( &txBufferTWI[Start_Position_for_Reply] );
} 

// ���������� �� ����������:

static void GetInfo(void)
{
		register unsigned char i,a=Start_Position_for_Reply;                    
	
		// 	�������� �����
		txBufferTWI[a++] = 40+1;
	
		for ( i = 0; i <32; i ++ )	
				txBufferTWI[a++] = device_name[i];	// ��� ����������

		txBufferTWI[a++] = my_ser_num;        		// �������� �����
		txBufferTWI[a++] = my_ser_num>>8;    	  	// �������� �����

		txBufferTWI[a++] = my_ser_num>>16;		// �������� �����
		txBufferTWI[a++] = my_ser_num>>24;		// �������� �����
	
		txBufferTWI[a++] =MY_TWI_ADDRESS ; 	// ����� ����������
        txBufferTWI[a++] =0;     							// ����������������� ����
	
		txBufferTWI[a++] = my_version_high;        	// ������ �����
		txBufferTWI[a++] = my_version_low;			// ������  �����
		
		txBufferTWI[a] = calc_CRC( &txBufferTWI[Start_Position_for_Reply] );

}


void main(void)
{
	// ���������� "������"
	 Initialization_Device(); 

	// Global enable interrupts
	#asm("sei")

	// ��������, ����� � ���������� ������
	while (1)
	{

	// ���������� ������� ��������� �� ������� (�������� 2�)
	if ( TIFR & (1 << TOV1) )
	{
		TIFR |= (1<<TOV1);
		TCNT1=0xD2F6;		//�������� 2���

		// ������� ������������� � ������� �����	
		RebootToWork();
	}

//		#asm("wdr");
		run_TWI_slave();
		
		// ������������ �������� ����� TWI
		if ( rxPack )
		{
			// ��������� ���������� �������
			if ( ( Recived_Address == Internal_Packet ) || ( Recived_Address == Global_Packet ) )		
			{
				switch ( Type_RX_Packet_TWI )
				{
					// ���������� � ���� ����������
					case PT_GETINFO:			
//							GetInfo();
							break;                                     

					// ���������� ���������						
					case PT_GETSTATE:			
//							GetState();
							break;                      

					// ������� � ����������������
					case PT_TOPROG:
							toProgramming = 1;				// ���� ������ ����������������
							// ��������� �����
							txBufferTWI[0] = 1;				 	// ����� ������
							txBufferTWI[1] = 1;				 	// ��

							break;      

					// ������� ���������� � �������� � ����������
					case PT_PRGINFO:	
							PrgInfo();
							break;

					// �������� �������� FLASH							
					case PT_WRFLASH:	

//							TCNT1=0xD2F6;		//�������� 2���

//							toProgramming = 1;				// ���� ������ ����������������
							WriteFlash();
							break;

					// �������� ���� � EEPROM
					case PT_WREEPROM:	

//							TCNT1=0xD2F6;		//�������� 2���

							WriteEeprom();
							break;
			

					default:
//							toProgramming = 0;		// ������������� �� ���
				}
				// ���������� �����
				packPacket (External_Packet);	// ���� ��� �������
				// ������������������ ������
				TCNT1=0xD2F6;		//�������� 2���
	         }
		
		rxPack = 0;							// ����� ���������
        }          
	}
}




/*		else if ( Recived_Address == MY_TWI_ADDRESS ) 							////////////// ��� �����. ���������� �� ���
		{
			switch ( Type_RX_Packet_TWI )
			{
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
		    else	if( Recived_Address == TO_MON)					// ������������ ����� �� ������ MONITOR
			{
				switch ( Type_RX_Packet_TWI )
				{
		 			case PT_SETADDR:       			// ��������� � ����������������
//							Setaddr();
							rxPack = 0;					// ����� ���������
							break;      

			 		case PT_SETSERIAL:       			// ��������� � ����������������
//							SetSerial();
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
	



/*
//		Wait4Hdr();						// ���� �����
        if ((adr == pAddr)||(adr == TO_MON )) 	            // ������ ��� ������� ���������
        	{
				switch(typePack)
					{

						case PT_PRGINFO:	// ������� ���������� � �������� � ����������
							PrgInfo();
							txBuff();
							break;

						case PT_WRFLASH:	// �������� �������� FLASH
							WriteFlash();
							txBuff();
							break;

						case PT_WREEPROM:	// �������� ���� � EEPROM
							WriteEeprom();
							txBuff();
						break;

						case PT_TOWORK:		// ��������� � ����� ������
							ToWorkMode();			
							txBuff();                         // �������� �
							RebootToWork();			// �� ������������
							break;    

						case PT_TOPROG:
							txBuffer[0] = 0;        				// �� ������ � ���������������
							txBuff();
							break;      

						case PT_GETINFO:
							GetInfo();
							txBuff();
							break;

						case PT_GETSTATE:
							GetState();
							txBuff();
							break;
						
						default:
							break;
					}

        	}
        else         if (adr==0)											//  ������� ��� �����. ������ 0
        	{
				switch(typePack)
					{
						case GetLogAddr:     						// ��������. ��������� ������ �� ��������
								txBuffer[0] = 1;				 		// ����� ������
								txBuffer[1] = 0;				 		// ���. �����
								txBuff ();                           		// ��������
								break;

/*						case pingPack :
								if (dannForTX) txBuff();
								else 	twi_byte(0);				  			// ����� ������
								break;
						default:
								break;
					}
        	
			}*/
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
//--------------------------------------------------------------------------------------
// ������� ��� ������ � FLASH

#include "CodingM8.h"      
#include "monitor.h"

#if (defined _CHIP_ATMEGA128L_) || (defined _CHIP_ATMEGA128_)
	#asm
		.equ	SPMCSR = 0x68
		.equ	SPMREG = SPMCSR
	#endasm
#elif (defined _CHIP_ATMEGA8_) || (defined _CHIP_ATMEGA8L_) || (defined _CHIP_ATMEGA8515_) || (defined _CHIP_ATMEGA8515L_) || (defined _CHIP_ATMEGA162_) || (defined _CHIP_ATMEGA162L_)
	#asm
		.equ	SPMCR  = 0x37
		.equ	SPMREG = SPMCR
	#endasm
#else
	#error ��������� ��� ����� ���������� ��� �� ��������
#endif

#asm
	.equ	SPMEN  = 0	; ���� ��������
	.equ	PGERS  = 1
	.equ	PGWRT  = 2
	.equ	BLBSET = 3
	.equ	RWWSRE = 4
	.equ	RWWSB  = 6
	.equ	SPMIE  = 7
	;--------------------------------------------------
	; �������� ���������� SPM. ������ R23
	spmWait:
#endasm
#ifdef USE_MEM_SPM
	#asm
		lds		r23, SPMREG
	#endasm
#else
	#asm
		in		r23, SPMREG
	#endasm
#endif
#asm
		andi	r23, (1 << SPMEN)
		brne	spmWait	
		ret
	;--------------------------------------------------
	; ������ SPM.
	spmSPM:
		in		r24, SREG	; �������� ���������
		cli					; �������� ����������
#endasm
#ifdef USE_RAMPZ
	#asm
		in		r25, RAMPZ	; �������� RAMPZ
	#endasm
#endif
#asm
		ld		r30, y		; �����
		ldd		r31, y+1
#endasm
#ifdef USE_RAMPZ
	#asm
		ldd		r26, y+2	; 3-� ���� ������ - � RAMPZ
		out		RAMPZ, r26
	#endasm
#endif
#asm
		rcall	spmWait		; ��� ���������� ���������� �������� (�� ������ ������)
#endasm
#ifdef USE_MEM_SPM
	#asm
		sts SPMREG, r22		; ������� ������, ��� ������
	#endasm
#else
	#asm
		out SPMREG, r22		; ������� ������, ��� ����
	#endasm
#endif
#asm
		spm					; ������ �� ����������
		nop
		nop
		nop
		nop
		rcall	spmWait		; ��� ����������
#endasm
#ifdef USE_RAMPZ
	#asm
		out		RAMPZ, r25	; �������������� ���������
	#endasm
#endif
#asm
		out		SREG, r24
		ret
#endasm

#pragma warn-
void ResetTempBuffer (FADDRTYPE addr)
{
	#asm
		ldi		r22, (1 << RWWSRE) | (1 << SPMEN)
		rcall	spmSPM
	#endasm
}

void FillTempBuffer (unsigned short data, FADDRTYPE addr)
{
	#ifdef USE_RAMPZ
		#asm
			ldd		r0, y+4			; ������
			ldd		r1,	y+5
		#endasm
	#else
		#asm
			ldd		r0, y+2			; ������
			ldd		r1,	y+3
		#endasm
	#endif
	#asm
		ldi		r22, (1 << SPMEN)	; �������
		rcall	spmSPM				; �� ����������
	#endasm
}

void PageErase (FADDRTYPE  addr)
{
	#asm
		ldi		r22, (1 << PGERS) | (1 << SPMEN)
		rcall	spmSPM
	#endasm
}

void PageWrite (FADDRTYPE addr)
{
	#asm
		ldi		r22, (1 << PGWRT) | (1 << SPMEN)
		rcall	spmSPM
	#endasm
}
#pragma warn+

void PageAccess (void)
{
	#asm
		ldi		r22, (1 << RWWSRE) | (1 << SPMEN)
		rcall	spmSPM
	#endasm
}

// ������ �������� FLASH
void WriteFlash(void)
{
	unsigned char a = 5;
	FADDRTYPE faddr;

	// ������� ����� ��������
	#asm ("wdr");
	faddr = GetWordBuff(a);
	a+=2;							// �������� 2 �����
	
	if (faddr >= PRGPAGES)
	{
		while(1);	// ���� ������������ ����� �������� - ������������ ������ � ����� �� ��������
	}	            
	

	// ������� ����� ������ ��������
	faddr <<= (ZPAGEMSB + 1);
	
	// �������� ������ � ������������� �����
	#asm ("wdr");
	ResetTempBuffer(faddr);
	do{
			FillTempBuffer(GetWordBuff(a), faddr);			// 
			a+=2;
			faddr += 2;
    	}while (faddr & (PAGESIZ-1)) ;	

		// �������, ��� ��� � ������� � ����� �������� ���������
//		#asm ("wdr");
//		txBufferTWI[0] = 2;                   		// �����
//		txBufferTWI[1] = RES_OK;
//		txBufferTWI[2] = 2 + RES_OK;         // ��*/

	// �������������� ����� ������ ��������
	faddr -= PAGESIZ;

	// ������ ��������
//	#asm ("wdr");
	PageErase(faddr);
	
	// ��������� ��������
	#asm ("wdr");
	PageWrite(faddr);

	// ��������� ��������� ������� RWW
	#asm ("wdr");
	PageAccess();

	// �������, ��� ��� � ������� � ����� �������� ���������
//	#asm ("wdr");
		txBufferTWI[Start_Position_for_Reply] = 2;                   		// �����
		txBufferTWI[Start_Position_for_Reply+1] = RES_OK;
		txBufferTWI[Start_Position_for_Reply+2] = 2 + RES_OK;         // ��*/
}
 
///////////////////////////////////////////////////////////////////////////////////////////
// ������������ ��������������� ������

unsigned long int next_rand = 1;
unsigned char rand_cnt = 31;

// ��������� ��������������� ������������������.
// �� ������ ����� IAR-������ ���������

bit descramble = 0;					// ������� ������������� ������������

unsigned char NextSeqByte(void)	// ��������� ���� ����������� ������������������
{
	next_rand = next_rand * 1103515245 + 12345;
	next_rand >>= 8;
	
	rand_cnt += 101;
		
	return rand_cnt ^ (unsigned char)next_rand;
}

void ResetDescrambling(void)		// ���������� ���������� ����������� ������������������
{
	next_rand = scrambling_seed;
	rand_cnt = 31;
	descramble = 0;
}
