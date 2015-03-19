
!Type = $174f
jmp HammerOut
jmp HammerMain
jmp HammerOut
jmp HammerExSprite




FindFreeSlot:
CODE_00FD19:                LDy #$01                ; \ Find a free extended sprite slot 
CODE_00FD1B:            LDA $1713,y   ;  | 
CODE_00FD1E:              BEQ ExSpriteReturn           ;  | 
CODE_00FD20:                    DEy                       ;  | 
CODE_00FD21:                 BPL CODE_00FD1B           ;  | 
ExSpriteReturn:                  rts                      ; / Return if no free slots 


Xpositionlo:
				db $fa, $05
Xpositionhi:	
				db $ff, $00		
HammerMain:
		phx
		ldx #$00
		rep #$20
		lda #$02e4
		jsl $01c546
		ldx #$02
		lda #$02e5
		jsl $01c546
		plx
		sep #$20
		lda $187A
		BNE NoGenerateHammer
        lda $16
		and #$40
		beq NoGenerateHammer
        jsr	FindFreeSlot
		bmi NoGenerateHammer
		STZ $00		;initialize scratch RAM
		lda $7B
		bpl +
		eor #$FF
+		lsr
		lsr
		lsr
		ldx $7B
		bpl +
		eor #$FF
+		sta $01
		LDA $76
		CLC
		ROR A
		ROR A
		EOR $01
		BPL +
		LDA $01
		STA $00
+		LDA #$01
		LDx $76
		BNE +
		EOR #$FF
		INC A
+		CLC
		ADC $00
		STA !Type,y	;Store into somespritetype's X speed
		lda $94
		clc
        adc Xpositionlo,x		
		sta $1727,y
		lda $95
        adc Xpositionhi,x	
		sta $173B,y
		lda #$b0 
		sta $1745,y
		lda $96
		clc
		adc #$14
		sta $171d,y
		lda $97
		adc #$00
		sta $1731,y
		lda #$05
		sta $1713,y
		lda #$0A
		sta $149C
		lda $1339
		sta $1781,y
NoGenerateHammer:
		rtl


HammerOut:
ldy #$01
- LDA $1713,y   ;  | 
beq +
lda #$0F
sta $1777,y
lda #$01
sta $1713,y
+     dey
bpl -
rtl

DATA_00E53D:                      db $FF,$FF,$FF,$FF,$01,$01,$01,$01
                                  db $FE,$FE,$02,$02,$FD,$03,$FD,$03
                                  db $FD,$03,$FD,$00,$00,$00,$00,$00
                                  db $08,$08,$F8,$F8,$FC,$FC,$04,$04
                                  db $00,$00,$00,$00,$00,$00,$01,$01
                                  db $01,$01,$01,$02,$02,$02,$02,$02
                                  db $03,$03,$03,$03,$03,$04,$04,$04
                                  db $04,$04,$05,$05,$05,$05,$05,$06
                                  db $06,$06,$06,$06,$07,$07,$07,$07
                                  db $07,$08,$08,$08,$08,$08,$09,$09
                                  db $09,$09,$09,$0A,$0A,$0A,$0A,$0A
                                  db $0B,$0B,$0B,$0B,$0B,$0C,$0C,$0C
                                  db $0C,$0C,$0D,$0D,$0D,$0D,$0D,$0E
                                  db $0F,$10,$11,$03,$03,$04,$04,$09
                                  db $09,$0A,$0A,$0C,$0C,$0D,$0D,$12
                                  db $13,$14,$15,$16,$17,$1C,$1D,$1E
                                  db $1F,$18,$19,$1A,$1B,$08,$09,$0A
                                  db $0B,$0C,$0D,$00,$00,$00,$00,$00
                                  db $01,$01,$01,$01,$01,$02,$02,$02
                                  db $02,$02,$03,$03,$03,$03,$03,$04
                                  db $04,$04,$04,$04,$05,$05,$05,$05
                                  db $05,$06,$06,$06,$06,$06,$07,$07
                                  db $07,$07,$07,$08,$08,$08,$08,$08
                                  db $09,$09,$09,$09,$09,$0A,$0A,$0A
                                  db $0A,$0A,$0B,$0B,$0B,$0B,$0B,$0C
                                  db $0C,$0C,$0C,$0C,$0D,$0D,$0D,$0D
                                  db $0D,$0E,$0F,$10,$11,$03,$03,$04
                                  db $04,$09,$09,$0A,$0A,$0C,$0C,$0D
                                  db $0D,$0C,$0D,$0D,$0C,$16,$17,$1C
                                  db $1D,$1E,$1F,$18,$19,$1A,$1B,$08
                                  db $09,$0A,$0B,$0C,$0D

								  

