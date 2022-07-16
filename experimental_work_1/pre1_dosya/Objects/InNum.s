			AREA    	InNum, READONLY, CODE
			THUMB
			EXPORT		InNum
			EXTERN		InChar
				
__InNum		push	{r1-r3}
			mov		r0,#0		;input
			mov		r1,#0		;digit counter
			mov		r2,#1		;coefficient
			mov		r3,#10	
loop		push	{lr}
			bl		InChar
			pop		{lr}
			cmp		r5,#0x20
			pushne	{r5}		;push ascii value of the input characters untill 'space' character
			addne	r1,#1		;count the number of digits
			bne		loop
dec2hex		pop		{r5}
			sub		r5,#0x30	;ascii to decimal conversion
			mul		r5,r2		;multiply with the coefficient of the digit
			add		r0,r5		;sum value in hex
			mul		r2,r3		;change the coefficient for higher decimal place
			subs	r1,#1		
			bne		dec2hex		
			pop		{r1-r3}
			bx		lr
			end