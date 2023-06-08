//--------------------------------------------------------------------------------------------
// "Самодельный" putchar для вывода диагностики через ногу 9 программирующего разъема
#ifdef DEBUG_OUT
void dtxdl(void)
{
	int i;
	for (i = 0; i < 17; i ++)
	{
		#asm("nop")
	}
}

void putchar(char c)
{
	register unsigned char b;
	
	#asm("cli")
	
	DTXDDR = 1;
	DRXDDR = 0;
	DTXPIN = 0;
	dtxdl();
	
	for (b = 0; b < 8; b ++)
	{
		if (c & 1)
		{
			DTXPIN = 1;
		}
		else
		{
			DTXPIN = 0;
		}
             
		c >>= 1;
		dtxdl();
	}

	DTXPIN = 1;
	dtxdl();
	dtxdl();
	
	#asm("sei")
}
#endif DEBUG_OUT
