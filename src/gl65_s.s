;; =======================================
;; 	       gl65 3D            v1.0
;; =======================================
;;   3D graphic library for 6502 platforms 
;;			
;;			by Jean-Baptiste PERIN 
;;
;;  advised by the great Mickael POINTIER 
;;                        (a.k.a Dbug)
;;  for insane optimizations 
;; =======================================
;; 
;; Copyright 2020 Jean-Baptiste PERIN
;; Email: jbperin@gmail.com
;;
;; Website: https://github.com/jbperin/gl65
;; 
;; =======================================



.include "config.inc"



NB_MAX_POINTS			= 64
NB_MAX_SEGMENTS			= 64
NB_MAX_PARTICULES       = 64
NB_MAX_FACES            = 64

.import popax
.import popa
.importzp ptr1, ptr2, ptr3, ptr4 ; 16 bits
.importzp tmp1, tmp2, tmp3, tmp4; 8 bits

;;    ___                                      
;;   / __\  __ _  _ __ ___    ___  _ __   __ _ 
;;  / /    / _` || '_ ` _ \  / _ \| '__| / _` |
;; / /___ | (_| || | | | | ||  __/| |   | (_| |
;; \____/  \__,_||_| |_| |_| \___||_|    \__,_|
                                            
.export _glCamPosX, _glCamPosY, _glCamPosZ
.export _glCamRotZ, _glCamRotX
.segment    "DATA" 
;; Camera Position
_glCamPosX:		.byte 0
_glCamPosY:		.byte 0
_glCamPosZ:		.byte 0

;; Camera Orientation
_glCamRotZ:		.byte 0			
_glCamRotX:		.byte 0


;;  __                            
;; / _\     ___   ___  _ __    ___
;; \ \     / __| / _ \| '_ \  / _ \
;; _\ \   | (__ |  __/| | | ||  __/
;; \__/    \___| \___||_| |_| \___|


.export _glNbSegments, _glNbParticles, _glNbFaces
.export _glSegmentsPt1, _glSegmentsPt2, _glSegmentsChar
.export _glParticlesPt, _glParticlesChar
.export _glFacesPt1, _glFacesPt2, _glFacesPt3, _glFacesChar


_glNbSegments:         .res 1
_glNbParticles:       .res 1
_glNbFaces:            .res 1

_glSegmentsPt1:        .res NB_MAX_SEGMENTS
_glSegmentsPt2:        .res NB_MAX_SEGMENTS
_glSegmentsChar:       .res NB_MAX_SEGMENTS

_glParticlesPt:       .res NB_MAX_PARTICULES
_glParticlesChar:     .res NB_MAX_PARTICULES

_glFacesPt1:           .res NB_MAX_FACES
_glFacesPt2:           .res NB_MAX_FACES
_glFacesPt3:           .res NB_MAX_FACES
_glFacesChar:          .res NB_MAX_FACES

;;    ___                 _              _    _               
;;   / _ \ _ __   ___    (_)  ___   ___ | |_ (_)  ___   _ __  
;;  / /_)/| '__| / _ \   | | / _ \ / __|| __|| | / _ \ | '_ \ 
;; / ___/ | |   | (_) |  | ||  __/| (__ | |_ | || (_) || | | |
;; \/     |_|    \___/  _/ | \___| \___| \__||_| \___/ |_| |_|
;;                     |__/                                   

.export _projOptions, _glNbVertices
.export _glVerticesX, _glVerticesY, _glVerticesZ, _points2aH, _points2aV, _points2dH, _points2dL


_projOptions:        .res 1
_glNbVertices:           .res 1

_glVerticesX:          .res NB_MAX_POINTS
_glVerticesY:          .res NB_MAX_POINTS
_glVerticesZ:          .res NB_MAX_POINTS

_points2aH:          .res NB_MAX_POINTS
_points2aV:          .res NB_MAX_POINTS
_points2dH:          .res NB_MAX_POINTS
_points2dL:          .res NB_MAX_POINTS


.export _PointX, _PointY, _PointZ


;; Point 3D Coordinates
_PointX:		.word 0
_PointY:		.word 0
_PointZ:		.word 0

.export _ResX, _ResY


;; Point 2D Projected Coordinates
_ResX:			.word 0	
_ResY:			.word 0


;; Intermediary Computation
_DeltaX:		.word 0
_DeltaY:		.word 0
_DeltaZ:		.word 0

_Norm:          .word 0
_AngleH:        .byte 0
_AngleV:        .byte 0

AnglePH: .byte 0 ; horizontal angle of point from player pov
AnglePV: .byte 0 ; vertical angle of point from player pov
HAngleOverflow: .byte 0 
VAngleOverflow: .byte 0 

.export _isFace2BeDrawn;
_isFace2BeDrawn:  .byte 0

.export _idxPt1, _idxPt2, _idxPt3
_idxPt1:         .byte 0
_idxPt2:         .byte 0
_idxPt3:         .byte 0

.export _P1X, _P1Y, _P2X, _P2Y, _P3X, _P3Y

_P1X: .byte 0
_P1Y: .byte 0
_P2X: .byte 0
_P2Y: .byte 0
_P3X: .byte 0
_P3Y: .byte 0

.export _P1AH, _P1AV, _P2AH, _P2AV, _P3AH, _P3AV
_P1AH: .byte 0
_P1AV: .byte 0
_P2AH: .byte 0
_P2AV: .byte 0
_P3AH: .byte 0
_P3AV: .byte 0

.export _dmoy, _distseg, _distface, _distpoint, _ch2disp
_dmoy:         .word 0

_distface: .byte 0
_distseg: .byte 0
_distpoint: .byte 0
_ch2disp: .byte 0

.export _pDepX , _pDepY, _pArr1X, _pArr1Y, _pArr2X, _pArr2Y

_pDepX:  .byte 0
_pDepY:  .byte 0
_pArr1X: .byte 0
_pArr1Y: .byte 0
_pArr2X: .byte 0
_pArr2Y: .byte 0

.export _mDeltaY1, _mDeltaX1, _mDeltaY2, _mDeltaX2

_mDeltaY1: .byte 0
_mDeltaX1: .byte 0
_mDeltaY2: .byte 0
_mDeltaX2: .byte 0

.export _m1, _m2, _m3, _v1, _v2, _v3
; unsigned char m1, m2, m3;
_m1:         .byte 0
_m2:         .byte 0
_m3:         .byte 0
; unsigned char v1, v2, v3;
_v1:         .byte 0
_v2:         .byte 0
_v3:         .byte 0

.export _A1XSatur, _A2XSatur
_A1XSatur: .byte 0
_A2XSatur: .byte 0

.export _A1X, _A1Y, _A1destX, _A1destY, _A1dX, _A1dY, _A1err, _A1sX, _A1sY, _A1arrived
.export _A2X, _A2Y, _A2destX, _A2destY, _A2dX, _A2dY, _A2err, _A2sX, _A2sY, _A2arrived

_A1X: 	.byte 0
_A1Y: 	.byte 0
_A1destX: .byte 0
_A1destY: .byte 0
_A1dX: .byte 0
_A1dY: .byte 0
_A1err: .byte 0
_A1sX: .byte 0
_A1sY: .byte 0
_A1arrived: .byte 0
_A2X: .byte 0
_A2Y: .byte 0
_A2destX: .byte 0
_A2destY: .byte 0
_A2dX: .byte 0
_A2dY: .byte 0
_A2err: .byte 0
_A2sX: .byte 0
_A2sY: .byte 0
_A2arrived: .byte 0

.export _A1Right, _lineIndex, _departX, _finX, _hLineLength

_A1Right: .byte 0

_lineIndex:   .byte 0
_departX:     .byte 0
_finX:        .byte 0
_hLineLength: .byte 0

ptrpt3 		:= ptr3
ptrpt2 		:= ptr2
;;glNbVertices 	:= tmp1
;;opts 		:= tmp1
_res		:= tmp2
_tx		:= tmp3
_ty		:= tmp4


.segment "CODE"

;---------------------------------------------------------------------------------
;void glProject (char *tabpoint2D, char *tabpoint3D, unsigned char glNbVertices, unsigned char opts);
;---------------------------------------------------------------------------------

.export _glProject

.proc _glProject
	;;sta tmp1		;opts
	jsr popa
	sta _glNbVertices		;glNbVertices
	jsr popax		;get tabpoint3D
	sta ptrpt3
	stx ptrpt3+1
	jsr popax		;get tabpoint2D
	sta ptrpt2
	stx ptrpt2+1

    ldx _glNbVertices		;glNbVertices
    dex
    txa ; ii = glNbVertices - 1
    asl
    asl ; ii * SIZEOF_3DPOINT (4)
    clc
    adc #$03
    tay
    
    ldx _glNbVertices		;glNbVertices
    dex
    txa ; ii = glNbVertices - 1
    asl
    asl ; ii * SIZEOF_2DPOINT (4)
    clc
    adc #$03
    tax
    
dofastprojloop:
;;          Status = points3d[ii*SIZEOF_3DPOINT + 3]
        dey
;;  		PointZ = points3d[ii*SIZEOF_3DPOINT + 2];
        lda (ptrpt3),y
        sta _PointZ
        dey
;;  		PointY = points3d[ii*SIZEOF_3DPOINT + 1];
        lda (ptrpt3),y
        sta _PointY
        dey
;;  		PointX = points3d[ii*SIZEOF_3DPOINT + 0];
        lda (ptrpt3),y
        sta _PointX
        dey

;;  		project();
        jsr _project
        
        tya
        pha
        txa
        tay
;; #ifdef TEXTDEMO  
.IFDEF TEXTDEMO    
;;  		points2d[ii*SIZEOF_2DPOINT + 1] = ResY;
        
        lda _Norm+1
        sta (ptrpt2), y
        dey 

        lda _Norm
        sta (ptrpt2), y
        dey

        lda _ResY
        sta (ptrpt2), y
;;  		points2d[ii*SIZEOF_2DPOINT + 0] = ResX;
        dey
        lda _ResX
        sta (ptrpt2), y

;; #else
.ELSE
        lda _ResY+1
        sta (ptrpt2), y
        dey 

        lda _ResY
        sta (ptrpt2), y
        dey

        lda _ResX+1
        sta (ptrpt2), y
        dey

        lda _ResX
        sta (ptrpt2), y
.ENDIF

        tya
        tax
        pla
		tay
;;;;  	}
    dex
    txa
    cmp #$FF
    bne dofastprojloop 
dofastprojdone:
	
	
    rts
.endproc

.export _glProjectArrays

.proc _glProjectArrays

    ;; for (ii = 0; ii < glNbVertices; ii++){
	ldy		_glNbVertices
glProjectArrays_loop:
	dey
	bmi		glProjectArrays_done
		;;     x = glVerticesX[ii];
		lda 	_glVerticesX, y
		sta		_PointX
		;;     y = glVerticesY[ii];
		lda 	_glVerticesY, y
		sta		_PointY
		;;     z = glVerticesZ[ii];
		lda 	_glVerticesZ, y
		sta		_PointZ

    ;;     glProjectPoint(x, y, z, options, &ah, &av, &dist);
		jsr 	_project 

    ;;     points2aH[ii] = ah;
		lda 	_ResX
		sta		_points2aH, y
    ;;     points2aV[ii] = av;
		lda 	_ResY
		sta		_points2aV, y
    ;;     points2dH[ii] = (signed char)((dist & 0xFF00)>>8) && 0x00FF;
		lda		_Norm+1
		sta		_points2dH, y
    ;;     points2dL[ii] = (signed char) (dist & 0x00FF);
		lda		_Norm
		sta		_points2dL, y

    ;; }
	jmp glProjectArrays_loop
glProjectArrays_done:

	rts
.endproc




;---------------------------------------------------------------------------------
;Fast 3D projection routines by Jean-Baptiste PERIN
;---------------------------------------------------------------------------------
;---------------------------------------------------------------------------------
;_project
;---------------------------------------------------------------------------------
.export _project
.proc _project
	;; save context
    pha
	txa
	pha
	tya
	pha

    lda #0
    sta HAngleOverflow
    sta VAngleOverflow

	;; DeltaX = glCamPosX - PointX
	;; Divisor = DeltaX
	sec
	lda _PointX
	sbc _glCamPosX
	sta _DeltaX
	sta _tx
	;; FOR 16 bits Coords
	;; lda _PointX+1
	;; sbc _glCamPosX+1
	;; sta _DeltaX+1

	;; DeltaY = glCamPosY - PointY
	sec
	lda _PointY
	sbc _glCamPosY
	sta _DeltaY
	sta _ty
	;; FOR 16 bits Coords
	;; lda _PointY+1
	;; sbc _glCamPosY+1
	;; sta _DeltaY+1

    ;; AngleH = atan2 (DeltaY, DeltaX)
    ;;lda _DeltaY
    ;;sta _ty
    ;;lda _DeltaX
    ;;sta _tx
    jsr _atan2_8
    lda _res
    sta _AngleH

    ;; Norm = norm (DeltaX, DeltaY)
    jsr _norm_8

   	;; DeltaZ = glCamPosZ - PointZ
	sec
	lda _PointZ
	sbc _glCamPosZ
	sta _DeltaZ
	;; FOR 16 bits Coords
	;; lda _PointZ+1
	;; sbc _glCamPosZ+1
	;; sta _DeltaZ+1

    ;; AngleV = atan2 (DeltaZ, Norm)
    lda _DeltaZ
    sta _ty
    lda _Norm
    sta _tx
    jsr _atan2_8
    lda _res
    sta _AngleV

    ;; AnglePH = AngleH - glCamRotZ
    sec
    lda _AngleH
    sbc _glCamRotZ
    sta AnglePH
    bvc project_noHAngleOverflow
    lda #$80
    sta HAngleOverflow

project_noHAngleOverflow:
    ;; AnglePV = AngleV - glCamRotX
    sec
    lda _AngleV
    sbc _glCamRotX
    sta AnglePV
    bvc project_noVAngleOverflow
    lda #$80
    sta VAngleOverflow

project_noVAngleOverflow:   

	lda AnglePH
	sta _ResX
	lda AnglePV
	sta _ResY
	
	;; restore context
	pla
	tay
	pla
	tax
	pla
    rts
.endproc

;---------------------------------------------------------------------------------
;Fast Euclidian Norm calculation by Jean-Baptiste PERIN
;---------------------------------------------------------------------------------
;---------------------------------------------------------------------------------
;_norm
;---------------------------------------------------------------------------------
.segment    "DATA"

absX: .byt 0
absY: .byt 0
tmpufnX: .byt 0
tmpufnY: .byt 0

.segment    "CODE"

.proc _norm_8


;;  IF DX == 0 THEN
    lda _DeltaX
	bne dxNotNull
;;    IF DY > 0 THEN
		lda _DeltaY
		bmi dyNegativ_01
;;      RETURN DY
		sta _Norm
		jmp hfndone
dyNegativ_01:
;;    ELSE
;;      RETURN -DY
		eor #$FF
		sec
		adc #$00
		sta _Norm
		jmp hfndone
dxNotNull:
;;  ELSE IF DX > 0 THEN
	bmi dxNegativ_01
;;    AX = DX
		sta absX
		jmp computeAbsY
dxNegativ_01:
;;  ELSE (DX < 0)
;;    AX = -DX
		eor #$FF
		sec
		adc #$00
		sta absX
;;  ENDIF
computeAbsY:
;;  IF DY == 0 THEN
	lda _DeltaY
	bne dyNotNull
;;    RETURN AX
		lda absX
		sta _Norm
		jmp hfndone
dyNotNull:
;;  ELSE IF DY > 0 THEN
	bmi dyNegativ_02
;;    AY = DY
		sta absY
		jmp sortAbsVal
dyNegativ_02:
;;  ELSE (DY < 0)
		eor #$FF
		sec
		adc #$00
		sta absY
;;    AY = -DY
;;  ENDIF
sortAbsVal:
;;  IF AX > AY THEN
	cmp absX
	bcs ayOverOrEqualAx
;;    TY = AY
		tay
		sta tmpufnY
;;    TX = AX
		lda absX
		tax
		sta tmpufnX
		jmp approxim
ayOverOrEqualAx:
;;  ELSE
;;    TX = AY
		tax
		sta tmpufnX
;;    TY = AX
		lda absX
		tay
		sta tmpufnY
;;  END
approxim:
;;  IF TY > TX/2 THEN
	lda tmpufnX
	lsr 
	cmp tmpufnY
	bcc tyLowerOrEqualTxDiv2
	beq tyLowerOrEqualTxDiv2	
;;    RETURN TAB_A[TX] + TAB_B[TY]
		lda tabmult_A,X
		clc
		adc tabmult_B,Y
		sta _Norm
		lda #$00
		adc #$00 ; propagate carry
		sta _Norm+1
		jmp hfndone
tyLowerOrEqualTxDiv2:
;;  ELSE (TX/2 <= TY)
;;    RETURN TAB_C[TX] + TAB_D[TY]
		lda tabmult_C,X
		clc
		adc tabmult_D,Y
		sta _Norm
		lda #$00
		adc #$00 ; propagate carry
		sta _Norm+1
;;  END IF 	
	
hfndone:

    rts
.endproc

.segment    "DATA"

octant: .res 1
.segment    "CODE"
;---------------------------------------------------------------------------------
;_atan2 https://codebase64.org/doku.php?id=base:8bit_atan2_8-bit_angle
;---------------------------------------------------------------------------------

.proc _atan2_8
    lda _tx
    clc
    bpl Xpositiv
    eor #$ff
    sec
Xpositiv:
    tax
    rol octant

    lda _ty
    clc
    bpl Ypositiv
    eor #$ff
    sec
Ypositiv:
    tay
    rol octant

    sec
    lda _log2_tab,x
    sbc _log2_tab,y
    bcc *+4
    eor #$ff
    tax

    lda octant
    rol
    and #$07
    tay

    lda atan_tab, x
    eor octant_adjust,y
    sta _res

    rts
.endproc

; ;---------------------------------------------------------------------------------
; ;une fonction
; ;---------------------------------------------------------------------------------

; .export _une_fonction
 
; .proc _une_fonction
; 	lda #SCREEN_WIDTH
;     rts
; .endproc

.export		_fbuffer
.export		_zbuffer

.segment	"DATA"

_fbuffer:
	.res	SCREEN_WIDTH * SCREEN_WIDTH,$00
_zbuffer:
	.res	SCREEN_WIDTH * SCREEN_WIDTH,$00

octant_adjust:	.byt %00111111		;; x+,y+,|x|>|y|
		.byt %00000000		;; x+,y+,|x|<|y|
		.byt %11000000		;; x+,y-,|x|>|y|
		.byt %11111111		;; x+,y-,|x|<|y|
		.byt %01000000		;; x-,y+,|x|>|y|
		.byt %01111111		;; x-,y+,|x|<|y|
		.byt %10111111		;; x-,y-,|x|>|y|
		.byt %10000000		;; x-,y-,|x|<|y|


		;;;;;;;; atan(2^(x/32))*128/pi ;;;;;;;;

atan_tab:	.byt $00,$00,$00,$00,$00,$00,$00,$00
		.byt $00,$00,$00,$00,$00,$00,$00,$00
		.byt $00,$00,$00,$00,$00,$00,$00,$00
		.byt $00,$00,$00,$00,$00,$00,$00,$00
		.byt $00,$00,$00,$00,$00,$00,$00,$00
		.byt $00,$00,$00,$00,$00,$00,$00,$00
		.byt $00,$00,$00,$00,$00,$00,$00,$00
		.byt $00,$00,$00,$00,$00,$00,$00,$00
		.byt $00,$00,$00,$00,$00,$00,$00,$00
		.byt $00,$00,$00,$00,$00,$00,$00,$00
		.byt $00,$00,$00,$00,$00,$01,$01,$01
		.byt $01,$01,$01,$01,$01,$01,$01,$01
		.byt $01,$01,$01,$01,$01,$01,$01,$01
		.byt $01,$01,$01,$01,$01,$01,$01,$01
		.byt $01,$01,$01,$01,$01,$02,$02,$02
		.byt $02,$02,$02,$02,$02,$02,$02,$02
		.byt $02,$02,$02,$02,$02,$02,$02,$02
		.byt $03,$03,$03,$03,$03,$03,$03,$03
		.byt $03,$03,$03,$03,$03,$04,$04,$04
		.byt $04,$04,$04,$04,$04,$04,$04,$04
		.byt $05,$05,$05,$05,$05,$05,$05,$05
		.byt $06,$06,$06,$06,$06,$06,$06,$06
		.byt $07,$07,$07,$07,$07,$07,$08,$08
		.byt $08,$08,$08,$08,$09,$09,$09,$09
		.byt $09,$0a,$0a,$0a,$0a,$0b,$0b,$0b
		.byt $0b,$0c,$0c,$0c,$0c,$0d,$0d,$0d
		.byt $0d,$0e,$0e,$0e,$0e,$0f,$0f,$0f
		.byt $10,$10,$10,$11,$11,$11,$12,$12
		.byt $12,$13,$13,$13,$14,$14,$15,$15
		.byt $15,$16,$16,$17,$17,$17,$18,$18
		.byt $19,$19,$19,$1a,$1a,$1b,$1b,$1c
		.byt $1c,$1c,$1d,$1d,$1e,$1e,$1f,$1f


		;;;;;;;; log2(x)*32 ;;;;;;;;
.export _log2_tab
_log2_tab:	.byt $00,$00,$20,$32,$40,$4a,$52,$59
		.byt $60,$65,$6a,$6e,$72,$76,$79,$7d
		.byt $80,$82,$85,$87,$8a,$8c,$8e,$90
		.byt $92,$94,$96,$98,$99,$9b,$9d,$9e
		.byt $a0,$a1,$a2,$a4,$a5,$a6,$a7,$a9
		.byt $aa,$ab,$ac,$ad,$ae,$af,$b0,$b1
		.byt $b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9
		.byt $b9,$ba,$bb,$bc,$bd,$bd,$be,$bf
		.byt $c0,$c0,$c1,$c2,$c2,$c3,$c4,$c4
		.byt $c5,$c6,$c6,$c7,$c7,$c8,$c9,$c9
		.byt $ca,$ca,$cb,$cc,$cc,$cd,$cd,$ce
		.byt $ce,$cf,$cf,$d0,$d0,$d1,$d1,$d2
		.byt $d2,$d3,$d3,$d4,$d4,$d5,$d5,$d5
		.byt $d6,$d6,$d7,$d7,$d8,$d8,$d9,$d9
		.byt $d9,$da,$da,$db,$db,$db,$dc,$dc
		.byt $dd,$dd,$dd,$de,$de,$de,$df,$df
		.byt $df,$e0,$e0,$e1,$e1,$e1,$e2,$e2
		.byt $e2,$e3,$e3,$e3,$e4,$e4,$e4,$e5
		.byt $e5,$e5,$e6,$e6,$e6,$e7,$e7,$e7
		.byt $e7,$e8,$e8,$e8,$e9,$e9,$e9,$ea
		.byt $ea,$ea,$ea,$eb,$eb,$eb,$ec,$ec
		.byt $ec,$ec,$ed,$ed,$ed,$ed,$ee,$ee
		.byt $ee,$ee,$ef,$ef,$ef,$ef,$f0,$f0
		.byt $f0,$f1,$f1,$f1,$f1,$f1,$f2,$f2
		.byt $f2,$f2,$f3,$f3,$f3,$f3,$f4,$f4
		.byt $f4,$f4,$f5,$f5,$f5,$f5,$f5,$f6
		.byt $f6,$f6,$f6,$f7,$f7,$f7,$f7,$f7
		.byt $f8,$f8,$f8,$f8,$f9,$f9,$f9,$f9
		.byt $f9,$fa,$fa,$fa,$fa,$fa,$fb,$fb
		.byt $fb,$fb,$fb,$fc,$fc,$fc,$fc,$fc
		.byt $fd,$fd,$fd,$fd,$fd,$fd,$fe,$fe
		.byt $fe,$fe,$fe,$ff,$ff,$ff,$ff,$ff

		
		
tabmult_A:
	.byt 0, 1, 2, 3, 4, 5, 6, 7
	.byt 8, 9, 10, 11, 12, 13, 14, 15
	.byt 16, 17, 18, 19, 20, 21, 22, 23
	.byt 24, 25, 26, 27, 28, 29, 30, 31
	.byt 32, 33, 34, 35, 36, 37, 38, 39
	.byt 40, 41, 42, 43, 44, 45, 46, 47
	.byt 48, 49, 50, 51, 52, 53, 54, 55
	.byt 56, 57, 58, 59, 60, 61, 62, 63
	.byt 64, 65, 66, 67, 68, 69, 70, 71
	.byt 72, 73, 74, 75, 76, 77, 78, 79
	.byt 80, 81, 82, 83, 84, 85, 86, 87
	.byt 88, 89, 90, 90, 91, 92, 93, 94
	.byt 95, 96, 97, 98, 99, 100, 101, 102
	.byt 103, 104, 105, 106, 107, 108, 109, 110
	.byt 111, 112, 113, 114, 115, 116, 117, 118
	.byt 119, 119, 120, 121, 122, 123, 124, 125
tabmult_B:
	.byt 0, 0, 0, 0, 0, 1, 1, 1
	.byt 1, 1, 1, 1, 2, 2, 2, 2
	.byt 2, 3, 3, 3, 3, 3, 4, 4
	.byt 4, 4, 4, 5, 5, 5, 6, 6
	.byt 6, 6, 7, 7, 7, 7, 8, 8
	.byt 8, 9, 9, 9, 10, 10, 10, 11
	.byt 11, 11, 12, 12, 13, 13, 13, 14
	.byt 14, 15, 15, 15, 16, 16, 17, 17
	.byt 18, 18, 18, 19, 19, 20, 20, 21
	.byt 21, 22, 22, 23, 23, 24, 24, 25
	.byt 25, 26, 26, 27, 27, 28, 29, 29
	.byt 30, 30, 31, 31, 32, 33, 33, 34
	.byt 34, 35, 36, 36, 37, 38, 38, 39
	.byt 39, 40, 41, 41, 42, 43, 44, 44
	.byt 45, 46, 46, 47, 48, 48, 49, 50
	.byt 51, 51, 52, 53, 54, 54, 55, 56
tabmult_C:
	.byt 0, 0, 2, 3, 4, 5, 5, 6
	.byt 7, 8, 8, 9, 10, 11, 12, 13
	.byt 14, 14, 15, 16, 17, 18, 19, 19
	.byt 20, 21, 22, 23, 24, 24, 25, 26
	.byt 27, 28, 29, 30, 30, 31, 32, 33
	.byt 34, 35, 35, 36, 37, 38, 39, 40
	.byt 40, 41, 42, 43, 44, 44, 45, 46
	.byt 47, 48, 49, 49, 50, 51, 52, 53
	.byt 54, 54, 55, 56, 57, 58, 59, 59
	.byt 60, 61, 62, 63, 63, 64, 65, 66
	.byt 67, 68, 68, 69, 70, 71, 72, 72
	.byt 73, 74, 75, 76, 76, 77, 78, 79
	.byt 80, 80, 81, 82, 83, 84, 85, 85
	.byt 86, 87, 88, 89, 89, 90, 91, 92
	.byt 93, 93, 94, 95, 96, 97, 97, 98
	.byt 99, 100, 101, 101, 102, 103, 104, 105
tabmult_D:
	.byt 0, 1, 1, 1, 2, 2, 3, 4
	.byt 4, 5, 5, 6, 7, 7, 8, 8
	.byt 9, 9, 10, 10, 11, 11, 12, 13
	.byt 13, 14, 14, 15, 15, 16, 17, 17
	.byt 18, 18, 19, 19, 20, 20, 21, 22
	.byt 22, 23, 23, 24, 24, 25, 26, 26
	.byt 27, 27, 28, 28, 29, 30, 30, 31
	.byt 31, 32, 33, 33, 34, 34, 35, 35
	.byt 36, 37, 37, 38, 38, 39, 40, 40
	.byt 41, 41, 42, 43, 43, 44, 44, 45
	.byt 46, 46, 47, 47, 48, 49, 49, 50
	.byt 50, 51, 52, 52, 53, 53, 54, 55
	.byt 55, 56, 56, 57, 58, 58, 59, 59
	.byt 60, 61, 61, 62, 63, 63, 64, 64
	.byt 65, 66, 66, 67, 68, 68, 69, 69
	.byt 70, 71, 71, 72, 73, 73, 74, 74
	




;;      _                    _             
;;   __| |_ __ __ ___      _(_)_ __   __ _ 
;;  / _` | '__/ _` \ \ /\ / / | '_ \ / _` |
;; | (_| | | | (_| |\ V  V /| | | | | (_| |
;;  \__,_|_|  \__,_| \_/\_/ |_|_| |_|\__, |
;;                                   |___/ 


USE_ZBUFFER = 1
SAFE_CONTEXT = 1

.segment	"DATA"
_plotX:		.res 1
_plotY:		.res 1

.export _glDrawParticules
 
.segment    "CODE"



.proc _fastzplot

.IFDEF SAFE_CONTEXT
	;; save context
    pha
	txa
	pha
	tya
	pha
	lda tmp1
	pha
	lda tmp1+1
	pha ;; ptrFbuf
	lda tmp2
	pha
	lda tmp2+1
	pha ;; ptrZbuf
.ENDIF

;; #ifdef USE_COLOR
;;    if ((Y <= 0) || (Y >= SCREEN_HEIGHT-NB_LESS_LINES_4_COLOR) || (X <= 2) || (X >= SCREEN_WIDTH))
;;        return;
;; #else
;;    if ((Y <= 0) || (Y >= SCREEN_HEIGHT) || (X <= 0) || (X >= SCREEN_WIDTH))
;;        return;
;; #endif

	lda		_plotY
    beq		fastzplot_done
    bmi		fastzplot_done
.IFDEF USE_COLOR
    cmp		#SCREEN_HEIGHT-NB_LESS_LINES_4_COLOR
.ELSE
	cmp		#SCREEN_HEIGHT
.ENDIF
    bcs		fastzplot_done
    tax

	lda		_plotX
.IFDEF USE_COLOR
	sec
	sbc		#COLUMN_OF_COLOR_ATTRIBUTE
	bvc		*+4
	eor		#$80
	bmi		fastzplot_done

	lda		_plotX				; Reload X coordinate
    cmp		#SCREEN_WIDTH
    bcs		fastzplot_done

.ELSE
    beq		fastzplot_done
    bmi		fastzplot_done
    cmp		#SCREEN_WIDTH
    bcs		fastzplot_done
.ENDIF

    ;; ptrZbuf = zbuffer + Y*SCREEN_WIDTH+X;;
	lda		ZBufferAdressLow,x	; Get the LOW part of the zbuffer adress
	clc						; Clear the carry (because we will do an addition after)
	adc		_plotX				; Add X coordinate
	sta		tmp2 ; ptrZbuf
	lda		ZBufferAdressHigh,x	; Get the HIGH part of the zbuffer adress
	adc		#0					; Eventually add the carry to complete the 16 bits addition
	sta		tmp2+1	 ; ptrZbuf+ 1			

    ;; if (dist < *ptrZbuf) {
    lda 	_distpoint		; Access dist
    ldx		#0
    cmp		(tmp2,x)
    bcs		fastzplot_done

    ;;    *ptrZbuf = dist;
        ldx		#0
        sta		(tmp2, x)
    ;;    *ptrFbuf = char2disp;
        ldx		_plotY    ; reload Y coordinate
    	lda		FBufferAdressLow,x	; Get the LOW part of the fbuffer adress
        clc						; Clear the carry (because we will do an addition after)
        ;;ldy #0
        adc		_plotX				; Add X coordinate
        sta		tmp1 ; ptrFbuf
        lda		FBufferAdressHigh,x	; Get the HIGH part of the fbuffer adress
        adc		#0					; Eventually add the carry to complete the 16 bits addition
        sta		tmp1+1	 ; ptrFbuf+ 1			

        lda		_ch2disp		; Access char2disp
        ldx		#0
        sta		(tmp1,x)

    ;;}


fastzplot_done:
.IFDEF SAFE_CONTEXT
	;; restore context
	pla
	sta tmp2+1
	pla
	sta tmp2
	pla
	sta tmp1+1
	pla
	sta tmp1
	pla
	tay
	pla
	tax
	pla
.ENDIF

	rts
.endproc


.segment "CODE"
;; void glDrawParticules(){
.proc _glDrawParticules

;;     unsigned char ii = 0;
.IF .DEFINED(SAFE_CONTEXT)
    lda tmp1
	pha 
.ENDIF ;; SAFE_CONTEXT

    ldy _glNbParticles
    jmp glDrawParticules_nextParticule
;;     for (ii = 0; ii < glNbParticles; ii++) {

glDrawParticules_loop:

;;         idxPt1    = glParticlesPt[ii];  ;; ii*SIZEOF_SEGMENT +0
        lda _glParticlesPt,y
		sta _idxPt1
;;         ch2disp = glParticlesChar[ii];    ;; ii*SIZEOF_SEGMENT +2
        lda _glParticlesChar,y
		sta _ch2disp

        sty tmp1
		ldy _idxPt1
;;         dchar = points2dL[idxPt]-2 ; ;;FIXME : -2 to helps particule to be displayed
        lda _points2dL,y
		sta _distpoint

;;         P1X = (SCREEN_WIDTH -points2aH[idxPt]) >> 1;
        sec
		lda #SCREEN_WIDTH
		sbc _points2aH,y
		cmp #$80
		ror
        sta _plotX
        
;;         P1Y = (SCREEN_HEIGHT - points2aV[idxPt]) >> 1;
        sec
		lda #SCREEN_HEIGHT
		sbc _points2aV,y
		cmp #$80
		ror
        sta _plotY

.IF .DEFINED(USE_ZBUFFER)
;;         glZPlot(P1X, P1Y, dchar, ch2disp);
        jsr _fastzplot
.ELSE
;;         ;; TODO : plot a point with no z-buffer
;;         plot(A1X, A1Y, ch2disp);
.ENDIF
        ldy tmp1
glDrawParticules_nextParticule:
	dey 
    bmi glDrawParticules_done
	jmp glDrawParticules_loop
;;     }

glDrawParticules_done:

.IF .DEFINED(SAFE_CONTEXT)
	;; Restore context
	pla
	sta tmp1
.ENDIF ;; SAFE_CONTEXT
;; }

    rts
.endproc



.segment	"DATA"

; This table contains lower 8 bits of the adress
ZBufferAdressLow:
	.byt <(_zbuffer+40*0)
	.byt <(_zbuffer+40*1)
	.byt <(_zbuffer+40*2)
	.byt <(_zbuffer+40*3)
	.byt <(_zbuffer+40*4)
	.byt <(_zbuffer+40*5)
	.byt <(_zbuffer+40*6)
	.byt <(_zbuffer+40*7)
	.byt <(_zbuffer+40*8)
	.byt <(_zbuffer+40*9)
	.byt <(_zbuffer+40*10)
	.byt <(_zbuffer+40*11)
	.byt <(_zbuffer+40*12)
	.byt <(_zbuffer+40*13)
	.byt <(_zbuffer+40*14)
	.byt <(_zbuffer+40*15)
	.byt <(_zbuffer+40*16)
	.byt <(_zbuffer+40*17)
	.byt <(_zbuffer+40*18)
	.byt <(_zbuffer+40*19)
	.byt <(_zbuffer+40*20)
	.byt <(_zbuffer+40*21)
	.byt <(_zbuffer+40*22)
	.byt <(_zbuffer+40*23)
	.byt <(_zbuffer+40*24)
	.byt <(_zbuffer+40*25)
	.byt <(_zbuffer+40*26)
	.byt <(_zbuffer+40*27)

; This table contains hight 8 bits of the adress
ZBufferAdressHigh:
	.byt >(_zbuffer+40*0)
	.byt >(_zbuffer+40*1)
	.byt >(_zbuffer+40*2)
	.byt >(_zbuffer+40*3)
	.byt >(_zbuffer+40*4)
	.byt >(_zbuffer+40*5)
	.byt >(_zbuffer+40*6)
	.byt >(_zbuffer+40*7)
	.byt >(_zbuffer+40*8)
	.byt >(_zbuffer+40*9)
	.byt >(_zbuffer+40*10)
	.byt >(_zbuffer+40*11)
	.byt >(_zbuffer+40*12)
	.byt >(_zbuffer+40*13)
	.byt >(_zbuffer+40*14)
	.byt >(_zbuffer+40*15)
	.byt >(_zbuffer+40*16)
	.byt >(_zbuffer+40*17)
	.byt >(_zbuffer+40*18)
	.byt >(_zbuffer+40*19)
	.byt >(_zbuffer+40*20)
	.byt >(_zbuffer+40*21)
	.byt >(_zbuffer+40*22)
	.byt >(_zbuffer+40*23)
	.byt >(_zbuffer+40*24)
	.byt >(_zbuffer+40*25)
	.byt >(_zbuffer+40*26)
	.byt >(_zbuffer+40*27)


; This table contains lower 8 bits of the adress
FBufferAdressLow:
	.byt <(_fbuffer+40*0)
	.byt <(_fbuffer+40*1)
	.byt <(_fbuffer+40*2)
	.byt <(_fbuffer+40*3)
	.byt <(_fbuffer+40*4)
	.byt <(_fbuffer+40*5)
	.byt <(_fbuffer+40*6)
	.byt <(_fbuffer+40*7)
	.byt <(_fbuffer+40*8)
	.byt <(_fbuffer+40*9)
	.byt <(_fbuffer+40*10)
	.byt <(_fbuffer+40*11)
	.byt <(_fbuffer+40*12)
	.byt <(_fbuffer+40*13)
	.byt <(_fbuffer+40*14)
	.byt <(_fbuffer+40*15)
	.byt <(_fbuffer+40*16)
	.byt <(_fbuffer+40*17)
	.byt <(_fbuffer+40*18)
	.byt <(_fbuffer+40*19)
	.byt <(_fbuffer+40*20)
	.byt <(_fbuffer+40*21)
	.byt <(_fbuffer+40*22)
	.byt <(_fbuffer+40*23)
	.byt <(_fbuffer+40*24)
	.byt <(_fbuffer+40*25)
	.byt <(_fbuffer+40*26)
	.byt <(_fbuffer+40*27)

; This table contains hight 8 bits of the adress
FBufferAdressHigh:
	.byt >(_fbuffer+40*0)
	.byt >(_fbuffer+40*1)
	.byt >(_fbuffer+40*2)
	.byt >(_fbuffer+40*3)
	.byt >(_fbuffer+40*4)
	.byt >(_fbuffer+40*5)
	.byt >(_fbuffer+40*6)
	.byt >(_fbuffer+40*7)
	.byt >(_fbuffer+40*8)
	.byt >(_fbuffer+40*9)
	.byt >(_fbuffer+40*10)
	.byt >(_fbuffer+40*11)
	.byt >(_fbuffer+40*12)
	.byt >(_fbuffer+40*13)
	.byt >(_fbuffer+40*14)
	.byt >(_fbuffer+40*15)
	.byt >(_fbuffer+40*16)
	.byt >(_fbuffer+40*17)
	.byt >(_fbuffer+40*18)
	.byt >(_fbuffer+40*19)
	.byt >(_fbuffer+40*20)
	.byt >(_fbuffer+40*21)
	.byt >(_fbuffer+40*22)
	.byt >(_fbuffer+40*23)
	.byt >(_fbuffer+40*24)
	.byt >(_fbuffer+40*25)
	.byt >(_fbuffer+40*26)
	.byt >(_fbuffer+40*27)

.segment "CODE"

.export _glInitScreenBuffers

;; void glInitScreenBuffers()
.proc _glInitScreenBuffers

  
    lda #$FF
    ldx #SCREEN_WIDTH-1

glInitScreenBuffersLoop_01:
    sta _zbuffer+SCREEN_WIDTH*0 , x
    sta _zbuffer+SCREEN_WIDTH*1 , x
    sta _zbuffer+SCREEN_WIDTH*2 , x
    sta _zbuffer+SCREEN_WIDTH*3 , x
    sta _zbuffer+SCREEN_WIDTH*4 , x
    sta _zbuffer+SCREEN_WIDTH*5 , x
    sta _zbuffer+SCREEN_WIDTH*6 , x
    sta _zbuffer+SCREEN_WIDTH*7 , x
    sta _zbuffer+SCREEN_WIDTH*8 , x
    sta _zbuffer+SCREEN_WIDTH*9 , x
    sta _zbuffer+SCREEN_WIDTH*10 , x
    sta _zbuffer+SCREEN_WIDTH*11 , x
    sta _zbuffer+SCREEN_WIDTH*12 , x
    sta _zbuffer+SCREEN_WIDTH*13 , x
    sta _zbuffer+SCREEN_WIDTH*14 , x
    sta _zbuffer+SCREEN_WIDTH*15 , x
    sta _zbuffer+SCREEN_WIDTH*16 , x
    sta _zbuffer+SCREEN_WIDTH*17 , x
    sta _zbuffer+SCREEN_WIDTH*18 , x
    sta _zbuffer+SCREEN_WIDTH*19 , x
    sta _zbuffer+SCREEN_WIDTH*20 , x
    sta _zbuffer+SCREEN_WIDTH*21 , x
    sta _zbuffer+SCREEN_WIDTH*22 , x
    sta _zbuffer+SCREEN_WIDTH*23 , x
    sta _zbuffer+SCREEN_WIDTH*24 , x
    sta _zbuffer+SCREEN_WIDTH*25 , x 
    sta _zbuffer+SCREEN_WIDTH*26 , x
    dex
    bne glInitScreenBuffersLoop_01

.IFNDEF USE_HORIZON
    lda #$20
.ENDIF ;; USE_HORIZON

    ldx #SCREEN_WIDTH-1

glInitScreenBuffersLoop_02:
.IFDEF USE_HORIZON
    lda #$20
.ENDIF ;; USE_HORIZON
    sta _fbuffer+SCREEN_WIDTH*0 , x
    sta _fbuffer+SCREEN_WIDTH*1 , x
    sta _fbuffer+SCREEN_WIDTH*2 , x
    sta _fbuffer+SCREEN_WIDTH*3 , x
    sta _fbuffer+SCREEN_WIDTH*4 , x
    sta _fbuffer+SCREEN_WIDTH*5 , x
    sta _fbuffer+SCREEN_WIDTH*6 , x
    sta _fbuffer+SCREEN_WIDTH*7 , x
    sta _fbuffer+SCREEN_WIDTH*8 , x
    sta _fbuffer+SCREEN_WIDTH*9 , x
    sta _fbuffer+SCREEN_WIDTH*10 , x
    sta _fbuffer+SCREEN_WIDTH*11 , x
    sta _fbuffer+SCREEN_WIDTH*12 , x
    sta _fbuffer+SCREEN_WIDTH*13 , x
.IFDEF USE_HORIZON
    lda #102 ;; light green
.ENDIF ;; USE_HORIZON
    sta _fbuffer+SCREEN_WIDTH*14 , x
    sta _fbuffer+SCREEN_WIDTH*15 , x
    sta _fbuffer+SCREEN_WIDTH*16 , x
    sta _fbuffer+SCREEN_WIDTH*17 , x
    sta _fbuffer+SCREEN_WIDTH*18 , x
    sta _fbuffer+SCREEN_WIDTH*19 , x
    sta _fbuffer+SCREEN_WIDTH*20 , x
    sta _fbuffer+SCREEN_WIDTH*21 , x
.IFNDEF USE_COLOR
    sta _fbuffer+SCREEN_WIDTH*22 , x
    sta _fbuffer+SCREEN_WIDTH*23 , x
    sta _fbuffer+SCREEN_WIDTH*24 , x
    sta _fbuffer+SCREEN_WIDTH*25 , x
    sta _fbuffer+SCREEN_WIDTH*26 , x
.ENDIF
    dex
.IFDEF USE_COLOR
 	cpx #2
 	beq glInitScreenBuffersDone
.ENDIF ;; USE_COLOR
    bpl glInitScreenBuffersLoop_02
glInitScreenBuffersDone:

    rts
.endproc




;;            _       _   
;;  _____ __ | | ___ | |_ 
;; |_  / '_ \| |/ _ \| __|
;;  / /| |_) | | (_) | |_ 
;; /___| .__/|_|\___/ \__|
;;     |_|                

.segment "CODE"
.export _glZPlot

;; void glZPlot(signed char X,
;;           signed char Y,
;;           unsigned char dist,
;;           char          char2disp) {

.proc _glZPlot

	sta _ch2disp		; Access char2disp
	jsr popa
	sta _distpoint		; Access dist
	jsr popa
	sta _plotY			; Access Y coordinate
	jsr popa
	sta _plotX			; Access X coordinate

	jsr 	_fastzplot

zplot_done:
    rts
.endproc


; USE_ASM_ANGLE2SCREEN = 1

.IFDEF USE_ASM_ANGLE2SCREEN
.segment "CODE"
.export _angle2screen
;; void angle2screen() {
.proc _angle2screen


.IFDEF SAFE_CONTEXT
    ;; save context
    pha
.ENDIF ;; SAFE_CONTEXT

    ;; FIXME : deal with case of overflow
    ;;     P1X = (SCREEN_WIDTH - P1AH) >> 1;
    sec
	lda #SCREEN_WIDTH
	sbc _P1AH
	cmp #$80
	ror
	sta _P1X
    ;;     P1Y = (SCREEN_HEIGHT - P1AV) >> 1;
    sec
	lda #SCREEN_HEIGHT
	sbc _P1AV
	cmp #$80
	ror
	sta _P1Y
    ;;     P2X = (SCREEN_WIDTH - P2AH) >> 1;
    sec
	lda #SCREEN_WIDTH
	sbc _P2AH
	cmp #$80
	ror
	sta _P2X
    ;;     P2Y = (SCREEN_HEIGHT - P2AV) >> 1;
    sec
	lda #SCREEN_HEIGHT
	sbc _P2AV
	cmp #$80
	ror
	sta _P2Y
    ;;     P3X = (SCREEN_WIDTH - P3AH) >> 1;
    sec
	lda #SCREEN_WIDTH
	sbc _P3AH
	cmp #$80
	ror
	sta _P3X
    ;;     P3Y = (SCREEN_HEIGHT - P3AV) >> 1;
    sec
	lda #SCREEN_HEIGHT
	sbc _P3AV
	cmp #$80
	ror
	sta _P3Y


.IFDEF SAFE_CONTEXT
    ;; restore context
    pla
.ENDIF ;; SAFE_CONTEXT
    ;; }

	rts
 .endproc

.ENDIF ;; USE_ASM_ANGLE2SCREEN





USE_ASM_RETRIEVEFACEDATA = 1
.IFDEF USE_ASM_RETRIEVEFACEDATA
.export _retrieveFaceData

;; void retrieveFaceData()
.proc _retrieveFaceData

	ldy _idxPt1
        ;; P1AH = points2aH[idxPt1];
	lda _points2aH,y
	sta _P1AH 
        ;; P1AV = points2aV[idxPt1];
	lda _points2aV,y
	sta _P1AV 
        ;; dmoy = points2dL[idxPt1]; ;;*((int*)(points2d + offPt1 + 2));
	lda _points2dL,y
	sta _dmoy
	lda _points2dH,y
	sta _dmoy+1

	ldy _idxPt2
        ;; P2AH = points2aH[idxPt2];
	lda _points2aH,y
	sta _P2AH 		
        ;; P2AV = points2aV[idxPt2];
	lda _points2aV,y
	sta _P2AV 		
        ;; dmoy += points2dL[idxPt2]; ;;*((int*)(points2d + offPt2 + 2));
	clc
	lda _points2dL,y
	adc _dmoy
	sta _dmoy
	lda _points2dH,y
	adc _dmoy+1
	sta _dmoy+1


    ldy _idxPt3
	    ;; P3AH = points2aH[idxPt3];
	lda _points2aH,y
	sta _P3AH	
        ;; P3AV = points2aV[idxPt3];
	lda _points2aV,y
	sta _P3AV 		
        ;; dmoy +=  points2dL[idxPt3]; ;;*((int*)(points2d + offPt3 + 2));
	clc
	lda _points2dL,y
	adc _dmoy
	sta _dmoy
	lda _points2dH,y
	adc _dmoy+1
	sta _dmoy+1

	lda _dmoy+1
	
	beq moynottoobig		;; FIXME :: it should be possible to deal with case *(dmoy+1) = 1
	lda #$FF
	sta _distface
	jmp retreiveFaceData_done

moynottoobig:
        ;; dmoy = dmoy / 3;
	lda _dmoy

	;Divide by 3 found on http://forums.nesdev.com/viewtopic.php?f=2&t=11336
	;18 bytes, 30 cycles
	sta  tmp1
	lsr
	adc  #21
	lsr
	adc  tmp1
	ror
	lsr
	adc  tmp1
	ror
	lsr
	adc  tmp1
	ror
	lsr

        ;; if (dmoy >= 256) {
        ;;     dmoy = 256;
        ;; }
        ;; distface = (unsigned char)(dmoy & 0x00FF);
	sta _distface


retreiveFaceData_done:	
	;; restore context
	; pla: sta tmp1
	; pla: sta tmp0
	; pla: sta reg0
	;pla

	; jmp leave :

	rts

.endproc
.ENDIF ;; USE_ASM_RETRIEVEFACEDATA




USE_ASM_SORTPOINTS=1
.IFDEF USE_ASM_SORTPOINTS
.export _sortPoints

;; void sortPoints()
.proc _sortPoints



.IFDEF SAFE_CONTEXT
	;; save context
    pha
	lda tmp1
	pha
	lda ptr1
	pha ; tmpH
	lda ptr1+1
	pha ; tmpV
.ENDIF ;; SAFE_CONTEXT

    ;; if (abs(P2AH) < abs(P1AH)) {

	lda _P1AH
	bpl sortPoints_01_positiv_02
	eor #$FF
	clc
	adc #1
sortPoints_01_positiv_02:
	sta tmp1

	lda _P2AH
	bpl sortPoints_01_positiv_01
	eor #$FF
	clc
	adc #1
sortPoints_01_positiv_01:

	cmp tmp1
	bcs sortPoints_step01

    ;;     tmpH = P1AH;
    ;;     tmpV = P1AV;
    ;;     P1AH = P2AH;
    ;;     P1AV = P2AV;
    ;;     P2AH = tmpH;
    ;;     P2AV = tmpV;
	lda _P1AH
	sta ptr1
	lda _P1AV
	sta ptr1+1
	lda _P2AH
	sta _P1AH
	lda _P2AV
	sta _P1AV
	lda ptr1
	sta _P2AH
	lda ptr1+1
	sta _P2AV


    ;; }
sortPoints_step01:	
    ;; if (abs(P3AH) < abs(P1AH)) {

	lda _P1AH
	bpl sortPoints_02_positiv_02
	eor #$FF
	clc
	adc #1
sortPoints_02_positiv_02:
	sta tmp1

	lda _P3AH
	bpl sortPoints_02_positiv_01
	eor #$FF
	clc
	adc #1
sortPoints_02_positiv_01:

	cmp tmp1
	bcs sortPoints_step02

    ;;     tmpH = P1AH;
    ;;     tmpV = P1AV;
    ;;     P1AH = P3AH;
    ;;     P1AV = P3AV;
    ;;     P3AH = tmpH;
    ;;     P3AV = tmpV;
	lda _P1AH
	sta ptr1
	lda _P1AV
	sta ptr1+1
	lda _P3AH
	sta _P1AH
	lda _P3AV
	sta _P1AV
	lda ptr1
	sta _P3AH
	lda ptr1+1
	sta _P3AV
    ;; }
sortPoints_step02:	
    ;; if (abs(P3AH) < abs(P2AH)) {

	lda _P2AH
	bpl sortPoints_03_positiv_02
	eor #$FF
	clc
	adc #1
sortPoints_03_positiv_02:
	sta tmp1

	lda _P3AH
	bpl sortPoints_03_positiv_01
	eor #$FF
	clc
	adc #1
sortPoints_03_positiv_01:

	cmp tmp1
	bcs sortPoints_done

    ;;     tmpH = P2AH;
    ;;     tmpV = P2AV;
    ;;     P2AH = P3AH;
    ;;     P2AV = P3AV;
    ;;     P3AH = tmpH;
    ;;     P3AV = tmpV;
	lda _P2AH
	sta ptr1
	lda _P2AV
	sta ptr1+1
	lda _P3AH
	sta _P2AH
	lda _P3AV
	sta _P2AV
	lda ptr1
	sta _P3AH
	lda ptr1+1
	sta _P3AV

    ;; }

sortPoints_done:	
.IFDEF SAFE_CONTEXT

	;; restore context
	pla
	sta ptr1+1
	pla
	sta ptr1
	pla
	sta tmp1
	pla

.ENDIF ;; SAFE_CONTEXT

	rts

.endproc
.ENDIF ;; USE_ASM_SORTPOINTS



USE_ASM_PREPAREBRESRUN = 1
.IFDEF USE_ASM_PREPAREBRESRUN
.export _prepare_bresrun

;; void prepare_bresrun()
.proc _prepare_bresrun

	lda _P2Y
	sec
	sbc _P1Y
	bvc prepare_bresrun_skip_01
	eor #$80
prepare_bresrun_skip_01:

	bpl prepare_bresrun_skip_01b
	jmp prepare_bresrun_Lbresfill129
prepare_bresrun_skip_01b:
	;; lda _P1Y : sta tmp0 :
	;; lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	;; lda _P2Y : sta tmp1 :
	;; lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	;; lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp prepare_bresrun_Lbresfill129 :skip : .) : : :
    ;     if (P2Y <= P3Y) {
		lda _P3Y
		sec
		sbc _P2Y
		bvc prepare_bresrun_skip_02
		eor #$80
prepare_bresrun_skip_02:
	bpl prepare_bresrun_skip_03
	jmp prepare_bresrun_Lbresfill131
prepare_bresrun_skip_03:
	;; lda _P2Y : sta tmp0 :
	;; lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	;; lda _P3Y : sta tmp1 :
	;; lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	;; lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp prepare_bresrun_Lbresfill131 :skip : .) : : :
	lda _P3X
	sta _pDepX    ;         pDepX  = P3X;   
	lda _P3Y
	sta _pDepY    ;         pDepY  = P3Y;
	lda _P2X 
	sta _pArr1X   ;         pArr1X = P2X;
	lda _P2Y 
	sta _pArr1Y   ;         pArr1Y = P2Y;
	lda _P1X 
	sta _pArr2X   ;         pArr2X = P1X;
	lda _P1Y 
	sta _pArr2Y   ;         pArr2Y = P1Y;
	jmp prepare_bresrun_Lbresfill130
    ;     } else {
prepare_bresrun_Lbresfill131:
	lda _P2X
	sta _pDepX    ;         pDepX = P2X;
	lda _P2Y
	sta _pDepY    ;         pDepY = P2Y;
    ;         if (P1Y <= P3Y) {
		lda _P3Y
		sec
		sbc _P1Y
		bvc prepare_bresrun_skip_04
		eor #$80
prepare_bresrun_skip_04:
	bpl prepare_bresrun_skip_05
	jmp prepare_bresrun_Lbresfill133
prepare_bresrun_skip_05:
	;; lda _P1Y : sta tmp0 :
	;; lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	;; lda _P3Y : sta tmp1 :
	;; lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	;; lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp prepare_bresrun_Lbresfill133 :skip : .) : : :
	lda _P3X
	sta _pArr1X  ;             pArr1X = P3X;
	lda _P3Y
	sta _pArr1Y  ;             pArr1Y = P3Y;
	lda _P1X
	sta _pArr2X  ;             pArr2X = P1X;
	lda _P1Y
	sta _pArr2Y  ;             pArr2Y = P1Y;
	jmp prepare_bresrun_Lbresfill130 
    ;         } else {
prepare_bresrun_Lbresfill133:
	lda _P1X
	sta _pArr1X  ;             pArr1X = P1X;
	lda _P1Y
	sta _pArr1Y  ;             pArr1Y = P1Y;
	lda _P3X
	sta _pArr2X  ;             pArr2X = P3X;
	lda _P3Y
	sta _pArr2Y  ;             pArr2Y = P3Y;
	jmp prepare_bresrun_Lbresfill130
    ;         }
    ;     }
    ; } else {
prepare_bresrun_Lbresfill129:
    ;     if (P1Y <= P3Y) {
		lda _P3Y
		sec
		sbc _P1Y
		bvc prepare_bresrun_skip_06
		eor #$80
prepare_bresrun_skip_06:
	bpl prepare_bresrun_skip_07
	jmp prepare_bresrun_Lbresfill135
prepare_bresrun_skip_07:
	;; lda _P1Y : sta tmp0 :
	;; lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	;; lda _P3Y : sta tmp1 :
	;; lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	;; lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp prepare_bresrun_Lbresfill135 :skip : .) : : :
	lda _P3X
	sta _pDepX   ;         pDepX  = P3X;
	lda _P3Y
	sta _pDepY   ;         pDepY  = P3Y;
	lda _P1X
	sta _pArr1X  ;         pArr1X = P1X;
	lda _P1Y
	sta _pArr1Y  ;         pArr1Y = P1Y;
	lda _P2X
	sta _pArr2X  ;         pArr2X = P2X;
	lda _P2Y
	sta _pArr2Y  ;         pArr2Y = P2Y;
	jmp prepare_bresrun_Lbresfill136
    ;     } else {
prepare_bresrun_Lbresfill135:
	lda _P1X
	sta _pDepX  ;         pDepX = P1X;
	lda _P1Y
	sta _pDepY  ;         pDepY = P1Y;
    ;         if (P2Y <= P3Y) {
		lda _P3Y
		sec
		sbc _P2Y
		bvc prepare_bresrun_skip_08
		eor #$80
prepare_bresrun_skip_08:
	bpl prepare_bresrun_skip_09
	jmp prepare_bresrun_Lbresfill137
prepare_bresrun_skip_09:
	;; lda _P2Y : sta tmp0 :
	;; lda #0 : ldx tmp0 : stx tmp0 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp0+1 :
	;; lda _P3Y : sta tmp1 :
	;; lda #0 : ldx tmp1 : stx tmp1 : .( : bpl skip : lda #$FF :skip : .)  : sta tmp1+1 :
	;; lda tmp1 : cmp tmp0 : lda tmp1+1 : sbc tmp0+1 : .( : bvc *+4 : eor #$80 : bpl skip : jmp prepare_bresrun_Lbresfill137 :skip : .) : : :
	lda _P3X
	sta _pArr1X   ;             pArr1X = P3X;
	lda _P3Y
	sta _pArr1Y   ;             pArr1Y = P3Y;
	lda _P2X
	sta _pArr2X   ;             pArr2X = P2X;
	lda _P2Y
	sta _pArr2Y   ;             pArr2Y = P2Y;
	jmp prepare_bresrun_Lbresfill138
    ;         } else {
prepare_bresrun_Lbresfill137:
	lda _P2X
	sta _pArr1X   ;             pArr1X = P2X;
	lda _P2Y
	sta _pArr1Y   ;             pArr1Y = P2Y;
	lda _P3X
	sta _pArr2X   ;             pArr2X = P3X;
	lda _P3Y
	sta _pArr2Y   ;             pArr2Y = P3Y;
prepare_bresrun_Lbresfill138:
    ;         }
prepare_bresrun_Lbresfill136:
    ;     }
prepare_bresrun_Lbresfill130:
    ; }

	rts 