DATA_029F99:                      db $00,$B8,$C0,$C8,$D0,$D8,$E0,$E8
                                  db $F0

DATA_029FA2:                      db $00

DATA_029FA3:                      db $05,$03

DATA_029FA5:                      db $02,$02,$02,$02,$02,$02,$F0,$F8
                                  db $A0,$A8


FireKillSpeedX:                   db $F0,$10



	
DATA_00BA60:                      db $00,$B0,$60,$10,$C0,$70,$20,$D0
                                  db $80,$30,$E0,$90,$40,$F0,$A0,$50
DATA_00BA70:                      db $00,$B0,$60,$10,$C0,$70,$20,$D0
                                  db $80,$30,$E0,$90,$40,$F0,$A0,$50
DATA_00BA80:                      db $00,$00,$00,$00,$00,$00,$00,$00
                                  db $00,$00,$00,$00,$00,$00

DATA_00BA8E:                      db $00,$00,$00,$00,$00,$00,$00,$00
                                  db $00,$00,$00,$00,$00,$00

DATA_00BA9C:                      db $C8,$C9,$CB,$CD,$CE,$D0,$D2,$D3
                                  db $D5,$D7,$D8,$DA,$DC,$DD,$DF,$E1
DATA_00BAAC:                      db $E3,$E4,$E6,$E8,$E9,$EB,$ED,$EE
                                  db $F0,$F2,$F3,$F5,$F7,$F8,$FA,$FC
DATA_00BABC:                      db $C8,$CA,$CC,$CE,$D0,$D2,$D4,$D6
                                  db $D8,$DA,$DC,$DE,$E0,$E2

DATA_00BACA:                      db $E4,$E6,$E8,$EA,$EC,$EE,$F0,$F2
                                  db $F4,$F6,$F8,$FA,$FC,$FE	  
						  
HammerExSprite:
                          LDA $9D 
CODE_029FB1:              BNE CODE_02A02C           
CODE_029FB3:              LDA $1715,X   
CODE_029FB6:              CMP $1c    
CODE_029FB8:              LDA $1729,X   
CODE_029FBB:              SBC $1d    
CODE_029FBD:              BEQ CODE_029FC2           
CODE_029FBF:              JMP CODE_02A211         

CODE_029FC2:              INC $1765,X             
CODE_029FC5:              JSR ProcessFireball     
CODE_029FC8:              LDA $173d,X   
CODE_029FCB:              CMP #$30                
CODE_029FCD:              BPL CODE_029FD8           
CODE_029FCF:              LDA $173d,X   
CODE_029FD2:              CLC                       
CODE_029FD3:              ADC #$04                
CODE_029FD5:              STA $173d,X   
CODE_029FD8:              JSR CODE_02A56E         
CODE_029FDB:              Bra NoObjContact           
CODE_029FDD:              INC $175B,X             
CODE_029FE0:              LDA $175B,X             
CODE_029FE3:              CMP #$02                
CODE_029FE5:              BCS CODE_02A042           
CODE_029FE7:              LDA $1747,X   
CODE_029FEA:              BPL CODE_029FF3           
CODE_029FEC:              LDA $0B                   
CODE_029FEE:              EOR #$FF                
CODE_029FF0:              INC A                     
CODE_029FF1:              STA $0B                   
CODE_029FF3:              LDA $0B                   
CODE_029FF5:              CLC                       
CODE_029FF6:             ADC #$04                
CODE_029FF8:             TAY                       
CODE_029FF9:              LDA DATA_029F99,Y       
CODE_029FFC:              STA $173d,X   
CODE_029FFF:              LDA $1715,X   
CODE_02A002:              SEC                       
CODE_02A003:              SBC DATA_029FA2,Y       
CODE_02A006:              STA $1715,X   
CODE_02A009:              BCS CODE_02A00E           
CODE_02A00B:              DEC $1729,X   
CODE_02A00E:              BRA CODE_02A013  
         
