.equ PIXEL_BUFFER_START, 0x08000000
.equ PIXEL_BUFFER_END, 0x08080000
.equ CHAR_BUFFER, 0x09000000
.equ BUTTON_BUFFER, 0x10000050

.global _start
_start:

INIT:							/*EVERYTHING THAT ONLY RUNS ON STARTUP HERE*/
 movia r2,PIXEL_BUFFER_START		
 movia r3,CHAR_BUFFER
 movia r6,PIXEL_BUFFER_END
 movia r18,BUTTON_BUFFER
 
 mov r4,r0			/*CLEAR CURRENT WORKING REGISTERS*/
 mov r5,r0
 
 
 mov r7,r0
 mov r8,r0
 mov r9,r0
 mov r10,r0
 
 movui r4,0x0000 /*Black Pixel MOVED HERE FOR TEST*/
 
INIT_VGA:
 beq r2,r6,END_INIT_VGA
 sthio r4,(r2)
 addi r2,r2,2
 addi r5,r5,1
 br INIT_VGA
END_INIT_VGA:
 movia r2,PIXEL_BUFFER_START
 mov r4,r0
 mov r5,r0
 br GAMELOOP


GAMELOOP: /*MAIN GAME LOOP*/
 ldhio r19,(r18) /*check is button is pressed by value loaded into r19*/
 beq r0,r19, INIT_VGA /* IF BUTTON NOT PRESSED PAINT VGA BLACK*/
 movui r4,0xffff /*White Pixel*/
 bne r0,r19 ,INIT_VGA /* IF BUTTON IS PRESSED PAINT VGA WHITE*/
 jmpi GAMELOOP
	
DRAW: /*Not implemented*/
 call DRAW_SCORE
 call DRAW_BOUNDARY
 call DRAW_PLAYER1
 call DRAW_PLAYER2
 call DRAW_BALL
 ret
 
DRAW_SCORE:
 movui r4,0xffff 
 ret

DRAW_PLAYER1:
 movui r4,0xffff 
 ret

DRAW_PLAYER2:
 movui r4,0xffff 
 ret

DRAW_BALL:
 movui r4,0xffff 
 ret
 
DRAW_BOUNDARY:
 movui r4,0xffff 
 ret
