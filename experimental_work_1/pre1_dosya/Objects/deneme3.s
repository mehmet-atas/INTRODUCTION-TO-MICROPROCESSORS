			AREA        sdata, DATA, READONLY
            THUMB
MSG1     	DCB     	"Please enter 'n' (with space at the end): "
			DCB			0x04
MSG2     	DCB			0x0d
			DCB     	"Is your number: "
			DCB			0x04
			
			AREA    	main, READONLY, CODE
			THUMB
			EXPORT  	__main
			EXTERN		CONVRT
			EXTERN		OutStr
			EXTERN		InNum
			EXTERN		UPBND
				
__main		LDR	   	R5,=MSG1		
		BL		OutStr			;print first message
			bl		InNum			;get the number 'n'
			mov		r1,r0
			mov		r0,#1
multiply	lsl		r0,#1
			subs	r1,#1
			bne		multiply		;find 2^n and make it upper boundry
			
			mov		r1,#0			;lower boundry=0
start		mov		r2,r1			
			mov		r3,r0
			add		r4,r0,r1
			lsr		r4,#1			;find mid point of the boundries
			LDR	    R5,=MSG2
			BL		OutStr			;print second message
			bl		CONVRT
			bl		OutStr			;print 'guess'
			bl		UPBND			;update boundries
			cmp		r2,r1			;{
			bne		start
			cmp		r3,r0			;	make another guess if boundries did change
			bne 	start			;}
			
done		b		done
			
			align
			end