
;TURBO WIESZCZ++ 2.0 FOR ZX81 / rewritten from my ZX SPECTRUM version
;(C)2017 NONIEWICZ.COM
;created 20171205 0130-0245 = 1h15m
;updated 20171206 0040-0125 = 0h45m
;updated 20171206 1500-1605 = 1h05m
;updated 20171206 1645-1845 = 2h00m
;updated 20171206 1935-2040 = 1h05m
;updated 20171206 2140-2220 = 0h40m

;todo:
;- ?


;note:
;RST16 is the same as in ZX48
;ASCII 2 zx81 - https://en.wikipedia.org/wiki/ZX81_character_set
;http://forum.tlienhard.com/TS1000/www.ts1000.us/memorymap.htm


TTCNT	EQU	32
RCNT	EQU	32
ZCNT	EQU	4
WCNT	EQU	4

;zx81
CLS		EQU	#0a2a
KEYBOARD	EQU	#02bb
DECODE		EQU	#07bd

KEY_SPC		EQU	0
KEY_A		EQU	38
KEY_X		EQU	61
KEY_R		EQU	55
KEY_H		EQU	45
KEY_Z		EQU	63
KEY_M		EQU	50

;-- ZX81
;learned from
;https://github.com/utz82/ZX81-1bit-Routines/blob/master/1k2b/main.asm

	org #4009

	db 0		;VERSN
	dw 0		;E_PPC
	dw dfile	;D_FILE
	dw dfile+1	;DF_CC
	dw var		;VARS
	dw 0		;DEST
	dw var+1	;E_LINE
	dw last-1	;CH_ADD
	dw 0		;X_PTR
	dw last		;STKBOT
	dw last		;STKEND
	db 0		;BERG
	dw membot	;MEM
	db 0		;not used
	db 2		;DF_SZ
	dw 1		;S_TOP
	db #ff,#ff,#ff	;LAST_K
	db 55		;MARGIN
	dw line10	;NXTLIN
	dw 0		;OLDPPC
	db 0		;FLAGX
	dw 0		;STRLEN
	dw #0c8d	;T_ADDR
	dw 0		;SEED
	dw #ffff	;FRAMES
	db 0,0		;COORDS
	db #bc		;PR_CC
	db 33,24	;S_POSN
	db #40		;CDFLAG (bit 7 reset = FAST mode)

membot equ $+33		;401F:5D40

;65 bytes that can hopefully be used

;	ds 33		;Print buffer

;variables
NUMER	ds	32	;32
BREAK	ds	1	;1

;	ds 30		;Calculator´s memory area

SEED	ds	2	;2
PER8	ds	1	;1
TMP1	ds	1	;1
MODE2	ds	1	;1
MODE3	ds	1	;1
N	dw	0	;2

	ds	30-2-1-1-1-1-2

;	ds 2		;not used

TYTUL	ds	2	;2

;BASIC upstart
 
line0			;#407d
	db 0, 0		;line number
	dw line10-$-2	;line length
	db #ea		;REM

;-- ZX81

START			;16514 = #4082
	XOR	A
	LD	(MODE2), A
	LD	(MODE3), A
	LD	A, R
	LD	(SEED), A
	XOR	111
	LD	(SEED+1), A

SUPER	LD	A, 255
	LD	(BREAK), A

	CALL	ABOUT1
	CALL	WK_SPC
	CALL	HELP1
	CALL	WK_SPC
	CALL	CLS

MAIN	CALL	WIERSZ
	LD	A, 255
	LD	(BREAK), A
	LD	HL, (TYTUL)
	CALL	LINE
	CALL	CRLF
	LD	HL,(NUMER)
	CALL	LINE
	LD	HL,(NUMER+2)
	CALL	LINE
	LD	HL,(NUMER+4)
	CALL	LINE
	LD	HL,(NUMER+6)
	CALL	LINE
	CALL	CRLF
	LD	HL,(NUMER+8)
	CALL	LINE
	LD	HL,(NUMER+10)
	CALL	LINE
	LD	HL,(NUMER+12)
	CALL	LINE
	LD	HL,(NUMER+14)
	CALL	LINE
	CALL	CRLF
	LD	HL,(NUMER+16)
	CALL	LINE
	LD	HL,(NUMER+18)
	CALL	LINE
	LD	HL,(NUMER+20)
	CALL	LINE
	LD	HL,(NUMER+22)
	CALL	LINE
	CALL	CRLF
	LD	HL,(NUMER+24)
	CALL	LINE
	LD	HL,(NUMER+26)
	CALL	LINE
	LD	HL,(NUMER+28)
	CALL	LINE
	LD	HL,(NUMER+30)
	CALL	LINE

WDONE	LD	A, (BREAK)
	CP	KEY_A
	JP	Z, ABOUT
	CP	KEY_H
	JP	Z, HELP
	CP	KEY_SPC
	JR	Z, POST1

LOOP0	LD	A, (MODE2)
	BIT	3, A
	JR	NZ, AUTOM
