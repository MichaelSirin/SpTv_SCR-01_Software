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

#ifndef _file_sys_h_
	#define _file_sys_h_

	#ifndef NULL
		#define NULL	0
	#endif
	#ifndef EOF
		#define EOF		-1
	#endif

	typedef struct
	{	// 552 bytes (+4 overhead using malloc) ==>  556 bytes required per file opened
		unsigned char name[12];			// Filename as 8.3 0x20-padded string
		unsigned int clus_start;		// Starting cluster of open file
		unsigned int clus_current;		// Current cluster of open file
		unsigned int clus_next;			// Next (reading) cluster of open file
		unsigned int clus_prev;			// Previous cluster of open file
		unsigned int sec_offset;		// Current sector withing current cluster
		unsigned long entry_sec_addr;	// Sector address of File entry of open file
		unsigned int entry_offset;		// Entry addr offset within sector for open file
		unsigned char buff[512];		// Open file read/write buffer
		unsigned long length;			// Length of file
		unsigned long position;			// Current position in file relative to begining
		unsigned char mode;				// 0=>closed, 1=>open for read, 2=>open for write, 3=> open for append
		unsigned char error;			// Error indicator
		unsigned char EOF_flag;			// End of File Flag
		unsigned char *pntr;			// Pointer for file data use
	} FILE;
	
	enum {NO_ERR=0, INIT_ERR, FILE_ERR, WRITE_ERR, READ_ERR, NAME_ERR, READONLY_ERR,
		SOF_ERR, EOF_ERR, ALLOC_ERR, POS_ERR, MODE_ERR, FAT_ERR, DISK_FULL, 
		PATH_ERR, NO_ENTRY_AVAL, EXIST_ERR};
	enum {CLOSED=0,READ, WRITE, APPEND};
	#define ATTR_READ_ONLY	0x01
	#define ATTR_HIDDEN		0x02 
	#define ATTR_SYSTEM		0x04
	#define ATTR_ARCHIVE	0x20
	enum {CHAIN, SINGLE, END_CHAIN};
	enum {SEEK_CUR, SEEK_END, SEEK_SET};

	unsigned char ascii_to_char(unsigned char ascii_char);
	int valid_file_char(unsigned char file_char);
	#ifdef _DEBUG_ON_
		void read_directory(void);
		void dump_file_data_hex(FILE *rp);
		void dump_file_data_view(FILE *rp);
	#endif
	void GetVolID(void);
	unsigned long clust_to_addr (unsigned int clust_no);
	unsigned int addr_to_clust(unsigned long clus_addr);
	unsigned int next_cluster(unsigned int current_cluster, unsigned char mode);
	#ifndef _READ_ONLY_
		unsigned int prev_cluster(unsigned int clus_no);
		unsigned char write_clus_table(unsigned int current_cluster, unsigned int next_cluster, unsigned char mode);
		unsigned char append_toc(FILE *rp);
		unsigned char erase_clus_chain(unsigned int start_clus);
		int fquickformat(void);
		FILE *fcreatec(unsigned char flash *NAMEC, unsigned char MODE);
		FILE *fcreate(unsigned char *NAME, unsigned char MODE);
		int removec(unsigned char flash *NAMEC);
		int remove(unsigned char *NAME);
		int rename(unsigned char *NAME_OLD, unsigned char *NAME_NEW);
		int mkdir(char *F_PATH);
		int rmdir(char *F_PATH);
		int ungetc(unsigned char file_data, FILE *rp);
		int fputc(unsigned char file_data, FILE *rp);
		int fputs(unsigned char *file_data, FILE *rp);	
		int fputsc(flash unsigned char *file_data, FILE *rp);
#ifdef _CVAVR_
void fprintf(FILE *rp, unsigned char flash *pstr, ...);
#endif
#ifdef _ICCAVR_
void fprintf(FILE *rp, unsigned char flash *pstr, long var);
#endif
		int fflush(FILE *rp);
	#endif
	unsigned char *file_name_conversion(unsigned char *current_file);
	FILE *fopenc(unsigned char flash *NAMEC, unsigned char MODEC);
	FILE *fopen(unsigned char *NAME, unsigned char MODE);
	int fclose(FILE *rp);
	int ffreemem(FILE *rp);
	int chdirc(char flash *F_PATH);
	int chdir(char *F_PATH);
	int _FF_chdir(char *F_PATH);
	int fget_file_info(unsigned char *NAME, unsigned long *F_SIZE, unsigned char *F_CREATE,
		unsigned char *F_MODIFY, unsigned char *F_ATTRIBUTE, unsigned int *F_CLUS_START);
	int fget_file_infoc(unsigned char flash *NAMEC, unsigned long *F_SIZE, unsigned char *F_CREATE,
		unsigned char *F_MODIFY, unsigned char *F_ATTRIBUTE, unsigned int *F_CLUS_START);
	int fgetc(FILE *rp);
	char *fgets(char *buffer, int n, FILE *rp);
	int fend(FILE *rp);
	int fseek(FILE *rp, unsigned long off_set, unsigned char mode);
	long ftell(FILE *rp);
	int feof(FILE *rp);

#endif