///////////////////////////////////////////////////////
// ������ ������ � CF CARD

#include "Coding.h"    

#define FLASH_command 	rx0buf[0]
#define appendAbon			1						// �������� �������� 
#define deleteAbon			2						// ������� ��������
#define pack_for_scremb	3						// ����� ������
#define pack_readAbons	4						// ��������� ���������� ��������

FILE * fu_user = NULL;	//����������� ���������� ��� ��������� �������� ����� s userami


// �������� �������� ����� prog.bin � ������ 
void check_fprog (void)
{
	u8 temp = 0;
	eefprog = f_buff_prog; 
		
	while (temp ++ < len_prog_bin)
	{
		*eefprog ++ = rx0buf [temp];
/*		#ifdef print
		printf("dann=%02x ",rx0buf [temp]);
 		#endif       */
	}
}


typedef union
{
	u32 w;
	u8 b[4];
} B2DW;

// ��������������� 4����� � 1 ����� (32���)
u32 convTOw32 (u8 *pConv)
{
	B2DW out_W;  
	
	out_W.b[0] = *pConv++;			// 
	out_W.b[1] = *pConv++;
	out_W.b[2] = *pConv++;
	out_W.b[3] = *pConv;        

	return out_W.w;
}



// ����������� ��������
u8 format_CF (void)
{  
		#ifdef print
		printf ("Format CF... ");
		#endif
	if (fquickformat() == EOF)
	{
		#ifdef print
		printf ("ERROR \r\n");
		#endif
		 return FALSE; 
	 }
	else
	{
		#ifdef print
		printf ("OK \r\n");
		#endif

		 return TRUE;           
	 }
}                       



// �������� / �������� ������
u8 append_abons (void)
{
	u8 temp;
	
	for (temp = 0; temp < dann_1_abon; temp++)
	{
		if ((fputc (rx0buf[temp+9], fu_user)) == EOF) return FALSE;
	}
	
		#ifdef print
		printf ("Append abons \r\n");
		#endif

	return TRUE;
}                                                  

// ������� ������                           
u8 delete_abons (void)
{                    
	u8 temp;
	

	for (temp = 0; temp < 4; temp++)
	{
		if ((fputc (0xFF, fu_user)) == EOF) return FALSE;
	}                               
	
		#ifdef print
		printf ("Del abons \r\n");
		#endif

	
	return TRUE;
}

// ������ ������ � ���������� ���������
u8 define_abons (void)
{

	if (fseek (fu_user,0,SEEK_SET) != EOF) 
	{
		if ((fputc (rx0buf[1], fu_user)) != EOF) 
			if ((fputc (rx0buf[2], fu_user)) != EOF) 
				if ((fputc (rx0buf[3], fu_user)) != EOF) 
					if ((fputc (rx0buf[4], fu_user)) != EOF)
					{
						#ifdef print
						printf ("WR count abons \r\n");
						#endif

						return TRUE;
					}
	}

	return FALSE;

}


// ����� ������� � �����. 
u8 found_location_in_file (u8 *pLoc)
{
  	u32 position = 0;

/*	position = ( 													// ������� � �����
					((position | rx0buf[8]) <<24) |
     				((position | rx0buf[7]) <<16) |
					((position | rx0buf[6]) << 8) |
					  (position | rx0buf[5]) );  
  */
	position = convTOw32 (pLoc);				// �������� 32 ���� ��������� �� �������

	position = ((position - 1) * dann_1_abon) + 4;		//���������� ��������� 4 �����

	//���� ���� �� �������� �� ������ ������� 0XFF
	while  ( ftell (fu_user) < position)
	{
		fputc (0xFF,fu_user);							
	}
	

	if ( ! define_abons()) return FALSE;				// ������ ������ � ���������� ���������

	if (fseek (fu_user,position,SEEK_SET) == EOF) return FALSE; //��������

		#ifdef print
		printf ("Position found-%x \r\n",position);
		#endif

	switch (FLASH_command)
	{
		case appendAbon:
				if ( ! append_abons ()) return FALSE;		// ��������/�������� ������
				break;

		case deleteAbon:
				if ( ! delete_abons ()) return FALSE;		// ������� ������
				break;

		default:
				return FALSE;
	}

	return TRUE;
}

// ��������� ����
u8 close_prog_bin (void)
{

	if (fclose (fu_user) == EOF) return FALSE;											// ��������� ����

	#ifdef print
	printf ("File CLOSE \r\n");
	#endif

	return TRUE;
	
}


// ��������� ���� ��� ������ / ������
u8 open_user_bin (u8 mode)
{
	u8 temp = 4;

	if (prog_bin_mode != (mode & 0x1)) close_prog_bin ();	// ��������� ���� ��� ��������� ������
	else 
	{
		if ( ftell(fu_user) != EOF )	return TRUE;					// ����� ��������� ���� �� ���� � ������� ���� ����
	}

	if ( mode == rd_file)
	{
		fu_user = fopenc("user.bin", READ);			

		if (fu_user == NULL)												
		{
			#ifdef print
			printf ("Open ERROR! \r\n");
			#endif
			return FALSE;
		}

		#ifdef print
		printf ("File OPEN read \r\n");
		#endif

	}
	else
	{
		fu_user = fopenc("user.bin", APPEND);			

		if (fu_user == NULL)												
		{
			#ifdef print
			printf ("Create NEW file \r\n");
			#endif

//			if (fquickformat() == EOF) return FALSE;		//����� ��������� ����� ����������� �����
			fu_user = fcreatec ("user.bin",0);

			if (fu_user == NULL )                                 // ������
				return FALSE;

			while ( temp--)  	fputc (0x00,fu_user);							// ����� ��� ���������� ���������
		}                                             
        
		#ifdef print
		printf ("File OPEN write \r\n");
		#endif

	}
	
	prog_bin_mode = mode & 0x1;

	return TRUE;
}


