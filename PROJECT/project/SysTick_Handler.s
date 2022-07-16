ADC0_ADCPSSI		EQU 0x40038028 
ADC0_RIS			EQU	0x40038004
ADC0_ADCSSFIFO3 	EQU	0x400380A8 
ADC0_ADCISC			EQU	0x4003800C
COUNTER				EQU 0x20000100	
MAXINDEX			EQU 0x20000110
AMPL				EQU 0x20000120
STCTRL 				EQU 0xE000E010
GPIO_PORTF_DATA  	EQU 0x40025038
GPIO_PORTF_DATA1 	EQU 0x40025008
GPIO_PORTF_DATA2  	EQU 0x40025010
GPIO_PORTF_DATA3  	EQU 0x40025020
TIMER1_CTL			EQU 0x4003000C
TIMER1_TAPR			EQU 0x40030038

					AREA    systic_handler, READONLY, CODE
					THUMB
					EXPORT  MY_SysTick_Handler	
					EXTERN 	__main
					EXTERN 		arm_cfft_q15
					EXTERN 		arm_cfft_sR_q15_len256	
					EXTERN 		OutStr
					EXTERN 		OutChar
					IMPORT		SCR_CHAR
					IMPORT		SCR_XY						
					EXTERN		CONVRT
					EXTERN		PortF_unlock
MY_SysTick_Handler 	PROC		
					PUSH {R0,R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,LR}
					LDR R1,=0x20000400
					LDR R5,=ADC0_ADCPSSI
					MOV R0,#0x08;sampling started for ss3
					STR R0,[R5]
					
					LDR R5,=ADC0_RIS ;check flag
loop				LDR R0,[R5]
					
					CMP R0,#0X08 
					BNE loop
					
					LDR R5,=ADC0_ADCSSFIFO3
					LDR R0,[R5] ; fifo val in the R0
					

					LDR R9,=COUNTER
					LDR R8,[R9]
					MOV R7,#0
					LDR R6,=0x20000800
					CMP R8,#512
					BEQ fft
					STRH R0,[R1,R8]
					ADD R8,#2
					STRH R7,[R1,R8]
					ADD R8,#2
					STR R8,[R9]
					
					
					B son
fft					
					LDR	R1,=STCTRL
					MOV	R2,#0X00
					STR	R2,[R1]
					PUSH{LR}
					LDR R0,=arm_cfft_sR_q15_len256
					LDR R1,=0x20000400
					MOV R2,#0
					MOV R3,#1
					BL	arm_cfft_q15
					POP{LR}

 					LDR R5,=0x20000408
					MOV R7,#1
					LDR R9,=MAXINDEX
					STR R7,[R9]
					LDRSH R10,[R5],#2 
					MUL R4,R10,R10
					LDRSH R10,[R5],#2
					MUL R6,R10,R10
					ADD R4,R6
					
					mov	r8,#0
square					
					CMP R7,#128
					BEQ ENDOFFFT
					ADD R7,#1
					LDRSH R10,[R5],#2 
					MUL R6,R10,R10
					LDRSH R10,[R5],#2
					MUL R11,R10,R10
					ADD R6,R11
					CMP R4,R6 
					movlt R4,R6
					movlt R8,R7
					LDR R6,=AMPL
					STR R4,[R6]
					STR R8,[R9]
					B square
					
ENDOFFFT						
					LDR	R1,=COUNTER
					MOV	R2,#0X00
					STR	R2,[R1]
					LDR R9,=MAXINDEX
					LDR R4,[R9]
					mov R3,#1000
					MUL R4,R3
					LSR R4,#7
;					PUSH	{LR}
;					BL CONVRT
;					BL OutStr		
;					POP	{LR}
						
					PUSH		{LR}	
					MOV			R0,#0X15
					MOV			R1,#0X3
					BL			SCR_XY
					BL			CONVRT
					LDR			r4,=0x20000000
writ				LDRB		R5,[R4],#1
					MOV			R6,R5
					CMP			R6,#0X0d
					BEQ			cont
					BL			SCR_CHAR
						
					B			writ
						
cont				MOV			R0,#0X15
					MOV			R1,#0X4
					BL			SCR_XY
					LDR R9,=AMPL
					LDR R4,[R9]
					BL			CONVRT
					LDR			r4,=0x20000000
W8					LDRB		R5,[R4],#1
					MOV			R6,R5
					CMP			R6,#0X0d
					BEQ			CON
					BL			SCR_CHAR
					B			W8
					
					



CON				
					MOV	R5,#0X20			;SPACE
					BL	SCR_CHAR
					LDR R9,=AMPL

					LDR R6,[R9]
					LDR R9,=MAXINDEX
					LDR R4,[R9]
					
					
					BL	PortF_unlock
					POP	{LR}
					CMP R6,#0x7000
					BPL LEDRGB
					LDR R1,=GPIO_PORTF_DATA 	
					MOV R3,#0x00
					STR R3, [R1]
					MOV	R8,#50
					B finish
LEDRGB				
					CMP R4, #0x3A 
					BPL LEDGB
					LDR R1,=GPIO_PORTF_DATA	
					MOV R3,#0x02
					STR R3, [R1]
					MOV	R8,#8
					B finish
LEDGB
					CMP R4, #0x5A
					BPL LEDG
					LDR R1,=GPIO_PORTF_DATA	
					MOV R3,#0x08
					STR R3, [R1]
					MOV	R8,#6
					B finish
LEDG			
					LDR R1,=GPIO_PORTF_DATA  	
					MOV R3,#0x04
					STR R3, [R1]
					MOV	R8,#3

finish				
					LDR R1, =TIMER1_CTL 
					LDR R2, [R1]
					BIC R2, R2, #0x03
					STR R2, [R1]
					
					LDR R1, =TIMER1_TAPR
					STR R8, [R1] 
					LDR R1, =TIMER1_CTL 
					LDR R2, [R1]
					ORR R2, R2, #0x03
					STR R2, [R1]
					
					
					LDR	R1,=STCTRL
					MOV	R2,#0X03
					STR	R2,[R1]		
					
son
					LDR R5,=ADC0_ADCISC
					MOV R6,#0x08
					STR R6,[R5]
					POP {R0,R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,LR}
					BX LR
					ENDP
					END