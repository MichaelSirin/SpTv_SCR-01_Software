#include <io.h>
#include <Comm.h>
#include <Delay.h>
#include <Scrambling.h>
#include <TWI_slave.h>

#define TOV1   2


//#define	Len_Packet	txBufferTWI[Start_Position_for_Reply]	 // 

#define LedOn()        {DDRC.0 = 1,PORTC.0=0;};
#define LedOff()       {DDRC.0 = 1,PORTC.0=1;};    
      
// ���� ������ ������������������
#define RX_HDR	 1		// �������� ���� - ���������
#define RX_LEN   2		// �������� ���� - �����
#define RX_ADDR  3		// �������� ���� - �����
#define RX_TYPE  4		// �������� ���� - ��� ������
#define RX_DATA  5		// �������� ���� - ���� ������
#define RX_CRC   6		// �������� ���� - CRC
#define RX_OK    7		// ����� ������� ������ � ��������� ���
#define RX_TIME  8		// �� ����� ������ ��������� ����-���
#define RX_ERR   9		// ������ CRC ������
#define RX_IDLE 10		// ���������� ����� ��������

#define MY_TWI_ADDRESS		1
//extern unsigned char pAddr;				//���������� ����� ���������� � TWI 

//extern unsigned char rx0buf[];
//extern unsigned char pcrc;	// ����������� ����� 

// ������, ������������ ������ CD
//#define startPing				0xAA			// ������� ����� ��� ������ ���������� ���������   
//#define startPack			'q'					// ������� ������ ������

//    #define IVCREG GICR
//	#define IVCE   0
//	#define IVSEL  1



void Initialization_Device (void);
inline unsigned char ReceiveChar(void);         
unsigned short GetWordBuff(unsigned char a);
