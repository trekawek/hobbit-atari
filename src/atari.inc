; =============================================================================
; Atari 800XL/XE Platform Definitions & Compatibility Layer
; for "Hobbit czyli w te i wewte..."
;
; Contains all Atari zero-page mappings, cross-platform macros, ANTIC 40x25
; display list using the original C64 Polish 8x8 font at $0800-$0BFF, PIA PORTB
; ($D301) RAM banking at $C000-$CFFF, PETSCII screen editor emulation, POKEY
; Polish keyboard translation, and CIO + in-memory fallback save/load.
; =============================================================================

; Relocate zero-page pointers out of Atari OS zero page ($00-$7F) to $E0-$EB
ZP_61 = $e0
ZP_62 = $e1
ZP_69 = $e8
ZP_6A = $e9
ZP_6B = $ea
ZP_6C = $eb

scr_ptr_lo      = $e2
scr_ptr_hi      = $e3
io_ram_ptr_lo   = $e4
io_ram_ptr_hi   = $e5

atari_screen    = $bc00         ; 40x25 screen RAM ($BC00-$BFE7, 1000 bytes)
save_ram_buf    = $a800         ; In-memory savegame fallback buffer ($A800-$A9FF)

; Atari OS / Hardware Registers
ATARI_SDLSTL    = $0230
ATARI_SDLSTH    = $0231
ATARI_COLOR1    = $02c5
ATARI_COLOR2    = $02c6
ATARI_COLOR4    = $02c8
ATARI_CHBAS     = $02f4
ATARI_CH        = $02fc
ATARI_IOCB1     = $0310
ATARI_ICCOM     = $0312
ATARI_ICBAL     = $0314
ATARI_ICBAH     = $0315
ATARI_ICBLL     = $0318
ATARI_ICBLH     = $0319
ATARI_ICAX1     = $031a
ATARI_ICAX2     = $031b
ATARI_COLPF1    = $d017
ATARI_COLPF2    = $d018
ATARI_COLBK     = $d01a
ATARI_PORTB     = $d301
ATARI_DLISTL    = $d402
ATARI_DLISTH    = $d403
ATARI_CHBASE    = $d409
ATARI_WSYNC     = $d40a
ATARI_NMIEN     = $d40e
ATARI_CIOV      = $e456

; -----------------------------------------------------------------------------
; Atari Platform Macros
; -----------------------------------------------------------------------------

.macro PROGRAM_HEADER
    opt h+
    org $0801
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
    bne skip
    inc :zp+1
skip
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

; -----------------------------------------------------------------------------
; Atari Runtime Implementation (emitted at end of binary via PROGRAM_FOOTER)
; -----------------------------------------------------------------------------
.macro PROGRAM_FOOTER

    ; ANTIC Display List: 25 rows x 40 columns of Mode 2 text at $BC00-$BFE7
    ; (Align so Display List never crosses a 1 KB boundary)
    .align $0100
atari_dlist:
    dta $70, $70, $30           ; 24 blank scanlines
    dta $42, a(atari_screen)    ; Row 0: ANTIC Mode 2 + LMS $BC00
    :+24 dta $02                ; Rows 1..24: 24 rows of ANTIC Mode 2
    dta $41, a(atari_dlist)     ; JVB back to atari_dlist

; Hardware Initialization (replaces C64 VIC-II setup at $4C72)
.def :atari_init_hardware
    ; Ensure BASIC ROM ($A000-$BFFF) and Self-Test ($5000-$57FF) are disabled,
    ; and OS ROM ($C000-$FFFF) is enabled
    lda ATARI_PORTB
    ora #$83
    sta ATARI_PORTB
    sta port_save

    ; Install safe RTI handler in RAM under $FFF0/$FFFA/$FFFE
    jsr atari_ramon
    lda #$40                    ; RTI opcode
    sta $fff0
    lda #$f0
    sta $fffa
    sta $fffc
    sta $fffe
    lda #$ff
    sta $fffb
    sta $fffd
    sta $ffff
    jsr atari_romon

    ; Configure colors: black background/border ($00), bright text ($0E)
    lda #$00
    sta ATARI_COLOR2
    sta ATARI_COLOR4
    sta ATARI_COLPF2
    sta ATARI_COLBK
    lda #$0e
    sta ATARI_COLOR1
    sta ATARI_COLPF1

    ; Point ANTIC character generator to the C64 Polish font at $0800-$0BFF
    lda #$08
    sta ATARI_CHBAS
    sta ATARI_CHBASE

    ; Clear screen RAM and install 40x25 Display List
    jsr atari_clear_screen
    lda #<atari_dlist
    sta ATARI_SDLSTL
    sta ATARI_DLISTL
    lda #>atari_dlist
    sta ATARI_SDLSTH
    sta ATARI_DLISTH

    ; Clear keyboard buffer
    lda #$ff
    sta ATARI_CH
    cli
    rts

