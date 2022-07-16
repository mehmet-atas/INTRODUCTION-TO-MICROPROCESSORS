            AREA        sdata, DATA, READONLY
            THUMB
MSG1     	DCB     	"PLEASE ENTER NUMBER OF FIBONACCI SEQUENCE(with space at the end):"
			DCB			0x04
MSG2     	DCB			0x0d
			DCB     	"sequence is"
			DCB			0x04
stradding	EQU			0x20000200	
			
			AREA    	main, READONLY, CODE
			THUMB
			EXPORT  	__main
			EXTERN		Fibonacci
			EXTERN		OutStr
			EXTERN		CONVRT
			EXTERN		InNum			
__main
			MOV32 R6,#0X20000800
			MOV32 R7,#0X12345678
			STR	  R7,[R6]
start		
			LDR	   	R5,=MSG1
			
			BL		OutStr		
			BL		InNum
			MOV		R1,R5
			BL		Fibonacci
			POP		{R1-R4}
			LDR		r2,=stradding
Log			LDR		r4,[r2],#4
			BL		CONVRT
			BL		OutStr
			SUB		R1,#1
			CMP		R1,#0x0
			BNE		Log
			b		start	
			align
			end