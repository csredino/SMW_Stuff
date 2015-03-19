
header
lorom
namespace "global"

;
;
;
!FreeRAM = $7Fad40

!FreeSpace = $2d8000


!PalleteBank = !FreeRAM+6      	     ;the bank of the pallete pointer(the lower 16-bit are at $0D82)
!PreviousPowerup = !FreeRAM 	     ;the powerup Mario had last frame, used to track powerup change and run the the OUT routine of prevoius powerup
!IsDecompressing =  !FreeRAM+5 		 ;1 = isnt decompressing 0 = is decompressing
!BoxItemPower =  !FreeRAM+1    		 ;the powerup the item box content represent
!BoxBackup =  !FreeRAM+3   		     ;the item box content saved when changing players
!AbillityByte1 = !FreeRAM+7          ;\
!AbillityByte2 = !FreeRAM+8          ;/
!ExtensionTilesPointer = !FreeRAM+9  ;
!MarioTiles = !FreeRAM+17
!Extra16x16TilePointer = !FreeRAM+33
!ItemTileLowByte = !FreeRAM+38      ;size 3
!ItemTileHighByte = !FreeRAM+42     ;size 3
!ItemTileBank = !FreeRAM+46     ;size 3
!ItemTileIndex = !FreeRAM+50	;size 3

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Those defines are used to find the location of the value in the powerlist table;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
!AbillityByteTable = powerlist
!ASMPointer        = powerlist+2
!TilePointer       = powerlist+5
!ItemPointer       = powerlist+8
!AnimPointer       = powerlist+11
!MGFXList          = powerlist+14    
!LGFXList          = powerlist+16
!MPalletePointer   = powerlist+18
!LPalletePointer   = powerlist+21



;;;;;;;;;;;;;;;;;
;routine hijacks;
;;;;;;;;;;;;;;;;;
;16x16 interraction hijack
org $03B67C
jsl GetInterBit
;Can't slide hijack
org $00EEF8
jsl GetSlideBit
nop #2
;Can't duck hijack
org $00D600
jsl GetDuckBit
org $00EEF8
;Fireball and cape hijack
org $00d062
Jsl Getpowerbits
rts
nop
;Make the fireball and cape spin end with rtl, this make acessing them easier
org $00d080
rtl
org $00D0AD
rtl

;Hijack the give item box item routine
org $01C53b
jsl SetItem
bra $0D

org $01C548
nop #8


org $01C541
jsl givePowerup
rtl
org $01c546
jsl setMarioImage
rtl
nop #3



;Hijack the Item box pallete routine
org $00909A
jsl getExItemPal
bra freethisspot  
nop
org $0090a1
jsl getItemPalAndType
rtl
org $0090a6
jsl DynamicItem
rtl
freethisspot:
NoExItem:
;Hijack the item box graphic
org $0090BE
jsl UseExGraphic
nop #2

;Hijack the NMI to transfer the new GFX+pallete
org $0082B9
jml NMIHijack
nop

ORG $02806A
jsl SetExItem
nop #2

org $01C6DA
STA $0302,Y
LDX $15E9 
LDA #$00 

org $01C636
jml SetPalleteandTile

org $00A31A
JSL SetPalBank
nop

org $00E30c
and #$03
inc
inc
inc
inc
BRA CODE_00E31A
lda $19
;asl
nop #5
;clc
;adc $0DB3
CODE_00E31A:
sta $03
asl
clc
adc $03
nop #4;jsl GetPalPointer
nop

org $01C598
JSL GetCorrectPowerup
lda #$0D
STA $1DF9

org $01C5F7
JSL GetCorrectPowerup2

org $00CFEE
jsl fixRunningFrame
nop

org $E381
bra $02 ; fix powerup's ASM code not executing during the flashing invincibillity animation

org $00E3A4
jml UpdatePowerups
nop

org $008179
jml Save00 ;I can't believe I'm doing this...
nop        ;Why do SMW's NMI corrupt $00-$02?>_<

org $008357
nop
JML Load00

org	$00CF3F
jsl FixSpin

org $00C569
jsl FixAnimation
JSR $C593
LDA $16                   
AND #$20                
BEQ CODE_00C58F  

org $00C58F
CODE_00C58F:     
	

org $0081DA
jml CheckIfDecompressing

org $01C5A7
nop #4

org $01C561
lda #$01
sta $19

org $008A74
jsl ClearRAM

org $01A832
jml CheckInterractionBit
nop

org $029Faf
jml RunCustomExSprite

org $00A0E0
jsl BackupLuigiitem
nop #2

org $1C576

NOP #9

org $0491D5
						jsl GetBackLuigiItem
						nop #2

;------------------------------------
;fix for the mario image on the OW
;------------------------------------
;org $487e3
;						   db  $ee, $24, $eF, $24, $Ff, $24, $Fe
;org $487d3
;						   db  $ee, $24, $eF, $24, $Ff, $24, $Fe 
;org $48853
;						   db  $ee, $24, $eF, $24
;org $48863
;						   db  $ee, $24, $eF, $24
;---------------------------------------------------------------------
;Actual start of code
;---------------------------------------------------------------------
org !FreeSpace
		 db "POWER"
         db "STAR"
	 dw END-START, END-START~
START:
UpdateBytes:
						 lda $19
                         jsr GetTableLoc				;
                         lda !AbillityByteTable,x       ; |
						 sta !AbillityByte1             ; |
						 lda !AbillityByteTable+1,x     ; |load the bytes from the table into RAM
						 sta !AbillityByte2             ; |
						 sep #$10                       ; |
						 rts                            ;/
GetBackLuigiItem:
                         lda $0dbc,x                   ;\
						 stA $0DC2                     ; |
						 lda !BoxBackup,x              ; |transfer the current player's item box content from the backup
						 sta !BoxItemPower             ;/
						 phx                           ;\
                         jsr UpdateBytes               ; |Update the abillity bytes(since the powerups have been changed while switching players)
						 plx                           ;/
                         rtl						 
