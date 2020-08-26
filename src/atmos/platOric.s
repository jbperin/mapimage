
; ------------------------------------------------------------------------
.export __TAPE__:abs = 1
.import __AUTORUN__, __PROGFLAG__
.import __BASHEAD_START__, __MAIN_LAST__

.segment "TAPE"

            .byte   $16, $16, $16, $16, $24, $00, $00
            .byte   <__PROGFLAG__
            .byte   <__AUTORUN__
            .dbyt   __MAIN_LAST__ - 1
            .dbyt   __BASHEAD_START__
            .byte   $00
            .byte   "GL65",0

; ======================================================================


; #define SCREEN_WIDTH            40
; #define SCREEN_HEIGHT           26
.define SCREEN_WIDTH	 40 
.define SCREEN_HEIGHT	26 

.import _fbuffer

.segment "CODE"
.export _glBuffer2Screen

ADR_BASE_LORES_SCREEN  = 48040

.proc _glBuffer2Screen

	ldy #$00

glBuffer2Screen_loop_01:

	lda _fbuffer, y 
	sta ADR_BASE_LORES_SCREEN,y
	lda _fbuffer+256, y 
	sta ADR_BASE_LORES_SCREEN+256,y
	lda _fbuffer+512, y 
	sta ADR_BASE_LORES_SCREEN+512,y
	lda _fbuffer+768, y 
	sta ADR_BASE_LORES_SCREEN+768,y
	iny
	bne glBuffer2Screen_loop_01

	ldy #$10

glBuffer2Screen_loop_02:

	lda _fbuffer+1024, y 
	sta ADR_BASE_LORES_SCREEN+1024,y
	dey
	bpl glBuffer2Screen_loop_02


    rts
.endproc

