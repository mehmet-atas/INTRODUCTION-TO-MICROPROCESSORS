GPIO_PORTB_DATA		EQU	0x400053fc
GPIO_PORTB_DIR		EQU 0x40005400
GPIO_PORTB_AFSEL	EQU 0x40005420
GPIO_PORTB_DEN		EQU 0x4000551C
GPIO_PORTB_PUR		EQU 0x40005510
IOB 				EQU 0xF0
SYSCTL_RCGCGPIO		EQU 0x400FE608

			AREA    	main, READONLY, CODE
			THUMB
			EXPORT  	__main
			EXTERN		DELAY100

__main
			ldr		r1,=SYSCTL_RCGCGPIO	
			ldr		r0,[r1]
			orr		r0,#0x02
			str		r0,[r1]				;start clock for pin B
			nop
			nop
			nop
			
			ldr		r1,=GPIO_PORTB_DIR
			ldr		r0,[r1]
			bic		r0,#0xff
			orr		r0,#IOB				;define i/o ports
			str		r0,[r1]
			ldr		r1,=GPIO_PORTB_AFSEL
			ldr		r0,[r1]
			bic		r0,#0xff
			str		r0,[r1]
			ldr		r1,=GPIO_PORTB_DEN
			ldr		r0,[r1]
			orr		r0,#0xff
			str		r0,[r1]
			ldr		r0,=GPIO_PORTB_PUR
			orr		r1,#0x0f
			str		r1,[r0]				;enable pull up resistor for input
			
			
getit		ldr		r0,=GPIO_PORTB_DATA
			ldr		r1,[r0]				;read inputs
			mov		r2,r1
			lsl		r2,#4				;shift input to output
			str		r2,[r0]				;give according output
			mov		r0,#10
delay		bl		DELAY100
			subs	r0,#1
			bne		delay				;wait for 5s
			b		getit				;restart the code
			
			end