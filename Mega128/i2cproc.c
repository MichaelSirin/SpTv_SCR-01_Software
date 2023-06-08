///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 
// Связь с внешним миром

#include <Coding.h>

// Состояния
#define START		0x08
#define	REP_START	0x10

// Коды статуса
#define	MTX_ADR_ACK		0x18
#define	MRX_ADR_ACK		0x40
#define	MTX_DATA_ACK	0x28
#define	MRX_DATA_NACK	0x58
#define	MRX_DATA_ACK	0x50


/*// Жду флажка окончания текущей операции
static void twi_wait_int (void)
{

	while (!(TWCR & (1<<TWINT)))
	{
	   if ( flagTWI & ( 1<< time_is_Out))  
	   {
					#ifdef DEBUG
					putchar2 ('#');
					#endif DEBUG

		break;  // выходим по тайм - ауту
		 }
	} 
} 

// Стартовое условие
// Возвращает не 0, если все в порядке
unsigned char twi_start (void)
{
	TWCR = ((1<<TWINT)+(1<<TWSTA)+(1<<TWEN));
	
	twi_wait_int();

    if((TWSR != START)&&(TWSR != REP_START)) 	return 0;
	else return 255;
}

// Стоповое условие
void twi_stop (void)
{
	TWCR = ((1<<TWEN) + (1<<TWINT) + (1<<TWSTO));
}

// Передача адреса
// Возвращает не 0, если все в порядке
unsigned char twi_addr (unsigned char addr)
{
//	twi_wait_int();

	TWDR = addr;
	TWCR = ((1<<TWINT)+(1<<TWEN));

	twi_wait_int();                 		// Ждем отклик 

	if ((TWSR != MTX_ADR_ACK)&&(TWSR != MRX_ADR_ACK))		return 0;
	else return 255;
}

// Передача байта данных
// Возвращает не 0, если все в порядке
unsigned char twi_byte (unsigned char data)
{

//	twi_wait_int();								// ждемс...

	TWDR = data;
 	TWCR = ((1<<TWINT)+(1<<TWEN));

	twi_wait_int();

	if (TWSR != MTX_DATA_ACK)	return 0;
	else 	return 255;
}

// Чтение байта 
// Возвращает не 0, если все в порядке
unsigned char  twi_read (unsigned char notlast)
{
	timeOut ();									// запускаем тайм аут
//	twi_wait_int();   

	TWDR = 0;
	
	if (notlast)  TWCR = ((1<<TWINT)+(1<<TWEA)+(1<<TWEN));	// формируем подтверждение приема
	else			 TWCR = ((1<<TWINT)+(1<<TWEN)); 					// НЕ формируем подтверждение приема

 	twi_wait_int();    
 	timeOutStop ();							// останов таймера таймаута   

	return TWDR;
}

// Изменение значения бита порта
static inline void PortBitChange(unsigned char port, unsigned char bnum, unsigned char set)
{
	register unsigned char mask;
	#asm("cli");

	mask = 1 << bnum;		// Маска
	if (!set)
	{
		mask ^= 0xFF;
	}
		
	switch(port)
	{
	case 'B':
		if (set) PORTB |= mask; else PORTB &= mask;
		break;
	case 'C':
		if (set) PORTC |= mask; else PORTC &= mask;
		break;
	case 'D':
		if (set) PORTD |= mask; else PORTD &= mask;
		break;
	}
	
	#asm("sei");
} */


     
////////////////////////////////////////////////////////////////////////////////
// Работа с внутренним каналом
/*
unsigned char tx1crc;
unsigned char rx1state = RX_IDLE;
unsigned char rx1crc;
unsigned char rx1len;
//unsigned char rx1buf[256];
unsigned char rx1ptr;*/

/*// Передача байта во "внутренний" канал
void putword1(unsigned int wd)
{
	putchar1(wd);
	putchar1(wd >> 8);
} 

// Начало запроса во внутренний канал
void StartIntReq(unsigned char dlen) 
{
	while(1)
	{	
		if (!twi_start())       // Cтарт пакета
		{
			twi_stop();
			continue;
		}

		
		if (!twi_addr(0))       // Передача всем подчиненным
		{
			twi_stop();
			continue;
		}
		
		break;
	}


	tx1crc = 0;					// Готовлю CRC

	twi_byte(PACKHDR);		    // Передаю заголовок
	tx1crc+=(PACKHDR);

	twi_byte(dlen+1);			// Передаю длину
	tx1crc+=(dlen+1);
} */


