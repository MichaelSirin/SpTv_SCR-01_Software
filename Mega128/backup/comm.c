///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ����������� ��������� ����� MPEG2
// ����� � ������� �����

#include "mpeg2-1.h"

#define BAUD 38400

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
	while ((UCSRA & DATA_REGISTER_EMPTY)==0);
	UDR = byt;
	tx0crc += byt;
}

// ������ ������ �� ������ �� �������� ������
void StartReply(unsigned char dlen) 
{
	rx0state = RX_BUSY;		// ������ ���������
	tx0crc = 0;				// ������� CRC
	
	UCSRB.3 = 1;			// �������� ����������
	
	putchar0(dlen+1);		// ������� �����
}

void EndReply(void)
{
	putchar0(tx0crc);		// ����������� �����
	UCSRB.3 = 0;			// �������� ����������
	rx0state = RX_HDR;		// �������� ����� ����. �������
}

// ���������� �� ������ ����� �� "���������" ������
interrupt [USART_RXC] void uart_rx_isr(void)
{
	register unsigned char byt;
	
	byt = UDR;					// �������� ����
	
	switch (rx0state)
	{
	case RX_HDR:				// ������ ���� ���������
		if (byt != PACKHDR)		// ���������� �� ���������
		{
			break;
		}

		rx0state = RX_LEN;		// �������� � �������� �����
		rx0crc = 0;				// ������� ������� CRC
		
		OCR1A = TCNT1+RXTIMEOUT;// ������ ����-���
		TIFR = 0x10;			// ������������ ������ ������������
		TIMSK |= 0x10;			// ���������� ���������� �� ����-����
		break;
		
	case RX_LEN:
		rx0len = byt - 3;		// ����� �����������
		rx0state = RX_ADDR;		// � ������ ������
		break;

	case RX_ADDR:
		rx0addr = byt;			// �����
		rx0state = RX_TYPE;		// � ������ ����
		break;

	case RX_TYPE:
		rx0type = byt;			// ���
		rx0ptr = 0;				// ��������� �� ������ ������
		if (rx0len)
		{
			rx0state = RX_DATA;	// � ������ ������
		}
		else
		{
			rx0state = RX_CRC; 	// � ������ ����������� �����
		}
		break;

	case RX_DATA:
		if (rx0ptr > (COMBUFSIZ-1))
		{
			rx0state = RX_HDR;		// ���� ����� ������� ������� - �������� � ��� � ������
			break;
		}
		rx0buf[rx0ptr++] = byt;	// ������
		if (rx0ptr < rx0len)	// ��� �� ��� ?
		{
			break;
		}
		rx0state = RX_CRC;		// � ������ ����������� �����
		break;

	case RX_CRC:
		if (byt != rx0crc)
		{
			rx0state = RX_HDR;	// �� ������� CRC - ��������� ����� � ��� ���������
		}
		else if ((rx0addr == my_addr) || (rx0addr == TO_ALL))
		{
			rx0state = RX_OK;	// ������ �����, �� ������� ����� ��������
		}
		else
		{
			rx0state = RX_HDR;	// ������ �����, ������������ �� ��� - ��� ����������
		}
		TIMSK &= 0x10 ^ 0xFF;	// ��������� ���������� �� ����-����
		break;
		
	case RX_BUSY:				// ������ ������, �� ����� ��� �� �����
		break;
		
	default:					// ��������� ���������
		rx0state = RX_HDR;		// �������� �� ������
		break;
	}

	rx0crc += byt;				// ����������� ����������� �����
}

// ���������� �� ��������� A ������� 1 ��� �������� ����-���� ������ "��������" ������
interrupt [TIM1_COMPA] void timer1_comp_a_isr(void)
{
	rx0state = RX_HDR;		// �� ����-���� �������� � ������ ������ ������ ������
	TIMSK &= 0x10 ^ 0xFF;	// ������ �� ������������ ����������
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
	rx0state = RX_HDR;		// �������� ����� ���������� ������
}

// ��������� �����������������
void CommInit(void)
{
	// �������� �� TXD
	DDRD.1 = 0;
	PORTD.1 = 1;
	
	// ���������� UART
	UCSRA = 0b00000000;
	UCSRB = 0b10010000;	//0b10011000;
	UCSRC = 0x86;
	UBRRL = ((_MCU_CLOCK_FREQUENCY_ / (16 * BAUD)) - 1) & 0xFF;
	UBRRH = (((_MCU_CLOCK_FREQUENCY_ / (16 * BAUD)) - 1) >> 8) & 0xFF;
	
	// ������ 1 ��� �������� ����-����� ������
	TCCR1B  = 0b00000101;
}

void putword0(unsigned short wd)
{
	putchar0(wd);
	putchar0(wd >> 8);
}