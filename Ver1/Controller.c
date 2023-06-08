/*********************************************
Project : FlashFileSD
Version : 1.31 
Date    : 12/19/2003
Author  : Erick Higa       
Company : Progressive Resources LLC       

Chip type           : ATmega128
Program type        : Application
Clock frequency     : 14.745600 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 1024

Comments:
The "fulldemo.c" file is an example of how the FlasFileSD
can be used.  It is setup to use an ATMega128 processor,
a 14.7456 MHz oscillator, with USART0 @ 115200 bps.

See "file_sys.c" header for revision history

Software License
The use of Progressive Resources LLC FlashFile Source Package indicates 
your understanding and acceptance of the following terms and conditions. 
This license shall supersede any verbal or prior verbal or written, statement 
or agreement to the contrary. If you do not understand or accept these terms, 
or your local regulations prohibit "after sale" license agreements or limited 
disclaimers, you must cease and desist using this product immediately.
This product is © Copyright 2003 by Progressive Resources LLC, all rights 
reserved. International copyright laws, international treaties and all other 
applicable national or international laws protect this product. This software 
product and documentation may not, in whole or in part, be copied, photocopied, 
translated, or reduced to any electronic medium or machine readable form, without 
prior consent in writing, from Progressive Resources LLC and according to all 
applicable laws. The sole owner of this product is Progressive Resources LLC.

Operating License
You have the non-exclusive right to use any enclosed product but have no right 
to distribute it as a source code product without the express written permission 
of Progressive Resources LLC. Use over a "local area network" (within the same 
locale) is permitted provided that only a single person, on a single computer 
uses the product at a time. Use over a "wide area network" (outside the same 
locale) is strictly prohibited under any and all circumstances.
                                           
Liability Disclaimer
This product and/or license is provided as is, without any representation or 
warranty of any kind, either express or implied, including without limitation 
any representations or endorsements regarding the use of, the results of, or 
performance of the product, Its appropriateness, accuracy, reliability, or 
correctness. The user and/or licensee assume the entire risk as to the use of 
this product. Progressive Resources LLC does not assume liability for the use 
of this product beyond the original purchase price of the software. In no event 
will Progressive Resources LLC be liable for additional direct or indirect 
damages including any lost profits, lost savings, or other incidental or 
consequential damages arising from any defects, or the use or inability to 
use these products, even if Progressive Resources LLC have been advised of 
the possibility of such damages.
*********************************************/

#include <mega128.h>

#define RXB8 1
#define TXB8 0
#define UPE 2
#define OVR 3
#define FE 4
#define UDRE 5
#define RXC 7

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// Get a character from the USART0 Receiver
#ifndef _DEBUG_TERMINAL_IO_
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char status,data;
while (1)
      {
      while (((status=UCSR0A) & RX_COMPLETE)==0);
      data=UDR0;
      if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
         return data;
      };
}
#pragma used-
#endif

// Write a character to the USART0 Transmitter
#ifndef _DEBUG_TERMINAL_IO_
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while ((UCSR0A & DATA_REGISTER_EMPTY)==0);
UDR0=c;
}
#pragma used-
#endif

#include "options.h"

#ifndef _UART_INT_
	#define		rx_counter0		(UCSR0A & 0x80)
	#define		tx_counter0		((!UCSR0A) & 0x40)
	#define		rx_counter1		(UCSR1A & 0x80)
	#define		tx_counter1		((!UCSR1A) & 0x40)
#endif

void port_init(void)
{
 PORTA = 0b00000010;	DDRA  = 0b00000011;  // Красный при вкл.
 PORTB = 0xFF;		DDRB  = 0x00;
 PORTC = 0xFF; 		DDRC  = 0x00;	  //m103 output only
 PORTD = 0xFF;		DDRD  = 0x00;
 PORTE = 0xFF;		DDRE  = 0x00;
 PORTF = 0xFF;		DDRF  = 0x00;
 PORTG = 0x1F;		DDRG  = 0x00;
}


/*//UART0 initialisation
// desired baud rate: 115200
// actual: baud rate:115200 (0.0%)
// char size: 8 bit
// parity: Disabled
void uart0_init(void)
{
 UCSR0B = 0x00; //disable while setting baud rate
 UCSR0A = 0x00;
 UCSR0C = 0x06;
// UBRR0L = 0x07; //set baud rate lo
// UBRR0H = 0x00; //set baud rate hi
 UBRR0H=0x00;
 UBRR0L=0x08;
 UCSR0B = 0x18;
} */

