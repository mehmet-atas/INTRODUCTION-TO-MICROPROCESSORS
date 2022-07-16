stradding	EQU			0x20000200	
			AREA    	Fibonacci, READONLY, CODE
			THUMB
			EXPORT		Fibonacci
			EXTERN		CONVRT
__Fibonacci
			push 		{r1-r4}
			mov			r1,r5
			LDR			R2,=stradding
re			cmp 		r1,#0x2
			BEQ			exit
			push		{lr}
			sub			r1,#1
			BL			re
			pop			{lr}		
			LDR			R3,[R2,#-8]
			LDR			R4,[R2,#-4]
			LSL			R4,#1
			ADD			R1,R3,R4
			STR			R1,[R2],#4
			MOV			PC,LR			
exit		MOV			R3,#0x0
			STR			r3,[r2],#0x4
			MOV			R3,#0x1
			STR			r3,[r2],#0x4
			MOV			pc,lr
			END