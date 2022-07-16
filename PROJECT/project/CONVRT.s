FIRST	   	EQU	    	0x20000000	
			AREA    	CONVRT, READONLY, CODE
			THUMB
			EXPORT		CONVRT
				
__CONVRT
			push	{r0-r4}
			ldr		r5,=FIRST			
			mov		r0,#0x30			
			mov32	r1,#1000000000		
			mov		r2,#10
			mov		r3,#0xa				
check		subs	r4,r1
			addpl	r0,#1				
			bpl		check
			add		r4,r1				
			str		r0,[r5]				
			cmp		r0,#0x30			
			cmpeq	r5,#FIRST			
			
			addne	r5,#1				
			mov		r0,#0x30			
			udiv	r1,r2				
			subs	r3,#1				
			bne		check
			cmp		r5,#FIRST
			addeq	r5,#1				
			mov		r0,#0x040d			
			str		r0,[r5]				
			ldr		r5,=FIRST			
			POP		{R0-R4}
			bx		lr
			
			align
			end