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

// Declare your global variables here
unsigned char twi_status, twi_rtc;    
extern unsigned int rtc_year;

void twi_setup(void)
{
	TWBR = 0x1F;    
	TWCR = 0x04;
}

char twi_step(unsigned char twcr_mask, unsigned char status)
{           

	TWCR = twcr_mask | TWI_ENABLE;          
	if (status != TWI_NO_WAIT)
	{
		twi_rtc = 0;
		while(((TWCR & 0x80) == 0) && (twi_rtc < 100))
			;                                      
         
		twi_status = (TWSR & 0xFC);                            
		
		if ((status != TWI_IGNORE_STATUS) && ((twi_status != status) || ((TWCR & 0x80) == 0)))
		{
			TWCR = TWI_SEND_STOP | TWI_ENABLE;
			twi_rtc = 0;
			while(((TWCR & 0x80) == 0) && (twi_rtc < 100))
				;        
			return TWI_ERROR;
		}
	}		
	return TWI_SUCCESS;
}

char twi_read(char addr, char num_bytes,unsigned char *pntr)
{        
	char cnt;      
    if (twi_step(TWI_SEND_START,0x08) != TWI_SUCCESS)
    	return TWI_ERROR;
	
	TWDR = 0xA2; 	// put in the address of the pfc
    if (twi_step(TWI_CLOCK_DATA, 0x18) != TWI_SUCCESS)
    	return TWI_ERROR;
    	
	TWDR = addr;	// put in word address
	if (twi_step(TWI_CLOCK_DATA,0x28) != TWI_SUCCESS)
		return TWI_ERROR;
	
	if (twi_step(TWI_SEND_START,0x10) != TWI_SUCCESS)	   // send start......
		return TWI_ERROR;
		
	TWDR = 0xA3; 	// put in the address of the pfc for read
	if (twi_step(TWI_CLOCK_DATA,0x40) != TWI_SUCCESS)
		return TWI_ERROR;
		                                                   
	for (cnt=0;cnt<num_bytes;cnt++)
	{
		if (cnt != (num_bytes-1))
		{
			if (twi_step(TWI_ACK_DATA,TWI_IGNORE_STATUS) != TWI_SUCCESS)
				return TWI_ERROR;                
		}
		else
		{
			if (twi_step(TWI_CLOCK_DATA,TWI_IGNORE_STATUS) != TWI_SUCCESS)
				return TWI_ERROR;                
		}
		
		*pntr = TWDR;                              
		pntr++;
	}
	
	twi_step(TWI_SEND_STOP,TWI_NO_WAIT);	// send stop
	
	return TWI_SUCCESS;			   

}   

char twi_write(char addr, char num_bytes, unsigned char *pntr)
{                                                            
	char cnt;
	if (twi_step(TWI_SEND_START,0x08) != TWI_SUCCESS)
		return TWI_ERROR;
		
	TWDR = 0xA2; 	// put in the address of the pfc
	if (twi_step(TWI_CLOCK_DATA,0x18) != TWI_SUCCESS)
		return TWI_ERROR;

	TWDR = addr;	// put in word address
	if (twi_step(TWI_CLOCK_DATA,0x28) != TWI_SUCCESS)
		return TWI_ERROR;              
		
	for (cnt=0;cnt<num_bytes;cnt++)
	{                     
		TWDR = *pntr++;     
		if (twi_step(TWI_CLOCK_DATA,0x28) != TWI_SUCCESS)
			return TWI_ERROR;                
	}
	twi_step(TWI_SEND_STOP,TWI_NO_WAIT);		
		
	return TWI_SUCCESS;
}

char _FF_bin2bcd(char binval)
{
 	unsigned char temp_val;
	
	if (binval>99)
	   return(EOF);

	temp_val = binval / 10;
	temp_val <<= 4;
	temp_val |= (binval % 10) & 0x0F;
	
	return (temp_val);	
}
                 
char rtc_set_time(char hour, char min, char sec)
{             
	unsigned char time_array[3];
	char ret_val;
	time_array[0] = _FF_bin2bcd(sec) | 0x80;
	time_array[1] = _FF_bin2bcd(min);
	time_array[2] = _FF_bin2bcd(hour);
	_FF_cli();
	ret_val = twi_write(0x02,3,time_array);
	_FF_sei();
	return(ret_val);
}
                                 

char rtc_set_date(char date, char month, int year)
{                                                   
	unsigned char date_array[4];                                                                                                 
	char ret_val;
	date_array[0] = _FF_bin2bcd(date);                                                                                               
	date_array[1] = 0;
	date_array[2] = _FF_bin2bcd(month);
	if (year > 1999)
	{
		date_array[2] |= 0x80;
		year -= 2000;
	}
	else if (year > 1900)
		year -= 1900;    
	date_array[3] = _FF_bin2bcd((unsigned char) year);
	_FF_cli();
	ret_val = twi_write(0x05,4,date_array);
	_FF_sei();
	return(ret_val);
}

char _FF_bcd2bin(char bcdval)
{
 	unsigned char temp_val;
	
	temp_val = ((bcdval >> 4) & 0x0F) * 10;
	temp_val += (bcdval & 0x0F);
	
	return (temp_val);
}

char rtc_get_timeNdate(char *hour, char *min, char *sec,char *date, char *month, int *year)
{
	unsigned char time_array[8];
	char ret_val;
    ret_val = twi_read(0x02,7,time_array);
	
	if (ret_val != TWI_SUCCESS)
		return TWI_ERROR;

	twi_read(0x02,7,time_array);
	
	*sec = _FF_bcd2bin(time_array[0] & 0x7F);
	*min = _FF_bcd2bin(time_array[1] & 0x7F);
	*hour = _FF_bcd2bin(time_array[2] & 0x3F);
	*date = _FF_bcd2bin(time_array[3] & 0x3F);
	*month = _FF_bcd2bin(time_array[5] & 0x1F);
		
		
	*year = _FF_bcd2bin(time_array[6]);
	if (time_array[5] & 0x80)
		*year += 2000;
	else
		*year += 1900;
		
 	return ret_val;	
 	
}
                      