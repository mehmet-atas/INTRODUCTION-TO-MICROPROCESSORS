			AREA    	main, READONLY, CODE
			THUMB
			EXPORT  	__main
			EXTERN		DELAY100
				
__main
			mov32		r2,#0x7fffffff

delay		bl			DELAY100
;	
loop		b			loop
			end