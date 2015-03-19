;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Custom Sprite ? Block
;
;Set it to act like tile 129
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

db $42
JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireBall
JMP MarioTopCorner : JMP MarioHeadIn : JMP MarioBodyIn
SpriteV:
SpriteH:
	lda $14c8,x
	cmp #$0A
	bne MarioSide
	jsr SetSpriteCoord2 
	bra spawn
MarioCape:
MarioBelow:
	JSR SetSpriteCoord1 
spawn:
	LDA #$00 		;Custom Sprite Number
	JSR SpawnSprite
	RTL

MarioHeadIn:
MarioBodyIn:
MarioFireBall:
MarioTopCorner:
MarioAbove:
MarioSide:
	RTL


SpawnSprite: 
	PHX 
	PHP 
	SEP #$30 
	PHA 
	LDX #$0B 
SpwnSprtTryAgain: 
	LDA $14C8,x ;Sprite Status Table 
	BEQ SpwnSprtSet 
	DEX 
	CPX #$FF 
	BEQ SpwnSprtClear 
	BRA SpwnSprtTryAgain 
SpwnSprtClear: 
	DEC $1861 
	BPL SpwnSprtExist 
	LDA #$01 
	STA $1861 
SpwnSprtExist: 
	LDA $1861 
	CLC 
	ADC #$0A 
	TAX 
SpwnSprtSet:
;	STX $185E  ;seem to litterally do nothing beside causing glitch if a sprite activated the block so I commented it out
	LDA #$08 
	STA $14C8,x ;Sprite Status Table
	PLA 
    STA $7FAB9E,x
    JSL $07F7D2             ; reset sprite properties
    JSL $0187A7             ; get table values for custom sprite
	LDA #$88                ; mark as initialized
    STA $7FAB10,x
	INC $15A0,x 		;"Sprite off screen" flag, horizontal
	LDA $9A ;Sprite creation: X position (low) 
	STA $E4,x ;Sprite Xpos Low Byte 
	LDA $9B 
	STA $14E0,x ;Sprite Xpos High Byte 
	LDA $98 ;Sprite creation: Y position (low) 
	STA $D8,x ;Sprite Ypos Low Byte 
	LDA $99 ;Sprite creation: Y position (high) 
	STA $14D4,x ;Sprite Ypos High Byte 
	LDA #$3E 
	STA $1540,x ;Sprite Spin Jump Death Frame Counter 
	LDA #$D0 
	STA $AA,x ;Sprite Y Speed 
	LDA #$2C 
	STA $144C,x 
	LDA $190F,x ;Sprite Properties 
	BPL SpwnSprtProp 
	LDA #$10 
	STA $15AC,x 
SpwnSprtProp: 
	lda $03
	beq nochecksmall
	lda $19
	beq small
nochecksmall:
	lda $03
	sta $c2,x
	PLP 
	PLX 
	RTS 
small:	
	lda #$01
	sta $c2,x
	PLP 
	PLX 
	RTS 
SetSpriteCoord1: 
	PHP 
	REP #$20 
	LDA $98 
	AND #$FFF0 
	STA $98 
	LDA $9A 
	AND #$FFF0 
	STA $9A 
	PLP 
	RTS 
SetSpriteCoord2: 
	PHP 
	LDA $d8,x 
	AND #$F0 
	STA $98 
	lda $14d4,x
	sta $99
	LDA $e4,x 
	AND #$F0 
	STA $9A 
	lda $14e0,x
	sta $9b
	PLP 
	RTS 