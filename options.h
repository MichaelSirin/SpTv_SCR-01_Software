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

#ifndef _OPTIONS_H_
// Control Block //
//	#define _RTC_ON_
	#define _SECOND_FAT_ON_
	#define _FAT12_ON_
//	#define _READ_ONLY_
	#define _DEBUG_ON_
	#define _OPTIONS_H_

	// The settings below should be modified
	// to match your hardware/software settings
	#define _CVAVR_
//	#define _ICCAVR_
	
	#define _SD_MMC_MEDIA_
//	#define _CF_MEDIA_

//	#define _MEGA128DEV_	
	
	#ifdef _SD_MMC_MEDIA_
		#ifdef _MEGA128DEV_
			#define SD_CS_OFF()		PORTD |= 0x40
			#define SD_CS_ON()		PORTD &= 0xBF
			#define CS_DDR_SET()	DDRD |= 0x40
		#else
			#define SD_CS_OFF()		PORTB |= 0x10
			#define SD_CS_ON()		PORTB &= 0xEF
			#define CS_DDR_SET()	DDRB |= 0x10
		#endif
	#endif
	#ifdef _CF_MEDIA_
		#define cf_data_out	PORTA
		#define cf_data_in	PINA
        #define cf_data_ddr	DDRA
		
		#define cf_addrport	PORTB

//		#define CE1		PORT.5
//		#define CD1		PINC.4
//		#define RESET	PORTC.7
//		#define OE		PORTC.6
//		#define WE		PORTG.0
//		#define RDY		PINC.3 

		#define CD1		(PINC & 0x10)
		#define RDY		(PINC & 0x08) 
        
		#define RESET_LO()	PORTC &= 0xEF;
		#define RESET_HI()	PORTC |= 0x80;
		#define WE_LO()		PORTG &= 0xFE;
		#define WE_HI()		PORTG |= 0x01;
		#define OE_LO()		PORTC &= 0xBE;
		#define OE_HI()		PORTC |= 0x40;

	#endif
	
	#define _FF_MAX_FPRINT		100
	#define _FF_PATH_LENGTH		100
	
	#ifndef _READ_ONLY_
		#include <stdio.h>
	#endif
	#ifdef _CVAVR_
		#define _AVR_LIB_	<mega128.h>
		#define CLI()	#asm("cli")
		#define SEI()	#asm("sei")
	#endif
	#ifdef _ICCAVR_
		#ifndef _AVR_LIB_
			#define _AVR_LIB_	<iom128v.h>
		#endif
		#include <macros.h>
		#define		printf			cprintf
	#endif
	#include _AVR_LIB_
	#include <stdlib.h>
	#include <stdarg.h>
	#include <ctype.h>
	#include <string.h>
	
	#ifdef _SD_MMC_MEDIA_
		#include <sd_cmd.h>
	#endif
	#ifdef _CF_MEDIA_
		#include <cf_cmd.h>
	#endif
	#include <file_sys.h>
	#ifdef _RTC_ON_
		#include <twi.h>
	#endif
	#ifdef _SD_MMC_MEDIA_
		#include <sd_cmd.c>
	#endif
	#ifdef _CF_MEDIA_
		#include <cf_cmd.c>
	#endif
	#include <file_sys.c>
	#ifdef _RTC_ON_
		#include <twi.c>
	#endif
#endif