; Memory Banking ($C000-$CFFF RAM under Atari OS ROM)
; Preserves A, X, Y, and Carry flag.
.def :atari_ramon
    pha
    sei
    lda #$00
    sta ATARI_NMIEN             ; Disable NMI while OS ROM is banked out
    lda ATARI_PORTB
    sta port_save
    and #$fe                    ; Bit 0 = 0: bank in RAM at $C000-$CFFF
    ora #$82                    ; Bit 1 = 1 (BASIC off), Bit 7 = 1 (Self-Test off)
    sta ATARI_PORTB
    pla
    rts

.def :atari_romon
    pha
    lda port_save
    ora #$83                    ; Bit 0 = 1 (OS ROM on), Bit 1 = 1, Bit 7 = 1
    sta ATARI_PORTB
    lda #$40
    sta ATARI_NMIEN             ; Re-enable VBI NMI
    pla
    cli
    rts

; Cursor Position Query (replaces C64 KERNAL PLOT $FFF0)
; Returns current column (0..39) in both X and Y with Carry clear.
.def :atari_getcol
    clc
    ldx cursor_col
    ldy cursor_col
    rts

; Character Output (replaces C64 KERNAL CHROUT $FFD2)
; Preserves A, X, Y. Supports PETSCII control codes & Polish font mapping.
.def :atari_chrout
    sta chrout_save_a
    stx chrout_save_x
    sty chrout_save_y

    lda io_channel
    beq chrout_screen
    jsr atari_io_put_byte
    jmp chrout_done

chrout_screen:
    lda chrout_save_a

    ; Check PETSCII control codes used by the game
    cmp #$93                    ; CLR (clear screen)
    bne @+
    jsr atari_clear_screen
    jmp chrout_done

@   cmp #$0d                    ; CR (carriage return)
    bne @+
    lda #$00
    sta cursor_col
    sta inst_flag
    jsr atari_newline
    jmp chrout_done

@   cmp #$11                    ; Cursor down
    bne @+
    jsr atari_newline
    jmp chrout_done

@   cmp #$91                    ; Cursor up
    bne @+1
    lda cursor_row
    beq @+
    dec cursor_row
@   jmp chrout_done

@   cmp #$1d                    ; Cursor right
    bne @+
    jsr atari_advance_cursor
    jmp chrout_done

@   cmp #$9d                    ; Cursor left
    bne @+
    jsr atari_cursor_left
    jmp chrout_done

@   cmp #$94                    ; INST (used before echoing input character)
    bne @+
    lda #$01
    sta inst_flag
    jmp chrout_done

@   cmp #$14                    ; DEL (backspace in input line)
    bne @+
    lda #$20                    ; Erase underscore cursor at current cell
    jsr atari_put_at_cursor
    jsr atari_cursor_left
    lda #$64                    ; Draw underscore cursor at new cell
    jsr atari_put_at_cursor
    jmp chrout_done

@   ; Ignore C64 color control codes ($05, $1F, $81, $9E, $9F) and others < $20
    cmp #$20
    bcc chrout_done
    cmp #$80
    bcc chrout_printable
    cmp #$a0
    bcc chrout_done

chrout_printable:
    ; Convert PETSCII code in A to C64 screen code (0..127)
    cmp #$40
    bcc chrout_sc_ready         ; $20-$3F -> $20-$3F
    cmp #$60
    bcs @+
    sec
    sbc #$40                    ; $40-$5F -> $00-$1F
    jmp chrout_sc_ready
@   cmp #$80
    bcs @+
    sec
    sbc #$20                    ; $60-$7F -> $40-$5F
    jmp chrout_sc_ready
@   cmp #$c0
    bcs @+
    sec
    sbc #$40                    ; $A0-$BF -> $60-$7F
    jmp chrout_sc_ready
@   and #$7f                    ; $C0-$FE -> $40-$7E

chrout_sc_ready:
    jsr atari_put_at_cursor
    jsr atari_advance_cursor
    lda inst_flag
    beq chrout_done
    lda #$00
    sta inst_flag
    lda #$64                    ; Redraw '_' cursor after inserted character
    jsr atari_put_at_cursor

chrout_done:
    lda chrout_save_a
    ldx chrout_save_x
    ldy chrout_save_y
    rts

; Screen Helper Routines
atari_clear_screen:
    lda #$00
    sta cursor_row
    sta cursor_col
    sta inst_flag
    ldx #$00
    lda #$20
@   sta atari_screen+$000,x
    sta atari_screen+$100,x
    sta atari_screen+$200,x
    sta atari_screen+$2e8,x
    inx
    bne @-
    rts

