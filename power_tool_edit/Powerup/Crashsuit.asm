!Timer1 = $7Faa2d
!HDMATable = $7Fa600
!HDMATable2 = $a600
JMP CrashInit
jmp CrashMain
jmp CrashOut



RootList:

dw $00, $01, $04, $09, $10, $19, $24, $31, $40, $51, $64, $79, $90, $A*$A, $B*$B, $C*$C, $D*$D, $E*$E, $F*$F
dw $10*$10, $11*$11, $12*$12, $13*$13, $14*$14, $15*$15, $16*$16, $17*$17, $18*$18, $19*$19, $1a*$1a, $1b*$1b, $1c*$1c, $1d*$1d, $1e*$1e, $1f*$1f
dw $20*$20, $21*$21, $22*$22, $23*$23, $24*$24, $25*$25, $26*$26, $27*$27, $28*$28, $29*$29, $2a*$2a, $2b*$2b, $2c*$2c, $2d*$2d, $2e*$2e, $2f*$2f
dw $30*$30, $31*$31, $32*$32, $33*$33, $34*$34, $35*$35, $36*$36, $37*$37, $38*$38, $39*$39, $3a*$3a, $3b*$3b, $3c*$3c, $3d*$3d, $3e*$3e, $3f*$3f
dw $40*$40, $41*$41, $42*$42, $43*$43, $44*$44, $45*$45, $46*$46, $47*$47, $48*$48, $49*$49, $4a*$4a, $4b*$4b, $4c*$4c, $4d*$4d, $4e*$4e, $4f*$4f
dw $50*$50, $51*$51, $52*$52, $53*$53, $54*$54, $55*$55, $56*$56, $57*$57, $58*$58, $59*$59, $5a*$5a, $5b*$5b, $5c*$5c, $5d*$5d, $5e*$5e, $5f*$5f
dw $60*$60, $61*$61, $62*$62, $63*$63, $64*$64, $65*$65, $66*$66, $67*$67, $68*$68, $69*$69, $6a*$6a, $6b*$6b, $6c*$6c, $6d*$6d, $6e*$6e, $6f*$6f
dw $70*$70, $71*$71, $72*$72, $73*$73, $74*$74, $75*$75, $76*$76, $77*$77, $78*$78, $79*$79, $7a*$7a, $7b*$7b, $7c*$7c, $7d*$7d, $7e*$7e, $7f*$7f
dw $80*$80, $81*$81, $82*$82, $83*$83, $84*$84, $85*$85, $86*$86, $87*$87, $88*$88, $89*$89, $8a*$8a, $8b*$8b, $8c*$8c, $8d*$8d, $8e*$8e, $8f*$8f
dw $90*$90, $91*$91, $92*$92, $93*$93, $94*$94, $95*$95, $96*$96, $97*$97, $98*$98, $99*$99, $9a*$9a, $9b*$9b, $9c*$9c, $9d*$9d, $9e*$9e, $9f*$9f
dw $a0*$a0, $a1*$a1, $a2*$a2, $a3*$a3, $a4*$a4, $a5*$a5, $a6*$a6, $a7*$a7, $a8*$a8, $a9*$a9, $aa*$aa, $ab*$ab, $ac*$ac, $ad*$ad, $ae*$ae, $af*$af
dw $b0*$b0, $b1*$b1, $b2*$b2, $b3*$b3, $b4*$b4, $b5*$b5, $b6*$b6, $b7*$b7, $b8*$b8, $b9*$b9, $ba*$ba, $bb*$bb, $bc*$bc, $bd*$bd, $be*$be, $bf*$bf
CrashInit:
lda #$00
sta !Timer1
rtl
CrashMain:
lda !Timer1
bne DrawCircle
lda $15
and $17
and #$40
beq Return
lda #$01
sta !Timer1
lda #$0f
sta $18bd
sta $13e0
Return:
rtl

HDMAPointer:
db $FF
dw !HDMATable2
db $FF
dw !HDMATable2+$fe



SquareRoot:
phx
ldx #$FFFE
cmp #$FE01
BCS RootFix
RootLoop:
inx
inx
cmp RootList,x
bcs RootLoop
txa
lsr
dec
dec
plx
rts
RootFix:
lda #$00FF
rep #$10
plx
rts

Squared:
sta $4202
sta $4203
nop #4
rep #$20
lda $4216
rts

DrawNothing:
sep #$20
lda #$ff
sta !HDMATable,x
inx
lda #$00
sta !HDMATable,x
inx
iny
cpx #$0200
bcc DrawNothing
brl EndDraw


