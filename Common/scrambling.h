
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





