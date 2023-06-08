#include <io.h>


//#include <stdio.h>

#include <Comm.h>
#include <Delay.h>  
//#include <Scrambling.h>  
#include "TWI_Master.h"

// файлы для SD-Card
	#include "sd_cmd.h"
	#include <file_sys.h>   
	#include "options.h"   


// тестовые настройки
//#define offset	3 
	
	
// константы глобальные   
#define max_abons		1									// количество абонентов сети (max)
extern flash unsigned char int_Devices;			// количество подчиненных устройств
extern unsigned char FILENAME[12];  



extern unsigned char flagTWI	;	// Состояние шины TWI. Флаги
#define 	time_is_Out			0		// Сработал таймаут (1-сработал, 0 - не сработал)


// типы переменных
#define u8		unsigned char 
#define u16	unsigned int
#define u32	unsigned long int	                  


#define IVCE 	0
#define IVSEL 	1                    

// Выводы микросхемы
#define CRST 			PORTA.2     //Вывод сброса периферии
#define testpin			PORTB.7	// тестовый пин (17 вывод)	
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

/*// Фазы работы приемопередатчиков
#define RX_HDR	 1		// Принятый байт - заголовок
#define RX_LEN   2		// Принятый байт - длина
#define RX_ADDR  3		// Принятый байт - адрес
#define RX_TYPE  4		// Принятый байт - тип пакета
#define RX_DATA  5		// Принятый байт - байт данных
#define RX_CRC   6		// Принятый байт - CRC
#define RX_OK    7		// Пакет успешно принят и адресован мне
#define RX_TIME  8		// Во время приема произошел тайм-аут
#define RX_ERR   9		// Ошибка CRC приема
#define RX_IDLE 10		// Внутренний канал свободен     */
  
// Пакеты работы с CF Flash
#define PT_Fcreate		1
#define PT_Fopen			2	// открыть файл
#define PT_Fclose        	3
#define PT_Fremove     	4
#define PT_Frename     5
#define PT_Ffseek        6
#define PT_Fformat       7 
#define PT_Fadd			8		//дописать данные в конец файла

// текущее состояние Устойства
#define Device_ERROR								0	// ошибка устройства TWI
#define Device_OK									1	// ошибок нет
#define Logik_Address_not_Found				2	// не найдено устройство с лог. адресом
#define Wait_Responce_After_GEN_CALL	3	//ждем ответов после глоб. адресации

// Пакеты, используемые внутри CD
#define Incoming_Pack_TWI							rxBuffer[2] 	// Тип входящего пакета TWI
#define Incoming_Inernal_Information_TWI 	rxBuffer[4]		// тип внутреннего пакета
#define Start_point_of_Dann_TX_TWI  						2		// начало расположения передаваемых данных


#define GetLogAddr						1	// дать логический адрес 
#define pingPacket						2	// пингуем подчиненное на наличие информации на передачу
#define Responce_GEN_CALL		3	// ответ на GEN CALL  
#define Responce_GEN_CALL_internal	4	// ответы для внутр. скремблера


#define Internal_Packet			0x00			// пакеты внутреннего пользования
#define External_Packet			0x01			// пакеты ретранслируемые
#define Global_Packet			0xFF			// глобальный пакет



// Все касательно закрытия
#define lbuff 				236			// длина буфера передаваемого пакета  
#define len_prog_bin	124			// 125 длина пакета для кодера        

#define buff_kazakovu (&txBuffer[Start_point_of_Dann_TX_TWI + 4])


#define conf3 0xb8	//konfiguracija gen sh 3 for kazakov
#define conf4 0x500	//konfiguracija gen sh 4
#define conf5 0x740	//konfiguracija gen sh 5
#define conf6 0xc3	//konfiguracija gen sh 6
#define conf7 0x751	//konfiguracija gen sh 7

		// состояния скремблера
#define startScremb				0		// инициализация переменных
#define TX_g_p_razresh		1		// передаем пакеты закрытия абонентам
#define TX_g_p_flash			2		// передаем обновление ПО флеш
#define TX_g_p_obnovlenie	3		// передаем обновление ПО ЕЕПРОМ
#define TX_g_p_ciklovogo		4		// передаем пакет " Конец цикла"
#define TX_men_ver_kl			5		// меняем версию ключа
#define TX_g_p_koderu			6		// передаем пакет кодеру
#define TX_g_p_kluchi			7		// меняем версию ключей	
#define TX_g_p_flagov			8		// генерим флаги

	// состояния портов
#define Ready						0		// состояние ожидания
#define TX_Pack_Scremb		1		// передан пакет скремблирования


extern unsigned char rx0buf[];
extern unsigned char rx0addr;
// переменные для CF Card
extern unsigned char _FF_FULL_PATH[_FF_PATH_LENGTH];     
extern unsigned char tx1crc;



typedef struct 				// структура приемного пакета при передаче имени файла
{
	char Ptype;               // тип принятого пакета
	char fname[13];        // имя файла
} strInPack; 

typedef struct 				// структура приемного пакета при передаче имени файла
{
	char Ptype;               // тип принятого пакета
	char dataFlash[28];        // имя файла
} strDataPack; 


//comm.c
void putchar0(char byt);
void StartReply(unsigned char dlen);
void EndReply(void);
void Reply(u8 status);
unsigned char HaveIncomingPack(void);
unsigned char IncomingPackType(void);
void DiscardIncomingPack(void);              
void CommInit(void);         					 //Настройка UART
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
void twi_init (void);          						 //Настройка I2C 
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


// файл flashcard.c
#define rd_file	0
#define wr_file	1
#define dann_1_abon	132//4+124+4		// количество ячеек одного абонента (МАК+данн+счет)

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
void g_kod(void);	//генерация ключей
void men_ver_kl(void);	//переключение версии ключей
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


                                    



