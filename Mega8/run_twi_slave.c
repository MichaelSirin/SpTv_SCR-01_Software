#include <twi_slave.h >
#include <Scrambling.h >

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
