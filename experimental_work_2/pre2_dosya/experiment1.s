GPIO_PORTB_DATA		EQU	0x400053fc
GPIO_PORTB_DIR		EQU 0x40005400
GPIO_PORTB_AFSEL	EQU 0x40005420
GPIO_PORTB_DEN		EQU 0x4000551C
GPIO_PORTB_PUR		EQU 0x40005510

GPIO_PORTF_DATA		EQU	0x40025018
GPIO_PORTF_DIR		EQU 0x40025400
GPIO_PORTF_AFSEL	EQU 0x40025420
GPIO_PORTF_DEN		EQU 0x4002551C
PORTF_LOCK_R		EQU	0x40025520
PORTF_CR			EQU	0x40025524
IOB 				EQU 0x0F
SYSCTL_RCGCGPIO		EQU 0x400FE608
			AREA        sdata, DATA, READONLY
            THUMB
MSG0				DCB "Old-School Key Pad", 13, "-----------------------", 13, "[a/b] [c/d] [e/f] [g/h]", 13, "[i/j] [k/l] [m/n] [o/p]", 13, "[q/r] [s/t] [u/v] [w/x]", 13, "[y/z] [,/.] [?/!] [>/_]", 13, "-----------------------", 13, 13,  4
	
			AREA    	main, READONLY, CODE
			THUMB
			EXPORT  	__main
			EXTERN		DELAY100
			EXTERN		OutChar
			EXTERN		OutStr

__main
			ldr		r1,=SYSCTL_RCGCGPIO
			ldr		r0,[r1]
			orr		r0,#0x22
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
			orr		r1,#0xf0
			str		r1,[r0]				;enable pull up resistor for input
			
			LDR 	R1,=PORTF_LOCK_R
			LDR 	R0,=0x4C4F434B
			STR 	R0,[R1]
			LDR 	R1,=PORTF_CR
			MOV 	R0,#0x06
			STR 	R0,[R1]
			
			ldr		r1,=GPIO_PORTF_DIR
			ldr		r0,[r1]
			bic		r0,#0xff
			orr		r0,#0x06			;define i/o ports
			str		r0,[r1]
			ldr		r1,=GPIO_PORTF_AFSEL
			ldr		r0,[r1]
			bic		r0,#0xff
			str		r0,[r1]
			ldr		r1,=GPIO_PORTF_DEN
			ldr		r0,[r1]
			orr		r0,#0xff
			str		r0,[r1]
			LDR	   	R5,=MSG0		
			BL		OutStr				;print first message
			
			ldr		r0,=GPIO_PORTF_DATA
			mov		r1,#0x04			;light the LED
			str		r1,[r0]	
			mov32	r3,#0x20000000
			mov32	r6,#0x20000001
			
firstRow	ldr		r0,=GPIO_PORTB_DATA
			mov		r5,#0xff
			mov		r1,#0x0e
			str		r1,[r0]				;make the output "0" for first row
			nop
			nop
			nop							;wait for output to stablize
			ldrb	r1,[r0]
			cmp		r1,#0xee
			moveq	r5,#0
			cmp		r1,#0xde
			moveq	r5,#1
			cmp		r1,#0xbe
			moveq	r5,#2
			cmp		r1,#0x7e
			moveq	r5,#3				;check for each column
			cmp		r5,#0xff
			bne		toggle				;start toggle operation if any key is detected
			
			mov		r1,#0x0d
			str		r1,[r0]				;make the output "0" for first row
			nop
			nop
			nop							;wait for output to stablize
			ldrb	r1,[r0]
			cmp		r1,#0xed
			moveq	r5,#4
			cmp		r1,#0xdd
			moveq	r5,#5
			cmp		r1,#0xbd
			moveq	r5,#6
			cmp		r1,#0x7d
			moveq	r5,#7				;check for each column
			cmp		r5,#0xff
			bne		toggle
			
			mov		r1,#0x0b
			str		r1,[r0]				;make the output "0" for first row
			nop
			nop
			nop							;wait for output to stablize
			ldrb	r1,[r0]
			cmp		r1,#0xeb
			moveq	r5,#8
			cmp		r1,#0xdb
			moveq	r5,#9
			cmp		r1,#0xbb
			moveq	r5,#10
			cmp		r1,#0x7b
			moveq	r5,#11				;check for each column
			cmp		r5,#0xff
			bne		toggle
			
			mov		r1,#0x07
			str		r1,[r0]				;make the output "0" for first row
			nop
			nop
			nop							;wait for output to stablize
			ldrb	r1,[r0]
			cmp		r1,#0xe7
			moveq	r5,#12
			cmp		r1,#0xd7
			moveq	r5,#13
			cmp		r1,#0xb7
			moveq	r5,#14
			cmp		r1,#0x77
			moveq	r5,#15				;check for each column
			cmp		r5,#0xff
			bne		toggle
			b		firstRow			;return to first row if no key is detected
			
