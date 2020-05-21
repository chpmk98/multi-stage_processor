# MAIN
.text 0x0000
.data 0x2000
.global _dat
_dat:
.word 15
.word 240
.word 3840 
.word 61440
.word 983040 
.word 15728640 
.word 251658240 
.word 268435456
.word 536870912 
.word 3221225472

.text
.proc _usum
.global _usum
_usum:
    xor r0, r0, r0      #Remains zero
    xor r4, r4, r4
    xor r5, r5, r5
    xor r6, r6, r6
    addi r6, r0, 36 

_loop:
    lw r4, _dat(r6)
    addu r5, r5, r4
    subi r6, r6, 4
    bnez r6, _loop
    sw _dat(r0), r6
    nop ;some spacing for the rest of the program to finish
    nop
    nop
    nop
    nop
.endproc _usum