.endproc
.ENDIF ;; USE_ASM_PREPAREBRESRUN


USE_ASM_ISA1RIGHT1 = 1
.IFDEF USE_ASM_ISA1RIGHT1
.export _isA1Right1
;; void isA1Right1()
.proc _isA1Right1

.IFDEF SAFE_CONTEXT
	;; save context
    pha
	txa
	pha
	tya
	pha
	lda ptr2
	pha
	lda ptr2+1
	pha
	lda ptr1
	pha
	lda ptr1+1
	pha
.ENDIF ;; SAFE_CONTEXT
    ;; if ((mDeltaX1 & 0x80) == 0){
	lda #$00
	sta _A1Right
	lda _mDeltaX1
	bmi isA1Right1_mDeltaX1_negativ
        
    ;; 	  if ((mDeltaX2 & 0x80) == 0){
		lda _mDeltaX2
		bmi isA1Right1_mDeltaX2_negativ_01
    ;;         ;; printf ("%d*%d  %d*%d ", mDeltaY1, mDeltaX2, mDeltaY2,mDeltaX1);get ();
    ;;         A1Right = (log2_tab[mDeltaX2] + log2_tab[mDeltaY1]) > (log2_tab[mDeltaX1] + log2_tab[mDeltaY2]);
    ;;         ;; A1Right = mDeltaY1*mDeltaX2 > mDeltaY2*mDeltaX1;

			ldx _mDeltaY1
			ldy _mDeltaX2
			clc
			lda _log2_tab,x
			adc _log2_tab,y
			ror						; to avoid modulo by overflow
			sta ptr2

			ldx _mDeltaX1			; abs(mDeltaX1)
			ldy _mDeltaY2
			clc
			lda _log2_tab,x
			adc _log2_tab,y
			ror						; to avoid modulo by overflow
			sta ptr2+1			; (log2_tab[abs(mDeltaX1)] + log2_tab[mDeltaY2])

			cmp ptr2

			bcs isA1Right1_done

			lda #$01
			sta _A1Right

			jmp isA1Right1_done
isA1Right1_mDeltaX2_negativ_01:
    ;;     } else {
			lda #$0
			sta _A1Right
    ;;         A1Right = 0 ; ;; (mDeltaX1 < 0) 
    ;;     }
	jmp isA1Right1_done
isA1Right1_mDeltaX1_negativ:
    ;; } else {
		eor #$ff
		sec
		adc #$00
		sta ptr1 ; ptr1 = abs(mDeltaX1)
 
    ;;     if ((mDeltaX2 & 0x80) == 0){
		lda _mDeltaX2
		bmi isA1Right1_mDeltaX2_negativ_02
    ;;         A1Right = 1 ; ;; (mDeltaX1 < 0)
			lda #$01
			sta _A1Right
			jmp isA1Right1_done
 isA1Right1_mDeltaX2_negativ_02:
    ;;     } else {
    ;;         ;; printf ("%d*%d  %d*%d ", mDeltaY1, -mDeltaX2, mDeltaY2,-mDeltaX1);get ();
			eor #$ff
			sec
			adc #$00
			sta ptr1+1 ; ptr1+1 = abs(mDeltaX2)
    ;;         A1Right = (log2_tab[abs(mDeltaX2)] + log2_tab[mDeltaY1]) < (log2_tab[abs(mDeltaX1)] + log2_tab[mDeltaY2]);

			ldx ptr1+1			; abs(mDeltaX2)
			ldy _mDeltaY1
			clc
			lda _log2_tab,x
			adc _log2_tab,y
			ror					; to avoid modulo by overflow
			sta ptr2			; log2_tab[abs(mDeltaX2)] + log2_tab[mDeltaY1]

			ldx ptr1			; abs(mDeltaX1)
			ldy _mDeltaY2
			clc
			lda _log2_tab,x
			adc _log2_tab,y
			ror					; to avoid modulo by overflow
			sta ptr2+1			; (log2_tab[abs(mDeltaX1)] + log2_tab[mDeltaY2])

			cmp ptr2 

			bcc isA1Right1_done

			lda #$01
			sta _A1Right

    ;;     }
    ;; }

