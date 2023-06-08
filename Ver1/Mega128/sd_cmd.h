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

#ifndef _sd_cmd_h_
	#define _sd_cmd_h_
	enum	{CMD0=0, CMD1, CMD9, CMD10, CMD12, CMD13, CMD16,
			CMD17, CMD18, CMD24, CMD25, CMD27, CMD28, CMD29,
			CMD30, CMD32, CMD33, CMD34, CMD35, CMD36, CMD37,
			CMD38, CMD42, CMD58, CMD59, ACMD41, CMD_TOT};

	enum	{GO_IDLE_STATE=0, SEND_OP_COND, SEND_CSD, SEND_CID,
			STOP_TRANSMISSION, SEND_STATUS, SET_BLOCKLEN,
			READ_SINGLE_BLOCK, READ_MULTIPLE_BLOCK, WRITE_BLOCK,
			WRITE_MULTIPLE_BLOCK, PROGRAM_CSD, SET_WRITE_PROT,
			CLR_WRITE_PROT, SEND_WRITE_PROT, TAG_SECTOR_START,
			TAG_SECTOR_END, UNTAG_SECTOR, TAG_ERASE_GROUP_START,
			TAG_ERASE_GROUP_END, UNTAG_ERASE_GROUP, ERASE,
			LOCK_UNLOCK, READ_OCR, CRC_ON_OFF};
			
	enum	{RESP_1, RESP_1b, RESP_2, RESP_3};
	
	enum	{NO_ARG, BLOCK_LEN, DATA_ADDR, STUFF_BITS};

	// unsigned int CRCCCITT(unsigned char *data, unsigned long length,
	//				      unsigned int seed, unsigned int final);
	unsigned int send_cmd(unsigned char command, unsigned long argument);
	unsigned char reset_sd(void);
	unsigned char init_sd(void);
	unsigned char _FF_read_disp(unsigned long sd_addr);
	unsigned char _FF_read(unsigned long sd_addr);
	unsigned char initialize_media(void);
	#ifndef _READ_ONLY_
		unsigned char _FF_write(unsigned long sd_addr);
	#endif

#endif	