BackupLuigiitem:
CODE_00A0E0:             LDA $0DC2               
CODE_00A0E3:             STA $0DBC,X                    
                         lda !BoxItemPower				; |transfer the current player's item box content to the backup
						 sta !BoxBackup,x
						 rtl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Powerup's abillity bytes related coding;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Check bit for 16x16 interraction;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GetInterBit:
								ldx #$ff
								lda !AbillityByte1
								and #$20
								beq bigCol
								inx
bigCol:
								rtl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Check the can't slide/duck bit;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GetSlideBit:
								lda !AbillityByte1
								and #$80
								bne noSlide
								LDA $148F               
								ORA $13ED
								rtl
noSlide:
								lda #$00
								rtl

GetDuckBit:
								lda !AbillityByte1
								and #$80
								bne noDuck
								lda $15
								and #$04
								rtl
								noDuck:
								lda #$00
								rtl
									

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Run custom exsprite insted of the fireball if the bit is set;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RunCustomExSprite:

								phx
								php
								lda $19
								jsr GetTableLoc
								lda !AbillityByteTable+1,x                  ; |if the "use custom Exsprite" is used for current powerup
								bit #$08                              ; |
								bne IsACustomEx  
								plp                     ;/
								plx                                   ;\
								lda $9d                               ; |don't run exsprite if sprites are locked
								bne SpriteLocked                      ;/
								jml $029FB3
								SpriteLocked:
								jml $02A02C
								rtl
IsACustomEx:
								stz $01                               ;\
								lda $19
								jsr GetTableLoc
								rep #$20
								lda !ASMPointer,x                      ;\
								clc                                   ; |
								adc #$0009                            ; |load the ASM pointer and add 9 to it to get to the ExSprite routine
								sta $00                               ; |
								sep #$20                              ; |
								lda !ASMPointer+2,x                    ; |
								sta $02                               ;/
								plp
								plx
								JSL GotoPointer
								jml $02A041

DontRunInteraction:
								jml $01A837

CheckInterractionBit:
								LDA $167A,X                 ; \ Branch if sprite don't uses default Mario interaction 
								Bmi DontRunInteraction      ; / 
								LDA $14c8,X  
								cmp #$08                 
								bne RunInteraction
								lda !AbillityByte1       ;\
								bit #$10                 ; |If the "don't use normal sprite interraction" bit is set for this powerup, don't 
								bne DontRunInteraction   ;/
								RunInteraction:
								jml $01A83B

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	 
;Check if the cape effect to spin jump is enabled;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FixSpin:
								lda $14A6
								bne RunSpin
								lda !AbillityByte1
								sep #$10 
								bit #$08	
								eor #$08	
								php
								lda $76
								plp								  
								rtl
RunSpin:
								ldy #$02
								lda $76
								cpy #$02
								rtl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Backup $00-$02 during the begining of NMI;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Save00:
								rep #$20           
								lda $00
								pha
								lda $02
								pha
								lda $04
								pha
								sep #$20
								LDA $1DFB
								bne $04
								jml $00817E
								jml $008186
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Backup $00-$02 during the end of NMI;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Load00:
								lda #$81
								sta $4200
								rep #$20
								pla									; |										
								sta $04								; |												
								pla 								; |pull the scratch RAM to prevent it from being overwritten during NMI												
								sta $02								; |												
								pla 								; |												
								sta $00	
								sep #$20
								jml $0083fb

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;clear the used RAM when the game boot;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ClearRAM:
								jsl GetPalPointer
								lda #$01                   ;\
								sta !IsDecompressing       ; |
								lda #$00                   ; |
								sta !PalleteBank           ; |
								sta !PreviousPowerup       ; |
								sta !BoxItemPower          ; |Clear RAM used by various part of the code to prevent unexpected values
								sta !BoxBackup             ; |
								sta !BoxBackup+1           ; |
								sta !AbillityByte1         ; |
								sta !AbillityByte2         ; |
								lda #$FF
								sta !ItemTileIndex
								sta !ItemTileIndex+1
								sta !ItemTileIndex+2
								STA $7F837D 
								rtl                        ;/


DATA_00E2B2:                      db $10,$D4,$10,$E8

						  
MarioPalIndex:
    db $00, $40
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;decompression and animation codes;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
DecompressionTilemap:
;Dummy tilemap used loaded while decompressing	
								dw $FFFF      ;16x16 Tile 1
								dw $0001      ;Tile Y displacement
								dB $00, 00     ;Tile X displacement
								dw $0004      ;16x16 Tile 2
								dw $0011      ;Tile Y displacement
								dB $00, 00     ;Tile X displacement	
								dw $00e0      ;16x16 Tile 3
								dw $0001      ;Tile Y displacement
								dB $00, 00     ;Tile X displacement
								dw $ffff      ;16x16 Tile 4
								dw $0000      ;Tile Y displacement
								dB $00, 00     ;Tile X displacement
								dw $FFFF      ;8x8 Tile 1
								dw $0000      ;Tile Y displacement
								dB $00, 00     ;Tile X displacement
								dw $FFFF      ;8x8 Tile 2
								dw $0000      ;Tile Y displacement
								dB $00, 00     ;Tile X displacement
								dw $FFFF      ;8x8 Tile 3
								dw $0000      ;Tile Y displacement
								dB $00, 00     ;Tile X displacement
								dw $FFFF      ;8x8 Tile 4
								dw $0000      ;Tile Y displacement
								dB $00, 00     ;Tile X displacement

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Load a different Mario frame to start playing the animation next frame;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PrepareDecompression:
								lda $19
								jsr GetTableLoc
								LDA #$00              ;\
								STA $00               ; |
								LDA #$20              ; |
								STA $01               ; |Specifiy that the decompressed graphic will be stored at 7E2000
								LDA #$7E              ; |
								STA $02               ;/
								lda $100              ;\
								cmp #$14              ; |only peform animation during level
								bne Dontplayanim      ;/					  
								lda !AbillityByte2    ;\
								bit #$04              ; |
								beq Dontrdyanimpal    ; |only perform pallete animation if the "animate pallete" bit is set
								lda #$2f              ; |
								sta $149B             ; |
								Dontrdyanimpal:       ;/
								lda #$2f              ;\set the frame to do the animation to $2F
								sta $1496             ;/
								lda $0DB3
								beq dontUseLuigiGFX
								jmp UseLuigiGFX
								dontUseLuigiGFX:
								rep #$20
								lda !MGFXList,x
								PHX
								jsl DecompGFX
								WaitForAnimEnd:
								sep #$30
								lda $1496
								bne WaitForAnimEnd
								lda #$01
								sta !IsDecompressing
								REP #$30
								PLX
								jmp RetDecomp  
   
