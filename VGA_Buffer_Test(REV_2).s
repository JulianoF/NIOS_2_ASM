.global _start
_start:
	
.equ ADDR_VGA, 0x08000000
.equ ADDR_CHAR, 0x09000000

main:
	
	mov r6,r0  /*Offset*/
	mov r11,r0 /*Counter*/
	mov r12,r0 /*Loop Control*/
	
	movia r2,ADDR_VGA
  	movia r3, ADDR_CHAR
  	movi r4, 0x4A  /* ASCII for 'J' */
 	movi r5, 0x46   /* ASCII for 'F' */
	movi r6, 128
	movi r12, 15
	
	br CLEARVGA
NEXT:
	mov r11,r0
	movia r3, ADDR_CHAR
	br LOOP

CLEARVGA:
	bge r11,r12,NEXT
	stbio r0,4(r3)
	stbio r0,5(r3)
	addi r3,r3,128
	addi r11,r11, 1
	br CLEARVGA

LOOP:
	bge r11,r12,main
  	stbio r4,4(r3) /* character (4,1) is x + y*128 so (4 + 128 = 132) */
	stbio r5,5(r3)
	addi r3,r3,128
	addi r11,r11, 1
	br LOOP