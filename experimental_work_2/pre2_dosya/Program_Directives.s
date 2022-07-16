;*************************************************************** 
; Program_Directives.s  
; Copies the table from one location
; to another memory location.           
; Directives and Addressing modes are   
; explained with this program.   
;***************************************************************	
;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
OFFSET  	EQU     	0x10
FIRST	   	EQU	    	0x20000480	
SECOND 		EQU 		0x2000049E
;***************************************************************
; Directives - This Data Section is part of the code
; It is in the read only section  so values cannot be changed.
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
            AREA        sdata, DATA, READONLY
            THUMB
CTR1    	DCB     	0x0F
MSG     	DCB     	"Copying table..."
			DCB			0x0D
			DCB			0x04
;***************************************************************
; Program section					      
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
			AREA    	main, READONLY, CODE
			THUMB
			EXTERN		OutStr	; Reference external subroutine	
			EXPORT  	__main	; Make available

		
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

__main		PROC
MOV 	R1, #input
MOV 	SP, #stack
MOV 	R0, #1
BL 		factorial
MOV32 	R2,#Res
STR 	R0,[R2] ; store the result
			
ENDP
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ALIGN
			END
