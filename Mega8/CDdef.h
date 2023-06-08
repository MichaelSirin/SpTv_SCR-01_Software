#include <mega8.h> 
#include <twi_slave.h >

#include <Comm.h>							// ���������, ��������� � �.�. ��������� �����.
#include <Scrambling.h>					// ���������, ������ ��.�. ��� ����������
    
#define IVCREG GICR
#define IVCE   0 
#define IVSEL  1     

// ���� ����������
#define u8		unsigned char 
#define u16	unsigned int
#define u32	unsigned long int	                  


// ������
#define MY_TWI_ADDRESS	0x1		// TWI �����-�� ���������
//#define from_TWI		0x0						// ���� TWI
//#define from_UART	0x1						// ���� UART

// ������ ����������
// ��������� ����������
#define LedOn()       	{  PORTD.3=0;}
#define LedOff()       	{  PORTD.3=1;}    
#define LedInv()		{ PORTD.3 = ! ( PORTD.3); }

#define testpin			 	PORTD.2				// �������� ���
#define DTXDDR			DDRD.4				// ����� ������������ UART
#define DTXPIN			PORTD.4				// ����� ������������ UART

#define UART_RX_Len 	 rxBufferUART[0]  	// ����� ������ UART

// �������
void workINpack ( void );	
unsigned char checkCRCrx (unsigned char *Position_in_Packet, unsigned char Incoming_PORT);
void putchar2(char c);
void packPacket (unsigned char type);
void _GetLogAddr (void);
void Initialization_Device (void);   
void workUARTpack (void);   
void give_GETINFO (void);
void Wait_Responce ( unsigned char Status );
void	Responce_OK (unsigned char Status);
void    port_state (u8 state);


#define TXB8 	0
#define RXB8 	1
#define UPE 		2
#define OVR 	3
#define FE 		4
#define UDRE 	5
#define RXC 	7

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

				