NoObjContact:
CODE_02A010:              STZ $175B,X             
CODE_02A013:              LDY #$00                
CODE_02A015:              LDA $1747,X   
CODE_02A018:              BPL CODE_02A01B           
CODE_02A01A:              DEY                       
CODE_02A01B:              CLC                       
CODE_02A01C:              ADC $171f,X   
CODE_02A01F:              STA $171f,X   
CODE_02A022:              TYA                       
CODE_02A023:              ADC $1733,X   
CODE_02A026:              STA $1733,X   
CODE_02A029:              JSR CODE_02B560         
CODE_02A02C:      
CODE_02A03B:              LDa DATA_029FA3,X     
                          tay  
CODE_02A03E:              JSl DrawSprite         
                          rtl					 
					
CODE_02A042:              JSl CODE_02A02C         
CODE_02A045:              LDA #$01                ; \ Play sound effect 
CODE_02A047:              STA $1DF9               ; / 
CODE_02A04A:              LDA #$0F                
CODE_02A04C:              JMP CODE_02A4E0      			

CODE_02A04F:              LDa DATA_029FA5,X
                          tay       
ADDR_02A052:              LDA $1747,X   
ADDR_02A055:              AND #$80                
ADDR_02A057:              LSR                       
ADDR_02A058:              STA $00                   
ADDR_02A05A:              LDA $171f,X   
ADDR_02A05D:              SEC                       
ADDR_02A05E:              SBC $1a    
ADDR_02A060:              CMP #$F8                
ADDR_02A062:              BCS ADDR_02A0A9           
ADDR_02A064:              STA $0300,Y         
ADDR_02A067:              LDA $1715,X   
ADDR_02A06A:              SEC                       
ADDR_02A06B:              SBC $1c    
ADDR_02A06D:              CMP #$F0                
ADDR_02A06F:              BCS ADDR_02A0A9           
ADDR_02A071:              STA $0301,Y         
ADDR_02A074:              LDA $1779,X             
ADDR_02A077:              STA $01                   
ADDR_02A079:              LDA $1765,X             
ADDR_02A07C:              LSR                       
ADDR_02A07D:              LSR                       
ADDR_02A07E:              AND #$03                
ADDR_02A080:              TAX                       
ADDR_02A081:              LDA FireballTiles,X     
ADDR_02A084:              STA $0302,Y          
ADDR_02A087:              LDA FireballTileProp,X       
ADDR_02A08A:              EOR $00                   
ADDR_02A08C:              ORA $64
                          ora #$30                   
ADDR_02A08E:              STA $0303,Y          
ADDR_02A091:              LDX $01                   
ADDR_02A093:              BEQ ADDR_02A09C           
ADDR_02A095:              AND #$CF                
ADDR_02A097:              ORA #$30                
ADDR_02A099:              STA $0303,Y          
ADDR_02A09C:              TYA                       
ADDR_02A09D:              LSR                       
ADDR_02A09E:              LSR                       
ADDR_02A09F:              TAY                       
ADDR_02A0A0:              LDA #$00                
ADDR_02A0A2:              STA $0460,Y      
ADDR_02A0A5:              LDX $15E9               ; X = Sprite index 
Return02A0A8:             RTs                       ; Return 

ADDR_02A0A9:             JMP CODE_02A211    
FireRtNextSprite2:
                             jmp FireRtNextSprite	
							 
