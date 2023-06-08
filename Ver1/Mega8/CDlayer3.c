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
		