// USART0 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART0 Receiver: On
// USART0 Transmitter: On
// USART0 Mode: Asynchronous
// USART0 Baud rate: 56000
void uart0_init(void)
{
UCSR0A=0x00;
UCSR0B=0x18;
UCSR0C=0x06;
UBRR0H=0x00;
UBRR0L=0x08;
}



/*
// USART0 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART0 Receiver: On
// USART0 Transmitter: On
// USART0 Mode: Asynchronous
// USART0 Baud rate: 56000
void uart0_init(void)
{
UCSR0A=0x00;
UCSR0B=0x18;
UCSR0C=0x06;
UBRR0H=0x00;
UBRR0L=0x08;
} 
*/
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
extern unsigned char _FF_buff[512];

extern unsigned char rtc_hour, rtc_min, rtc_sec;
extern unsigned char rtc_date, rtc_month;
extern unsigned int rtc_year;

char menu_level;
FILE *file1;



void display_demo_commands(void)
{
	printf("\r\nTest Commands:");
	printf("\r\n  (1)-Initialize Media      (2)-Read Directory Files");
	printf("\r\n  (3)-Create File           (4)-Delete File");
	printf("\r\n  (5)-Rename File           (6)-Open File");
	printf("\r\n  (7)-Make Directory        (8)-Delete Directory");
	printf("\r\n  (9)-Change Working Dir    (0)-Get File Info");
	printf("\r\n  (F)-Quick Format Card     (V)-Get Media Serial & Label");
	printf("\r\n  (c)-Display Time/Date     (C)-Set Time/Date\r\n");
}

void display_file_commands(void)
{
	printf("\r\nOpen File Commands:");
	printf("\r\n  (1)-ftell               (2)-fseek");
	printf("\r\n  (3)-fgetc               (4)-ungetc");
	printf("\r\n  (5)-Read file till END  (6)-Write to File");
	printf("\r\n  (7)-Dump Buffer - HEX   (8)-Dump Buffer - ASCII");
	printf("\r\n  (9)-fflush              (0)-fclose");
	printf("\r\n  (E)-Free File Memory\r\n");
}
                                
void flush_receive(void)
{
	while (rx_counter0)
		getchar();
}                          
                          
int get_input_str(char *input_str, int max_size)
{
	int i;
	char c;           

	for (i=0; i<max_size;)
	{
    	c = getchar();
        if ((c=='\n')||(c=='\r'))	// if its a Line Feed
		{
			*input_str = '\0';		// null terminate the string and 
			return i;				// return the length
		}                            
		else if (c == 8)			// backspace
		{
			if (i > 0) 
			{
				putchar(c);
				putchar(' ');
				putchar(c);
				input_str--;
				*input_str = '\0';
				i--;
			}
		}       
		else if (c == 0x1B)	   		// ESC
		{            
			*input_str = '\0';		// null terminate the string
			return 0;				// flag escape with 0 lenght 
		}
		else
		{
			putchar(c);
			*input_str++ = c;
			i++;             		// only increment on valid entries!
		}
	}        
	*input_str = '\0';	// null terminate       
	return i;
}
                                        
void set_date_time(void)
{                           
	char myinstr[25];
	char *next_str;
	int input_vals[6];
	char c;
	#ifdef _ICCAVR_
		char d_str[3], semi_str[4];
		cstrcpy(d_str, "%d");
		cstrcpy(semi_str, "/: ");
	#endif
	printf("\n\rSend Date and Time as mm/dd/yyyy hh:mm:ss[ENTER]\n\r");
	if (get_input_str(myinstr,20) == 0)
		return;         
	next_str = myinstr;
	for (c=0;((c<6) && (strlen(next_str) != 0));c++)                         
	{
		#ifdef _CVAVR_
			sscanf(next_str,"%d",&(input_vals[c]));
			// find next delimiter
			next_str = strpbrkf(next_str,"/: ");
		#else		
			sscanf(next_str, d_str,&(input_vals[c]));
			// find next delimiter
			next_str = strpbrk(next_str,semi_str);
		#endif
		// if not null, move past delimiter
		if (next_str != '\0')
			next_str++;
	}
//	rtc_set_time(input_vals[3], input_vals[4], input_vals[5]);
//    rtc_set_date(input_vals[1],input_vals[0],input_vals[2]);  
//    rtc_get_timeNdate(&rtc_hour, &rtc_min, &rtc_sec, &rtc_date, &rtc_month, (int *)&rtc_year);	    			
//    printf("\r\n%02d/%02d/%04d %02d:%02d:%02d", rtc_month,rtc_date,rtc_year,rtc_hour,rtc_min,rtc_sec);
}

