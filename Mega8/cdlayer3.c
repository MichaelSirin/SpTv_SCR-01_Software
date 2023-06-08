#include "CDdef.h"  

flash unsigned char device_name[32] =					// Имя устройства
		"Main Program. Mega 8L ";
eeprom unsigned long my_ser_num = 1;					// Серийный номер устройства
const flash unsigned short my_version_high = 1;				// Версия софта 
const flash unsigned short my_version_low = 2;				// Версия софта 
//eeprom unsigned char my_addr = TO_MON;					// Мой адрес - изначально TO_MON

//-----------------------------------------------------------------------------------------------------------------

// ----------------------- Обработка прерывания таймера 0 (тайм-аут RS232) --------
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
	TCCR0=0x00;										// Останавливаем таймер
}
//--------------------------------------------------------------------------------------

// Посылаем запрос адреса устройства
 void give_GETINFO (void)
{
	// 	запрос  типа устройства
			putchar ('q');						// заголовок
			putchar (3);							// число байт после этого
			putchar (255);		 				//  адрес (циркулярный)
			putchar (PT_GETINFO);		// тип пакета
			putchar ((PT_GETINFO)+(255)+3+('q'));
			
			CountUART = 0;				// ожидаем ответный пакет  

}

// ----------------------- Обработка прерывания таймера 1 ( опрос подключения каждые 8 с) --------
// Timer 1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
		if (! (Device_Connected) )
		{
			lAddr = 0;						// ничего не подключено             
			_GetLogAddr ();				// cообщаем свой логический адрес
		}

		Device_Connected = 0;						// пора проверить устройство присутствует ли ?           

		give_GETINFO();		// отправляем посылку запроса
#ifdef aaa
    putchar (0xac);
	putchar (TWDR);
	putchar (TWSR);
#endif    

}

// отправляем ответ на GEN CALL
void	Responce_OK (u8 Status)
{    

		Long_TX_Packet_TWI = 2;				 		// длина пакета

				Command_TX_Packet_TWI = Responce_GEN_CALL_internal;	

	// ответ не пришел
	if ( Status == FALSE )
	{
		Packet_Lost ++;								// потеряли пакет
		txBufferTWI[Start_Position_for_Reply+2] = FALSE;		  				// содержимое
	}
	// ответ пришел
	else
		txBufferTWI[Start_Position_for_Reply+2] = rxBufferUART[1];		// содержимое

		packPacket (Internal_Packet);	// даем тип ВНУТРЕННИЙ
}

// Ждем ответа при глоб. адресации. Работает с таймером 2.
void Wait_Responce ( unsigned char Status )
{
			Count_For_Timer2 = 0;                                  

			TCNT2=0x00;			
			if ( Status == START_Timer )
			{
			 	Responce_Time_Out = 0;								
			 	TCCR2=0x07;       // пуск
			}
			else 		
				TCCR2=0x00;       // стоп

}
// ----------------------- Обработка прерывания таймера 2 ------------------------
// Ждем подтверждение передачи пакета кодирования ( ожидание ответа устройства - 200мс)
// Timer 2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
		Count_For_Timer2 ++;

		if (Count_For_Timer2 > 4 )
		{
			Responce_Time_Out = 1;				// время ожидания ответного пакета истекло
			Wait_Responce ( STOP_Timer );				// стоп
		}                                   
}


//-----------------------------------------------------------------------------------------------------------------
// Реакция на команду перейти в рабочий режим
void ToWorkMode(void)
{
	// Отправляю ответ
	Long_TX_Packet_TWI = 1;        						// подтверждаю прием
	txBufferTWI[Start_Position_for_Reply+1] = 1;        						// подтверждаю прием

	packPacket (External_Packet);	// даем тип ВНЕШНИЙ
}
// Назначение серийного номера устройства
static void SetSerial(void)
{
		Long_TX_Packet_TWI = 2;  			//длина
		txBufferTWI[Start_Position_for_Reply+1] = (RES_OK);		
		txBufferTWI[Start_Position_for_Reply+2] = 2+(RES_OK);          // КС

		packPacket (External_Packet);	// даем тип ВНЕШНИЙ
}

