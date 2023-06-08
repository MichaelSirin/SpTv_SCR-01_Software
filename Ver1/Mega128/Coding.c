/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ����������� ��������� ������

#include "Coding.h"

flash unsigned char device_name[32] =					// ��� ����������
		"Port Device v1.0";
eeprom unsigned long my_ser_num = 0;					// �������� ����� ����������
const flash unsigned short my_version = 0x0100;			// ������ ����� 
eeprom unsigned char my_addr = TO_MON;					// ��� ����� - ���������� TO_MON

unsigned char txBuffer [256];		//������ �����������
unsigned char rxBuffer [256];		//���� ���������
unsigned char lAddrDevice	[64];	// ������ ���. ������ ������������ ���������
															// 0 ������ - ���-�� ������ 232 .1 ������ �������� ���. ����� ����� 1, 2-���.
															// ����� ����� 2 � �. �.
// ���������� ��� ������ � CF Card
/*
typedef struct 				// ��������� ��������� ������ ��� �������� ����� �����
{
	char Ptype;               // ��� ��������� ������
	char fname[13];        // ��� �����
} strInPack; */

strInPack * str = (strInPack *)(rx0buf);
strDataPack * str1 = (strDataPack *)(rx0buf);

FILE *pntr1; 


typedef struct _chip_port
{
	flash char name[16];
	flash unsigned char addr;
} CHIPPORT;

CHIPPORT cp[] = {
	{"���� 1", 1},
	{"���� 2", 2},
	{"���� 3", 3},
	{"���� 4", 4}
};

//-----------------------------------------------------------------------------------------------------------------
// ��������� ��������� ����������
static void GetState(void)
{
	register unsigned char i, n, b;
	
	#define strq  ((RQ_GETSTATE *)rx0buf)

	switch(strq->page)
	{
	case 0:
		StartReply(2 + 16*(sizeof(cp) / sizeof(CHIPPORT)) + 1);

		putchar0(2);               						 // ����� ��������� �������, ������� ���
		putchar0(0);										// ��������������
		
		for (n = 0; n < (sizeof(cp) / sizeof(CHIPPORT)); n ++)
		{
			for (i = 0; i < 15; i ++)
			{
				b = cp[n].name[i];
				if (!b)
				{
					break;
				}
				putchar0(b);
			}
			while(i < 15)
			{
				putchar0(' ');
				i++;
			}
			
			putchar0(cp[n].addr);
		}
		
		putchar0(255);

		EndReply();
		return;

	case 1:
	
		StartReply(3 * (sizeof(cp) / sizeof(CHIPPORT)) + 1);
		
		for (n = 0; n < (sizeof(cp) / sizeof(CHIPPORT)); n++)
		{
			putchar0(n);
			putchar0(cp[n].addr);
			putchar0(lAddrDevice [cp[n].addr]);
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
        twi_init ();      
		CommInit();				// �������������  COM-�����
		timer_0_Init ();			// �������������� ������ 0 (�������)
		portInit();					// ������ - � �������� ���������
        
}

//-----------------------------------------------------------------------------------------------------------------
// ����� ���������
void ResetPeripherial(void)
{
        CRST = 0;
        delay_ms(10);
        CRST = 1;
        delay_ms(500);     //���� ���� ���������� �����
}

//-----------------------------------------------------------------------------------------------------------------
// ����� ����� � ���������
void main(void)
{
unsigned char a;   

//	���� ���������� ���������� ������ ��������� - �������. �� ��������� - �������.

    LedRed();               
	HardwareInit();				// ������ ����������
	ResetPeripherial();		// ��������� ��������� 

	#asm("sei")

	UCSR0B.3 = 1;		 				// �������� ���������� UART
	delay_ms (3000);					// ���� ����� ���������� �����
	verIntDev();							// �������	 ���������� ����������� ��������� 

// �������� � ���������...
	while (!(initialize_media()));		// ������������� CF Card   

	while (1)
	{


		LedGreen();
		ReadLogAddr ();				// ���������� ���. ������

//		for (a=1; a<= int_Devices; a++) pingPack (a);	
	

		// ��������, ��� �� ������ � �������� ����, ���� ����
		if (HaveIncomingPack())
		{
		if ((rx0addr == my_addr) || (rx0addr == TO_ALL))				// ����� ��� 
			{
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

						case PT_RELAY:           			// ������������ ������ ��� ����������������
							    RelayPack();	
                				break;

						case PT_FLASH:								// ������ ��� ������ � CF Flash
							    flash_Work();	
                				break;
                			
						default:
								DiscardIncomingPack();
								break;
					}
		   }
		else																	// �������������
				{                                                                      
					for (a=1; a<= int_Devices; a++)				// ���� ���� �� ������
						{
						 	if (lAddrDevice [a]	== rx0addr)
						 		{
									LedRed();
									recompPack (a);		
									DiscardIncomingPack();        // ��������� ��������� ����. �����
									delay_ms (50);
									pingPack (a);	
									break;
						 		}
						}
				}
		}
	}
}    	

