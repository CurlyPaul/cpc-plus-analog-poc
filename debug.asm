BUILDSNA ; recommanded usage when using snapshot is to set it first
BANKSET 0 
ORG #8000 
RUN start ; entry point

start
im 1
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

include "main.asm"

include ".\libs\CPC_V3_SimplePalette.asm"
include ".\libs\CPC_SimpleScreenSetUp.asm"