isA1Right1_done:
.IFDEF SAFE_CONTEXT
	;; restore context
	pla
	sta ptr1+1 
	pla
	sta ptr1 
	pla
	sta ptr2+1 
	pla
	sta ptr2 
	pla
	tay
	pla
	tax
	pla
.ENDIF ;; SAFE_CONTEXT

	rts

.endproc
.ENDIF ;; USE_ASM_ISA1RIGHT1



USE_ASM_ISA1RIGHT3 = 1
.IFDEF USE_ASM_ISA1RIGHT3
.export _isA1Right3
;; void isA1Right3()
.proc _isA1Right3

	lda #$00
	sta _A1Right

	;; A1Right = (A1X > A2X);
	lda _A2X
	sec
	sbc _A1X
	bvc isA1Right3_skip_01
	eor #$80
isA1Right3_skip_01:
	bpl isA1Right3_done

	lda #$01
	sta _A1Right
isA1Right3_done:
	rts
.endproc
.ENDIF ;; USE_ASM_ISA1RIGHT3

USE_ASM_SWITCHA1XSATUR = 1
.IFDEF USE_ASM_SWITCHA1XSATUR
.export _switch_A1XSatur
;; void switch_A1XSatur()
.proc _switch_A1XSatur
	lda _A1XSatur
	eor #$01
	sta _A1XSatur
.endproc
.ENDIF ;; USE_ASM_SWITCHA1XSATUR

USE_ASM_SWITCHA2XSATUR = 1
.IFDEF USE_ASM_SWITCHA2XSATUR
.export _switch_A2XSatur
;; void switch_A2XSatur()
.proc _switch_A2XSatur
	lda _A2XSatur
	eor #$01
	sta _A2XSatur
.endproc
.ENDIF ;; USE_ASM_SWITCHA2XSATUR

; .IFDEF USE_ASM_FUNCNAME
; .export _funcName

; ;; void funcName()
; .proc _funcName


; .endproc
; .ENDIF ;; funcName