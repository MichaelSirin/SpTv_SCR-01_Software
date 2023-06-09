//--------------------------------------------------------------------------------------
// ������� ��� ������ � FLASH

#include "CodingM8.h"      
#include "monitor.h"

#if (defined _CHIP_ATMEGA128L_) || (defined _CHIP_ATMEGA128_)
	#asm
		.equ	SPMCSR = 0x68
		.equ	SPMREG = SPMCSR
	#endasm
#elif (defined _CHIP_ATMEGA8_) || (defined _CHIP_ATMEGA8L_) || (defined _CHIP_ATMEGA8515_) || (defined _CHIP_ATMEGA8515L_) || (defined _CHIP_ATMEGA162_) || (defined _CHIP_ATMEGA162L_)
	#asm
		.equ	SPMCR  = 0x37
		.equ	SPMREG = SPMCR
	#endasm
#else
	#error ��������� ��� ����� ���������� ��� �� ��������
#endif

#asm
	.equ	SPMEN  = 0	; ���� ��������
	.equ	PGERS  = 1
	.equ	PGWRT  = 2
	.equ	BLBSET = 3
	.equ	RWWSRE = 4
	.equ	RWWSB  = 6
	.equ	SPMIE  = 7

	;--------------------------------------------------
	; �������� ���������� SPM. ������ R23
	spmWait:
#endasm
#ifdef USE_MEM_SPM
	#asm
		lds		r23, SPMREG
	#endasm
#else
	#asm
		in		r23, SPMREG
	#endasm
#endif
#asm
		andi	r23, (1 << SPMEN)
		brne	spmWait	
		ret

	;--------------------------------------------------
	; ������ SPM.
	spmSPM:
		in		r24, SREG	; �������� ���������
		cli					; �������� ����������
#endasm
#ifdef USE_RAMPZ
	#asm
		in		r25, RAMPZ	; �������� RAMPZ
	#endasm
#endif
#asm
		ld		r30, y		; �����
		ldd		r31, y+1
#endasm
#ifdef USE_RAMPZ
	#asm
		ldd		r26, y+2	; 3-� ���� ������ - � RAMPZ
		out		RAMPZ, r26
	#endasm
#endif
#asm
		rcall	spmWait		; ��� ���������� ���������� �������� (�� ������ ������)
#endasm
#ifdef USE_MEM_SPM
	#asm
		sts SPMREG, r22		; ������� ������, ��� ������
	#endasm
#else
	#asm
		out SPMREG, r22		; ������� ������, ��� ����
	#endasm
#endif
#asm
		spm					; ������ �� ����������

		nop
		nop
		nop
		nop

		rcall	spmWait		; ��� ����������
#endasm
#ifdef USE_RAMPZ
	#asm
		out		RAMPZ, r25	; �������������� ���������
	#endasm
#endif
#asm
		out		SREG, r24
		ret
#endasm

#pragma warn-
void ResetTempBuffer (FADDRTYPE addr)
{
	#asm
		ldi		r22, (1 << RWWSRE) | (1 << SPMEN)
		rcall	spmSPM
	#endasm
}

void FillTempBuffer (unsigned short data, FADDRTYPE addr)
{
	#ifdef USE_RAMPZ
		#asm
			ldd		r0, y+4			; ������
			ldd		r1,	y+5
		#endasm
	#else
		#asm
			ldd		r0, y+2			; ������
			ldd		r1,	y+3
		#endasm
	#endif
	#asm
		ldi		r22, (1 << SPMEN)	; �������

		rcall	spmSPM				; �� ����������
	#endasm
}

void PageErase (FADDRTYPE  addr)
{
	#asm
		ldi		r22, (1 << PGERS) | (1 << SPMEN)
		rcall	spmSPM
	#endasm
}

void PageWrite (FADDRTYPE addr)
{
	#asm
		ldi		r22, (1 << PGWRT) | (1 << SPMEN)
		rcall	spmSPM
	#endasm
}
#pragma warn+

void PageAccess (void)
{
	#asm
		ldi		r22, (1 << RWWSRE) | (1 << SPMEN)
		rcall	spmSPM
	#endasm
}

// ������ �������� FLASH
void WriteFlash(void)
{
	unsigned char a = 5;
	FADDRTYPE faddr;

	// ������� ����� ��������
	#asm ("wdr");
	faddr = GetWordBuff(a);
	a+=2;							// �������� 2 �����
	
	if (faddr >= PRGPAGES)
	{
		while(1);	// ���� ������������ ����� �������� - ������������ ������ � ����� �� ��������
	}	            
	

	// ������� ����� ������ ��������
	faddr <<= (ZPAGEMSB + 1);
	
	// �������� ������ � ������������� �����
	#asm ("wdr");
	ResetTempBuffer(faddr);
	do{
			FillTempBuffer(GetWordBuff(a), faddr);			// 
			a+=2;
			faddr += 2;
    	}while (faddr & (PAGESIZ-1)) ;	

		// �������, ��� ��� � ������� � ����� �������� ���������
//		#asm ("wdr");
//		txBufferTWI[0] = 2;                   		// �����
//		txBufferTWI[1] = RES_OK;
//		txBufferTWI[2] = 2 + RES_OK;         // ��*/

	// �������������� ����� ������ ��������
	faddr -= PAGESIZ;

	// ������ ��������
//	#asm ("wdr");
	PageErase(faddr);
	
	// ��������� ��������
	#asm ("wdr");
	PageWrite(faddr);

	// ��������� ��������� ������� RWW
	#asm ("wdr");
	PageAccess();

	// �������, ��� ��� � ������� � ����� �������� ���������
//	#asm ("wdr");
		txBufferTWI[Start_Position_for_Reply] = 2;                   		// �����
		txBufferTWI[Start_Position_for_Reply+1] = RES_OK;
		txBufferTWI[Start_Position_for_Reply+2] = 2 + RES_OK;         // ��*/
}
 