; =============================================================================
; HOBBIT CZYLI W TE I WEWTE...
; (c) 1988 Bohdan R. Rau (Braintron Software)
;
; Full structured MADS disassembly of the original release.
; Compiles into a byte-exact Commodore 64 (.prg) or Atari 800XL/XE (.xex).
; =============================================================================

.ifdef TARGET_ATARI
    icl "atari.inc"
.else
    icl "c64.inc"
.endif

; -----------------------------------------------------------------------------
; Polish PETSCII & Control Character Constants
; -----------------------------------------------------------------------------
C_WHT    = $05                  ; White text
CR       = $0d                  ; Carriage return
CUR_DN   = $11                  ; Cursor down
DEL      = $14                  ; Delete / Backspace
CUR_RT   = $1d                  ; Cursor right
C_BLU    = $1f                  ; Blue text
PL_Z_DOT = $40                  ; 'Ż'
PL_L     = $5c                  ; 'Ł'
C_ORN    = $81                  ; Orange text
CUR_UP   = $91                  ; Cursor up
CLR      = $93                  ; Clear screen
INST     = $94                  ; Insert space
CUR_LT   = $9d                  ; Cursor left
C_YEL    = $9e                  ; Yellow text
C_CYN    = $9f                  ; Cyan text
PL_A     = $c1                  ; 'Ą'
PL_C     = $c3                  ; 'Ć'
PL_E     = $c5                  ; 'Ę'
PL_N     = $ce                  ; 'Ń'
PL_O     = $cf                  ; 'Ó'
PL_S     = $d3                  ; 'Ś'
PL_Z_AC  = $da                  ; 'Ź'

    PROGRAM_HEADER

; =============================================================================
; $0801-$0BFF: BASIC Stub (1988 SYS 2176), Bootstrap & 128-Char 8x8 Polish Font
; =============================================================================
basic_stub:
    dta a($080c), a(1988), $9e, c' 2176', $00, a($0000)
    dta $66, $00                ; Tail of char $01 ('A')
    dta $00, $7c, $66, $7c, $66, $66, $7c, $00 ; Char $02 ('B')
    dta $00, $3c, $66, $60, $60, $66, $3c, $00 ; Char $03 ('C')
    dta $00, $78, $6c, $66, $66, $6c, $78, $00 ; Char $04 ('D')
    dta $00, $7e, $60, $78, $60, $60, $7e, $00 ; Char $05 ('E')
    dta $00, $7e, $60, $78, $60, $60, $60, $00 ; Char $06 ('F')
    dta $00, $3c, $66, $60, $6e, $66, $3c, $00 ; Char $07 ('G')

; Stage-2 bootstrap embedded in character $08-$09 ($0840-$084D), copied to $0400
boot_stage2:
    ldx #$00
L0842:
    lda font_backup,x
    sta $0800,x
    inx
    bne L0842
    jmp start
    dta $3c, $00

    dta $00, $1e, $0c, $0c, $0c, $6c, $38, $00 ; Char $0a ('J')
    dta $00, $66, $6c, $78, $78, $6c, $66, $00 ; Char $0b ('K')
    dta $00, $60, $60, $60, $60, $60, $7e, $00 ; Char $0c ('L')
    dta $00, $63, $77, $7f, $6b, $63, $63, $00 ; Char $0d ('M')
    dta $00, $66, $76, $7e, $7e, $6e, $66, $00 ; Char $0e ('N')
    dta $00, $3c, $66, $66, $66, $66, $3c, $00 ; Char $0f ('O')

; Stage-1 bootstrap embedded in character $10-$11 ($0880-$088D, SYS 2176)
boot_stage1:
    ldx #$10