toggle		bl		DELAY100			;wait 100ms for debouncing (for pressing)
			
check		ldrb	r1,[r0]
			and		r1,#0xf0
			cmp		r1,#0xf0
			bne		check				;wait until key is released
			
			strb	r5,[r3],#1
			ldr		r0,=GPIO_PORTF_DATA
			ldr		r1,[r0]
			eor		r2,r1,#0xff
			and		r2,#0x06
			str		r2,[r0]	
			cmp		r3,r6
			beq		firstRow
			ldrb	r4,[r3,#-2]
			cmp		r4,r5
			beq		firstRow
			
			cmp		r4,#0
			beq		zero
			cmp		r4,#1
			beq		one
			cmp		r4,#2
			beq		two
			cmp		r4,#3
			beq		three
			cmp		r4,#4
			beq		four
			cmp		r4,#5
			beq		five
			cmp		r4,#6
			beq		six
			cmp		r4,#7
			beq		seven
			cmp		r4,#8
			beq		eight
			cmp		r4,#9
			beq		nine
			cmp		r4,#10
			beq		ten
			cmp		r4,#11
			beq		eleven
			cmp		r4,#12
			beq		twelve1
			cmp		r4,#13
			beq		thirteen1
			cmp		r4,#14
			beq		fourteen1
			cmp		r4,#15
			beq		fifteen1

			
zero		cmp		r2,#0x04
			moveq	r5,#0x61
			bleq	OutChar
			movne	r5,#0x62
			blne	OutChar
			b		firstRow
one			cmp		r2,#0x04
			moveq	r5,#0x63
			bleq	OutChar
			movne	r5,#0x64
			blne	OutChar
			b		firstRow
two			cmp		r2,#0x04
			moveq	r5,#0x65
			bleq	OutChar
			movne	r5,#0x66
			blne	OutChar
			b		firstRow
three		cmp		r2,#0x04
			moveq	r5,#0x67
			bleq	OutChar
			movne	r5,#0x68
			blne	OutChar
			b		firstRow
four		cmp		r2,#0x04
			moveq	r5,#0x69
			bleq	OutChar
			movne	r5,#0x6a
			blne	OutChar
			b		firstRow
five		cmp		r2,#0x04
			moveq	r5,#0x6b
			bleq	OutChar
			movne	r5,#0x6c
			blne	OutChar
			b		firstRow
six			cmp		r2,#0x04
			moveq	r5,#0x6d
			bleq	OutChar
			movne	r5,#0x6e
			blne	OutChar
			b		firstRow
seven		cmp		r2,#0x04
			moveq	r5,#0x6f
			bleq	OutChar
			movne	r5,#0x70
			blne	OutChar
			b		firstRow
eight		cmp		r2,#0x04
			moveq	r5,#0x71
			bleq	OutChar
			movne	r5,#0x72
			blne	OutChar
			b		firstRow
nine		cmp		r2,#0x04
			moveq	r5,#0x73
			bleq	OutChar
			movne	r5,#0x74
			blne	OutChar
			b		firstRow
twelve1		b		twelve		;step for branch because it gives error
fifteen1	b		fifteen		;step for branch because it gives error
ten			cmp		r2,#0x04
			moveq	r5,#0x75
			bleq	OutChar
			movne	r5,#0x76
			blne	OutChar
			b		firstRow
eleven		cmp		r2,#0x04
			moveq	r5,#0x77
			bleq	OutChar
			movne	r5,#0x78
			blne	OutChar
			b		firstRow
fourteen1	b		fourteen	;step for branch because it gives error
thirteen1	b		thirteen	;step for branch because it gives error
twelve		cmp		r2,#0x04
			moveq	r5,#0x79
			bleq	OutChar
			movne	r5,#0x7a
			blne	OutChar
			b		firstRow
thirteen	cmp		r2,#0x04
			moveq	r5,#0x2c
			bleq	OutChar
			movne	r5,#0x2e
			blne	OutChar
			b		firstRow
fourteen	cmp		r2,#0x04
			moveq	r5,#0x3f
			bleq	OutChar
			movne	r5,#0x21
			blne	OutChar	
fifteen		cmp		r2,#0x04
			movne	r5,#0x5f
			blne	OutChar	


			
			b		firstRow
			end