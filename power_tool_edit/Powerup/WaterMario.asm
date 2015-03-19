
JMP WaterInit
jmp WaterMain
jmp WaterOut
WaterInit:
			lda #$01
			sta $86
			rtl
WaterMain:
			
			lda #$01
			sta $86
			lda $75
			beq gotoOutOfW
			jmp underWater
gotoOutOfW:	jmp outOfWater



outOfWater:
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
 db $10, $25
UpSpeed:
 db $f0, $db
LeftSpeed:
 db $f0, $db
RightSpeed:
 db $10, $25
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
WaterOut:
			stz $86
			lda $192a
			bpl isNotSlip
			lda #$01
			sta $86
isNotSlip:  rtl			