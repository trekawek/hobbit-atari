; =============================================================================
; Commodore 64 Platform Definitions for "Hobbit czyli w te i wewte..."
; Produces a byte-exact build of the original 1988 C64 release (hobbit.prg)
; =============================================================================

; Zero-page pointers used by the game engine and Polish parser
ZP_61 = $61
ZP_62 = $62
ZP_69 = $69
ZP_6A = $6a
ZP_6B = $6b
ZP_6C = $6c

.macro PROGRAM_HEADER
    opt h-
    org $07ff
    dta a($0801)
.endm

.macro PROGRAM_FOOTER
.endm

; Bank in RAM under $A000-$BFFF and $C000-$FFFF (6510 CPU port $01)
.macro RAMON
    sei
    lda $01
    sta port_save
    and #$f8
    sta $01
.endm

; Restore 6510 CPU port $01 and re-enable interrupts
.macro ROMON
    lda port_save
    sta $01
    cli
.endm

; 16-bit pointer increment (matches original 7-byte sequence with abs high-byte inc)
.macro INCPTR zp
    inc :zp
    bne skip
    inc.w :zp+1
skip
.endm

; Initialize VIC-II colors and custom character generator at $0800
.macro INIT_HARDWARE
    lda #$00
    sta $d020
    sta $d021
    lda #$9e
    jsr $ffd2
    lda $d018
    and #$e0
    lda #$12
    sta $d018
.endm

; Read byte from (ZP_69),Y in banked RAM under BASIC/KERNAL ROM ($B000-$CFFF)
.macro BANK_READ_IMPL
    sei
    lda $01
    pha
    lda #$00
    sta $01
    lda (ZP_69),y
    tax
    pla
    sta $01
    txa
    cli
    rts
.endm

; C64 KERNAL I/O Calls
.macro CHROUT
    jsr $ffd2
.endm

.macro CHROUT_JMP
    jmp $ffd2
.endm

.macro GETIN
    jsr $ffe4
.endm

.macro GETCOL
    jsr $fff0
.endm

.macro CHRIN
    jsr $ffcf
.endm

.macro SETLFS
    jsr $ffba
.endm

.macro SETNAM
    jsr $ffbd
.endm

.macro OPEN_CH
    jsr $ffc0
.endm

.macro CLOSE_CH_JMP
    jmp $ffc3
.endm

.macro CHKIN
    jsr $ffc6
.endm

.macro CHKOUT
    jsr $ffc9
.endm

.macro CLRCHN
    jsr $ffcc
.endm