L0882:
    lda boot_stage2,x
    sta $0400,x
    dex
    bpl L0882
    jmp $0400
    dta $0e, $00

    dta $00, $7c, $66, $66, $7c, $6c, $66, $00 ; Char $12 ('R')
    dta $00, $3e, $60, $3c, $06, $66, $3c, $00 ; Char $13 ('S')
    dta $00, $7e, $18, $18, $18, $18, $18, $00 ; Char $14 ('T')
    dta $00, $66, $66, $66, $66, $66, $3c, $00 ; Char $15 ('U')
    dta $00, $66, $66, $66, $66, $3c, $18, $00 ; Char $16 ('V')
    dta $00, $63, $63, $6b, $7f, $77, $63, $00 ; Char $17 ('W')
    dta $00, $66, $3c, $18, $3c, $66, $66, $00 ; Char $18 ('X')
    dta $00, $66, $66, $66, $3c, $18, $18, $00 ; Char $19 ('Y')
    dta $00, $7e, $0c, $18, $30, $60, $7e, $00 ; Char $1a ('Z')
    dta $3c, $30, $30, $30, $30, $30, $3c, $00 ; Char $1b (gfx)
    dta $00, $60, $6c, $78, $70, $60, $7e, $00 ; Char $1c ('Ł')
    dta $3c, $0c, $0c, $0c, $0c, $0c, $3c, $00 ; Char $1d (gfx)
    dta $00, $18, $3c, $7e, $18, $18, $18, $18 ; Char $1e (gfx)
    dta $00, $10, $30, $7f, $7f, $30, $10, $00 ; Char $1f (gfx)
    dta $00, $00, $00, $00, $00, $00, $00, $00 ; Char $20 (' ')
    dta $18, $18, $18, $18, $00, $00, $18, $00 ; Char $21 ('!')
    dta $66, $66, $66, $00, $00, $00, $00, $00 ; Char $22 ('"')
    dta $66, $66, $ff, $66, $ff, $66, $66, $00 ; Char $23 ('#')
    dta $18, $3e, $60, $3c, $06, $7c, $18, $00 ; Char $24 ('$')
    dta $62, $66, $0c, $18, $30, $66, $46, $00 ; Char $25 ('%')
    dta $3c, $66, $3c, $38, $67, $66, $3f, $00 ; Char $26 ('&')
    dta $06, $0c, $18, $00, $00, $00, $00, $00 ; Char $27 (''')
    dta $0c, $18, $30, $30, $30, $18, $0c, $00 ; Char $28 ('(')
    dta $30, $18, $0c, $0c, $0c, $18, $30, $00 ; Char $29 (')')
    dta $00, $66, $3c, $ff, $3c, $66, $00, $00 ; Char $2a ('*')
    dta $00, $18, $18, $7e, $18, $18, $00, $00 ; Char $2b ('+')
    dta $00, $00, $00, $00, $00, $18, $18, $30 ; Char $2c (',')
    dta $00, $00, $00, $7e, $00, $00, $00, $00 ; Char $2d ('-')
    dta $00, $00, $00, $00, $00, $18, $18, $00 ; Char $2e ('.')
    dta $00, $03, $06, $0c, $18, $30, $60, $00 ; Char $2f ('/')
    dta $00, $3c, $66, $6e, $76, $66, $3c, $00 ; Char $30 ('0')
    dta $00, $18, $38, $18, $18, $18, $7e, $00 ; Char $31 ('1')
    dta $00, $3c, $66, $06, $0c, $30, $7e, $00 ; Char $32 ('2')
    dta $00, $7c, $06, $1c, $06, $66, $3c, $00 ; Char $33 ('3')
    dta $00, $0e, $1e, $66, $7f, $06, $06, $00 ; Char $34 ('4')
    dta $00, $7e, $60, $7c, $06, $66, $3c, $00 ; Char $35 ('5')
    dta $00, $3e, $60, $7c, $66, $66, $3c, $00 ; Char $36 ('6')
    dta $00, $7e, $66, $0c, $18, $18, $18, $00 ; Char $37 ('7')
    dta $00, $3c, $66, $3c, $66, $66, $3c, $00 ; Char $38 ('8')
    dta $00, $3c, $66, $66, $3e, $06, $3c, $00 ; Char $39 ('9')
    dta $00, $00, $18, $00, $00, $18, $00, $00 ; Char $3a (':')
    dta $00, $00, $18, $00, $00, $18, $18, $30 ; Char $3b (';')
    dta $0e, $18, $30, $60, $30, $18, $0e, $00 ; Char $3c ('<')
    dta $00, $00, $7e, $00, $7e, $00, $00, $00 ; Char $3d ('=')
    dta $70, $18, $0c, $06, $0c, $18, $70, $00 ; Char $3e ('>')
    dta $3c, $66, $06, $0c, $18, $00, $18, $00 ; Char $3f ('?')
    dta $00, $00, $00, $ff, $ff, $00, $00, $00 ; Char $40 (gfx)
    dta $00, $18, $3c, $66, $7e, $66, $66, $0c ; Char $41 ('Ą')
    dta $00, $7e, $60, $78, $60, $60, $7e, $0c ; Char $42 (gfx)
    dta $06, $3c, $66, $60, $60, $66, $3c, $00 ; Char $43 ('Ć')
    dta $00, $00, $ff, $ff, $00, $00, $00, $00 ; Char $44 (gfx)
    dta $00, $7e, $60, $78, $60, $60, $7e, $18 ; Char $45 ('Ę')
    dta $00, $00, $00, $00, $ff, $ff, $00, $00 ; Char $46 (gfx)
    dta $30, $30, $30, $30, $30, $30, $30, $30 ; Char $47 (gfx)
    dta $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c ; Char $48 (gfx)
    dta $00, $00, $00, $e0, $f0, $38, $18, $18 ; Char $49 (gfx)
    dta $18, $18, $1c, $0f, $07, $00, $00, $00 ; Char $4a (gfx)
    dta $18, $18, $38, $f0, $e0, $00, $00, $00 ; Char $4b (gfx)
    dta $c0, $c0, $c0, $c0, $c0, $c0, $ff, $ff ; Char $4c (gfx)
    dta $c0, $e0, $70, $38, $1c, $0e, $07, $03 ; Char $4d (gfx)
    dta $0c, $66, $76, $7e, $7e, $6e, $66, $00 ; Char $4e ('Ń')
    dta $06, $3c, $66, $66, $66, $66, $3c, $00 ; Char $4f ('Ó')
    dta $ff, $ff, $03, $03, $03, $03, $03, $03 ; Char $50 (gfx)
    dta $00, $3c, $7e, $7e, $7e, $7e, $3c, $00 ; Char $51 (gfx)
    dta $00, $00, $00, $00, $00, $ff, $ff, $00 ; Char $52 (gfx)
    dta $06, $3c, $60, $3c, $06, $66, $3c, $00 ; Char $53 ('Ś')
    dta $60, $60, $60, $60, $60, $60, $60, $60 ; Char $54 (gfx)
    dta $00, $00, $00, $07, $0f, $1c, $18, $18 ; Char $55 (gfx)
    dta $c3, $e7, $7e, $3c, $3c, $7e, $e7, $c3 ; Char $56 (gfx)
    dta $00, $3c, $7e, $66, $66, $7e, $3c, $00 ; Char $57 (gfx)
    dta $18, $18, $66, $66, $18, $18, $3c, $00 ; Char $58 (gfx)
    dta $06, $06, $06, $06, $06, $06, $06, $06 ; Char $59 (gfx)
    dta $06, $08, $7e, $0c, $18, $30, $7e, $00 ; Char $5a ('Ź')
    dta $18, $18, $18, $ff, $ff, $18, $18, $18 ; Char $5b (gfx)
    dta $c0, $c0, $30, $30, $c0, $c0, $30, $30 ; Char $5c (gfx)
    dta $18, $18, $18, $18, $18, $18, $18, $18 ; Char $5d (gfx)
    dta $00, $00, $03, $3e, $76, $36, $36, $00 ; Char $5e (gfx)
    dta $ff, $7f, $3f, $1f, $0f, $07, $03, $01 ; Char $5f (gfx)
    dta $00, $00, $00, $00, $00, $00, $00, $00 ; Char $60 (gfx)
    dta $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0 ; Char $61 (gfx)
    dta $00, $00, $00, $00, $ff, $ff, $ff, $ff ; Char $62 (gfx)
    dta $ff, $00, $00, $00, $00, $00, $00, $00 ; Char $63 (gfx)
    dta $00, $00, $00, $00, $00, $00, $00, $ff ; Char $64 ('_')
    dta $06, $3c, $66, $66, $66, $66, $3c, $00 ; Char $65 (gfx)
    dta $cc, $cc, $33, $33, $cc, $cc, $33, $33 ; Char $66 (gfx)
    dta $03, $03, $03, $03, $03, $03, $03, $03 ; Char $67 (gfx)
    dta $00, $00, $00, $00, $cc, $cc, $33, $33 ; Char $68 (gfx)
    dta $ff, $fe, $fc, $f8, $f0, $e0, $c0, $80 ; Char $69 (gfx)
    dta $0c, $66, $76, $7e, $7e, $6e, $66, $00 ; Char $6a (gfx)
    dta $18, $18, $18, $1f, $1f, $18, $18, $18 ; Char $6b (gfx)
    dta $00, $00, $00, $00, $0f, $0f, $0f, $0f ; Char $6c (gfx)
    dta $18, $18, $18, $1f, $1f, $00, $00, $00 ; Char $6d (gfx)
    dta $00, $00, $00, $f8, $f8, $18, $18, $18 ; Char $6e (gfx)
    dta $00, $00, $00, $00, $00, $00, $ff, $ff ; Char $6f (gfx)
    dta $00, $00, $00, $1f, $1f, $18, $18, $18 ; Char $70 (gfx)
    dta $18, $18, $18, $ff, $ff, $00, $00, $00 ; Char $71 (gfx)
    dta $00, $00, $00, $ff, $ff, $18, $18, $18 ; Char $72 (gfx)
    dta $18, $18, $18, $f8, $f8, $18, $18, $18 ; Char $73 (gfx)
    dta $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0 ; Char $74 (gfx)
    dta $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0 ; Char $75 (gfx)
    dta $07, $07, $07, $07, $07, $07, $07, $07 ; Char $76 (gfx)
    dta $ff, $ff, $00, $00, $00, $00, $00, $00 ; Char $77 (gfx)
    dta $ff, $ff, $ff, $00, $00, $00, $00, $00 ; Char $78 (gfx)
    dta $00, $00, $00, $00, $00, $ff, $ff, $ff ; Char $79 (gfx)
    dta $03, $03, $03, $03, $03, $03, $ff, $ff ; Char $7a (gfx)
    dta $00, $00, $00, $00, $f0, $f0, $f0, $f0 ; Char $7b (gfx)
    dta $0f, $0f, $0f, $0f, $00, $00, $00, $00 ; Char $7c (gfx)
    dta $18, $18, $18, $f8, $f8, $00, $00, $00 ; Char $7d (gfx)
    dta $f0, $f0, $f0, $f0, $00, $00, $00, $00 ; Char $7e (gfx)
    dta $7e, $81, $9d, $b1, $b1, $9d, $81, $7e ; Char $7f ('(C)')

; =============================================================================
; $0C00-$0CFF: Clean Backup of Font Characters $00-$1F ($0800-$08FF)
; =============================================================================
font_backup:
    dta $00, $7e, $0c, $7e, $30, $60, $7e, $00 ; Backup Char $00 ('Ż')
    dta $00, $18, $3c, $66, $7e, $66, $66, $00 ; Backup Char $01 ('A')
    dta $00, $7c, $66, $7c, $66, $66, $7c, $00 ; Backup Char $02 ('B')
    dta $00, $3c, $66, $60, $60, $66, $3c, $00 ; Backup Char $03 ('C')
    dta $00, $78, $6c, $66, $66, $6c, $78, $00 ; Backup Char $04 ('D')
    dta $00, $7e, $60, $78, $60, $60, $7e, $00 ; Backup Char $05 ('E')
    dta $00, $7e, $60, $78, $60, $60, $60, $00 ; Backup Char $06 ('F')
    dta $00, $3c, $66, $60, $6e, $66, $3c, $00 ; Backup Char $07 ('G')
    dta $00, $66, $66, $7e, $66, $66, $66, $00 ; Backup Char $08 ('H')
    dta $00, $3c, $18, $18, $18, $18, $3c, $00 ; Backup Char $09 ('I')
    dta $00, $1e, $0c, $0c, $0c, $6c, $38, $00 ; Backup Char $0a ('J')
    dta $00, $66, $6c, $78, $78, $6c, $66, $00 ; Backup Char $0b ('K')
    dta $00, $60, $60, $60, $60, $60, $7e, $00 ; Backup Char $0c ('L')
    dta $00, $63, $77, $7f, $6b, $63, $63, $00 ; Backup Char $0d ('M')
    dta $00, $66, $76, $7e, $7e, $6e, $66, $00 ; Backup Char $0e ('N')
    dta $00, $3c, $66, $66, $66, $66, $3c, $00 ; Backup Char $0f ('O')
    dta $00, $7c, $66, $66, $7c, $60, $60, $00 ; Backup Char $10 ('P')
    dta $00, $3c, $66, $66, $66, $3c, $0e, $00 ; Backup Char $11 ('Q')
    dta $00, $7c, $66, $66, $7c, $6c, $66, $00 ; Backup Char $12 ('R')
    dta $00, $3e, $60, $3c, $06, $66, $3c, $00 ; Backup Char $13 ('S')
    dta $00, $7e, $18, $18, $18, $18, $18, $00 ; Backup Char $14 ('T')
    dta $00, $66, $66, $66, $66, $66, $3c, $00 ; Backup Char $15 ('U')
    dta $00, $66, $66, $66, $66, $3c, $18, $00 ; Backup Char $16 ('V')
    dta $00, $63, $63, $6b, $7f, $77, $63, $00 ; Backup Char $17 ('W')
    dta $00, $66, $3c, $18, $3c, $66, $66, $00 ; Backup Char $18 ('X')
    dta $00, $66, $66, $66, $3c, $18, $18, $00 ; Backup Char $19 ('Y')
    dta $00, $7e, $0c, $18, $30, $60, $7e, $00 ; Backup Char $1a ('Z')
    dta $3c, $30, $30, $30, $30, $30, $3c, $00 ; Backup Char $1b (gfx)
    dta $00, $60, $6c, $78, $70, $60, $7e, $00 ; Backup Char $1c ('Ł')
    dta $3c, $0c, $0c, $0c, $0c, $0c, $3c, $00 ; Backup Char $1d (gfx)
    dta $00, $18, $3c, $7e, $18, $18, $18, $18 ; Backup Char $1e (gfx)
    dta $00, $10, $30, $7f, $7f, $30, $10, $00 ; Backup Char $1f (gfx)

; =============================================================================
; $0D00-$0DC2: Startup Vector, Parser Syntax Rules & Verb Dispatch Table
; =============================================================================
start:
    jsr copy_dict_to_c000
    jmp main_entry

obj_table_ptr:
    dta a($b000)
syntax_rule_0:
    dta $05, $02, $06, $02, $fe
syntax_rule_1:
    dta $ff, $04, $fe
syntax_rule_2:
    dta $03, $20, $04, $02, $fe
syntax_rule_3:
    dta $ff, $10, $fe
syntax_rule_4:
    dta $fe
prep_table_1:
    dta $00, $00, $00, $01, $01, $01, $00, $02, $02, $02, $00, $00
prep_table_2:
    dta $00, $00, $00, $01, $01, $01, $00, $01, $01, $01, $00, $00

; 15-entry verb syntax table (3 bytes per verb ID $00..$0E)
verb_syntax_table:
    dta $02, $08, $04 ; Verb $00
    dta $02, $01, $08 ; Verb $01
    dta $ff, $10, $03 ; Verb $02
    dta $08, $00, $02 ; Verb $03
    dta $08, $04, $02 ; Verb $04
    dta $00, $00, $ff ; Verb $05
    dta $08, $00, $ff ; Verb $06
    dta $08, $00, $ff ; Verb $07
    dta $08, $00, $00 ; Verb $08
    dta $ff, $08, $00 ; Verb $09
    dta $ff, $08, $00 ; Verb $0a
    dta $ff, $08, $00 ; Verb $0b
    dta $00, $00, $00 ; Verb $0c
    dta $ff, $08, $00 ; Verb $0d
    dta $ff, $08, $00 ; Verb $0e

verb_prep_req_table:
    dta $00, $01, $02, $01, $01, $01, $00, $01, $01, $01, $02, $02, $02, $00, $01
weapon_pair_table:
    dta $1d, $01
obj_weight_table:
    dta $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $02
    dta $80, $ff, $ff, $80, $00, $80, $00, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    dta $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $40

verb_jump_table:
    dta a(verb_0_go)
    dta a(verb_1_take)
    dta a(verb_2_drop)
    dta a(verb_3_open_close)
    dta a(verb_4_examine)
    dta a(verb_5_inventory)
    dta a(print_random_cant_do)
    dta a(verb_7_attack)
    dta a(verb_8_give_throw)
    dta a(verb_9_put_in)
    dta a(verb_10_wait)
    dta a(verb_11_quit)
    dta a(verb_12_save)
    dta a(verb_13_eat_drink)
    dta a(verb_14_fill)

; =============================================================================
; $0DC3-$147B: Title Screen Keyboard Diagram, HOBBIT Logo & Intro Story
; =============================================================================
str_kbd_top:
    dta CLR, C_WHT, c'    POLSKA KLAWIATURA U', PL_Z_DOT, c'YTA W GRZE:'
    dta CR
    dta CR, CR, CR, c' ', C_BLU, $b0, $c0, $b2, $c0, $b2, $c0, $b2, $c0
    dta $b2, $c0, $b2, $c0, $b2, $c0, $b2, $c0, $b2, $c0, $b2, $c0, $b2, $c0
    dta $ae, CR
    dta c' ', $dd, c' ', $dd, c' ', $dd, C_YEL, PL_E, C_BLU, $dd, c' '
    dta $dd, c' ', $dd, c' ', $dd, c' ', $dd, c' ', $dd, C_YEL, PL_O, C_BLU
    dta $dd, c' ', $dd, c' ', $dd, CR
    dta c' ', $dd, C_YEL, c'Q', C_BLU, $dd, C_YEL, c'W', C_BLU, $dd, C_YEL
    dta c'E', C_BLU, $dd, C_YEL, c'R', C_BLU, $dd, C_YEL, c'T', C_BLU, $dd
    dta C_YEL, c'Y', C_BLU, $dd, C_YEL, c'U', C_BLU, $dd, C_YEL, c'I', C_BLU
    dta $dd, C_YEL, c'O', C_BLU, $dd, C_YEL, c'P', C_BLU, $dd, C_YEL
    dta PL_Z_DOT, C_BLU, $dd, CR
    dta c' ', $ad, $b2, $b1, $b2, $b1, $b2, $b1, $b2, $b1, $b2, $b1, $b2
    dta $b1, $b2, $b1, $b2, $b1, $b2, $b1, $b2, $b1, $b2, $b1, $b2, $c0, $b2
    dta $c0, $c0, $c0, $c0, $c0, $ae, $00

str_kbd_mid1:
    dta CR, C_BLU, c'  ', $dd, C_YEL, PL_A, C_BLU, $dd, C_YEL, PL_S, C_BLU
    dta $dd, c' ', $dd, c' ', $dd, c' ', $dd, c' ', $dd, c' ', $dd, c' '
    dta $dd, c' ', $dd, c' ', $dd, c' ', $dd, c' ', $dd, c'     ', $dd, CR
    dta c'  ', $dd, C_YEL, c'A', C_BLU, $dd, C_YEL, c'S', C_BLU, $dd
    dta C_YEL, c'D', C_BLU, $dd, C_YEL, c'F', C_BLU, $dd, C_YEL, c'G', C_BLU
    dta $dd, C_YEL, c'H', C_BLU, $dd, C_YEL, c'J', C_BLU, $dd, C_YEL, c'K'
    dta C_BLU, $dd, C_YEL, c'L', C_BLU, $dd, c' ', $dd, c' ', $dd, c' ', $dd
    dta C_YEL, c'ENTER', C_BLU, $dd, CR
    dta $b0, $c0, $b1, $b2, $b1, $b2, $b1, $b2, $b1, $b2, $b1, $b2, $b1
    dta $b2, $b1, $b2, $b1, $b2, $b1, $b2, $b1, $b2, $b1, $b2, $b1, $c0, $db
    dta $c0, $c0, $c0, $c0, $c0, $bd, CR
    dta $00

str_kbd_mid2:
    dta $dd, c'^^', $dd, C_YEL, PL_Z_AC, C_BLU, $dd, c' ', $dd, C_YEL
    dta PL_C, C_BLU, $dd, c' ', $dd, c' ', $dd, C_YEL, PL_N, C_BLU, $dd
    dta c' ', $dd, c' ', $dd, c' ', $dd, c' ', $dd, c'^^', $dd, CR
    dta $dd, c'  ', $dd, C_YEL, c'Z', C_BLU, $dd, C_YEL, c'X', C_BLU, $dd
    dta C_YEL, c'C', C_BLU, $dd, C_YEL, c'V', C_BLU, $dd, C_YEL, c'B', C_BLU
    dta $dd, C_YEL, c'N', C_BLU, $dd, C_YEL, c'M', C_BLU, $dd, c' ', $dd
    dta c' ', $dd, c' ', $dd, c'  ', $dd, CR
    dta $00

str_kbd_bot:
    dta $ad, $c0, $c0, $b1, $c0, $b1, $c0, $b1, $c0, $b1, $c0, $b1, $c0
    dta $b1, $c0, $b1, $c0, $b1, $c0, $b1, $c0, $b1, $c0, $b1, $c0, $c0, $bd
    dta $00

str_title_logo:
    dta CR, CR, CR, C_CYN, c'BRAINTRON SOFTWARE PRZEDSTAWIA:', CR
    dta CR, c'PIERWSZA POLSKA PRAWDZIWA GRA TEKSTOWA', CR
    dta c'NA COMMODORE 64/128/+4, ATARI 800XL', CR
    dta c'   ', C_WHT, $b2, c' ', $b2, $d5, $c0, $c9, $b2, $c0, $c9, $b2
    dta $c0, $c9, $b2, $b0, $b2, $ae, CR
    dta c'   ', C_YEL, $db, $c0, $b3, $dd, c' ', $dd, $db, $c0, $b3, $db
    dta $c0, $b3, $dd, c' ', $dd, c'   ', C_CYN, $bf, c' BOHDAN R.RAU', CR
    dta c'   ', C_ORN, $b1, c' ', $b1, $ca, $c0, $cb, $b1, $c0, $cb, $b1
    dta $c0, $cb, $b1, c' ', $b1, CR
    dta c'   CZYLI W TE I WEWTE...', $00, C_BLU, CUR_UP, CUR_UP, CUR_UP
    dta CUR_RT, $b2, CUR_DN, CUR_LT, $dd, CUR_DN, CUR_LT, CUR_LT, C_YEL
    dta PL_L, C_BLU, $dd, CUR_DN, CUR_LT, CUR_LT, CUR_LT, $b1, $c0, $bd, $00

str_kbd_l_box:
    dta CUR_LT, CUR_LT, CUR_LT, CUR_LT, CUR_LT, CUR_LT, CUR_LT, CUR_LT
    dta CUR_LT, CUR_LT, CUR_UP, CUR_UP, CUR_UP, $b2, $c0, $c0, $c0, $b1, $c0
    dta $bd, CUR_UP, CUR_LT, CUR_LT, CUR_LT, $dd, C_YEL, PL_L, C_BLU, $dd
    dta CUR_UP, CUR_LT, CUR_LT, CUR_LT, $dd, c' ', $dd, CUR_UP, CUR_LT
    dta CUR_LT, CUR_LT, $b0, $c0, $ae, CUR_DN, CUR_DN, CUR_DN, CUR_DN
    dta CUR_DN, CUR_DN, $00

str_intro_story:
    dta CLR, CUR_DN, CUR_DN, c' DAWNO TEMU W PODZIEMNYM MIE', PL_S
    dta c'CIE MORIA,', CR
    dta c'ZWANYM W J', PL_E, c'ZYKU KRASNOLUD', PL_O, c'W KHAZAD-DUM,', CR
    dta c'NAD WALECZNYM LUDEM KHUZDUL PANOWA', PL_L, CR
    dta c'WIELKI DURIN. KRASNOLUDY S', PL_L, c'YN', PL_E, PL_L, c'Y W', CR
    dta c'CA', PL_L, c'YM ', PL_S, c'WIECIE ZE SWYCH KLEJNOT', PL_O
    dta c'W. ALE', CR
    dta c'S', PL_L, c'AWA ICH DOTAR', PL_L, c'A A', PL_Z_DOT, c' NA P'
    dta PL_O, PL_L, c'NOC, GDZIE', CR
    dta c'W CZARNEJ KRAINIE MORDOR PANUJE Z', PL_L, c'Y', CR
    dta c'MORGOTH. I OTO WOJSKA MORGOTHA ZAJ', PL_E, PL_L, c'Y', CR
    dta c'PODZIEMNE PA', PL_L, c'ACE MORII, A SKARBY RODU', CR
    dta c'KHUZDUL ZAGARN', PL_A, PL_L, c' CZARNY W', PL_O, c'DZ. JEDEN'
    dta CR
    dta c'TYLKO NAJCENNIEJSZY KLEJNOT, BRYLANTOW', PL_A, CR
    dta c'KUL', PL_E, c', ZABRA', PL_L, c' KTO', PL_S, c' INNY.', CR
    dta c' NA WYSPIE NA D', PL_L, c'UGIM JEZIORZE MIESZKA', CR
    dta c'JEDEN Z POTOMK', PL_O, c'W STAREGO GLAURUNGA,', CR
    dta c'STRASZLIWY SMOK SMAUG. W JEGO JASKINI', CR
    dta c'ZNAJDUJE SI', PL_E, c' NAJWI', PL_E, c'KSZE DZIE', PL_L, c'O'
    dta CR
    dta c'KRASNOLUDZKICH MISTRZ', PL_O, c'W.', CR
    dta c' NIEWIELU POZOSTA', PL_L, c'O Z TYCH, KT', PL_O, c'RZY', CR
    dta c'ZNAJ', PL_A, c' DAWNE DNI. TO MITHRANDIR Z RODU', CR
    dta c'CZARODZIEJ', PL_O, c'W ZWANY TE', PL_Z_DOT, c' GANDALFEM. TO'
    dta CR
    dta c'KRASNOLUD THORIN SYN THRORA Z DRU', PL_Z_DOT, c'YNY', CR
    dta c'DURINA. TO ELROND P', PL_O, PL_L, c'ELF, POSIADAJ', PL_A, c'CY'
    dta CR
    dta c'SZTUK', PL_E, c' CZYTANIA STARO', PL_Z_DOT, c'YTNEGO PISMA', CR
    dta c'ELF', PL_O, c'W, TO DZIKI STRA', PL_Z_DOT, c'NIK LAS', PL_O
    dta c'W BEORN,', CR
    dta c'TO NIEUSTRASZONY BARD Z MIASTA NAD', CR
    dta c'JEZIOREM. ALE TYLKO KTO', PL_S, c' Z RODU MA', PL_L, c'YCH', CR
    dta c'HOBBIT', PL_O, c'W MO', PL_Z_DOT, c'E DOJ', PL_S, PL_C
    dta c' DO JASKINI SMAUGA', CR
    dta c'I ZANIE', PL_S, PL_C, c' KLEJNOT DURINA GANDALFOWI.', CR
    dta CR, $00

; =============================================================================
; $147C-$174C: Parser Work Buffers (with original RAM residue) & Abbreviations
; =============================================================================
; 16 parsed words x 8 bytes ($147C-$14FB)
parsed_words_buf:
    dta c'EZ PEWIEN CZAS CZUJESZ KO', PL_L, c'YSANIE', CR
    dta c'POTEM SILNE UDERZENIE I BECZKA', CR
    dta c'ROZBIJA SI', PL_E, CR, $00, CR, C_CYN, c'TRATWA RUSZA I P', PL_L
    dta c'YNIE PO FALACH', CR
    dta c'D', PL_L, c'UGIEGO JEZIORA', CR

; Current word lookup result buffer ($14FC-$1503)
word_match_buf:
    dta $00, c'TRATWA '

; Raw input line buffer ($1504-$1556)
input_line_buf:
    dta c'DOBIJA DO BRZEGU. WYSIADASZ', CR
    dta $00, CR, C_CYN, c'> ', C_WHT, $a4, CUR_LT, $00, $01, c' JAK STRA'
    dta PL_Z_DOT, c'NIK WYRZUCA BECZK', PL_E, CR
    dta c'Z SIEDZ', PL_A, c'CYM W NI'

; Command prompt string ("> _")
str_prompt:
    dta CR, C_CYN, c'> ', C_WHT, $a4, CUR_LT, $00

; Current input line length
input_len:
    dta $01

; Tokenized words buffer: 16 tokens x 16 bytes ($1560-$165F)
token_table:
    dta c'EM PRZEZ KLAP', PL_E, CR, $00, CR
    dta C_CYN, c'STRA', PL_Z_DOT, c'NIK WYRZUCA JEDN', PL_A, c' Z BECZEK'
    dta CR
    dta c'PRZEZ KLAP', PL_E, c' W POD', PL_L, c'ODZE', CR
    dta $00, C_CYN, c'NIE CHCE ', $00, CR, C_CYN, c'THORIN M', PL_O
    dta c'WI:', CR
    dta c'JEST TO TOP', PL_O, c'R WYKUTY W PODZIEMNYM', CR
    dta c'MIE', PL_S, c'CIE KHAZAD-DUM. TYLKO MY, WOJOWNICY', CR
    dta c'Z RODU KRASNOLUD', PL_O, c'W POTRAFIMY ID', PL_Z_AC, c' NA P'
    dta PL_O, PL_L, c'NOC', $00, c'ID', PL_Z_AC, c' NA P', PL_O, PL_L
    dta c'NOCNY WSCH', PL_O, c'D', $00, c'ID', PL_Z_AC, c' NA WSCH', PL_O
    dta c'D', $00, c'ID'

; Number of tokens in current input line
token_count:
    dta PL_Z_AC

; Expanded command strings for single/multi-letter direction abbreviations
abbrev_exp_0: ; "IDŹ NA PÓŁNOC"
    dta c'ID', PL_Z_AC, c' NA P', PL_O, PL_L, c'NOC', $00
abbrev_exp_1: ; "IDŹ NA PÓŁNOCNY WSCHÓD"
    dta c'ID', PL_Z_AC, c' NA P', PL_O, PL_L, c'NOCNY WSCH', PL_O, c'D'
    dta $00
abbrev_exp_2: ; "IDŹ NA WSCHÓD"
    dta c'ID', PL_Z_AC, c' NA WSCH', PL_O, c'D', $00
abbrev_exp_3: ; "IDŹ NA POŁUDNIOWY WSCHÓD"
    dta c'ID', PL_Z_AC, c' NA PO', PL_L, c'UDNIOWY WSCH', PL_O, c'D', $00
abbrev_exp_4: ; "IDŹ NA POŁUDNIE"
    dta c'ID', PL_Z_AC, c' NA PO', PL_L, c'UDNIE', $00
abbrev_exp_5: ; "IDŹ NA POŁUDNIOWY ZACHÓD"
    dta c'ID', PL_Z_AC, c' NA PO', PL_L, c'UDNIOWY ZACH', PL_O, c'D', $00
abbrev_exp_6: ; "IDŹ NA ZACHÓD"
    dta c'ID', PL_Z_AC, c' NA ZACH', PL_O, c'D', $00
abbrev_exp_7: ; "IDŹ NA PÓŁNOCNY ZACHÓD"
    dta c'ID', PL_Z_AC, c' NA P', PL_O, PL_L, c'NOCNY ZACH', PL_O, c'D'
    dta $00
abbrev_exp_8: ; "IDŹ W GÓRĘ"
    dta c'ID', PL_Z_AC, c' W G', PL_O, c'R', PL_E, $00
abbrev_exp_9: ; "IDŹ W DÓŁ"
    dta c'ID', PL_Z_AC, c' W D', PL_O, PL_L, $00
abbrev_exp_10: ; "CZEKAJ"
    dta c'CZEKAJ', $00

abbrev_ptr_table:
    dta a(abbrev_exp_0)
    dta a(abbrev_exp_1)
    dta a(abbrev_exp_2)
    dta a(abbrev_exp_3)
    dta a(abbrev_exp_4)
    dta a(abbrev_exp_5)
    dta a(abbrev_exp_6)
    dta a(abbrev_exp_7)
    dta a(abbrev_exp_8)
    dta a(abbrev_exp_9)
    dta a(abbrev_exp_10)

abbrev_str_table:
    dta c'PN', $00
    dta c'PNW', $00
    dta c'W', $00
    dta c'PDW', $00
    dta c'PD', $00
    dta c'PDZ', $00
    dta c'Z', $00
    dta c'PNZ', $00
    dta c'G', $00
    dta c'D', $00
    dta c'C', $00

; =============================================================================
; $174D-$260F: Game Messages, Dialogs & Pointer Tables
; =============================================================================
str_sentence_too_long: ; "ZDANIE ZBYT DŁUGIE."
    dta C_BLU, c'ZDANIE ZBYT D', PL_L, c'UGIE.', $00

str_word_too_long: ; "NIE ROZUMIEM"
    dta C_BLU, c'NIE ROZUMIEM', $00

msg_1770: ; "NIE ROZUMIEM SLOWA ""
    dta C_BLU, c'NIE ROZUMIEM SLOWA "', $00

msg_1786: ; ""\n"
    dta c'"', CR, $00

err_msg_ptr_table:
    dta a(msg_1791)
    dta a(msg_17b2)
    dta a(msg_17cf)
    dta a(msg_17d7)

msg_1791: ; "NIE BARDZO ROZUMIEM O CO CHODZI"
    dta C_BLU, c'NIE BARDZO ROZUMIEM O CO CHODZI', $00

msg_17b2: ; "SPRÓBUJ WYRAŻAĆ SIĘ JAŚNIEJ"
    dta C_BLU, c'SPR', PL_O, c'BUJ WYRA', PL_Z_DOT, c'A', PL_C, c' SI'
    dta PL_E, c' JA', PL_S, c'NIEJ', $00

msg_17cf: ; "ŻE CO?"
    dta C_BLU, PL_Z_DOT, c'E CO?', $00

msg_17d7: ; "O CO CHODZI, NIE ROZUMIEM"
    dta C_BLU, c'O CO CHODZI, NIE ROZUMIEM', $00

str_sentence_too_complex: ; "ZDANIE ZBYT SKOMPLIKOWANE."
    dta C_BLU, c'ZDANIE ZBYT SKOMPLIKOWANE.', $00

msg_180e: ; "SPRECYZUJ"
    dta C_BLU, c'SPRECYZUJ ', $00

msg_181a: ; "NIE WIDZISZ"
    dta C_BLU, c'NIE WIDZISZ ', $00

msg_1828: ; "NIE WIDZĘ"
    dta C_BLU, c'NIE WIDZ', PL_E, c' ', $00

msg_1834: ; "NIE MOGĘ"
    dta C_BLU, c'NIE MOG', PL_E, c' ', $00

msg_183f: ; "NIE MOŻESZ"
    dta C_BLU, c'NIE MO', PL_Z_DOT, c'ESZ ', $00

msg_184c: ; "TU NIE MA PRZEJŚCIA"
    dta C_BLU, c'TU NIE MA PRZEJ', PL_S, c'CIA', $00

msg_1861: ; "NA PEWNO CHCESZ SKOŃCZYĆ GRĘ?\nNACIŚNIJ "T" LUB "N""
    dta C_CYN, c'NA PEWNO CHCESZ SKO', PL_N, c'CZY', PL_C, c' GR', PL_E
    dta c'?', CR
    dta c'NACI', PL_S, c'NIJ "T" LUB "N"', $00

msg_1895: ; "\nWCHODZI"
    dta CR, C_CYN, c'WCHODZI ', $00

msg_18a0: ; "\nZNAJDUJESZ SIĘ"
    dta CR, $9b, c'ZNAJDUJESZ SI', PL_E, c' ', $00

msg_18b2: ; "ZOBACZ, WILL, WESZŁO ŚNIADANIE!\n"
    dta C_CYN, c'ZOBACZ, WILL, WESZ', PL_L, c'O ', PL_S, c'NIADANIE!', CR
    dta $00

msg_18d4: ; "COŚ TY, ON JEST ZA MAŁY, NIE NAJEMY SIĘ\n"
    dta C_CYN, c'CO', PL_S, c' TY, ON JEST ZA MA', PL_L
    dta c'Y, NIE NAJEMY SI', PL_E, CR
    dta $00

msg_18fe: ; "\nTROLLE DOCHODZĄ DO WNIOSKU, ŻE NA\nŚNIADANIE JESTEŚ JEDNAK WYS"
    dta CR, C_CYN, c'TROLLE DOCHODZ', PL_A, c' DO WNIOSKU, ', PL_Z_DOT
    dta c'E NA', CR
    dta PL_S, c'NIADANIE JESTE', PL_S, c' JEDNAK WYSTARCZAJ', PL_A, c'CO'
    dta CR
    dta c'T', PL_L, c'USTY...', CR, $00

msg_1953: ; "\nWSTAJE DZIEŃ...\n"
    dta CR, C_CYN, c'WSTAJE DZIE', PL_N, c'...', CR, $00

msg_1966: ; "\nNAGLE POJAWIAJĄ SIĘ GOBLINY\nMIMO PRÓB UCIECZKI DOSTAJESZ SIĘ "
    dta CR, C_CYN, c'NAGLE POJAWIAJ', PL_A, c' SI', PL_E, c' GOBLINY', CR
    dta c'MIMO PR', PL_O, c'B UCIECZKI DOSTAJESZ SI', PL_E, c' DO', CR
    dta c'NIEWOLI', CR, $00

msg_19b1: ; "IDZIE NA"
    dta c'IDZIE NA ', $00

msg_19bb: ; "\nNIESTETY NIE UMIESZ PŁYWAĆ"
    dta C_CYN, CR, c'NIESTETY NIE UMIESZ P', PL_L, c'YWA', PL_C, $00

msg_19d8: ; "\nWYJŚCIA:\n"
    dta CR, C_CYN, c'WYJ', PL_S, c'CIA:', C_WHT, CR, $00

msg_19e5: ; "WIDZISZ:\n"
    dta C_CYN
msg_19e6:
    dta c'WIDZISZ:', CR, $00

msg_19f0: ; "WIDZISZ"
    dta C_CYN, c'WIDZISZ ', $00

msg_19fa: ; "WIDZĘ"
    dta C_CYN, c'WIDZ', PL_E, c' ', $00

msg_1a02: ; "\nKTOŚ"
    dta CR, C_CYN, c'KTO', PL_S, c' ', $00

msg_1a0a: ; "\nMASZ:"
    dta CR, C_CYN, c'MASZ:', $00

msg_1a12: ; "NIE DA SIĘ ROZMAWIAĆ Z"
    dta C_YEL, c'NIE DA SI', PL_E, c' ROZMAWIA', PL_C, c' Z ', $00

msg_1a2b: ; "SĄ"
    dta c'S', PL_A, c' ', $00

msg_1a2f: ; "JEST"
    dta c'JEST ', $00

msg_1a35: ; "SZUKAJ NA POŁUDNIE OD DOLINY MGIEŁ\n"
    dta C_CYN, c'SZUKAJ NA PO', PL_L, c'UDNIE OD DOLINY MGIE', PL_L, CR
    dta $00

msg_1a5a: ; "\nELROND MÓWI :\n WEŹ PROWIANT NA DROGĘ, W TAK DŁUGIEJ\nPODRÓŻY "
    dta CR, C_CYN, c'ELROND M', PL_O, c'WI :', CR
    dta c' ', C_YEL, c'WE', PL_Z_AC, c' PROWIANT NA DROG', PL_E
    dta c', W TAK D', PL_L, c'UGIEJ', CR
    dta c'PODR', PL_O, PL_Z_DOT, c'Y MO', PL_Z_DOT, c'ESZ CZASEM BY', PL_C
    dta c' G', PL_L, c'ODNY.', CR
    dta C_CYN, c'ELROND DAJE CI ', PL_S, c'NIADANIE', CR
    dta $00

msg_1ace: ; "STAROZYTNEGO PISMA\nKTÓRYM OPISANA JEST MAPA\n"
    dta c'STAROZYTNEGO PISMA', CR
    dta c'KT', PL_O, c'RYM OPISANA JEST MAPA', CR
    dta $00

msg_1afb: ; "\nPRÓBUJESZ ZABIĆ"
    dta CR, C_CYN, c'PR', PL_O, c'BUJESZ ZABI', PL_C, c' ', $00

msg_1b0e: ; "\nWALKA JEST ZACIĘTA, ALE JESTEŚ ZBYT\nSŁABY. ZOSTAJESZ POKONANY"
    dta CR, c'WALKA JEST ZACI', PL_E, c'TA, ALE JESTE', PL_S, c' ZBYT', CR
    dta c'S', PL_L, c'ABY. ZOSTAJESZ POKONANY PRZEZ ', $00

msg_1b54: ; "\nUWAŻAJ, DZIKI WARG ATAKUJE!\n"
    dta CR, C_YEL, c'UWA', PL_Z_DOT, c'AJ, DZIKI WARG ATAKUJE!', CR, $00

msg_1b73: ; "\nNIESTETY, WARG OKAZAŁ SIĘ SILNIEJSZY\n"
    dta CR, C_YEL, c'NIESTETY, WARG OKAZA', PL_L, c' SI', PL_E
    dta c' SILNIEJSZY', CR, $00

msg_1b9b: ; "\nUWAŻAJ, PAJĄK ATAKUJE!\n"
    dta CR, C_YEL, c'UWA', PL_Z_DOT, c'AJ, PAJ', PL_A, c'K ATAKUJE!', CR
    dta $00

msg_1bb5: ; "\nNIESTETY, PAJĄK OKAZAŁ SIĘ SILNIEJSZY\n"
    dta CR, C_YEL, c'NIESTETY, PAJ', PL_A, c'K OKAZA', PL_L, c' SI', PL_E
    dta c' SILNIEJSZY', CR
    dta $00

msg_1bde: ; "\nGOLLUM JEST ZDANIA, ŻE PIERŚCIEŃ JEST\nJEGO WŁASNOŚCIĄ I ZABIJ"
    dta CR, C_YEL, c'GOLLUM JEST ZDANIA, ', PL_Z_DOT, c'E PIER', PL_S
    dta c'CIE', PL_N, c' JEST', CR
    dta c'JEGO W', PL_L, c'ASNO', PL_S, c'CI', PL_A, c' I ZABIJA CI', PL_E
    dta CR
    dta $00

msg_1c24: ; "\nDOTYCHCZAS CHRONIŁ CIĘ PIERŚCIEŃ DAJĄC CI\nNIEWIDZIALNOŚĆ, ALE"
    dta CR, C_CYN, c'DOTYCHCZAS CHRONI', PL_L, c' CI', PL_E, c' PIER'
    dta PL_S, c'CIE', PL_N, c' DAJ', PL_A, c'C CI', CR
    dta c'NIEWIDZIALNO', PL_S, PL_C, c', ALE TERAZ GOLLUM', CR
    dta c'US', PL_L, c'YSZA', PL_L, c' TW', PL_O, c'J G', PL_L
    dta c'OS I WIE, ', PL_Z_DOT, c'E TU JESTE', PL_S, $00

msg_1c98: ; "\nGOLLUM MOWI :\n KTOŚ UKRADŁ MÓJ PIERŚCIEŃ I POSIADŁ MOC\nELFÓW"
    dta CR, C_CYN, c'GOLLUM MOWI :', CR
    dta c' KTO', PL_S, c' UKRAD', PL_L, c' M', PL_O, c'J PIER', PL_S
    dta c'CIE', PL_N, c' I POSIAD', PL_L, c' MOC', CR
    dta c'ELF', PL_O, c'W, KT', PL_O, c'RE GO WYKU', PL_L, c'Y! ZABIJ'
    dta PL_E, c' GO!', CR
    dta $00

msg_1cf5: ; "\nWARG NIE POZWALA CI ODEJŚĆ\n"
    dta CR, C_CYN, c'WARG NIE POZWALA CI ODEJ', PL_S, PL_C, CR, $00

msg_1d13: ; "\nPAJAK NIE POZWALA CI ODEJŚĆ\n"
    dta CR, C_CYN, c'PAJAK NIE POZWALA CI ODEJ', PL_S, PL_C, CR, $00

msg_1d32: ; "\nPOJAWIA SIĘ KILKUNASTU ELFÓW\nELFY PORYWAJĄ CIĘ\n"
    dta CR, C_CYN, c'POJAWIA SI', PL_E, c' KILKUNASTU ELF', PL_O, c'W', CR
    dta c'ELFY PORYWAJ', PL_A, c' CI', PL_E, CR
    dta $00

msg_1d64: ; "\nMOC PIERŚCIENIA PORUSZA ŁÓDKĘ\n\n"
    dta CR, C_YEL, c'MOC PIER', PL_S, c'CIENIA PORUSZA ', PL_L, PL_O
    dta c'DK', PL_E, CR, CR, $00

msg_1d86: ; "\nCZUJESZ, ŻE BECZKA PORUSZA SIĘ I SPADA\nPRZEZ PEWIEN CZAS CZUJ"
    dta CR, C_CYN, c'CZUJESZ, ', PL_Z_DOT, c'E BECZKA PORUSZA SI', PL_E
    dta c' I SPADA', CR
    dta c'PRZEZ PEWIEN CZAS CZUJESZ KO', PL_L, c'YSANIE', CR
    dta c'POTEM SILNE UDERZENIE I BECZKA', CR
    dta c'ROZBIJA SI', PL_E, CR, $00

msg_1dff: ; "\nTRATWA RUSZA I PŁYNIE PO FALACH\nDŁUGIEGO JEZIORA\n"
    dta CR, C_CYN, c'TRATWA RUSZA I P', PL_L, c'YNIE PO FALACH', CR
    dta c'D', PL_L, c'UGIEGO JEZIORA', CR
    dta $00

msg_1e33: ; "TRATWA DOBIJA DO BRZEGU. WYSIADASZ\n"
    dta c'TRATWA DOBIJA DO BRZEGU. WYSIADASZ', CR, $00

msg_1e57: ; "\nWIDZISZ JAK STRAŻNIK WYRZUCA BECZKĘ\nZ SIEDZĄCYM W NIEJ THORIN"
    dta CR, C_CYN, c'WIDZISZ JAK STRA', PL_Z_DOT, c'NIK WYRZUCA BECZK'
    dta PL_E, CR
    dta c'Z SIEDZ', PL_A, c'CYM W NIEJ THORINEM PRZEZ KLAP', PL_E, CR
    dta $00

msg_1ea6: ; "\nSTRAŻNIK WYRZUCA JEDNĄ Z BECZEK\nPRZEZ KLAPĘ W PODŁODZE\n"
    dta CR, C_CYN, c'STRA', PL_Z_DOT, c'NIK WYRZUCA JEDN', PL_A
    dta c' Z BECZEK', CR
    dta c'PRZEZ KLAP', PL_E, c' W POD', PL_L, c'ODZE', CR
    dta $00

msg_1ee0: ; "NIE CHCE"
    dta C_CYN, c'NIE CHCE ', $00

msg_1eeb: ; "\nTHORIN MÓWI:\nJEST TO TOPÓR WYKUTY W PODZIEMNYM\nMIEŚCIE KHAZA"
    dta CR, C_CYN, c'THORIN M', PL_O, c'WI:', CR, c'JEST TO TOP', PL_O
    dta c'R WYKUTY W PODZIEMNYM', CR
    dta c'MIE', PL_S, c'CIE KHAZAD-DUM. TYLKO MY, WOJOWNICY', CR
    dta c'Z RODU KRASNOLUD', PL_O, c'W POTRAFIMY POS', PL_L, c'U'
    dta PL_Z_DOT, c'Y', PL_C, CR
    dta c'SI', PL_E, $a0, c'TAKIM TOPOREM', CR
    dta CR, c'THORIN ZABIERA WIELKI TOP', PL_O, c'R', CR
    dta $00

msg_1f9a: ; "\nOKAZUJE SIĘ, ŻE BEORN BARDZO NIE LUBI\nJEŚLI OTWIERA SIĘ JEGO "
    dta CR, C_CYN, c'OKAZUJE SI', PL_E, c', ', PL_Z_DOT
    dta c'E BEORN BARDZO NIE LUBI', CR
    dta c'JE', PL_S, c'LI OTWIERA SI', PL_E, c' JEGO DRZWI BEZ', CR
    dta c'POZWOLENIA. ', PL_N, c'IESTETY MA ON ZWYCZAJ', CR
    dta c'ZABIJANIA NIEPO', PL_Z_DOT, PL_A, c'DANYCH GO', PL_S, c'CI', CR
    dta $00

msg_2025: ; "\nBARD MÓWI :\nPOKAŻĘ CI UKRYTE PRZEJŚCIE.\nCHODŹ ZA MNĄ.\n"
    dta CR, C_CYN, c'BARD M', PL_O, c'WI :', CR, c'POKA', PL_Z_DOT, PL_E
    dta c' CI UKRYTE PRZEJ', PL_S, c'CIE.', CR
    dta c'CHOD', PL_Z_AC, c' ZA MN', PL_A, c'.', CR, $00

msg_205e: ; "\nGANDALF MÓWI :\nNA CO CZEKASZ, SPIESZ SIĘ!\n"
    dta CR, C_CYN, c'GANDALF M', PL_O, c'WI :', CR
    dta c'NA CO CZEKASZ, SPIESZ SI', PL_E, c'!', CR
    dta $00

msg_208b: ; "\nOKAZUJE SIĘ, ŻE SMOK NIE LUBI, KIEDY\nKTOŚ DOBIERA SIĘ DO JEGO"
    dta CR, C_YEL, c'OKAZUJE SI', PL_E, c', ', PL_Z_DOT
    dta c'E SMOK NIE LUBI, KIEDY', CR
    dta c'KTO', PL_S, c' DOBIERA SI', PL_E, c' DO JEGO W', PL_L, c'ASNO'
    dta PL_S, c'CI...', CR
    dta $00

msg_20d9: ; "\nWLATUJE STRASZNY SMOK\n"
    dta CR, C_CYN, c'WLATUJE STRASZNY SMOK', CR, $00

msg_20f2: ; "\nSTRASZNY SMOK ODLATUJE\n"
    dta CR, C_CYN, c'STRASZNY SMOK ODLATUJE', CR, $00

msg_210c: ; "\nNIAM NIAM NIAM...\n"
    dta CR, C_CYN, c'NIAM NIAM NIAM...', CR, $00

msg_2121: ; "\nBEORN MÓWI :\n MUSISZ MIEĆ ŻYWNOŚĆ NA DROGĘ\nNIE MAM WIELE ALE"
    dta CR, C_CYN, c'BEORN M', PL_O, c'WI :', CR, c' MUSISZ MIE', PL_C
    dta c' ', PL_Z_DOT, c'YWNO', PL_S, PL_C, c' NA DROG', PL_E, CR
    dta c'NIE MAM WIELE ALE PODZIEL', PL_E, c' SI', PL_E, CR
    dta c'TYM CO MAM', CR, $00

msg_2179: ; "\nNA WIDOK KLEJNOTU DURINA THORIN TRACI\nGŁOWĘ\nTHORIN MÓWI :\n "
    dta CR, C_CYN, c'NA WIDOK KLEJNOTU DURINA THORIN TRACI', CR
    dta c'G', PL_L, c'OW', PL_E, CR, c'THORIN M', PL_O, c'WI :', CR
    dta c' KRYSZTA', PL_L, c'OWA KULA KRASNOLUD', PL_O, c'W MUSI', CR
    dta c'POZOSTA', PL_C, c' W R', PL_E, c'KU JEDNEGO Z NICH', CR
    dta c'ZABIJ', PL_E, c' KA', PL_Z_DOT, c'DEGO KTO JEJ DOTKNIE!', CR
    dta CR, c'...I THORIN ROBI TO CO ZAPOWIEDZIA', PL_L, CR
    dta $00

msg_223d: ; "\nWIDZISZ JAK BARD ZABIJA SMOKA\n"
    dta CR, C_YEL, c'WIDZISZ JAK BARD ZABIJA SMOKA', CR, $00

msg_225e: ; "\nDOBIEGA CIĘ RYK KONAJĄCEGO SMOKA\n"
    dta CR, C_YEL, c'DOBIEGA CI', PL_E, c' RYK KONAJ', PL_A, c'CEGO SMOKA'
    dta CR, $00

msg_2282: ; "\n ŚWIETNY POMYSŁ! JAK GO TYLKO ZOBACZĘ\n"
    dta CR, C_CYN, c' ', PL_S, c'WIETNY POMYS', PL_L
    dta c'! JAK GO TYLKO ZOBACZ', PL_E, CR
    dta $00

msg_22ab: ; "\n JEDNEGO JUŻ ZABIŁEM\n"
    dta CR, C_CYN, c' JEDNEGO JU', PL_Z_DOT, c' ZABI', PL_L, c'EM', CR
    dta $00

msg_22c3: ; "\n JUŻ MI TO MÓWIŁEŚ\n"
    dta CR, C_CYN, c' JU', PL_Z_DOT, c' MI TO M', PL_O, c'WI', PL_L, c'E'
    dta PL_S, CR, $00

msg_22d9: ; "\nTHORIN MÓWI :\n MAM JUŻ DOŚĆ, ODCHODZĘ. ŻEGNAJ\nTHORIN ODCHODZ"
    dta CR, C_CYN, c'THORIN M', PL_O, c'WI :', CR
    dta c' MAM JU', PL_Z_DOT, c' DO', PL_S, PL_C, c', ODCHODZ', PL_E
    dta c'. ', PL_Z_DOT, c'EGNAJ', CR
    dta c'THORIN ODCHODZI', CR
    dta $00

str_ok: ; "\nN...WZNOWIENIE ZAPISANEJ GRY:\n\n"
    dta CR, $1b, c'N', C_CYN, CLR, CUR_DN, CUR_RT
    dta c'...WZNOWIENIE ZAPISANEJ GRY:', CR, CR, $00

hunger_msg_ptr_table:
    dta a(msg_23b0)
    dta a(msg_23cb)
    dta a(msg_23ec)
    dta a(msg_2404)
    dta a(msg_2404)
    dta a(msg_2404)
    dta a(msg_2418)
    dta a(msg_242f)

str_starved: ; "\nNIESTETY, HOBBIT TO NIE JEST WIELBŁĄD I\nCO JAKIŚ CZAS MUSI CO"
    dta CR, C_CYN, c'NIESTETY, HOBBIT TO NIE JEST WIELB', PL_L, PL_A
    dta c'D I', CR
    dta c'CO JAKI', PL_S, c' CZAS MUSI CO', PL_S, c' ZJE', PL_S, PL_C
    dta c', INACZEJ', CR
    dta c'GINIE Z G', PL_L, c'ODU.', CR, $00

msg_23b0: ; "\nPRAWIE UMIERASZ Z GŁODU\n"
    dta CR, C_YEL, c'PRAWIE UMIERASZ Z G', PL_L, c'ODU', CR, $00

msg_23cb: ; "\nCZUJESZ, ŻE CIĘ SSIE Z GŁODU!\n"
    dta CR, C_YEL, c'CZUJESZ, ', PL_Z_DOT, c'E CI', PL_E, c' SSIE Z G'
    dta PL_L, c'ODU!', CR, $00

msg_23ec: ; "\nJESTEŚ BARDZO GŁODNY\n"
    dta CR, C_YEL, c'JESTE', PL_S, c' BARDZO G', PL_L, c'ODNY', CR, $00

msg_2404: ; "\nCHCE CI SIĘ JEŚĆ\n"
    dta CR, C_YEL, c'CHCE CI SI', PL_E, c' JE', PL_S, PL_C, CR, $00

msg_2418: ; "\nCOŚ BY SIĘ ZJADŁO...\n"
    dta CR, c'CO', PL_S, c' BY SI', PL_E, c' ZJAD', PL_L, c'O...', CR, $00

msg_242f: ; "\nZACZYNA CI SIĘ CHCIEĆ JEŚĆ\n"
    dta CR, c'ZACZYNA CI SI', PL_E, c' CHCIE', PL_C, c' JE', PL_S, PL_C
    dta CR, $00

msg_244c: ; "\n\n      G R A   S K O Ń C Z O N A       \n"
    dta CR, CR, C_BLU, $b0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0
    dta $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0
    dta $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0
    dta $c0, $ae, $dd, c'      ', C_YEL, c'G R A   S K O ', PL_N
    dta c' C Z O N A', C_BLU, c'       ', $dd, $ad, $c0, $c0, $c0, $c0, $c0
    dta $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0
    dta $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0
    dta $c0, $c0, $c0, $c0, $c0, $bd, CR
    dta $00

msg_24cb: ; "\n\n  DOKONAŁEŚ WIELKIEGO CZYNU. KLEJNOT    DURINA ZNALAZŁ SIĘ W"
    dta CR, CR, $b0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0
    dta $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0
    dta $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $ae
    dta $dd, c'  DOKONA', PL_L, c'E', PL_S, c' WIELKIEGO CZYNU. KLEJNOT  '
    dta $dd, $dd, c'  DURINA ZNALAZ', PL_L, c' SI', PL_E, c' WE W', PL_L
    dta c'A', PL_S, c'CIWYCH    ', $dd, $dd, c'  R', PL_E, c'KACH. '
    dta PL_Z_AC, c'NOWU WRACA SPOK', PL_O, c'J, A NA    ', $dd, $00

msg_256e: ; "PAMIĄTKĘ WYPRAWY POZOSTAŁ TYLKO       ZŁOTY PIERŚCIEŃ...        "
    dta $dd, c'  PAMI', PL_A, c'TK', PL_E, c' WYPRAWY POZOSTA', PL_L
    dta c' TYLKO     ', $dd, $dd, c'  Z', PL_L, c'OTY PIER', PL_S, c'CIE'
    dta PL_N, c'...                  ', $dd, $dd, c'      G R A   S K O '
    dta PL_N, c' C Z O N A       ', $dd, $ad, $c0, $c0, $c0, $c0, $c0, $c0
    dta $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0
    dta $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0
    dta $c0, $c0, $c0, $c0, $bd, CR
    dta $00

; =============================================================================
; $2610-$2C72: Room Descriptions Table (82 Rooms, $01..$52)
; =============================================================================
room_desc_table:
    dta c'W WYGODNYM TUNELU', $00 ; Room $01 (1): W WYGODNYM TUNELU
    dta c'NA PUSTKOWIU', $00 ; Room $02 (2): NA PUSTKOWIU
    dta c'NA POLANIE TROLLI', $00 ; Room $03 (3): NA POLANIE TROLLI
    dta c'NA SKALNEJ ', PL_S, c'CIE', PL_Z_DOT, c'CE', $00 ; Room $04 (4): NA SKALNEJ ŚCIEŻCE
    dta c'W SKALNEJ PIECZARZE', $00 ; Room $05 (5): W SKALNEJ PIECZARZE
    dta c'W RIVENDELL', $00 ; Room $06 (6): W RIVENDELL
    dta c'W DOLINIE MGIE', PL_L, $00 ; Room $07 (7): W DOLINIE MGIEŁ
    dta c'W G', PL_O, c'RACH MGLISTYCH', $00 ; Room $08 (8): W GÓRACH MGLISTYCH
    dta c'W G', PL_O, c'RACH MGLISTYCH', $00 ; Room $09 (9): W GÓRACH MGLISTYCH
    dta c'W G', PL_O, c'RACH MGLISTYCH', $00 ; Room $0a (10): W GÓRACH MGLISTYCH
    dta c'W G', PL_O, c'RACH MGLISTYCH', $00 ; Room $0b (11): W GÓRACH MGLISTYCH
    dta c'W G', PL_O, c'RACH MGLISTYCH', $00 ; Room $0c (12): W GÓRACH MGLISTYCH
    dta c'W G', PL_O, c'RACH MGLISTYCH', $00 ; Room $0d (13): W GÓRACH MGLISTYCH
    dta c'W G', PL_O, c'RACH MGLISTYCH', $00 ; Room $0e (14): W GÓRACH MGLISTYCH
    dta c'W G', PL_O, c'RACH MGLISTYCH', $00 ; Room $0f (15): W GÓRACH MGLISTYCH
    dta c'W G', PL_O, c'RACH MGLISTYCH', $00 ; Room $10 (16): W GÓRACH MGLISTYCH
    dta c'W G', PL_O, c'RACH MGLISTYCH', $00 ; Room $11 (17): W GÓRACH MGLISTYCH
    dta c'NA SKALNEJ ', PL_S, c'CIEZCE', $00 ; Room $12 (18): NA SKALNEJ ŚCIEZCE
    dta c'W LOCHU GOBLIN', PL_O, c'W', $00 ; Room $13 (19): W LOCHU GOBLINÓW
    dta c'W LABIRYNCIE KORYTARZY', $00 ; Room $14 (20): W LABIRYNCIE KORYTARZY
    dta c'W LABIRYNCIE KORYTARZY', $00 ; Room $15 (21): W LABIRYNCIE KORYTARZY
    dta c'W LABIRYNCIE KORYTARZY', $00 ; Room $16 (22): W LABIRYNCIE KORYTARZY
    dta c'W LABIRYNCIE KORYTARZY', $00 ; Room $17 (23): W LABIRYNCIE KORYTARZY
    dta c'W LABIRYNCIE KORYTARZY', $00 ; Room $18 (24): W LABIRYNCIE KORYTARZY
    dta c'W LABIRYNCIE KORYTARZY', $00 ; Room $19 (25): W LABIRYNCIE KORYTARZY
    dta c'W LABIRYNCIE KORYTARZY', $00 ; Room $1a (26): W LABIRYNCIE KORYTARZY
    dta c'W LABIRYNCIE KORYTARZY', $00 ; Room $1b (27): W LABIRYNCIE KORYTARZY
    dta c'W LABIRYNCIE KORYTARZY', $00 ; Room $1c (28): W LABIRYNCIE KORYTARZY
    dta c'W LABIRYNCIE KORYTARZY', $00 ; Room $1d (29): W LABIRYNCIE KORYTARZY
    dta c'W LABIRYNCIE KORYTARZY', $00 ; Room $1e (30): W LABIRYNCIE KORYTARZY
    dta c'W LABIRYNCIE KORYTARZY', $00 ; Room $1f (31): W LABIRYNCIE KORYTARZY
    dta c'W PIECZARZE NAD CZARNYM  JEZIOREM', $00 ; Room $20 (32): W PIECZARZE NAD CZARNYM  JEZIOREM
    dta c'W PIECZARZE NAD CZARNYM  JEZIOREM', $00 ; Room $21 (33): W PIECZARZE NAD CZARNYM  JEZIOREM
    dta c'W PIECZARZE NAD CZARNYM  JEZIOREM', $00 ; Room $22 (34): W PIECZARZE NAD CZARNYM  JEZIOREM
    dta c'W PIECZARZE NAD CZARNYM  JEZIOREM', $00 ; Room $23 (35): W PIECZARZE NAD CZARNYM  JEZIOREM
    dta c'W CZARNYM JEZIORZE', $00 ; Room $24 (36): W CZARNYM JEZIORZE
    dta c'NA SKALNEJ ', PL_S, c'CIEZCE', $00 ; Room $25 (37): NA SKALNEJ ŚCIEZCE
    dta c'NA PODW', PL_O, c'RZU POD DOMEM', CR, c'BEORNA', $00 ; Room $26 (38): NA PODWÓRZU POD DOMEM\nBEORNA
    dta c'W DOMU BEORNA', $00 ; Room $27 (39): W DOMU BEORNA
    dta c'W LESIE', $00 ; Room $28 (40): W LESIE
    dta c'W LESIE', $00 ; Room $29 (41): W LESIE
    dta c'W LESIE', $00 ; Room $2a (42): W LESIE
    dta c'W LESIE', $00 ; Room $2b (43): W LESIE
    dta c'NA ZACHODNIM BRZEGU', CR, c'CZARNEJ RZEKI', $00 ; Room $2c (44): NA ZACHODNIM BRZEGU\nCZARNEJ RZEKI
    dta c'W CZARNEJ RZECE', $00 ; Room $2d (45): W CZARNEJ RZECE
    dta c'NA WSCHODNIM BRZEGU', CR, c'CZARNEJ RZEKI', $00 ; Room $2e (46): NA WSCHODNIM BRZEGU\nCZARNEJ RZEKI
    dta c'W LESIE', $00 ; Room $2f (47): W LESIE
    dta c'W LESIE', $00 ; Room $30 (48): W LESIE
    dta c'W LESIE', $00 ; Room $31 (49): W LESIE
    dta c'W LESIE', $00 ; Room $32 (50): W LESIE
    dta c'NA LE', PL_S, c'NEJ POLANIE', $00 ; Room $33 (51): NA LEŚNEJ POLANIE
    dta c'NA LE', PL_S, c'NEJ POLANIE', $00 ; Room $34 (52): NA LEŚNEJ POLANIE
    dta c'NA P', PL_O, PL_L, c'NOCNYM BRZEGU', CR, c'WIELKIEJ RZEKI', $00 ; Room $35 (53): NA PÓŁNOCNYM BRZEGU\nWIELKIEJ RZEKI
    dta c'W WIELKIEJ RZECE', $00 ; Room $36 (54): W WIELKIEJ RZECE
    dta c'NA PO', PL_L, c'UDNIOWYM BRZEGU', CR, c'WIELKIEJ RZEKI', $00 ; Room $37 (55): NA POŁUDNIOWYM BRZEGU\nWIELKIEJ RZEKI
    dta c'W LOCHU KR', PL_O, c'LA ELF', PL_O, c'W', $00 ; Room $38 (56): W LOCHU KRÓLA ELFÓW
    dta c'W LOCHU KR', PL_O, c'LA ELF', PL_O, c'W', $00 ; Room $39 (57): W LOCHU KRÓLA ELFÓW
    dta c'W KORYTARZU', $00 ; Room $3a (58): W KORYTARZU
    dta c'W PA', PL_L, c'ACOWEJ PIWNICY', $00 ; Room $3b (59): W PAŁACOWEJ PIWNICY
    dta c'W WODOSPADZIE', $00 ; Room $3c (60): W WODOSPADZIE
    dta c'W MIE', PL_S, c'CIE NAD JEZIOREM', $00 ; Room $3d (61): W MIEŚCIE NAD JEZIOREM
    dta c'W MIE', PL_S, c'CIE NAD JEZIOREM', $00 ; Room $3e (62): W MIEŚCIE NAD JEZIOREM
    dta c'W MIE', PL_S, c'CIE NAD JEZIOREM', $00 ; Room $3f (63): W MIEŚCIE NAD JEZIOREM
    dta c'W MIE', PL_S, c'CIE NAD JEZIOREM', $00 ; Room $40 (64): W MIEŚCIE NAD JEZIOREM
    dta c'W MIE', PL_S, c'CIE NAD JEZIOREM', $00 ; Room $41 (65): W MIEŚCIE NAD JEZIOREM
    dta c'W MIE', PL_S, c'CIE NAD JEZIOREM', $00 ; Room $42 (66): W MIEŚCIE NAD JEZIOREM
    dta c'W MIE', PL_S, c'CIE NAD JEZIOREM', $00 ; Room $43 (67): W MIEŚCIE NAD JEZIOREM
    dta c'W MIE', PL_S, c'CIE NAD JEZIOREM', $00 ; Room $44 (68): W MIEŚCIE NAD JEZIOREM
    dta c'W MIE', PL_S, c'CIE NAD JEZIOREM', $00 ; Room $45 (69): W MIEŚCIE NAD JEZIOREM
    dta c'W MIE', PL_S, c'CIE NAD JEZIOREM', $00 ; Room $46 (70): W MIEŚCIE NAD JEZIOREM
    dta c'W MIE', PL_S, c'CIE NAD JEZIOREM', $00 ; Room $47 (71): W MIEŚCIE NAD JEZIOREM
    dta c'W MIE', PL_S, c'CIE NAD JEZIOREM', $00 ; Room $48 (72): W MIEŚCIE NAD JEZIOREM
    dta c'W MIE', PL_S, c'CIE NAD JEZIOREM', $00 ; Room $49 (73): W MIEŚCIE NAD JEZIOREM
    dta c'W MIE', PL_S, c'CIE NAD JEZIOREM', $00 ; Room $4a (74): W MIEŚCIE NAD JEZIOREM
    dta c'W PA', PL_L, c'ACU', $00 ; Room $4b (75): W PAŁACU
    dta c'NA PRZYSTANI', $00 ; Room $4c (76): NA PRZYSTANI
    dta c'W JEZIORZE', $00 ; Room $4d (77): W JEZIORZE
    dta c'W JEZIORZE', $00 ; Room $4e (78): W JEZIORZE
    dta c'NA KAMIENISTEJ PLA', PL_Z_DOT, c'Y', $00 ; Room $4f (79): NA KAMIENISTEJ PLAŻY
    dta c'NA SKALNEJ P', PL_O, PL_L, c'CE', $00 ; Room $50 (80): NA SKALNEJ PÓŁCE
    dta c'W CIASNEJ PIECZARZE', $00 ; Room $51 (81): W CIASNEJ PIECZARZE
    dta c'W JASKINI SMOKA', $00 ; Room $52 (82): W JASKINI SMOKA
    dta $00                         ; End of room descriptions

; =============================================================================
; $2C73-$2D7F: Game State Variables, Clause Work Area & World Tables
; =============================================================================
    dta $ff
gram_case:
    dta $00, $ff, $00, $ff
word_idx:
    dta $00
unknown_word_buf:
    dta $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    dta $ff, $00, $ff
clause_idx:
    dta $00
cur_adj1:
    dta $ff
cur_adj2:
    dta $00
cur_noun:
    dta $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    dta $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    dta $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $01
    dta $ff, $00, $ff, $15, $34, $36, $00, $40, $40, $40, $4c, $40, $40, $3e, $43, $44
    dta $44, $44, $44, $52, $52, $52, $52, $52, $52, $43, $52, $52, $4f, $24, $4d, $4e
    dta $36, $3c, $2d, $24, $00, $03, $04, $02, $ff, $03, $01, $06, $06, $02, $01, $01
    dta $01, $03, $05, $07, $01, $21, $07, $22, $01, $23, $01, $20
cmd_verb_arg1:
    dta $08
cmd_prep:
    dta $1b
cmd_obj_list:
    dta $02, $1c, $02, $1d, $02, $1e, $00, $1a
cmd_obj_count:
    dta $04
cmd_verb_id:
    dta $00
current_room:
    dta $01
print_hdr_flag:
    dta $02
temp_dir_idx:
    dta $04
temp_obj_idx:
    dta $08, $10, $20, $40, $80
turn_wait_cnt:
    dta $ff, $00, $ff, $01, $ff, $01, $ff, $00
hunger_lo:
    dta $ff
hunger_hi:
    dta $ff, $00, $02, $01
rng_seed_lo:
    dta $02
rng_seed_hi:
    dta $01
io_dev_num:
    dta $03
fillable_objs_table:
    dta $15, $34, $35, $00, $40, $40, $40, $4c, $40, $40, $3e, $43, $44, $44, $44, $44
    dta $52, $52, $52, $52, $52, $52, $43, $52, $52, $4f
dark_rooms_table:
    dta $24, $4d, $4e, $36, $3c, $2d, $24, $00, $03, $04, $02, $ff, $03, $01, $06, $06
    dta $02, $01, $01, $01, $03, $05, $07, $01
npc_move_table:
    dta $21, $07, $22, $01, $23, $01, $20, $08, $1b, $02, $1c, $02, $1d, $02, $1e, $00
    dta $1a, $04, $00
bit_mask_table:
    dta $01, $02, $04, $08, $10, $20, $40, $80
dir_adj_table:
    dta $ff, $00, $ff, $01, $ff, $01, $ff, $00, $ff, $ff
dir_noun_table:
    dta $00, $02, $02, $02, $01, $03, $03, $03, $04, $05

; =============================================================================
; $2D80-$59DF: Main Game Engine & Polish Grammar Parser
; =============================================================================
read_bank_byte:
    BANK_READ_IMPL
port_save:
    dta $38
describe_room:
    ldx #$00
L2D94:
    lda dark_rooms_table,x
    beq L2DA2
    cmp current_room
    bne L2D9F
    rts
L2D9F:
    inx
    bne L2D94
L2DA2:
    lda #$00
    sta print_hdr_flag
    sta temp_dir_idx
    sta ZP_6B
    sta ZP_6C
    RAMON
    lda $c010
    sta ZP_69
    lda $c011
    sta ZP_6A
    lda current_room
    sta ZP_6B
    asl ZP_6B
    rol ZP_6C
    asl ZP_6B
    rol ZP_6C
    lda current_room
    adc ZP_6B
    sta ZP_6B
    lda ZP_6C
    adc #$00
    sta ZP_6C
    asl ZP_6B
    rol ZP_6C
    lda ZP_69
    adc ZP_6B
    sta ZP_69
    lda ZP_6A
    adc ZP_6C
    sta ZP_6A
    lda ZP_69
    sec
    sbc #$0a
    sta ZP_69
    lda ZP_6A
    sbc #$00
    sta ZP_6A
    lda #$00
    sta gram_case
L2DFE:
    ldy temp_dir_idx
    lda (ZP_69),y
    beq L2E38
    lda ZP_69
    pha
    lda ZP_6A
    pha
    ROMON
    lda print_hdr_flag
    bne L2E20
    ldx #<msg_19d8
    ldy #>msg_19d8
    jsr print_string
    inc print_hdr_flag
L2E20:
    jsr print_direction_name
    lda #$0d
    CHROUT
    pla
    sta ZP_6A
    pla
    sta ZP_69
    RAMON
L2E38:
    inc temp_dir_idx
    lda temp_dir_idx
    cmp #$0a
    bne L2DFE
    ROMON
    rts
print_direction_name:
    ldx temp_dir_idx
    lda dir_adj_table,x
    sta cur_adj1
    lda dir_noun_table,x
    sta cur_noun
    lda #$ff
    sta cur_adj2
    jmp print_inflected_noun
print_object_name:
    jsr get_object_ptr
    ldy #$00
    jsr read_bank_byte
    sta cur_adj1
    iny
    jsr read_bank_byte
    sta cur_adj2
    iny
    jsr read_bank_byte
    sta cur_noun
    jmp print_inflected_noun
get_object_ptr:
    pha
    RAMON
    pla
    tax
    lda obj_table_ptr
    sta ZP_69
    lda $0d07
    sta ZP_6A
L2E93:
    dex
    beq L2EA6
    clc
    lda ZP_69
    adc #$08
    sta ZP_69
    lda ZP_6A
    adc #$00
    sta ZP_6A
    jmp L2E93
L2EA6:
    ROMON
    rts
L2EAD:
    lda print_hdr_flag
    bne L2EBC
    inc print_hdr_flag
    ldx #<msg_19e5
    ldy #>msg_19e5
    jsr print_string
L2EBC:
    rts
list_room_objects:
    ldx #$00
L2EBF:
    lda dark_rooms_table,x
    beq L2ECD
    cmp current_room
    bne L2ECA
    rts
L2ECA:
    inx
    bne L2EBF
L2ECD:
    lda #$00
    sta temp_obj_idx
    sta print_hdr_flag
    inc temp_obj_idx
    lda #$03
    sta gram_case
L2EDD:
    lda temp_obj_idx
    jsr get_object_ptr
    ldy #$00
    jsr read_bank_byte
    cmp #$fe
    bne L2EED
    rts
L2EED:
    ldy #$05
    jsr read_bank_byte
    and #$60
    bne L2F17
    ldy #$03
    jsr read_bank_byte
    cmp current_room
    beq L2F09
    iny
    jsr read_bank_byte
    cmp current_room
    bne L2F17
L2F09:
    jsr L2EAD
    lda temp_obj_idx
    jsr L2F1D
    lda #$0d
    CHROUT
L2F17:
    inc temp_obj_idx
    jmp L2EDD
L2F1D:
    sta $2d0c
    jsr get_object_ptr
    ldy #$06
    jsr read_bank_byte
    sta $2d0e
    lda $2d0c
    jsr print_object_name
    jsr L2FAC
    lda $2d0e
    pha
    lda $2d0c
    jsr L3006
    pla
    sta $2d0e
    and #$54
    cmp #$04
    beq L2F54
    cmp #$54
    beq L2F54
    lda $2d0e
    and #$80
    bne L2F54
    rts
L2F54:
    lda $2d0e
    bmi L2F5E
    lda #$40
    jmp L2F60
L2F5E:
    lda #$20
L2F60:
    sta $2d0e
    lda #$01
    sta $2d0b
    lda #$00
    sta $2d0d
L2F6D:
    lda $2d0b
    jsr get_object_ptr
    ldy #$00
    jsr read_bank_byte
    cmp #$fe
    bne L2F7D
    rts
L2F7D:
    ldy #$05
    jsr read_bank_byte
    and #$60
    cmp $2d0e
    bne L2FA6
    ldy #$03
    jsr read_bank_byte
    cmp $2d0c
    bne L2FA6
    jsr L305A
    lda #$20
    CHROUT
    lda #$20
    CHROUT
    lda $2d0b
    jsr print_object_name
L2FA6:
    inc $2d0b
    jmp L2F6D
L2FAC:
    lda temp_obj_idx
    jsr get_object_ptr
    ldy #$05
    jsr read_bank_byte
    and #$60
    beq L2FBC
L2FBB:
    rts
L2FBC:
    jsr read_bank_byte
    sta temp_dir_idx
    bmi L2FBB
    ldy #$03
    jsr read_bank_byte
    cmp current_room
    beq L2FEB
    iny
    jsr read_bank_byte
    cmp current_room
    bne L2FBB
    lda temp_dir_idx
    cmp #$08
    bcs L2FE6
    eor #$04
    sta temp_dir_idx
    jmp L2FEB
L2FE6:
    eor #$01
    sta temp_dir_idx
L2FEB:
    lda #$02
    sta $2c73
    lda #$00
    sta $2cb9
    jsr L3418
    lda #$05
    sta gram_case
    jsr print_direction_name
    lda #$03
    sta gram_case
    rts
L3006:
    sta $2d0c
    jsr get_object_ptr
    ldy #$06
    jsr read_bank_byte
    and #$50
    bne L3016
    rts
L3016:
    pha
    lda #$00
    sta gram_case
    lda #$0d
    CHROUT
    lda #$20
    CHROUT
    lda $2d0c
    jsr print_object_name
    lda $2c77
    cmp #$04
    bcc L303D
    ldx #<msg_1a2b
    ldy #>msg_1a2b
    jsr print_string
    jmp L3044
L303D:
    ldx #<msg_1a2f
    ldy #>msg_1a2f
    jsr print_string
L3044:
    pla
    and #$10
    beq L304C
    lda #$02
    dta $2c ; BIT abs trick to skip next 2-byte instruction
L304C:
    lda #$03
    sta $2c73
    jsr L31B4
    lda #$03
    sta gram_case
    rts
L305A:
    lda $2d0d
    beq L3064
    lda #$0d
    CHROUT_JMP
L3064:
    inc $2d0d
    lda #$0d
    CHROUT
    lda #$20
    CHROUT
    lda $2d0e
    cmp #$40
    bne L309A
    lda #$57
    CHROUT
    lda #$20
    CHROUT
    lda #$05
    sta gram_case
    lda $2d0c
    jsr print_object_name
    lda #$03
    sta gram_case
    ldx #<msg_19e6
    ldy #>msg_19e6
    jsr print_string
    rts
L309A:
    lda #$00
    sta gram_case
    lda $2d0c
    jsr print_object_name
    ldx #<str_ma
    ldy #>str_ma
    jsr print_string
    lda #$03
    sta gram_case
    rts
str_ma:
    dta c'MA:', CR, $00
L30B7:
    RAMON
    lda $c000
    sta ZP_69
    lda $c001
    sta ZP_6A
    ldx $2c73
L30CE:
    cpx #$00
    beq L30F2
    ldy #$00
L30D4:
    lda (ZP_69),y
    INCPTR ZP_69
    cmp #$3a
    bne L30D4
    INCPTR ZP_69
    INCPTR ZP_69
    dex
    bne L30CE
L30F2:
    ldy #$00
L30F4:
    lda (ZP_69),y
    cmp #$3a
    beq L30FD
    iny
    bne L30F4
L30FD:
    sty $2c76
    iny
    lda (ZP_69),y
    sta $2c75
    iny
    lda (ZP_69),y
    sta $2c77
    lda ZP_69
    sta ZP_6B
    lda ZP_6A
    sta ZP_6C
    lda $c002
    sta ZP_69
    lda $c003
    sta ZP_6A
    ldx $2c75
    dex
    cpx #$00
    beq L3138
L3126:
    ldy #$00
    lda (ZP_69),y
    INCPTR ZP_69
    cmp #$00
    bne L3126
    dex
    bne L3126
L3138:
    ldx gram_case
    ldy #$00
    cpx #$00
    beq L3153
L3141:
    lda (ZP_69),y
    INCPTR ZP_69
    cmp #$2d
    bne L3141
    dex
    bne L3141
    ldy #$00
L3153:
    lda (ZP_69),y
    cmp #$2d
    beq L315C
    iny
    bne L3153
L315C:
    tya
    clc
    adc $2c76
    sta $2c76
    lda ZP_69
    pha
    lda ZP_6A
    pha
    ROMON
    lda ZP_6B
    sta ZP_69
    lda ZP_6C
    sta ZP_6A
    sec
    GETCOL
    tya
    clc
    adc $2c76
    cmp #$25
    bcc L318A
    lda #$0d
    CHROUT
L318A:
    ldy #$00
L318C:
    jsr read_bank_byte
    cmp #$3a
    beq L3199
    CHROUT
    iny
    bne L318C
L3199:
    pla
    sta ZP_6A
    pla
    sta ZP_69
    ldy #$00
L31A1:
    jsr read_bank_byte
    cmp #$2d
    beq L31AE
    CHROUT
    iny
    bne L31A1
L31AE:
    lda #$20
    CHROUT
    rts
L31B4:
    RAMON
    lda $c004
    sta ZP_69
    lda $c005
    sta ZP_6A
    ldx $2c73
L31CB:
    cpx #$00
    beq L31E8
    ldy #$00
L31D1:
    lda (ZP_69),y
    INCPTR ZP_69
    cmp #$3a
    bne L31D1
    INCPTR ZP_69
    dex
    bne L31CB
L31E8:
    ldy #$00
L31EA:
    lda (ZP_69),y
    cmp #$3a
    beq L31F3
    iny
    bne L31EA
L31F3:
    sty $2c76
    iny
    lda (ZP_69),y
    sta $2c75
    lda ZP_69
    sta ZP_6B
    lda ZP_6A
    sta ZP_6C
    lda $c006
    sta ZP_69
    lda $c007
    sta ZP_6A
    ldx $2c75
    dex
    cpx #$00
    beq L3228
L3216:
    ldy #$00
    lda (ZP_69),y
    INCPTR ZP_69
    cmp #$00
    bne L3216
    dex
    bne L3216
L3228:
    lda $2c77
    asl @
    asl @
    asl @
    sec
    sbc $2c77
    clc
    adc gram_case
    tax
    cpx #$00
    beq L324F
    ldy #$00
L323D:
    lda (ZP_69),y
    INCPTR ZP_69
    cmp #$2d
    bne L323D
    dex
    bne L323D
    ldy #$00
L324F:
    lda (ZP_69),y
    cmp #$2d
    beq L3258
    iny
    bne L324F
L3258:
    tya
    clc
    adc $2c76
    sta $2c76
    lda ZP_69
    pha
    lda ZP_6A
    pha
    ROMON
    lda ZP_6B
    sta ZP_69
    lda ZP_6C
    sta ZP_6A
    sec
    GETCOL
    tya
    clc
    adc $2c76
    cmp #$25
    bcc L3286
    lda #$0d
    CHROUT
L3286:
    ldy #$00
L3288:
    jsr read_bank_byte
    cmp #$3a
    beq L3295
    CHROUT
    iny
    bne L3288
L3295:
    pla
    sta ZP_6A
    pla
    sta ZP_69
    ldy #$00
L329D:
    jsr read_bank_byte
    cmp #$2d
    beq L32AA
    CHROUT
    iny
    bne L329D
L32AA:
    lda #$20
    CHROUT
    rts
L32B0:
    RAMON
    lda $c000
    sta ZP_69
    lda $c001
    sta ZP_6A
    ldx $2c73
L32C7:
    cpx #$00
    beq L32EB
    ldy #$00
L32CD:
    lda (ZP_69),y
    INCPTR ZP_69
    cmp #$3a
    bne L32CD
    INCPTR ZP_69
    INCPTR ZP_69
    dex
    bne L32C7
L32EB:
    ldy #$00
L32ED:
    lda (ZP_69),y
    cmp #$3a
    beq L32F6
    iny
    bne L32ED
L32F6:
    iny
    iny
    lda (ZP_69),y
    sta $2c77
    ROMON
    rts
lookup_word:
    lda word_idx
    asl @
    asl @
    asl @
    asl @
    adc #$60
    sta ZP_69
    lda #$15
    adc #$00
    sta ZP_6A
    ldy #$11
    lda #$00
L3319:
    sta word_idx,y
    dey
    bne L3319
L331F:
    lda (ZP_69),y
    beq L332B
    sta unknown_word_buf,y
    iny
    cpy #$10
    bne L331F
L332B:
    rts
L332C:
    RAMON
    lda $c008
    sta ZP_69
    lda $c009
    sta ZP_6A
    lda #$ff
    sta $2c73
L3345:
    ldy #$00
    inc $2c73
    lda (ZP_69),y
    bne L3357
    ROMON
    lda #$ff
    rts
L3357:
    lda (ZP_69),y
    cmp unknown_word_buf,y
    bne L337D
    iny
    bne L3357
L3361:
    lda unknown_word_buf,y
    beq L3369
    jmp L337D
L3369:
    iny
    lda (ZP_69),y
    pha
    ROMON
    lda #$03
    sta word_match_buf
    pla
    sta $14fd
    rts
L337D:
    cmp #$3a
    beq L3361
    ldy #$00
L3383:
    lda (ZP_69),y
    INCPTR ZP_69
    cmp #$3a
    bne L3383
    INCPTR ZP_69
    jmp L3345
L339A:
    RAMON
    lda $c00c
    sta ZP_69
    lda $c00d
    sta ZP_6A
    lda #$ff
    sta $2c73
L33B3:
    ldy #$00
    inc $2c73
    lda (ZP_69),y
    bne L33C5
    ROMON
    lda #$ff
    rts
L33C5:
    lda (ZP_69),y
    cmp unknown_word_buf,y
    bne L33F4
    iny
    bne L33C5
L33CF:
    lda unknown_word_buf,y
    bne L33F4
    iny
    lda (ZP_69),y
    sta $14fd
    iny
    lda (ZP_69),y
    sta $14fe
    ROMON
    lda #$04
    sta word_match_buf
    lda $14fd
    beq L33F3
    inc word_match_buf
L33F3:
    rts
L33F4:
    cmp #$3a
    beq L33CF
    ldy #$00
L33FA:
    lda (ZP_69),y
    INCPTR ZP_69
    cmp #$3a
    bne L33FA
    INCPTR ZP_69
    INCPTR ZP_69
    jmp L33B3
L3418:
    RAMON
    lda $c00c
    sta ZP_69
    lda $c00d
    sta ZP_6A
L342C:
    ldy #$00
    lda (ZP_69),y
    bne L3439
    ROMON
    rts
L3439:
    ldy #$00
L343B:
    lda (ZP_69),y
    iny
    cmp #$3a
    bne L343B
    lda (ZP_69),y
    iny
    cmp $2c73
    bne L3473
    lda (ZP_69),y
    cmp $2cb9
    bne L3473
    dey
    dey
    sty $2c76
    ROMON
    jsr L34F7
    ldy #$00
L3461:
    jsr read_bank_byte
    cmp #$3a
    beq L346E
    CHROUT
    iny
    bne L3461
L346E:
    lda #$20
    CHROUT_JMP
L3473:
    tya
    sec
    adc ZP_69
    sta ZP_69
    lda ZP_6A
    adc #$00
    sta ZP_6A
    jmp L342C
L3482:
    RAMON
    lda $c00a
    sta ZP_69
    lda $c00b
    sta ZP_6A
    lda $2c73
    sta ZP_6B
    ldy #$00
    lda ZP_6B
    beq L34B4
L34A1:
    ldy #$00
    lda (ZP_69),y
    INCPTR ZP_69
    cmp #$00
    bne L34A1
    dec ZP_6B
    bne L34A1
L34B4:
    lda $2c8b
    sta ZP_6B
    lda ZP_6B
    beq L34CE
L34BD:
    lda (ZP_69),y
    INCPTR ZP_69
    cmp #$2d
    bne L34BD
    dec ZP_6B
    bne L34BD
L34CE:
    lda (ZP_69),y
    cmp #$2d
    beq L34D7
    iny
    bne L34CE
L34D7:
    sty $2c76
    ROMON
    jsr L34F7
    ldy #$00
L34E5:
    jsr read_bank_byte
    cmp #$2d
    beq L34F2
    CHROUT
    iny
    bne L34E5
L34F2:
    lda #$20
    CHROUT_JMP
L34F7:
    sec
    GETCOL
    txa
    adc $2c76
    cmp #$26
    bcs L3504
    rts
L3504:
    lda #$0d
    CHROUT_JMP
L3509:
    RAMON
    lda $c000
    sta ZP_69
    lda $c001
    sta ZP_6A
    lda #$ff
    sta $2c73
L3522:
    ldy #$00
    inc $2c73
    lda (ZP_69),y
    bne L3534
    ROMON
    lda #$ff
    rts
L3534:
    lda (ZP_69),y
    cmp #$3a
    beq L3562
    cmp unknown_word_buf,y
    bne L3542
    iny
    bne L3534
L3542:
    ldy #$00
    lda (ZP_69),y
    INCPTR ZP_69
    cmp #$3a
    bne L3542
    INCPTR ZP_69
    INCPTR ZP_69
    jmp L3522
L3562:
    sty ZP_6B
    lda #$00
    sta ZP_6C
    sta gram_case
    iny
    lda (ZP_69),y
    sta $2c75
    lda $c002
    sta ZP_61
    lda $c003
    sta ZP_62
    ldy #$00
    ldx $2c75
L3580:
    dex
    beq L3593
L3583:
    lda (ZP_61),y
    INCPTR ZP_61
    cmp #$00
    bne L3583
    jmp L3580
L3593:
    ldx ZP_6B
    ldy #$00
L3597:
    lda (ZP_61),y
    cmp #$2d
    beq L35A7
    cmp unknown_word_buf,x
    bne L35B6
    iny
    inx
    jmp L3597
L35A7:
    lda unknown_word_buf,x
    bne L35B6
    ldx gram_case
    lda bit_mask_table,x
    ora ZP_6C
    sta ZP_6C
L35B6:
    inc gram_case
    lda gram_case
    cmp #$07
    beq L35D2
    ldy #$00
L35C2:
    lda (ZP_61),y
    INCPTR ZP_61
    cmp #$2d
    bne L35C2
    jmp L3593
L35D2:
    ROMON
    ldx ZP_6C
    cpx #$00
    bne L35EB
    RAMON
    jmp L3542
L35EB:
    lda #$01
    sta word_match_buf
    lda ZP_6C
    sta $14fe
    lda $2c73
    sta $14fd
    rts
L35FC:
    RAMON
    lda $c004
    sta ZP_69
    lda $c005
    sta ZP_6A
    lda #$ff
    sta $2c73
L3615:
    ldy #$00
    inc $2c73
    lda (ZP_69),y
    bne L3627
    ROMON
    lda #$ff
    rts
L3627:
    lda (ZP_69),y
    cmp #$3a
    beq L364E
    cmp unknown_word_buf,y
    bne L3635
    iny
    bne L3627
L3635:
    ldy #$00
    lda (ZP_69),y
    INCPTR ZP_69
    cmp #$3a
    bne L3635
    INCPTR ZP_69
    jmp L3615
L364E:
    sty ZP_6B
    iny
    lda (ZP_69),y
    sta $2c75
    lda $c006
    sta ZP_61
    lda $c007
    sta ZP_62
    ldy #$00
    ldx $2c75
L3665:
    dex
    beq L3678
L3668:
    lda (ZP_61),y
    INCPTR ZP_61
    cmp #$00
    bne L3668
    jmp L3665
L3678:
    lda #$00
    sta $1556
L367D:
    lda #$00
    sta gram_case
    sta ZP_6C
L3684:
    ldx ZP_6B
    ldy #$00
L3688:
    lda (ZP_61),y
    cmp #$2d
    beq L3698
    cmp unknown_word_buf,x
    bne L36A7
    iny
    inx
    jmp L3688
L3698:
    lda unknown_word_buf,x
    bne L36A7
    ldx gram_case
    lda bit_mask_table,x
    ora ZP_6C
    sta ZP_6C
L36A7:
    inc gram_case
    lda gram_case
    cmp #$07
    beq L36C3
    ldy #$00
L36B3:
    lda (ZP_61),y
    INCPTR ZP_61
    cmp #$2d
    bne L36B3
    jmp L3684
L36C3:
    lda ZP_6C
    ldx $1556
    sta $14fe,x
    inc $1556
    lda $1556
    cmp #$06
    beq L36E7
L36D5:
    ldy #$00
    lda (ZP_61),y
    INCPTR ZP_61
    cmp #$2d
    bne L36D5
    jmp L367D
L36E7:
    lda #$00
    ldx #$00
L36EB:
    ora $14fe,x
    inx
    cpx #$06
    bne L36EB
    cmp #$00
    bne L36FA
    jmp L3635
L36FA:
    ROMON
    lda #$02
    sta word_match_buf
    lda $2c73
    sta $14fd
    rts
L370C:
    jsr L3509
    cmp #$ff
    beq L3714
    rts
L3714:
    jsr L35FC
    cmp #$ff
    beq L371C
    rts
L371C:
    jsr L332C
    cmp #$ff
    beq L3724
    rts
L3724:
    jsr L339A
    cmp #$ff
    beq L372C
    rts
L372C:
    lda #$00
    sta word_match_buf
    rts
check_word_valid:
    jsr L370C
    lda $14fd
    sta $2c73
    lda word_match_buf
    bne L3757
    ldx #<msg_1770
    ldy #>msg_1770
    jsr print_string
    ldx #<unknown_word_buf
    ldy #>unknown_word_buf
    jsr print_string
    ldx #<msg_1786
    ldy #>msg_1786
    jsr print_string
    lda #$ff
L3757:
    rts
read_input_line:
    lda #$00
    sta input_len
    ldx #<str_prompt
    ldy #>str_prompt
    jsr print_string
L3764:
    jsr get_filtered_key
    cmp #$14
    bne L377B
    lda input_len
    beq L3764
    lda #$14
    CHROUT
    dec input_len
    jmp L3764
L377B:
    cmp #$0d
    bne L3799
    lda input_len
    beq L3764
    lda #$00
    ldx input_len
    sta input_line_buf,x
    lda #$20
    CHROUT
    lda #$0d
    CHROUT
    jmp L37B6
L3799:
    ldx input_len
    cpx #$4d
    bcs L3764
    pha
    lda #$94
    CHROUT
    pla
    CHROUT
    ldy input_len
    sta input_line_buf,y
    inc input_len
    jmp L3764
L37B6:
    lda #<abbrev_str_table
    sta ZP_69
    lda #>abbrev_str_table
    sta ZP_6A
    ldx #$00
L37C0:
    cpx #$0b
    bne L37C7
    jmp L3804
L37C7:
    ldy #$00
L37C9:
    lda (ZP_69),y
    cmp input_line_buf,y
    bne L37D8
    cmp #$00
    beq L37EB
    iny
    jmp L37C9
L37D8:
    ldy #$00
    lda (ZP_69),y
    INCPTR ZP_69
    cmp #$00
    bne L37D8
    inx
    jmp L37C0
L37EB:
    txa
    asl @
    tax
    lda abbrev_ptr_table,x
    sta ZP_69
    lda $1718,x
    sta ZP_6A
    ldy #$00
L37FA:
    lda (ZP_69),y
    sta input_line_buf,y
    iny
    cmp #$00
    bne L37FA
L3804:
    rts
print_string:
    stx ZP_69
    sty ZP_6A
    ldy #$00
L380B:
    lda (ZP_69),y
    beq L3815
    CHROUT
    iny
    bne L380B
L3815:
    rts
get_filtered_key:
    inc rng_seed_lo
    GETIN
    cmp #$14
    beq L3854
    cmp #$0d
    beq L3854
    cmp #$40
    beq L3854
    cmp #$c1
    beq L3854
    cmp #$5c
    beq L3854
    cmp #$c5
    beq L3854
    cmp #$cf
    beq L3854
    cmp #$ce
    beq L3854
    cmp #$da
    beq L3854
    cmp #$c3
    beq L3854
    cmp #$d3
    beq L3854
    cmp #$20
    beq L3854
    cmp #$41
    bcc L3855
    cmp #$5b
    bcs get_filtered_key
L3854:
    rts
L3855:
    cmp #$30
    bcc get_filtered_key
    cmp #$3a
    bcs get_filtered_key
    rts
L385E:
    ldx #<str_word_too_long
    ldy #>str_word_too_long
    jsr print_string
    rts
L3866:
    lda input_line_buf
    cmp #$20
    beq L386E
    rts
L386E:
    ldx #$00
L3870:
    lda $1505,x
    sta input_line_buf,x
    inx
    cmp #$00
    bne L3870
    jmp L3866
L387E:
    lda token_count
    asl @
    asl @
    asl @
    asl @
    adc #$60
    sta ZP_69
    lda #$15
    adc #$00
    sta ZP_6A
    ldy #$00
L3891:
    lda input_line_buf
    beq L38BA
    cmp #$20
    beq L38BA
    sta (ZP_69),y
    iny
    ldx #$00
L389F:
    lda $1505,x
    sta input_line_buf,x
    inx
    cmp #$00
    bne L389F
    cpy #$10
    bne L3891
    lda input_line_buf
    beq L38BA
    cmp #$20
    beq L38BA
    lda #$01
    rts
L38BA:
    jsr L3866
    inc token_count
    lda #$00
    rts
read_and_tokenize:
    jsr read_input_line
    ldy #$00
L38C8:
    lda #$00
    sta token_table,y
    iny
    bne L38C8
    lda #$00
    sta token_count
    jsr L3866
    lda input_line_buf
    beq read_and_tokenize
    lda #$00
    sta token_count
L38E2:
    jsr L387E
    beq L38ED
    jsr L385E
    jmp read_and_tokenize
L38ED:
    lda token_count
    cmp #$10
    bne L3900
    lda input_line_buf
    beq L38FF
    jsr L3906
    jmp read_and_tokenize
L38FF:
    rts
L3900:
    lda input_line_buf
    bne L38E2
    rts
L3906:
    ldx #<str_sentence_too_long
    ldy #>str_sentence_too_long
    jmp print_string
L390D:
    lda word_idx
    asl @
    asl @
    asl @
    tax
    ldy #$00
L3916:
    lda parsed_words_buf,x
    sta word_match_buf,y
    inx
    iny
    cpy #$10
    bne L3916
    lda word_match_buf
    rts
parse_clause:
    jsr L390D
    cmp #$03
    bne L3944
    ldx clause_idx
    lda #$01
    sta $2c90,x
    lda $14fd
    sta $2c98,x
    inc word_idx
    inc clause_idx
    lda #$00
    rts
L3944:
    ldx clause_idx
    lda #$02
    sta $2c90,x
    lda #$ff
    sta $2c98,x
    lda word_match_buf
    cmp #$05
    bne L3972
    lda $14fd
    sta $2c98,x
    lda $14fe
    sta $2ca0,x
    inc word_idx
    lda word_idx
    cmp token_count
    bcc L3972
    lda #$ff
    rts
L3972:
    ldx clause_idx
    lda $2cca
    sta $2cba,x
    lda #$ff
    sta $2cb8
L3980:
    jsr L39DF
    bpl L3986
    rts
L3986:
    ldx $2cca
    lda cur_adj1
    sta $2ccb,x
    lda cur_adj2
    sta $2cdb,x
    lda cur_noun
    sta $2ceb,x
    inc $2cca
    ldx clause_idx
    lda $2cca
    sec
    sbc $2cba,x
    sta $2cc2,x
    lda word_idx
    cmp token_count
    bcc L39C6
L39B3:
    lda #$00
    sta gram_case
    inc clause_idx
    lda $2cb8
    bne L39C3
    lda #$ff
    rts
L39C3:
    lda #$00
    rts
L39C6:
    jsr L390D
    lda word_match_buf
    cmp #$04
    bne L39B3
    inc word_idx
    lda word_idx
    cmp token_count
    bcs L39E7
    jmp L3980
    dta $00
L39DF:
    lda word_idx
    cmp token_count
    bcc L39EA
L39E7:
    lda #$ff
    rts
L39EA:
    jsr L390D
    lda #$ff
    sta cur_adj1
    sta cur_adj2
    ldx #$00
L39F7:
    sta $2ca8,x
    inx
    cpx #$06
    bne L39F7
    lda word_match_buf
    cmp #$01
    beq L3A67
    cmp #$02
    bne L39E7
    lda $14fd
    sta cur_adj1
    ldx #$00
L3A12:
    lda $2ca8,x
    and $14fe,x
    sta $2ca8,x
    inx
    cpx #$06
    bne L3A12
    inc word_idx
    lda word_idx
    cmp token_count
    bcs L39E7
    jsr L390D
    lda word_match_buf
    cmp #$01
    beq L3A67
    cmp #$02
    bne L39E7
    lda $14fd
    sta cur_adj2
    ldx #$00
L3A41:
    lda $2ca8,x
    and $14fe,x
    sta $2ca8,x
    inx
    cpx #$06
    bne L3A41
    inc word_idx
    lda word_idx
    cmp token_count
    bcs L39E7
    jsr L390D
    lda word_match_buf
    cmp #$01
    beq L3A67
    jmp L39E7
L3A67:
    lda $14fd
    sta cur_noun
    lda $14fe
    and $2cb8
    sta $2cb8
    lda cur_noun
    sta $2c73
    jsr L32B0
    ldx #$00
L3A81:
    cpx $2c77
    bne L3A8F
    lda $2cb8
    and $2ca8,x
    sta $2cb8
L3A8F:
    inx
    cpx #$06
    bne L3A81
    inc word_idx
    lda #$00
    rts
print_inflected_noun:
    lda cur_noun
    sta $2c73
    jsr L32B0
    lda $2c77
    lda cur_adj1
    cmp #$ff
    beq L3AC0
    sta $2c73
    jsr L31B4
    lda cur_adj2
    cmp #$ff
    beq L3AC0
    sta $2c73
    jsr L31B4
L3AC0:
    lda cur_noun
    sta $2c73
    sta $2c8a
    jmp L30B7
load_room_exits:
    pha
    ldx #<msg_18a0
    ldy #>msg_18a0
    jsr print_string
    lda #<room_desc_table
    sta ZP_69
    lda #>room_desc_table
    sta ZP_6A
    ldy #$00
    pla
    tax
L3AE0:
    dex
    beq L3AF5
    ldy #$00
L3AE5:
    lda (ZP_69),y
    INCPTR ZP_69
    cmp #$00
    beq L3AE0
    jmp L3AE5
L3AF5:
    lda (ZP_69),y
    iny
    CHROUT
    cmp #$00
    bne L3AF5
    lda #$0d
    CHROUT_JMP
L3B04:
    ldy #$00
    jsr read_bank_byte
    sta $1481
    iny
    jsr read_bank_byte
    sta $1482
    iny
    jsr read_bank_byte
    cmp cur_noun
    beq L3B1F
    lda #$01
    rts
L3B1F:
    lda cur_adj1
    cmp #$ff
    bne L3B29
L3B26:
    lda #$00
    rts
L3B29:
    cmp $1481
    bne L3B3D
    lda cur_adj2
    cmp #$ff
    beq L3B26
    cmp $1482
    beq L3B26
    lda #$01
    rts
L3B3D:
    cmp $1482
    bne L3B4E
    lda cur_adj2
    cmp #$ff
    beq L3B26
    cmp $1481
    beq L3B26
L3B4E:
    lda #$01
    rts
L3B51:
    sta $1483
    lda #$01
    sta temp_obj_idx
    lda #$00
    sta $1484
L3B5E:
    lda temp_obj_idx
    jsr get_object_ptr
    ldy #$00
    jsr read_bank_byte
    cmp #$fe
    bne L3B6E
    rts
L3B6E:
    jsr L3B04
    cmp #$00
    beq L3B78
    jmp L3C92
L3B78:
    lda $1483
    and #$01
    beq L3BA1
    ldy #$05
    jsr read_bank_byte
    and #$60
    bne L3BA1
    ldy #$03
    jsr read_bank_byte
    cmp current_room
    bne L3B95
    jmp L3C89
L3B95:
    iny
    jsr read_bank_byte
    cmp current_room
    bne L3BA1
    jmp L3C89
L3BA1:
    lda $1483
    and #$02
    beq L3BBE
    ldy #$05
    jsr read_bank_byte
    and #$20
    beq L3BBE
    ldy #$03
    jsr read_bank_byte
    cmp cmd_verb_arg1
    bne L3BBE
    jmp L3C89
L3BBE:
    lda $1483
    and #$04
    beq L3C07
    ldy #$05
    jsr read_bank_byte
    and #$20
    beq L3C07
    ldy #$03
    jsr read_bank_byte
    cmp cmd_verb_arg1
    beq L3C07
    cmp #$ff
    beq L3C07
    jsr get_object_ptr
    ldy #$05
    jsr read_bank_byte
    and #$60
    bne L3C07
    ldy #$03
    jsr read_bank_byte
    cmp current_room
    beq L3BFB
    iny
    jsr read_bank_byte
    cmp current_room
    bne L3C07
L3BFB:
    ldy #$06
    jsr read_bank_byte
    and #$08
    beq L3C07
    jmp L3C89
L3C07:
    lda temp_obj_idx
    jsr get_object_ptr
    lda $1483
    and #$08
    beq L3C58
    ldy #$05
    jsr read_bank_byte
    and #$40
    beq L3C58
    ldy #$03
    jsr read_bank_byte
    cmp cmd_verb_arg1
    beq L3C58
    cmp #$ff
    beq L3C58
    jsr get_object_ptr
    ldy #$05
    jsr read_bank_byte
    and #$60
    bne L3C58
    ldy #$03
    jsr read_bank_byte
    cmp current_room
    beq L3C4A
    iny
    jsr read_bank_byte
    cmp current_room
    bne L3C58
L3C4A:
    ldy #$06
    jsr read_bank_byte
    and #$50
    cmp #$40
    beq L3C58
    jmp L3C89
L3C58:
    lda temp_obj_idx
    jsr get_object_ptr
    lda $1483
    and #$10
    beq L3C92
    ldy #$05
    jsr read_bank_byte
    and #$60
    beq L3C92
    ldy #$03
    jsr read_bank_byte
    cmp cmd_prep
    bne L3C92
    lda cmd_prep
    jsr get_object_ptr
    ldy #$06
    jsr read_bank_byte
    and #$50
    cmp #$40
    beq L3C92
L3C89:
    inc $1484
    lda temp_obj_idx
    sta $2d0b
L3C92:
    inc temp_obj_idx
    jmp L3B5E
L3C98:
    lda cmd_verb_id
    cmp #$00
    bne L3CA2
L3C9F:
    lda #$ff
    rts
L3CA2:
    cmp #$01
    beq L3C9F
    cmp #$02
    beq L3C9F
    cmp #$03
    bne L3CB9
    lda #<syntax_rule_0
    sta ZP_69
    lda #>syntax_rule_0
    sta ZP_6A
    jmp L3D1A
L3CB9:
    cmp #$04
    bne L3CC8
    lda #<syntax_rule_1
    sta ZP_69
    lda #>syntax_rule_1
    sta ZP_6A
    jmp L3D1A
L3CC8:
    cmp #$05
    bne L3CD7
    lda #<syntax_rule_2
    sta ZP_69
    lda #>syntax_rule_2
    sta ZP_6A
    jmp L3D1A
L3CD7:
    cmp #$07
    bne L3CE6
L3CDB:
    lda #<syntax_rule_3
    sta ZP_69
    lda #>syntax_rule_3
    sta ZP_6A
    jmp L3D1A
L3CE6:
    cmp #$08
    beq L3CDB
    cmp #$09
    beq L3CDB
    cmp #$06
    bne L3CF5
L3CF2:
    lda #$ff
    rts
L3CF5:
    cmp #$0a
    beq L3CF2
    cmp #$0b
    beq L3D01
    cmp #$0c
    bne L3D0C
L3D01:
    lda #<syntax_rule_4
    sta ZP_69
    lda #>syntax_rule_4
    sta ZP_6A
    jmp L3D1A
L3D0C:
    cmp #$0d
    bne L3D13
L3D10:
    lda #$ff
    rts
L3D13:
    cmp #$0e
    beq L3D10
    lda #$ff
    rts
L3D1A:
    ldx #$00
L3D1C:
    lda $2cc2,x
    cmp #$01
    bne L3D2D
    lda $2c90,x
    cmp #$02
    bne L3D2D
    jmp L3D36
L3D2D:
    inx
    cpx clause_idx
    bne L3D1C
    jmp L3C9F
L3D36:
    ldy #$00
L3D38:
    lda (ZP_69),y
    cmp #$fe
    beq L3D2D
    cmp $2c98,x
    bne L3D4C
    iny
    lda (ZP_69),y
    dey
    and $2cb0,x
    bne L3D51
L3D4C:
    iny
    iny
    jmp L3D38
L3D51:
    lda $2c98,x
    sta $1485
    lda $2ca0,x
    sta $1486
    lda #$00
    sta $2c90,x
    lda $2cb0,x
    sta $1486
    lda $2cba,x
    tax
    lda $2ceb,x
    sta $1489
    lda $2ccb,x
    sta $1487
    lda $2cdb,x
    sta $1488
    lda #$00
    rts
L3D81:
    lda cmd_verb_arg1
    cmp #$ff
    bne L3D89
    rts
L3D89:
    lda #$9f
    CHROUT
    lda #$00
    sta gram_case
    lda cmd_verb_arg1
    jsr print_object_name
    lda #$01
    sta $2c8b
    lda #$06
    sta $2c73
    jsr L3482
    lda #$3a
    CHROUT
    lda #$0d
    CHROUT
    lda #$20
    CHROUT_JMP
L3DB5:
    sta $14a6
    ldx #$00
    stx clause_idx
L3DBD:
    lda clause_idx
    cmp cmd_obj_count
    bcc L3DC8
    lda #$00
    rts
L3DC8:
    tax
    lda $148a,x
    sta cur_adj1
    lda $1492,x
    sta cur_adj2
    lda $149a,x
    sta cur_noun
    lda $14a6
    jsr L3B51
    lda $1484
    cmp #$01
    bne L3DF7
    ldx clause_idx
    lda $2d0b
    sta cmd_obj_list,x
    inc clause_idx
    jmp L3DBD
L3DF7:
    jsr L3F44
    lda #$ff
    rts
L3DFD:
    lda #$9f
    CHROUT
    lda #$0d
    CHROUT
    lda cmd_verb_arg1
    cmp #$ff
    beq L3E1C
    lda #$00
    sta gram_case
    lda cmd_verb_arg1
    jsr print_object_name
    lda #$01
    dta $2c ; BIT abs trick to skip next 2-byte instruction
L3E1C:
    lda #$00
    sta $2c8b
    lda cmd_verb_id
    sta $2c73
    jsr L3482
    lda cmd_obj_count
    bne L3E30
    rts
L3E30:
    ldx clause_idx
    lda cmd_obj_list,x
    sta temp_obj_idx
    lda $14a3
    cmp #$ff
    beq L3E4C
    sta $2c73
    lda $14a4
    sta $2cb9
    jsr L3418
L3E4C:
    lda $14a2
    jsr L3F2A
    lda temp_obj_idx
    jsr L3E7F
L3E58:
    lda cmd_prep
    cmp #$ff
    bne L3E60
    rts
L3E60:
    lda $1485
    cmp #$ff
    beq L3E72
    sta $2c73
    lda #$00
    sta $2cb9
    jsr L3418
L3E72:
    lda $1486
    jsr L3F2A
    lda cmd_prep
    jsr print_object_name
    rts
L3E7F:
    cmp #$f0
    bcs L3E86
    jmp print_object_name
L3E86:
    and #$0f
    sta temp_dir_idx
    jmp print_direction_name
L3E8E:
    lda cur_adj2
    cmp #$ff
    beq L3E98
    lda #$ff
    rts
L3E98:
    ldx #$00
L3E9A:
    lda dir_adj_table,x
    cmp cur_adj1
    bne L3EAC
    lda dir_noun_table,x
    cmp cur_noun
    bne L3EAC
    txa
    rts
L3EAC:
    inx
    cpx #$0a
    bcc L3E9A
    lda #$ff
    rts
L3EB4:
    lda #$0d
    CHROUT
    jsr L3D81
    lda #$9f
    CHROUT
    lda cmd_verb_arg1
    cmp #$ff
    beq L3ED2
    ldx #<msg_1834
    ldy #>msg_1834
    jsr print_string
    jmp L3ED9
L3ED2:
    ldx #<msg_183f
    ldy #>msg_183f
    jsr print_string
L3ED9:
    lda cmd_verb_id
    sta $2c73
    lda #$02
    sta $2c8b
    jsr L3482
    lda cmd_obj_count
    bne L3EED
    rts
L3EED:
    ldx clause_idx
    lda cmd_obj_list,x
    sta temp_obj_idx
    lda $14a3
    cmp #$ff
    beq L3F0C
    sta $2c73
    lda $14a4
    sta $2cb9
    jsr L3418
    jmp L3F1B
L3F0C:
    lda $14a2
    and #$08
    beq L3F1B
    lda #$01
    sta gram_case
    jmp L3F21
L3F1B:
    lda $14a2
    jsr L3F2A
L3F21:
    lda temp_obj_idx
    jsr print_object_name
    jmp L3E58
L3F2A:
    ldx #$00
    sta ZP_69
L3F2E:
    lda ZP_69
    and bit_mask_table,x
    beq L3F39
    stx gram_case
    rts
L3F39:
    inx
    cpx #$06
    bne L3F2E
    lda #$00
    sta gram_case
    rts
L3F44:
    lda $1484
    cmp #$01
    bne L3F4E
    lda #$00
    rts
L3F4E:
    lda cur_noun
    pha
    lda cur_adj1
    pha
    lda cur_adj2
    pha
    jsr L3D81
    pla
    sta cur_adj2
    pla
    sta cur_adj1
    pla
    sta cur_noun
    lda $1484
    beq L3F80
    ldx #<msg_180e
    ldy #>msg_180e
    jsr print_string
    lda #$03
    sta gram_case
    jsr print_inflected_noun
    lda #$ff
    rts
L3F80:
    lda cmd_verb_arg1
    cmp #$ff
    beq L3F91
    ldx #<msg_1828
    ldy #>msg_1828
    jsr print_string
    jmp L3F98
L3F91:
    ldx #<msg_181a
    ldy #>msg_181a
    jsr print_string
L3F98:
    lda #$01
    sta gram_case
    jsr print_inflected_noun
    lda #$ff
    rts
L3FA3:
    pha
    RAMON
    lda $c010
    sta ZP_69
    lda $c011
    sta ZP_6A
    ROMON
    pla
    tax
L3FC0:
    dex
    beq L3FD3
    clc
    lda ZP_69
    adc #$0a
    sta ZP_69
    lda ZP_6A
    adc #$00
    sta ZP_6A
    jmp L3FC0
L3FD3:
    rts
get_random_byte:
    ldy #$0f
L3FD6:
    lda rng_seed_hi
    and #$a4
    sta ZP_69
    ldx #$08
    lda #$00
L3FE1:
    lsr ZP_69
    adc #$00
    dex
    bne L3FE1
    and #$01
    eor #$01
    lsr @
    rol rng_seed_lo
    rol rng_seed_hi
    dey
    bne L3FD6
    lda rng_seed_lo
    rts
L3FFA:
    lda $2d10
    bpl L4000
    rts
L4000:
    lda current_room
    cmp #$03
    bne L403F
    lda $2d10
    and #$01
    bne L4035
    inc $2d10
    lda #$0d
    CHROUT
    lda #$0b
    sta cmd_verb_arg1
    jsr L3D81
    ldx #<msg_18b2
    ldy #>msg_18b2
    jsr print_string
    lda #$0a
    sta cmd_verb_arg1
    jsr L3D81
    ldx #<msg_18d4
    ldy #>msg_18d4
    jsr print_string
    rts
L4035:
    ldx #<msg_18fe
    ldy #>msg_18fe
    jsr print_string
    jmp ask_play_again
L403F:
    cmp #$04
    beq L4044
    rts
L4044:
    lda $2d10
    and #$02
    bne L405C
    lda $2d10
    and #$01
    bne L4053
    rts
L4053:
    lda #$02
    ora $2d10
    sta $2d10
    rts
L405C:
    lda #$0a
    jsr L4094
    lda #$0b
    jsr L4094
    ldx #<msg_1953
    ldy #>msg_1953
    jsr print_string
    lda #$80
    sta $2d10
    lda #$17
    jsr get_object_ptr
    RAMON
    ldy #$05
    lda #$80
    sta (ZP_69),y
    ldy #$03
    lda #$03
    sta (ZP_69),y
    ROMON
    rts
L4094:
    jsr get_object_ptr
    RAMON
    ldy #$00
    lda (ZP_69),y
    iny
    sta (ZP_69),y
    dey
    lda #$12
    sta (ZP_69),y
    ROMON
    rts
L40B4:
    jsr get_object_ptr
    ldy #$00
L40B9:
    jsr read_bank_byte
    cmp #$11
    beq L40CC
    cmp #$12
    beq L40CC
    iny
    cpy #$02
    bne L40B9
    lda #$00
    rts
L40CC:
    lda #$01
    rts
L40CF:
    lda #$05
    jsr L40B4
    cmp #$00
    beq L40D9
    rts
L40D9:
    lda #$05
    jsr get_object_ptr
    ldy #$03
    jsr read_bank_byte
    sta $14a5
    cmp current_room
    beq L4123
    inc $14a5
    lda $14a5
    and #$03
    ora #$0c
    sta $14a5
    RAMON
    ldy #$03
    lda $14a5
    sta (ZP_69),y
    ROMON
    lda $14a5
    cmp current_room
    beq L4118
    rts
L4118:
    lda #$05
    jsr L4883
    lda #$01
    sta $2d11
    rts
L4123:
    inc $2d11
    lda $2d11
    cmp #$04
    bcs L4135
    ldx #<msg_1b54
    ldy #>msg_1b54
    jsr print_string
    rts
L4135:
    ldx #<msg_1b73
    ldy #>msg_1b73
    jsr print_string
    jmp ask_play_again
L413F:
    lda #$31
    jsr L40B4
    cmp #$00
    beq L4149
    rts
L4149:
    lda #$31
    jsr get_object_ptr
    ldy #$03
    jsr read_bank_byte
    sta $14a5
    cmp current_room
    beq L415C
    rts
L415C:
    inc $2d14
    lda $2d14
    cmp #$06
    bcs L416E
    ldx #<msg_1b9b
    ldy #>msg_1b9b
    jsr print_string
    rts
L416E:
    ldx #<msg_1bb5
    ldy #>msg_1bb5
    jsr print_string
    jmp ask_play_again
L4178:
    lda #$11
    jsr get_object_ptr
    ldy #$03
    jsr read_bank_byte
    cmp #$ff
    rts
L4185:
    jsr L4178
    bne L41AB
    lda #$22
    jsr get_object_ptr
    RAMON
    ldy #$03
    lda #$2c
    sta (ZP_69),y
    lda #$2e
    iny
    sta (ZP_69),y
    ROMON
    rts
L41AB:
    lda #$22
    jsr get_object_ptr
    RAMON
    ldy #$03
    lda #$00
    sta (ZP_69),y
    iny
    sta (ZP_69),y
    ROMON
    rts
L41CA:
    lda #$33
    jsr get_object_ptr
    ldy #$03
    jsr read_bank_byte
    cmp #$ff
    bne L41D9
    rts
L41D9:
    lda current_room
    cmp #$34
    beq L41E1
    rts
L41E1:
    lda #$38
    sta current_room
    lda #$01
    jsr get_object_ptr
    ldy #$03
    jsr read_bank_byte
    cmp #$34
    bne L420A
    RAMON
    lda #$39
    ldy #$03
    sta (ZP_69),y
    ROMON
L420A:
    ldx #<msg_1d32
    ldy #>msg_1d32
    jsr print_string
    pla
    pla
    jmp room_loop
L4216:
    lda current_room
    cmp #$3b
    beq L421E
    rts
L421E:
    jsr get_random_byte
    and #$01
    beq L4226
    rts
L4226:
    ldx #<msg_1ea6
    ldy #>msg_1ea6
    jsr print_string
    rts
L422E:
    lda $2d1a
    beq L4252
L4233:
    lda #$03
    jsr get_object_ptr
    RAMON
    ldy #$03
    lda #$00
    sta (ZP_69),y
    iny
    sta (ZP_69),y
    ROMON
    rts
L4252:
    lda #$03
    jsr get_object_ptr
    ldy #$03
    jsr read_bank_byte
    cmp #$06
    bne L4233
    cmp current_room
    beq L4266
L4265:
    rts
L4266:
    lda $2d1b
    beq L4265
    lda #$15
    jsr get_object_ptr
    ldy #$03
    jsr read_bank_byte
    cmp #$03
    bne L4265
    ldy #$05
    jsr read_bank_byte
    and #$60
    beq L4265
    RAMON
    ldy #$03
    lda #$ff
    sta (ZP_69),y
    ldy #$05
    lda #$20
    sta (ZP_69),y
    ROMON
    ldx #<msg_1a5a
    ldy #>msg_1a5a
    jsr print_string
    rts
L42A6:
    lda $2d1a
    beq L42AC
    rts
L42AC:
    lda #$33
    jsr get_object_ptr
    ldy #$03
    jsr read_bank_byte
    cmp #$ff
    bne L42BD
    inc $2d1a
L42BD:
    rts
L42BE:
    lda $2d12
    beq L42C6
    jmp L4326
L42C6:
    lda current_room
    cmp #$27
    bne L42FA
    lda #$34
    jsr get_object_ptr
    ldy #$03
    jsr read_bank_byte
    cmp #$04
    beq L42DC
    rts
L42DC:
    RAMON
    ldy #$03
    lda #$ff
    sta (ZP_69),y
    ROMON
    ldx #<msg_2121
    ldy #>msg_2121
    jsr print_string
    rts
L42FA:
    jsr get_random_byte
    and #$03
    beq L4302
    rts
L4302:
    lda current_room
    cmp #$26
    beq L430A
    rts
L430A:
    lda #$21
    jsr get_object_ptr
    ldy #$06
    jsr read_bank_byte
    and #$10
    beq L4319
    rts
L4319:
    lda #$0d
    CHROUT
    lda #$04
    ldx #$21
    jsr L47B1
    rts
L4326:
    lda current_room
    cmp #$27
    beq L432E
    rts
L432E:
    ldx #<msg_1f9a
    ldy #>msg_1f9a
    jsr print_string
    jmp ask_play_again
L4338:
    lda #$02
    jsr get_object_ptr
    ldy #$03
    jsr read_bank_byte
    sta $14a5
    cmp current_room
    beq L434B
    rts
L434B:
    lda #$33
    jsr get_object_ptr
    ldy #$05
    jsr read_bank_byte
    and #$60
    beq L4365
    ldy #$03
    jsr read_bank_byte
    cmp #$02
    bne L4365
    jmp L599D
L4365:
    jsr get_random_byte
    and #$03
    beq L436D
    rts
L436D:
    ldx #<msg_205e
    ldy #>msg_205e
    jsr print_string
    rts
L4375:
    lda #$01
    jsr get_object_ptr
    ldy #$03
    jsr read_bank_byte
    sta $14a5
    lda turn_wait_cnt
    bne L43FF
    lda $14a5
    cmp current_room
    beq L43FF
    lda current_room
    cmp #$13
    beq L43DB
    lda $14a5
    jsr L3FA3
    ldy #$00
L439E:
    jsr read_bank_byte
    cmp current_room
    beq L43AE
    iny
    cpy #$0a
    bne L439E
    jmp L43FF
L43AE:
    sty temp_dir_idx
    jsr L4829
    cmp #$ff
    beq L43DB
    sta temp_obj_idx
    jsr get_object_ptr
    ldy #$06
    jsr read_bank_byte
    and #$20
    beq L43FF
    jsr read_bank_byte
    and #$50
    cmp #$40
    bne L43DB
    lda #$01
    ldx temp_obj_idx
    jsr L47B1
    jmp L43FF
L43DB:
    lda #$01
    jsr get_object_ptr
    RAMON
    lda current_room
    ldy #$03
    sta (ZP_69),y
    sta $14a5
    ROMON
    lda #$01
    jsr L4883
L43FF:
    lda turn_wait_cnt
    beq L4407
    dec turn_wait_cnt
L4407:
    lda #$14
    jsr get_object_ptr
    ldy #$05
    jsr read_bank_byte
    and #$20
    beq L4448
    ldy #$03
    jsr read_bank_byte
    cmp #$ff
    bne L4448
    lda $14a5
    cmp current_room
    bne L4448
    ldx #<msg_1eeb
    ldy #>msg_1eeb
    jsr print_string
    lda #$14
    jsr get_object_ptr
    RAMON
    ldy #$03
    lda #$01
    sta (ZP_69),y
    ROMON
L4448:
    lda #$14
    jsr get_object_ptr
    ldy #$05
    jsr read_bank_byte
    and #$60
    bne L448B
    ldy #$03
    jsr read_bank_byte
    cmp $14a5
    bne L448B
    RAMON
    lda #$20
    ldy #$05
    sta (ZP_69),y
    lda #$01
    ldy #$03
    sta (ZP_69),y
    ROMON
    lda current_room
    cmp $14a5
    bne L448B
    ldx #<msg_1eeb
    ldy #>msg_1eeb
    jsr print_string
L448B:
    lda current_room
    cmp $14a5
    bne L44C8
    lda #$33
    jsr get_object_ptr
    ldy #$03
    jsr read_bank_byte
    cmp #$ff
    bne L44C8
    lda turn_wait_cnt
    bne L44C8
    ldx #<msg_22d9
    ldy #>msg_22d9
    jsr print_string
    lda #$01
    jsr get_object_ptr
    RAMON
    ldy #$03
    lda #$00
    sta (ZP_69),y
    ROMON
L44C8:
    rts
L44C9:
    lda #$11
    jsr get_object_ptr
    ldy #$03
    jsr read_bank_byte
    cmp #$ff
    bne L44D8
    rts
L44D8:
    lda current_room
    cmp #$12
    bne L44FA
    ldx #<msg_1966
    ldy #>msg_1966
    jsr print_string
    lda #$13
    sta current_room
    jsr get_random_byte
    and #$07
    ora #$08
    sta turn_wait_cnt
    pla
    pla
    jmp room_loop
L44FA:
    lda #$06
    sta $14a7
L44FF:
    lda $14a7
    jsr get_object_ptr
    ldy #$03
    jsr read_bank_byte
    sta $14a5
    jsr get_random_byte
    jmp L4519
L4513:
    inc temp_dir_idx
    lda temp_dir_idx
L4519:
    and #$07
    sta temp_dir_idx
    lda $14a5
    jsr L3FA3
    ldy temp_dir_idx
    jsr read_bank_byte
    cmp #$14
    bcc L4513
    cmp #$20
    bcs L4513
    lda $14a5
    cmp current_room
    bne L455E
    lda #$0d
    CHROUT
    lda #$9f
    CHROUT
    lda #$00
    sta gram_case
    lda $14a7
    jsr print_object_name
    ldx #<msg_19b1
    ldy #>msg_19b1
    jsr print_string
    lda #$03
    sta gram_case
    jsr print_direction_name
L455E:
    lda $14a5
    jsr L3FA3
    ldy temp_dir_idx
    jsr read_bank_byte
    sta $14a5
    lda $14a7
    jsr get_object_ptr
    RAMON
    ldy #$03
    lda $14a5
    sta (ZP_69),y
    ROMON
    lda $14a5
    cmp current_room
    bne L4598
    lda $14a7
    jsr L4883
L4598:
    inc $14a7
    lda $14a7
    cmp #$0a
    bne L45A3
    rts
L45A3:
    jmp L44FF
L45A6:
    lda $2d19
    bne L45AC
    rts
L45AC:
    lda #$0d
    jsr get_object_ptr
    ldy #$03
    jsr read_bank_byte
    sta $14a5
    lda #$0e
    jsr get_object_ptr
    ldy #$03
    jsr read_bank_byte
    cmp $14a5
    beq L45C9
    rts
L45C9:
    RAMON
    ldy #$03
    lda #$00
    sta (ZP_69),y
    ROMON
    lda $14a5
    cmp current_room
    bne L45EF
    ldx #<msg_223d
    ldy #>msg_223d
    jsr print_string
    rts
L45EF:
    ldx #<msg_225e
    ldy #>msg_225e
    jsr print_string
    rts
L45F7:
    lda #$0d
    jsr get_object_ptr
    ldy #$03
    jsr read_bank_byte
    sta $14a5
    cmp current_room
    bne L460C
    jmp L4695
L460C:
    jsr get_random_byte
    jmp L4618
L4612:
    inc temp_dir_idx
    lda temp_dir_idx
L4618:
    and #$07
    sta temp_dir_idx
    lda $14a5
    jsr L3FA3
    ldy temp_dir_idx
    jsr read_bank_byte
    cmp #$3d
    bcc L4612
    cmp #$49
    bcs L4612
L4631:
    lda $14a5
    cmp current_room
    bne L465C
    lda #$0d
    CHROUT
    lda #$9f
    CHROUT
    lda #$00
    sta gram_case
    lda #$0d
    jsr print_object_name
    ldx #<msg_19b1
    ldy #>msg_19b1
    jsr print_string
    lda #$03
    sta gram_case
    jsr print_direction_name
L465C:
    lda $14a5
    jsr L3FA3
    ldy temp_dir_idx
    jsr read_bank_byte
    sta $14a5
    lda #$0d
    jsr get_object_ptr
    RAMON
    ldy #$03
    lda $14a5
    sta (ZP_69),y
    ROMON
    lda $14a5
    cmp current_room
    bne L4694
    lda #$0d
    jsr L4883
L4694:
    rts
L4695:
    ldx $14a5
    lda $2d04,x
    sta temp_dir_idx
    lda $2d13
    bne L46CD
    ldx #<msg_2025
    ldy #>msg_2025
    jsr print_string
    inc $2d13
    lda #$29
    jsr get_object_ptr
    RAMON
    ldy #$03
    lda #$40
    sta (ZP_69),y
    iny
    lda #$4c
    sta (ZP_69),y
    ROMON
L46CD:
    lda temp_dir_idx
    bmi L46D5
    jmp L4631
L46D5:
    rts
L46D6:
    lda #$0f
    jsr get_object_ptr
    ldy #$03
    jsr read_bank_byte
    sta $14a5
    jmp L474A
L46E6:
    lda $14a5
    cmp current_room
    bne L4711
    lda #$0d
    CHROUT
    lda #$9f
    CHROUT
    lda #$00
    sta gram_case
    lda #$0f
    jsr print_object_name
    ldx #<msg_19b1
    ldy #>msg_19b1
    jsr print_string
    lda #$03
    sta gram_case
    jsr print_direction_name
L4711:
    lda $14a5
    jsr L3FA3
    ldy temp_dir_idx
    jsr read_bank_byte
    sta $14a5
    lda #$0f
    jsr get_object_ptr
    RAMON
    ldy #$03
    lda $14a5
    sta (ZP_69),y
    ROMON
    lda $14a5
    cmp current_room
    bne L4749
    lda #$0f
    jsr L4883
L4749:
    rts
L474A:
    jsr L4178
    bne L476B
    lda $2d16
    bne L4786
    lda current_room
    cmp $14a5
    bne L476B
    lda #$01
    sta $2d16
    ldx #<msg_1c98
    ldy #>msg_1c98
    jsr print_string
    jmp L4786
L476B:
    lda $2d16
    bne L4786
    ldx $14a5
    cpx #$20
    bcs L4778
    rts
L4778:
    cpx #$25
    bcc L477D
    rts
L477D:
    lda $2d2d,x
    sta temp_dir_idx
    jmp L46E6
L4786:
    lda $14a5
    cmp current_room
    beq L478F
    rts
L478F:
    lda #<npc_move_table
    sta ZP_69
    lda #>npc_move_table
    sta ZP_6A
    ldy #$00
L4799:
    lda (ZP_69),y
    bne L479E
    rts
L479E:
    cmp $14a5
    bne L47AC
    iny
    lda (ZP_69),y
    sta temp_dir_idx
    jmp L46E6
L47AC:
    iny
    iny
    jmp L4799
L47B1:
    stx cmd_obj_list
    sta cmd_verb_arg1
    lda cmd_obj_list
    jsr get_object_ptr
    ldy #$07
    jsr read_bank_byte
    cmp #$ff
    beq L47C7
    rts
L47C7:
    RAMON
    ldy #$06
    lda (ZP_69),y
    ora #$10
    sta (ZP_69),y
    ROMON
    lda $14a5
    cmp current_room
    beq L4805
    ldy #$03
    jsr read_bank_byte
    cmp current_room
    beq L47FB
    iny
    jsr read_bank_byte
    cmp current_room
    beq L47FB
    rts
L47FB:
    ldx #<msg_1a02
    ldy #>msg_1a02
    jsr print_string
    jmp L4810
L4805:
    lda #$00
    sta gram_case
    lda cmd_verb_arg1
    jsr print_object_name
L4810:
    lda #$01
    sta $2c8b
    lda #$07
    sta $2c73
    jsr L3482
    lda #$03
    sta gram_case
    lda cmd_obj_list
    jsr print_object_name
    rts
L4829:
    lda #$01
    sta temp_obj_idx
L482E:
    lda temp_obj_idx
    jsr get_object_ptr
    ldy #$00
    jsr read_bank_byte
    cmp #$fe
    beq L4880
    ldy #$05
    jsr read_bank_byte
    and #$60
    bne L487A
    ldy #$03
    jsr read_bank_byte
    cmp $14a5
    beq L486C
    iny
    jsr read_bank_byte
    cmp $14a5
    bne L487A
    ldy #$05
    jsr read_bank_byte
    cmp #$08
    bcs L4867
    eor #$04
    jmp L4871
L4867:
    eor #$01
    jmp L4871
L486C:
    ldy #$05
    jsr read_bank_byte
L4871:
    cmp temp_dir_idx
    bne L487A
    lda temp_obj_idx
    rts
L487A:
    inc temp_obj_idx
    jmp L482E
L4880:
    lda #$ff
    rts
L4883:
    pha
    ldx #<msg_1895
    ldy #>msg_1895
    jsr print_string
    lda #$00
    sta gram_case
    pla
    jmp print_object_name
L4894:
    pha
    jsr L3D81
    ldx #<msg_1a12
    ldy #>msg_1a12
    jsr print_string
    lda #$04
    sta gram_case
    pla
    jmp print_object_name
L48A8:
    cmp #$12
    bne L48C3
    ldy cmd_verb_arg1
    cpy #$03
    bne L48C3
    jsr L3D81
    ldx #<msg_1a35
    ldy #>msg_1a35
    jsr print_string
    lda #$01
    sta $2d1b
    rts
L48C3:
    rts
L48C4:
    sta temp_obj_idx
    jsr get_object_ptr
    RAMON
    ldy #$00
    lda (ZP_69),y
    cmp #$ff
    beq L48DD
    iny
L48DD:
    lda #$11
    sta (ZP_69),y
    ldy #$06
    lda #$00
    sta (ZP_69),y
    ROMON
    rts
L48EE:
    lda #<weapon_pair_table
    sta ZP_69
    lda #>weapon_pair_table
    sta ZP_6A
L48F6:
    ldy #$00
    lda (ZP_69),y
    ldx clause_idx
    cmp cmd_obj_list,x
    bne L490D
    iny
    lda (ZP_69),y
    cmp cmd_verb_arg1
    bne L490D
    lda #$00
    rts
L490D:
    INCPTR ZP_69
    INCPTR ZP_69
    ldy #$00
    lda (ZP_69),y
    cmp #$ff
    bne L48F6
    rts
L4924:
    ldx #$00
L4926:
    lda dark_rooms_table,x
    beq L493D
    cmp current_room
    bne L493A
    ldx #<msg_19bb
    ldy #>msg_19bb
    jsr print_string
    jmp ask_play_again
L493A:
    inx
    bne L4926
L493D:
    rts
show_title_and_intro:
    ldx #<str_kbd_top
    ldy #>str_kbd_top
    jsr print_string
    ldx #<str_kbd_l_box
    ldy #>str_kbd_l_box
    jsr print_string
    ldx #<str_kbd_mid1
    ldy #>str_kbd_mid1
    jsr print_string
    ldx #<str_kbd_mid2
    ldy #>str_kbd_mid2
    jsr print_string
    ldx #<str_kbd_bot
    ldy #>str_kbd_bot
    jsr print_string
    ldx #<str_title_logo
    ldy #>str_title_logo
    jsr print_string
L4968:
    GETIN
    beq L4968
    lda #<str_intro_story
    sta ZP_69
    lda #>str_intro_story
    sta ZP_6A
L4975:
    ldy #$00
    lda (ZP_69),y
    beq L4998
    CHROUT
    ldx #$20
    ldy #$00
L4982:
    dey
    bne L4982
    dex
    bne L4982
    GETIN
    bne L4997
    INCPTR ZP_69
    jmp L4975
L4997:
    rts
L4998:
    GETIN
    beq L4998
    rts
L499E:
    lda #$0e
    jsr get_object_ptr
    ldy #$03
    jsr read_bank_byte
    sta $14a5
    cmp #$00
    bne L49B0
    rts
L49B0:
    cmp #$52
    bne L49D0
    lda #$33
    jsr get_object_ptr
    ldy #$03
    jsr read_bank_byte
    cmp #$32
    bne L49D0
    ldy #$05
    jsr read_bank_byte
    and #$60
    bne L49D0
    lda #$01
    sta $2d15
L49D0:
    lda $14a5
    cmp current_room
    bne L49E7
    lda $2d15
    beq L49E7
L49DD:
    ldx #<msg_208b
    ldy #>msg_208b
    jsr print_string
    jmp ask_play_again
L49E7:
    lda $14a5
    cmp current_room
    bne L49F6
    ldx #<msg_20f2
    ldy #>msg_20f2
    jsr print_string
L49F6:
    ldx $14a5
    lda $2ce6,x
    sta $14a5
    lda #$0e
    jsr get_object_ptr
    RAMON
    lda $14a5
    ldy #$03
    sta (ZP_69),y
    ROMON
    lda $14a5
    cmp current_room
    bne L4A2F
    ldx #<msg_20d9
    ldy #>msg_20d9
    jsr print_string
    lda $2d15
    bne L49DD
L4A2F:
    rts
L4A30:
    jsr L3D81
    ldx #<msg_1ee0
    ldy #>msg_1ee0
    jsr print_string
    jmp L3ED9
delay_short:
    lda #$0a
    sta ZP_69
L4A41:
    ldx #$00
    ldy #$00
L4A45:
    dey
    bne L4A45
    dex
    bne L4A45
    dec ZP_69
    bne L4A41
    rts
write_save_data:
    ldy #$00
L4A52:
    lda turn_wait_cnt,y
    CHROUT
    iny
    cpy #$0d
    bne L4A52
    lda current_room
    CHROUT
    RAMON
    lda obj_table_ptr
    sta ZP_69
    lda $0d07
    sta ZP_6A
    ROMON
L4A7D:
    ldy #$00
    jsr read_bank_byte
    cmp #$fe
    bne L4A89
    CHROUT_JMP
L4A89:
    jsr read_bank_byte
    CHROUT
    iny
    cpy #$08
    bne L4A89
    clc
    lda ZP_69
    adc #$08
    sta ZP_69
    lda ZP_6A
    adc #$00
    sta ZP_6A
    jmp L4A7D
read_save_data:
    ldy #$00
L4AA6:
    CHRIN
    sta turn_wait_cnt,y
    iny
    cpy #$0d
    bne L4AA6
    CHRIN
    sta current_room
    RAMON
    lda obj_table_ptr
    sta ZP_69
    lda $0d07
    sta ZP_6A
    ROMON
L4AD1:
    CHRIN
    ldy #$00
    pha
    RAMON
    pla
    sta (ZP_69),y
    pha
    ROMON
    pla
    cmp #$fe
    bne L4AF1
    rts
L4AF1:
    iny
    cpy #$08
    beq L4B10
    CHRIN
    pha
    RAMON
    pla
    sta (ZP_69),y
    ROMON
    jmp L4AF1
L4B10:
    clc
    lda ZP_69
    adc #$08
    sta ZP_69
    lda ZP_6A
    adc #$00
    sta ZP_6A
    jmp L4AD1
str_ask_restore:
    dta CR, C_YEL, c'CZY ODTWARZASZ NAGRAN', PL_A, c' GR', PL_E
    dta c'? (T/N)', CR, $00
str_ask_tape_disk:
    dta CR, C_YEL, c'TA', PL_S, c'MA CZY DYSK?', CR, $00
str_dos_Hobbidata:
    dta PL_Z_DOT, c':'
str_hobbidata:
    dta c'HOBBIDATA'
ask_tape_or_disk:
    ldx #<str_ask_tape_disk
    ldy #>str_ask_tape_disk
    jsr print_string
L4B6A:
    GETIN
    cmp #$54
    beq L4B7B
    cmp #$44
    bne L4B6A
    lda #$08
    sta io_dev_num
    rts
L4B7B:
    lda #$01
    sta io_dev_num
    rts
save_game:
    jsr ask_tape_or_disk
    lda #$01
    ldx io_dev_num
    ldy #$01
    SETLFS
    ldx #<str_dos_Hobbidata
    ldy #>str_dos_Hobbidata
    lda io_dev_num
    cmp #$08
    beq L4BA2
    ldx #<str_hobbidata
    ldy #>str_hobbidata
    lda #$09
    jmp L4BA4
L4BA2:
    lda #$0b
L4BA4:
    SETNAM
    OPEN_CH
    ldx #$01
    CHKOUT
    jsr write_save_data
    CLRCHN
    lda #$01
    CLOSE_CH_JMP
load_game:
    jsr ask_tape_or_disk
    lda #$01
    ldx io_dev_num
    ldy #$00
    SETLFS
    lda #$09
    ldx #<str_hobbidata
    ldy #>str_hobbidata
    SETNAM
    OPEN_CH
    ldx #$01
    CHKIN
    jsr read_save_data
    CLRCHN
    lda #$01
    CLOSE_CH_JMP
L4BE3:
    lda #$01
    sta temp_obj_idx
    lda #$00
    sta ZP_6B
    lda #$01
    sta ZP_6C
L4BF0:
    lda temp_obj_idx
    jsr get_object_ptr
    ldy #$00
    jsr read_bank_byte
    cmp #$fe
    bne L4C00
    rts
L4C00:
    ldy #$03
    jsr read_bank_byte
    cmp #$ff
    bne L4C1A
    ldy temp_obj_idx
    lda obj_weight_table,y
    clc
    adc ZP_69
    sta ZP_69
    lda ZP_6A
    adc #$00
    sta ZP_6A
L4C1A:
    inc temp_obj_idx
    jmp L4BF0
update_hunger_and_carry:
    lda hunger_lo
    ora hunger_hi
    bne L4C32
    ldx #<str_starved
    ldy #>str_starved
    jsr print_string
    jmp ask_play_again
L4C32:
    jsr L4BE3
    lda hunger_lo
    sec
    sbc ZP_6B
    sta hunger_lo
    lda hunger_hi
    sbc ZP_6C
    sta hunger_hi
    bcs L4C50
    lda #$00
    sta hunger_lo
    sta hunger_hi
L4C50:
    lda hunger_hi
    bpl L4C56
    rts
L4C56:
    and #$03
    beq L4C5B
    rts
L4C5B:
    lda hunger_hi
    and #$7f
    lsr @
    lsr @
    lsr @
    lsr @
    asl @
    tay
    lda hunger_msg_ptr_table,y
    tax
    lda $2341,y
    tay
    jsr print_string
    rts
main_entry:
    INIT_HARDWARE
    jsr show_title_and_intro
    ldx #<str_ask_restore
    ldy #>str_ask_restore
    jsr print_string
L4C93:
    GETIN
    cmp #$4e
    beq init_new_game
    cmp #$54
    bne L4C93
    jsr load_game
    ldx #<str_ok
    ldy #>str_ok
    jsr print_string
    jmp room_loop
init_new_game:
    RAMON
    lda $c00e
    sta ZP_69
    lda $c00f
    sta ZP_6A
    lda obj_table_ptr
    sta ZP_6B
    lda $0d07
    sta ZP_6C
L4CC9:
    ldy #$00
    lda (ZP_69),y
    cmp #$fe
    beq L4CF7
L4CD1:
    lda (ZP_69),y
    sta (ZP_6B),y
    iny
    cpy #$08
    bne L4CD1
    clc
    lda ZP_69
    adc #$08
    sta ZP_69
    lda ZP_6A
    adc #$00
    sta ZP_6A
    clc
    lda ZP_6B
    adc #$08
    sta ZP_6B
    lda ZP_6C
    adc #$00
    sta ZP_6C
    jmp L4CC9
L4CF7:
    lda #$fe
    sta (ZP_6B),y
    ROMON
    lda #$93
    CHROUT
    lda #$01
    sta current_room
    lda #$02
    sta turn_wait_cnt
    lda #$00
    sta $2d10
    sta $2d11
    sta $2d12
    sta $2d13
    sta $2d14
    sta $2d16
    sta $2d19
    sta $2d15
    sta $2d1a
    sta $2d1b
    sta hunger_lo
    lda #$b4
    sta hunger_hi
room_loop:
    lda current_room
    jsr load_room_exits
    jsr describe_room
    jsr list_room_objects
L4D44:
    jsr L45A6
    jsr L4924
    jsr L40CF
    jsr L4375
    jsr L3FFA
    jsr L44C9
    jsr L4185
    jsr L41CA
    jsr L4216
    jsr L42BE
    jsr L45F7
    jsr L45A6
    jsr L413F
    jsr L46D6
    jsr L4338
    jsr L499E
    jsr L45A6
    jsr L422E
    jsr update_hunger_and_carry
    jsr L42A6
command_loop:
    jsr read_and_tokenize
    lda #$00
    sta word_idx
L4D88:
    jsr lookup_word
    jsr check_word_valid
    cmp #$ff
    beq command_loop
    lda word_idx
    asl @
    asl @
    asl @
    tax
    ldy #$00
L4D9B:
    lda word_match_buf,y
    sta parsed_words_buf,x
    inx
    iny
    cpy #$08
    bne L4D9B
    inc word_idx
    lda word_idx
    cmp token_count
    bcc L4D88
    lda #$00
    sta word_idx
    sta $2cca
    sta clause_idx
L4DBD:
    jsr parse_clause
    bpl L4DDE
print_random_cant_do:
    jsr get_random_byte
    and #$03
    asl @
    tay
    lda err_msg_ptr_table,y
    tax
    lda $178a,y
    tay
L4DD1:
    jsr print_string
    jmp command_loop
L4DD7:
    ldx #<str_sentence_too_complex
    ldy #>str_sentence_too_complex
    jmp L4DD1
L4DDE:
    ldx clause_idx
    lda $2cb8
    sta $2caf,x
    lda word_idx
    cmp token_count
    bcc L4DF2
    jmp L4DFF
L4DF2:
    lda clause_idx
    cmp #$05
    bcc L4DFC
    jmp L4DD7
L4DFC:
    jmp L4DBD
L4DFF:
    lda #$ff
    sta cmd_verb_arg1
    lda $2c90
    cmp #$01
    beq L4E0E
    jmp L4ED6
L4E0E:
    lda $2c98
    cmp #$06
    beq L4E18
    jmp L4ED6
L4E18:
    lda #$00
    sta $2c90
    lda $2c91
    cmp #$02
    beq L4E27
L4E24:
    jmp print_random_cant_do
L4E27:
    lda #$00
    sta $2c91
    lda $2cc3
    cmp #$01
    bne L4E24
    lda $2cbb
    tax
    lda $2ccb,x
    sta cur_adj1
    lda $2cdb,x
    sta cur_adj2
    lda $2ceb,x
    sta cur_noun
    lda $2c99
    cmp #$ff
    bne L4E5A
    lda $2cb1
    and #$04
    beq L4E24
    jmp L4E65
L4E5A:
    cmp #$04
    bne L4E24
    lda $2cb0
    and #$02
    beq L4E24
L4E65:
    lda #$01
    jsr L3B51
    lda $1484
    cmp #$02
    bcc L4E83
    ldx #<msg_180e
    ldy #>msg_180e
    jsr print_string
L4E78:
    lda #$03
    sta gram_case
    jsr print_inflected_noun
    jmp command_loop
L4E83:
    cmp #$00
    bne L4E91
    ldx #<msg_181a
    ldy #>msg_181a
    jsr print_string
    jmp L4E78
L4E91:
    lda $2d0b
    sta cmd_verb_arg1
    sta temp_obj_idx
    lda #$01
    sta gram_case
    lda #$00
    sta $2c8b
    lda #$06
    sta $2c73
    jsr L3482
    lda #$00
    sta $2cb9
    lda #$04
    sta $2c73
    jsr L3418
    lda temp_obj_idx
    jsr print_object_name
    lda #$0d
    CHROUT
    lda cmd_verb_arg1
    jsr get_object_ptr
    ldy #$06
    jsr read_bank_byte
    and #$08
    bne L4ED6
    jmp after_turn_jump
L4ED6:
    ldy #$00
    sty ZP_69
L4EDA:
    lda $2c90,y
    cmp #$01
    bne L4EE5
    inc ZP_69
    sty ZP_6A
L4EE5:
    iny
    cpy clause_idx
    bcc L4EDA
    lda ZP_69
    cmp #$01
    beq L4EF7
    jsr L3D81
    jmp print_random_cant_do
L4EF7:
    ldy ZP_6A
    lda #$00
    sta $2c90,y
    lda $2c98,y
    sta cmd_verb_id
    ldy #$00
    sty ZP_69
L4F08:
    lda $2c90,y
    cmp #$02
    bne L4F17
    ldx ZP_69
    tya
    sta parsed_words_buf,x
    inc ZP_69
L4F17:
    iny
    cpy clause_idx
    bne L4F08
    lda ZP_69
    sta $1480
    cmp #$03
    bcc L4F2C
    jsr L3D81
    jmp print_random_cant_do
L4F2C:
    lda cmd_verb_arg1
    cmp #$0f
    bne L4F49
    lda $2d16
    beq L4F49
    ldx #<msg_1c24
    ldy #>msg_1c24
    jsr print_string
    ldx #<msg_1bde
    ldy #>msg_1bde
    jsr print_string
    jmp ask_play_again
L4F49:
    lda $1480
    cmp #$02
    beq L4F58
    lda #$ff
    sta cmd_prep
    jmp L4FE8
L4F58:
    jsr L3C98
    cmp #$ff
    bne L4F65
    jsr L3D81
    jmp print_random_cant_do
L4F65:
    dec $1480
    lda $1489
    sta cur_noun
    lda $1487
    sta cur_adj1
    lda $1488
    sta cur_adj2
    ldx cmd_verb_id
    lda prep_table_1,x
    jsr L3B51
    lda $2d0b
    sta cmd_prep
    lda $1484
    cmp #$01
    beq L4FE8
    cmp #$00
    beq L4FA6
    jsr L3D81
    ldx #<msg_180e
    ldy #>msg_180e
    jsr print_string
    lda #$03
    sta gram_case
    jmp L4FC6
L4FA6:
    jsr L3D81
    lda cmd_verb_arg1
    cmp #$ff
    beq L4FBA
    ldx #<msg_1828
    ldy #>msg_1828
    jsr print_string
    jmp L4FC1
L4FBA:
    ldx #<msg_181a
    ldy #>msg_181a
    jsr print_string
L4FC1:
    lda #$01
    sta gram_case
L4FC6:
    lda $1489
    sta cur_noun
    lda $1487
    sta cur_adj1
    lda $1488
    sta cur_adj2
    jsr print_inflected_noun
    lda cmd_verb_arg1
    cmp #$ff
    beq L4FE5
    jmp after_turn_jump
L4FE5:
    jmp command_loop
L4FE8:
    lda $1480
    bne L4FF5
    lda #$00
    sta cmd_obj_count
    jmp L50CD
L4FF5:
    ldy #$00
L4FF7:
    lda $2c90,y
    cmp #$02
    beq L5007
    iny
    cpy clause_idx
    bne L4FF7
    jmp print_random_cant_do
L5007:
    ldx cmd_verb_id
    lda $2cc2,y
    sta $2cc2
    sta cmd_obj_count
    lda verb_prep_req_table,x
    bne L5041
    lda $2cc2
    cmp #$01
    beq L5041
    jsr L3D81
    jsr get_random_byte
    and #$03
    asl @
    tay
    lda err_msg_ptr_table,y
    tax
    lda $178a,y
    tay
    jsr print_string
    lda cmd_verb_arg1
    cmp #$ff
    beq L503E
    jmp after_turn_jump
L503E:
    jmp command_loop
L5041:
    lda #$00
    sta $1480
    lda $2cba,y
    sta clause_idx
    lda $2cb0,y
    sta $14a2
    lda $2c98,y
    sta $14a3
    lda $2ca0,y
    sta $14a4
    lda #<verb_syntax_table
    sta ZP_69
    lda #>verb_syntax_table
    sta ZP_6A
    ldx cmd_verb_id
    beq L507D
L506B:
    ldy #$00
    lda (ZP_69),y
    INCPTR ZP_69
    cmp #$00
    bne L506B
    dex
    bne L506B
L507D:
    ldy #$00
    lda (ZP_69),y
    bne L5089
    jsr L3D81
    jmp print_random_cant_do
L5089:
    cmp $14a3
    bne L5096
    iny
    lda (ZP_69),y
    and $14a2
    bne L50A7
L5096:
    INCPTR ZP_69
    INCPTR ZP_69
    jmp L507D
L50A7:
    ldx $1480
    ldy clause_idx
    lda $2ceb,y
    sta $149a,x
    lda $2ccb,y
    sta $148a,x
    lda $2cdb,y
    sta $1492,x
    inc clause_idx
    inc $1480
    ldx $1480
    cpx $2cc2
    bne L50A7
L50CD:
    ldx cmd_verb_id
    lda prep_table_2,x
    bne L50E2
    lda cmd_prep
    cmp #$ff
    beq L50ED
L50DC:
    jsr L3D81
    jmp print_random_cant_do
L50E2:
    cmp #$02
    bne L50ED
    lda cmd_prep
    cmp #$ff
    bne L50DC
L50ED:
    lda cmd_verb_id
    asl @
    tay
    lda verb_jump_table,y
    sta ZP_69
    lda $0da6,y
    sta ZP_6A
    jmp (ZP_69)
verb_0_go:
    lda cmd_obj_count
    cmp #$01
    beq L5109
    jmp print_random_cant_do
L5109:
    lda $148a
    sta cur_adj1
    lda $1492
    sta cur_adj2
    lda $149a
    sta cur_noun
    jsr L3E8E
    cmp #$ff
    beq L5128
    sta temp_dir_idx
    jmp L5177
L5128:
    lda #$01
    jsr L3B51
    jsr L3F44
    cmp #$ff
    bne L5137
    jmp after_turn_jump
L5137:
    lda #$00
    sta clause_idx
L513C:
    lda $2d0b
    sta cmd_obj_list
    jsr get_object_ptr
    ldy #$06
    jsr read_bank_byte
    and #$20
    beq L5157
    jsr read_bank_byte
    and #$50
    cmp #$40
    bne L515D
L5157:
    jsr L3EB4
    jmp after_turn_jump
L515D:
    lda $2d0b
    jsr get_object_ptr
    ldy #$03
    jsr read_bank_byte
    cmp current_room
    bne L516E
    iny
L516E:
    jsr read_bank_byte
    sta $14a5
    jmp L523F
L5177:
    RAMON
    lda $c010
    sta ZP_69
    lda $c011
    sta ZP_6A
    ROMON
    ldx current_room
L5194:
    dex
    beq L51A7
    lda ZP_69
    clc
    adc #$0a
    sta ZP_69
    lda ZP_6A
    adc #$00
    sta ZP_6A
    jmp L5194
L51A7:
    ldy temp_dir_idx
    jsr read_bank_byte
    sta $14a5
    cmp #$00
    bne L51C1
    jsr L3D81
    ldx #<msg_184c
    ldy #>msg_184c
    jsr print_string
    jmp after_turn_jump
L51C1:
    lda #$01
    sta temp_obj_idx
L51C6:
    lda temp_obj_idx
    jsr get_object_ptr
    ldy #$00
    jsr read_bank_byte
    cmp #$fe
    beq L5232
    ldy #$05
    jsr read_bank_byte
    and #$60
    bne L522C
    ldy #$03
    jsr read_bank_byte
    cmp current_room
    beq L5204
    iny
    jsr read_bank_byte
    cmp current_room
    bne L522C
    ldy #$05
    jsr read_bank_byte
    cmp #$08
    bcs L51FF
    eor #$04
    jmp L5209
L51FF:
    eor #$01
    jmp L5209
L5204:
    ldy #$05
    jsr read_bank_byte
L5209:
    cmp temp_dir_idx
    bne L522C
    lda temp_obj_idx
    sta $2d0b
    sta cmd_obj_list
    lda #$01
    sta $14a3
    lda #$00
    sta $14a4
    sta clause_idx
    lda #$08
    sta $14a2
    jmp L513C
L522C:
    inc temp_obj_idx
    jmp L51C6
L5232:
    lda temp_dir_idx
    ora #$f0
    sta cmd_obj_list
    lda #$00
    sta clause_idx
L523F:
    lda cmd_verb_arg1
    cmp #$ff
    bne L5286
    lda #$05
    jsr L40B4
    bne L5266
    lda #$05
    jsr get_object_ptr
    ldy #$03
    jsr read_bank_byte
    cmp current_room
    bne L5266
    ldx #<msg_1cf5
    ldy #>msg_1cf5
    jsr print_string
    jmp after_turn_jump
L5266:
    lda #$31
    jsr L40B4
    bne L5286
    lda #$31
    jsr get_object_ptr
    ldy #$03
    jsr read_bank_byte
    cmp current_room
    bne L5286
    ldx #<msg_1d13
    ldy #>msg_1d13
    jsr print_string
    jmp after_turn_jump
L5286:
    jsr L3DFD
    lda cmd_verb_arg1
    cmp #$ff
    beq L52CD
    pha
    cmp #$01
    bne L52A3
    lda cmd_obj_list
    cmp #$27
    bne L52A3
    ldx #<msg_1e57
    ldy #>msg_1e57
    jsr print_string
L52A3:
    pla
    jsr get_object_ptr
    RAMON
    ldy #$03
    lda $14a5
    sta (ZP_69),y
    ROMON
    lda cmd_verb_arg1
    cmp #$01
    bne L52CA
    lda #$01
    sta turn_wait_cnt
L52CA:
    jmp after_turn_jump
L52CD:
    lda cmd_obj_list
    cmp #$22
    bcc L52E5
    cmp #$24
    bcs L52E5
    ldx #<msg_1d64
    ldy #>msg_1d64
    jsr print_string
    jsr delay_short
    jmp L532C
L52E5:
    cmp #$27
    bne L5314
    ldx #<msg_1d86
    ldy #>msg_1d86
    jsr print_string
    jsr delay_short
    lda #$27
    jsr get_object_ptr
    RAMON
    ldy #$03
    lda #$00
    sta (ZP_69),y
    iny
    sta (ZP_69),y
    ROMON
    jmp L532C
L5314:
    cmp #$2b
    bne L532C
    ldx #<msg_1dff
    ldy #>msg_1dff
    jsr print_string
    jsr delay_short
    ldx #<msg_1e33
    ldy #>msg_1e33
    jsr print_string
    jmp L532C
L532C:
    lda $14a5
    sta current_room
L5332:
    lda current_room
    jsr load_room_exits
    jsr describe_room
    jsr list_room_objects
    jmp after_turn_jump
verb_1_take:
    lda cmd_obj_count
    beq L5332
    lda #$1f
    jsr L3DB5
    cmp #$ff
    bne L5352
    jmp after_turn_jump
L5352:
    ldx #$00
    stx clause_idx
L5357:
    ldx clause_idx
    cpx cmd_obj_count
    bne L5362
    jmp after_turn_jump
L5362:
    jsr L3D81
    lda cmd_verb_arg1
    cmp #$ff
    beq L5376
    ldx #<msg_19fa
    ldy #>msg_19fa
    jsr print_string
    jmp L537D
L5376:
    ldx #<msg_19f0
    ldy #>msg_19f0
    jsr print_string
L537D:
    ldx clause_idx
    lda #$03
    sta gram_case
    lda cmd_obj_list,x
    jsr L2F1D
    lda #$0d
    CHROUT
    ldx clause_idx
    lda cmd_obj_list,x
    jsr L48A8
    inc clause_idx
    jmp L5357
verb_2_drop:
    lda cmd_verb_arg1
    cmp #$ff
    beq L53AC
    jsr L3D81
    jmp print_random_cant_do
L53AC:
    lda #$00
    sta print_hdr_flag
    lda #$03
    sta gram_case
    lda #$01
    sta temp_obj_idx
L53BB:
    lda temp_obj_idx
    jsr get_object_ptr
    ldy #$00
    jsr read_bank_byte
    cmp #$fe
    bne L53CD
    jmp after_turn_jump
L53CD:
    ldy #$05
    jsr read_bank_byte
    and #$60
    beq L53F9
    ldy #$03
    jsr read_bank_byte
    cmp #$ff
    bne L53F9
    lda print_hdr_flag
    bne L53EE
    inc print_hdr_flag
    ldx #<msg_1a0a
    ldy #>msg_1a0a
    jsr print_string
L53EE:
    lda #$0d
    CHROUT
    lda temp_obj_idx
    jsr print_object_name
L53F9:
    inc temp_obj_idx
    jmp L53BB
verb_3_open_close:
    lda cmd_prep
    cmp #$ff
    bne L540B
    lda #$0d
    jmp L5429
L540B:
    jsr get_object_ptr
    ldy #$06
    jsr read_bank_byte
    and #$80
    beq L5427
    jsr read_bank_byte
    and #$08
    bne L5427
    lda cmd_prep
    jsr L4894
    jmp after_turn_jump
L5427:
    lda #$10
L5429:
    jsr L3DB5
    cmp #$ff
    bne L5433
    jmp after_turn_jump
L5433:
    lda #$00
    sta clause_idx
L5438:
    ldx clause_idx
    cpx cmd_obj_count
    bne L5443
    jmp L54CF
L5443:
    lda cmd_obj_list,x
    jsr get_object_ptr
    ldy #$06
    jsr read_bank_byte
    and #$01
    bne L5458
    jsr L3EB4
    jmp L549F
L5458:
    RAMON
    ldy #$05
    lda (ZP_69),y
    and #$1f
    ora #$20
    sta (ZP_69),y
    ldy #$03
    lda cmd_verb_arg1
    sta (ZP_69),y
    ROMON
    jsr L3DFD
    ldx clause_idx
    lda cmd_obj_list,x
    cmp #$11
    bne L549F
    lda #$0f
    jsr get_object_ptr
    ldy #$03
    jsr read_bank_byte
    cmp current_room
    bne L549F
    ldx #<msg_1bde
    ldy #>msg_1bde
    jsr print_string
    jmp ask_play_again
L549F:
    ldx clause_idx
    lda cmd_obj_list,x
    cmp #$33
    bne L54C9
    lda cmd_verb_arg1
    cmp #$ff
    bne L54C9
    lda #$01
    jsr get_object_ptr
    ldy #$03
    jsr read_bank_byte
    cmp current_room
    bne L54C9
    ldx #<msg_2179
    ldy #>msg_2179
    jsr print_string
    jmp ask_play_again
L54C9:
    inc clause_idx
    jmp L5438
L54CF:
    jmp after_turn_jump
verb_4_examine:
    lda cmd_prep
    cmp cmd_verb_arg1
    bne L54E4
L54DA:
    ldx #<msg_1791
    ldy #>msg_1791
    jsr print_string
    jmp after_turn_jump
L54E4:
    lda #$02
    jsr L3DB5
    cmp #$ff
    bne L54F0
    jmp after_turn_jump
L54F0:
    lda cmd_prep
    cmp #$ff
    beq L5505
    jsr get_object_ptr
    ldy #$06
    jsr read_bank_byte
    and #$88
    cmp #$88
    bne L54DA
L5505:
    lda #$00
    sta clause_idx
L550A:
    ldx clause_idx
    cpx cmd_obj_count
    bne L5515
    jmp after_turn_jump
L5515:
    lda cmd_obj_list,x
    jsr get_object_ptr
    RAMON
    ldy #$03
    lda cmd_prep
    sta (ZP_69),y
    ROMON
    jsr L3DFD
    inc clause_idx
    jmp L550A
verb_5_inventory:
    lda #$02
    jsr L3DB5
    cmp #$ff
    bne L5547
    jmp after_turn_jump
L5547:
    lda #$03
    sta $1485
    lda #$00
    sta clause_idx
    lda cmd_prep
    cmp #$ff
    beq L5573
    jsr get_object_ptr
    ldy #$06
    jsr read_bank_byte
    and #$04
    bne L556A
L5564:
    jsr L3EB4
    jmp after_turn_jump
L556A:
    jsr read_bank_byte
    and #$50
    cmp #$40
    beq L5564
L5573:
    ldx clause_idx
    cpx cmd_obj_count
    bne L557E
    jmp after_turn_jump
L557E:
    lda cmd_obj_list,x
    jsr get_object_ptr
    lda cmd_prep
    cmp #$ff
    beq L55AB
    RAMON
    ldy #$03
    lda cmd_prep
    sta (ZP_69),y
    ldy #$05
    lda #$40
    sta (ZP_69),y
    ROMON
    jmp L55C8
L55AB:
    RAMON
    ldy #$03
    lda current_room
    sta (ZP_69),y
    lda #$80
    ldy #$05
    sta (ZP_69),y
    ROMON
L55C8:
    jsr L3DFD
    inc clause_idx
    jmp L5573
verb_7_attack:
    lda #$00
    sta clause_idx
    lda #$9f
    CHROUT
    lda #$01
    jsr L3DB5
    cmp #$ff
    bne L55E7
    jmp after_turn_jump
L55E7:
    lda #$00
    sta clause_idx
L55EC:
    lda clause_idx
    cmp cmd_obj_count
    bne L55F7
    jmp after_turn_jump
L55F7:
    ldx clause_idx
    lda cmd_obj_list,x
    sta $14a6
    jsr get_object_ptr
    ldy #$06
    jsr read_bank_byte
    and #$40
    bne L563A
L560C:
    jsr L3EB4
    jmp L56B5
L5612:
    jsr L48EE
    cmp #$ff
    beq L560C
    lda cmd_verb_arg1
    cmp #$01
    bne L5630
    ldx clause_idx
    lda cmd_obj_list,x
    cmp #$21
    bne L5630
    jsr L4A30
    jmp L56B5
L5630:
    lda cmd_prep
    cmp #$ff
    beq L566B
    jmp L560C
L563A:
    ldy #$07
    jsr read_bank_byte
    cmp #$fe
    beq L5612
    cmp cmd_prep
    beq L5674
    sta temp_obj_idx
    lda cmd_prep
    cmp #$ff
    bne L560C
    lda temp_obj_idx
    jsr get_object_ptr
    ldy #$05
    jsr read_bank_byte
    and #$60
    beq L560C
    ldy #$03
    jsr read_bank_byte
    cmp cmd_verb_arg1
    bne L560C
L566B:
    ldx clause_idx
    lda cmd_obj_list,x
    jsr get_object_ptr
L5674:
    ldy #$06
    jsr read_bank_byte
    and #$10
    bne L56AC
    RAMON
    ldy #$06
    lda (ZP_69),y
    ora #$10
    sta (ZP_69),y
    ROMON
    jsr L3DFD
    lda cmd_verb_arg1
    cmp #$ff
    bne L56AC
    ldx clause_idx
    lda cmd_obj_list,x
    cmp #$21
    bne L56AC
    inc $2d12
L56AC:
    lda $14a6
    sta temp_obj_idx
    jsr L3006
L56B5:
    inc clause_idx
    jmp L55EC
verb_8_give_throw:
    lda #$00
    sta clause_idx
    lda #$9f
    CHROUT
    lda #$01
    jsr L3DB5
    cmp #$ff
    bne L56D1
    jmp after_turn_jump
L56D1:
    lda #$00
    sta clause_idx
L56D6:
    lda clause_idx
    cmp cmd_obj_count
    bne L56E1
    jmp after_turn_jump
L56E1:
    ldx clause_idx
    lda cmd_obj_list,x
    sta $14a6
    jsr get_object_ptr
    ldy #$06
    jsr read_bank_byte
    and #$40
    bne L570D
L56F6:
    jsr L3EB4
    jmp L5774
L56FC:
    jsr L48EE
    cmp #$ff
    beq L56F6
    lda cmd_prep
    cmp #$ff
    beq L573E
    jmp L56F6
L570D:
    ldy #$07
    jsr read_bank_byte
    cmp #$fe
    beq L56FC
    cmp cmd_prep
    beq L5747
    sta temp_obj_idx
    lda cmd_prep
    cmp #$ff
    bne L56F6
    lda temp_obj_idx
    jsr get_object_ptr
    ldy #$05
    jsr read_bank_byte
    and #$60
    beq L56F6
    ldy #$03
    jsr read_bank_byte
    cmp cmd_verb_arg1
    bne L56F6
L573E:
    ldx clause_idx
    lda cmd_obj_list,x
    jsr get_object_ptr
L5747:
    ldy #$06
    jsr read_bank_byte
    and #$10
    beq L576B
    RAMON
    ldy #$06
    lda (ZP_69),y
    and #$ef
    sta (ZP_69),y
    ROMON
    jsr L3DFD
L576B:
    lda $14a6
    sta temp_obj_idx
    jsr L3006
L5774:
    inc clause_idx
    jmp L56D6
verb_9_put_in:
    lda cmd_verb_arg1
    cmp #$0d
    bne L57D9
    lda cmd_prep
    cmp #$ff
    bne L57D9
    lda cmd_obj_count
    cmp #$01
    bne L57D9
    lda $149a
    cmp #$0c
    bne L57D9
    lda $148a
    cmp #$ff
    bne L57D9
    jsr L3D81
    lda $2d19
    bne L57B2
    ldx #<msg_2282
    ldy #>msg_2282
    jsr print_string
    inc $2d19
    jmp after_turn_jump
L57B2:
    lda #$0e
    jsr get_object_ptr
    ldy #$03
    jsr read_bank_byte
    cmp #$00
    bne L57CA
    ldx #<msg_22ab
    ldy #>msg_22ab
    jsr print_string
    jmp after_turn_jump
L57CA:
    cmp current_room
    beq L57D9
    ldx #<msg_22c3
    ldy #>msg_22c3
    jsr print_string
    jmp after_turn_jump
L57D9:
    lda #$01
    jsr L3DB5
    cmp #$ff
    bne L57E5
    jmp after_turn_jump
L57E5:
    lda #$00
    sta clause_idx
L57EA:
    ldx clause_idx
    cpx cmd_obj_count
    bne L57F5
    jmp after_turn_jump
L57F5:
    lda cmd_obj_list,x
    jsr get_object_ptr
    ldy #$06
    jsr read_bank_byte
    and #$02
    bne L580A
L5804:
    jsr L3EB4
    jmp L5826
L580A:
    ldy #$07
    jsr read_bank_byte
    cmp #$fe
    beq L582C
    cmp cmd_prep
    bne L5804
    ldx clause_idx
    lda cmd_obj_list,x
    pha
    jsr L3DFD
    pla
    jsr L48C4
L5826:
    inc clause_idx
    jmp L57EA
L582C:
    lda cmd_verb_arg1
    cmp #$ff
    beq L5836
    jmp L5804
L5836:
    ldx #<msg_1afb
    ldy #>msg_1afb
    jsr print_string
    lda #$03
    sta gram_case
    ldx clause_idx
    lda cmd_obj_list,x
    pha
    jsr print_object_name
    ldx #<msg_1b0e
    ldy #>msg_1b0e
    jsr print_string
    lda #$03
    sta gram_case
    pla
    jsr print_object_name
    jmp ask_play_again
verb_10_wait:
    jsr save_game
    jmp command_loop
verb_11_quit:
    lda cmd_verb_arg1
    cmp #$ff
    beq L586F
    jmp print_random_cant_do
L586F:
    ldx #<msg_1861
    ldy #>msg_1861
    jsr print_string
L5876:
    GETIN
    cmp #$54
    bne L5880
    jmp ask_play_again
L5880:
    cmp #$4e
    bne L5876
    jmp command_loop
verb_12_save:
    lda cmd_verb_arg1
    cmp #$ff
    beq L5897
    cmp #$01
    bne L5897
    lda #$02
    sta turn_wait_cnt
L5897:
    jsr L3DFD
    jmp after_turn_jump
verb_13_eat_drink:
    lda #$01
    cmp cmd_obj_count
    beq L58A7
    jmp print_random_cant_do
L58A7:
    lda #$0f
    jsr L3DB5
    cmp #$ff
    bne L58B3
    jmp after_turn_jump
L58B3:
    lda #$00
    sta clause_idx
    lda cmd_obj_list
    cmp #$12
    beq L58C5
    jsr L3EB4
    jmp after_turn_jump
L58C5:
    lda cmd_verb_arg1
    cmp #$03
    beq L5909
    lda #$0d
    CHROUT
    jsr L3D81
    lda #$9f
    CHROUT
    lda cmd_verb_arg1
    cmp #$ff
    beq L58EA
    ldx #<msg_1834
    ldy #>msg_1834
    jsr print_string
    jmp L58F1
L58EA:
    ldx #<msg_183f
    ldy #>msg_183f
    jsr print_string
L58F1:
    lda cmd_verb_id
    sta $2c73
    lda #$02
    sta $2c8b
    jsr L3482
    ldx #<msg_1ace
    ldy #>msg_1ace
    jsr print_string
    jmp after_turn_jump
L5909:
    jsr L3DFD
    lda #$0d
    CHROUT
    jsr L3D81
    ldx #<msg_1a35
    ldy #>msg_1a35
    jsr print_string
    lda #$01
    sta $2d1b
    jmp after_turn_jump
verb_14_fill:
    lda #$02
    jsr L3DB5
    cmp #$ff
    bne L592F
    jmp after_turn_jump
L592F:
    lda #$00
    sta clause_idx
L5934:
    ldx clause_idx
    cpx cmd_obj_count
    bne L593F
    jmp after_turn_jump
L593F:
    ldy #$00
L5941:
    lda fillable_objs_table,y
    bne L594C
    jsr L3EB4
    jmp L5982
L594C:
    iny
    cmp cmd_obj_list,x
    bne L5941
    jsr get_object_ptr
    RAMON
    ldy #$03
    lda #$00
    sta (ZP_69),y
    iny
    sta (ZP_69),y
    ROMON
    jsr L3DFD
    lda cmd_verb_arg1
    cmp #$ff
    bne L597B
    sta hunger_hi
L597B:
    ldx #<msg_210c
    ldy #>msg_210c
    jsr print_string
L5982:
    inc clause_idx
    jmp L5934
after_turn_jump:
    jmp L4D44
ask_play_again:
    ldx #<msg_244c
    ldy #>msg_244c
    jsr print_string
L5992:
    GETIN
    beq L5992
    ldx #$f8
    txs
    jmp main_entry
L599D:
    ldx #<msg_24cb
    ldy #>msg_24cb
    jsr print_string
    ldx #<msg_256e
    ldy #>msg_256e
    jsr print_string
    jmp L5992
copy_dict_to_c000:
    ldy #$00
    sty ZP_6B
    lda #$c0
    sta ZP_6C
    lda #<dict_data_src
    sta ZP_69
    lda #>dict_data_src
    sta ZP_6A
    RAMON
L59C8:
    lda (ZP_69),y
    sta (ZP_6B),y
    iny
    bne L59C8
    inc ZP_6A
    inc ZP_6C
    lda ZP_6C
    cmp #$d0
    bne L59C8
    ROMON
    rts

; =============================================================================
; $59E0-$6663: Polish Grammar, Vocabulary, Objects & World Map (-> $C000-$CC83)
; =============================================================================
dict_data_src:
    dta a($c000 + dict_nouns - dict_data_src)        ; $C000: Noun stems ($C1D4)
    dta a($c000 + dict_noun_endings - dict_data_src) ; $C002: Noun declension paradigms ($C012)
    dta a($c000 + dict_adjectives - dict_data_src)   ; $C004: Adjective stems ($C31D)
    dta a($c000 + dict_adj_endings - dict_data_src)  ; $C006: Adjective declension paradigms ($C3E8)
    dta a($c000 + dict_verbs - dict_data_src)        ; $C008: Verb imperatives ($C656)
    dta a($c000 + dict_verb_conj - dict_data_src)    ; $C00A: Verb conjugations ($C4EF)
    dta a($c000 + dict_preps - dict_data_src)        ; $C00C: Prepositions & conjunctions ($C768)
    dta a($c000 + init_objects - dict_data_src)      ; $C00E: Initial object table ($C7A6)
    dta a($c000 + room_exits - dict_data_src)        ; $C010: Room exits matrix ($C94F)

; -----------------------------------------------------------------------------
; Noun Declension Paradigms ($C012-$C1D3: 7 Polish cases separated by '-')
; -----------------------------------------------------------------------------
dict_noun_endings:
    dta c'-A-OWI-A-EM-IE-IE-', $00 ; Paradigm $01: -A-OWI-A-EM-IE-IE-
    dta c'A---', PL_E, c'-', PL_A, c'--O-', $00 ; Paradigm $02: A---Ę-Ą--O-
    dta c'-A-OWI-A-EM-ZIE-ZIE-', $00 ; Paradigm $03: -A-OWI-A-EM-ZIE-ZIE-
    dta c'-A-OWI-A-EM-U-U-', $00 ; Paradigm $04: -A-OWI-A-EM-U-U-
    dta c'-Y-Y--', PL_A, c'-Y-Y-', $00 ; Paradigm $05: -Y-Y--Ą-Y-Y-
    dta c'E-A-U-E-EM-U-E-', $00 ; Paradigm $06: E-A-U-E-EM-U-E-
    dta PL_O, c'D-ODU-ODOWI-', PL_O, c'D-ODEM-ODZIE-ODZIE-', $00 ; Paradigm $07: ÓD-ODU-ODOWI-ÓD-ODEM-ODZIE-ODZIE-
    dta c'A-Y-IE-', PL_E, c'-', PL_A, c'-IE-O-', $00 ; Paradigm $08: A-Y-IE-Ę-Ą-IE-O-
    dta c'--OM--AMI-ACH--', $00 ; Paradigm $09: --OM--AMI-ACH--
    dta c'OTA-', PL_O, c'T-OTOM-OTA-OTAMI-OTACH-OTA-', $00 ; Paradigm $0a: OTA-ÓT-OTOM-OTA-OTAMI-OTACH-OTA-
    dta c'-A-OWI--EM-U-U-', $00 ; Paradigm $0b: -A-OWI--EM-U-U-
    dta c'-A-OWI-A-IEM-U-U-', $00 ; Paradigm $0c: -A-OWI-A-IEM-U-U-
    dta PL_N, c'-NIA-NIOWI-', PL_N, c'-NIEM-NIU-NIU-', $00 ; Paradigm $0d: Ń-NIA-NIOWI-Ń-NIEM-NIU-NIU-
    dta c'KA-KI-CE-K', PL_E, c'-K', PL_A, c'-CE-KO-', $00 ; Paradigm $0e: KA-KI-CE-KĘ-KĄ-CE-KO-
    dta c'A-Y-ZE-', PL_E, c'-', PL_A, c'-ZE-O-', $00 ; Paradigm $0f: A-Y-ZE-Ę-Ą-ZE-O-
    dta PL_O, PL_L, c'-O', PL_L, c'U-O', PL_L, c'OWI-', PL_O, PL_L, c'-O' ; Paradigm $10: ÓŁ-OŁU-OŁOWI-ÓŁ-OŁEM-OLE-OLE-
    dta PL_L, c'EM-OLE-OLE-', $00
    dta c'O-A-U-O-EM-ZE-O-', $00 ; Paradigm $11: O-A-U-O-EM-ZE-O-
    dta c'O-A-U-O-EM-IE-O-', $00 ; Paradigm $12: O-A-U-O-EM-IE-O-
    dta c'KI-EK-OM-KI-AMI-ACH-KI-', $00 ; Paradigm $13: KI-EK-OM-KI-AMI-ACH-KI-
    dta PL_O, c'R-ORU-OWI-', PL_O, c'R-OREM-ORZE-ORZE-', $00 ; Paradigm $14: ÓR-ORU-OWI-ÓR-OREM-ORZE-ORZE-
    dta c'A-I-I-', PL_E, c'-', PL_A, c'-I-O-', $00 ; Paradigm $15: A-I-I-Ę-Ą-I-O-
    dta c'-A-OWI--EM-IE-IE-', $00 ; Paradigm $16: -A-OWI--EM-IE-IE-

; -----------------------------------------------------------------------------
; Noun Stem Dictionary ($C1D4-$C31C: stem + ':' + paradigm_id + gender/type)
; -----------------------------------------------------------------------------
dict_nouns:
    dta c'P', PL_O, PL_L, c'NOC:', $05, $02 ; Noun $00: PÓŁNOC-
    dta c'PO', PL_L, c'UDNI:', $06, $03 ; Noun $01: POŁUDNI-
    dta c'WSCH:', $07, $00 ; Noun $02: WSCH-
    dta c'ZACH:', $07, $00 ; Noun $03: ZACH-
    dta c'G', PL_O, c'R:', $0f, $02 ; Noun $04: GÓR-
    dta c'D:', $10, $00 ; Noun $05: D-
    dta c'GANDALF:', $01, $01 ; Noun $06: GANDALF-
    dta c'THORIN:', $01, $01 ; Noun $07: THORIN-
    dta c'BARD:', $03, $01 ; Noun $08: BARD-
    dta c'TROLL:', $04, $01 ; Noun $09: TROLL-
    dta c'ELROND:', $03, $01 ; Noun $0a: ELROND-
    dta c'GOBLIN:', $01, $01 ; Noun $0b: GOBLIN-
    dta c'SMOK:', $0c, $01 ; Noun $0c: SMOK-
    dta c'WARG:', $0c, $01 ; Noun $0d: WARG-
    dta c'SKRZYNI:', $02, $02 ; Noun $0e: SKRZYNI-
    dta c'MAP:', $08, $02 ; Noun $0f: MAP-
    dta c'DRZWI:', $09, $05 ; Noun $10: DRZWI-
    dta c'WR:', $0a, $05 ; Noun $11: WR-
    dta c'KLUCZ:', $0b, $00 ; Noun $12: KLUCZ-
    dta c'MIECZ:', $0b, $00 ; Noun $13: MIECZ-
    dta c'PIER', PL_S, c'CIE:', $0d, $00 ; Noun $14: PIERŚCIE-
    dta c'GOLLUM:', $01, $01 ; Noun $15: GOLLUM-
    dta c'KLAP:', $08, $02 ; Noun $16: KLAP-
    dta c'BECZ:', $0e, $02 ; Noun $17: BECZ-
    dta PL_L, PL_O, c'D:', $0e, $02 ; Noun $18: ŁÓD-
    dta c'TRATW:', $08, $02 ; Noun $19: TRATW-
    dta c'LIN:', $08, $02 ; Noun $1a: LIN-
    dta c'BEORN:', $01, $01 ; Noun $1b: BEORN-
    dta c'STRAZNIK:', $0c, $01 ; Noun $1c: STRAZNIK-
    dta PL_S, c'NIADANI:', $06, $03 ; Noun $1d: ŚNIADANI-
    dta c'JEZIOR:', $11, $03 ; Noun $1e: JEZIOR-
    dta c'OKN:', $12, $03 ; Noun $1f: OKN-
    dta c'BRAM:', $08, $02 ; Noun $20: BRAM-
    dta c'BECZ:', $13, $05 ; Noun $21: BECZ-
    dta c'TOP:', $14, $00 ; Noun $22: TOP-
    dta c'PRZEJ', PL_S, c'CI:', $06, $03 ; Noun $23: PRZEJŚCI-
    dta c'OTW:', $14, $00 ; Noun $24: OTW-
    dta c'WEJ', PL_S, c'CI:', $06, $03 ; Noun $25: WEJŚCI-
    dta c'PAJ', PL_A, c'K:', $0c, $01 ; Noun $26: PAJĄK-
    dta c'KUL:', $15, $02 ; Noun $27: KUL-
    dta c'MI', PL_E, c'S:', $12, $03 ; Noun $28: MIĘS-
    dta c'CHLEB:', $16, $01 ; Noun $29: CHLEB-
    dta $00                         ; End of noun dictionary

; -----------------------------------------------------------------------------
; Adjective Stem Dictionary ($C31D-$C3E7: stem + ':' + paradigm_id)
; -----------------------------------------------------------------------------
dict_adjectives:
    dta c'P', PL_O, PL_L, c'NOCN:', $02 ; Adj $00: PÓŁNOCN-
    dta c'PO', PL_L, c'UDNIOW:', $02 ; Adj $01: POŁUDNIOW-
    dta c'OTWART:', $02 ; Adj $02: OTWART-
    dta c'ZAMKNI', PL_E, c'T:', $02 ; Adj $03: ZAMKNIĘT-
    dta c'DZIK:', $01 ; Adj $04: DZIK-
    dta c'GRUB:', $02 ; Adj $05: GRUB-
    dta c'CHUD:', $02 ; Adj $06: CHUD-
    dta c'STAR:', $02 ; Adj $07: STAR-
    dta c'M', PL_L, c'OD:', $02 ; Adj $08: MŁOD-
    dta c'KR', PL_O, c'LEWSK:', $01 ; Adj $09: KRÓLEWSK-
    dta c'STRASZN:', $02 ; Adj $0a: STRASZN-
    dta c'WIELK:', $01 ; Adj $0b: WIELK-
    dta c'DREWNIAN:', $02 ; Adj $0c: DREWNIAN-
    dta c'Z', PL_L, c'OT:', $02 ; Adj $0d: ZŁOT-
    dta c'OKR', PL_A, c'G', PL_L, c':', $02 ; Adj $0e: OKRĄGŁ-
    dta c'KAMIENN:', $02 ; Adj $0f: KAMIENN-
    dta c'CZARN:', $02 ; Adj $10: CZARN-
    dta c'ZABIT:', $02 ; Adj $11: ZABIT-
    dta c'SKAMIENIA', PL_L, c':', $02 ; Adj $12: SKAMIENIAŁ-
    dta c'OKUT:', $02 ; Adj $13: OKUT-
    dta c'UKRYT:', $02 ; Adj $14: UKRYT-
    dta c'PA', PL_L, c'ACOW:', $02 ; Adj $15: PAŁACOW-
    dta c'G', PL_L, PL_O, c'WN:', $02 ; Adj $16: GŁÓWN-
    dta c'KRYSZTA', PL_L, c'OW:', $02 ; Adj $17: KRYSZTAŁOW-
    dta c'SUSZON:', $02 ; Adj $18: SUSZON-
    dta $00                         ; End of adjective dictionary

; -----------------------------------------------------------------------------
; Adjective Declension Paradigms ($C3E8-$C4EE)
; -----------------------------------------------------------------------------
dict_adj_endings:
    dta c'I-IEGO-IEMU-I-IM-IM-I-I-IEGO-IEMU-IEGO-IM-IM-I-A-IEJ-IEJ-', PL_A
    dta c'-', PL_A
    dta c'-IEJ-A-IE-IEGO-IEMU-IE-IM-IM-IE-IE-ICH-ICH-IE-IM-ICH-IE-IE-ICH-ICH-IE-IM-ICH-IE-'
    dta $00
    dta c'Y-EGO-EMU-Y-YM-YM-Y-Y-EGO-EMU-EGO-YM-YM-Y-A-EJ-EJ-', PL_A, c'-'
    dta PL_A
    dta c'-EJ-A-E-EGO-EMU-E-YM-YM-E-E-YCH-YM-E-YMI-YCH-E-E-YCH-YM-E-YMI-YCH-E-'
    dta $00

; -----------------------------------------------------------------------------
; Verb Conjugation Table ($C4EF-$C655: 2nd sg - 3rd sg - infinitive)
; -----------------------------------------------------------------------------
dict_verb_conj:
    dta c'IDZIESZ-IDZIE-I', PL_S, PL_C, c'-', $00 ; Verb $00: IDZIESZ-IDZIE-IŚĆ-
    dta c'PATRZYSZ-PATRZY-PATRZE', PL_C, c'-', $00 ; Verb $01: PATRZYSZ-PATRZY-PATRZEĆ-
    dta c'POKAZUJESZ-POKAZUJE-POKAZA', PL_C, c'-', $00 ; Verb $02: POKAZUJESZ-POKAZUJE-POKAZAĆ-
    dta c'BIERZESZ-BIERZE-WZI', PL_A, PL_C, c'-', $00 ; Verb $03: BIERZESZ-BIERZE-WZIĄĆ-
    dta c'DAJESZ-DAJE-DA', PL_C, c'-', $00 ; Verb $04: DAJESZ-DAJE-DAĆ-
    dta c'ZOSTAWIASZ-ZOSTAWIA-ZOSTAWI', PL_C, c'-', $00 ; Verb $05: ZOSTAWIASZ-ZOSTAWIA-ZOSTAWIĆ-
    dta c'M', PL_O, c'WISZ-M', PL_O, c'WI-POWIEDZIE', PL_C, c'-', $00 ; Verb $06: MÓWISZ-MÓWI-POWIEDZIEĆ-
    dta c'OTWIERASZ-OTWIERA-OTWORZY', PL_C, c'-', $00 ; Verb $07: OTWIERASZ-OTWIERA-OTWORZYĆ-
    dta c'ZAMYKASZ-ZAMYKA-ZAMKN', PL_A, PL_C, c'-', $00 ; Verb $08: ZAMYKASZ-ZAMYKA-ZAMKNĄĆ-
    dta c'ZABIJASZ-ZABIJA-ZABI', PL_C, c'-', $00 ; Verb $09: ZABIJASZ-ZABIJA-ZABIĆ-
    dta c'NAGRYWASZ-NAGRYWA-NAGRA', PL_C, c'-', $00 ; Verb $0a: NAGRYWASZ-NAGRYWA-NAGRAĆ-
    dta c'KO', PL_N, c'CZYSZ-KO', PL_N, c'CZY-KO', PL_N, c'CZ-', $00 ; Verb $0b: KOŃCZYSZ-KOŃCZY-KOŃCZ-
    dta c'CZEKASZ-CZEKA-CZEKA', PL_C, c'-', $00 ; Verb $0c: CZEKASZ-CZEKA-CZEKAĆ-
    dta c'ODCZYTUJESZ-ODCZYTUJE-CZYTA', PL_C, c'-', $00 ; Verb $0d: ODCZYTUJESZ-ODCZYTUJE-CZYTAĆ-
    dta c'JESZ-JE-ZJE', PL_S, PL_C, c'-', $00 ; Verb $0e: JESZ-JE-ZJEŚĆ-

; -----------------------------------------------------------------------------
; Verb Imperative Dictionary ($C656-$C767: imperative + ':' + verb_id)
; -----------------------------------------------------------------------------
dict_verbs:
    dta c'ID', PL_Z_AC, c':', $00 ; "IDŹ" -> Verb $00
    dta c'WEJD', PL_Z_AC, c':', $00 ; "WEJDŹ" -> Verb $00
    dta c'WYJD', PL_Z_AC, c':', $00 ; "WYJDŹ" -> Verb $00
    dta c'ZEJD', PL_Z_AC, c':', $00 ; "ZEJDŹ" -> Verb $00
    dta c'PRZEJD', PL_Z_AC, c':', $00 ; "PRZEJDŹ" -> Verb $00
    dta c'PATRZ:', $01 ; "PATRZ" -> Verb $01
    dta c'POPATRZ:', $01 ; "POPATRZ" -> Verb $01
    dta c'SP', PL_O, c'JRZ:', $01 ; "SPÓJRZ" -> Verb $01
    dta c'ZOBACZ:', $01 ; "ZOBACZ" -> Verb $01
    dta c'ZAJRZYJ:', $01 ; "ZAJRZYJ" -> Verb $01
    dta c'POKA', PL_Z_DOT, c':', $02 ; "POKAŻ" -> Verb $02
    dta c'WE', PL_Z_AC, c':', $03 ; "WEŹ" -> Verb $03
    dta c'ZABIERZ:', $03 ; "ZABIERZ" -> Verb $03
    dta c'DAJ:', $04 ; "DAJ" -> Verb $04
    dta c'ODDAJ:', $04 ; "ODDAJ" -> Verb $04
    dta c'ZOSTAW:', $05 ; "ZOSTAW" -> Verb $05
    dta c'PO', PL_L, PL_O, PL_Z_DOT, c':', $05 ; "POŁÓŻ" -> Verb $05
    dta c'OD', PL_L, PL_O, PL_Z_DOT, c':', $05 ; "ODŁÓŻ" -> Verb $05
    dta c'W', PL_L, PL_O, PL_Z_DOT, c':', $05 ; "WŁÓŻ" -> Verb $05
    dta c'POWIEDZ:', $06 ; "POWIEDZ" -> Verb $06
    dta c'OTW', PL_O, c'RZ:', $07 ; "OTWÓRZ" -> Verb $07
    dta c'ZAMKNIJ:', $08 ; "ZAMKNIJ" -> Verb $08
    dta c'ZABIJ:', $09 ; "ZABIJ" -> Verb $09
    dta c'NAGRAJ:', $0a ; "NAGRAJ" -> Verb $0a
    dta c'SAVE:', $0a ; "SAVE" -> Verb $0a
    dta c'KO', PL_N, c'CZ:', $0b ; "KOŃCZ" -> Verb $0b
    dta c'SKO', PL_N, c'CZ:', $0b ; "SKOŃCZ" -> Verb $0b
    dta c'ZAKO', PL_N, c'CZ:', $0b ; "ZAKOŃCZ" -> Verb $0b
    dta c'POCZEKAJ:', $0c ; "POCZEKAJ" -> Verb $0c
    dta c'ZACZEKAJ:', $0c ; "ZACZEKAJ" -> Verb $0c
    dta c'CZEKAJ:', $0c ; "CZEKAJ" -> Verb $0c
    dta c'CZYTAJ:', $0d ; "CZYTAJ" -> Verb $0d
    dta c'PRZECZYTAJ:', $0d ; "PRZECZYTAJ" -> Verb $0d
    dta c'ODCZYTAJ:', $0d ; "ODCZYTAJ" -> Verb $0d
    dta c'ZJEDZ:', $0e ; "ZJEDZ" -> Verb $0e
    dta $00                         ; End of verb dictionary

; -----------------------------------------------------------------------------
; Preposition & Conjunction Dictionary ($C768-$C7A5)
; -----------------------------------------------------------------------------
dict_preps:
    dta c'I:', $00, $00 ; "I"
    dta c'ORAZ:', $00, $00 ; "ORAZ"
    dta c'PRZEZ:', $01, $00 ; "PRZEZ"
    dta c'PRZEZE:', $01, $01 ; "PRZEZE"
    dta c'NA:', $02, $00 ; "NA"
    dta c'W:', $03, $00 ; "W"
    dta c'WE:', $03, $01 ; "WE"
    dta c'DO:', $04, $00 ; "DO"
    dta c'Z:', $05, $00 ; "Z"
    dta c'ZE:', $05, $01 ; "ZE"
    dta c'OD:', $06, $00 ; "OD"
    dta $00                         ; End of preposition dictionary

; -----------------------------------------------------------------------------
; Initial Object Table ($C7A6-$C94E: 53 x 8-byte records, copied to $B000)
; Format: [adj1, adj2, noun, room, dir/prop, flags, container, key]
; -----------------------------------------------------------------------------
init_objects:
    dta $ff, $ff, $07, $02, $00, $80, $8a, $fe ; Obj $01: THORIN- (Room $02)
    dta $ff, $ff, $06, $01, $00, $80, $8a, $fe ; Obj $02: GANDALF- (Room $01)
    dta $ff, $ff, $0a, $06, $00, $80, $8a, $fe ; Obj $03: ELROND- (Room $06)
    dta $ff, $ff, $1b, $27, $00, $80, $8a, $fe ; Obj $04: BEORN- (Room $27)
    dta $04, $ff, $0d, $0c, $00, $80, $82, $13 ; Obj $05: DZIK- WARG- (Room $0c)
    dta $05, $ff, $0b, $1a, $00, $80, $82, $fe ; Obj $06: GRUB- GOBLIN- (Room $1a)
    dta $06, $ff, $0b, $1a, $00, $80, $82, $fe ; Obj $07: CHUD- GOBLIN- (Room $1a)
    dta $07, $ff, $0b, $1a, $00, $80, $82, $fe ; Obj $08: STAR- GOBLIN- (Room $1a)
    dta $08, $ff, $0b, $1a, $00, $80, $82, $fe ; Obj $09: MŁOD- GOBLIN- (Room $1a)
    dta $07, $04, $09, $03, $00, $80, $82, $fe ; Obj $0a: STAR- DZIK- TROLL- (Room $03)
    dta $08, $04, $09, $03, $00, $80, $82, $fe ; Obj $0b: MŁOD- DZIK- TROLL- (Room $03)
    dta $09, $ff, $1c, $3b, $00, $80, $8a, $fe ; Obj $0c: KRÓLEWSK- STRAZNIK- (Room $3b)
    dta $ff, $ff, $08, $3d, $00, $80, $8a, $ff ; Obj $0d: BARD- (Room $3d)
    dta $0a, $ff, $0c, $52, $00, $80, $8a, $fe ; Obj $0e: STRASZN- SMOK- (Room $52)
    dta $ff, $ff, $15, $22, $00, $80, $8a, $fe ; Obj $0f: GOLLUM- (Room $22)
    dta $0b, $0c, $0e, $01, $00, $80, $44, $ff ; Obj $10: WIELK- DREWNIAN- SKRZYNI- (Room $01)
    dta $0d, $ff, $14, $22, $00, $80, $01, $ff ; Obj $11: ZŁOT- PIERŚCIE- (Room $22)
    dta $07, $ff, $0f, $10, $00, $40, $01, $ff ; Obj $12: STAR- MAP- (Room $10)
    dta $ff, $ff, $13, $05, $00, $80, $01, $ff ; Obj $13: MIECZ- (Room $05)
    dta $0b, $ff, $22, $05, $00, $80, $01, $ff ; Obj $14: WIELK- TOP- (Room $05)
    dta $ff, $ff, $1d, $03, $00, $20, $01, $ff ; Obj $15: ŚNIADANI- (Room $03)
    dta $0e, $ff, $10, $01, $02, $02, $60, $ff ; Obj $16: OKRĄGŁ- DRZWI- (Room $01)
    dta $0b, $ff, $12, $0a, $00, $20, $01, $ff ; Obj $17: WIELK- KLUCZ- (Room $0a)
    dta $0f, $ff, $10, $04, $05, $00, $60, $17 ; Obj $18: KAMIENN- DRZWI- (Room $04)
    dta $0d, $ff, $12, $10, $00, $80, $01, $ff ; Obj $19: ZŁOT- KLUCZ- (Room $10)
    dta $0f, $ff, $11, $1a, $12, $01, $60, $11 ; Obj $1a: KAMIENN- WR- (Room $1a)
    dta $10, $ff, $1e, $20, $24, $04, $20, $ff ; Obj $1b: CZARN- JEZIOR- (Room $20)
    dta $10, $ff, $1e, $23, $24, $02, $20, $ff ; Obj $1c: CZARN- JEZIOR- (Room $23)
    dta $ff, $ff, $1f, $13, $14, $08, $60, $fe ; Obj $1d: OKN- (Room $13)
    dta $10, $ff, $1e, $22, $24, $00, $20, $ff ; Obj $1e: CZARN- JEZIOR- (Room $22)
    dta $10, $ff, $1e, $21, $24, $06, $20, $ff ; Obj $1f: CZARN- JEZIOR- (Room $21)
    dta $ff, $ff, $20, $25, $26, $01, $70, $fe ; Obj $20: BRAM- (Room $25)
    dta $0c, $ff, $10, $26, $27, $02, $60, $ff ; Obj $21: DREWNIAN- DRZWI- (Room $26)
    dta $ff, $ff, $18, $2c, $2e, $80, $20, $ff ; Obj $22: ŁÓD- (Room $2c)
    dta $ff, $ff, $18, $35, $37, $80, $20, $ff ; Obj $23: ŁÓD- (Room $35)
    dta $13, $ff, $10, $38, $3a, $02, $60, $19 ; Obj $24: OKUT- DRZWI- (Room $38)
    dta $0c, $ff, $10, $39, $3a, $04, $60, $19 ; Obj $25: DREWNIAN- DRZWI- (Room $39)
    dta $0c, $ff, $16, $3b, $3c, $09, $70, $fe ; Obj $26: DREWNIAN- KLAP- (Room $3b)
    dta $02, $ff, $17, $3b, $37, $80, $20, $ff ; Obj $27: OTWART- BECZ- (Room $3b)
    dta $03, $ff, $21, $3b, $00, $80, $00, $ff ; Obj $28: ZAMKNIĘT- BECZ- (Room $3b)
    dta $14, $ff, $23, $00, $00, $80, $20, $ff ; Obj $29: UKRYT- PRZEJŚCI- (Nowhere)
    dta $15, $ff, $20, $4a, $4b, $02, $70, $fe ; Obj $2a: PAŁACOW- BRAM- (Room $4a)
    dta $ff, $ff, $19, $4c, $4f, $80, $20, $ff ; Obj $2b: TRATW- (Room $4c)
    dta $16, $ff, $25, $4f, $52, $02, $20, $ff ; Obj $2c: GŁÓWN- WEJŚCI- (Room $4f)
    dta $ff, $ff, $23, $51, $52, $09, $20, $ff ; Obj $2d: PRZEJŚCI- (Room $51)
    dta $ff, $ff, $24, $50, $51, $02, $20, $ff ; Obj $2e: OTW- (Room $50)
    dta $ff, $ff, $1e, $4c, $4d, $02, $20, $ff ; Obj $2f: JEZIOR- (Room $4c)
    dta $ff, $ff, $1e, $4e, $4f, $02, $20, $ff ; Obj $30: JEZIOR- (Room $4e)
    dta $10, $ff, $26, $33, $00, $80, $82, $14 ; Obj $31: CZARN- PAJĄK- (Room $33)
    dta $13, $ff, $0e, $52, $00, $80, $44, $ff ; Obj $32: OKUT- SKRZYNI- (Room $52)
    dta $17, $ff, $27, $32, $00, $40, $01, $ff ; Obj $33: KRYSZTAŁOW- KUL- (Room $32)
    dta $18, $ff, $28, $04, $00, $20, $01, $ff ; Obj $34: SUSZON- MIĘS- (Room $04)
    dta $ff, $ff, $29, $38, $00, $80, $01, $ff ; Obj $35: CHLEB- (Room $38)
    dta $fe                         ; End of object table ($FE)

; -----------------------------------------------------------------------------
; Room Exits Matrix ($C94F-$CC82: 82 rooms x 10 directions)
; Columns: [N, NE, E, SE, S, SW, W, NW, UP, DOWN]
; -----------------------------------------------------------------------------
room_exits:
    dta $00, $00, $02, $00, $00, $00, $00, $00, $00, $00 ; Room $01 (1): W WYGODNYM TUNELU
    dta $00, $04, $03, $00, $00, $00, $01, $00, $00, $00 ; Room $02 (2): NA PUSTKOWIU
    dta $04, $00, $06, $00, $00, $00, $02, $00, $00, $00 ; Room $03 (3): NA POLANIE TROLLI
    dta $05, $00, $00, $06, $03, $02, $00, $00, $00, $00 ; Room $04 (4): NA SKALNEJ ŚCIEŻCE
    dta $00, $00, $00, $00, $04, $00, $00, $00, $00, $00 ; Room $05 (5): W SKALNEJ PIECZARZE
    dta $00, $00, $07, $00, $00, $00, $03, $04, $00, $00 ; Room $06 (6): W RIVENDELL
    dta $08, $00, $12, $00, $0b, $00, $06, $00, $00, $00 ; Room $07 (7): W DOLINIE MGIEŁ
    dta $00, $00, $00, $00, $07, $00, $00, $00, $00, $09 ; Room $08 (8): W GÓRACH MGLISTYCH
    dta $00, $00, $00, $00, $0a, $00, $00, $00, $08, $00 ; Room $09 (9): W GÓRACH MGLISTYCH
    dta $09, $00, $00, $00, $00, $00, $00, $00, $0b, $00 ; Room $0a (10): W GÓRACH MGLISTYCH
    dta $07, $00, $00, $00, $0c, $00, $00, $00, $00, $0a ; Room $0b (11): W GÓRACH MGLISTYCH
    dta $0b, $00, $0d, $00, $0f, $00, $00, $00, $00, $00 ; Room $0c (12): W GÓRACH MGLISTYCH
    dta $00, $00, $00, $00, $0e, $00, $0c, $00, $00, $11 ; Room $0d (13): W GÓRACH MGLISTYCH
    dta $0d, $00, $00, $00, $00, $00, $0f, $00, $00, $10 ; Room $0e (14): W GÓRACH MGLISTYCH
    dta $0c, $00, $0e, $00, $00, $00, $00, $00, $00, $00 ; Room $0f (15): W GÓRACH MGLISTYCH
    dta $11, $00, $00, $00, $00, $00, $00, $00, $0e, $00 ; Room $10 (16): W GÓRACH MGLISTYCH
    dta $00, $00, $00, $00, $10, $00, $00, $00, $0d, $00 ; Room $11 (17): W GÓRACH MGLISTYCH
    dta $00, $00, $25, $00, $00, $1a, $07, $00, $00, $00 ; Room $12 (18): NA SKALNEJ ŚCIEZCE
    dta $00, $00, $00, $00, $00, $00, $00, $00, $14, $00 ; Room $13 (19): W LOCHU GOBLINÓW
    dta $00, $00, $15, $00, $18, $00, $00, $00, $00, $13 ; Room $14 (20): W LABIRYNCIE KORYTARZY
    dta $00, $00, $16, $00, $19, $00, $14, $00, $00, $00 ; Room $15 (21): W LABIRYNCIE KORYTARZY
    dta $19, $00, $00, $00, $00, $00, $15, $00, $00, $00 ; Room $16 (22): W LABIRYNCIE KORYTARZY
    dta $00, $00, $00, $00, $1a, $00, $1a, $1a, $00, $00 ; Room $17 (23): W LABIRYNCIE KORYTARZY
    dta $14, $00, $19, $00, $1c, $00, $00, $00, $00, $00 ; Room $18 (24): W LABIRYNCIE KORYTARZY
    dta $15, $00, $1f, $00, $1d, $00, $18, $1e, $00, $00 ; Room $19 (25): W LABIRYNCIE KORYTARZY
    dta $17, $12, $17, $17, $1e, $00, $00, $00, $00, $00 ; Room $1a (26): W LABIRYNCIE KORYTARZY
    dta $00, $00, $1c, $00, $1f, $00, $00, $00, $00, $20 ; Room $1b (27): W LABIRYNCIE KORYTARZY
    dta $18, $00, $1d, $00, $00, $00, $1b, $00, $00, $00 ; Room $1c (28): W LABIRYNCIE KORYTARZY
    dta $19, $00, $1e, $00, $00, $00, $1c, $00, $00, $00 ; Room $1d (29): W LABIRYNCIE KORYTARZY
    dta $1a, $00, $00, $00, $19, $00, $1d, $00, $00, $00 ; Room $1e (30): W LABIRYNCIE KORYTARZY
    dta $1b, $00, $00, $00, $00, $00, $19, $00, $00, $00 ; Room $1f (31): W LABIRYNCIE KORYTARZY
    dta $00, $00, $00, $21, $24, $23, $00, $00, $1b, $00 ; Room $20 (32): W PIECZARZE NAD CZARNYM  JEZIOREM
    dta $00, $00, $00, $00, $00, $22, $24, $20, $00, $00 ; Room $21 (33): W PIECZARZE NAD CZARNYM  JEZIOREM
    dta $24, $21, $00, $00, $00, $00, $00, $23, $00, $00 ; Room $22 (34): W PIECZARZE NAD CZARNYM  JEZIOREM
    dta $00, $20, $24, $22, $00, $00, $00, $00, $00, $00 ; Room $23 (35): W PIECZARZE NAD CZARNYM  JEZIOREM
    dta $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ; Room $24 (36): W CZARNYM JEZIORZE
    dta $00, $26, $00, $00, $00, $00, $12, $00, $00, $00 ; Room $25 (37): NA SKALNEJ ŚCIEZCE
    dta $00, $00, $27, $00, $00, $25, $00, $00, $00, $00 ; Room $26 (38): NA PODWÓRZU POD DOMEM\nBEORNA
    dta $00, $28, $29, $2b, $00, $00, $26, $00, $00, $00 ; Room $27 (39): W DOMU BEORNA
    dta $00, $00, $2a, $00, $2a, $27, $00, $00, $00, $00 ; Room $28 (40): W LESIE
    dta $00, $00, $2a, $00, $00, $00, $27, $00, $00, $00 ; Room $29 (41): W LESIE
    dta $28, $00, $2c, $00, $2b, $00, $29, $00, $00, $00 ; Room $2a (42): W LESIE
    dta $2a, $00, $2a, $00, $00, $00, $00, $27, $00, $00 ; Room $2b (43): W LESIE
    dta $00, $00, $2d, $00, $00, $00, $2a, $00, $00, $00 ; Room $2c (44): NA ZACHODNIM BRZEGU\nCZARNEJ RZEKI
    dta $00, $00, $2e, $00, $00, $00, $2c, $00, $00, $00 ; Room $2d (45): W CZARNEJ RZECE
    dta $00, $00, $2f, $00, $00, $00, $2d, $00, $00, $00 ; Room $2e (46): NA WSCHODNIM BRZEGU\nCZARNEJ RZEKI
    dta $00, $00, $32, $00, $31, $00, $2e, $32, $00, $00 ; Room $2f (47): W LESIE
    dta $00, $00, $00, $33, $32, $31, $31, $31, $00, $00 ; Room $30 (48): W LESIE
    dta $2f, $30, $30, $30, $00, $00, $00, $00, $00, $00 ; Room $31 (49): W LESIE
    dta $30, $00, $00, $2f, $00, $00, $2f, $00, $00, $00 ; Room $32 (50): W LESIE
    dta $00, $00, $34, $00, $00, $00, $00, $30, $00, $00 ; Room $33 (51): NA LEŚNEJ POLANIE
    dta $00, $00, $35, $00, $00, $00, $33, $00, $00, $00 ; Room $34 (52): NA LEŚNEJ POLANIE
    dta $00, $00, $00, $00, $36, $00, $34, $00, $00, $00 ; Room $35 (53): NA PÓŁNOCNYM BRZEGU\nWIELKIEJ RZEKI
    dta $35, $00, $00, $00, $37, $00, $00, $00, $00, $00 ; Room $36 (54): W WIELKIEJ RZECE
    dta $36, $00, $41, $00, $00, $00, $00, $00, $00, $00 ; Room $37 (55): NA POŁUDNIOWYM BRZEGU\nWIELKIEJ RZEKI
    dta $00, $00, $3a, $00, $00, $00, $00, $00, $00, $00 ; Room $38 (56): W LOCHU KRÓLA ELFÓW
    dta $00, $00, $00, $00, $3a, $00, $00, $00, $00, $00 ; Room $39 (57): W LOCHU KRÓLA ELFÓW
    dta $39, $00, $3b, $00, $00, $00, $38, $00, $00, $00 ; Room $3a (58): W KORYTARZU
    dta $00, $00, $00, $00, $00, $00, $3a, $00, $00, $3c ; Room $3b (59): W PAŁACOWEJ PIWNICY
    dta $00, $00, $00, $00, $00, $00, $00, $00, $3b, $00 ; Room $3c (60): W WODOSPADZIE
    dta $00, $00, $00, $42, $00, $00, $00, $00, $00, $00 ; Room $3d (61): W MIEŚCIE NAD JEZIOREM
    dta $00, $49, $00, $00, $42, $00, $00, $00, $00, $00 ; Room $3e (62): W MIEŚCIE NAD JEZIOREM
    dta $00, $00, $40, $00, $00, $42, $00, $00, $00, $00 ; Room $3f (63): W MIEŚCIE NAD JEZIOREM
    dta $00, $00, $00, $00, $00, $00, $3f, $00, $00, $00 ; Room $40 (64): W MIEŚCIE NAD JEZIOREM
    dta $00, $00, $00, $46, $00, $48, $37, $00, $00, $00 ; Room $41 (65): W MIEŚCIE NAD JEZIOREM
    dta $3e, $3f, $43, $00, $00, $00, $00, $3d, $00, $00 ; Room $42 (66): W MIEŚCIE NAD JEZIOREM
    dta $00, $00, $44, $00, $00, $46, $42, $00, $00, $00 ; Room $43 (67): W MIEŚCIE NAD JEZIOREM
    dta $00, $00, $00, $00, $00, $47, $43, $00, $00, $00 ; Room $44 (68): W MIEŚCIE NAD JEZIOREM
    dta $00, $00, $46, $00, $00, $00, $00, $00, $00, $00 ; Room $45 (69): W MIEŚCIE NAD JEZIOREM
    dta $00, $43, $00, $00, $00, $00, $45, $41, $00, $00 ; Room $46 (70): W MIEŚCIE NAD JEZIOREM
    dta $00, $44, $00, $00, $00, $00, $00, $00, $00, $00 ; Room $47 (71): W MIEŚCIE NAD JEZIOREM
    dta $00, $41, $00, $00, $00, $00, $00, $00, $00, $00 ; Room $48 (72): W MIEŚCIE NAD JEZIOREM
    dta $00, $00, $4a, $00, $00, $3e, $00, $00, $00, $00 ; Room $49 (73): W MIEŚCIE NAD JEZIOREM
    dta $00, $00, $4b, $00, $00, $00, $49, $00, $00, $00 ; Room $4a (74): W MIEŚCIE NAD JEZIOREM
    dta $00, $00, $00, $00, $00, $00, $4a, $00, $00, $00 ; Room $4b (75): W PAŁACU
    dta $00, $00, $4d, $00, $00, $00, $00, $00, $00, $00 ; Room $4c (76): NA PRZYSTANI
    dta $00, $00, $00, $00, $00, $00, $4c, $00, $00, $00 ; Room $4d (77): W JEZIORZE
    dta $00, $00, $4f, $00, $00, $00, $00, $00, $00, $00 ; Room $4e (78): W JEZIORZE
    dta $00, $50, $52, $00, $00, $00, $4e, $00, $00, $00 ; Room $4f (79): NA KAMIENISTEJ PLAŻY
    dta $00, $00, $51, $00, $00, $4f, $00, $00, $00, $00 ; Room $50 (80): NA SKALNEJ PÓŁCE
    dta $00, $00, $00, $00, $00, $00, $50, $00, $00, $52 ; Room $51 (81): W CIASNEJ PIECZARZE
    dta $00, $00, $00, $00, $00, $00, $4f, $00, $51, $00 ; Room $52 (82): W JASKINI SMOKA

    PROGRAM_FOOTER
