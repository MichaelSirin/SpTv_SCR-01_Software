#include "Coding.h"

void ini_kluchej(void)
{
	confkluch1	=0xb2;	//konfiguracija gen klucha1
	confkluch2	=0xa6;	//konfiguracija gen klucha2
	krutnut		=0x7;
	ver_kl		=0x7d;

	kluchi_koderu[0]=0x2;//kl0h
	kluchi_koderu[1]=0x45;//kl0l
	kluchi_koderu[2]=0x1;//kl1h
	kluchi_koderu[3]=0x89;//kl1l
	kluchi_koderu[4]=0x6;//kl2h
	kluchi_koderu[5]=0x42;//kl2l
	kluchi_koderu[6]=0x5;//kl3h
	kluchi_koderu[7]=0xf6;//kl3l

}

void podgotovka_kluch_dekoderu(void)
{
int a,i;

	kluchi_dekoderu[0]=0x55;//confkluch1;
	kluchi_dekoderu[1]=confkluch2;
	kluchi_dekoderu[2]=0x55;//krutnut;
	kluchi_dekoderu[3]=0x55;//kolvo_abonentov;
	kluchi_dekoderu[4]=kolvo_stvolov;
	kluchi_dekoderu[5]=0x55;//rezerv
	kluchi_dekoderu[6]=0x55;//rezerv


	kluchi_dekoderu[7]=kluchi_koderu[0];//f_buff_kluch[86]^f_buff_kluch[225];//kl0h
	kluchi_dekoderu[8]=kluchi_koderu[1];//	f_buff_kluch[89]^f_buff_kluch[225];//kl0l
	kluchi_dekoderu[9]=kluchi_koderu[2];//f_buff_kluch[131]^f_buff_kluch[225];//kl1h
	kluchi_dekoderu[10]=kluchi_koderu[3];//f_buff_kluch[141]^f_buff_kluch[225];//kl1l
	kluchi_dekoderu[11]=kluchi_koderu[4];//f_buff_kluch[215]^f_buff_kluch[225];//kl2h
	kluchi_dekoderu[12]=kluchi_koderu[5];//f_buff_kluch[241]^f_buff_kluch[225];//kl2l
	kluchi_dekoderu[13]=kluchi_koderu[6];//f_buff_kluch[162]^f_buff_kluch[225];//kl3h
	kluchi_dekoderu[14]=kluchi_koderu[7];//f_buff_kluch[169]^f_buff_kluch[225];//kl3l

	a=0;
	for (i=0;i<15;i++)
	{
		a=a+kluchi_dekoderu[i];
	}
	a=-1-a;
	kluchi_dekoderu[15]=a;
}

//��������� ������
void g_kod(void)	
{
	if  (ver_kl & 0x80)
	{
	gshum7();
	kluchi_koderu[0]=gshch7;//f_buff_kluch[86]^f_buff_kluch[225];//kl0h
	gshum7();
	kluchi_koderu[1]=gshch7;//f_buff_kluch[89]^f_buff_kluch[225];//kl0l
	gshum7();
	kluchi_koderu[4]=gshch7;//f_buff_kluch[215]^f_buff_kluch[225];//kl2h
	gshum7();
	kluchi_koderu[5]=gshch7;//f_buff_kluch[241]^f_buff_kluch[225];//kl2l
	
	}
	else
	{
	gshum7();
	kluchi_koderu[2]=gshch7;//f_buff_kluch[131]^f_buff_kluch[225];//kl1h
	gshum7();
	kluchi_koderu[3]=gshch7;//f_buff_kluch[141]^f_buff_kluch[225];//kl1l
	gshum7();
	kluchi_koderu[6]=gshch7;//f_buff_kluch[162]^f_buff_kluch[225];//kl3h
	gshum7();
	kluchi_koderu[7]=gshch7;//f_buff_kluch[169]^f_buff_kluch[225];//kl3l           
	
	}	 
	podgotovka_kluch_dekoderu();
}

//������������ ������ ������
void men_ver_kl(void)	
{
	if  (ver_kl & 0x80)
	{
		ver_kl=ver_kl & 0x7f;
	}
	else
	{
		ver_kl=ver_kl | 0x80;
	}
}

	
//��� �������� ������ ��������
void g_klucha1(void) 
{
int a,b,i;
		a=gshch1 & confkluch1;
		b=0;
		for (i=0;i<16;i++)
		{
			b=b^a;
			b=b & 1;
			a>>=1;
		}
		gshch1<<=1;
		gshch1=gshch1 | b;	//or
}

//����������� ��������� ���������� ��� �������������
void g_klucha2(void)	
{
int a,b,i;
		a=gshch2 & confkluch2;
		b=0;
		for (i=0;i<16;i++)
		{
			b=b^a;
			b=b & 1;
			a>>=1;
		}
		gshch2<<=1;
		gshch2=gshch2 | b;	//or
}


//dlja peredachi Kazakovu
void gshum3(void)	
{
int a,b,i;
		a=gshch3 & conf3;
		b=0;
		for (i=0;i<16;i++)
		{
			b=b^a;
			b=b & 1;
			a>>=1;

		}
		gshch3<<=1;
		gshch3=gshch3 | b;
}

//���������� ������ � ����
void gshum4(void)	
{
int a,b,i; 

		a=gshch4 & conf4;
		b=0;
		for (i=0;i<16;i++)
		{
			b=b^a;
			b=b & 1;
			a>>=1;

		}
		gshch4<<=1;
		gshch4=gshch4 | b;	//or
}

//���������� ������ ��������
void gshum5(void)		
{
int a,b,i;
		a=gshch5 & conf5;
		b=0;
		for (i=0;i<16;i++)
		{
			b=b^a;
			b=b & 1;
			a>>=1;

		}
		gshch5<<=1;
		gshch5=gshch5 | b;	//or
}

//������������� ����� flash.bin
void gshum6(void)		
{
int a,b,i;
		a=gshch6 & conf6;
		b=0;
		for (i=0;i<16;i++)
		{
			b=b^a;
			b=b & 1;
			a>>=1;

		}
		gshch6<<=1;
		gshch6=gshch6 | b;	//or
}

//��������� ������
//������������� ����� flash.bin ��� �������� �� �����
void gshum7(void)	
{
int a,b,i;
gshum7st:
		a=gshch7 & conf7;
		b=0;
		for (i=0;i<16;i++)
		{
			b=b^a;
			b=b & 1;
			a>>=1;

		}
		gshch7<<=1;
		gshch7=gshch7 | b;	//or
		a=gshch7 &0xff;
		if (a==0) goto gshum7st;
}