ProcessFireball:             TXA                       ; \ Return every other frame 
CODE_02A0AD:                 EOR $13      ;  | 
CODE_02A0AF:                 AND #$03                ;  | 
CODE_02A0B1:                 BNE Return02A0A8          ; / 
CODE_02A0B3:                 PHX                       
CODE_02A0B4:                 TXY                       
CODE_02A0B5:                 STY $185E               ; $185E = Y = Extended sprite index 
CODE_02A0B8:                 LDX #$09                ; Loop over sprites: 
FireRtLoopStart:             STX $15E9               
CODE_02A0BD:                 LDA $14C8,X             ; \ Skip current sprite if status < 8 
CODE_02A0C0:                 CMP #$08                ;  | 
CODE_02A0C2:                 BCC FireRtNextSprite2      ; / 
CODE_02A0C4:                 LDA $167A,X   ; \ Skip current sprite if... 
CODE_02A0C7:                 AND #$02                ;  | ...invincible to fire/cape/etc 
CODE_02A0C9:                 ORA $15D0,X             ;  | ...sprite being eaten... 
CODE_02A0CC:                 ORA $1632,X ;  | ...interactions disabled...           
CODE_02A0D2:                 BNE FireRtNextSprite      ; / 
CODE_02A0D4:                 JSL $03B69f                    ;Get sprite's cliiping
CODE_02A0D8:                 JSR GetHammerClipping                ;Get Hammer Cliiping
CODE_02A0DB:                 JSL $03B72b                    ;Check for contact
CODE_02A0DF:                 BCC FireRtNextSprite     
CODE_02A0E1:                 LDA $170b,Y   ; \ if Yoshi fireball... 
CODE_02A0E4:                 CMP #$11                ;  | 
CODE_02A0E6:                 BEQ CODE_02A0EE           ;  | 
CODE_02A0E8:                 PHX                       ;  | 
CODE_02A0E9:                 TYX                       ;  | 
CODE_02A0EA:                 JSl CODE_02A045         ;  | ...? 
CODE_02A0ED:                 PLX                       ; / 
CODE_02A0EE:                 LDA $167a,X   ; \ Skip sprite if fire killing is disabled 
CODE_02A0F1:                 AND #$02               ;  | 
CODE_02A0F3:                 BNE FireRtNextSprite      ; / 
ChuckFireKill:               LDA #$02                ;  | Play sound effect 
CODE_02A108:                 STA $1DF9               ;  | 
CODE_02A10B:                 LDA #$02                ;  | Sprite status = Killed 
CODE_02A10D:                 STA $14C8,X             ;  | 
CODE_02A110:                 LDA #$D0                ;  | Set death Y speed 
CODE_02A112:                 STA $AA,X    ;  | 
CODE_02A114:                 JSR SubHorzPosBnk2
                             phx
                             tyx							 
CODE_02A117:                 LDA FireKillSpeedX,x    ;  | Set death X speed 
                             plx
CODE_02A11A:                 STA $B6,X    ;  | 
CODE_02A11C:                 LDA #$04                ;  | Increase points 
CODE_02A11E:                 JSL $02ACE5          ;  | 
CODE_02A122:                 BRA FireRtNextSprite      ; / 

TurnSpriteToCoin:            LDA #$03                ; \ Turn sprite into coin: 
CODE_02A126:              STA $1DF9               ;  | Play sound effect 
CODE_02A129:                 LDA #$21                ;  | Sprite = Moving Coin 
CODE_02A12B:                 STA $9e,X       ;  | 
CODE_02A12D:                 LDA #$08                ;  | Sprite status = Normal 
CODE_02A12F:              STA $14C8,X             ;  | 
CODE_02A132:           JSL $07F7D2    ;  | Reset sprite tables 
CODE_02A136:                 LDA #$D0                ;  | Set upward speed 
CODE_02A138:                 STA $AA,X    ;  | 
CODE_02A13A:              JSR SubHorzPosBnk2      
CODE_02A13D:                    TYA                       
CODE_02A13E:                 EOR #$01                
CODE_02A140:              STA $157c,X     ; / 
FireRtNextSprite:         LDY $185E               
CODE_02A146:                    DEX                       
CODE_02A147:                 BMI CODE_02A14C           
CODE_02A149:              JMP FireRtLoopStart     

CODE_02A14C:                    PLX                       ; $15E9 = Sprite index 
CODE_02A14D:              STX $15E9               ; $15E9 = Sprite index 
Return02A150:                   rts       

CODE_02A211:              LDA #$00                ; \ Clear extended sprite 
CODE_02A213:              STA $170b,X   ; / 
Return02A216:             RTl                       ; Return 






