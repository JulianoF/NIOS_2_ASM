.global _start
_start:
	
MAIN:
    movia sp,0x5000
	movia r10,10
	
	movia r4, 0x1000000
	mov r5,r0
	call SUBR
	br MAIN

SUBR:
	subi sp,sp,8
	stw r4,(sp)
	stw r5,4(sp)
LOOP:
	beq r5,r10, END_LOOP
	addi r4,r4,2
	addi r5,r5,1
	br LOOP
END_LOOP:
	ldw r4,(sp)
	ldw r5,4(sp)
	addi sp,sp,8
	ret
	