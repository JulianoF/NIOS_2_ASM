.equ PIXEL_BUFFER_START, 0x08000000
.equ PIXEL_BUFFER_END, 0x0803BE80
.equ CHAR_BUFFER, 0x09000000
.equ SWITCH_BUFFER, 0x10000040

.equ VGA_ROW_VIS_WIDTH, 0x280 /*HEX WIDTH OF BYTES USED FOR ONE FULL ROW OF PIXELS that are visible on screen*/
.equ VGA_HALF_ROW_VIS_WIDTH, 0x140 /*HEX HALF WIDTH OF BYTES USED FOR ONE HALF ROW OF PIXELS that are visible on screen*/

.equ VGA_SIZE_NEXT_ROW, 0x400

.equ P1_DEFAULT_START_POS, 0x08004840
.equ P2_DEFAULT_START_POS, 0x08004A40

.global _start
_start:

INIT:			   		/*EVERYTHING THAT ONLY RUNS ON STARTUP HERE*/
 	movia sp, 0x10000 	/*INIT Stack pointer at reasonable address */
 
				   		/*CLEAR ALL REGISTERS ON A FRESH BOOT/START */
 	mov r2,r0  			#r2 mainly used for Mem Addresses in the VGA space 
 	mov r3,r0  			#r3 mainly used for Mem Addresses in the VGA space
 	mov r4,r0			#will be used to hold pixel color values
 	mov r5,r0			#will always hold address of SWITCH mem region
 	mov r6,r0
 	mov r7,r0
 	mov r8,r0
 	mov r9,r0
 	mov r10,r0
 	mov r11,r0
 	mov r12,r0
 	mov r13,r0
 	mov r14,r0
 	mov r15,r0
 	mov r16,r0
 	mov r17,r0
 	mov r18,r0
 	mov r19,r0
 	mov r20,r0
 	mov r21,r0
 	mov r22,r0
 	mov r23,r0
									
 	movia r2,PIXEL_BUFFER_START		
 	movia r3,PIXEL_BUFFER_END
 	movui r4,0x0000 				/*Black Pixel MOVED HERE FOR TEST*/
 	movia r5,SWITCH_BUFFER 			/*init r5 to start of switch buffer location*/
 
################################################################## 
PAINT_FULL_VGA:
 	beq r2,r3,END_PAINT_FULL_VGA
 	sthio r4,(r2)
 	addi r2,r2,2
 	br PAINT_FULL_VGA
END_PAINT_FULL_VGA:
 	movia r2,PIXEL_BUFFER_START
 	mov r4,r0
##################################################################	
 	movia r2,((PIXEL_BUFFER_START+VGA_HALF_ROW_VIS_WIDTH)-0x06) 		/*Move address into r2 where we want to start drawing*/
 	call DRAW_BOUNDARY  												/*Call subroutine DRAW_BOUNDARY*/
	
	movia r2, Player1
	movia r3,P1_DEFAULT_START_POS
	stw r3,(r2) 		/* MAKE CURRENT AND LAST POS SAME ON INIT*/
	stw r3,4(r2)
	movia r2, Player2
	movia r3,P2_DEFAULT_START_POS
	stw r3,(r2)  		/* MAKE CURRENT AND LAST POS SAME ON INIT*/
	stw r3,4(r2)
	
##############################################################################
GAMELOOP: 							/*MAIN GAME LOOP*/
	call GET_INPUT
 	call DRAW						/*Call the draw subroutine*/
 	jmpi GAMELOOP					/*Jump back to label GAMELOOP infinitly*/
##############################################################################	
DRAW: 															/*Drawing Subroutine to handle all drawing logic*/
 	subi sp,sp,4 														/*Reserve 4 bytes on the stack*/
 	stw ra,(sp) 														/*Store the current return Address on the stack*/

 	mov r10,r0  														/*Ensure some registers are zerod for use in Drawing functions*/
 	mov r11,r0
 	mov r12,r0
 	mov r13,r0
 
	movia r3,Player1
 	ldw r2,4(r3) 										/*Move address into r2 the chosen test spot to start Player 1*/ 
 	call DRAW_PLAYER1
 
 
	movia r3,Player2
 	ldw r2,4(r3) 									/*Move address into r2 the chosen test spot to start Player 2*/
 	call DRAW_PLAYER2
 
 	#call DRAW_BALL
 	#call DRAW_SCORE
 
 	ldw ra,(sp) 		 												/*Restore return address to return to GAMELOOP*/
 	addi sp,sp,4		 												/*Update Stack Pointer*/
 	ret
##############################################################################
DRAW_SCORE:
 	movui r4,0xffff 
 	ret
##############################################################################
DRAW_PLAYER1:
 	movui r4,0xff00
 	subi sp,sp,4
 	stw ra,(sp)
 
 	mov r10,r0
 	mov r11,r0
 	movia r12,4  /*Player Pixel Draw Width */
 	movia r13,30 /*Player Pixel Draw Height */
 
 D_P1_ROW:
 	beq r10,r12, D_P1_NEXTROW
 	sthio r4,(r2)
 	addi r2,r2,2
 	addi r10,r10,1
 	br D_P1_ROW
	
 D_P1_NEXTROW:
 	addi r2,r2, 1016
	mov r10,r0
	addi r11,r11,1
	bne r11,r13,D_P1_ROW
	br DONE_P1
	
 DONE_P1:
  	mov r10,r0
 	mov r11,r0
	mov r12,r0
 	mov r13,r0
 	ldw ra,(sp)
	addi sp,sp,4
 	ret
