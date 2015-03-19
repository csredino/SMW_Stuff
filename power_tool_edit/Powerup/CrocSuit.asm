

rtl
nop #2
jmp ChuckMain
rtl



				
ChuckMain:	
					lda $13E3
					cmp #$00
					bne NotSpinning
                    lda $13E4
                    cmp #$70
					bcc NotSpinning
		        	CODE_00D076:              LDA #$12                ;\
					CODE_00D078:              STA $14A6               ;/ make mario spin
					CODE_00D07B:              LDA #$04                ; \ Play sound effect 
					CODE_00D07D:              STA $1DFC               ; / 					
NotSpinning:  					
rtl