YDisplacement:       db $fa,$02,$Fa,$02,$fe,$06,$fe,$06

FireballTiles:       db $33,$32,$33,$32,$32,$33,$32,$33	

XDisplacement:        db $02,$02,$Fe,$fe,$fe,$fe,$02,$02

FireballTileProp:    db $04,$04,$44,$44,$c4,$c4,$84,$84
						  

OAMIndex:            db $90,$94,$98,$9C,$A0,$A4,$A8,$b0,$b8,$c0	





        
DrawSprite:              LDA $1747,X   
CODE_02A1AA:              AND #$80                
CODE_02A1AC:              EOR #$80                
CODE_02A1AE:              LSR                       
CODE_02A1AF:              STA $00                   
CODE_02A1B1:              LDA $171f,X   
CODE_02A1B4:              SEC                       
CODE_02A1B5:              SBC $1a    
CODE_02A1B7:              STA $01                   
CODE_02A1B9:              LDA $1733,X   
CODE_02A1BC:              SBC $1b    
CODE_02A1BE:              BNE CODE_02A211           
CODE_02A1C0:              LDA $1715,X   
CODE_02A1C3:              SEC                       
CODE_02A1C4:              SBC $1c    
CODE_02A1C6:              STA $02                   
CODE_02A1C8:              LDA $1729,X   
CODE_02A1CB:              SBC $1d    
CODE_02A1CD:              BNE CODE_02A211           
CODE_02A1CF:              LDA $02                   
CODE_02A1D1:              CMP #$F0                
CODE_02A1D3:              BCS CODE_02A211  
                          lda #$01
                          sta $03						  
CODE_02A1E2:              LDA $14 
CODE_02A1E4:              LSR                                          
CODE_02A1E6:              AND #$06              
CODE_02A1E8:              TAX     
DrawLoop:
                          lda $02
                          clc
                          adc YDisplacement,x						  
CODE_02A1D5:              STA $0201,Y 
CODE_02A1D8:              LDA $01  
          				  clc
                          adc XDisplacement,x	 
CODE_02A1DA:              STA $0200,Y 
CODE_02A1DD:              LDA $1779,X             
CODE_02A1E0:              STA $04                                     
CODE_02A1E9:              LDA FireballTiles,X     
CODE_02A1EC:              STA $0202,Y  
CODE_02A1EF:              LDA FireballTileProp,X       
                          ora #$30                  
CODE_02A1F6:              STA $0203,Y
                          phx  
CODE_02A1F9:              LDX $04                   
CODE_02A1FB:              BEQ CODE_02A204           
ADDR_02A1FD:              AND #$CF                
ADDR_02A1FF:              ORA #$30                
ADDR_02A201:              STA $0203,Y  
CODE_02A204:              TYA
                          plx                       
CODE_02A205:              LSR                       
CODE_02A206:              LSR  
                          phy                     
CODE_02A207:              TAY                       
CODE_02A208:              LDA #$00                
CODE_02A20A:              STA $0420,Y     
                          ply
						  iny
						  iny
						  iny
						  iny
						  inx
                          dec $03
                          bpl DrawLoop 						  
CODE_02A20D:              LDX $15E9               ; X = Sprite index 
Return02A210:             RTl                       ; Return 
       
CODE_02A4E0:              STA $176F,X             
CODE_02A4E3:             ; LDA #$01                ;\Uncomment this to make hammer vanish when killing ennemie
Instr02A4E5:             ; STA $170B,x             ;/
Return02A4E8:             RTL                       ; Return 

GetHammerClipping:             
                          LDA $171f,Y   
CODE_02A54A:              clc                       
CODE_02A54B:              adc #$02                
CODE_02A54D:              STA $00                   
CODE_02A54F:              LDA $1733,Y   
CODE_02A552:              adc #$00                
CODE_02A554:              STA $08                   
CODE_02A556:              LDA #$0c                
CODE_02A558:              STA $02                   
CODE_02A55A:              LDA $1715,Y   
CODE_02A55D:              clc                       
CODE_02A55E:              adc #$03                
CODE_02A560:              STA $01                   
CODE_02A562:              LDA $1729,Y   
CODE_02A565:              adc #$00                
CODE_02A567:              STA $09                   
CODE_02A569:              LDA #$0a                
CODE_02A56B:              STA $03                   
Return02A56D:             RTS                       ; Return 

