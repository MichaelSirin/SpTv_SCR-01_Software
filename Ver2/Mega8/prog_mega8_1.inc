
	.DEF _pAddr=R4
_3:
	.DB  0x1
	.DEF _lAddr=R5
	.DEF _Count1=R6
	.DEF _Count=R7
	.DEF _CRCPackRX=R8
	.DEF _Count2=R9
	.DEF _Count3=R10
	.DEF _CountUART=R11
	.DEF _CountUART_1=R12
_device_name:
	.DB  0x4D,0x61,0x69,0x6E,0x20,0x50,0x72,0x6F
	.DB  0x67,0x72,0x61,0x6D,0x2E,0x20,0x50,0x6F
	.DB  0x72,0x74,0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
_my_version:
	.DB  0x1,0x0
__PT_GETSTATE_:
	.DB  0x14,0x2,0x0,0x50,0x6F,0x72,0x74,0x20
	.DB  0x52,0x53,0x2D,0x32,0x33,0x32,0x20,0x20
	.DB  0x20,0x20,0x64,0xFF

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x04
	.DW  _3*2

	.DW  0
_0x6E:
