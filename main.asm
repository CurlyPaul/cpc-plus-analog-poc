;call Screen_Init
ld hl,ColourPalette
call SetupColours

;;--------------------------------------------------
;; STEP 1 - Unlock CPC+ additional features
;; unlock asic to gain access to asic registers

di
ld b,#bc
ld hl,sequence
ld e,17
seq 
ld a,(hl)
out (c),a
inc hl
dec e
jr nz,seq
ei

	;;--------------------------------------------------
	;; STEP 2 - Setup sprite pixel data
	;;
	;; The ASIC has internal "RAM" used to store the sprite pixel
	;; data. If you want to change the pixel data for a sprite
	;; then you need to copy new data into the internal "RAM".
di
	;; page-in asic registers to #4000-#7fff
	ld bc,#7fb8
	out (c),c

	;; stored sprite pixel data
	ld hl,PlumbusPlus

	;; address of sprite 0 pixel data
	;; sprite 0 pixel data is in the range #4000-#4100
	ld de,#4000

	;; length of pixel data for a single sprite (16x16 = 256)
	ld bc,#100
	ldir

	ld hl,PlumbusBottom
	ld de,#4100
	ld bc,#100
	ldir

	;;--------------------------------------------------
	;; STEP 3 - Setup sprite palette
	;;
	;; The sprites use a single 15 entry sprite palette.
	;; pen 0 is ALWAYS transparent.
	;;
	;; The sprite palette is different to the screen palette.

	;; copy colours into ASIC sprite palette registers
	ld hl,sprite_colours
	ld de,#6422
	ld bc,15*2
	ldir

	;;--------------------------------------------------
	;; STEP 4 - Setup sprite properties
	;;
	;; Each sprite has properties which define the x,y coordinates 
	;; and x,y magnification.

	;; page-in asic registers to #4000-#7fff
	ld bc,#7fb8
	out (c),c

	;; set x coordinate for sprite 0
	ld hl,310
	ld (#6000),hl

	;; set y coordinate for sprite 0
	ld hl,100-32
	ld (#6002),hl

	ld hl,310
	ld (#6008),hl
	ld hl,100
	ld (#600a),hl

	;; set sprite x and y magnification
	;; x magnification = 1
	;; y magnification = 1
	ld a,10
	ld (#6004),a

	ld a,10
	ld (#600c),a

	; ;; page-out asic registers
	ld bc,#7fa0
	out (c),c
ei

Sync:
		ld b,#f5
        in a,(c)
        rra
    jr nc,Sync + 2
	
	;; page-in asic registers to #4000-#7fff
	;ld bc,#7fb8
	;out (c),c
	
	;; Check for Y
	;ld hl,(#6809)	
	
	;; Check for X
	;ld hl,(#6809)

	;; Redraw sprite

jr Sync

;;--------------------------------------------------
;; - there is two bytes per colour.
;; - these are stored in a form that can be written direct 
;; to the CPC+ colour palette registers (i.e. xGRB)
;; - pen 0 is always transparent and doesn't have a entry
;; in the CPC+ palette

sprite_colours
defw #000
defw #CEB
defw #9E9
defw #EFD
defw #DF0
defw #FA0
defw #F50
defw #0E0
defw #F09
defw #F0F
defw #A0F
defw #20F
defw #05F
defw #0AF
defw #FFF

;;---------------------------------------------
;; - there is one pixel per byte (bits 3..0 of each byte define the palette index for this pixel)
;; - these bytes are stored in a form that can be written direct to the ASIC
;; sprite pixel data
PlumbusPlus
defb #00,#00,#00,#00,#00,#00,#00,#00,#01,#01,#01,#01,#00,#00,#00,#00; line 0
defb #00,#00,#00,#00,#00,#01,#01,#01,#03,#03,#04,#03,#01,#00,#00,#00; line 1
defb #00,#00,#00,#00,#01,#03,#03,#03,#03,#01,#01,#03,#03,#01,#01,#00; line 2
defb #00,#00,#00,#01,#03,#03,#03,#01,#03,#03,#03,#01,#03,#03,#04,#01; line 3
defb #00,#00,#00,#01,#03,#03,#04,#04,#01,#03,#03,#01,#03,#03,#04,#01; line 4
defb #00,#00,#00,#01,#03,#03,#03,#03,#03,#03,#01,#03,#04,#03,#03,#01; line 5
defb #00,#00,#00,#01,#03,#03,#03,#03,#03,#01,#01,#01,#01,#03,#01,#01; line 6
defb #00,#00,#00,#01,#01,#03,#03,#03,#03,#03,#03,#03,#01,#03,#03,#01; line 7
defb #00,#00,#00,#01,#03,#03,#03,#03,#03,#03,#03,#03,#01,#03,#03,#01; line 8
defb #00,#00,#00,#01,#03,#03,#03,#03,#03,#01,#03,#03,#01,#03,#03,#01; line 9
defb #00,#00,#00,#00,#01,#03,#03,#03,#03,#03,#01,#01,#03,#03,#01,#00; line 10
defb #00,#00,#00,#00,#00,#01,#03,#04,#01,#03,#03,#03,#03,#01,#00,#00; line 11
defb #00,#00,#00,#00,#00,#00,#01,#01,#01,#01,#01,#01,#01,#00,#00,#00; line 12
defb #00,#00,#00,#00,#00,#00,#00,#01,#02,#02,#04,#01,#00,#00,#00,#00; line 13
defb #00,#00,#00,#00,#00,#00,#00,#01,#02,#02,#04,#01,#00,#00,#00,#00; line 14
defb #00,#00,#00,#00,#00,#00,#00,#01,#02,#02,#04,#01,#00,#00,#00,#00; line 15

PlumbusBottom
defb #00,#00,#00,#00,#01,#01,#01,#03,#03,#03,#02,#01,#01,#00,#00,#00; line 0
defb #00,#00,#00,#01,#01,#03,#03,#03,#03,#02,#02,#02,#04,#01,#00,#00; line 1
defb #00,#00,#01,#01,#03,#03,#03,#03,#02,#02,#02,#02,#02,#04,#01,#00; line 2
defb #00,#01,#01,#03,#03,#03,#03,#02,#02,#02,#02,#02,#02,#02,#01,#00; line 3
defb #00,#01,#03,#03,#03,#03,#03,#02,#02,#02,#02,#02,#01,#02,#02,#01; line 4
defb #00,#01,#03,#03,#03,#03,#02,#02,#02,#01,#02,#02,#02,#01,#02,#01; line 5
defb #01,#03,#03,#03,#03,#03,#02,#02,#02,#01,#01,#02,#02,#01,#02,#01; line 6
defb #01,#03,#03,#03,#03,#02,#02,#02,#02,#02,#01,#02,#02,#01,#02,#01; line 7
defb #01,#03,#03,#03,#03,#02,#02,#02,#02,#02,#01,#02,#02,#01,#02,#01; line 8
defb #01,#03,#03,#03,#03,#02,#02,#02,#02,#02,#02,#01,#02,#01,#02,#01; line 9
defb #01,#03,#03,#03,#03,#02,#02,#02,#02,#02,#01,#02,#02,#01,#02,#01; line 10
defb #01,#03,#03,#03,#03,#03,#02,#02,#02,#02,#01,#02,#01,#02,#02,#01; line 11
defb #00,#01,#03,#03,#03,#03,#02,#02,#02,#02,#01,#01,#01,#02,#01,#00; line 12
defb #00,#00,#01,#03,#03,#03,#03,#02,#02,#02,#02,#02,#02,#02,#01,#00; line 13
defb #00,#00,#00,#01,#03,#03,#03,#02,#02,#02,#02,#02,#02,#01,#00,#00; line 14
defb #00,#00,#00,#00,#01,#01,#01,#01,#01,#01,#01,#01,#01,#00,#00,#00; line 15

sequence
defb #ff,#00,#ff,#77,#b3,#51,#a8,#d4,#62,#39,#9c,#46,#2b,#15,#8a,#cd,#ee