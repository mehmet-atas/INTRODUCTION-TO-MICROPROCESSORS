
;SIFIRDAN_ARM_ÖGRENIYORUM 
;#############
;ARDUINO HOCAM
;############# 
;LECTURE:TIMER
RELOAD_VALUE 		EQU 0XFFFF; reload value
SYSCTL_RCGCTIMER 	EQU 0x400FE604 ; GPTM Gate Control
; 16/32 Timer Registers
TIMER0_CFG			EQU 0x40030000;;for A and B 16bit/32bit selection,0x04 =16bit
TIMER0_TAMR			EQU 0x40030004;SET FUNC OF TIMER,;[1:0] 1=oneshot,2=periodic,3=capture
;[2]=0 edge count,1=edge time , [4]=0 count down,1=up
TIMER0_CTL			EQU 0x4003000C;TIMER0   (en/dis,fall/ris/both)
TIMER0_IMR			EQU 0x40030018

TIMER0_TAILR		EQU 0x40030028 ; Timer interval;
;in 16bit,value for count up or down .(if down, up to this number)
TIMER0_TAPR			EQU 0x40030038 ;presecalar
	

;Nested Vector Interrupt Controller registers
NVIC_EN0_INT19		EQU 0x00080000 ; Interrupt 19 enable
NVIC_EN0			EQU 0xE000E100 ; IRQ 0 to 31 Set Enable Register
NVIC_PRI4			EQU 0xE000E410 ; IRQ 16 to 19 Priority Register
	

					AREA init_timer0 , CODE, READONLY
					THUMB
					EXPORT INIT_TIMER0


INIT_TIMER0 PROC

					LDR R1,=SYSCTL_RCGCTIMER ;clock for timer
					LDR R0,[R1]
					ORR R0,#0x01
					STR R0,[R1]
					
					LDR R1,=TIMER0_CTL;disable timer first
					LDR R0,[R1]
					BIC R0,#0xFF
					STR R0,[R1]
					
					LDR R1,=TIMER0_CFG;
					LDR R0,[R1]
					ORR R0,#0x4 ;select 16-bit MODE
					STR R0,[R1]
					
					LDR R1,=TIMER0_TAMR;
					LDR R0,[R1]
					ORR R0,#0x2 ;periodic mode, down count 
					STR R0,[R1]
					
					LDR R1,=TIMER0_TAILR;RELOAD VALUE
					LDR R2,=RELOAD_VALUE
					STR R2,[R1] ; load reload value
					
					
					LDR R1,=TIMER0_TAPR;prescalar is select to 15 so the clock is 1 Mhz now
					MOV R2,#0x4F
					STR R2,[R1]
					
					LDR R1, =TIMER0_IMR ;enable timeout interrupt
					MOV R2, #0x01
					STR R2, [R1]
							
					
;INTERRUPT PRIORITY SET UP

					LDR R1,=NVIC_PRI4
					LDR R2,[R1]
					AND R2,#0x0FFFFFFF ;clear int#19 priority
					ORR R2,#0x40000000 ;set priority#19 as 2
					STR R2,[R1]
					
					
					LDR R1,=NVIC_EN0
					LDR R0,[R1]
					ORR R0,#0x00080000; SET bit 19 to 1 for enable interrupt #19
					STR R0,[R1]
					
					
					LDR R1,=TIMER0_CTL
					LDR R3,[R1]
					ORR R3,#0x03; enable timer
					STR R3,[R1]

					BX LR
					ENDP
						