CODE_02A56E:                 STZ $0F                   
CODE_02A570:                 STZ $0E                   
CODE_02A572:                 STZ $0B                   
CODE_02A574:              STZ $1694               
CODE_02A577:              LDA $140F               
CODE_02A57A:                 BNE CODE_02A5BC           
CODE_02A57C:              LDA $0D9B               
CODE_02A57F:                 BPL CODE_02A5BC           
CODE_02A581:                AND #$40                
CODE_02A583:                 BEQ CODE_02A592           
ADDR_02A585:              LDA $0D9B               
ADDR_02A588:                 CMP #$C1                
ADDR_02A58A:                 BEQ CODE_02A5BC           
ADDR_02A58C:              LDA $1715,X   
ADDR_02A58F:                 CMP #$A8                
Return02A591:                  rts                       ; Return 


CODE_02A592:              LDA $171f,X   
CODE_02A595:              CLC                       
CODE_02A596:              ADC #$04                
CODE_02A598:              STA $14B4               
CODE_02A59B:              LDA $1733,X   
CODE_02A59E:              ADC #$00                
CODE_02A5A0:              STA $14B5               
CODE_02A5A3:              LDA $1715,X   
CODE_02A5A6:              CLC                       
CODE_02A5A7:              ADC #$08                
CODE_02A5A9:              STA $14B6               
CODE_02A5AC:              LDA $1729,X   
CODE_02A5AF:              ADC #$00                
CODE_02A5B1:              STA $14B7               
CODE_02A5B4:              JSL $01CC9D         
CODE_02A5B8:              LDX $15E9               ; X = Sprite index 
Return02A5BB:             rts                       ; Return 

CODE_02A5BC:              JSR CODE_02A611         
CODE_02A5BF:              ROL $0E                   
CODE_02A5C1:              LDA $1693               
CODE_02A5C4:              STA $0C                   
CODE_02A5C6:              LDA $5B
CODE_02A5C8:              BPL CODE_02A60C           
CODE_02A5CA:              INC $0F                   
CODE_02A5CC:              LDA $171f,X   
CODE_02A5CF:              PHA                       
CODE_02A5D0:              CLC                       
CODE_02A5D1:              ADC $26                   
CODE_02A5D3:              STA $171f,X   
CODE_02A5D6:              LDA $1733,X   
CODE_02A5D9:              PHA                       
CODE_02A5DA:              ADC $27                   
CODE_02A5DC:              STA $1733,X   
CODE_02A5DF:              LDA $1715,X   
CODE_02A5E2:              PHA                       
CODE_02A5E3:              CLC                       
CODE_02A5E4:              ADC $28                   
CODE_02A5E6:              STA $1715,X   
CODE_02A5E9:              LDA $1729,X  
CODE_02A5EC:              PHA                       
CODE_02A5ED:              ADC $29                   
CODE_02A5EF:              STA $1729,X     
CODE_02A5F2:              JSR CODE_02A611         
CODE_02A5F5:              ROL $0E                   
CODE_02A5F7:              LDA $1693               
CODE_02A5FA:              STA $0D                   
CODE_02A5FC:              PLA                       
CODE_02A5FD:              STA $1729,X    
CODE_02A600:              PLA                       
CODE_02A601:              STA $1715,X   
CODE_02A604:              PLA                       
CODE_02A605:              STA $1733,X      
CODE_02A608:              PLA                       
CODE_02A609:              STA $171f,X   
CODE_02A60C:              LDA $0E                   
CODE_02A60E:              CMP #$01                
Return02A610:             rts                       ; Return 