; Write screen code in A to atari_screen[cursor_row * 40 + cursor_col]
atari_put_at_cursor:
    pha
    ldx cursor_row
    lda row_addr_lo,x
    sta scr_ptr_lo
    lda row_addr_hi,x
    sta scr_ptr_hi
    ldy cursor_col
    pla
    sta (scr_ptr_lo),y
    rts

atari_advance_cursor:
    inc cursor_col
    lda cursor_col
    cmp #40
    bcc @+
    lda #$00
    sta cursor_col
    jmp atari_newline
@   rts

atari_cursor_left:
    lda cursor_col
    bne @+1
    lda cursor_row
    beq @+
    dec cursor_row
    lda #39
    sta cursor_col
@   rts
@   dec cursor_col
    rts

atari_newline:
    inc cursor_row
    lda cursor_row
    cmp #25
    bcc @+5
    lda #24
    sta cursor_row
    ; Scroll 25-row screen ($BC00-$BFE7) up by 1 row (40 bytes) sequentially
    ldx #$00
@   lda atari_screen+40,x
    sta atari_screen,x
    inx
    bne @-
@   lda atari_screen+$100+40,x
    sta atari_screen+$100,x
    inx
    bne @-
@   lda atari_screen+$200+40,x
    sta atari_screen+$200,x
    inx
    bne @-
@   lda atari_screen+$300+40,x
    sta atari_screen+$300,x
    inx
    cpx #$c0                    ; $300 + $C0 = $3C0 (960 bytes)
    bcc @-
    ; Clear bottom row (row 24: $BC00 + 960 = $BFC0..$BFE7)
    lda #$20
    ldx #39
@   sta atari_screen+960,x
    dex
    bpl @-
@   rts

