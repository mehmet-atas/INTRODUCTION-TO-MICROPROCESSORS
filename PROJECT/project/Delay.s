			AREA    	delay, READONLY, CODE
			THUMB
			EXPORT  	DELAY100
			EXTERN		__main
DELAY100
			PUSH		{R0}
			MOV32		R0,#0x7A120; 500K in hex
Loop		SUBS		R0,#1
			BNE			Loop
			POP			{R0}
			BX			LR
			ALIGN
			END