CODE_02A611:              LDA $0F                   
CODE_02A613:              INC A                     
CODE_02A614:              AND $5b     
CODE_02A616:              BEQ CODE_02A679           
CODE_02A618:              LDA $1715,X   
CODE_02A61B:              CLC                       
CODE_02A61C:              ADC #$08                
CODE_02A61E:              STA $98          
CODE_02A620:              AND #$F0                
CODE_02A622:              STA $00                   
CODE_02A624:              LDA $1729,X   
CODE_02A627:              ADC #$00                
CODE_02A629:              CMP $5d      
CODE_02A62B:              BCS CODE_02A677           
CODE_02A62D:              STA $03                   
CODE_02A62F:              STA $99          
CODE_02A631:              LDA $171f,X   
CODE_02A634:              CLC                       
CODE_02A635:              ADC #$04                
CODE_02A637:              STA $01                   
CODE_02A639:              STA $9a          
CODE_02A63B:              LDA $1733,X   
CODE_02A63E:              ADC #$00                
CODE_02A640:              CMP #$02                
CODE_02A642:              BCS CODE_02A677           
CODE_02A644:              STA $02                   
CODE_02A646:              STA $8b          
CODE_02A648:              LDA $01                   
CODE_02A64A:              LSR                       
CODE_02A64B:              LSR                       
CODE_02A64C:              LSR                       
CODE_02A64D:              LSR                       
CODE_02A64E:              ORA $00                   
CODE_02A650:              STA $00                   
CODE_02A652:              LDX $03                   
CODE_02A654:            LDA DATA_00BA80,X       
CODE_02A658:              LDY $0F                   
CODE_02A65A:              BEQ CODE_02A660           
CODE_02A65C:            LDA DATA_00BA8E,X       
CODE_02A660:              CLC                       
CODE_02A661:              ADC $00                   
CODE_02A663:              STA $05                   
CODE_02A665:            LDA DATA_00BABC,X       
CODE_02A669:              LDY $0F                   
CODE_02A66B:              BEQ CODE_02A671           
CODE_02A66D:            LDA DATA_00BACA,X       
CODE_02A671:              ADC $02                   
CODE_02A673:              STA $06                   
CODE_02A675:                 BRA CODE_02A6DB           

CODE_02A677:                    CLC                       
Return02A678:                   rts                      ; Return 

CODE_02A679:              LDA $1715,X   
CODE_02A67C:              CLC                       
CODE_02A67D:              ADC #$08                
CODE_02A67F:              STA $98          
CODE_02A681:              AND #$F0                
CODE_02A683:              STA $00                   
CODE_02A685:              LDA $1729,X   
CODE_02A688:              ADC #$00                
CODE_02A68A:              STA $02                   
CODE_02A68C:              STA $99          
CODE_02A68E:              LDA $00                   
CODE_02A690:              SEC                       
CODE_02A691:              SBC $1c    
CODE_02A693:              CMP #$F0                
CODE_02A695:              BCS CODE_02A677           
CODE_02A697:              LDA $171f,X   
CODE_02A69A:              CLC                       
CODE_02A69B:              ADC #$04                
CODE_02A69D:              STA $01                   
CODE_02A69F:              STA $9a          
CODE_02A6A1:              LDA $1733,X   
CODE_02A6A4:              ADC #$00                
CODE_02A6A6:              CMP $5d      
CODE_02A6A8:              BCS CODE_02A677           
CODE_02A6AA:              STA $03                   
CODE_02A6AC:              STA $8b          
CODE_02A6AE:              LDA $01                   
CODE_02A6B0:              LSR                       
CODE_02A6B1:              LSR                       
CODE_02A6B2:              LSR                       
CODE_02A6B3:              LSR                       
CODE_02A6B4:              ORA $00                   
CODE_02A6B6:              STA $00                   
CODE_02A6B8:              LDX $03                   
CODE_02A6BA:            LDA DATA_00BA60,X       
CODE_02A6BE:              LDY $0F                   
CODE_02A6C0:              BEQ CODE_02A6C6           
CODE_02A6C2:            LDA DATA_00BA70,X       
CODE_02A6C6:              CLC                       
CODE_02A6C7:              ADC $00                   
CODE_02A6C9:              STA $05                   
CODE_02A6CB:            LDA DATA_00BA9C,X       
CODE_02A6CF:              LDY $0F                   
CODE_02A6D1:              BEQ CODE_02A6D7           
CODE_02A6D3:            LDA DATA_00BAAC,X       
CODE_02A6D7:              ADC $02                   
CODE_02A6D9:              STA $06                   
CODE_02A6DB:              LDA #$7E                
CODE_02A6DD:              STA $07                   
CODE_02A6DF:              LDX $15E9               ; X = Sprite index 
CODE_02A6E2:              LDA [$05]                 
CODE_02A6E4:              STA $1693               
CODE_02A6E7:              INC $07                   
CODE_02A6E9:              LDA [$05]                 
CODE_02A6EB:            JSL $06F7A0         
CODE_02A6EF:              CMP #$00                
CODE_02A6F1:              BEQ CODE_02A729           
CODE_02A6F3:              LDA $1693               
CODE_02A6F6:              CMP #$11                
CODE_02A6F8:              BCC CODE_02A72B           
CODE_02A6FA:              CMP #$6E                
CODE_02A6FC:              BCC CODE_02A727           
CODE_02A6FE:              CMP #$D8                
CODE_02A700:              BCS CODE_02A735           
CODE_02A702:              LDY $9a          
CODE_02A704:              STY $0A                   
CODE_02A706:              LDY $98          
CODE_02A708:              STY $0C                   
CODE_02A70A:            JSL $00FA19         
CODE_02A70E:              LDA $00                   
CODE_02A710:              CMP #$0C                
CODE_02A712:              BCS CODE_02A718           
CODE_02A714:              CMP [$05],Y               
CODE_02A716:              BCC CODE_02A729           
CODE_02A718:              LDA [$05],Y               
CODE_02A71A:              STA $1694               
CODE_02A71D:              PHX                       
CODE_02A71E:              LDX $08                   
CODE_02A720:           LDA DATA_00E53D,X       
CODE_02A724:             PLX                       
CODE_02A725:             STA $0B                   
CODE_02A727:             SEC                       
Return02A728:            rts                       ; Return 