;	LD	A, (IY-54)
	call	kscan
	CP	KEY_A
	JP	Z, ABOUT
	CP	KEY_R
	JR	Z, RYMCHA
	CP	KEY_Z
	JR	Z, REPCHA
	CP	KEY_M
	JR	Z, AUTCHA
	CP	KEY_H
	JP	Z, HELP
	cp	KEY_SPC
	JR	NZ, LOOP0

POST1	CALL	CLS
	JP	MAIN

AUTOM	CALL	PAUS10
;	LD	A, (IY-54)
	call	kscan
	CP	KEY_A
	JR	Z, ABOUT
	CP	KEY_H
	JR	Z, HELP
	CP	KEY_R
	JR	Z, RYMCHA
	CP	KEY_Z
	JR	Z, REPCHA
	CP	KEY_M
	JR	Z, AUTCHA
	JR	POST1

POST2	CALL	WK0
	JP	WDONE

;;; todo: tu 1 test kbd

REPCHA	LD	A, (MODE2)
	XOR	4
	LD	(MODE2), A
	JR	POST2

AUTCHA	LD	A, (MODE2)
	XOR	8
	LD	(MODE2), A
	JR	POST1

RYMCHA	LD	A, (MODE3)
	INC	A
	AND	3
	CP	3
	JR	NZ, RYMC1
	XOR	A
RYMC1	LD	(MODE3), A
	JR	POST2

ABOUT	CALL	ABOUT1
	JP	WDONE

HELP	CALL	HELP1
	JP	WDONE

ABOUT1	LD	A, 255
	LD	(BREAK), A
	CALL	CLS
	LD	HL, ABO
	JP	LINE

HELP1	LD	A, 255
	LD	(BREAK), A
	CALL	CLS
	LD	HL, OPTS
	JP	LINE

WK0
;	LD	A, (IY-54)
	call	kscan
	CP	255
	JR	Z, WK0		;NZ -> Z / zx48 -> zx81
	RET

WK_SPC
	halt
	halt
	call	kscan
	CP	KEY_SPC
	JR	NZ, WK_SPC
	RET

DELAY	NOP
	DJNZ	DELAY
	RET

SETRND	CALL	RND
	AND	RCNT-1
	LD	D,0
	LD	E,A
	LD	A,(TMP1)
	AND	3
	LD	HL,(RYM)
	CP	0
	JR	Z,SET2
	LD	HL,(RYM+2)
	CP	1
	JR	Z,SET2
	LD	HL,(RYM+4)
	CP	2
	JR	Z,SET2
	LD	HL,(RYM+6)
SET2	ADD	HL,DE
	ADD	HL,DE
	RET

SETRYM	LD	A,(MODE3)
	AND	3
	CP	2
	JR	Z,AABB
	CP	1
	JR	Z,ABBA
	LD	HL,D0_A
	LD	(RYM),HL
	LD	HL,D1_A
	LD	(RYM+2),HL
	LD	HL,D2_A
	LD	(RYM+4),HL
	LD	HL,D3_A
	LD	(RYM+6),HL
	RET
ABBA	LD	HL,D0_A
	LD	(RYM),HL
	LD	HL,D1_A
	LD	(RYM+2),HL
	LD	HL,D3_A
	LD	(RYM+4),HL
	LD	HL,D2_A
	LD	(RYM+6),HL
	RET
AABB	LD	HL,D0_A
	LD	(RYM),HL
	LD	HL,D2_A
	LD	(RYM+2),HL
	LD	HL,D1_A
	LD	(RYM+4),HL
	LD	HL,D3_A
	LD	(RYM+6),HL
	RET

WIERSZ	CALL	SETRYM
	CALL	RND
	AND	TTCNT-1
	LD	D, 0
	LD	E, A
	LD	HL, TTLS
	ADD	HL, DE
	ADD	HL, DE

	LD	A, (HL)
	LD	(TYTUL), A
	INC	HL
	LD	A, (HL)
	LD	(TYTUL+1), A

	LD	B, ZCNT*WCNT
	LD	DE, NUMER
	XOR	A
	LD	(TMP1), A
SGEN	PUSH	BC
	PUSH	DE
	CALL	SETRND
	POP	DE
	POP	BC

	LD	A, (MODE2)
	BIT	2, A
	JR	NZ, SG1
	CALL	RCHCK
	OR	A
	JR	Z, SGEN

SG1	LD	A, (TMP1)
	INC	A
	AND	3
	LD	(TMP1), A
	LD	A, (HL)
	LD	(DE), A
	INC	DE
	INC	HL
	LD	A, (HL)
	LD	(DE), A
	INC	DE
	DJNZ	SGEN
	RET

