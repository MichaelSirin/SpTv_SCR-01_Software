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
		

