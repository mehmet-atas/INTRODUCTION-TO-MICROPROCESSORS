stack EQU 0x1000
input EQU 6
Res EQU 0x2000A000
factorial CMP R1, #0
MOVEQ R1, #1
BEQ exit ; terminating end condition – factorial of 0 = 1

STMDB 	SP!, {R1, LR}
SUB 	R1, R1, #1  
BL 		factorial ; call factorial with n-1
LDMIA 	SP!, {R1, LR} ; restore R1 and LR
exit 
MUL 	R0, R0, R1 ; return n*factorial(n-1) in R0
MOV 	PC, LR
main 
MOV 	R1, #input
MOV 	SP, #stack
MOV 	R0, #1
BL 		factorial
MOV32 	R2,#Res
STR 	R0,[R2] ; store the result


