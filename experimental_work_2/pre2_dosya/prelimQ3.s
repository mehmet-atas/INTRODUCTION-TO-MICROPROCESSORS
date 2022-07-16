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
			EXTERN		OutChar

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
			
			
			ldr		r0,=GPIO_PORTB_DATA
firstRow	mov		r5,#0
			mov		r1,#0xe0
			str		r1,[r0]				;make the output "0" for first row
			nop
			nop
			nop							;wait for output to stablize
			ldrb	r1,[r0]
			cmp		r1,#0xee
			moveq	r5,#0x30
			cmp		r1,#0xed
			moveq	r5,#0x31
			cmp		r1,#0xeb
			moveq	r5,#0x32
			cmp		r1,#0xe7
			moveq	r5,#0x33			;check for each column
			cmp		r5,#0
			bne		print				;start print operation if any key is detected
			mov		r1,#0xd0
			str		r1,[r0]				;make the output "0" for second row
			nop
			nop
			nop							;wait for output to stablize
			ldrb	r1,[r0]
			cmp		r1,#0xde
			moveq	r5,#0x34
			cmp		r1,#0xdd
			moveq	r5,#0x35
			cmp		r1,#0xdb
			moveq	r5,#0x36
			cmp		r1,#0xd7
			moveq	r5,#0x37			;check for each column
			cmp		r5,#0
			bne		print				;start print operation if any key is detected
			mov		r1,#0xb0
			str		r1,[r0]				;make the output "0" for third row
			nop
			nop
			nop							;wait for output to stablize
			ldrb	r1,[r0]
			cmp		r1,#0xbe
			moveq	r5,#0x38
			cmp		r1,#0xbd
			moveq	r5,#0x39
			cmp		r1,#0xbb
			moveq	r5,#0x41
			cmp		r1,#0xb7
			moveq	r5,#0x42			;check for each column
			cmp		r5,#0
			bne		print				;start print operation if any key is detected
			mov		r1,#0x70
			str		r1,[r0]				;make the output "0" for fourth row
			nop
			nop
			nop							;wait for output to stablize
			ldrb	r1,[r0]
			cmp		r1,#0x7e
			moveq	r5,#0x43
			cmp		r1,#0x7d
			moveq	r5,#0x44
			cmp		r1,#0x7b
			moveq	r5,#0x45
			cmp		r1,#0x77
			moveq	r5,#0x46			;check for each column
			cmp		r5,#0
			bne		print				;start print operation if any key is detected
			b		firstRow			;return to first row if no key is detected
			
print		bl		DELAY100			;wait 100ms for debouncing (for pressing)
check		ldrb	r1,[r0]
			and		r1,#0x0f
			cmp		r1,#0x0f
			bne		check				;wait until key is released
			bl		OutChar
			mov		r5,#0x0d
			bl		OutChar				;print the key value and a newline
			bl		DELAY100			;wait 100ms for debouncing (for releasing)
			b		firstRow			;restart the code
			
			end
			