//������ ��������� ��������
// ������� �������� - MAC �������, �������� - ��������� �� 
// ������ � ������������
u8 read_abons (u32 MACabons)
{
  	u32 position = 0;			// ������� � �����
  	u32 pos = 0+1;	
  	u32 a;			      
	u32 	countAbons;


  	MACabons = (MACabons - 1)*2;

	if ( open_user_bin (rd_file) )	 		// ��������� ����
	{
		countAbons = getAbons ();			// ���������� ��������� ���������	

		while ( countAbons --)
		{
			position = pos++;				// �������� 32 ���� ��������� �� �������
			position = ((position - 1) * dann_1_abon) + 4;		//���������� ��������� 4 �����

			if ( fseek (fu_user,position,SEEK_SET) != EOF)  //��������
			{
					a = fgetc(fu_user);
					a |= fgetc(fu_user)*256;
					a |= fgetc(fu_user)*256*256;
					a |= fgetc(fu_user)*256*256*256;         

					if (a == MACabons)
					{
						StartReply(dann_1_abon);         		// ��������

						putchar0(a);						// MAC �����
						putchar0(a>>8);
						putchar0(a>>16);
						putchar0(a>>24);

	 					for (a = 0; a<(dann_1_abon - 4); a ++)		// ������
						{
							if (feof(fu_user)) 
							{
								putchar0 (0);
								#ifdef print
								printf ("Error READ! \r\n");
								#endif    
							}
							else
							{
//								#ifdef print
//								printf ("%x ",fgetc(fu_user));
//								#endif    

								putchar0(fgetc(fu_user));
							}
						}
						EndReply();
						return TRUE;
					}
			}
		}
	
		#ifdef print
		printf ("readAbons NOT Found! \r\n");
		#endif    

    }
	return FALSE;
}




///////////////////////////////////////////////////////////////////
// ������ �������� ������: 
//		1 - ����� ������� (	1 - �������� ��������, 
//										2 - ������� ��������, 
//										3 - ���������� ������ �������(���������/�����������)
//										4 - ��������� ���������� �������� (�������  4b MAC);
//										5 - ������� ������� ����� � ��� ���������� �� ��������
//										)
//		2...5 - ������������ �������� ������ �����;
//		6...9 - ����� ����� ���� ���������� ������;
//		10...13 - ��� ����� ��������;
//		14...137 - ���������� ��� �������� � �����;
//  ��� �������� �� ����� - 	1...4 - ������������ �������� ������ �����;
//												5...8 -  ��� ����� ��������;
//												9...132 - ���������� ��� �������� � �����;

void flash_Work (void)
{  
//	u8 status = TRUE;  	
  
	if ( ! CF_card_INI_OK ) Reply(FALSE);	// CF ����� �� ������ 
	else
	{
		switch (FLASH_command)
		{
			case appendAbon:							// �������� � �������� ������
			case deleteAbon:							// ��������� ����. ���� ����� ��� - �������.
				#ifdef print
				printf ("Rx pack user.bin \r\n");
				#endif    
				if ( open_user_bin (wr_file) ) 
				{
					if (found_location_in_file(&rx0buf[5]) )
					{
						open_user_bin (rd_file);							// ��������� �� ������ (prog.bin)
					 	Reply (TRUE);                                      // ������� ����. ���� � ����� ��������. ����� �� ��������
					 }
					else 
					{
						open_user_bin (rd_file);							// ��������� �� ������ (prog.bin)
						Reply (FALSE); 
					}
				}
				else Reply (FALSE);

				break;

			case pack_for_scremb:  				// �������� � ������� ��� ������
				#ifdef print
				printf ("Rx pack for coder \r\n");
				#endif    

				check_fprog();
				Reply(TRUE);
				break;

			case pack_readAbons:
				#ifdef print
				printf ("Rx pack readAbons \r\n");
				#endif    
		
				if (! read_abons (convTOw32 (&rx0buf[5]))) Reply (FALSE);                             

				break;

			default:
				break;
		}
	}


/*
	// �������� � ������� ��� ������
	if (FLASH_command == pack_for_scremb)
	{
		#ifdef print
		printf ("Rx pack for coder \r\n");
		#endif    

		check_fprog();

		return TRUE;		
	}

	if ( ! CF_card_INI_OK ) return FALSE;		// CF ����� �� ������ 
	
	if (FLASH_command == pack_readAbons)
	{                                                           
		#ifdef print
		printf ("Rx pack readAbons \r\n");
		#endif    
		
		if (! read_abons ()) return FALSE;                             
		else return TRUE;
		
	}


	// �������� � �������� ������
	// ��������� ����. ���� ����� ��� - �������.
	#ifdef print
	printf ("Rx pack user.bin \r\n");
	#endif    

	if ( !open_prog_bin (wr_file) ) return FALSE;

	if (! found_location_in_file(&rx0buf[5]) ) status = FALSE;
	else status = TRUE; 

	open_prog_bin (rd_file);							// ��������� �� ������ (prog.bin)

	return status;	*/
}



	