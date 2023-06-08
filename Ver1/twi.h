/*
	Progressive Resources LLC
                                    
			FlashFile
	
	Version : 	1.32
	Date: 		12/31/2003
	Author: 	Erick M. Higa
                                           
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
*/                                 

#ifndef _TWI_H_
	#include <stdio.h>
	#include <stdlib.h>
	#include <ctype.h>

	#define _TWI_H_

	// Declare your global variables here
	#define TWI_ENABLE			0x04	
	#define TWI_SEND_START		0xA0
	#define TWI_SEND_STOP		0x90
	#define TWI_CLOCK_DATA		0x80  
	#define TWI_ACK_DATA		0xC0
	#define TWI_IGNORE_STATUS	0xFF
	#define TWI_NO_WAIT			0xFE                   
	
	#define TWI_SUCCESS			0
	#define TWI_ERROR           1

	#define _FF_cli()			SREG &= 0x7F;
	#define _FF_sei()			SREG |= 0x80;
	 
	void twi_setup(void);
	char twi_step(unsigned char twcr_mask, unsigned char status);
	char twi_read(char addr, char num_bytes,unsigned char *pntr);
	char twi_write(char addr, char num_bytes, unsigned char *pntr);
	char rtc_set_time(char hour, char min, char sec);
	char rtc_set_date(char date, char month, int year);
	char rtc_get_timeNdate(char *hour, char *min, char *sec,char *date, char *month, int *year);

//	#include "..\flash\twi.c"
#endif