; Lookup table for row start addresses ($BC00 + row * 40)
row_addr_lo:
    :+25 dta <[atari_screen + # * 40]
row_addr_hi:
    :+25 dta >[atari_screen + # * 40]

; Keyboard Input (replaces C64 KERNAL GETIN $FFE4)
; Non-blocking: returns A=0 (Z=1) if no key, or PETSCII code in A (Z=0).
; Preserves X and Y.
.def :atari_getin
    lda ATARI_CH
    cmp #$ff
    bne @+
    lda #$00
    rts
@   stx getin_save_x
    pha
    lda #$ff
    sta ATARI_CH
    pla
    cmp #$40
    bcs @+
    tax
    lda pokey_unshifted_table,x
    ldx getin_save_x
    cmp #$00
    rts
@   and #$3f
    tax
    lda pokey_shifted_table,x
    ldx getin_save_x
    cmp #$00
    rts

; POKEY Scancode -> PETSCII Lookup Tables (64 bytes unshifted + 64 bytes Shift/Ctrl)
pokey_unshifted_table:
    dta $4c, $4a, $5c, $00, $00, $4b, $5c, $5c ; 00-07: L, J, ;(Ł), F1, F2, K, +(Ł), *(Ł)
    dta $4f, $00, $50, $55, $0d, $49, $40, $40 ; 08-0F: O, none, P, U, RETURN, I, -(Ż), =(Ż)
    dta $56, $00, $43, $00, $00, $42, $58, $5a ; 10-17: V, HELP, C, F3, F4, B, X, Z
    dta $34, $00, $33, $36, $00, $35, $32, $31 ; 18-1F: 4, none, 3, 6, ESC, 5, 2, 1
    dta $2c, $20, $2e, $4e, $00, $4d, $2f, $00 ; 20-27: comma, SPACE, period, N, none, M, /, INV
    dta $52, $00, $45, $59, $00, $54, $57, $51 ; 28-2F: R, none, E, Y, TAB, T, W, Q
    dta $39, $00, $30, $37, $14, $38, $00, $00 ; 30-37: 9, none, 0, 7, BACKSPACE, 8, <, >
    dta $46, $48, $44, $00, $00, $47, $53, $41 ; 38-3F: F, H, D, none, CAPS, G, S, A

pokey_shifted_table:
    dta $5c, $4a, $5c, $00, $00, $4b, $5c, $5c ; 00-07: Ł, J, Ł, F1, F2, K, Ł, Ł
    dta $cf, $00, $50, $55, $0d, $49, $40, $40 ; 08-0F: Ó, none, P, U, RETURN, I, Ż, Ż
    dta $56, $00, $c3, $00, $00, $42, $40, $da ; 10-17: V, HELP, Ć, F3, F4, B, Ż, Ź
    dta $34, $00, $33, $36, $00, $35, $32, $31 ; 18-1F: 4..1
    dta $2c, $20, $2e, $ce, $00, $4d, $2f, $00 ; 20-27: comma, SPACE, period, Ń, none, M, /, INV
    dta $52, $00, $c5, $59, $00, $54, $57, $51 ; 28-2F: R, none, Ę, Y, TAB, T, W, Q
    dta $39, $00, $30, $37, $14, $38, $00, $00 ; 30-37: 9, none, 0, 7, BACKSPACE, 8, <, >
    dta $46, $48, $44, $00, $00, $47, $d3, $c1 ; 38-3F: F, H, D, none, CAPS, G, Ś, Ą

; Save / Load I/O Emulation (CIO IOCB #1 + In-Memory Fallback at $A800)
.def :atari_setlfs
    stx io_device               ; $08 = disk, $01 = tape
    sty io_mode                 ; $01 = save, $00 = load
    rts

.def :atari_setnam
    rts

.def :atari_open
    lda #<save_ram_buf
    sta io_ram_ptr_lo
    lda #>save_ram_buf
    sta io_ram_ptr_hi
    lda #$00
    sta cio_active

    ; Close IOCB #1 first in case it was open
    ldx #$10
    lda #$0c                    ; CLOSE
    sta ATARI_ICCOM
    jsr ATARI_CIOV

    ; Choose filename "D:HOBBIDATA" (disk) or "C:" (tape)
    ldx #$10
    lda io_device
    cmp #$08
    beq @+
    lda #<atari_fn_tape
    sta ATARI_ICBAL
    lda #>atari_fn_tape
    sta ATARI_ICBAH
    jmp @+1
@   lda #<atari_fn_disk
    sta ATARI_ICBAL
    lda #>atari_fn_disk
    sta ATARI_ICBAH
@   lda io_mode
    beq @+
    lda #$08                    ; ICAX1 = $08 (write)
    jmp @+1
@   lda #$04                    ; ICAX1 = $04 (read)
@   sta ATARI_ICAX1
    lda #$00
    sta ATARI_ICAX2
    lda #$03                    ; OPEN
    sta ATARI_ICCOM
    jsr ATARI_CIOV
    bmi @+                      ; If no DOS/disk/tape, fall back to RAM buffer
    lda #$01
    sta cio_active
@   rts

.def :atari_chkin
    lda #$01
    sta io_channel
    rts

.def :atari_chkout
    lda #$02
    sta io_channel
    lda #$01
    sta save_ram_valid
    rts

.def :atari_clrchn
    lda #$00
    sta io_channel
    rts

.def :atari_close
    lda #$00
    sta io_channel
    lda cio_active
    beq @+
    ldx #$10
    lda #$0c                    ; CLOSE
    sta ATARI_ICCOM
    jsr ATARI_CIOV
    lda #$00
    sta cio_active
@   rts

; Write byte in chrout_save_a to save stream (both RAM buffer and CIO if open)
atari_io_put_byte:
    ldy #$00
    lda chrout_save_a
    sta (io_ram_ptr_lo),y
    inc io_ram_ptr_lo
    bne @+
    inc io_ram_ptr_hi
@   lda cio_active
    beq @+
    ldx #$10
    lda #$0b                    ; PUT BYTES
    sta ATARI_ICCOM
    lda #$00
    sta ATARI_ICBLL
    sta ATARI_ICBLH
    lda chrout_save_a
    jsr ATARI_CIOV
@   rts

; Read byte from load stream into A (preserves X and Y)
.def :atari_chrin
    stx chrin_save_x
    sty chrin_save_y
    lda cio_active
    beq @+
    ldx #$10
    lda #$07                    ; GET BYTES
    sta ATARI_ICCOM
    lda #$00
    sta ATARI_ICBLL
    sta ATARI_ICBLH
    jsr ATARI_CIOV
    bmi @+
    jmp @+2
@   lda save_ram_valid
    beq @+
    ldy #$00
    lda (io_ram_ptr_lo),y
    inc io_ram_ptr_lo
    bne @+1
    inc io_ram_ptr_hi
    jmp @+1
@   ; If user selected load before any save exists, return $FE sentinel after header
    lda #$fe
@   ldx chrin_save_x
    ldy chrin_save_y
    rts

atari_fn_disk:
    dta c'D:HOBBIDATA', $9b
atari_fn_tape:
    dta c'C:', $9b

; Atari Adapter State Variables
cursor_row:     dta $00
cursor_col:     dta $00
inst_flag:      dta $00
chrout_save_a:  dta $00
chrout_save_x:  dta $00
chrout_save_y:  dta $00
getin_save_x:   dta $00
chrin_save_x:   dta $00
chrin_save_y:   dta $00
io_channel:     dta $00
io_device:      dta $00
io_mode:        dta $00
cio_active:     dta $00
save_ram_valid: dta $00

    run boot_stage1
.endm
