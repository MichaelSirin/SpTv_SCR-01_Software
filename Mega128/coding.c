/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ����������� ��������� 
//  ����������� ���������� ���� �������� � ����� ���������.

#include "Coding.h"

#ifdef print
const flash unsigned long update_program_ser_num = 0;			// ����� ����������, � ���. �������� ��������
#else 
const flash unsigned long update_program_ser_num = 9;			// ����� ����������, � ���. �������� ��������
#endif

flash u8 device_name[32] =	"Scrambling Device";       	// ��� ����������                                                  
const flash unsigned short my_version = 0x0209;			// ������ ����� 
eeprom unsigned char my_addr = TO_MON;					// ��� ����� - ���������� TO_MON
eeprom unsigned long my_ser_num = 0;				// �������� ����� ����������


eeprom u8 f_buff_prog[len_prog_bin] = {0x01,0xff,0x7f};		// ������ ����� ����� prog (+1 �.�. ����� ��� 1-� ����)
u8	eeprom *eefprog = 0;

u8 txBuffer 			[TWI_BUFFER_SIZE];			//����� ����������� TWI
u8 buff_wyh_paket	[TWI_BUFFER_SIZE];			//����� ��� ��������� ��������� ������
u8 rxBuffer 			[TWI_BUFFER_SIZE / 2];		//����� ��������� TWI


flash u8 int_Devices		=	8;	//8			// ���������� ����������� ���������
u8 lAddrDevice	[16];				// ������ ���. ������ ������������ ���������
											// 0 ������ - ���-�� ������ 232 .1 ������ �������� ���. ����� ����� 1, 2-���.
											// ����� ����� 2 � �. �.  

u8 counter_ciklov = 0;
u8 Combine_Responce_GEN_CALL = 0;	// �������� ������ ��� GEN CALL
u8 reflection_active_PORTS	=	0;			// ������� ������ (1-�������, 0 - �� �������)

bit EndTimePack = 0;				// ������� �������� ������� ��������
bit intScremblerON	=	0;			// �������� ���������� ���������
bit CF_card_INI_OK	=	0;			// ������� ������ ��������������������� CF �����
bit prog_bin_mode		=	0;			// ����� ��������� prog.bin ����� 0-rd_file; 1-wr_file


strInPack * str = (strInPack *)(rx0buf);
strDataPack * str1 = (strDataPack *)(rx0buf);

// ��������� ��� CRYPT
//FILE * fu;				//����������� ���������� ��� ��������� �������� ����� s userami
FILE * fprog;			//����������� ���������� ��� ��������� �������� ����� s programmami
FILE * fprogflas;


#ifdef print_from_pin
#define _ALTERNATE_PUTCHAR_
void putchar(char c)
{
	putchar2 (c);
}               
#endif






typedef struct _chip_port
{
	flash char name[16];
	flash unsigned char addr;
} CHIPPORT;

CHIPPORT cp[] = {"Port  RS-232 �", 0};

// ��� ��� ������ � TWI
TWISR TWI_statusReg;   
unsigned char  TWI_operation=0;

//unsigned char TWI_targetSlaveAddress;

//-----------------------------------------------------------------------------------------------------------------
// ��������� ��������� ����������
static void GetState(void)
{
	register unsigned char i, n, b;
	
	#define strq  ((RQ_GETSTATE *)rx0buf)

	switch(strq->page)
	{
	case 0:
		StartReply(2 + 16 + 1);

		putchar0(2);               						 // ����� ��������� �������, ������� ���
		putchar0(0);										// ��������������
		

			for (i = 0; i < 15; i ++)
			{
				b = cp[0].name[i];
				if (!b)	break;
				putchar0(b);
			}
				

			while(i < 15)
			{
				putchar0(' ');
				i++;
			}
			
			putchar0(cp[n].addr);
		
		putchar0(255);

		EndReply();
		return;

	case 1:
	
		StartReply(3 * int_Devices + 1);
		
		for (n = 0; n < int_Devices; n++)
		{
			putchar0(0);
			putchar0( n+1 );
#pragma warn-
			putchar0((u8)lAddrDevice [n+1]);
#pragma warn+
		}

		putchar0(255);

		EndReply();
		return;
	}
}

//-----------------------------------------------------------------------------------------------------------------
// ���������� �� ����������
static void GetInfo(void)
{
	register unsigned char i;
	
	// 	������� �������� ������
	StartReply(40);
	
	for (i = 0; i < 32; i ++)	// ��� ����������
	{
		putchar0(device_name[i]);
	}

	putword0(my_ser_num);		// �������� �����
	putword0(my_ser_num >> 16);	
	
	putchar0(my_addr);			// ����� ����������

	putchar0(0);				// ����������������� ����
	
	putword0(my_version);		// ������
	
	EndReply();					// �������� �����
}

