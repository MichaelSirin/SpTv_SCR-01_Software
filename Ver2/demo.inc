	.DEF _PT_SecStart=R4
	.DEF _BPB_BytsPerSec=R6
	.DEF _BPB_SecPerClus=R8
	.DEF _BPB_RsvdSecCnt=R9
	.DEF _BPB_NumFATs=R11
	.DEF _BPB_RootEntCnt=R12
	.DEF _BPB_FATType=R14
_sd_cmd:
	.DB  0x0,0x0
	.DB  0x40,0x0
	.DB  0x0,0x0
	.DB  0x0,0x0
	.DB  0x1,0x0
	.DB  0x41,0x0
	.DB  0x0,0x0
	.DB  0x0,0x0
	.DB  0x2,0x0
	.DB  0x49,0x0
	.DB  0x0,0x0
	.DB  0x0,0x0
	.DB  0x3,0x0
	.DB  0x4A,0x0
	.DB  0x0,0x0
	.DB  0x0,0x0
	.DB  0x4,0x0
	.DB  0x4C,0x0
	.DB  0x0,0x0
	.DB  0x0,0x0
	.DB  0x5,0x0
	.DB  0x4D,0x0
	.DB  0x0,0x0
	.DB  0x2,0x0
	.DB  0x6,0x0
	.DB  0x50,0x0
	.DB  0x1,0x0
	.DB  0x0,0x0
	.DB  0x7,0x0
	.DB  0x51,0x0
	.DB  0x2,0x0
	.DB  0x0,0x0
	.DB  0x8,0x0
	.DB  0x52,0x0
	.DB  0x2,0x0
	.DB  0x0,0x0
	.DB  0x9,0x0
	.DB  0x58,0x0
	.DB  0x2,0x0
	.DB  0x0,0x0
	.DB  0xA,0x0
	.DB  0x59,0x0
	.DB  0x2,0x0
	.DB  0x0,0x0
	.DB  0xB,0x0
	.DB  0x5B,0x0
	.DB  0x0,0x0
	.DB  0x0,0x0
	.DB  0xC,0x0
	.DB  0x5C,0x0
	.DB  0x2,0x0
	.DB  0x1,0x0
	.DB  0xD,0x0
	.DB  0x5D,0x0
	.DB  0x2,0x0
	.DB  0x1,0x0
	.DB  0xE,0x0
	.DB  0x5E,0x0
	.DB  0x2,0x0
	.DB  0x0,0x0
	.DB  0xF,0x0
	.DB  0x60,0x0
	.DB  0x2,0x0
	.DB  0x0,0x0
	.DB  0x10,0x0
	.DB  0x61,0x0
	.DB  0x2,0x0
	.DB  0x0,0x0
	.DB  0x11,0x0
	.DB  0x62,0x0
	.DB  0x2,0x0
	.DB  0x0,0x0
	.DB  0x12,0x0
	.DB  0x63,0x0
	.DB  0x2,0x0
	.DB  0x0,0x0
	.DB  0x13,0x0
	.DB  0x64,0x0
	.DB  0x2,0x0
	.DB  0x0,0x0
	.DB  0x14,0x0
	.DB  0x65,0x0
	.DB  0x2,0x0
	.DB  0x0,0x0
	.DB  0x15,0x0
	.DB  0x66,0x0
	.DB  0x3,0x0
	.DB  0x1,0x0
	.DB  0x16,0x0
	.DB  0x6A,0x0
	.DB  0x3,0x0
	.DB  0x1,0x0
	.DB  0x17,0x0
	.DB  0x7A,0x0
	.DB  0x0,0x0
	.DB  0x3,0x0
	.DB  0x18,0x0
	.DB  0x7B,0x0
	.DB  0x3,0x0
	.DB  0x0,0x0
	.DB  0x19,0x0
	.DB  0x69,0x0
	.DB  0x0,0x0
	.DB  0x0,0x0
