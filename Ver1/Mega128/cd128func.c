#include "Coding.h"

unsigned char flagTWI				=	0;
unsigned char int_Devices		=	0;			// ���������� ����������� ���������



// ������������� �������
void portInit (void)
		{
			DDRB.7 = 1;		// testpin
			CS_DDR_SET();	// ��� CF Card
		}



// -------------------- ������� ������ � �������� 0 -------------------------------
///////////////////////////////////////////////////////////////////////////////////////////////
// Timer/Counter 0 initialization ; Clock source: System Clock
// Clock value: 31,250 kHz ;  Mode: Normal top=FFh
///////////////////////////////////////////////////////////////////////////////////////////////
void timer_0_Init  (void)
	{
		ASSR=0x00;
		TCCR0=0x0;        //0x06 -start
		TCNT0=0x01;
		OCR0=0x00;

		TIMSK=0x01;			// Timer(s)/Counter(s) Interrupt(s) initialization
		ETIMSK=0x00;

	}

// ��������� ������ ��� ��������
void timeOut (void)
	{
//		flagTWI  = (flagTWI  ^ (1 << time_is_Out));		// ����� ��������
		TCNT0=0x0	;														// �������� �������
		TCCR0 = 0x06;													// ������� ������ (����� 10 ��)
	}

// ��������� ������� ��� ��������
void timeOutStop (void)
	{
		TCCR0 = 0x0; 						// �������� ������� (����� 10 ��)
	}


// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
		TCCR0 = 0x0;						//������������� ������
		flagTWI  = flagTWI  | (1 << time_is_Out);	 //������� �������    

}
                                                                                             
// ��������� ���������� ����������� ���������
void verIntDev (void)
	{
		unsigned char a;
		for (a=1; a<10;a++)				// ��������� ���������� ����������� ��������� 
			{											//  ������ ���������� � 1
				if (!(txTWIbyte ( a, 0xaa))) break;   
			}
        int_Devices = a-1;
		lAddrDevice[0] = lAddrDevice;	// ���������� ���-�� ������ 232
	}     
	
// ������� �� ��������� ������
unsigned char rxCRC (void)
	{                    
		unsigned char KS = 0, a;		
			for (a=0; a< rxBuffer [0] ;a++)
				{
					KS =KS+rxBuffer [a];
				}                                     
			if (KS == rxBuffer [a]) return 255; 	//Ok
			else return 0;                                         // Error
		
	}	        

// ���������� ���������� ������ ���������
void ReadLogAddr (void)
		{          
		unsigned char b;
		
					txBuffer[0] = 'q';								// ���������
					txBuffer[1] = 3;		                 		// �����
					txBuffer[2] = 0;                   		// �����
					txBuffer[3] = GetLogAddr;       		// ���
					txBuffer[4] = 'q'+3+0+GetLogAddr; 		//KC

for (b=1; b<= int_Devices; b++)
	{
					txTWIbuff (b);		//�������� 
					delay_ms (20);          
					rxTWIbuff (b);
//putchar (b);
//putchar (rxBuffer[1]);					
					lAddrDevice [b] = rxBuffer[1];		// ���������� ���. ������ ������       
     }
				
}  

// ������������� �����
void		recompPack (unsigned char device)
	{
		unsigned char a, b=0;
					txBuffer[0] = PACKHDR;				// ���������
					txBuffer[1] = rx0len+3;            		// ����� (+3 - ��. ������� ��� ������)
					txBuffer[2] = rx0addr;                 	// �����
					txBuffer[3] = rx0type;					// ���

					for (a=4; a<=(rx0len+4); a++)
						{
							txBuffer[a] = rx0buf 	[b++];				
						}                   

					txTWIbuff (device);								//�������� 


	}
	
// ������� ����������� ��� �������� ����������
void pingPack (unsigned char device)
	{
	unsigned char a;
			
					txBuffer[0] = 'q';									// ���������
					txBuffer[1] = 3;                 					// �����
					txBuffer[2] = 0;                   				// �����
					txBuffer[3] = pingPacket;       				// ���
					txBuffer[4] = 'q'+3+0+pingPacket; 		// KC

					txTWIbuff (device);								// �������� 
					delay_ms (20);          
					rxTWIbuff (device);                  			// ���������

					if (rxBuffer[0] )
						{
						UCSR0B.3 = 1;								// �������� ����������
                            	for (a=0;a<=rxBuffer[0];a++)
									{
										putchar0 (rxBuffer [a]);
									}     
						rx0state = RX_HDR;					// �������� ����� ����. �������
						
						}          
	
	
	}
	

	
	