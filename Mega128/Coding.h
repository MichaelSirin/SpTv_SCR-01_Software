#include <io.h>


//#include <stdio.h>

#include <Comm.h>
#include <Delay.h>  
//#include <Scrambling.h>  
#include "TWI_Master.h"

// ����� ��� SD-Card
	#include "sd_cmd.h"
	#include <file_sys.h>   
	#include "options.h"   


// �������� ���������
//#define offset	3 
	
	
// ��������� ����������   
#define max_abons		1									// ���������� ��������� ���� (max)
extern flash unsigned char int_Devices;			// ���������� ����������� ���������
extern unsigned char FILENAME[12];  



extern unsigned char flagTWI	;	// ��������� ���� TWI. �����
#define 	time_is_Out			0		// �������� ������� (1-��������, 0 - �� ��������)


// ���� ����������
#define u8		unsigned char 
#define u16	unsigned int
#define u32	unsigned long int	                  


#define IVCE 	0
#define IVSEL 	1                    

// ������ ����������
#define CRST 			PORTA.2     //����� ������ ���������
#define testpin			PORTB.7	// �������� ��� (17 �����)	
#define LedRed() 		{DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 0, PORTA.1 = 1;}
#define LedGreen() 	{DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 1, PORTA.1 = 0;}
#define LedOff() 		{DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 1, PORTA.1 = 1;}

// Global CALL for TWI
#define TWI_GEN_CALL         0x00  // The General Call address is 0

// Sample TWI transmission commands
#define TWI_CMD_MASTER_WRITE 					0x10
#define TWI_CMD_MASTER_READ  						0x20
#define TWI_CMD_MASTER_RECIVE_PACK_OK 	0x21
#define TWI_CMD_MASTER_REQUEST_CRC 		0x22

// Sample TWI transmission states, used in the main application.
#define SEND_DATA             								0x01
#define REQUEST_DATA          								0x02
#define READ_DATA_FROM_BUFFER 					0x03 
#define STOP														0x04

/*// ���� ������ ������������������
#define RX_HDR	 1		// �������� ���� - ���������
#define RX_LEN   2		// �������� ���� - �����
#define RX_ADDR  3		// �������� ���� - �����
#define RX_TYPE  4		// �������� ���� - ��� ������
#define RX_DATA  5		// �������� ���� - ���� ������
#define RX_CRC   6		// �������� ���� - CRC
#define RX_OK    7		// ����� ������� ������ � ��������� ���
#define RX_TIME  8		// �� ����� ������ ��������� ����-���
#define RX_ERR   9		// ������ CRC ������
#define RX_IDLE 10		// ���������� ����� ��������     */
  
// ������ ������ � CF Flash
#define PT_Fcreate		1
#define PT_Fopen			2	// ������� ����
#define PT_Fclose        	3
#define PT_Fremove     	4
#define PT_Frename     5
#define PT_Ffseek        6
#define PT_Fformat       7 
#define PT_Fadd			8		//�������� ������ � ����� �����

// ������� ��������� ���������
#define Device_ERROR								0	// ������ ���������� TWI
#define Device_OK									1	// ������ ���
#define Logik_Address_not_Found				2	// �� ������� ���������� � ���. �������
#define Wait_Responce_After_GEN_CALL	3	//���� ������� ����� ����. ���������

// ������, ������������ ������ CD
#define Incoming_Pack_TWI							rxBuffer[2] 	// ��� ��������� ������ TWI
#define Incoming_Inernal_Information_TWI 	rxBuffer[4]		// ��� ����������� ������
#define Start_point_of_Dann_TX_TWI  						2		// ������ ������������ ������������ ������


#define GetLogAddr						1	// ���� ���������� ����� 
#define pingPacket						2	// ������� ����������� �� ������� ���������� �� ��������
#define Responce_GEN_CALL		3	// ����� �� GEN CALL  
#define Responce_GEN_CALL_internal	4	// ������ ��� �����. ����������


#define Internal_Packet			0x00			// ������ ����������� �����������
#define External_Packet			0x01			// ������ ���������������
#define Global_Packet			0xFF			// ���������� �����



// ��� ���������� ��������
#define lbuff 				236			// ����� ������ ������������� ������  
#define len_prog_bin	124			// 125 ����� ������ ��� ������        

