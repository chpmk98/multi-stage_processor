; Linked by DLX-LD.
; MemSize 20480
; Data size: 256
; Text size: 640
; Stack size: 8192
.text 0x0000
.data 0x2000
; Compiled by GCC
.global _A

.align 2
_A:
.byte 207
.byte 11
.byte 115
.byte 123
.byte 70
.byte 22
.byte 0
.byte 100
.byte 116
.byte 53
.byte 124
.byte 83
.byte 37
.byte 180
.byte 172
.byte 178
.byte 61
.byte 224
.byte 104
.byte 0
.byte 197
.byte 250
.byte 29
.byte 59
.byte 251
.byte 205
.byte 110
.byte 100
.byte 162
.byte 35
.byte 56
.byte 208
.byte 92
.byte 107
.byte 231
.byte 199
.byte 180
.byte 235
.byte 142
.byte 28
.byte 105
.byte 128
.byte 35
.byte 71
.byte 148
.byte 82
.byte 169
.byte 47
.byte 172
.byte 116
.byte 102
.byte 88
.byte 153
.byte 117
.byte 227
.byte 110
.byte 206
.byte 195
.byte 146
.byte 163
.byte 52
.byte 201
.byte 30
.byte 50
.byte 50
.byte 157
.byte 48
.byte 75
.byte 10
.byte 143
.byte 229
.byte 71
.byte 12
.byte 56
.byte 51
.byte 74
.byte 179
.byte 73
.byte 217
.byte 53
.byte 49
.byte 189
.byte 208
.byte 212
.byte 215
.byte 125
.byte 178
.byte 217
.byte 157
.byte 203
.byte 106
.byte 246
.byte 254
.byte 203
.byte 42
.byte 195
.byte 140
.byte 253
.byte 107
.byte 24
.byte 58
.byte 253
.byte 59
.byte 8
.byte 102
.byte 9
.byte 52
.byte 103
.byte 210
.byte 54
.byte 156
.byte 233
.byte 4
.byte 236
.byte 98
.byte 95
.byte 126
.byte 6
.byte 135
.byte 250
.byte 153
.byte 186
.byte 174
.byte 53
.byte 195
.byte 98
.byte 162
.byte 58
.byte 41
.byte 4
.byte 182
.byte 163
.byte 7
.byte 66
.byte 205
.byte 243
.byte 59
.byte 243
.byte 211
.byte 6
.byte 99
.byte 237
.byte 196
.byte 88
.byte 136
.byte 97
.byte 154
.byte 8
.byte 165
.byte 83
.byte 178
.byte 251
.byte 211
.byte 84
.byte 72
.byte 194
.byte 1
.byte 250
.byte 139
.byte 178
.byte 109
.byte 167
.byte 20
.byte 81
.byte 102
.byte 31
.byte 0
.byte 208
.byte 17
.byte 83
.byte 94
.byte 112
.byte 109
.byte 191
.byte 103
.byte 4
.byte 103
.byte 7
.byte 33
.byte 245
.byte 195
.byte 190
.byte 72
.byte 11
.byte 59
.byte 142
.byte 141
.byte 24
.byte 83
.byte 158
.byte 54
.byte 142
.byte 212
.byte 155
.byte 93
.byte 169
.byte 97
.byte 160
.byte 43
.byte 74
.byte 124
.byte 185
.byte 86
.byte 0
.byte 200
.byte 14
.byte 160
.byte 154
.byte 49
.byte 133
.byte 142
.byte 22
.byte 227
.byte 50
.byte 51
.byte 184
.byte 242
.byte 77
.byte 230
.byte 54
.byte 110
.byte 86
.byte 212
.byte 114
.byte 173
.byte 158
.byte 188
.byte 65
.byte 103
.byte 118
.byte 24
.byte 26
.byte 17
.byte 208
.byte 59
.byte 200
.byte 181
.byte 61
.byte 194
.byte 7
.byte 234
.byte 35
.byte 250
.byte 36
.byte 96
.byte 67
.byte 9
.byte 238
.byte 113
.byte 206
.byte 102
.byte 208
.byte 242
.byte 136
.byte 194
.byte 252
.word 1024
.text
.align 2
.proc _main
.global _main
_main:
;  Function 'main'; 272 bytes of locals, 0 regs to save.
	addui r29,r0,0x1000
	addui r1,r0,0x1000
	sw	-4(r29),r30; push fp
	add	r30,r0,r29; fp = sp
	sw	-8(r29),r31; push ret addr
	subui	r29,r29,#280; alloc local storage
	jal	___main
	nop; delay slot nop
	addi	r1,r0,#0
	sw	-268(r30),r1
L2_LF0:
	lw	r1,-268(r30)
	slei	r2,r1,#15
	bnez	r2,L5_LF0
	nop; delay slot nop
	j	L3_LF0
	nop; delay slot nop
