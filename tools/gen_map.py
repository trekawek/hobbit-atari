#!/usr/bin/env python3
"""
Generate a complete visual world map of 'Hobbit czyli w te i wewte...' (82 rooms, $01-$52)
using PyCairo. Outputs screenshots/map.png.
"""
import math
import cairo

WIDTH = 2640
HEIGHT = 1940


def draw_rounded_rect(ctx, x, y, w, h, r):
    ctx.new_sub_path()
    ctx.arc(x + w - r, y + r, r, -math.pi / 2, 0)
    ctx.arc(x + w - r, y + h - r, r, 0, math.pi / 2)
    ctx.arc(x + r, y + h - r, r, math.pi / 2, math.pi)
    ctx.arc(x + r, y + r, r, math.pi, 3 * math.pi / 2)
    ctx.close_path()


def set_color_hex(ctx, hex_str, alpha=1.0):
    hex_str = hex_str.lstrip("#")
    r = int(hex_str[0:2], 16) / 255.0
    g = int(hex_str[2:4], 16) / 255.0
    b = int(hex_str[4:6], 16) / 255.0
    ctx.set_source_rgba(r, g, b, alpha)


def main():
    surface = cairo.ImageSurface(cairo.FORMAT_ARGB32, WIDTH, HEIGHT)
    ctx = cairo.Context(surface)

    # Dark slate background
    set_color_hex(ctx, "#0f141d")
    ctx.paint()

    # Title banner
    draw_rounded_rect(ctx, 25, 18, WIDTH - 50, 72, 12)
    set_color_hex(ctx, "#1a2333")
    ctx.fill_preserve()
    set_color_hex(ctx, "#4a6491")
    ctx.set_line_width(2)
    ctx.stroke()

    ctx.select_font_face("DejaVu Sans", cairo.FONT_SLANT_NORMAL, cairo.FONT_WEIGHT_BOLD)
    ctx.set_font_size(27)
    set_color_hex(ctx, "#ffd866")
    ctx.move_to(48, 52)
    ctx.show_text("HOBBIT CZYLI W TE I WEWTE... (1988) — PEŁNA MAPA ŚWIATA GRY (82 LOKACJE: $01–$52)")

    ctx.select_font_face("DejaVu Sans", cairo.FONT_SLANT_NORMAL, cairo.FONT_WEIGHT_NORMAL)
    ctx.set_font_size(14)
    set_color_hex(ctx, "#b8c7e0")
    ctx.move_to(48, 76)
    ctx.show_text(
        "Wszystkie lokacje ($01–$52), przejścia kierunkowe, drzwi i klucze, postacie (NPC), przedmioty, przeprawy (łódki, beczka, tratwa) oraz pułapki."
    )

    # Region boxes: (x, y, w, h, title, color_hex)
    regions = [
        (25, 104, 780, 435, "1. HOBBITON, POLANA TROLLI I RIVENDELL ($01–$06)", "#2e4a3b"),
        (820, 104, 865, 435, "2. DOLINA MGIEŁ I GÓRY MGLISTE ($07–$12)", "#3b3e54"),
        (1700, 104, 915, 645, "3. LOCHY GOBLINÓW, LABIRYNT I CZARNE JEZIORO ($13–$24)", "#42334a"),
        (25, 560, 780, 580, "4. DOM BEORNA I ZACHODNIA MROCZNA PUSZCZA ($25–$2E)", "#2d4739"),
        (820, 560, 865, 675, "5. WSCHODNIA PUSZCZA, WIELKA RZEKA I LOCHY ELFÓW ($2F–$3C)", "#294649"),
        (25, 1160, 1230, 595, "6. MIASTO NAD JEZIOREM — ESGAROTH ($3D–$4B)", "#3d392e"),
        (1275, 1255, 1340, 500, "7. DŁUGIE JEZIORO I SAMOTNA GÓRA — EREBOR ($4C–$52)", "#4d2f2f"),
    ]

    for rx, ry, rw, rh, rtitle, rcol in regions:
        draw_rounded_rect(ctx, rx, ry, rw, rh, 12)
        set_color_hex(ctx, rcol, 0.25)
        ctx.fill_preserve()
        set_color_hex(ctx, rcol, 0.95)
        ctx.set_line_width(2)
        ctx.stroke()

        draw_rounded_rect(ctx, rx, ry, rw, 32, 12)
        set_color_hex(ctx, rcol, 0.78)
        ctx.fill()

        ctx.select_font_face("DejaVu Sans", cairo.FONT_SLANT_NORMAL, cairo.FONT_WEIGHT_BOLD)
        ctx.set_font_size(14)
        set_color_hex(ctx, "#ffffff")
        ctx.move_to(rx + 16, ry + 21)
        ctx.show_text(rtitle)

    # Room definitions: id -> (cx, cy, short_name, sub_info, kind)
    rooms = {
        # Region 1 ($01-$06)
        0x01: (120, 445, "W WYGODNYM TUNELU", "START • Gandalf • Skrzynia (Mapa)", "start"),
        0x02: (325, 445, "NA PUSTKOWIU", "Thorin", "normal"),
        0x03: (520, 445, "NA POLANIE TROLLI", "2 Trolle → Wielki klucz", "danger"),
        0x04: (520, 310, "NA SKALNEJ ŚCIEŻCE", "Kamienne drzwi [N]", "normal"),
        0x05: (520, 185, "W SKALNEJ PIECZARZE", "Miecz • Wielki topór", "item"),
        0x06: (715, 445, "W RIVENDELL", "Elrond → Śniadanie", "item"),

        # Region 2 ($07-$12)
        0x07: (925, 305, "W DOLINIE MGIEŁ", "Rozwidlenie dróg", "normal"),
        0x08: (925, 185, "W GÓRACH MGLISTYCH", "Szczyt północny", "normal"),
        0x09: (1105, 185, "W GÓRACH MGLISTYCH", "Przełęcz północna", "normal"),
        0x0A: (1105, 305, "W GÓRACH MGLISTYCH", "Skalny występ", "normal"),
        0x0B: (925, 405, "W GÓRACH MGLISTYCH", "Szlak południowy", "normal"),
        0x0C: (1105, 405, "W GÓRACH MGLISTYCH", "Dziki warg (patrol $0C–$0F)", "danger"),
        0x0D: (1285, 405, "W GÓRACH MGLISTYCH", "Zejście na wschód", "normal"),
        0x0F: (1105, 495, "W GÓRACH MGLISTYCH", "Południowy zakręt", "normal"),
        0x0E: (1285, 495, "W GÓRACH MGLISTYCH", "Krawędź rozpadliny", "normal"),
        0x11: (1465, 405, "W GÓRACH MGLISTYCH", "Dolna półka (N)", "normal"),
        0x10: (1465, 495, "W GÓRACH MGLISTYCH", "Złoty klucz", "item"),
        0x12: (1585, 285, "NA SKALNEJ ŚCIEŻCE", "Zasadzka Goblinów → $13!", "danger"),

        # Region 3 ($13-$24)
        0x13: (1795, 200, "W LOCHU GOBLINÓW", "Okno [U] (otwiera Thorin)", "danger"),
        0x14: (1980, 200, "W LABIRYNCIE", "Korytarz wejściowy", "normal"),
        0x15: (2160, 200, "W LABIRYNCIE", "Korytarz północny", "normal"),
        0x16: (2340, 200, "W LABIRYNCIE", "Ślepy zaułek (N→$19)", "normal"),
        0x17: (2520, 200, "W LABIRYNCIE", "Pętla przy wrotach", "normal"),
        0x18: (1980, 295, "W LABIRYNCIE", "Korytarz zachodni", "normal"),
        0x19: (2160, 295, "W LABIRYNCIE", "Skrzyżowanie centralne", "normal"),
        0x1F: (2340, 295, "W LABIRYNCIE", "Korytarz wschodni", "normal"),
        0x1A: (2520, 295, "W LABIRYNCIE", "4 Gobliny • Wrota [NE→$12]", "danger"),
        0x1B: (1980, 390, "W LABIRYNCIE", "Zejście nad jezioro [D]", "normal"),
        0x1C: (2160, 390, "W LABIRYNCIE", "Korytarz południowy", "normal"),
        0x1D: (2340, 390, "W LABIRYNCIE", "Korytarz dolny", "normal"),
        0x1E: (2520, 390, "W LABIRYNCIE", "Korytarz pod wrotami", "normal"),
        0x20: (2160, 490, "NAD CZARNYM JEZIOREM", "Brzeg północny [U→$1B]", "normal"),
        0x23: (1950, 585, "NAD CZARNYM JEZIOREM", "Brzeg zachodni", "normal"),
        0x24: (2160, 585, "W CZARNYM JEZIORZE", "ŚMIERĆ (Utonięcie!)", "death"),
        0x21: (2370, 585, "NAD CZARNYM JEZIOREM", "Brzeg wschodni", "normal"),
        0x22: (2160, 685, "NAD CZARNYM JEZIOREM", "Gollum • Złoty pierścień", "item"),

        # Region 4 ($25-$2E) — zero crossing layout!
        0x25: (120, 650, "NA SKALNEJ ŚCIEŻCE", "Brama [NE→$26]", "normal"),
        0x26: (120, 775, "POD DOMEM BEORNA", "Drewniane drzwi [E→$27]", "normal"),
        0x27: (310, 775, "W DOMU BEORNA", "Beorn → Suszone mięso", "item"),
        0x28: (505, 665, "W LESIE ($28)", "Północny skraj puszczy", "normal"),
        0x29: (505, 775, "W LESIE ($29)", "Leśna ścieżka", "normal"),
        0x2B: (505, 885, "W LESIE ($2B)", "Południowy gąszcz", "normal"),
        0x2A: (705, 775, "W LESIE ($2A)", "Skrzyżowanie w puszczy", "normal"),
        0x2C: (705, 925, "ZACH. BRZEG CZ. RZEKI", "Łódka (z Pierścieniem → $2E)", "water_passage"),
        0x2D: (485, 1045, "W CZARNEJ RZECE", "ŚMIERĆ (Utonięcie!)", "death"),
        0x2E: (705, 1075, "WSCH. BRZEG CZ. RZEKI", "Wyjście do Wsch. Puszczy", "normal"),

        # Region 5 ($2F-$3C)
        0x2F: (925, 655, "W LESIE ($2F)", "Wejście do gęstwiny", "normal"),
        0x32: (1120, 655, "W LESIE ($32)", "Pętla leśna", "normal"),
        0x31: (925, 765, "W LESIE ($31)", "Gęstwina (S)", "normal"),
        0x30: (1120, 765, "W LESIE ($30)", "Wyjście na polanę [SE]", "normal"),
        0x33: (1325, 765, "NA LEŚNEJ POLANIE", "Czarny pająk (zabija Thorin)", "danger"),
        0x34: (1555, 765, "NA LEŚNEJ POLANIE", "Elfy łapią → $38 / $39!", "danger"),
        0x35: (1585, 900, "PN. BRZEG W. RZEKI", "Łódka (→ $37)", "water_passage"),
        0x36: (1585, 1025, "W WIELKIEJ RZECE", "ŚMIERĆ (Utonięcie!)", "death"),
        0x37: (1585, 1155, "PD. BRZEG W. RZEKI", "Lądowanie beczki / łódki", "water_passage"),
        0x38: (925, 1005, "W LOCHU KRÓLA ELFÓW", "Cela Bilba • Chleb • Drzwi", "item"),
        0x39: (1135, 895, "W LOCHU KRÓLA ELFÓW", "Cela Thorina • Drzwi [S]", "normal"),
        0x3A: (1135, 1005, "W KORYTARZU", "Między celami a piwnicą", "normal"),
        0x3B: (1355, 1005, "W PAŁACOWEJ PIWNICY", "Strażnik • Otwarta beczka →$37", "water_passage"),
        0x3C: (1355, 1155, "W WODOSPADZIE", "ŚMIERĆ (Utonięcie!)", "death"),

        # Region 6 ($3D-$4B) — 100% compass-aligned, zero crossings!
        0x49: (685, 1245, "W MIEŚCIE ($49)", "Aleja pałacowa", "normal"),
        0x4A: (905, 1245, "W MIEŚCIE ($4A)", "Pałacowa brama [E→$4B]", "normal"),
        0x4B: (1135, 1245, "W PAŁACU ($4B)", "ŚMIERĆ / Więzienie!", "death"),
        0x3D: (285, 1365, "W MIEŚCIE ($3D)", "Start Barda", "item"),
        0x3E: (485, 1365, "W MIEŚCIE ($3E)", "Północny pomost", "normal"),
        0x3F: (685, 1365, "W MIEŚCIE ($3F)", "Droga do przystani", "normal"),
        0x40: (905, 1365, "W MIEŚCIE ($40)", "Bard → Ukryte przejście →$4C", "water_passage"),
        0x41: (285, 1490, "W MIEŚCIE ($41)", "Wejście od Wielkiej Rzeki", "normal"),
        0x42: (485, 1490, "W MIEŚCIE ($42)", "Główny plac", "normal"),
        0x43: (685, 1490, "W MIEŚCIE ($43)", "Wschodni pomost", "normal"),
        0x44: (905, 1490, "W MIEŚCIE ($44)", "Wschodni kraniec", "normal"),
        0x48: (115, 1625, "W MIEŚCIE ($48)", "Południowo-zach. zaułek", "normal"),
        0x45: (285, 1625, "W MIEŚCIE ($45)", "Zachodni zaułek", "normal"),
        0x46: (485, 1625, "W MIEŚCIE ($46)", "Południowy pomost", "normal"),
        0x47: (685, 1625, "W MIEŚCIE ($47)", "Południowo-wsch. zaułek", "normal"),

        # Region 7 ($4C-$52)
        0x4C: (1405, 1445, "NA PRZYSTANI", "Tratwa (→ $4F)", "water_passage"),
        0x4D: (1405, 1625, "W JEZIORZE ($4D)", "ŚMIERĆ (Utonięcie!)", "death"),
        0x4E: (1745, 1625, "W JEZIORZE ($4E)", "ŚMIERĆ (Utonięcie!)", "death"),
        0x4F: (1745, 1445, "NA KAMIENISTEJ PLAŻY", "Podnóże Samotnej Góry", "normal"),
        0x50: (2055, 1365, "NA SKALNEJ PÓŁCE", "Otwór [E→$51]", "normal"),
        0x51: (2425, 1365, "W CIASNEJ PIECZARZE", "Przejście w dół [D→$52]", "normal"),
        0x52: (2425, 1585, "W JASKINI SMOKA", "Smaug • Okuta skrzynia (Kula!)", "goal"),
    }

    # Edges: (ra, rb, label, style, label_offset_x, label_offset_y)
    edges = [
        # Region 1
        (0x01, 0x02, "E/W: Okrągłe drzwi", "door", 0, -35),
        (0x02, 0x03, "E/W", "normal", 0, 0),
        (0x02, 0x04, "NE/SW", "normal", -12, -8),
        (0x03, 0x04, "N/S", "normal", 0, 0),
        (0x04, 0x05, "N/S: Kamienne drzwi (Wielki klucz)", "door", 0, 0),
        (0x03, 0x06, "E/W", "normal", 0, 0),
        (0x04, 0x06, "SE/NW", "normal", 12, -8),
        (0x06, 0x07, "E/W", "normal", -5, -12),

        # Region 2
        (0x07, 0x08, "N/S", "normal", 0, 0),
        (0x08, 0x09, "D/U", "normal", 0, 0),
        (0x09, 0x0A, "S/N", "normal", 0, 0),
        (0x0B, 0x0A, "D/U", "normal", 0, -6),
        (0x07, 0x0B, "S/N", "normal", 0, 0),
        (0x0B, 0x0C, "S/N", "normal", 0, 0),
        (0x0C, 0x0D, "E/W", "normal", 0, 0),
        (0x0C, 0x0F, "S/N", "normal", 0, 0),
        (0x0F, 0x0E, "E/W", "normal", 0, 0),
        (0x0D, 0x0E, "S/N", "normal", 0, 0),
        (0x0D, 0x11, "D/U", "normal", 0, 0),
        (0x0E, 0x10, "D/U", "normal", 0, 0),
        (0x11, 0x10, "S/N", "normal", 0, 0),
        (0x07, 0x12, "E/W", "normal", 110, -28),

        # Region 2 <-> 3
        (0x12, 0x13, "Zasadzka (bez Pierścienia)!", "trap", -10, 18),
        (0x1A, 0x12, "NE/SW: Kamienne wrota (Złoty pierścień)", "door", 0, -6),

        # Region 3
        (0x13, 0x14, "U/D: Okno", "door", 0, -34),
        (0x14, 0x15, "E/W", "normal", 0, 0),
        (0x15, 0x16, "E/W", "normal", 0, 0),
        (0x16, 0x19, "N→$19", "normal", 18, 0),
        (0x14, 0x18, "S/N", "normal", 0, 0),
        (0x15, 0x19, "S/N", "normal", 0, 0),
        (0x18, 0x19, "E/W", "normal", 0, 0),
        (0x19, 0x1F, "E/W", "normal", 0, 0),
        (0x18, 0x1C, "S/N", "normal", 0, 0),
        (0x19, 0x1D, "S/N", "normal", -20, 0),
        (0x19, 0x1E, "NW/S", "normal", 15, 12),
        (0x1B, 0x1F, "S/N", "normal", -30, -14),
        (0x1B, 0x1C, "E/W", "normal", 0, 0),
        (0x1C, 0x1D, "E/W", "normal", 0, 0),
        (0x1D, 0x1E, "E/W", "normal", 0, 0),
        (0x1A, 0x1E, "S/N", "normal", 0, 0),
        (0x1A, 0x17, "N,E,SE ↔ S,W,NW", "normal", 0, 0),
        (0x1B, 0x20, "D/U", "normal", -18, 6),
        (0x20, 0x21, "SE/NW", "normal", 16, -6),
        (0x21, 0x22, "SW/NE", "normal", 16, 6),
        (0x22, 0x23, "NW/SE", "normal", -16, 6),
        (0x23, 0x20, "NE/SW", "normal", -16, -6),
        (0x20, 0x24, "S", "trap", 0, 0),
        (0x21, 0x24, "W", "trap", 0, 0),
        (0x22, 0x24, "N", "trap", 0, 0),
        (0x23, 0x24, "E", "trap", 0, 0),

        # Region 2 <-> 4
        (0x12, 0x25, "E/W ($12 ↔ $25)", "normal", 0, 0),

        # Region 4
        (0x25, 0x26, "NE/SW (Brama)", "door", 0, 0),
        (0x26, 0x27, "E/W: Drzwi (Beorn)", "door", 0, -34),
        (0x27, 0x28, "NE/SW", "normal", -10, -8),
        (0x27, 0x29, "E/W", "normal", 0, 0),
        (0x27, 0x2B, "SE/NW", "normal", -10, 8),
        (0x28, 0x2A, "E,S / N", "normal", 10, -8),
        (0x29, 0x2A, "E/W", "normal", 0, 0),
        (0x2B, 0x2A, "N,E / S", "normal", 10, 8),
        (0x2A, 0x2C, "E/W", "normal", 0, 0),
        (0x2C, 0x2D, "E/W", "trap", -12, -6),
        (0x2D, 0x2E, "E/W", "trap", -12, 8),
        (0x2C, 0x2E, "WEJDŹ DO ŁÓDKI (Pierścień)", "boat", 0, 0),

        # Region 4 <-> 5
        (0x2E, 0x2F, "E/W ($2E ↔ $2F)", "normal", 5, 40),

        # Region 5
        (0x2F, 0x32, "E,NW / W,SE", "normal", 0, -34),
        (0x2F, 0x31, "S/N", "normal", 0, 0),
        (0x31, 0x30, "NE,E,SE / SW,W,NW", "normal", 0, 34),
        (0x30, 0x32, "S/N", "normal", 0, 0),
        (0x30, 0x33, "SE/NW", "normal", 0, -34),
        (0x33, 0x34, "E/W", "normal", 0, 0),
        (0x34, 0x35, "E/W (z Kulą bezpiecznie)", "normal", -10, 0),
        (0x34, 0x38, "Niewola u Elfów (gdy brak Kuli)!", "trap", -45, -18),
        (0x38, 0x3A, "E/W: Okute drzwi (Złoty klucz)", "door", 0, 36),
        (0x39, 0x3A, "S/N: Drewniane drzwi (Złoty klucz)", "door", 0, 0),
        (0x3A, 0x3B, "E/W", "normal", 0, 0),
        (0x3B, 0x3C, "D/U (Klapa)", "trap", 0, 0),
        (0x3B, 0x37, "WEJDŹ W OTWARTĄ BECZKĘ", "boat", -15, 16),
        (0x35, 0x36, "S/N", "trap", 0, 0),
        (0x36, 0x37, "S/N", "trap", 0, 0),
        (0x35, 0x37, "WEJDŹ DO ŁÓDKI", "boat", 12, 0),

        # Region 5 <-> 6
        (0x37, 0x41, "E/W ($37 ↔ $41)", "normal", 0, 0),

        # Region 6
        (0x41, 0x48, "SW/NE", "normal", -12, 0),
        (0x41, 0x46, "SE/NW", "normal", -12, 8),
        (0x45, 0x46, "E/W", "normal", 0, 0),
        (0x46, 0x43, "NE/SW", "normal", 12, 8),
        (0x3D, 0x42, "SE/NW", "normal", -12, 0),
        (0x3E, 0x42, "S/N", "normal", 0, 0),
        (0x3F, 0x42, "SW/NE", "normal", -12, 0),
        (0x3F, 0x40, "E/W", "normal", 0, 0),
        (0x42, 0x43, "E/W", "normal", 0, 0),
        (0x43, 0x44, "E/W", "normal", 0, 0),
        (0x44, 0x47, "SW/NE", "normal", 12, 8),
        (0x3E, 0x49, "NE/SW", "normal", -12, -6),
        (0x49, 0x4A, "E/W", "normal", 0, 0),
        (0x4A, 0x4B, "E/W: Pałacowa brama", "trap", 0, -34),

        # Region 6 <-> 7
        (0x40, 0x4C, "IDŹ PRZEZ UKRYTE PRZEJŚCIE (od Barda)", "boat", -20, -16),

        # Region 7
        (0x4C, 0x4D, "E/W", "trap", 0, 0),
        (0x4E, 0x4F, "E/W", "trap", 0, 0),
        (0x4C, 0x4F, "WEJDŹ NA TRATWĘ", "boat", 0, -10),
        (0x4F, 0x50, "NE/SW", "normal", -10, -12),
        (0x50, 0x51, "E/W (Otwór)", "door", 0, 0),
        (0x51, 0x52, "D/U (Przejście)", "door", 0, 0),
        (0x4F, 0x52, "E/W (Główne wejście)", "door", 0, 12),
    ]

    label_queue = []

    # 1. Draw edge lines
    for ra, rb, label, style, ox, oy in edges:
        x1, y1, _, _, _ = rooms[ra]
        x2, y2, _, _, _ = rooms[rb]

        ctx.save()
        if style == "normal":
            set_color_hex(ctx, "#7c93b8", 0.88)
            ctx.set_line_width(2.2)
        elif style == "door":
            set_color_hex(ctx, "#f5a623", 0.95)
            ctx.set_line_width(2.8)
            ctx.set_dash([8, 4])
        elif style == "boat":
            set_color_hex(ctx, "#38ef7d", 0.95)
            ctx.set_line_width(3.2)
            ctx.set_dash([10, 5])
        elif style == "trap":
            set_color_hex(ctx, "#ff5757", 0.88)
            ctx.set_line_width(2.4)
            ctx.set_dash([4, 4])

        if (ra, rb) == (0x1A, 0x12):
            # Route cleanly around the right & top of Region 3 labyrinth
            ctx.move_to(x1 + 74, y1)
            ctx.line_to(2604, y1)
            ctx.line_to(2604, 152)
            ctx.line_to(1690, 152)
            ctx.line_to(x2, y2 - 26)
            ctx.stroke()
            lx, ly = 2160, 152
        elif (ra, rb) == (0x07, 0x12):
            ctx.move_to(x1 + 50, y1 - 22)
            ctx.curve_to(1180, 240, 1380, 240, x2 - 70, y2)
            ctx.stroke()
            lx, ly = 1280, 250
        elif (ra, rb) == (0x12, 0x25):
            # Route cleanly along the horizontal channel between rows (y=550)
            ctx.move_to(x1, y1 + 26)
            ctx.line_to(x1, 550)
            ctx.line_to(x2, 550)
            ctx.line_to(x2, y2 - 26)
            ctx.stroke()
            lx, ly = 750, 550
        elif (ra, rb) == (0x37, 0x41):
            # Route cleanly between Region 5 and Region 6
            ctx.move_to(x1 - 74, y1)
            ctx.line_to(185, y1)
            ctx.line_to(185, y2)
            ctx.line_to(x2 - 74, y2)
            ctx.stroke()
            lx, ly = 560, 1155
        elif (ra, rb) == (0x2C, 0x2E):
            ctx.move_to(x1 + 55, y1 + 26)
            ctx.curve_to(x1 + 95, (y1 + y2) / 2, x1 + 95, (y1 + y2) / 2, x2 + 55, y2 - 26)
            ctx.stroke()
            lx, ly = x1 + 10, (y1 + y2) / 2
        elif (ra, rb) == (0x35, 0x37):
            ctx.move_to(x1 + 60, y1 + 26)
            ctx.curve_to(x1 + 95, (y1 + y2) / 2, x1 + 95, (y1 + y2) / 2, x2 + 60, y2 - 26)
            ctx.stroke()
            lx, ly = x1 + 15, (y1 + y2) / 2 - 42
        elif (ra, rb) == (0x4C, 0x4F):
            ctx.move_to(x1, y1 - 26)
            ctx.curve_to((x1 + x2) / 2, y1 - 75, (x1 + x2) / 2, y1 - 75, x2, y2 - 26)
            ctx.stroke()
            lx, ly = (x1 + x2) / 2, y1 - 60
        else:
            ctx.move_to(x1, y1)
            ctx.line_to(x2, y2)
            ctx.stroke()
            lx, ly = (x1 + x2) / 2 + ox, (y1 + y2) / 2 + oy

        ctx.restore()
        if label:
            label_queue.append((lx, ly, label, style))

    # 2. Draw room boxes
    BOX_W = 148
    BOX_H = 52

    palette = {
        "start": ("#1b4332", "#40916c", "#95d5b2"),
        "normal": ("#1d283a", "#4a6491", "#dce6f7"),
        "item": ("#3b2f14", "#e09f3e", "#ffe6a7"),
        "danger": ("#422026", "#d94e5a", "#ffb3ba"),
        "death": ("#590d22", "#ff2a55", "#ffccd5"),
        "goal": ("#4a2511", "#ffb703", "#fff3b0"),
        "water_passage": ("#133b4a", "#00b4d8", "#ade8f4"),
    }

    for rid, (cx, cy, rname, sub, kind) in rooms.items():
        bg_hex, border_hex, title_hex = palette[kind]
        x = cx - BOX_W / 2
        y = cy - BOX_H / 2

        draw_rounded_rect(ctx, x + 3, y + 3, BOX_W, BOX_H, 7)
        set_color_hex(ctx, "#000000", 0.45)
        ctx.fill()

        draw_rounded_rect(ctx, x, y, BOX_W, BOX_H, 7)
        set_color_hex(ctx, bg_hex, 0.96)
        ctx.fill_preserve()
        set_color_hex(ctx, border_hex, 1.0)
        ctx.set_line_width(2.0 if kind == "normal" else 2.6)
        ctx.stroke()

        badge_str = f"${rid:02X} ({rid})"
        ctx.select_font_face("DejaVu Sans Mono", cairo.FONT_SLANT_NORMAL, cairo.FONT_WEIGHT_BOLD)
        ctx.set_font_size(10)
        set_color_hex(ctx, "#ffd866")
        ctx.move_to(x + 6, y + 14)
        ctx.show_text(badge_str)

        ctx.select_font_face("DejaVu Sans", cairo.FONT_SLANT_NORMAL, cairo.FONT_WEIGHT_BOLD)
        ctx.set_font_size(9.5)
        set_color_hex(ctx, title_hex)
        ctx.move_to(x + 6, y + 29)
        ctx.show_text(rname)

        if sub:
            ctx.select_font_face("DejaVu Sans", cairo.FONT_SLANT_NORMAL, cairo.FONT_WEIGHT_NORMAL)
            ctx.set_font_size(8.4)
            set_color_hex(ctx, "#d8e2f0")
            ctx.move_to(x + 6, y + 43)
            ctx.show_text(sub)

    # 3. Draw edge labels ON TOP so they are never occluded by boxes
    for lx, ly, label, style in label_queue:
        ctx.select_font_face("DejaVu Sans", cairo.FONT_SLANT_NORMAL, cairo.FONT_WEIGHT_BOLD)
        ctx.set_font_size(9.2)
        ext = ctx.text_extents(label)
        pw = ext.width + 8
        ph = ext.height + 6
        draw_rounded_rect(ctx, lx - pw / 2, ly - ph / 2, pw, ph, 4)
        set_color_hex(ctx, "#0d121a", 0.92)
        ctx.fill_preserve()
        if style == "door":
            set_color_hex(ctx, "#f5a623", 0.7)
            ctx.set_line_width(1.0)
            ctx.stroke()
            set_color_hex(ctx, "#ffc857")
        elif style == "boat":
            set_color_hex(ctx, "#38ef7d", 0.7)
            ctx.set_line_width(1.0)
            ctx.stroke()
            set_color_hex(ctx, "#52ff9b")
        elif style == "trap":
            set_color_hex(ctx, "#ff5757", 0.7)
            ctx.set_line_width(1.0)
            ctx.stroke()
            set_color_hex(ctx, "#ff8585")
        else:
            ctx.new_path()
            set_color_hex(ctx, "#c6d6f0")
        ctx.move_to(lx - ext.width / 2 - ext.x_bearing, ly - ext.height / 2 - ext.y_bearing)
        ctx.show_text(label)

    # Legend bar at the bottom
    draw_rounded_rect(ctx, 25, 1775, WIDTH - 50, 142, 12)
    set_color_hex(ctx, "#182130")
    ctx.fill_preserve()
    set_color_hex(ctx, "#4a6491")
    ctx.set_line_width(2)
    ctx.stroke()

    ctx.select_font_face("DejaVu Sans", cairo.FONT_SLANT_NORMAL, cairo.FONT_WEIGHT_BOLD)
    ctx.set_font_size(15)
    set_color_hex(ctx, "#ffd866")
    ctx.move_to(45, 1803)
    ctx.show_text("LEGENDA I SKRÓT OPTYMALNEJ TRASY PRZEJŚCIA GRY:")

    legend_items = [
        ("Start ($01)", "start", 45, 1820),
        ("Zwykła lokacja", "normal", 215, 1820),
        ("Ważny przedmiot / Pomocny NPC", "item", 405, 1820),
        ("Przeprawa / Ukryte przejście", "water_passage", 695, 1820),
        ("Wróg / Zasadzka", "danger", 965, 1820),
        ("Śmierć / Pułapka bez wyjścia", "death", 1175, 1820),
        ("Cel wyprawy ($52)", "goal", 1455, 1820),
    ]
    for label, kind, lx, ly in legend_items:
        bg_hex, border_hex, _ = palette[kind]
        draw_rounded_rect(ctx, lx, ly, 22, 18, 4)
        set_color_hex(ctx, bg_hex)
        ctx.fill_preserve()
        set_color_hex(ctx, border_hex)
        ctx.set_line_width(2)
        ctx.stroke()
        ctx.select_font_face("DejaVu Sans", cairo.FONT_SLANT_NORMAL, cairo.FONT_WEIGHT_NORMAL)
        ctx.set_font_size(12.5)
        set_color_hex(ctx, "#e2ecfc")
        ctx.move_to(lx + 30, ly + 14)
        ctx.show_text(label)

    ctx.select_font_face("DejaVu Sans", cairo.FONT_SLANT_NORMAL, cairo.FONT_WEIGHT_NORMAL)
    ctx.set_font_size(12.5)
    set_color_hex(ctx, "#b8c7e0")
    ctx.move_to(45, 1865)
    ctx.show_text(
        "1. Bag End ($01, Stara mapa) → Polana Trolli ($03→$04, świt zmienia trolle w kamień → Wielki klucz) → Skalna Pieczara ($05: Miecz dla Bilba, Topór dla Thorina) → Rivendell ($06: Elrond czyta mapę i daje Śniadanie)."
    )
    ctx.move_to(45, 1887)
    ctx.show_text(
        "2. Góry Mgliste ($0C: zabij Warga mieczem → $10: Złoty klucz) → Zasadzka ($12→$13: Thorin otwiera okno) → Czarne Jezioro ($22: Złoty pierścień) → Kamienne wrota ($1A→$12) → Dom Beorna ($27: Suszone mięso)."
    )
    ctx.move_to(45, 1909)
    ctx.show_text(
        "3. Czarna Rzeka ($2C→$2E łódką) → Polana ($33: Thorin zabija Pająka toporem) → Lochy Elfów ($34→$38/$39: Złoty klucz → beczką $3B→$37) → Esgaroth ($3D: Bard zabija Smoka; $40→$4C→$4F→$52: zabierz Okutą skrzynię i wróć do $01!)."
    )

    surface.write_to_png("/home/newton/dev/hobbit/screenshots/map.png")
    print("Saved /home/newton/dev/hobbit/screenshots/map.png")


if __name__ == "__main__":
    main()