//  Назначение адреса устройства
void Setaddr (void)
	{
			Long_TX_Packet_TWI = 2;  			//длина
			txBufferTWI[Start_Position_for_Reply+1] = 0;		
			txBufferTWI[Start_Position_for_Reply+2] = 2;          // КС

			packPacket (External_Packet);	// даем тип ВНЕШНИЙ
	}

// Перезагрузка в режим программирования
static void ToProg(void)
{
			// Отправляю ответ
			Long_TX_Packet_TWI = 1;  			//длина
			txBufferTWI[Start_Position_for_Reply+1] = 1;          // КС
		
			packPacket (External_Packet);	// даем тип ВНЕШНИЙ
			to_Reboot = 1;			//  на перезагрузку в загрузчик
}		


// Возвращаю состояние устройства
const char _PT_GETSTATE_[]={67,2,0,"Connected Dev.",100,"RelayTWI->UART",100,
														"RelayUART->TWI",100,"Packet LOST   ",100,255};

static void GetState(void)
{
	register unsigned char a=Start_Position_for_Reply;

	switch (PT_GETSTATE_page)
	{
		case 0:
			memcpyf(&txBufferTWI[Start_Position_for_Reply], _PT_GETSTATE_, _PT_GETSTATE_[0]+1); // 0 пакет
			break;

		case 1:			
			txBufferTWI[a++] = 14;				 			// длина пакета

			txBufferTWI[a++] = 0;							// № микросхемы
			txBufferTWI[a++] = TWI_slaveAddress;
			txBufferTWI[a++] = lAddr;

			txBufferTWI[a++] = 1;							// № микросхемы
			txBufferTWI[a++] = TWI_slaveAddress;
			txBufferTWI[a++] =  Relay_Pack_TWI_UART;

			txBufferTWI[a++] = 2;							// № микросхемы
			txBufferTWI[a++] = TWI_slaveAddress;
			txBufferTWI[a++] =  Relay_Pack_UART_TWI;

			txBufferTWI[a++] = 3;							// № микросхемы
			txBufferTWI[a++] = TWI_slaveAddress;
			txBufferTWI[a++] =  Packet_Lost;

			txBufferTWI[a++] = 255;
			break;

		default:
			txBufferTWI[a++] = 0;				 			// длина пакета
			break;
	} 

	//KC
	txBufferTWI[txBufferTWI[Start_Position_for_Reply]+2] = calc_CRC( &txBufferTWI[Start_Position_for_Reply] );

	packPacket (External_Packet);	// даем тип ВНЕШНИЙ
} 

// Информация об устройстве:

static void GetInfo(void)
{
		register unsigned char i,a=Start_Position_for_Reply;                    
	
		// 	заполняю буфер
		txBufferTWI[a++] = 40+1;
	
		for ( i = 0; i <32; i ++ )	
				txBufferTWI[a++] = device_name[i];	// Имя устройства

		txBufferTWI[a++] = my_ser_num;         	 	// Серийный номер
		txBufferTWI[a++] = my_ser_num>>8;    	  	// Серийный номер

		txBufferTWI[a++] = my_ser_num>>16;		// Серийный номер
		txBufferTWI[a++] = my_ser_num>>24;		// Серийный номер
	
		txBufferTWI[a++] =TWI_slaveAddress ;    	// Адрес устройства
        txBufferTWI[a++] =0;     							// Зарезервированный байт
	
		txBufferTWI[a++] = my_version_high;			// Версия софта
		txBufferTWI[a++] = my_version_low;			// Версия  софта
		
		//KC
		txBufferTWI[txBufferTWI[Start_Position_for_Reply]+2] = calc_CRC( &txBufferTWI[Start_Position_for_Reply] );
		packPacket (External_Packet);					// даем тип ВНЕШНИЙ
}


