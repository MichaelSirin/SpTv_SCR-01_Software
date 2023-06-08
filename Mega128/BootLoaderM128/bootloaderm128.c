/////////////////////////////////////////////////////////////////////////////////////////////
// ��� �������� "������" I2CxCOM
#include "monitor.h"
                                    
#define LedRed() {DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 0, PORTA.1 = 1;}
#define LedGreen() {DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 1, PORTA.1 = 0;}
#define LedOff() {DDRA.0 = 1, DDRA.1 = 1, PORTA.0 = 1, PORTA.1 = 1;}

#define BAUD 38400		// �������� ������ �� COM-�����
const unsigned int scrambling_seed = 333;

void HardwareInit(void)
{
	// ���������� UART
//	UCSR0A = 0x00;
	UCSR0B = 0x10; //0x18; //�������� ���.
	UCSR0C = 0x06;
	UBRR0L = ((_MCU_CLOCK_FREQUENCY_ / (16 * BAUD)) - 1) & 0xFF;
	UBRR0H = (((_MCU_CLOCK_FREQUENCY_ / (16 * BAUD)) - 1) >> 8) & 0xFF;

	// �������� ����������
//	ACSR=0x80;
//	SFIOR=0x00;

	// �������
	WDTCR=0x1F;
	WDTCR=0x0F;
}

#define USR  UCSR0A
#define UDRE (1 << 5)
#define UDR  UDR0
#define RXC  (1 << 7)

// �������� ����� � �����
inline void XmitChar(unsigned char byt)
{
	while(!(USR & UDRE));
	UDR = byt;
}

// ������� ��������� �����
unsigned char HaveRxChar(void)
{
	return USR & RXC;
}

// ����� ����� �� ������
inline unsigned char ReceiveChar(void)
{
	while(!HaveRxChar());
	return UDR;
}
