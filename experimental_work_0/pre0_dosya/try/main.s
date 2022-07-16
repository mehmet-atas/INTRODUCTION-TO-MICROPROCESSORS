
;SIFIRDAN_ARM_ÖGRENIYORUM 
;#############
;ARDUINO HOCAM
;############# 
;LECTURE:TIMER


					AREA main , CODE, READONLY
					THUMB
					EXTERN INIT_GPIO
					EXTERN INIT_TIMER0
					EXTERN TIMER0A_HANDLER
					EXTERN GPIO_PORTF_INIT
					EXPORT __main
__main					
					
					
					BL INIT_GPIO
					BL GPIO_PORTF_INIT
					BL INIT_TIMER0
					
loop				B loop					
					END


			
	
				
			
			
			
			
			
			
			
			