#include <io.h>
#include <stdio.h>
#include <Comm.h>
#include <Delay.h>   

// файлы для SD-Card
	#include "sd_cmd.h"
	#include <file_sys.h>   
	#include "options.h"   



// константы глобальные
extern unsigned char int_Devices;			// количество подчиненных устройств
extern unsigned char FILENAME[12];

extern unsigned char flagTWI	;	// Состояние шины TWI. Флаги
#define 	time_is_Out			0		// Сработал таймаут (1-сработал, 0 - не сработал) 




#define IVCE 	0
#define IVSEL 1                    

// Выводы микросхемы
#define CRST 		PORTA.2     //Вывод сброса периферии
#define testpin			PORTB.7	// тестовый пин (17 вывод)	
#define LedRed() {DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 0, PORTA.1 = 1;}
#define LedGreen() {DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 1, PORTA.1 = 0;}
#define LedOff() {DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 1, PORTA.1 = 1;}

// Фазы работы приемопередатчиков
#define RX_HDR	 1		// Принятый байт - заголовок
#define RX_LEN   2		// Принятый байт - длина
#define RX_ADDR  3		// Принятый байт - адрес
#define RX_TYPE  4		// Принятый байт - тип пакета
#define RX_DATA  5		// Принятый байт - байт данных
#define RX_CRC   6		// Принятый байт - CRC
#define RX_OK    7		// Пакет успешно принят и адресован мне
#define RX_TIME  8		// Во время приема произошел тайм-аут
#define RX_ERR   9		// Ошибка CRC приема
#define RX_IDLE 10		// Внутренний канал свободен     
  
// Пакеты работы с CF Flash
#define PT_Fcreate		1
#define PT_Fopen			2	// открыть файл
#define PT_Fclose        	3
#define PT_Fremove     	4
#define PT_Frename     5
#define PT_Ffseek        6
#define PT_Fformat       7 
#define PT_Fadd			8		//дописать данные в конец файла

// Пакеты, используемые внутри CD
#define GetLogAddr	1				// дать логический адрес
#define OP					100		// пакеты для отладки
#define pingPacket		2			// пингуем подчиненное на наличие информации на передачу

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


void StartReply(unsigned char dlen);
void putchar0(char byt);
void EndReply(void);
void putword0(unsigned short wd); 
void RelayPack(void);
void CommInit(void);         					 //Настройка UART
void twi_init (void);          						 //Настройка I2C 
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
// работаем с CF Card
unsigned char initialize_media(void);
void display_demo_commands(void);
void flash_Work (void);     
void fprintf(FILE *rp, unsigned char flash *pstr, ...);

                                    



