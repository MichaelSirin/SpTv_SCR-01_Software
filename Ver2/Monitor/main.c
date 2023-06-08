////////////////////////////////////////////////////////////////////////////////////////////
// ������� - ��������� FLASH � EEPROM
////////////////////////////////////////////////////////////////////////////////////////////
#include "monitor.h" 
#include "CodingM8.h"      
#include "stdio.h"  
#include "string.h"  

flash unsigned char device_name[32] =					// ��� ����������
		"Boot Program. Port";
eeprom unsigned long my_ser_num = 1;					// �������� ����� ����������
const flash unsigned short my_version = 1;			// ������ ����� 
eeprom unsigned char my_addr = TO_MON;					// ��� ����� - ���������� TO_MON
    

unsigned char pAddr;				// ����� ���������� �� ���� TWI
unsigned char adr;									// ����� � ��������� ������
unsigned char typePack;							// ��� ��������� ������


//bit 		ping		 			=		0;					// ������� ��� ������ ������ ����	
bit	dannForTX			=		0;					// ���� ������ �� ��������
bit	toReboot				=		0;					// ������������� � ������� ���������
	
unsigned char txBuffer[128];								// ���������� ������
unsigned char rxBuffer[128];								// �������� ������


// ������� ���������� � �������� � ����������
void PrgInfo(void)
{
	// ��������� �����
	#asm("wdr");
	txBuffer[0] = (sizeof(RP_PRGINFO));

	#asm("wdr");
	txBuffer[1] = (PAGESIZ);     			//��.
	txBuffer[2] = (PAGESIZ>>8);          //��.

	#asm("wdr");
	txBuffer[3] = (PRGPAGES);
	txBuffer[4] = (PRGPAGES>>8);

	#asm("wdr");
	txBuffer[5] = (EEPROMSIZ);
	txBuffer[6] = (EEPROMSIZ>>8);

	#asm("wdr");
	txBuffer[7] = (MONITORVERSION);
	txBuffer[8] = (MONITORVERSION>>8);

	#asm("wdr");
	dannForTX = 1;								// ���� ������	

	// ������� � ����� ���������������� - ������ ���� ����� ����� ��������� �����
	prgmode = 1;
	
	// ������� ��������� ����������� ������������������
	ResetDescrambling();
}

// ������ � EEPROM
void WriteEeprom(void)
{
	register unsigned short addr;
	register unsigned char  data;

	// ����� ������ � ������	
	#asm ("wdr");
	addr = GetWordBuff(0);
	
	// �������� ���������� � ������������ ������
	if (addr >= EEPROMSIZ)
	{
			txBuffer[0] = 1;        				// �����
			txBuffer[1] = RES_ERR;			//  ������
			dannForTX = 1;						// ���� ������	

		return;
	}
	
	// ���� � EEPROM
	*((char eeprom *)addr) = data;
	
	// ��������, ���������� ��
	if (*((char eeprom *)addr) != data)
	{
			txBuffer[0] = 1;        				// �����
			txBuffer[1] = RES_ERR;			//  ������
			dannForTX = 1;						// ���� ������	
		return;
	}

	// �������, ��� ��� � ������� 
	#asm ("wdr");                                                        
			txBuffer[0] = 1;        				// �����
			txBuffer[1] = RES_OK;			
			dannForTX = 1;						// ���� ������	
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
	
	#asm("wdr");
	
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
	
	#asm("wdr");
	
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

//	#asm("wdr");
	#asm("rjmp 0");      //Mega128 - JMP, Mega8 - RJMP
}

// ������� �� ������� ������� � ������� �����
void ToWorkMode(void)
{

	// ��������� �����
	txBuffer[0] = 0;        						// ����������� �����
//	dannForTX = 1;								// ���� ������

	prgmode = 0;
	  
	// �� ������������
	toReboot =1;
//	RebootToWork();
}

//-----------------------------------------------------------------------------------------------------------------

// ���������� �� ����������
static void GetInfo(void)
{
	register unsigned char i;
	
	// 	�������� �����
	txBuffer[0] = 40;
	
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
	
		dannForTX = 1;								// ���� ������	

}

//-----------------------------------------------------------------------------------------------------------------

// ��������� ��������� ����������
const char _PT_GETSTATE_[]={19,0,0,'a','a','a','a','a','a','a','a','a','a','a','a','a','a',' ',100,255};
static void GetState(void)
{
		memcpyf(txBuffer, _PT_GETSTATE_, _PT_GETSTATE_[0]+1);
		dannForTX = 1;								// ���� ������	
} 


void main(void)
{
	// ���������� "������"
	HardwareInit(); 

	// ��� ��� ����� �� ��������?
	if (MCUCSR & (1 << WDRF))
	{
		MCUCSR &= (1 << WDRF) ^ 0xFF;
	
		// ���� ������� �� �������� - ������� ������������� � ������� �����	
		RebootToWork();
	}
	
	// ��������, ����� � ���������� ������
	while (1)
	{

		Wait4Hdr();						// ���� �����
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
								break;*/
						default:
								break;
					}
        	
			}
	}
}