CODE_02A729:                    CLC                       
Return02A72A:                   rts                       ; Return 

CODE_02A72B:              LDA $98          
CODE_02A72D:              AND #$0F                
CODE_02A72F:              CMP #$06                
CODE_02A731:              BCS CODE_02A729           
CODE_02A733:              SEC                       
Return02A734:             rts                       ; Return 

CODE_02A735:              LDA $98          
CODE_02A737:              AND #$0F                
CODE_02A739:              CMP #$06                
CODE_02A73B:              BCS CODE_02A729           
CODE_02A73D:              LDA $1715,X   
CODE_02A740:              SEC                       
CODE_02A741:              SBC #$02                
CODE_02A743:              STA $1715,X   
CODE_02A746:              LDA $1729,X   
CODE_02A749:              SBC #$00                
CODE_02A74B:              STA $1729,X   
CODE_02A74E:              JMP CODE_02A611         


CODE_02B560:              LDA $173d,X   
CODE_02B563:              ASL                       
CODE_02B564:              ASL                       
CODE_02B565:              ASL                       
CODE_02B566:              ASL                       
CODE_02B567:              CLC                       
CODE_02B568:              ADC $1751,X             
CODE_02B56B:              STA $1751,X             
CODE_02B56E:              PHP                       
CODE_02B56F:              LDY #$00                
CODE_02B571:              LDA $173d,X   
CODE_02B574:              LSR                       
CODE_02B575:              LSR                       
CODE_02B576:              LSR                       
CODE_02B577:              LSR                       
CODE_02B578:              CMP #$08                
CODE_02B57A:              BCC CODE_02B57F           
CODE_02B57C:              ORA #$F0                
CODE_02B57E:              DEY                       
CODE_02B57F:              PLP                       
CODE_02B580:              ADC $1715,X   
CODE_02B583:              STA $1715,X   
CODE_02B586:              TYA                       
CODE_02B587:              ADC $1729,X   
CODE_02B58A:              STA $1729,X   
Return02B58D:             RTS                       ; Return 

SubHorzPosBnk2:           LDY #$00                
CODE_02848F:              LDA $94        
CODE_028491:              SEC                       
CODE_028492:              SBC $e4,X       
CODE_028494:              STA $0F                   
CODE_028496:              LDA $95    
CODE_028498:              SBC $14e0,X     
CODE_02849B:              BPL Return02849E          
CODE_02849D:              INY                       
Return02849E:             RTS    

					