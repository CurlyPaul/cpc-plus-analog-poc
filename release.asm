BUILDCRT ; recommanded usage when using snapshot is to set it first
BANK 0 ; assembling in first 64K
ORG #0000 
RUN start ; entry point
start
di
im 1

ld bc,#f782			;; setup initial PPI port directions
out (c),c
ld bc,#f400			;; set initial PPI port A (AY)
out (c),c
ld bc,#f600			;; set initial PPI port C (AY direction)
out (c),c

ld bc,#7fc0			;; set initial RAM configuration
out (c),c

ld hl,end_crtc_data
ld bc,#bc0f
crtc_loop:
out (c),c
dec hl
ld a,(hl)
inc b
out (c),a
dec b
dec c
jp p,crtc_loop

ei
jr entrypoint

ORG #0038
ei
ret

entrypoint

include "main.asm"

; ; Sets the screen to 16 colour/160 wide mode
; ;	ld bc,#7F00+128+4+8+0
; ;	out (c),c

; ;call Screen_Init
; ld hl,ColourPalette
; call SetupColours

; Sync:
; 		ld b,#f5
;         in a,(c)
;         rra
;     jr nc,Sync + 2
; ;;	// TODO Something is amis here as the interupts keep switching off. There is some odd stuff in 0038
; 	breakpoint

; halt
; 	;; page-in asic registers to #4000-#7fff
; 	;ld bc,#7fb8
; 	;out (c),c
	
; 	;; Check for Y
; 	;ld hl,(#6809)	
	
; 	;; Check for X
; 	;ld hl,(#6809)

; 	;; Redraw sprite

; jr Sync

;include "main.asm"

crtc_data:
defb #3f, #28, #2e, #8e, #26, #00, #19, #1e, #00, #07, #00,#00,#30,#00,#c0,#00
end_crtc_data:

include ".\libs\CPC_V3_SimplePalette.asm"
include ".\libs\CPC_SimpleScreenSetUp.asm"