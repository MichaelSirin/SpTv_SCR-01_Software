///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 
// ����� � ������� �����

#include <Coding.h>

// ���������
#define START		0x08
#define	REP_START	0x10

// ���� �������
#define	MTX_ADR_ACK		0x18
#define	MRX_ADR_ACK		0x40
#define	MTX_DATA_ACK	0x28
#define	MRX_DATA_NACK	0x58
#define	MRX_DATA_ACK	0x50


/*// ��� ������ ��������� ������� ��������
static void twi_wait_int (void)
{

	while (!(TWCR & (1<<TWINT)))
	{
	   if ( flagTWI & ( 1<< time_is_Out))  
	   {
					#ifdef DEBUG
					putchar2 ('#');
					#endif DEBUG

		break;  // ������� �� ���� - ����
		 }
	} 
} 

// ��������� �������
// ���������� �� 0, ���� ��� � �������
unsigned char twi_start (void)
{
	TWCR = ((1<<TWINT)+(1<<TWSTA)+(1<<TWEN));
	
	twi_wait_int();

    if((TWSR != START)&&(TWSR != REP_START)) 	return 0;
	else return 255;
}

// �������� �������
void twi_stop (void)
{
	TWCR = ((1<<TWEN) + (1<<TWINT) + (1<<TWSTO));
}

// �������� ������
// ���������� �� 0, ���� ��� � �������
unsigned char twi_addr (unsigned char addr)
{
//	twi_wait_int();

	TWDR = addr;
	TWCR = ((1<<TWINT)+(1<<TWEN));

	twi_wait_int();                 		// ���� ������ 

	if ((TWSR != MTX_ADR_ACK)&&(TWSR != MRX_ADR_ACK))		return 0;
	else return 255;
}

// �������� ����� ������
// ���������� �� 0, ���� ��� � �������
unsigned char twi_byte (unsigned char data)
{

//	twi_wait_int();								// �����...

	TWDR = data;
 	TWCR = ((1<<TWINT)+(1<<TWEN));

	twi_wait_int();

	if (TWSR != MTX_DATA_ACK)	return 0;
	else 	return 255;
}

// ������ ����� 
// ���������� �� 0, ���� ��� � �������
unsigned char  twi_read (unsigned char notlast)
{
	timeOut ();									// ��������� ���� ���
//	twi_wait_int();   

	TWDR = 0;
	
	if (notlast)  TWCR = ((1<<TWINT)+(1<<TWEA)+(1<<TWEN));	// ��������� ������������� ������
	else			 TWCR = ((1<<TWINT)+(1<<TWEN)); 					// �� ��������� ������������� ������

 	twi_wait_int();    
 	timeOutStop ();							// ������� ������� ��������   

	return TWDR;
}

// ��������� �������� ���� �����
static inline void PortBitChange(unsigned char port, unsigned char bnum, unsigned char set)
{
	register unsigned char mask;
	#asm("cli");

	mask = 1 << bnum;		// �����
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
// ������ � ���������� �������
/*
unsigned char tx1crc;
unsigned char rx1state = RX_IDLE;
unsigned char rx1crc;
unsigned char rx1len;
//unsigned char rx1buf[256];
unsigned char rx1ptr;*/

/*// �������� ����� �� "����������" �����
void putword1(unsigned int wd)
{
	putchar1(wd);
	putchar1(wd >> 8);
} 

// ������ ������� �� ���������� �����
void StartIntReq(unsigned char dlen) 
{
	while(1)
	{	
		if (!twi_start())       // C���� ������
		{
			twi_stop();
			continue;
		}

		
		if (!twi_addr(0))       // �������� ���� �����������
		{
			twi_stop();
			continue;
		}
		
		break;
	}


	tx1crc = 0;					// ������� CRC

	twi_byte(PACKHDR);		    // ������� ���������
	tx1crc+=(PACKHDR);

	twi_byte(dlen+1);			// ������� �����
	tx1crc+=(dlen+1);
} */


// ���������� �� ��������� B ������� 1 ��� �������� ����-���� ������ "�����������" ������
interrupt [TIM1_COMPB] void timer1_comp_b_isr(void)
{
//	rx1state = RX_TIME;		// ��� ����-���
//	TIMSK &= 0x08 ^ 0xFF;	// ��������� ���������� �� ����-����
}


/*// ������� ���������� ����� ������ �� ������ ������
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

// ���������� ������� ����� ���������� ��������� ��������� �� "�����������" ������ ������
void FreeInternalCom(void)
{
	rx1state = RX_IDLE;
}

// �������� ����� byte �� pAddr
unsigned char txTWIbyte (unsigned char pAddr, unsigned char byte)
	{  

		timeOut ();									// ��������� ���� ���

		if (!twi_start())     		  				// C���� ������
			{
				twi_stop();
			}
		
		if (!twi_addr((pAddr<<1)+0))       // ��������  �� ������ pAddr (�� 0 - ������)
			{
				twi_stop();
			}            
			
		twi_byte(byte);								// �������� ����
		twi_stop();									// ���� ������

		timeOutStop ();							// ������� ������� ��������   
		
	    if ( ! ( flagTWI & ( 1 << time_is_Out))) return 255;
	    	else 
    		{
				flagTWI  = flagTWI  ^ (1 << time_is_Out);	//����������  �������
				return 0;
    		}
	}

/*unsigned char txTWIbuff (unsigned char pAddr)
	{                                                                           
		unsigned char a ;
//printf("Transmitting... ");
		
//		timeOut ();									// ��������� ���� ���
		if (!twi_start())     		  				// C���� ������
			{
				twi_stop();
			}

		if (!twi_addr((pAddr<<1)+0))       // ��������  �� ������ pAddr (�� 0 - ������)
			{
				twi_stop();
			}            

	twi_wait_int(); 					// ���� ������ �� �����

		for (a=0;a<=txBuffer[1]+1;a++)     //�����+���������
			{		                         
				twi_byte(txBuffer[a]);				// �������� ����
			}		

			twi_stop();									// ���� ������
			timeOutStop ();							// ������� ������� ��������   
		
	    	if ( ! ( flagTWI & ( 1 << time_is_Out))) return 255;
	    		else 
	    			{
						flagTWI  = flagTWI  ^ (1 << time_is_Out);	//����������  �������
						return 0;
		    		}
	}
	

// ���������� � ������
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

		if ( !twi_start() )	twi_stop();                         // C���� ������
		if (!twi_addr( (pAddr<<1) + 1) )  	twi_stop(); 		// ��������  �� ������ pAddr (�� 1 - ������)

		rxBuffer[0] = twi_read(1);				// ������  � ����������  ����� ������������ ������
		for (a=1; a<rxBuffer[0];  a++)		rxBuffer[a] = twi_read(1);			// �� ����. ���� - ��������� ACK
		rxBuffer[a] = twi_read(0);			// ����. ���� -  �� ��������� ACK

		twi_stop();									// ���� ������       
        
			
			// ��������� ������� � CRC
			#ifdef DEBUG
			if ((pAddr == 4)&&(rxBuffer[0])) putchar2 ('+');
			#endif DEBUG

    	if ( (! ( flagTWI & ( 1 << time_is_Out) ) ) ) 		return 255;	//Ok
   		else 
		{
				flagTWI  = flagTWI  ^ (1 << time_is_Out);		//����������  �������
				return 0;                                                          // Time Out
   		}
} */