// Отвечаем. Заполняем буфер на передачу
void _GetLogAddr (void)
{

		Long_TX_Packet_TWI = 2;				 					// длина пакета
		txBufferTWI[Start_Position_for_Reply+1] = GetLogAddr;		 				// тип пакета
		txBufferTWI[Start_Position_for_Reply+2] = lAddr;		  						// содержимое

		packPacket (Internal_Packet);					// даем тип ВНУТРЕННИЙ
}  
	
// ретрансляция из TWI в UART
void relayTWI_to_UART (void)
{       
		u8 a;
		
		if ( Device_Connected )
		{
			Wait_Responce ( START_Timer );  

			for ( a = 1;a<= Long_RX_Packet_TWI+2; a++ )	
					putchar ( rxBufferTWI[a] ); 

			Relay_Pack_TWI_UART++;			//счетчик статистики
			LedOn ();										// отправили пакет	
			gate_UART_to_TWI_open = TRUE;	// открываем обратную ретрансляцию		
		}

}

// Включаем-выключаем UART
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


// Обрабатываем принятый пакет TWI
void workINpack ( void )
		{

		// Обработка внутренних пакетов
		if ( Recived_Address == Internal_Packet )		
		{
				#ifdef DEBUG
				putchar2 (0x04);
				#endif
			switch ( Type_RX_Packet_TWI )
			{
				case PT_GETINFO:			// возвращаем о себе информацию
						GetInfo();
						break;                                     
						
				case PT_GETSTATE:				// возвращаем состояние
						GetState();
						break;

		 		case PT_TOPROG:       			// переходим в программирование
						ToProg();
						break;      

		 		case PT_PORT_UNLOCK:      // разрешаем UART
						port_state(TRUE);
						break;

		 		case PT_SCRDATA:       		// пакет внутреннего скремблера
						Recived_Address = 255;			//меняем адрес и КС
						CRC_RX_Packet_TWI = calc_CRC( &Long_RX_Packet_TWI )+Heading_RX_Packet;

						InternalPack = TRUE;
						relayTWI_to_UART ();
						break;

				default:
						break;

			}
         }
	    else	if( Recived_Address == TO_MON)					// обрабатываем пакет по адресу MONITOR
		{
			switch ( Type_RX_Packet_TWI )
			{
		 		case PT_SETADDR:       			// переходим в программирование
						Setaddr();
						break;      

		 		case PT_SETSERIAL:       			// переходим в программирование
						SetSerial();
						break; 

		 		case PT_TOWORK:       			// переходим в программирование
						ToWorkMode();
						break;


				default: 
						break;
									     
			}                                                                               
		}
		// иначе ретранслируем
		// только при подключенном устройстве и разблок. порт
		else
		{ 													
				relayTWI_to_UART ();
		}
}	

// Обработка пакета, принятого по UART        
// Принятый пакет упаковывается во внешний:
//    ДЛИНА_ТИП_ПРИНЯТЫЙ ПАКЕТ_КС(включая ДЛИНА)

void workUARTpack (void)
{
	if (! Device_Connected ) 						// получен первый пакет           
	{
		lAddr = rxBufferUART [37];			// вынимаем адрес из принятого пакта             
		_GetLogAddr ();							// cообщаем свой логический адрес
		Device_Connected = 1;				// Устройство ответило 
		LedOff();									// тушим индикатор проблем

	}
	else
	{
			#ifdef DEBUG
			putchar2 (0x01);
			#endif

		if (gate_UART_to_TWI_open == TRUE)
		{
			Wait_Responce ( STOP_Timer );  	// останавливаем таймер

			if (InternalPack == TRUE)
			{
				#ifdef DEBUG
				putchar2 (0x02);
				#endif
				Responce_OK ( TRUE );					// отправляем ответ
			}				
			else
			{
				#ifdef DEBUG
				putchar2 (0x03);
				#endif
					memcpy(&txBufferTWI[Start_Position_for_Reply], rxBufferUART, rxBufferUART[0]+1); 	// пакет принятый
					packPacket (External_Packet);		// даем тип ВНЕШНИЙ
			}

			InternalPack = FALSE;
			Relay_Pack_UART_TWI++;			//счетчик статистики						
		}
	}
}	
	

	//--------------------------------------------------------------------------------------------
// "программный" UART
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
	