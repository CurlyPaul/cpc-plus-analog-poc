;;*****************************************************************************************
;; Cart architecture based on example at https://cpctech.cpc-live.com/source/cart.html 
;; With a few modifications as it didn't initially work for me
;;****************************************************************************************
BUILDCRT 
BANK 0 
ORG #0000

di
im 1
ld sp,#BFFF         ;; this is missing from the og version and caused much confusion
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

ORG #0038           ;; Another change from the og code, as ld (#0038), hl won't work with the rom in the way
ei
ret

entrypoint

include "main.asm"

;; Currently set to normal mode 0
crtc_data:
defb #3f, #28, #2e, #8e, #26, #00, #19, #1e, #00, #07, #00,#00,#30,#00,#c0,#00
end_crtc_data:

include ".\libs\CPC_V3_SimplePalette.asm"
include ".\libs\CPC_SimpleScreenSetUp.asm"