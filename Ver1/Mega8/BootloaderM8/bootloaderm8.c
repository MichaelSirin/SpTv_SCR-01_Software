/////////////////////////////////////////////////////////////////////////////////////////////
// ��� �������� "������" Coding Device (Mega8)
#include "monitor.h"
#include "CodingM8.h"        


const   unsigned int scrambling_seed = 333;

void HardwareInit(void)
{
	// ��������� �������
	PORTC=0x07;
	DDRC=0x00;

    // USART initialization
    // Communication Parameters: 8 Data, 1 Stop, No Parity
    // USART Receiver: On
    // USART Transmitter: On
    // USART Mode: Asynchronous
    // USART Baud rate: 38400
    UCSRA=0x00;
    UCSRB=0x18;
    UCSRC=0x86;
    UBRRH=0x00;
    UBRRL=0x0C;



	// �������� ����������
	ACSR=0x80;
	SFIOR=0x00;

    //��������� TWI
    twi_init();             

	// �������
	WDTCR=0x1F;
	WDTCR=0x0F;  

}

#define USR  TWSR                   //������ ����� 
#define UDRE (1 << 5)
#define UDR  TWDR                   //������� � ������������/������������� �������
#define RXC  (1 << 7)
