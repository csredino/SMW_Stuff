

rtl
nop #2
jmp ChuckMain
rtl



				
ChuckMain:
                    lda $13E4
                    cmp #$70
					bcc NotIvincible
		        	lda #$01
                    sta $1490					
NotIvincible:  					
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
                                lda $1490
								bne CODE_01A837
                                jsl $00F5B7
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