L5_LF0:
	addi	r1,r0,#0
	sw	-272(r30),r1
L6_LF0:
	lw	r1,-272(r30)
	slei	r2,r1,#15
	bnez	r2,L9_LF0
	nop; delay slot nop
	j	L7_LF0
	nop; delay slot nop
L9_LF0:
	lw	r1,-268(r30)
	addi	r2,r0,#16
	mult r1,r1,r2
	addi	r2,r30,#-8
	add	r1,r1,r2
	addi	r2,r1,#-256
	lw	r3,-272(r30)
	add	r1,r2,r3
	addi	r2,r0,(#0x0)&0xff
	sb	(r1),r2
L8_LF0:
	lw	r2,-272(r30)
	addi	r1,r2,#1
	add	r2,r0,r1
	sw	-272(r30),r2
	j	L6_LF0
	nop; delay slot nop
L7_LF0:
L4_LF0:
	lw	r2,-268(r30)
	addi	r1,r2,#1
	add	r2,r0,r1
	sw	-268(r30),r2
	j	L2_LF0
	nop; delay slot nop
L3_LF0:
	nop
	addi	r1,r0,#1
	sw	-268(r30),r1
L10_LF0:
	lw	r1,-268(r30)
	slei	r2,r1,#14
	bnez	r2,L13_LF0
	nop; delay slot nop
	j	L11_LF0
	nop; delay slot nop
L13_LF0:
	addi	r1,r0,#1
	sw	-272(r30),r1
L14_LF0:
	lw	r1,-272(r30)
	slei	r2,r1,#14
	bnez	r2,L17_LF0
	nop; delay slot nop
	j	L15_LF0
	nop; delay slot nop
L17_LF0:
	lw	r1,-268(r30)
	addi	r2,r0,#16
	mult r1,r1,r2
	lhi	r5,((_A)>>16)&0xffff
	addui	r5,r5,(_A)&0xffff
	add	r2,r1,r5
	lw	r3,-272(r30)
	add	r1,r2,r3
	lbu	r2,(r1)
	add	r1,r0,r2
	slli	r2,r1,#0x2
	sub	r1,r0,r2
	lw	r2,-268(r30)
	add	r3,r0,r2
	slli	r2,r3,#0x4
	lhi	r5,((_A-16)>>16)&0xffff
	addui	r5,r5,(_A-16)&0xffff
	add	r3,r2,r5
	lw	r4,-272(r30)
	add	r2,r3,r4
	lbu	r3,(r2)
	addi	r4,r0,#2
	mult r2,r3,r4
	add	r1,r1,r2
	sw	-276(r30),r1
	lw	r1,-268(r30)
	addi	r2,r0,#16
	mult r1,r1,r2
	lhi	r5,((_A)>>16)&0xffff
	addui	r5,r5,(_A)&0xffff
	add	r2,r1,r5
	lw	r3,-272(r30)
	add	r1,r2,r3
	addi	r2,r1,#-1
	lbu	r1,(r2)
	lw	r2,-268(r30)
	addi	r3,r0,#16
	mult r2,r2,r3
	lhi	r5,((_A)>>16)&0xffff
	addui	r5,r5,(_A)&0xffff
	add	r3,r2,r5
	lw	r4,-272(r30)
	add	r2,r3,r4
	addi	r3,r2,#1
	lbu	r2,(r3)
	add	r1,r1,r2
	lw	r2,-276(r30)
	add	r1,r2,r1
	sw	-276(r30),r1
	lw	r1,-268(r30)
	addi	r2,r0,#16
	mult r1,r1,r2
	addi	r2,r30,#-8
	add	r1,r1,r2
	addi	r2,r1,#-256
	lw	r3,-272(r30)
	add	r1,r2,r3
	lb	r2,-273(r30)
	sb	(r1),r2
L16_LF0:
	lw	r2,-272(r30)
	addi	r1,r2,#1
	add	r2,r0,r1
	sw	-272(r30),r2
	j	L14_LF0
	nop; delay slot nop
L15_LF0:
L12_LF0:
	lw	r2,-268(r30)
	addi	r1,r2,#1
	add	r2,r0,r1
	sw	-268(r30),r2
	j	L10_LF0
	nop; delay slot nop
L11_LF0:
	addi	r1,r0,#0
	j	L1_LF0
	nop; delay slot nop
L1_LF0:
	jal	_exit
	nop
.endproc _main
;;; Ethan L. Miller, 1999.  Released to the public domain
;;;
;;; Most of the traps are called in files from libtraps.


.align 2
.proc _exit
.global _exit
_exit:
	trap	#0x300
	jr	r31
	nop
.endproc _exit

; for the benefit of gcc.
.proc ___main
.global ___main
___main:
	nop
	jr	r31
	nop
.endproc ___main
.text
.global _etext
_etext:
.align 3
.data
.global _edata
_edata:
