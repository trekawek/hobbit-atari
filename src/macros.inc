; =============================================================================
; Cross-Platform Macro Definitions for "Hobbit czyli w te i wewte..."
; Supports Commodore 64 (default) and Atari 800XL/XE (-d:TARGET_ATARI=1)
; =============================================================================

.ifndef TARGET_ATARI

; -----------------------------------------------------------------------------
; COMMODORE 64 CONFIGURATION (produces byte-exact original hobbit.prg)
; -----------------------------------------------------------------------------

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

; Bank in RAM under $A000-$BFFF and $C000-$FFFF (6510 port $01)
.macro RAMON
    sei
    lda $01
    sta port_save
    and #$f8
    sta $01
.endm

; Restore 6510 port $01 and re-enable interrupts
.macro ROMON
    lda port_save
    sta $01
    cli
.endm

; 16-bit pointer increment (matches original 7-byte sequence with abs high-byte inc)
.macro INCPTR zp
    inc :zp
    bne @+
    inc.w :zp+1
@
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

; Read byte from object table at (ZP_69),Y under BASIC ROM ($B000)
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

.else

; -----------------------------------------------------------------------------
; ATARI 800XL/XE CONFIGURATION (-d:TARGET_ATARI=1)
; -----------------------------------------------------------------------------

; Relocate zero-page pointers out of Atari OS zero page ($00-$7F) to $E0-$EB
ZP_61 = $e0
ZP_62 = $e1
ZP_69 = $e8
ZP_6A = $e9
ZP_6B = $ea
ZP_6C = $eb

.macro PROGRAM_HEADER
    opt h+
    org $0801
.endm

.macro PROGRAM_FOOTER
    icl "atari.inc"
    run boot_stage1
.endm

; Bank in RAM under $C000-$CFFF via PIA PORTB ($D301)
.macro RAMON
    jsr atari_ramon
.endm

; Restore Atari OS ROM at $C000-$FFFF via PIA PORTB ($D301)
.macro ROMON
    jsr atari_romon
.endm

; 16-bit pointer increment
.macro INCPTR zp
    inc :zp
    bne @+
    inc :zp+1
@
.endm

; Initialize Atari ANTIC 40x25 display list, custom font at $0800, and PORTB
.macro INIT_HARDWARE
    jsr atari_init_hardware
.endm

; Read byte from (ZP_69),Y in $B000-$CFFF RAM (banking out Atari OS ROM)
.macro BANK_READ_IMPL
    jsr atari_ramon
    lda (ZP_69),y
    jsr atari_romon
    cmp #$00
    rts
.endm

.macro CHROUT
    jsr atari_chrout
.endm

.macro CHROUT_JMP
    jmp atari_chrout
.endm

.macro GETIN
    jsr atari_getin
.endm

.macro GETCOL
    jsr atari_getcol
.endm

.macro CHRIN
    jsr atari_chrin
.endm

.macro SETLFS
    jsr atari_setlfs
.endm

.macro SETNAM
    jsr atari_setnam
.endm

.macro OPEN_CH
    jsr atari_open
.endm

.macro CLOSE_CH_JMP
    jmp atari_close
.endm

.macro CHKIN
    jsr atari_chkin
.endm

.macro CHKOUT
    jsr atari_chkout
.endm

.macro CLRCHN
    jsr atari_clrchn
.endm

.endif
