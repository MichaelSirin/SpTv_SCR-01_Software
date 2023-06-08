///////////////////////////////////////////////////////////////////////////////////////////
// ������������ ��������������� ������

unsigned long int next_rand = 1;
unsigned char rand_cnt = 31;

// ��������� ��������������� ������������������.
// �� ������ ����� IAR-������ ���������

bit descramble = 0;					// ������� ������������� ������������

unsigned char NextSeqByte(void)	// ��������� ���� ����������� ������������������
{
	next_rand = next_rand * 1103515245 + 12345;
	next_rand >>= 8;
	
	rand_cnt += 101;
		
	return rand_cnt ^ (unsigned char)next_rand;
}

void ResetDescrambling(void)		// ���������� ���������� ����������� ������������������
{
	next_rand = scrambling_seed;
	rand_cnt = 31;
	descramble = 0;
}
