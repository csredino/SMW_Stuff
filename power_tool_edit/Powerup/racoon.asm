!Timer1 = $7Faa2A
!Timer2 = $7FAa2B
!Timer3 = $7Faa2C


JMP RacoonInit
jmp RacoonMain
rtl
RacoonInit:
lda #$00
sta !Timer1
sta !Timer2
sta !Timer3
rtl
RacoonMain:
lda !Timer1
beq NoDecrease1
lda !Timer1
dec
sta !Timer1
NoDecrease1:
lda !Timer2
beq NoDecrease2
lda !Timer2
dec
sta !Timer2
NoDecrease2:
lda !Timer3
beq NoDecrease3
lda !Timer3
dec
sta !Timer3
NoDecrease3:
lda $13E3
bne Flight
lda !Timer1
bne CantSpin
CODE_00D068:                BIT $16                   ;\ if X/Y not held, return
CODE_00D06A:                 BVC CantSpin          ;/
CODE_00D06C:                 LDA $73         ;\
CODE_00D06E:              ORA $187a         ;| if mario is ducking, on yoshi, or spinjumping, 
CODE_00D071:              ORA $140d      ;|return
.						  ora $1493
                          ora !Timer1
CODE_00D074:              BNE CantSpin          ;/
CODE_00D076:              LDA #$12                ;\
CODE_00D078:              STA $14A6               ;/ make mario spin
CODE_00D07B:              LDA #$04                ; \ Play sound effect 
CODE_00D07D:              STA $1DFC               ; / 
                          lda #$1a
						  sta !Timer1
CantSpin:
                    lda $75
					ora $71
					bne SkipFlight
					lda $13EF		;\
					ora $1471		; |goto air if the player is in the air
                    BEq Air			;/
                    lda $13E4 
                    cmp #$70
					bcc SkipFlight
Flight:             lda #$B0
					sta !Timer3
SkipFlight:         rtl
FlyingFrames:
db $0c, $2B
AirFrames:
db $24, $2a
CrouchFrames:
db $3c, $29
YSpeed:
db $0b, $e8
Air:                     
                    ldx #$00
					lda $140D
					bne SpinJump
                    lda !Timer3
					beq NotFlying
                    ldx #$01
                    stx $1404					
NotFlying:   

SpinJump:           lda $16
					bit #$80
					beq NoIncFloat					
                    lda #$10
					sta !Timer2
                    LDA #$04                ; \ Play sound effect 
                    STA $1DFC               ; / 
NoIncFloat:			
                    lda !Timer2
                    beq NoFloat
					lda $7D
					cmp YSpeed,x
					bmi NoFloat
                    lda YSpeed,x				
                    sta $7D					
NoFloat:            lda $14
					and #$04
					lsr #2
					tax
					lda !Timer2
					beq return
					lda AirFrames,x
					sta $13e0
					lda !Timer3
					beq next
					lda FlyingFrames,x
					sta $13e0
next:				lda $73
					beq return
					lda CrouchFrames,x
					sta $13e0
return:				rtl             					