void print_result(int result,char error_flag,int bad_compare_value)
{                 
	if (result != bad_compare_value)
		printf("\r\n - OK!");
	else
	{
		if (error_flag == 1)
	 		printf("\r\n - ERROR! - %X", _FF_error);
	 	else                                        
	 		printf("\r\n - ERROR!");	 	
	 }
}

long get_addr_entry(char addr_size)
{            	
	unsigned char test_char;
	unsigned long addr_sd;
	unsigned int n;
	
   	test_char = getchar();
	putchar(test_char);
    test_char = ascii_to_char(test_char);
    addr_sd = test_char;
    for (n=0; n<addr_size; n++)
    {
    	test_char = getchar();
        putchar(test_char);
        if (test_char == 0x8)
        {
        	n -= 2;
            addr_sd >>= 8;
        }
        else if ((test_char=='\r')||(test_char=='\n'))
        	return addr_sd;
        if (test_char == 0x1B)
        	return EOF;
    	test_char = ascii_to_char(test_char);
    	addr_sd = addr_sd << 4;
    	addr_sd |= test_char;
    }               
    return addr_sd;
}

void handle_level1(unsigned char test_char)
{                           
	unsigned char *pointer, sd_temp[14], sd_temp2[24], create_info[22], modify_info[22];
	unsigned int status, n;
	unsigned long addr_sd, c;
	char print_demo_flag;
	pointer = 0;
	print_demo_flag = 1;	// assume for now that we will recognize the command!
	
   	switch(test_char)
   	{	
   		case '$':
	  		#ifdef _DEBUG_ON_
    		printf("\r\nJumping to Bootloader");
    		while(tx_counter0);
    		#endif
//			#asm("jmp 0xFC00");
		   	break;
       	case '1':
       		printf("\r\nInitializing... ");
       		print_result(initialize_media(),0,0);
   			break;

   		#ifdef _DEBUG_ON_
   		case '2':
   			read_directory();
      		break;
       	#endif

       	#ifndef _READ_ONLY_
       	case '3':
       		printf("\r\nCreating File:  ");
			if (get_input_str(sd_temp2, 24) != 0)
			{

printf ("My  Point1");

   	    		file1 = fcreate(sd_temp2, 0);
printf ("My  Point2");
   	    		print_result((int)file1,1,NULL);
        		if (file1 != 0)
       				fclose(file1);
   			}
       		break;
       	case '4':
       		printf("\r\nDeleting File:  ");
			if (get_input_str(sd_temp2, 24) != 0)
				print_result(remove(sd_temp2),1,EOF);
       		break;
       	case '5':
       		printf("\r\nRename File:\r\n  Old Name:  ");
			if (get_input_str(sd_temp2, 24) != 0)
			{               
        		printf("\r\n  New Name:  ");
				flush_receive();    	// clear out any hanging characters from last entry
				if (get_input_str(sd_temp, 12) != 0)
    	       		print_result(rename(sd_temp2, sd_temp),1,EOF);
    		}
        	break;
       	#endif
       	case '6':
       		printf("\n\rOpen file:  ");
			if (get_input_str(sd_temp2, 24) != 0)
			{
          		printf("\r\nChoose:  (1)-READ  (2)-WRITE  (3)-APPEND");
				flush_receive();    	// clear out any hanging characters from last entry          		
       			status = getchar();
       			switch (status)
        		{
   	    			case '1':
       					printf("  -- READ");
       					file1 = fopen(sd_temp2, READ);
       					break;
        			case '2':
   	    				printf("  -- WRITE");
       					file1 = fopen(sd_temp2, WRITE);
       					break;
       				case '3':
       					printf("  -- APPEND");
        				file1 = fopen(sd_temp2, APPEND);
   	    				break;
       			}
       			if (file1==0)
       				printf("\r\nFileOpen Error = %x", _FF_error);
        		else
   	    		{
       				printf("\r\nSuccess!!!  -  %s - Opened! \r\n",sd_temp2);
       				menu_level = 2;
       				display_file_commands();
       				print_demo_flag = 0;
       			}
   			}
   			break;
       	case '7':
			printf("\r\nMake Directory:  ");
    		if (get_input_str(sd_temp2, 24) != 0)
    	    	print_result(mkdir(sd_temp2),0,EOF);
    	 	break;
		case '8':
       		printf("\r\nDelete Directory:  ");
    		if (get_input_str(sd_temp2, 24) != 0)
    	 		print_result(rmdir(sd_temp2),0,EOF);
        	break;
		case '9':
        	printf("\r\nChange Current Directory to:  ");
    		if (get_input_str(sd_temp2, 24) != 0)
    	    	print_result(chdir(sd_temp2),0,EOF);
          	break;
		case '0':
        	printf("\r\nGet File Info for:  ");
    		if (get_input_str(sd_temp, 12) != 0)
    		{
    	    	if (fget_file_info(sd_temp, &addr_sd, create_info, modify_info, pointer, &n)!=EOF)
        	    {
            		printf("\r\n  File Size:  %ld bytes\r\n  Create Time:  ", addr_sd);
            		puts(create_info);
            		printf("\r  Modify Time:  ");
            		puts(modify_info);
					printf("\r  Attributes:  0x%X\n", *pointer);
        	    	printf("\r  Starting Cluster:  0x%lX @ ADDR: 0x%lX\r\n", n, clust_to_addr(n));
     			}
            	else
            		printf("\r\n - ERROR! - %X\r\n", _FF_error);
        	}
            break;
        case 'F':
        	printf("\r\nQuick Format Card and delete all existing data?  (Y)es  (N)o\r\n  ");
            c = getchar();
            putchar(c);
            if ((c=='Y')||(c=='y'))
            {
            	printf("es - ");
            	print_result(fquickformat(),0,EOF);
            }
            else if ((c=='N')||(c=='n'))
            	printf("o - Cancelled\r\n");
            else
            	printf(" - Ivnalid Response - Cancelled\r\n");
            break;	
         case '-':
         	printf("\n\rRead MMC - Enter Address: ");
            addr_sd = get_addr_entry(7);
            if (addr_sd!=EOF)
            {
				printf("\n\rCalc. address: %lx", addr_sd);
    	   		_FF_read_disp(addr_sd);
    		}
       		break;
   		#ifndef _READ_ONLY_
   		case 'E':
   			_FF_error = 0;
   			break;
   		#ifdef _DEBUG_ON_
   		case 'N':
   			status = prev_cluster(0);
   			printf("\n\rFinding Next Avaliable Cluster:  [%X],  _FF_error = [%X]", status, _FF_error);
   			printf("\n\rLocated @ 0x%lX", clust_to_addr(status));
   			break;
   		case 'M':
   			printf("\r\nPoint Cluster: 0x");
   			addr_sd = get_addr_entry(4);
   			printf("\r\nTo Cluster: 0x");
   			status = get_addr_entry(4);
   			if (write_clus_table(addr_sd, status, SINGLE))
   				printf("  -  OK!!!");
   			else
   				printf("  -  ERROR!!!");
   			break;
   		#endif	
   		#endif         
#ifdef _SD_MMC_MEDIA_
   		case 'R':
			reset_sd();
        	break;
   		case 'I':
        	init_sd();
        	break;
#endif
		#ifdef _RTC_ON_
    	case 'c':
        	rtc_get_timeNdate(&rtc_hour, &rtc_min, &rtc_sec, &rtc_date, &rtc_month, (int *)&rtc_year);	    			
        	printf("\r\n%02d/%02d/%04d %02d:%02d:%02d", rtc_month,rtc_date,rtc_year,rtc_hour,rtc_min,rtc_sec);
        	break;
    	case 'C':
    		set_date_time();
    		break;
    	#endif
       	case 'V':
       		printf("\r\nVolume Serial Number and Label:");
       		GetVolID();
       		break;
    	default:
    		print_demo_flag = 0;
    		break;
    }                                                  
    // if this was a valid command, finish by printing the commands
	if (print_demo_flag == 1)
		display_demo_commands(); 
}