Dontplayanim:	
								lda $0DB3                  ;\
								bne UseLuigiGFX            ;/If the player is luigi, load the luigi GFX file
								rep #$20                   
								lda !MGFXList,x              ;load the GFX file to use
								PHX
								jsl DecompGFX	           ;perform the decompression
								sep #$30
								lda #$01                   ;\
								sta !IsDecompressing       ;/use to specify that the graphic have finished decompressing
								REP #$30
								PLX
								jmp RetDecomp              

UseLuigiGFX:
								rep #$30
								lda !LGFXList,x
								phx
								jsl DecompGFX	
								sep #$30
								lda #$01
								sta !IsDecompressing
								rep #$30
								plx
								jmp RetDecomp  
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Updating code for when changing powerup;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UpdatePowerups:
								lda #$00
								xba
								lda !IsDecompressing       ;\
								bne +
								jmp PrepareDecompression   ;/if the game should be decompressing, prepare for decompression
								+
								lda !PreviousPowerup       ;\
								cmp $19                    ; |if powerup state hasn't changed, don't start animation
								beq DontdeCompress         ;/
								jsl GetPalPointer
								lda !PreviousPowerup
								jsr GetTableLoc
								rep #$20
								lda !ASMPointer,x           ;\
								clc                        ; |
								adc #$0006                 ; |load the ASM pointer and add 6 to it to get the OUT routine
								sta $00                    ; |
								sep #$20                   ; |
								lda !ASMPointer+2,x         ; |
								sta $02                    ; |
								sep #$30                   ;/
								JSL GotoPointer            ;Run the OUT routine of previous powerup
								jsr UpdateBytes            ;Update the abillity bytes since powerup state have changed
								lda $19
								jsr GetTableLoc
								rep #$20
								lda !ASMPointer,x           ;\
								sta $00                    ; |
								sep #$20                   ; |
								lda !ASMPointer+2,x         ; |load the ASM pointer to get the locatation of the INIT routine
								sta $02                    ; |
								sep #$30                   ;/
								JSL GotoPointer            ;Run the INIT routine of aquired powerup
								rep #$20                   ;\
								lda #DecompressionTilemap  ; |load dummy tilemap to prevent glitched looking graphics if the frame was using a wacky tile placement
								sta $00                    ;/

								sep #$20                   
								phk
								pla
								sta $02
								stz $13E0
								lda #$00                     ;\
								sta !IsDecompressing         ;/trigger the decompression next frame
								lda $19                      ;\
								sta !PreviousPowerup         ;/Update !PreviousPowerup
								jmp RetPrepDecomp


DontdeCompress:
								  lda #$01                 ;\
								  sta !IsDecompressing     ;/disable decompression								  
								  lda $19                  ; |
								  jsr GetTableLoc
								  rep #$30
								  lda !ASMPointer,x         ;\
								  clc                      ; |
								  adc #$0003               ; |
								  sta $00                  ; |load the ASM pointer and add 3 to it to get the MAIN routine
								  sep #$20                 ; |
								  lda !ASMPointer+2,x       ; |
								  sta $02
                                  phx								  ;/
								  sep #$30				   ;push X since the rest of the code still need it to be $19*3		  
								  JSL GotoPointer          ;Run the current powerup MAIN routine
								  rep #$30
								  plx
;;;;;;;;;;;;;;;;;;;;;;;
;Tilemap related codes;				
;;;;;;;;;;;;;;;;;;;;;;;		
RetDecomp:      		  		  
								  sep #$20
								  LDA #$00
								  XBA
								  lda $1497
								  BEQ DrawTilemap
								  lsr
								  lsr
								  lsr
								  tay
								  lda $E292,y
								  and $1497
								  ORA $9D    ;| adding in sprites locked, and if mario is frozen.
								  ORA $13FB               ;|
								  bne DrawTilemap
								  SEP #$10
								  jml $00e45B	 
								  
  
								  
DrawTilemap:					  REP #$20
								  lda !TilePointer,x       ;\
								  sta $00                 ; |
								  sep #$20                ; |Load the tilemap pointer
								  lda !TilePointer+2,x     ; |
								  sta $02                 ;/
								  ldx #$0000              ;\
								  sep #$10                ; |        
RetPrepDecomp:                    LDA $64                   ;\ load mario properties?
CODE_00E3C2:                      LDX $13f9                 ;| if properties = 0, do not make A = A table plus the behind scenery flag
CODE_00E3C5:                      BEQ CODE_00E3CA           ;/
CODE_00E3C7:   				      LDA $E2B9,X       
CODE_00E3CA:         			  LDY $E2B2,X             ;\
CODE_00E3CD:                      LDX $76                 ;|
CODE_00E3CF:                      ORA $E18c,X             ;|
CODE_00E3D2:                      STA $0303,Y             ;|
CODE_00E3D5:                      STA $0307,Y             ;|
CODE_00E3D8:                      STA $030F,Y             ;|
CODE_00E3DB:                      STA $0313,Y             ;| Handling parts of Mario's OAM
                                  STA $0317,Y             ;|