// Прерывание по сравнению B таймера 1 для подсчета тайм-аута приема "внутреннего" канала
interrupt [TIM1_COMPB] void timer1_comp_b_isr(void)
{
//	rx1state = RX_TIME;		// Был тайм-аут
//	TIMSK &= 0x08 ^ 0xFF;	// Запретить прерывание по тайм-ауту
}


/*// Признак завершения цикла обмена во внутрю канале
unsigned char HaveInternalReply(void)
{
	switch(rx1state)
	{
	case RX_OK:
	case RX_TIME:
	case RX_ERR:
		return rx1state;
	default:
		return 0;
	}
} 

// Необходимо вызвать после завершения обработки принятого по "внутреннему" каналу пакета
void FreeInternalCom(void)
{
	rx1state = RX_IDLE;
}

// Передача байта byte по pAddr
unsigned char txTWIbyte (unsigned char pAddr, unsigned char byte)
	{  

		timeOut ();									// запускаем тайм аут

		if (!twi_start())     		  				// Cтарт пакета
			{
				twi_stop();
			}
		
		if (!twi_addr((pAddr<<1)+0))       // Передача  по адресу pAddr (мл 0 - запись)
			{
				twi_stop();
			}            
			
		twi_byte(byte);								// передаем байт
		twi_stop();									// стоп пакета

		timeOutStop ();							// останов таймера таймаута   
		
	    if ( ! ( flagTWI & ( 1 << time_is_Out))) return 255;
	    	else 
    		{
				flagTWI  = flagTWI  ^ (1 << time_is_Out);	//сбрасываем  признак
				return 0;
    		}
	}

/*unsigned char txTWIbuff (unsigned char pAddr)
	{                                                                           
		unsigned char a ;
//printf("Transmitting... ");
		
//		timeOut ();									// запускаем тайм аут
		if (!twi_start())     		  				// Cтарт пакета
			{
				twi_stop();
			}

		if (!twi_addr((pAddr<<1)+0))       // Передача  по адресу pAddr (мл 0 - запись)
			{
				twi_stop();
			}            

	twi_wait_int(); 					// ждем отклик на адрес

		for (a=0;a<=txBuffer[1]+1;a++)     //длина+заголовок
			{		                         
				twi_byte(txBuffer[a]);				// передаем байт
			}		

			twi_stop();									// стоп пакета
			timeOutStop ();							// останов таймера таймаута   
		
	    	if ( ! ( flagTWI & ( 1 << time_is_Out))) return 255;
	    		else 
	    			{
						flagTWI  = flagTWI  ^ (1 << time_is_Out);	//сбрасываем  признак
						return 0;
		    		}
	}
	

// Вычитываем в буффер
unsigned char rxTWIbuff (unsigned char pAddr)
		{                                                         
		unsigned char a;

		#ifdef DEBUG
		rxBuffer[0] = 0xFF;
		rxBuffer[1] = 0xFF;
		rxBuffer[2] = 0xFF;
		rxBuffer[3] = 0xFF;
		rxBuffer[4] = 0xFF; 
		rxBuffer[5] = 0xFF;
		#endif DEBUG  

		if ( !twi_start() )	twi_stop();                         // Cтарт пакета
		if (!twi_addr( (pAddr<<1) + 1) )  	twi_stop(); 		// Передача  по адресу pAddr (мл 1 - чтение)

		rxBuffer[0] = twi_read(1);				// читаем  и запоминаем  длину принимаемого пакета
		for (a=1; a<rxBuffer[0];  a++)		rxBuffer[a] = twi_read(1);			// не посл. байт - формируем ACK
		rxBuffer[a] = twi_read(0);			// посл. байт -  не формируем ACK

		twi_stop();									// стоп пакета       
        
			
			// Проверяем таймаут и CRC
			#ifdef DEBUG
			if ((pAddr == 4)&&(rxBuffer[0])) putchar2 ('+');
			#endif DEBUG

    	if ( (! ( flagTWI & ( 1 << time_is_Out) ) ) ) 		return 255;	//Ok
   		else 
		{
				flagTWI  = flagTWI  ^ (1 << time_is_Out);		//сбрасываем  признак
				return 0;                                                          // Time Out
   		}
} */
