; Start instrs at address 0
.text 0x0000
; Start data somewhere else
.data 0x2000
.global _f
_f:
.word 0
.word 1

; Instructions
.text


; Fibonacci: f[i] = f[i-2] + f[i-1]; f[0]=0, f[1]=1
.proc _fib
.global _fib
_fib:
    ; Initialize r1-r2
    lw r1, _f(r0)
    lw r2, (_f+4)(r0)
    ; r3 = 'i'
    xor r3, r3, r3 ; i=0
    addui r3, r3, #8 ; i=2
fibr1:
    addu r1, r1, r2 ; a=(a+b)
    sw _f(r3), r1   ; f[i] = a
    addui r3, r3, #4 ; i++
    addu r2, r1, r2 ; b=(a+b)
    sw _f(r3), r2   ; f[i] = b
    addui r3, r3, #4 ; i++
    sgei r4, r3, #0xb4
    ; 0xb4 = 180 = 45*4
    ; much higher, and the number runs out of bits
    beqz r4, fibr1
    nop ; delay slow
    trap #0x300

    ;nop's to make sure the pipeline flushes
    nop
    nop
    nop
    nop
    nop
.endproc _fib