_0:
	.DB  0xA,0xD,0x52,0x45,0x41,0x44,0x5F,0x45
	.DB  0x52,0x52,0x0,0xA,0xD,0x42,0x6F,0x6F
	.DB  0x74,0x5F,0x53,0x65,0x63,0x3A,0x20,0x5B
	.DB  0x30,0x78,0x25,0x58,0x20,0x25,0x58,0x20
	.DB  0x25,0x58,0x5D,0x20,0x5B,0x30,0x78,0x25
	.DB  0x58,0x5D,0x20,0x5B,0x30,0x78,0x25,0x58
	.DB  0x5D,0x0,0xA,0xD,0x50,0x61,0x72,0x74
	.DB  0x20,0x41,0x64,0x64,0x72,0x65,0x73,0x73
	.DB  0x3A,0x20,0x20,0x25,0x6C,0x58,0x0,0xA
	.DB  0xD,0x42,0x53,0x5F,0x6A,0x6D,0x70,0x42
	.DB  0x6F,0x6F,0x74,0x3A,0x20,0x20,0x25,0x6C
	.DB  0x58,0x0,0xA,0xD,0x42,0x50,0x42,0x5F
	.DB  0x42,0x79,0x74,0x73,0x50,0x65,0x72,0x53
	.DB  0x65,0x63,0x3A,0x20,0x20,0x25,0x58,0x0
	.DB  0xA,0xD,0x42,0x50,0x42,0x5F,0x53,0x65
	.DB  0x63,0x50,0x65,0x72,0x43,0x6C,0x75,0x73
	.DB  0x3A,0x20,0x20,0x25,0x58,0x0,0xA,0xD
	.DB  0x42,0x50,0x42,0x5F,0x52,0x73,0x76,0x64
	.DB  0x53,0x65,0x63,0x43,0x6E,0x74,0x3A,0x20
	.DB  0x20,0x25,0x58,0x0,0xA,0xD,0x42,0x50
	.DB  0x42,0x5F,0x4E,0x75,0x6D,0x46,0x41,0x54
	.DB  0x73,0x3A,0x20,0x20,0x25,0x58,0x0,0xA
	.DB  0xD,0x42,0x50,0x42,0x5F,0x52,0x6F,0x6F
	.DB  0x74,0x45,0x6E,0x74,0x43,0x6E,0x74,0x3A
	.DB  0x20,0x20,0x25,0x58,0x0,0xA,0xD,0x42
	.DB  0x50,0x42,0x5F,0x46,0x41,0x54,0x53,0x7A
	.DB  0x31,0x36,0x3A,0x20,0x20,0x25,0x58,0x0
	.DB  0xA,0xD,0x42,0x50,0x42,0x5F,0x54,0x6F
	.DB  0x74,0x53,0x65,0x63,0x31,0x36,0x3A,0x20
	.DB  0x20,0x25,0x6C,0x58,0x0,0xA,0xD,0x42
	.DB  0x50,0x42,0x5F,0x46,0x41,0x54,0x54,0x79
	.DB  0x70,0x65,0x3A,0x20,0x20,0x46,0x41,0x54
	.DB  0x31,0x32,0x0,0xA,0xD,0x42,0x50,0x42
	.DB  0x5F,0x46,0x41,0x54,0x54,0x79,0x70,0x65
	.DB  0x3A,0x20,0x20,0x46,0x41,0x54,0x31,0x36
	.DB  0x0,0xA,0xD,0x42,0x50,0x42,0x5F,0x46
	.DB  0x41,0x54,0x54,0x79,0x70,0x65,0x3A,0x20
	.DB  0x20,0x46,0x41,0x54,0x20,0x45,0x52,0x52
	.DB  0x4F,0x52,0x21,0x21,0x0,0xA,0xD,0x43
	.DB  0x6C,0x75,0x73,0x74,0x65,0x72,0x43,0x6E
	.DB  0x74,0x3A,0x20,0x20,0x25,0x6C,0x58,0x0
	.DB  0xA,0xD,0x52,0x4F,0x4F,0x54,0x5F,0x41
	.DB  0x44,0x44,0x52,0x3A,0x20,0x20,0x25,0x6C
	.DB  0x58,0x0,0xA,0xD,0x46,0x41,0x54,0x32
	.DB  0x5F,0x41,0x44,0x44,0x52,0x3A,0x20,0x20
	.DB  0x25,0x6C,0x58,0x0,0xA,0xD,0x52,0x6F
	.DB  0x6F,0x74,0x44,0x69,0x72,0x53,0x65,0x63
	.DB  0x74,0x6F,0x72,0x73,0x3A,0x20,0x20,0x25
	.DB  0x58,0x0,0xA,0xD,0x46,0x69,0x72,0x73
	.DB  0x74,0x44,0x61,0x74,0x61,0x53,0x65,0x63
	.DB  0x74,0x6F,0x72,0x3A,0x20,0x20,0x25,0x58
	.DB  0x0,0xA,0xD,0x52,0x65,0x73,0x65,0x74
	.DB  0x20,0x43,0x4D,0x44,0x3A,0x20,0x20,0x0
	.DB  0x4F,0x4B,0x21,0x21,0x21,0x0,0x45,0x52
	.DB  0x52,0x4F,0x52,0x21,0x21,0x21,0x0,0xD
	.DB  0xA,0x49,0x6E,0x69,0x74,0x69,0x61,0x6C
	.DB  0x69,0x7A,0x61,0x74,0x69,0x6F,0x6E,0x3A
	.DB  0x20,0x20,0x0,0x4F,0x4B,0x21,0x0,0x45
	.DB  0x52,0x52,0x4F,0x52,0x2D,0x25,0x78,0x20
	.DB  0x20,0x0,0xA,0xD,0x0,0x25,0x58,0x20
	.DB  0x0,0xD,0xA,0x46,0x69,0x6C,0x65,0x20
	.DB  0x4C,0x69,0x73,0x74,0x69,0x6E,0x67,0x20
	.DB  0x66,0x6F,0x72,0x3A,0x20,0x20,0x52,0x4F
	.DB  0x4F,0x54,0x5C,0x0,0x20,0x20,0x5B,0x0
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x5B,0x25,0x6C,0x64,0x5D,0x20,0x62,0x79
	.DB  0x74,0x65,0x73,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x28,0x25,0x58,0x29,0xD,0x20,0x20
	.DB  0x0,0x5D,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x28,0x25,0x58,0x29,0x0,0xD,0xA,0x20
	.DB  0x20,0x56,0x6F,0x6C,0x75,0x6D,0x65,0x20
	.DB  0x53,0x65,0x72,0x69,0x61,0x6C,0x3A,0x20
	.DB  0x20,0x5B,0x30,0x78,0x25,0x6C,0x58,0x5D
	.DB  0x0,0xD,0xA,0x20,0x20,0x56,0x6F,0x6C
	.DB  0x75,0x6D,0x65,0x20,0x4C,0x61,0x62,0x65
	.DB  0x6C,0x3A,0x20,0x20,0x5B,0x25,0x73,0x5D
	.DB  0xD,0xA,0x0,0x25,0x30,0x32,0x58,0x20
	.DB  0x0,0x64,0x65,0x6D,0x6F,0x2E,0x64,0x61
	.DB  0x74,0x0,0x43,0x6F,0x6C,0x75,0x6D,0x6E
	.DB  0x20,0x25,0x64,0x2C,0x20,0x43,0x6F,0x6C
	.DB  0x75,0x6D,0x6E,0x20,0x25,0x64,0x2C,0x20
	.DB  0x43,0x6F,0x6C,0x75,0x6D,0x6E,0x20,0x25
	.DB  0x64,0x2C,0x20,0x43,0x6F,0x6C,0x75,0x6D
	.DB  0x6E,0x20,0x25,0x64,0x2C,0x20,0x43,0x6F
	.DB  0x6C,0x75,0x6D,0x6E,0x20,0x25,0x64,0x2C
	.DB  0x20,0x43,0x6F,0x6C,0x75,0x6D,0x6E,0x20
	.DB  0x25,0x64,0x2C,0x20,0x43,0x6F,0x6C,0x75
	.DB  0x6D,0x6E,0x20,0x25,0x64,0x2C,0x20,0x43
	.DB  0x6F,0x6C,0x75,0x6D,0x6E,0x20,0x25,0x64
	.DB  0x2C,0x20,0x43,0x6F,0x6C,0x75,0x6D,0x6E
	.DB  0x20,0x25,0x64,0x2C,0x20,0x43,0x6F,0x6C
	.DB  0x75,0x6D,0x6E,0x20,0x25,0x64,0x2C,0xD
	.DB  0xA,0x0,0x25,0x6C,0x64,0x2C,0x20,0x0
	.DB  0xD,0xA,0xD,0xA,0x44,0x4F,0x4E,0x45
	.DB  0x21,0x21,0x21,0x0

;HEAP START MARKER INITIALIZATION
__HEAP_START_MARKER:
	.DW  0,0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x824
	.DW  __HEAP_START_MARKER*2

	.DW  0