#include "Coding.h"

unsigned char flagTWI				=	0;



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
// ���������� ��� �������� �� ����� TWI
///////////////////////////////////////////////////////////////////////////////////////////////
void timer_0_Init  (void)
	{
		ASSR=0x00;
		TCCR0=0x0;        //0x06 -start
		TCNT0=0x01;
		OCR0=0x00;
		TIMSK^=0x01;			// Timer(s)/Counter(s) Interrupt(s) initialization
	}

// -------------------- ������� ������ � �������� 2 -------------------------------
///////////////////////////////////////////////////////////////////////////////////////////////
// Timer/Counter 2 initialization;  Clock source: System Clock
// Clock value: 7,813 kHz ; Mode: Normal top=FFh
// ���������� ��� �������� �������� ������� ��������
///////////////////////////////////////////////////////////////////////////////////////////////
void timer_2_Init  (void)
	{
		TCCR2=0x00;
		TCNT2=0x00;
		OCR2=0x00;
		TIMSK^=0x40;			// Timer(s)/Counter(s) Interrupt(s) initialization
		ETIMSK^=0x00;
	}                      
	
// -------------------- ������� ������ � �������� 3 -------------------------------
///////////////////////////////////////////////////////////////////////////////////////////////
// Clock source: System Clock; Clock value: 7,813 kHz
// Mode: Normal top=FFFFh ;Timer 3 Overflow Interrupt: On
// ���������� ��� �������� �������� ������� ��������
///////////////////////////////////////////////////////////////////////////////////////////////
void timer_3_Init  (void)
	{
		TCCR3A=0x00;
		TCCR3B=0x05;
		TCNT3H=0x00;
		TCNT3L=0xAA;
		ICR3H=0x00;
		ICR3L=0xFF;
		OCR3AH=0x00;
		OCR3AL=0x00;
		OCR3BH=0x00;
		OCR3BL=0x00;
		OCR3CH=0x00;
		OCR3CL=0x00;
										
		TIMSK^=0x00;                    // Timer(s)/Counter(s) Interrupt(s) initialization
		ETIMSK^=0x04;   
	}



// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
		TCCR0 = 0x0;						//������������� ������
		flagTWI  = flagTWI  | (1 << time_is_Out);	 //������� �������    

}
                                                                                             
// Timer 2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
		TCCR2 = 0x0; 						// ������� ������� 
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
	
// Timer 3 overflow interrupt service routine
interrupt [TIM3_OVF] void timer3_ovf_isr(void)
{
		EndTimePack = 1;			// ����� �����

						#ifdef print
						printf ("Timeout Scremb! \r\n");
						#endif
		

		TCCR3A=0x00;			// ������� ������� 
		TCCR3B=0x00;
		
		testpin = ~testpin;
		
}

// ��������� ������ ��� �������� ������� (150mc)
void timeOutPackStart (void)
	{
		EndTimePack = 0;		// ����� ��������
		
//		TCNT3H=0xFF;			// ����. �������� 32��
//		TCNT3L=0x00;			// ����. �������� 32��

//		TCNT3H=0xFC;			// ����. �������� 100��
//		TCNT3L=0xF2;        // ����. �������� 100��

//		TCNT3H=0xFB;			// ����. �������� 150��
//		TCNT3L=0x6C;			// ����. �������� 150��

		TCNT3H=0xF0;			// test
		TCNT3L=0x00;        // test

		TCCR3A=0x00;			// �������� �� 7.813���
		TCCR3B=0x05;


	}

// ��������� ���� � ������
void ModifyKey (void)
{
		u8 a,b;
		#ifdef print
		printf ("Modify Key\n\r");
		#endif
			
		#ifdef print
			for (a=0;a<rx0len;a++) printf ("%x ", rx0buf[a]);
		#endif

		b=rx0buf [55];
		rx0buf[55] = ver_kl;
		
		rx0buf[rx0len] = ((rx0buf[rx0len]-b) +ver_kl);

		#ifdef print
			printf("\n\r");
			for (a=0;a<rx0len;a++) printf ("%x ", rx0buf[a]);
		#endif
}


//  ��������� ���������� ���������� �������
 unsigned char Logic_Address_Identical (unsigned char Logik_Address, unsigned char device)
 {
		unsigned char a;
		
		for (a=1; a<= int_Devices; a++)				// ���� ���� �� ������
		{
		 	if (lAddrDevice [a]	== Logik_Address)
		 	{
		 		if (a != device) return TRUE;		// ���� ����������
		 	}
		 }	

 		return FALSE;
 }
	
 // ��������� � ��������� �����. ������� �������
void check_incoming_LOG_ADDR (u8 checking_Device)
{
		
		if ( !( Logic_Address_Identical ( rxBuffer[5], checking_Device ) ) )  //���� �� ������ �����?
		{
					#ifdef print
					printf ("Logic ADDR-%d\r\n",rxBuffer[5]);
					#endif
					 lAddrDevice [checking_Device] = rxBuffer[5];
		}
		else		 lAddrDevice [checking_Device] = 0;                                                                                

// ��������� ������� ������
		 if (! lAddrDevice [checking_Device])	reflection_active_PORTS &= ((1 << (checking_Device - 1)) ^ -1);
		 else													reflection_active_PORTS |= (1 << (checking_Device - 1));		
}
