

#include "Coding.h"

void flash_Work (void)
	{  
		unsigned char a;
		switch(rx0buf[0])
			{
				case PT_Fcreate: 		// ������� � ������� ����
					{       
LedRed();

						pntr1 = fcreate(str->fname, 0); 

						if (!(pntr1)) putchar (0); 						// ���� �� ���� ������� ���� �� ��������� 0
						else putchar (0x255);

//						fputc('S', pntr1);      // write an �S� to the file, increment file pointer */ 
//						fputs(str->fname, pntr1);    // add �Hello World!\r\n� to the end of the file 
 
						break;
					}
				case PT_Fopen: 		// ������� ����
					{       
					
						break;
					}

				case PT_Fclose:
					{
LedRed();
					    fclose(pntr1);     							   	// Close          

						if (!(pntr1)) putchar (0); 						// ���� �� ���� ������� ���� �� ��������� 0
						else putchar (0x255);
						break;
					}

				case PT_Fremove:
					{
						break;
					}

				case PT_Frename:
					{
						break;
					}

				case PT_Ffseek:
					{
						break;
					}

				case PT_Fformat:
					{
						fquickformat();    			// Delete all information on the card 
						break;
					}

				case PT_Fadd:
					{
LedRed();
//						fputs(str1->dataFlash, pntr1);    // add �Hello World!\r\n� to the end of the file 
//						fprintf(pntr1, "%x",11);  			// output the string to the file

//						strcpyf (a,0x31);
						fflush (pntr1);

						if (!(pntr1)) putchar (0); 						// ���� �� ���� ������� ���� �� ��������� 0
						else putchar (0x255);
						break;
					}

    		}
	rx0state = RX_HDR;						// �������� ����� ����. �������
	}



	