#define buff_kazakovu (&txBuffer[Start_point_of_Dann_TX_TWI + 4])


#define conf3 0xb8	//konfiguracija gen sh 3 for kazakov
#define conf4 0x500	//konfiguracija gen sh 4
#define conf5 0x740	//konfiguracija gen sh 5
#define conf6 0xc3	//konfiguracija gen sh 6
#define conf7 0x751	//konfiguracija gen sh 7

		// ��������� ����������
#define startScremb				0		// ������������� ����������
#define TX_g_p_razresh		1		// �������� ������ �������� ���������
#define TX_g_p_flash			2		// �������� ���������� �� ����
#define TX_g_p_obnovlenie	3		// �������� ���������� �� ������
#define TX_g_p_ciklovogo		4		// �������� ����� " ����� �����"
#define TX_men_ver_kl			5		// ������ ������ �����
#define TX_g_p_koderu			6		// �������� ����� ������
#define TX_g_p_kluchi			7		// ������ ������ ������	
#define TX_g_p_flagov			8		// ������� �����

	// ��������� ������
#define Ready						0		// ��������� ��������
#define TX_Pack_Scremb		1		// ������� ����� ���������������


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


//comm.c
void putchar0(char byt);
void StartReply(unsigned char dlen);
void EndReply(void);
void Reply(u8 status);
unsigned char HaveIncomingPack(void);
unsigned char IncomingPackType(void);
void DiscardIncomingPack(void);              
void CommInit(void);         					 //��������� UART
void putword0(unsigned short wd); 
void putchar2(char c);
void	Transmitt_from_TWI_to_UART (unsigned char *Transmitting_Bytes);
void  Scramb_Responce ( void);


//twi_funct.c

unsigned char pingPack (unsigned char TWI_targetSlaveAddress);
void	Relay_pack_from_UART_to_TWI (unsigned char TWI_targetSlaveAddress);  
unsigned char	Relay_pack_from_UART_to_TWI_Internal (u8 Target_Reciver_Addr);
u8 Searching_Port_for_Relay (void);  
u8 RUN_TWI (u8 TWI_targetSlaveAddress, u8 TWI_sendCommand,	u8 Count_Bytes );
void unlock_Pack (u8 TWI_targetSlaveAddress);



//cd128funct.c
void check_incoming_LOG_ADDR (u8 checking_Device);
 unsigned char Logic_Address_Identical (unsigned char Logik_Address, unsigned char device);
void ModifyKey (void);



void RelayPack(void);
void twi_init (void);          						 //��������� I2C 
void EndIntReq(void);                
unsigned char HaveInternalReply(void);  
void verIntDev (void);   
void timer_0_Init  (void); 
void timer_2_Init  (void);
void timer_3_Init  (void);
void timeOut (void);              
void timeOutStop (void);    
void portInit (void);   
void	recompPack (unsigned char device);      
//unsigned char Logic_Address_Identical (unsigned char Logik_Address, unsigned char device);


// ���� flashcard.c
#define rd_file	0
#define wr_file	1
#define dann_1_abon	132//4+124+4		// ���������� ����� ������ �������� (���+����+����)

unsigned char initialize_media(void);
void display_demo_commands(void);
void flash_Work (void);     
unsigned char scrambling (void);
void gshum7(void);
//unsigned char txTWIbuff (unsigned char pAddr);
void createPack (void);
unsigned char openBase (void); 
void g_p_koderu (void); 
void	scrambOff (void);  
u8 format_CF (void);
u8 open_user_bin (u8 mode);
u8 read_abons (u32 MACabons);
//u8 read_abons (void);



void ini_kluchej(void); 
void g_kod(void);	//��������� ������
void men_ver_kl(void);	//������������ ������ ������
void g_p_kluchi(void)	;
void g_p_razresh(void);	
void g_p_ciklovogo(void);
void g_p_flagov(void);
void g_p_progf(void)	; 

void reciveFiles (void);
    


void timeOutPackStart (void);


void fprintf(FILE *rp, unsigned char flash *pstr, ...);

//crypt.c
extern int ver_kl;    
extern u32 getAbons (void);


                                    



