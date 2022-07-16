			AREA    	DELAY500, READONLY, CODE
			THUMB
			EXPORT		DELAY500
				
__DELAY500
			push	{r0,r3}
			mov32	r0,#2000	;number needed for 100ms delay
			mov32	r3,#500000
count		cmp		r3,#1
			subs	r0,#1
			bne		count		
			pop		{r0,r3}
			bx 		lr
			
			end