CODE_00E3DE:                      STA $02FB,Y             ;|
CODE_00E3E1:                      STA $02FF,Y             ;/
CODE_00E3EC:                      STA $030B,Y     		  ;
								  sep #$20
								  lda !AbillityByte1
							      sep #$10 								  
                                  and #$04
								  lsr
								  lsr
								  and !IsDecompressing
CODE_00E3FF:                      Bne DrawWithCape	
								  lda #$00                ; |
                                  xba				      ;	|	  
                                  LDa $13e0				  ;	|		 
								  rep #$20                ; |
                                  asl #4                  ; |get pointer+(Frame*$30)
								  pha                     ; |
                                  clc                     ; |
								  adc $00				  ;	|		  
								  sta $00                 ; |
								  sep #$20
								  lda $02                 ; |
								  adc #$00                ; |
								  sta $02                 ;/
								  rep #$20
								  pla                     ; |
								  asl                     ; |
								  clc                     ;/
								  adc $00                 ;\
								  ora #$8000              ; |
								  sta $00                 ; |
                                  sep #$20	              ; |correct pointer in case there is a bank overflow
								  lda $02                 ; |
								  adc #$00                ; |
								  sta $02                 ;/
                                  ldx #$0e	
LoadTilesLoop:						  
								  JSr LoadTiles         ;|
								  bpl LoadTilesLoop
                                  jsr SetPointer
								  sep #$10
								  jml $00e45B	   

DrawWithCape:
  
                                  LDa $13e0				  ;	|
								  sta $4202
								  lda #$2a
								  sta $4203
								  rep #$20
								  lda [$00]
								  sta $07
								  lda #$0002
						    	  jsr addToPointer            ; |
                                  lda $4216               ; |get pointer+(Frame*$0C)
								  jsr addToPointer
								  lda $00
								  ora #$8000              ; |
								  sta $00                 ; |
                                 ldx #$0e
								 ldy #$00
LoadTilesLoop2:							 
								 JSR LoadTiles
								 cpx #$08
								 beq LoadCapeTile
								 cpx #$00
								 bpl LoadTilesLoop2
								 JSR SetPointer
								 sep #$10
								 jml $00e45B	 
								 
								 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Code used to load the cape image for cape-using tilemap;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


LoadCapeTile:
								 REP #$20
                                 lda $00
								 PHA
								 lda $07
								 sta $00
								 sep #$20
								 lda $13e0
								 phx
								 tax 
								 lda CapeTileTable,x
								 beq noneedFix
								 sta $13df
noneedFix:						 plx		 
								 lda $13df               
								 sta $4202           
								 lda #$06            
								 sta $4203        
								 nop #3
								 rep #$20
								 lda $4216
								 jsr addToPointer
								 JSR LoadTiles
								 rep #$20
								 PLA
								 sta $00
								 bra LoadTilesLoop2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Table to get the cape frames ascociated with some frames;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;						 
CapeTileTable: 
		db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$11
		db $12,$13,$14,$15,$00,$16,$00,$00,$00,$00,$00,$00,$00,$00,$16,$16
		db $00,$17,$18,$18,$00,$16,$00,$00,$00,$00,$0B,$0C,$0D,$0E,$0F,$10
		db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00								
								
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Routine used to get the position of the tile in the RAM from the tile number;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SetPointer:        
CODE_00F636:                      REP #$20                  ; Accum (16 bit) 
CODE_00F638:                      LDX #$00                
PointerLoop:                      lda !MarioTiles+10,x
								  asl #5
                                  clc
                                  adc #$2000
								  sta $0D85,x
								  adc #$0200
								  sta $0D8F,x
								  inx
								  inx
								  cpx #$06
								  bcc PointerLoop
                                  ldx #$00               
ExtensionPointerLoop:             lda !MarioTiles,x
								  asl #5
                                  clc
                                  adc #$2000
								  sta !ExtensionTilesPointer,x
								  inx
								  inx
								  cpx #$08
								  bcc ExtensionPointerLoop
								  lda !MarioTiles,x
								  asl #5
                                  clc
                                  adc #$2000								  
								  sta !Extra16x16TilePointer
								  adc #$0200
								  sta !Extra16x16TilePointer+2
								  sep #$20
CODE_00F699:                      LDA #$0A                
CODE_00F69B:                      STA $0D84								  
Return00F69E:                     RTS                       ; Return 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;increase pointer and handle bank crossing;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
addToPointer:
								  
                                  clc
								  adc $00
								  bpl movetonextbank
								  sta $00
								  rts
								  
movetonextbank:					  inc $02
								  ora #$8000
						          sta $00		
								  rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Tile in the OAM that will be used for each of Mario tile(the 4 8x8 tiles are fiest and the four 16x16 are after);
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MarioOAMTile:

dw  $0033, $0032, $0023, $0022, $0020, $0000, $0002, $0004

DontLoadTiles2:  
								rep #$20
								lda #$0002
								clc
								adc $00
								sta $00
DontLoadTiles3: 
								rep #$20
								lda #$0002
								clc
								adc $00
								sta $00
DontLoadTiles4: 
								rep #$20
								lda #$0002
								clc
								adc $00
								sta $00
								sep #$20
								stz $09
								jmp CODE_00E49F
								
IndexValue:

dw $000C, $0008, $0004, $0000, $001c, $0018, $0014, $0010					  

								
LoadTiles:                    
								  sep #$20
								  phx
								  LDX $13f9
								  LDa $E2B2,X
								  plx
								  clc
								  adc IndexValue,x
								  tay
                                  rep #$20								  
                                  LDA [$00]   
                                  cmp #$FFFF								  
                                  Beq DontLoadTiles2   
                                  sta !MarioTiles,x						          
								  lda #$0002	
								  jsr addToPointer
								  lda [$00]
								  and #$9FFF
								  bpl nofixmisbit
								  ora #$6000
