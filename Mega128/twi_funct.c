////////////////////////////////////////////////////////
// ������� ������ � TWI

#include "coding.h"


// ������� CRC ������
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


// ������� �� ��������� ������. ��������� - �� ���� ����� ������.
unsigned char check_RX_CRC_TWI (unsigned char *Position_in_Packet)
{                    
	unsigned char CRC = 0, a;		

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
                    
                    // Here is a simple sample, where if received a NACK on the slave address,
                    // then a retransmission will be initiated.
 
  if ( (TWIerrorMsg == TWI_MTX_ADR_NACK) | (TWIerrorMsg == TWI_MRX_ADR_NACK) )
    TWI_Start_Transceiver();
    
  return TWIerrorMsg; 
}


// ��������� ������� TWI
u8 RUN_TWI (u8 TWI_targetSlaveAddress, u8 TWI_sendCommand,	u8 Count_Bytes )
{

	    if ( ! TWI_Transceiver_Busy() )                              
	    {
    	// Check if the last operation was successful
	      if ( TWI_statusReg.bits.lastTransOK )
    	  {
			LedGreen ();			// TWI   � �����
			
	        if (TWI_operation == SEND_DATA)
	        { // Send data to slave
    	      txBuffer[0] = (TWI_targetSlaveAddress<<TWI_ADR_BITS) | (FALSE<<TWI_READ_BIT);
			  txBuffer[1] = TWI_sendCommand;             // The first byte is used for commands.

        	  TWI_Start_Transceiver_With_Data( txBuffer, Count_Bytes ); 
        	}  

	        else if (TWI_operation == REQUEST_DATA)
    	    { // Request data from slave
        	  txBuffer[0] = (TWI_targetSlaveAddress<<TWI_ADR_BITS) | (TRUE<<TWI_READ_BIT);
        	  TWI_Start_Transceiver_With_Data( txBuffer, Count_Bytes );
	        }

    	    else if (TWI_operation == READ_DATA_FROM_BUFFER)
        	{ // Get the received data from the transceiver buffer
	          TWI_Get_Data_From_Transceiver( rxBuffer, Count_Bytes ); // ����� �������� ���� � ������ ������ 	
	        }
			return TRUE;
    	  }
	      else // Got an error during the last transmission
    	  {
        	// Use TWI status information to detemine cause of failure and take appropriate actions. 
	        TWI_Act_On_Failure_In_Last_Transmission( TWI_Get_State_Info( ) );
			LedRed ();			// ������ TWI
    	  }
	    }
		return FALSE;		// ���� ��������
 }


//    ������������� ����.������
	void unlock_Pack (u8 TWI_targetSlaveAddress)
	{
		u8 temp = Start_point_of_Dann_TX_TWI;	
	
		// �������� ��� 
		txBuffer[temp++] = PACKHDR;				// ���������
		txBuffer[temp++] = 4; 			           		// �����
		txBuffer[temp++] = Internal_Packet;        	// �����
		txBuffer[temp++] = PT_PORT_UNLOCK; 	// ���
		txBuffer[temp++] = TRUE;						// ������
		txBuffer[temp++] = calc_CRC (&txBuffer[Start_point_of_Dann_TX_TWI+1]) + txBuffer[Start_point_of_Dann_TX_TWI];		//CRC

		// ��������
		TWI_operation = SEND_DATA; // Set next operation        
		while (! RUN_TWI ( TWI_targetSlaveAddress, TWI_CMD_MASTER_WRITE, txBuffer[Start_point_of_Dann_TX_TWI+1] + 4 ) );
		
		#ifdef print
		printf ("Unlock PORT %d \r\n",TWI_targetSlaveAddress);
		#endif

     }


// ������� ����������� ��� �������� ����������. ���� ������� ������ ��� ������ - 
// ���������� ������������� ������.
// 
unsigned char pingPack (unsigned char TWI_targetSlaveAddress)
{
		// ����� ������� ������
		TWI_operation = SEND_DATA; // Set next operation        
		while (! RUN_TWI ( TWI_targetSlaveAddress, TWI_CMD_MASTER_READ, 2 ) );
   
		// �������� ������
		TWI_operation = REQUEST_DATA; // Set next operation        
		while (! RUN_TWI (TWI_targetSlaveAddress, 0, 1 ) );

        TWI_operation = READ_DATA_FROM_BUFFER; // Set next operation        
		while (! RUN_TWI (TWI_targetSlaveAddress, 0, 2) );
		
		
		// ���� ������ �� ��������. ��������� �
		// ���� ������  ������� ��� ������ - �������� �������������
		
		if ( rxBuffer [1] )		
		{
			// �������� ������
			TWI_operation = REQUEST_DATA; // Set next operation        
			while (! RUN_TWI (TWI_targetSlaveAddress, 0, rxBuffer [1]+2 ) );

	        TWI_operation = READ_DATA_FROM_BUFFER; // Set next operation        
			while (! RUN_TWI (TWI_targetSlaveAddress, 0, rxBuffer [1] +2) );

			// ��������� ��
			if ( check_RX_CRC_TWI ( &rxBuffer[1] ) )
			{//  ������������� ������
				TWI_operation = SEND_DATA; // Set next operation        
				while (! RUN_TWI (TWI_targetSlaveAddress, TWI_CMD_MASTER_RECIVE_PACK_OK, 2 ) );
				
				return TRUE;
			}
		                      
		}	
		return FALSE;
}	
 
 

