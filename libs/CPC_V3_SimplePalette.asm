;;********************************************************************************************
;; Originally based an example at http://www.cpcwiki.eu/index.php/Programming An_example_loader
;;********************************************************************************************

Black equ #54			;; FMC 00
Blue equ #44			;; FMC 01
BrightBlue equ #55		;; FMC 02
Red equ #5C				;; FMC 03
Magenta equ #58			;; FMC 04
Mauve	equ #5D			;; FMC 05
BrightRed equ #4C		;; FMC 06

BrightMagenta equ #4d	;; FMC 08
Green equ #56			;; FMC 09
Cyan equ #46			;; FMC 10
Yellow equ #5e			;; FMC 12
White equ #40			;; FMC 13
Orange equ #4e			;; FMC 15
Pink equ #47			;; FMC 16
PastelMagenta equ #4f	;; FMC 17
SeaGreen equ #42		;; FMC 19

BrightYellow equ #4a	;; FMC 24
PastelYellow equ #43	;; FMC 25
BrightWhite equ #4B		;; FMC 26


ColourPalette: 
defb BrightWhite		;; #0  
defb Blue	 			;; #1 
defb BrightWhite 		;; #2  
defb BrightWhite		;; #3 
defb BrightWhite 		;; #4 
defb BrightWhite	 	;; #5
defb BrightWhite 		;; #6
defb BrightWhite 		;; #7 
defb BrightWhite 		;; #8 
defb BrightWhite 		;; #9 
defb BrightWhite 		;; #10
defb BrightWhite 		;; #11
defb BrightWhite 		;; #12
defb BrightWhite 		;; #12
defb BrightWhite 		;; #13
defb BrightWhite 		;; #14 
defb BrightWhite 		;; #15 
defb BrightWhite		;; Border

Palette_Init:
	ld hl,ColourPalette
	call SetupColours
ret

Palette_All:
	;; INPUTS
	;; D = HW Colour 
	ld b,17			;; 16 colours + 1 border
	xor a			;; start with pen 0
.doColours:
	push bc			
		ld bc,#7F00
     	out (c),a	;; PENR:#7F{pp} - where pp is the palette/pen number 
		out (c),e	;; INKR:#7F{hc} - where hc is the hardware colour number
	pop bc
	inc a			;; increment pen number
	djnz .doColours
ret

SetupColours:
	;; Inputs: HL Address the palette values are stored
	ld b,17			;; 16 colours + 1 border
	xor a			;; start with pen 0

DoColours:
	push bc			;; need to stash b as we are using it for our loop and need it
				;; below to write to the port 		
		ld e,(hl)	;; read the value of the colour we want into e
		inc hl          ;; move along ready for next time

		ld bc,#7F00
     	out (c),a	;; PENR:#7F{pp} - where pp is the palette/pen number 
		out (c),e	;; INKR:#7F{hc} - where hc is the hardware colour number
	pop bc
	inc a			;; increment pen number
	djnz DoColours
ret