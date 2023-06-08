///////////////////////////////////////////////////////////////////////////////////////////
// Дешифрование программирующих данных

unsigned long int next_rand = 1;
unsigned char rand_cnt = 31;

// Генератор псевдослучайной последовательности.
// За основу взяты IAR-овские исходники

bit descramble = 0;					// Признак необходимости дешифрования

unsigned char NextSeqByte(void)	// Очередной байт дешифрующей последовательности
{
	next_rand = next_rand * 1103515245 + 12345;
	next_rand >>= 8;
	
	rand_cnt += 101;
		
	return rand_cnt ^ (unsigned char)next_rand;
}

void ResetDescrambling(void)		// Перезапуск генератора дешифрующей последовательности
{
	next_rand = scrambling_seed;
	rand_cnt = 31;
	descramble = 0;
}
