
;SIFIRDAN_ARM_ÖGRENIYORUM 
;#############
;ARDUINO HOCAM
;############# 
;LECTURE:TIMER
GPIO_PORTB_DIR 		EQU 0x40005400;GPIO direction register
GPIO_PORTB_AFSEL 	EQU 0x40005420;GPIO alternate function select
GPIO_PORTB_DEN 		EQU 0x4000551C;GPIO Digital enable regisgter
GPIO_PORTB_AMSEL 	EQU 0x40005528;
GPIO_PORTB_PCTL 	EQU 0x4000552C;pctl register for timer function selection 
IOB 				EQU 0x00
SYSCTL_RCGCGPIO 	EQU 0x400FE608;run clock gate for gpio					
					
					
					AREA init_gpio , CODE, READONLY
					THUMB
					EXPORT INIT_GPIO
					EXPORT GPIO_PORTF_INIT
						
INIT_GPIO  PROC
;---------------------------------GPIO INIT BEGIN-------------------------------
;done in also previous video
					LDR R1,=SYSCTL_RCGCGPIO
					LDR R0,[R1]
					ORR R0,#0x2;enable port B
					STR R0,[R1]
					NOP 
					NOP
					NOP
					
					LDR R1,=GPIO_PORTB_DIR
					LDR R0,[R1]
					BIC R0,#0xFF
					ORR R0,#0x20;set PB6 as OUTPUT
					STR R0,[R1]
					
					LDR R1,=GPIO_PORTB_DEN
					LDR R0,[R1]
					BIC R0,#0xFF
					ORR R0,#0x01; digital enabled
					STR R0,[R1]
					
					LDR R1, =GPIO_PORTB_AFSEL
					LDR R0,[R1]
					BIC R0,#0xFF
					ORR R0,#0x40 ;set the pin6 as alternative function
					STR R0,[R1]
					
					LDR R1,=GPIO_PORTB_PCTL
					LDR R0,[R1]
					BIC R0,#0xFF
					ORR R0,#0x07000000;for PB6, 7 means it is TIMER on the tabel!
					STR R0,[R1]
					
					BX LR
					ENDP
;---------------------------------GPIO INIT END-------------------------------
;done in also previous video


;Port F base address is : 0x40025000
GPIO_PORTF_DIR			EQU	0x40025400
PORT_F_Pin_OUTPUTS		EQU	0x0E ; 0000_1110 PF1,PF2,PF3 are outputs	
GPIO_PORTF_AFSEL		EQU 0x40025420 ;PORTF AFSEL 
GPIO_PORTF_DEN			EQU 0x4002551C ;portf den
GPIO_PORTF_DATA			EQU	0x40025038; DATA REGISTER	

GPIO_PORTF_INIT	PROC
					
					LDR R1,=SYSCTL_RCGCGPIO
					LDR R0,[R1]
					ORR R0,R0,#0x20 ;enable port F ,disable rest of the ports
					STR R0,[R1]
					NOP
					NOP
					NOP ; let the GPIO clock stabilize

					LDR R1,=GPIO_PORTF_DIR
					LDR R0,[R1]
					BIC R0,#0xFF ;clear pins 0-7
					ORR R0,#PORT_F_Pin_OUTPUTS;set PF1 PF2 PF3 as output
					STR R0,[R1]
					
					LDR R1,=GPIO_PORTF_AFSEL
					LDR R0,[R1]
					BIC R0,#0xFF ;clear all pins as no alternate function
					STR R0,[R1]

					LDR R1,=GPIO_PORTF_DEN
					LDR R0,[R1]
					ORR R0,#0xFF ;SET AS ALL DIGITAN ENABLED
				    STR R0,[R1]

					BX LR
					ENDP
