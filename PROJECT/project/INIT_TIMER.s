STCTRL 		EQU 0xE000E010;control register
STRELOAD	EQU 0xE000E014;reload register
STCURRENT	EQU	0xE000E018;current register 24 bit
LOAD_VAL	EQU 0x000007D0
SHP_SYSPRI3	EQU	0XE000ED20

			AREA    timer_init, READONLY, CODE
			THUMB
			EXPORT  INIT_TIMER	
			EXTERN 	__main

INIT_TIMER
PROC
			LDR R1,=STCTRL
			LDR R0,[R1]
			BIC R0,#0xFF ;disable first 
			STR R0, [R1]
			
			LDR R0,=LOAD_VAL ; load the reload value
			STR R0,[R1,#4];offset is 4  for reload register
			STR R0,[R1,#8];offset is 8 for stcurrent register 
			MOV R4,#0x3 ;start timer 
			STR R4,[R1]
			
			LDR			R1,=SHP_SYSPRI3
			MOV			R0,#0X40000000			;PRIORITY SET TO 2
			STR			R0,[R1]
			BX LR
			ENDP
