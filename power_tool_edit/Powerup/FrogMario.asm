
JMP FrogInit
jmp FrogMain
rtl
FrogInit:

			rtl
FrogMain:
			

			lda $75
			beq gotoOutOfW
			jmp underWater
gotoOutOfW:	jmp outOfWater


GroundFrames:

db $00, $01, $02

Threesold1:
		db $07, $15
Threesold2:
		db $0d, $1e
Threesold3:
		db $15, $25
ResetSpeed:
		db $00, $04
intheair:
				plb
				rtl
outOfWater:
				phb
				phk
				plb
				ldx #$00
				ldy #$00
				lda $72
				bne intheair
				lda $15
				and #$40	
				beq walkanim
				iny
walkanim:		lda $7B
				bpl noFixSign
				eor #$FF
				inc
noFixSign:	    cmp Threesold1,y
				bcc nonextframe
				inx
nonextframe:	cmp Threesold2,y
				bcc nonextframe2
				inx
nonextframe2:	cmp Threesold3,y
				bcc noReset
				lda ResetSpeed,y
				ldy $76
				bne noFixSign2
				eor #$FF
				inc				
noFixSign2:		sta $7B
				stz $13e4
noReset:		lda GroundFrames,x
				sta $13e0
				plb
				rtl			

NeutralFrames:
 db $18, $1a, $1a
LifetRightFrames:
 db $29, $2a, $2b
UpFrames:
 db $2C, $2D, $2E
DownFrames:
 db $46, $47, $48
DownSpeed:
 db $10, $28
UpSpeed:
 db $f0, $db
LeftSpeed:
 db $f0, $db
RightSpeed:
 db $10, $28
underWater:
			phb
			phk
			plb
			stz $7B
			stz $7D
			ldy #$00
			lda $15
			bpl slowWaterSpeed
			iny
slowWaterSpeed:
     		lda $14
			and #$18
			lsr
			lsr
			lsr
			beq nodec
			dec
nodec:		tax
			lda NeutralFrames,x
			sta $13e0
			lda $15
			bit #$01
			beq notRight
			lda LifetRightFrames,x
			sta $13e0
			lda $77
			bit #$01
			bne notRight
			lda RightSpeed,y
			sta $7B
notRight:	lda $15
			bit #$02
			beq notLeft
			lda LifetRightFrames,x
			sta $13e0
			lda $77
			bit #$02
			bne notLeft
			lda LeftSpeed,y
			sta $7B
notLeft:	lda $15
			bit #$04
			beq notDown
			lda DownFrames,x
			sta $13e0
			lda $77
			bit #$04
			bne notDown
			lda DownSpeed,y
			sta $7D
notDown:	lda $15
			bit #$08
			beq notUp
			lda UpFrames,x
			sta $13e0
			lda $77
			bit #$08
			bne notUp
			lda UpSpeed,y
			sta $7D
notUp:		plb
			rtl
