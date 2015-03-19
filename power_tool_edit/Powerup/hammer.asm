!Attack = $7Faa2A
!Timer = $7FAa2B
!CoolDown = $7Faa2C
!XDisplacement = $7FAa2D
!YDisplacement = $7Faa2f
!Direction = $7Faa31

jmp HammerInit
jmp HammerMain
rtl

HammerInit:
                  lda #$00
				  sta !Attack
				  sta !CoolDown
				  sta !Timer
 
				  
Return:				  
                  rtl
HammerMain:
                  lda $9d
				  bne Return
                  lda !Attack               
				  asl
				  tax
				  jsr (AttackPointer,x)
                  lda $187A     ;\
				  ora !Timer    ; |Can't attack while one yoshi or while already attacking
				  ora !CoolDown
				  bne NoAttack	;/				  
				  lda $16
				  and #$40
				  beq NoAttack				  
				  ldx #$01
				  lda $13e4
				  cmp #$40
				  bcc NotDash
				  ldx #$02
NotDash:		  lda $77
                  and #$04
				  ora $75
                  bne NotAir				  
				  ldx #$03
NotAir:           txa
                  sta !Attack
                  lda Timerlist,x
                  sta !Timer
                  lda #$10
                  sta !CoolDown
                  lda $76
				  sta !Direction
 				  
NoAttack:         
                  rtl                				  
				  
AttackPointer:
	dw ReduceCooldown, Normal, Dash, Air		



ReduceCooldown:
                  lda !CoolDown
				  beq +
                  dec
			      sta !CoolDown
				  +
				  rts
				  
FrameList:
	db $2c,$2b,$2a,$29
XInterraction:
	dw $ffec,$ffef,$0000,$0010
YInterraction:
	dw $000a,$ffff,$fff3,$ffff
Timerlist:
	db $00,$10,$40,$20


	
Normal:            
                  lda !Timer
				  beq EndAttack
				  dec
				  sta !Timer
				  lsr
				  lsr
				  tax
                  lda FrameList,x
                  sta $13e0
				  txa
				  asl
				  tax
				  rep #$20
                  lda XInterraction,x		  
				  ldy $76
				  beq +
				  eor #$FFFF
				  inc
				  +
                  sta !XDisplacement
                  lda YInterraction,x			  
                  sta !YDisplacement
				  sep #$20
                  jsr Runinterraction		
                  stz $7B				  
                  rts
EndAttack:
                  lda #$00
                  sta !Attack
				  sta !Timer
				;  sta !CoolDown
                  rts	
FrameList2:
	db $4a,$49,$4a,$46,$47,$48,$47,$46
XInterraction2:
	dw $FFEF,$0000,$FFEF,$ffec,$FFEF,$0000,$FFEF, $ffec 
YInterraction2:
	dw $000a,$000a,$000a,$000a,$000a,$000a,$000a,$000a

ChangeDirection:
                  lda !Direction
                  eor #$01
				  sta !Direction
				  bra ReturnFromDirectionChange

Dash:				  
                  lda !Timer
				  beq EndAttack
				  dec
				  sta !Timer
				  and #$1F
				  cmp #$04
				  beq ChangeDirection
				  cmp #$18
				  beq ChangeDirection
ReturnFromDirectionChange:	
                  lda !Timer
				  and #$1F
				  lsr
				  lsr
				  tax
                  lda FrameList2,x
                  sta $13e0					  
				  lda !Direction
                  sta $76	
				  txa
				  asl
				  tax
				  rep #$20
                  lda XInterraction2,x		  
				  ldy $76
				  beq +
				  eor #$FFFF
				  inc
				  +
                  sta !XDisplacement
                  lda YInterraction2,x			  
                  sta !YDisplacement
				  sep #$20
                  jsr Runinterraction
                  lda $7b
                  bmi +				  
                  dec $7B	  
                  rts
                  +
                  inc $7B
                  rts	
FrameList3:
	db $52,  $51,  $50,  $4F,  $4E,  $4D,  $4C,  $4B
XInterraction3:
	dw $FFf1,$0000,$0013,$0015,$000c,$0000,$FFEe,$ffea 
YInterraction3:
	dw $fff4,$ffef,$fffe,$000a,$001a,$001d,$0016,$000a
Air:
                  lda $77
				  and #$04
				  beq NoGroundCancel
				  lda #$00
				  sta !Timer
NoGroundCancel:   lda !Timer
				  bne + 
				  jmp EndAttack
				  +
				  dec
				  sta !Timer
				  and #$0F
				  lsr
				  tax
				  lda FrameList3,x
				  sta $13E0
				  txa
				  asl
				  tax
				  rep #$20
                  lda XInterraction,x		  
				  ldy $76
				  beq +
				  eor #$FFFF
				  inc
				  +
                  sta !XDisplacement
                  lda YInterraction,x			  
                  sta !YDisplacement
				  sep #$20
                  jsr Runinterraction		
                  rts

EndLoop:
                  rts
				  
Runinterraction:
                  ldx #$0C				  
CheckSprLoop:     
                  dex
                  bmi EndLoop				  
                  lda $14c8,x
				  cmp #$08
				  bcc CheckSprLoop
				  LDA $167A,X   ; \ Skip current sprite if... 
                  AND #$02                ;  | ...invincible to fire/cape/etc   
                  ORA $15D0,X             ;  | ...sprite being eaten... 
                  ORA $1632,X ;  | ...interactions disabled...           				  
                  BNE CheckSprLoop     ; / 
                  rep #$20				  
                  lda $d1
				  clc
				  adc !XDisplacement
				  sep #$20
				  sta $00
				  xba
				  sta $08
				  rep #$20
				  lda $d3
				  clc
				  adc !YDisplacement
				  sep #$20
				  sta $01
                  xba
				  sta $09
			      LDA #$15                
                  STA $02  
                  lda #$15
                  sta $03
                  JSL $03B69f                    ;Get sprite's clipping						  
                  JSL $03B72b                    ;Check for contact
                  bcc CheckSprLoop
                  LDA #$02                ;  | Play sound effect 
                  STA $1DF9               ;  | 
				  lda #$02
				  sta $14c8,x
                  LDA #$D0                ;  | Set death Y speed 
                  STA $AA,X    ;  | 
CODE_02A11C:      LDA #$04                ;  | Increase points 
CODE_02A11E:      JSL $02ACE5          ;  | 
                  lda #$20
				  ldy !XDisplacement
				  bne +
				  lda #$df
				  +
				  sta $B6,x
				  bra CheckSprLoop