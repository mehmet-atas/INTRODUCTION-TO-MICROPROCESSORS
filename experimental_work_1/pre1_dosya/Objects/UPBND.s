			AREA    	UPBND, READONLY, CODE
			THUMB
			EXPORT		UPBND
			EXTERN		InChar

__UPBND		PROC
			push	{lr}
			bl		InChar		;get the input (U,D,C)
			pop		{lr}
			cmp		r5,#0x43	
			beq		correct		;dont change boundries if input is C
			cmp		r5,#0x44
			beq		down
			cmp		r5,#0x55
			beq		up			;I assumed that inputs are 'only' (U,D,C)
down		mov		r0,r4		;change the upper boundry to 'guess' if input is D
			bx		lr
up			mov		r1,r4		;change the lower boundry to 'guess' if input is U
			bx		lr
correct		bx		lr
			
			endp