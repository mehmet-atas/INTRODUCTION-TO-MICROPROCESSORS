NUM	  	 	EQU	    	0x20000400

			AREA    	main, READONLY, CODE
			THUMB
			EXPORT  	__main
			EXTERN		CONVRT
			EXTERN		OutStr
			EXTERN		InChar

__main
done		mov32	r0,#0x567		;{
			
			
			ldr		r1,=NUM	
						;write the number into the memory starting from the address NUM
			str		r0,[r1]		;}
			bl		InChar		;wait until user presses a key
			ldr		r4,[r1]		;load the number from memory with address NUM
			bl		CONVRT		;convert hex number to decimal
			bl		OutStr		;print the number in decimal base
			b		done		;restart the code
			
			align
			end