//-----------------------------------------------------------------------------------------------------------------
// ����� ������ ����������
static void SetAddr(void)
{
	#define sap ((RQ_SETADDR *)rx0buf)
	
	my_addr = sap->addr;
	
	StartReply(1);
	putchar0(RES_OK);
	EndReply();
}

//-----------------------------------------------------------------------------------------------------------------
// ���������� ��������� ������ ����������
static void SetSerial(void)
{
	#define ssp ((RQ_SETSERIAL *)rx0buf)
	
	if (my_ser_num)
	{
		StartReply(1);
		putchar0(RES_ERR);
		EndReply();
		return;
	}
	
	my_ser_num = ssp->num;
	
	StartReply(1);
	putchar0(RES_OK);
	EndReply();
}

//-----------------------------------------------------------------------------------------------------------------
// ������������ � ����� ����������������
static void ToProg(void)
{
	// ��������� �����
	StartReply(0);
	EndReply();

	// �� ������������ � �������
	MCUCR = 1 << IVCE;
	MCUCR = 1 << IVSEL;

	#asm("jmp 0xFC00");
}

//-----------------------------------------------------------------------------------------------------------------
// ������ ���������� � �������� ���������
static void HardwareInit(void)
{         
        TWI_Master_Initialise();
		CommInit();				// �������������  COM-�����
		timer_0_Init ();			// �������������� ������ 0 (������� TWI)
		timer_2_Init ();			// �������������� ������ 2 (������� ������� ��������)
		timer_3_Init  ();			// �������������� ������ 3 (������� ������� ��������)
		portInit();					// ������ - � �������� ���������
		
		// �������
		#ifdef WD_active
		WDTCR=0x1F;
		WDTCR=0x0F;   
		#endif           

        
}

//-----------------------------------------------------------------------------------------------------------------
// ����� ���������
void ResetPeripherial(void)
{
		DDRA.2 = 1;		// RESET ����������� �����������
        CRST = 0;
        delay_ms(10);
        CRST = 1;
		DDRA.2 = 0;
}

