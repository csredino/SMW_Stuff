!FlyTimer = $7Faa2A
!IsFlying = $7FAa2B

JMP BeeInit
jmp BeeMain
rtl
BeeInit:
lda #$30
sta !FlyTimer
lda #$00
sta !IsFlying
rtl
loseSuit:
lda $100
cmp #$14
bne BeeInit
lda #$01
sta $19
rtl
BeeMain:
lda $75
bne loseSuit
lda $77
and #$04
bne ground
CODE_00D06C:                 LDA $73         ;\
CODE_00D06E:              ORA $187a         ;| if mario is ducking, on yoshi, or spinjumping, 
CODE_00D071:              ORA $140d      ;|return
bne ground
lda !IsFlying
bne falling
lda $7D
bpl falling
rtl

ground:
lda #$30
sta !FlyTimer
lda #$00
sta !IsFlying
rtl
flyframes:

db $24,$2a

dashflyframes:

db $0C,$2B

falling:

lda $15
bpl noFly
lda !FlyTimer
beq noFly
lda !FlyTimer
dec
sta !FlyTimer
lda #$f4
sta $7D
lda #$01
sta !IsFlying
lda $13
and #$04
lsr
lsr
tax
lda $13E4
cmp #$70
bcs useDashFrames
lda flyframes,x
sta $13e0
noFly: 
rtl
useDashFrames:
lda dashflyframes,x
sta $13e0
rtl