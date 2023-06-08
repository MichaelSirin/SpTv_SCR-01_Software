/*********************************************
Project : FlashFileSD Example
Version : 
Date    : 12/23/2003
Author  : Erick M Higa    
Company : Progressive Resources LLC       
Comments: 
This is a simple example program for the FlashFileSD


Chip type           : ATmega128
Program type        : Application
Clock frequency     : 14.745600 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 1024
*********************************************/


#include "options.h"

#ifndef _UART_INT_
	#define		rx_counter0		(UCSR0A & 0x80)
	#define		tx_counter0		((!UCSR0A) & 0x40)
	#define		rx_counter1		(UCSR1A & 0x80)
	#define		tx_counter1		((!UCSR1A) & 0x40)
#endif

void port_init(void)
{
	PORTA = 0xFF;		DDRA  = 0x00;
	PORTB = 0xFF;		DDRB  = 0xD0;
	PORTC = 0xFF; 		DDRC  = 0x00;	  //m103 output only
	PORTD = 0xFF;		DDRD  = 0x00;
	PORTE = 0xFF;		DDRE  = 0x00;
	PORTF = 0xFF;		DDRF  = 0x00;
	PORTG = 0x1F;		DDRG  = 0x00;
}

//UART0 initialisation
// desired baud rate: 115200
// actual: baud rate:115200 (0.0%)
// char size: 8 bit
// parity: Disabled
void uart0_init(void)
{
	UCSR0B = 0x00; //disable while setting baud rate
	UCSR0A = 0x00;
	UCSR0C = 0x06;
	UBRR0L = 0x07; //set baud rate lo
	UBRR0H = 0x00; //set baud rate hi
	UCSR0B = 0x18;
}


//UART1 initialisation
// desired baud rate:115200
// actual baud rate:115200 (0.0%)
// char size: 8 bit
// parity: Disabled
void uart1_init(void)
{
	UCSR1B = 0x00; //disable while setting baud rate
	UCSR1A = 0x00;
	UCSR1C = 0x06;
	UBRR1L = 0x07; //set baud rate lo
	UBRR1H = 0x00; //set baud rate hi
	UCSR1B = 0x18;
}


//call this routine to initialise all peripherals
void init_devices(void)
{
	//stop errant interrupts until set up
	CLI(); //disable all interrupts
	XDIV  = 0x00; //xtal divider
	XMCRA = 0x00; //external memory
	port_init();
	uart0_init();
	uart1_init();

	MCUCR = 0x00;
	EICRA = 0x00; //extended ext ints
	EICRB = 0x00; //extended ext ints
	EIMSK = 0x00;
	TIMSK = 0x00; //timer interrupt sources
	ETIMSK = 0x00; //extended timer interrupt sources
	SEI(); //re-enable interrupts
	//all peripherals are now initialised
}

// Declare your global variables here
extern unsigned char rtc_hour, rtc_min, rtc_sec;
extern unsigned char rtc_date, rtc_month;
extern unsigned int rtc_year;
#ifdef _ICCAVR_
extern char _bss_end;
#endif


void main(void)
{
	FILE *pntr1;
	unsigned long c, n;

 	init_devices();

	#ifdef _ICCAVR_
		_NewHeap(&_bss_end + 1, &_bss_end + 1001);
	#endif
	
	#ifdef _RTC_ON_
		twi_setup();
	#endif 


	PORTB |= 0xD0;    
	
	// initialize the Secure Digital card
	while (initialize_media()==0)
	{	// Blink LED while waiting to initialize
		PORTB ^= 0x40;
	}
	PORTB &= 0x5F;

	// Create File
	
	pntr1 = fcreatec("demo.dat", 0);
	while (pntr1==0)
		pntr1 = fcreatec("demo.dat", 0);

	// Write to file
	#ifdef _RTC_ON_
		// if real time clock enabled, get and print time and date to file
		rtc_get_timeNdate(&rtc_hour, &rtc_min, &rtc_sec, &rtc_date, &rtc_month, (int *)&rtc_year);
		fputc(0x22, pntr1);		// put a " in before time/date
		if ((rtc_month/10)==0)
			fputc('0', pntr1);
		fprintf(pntr1, "%d/", rtc_month);
		if ((rtc_date/10)==0)
			fputc('0', pntr1);
		fprintf(pntr1, "%d/", rtc_date);
		fprintf(pntr1, "%d  ", rtc_year);
		if ((rtc_hour/10)==0)
			fputc('0', pntr1);
		fprintf(pntr1, "%d:", rtc_hour);
			if ((rtc_min/10)==0)
			fputc('0', pntr1);
		fprintf(pntr1, "%d:", rtc_min);
		if ((rtc_sec/10)==0)
			fputc('0', pntr1);
		fprintf(pntr1, "%d", rtc_sec);
		fputc(0x22, pntr1);	    // put a " in after time/date
		fputsc("", pntr1);
	#endif
	
	#ifdef _CVAVR_
	fprintf(pntr1, "Column %d, Column %d, Column %d, Column %d, Column %d, Column %d, Column %d, Column %d, Column %d, Column %d,\r\n",
		0, 1, 2, 3, 4, 5, 6, 7, 8, 9);
	#endif
	#ifdef _ICCAVR_
	fputsc("Column 0, Column 1, Column 2, Column 3, Column 4, Column 5, Column 6, Column 7, Column 8, Column 9,", pntr1);
	#endif
	
	
	for (c=0; c<100; c++)
	{	// print numbers separated by commas
		for (n=0; n<10; n++)
			fprintf(pntr1, "%ld, ", (((long)c*10)+(long)n));
		if (fputc('\r', pntr1)==EOF)
			break;			// line feed/carriage return
		if (fputc('\n', pntr1)==EOF)
			break;			// line feed/carriage return
		PORTB ^= 0x40;
		PORTB ^= 0x80;
	}

	fclose(pntr1);

	printf("\r\n\r\nDONE!!!");
	PORTB &= 0xBF;	// Keep LED on when done
	while (1)
	{	// Blink LED when done
		PORTB ^= 0x80;
		for (c=0; c<100000; c++)
			;
	};
}
