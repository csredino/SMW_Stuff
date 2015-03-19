need to expand the rom
need the rom and xkas in this directory to patch, (optional)
xkas needs to stay in the directory for later
need to patch it manually with Powerup.asm
make a patch.bat file which has the lines: xkas.exe Powerup.asm romname.smc @pause
need to add the graphics also

insert the generic power up sprite, remember the sprite number chosen, to do this the rom needs to be in the sprite tool folder and the generic power up sprite has to be in the sprite list
insert the generic power up block, the asm file needs to be edited to match the sprite number above, remember the hex addresses used for map 16 (all the power ups are done at once in order, so ten power ups takes ten blocks)
new block should be set to act like tile 129 in map 16
run powerup, this applies all the power ups simutaneously

other notes:
 enabling spin on chuck enables it on small mario, bad . . . 
 editing tile on chuck seems to effect other marios tiles too, bad, maybe avoidable if i only edit certain guys tiles, or maybe i can check them simultanously
maybe i should be making new power ups instead of editing old ones . . .
if changing the files, make sure they stay in the same powerup directory, otherwise it wont know where they are

ALSO at 4powertool, i inserted a hitbox flag reset right before the OUT routine, just search "OUT " with a space after to find it, flag is $87, set to #$0 for "normal"
