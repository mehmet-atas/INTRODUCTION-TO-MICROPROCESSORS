GPIO_PORTE_DIR 		EQU 0x40024400 ; Port Direction
GPIO_PORTE_AMSEL 	EQU 0x40024528 ; Analog enable
GPIO_PORTE_PCTL 	EQU 0x4002452C ; Alternate Functions
GPIO_PORTE_AFSEL	EQU 0x40024420 ; Alt Function enable
GPIO_PORTE_DEN 		EQU 0x4002451C ; Digital Enable

	

	
ADC0_RIS			EQU	0x40038004 ;RIS REG FOR FLAG
ADC0_ADCSSFIFO3 	EQU	0x400380A8 ; FIFO REG for sequ.3
ADC0_ADCSSCTL3		EQU	0x400380A4 ; IE0 and END0 bit to tell ;sequencer stop or start etc.
ADC0_ADCPC			EQU	0x40038FC4 ; sample rate  3:0 BIT  set 0x01	
ADC0_ADCPSSI		EQU 0x40038028 ;  start sampling.
ADC0_ISC			EQU	0x4003800C ;CLEAR REG FOR FLAG
ADC0_ADCACTSS		EQU	0x40038000 ;enable/disable reg for sequencer
ADC0_ADCEMUX		EQU 0x40038014 ; 15:12 bits need to be cleared for ;trigger
ADC0_SSMUX3			EQU 0x400380A0	
RCGCADC				EQU 0x400FE638 ; Run Clock Gate Control ADC

SYSCTL_RCGCGPIO 	EQU 0x400FE608 ; GPIO Gate Control	
COUNTER				EQU 0x20000100	

MAXINDEX			EQU 0x20000110
SW					EQU	0x20000200
					AREA	messages, DATA, READONLY
					THUMB

				AREA    	main, READONLY, CODE
				THUMB
				EXPORT  	__main
				EXTERN		DELAY100
				EXTERN		PortF_unlock
				EXTERN 		OutStr
				EXTERN 		SETUP
				EXTERN		INIT_TIMER
				EXTERN 		OutChar
				EXTERN 		CONVRT
				EXTERN 		EDGE_TIMER	
				EXTERN 		arm_cfft_q15
				EXTERN 		arm_cfft_sR_q15_len256
				EXTERN		SCREEN_INIT
				EXTERN		SCREEN_ALWYS
PF_INP			EQU			0X400253C4
PF_OUT			EQU			0X40025038

__main			PROC
				
				MOV R7,#0
				LDR R9,=COUNTER
				STR R7,[R9]
				BL	SCREEN_INIT
				BL	SCREEN_ALWYS
				BL	INIT_TIMER
				BL 	EDGE_TIMER
				
	
				LDR R1, =SYSCTL_RCGCGPIO ; start GPIO clock
				LDR R0, [R1]
				ORR R0, R0, #0x10 ; set bit 6 for port E
				STR R0, [R1]
				NOP ; LET clock to settle
				NOP
				NOP
				NOP
				NOP
				LDR R0,=GPIO_PORTE_DIR
				MOV R1,#0x00 ;set as input
				STR R1,[R0]
				LDR R0,=GPIO_PORTE_AFSEL
				MOV	R1,#0x08 ;enable alternate func for ;pin3
				STR R1,[R0]
				LDR R0,=GPIO_PORTE_AMSEL
				MOV R1,#0x08 ; Enable analog for pin 3
				STR R1,[R0]
					
				LDR R0,=RCGCADC
				MOV R1,#0x01 ; start adc clock
				STR R1,[R0]
				NOP
				NOP
				NOP
				NOP
				NOP
				NOP
					
				LDR R1, = ADC0_ADCACTSS ;disable adc 
				MOV R0,#0x00
				STR R0,[R1]
					
				LDR R1,=ADC0_ADCEMUX ;Sample triggered by ;software
				MOV R0,#0x00
				STR R0,[R1]
					
				LDR R1,=ADC0_SSMUX3
				MOV R0,#0x00 
				STR R0,[R1]
					
				LDR R1,=ADC0_ADCSSCTL3
				MOV R0,#0x06 
				STR R0,[R1]
					
				LDR R1,=ADC0_ADCPC  ;125ksps
				MOV R0,#0X01
				STR R0,[R1]
					
				LDR R1,=ADC0_ADCACTSS ;
				MOV R0,#0X08
				STR R0,[R1]
				
				BL			PortF_unlock
							;IF R5 = 1 CW, R5 = 2 CCW, FIRST AND SECOND BUTTON CAN BE USED TO CHANGE THE DIRECTION
												;IF ITS UNWANTED, R5 CAN BE CHANGED TO #2 IN ORDER TO SEE THE CCW ACTION.
LOOP			LDR			R0,=PF_INP			;PORTF_DATA REGISTERININ ADRESINI R0'YA KAYDEDIYORUM
				LDRB		R1,[R0]				;PORTF_DATA REGISTERINDEKI DEGERI R1'E KAYDEDIYORUM
				AND 		R1,#0x11
				BL			DELAY100			;100MSEC BEKLIYORUM
				LDRB		R2,[R0]	
				AND 		R2,#0x11;PORTF_DATA REGISTERINDEKI DEGERI R2'YE KAYDEDIYORUM
				CMP			R1,R2				;DEBOUNCING ICIN KARSILASTIRMA YAPIYORUM
				BNE			LOOP				;DEGILSE YANLISLIK OLMUS, TEKRAR INPUT ALIYORUM
				CMP			R1,#0X11			;R1 VE R2 AYNI OLMASINA RAGMEN 0X11 ISELER, HICBIR TUSA BASILMAMIS DEMEKTIR, TEKRAR INPUT ALIYORUM
				BEQ			LOOP		
				CPY			R7,R1
RELEASE			LDRB		R1,[R0]
				AND 		R1,#0x11;PORTF_DATA'DA SAKLANAN DEGERI R1'E YUKLUYORUM
				BL			DELAY100
				LDRB		R2,[R0]
				AND 		R2,#0x11;PORTF_DATA'DA SAKLANAN DEGERI R2'YE YUKLUYORUM
				CMP			R1,R2				;DEBOUNCING
				BNE			RELEASE
				CMP			R1,#0X11			;EGER HALA TUSA BASILI ISE BIRAKANA KADAR BEKLIYORUM, RELEASE'YE DONUYORUM
				BNE			RELEASE				;EGER TUS BIRAKILDIYSA, R1'E 0XF0 YUKLENIYOR VE BU LOOP'TAN CIKILIYOR
				LDR 		R5,=SW
				STRB 		R7,[R5]
				b			LOOP
				

LOOP2 			B LOOP2			
				ENDP					
				END
