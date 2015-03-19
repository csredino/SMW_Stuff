!Timer1 = $7Faa2A
!Timer2 = $7FAa2B
!Timer3 = $7Faa2C
!StatueTimer = $7Faa2D
!animTimer = $7Faa2e
!PalBackup = $7Faa2F

JMP RacoonInit
jmp RacoonMain
rtl
stonePallete:
incbin Powerup/tanukistone.pal
SmokeFrame:
 db $41,$40,$3F

destone:
LDA #$3f
STA $13E0
;LDA #$0d
;STA $1DF9
lda #$8B
sta !animTimer
LDA #$00
STA !StatueTimer
lda !PalBackup
sta !PalleteBank
lda !PalBackup+1
sta $0D82
lda !PalBackup+2
sta $0D83
lda !AbillityByte1 
and #$eF
sta !AbillityByte1 
rtl     
 
 
stoned:

LDA #$3b
STA $13E0
lda !StatueTimer
cmp #$20
bcc flash
lda #$03
flash:
sta $1497
lda !StatueTimer
dec
sta !StatueTimer
beq destone
lda $15
and #$40
beq destone
stz $15
stz $18
                    JSR SprCollision
					cpx #$00
					bmi NotKillSprite	                   					
					jsr SUB_STOMP_PTS
					lda $1490
					bne Dontbounce					
                    JSL $01AA33             ; set mario speed
                    JSL $01AB99             ; display contact graphic
					Dontbounce:		
					LDA #02
					STA $14C8,x
					sta $AA,x
					stz $B6,x
NotKillSprite:      

     
                    rtl

					rtl

STAR_SOUNDS:         db $00, $13, $14, $15, $16, $17, $18, $19

SUB_STOMP_PTS:                          ; 
                    LDA $1697              ; \
                    INC $1697             ; increase consecutive enemies stomped
					phx
                    TAx                    ;
                    INx                     ;
                    CPx #$08                ; \ if consecutive enemies stomped >= 8 ...
                    BCS NO_SOUND            ; /    ... don't play sound 
                    LDA STAR_SOUNDS,x       ; \ play sound effect
                    STA $1DF9               ; /   					
NO_SOUND:            TxA                     ; \
                    CMP #$08                ;  | if consecutive enemies stomped >= 8, reset to 8
                    BCC NO_RESET            ;  |
                    LDA #$08                ; /
NO_RESET:           plx
                    JSL $02ACE5             ; give mario points                    ;
                    RTS                     ; return
					
					CODE_01AD42:                 LDY #$00                
CODE_01AD44:                 LDA $D3                   
CODE_01AD46:                   SEC                       
CODE_01AD47:                 SBC $d8,X       
CODE_01AD49:                 STA $0E                   
CODE_01AD4B:                 LDA $D4                   
CODE_01AD4D:              SBC $14d4,X     
CODE_01AD50:                 BPL Return01AD53          
CODE_01AD52:                    INY                       
Return01AD53:                   RTS                       ; Return 

SubHorizPos:                 LDY #$00                
CODE_01AD32:                 LDA $D1                   
CODE_01AD34:                    SEC                       
CODE_01AD35:                 SBC $e4,X       
CODE_01AD37:                 STA $0F                   
CODE_01AD39:                 LDA $D2                   
CODE_01AD3B:              SBC $14e0,X     
CODE_01AD3E:                 BPL Return01AD41          
CODE_01AD40:                    INY                       
Return01AD41:                   RTS                       ; Return 


MarioSprInteractRt:      LDA $167A,X   ; \ Branch if "Process interaction every frame" is set 
CODE_01A7E7:                 AND #$20                ;  | 
CODE_01A7E9:                 BNE ProcessInteract       ; / 
CODE_01A7EB:                    TXA                       ; \ Otherwise, return every other frame 
CODE_01A7EC:                 EOR $13      ;  | 
CODE_01A7EE:                 AND #$01                ;  | 
CODE_01A7F0:              ORA $15a0,X ;  | 
CODE_01A7F3:                 BEQ ProcessInteract       ;  | 
ReturnNoContact:                CLC                       ;  | 
Return01A7F6:                   RTS                       ; / 