void	Relay_pack_from_UART_to_TWI (u8 TWI_targetSlaveAddress)
{    
		u8 a, b=0, CRC=0, temp = Start_point_of_Dann_TX_TWI;	
		
//		temp = Start_point_of_Dann_TX_TWI;	
	
		// �������� ��� 
		txBuffer[temp++] = PACKHDR;				// ���������
		txBuffer[temp++] = rx0len+3;            		// ����� (+3 - ��. ������� ��� ������)
		txBuffer[temp++] = rx0addr;                 	// �����
		txBuffer[temp++] = rx0type;					// ���

		for (a=0; a<=rx0len;  a++)
		{
			txBuffer[temp++] = rx0buf 	[b++];				
		}                   

		// ��������
		TWI_operation = SEND_DATA; // Set next operation        
		while (! RUN_TWI ( TWI_targetSlaveAddress, TWI_CMD_MASTER_WRITE, txBuffer[Start_point_of_Dann_TX_TWI+1] + 4 ) );

}

// ������������ ������ ������������ ����������
// ���������� �������� ���� �����������
//u8	Relay_pack_from_UART_to_TWI_Internal (void)
u8	Relay_pack_from_UART_to_TWI_Internal (u8 Target_Reciver_Addr)
{    
		u8 a, b=1, temp=Start_point_of_Dann_TX_TWI, CRC;
//									 Target_Reciver_Addr;

//		Target_Reciver_Addr = rx0buf [0]+offset;			// ����� ���������

		// ����� ����
		if ( ( Target_Reciver_Addr == 255 ) || ( Target_Reciver_Addr == 254 )  )
													  	Target_Reciver_Addr = TWI_GEN_CALL;

		// ����� ������� �� �������� ������� �������?
//	 	if (  Target_Reciver_Addr > int_Devices+offset )  		return FALSE;		
	 	if (  Target_Reciver_Addr > int_Devices )  		return FALSE;		

		// �������� ��� 

		txBuffer[temp++] = PACKHDR;				// ���������
		CRC =  txBuffer[temp - 1];
		
		txBuffer[temp++] = rx0len+1;            		// ����� 
        CRC+=  txBuffer[temp - 1];
        
		if ( ! Target_Reciver_Addr )
		{
		 	txBuffer[temp++] = Global_Packet;			// ��������� ����� �� ���������� (255).
		}
		else 	txBuffer[temp++] = Internal_Packet;			// ��������� ����� �� ����������. (0).
        CRC+=  txBuffer[temp - 1];

		
		for (a=0; a<rx0len-1;  a++)
		{
	        CRC+= rx0buf [b];
			txBuffer[temp++] = rx0buf 	[b++];				
		}   
		
		txBuffer[temp++] = CRC;

		// �������� �� ������ ���������������� ������. � ����� ������ ��������� ����� �� 0-
		// ������� ����������� ������  
		TWI_operation = SEND_DATA; // Set next operation        
		while (! RUN_TWI ( Target_Reciver_Addr, TWI_CMD_MASTER_WRITE,
								 txBuffer[Start_point_of_Dann_TX_TWI+1] +4 ) );
		return TRUE;					 
}

 // ����� �����  � �������� ������ � ����
u8 Searching_Port_for_Relay (void)
{
		u8 a;
		
		for (a=1; a<= int_Devices; a++)				// ���� ���� �� ������
		{
				#ifdef print
				printf ("Found PORT-%x, Device-%x\r\n", a, lAddrDevice [a]);
				#endif

		 	if (lAddrDevice [a]	== rx0addr)
		 	{
				LedRed();
				Relay_pack_from_UART_to_TWI ( a );
				return TRUE;
		 	}
		}

		return FALSE;
}
