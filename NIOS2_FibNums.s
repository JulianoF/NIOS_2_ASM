.equ RESULTS, 0x1000
.equ NUM, 0x1500

.global _start
_start:

 mov r2,r0	        /*clear r2*/
 addi r2,r2,1       /*Set R2 to fibNum 1 */ 
 mov r3,r2          /*Init Counter to 1 */
 movia r4,NUM       /*Set R4 to address of N*/
 ldw r5,(r4)        /* Load amount of Fib Nums we want in R5*/
 movia r6,RESULTS   /*Load Address of results memory */
 
 mov r10,r0         /*Used for work in loop*/
 mov r11,r2         /*Used for work in loop*/
 mov r12,r0         /*Used for work in loop*/
 
 stw r0,(r6)        /* Store 0 in 0x1000 as 0 is Fib 1*/
 addi r6,r6,4       /*increment results pointer*/
 beq r3,r5,DONE     /*If only looking for 1st Fib Num we are done*/
 
 stw r2,(r6)        /*Store 1 in 0x1004 as 1 is Fib 2*/
 addi r3,r3,1       /*Increment Counter for Condition*/
 beq r3,r5,DONE     /*If onle looking for first 2 fib Nums we done*/
 
LOOP:
 bge r3,r5,DONE     /*End if Loop Counter >= number of fib nums we want*/
 add r12,r11,r10    /*Add last two fib nums for next fib num*/
 addi r6,r6,4       /*Increment Results Pointer*/
 stw r12,(r6)       /*Store new fib num in memory*/
 mov r10,r11	    /*old fib 2 now new fib 1*/
 mov r11,r12	    /* new fib num now fib 2*/
 addi r3,r3,1	    /*Increment loop counter*/
 br LOOP			/*Break to start of loop*/

DONE:
 br DONE			/*end of program*/
 
.org 0x1000	
.skip 100

.org 0x1500
.word 8