nofixmisbit:					  sta $09
								  lda [$00]
								  sep #$20
								  xba
								  and #$60
								  asl
								  eor $02FB,Y 
								  sta $02FB,Y 
								  rep #$20
                                  LDA $80                   
                                  CLC                       
                                  ADC $09
                                  PHA                       
                                  CLC                       
                                  ADC #$0010              
                                  CMP #$0100              
                                  PLA                       
                                  SEP #$20                  ; Accum (8 bit) 
                                  BCS DontLoadTiles3         
                                  STA $02F9,Y 
			                      REP #$20                  ; Accum (16 bit) 								  
 				                  lda #$0002	
                                  clc
					              adc $00
						          sta $00
                                  lda $76
							      and #$0001
                                  bne GetflippedX								  
								  jsr writingXpos
                                  bra FinishwritingXpos
								  
writingXpos:
								  sep #$20
								  lda [$00]
								  bmi ReverseXdisplacement
								  rep #$20
								  LDA $7E 
								  sep #$20								  
                                  CLC                       
                                  ADC [$00]
								  STA $02F8,Y 
								  lda #$00
								  adc #$00
								  sta $09
								  rts
								  
ReverseXdisplacement:    
								  LDA $7E 
								  sep #$20								  
                                  CLC                       
                                  ADC [$00]
								  STA $02F8,Y 
								  lda #$00
								  sbc #$00
								  and #$01
								  sta $09
								  rts
GetflippedX:         

								  inc $00
								  jsr writingXpos
								  REP #$20
								  dec $00							  			  

FinishwritingXpos:                           
                                 
					              REP #$20                  ; Accum (16 bit) 								  
 			                      lda #$0002	
                                  clc
				                  adc $00
			                      sta $00	
  	                      		  SEP #$20        
			                      lda MarioOAMTile,x
                                  STA $02FA,Y								  
CODE_00E49F:                        
                                  lda $09								  
                                  cpx #$08								  
                                  bcc SmallTile								  
                                  ora #$02								  
SmallTile:                        phx
                                  pha
                                  tya
								  lsr
								  lsr
								  tax
								  pla
                                  STA $045E,X 
								  plx		
								  dex
								  dex
                                  RTS 




GetCorrectPowerup:
						lda $1594,X              ;\
						bne GetExpowerup         ; |
						lda #$02                 ; |if the "feather" is a custom powerup falling from the item box, give the custom powerup represented by said item
						sta $19                  ;/
						rtl
GetCorrectPowerup2:     
						lda $1594,X            ;\
						bne GetExpowerup       ; |
						lda #$03               ; |same as above, but for the fire flower
						sta $19                ; |
						rtl                    ;/

GetExpowerup:
						sta $19
						rtl


GetPalPointer:           
						lda $19
						jsr GetTableLoc
						lda $0db3
						bne useLuigiPal
						lda !MPalletePointer,x     ; |
						sta $0D82                ; |
						lda !MPalletePointer+1,x   ; |load the current powerup pallete pointer from the new table
						sta $0D83                ; |
						lda !MPalletePointer+2,x   ; |
						sta !PalleteBank         ; |
						sep #$10
						rtl                     ;/
						useLuigiPal:
						lda !LPalletePointer,x     ; |
						sta $0D82                ; |
						lda !LPalletePointer+1,x   ; |load the current powerup pallete pointer from the new table
						sta $0D83                ; |
						lda !LPalletePointer+2,x   ; |
						sta !PalleteBank         ; |
						sep #$10
						rtl                     ;/

SetPalBank:
						sep #$20                ;\
						lda $1490
						bne FlashAnim
						lda !PalleteBank        ; |
						sta $4324               ; |made the pallete DMA use the bank loaded from the table
						rep #$20                ; |
						rtl                     ;/

starPalTable:

						dw $b2c8, $b2dc, $b2f0, $b304
						FlashAnim:
						phx
						lda $14
						and #$0c
						lsr
						tax
						lda #$00
						sta $4324
						rep #$20
						lda starPalTable,x
						sta $4322
						plx
						rtl

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;this us to make the generic powerups items dynamics;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CusSpriteDyna:
					LDA $00                   ; \ Set tile x position 
					STA $0300,Y         ; / 
					LDA $01                   ; \ Set tile y position 
					DEC A                     ;  | 
					STA $0301,Y         ; / 

					phy
					lda $1594,x
					jsl DynamicItem
					phx
					tyx
					lda DynamicItemTilemap,x
					plx
					ply
					sta $0302,y
					lda $1594,x
					jsl getItemPalAndType
					and #$07
					asl
					ora $64
					STA $0303,Y          ; / Set property byte 
					LDA $157C,X     ; \ Flip flower/cape if 157C,x is set 
					beq noFlip8
					lda $303,y
					eor #$40
					sta $303,y
noFlip8:			
					jml $01C6DD



SetPalleteandTile:
						lda $1534,X
						bne ExItemPalTile
						LDA $1626,X
						bne CusSpriteDyna
						lda $9E,x
						cmp #$21
						beq CoinSprGfx
						cmp #$7F
						beq skipcheck
						cmp #$79
						bcs notanItem
skipcheck:				jml UseDynaGFX
						CoinSprGfx:
						jml $01C63C
notanItem:
						jml $01C6A3