ProcessInteract:          JSR SubHorizPos         
CODE_01A7FA:                 LDA $0F                   
CODE_01A7FC:                    CLC                       
CODE_01A7FD:                 ADC #$50                
CODE_01A7FF:                 CMP #$A0                
CODE_01A801:                 BCS ReturnNoContact       ; No contact, return 
CODE_01A803:              JSR CODE_01AD42         
CODE_01A806:                 LDA $0E                   
CODE_01A808:                    CLC                       
CODE_01A809:                 ADC #$60                
CODE_01A80B:                 CMP #$C0                
CODE_01A80D:                 BCS ReturnNoContact       ; No contact, return 
CODE_01A80F:                 LDA $71    ; \ If animation sequence activated... 
CODE_01A811:                 CMP #$01                ;  | 
CODE_01A813:                 BCS ReturnNoContact       ; / ...no contact, return 
CODE_01A815:                 LDA #$00                ; \ Branch if bit 6 of $0D9B set? 
CODE_01A817:              BIT $0D9B               ;  | 
CODE_01A81A:                 BVS CODE_01A822           ; / 
CODE_01A81C:              LDA $13F9 ; \ If Mario and Sprite not on same side of scenery... 
CODE_01A81F:              EOR $1632,X ;  | 
CODE_01A822:                 BNE ReturnNoContact2      ; / ...no contact, return 
CODE_01A824:           JSL $03b664
CODE_01A828:           JSL $03b69f
CODE_01A82C:           JSL $03B72B
CODE_01A830:                 BCC ReturnNoContact2      ; No contact, return 
CODE_01A87E:              STZ $18D2               
CODE_01A881:              LDA $154c,X  
CODE_01A884:                 BNE CODE_01A895           
CODE_01A886:                 LDA #$08                
CODE_01A888:              STA $154c,X  
CODE_01A88B:              LDA $14C8,X             
CODE_01A88E:                 CMP #$09                
CODE_01A890:                 BNE CODE_01A897                  
CODE_01A895:                    CLC                       
Return01A896:                   RTS                       ; Return 

CODE_01A897:                 LDA #$14                
CODE_01A899:                 STA $01                   
CODE_01A89B:                 LDA $05                   
CODE_01A89D:                    SEC                       
CODE_01A89E:                 SBC $01                   
CODE_01A8A0:                 ROL $00                   
CODE_01A8A2:                 CMP $96                   
CODE_01A8A4:                   PHP                       
CODE_01A8A5:                LSR $00                   
CODE_01A8A7:                 LDA $0B                   
CODE_01A8A9:                SBC #$00                
CODE_01A8AB:                    PLP                       
CODE_01A8AC:                 SBC $97                  
CODE_01A8AE:                 BMI hurt                               

CODE_01A837:                    SEC                       ; Contact, return 
Return01A838:                   RTS                       ; Return 
hurt:                        
ReturnNoContact2:               CLC                       
Return01A87D:                   RTS                       ; Return 
SprCollision:
                    ldx #$0c
CheckNextSprite:    lda $14C8,x
					cmp #$08
                    bne	Skip
                    LDA $167a,X
                    BMI	Skip				
                    JSr MarioSprInteractRt ; check for mario/sprite contact
                    BCs CONTACT            ; (carry set = mario/sprite contact)
Skip:
					dex
					bpl CheckNextSprite
CONTACT:
					rts
rtl

                

SmokeAnim:
lda #$05
sta $18BD
STZ $7b
lda #$FF
STa $7d
lda !animTimer
and #$7F
lsr
lsr
tax
lda SmokeFrame,x
sta $13e0
lda #$03
sta $1497
lda !animTimer
dec
sta !animTimer
and #$7F
beq EndAnim
rtl

EndAnim:
lda !animTimer
bmi turnNormal
lda #$80
sta !StatueTimer
rtl
turnNormal:
lda #$00
sta !animTimer
sta !StatueTimer

rtl


RacoonInit:
lda #$00
sta !Timer1
sta !Timer2
sta !Timer3
sta !StatueTimer
sta !animTimer
rtl

beginStone:
LDA #$3f
STA $13E0
LDA #$0B
STA !animTimer
STZ $7b
STZ $7d
lda !PalleteBank
sta !PalBackup
phk
pla
sta !PalleteBank
rep #$20
lda $0d82
sta !PalBackup+1
lda #stonePallete
sta $0d82
sep #$20
lda !AbillityByte1 
ora #$10
sta !AbillityByte1 
RTl


RacoonMain:
lda $100
cmp #$14
bne RacoonInit
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
						lda $187a         ;| if mario is ducking, on yoshi, or spinjumping, 
						ORA $148f
						BNE CantStone          ;/
						lda !StatueTimer
						beq notstoned
						jmp stoned
notstoned:				LDA !animTimer
						Beq notSmokeAnim
						jmp SmokeAnim
notSmokeAnim:			lda $15
						and #$04
						ora $16
						and #$44
						cmp #$44
						bne CantStone
						jmp beginStone
CantStone:

						lda $13E3
						bne Flight
						lda !Timer1
						bne CantSpin
						BIT $16                   ;\ if X/Y not held, return
CODE_00D06A:              BVC CantSpin          ;/
CODE_00D06C:              LDA $73         ;\
CODE_00D06E:              ORA $187a         ;| if mario is ducking, on yoshi, or spinjumping, 
CODE_00D071:              ORA $140d      ;|return
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


		