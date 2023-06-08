///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ����������� ��������� ������
// ����� � ������� �����

#include "Coding.h"

#define BAUD 38400

/*
////////////////////////////////////////////////////////////////////////////////
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
#define RX_BUSY 10		// ������ ��������, � ����� ��� �� �����������
*/
#define UDRE 5
#define DATA_REGISTER_EMPTY (1<<UDRE)

#define RXTIMEOUT 4000	// ����-��� ������ ��������� ������

////////////////////////////////////////////////////////////////////////////////
// ������ � �������� �������

unsigned char tx0crc;
unsigned char rx0state = RX_HDR;
unsigned char rx0crc;
unsigned char rx0len;
unsigned char rx0addr;
unsigned char rx0type;

#define COMBUFSIZ 255

unsigned char rx0buf[COMBUFSIZ];
unsigned char rx0ptr;

// �������� ����� �� "�������" �����
void putchar0(char byt)
{
	while ((UCSR0A & DATA_REGISTER_EMPTY)==0);
	UDR0 = byt;
	tx0crc += byt;
}

// ������ ������ �� ������ �� �������� ������
void StartReply(unsigned char dlen) 
{
//	rx0state = RX_BUSY;					// ������ ���������
	tx0crc = 0;										// ������� CRC
	
	UCSR0B.3 = 1;								// �������� ����������
	
	putchar0(dlen+1);							// ������� �����
}

void EndReply(void)
{
	putchar0(tx0crc);							// ����������� �����
//	UCSR0B.3 = 0;								// �������� ����������
	rx0state = RX_HDR;						// �������� ����� ����. �������
}

// ���������� �� ������ ����� �� "���������" ������
interrupt [USART0_RXC] void uart_rx_isr(void)
{
	register unsigned char byt;

	byt = UDR0;									// �������� ����

	
	switch (rx0state)
	{
	case RX_HDR:								// ������ ���� ���������
		if (byt != PACKHDR)					// ���������� �� ���������
		{
			break;
		}


		rx0state = RX_LEN;					// �������� � �������� �����
		rx0crc = 0;								// ������� ������� CRC
		
		OCR1A = TCNT1+RXTIMEOUT;	// ������ ����-���
		TIFR = 0x10;								// ������������ ������ ������������
		TIMSK |= 0x10;							// ���������� ���������� �� ����-����
		break;
		
	case RX_LEN:
		rx0len = byt - 3;							// ����� �����������
		rx0state = RX_ADDR;					// � ������ ������
		break;

	case RX_ADDR:
		rx0addr = byt;							// �����
		rx0state = RX_TYPE;					// � ������ ����
		break;

	case RX_TYPE:
		rx0type = byt;							// ���
		rx0ptr = 0;									// ��������� �� ������ ������
		if (rx0len)
		{
			rx0state = RX_DATA;				// � ������ ������
		}
		else
		{
			rx0state = RX_CRC; 				// � ������ ����������� �����
		}
		break;

	case RX_DATA:
		if (rx0ptr > (COMBUFSIZ-1))
		{
			rx0state = RX_HDR;				// ���� ����� ������� ������� - �������� � ��� � ������
			break;
		}
		rx0buf[rx0ptr++] = byt;				// ������
		if (rx0ptr < rx0len)						// ��� �� ��� ?
		{
			break;
		}
		rx0state = RX_CRC;					// � ������ ����������� �����
		break;

	case RX_CRC:
		if (byt != rx0crc)
		{
			rx0state = RX_HDR;				// �� ������� CRC - ��������� ����� � ��� ���������
		}
// ����� ������ ������
else
{
rx0buf[rx0ptr++] = byt;						// ������
rx0state = RX_OK;								// ������ �����, �� ������� ����� ��������
}
/*		else if ((rx0addr == my_addr) || (rx0addr == TO_ALL))
		{
 			rx0buf[rx0ptr++] = byt;			// ������
    		rx0state = RX_OK;				// ������ �����, �� ������� ����� ��������
		}
		else
		{
			rx0state = RX_HDR;				// ������ �����, ������������ �� ��� - ��� ����������
		}*/
		TIMSK &= 0x10 ^ 0xFF;				// ��������� ���������� �� ����-����
		break;
		
//	case RX_BUSY:							// ������ ������, �� ����� ��� �� �����
		break;
		
	default:											// ��������� ���������
		rx0state = RX_HDR;					// �������� �� ������
		break;
	}

	rx0crc += byt;								// ����������� ����������� �����
}

// ���������� �� ��������� A ������� 1 ��� �������� ����-���� ������ "��������" ������
interrupt [TIM1_COMPA] void timer1_comp_a_isr(void)
{
	rx0state = RX_HDR;						// �� ����-���� �������� � ������ ������ ������ ������
	TIMSK &= 0x10 ^ 0xFF;					// ������ �� ������������ ����������
}

unsigned char HaveIncomingPack(void)
{
	if (rx0state == RX_OK)	return 255;
	else					return 0;
}

unsigned char IncomingPackType(void)
{
	return rx0type;
}

void DiscardIncomingPack(void)
{
	rx0state = RX_HDR;						// �������� ����� ���������� ������
}

// ��������� �����������������
void CommInit(void)
{
	// �������� �� TXD
//	DDRD.1 = 0;
//	PORTD.1 = 1;
/*	
// USART0 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART0 Receiver: On
// USART0 Transmitter: On
// USART0 Mode: Asynchronous
// USART0 Baud rate: 38400
UCSR0A=0x00;
UCSR0B=0x18;
UCSR0C=0x06;
UBRR0H=0x00;
UBRR0L=0x0C;
*/


	// ���������� UART
	UCSR0A = 0b00000000;
	UCSR0B = 0b10010000;	//0b10011000;
	UCSR0C = 0x86;
	UBRR0L = ((_MCU_CLOCK_FREQUENCY_ / (16 * BAUD)) - 1) & 0xFF;
	UBRR0H = (((_MCU_CLOCK_FREQUENCY_ / (16 * BAUD)) - 1) >> 8) & 0xFF;
	
	// ������ 1 ��� �������� ����-����� ������
	TCCR1B  = 0b00000101;
}

void putword0(unsigned short wd)
{
	putchar0(wd);
	putchar0(wd >> 8);
}                                  


// ������������ ����� ������ �� �������� �� �����. ����� � �������
// "����������" ����� ������ ���� ��������

void RelayPack(void)
{
	register unsigned char i,a;
 LedRed();	
	// ������� ������
	StartIntReq(rx0len);
	
	// ���� ������
	for (i = 0; i < rx0len; i ++)
	{
		twi_byte(rx0buf[i]);   
		tx1crc +=(rx0buf[i]);
	}
	
	// ��������� �������
	EndIntReq();
	DiscardIncomingPack();        // ��������� ��������� ����. �����

	delay_ms (10);						// ��������� �����

/*	if ((rx0buf[0] == TO_MON) || (rx0buf[0] == TO_MON))       // ���� ����� ������ ���� - ��������� ����� �� �������
		{
			for (a=1; a<= int_Devices; a++) pingPack (a);	
		}
	else	pingPack (rx0buf[0]);*/

//	pingPack (4);	

} 
  