FixTop:
eor #$ffFF
tay
bra Drawloop
DrawCircle:
rep #$10
ldy #$0000
ldx #$0000
CleanLoop:
lda !Timer1
sta $00
stz $01
rep #$20
lda $80
clc
adc #$0008
sec
sbc $00
bmi FixTop
asl
sta $00
cpx $00
bcs Drawloop
sep #$20
lda #$ff
sta !HDMATable,x
inx
lda #$00
sta !HDMATable,x
inx
cpx #$0200
bcc CleanLoop
bra EndDraw
Drawloop:
sep #$20
tya
sec
sbc !Timer1
bpl $02
eor #$FF
jsr Squared
sta $00
sep #$20
lda !Timer1
jsr Squared
sec
sbc $00
beq DrawNothing
bmi DrawNothing
jsr SquareRoot
sep #$20
sta $00
lda $7E
clc
adc #$08
sec
sbc $00
bcs DontFixOver
lda #$00
DontFixOver:
sta !HDMATable,x
inx
lda $7E
clc
adc #$08
clc
adc $00
bcc DontFixOver2
lda #$ff
DontFixOver2:
sta !HDMATable,x
inx
iny
cpx #$0200
bcc Drawloop
EndDraw:
sep #$30
lda #$41
sta $4360
rep #$30
lda #HDMAPointer
sta $4362
sep #$30
phk
pla
sta $4364
lda #$7F
sta $4367
lda #$26
sta $4361
lda #$40
sta $0d9F
lda #$22
sta $44
lda #$22
sta $43
sta $41
lda #$01
sta $1497
sta $13fd
lda !Timer1
clc
adc #$04
cmp #$80
bcs EndCrash
sta !Timer1
rtl
EndCrash:
CODE_00FA8F:                 LDY #$0B                ; Loop over sprites: 
LvlEndSprLoopStrt:        LDA $14C8,Y             ; \ If sprite status < 8, 
CODE_00FA94:                CMP #$08                ;  | skip the current sprite 
CODE_00FA96:                BCC LvlEndNextSprite      ; / 
CODE_00FAA3:             LDA $009e,Y     ; \ Branch if goal tape 
CODE_00FAA6:                 CMP #$7B                ;  | 
CODE_00FAA8:                 BEQ LvlEndNextSprite           ; / 
CODE_00FAAA:              LDA $15a0,Y ; \ If sprite on screen... 
CODE_00FAAD:              ORA $186c,Y ;  | 
CODE_00FAB0:                BNE CODE_00FAC5           ;  | 
CODE_00FAB2:            LDA $1686,Y   ;  | ...and "don't turn into coin" not set, 
CODE_00FAB5:                AND #$20                ;  | 
CODE_00FAB7:               BNE LvlEndNextSprite           ;  | 
CODE_00FAB9:                LDA #$10                ;  | Set coin animation timer = #$10 
CODE_00FABB:           STA $1540,Y             ;  | 
CODE_00FABE:             LDA #$06                ;  | Sprite status = Level end, turn to coins 
CODE_00FAC0:           STA $14C8,Y             ;  | 
CODE_00FAC3:            BRA LvlEndNextSprite      ; / 

CODE_00FAC5:            LDA $190F,Y   ; \ If "don't erase" not set, 
CODE_00FAC8:           AND #$02                ;  | 
CODE_00FACA:              BNE LvlEndNextSprite      ;  | 
CODE_00FACC:             LDA #$00                ;  | Erase sprite 
CODE_00FACE:           STA $14C8,Y             ; / 
LvlEndNextSprite:           DEY                       ; \ Goto next sprite 
CODE_00FAD2:             BPL LvlEndSprLoopStrt     ; / 
CODE_00FAD4:             LDY #$07                ; \ 
CODE_00FAD6:               LDA #$00                ;  | Clear out all extended sprites 
CODE_00FAD8:          STA $170b,Y   ;  | 
CODE_00FADB:                   DEY                       ;  | 
CODE_00FADC:               BPL CODE_00FAD8           ; / 
Return00FADE:             
lda #$00
sta $2127
inc
sta $2126
lda #$02
sta $44
lda #$01
sta $19
stz $13fd
lda $0d9F
and #$bF
sta $0d9F
rtl
CrashOut:
lda #$00
sta $2127
inc
sta $2126
lda #$02
sta $44
stz $13fd
lda $0d9F
and #$bF
sta $0d9F
rtl