//-----------------------------------------------------------------------------------------------------------------
// ����� ����� � ���������
void main(void)
{

u8 TWI_targetSlaveAddress, a,counter_Responce = 0;

  TWI_targetSlaveAddress   = 0x10;


//	���� ���������� ���������� ������ ��������� - �������. �� ��������� - �������.

    LedRed();               
	HardwareInit();				// ������ ����������

	#asm("sei")

	ResetPeripherial();		// ��������� ��������� 
	delay_ms (3000);					// ���� ����� ���������� �����

	// ���������� TWI	
    txBuffer[0] = (TWI_GEN_CALL<< TWI_ADR_BITS) | (FALSE<<TWI_READ_BIT);
	txBuffer[1] = TWI_CMD_MASTER_READ;             // The first byte is used for commands.
	TWI_Start_Transceiver_With_Data( txBuffer, 2 );

	UCSR0B.3 = 1;		 				// �������� ���������� UART

	#ifdef print
	printf ("Start program \r\n");
	#endif

	if (my_ser_num == update_program_ser_num)
	{
		// �������� � ���������...
		#ifdef print
		printf ("Scrambling ON! \r\n");
		#endif
		if (initialize_media())							// ������������� CF Card   
		{

//format_CF();
				CF_card_INI_OK = 1;
				#ifdef print
				printf ("Ini CF - OK! \r\n");
				#endif

				open_user_bin (rd_file);  // ��������� �� ������ (prog.bin)
				 
		}
		else
		{
		 		#ifdef print
				printf ("Ini CF - Error! \r\n");
				#endif
		}
	}

	for (a=1; a<= int_Devices; a++)	     		   		// ������������ �����
	{
		unlock_Pack(a);
	}
// ---------------------------------------------------------------------------------------------------------------------
while (1)
{
	#asm("wdr");					// 	����� WD

	LedGreen(); 

		//					-------------------		TWI	---------------------
//	for (a=1+offset; a<= int_Devices+offset; a++)	     		   			// ���������� � ���� ��� ����
	for (a=1; a<= int_Devices; a++)	     		   			// ���������� � ���� ��� ����
	{
		// ����������� ���������� - c ������ 0�01
		 if ( pingPack (a) )
		 { 
 			if ( Incoming_Pack_TWI == Internal_Packet )
		 	{
				switch (Incoming_Inernal_Information_TWI)
				{
					case GetLogAddr:            						// ������ ���. �����
						check_incoming_LOG_ADDR (a);
						break;

					case Responce_GEN_CALL:				// ������ ������������� GEN CALL
						Combine_Responce_GEN_CALL |=  ( rxBuffer[5] & 1 ) <<  ( a - 1);    
						counter_Responce &= (1 <<  ( a - 1)) ^-1;

						if (counter_Responce == 0 )
						{
								if ( Combine_Responce_GEN_CALL != reflection_active_PORTS )
										Reply (FALSE);		// ������ ��������
								else 	Reply (TRUE);															// �������� �������
								
//								EndTimePack = TRUE;		// ��������� ���������
						}                                  
						break;

					case Responce_GEN_CALL_internal:			// ������ ��� �����. ����������
						#ifdef print
						printf ("Resp Int Scremb \r\n");
						#endif

						Combine_Responce_GEN_CALL |=  ( rxBuffer[5] & 1 ) <<  ( a - 1);    
						counter_Responce &= (1 <<  ( a - 1)) ^-1;

						if (counter_Responce == 0 )
						{
						#ifdef print
						printf ("Resp OK! Scremb ON! \r\n");
						#endif
							EndTimePack = TRUE;		// ��������� ���������
						}

						break;

						
					default:	
						break;
				}		
		 	}
		 	else 	// ����� ��� ������������
			{
				#ifdef print
				printf ("Relay TWI_UART \r\n");
				#endif

				Transmitt_from_TWI_to_UART ( &rxBuffer[3] );
			}
		 }
		 else // ��� �������� ���������� �� �����. ������
		 {           
		 
		 }
	 }

			 

		// �������� ����� ---------------		UART		-----------------------
		if (HaveIncomingPack())
		{
			scrambOff();							// ��� ��������� ������ ��������� ��������� �� 8���

			if ((rx0addr == my_addr) || (rx0addr == TO_ALL))				// ����� ��� 
			{
				#ifdef print
				printf ("Have Incoming Pack \r\n");
				#endif

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

					// ������������ ������ � TWI ��� MY_ADDR ��� 255. �������� -  �����������
					// ���������� (������ ����).
					case PT_RELAY:           			

//						    if ( ! ( Relay_pack_from_UART_to_TWI_Internal (rx0buf [0]+offset) ) )	Reply (FALSE);					//������
						    if ( ! ( Relay_pack_from_UART_to_TWI_Internal (rx0buf [0]) ) )	Reply (FALSE);					//������
							#ifdef print
							printf ("Relay to Internal PT_RELAY \r\n");
							#endif
							Combine_Responce_GEN_CALL = 0;	// ����� ��������� ������ �������������
							counter_Responce = reflection_active_PORTS;

							DiscardIncomingPack();        // ��������� ��������� ����. �����
        	   				break;

					case PT_CF_CARD:						// ������ ��� ������ � CF Flash
							flash_Work();

							DiscardIncomingPack();
           					break;

					case PT_SCRCTL:
					case PT_SCRDATA:    
				#ifdef print
				printf ("Relay to Internal PT_SCRCTR or PT_SCRDATA\r\n");
				#endif
							Relay_pack_from_UART_to_TWI(Internal_Packet);
							Combine_Responce_GEN_CALL = 0;	// ����� ��������� ������ �������������
							counter_Responce = reflection_active_PORTS;

							DiscardIncomingPack();
           					break;

           					
					case PT_DESCRUPD:    
				#ifdef print
				printf ("Relay to Internal PT_DESCRUPD\r\n");
				#endif
                        ModifyKey ();									// ��������� ������� ����
						Relay_pack_from_UART_to_TWI(Internal_Packet);

							Combine_Responce_GEN_CALL = 0;	// ����� ��������� ������ �������������
							counter_Responce = reflection_active_PORTS;

							DiscardIncomingPack();
           					break;    
                			
					default:
							DiscardIncomingPack();
							break;
				}
		    }
		   	else																// �������������
			{                                                                     
				#ifdef print
				printf ("Relay Pack \r\n");
				#endif


		        if ( ! Searching_Port_for_Relay () ) 
		        {
					#ifdef print
					printf ("port for Relay Pack not FOUND!\r\n");
					printf ("Incoming PORT-%x!\r\n",rx0addr);
					#endif
		        	Reply (FALSE);		// �������� ������
	    	    }
				DiscardIncomingPack();        // ��������� ��������� ����. �����
			}
		}
		

		//					-------------------		Scrambler	---------------------
		// ���� ����� ��������������������� - ��������� ���������������
		
		if (CF_card_INI_OK)				
		{
			if (EndTimePack == TRUE) 		// ������ ����������
			{
				if (reflection_active_PORTS != 0)	// ���� ��� �����. �������� - �� ������������
				{
					#ifdef print
					printf ("Scrambling... \r\n");
					#endif

					scrambling();   		// ������� ���� ������ ��� �������� � �����
					timeOutPackStart();
					LedRed(); 

					Combine_Responce_GEN_CALL = 0;	// ����� ��������� ������ �������������
					counter_Responce = reflection_active_PORTS;
				}

			}
		}	
}
}    	