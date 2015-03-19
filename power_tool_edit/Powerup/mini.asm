
rtl
nop #2
JMP MiniMain
rtl

MiniMain:
LDA #$1 
STA $87			;force hitbox to be small 
LDA $187A		;check for yoshi
CMP #$0
BNE Dismount    ;if mini is on yoshi then 
rtl

Dismount:
;LDA #$1
;STA $140D		;try dismounting by forcing spin jump, may not work because of the sprite that disables spin jump (who has priority?)
				;this seems to just make him "spin" when he does his normally allowed dismount in the air
;JSR $01ED9E		;try forcing dismount yoshi routine this causes a crash apparently
;JSL $00F5B7		;try dismounting by forcing mario to be hurt, 
				;this just kills him, maybe because of the way i setup the hurt lil mario routine (dies on hurt)
;STZ $187A		;try dismounting by changing the riding yoshi flag, may change the flag, but not actually cause the dismount
rtl