#########################################################################################
DRAW_PLAYER2:
 	movui r4,0xf0ff
 	subi sp,sp,4
 	stw ra,(sp)

 	mov r10,r0
 	mov r11,r0
 	movia r12,4  /*Player Pixel Draw Width */
 	movia r13,30 /*Player Pixel Draw Height */
 
 D_P2_ROW:
 	beq r10,r12, D_P2_NEXTROW
 	sthio r4,(r2)
 	addi r2,r2,2
 	addi r10,r10,1
 	br D_P2_ROW
	
 D_P2_NEXTROW:
 	addi r2,r2, 1016
	mov r10,r0
	addi r11,r11,1
	bne r11,r13,D_P2_ROW
	br DONE_P2
	
 DONE_P2:
  	mov r10,r0
 	mov r11,r0
	mov r12,r0
 	mov r13,r0
 	ldw ra,(sp)
	addi sp,sp,4
 	ret
#######################################################################################
DRAW_BALL:
 	movui r4,0xffff 
 	ret
#######################################################################################
DRAW_BOUNDARY:
 	movui r4,0xffff 		/*White Pixel*/
 	subi sp,sp,4 			/*Allocate Space for Stack Pointer*/
 	stw ra,(sp)  			/*Store Return Address on Stack */
 
 	movia r3, ((PIXEL_BUFFER_START+VGA_HALF_ROW_VIS_WIDTH)+0x06) /*Choose Right Spot to start Drawing*/
 	mov r10,r0 			/* Clear r10 */
 	mov r13,r0 			/* Clear r13 */
 	movia r11,5 		/*Height of Each Square*/
	movia r12,19 		/*Total Squares in Middle Bound*/
 
 DRAW_SQUARE:
  	beq r2,r3, NEXT_DRAW_ROW 	/*Branch when Current pixel = end mem address of where we want to stop drawing*/
  	sthio r4,(r2)
  	addi r2,r2,2
  	br DRAW_SQUARE
  
 NEXT_DRAW_ROW:
  	addi r2,r2, (VGA_SIZE_NEXT_ROW-0xC)
  	addi r3,r3, VGA_SIZE_NEXT_ROW
  	addi r10,r10,1
  	bne r10,r11,DRAW_SQUARE
  	mov r10,r0 				/* Clear r10 */
  	addi r13,r13,1
  	addi r2,r2,0x2000 		/*Move Pointer for Current Pixel down 10 rows */
  	addi r3,r3,0x2000 		/*Move Mem Address for last Row Pixel down 10 rows */
  	bne r12,r13,DRAW_SQUARE
 	br BOUND_DONE
  
BOUND_DONE: 
 	mov r10,r0 		/*Restore Used Registers*/
 	mov r11,r0
 	mov r12,r0
 	mov r13,r0
 	ldw ra,(sp) 		/*Restore Return Adress*/
 	addi sp,sp,4
 	ret
####################################################################################
GET_INPUT:
 	subi sp,sp,8 			/*Allocate Space for Stack Pointer*/
 	stw ra,(sp)
	stw r17,4(sp)
	
	ldhio r17,(r5) 					/*check is button is pressed by value loaded into r19*/
CHECK_P1_UP:	
	movia r18, 0x0001
	and r19,r18,r17
	beq r18,r19,MOVE_P1_UP
CHECK_P1_DOWN:	
	movia r18, 0x0010
	and r20,r18,r17
	beq r18,r20,MOVE_P1_DOWN
CHECK_P2_UP:	
	movia r18, 0x0100
	and r21,r18,r17
	beq r18,r21,MOVE_P2_UP
CHECK_P2_DOWN:		
	movia r18, 0x1000
	and r22,r18,r17
	beq r18,r22,MOVE_P2_DOWN
	br END_INPUT
	
MOVE_P1_UP:
	movia r3,Player1
	ldw r2,(r3)
	subi r2,r2,(VGA_SIZE_NEXT_ROW * 1)
	stw r2,(r3)
	stw r2,4(r3)
	br CHECK_P1_DOWN
MOVE_P1_DOWN:
	movia r3,Player1
	ldw r2,(r3)
	addi r2,r2,(VGA_SIZE_NEXT_ROW * 1)
	stw r2,(r3)	
	stw r2,4(r3)
	br CHECK_P2_UP
MOVE_P2_UP:
	movia r3,Player2
	ldw r2,(r3)
	subi r2,r2,(VGA_SIZE_NEXT_ROW * 1)
	stw r2,4(r3)
	stw r2,(r3)	
	br CHECK_P2_DOWN
MOVE_P2_DOWN:
	movia r3,Player2
	ldw r2,(r3)
	addi r2,r2,(VGA_SIZE_NEXT_ROW * 1)
	stw r2,(r3)
	stw r2,4(r3)
END_INPUT:
	mov r18,r0
	mov r19,r0
	mov r20,r0
	mov r21,r0
	mov r22,r0
	ldw r17,4(sp)
 	ldw ra,(sp) 		/*Restore Return Adress*/
 	addi sp,sp,8
 	ret
 .data 
	Player1:
		.skip 4 /* P1 LAST X POS */
		.skip 4 /* P1 CURRENT X POS */
	Player2:
		.skip 4 /* P1 LAST X POS */
		.skip 4 /* P1 CURRENT X POS */
	Score:
		.skip 4 /* P1 Score */
		.skip 4 /* P2 Score */