
;SIFIRDAN_ARM_ÖGRENIYORUM 
;#############
;ARDUINO HOCAM
;############# 
;LECTURE:TIMER
GPIO_PORTF_DATA		EQU	0x40025038; DATA REGISTER WITH MASK PF1 PF2 FP3	
COMPARE_VALUE		EQU 0x0E  ;used for the gpio state comparison
TIMER0_ICR			EQU 0x40030024 ; Timer Interrupt Clear

					
					AREA 	my_handler_for_timer, CODE, READONLY
					THUMB
					EXPORT 	TIMER0A_HANDLER
;done in also previous video
					
TIMER0A_HANDLER PROC

					LDR R1,=TIMER0_ICR ;clear interrupt flag
					MOV R0,#0x01
					STR R0,[R1]

					LDR R1,=GPIO_PORTF_DATA ; read the masked gpio data
					LDR R2,[R1]
					MOV R8,#COMPARE_VALUE
					
					CMP R2, R8 ; if the pin was high
					BEQ reset_gpio;if equal , then reset gpio pin
					MOV R8,#COMPARE_VALUE ;
					STR R8,[R1]
					B finish			
					
reset_gpio			MOV R8,#0x00 ;reset gpio
					STR R8,[R1]
			


finish
					BX LR
					ENDP
						