ExItemPalTile:
						LDA $00                   ; \ Set tile x position 
						STA $300,Y         ; / 
						LDA $01                   ; \ Set tile y position 
						DEC A                     ;  | 
						STA $301,Y         ; / 
						LDA $157C,X     ; \ Flip flower/cape if 157C,x is set 
						sta $02
						lda $1594,X
						jsl getItemPalAndType
						and #$07
						asl
						ora #$30
						STA $303,Y          ; / Set property byte 
						lda $02
						beq noFlip6
						lda $303,y
						ora #$40
						sta $303,y
noFlip6: 			    lda #$C2
						STA $302,Y          ; / 
						jml $01C6DD



		 
AllowJSL:

						jsl $00b888
						inc $100
						rtl		 
		 
DecompGFX:		 
						cmp #$0032
						beq FixNormalGFX
						jml $0FF900             ;Decompression of GFX routine(lunar magic version)

FixNormalGFX:
						sep #$30
						phb
						LDA #$00
						PHA
						PLB
						PEA $84Cd
						JML $00b888

FixAnimation:

						rtl  
Getpowerbits:
						lda !AbillityByte1
						sep #$10
						bit #$01               ;Check for the cape spin bit
						beq NoFireball         ;\
						jsl $00D068              ; |If set, run the cape spin routine(the routine itself check if x or y is pressed) 
						NoFireball:            ;/
						bit #$02               ;Check for the fireball bit
						beq NoSpin
						jsl $00D085
NoSpin:

						rtl
GotoPointer:
						JMl [$0000]

ItemTable:
						db $01, $03, $00, $02, $00
ItemTable2:
						db $00, $04, $02, $03, $05


SetItem:										
						sta $00																				
						lda $1626,X										
						bne ExItem			
						lda $1534,X										
						bne ExItem							
						phx										
						lda $00										
						tax										
						lda ItemTable,x										
						beq NotARealOne			
						jsl givePowerup
						plx

						lda #$01			
						rtl
NotARealOne:										
						lda ItemTable2,x										
						plx										
						rtl										

ExItem:
						jsr checkAndGiveScore
						lda $1594,x
						jsl givePowerup							
						lda #$01								
						rtl										

checkAndGiveScore:
						lda $1534,x
						bne noScore
						lda $1594,x
						beq noScore				
						lda #$04
						JSL $02ACE5 ; give points
noScore:				rts


						
						
UseExGraphic:										
						lda !BoxItemPower				;\						
						bne UseExItemGFX				; |if the item box should be holding a powerup...						
						ldx $0DC2						; |				
						LDA $8DF9,X						; |				
						rtl								; |		
UseExItemGFX:					; |							
						lda #$C2						;/				
						rtl										



;----------------------------------------------------------------------------------------

VRAM8x8Pos:
dw $6330, $6320, $6230, $6220

VRAM16x16Pos:
dw $6200, $6300

VRAMItemPos:
dw $60E0, $6240, $6260

;;;;;;;;;;;;;;;;;;;;;;;;;;
;Code executed during NMI;
;;;;;;;;;;;;;;;;;;;;;;;;;
NMIHijack:							
						STA $420C	
						rep #$20                            ;\										
						pla									; |										
						sta $04								; |												
						pla 								; |pull the scratch RAM to prevent it from being overwritten during NMI												
						sta $02								; |												
						pla 								; |												
						sta $00	
						sep #$20							
						ldA #$80										
						sta $2115																								
						sep #$20							;\			
						lda #$18							; |			
						sta $4301							; |			
						lda #$01							; |			
						sta $4300							; |			
						lda #$7e							; |			
						sta $4304							; |			
						sep #$10							; |			
						rep #$20							; | 			
						ldx #$08							; |			
						MarioExtensionTilesLoop:			; |transfer the graphic for Mario's 8x8 tiles																	
						lda !ExtensionTilesPointer,x        ; |
						sta $4302							; |
						lda VRAM8x8Pos,x 					; |
						sta $2116							; |
						lda #$0020							; |
						sta $4305							; |
						ldy #$01							; |
						sty $420b							; |
						dex									; |
						dex									; |	
						bpl MarioExtensionTilesLoop         ;/
						ldx #$02							;\		