void handle_level2(unsigned char testchar)
{
	unsigned int status, c;
	unsigned long addr_sd;

	switch (testchar)
	{
    	case '1':
        	printf("\n\rftell:  position = 0x%lX", ftell(file1));
    		break;
		case '2':
    		printf("\n\rfseek:  Offset = 0x");
    		addr_sd = get_addr_entry(7);
    		if (addr_sd==EOF)
    			break;
			printf("=%lX\r\n    Mode:  (1)-SEEK_CUR  (2)-SEEK_END  (3)-SEEK_SET :", addr_sd);
    		status = getchar();
			switch (status)
			{
        		case '1':
			    	printf("  -- SEEK_CUR");
        			status = 0;
				    break;
    	   		case '2':
        			printf("  -- SEEK_END");
				    status = 1;
        			break;
			    case '3':
        			printf("  -- SEEK_SET");
			        status = 2;
        			break;
       		}
			print_result(fseek(file1, addr_sd, status),0,EOF);
			break;
		case '3':
        	putchar(fgetc(file1));
    		break;
      	case '4':
        	printf("\r\nEnter character to push back: ");
    		putchar(ungetc(getchar(), file1)); 
    		printf(" - OK!\r\n");
        	break;
  		case '5':
        	while (feof(file1)==0)
    			putchar(fgetc(file1));
        	break;
		#ifndef _READ_ONLY_
    	case '6':
        	printf("\r\nWrite to file:   Press [ESC] to end 'Write' mode\r\n");
    		status = getchar();
        	while (status!=0x1b)
    		{
        		if (fputc(status, file1)!=EOF)
    			{
        			if (status==0x08)
    	    		{	// Backspace pressed
    					ungetc('0', file1);
        				ungetc('0', file1);
        			}
    				putchar(status);
    		    	status = getchar();
    			}
    		    else
    			{
    		    	printf("\r\nWrite ERROR!!!");
    				status = 0x1b;					// exit the while loop
    			}
			}
			break;
   		#endif
    	case '7':
        	dump_file_data_hex(file1);
			break;
		case '8':
        	dump_file_data_view(file1);
			break;
		#ifndef _READ_ONLY_
        case '9':
    		printf("\n\rFile Flushing...");
      		print_result(fflush(file1),0,EOF);
			break;
   		#endif
    	case '0':
    		printf("\n\rFile Closing...");  
    		status = fclose(file1);
        	print_result(status,0,EOF);
        	if (status==0)
        		file1 = NULL;
			break;
		case 'E':
        	printf("\r\nClose File w/o saving buffered data?  (Y)es  (N)o\r\n  ");
            c = getchar();
            putchar(c);
            if ((c=='Y')||(c=='y'))
            {
            	printf("es - ");
            	print_result(ffreemem(file1),0,EOF);
        		file1 = NULL;
            }
            else if ((c=='N')||(c=='n'))
            	printf("o - Cancelled\r\n");
            else
            	printf(" - Ivnalid Response - Cancelled\r\n");
            break;	
	}
	if (file1 == NULL) 
	{
		menu_level = 1;
		display_demo_commands();
	}
	else if ((testchar != '0') && (testchar != '3'))
		display_file_commands();
}

