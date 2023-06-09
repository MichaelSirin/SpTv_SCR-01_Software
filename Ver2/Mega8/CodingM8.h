#include <io.h>
#include <Comm.h>
#include <Delay.h>

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

extern unsigned char pAddr;				//���������� ����� ���������� � TWI 

extern unsigned char rx0buf[];
extern unsigned char pcrc;	// ����������� ����� 

// ������, ������������ ������ CD
#define startPing				0xAA			// ������� ����� ��� ������ ���������� ���������   
#define startPack			'q'					// ������� ������ ������

#define GetLogAddr	1			// ���� ���������� ����� 
#define pingPack			2			// ��� ������� �� ������� ���������� �� ��������
#define OP					100		// ������ ��� �������    

//    #define IVCREG GICR
//	#define IVCE   0
//	#define IVSEL  1



//void StartReply(unsigned char dlen);
//void putchar0(char byt);
//void EndReply(void);
void twi_init (void);           //��������� I2C 
unsigned char twi_byte (unsigned char data);
//void EndIntReq(void);
inline unsigned char ReceiveChar(void);         
void txBuff (void);  
void twi_init (void);
unsigned short GetWordBuff(unsigned char a);

//void DiscardIncomingPack(void);
//void putword0(unsigned short wd); 
//void RelayPack(void); 
//unsigned char rx_addr (void);
//void CommInit(void);            //��������� UART
//unsigned char twi_addr (unsigned char addr);
//void StartIntReq(unsigned char dlen);
//unsigned char twi_read (unsigned char * pByt, unsigned char notlast);