-						                         			; |
						lda !Extra16x16TilePointer,x		; |							
						sta $4302							; |		
						lda VRAM16x16Pos,x					; |				
						sta $2116							; |transfer the graphic for the added Mario's 16x16 tile		
						lda #$0040							; |		
						sta $4305							; |		
						ldy #$01							; |		
						sty $420b							; |		
						dex									; |
						dex									; |
						bpl -								;/ 
						sep #$30
						ldy #$00
						ldx #$00
						phb
						phk
						plb
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;loop to DMA items graphics(since all items are now dynamics;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
						SendItemLoop:
						phx                             
						lda !ItemTileIndex,x 	    
						tax							
						lda $14c8,x                    
						plx								
						cmp #$08
						beq NoNeedToerase
						lda #$FF
						sta !ItemTileIndex,x
						NoNeedToerase:
						lda !ItemTileIndex,x 	
						bmi SkipThisItem
						lda !ItemTileBank,x 	
						sta $4304
						lda !ItemTileLowByte,x      
						sta $4302			
						lda !ItemTileHighByte,x 	
						sta $4303			
						lda #$40							
						sta $4305	
						stz $4306	
						rep #$20
						lda VRAMItemPos,y								
						sta $2116	
						sep #$20					
						lda #$01								
						sta $420b							
						lda #$40							
						sta $4305
						stz $4306	
						rep #$20
						lda VRAMItemPos,y
						clc
						adc #$0100					
						sta $2116	
						sep #$20										
						lda #$01								
						sta $420b	

SkipThisItem:		
						inx
						iny
						iny
						cpx #$03
						bcc SendItemLoop

						plb	 							
						lda #$00                     ; |										
						sta !BoxItemPower+1          ; |Clean the RAM directly after the one used for the item box power to use it in 16-bit math
						rep #$10                     ;/          
						lda !BoxItemPower
						bne SpecialItem
						rep #$30
						jml $0082BE

SpecialItem:
						jsr GetTableLoc
						lda #$20
						sta $2116               ;\
						lda #$6c				; |
						sta $2117				; |
						lda !ItemPointer,x      ; |  
						sta $4302				; |
						lda !ItemPointer+1,x	; |
						sta $4303				; |
						lda !ItemPointer+2,x	; |
						sta $4304				; |
						lda #$40				; |
						sta $4305				; |load the pointer for the graphic used for the item box's powerup and DMA them to VRAM
						stz $4306				; |
						lda #$01				; |
						sta $420b				; |
						lda #$20				; |
						sta $2116				; |
						lda #$6D				; |
						sta $2117				; |
						lda #$40				; |
						sta $4305				; |
						stz $4306				; |
						lda #$01				; |
						sta $420b				; |
						rep #$30				; |
						jml $0082BE				;/

						
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;give a free dynamic item spot for an item, and delete the oldest one if there is none left;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SetExItem:
						STA $14D4,X
						lda #$00
						xba
						lda !BoxItemPower
						sta $1594,X
						lda #$01
						sta $1534,x
						phx
						jsr RemoveDuplicateItem
						rep #$30
						asl
						tax
						sep #$20
						lda !AbillityByteTable+1,x
						sep #$10
						plx
						and #$20
						beq fallLikeCape
						lda #$74
						sta $9E,x
						rtl
fallLikeCape:
						lda #$76
						sta $9E,x
						rtl
RemoveDuplicateItem:
						ldx #$0B
						RemoveLoop:
						lda $9E
						cmp #$75
						beq RemoveThisOne
						cmp #$77
						beq RemoveThisOne
						RemovecheckNext:
						dex
						bpl RemoveLoop
						rts

RemoveThisOne:

						lda $1534,x
						beq RemovecheckNext
						stz $14c8,x
						bra RemovecheckNext
PalList:

						dw $B2C8, $B2DC, $B2F0, $B304

PerformAnimation:
						lda $149b
						beq DontAnimPal
						dec
						beq RestorePal
						sta $149B
						and #$03
						asl
						tax
						rep #$20
						lda PalList,x
						sta $0D82
						sep #$20
						lda #$00
						sta !PalleteBank

DontAnimPal:
						rts
RestorePal:             						
						jsl GetPalPointer
						rts
DMANewMarioStuffs:  

						php
						REP #$20                  ; 16 bit A ; Accum (16 bit) 
                        SEP #$10
CODE_00A302:            LDX #$04                ; We're using DMA channel 2 
        
CODE_00A309:            LDY #$86                ; \ Set Address for CG-RAM Write to x86 
CODE_00A30B:            STY $2121               ; / ; Address for CG-RAM Write
CODE_00A30E:            LDA #$2200              
CODE_00A311:            STA $4320               ; Parameters for DMA Transfer
CODE_00A314:            LDA $0D82               ; \ Get location of palette from $0D82-$0D83 
CODE_00A317:            STA $4322               ; / ; A Address (Low Byte)
                        sep #$20
                        lda !PalleteBank
CODE_00A31C:            STa $4324               ; / ; A Address Bank
                        rep #$20
CODE_00A31F:            LDA #$0014              ; \ x14 bytes will be transferred 
CODE_00A322:            STA $4325               ; / ; Number Bytes to Transfer (Low Byte) (DMA)
CODE_00A325:            STX $420B               ; Transfer the colors ; Regular DMA Channel Enable
						lda #$6000
						sta $2116
						sep #$30
						ldx #$00
						lda $1496
						beq NoAnim
						lsr
						lsr
						sta $00
						ldA #$80
						sta $2115
						lda #$01
						sta $4320
						lda #$18
						sta $4321
						lda #$00
						xba
						lda $19
						jsr GetTableLoc
						sep #$20
						lda !AnimPointer,x
						sta $4322
						lda !AnimPointer+1,x
						sec
						sbc $00
						clc
						Adc #$0B
						ora #$80
						sta $4323
						lda !AnimPointer+2,x
						adc #$00
						sta $4324
						lda #$80
						sta $4325
						stz $4326
						lda #$04
						sta $420b
						lda #$61
						sta $2117
						lda #$00
						sta $2116
						lda #$80
						sta $4325
						stz $4326
						lda #$04
						sta $420b
						dec $1496
NoAnim:
						plp
CODE_00A328: 			rts

NormalUpdate:      
					jml $0081E7                 ;If not decompressing, do a normal DMA
					DecompUpdate:               ;\
					jsr PerformAnimation        ; |
					jsr DMANewMarioStuffs       ; |If decompressing, DMA new graphic to perform the animation
					jml $0081dE                 ;/
					CheckIfDecompressing:
					lda $10
					beq NormalUpdate
					lda !IsDecompressing
					beq DecompUpdate
					jml $0081DE
					BlankASM:
					rtl                      ;\
					nop #2                   ; |
					rtl                      ; |empty ASM code, mainly used as a pointer for default powerups
					nop #2                   ; |
					rtl                      ;/


;;;;;;;;;;;;;
;Minor fixes;
;;;;;;;;;;;;;

fixRunningFrame:
					lda !AbillityByte1         ;\
					and #$40				   ; |
					BEQ use3Frame              ; |
					ldy #$00                   ; |
					lda $DC78,y                ; |
					rtl                        ; |small fix for the running animation for powerup value above $03
					use3Frame:                 ; |
					ldy #$01                   ; |
					lda $DC78,y                ; |
					rtl                        ;/



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;subroutine to get the location of the powerup's table;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GetTableLoc:
					sta $4202
					lda #$18
					sta $4203
					rep #$30
					nop #2
					lda $4216
					tax
					sep #$20
					rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Use to make the normal items use dynamic GFX;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

itempowerlist:	db $01,$03,$00,$02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01


DynamicItemTilemap:  db $0e,$24,$26

flying1up:	
					lda #$04
					ORA $64
					STA $0303,Y  
					JMP isnota1up
UseDynaGFX:			        
					LDA $00                   ; \ Set tile x position 
					STA $0300,Y         ; / 
					LDA $01                   ; \ Set tile y position 
					DEC A                     ;  | 
					STA $0301,Y         ; / 
					LDA $157C,X     ; \ Flip flower/cape if 157C,x is set 
					sta $02                       ;  | 
					LDA $9e,X       ; \ Set powerup tile 
					cmp #$7F
					beq flying1up
					cmp #$79
					BCS notanPowerItem
					SEC                       ;  | 
					SBC #$74                ;  | 
					TAX                       ;  | X
					lda itempowerlist,x
					jsl getItemPalAndType
					and #$07
					asl
					ora $64
					STA $0303,Y          ; / Set property byte 
					lda $02
					beq noFlip7
					lda $303,y
					ora #$40
					sta $303,y
noFlip7:			

					cpx #$02
					beq isastar
					cpx #$04
					bne isnota1up
					lda #$0A
					ora $64
					STA $0303,Y 
					cpx #$0B
					bne isnota1up
					lda $02
					ora $64
					STA $0303,Y 
isnota1up:	
					phy
					lda itempowerlist,x
					LDX $15E9
					jsl DynamicItem
					phx
					tyx
					lda DynamicItemTilemap,x
					plx
					ply
					sta $0302,y
					jml $01C6DD
					
					
notanPowerItem:		jml $01C6A3

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;this is to make the star not use dynamic GFX;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
isastar: 
					lda #$48
					sta $0302,y
					lda $13
					and #$08
					lsr
					clc
					adc #$04
					ora $64
					STA $0303,Y          ; / Set property byte 
                    LDX $15E9
					jml $01C6DD

					


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;GivePowerup is used to give the powerup in A, it will be put in the box if needed (this also fix the issue where getting a mushroom could remove better powerup in the item box);
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
onlygivepower:
					pla
					sta $19	
					rtl

givePowerup:
					pha
					cmp #$00 
					beq poison
					cmp #$01
					beq mush
					cmp $19
					beq goinbox
					lda $19
					cmp #$02
					bcs noneedprevweak
					cmp #$00
					beq onlygivepower
					lda !BoxItemPower
					bne onlygivepower
noneedprevweak:		lda $19
					sta !BoxItemPower
					pla
					sta $19	
					jsl getItemPalAndType
					and #$18
					cmp #$10
					beq isafeather
					lda #$0A
					sta $1dF9
					lda #$02
					sta $0dc2			
RETURN_24:          RTl                     ;

goinbox:			pla
					sta !BoxItemPower
					jsl getItemPalAndType
					and #$18
					cmp #$10
					beq isafeather
					lda #$05
					sta $1dF9
					lda #$02
					sta $0dc2
					rtl
isafeather:				
					lda #$0D
					sta $1dF9	
					lda #$04
					sta $0dc2
					rtl
					
poison:				pla
					lda $19
					beq nohurtsound
					lda #$04
					sta $1Df9
nohurtsound:		jsl $00F5B7
					rtl

mush:				pla
					lda #$0A
					sta $1dF9
					lda $19
					bne nosmall
					lda #$01
					sta $19
					rtl
					
nosmall:			lda $0dc2
					bne RETURN_24
					lda #$01
					sta !BoxItemPower
					sta $0dc2
					rtl
setMarioImage:
					
					sta !MarioTiles,x
					rtl
;;;;;;;;;;;;;;;;;;;
;Dynamic item code;
;;;;;;;;;;;;;;;;;;;
DynamicItem:
					phx
					jsr GetTableLoc
					lda !ItemPointer,x
					sta $00
					lda !ItemPointer+1,x
					sta $01
					lda !ItemPointer+2,x
					sta $02
					pla 
					sta $03
					sep #$10
					ldx #$00
RetakeSpotLoop:		lda !ItemTileIndex,x
					cmp $03
					beq WriteItemTile
					inx
					cpx #$03
					bcc RetakeSpotLoop
					ldx #$00
GetFreeSpotLoop:	
					lda !ItemTileIndex,x
					bmi WriteItemTile
					inx
					cpx #$03
					bcc GetFreeSpotLoop
					lda !ItemTileIndex
					tax 
					stz $14c8,x
					ldx #$00
bufferloop:		    lda !ItemTileLowByte+1,x
					sta !ItemTileLowByte,x
					lda !ItemTileHighByte+1,x
					sta !ItemTileHighByte,x
					lda !ItemTileBank+1,x
					sta !ItemTileBank,x
					lda !ItemTileIndex+1,x
					sta !ItemTileIndex,x
					inx
					cpx #$03
					bcc bufferloop
					ldx #$02
WriteItemTile:     	lda $00
					sta !ItemTileLowByte,x
					lda $01
					sta !ItemTileHighByte,x
					lda $02
					sta !ItemTileBank,x
					lda $03
					sta !ItemTileIndex,x
					txy
					tax
					rtl
					
					
getExItemPal:		
					lda !BoxItemPower
					beq notexitem
					jsl getItemPalAndType
					and #$07
					asl
					sta $00
notexitem:          rtl					


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;fonction that take the powerup in A and return the type and pallete in the 000ttppp format;
;t= type of item									p= item pallete						   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getItemPalAndType:	phx
					php
					jsr GetTableLoc
					lda !AbillityByteTable+1,x
					and #$70
					lsr
					lsr
					lsr
					lsr
					sta $00
					lda !AbillityByteTable+1,x
					and #$03
					asl
					asl
					asl
					ora $00
					plp
					plx
					rtl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;this table is used to store the powerups setting in Powerlist.asm;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
powerlist:
incsrc Powerlist.asm
incsrc Filelist.asm

END: