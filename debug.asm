BUILDSNA ; recommanded usage when using snapshot is to set it first
BANKSET 0 
ORG #0000 
RUN start ; entry point

start
di
im 1
jr entrypoint

ORG #0038           ;; Another change from the og code, as ld (#0038), hl won't work with the rom in the way
ei
ret

entrypoint
ei
include "main.asm"

include ".\libs\CPC_V3_SimplePalette.asm"
include ".\libs\CPC_SimpleScreenSetUp.asm"
