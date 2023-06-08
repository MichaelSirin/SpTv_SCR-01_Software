
_scrambling_seed:
	.DB  0x4D,0x1
	.DEF _pcrc=R4
_72:
	.DB  0x1,0x0,0x0,0x0
	.DEF _rand_cnt=R5
_73:
	.DB  0x1F

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  _next_rand
	.DW  _72*2

	.DW  0x01
	.DW  0x05
	.DW  _73*2

	.DW  0
_0x4E:
