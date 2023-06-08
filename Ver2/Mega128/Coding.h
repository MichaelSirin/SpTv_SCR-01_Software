#include <io.h>
#include <stdio.h>
#include <Comm.h>
#include <Delay.h>   

// ����� ��� SD-Card
	#include "sd_cmd.h"
	#include <file_sys.h>   
	#include "options.h"   



// ��������� ����������
extern unsigned char int_Devices;			// ���������� ����������� ���������
extern unsigned char FILENAME[12];

extern unsigned char flagTWI	;	// ��������� ���� TWI. �����
#define 	time_is_Out			0		// �������� ������� (1-��������, 0 - �� ��������) 




#define IVCE 	0
#define IVSEL 1                    

// ������ ����������
#define CRST 		PORTA.2     //����� ������ ���������
#define testpin			PORTB.7	// �������� ��� (17 �����)	
#define LedRed() {DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 0, PORTA.1 = 1;}
#define LedGreen() {DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 1, PORTA.1 = 0;}
#define LedOff() {DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 1, PORTA.1 = 1;}

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
  
// ������ ������ � CF Flash
#define PT_Fcreate		1
#define PT_Fopen			2	// ������� ����
#define PT_Fclose        	3
#define PT_Fremove     	4
#define PT_Frename     5
#define PT_Ffseek        6
#define PT_Fformat       7 
#define PT_Fadd			8		//�������� ������ � ����� �����

// ������, ������������ ������ CD
#define GetLogAddr	1				// ���� ���������� �����
#define OP					100		// ������ ��� �������
#define pingPacket		2			// ������� ����������� �� ������� ���������� �� ��������

extern unsigned char rx0buf[];
extern unsigned char rx0addr;
// ���������� ��� CF Card
extern unsigned char _FF_FULL_PATH[_FF_PATH_LENGTH];     
extern unsigned char tx1crc;


typedef struct 				// ��������� ��������� ������ ��� �������� ����� �����
{
	char Ptype;               // ��� ��������� ������
	char fname[13];        // ��� �����
} strInPack; 

typedef struct 				// ��������� ��������� ������ ��� �������� ����� �����
{
	char Ptype;               // ��� ��������� ������
	char dataFlash[28];        // ��� �����
} strDataPack; 


void StartReply(unsigned char dlen);
void putchar0(char byt);
void EndReply(void);
void putword0(unsigned short wd); 
void RelayPack(void);
void CommInit(void);         					 //��������� UART
void twi_init (void);          						 //��������� I2C 
unsigned char twi_start (void);
void twi_stop (void);
unsigned char twi_addr (unsigned char addr);
unsigned char twi_byte (unsigned char data);
void StartIntReq(unsigned char dlen);
void EndIntReq(void);                
unsigned char HaveInternalReply(void);  
void verIntDev (void);   
void timer_0_Init  (void);
void timeOut (void);              
void timeOutStop (void);    
void ReadLogAddr (void);    
void portInit (void);   
unsigned char rxCRC (void);
void		recompPack (unsigned char device);      
void pingPack (unsigned char device);
unsigned char HaveIncomingPack(void);
unsigned char IncomingPackType(void);
void DiscardIncomingPack(void);              
// �������� � CF Card
unsigned char initialize_media(void);
void display_demo_commands(void);
void flash_Work (void);     
void fprintf(FILE *rp, unsigned char flash *pstr, ...);

                                    