extern char _bss_end;

main()
{
 	unsigned char test_char;
	
	init_devices();

	#ifdef _ICCAVR_
		_NewHeap(&_bss_end + 1, &_bss_end + 701);
	#endif
	
//	twi_setup();    

	menu_level = 1;
	printf("\r\nMicrocontroller Reset!!!\r\n");
	printf("\r\nPress '1' to initialize media:");

	test_char = 1;
	while (test_char != '1')
	{
		test_char = getchar();
                putchar (test_char);
	}
	while (initialize_media()==0)
	{
		printf("\r\n  ERROR!!!\r\n");
		printf("\r\nPress '1' to initialize media:");
		while (getchar()!='1')
			;
	}
	printf("\r\n  OK!!!");
	display_demo_commands();
	
	while (1)
    {
    	// Place your code here
/*	    if (rx_counter1)
	    {
	    	if (getchar1()==0x24)
	    	{
		    	#ifdef _DEBUG_ON_
		    		printf("\r\nJumping to Bootloader");
			    	while(tx_counter1);
		    	#endif
//	    		#asm("jmp 0xFC00");
	    	}
	    }
*/	    if (rx_counter0)
	    {
	    	test_char = getchar();
	    	if (menu_level == 1)
	    		handle_level1(test_char);
	    	else
	    		handle_level2(test_char);
	    }
    }
	return (0);
}