RCHCK	LD	A, B
	CP	ZCNT*WCNT
	RET	Z
	CP	ZCNT*WCNT-1
	RET	Z
	CP	ZCNT*WCNT-2
	RET	Z
	CP	ZCNT*WCNT-3
	RET	Z

	LD	A, ZCNT*WCNT
	SUB	B
	SUB	4
	PUSH	BC
	PUSH	DE
	PUSH	HL
	LD	E, (HL)
	INC	HL
	LD	D, (HL)

	LD	HL, CDATA
	LD	C, A
	LD	B, 0
	ADD	HL, BC
	ADD	HL, BC
	ADD	HL, BC
	ADD	HL, BC
	ADD	HL, BC
	ADD	HL, BC

	LD	C, (HL)
	INC	HL
	LD	B, (HL)
	LD	(RP1+1), BC
	INC	HL
	LD	C, (HL)
	INC	HL
	LD	B, (HL)
	LD	(RP2+1), BC
	INC	HL
	LD	C, (HL)
	INC	HL
	LD	B, (HL)
	LD	(RP3+1), BC

RP1	LD	HL, (0)
	SBC	HL, DE
	LD	A, H
	OR	L
	JR	Z, R_BAD

RP2	LD	HL, (0)
	SBC	HL, DE
	LD	A, H
	OR	L
	JR	Z, R_BAD

RP3	LD	HL, (0)
	SBC	HL, DE
	LD	A, H
	OR	L
	JR	Z, R_BAD

R_OK	LD	A, 1
	JR	R_E
R_BAD	XOR	A
R_E	POP	HL
	POP	DE
	POP	BC
	RET

RND	PUSH	HL
	PUSH	DE
	LD	HL, (SEED)
	LD	A, R
	LD	D, A
	LD	E, (HL)
	ADD	HL, DE
	ADD	A, L
	XOR	H
	LD	(SEED), HL
	POP	DE
	POP	HL
	RET

LINE	PUSH	BC
LNX	LD	A, (BREAK)
	CP	255
	JR	NZ, LEXT
	LD	A, (HL)
	cp	255		;zx81 marker is 255
	JR	Z, LEXT
	INC	HL
	CALL	CHAR
	JR	LNX
LEXT	POP	BC
CRLF	LD	A, 118	;13
	RST	16
	RET

CHAR	RST	16
;	LD	A, (IY-54)
	call	kscan
	CP	KEY_X
	JR	Z, CFAST
	CALL	RND
	AND	%01100000
	OR	%00000001
	LD	C, A
CWAIT2	LD	B, 47-27	;zx81 speedup
	CALL	CWAIT
	DEC	C
	LD	A, C
	OR	C
	JR	NZ, CWAIT2
CFAST
;	LD	A, (IY-54)
	call	kscan
	CP	KEY_SPC
	JR	Z, CHKEY
	CP	KEY_A
	JR	Z, CHKEY
	CP	KEY_H
	JR	Z, CHKEY
	RET
CHKEY	LD	(BREAK), A
	RET

CWAIT	NOP
	DJNZ	CWAIT
	RET

PAUS10	LD	B, 250
PA10	HALT
	HALT
;	LD	A, (IY-54)
	call	kscan
	CP	KEY_X
	JR	Z, PAON
	CP	255
	JR	NZ, PAEND
PAON	DJNZ	PA10
PAEND	RET

;--- zx81 specific keyboard read

kscan
	ld	a, 255
	push	bc
	push	de
	push	hl
	CALL	KEYBOARD
	LD	B, H
	LD	C, L
	LD	D, C
	INC	D
	JR	Z, kscx		;no char?
	CALL	DECODE
	LD A,	(HL)
kscx	pop	hl
	pop	de
	pop	bc
	ret

;---

;more variables/data
RYM	ds	4*32	;4*32

CDATA
	dw	NUMER+0,N,N
	dw	NUMER+2,N,N
	dw	NUMER+4,N,N
	dw	NUMER+6,N,N
	dw	NUMER+0,NUMER+8,N
	dw	NUMER+2,NUMER+10,N
	dw	NUMER+4,NUMER+12,N
	dw	NUMER+6,NUMER+14,N
	dw	NUMER+0,NUMER+8,NUMER+16
	dw	NUMER+2,NUMER+10,NUMER+18
	dw	NUMER+4,NUMER+12,NUMER+20
	dw	NUMER+6,NUMER+14,NUMER+22

INCLUDE "tw-data.asm"

;----

;db #76		;newline			;not needed since no LISTing is ever produced
line10
	db 0, 10	;line number
	dw dfile-$-2	;line length
	db #f5		;PRINT
	db #d4		;USR
	db #1d		;1
	db #22		;6
	db #21		;5
	db #1d		;1
	db #20		;4
	db #7e		;FP mark
	db #8f		;5 bytes FP number
	db #01
	db #04
	db #00
	db #00
;	db #76		;newline			;not needed, can use first byte 

dfile
	db #76
	db #76,#76,#76,#76,#76,#76,#76,#76
	db #76,#76,#76,#76,#76,#76,#76,#76
	db #76,#76,#76,#76,#76,#76,#76,#76

var	db #80		;2 bytes, actually! [?]

last
