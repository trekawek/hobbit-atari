# Hobbit czyli w te i wewte... — Pełna solucja i zapis tekstów z gry

Kompletny, zweryfikowany w emulatorze opis przejścia polskiej tekstowej gry przygodowej **_Hobbit czyli w te i wewte..._** autorstwa **Bohdana R. Raua** (*Braintron Software*, 1988), opracowany na podstawie symbolicznego deasemblera w pliku [`src/hobbit.asm`](src/hobbit.asm), wraz z pełnym zapisem tekstowym rozgrywki, opisami wszystkich lokacji, przedmiotów oraz wypowiedzi postaci.

---

## Spis treści

1. [Skróty komend i mechanika silnika gry](#1-skróty-komend-i-mechanika-silnika-gry)
2. [Opis przejścia krok po kroku (Solucja)](#2-opis-przejścia-krok-po-kroku-solucja)
3. [Pełny zapis tekstowy przejścia gry (Transkrypcja z gry)](#3-pełny-zapis-tekstowy-przejścia-gry-transkrypcja-z-gry)
4. [Wszystkie wypowiedzi postaci, komunikaty i zdarzenia w grze](#4-wszystkie-wypowiedzi-postaci-komunikaty-i-zdarzenia-w-grze)
5. [Spis wszystkich 82 lokacji (`$01`–`$52`)](#5-spis-wszystkich-82-lokacji-0152)
6. [Spis wszystkich 53 obiektów i postaci (`$01`–`$35`)](#6-spis-wszystkich-53-obiektów-i-postaci-0135)

---

## 1. Skróty komend i mechanika silnika gry

### Skróty kierunków i poleceń (`abbrev_str_table`)
| Skrót | Rozwinięcie w silniku gry | Znaczenie |
| :--- | :--- | :--- |
| `PN` | `IDŹ NA PÓŁNOC` | Idź na północ |
| `PNW` | `IDŹ NA PÓŁNOCNY WSCHÓD` | Idź na północny wschód |
| `W` | `IDŹ NA WSCHÓD` | Idź na wschód |
| `PDW` | `IDŹ NA POŁUDNIOWY WSCHÓD` | Idź na południowy wschód |
| `PD` | `IDŹ NA POŁUDNIE` | Idź na południe |
| `PDZ` | `IDŹ NA POŁUDNIOWY ZACHÓD` | Idź na południowy zachód |
| `Z` | `IDŹ NA ZACHÓD` | Idź na zachód |
| `PNZ` | `IDŹ NA PÓŁNOCNY ZACHÓD` | Idź na północny zachód |
| `G` | `IDŹ W GÓRĘ` | Idź w górę |
| `D` | `IDŹ W DÓŁ` | Idź w dół |
| `C` | `CZEKAJ` | Czekaj jedną turę |
| `POKAŻ` | `POKAŻ` | Pokaż niesione przedmioty (ekwipunek) |
| `NAGRAJ` / `SAVE` | `NAGRAJ` | Zapisz stan gry na taśmę (`T`) lub dyskietkę (`D`) |
| `ZAKOŃCZ` | `ZAKOŃCZ` | Zakończ / zrestartuj grę |

### Ważne zasady parsera i mechaniki rozgrywki
1. **Walka wymaga podania nazwy broni w narzędniku:**
   Atakując przeciwnika (lub wydając polecenie ataku innej postaci), **trzeba** wskazać broń w narzędniku (`kim? czym?`):
   * `ZABIJ WARGA MIECZEM`
   * `POWIEDZ THORINOWI ZABIJ PAJĄKA TOPOREM`
   Atak bez podania broni (`ZABIJ WARGA`) zawsze kończy się przegraną (`WALKA JEST ZACIĘTA, ALE JESTEŚ ZBYT SŁABY...`).
2. **Przekazywanie przedmiotów przed wydaniem polecenia postaci niezależnej (NPC):**
   Postać niezależna widzi wyłącznie obiekty znajdujące się w bieżącej lokacji lub w jej własnym ekwipunku. Zanim poprosisz Elronda o odczytanie mapy (`STARA MAPA`), musisz mu ją dać (`DAJ MAPĘ ELRONDOWI`) albo położyć na ziemi (`ZOSTAW MAPĘ`).
3. **Głód i prowiant (`update_hunger_and_carry`):**
   Rozpoczynasz grę z zapasem `180` tur do śmierci głodowej (`GINIE Z GŁODU`). Zjedzenie dowolnego z trzech produktów żywnościowych dostępnych w grze przywraca licznik głodu do maksimum (`255` tur):
   * `ŚNIADANIE` (otrzymane od Elronda w Rivendell)
   * `SUSZONE MIĘSO` (otrzymane od Beorna w jego domu)
   * `CHLEB` (znaleziony w lochu Króla Leśnych Elfów)

---

## 2. Opis przejścia krok po kroku (Solucja)

### Etap 1: Bag End i Trolle (Lokacje `$01`–`$05`)
Grę rozpoczynasz w swojej norze hobbita (`W WYGODNYM TUNELU`, lokacja `$01`) w towarzystwie Gandalfa.

1. `OTWÓRZ SKRZYNIĘ` — otwiera wielką drewnianą skrzynię (`WIELKA DREWNIANA SKRZYNIA`).
2. `WEŹ MAPĘ` — zabiera starą mapę (`STARA MAPA`).
3. `OTWÓRZ DRZWI` — otwiera okrągłe drzwi (`OKRĄGŁE DRZWI`; często w tym samym momencie otwiera je z zewnątrz Thorin).
4. `W` — idź na wschód na pustkowie (`NA PUSTKOWIU`, lokacja `$02`). Dołącza do Ciebie Thorin i odtąd podąża za Tobą.
5. `W` — idź na wschód na polanę trolli (`NA POLANIE TROLLI`, lokacja `$03`).
   > **Pułapka:** Dwa trolle (`STARY DZIKI TROLL` i `MŁODY DZIKI TROLL`) zauważają Cię (`ZOBACZ, WILL, WESZŁO ŚNIADANIE!`). Jeśli pozostaniesz na polanie przez kolejną turę, trolle Cię zjedzą (`TROLLE DOCHODZĄ DO WNIOSKU, ŻE NA ŚNIADANIE JESTEŚ JEDNAK WYSTARCZAJĄCO TŁUSTY...`).
6. `PN` — natychmiast uciekaj na północ na skalną ścieżkę (`NA SKALNEJ ŚCIEŻCE`, lokacja `$04`).
7. `C` — zaczekaj jedną turę. Wstaje świt (`WSTAJE DZIEŃ...`), który zamienia oba trolle w kamień, a `STARY DZIKI TROLL` upuszcza wielki klucz (`WIELKI KLUCZ`) na polanie (`$03`).
8. `PD` — wróć na południe na polanę trolli (`NA POLANIE TROLLI`, lokacja `$03`).
9. `WEŹ KLUCZ` — podnieś wielki klucz (`WIELKI KLUCZ`).
10. `PN` — wróć na północ na skalną ścieżkę (`NA SKALNEJ ŚCIEŻCE`, lokacja `$04`).
11. `OTWÓRZ DRZWI` — otwiera kamienne drzwi (`KAMIENNE DRZWI`) przy użyciu wielkiego klucza.
12. `ZOSTAW KLUCZ` — odłóż wielki klucz (nie będzie już potrzebny).
13. `PN` — wejdź do jaskini trolli (`W SKALNEJ PIECZARZE`, lokacja `$05`). Gdy Thorin wejdzie za Tobą, opowie historię topora z Khazad-dûm i automatycznie zabierze `WIELKI TOPÓR` (`THORIN ZABIERA WIELKI TOPÓR`).
14. `WEŹ MIECZ` — weź miecz (`MIECZ`).

---

### Etap 2: Rivendell i Góry Mgliste (Lokacje `$06`–`$11`)
1. `PD` — wyjdź z pieczary z powrotem na skalną ścieżkę (`NA SKALNEJ ŚCIEŻCE`, lokacja `$04`).
2. `PDW` — idź na południowy wschód do Rivendell (`W RIVENDELL`, lokacja `$06`), gdzie czeka `ELROND`.
3. `DAJ MAPĘ ELRONDOWI` — przekaż starą mapę Elrondowi.
4. `POWIEDZ ELRONDOWI PRZECZYTAJ MAPĘ` — Elrond odczytuje starożytne pismo (`SZUKAJ NA POŁUDNIE OD DOLINY MGIEŁ`) i wręcza Ci prowiant (`ELROND DAJE CI ŚNIADANIE`).
5. `W` — idź na wschód do Doliny Mgieł (`W DOLINIE MGIEŁ`, lokacja `$07`).
6. `PD` — idź na południe w Góry Mgliste (`W GÓRACH MGLISTYCH`, lokacja `$0B`).
7. `PD` — idź dalej na południe (lokacja `$0C`).
   > **Walka:** Lokacje `$0C`–`$0F` patroluje dziki warg (`DZIKI WARG`), który blokuje przejście (`WARG NIE POZWALA CI ODEJŚĆ`). Jeśli nie ma go jeszcze w lokacji `$0C`, zaczekaj (`C` 1–2 razy), aż pojawi się komunikat `WCHODZI DZIKI WARG`.
8. `ZABIJ WARGA MIECZEM` — zabijasz dzikiego warga mieczem (`ZABIJASZ DZIKIEGO WARGA MIECZEM`).
9. `ZOSTAW MIECZ` — odłóż miecz (nie będzie już potrzebny).
10. `W` — idź na wschód (lokacja `$0D`).
11. `D` — zejdź w dół (lokacja `$11`).
12. `PD` — idź na południe (lokacja `$10`), gdzie leży złoty klucz (`ZŁOTY KLUCZ`).
13. `WEŹ KLUCZ` — zabierz `ZŁOTY KLUCZ` (posłuży później do otwarcia celi w lochach Króla Elfów).
14. `PN`, następnie `G`, `Z`, `PN`, `PN` — wróć do Doliny Mgieł (`W DOLINIE MGIEŁ`, lokacja `$07`).

---

### Etap 3: Lochy Goblinów, Labirynt i Pierścień Golluma (Lokacje `$12`–`$23`)
1. `W` — idź na wschód na skalną ścieżkę (`NA SKALNEJ ŚCIEZCE`, lokacja `$12`). Gobliny urządzają zasadzkę (`NAGLE POJAWIAJĄ SIĘ GOBLINY / MIMO PRÓB UCIECZKI DOSTAJESZ SIĘ DO NIEWOLI`) i wrzucają Cię do lochu (`W LOCHU GOBLINÓW`, lokacja `$13`).
2. `C` *(powtórz 8–15 razy)* — czekaj, aż do lochu dotrze Thorin (`WCHODZI THORIN`).
3. `POWIEDZ THORINOWI OTWÓRZ OKNO` — tylko Thorin potrafi otworzyć wysoko położone okno (`OKNO`).
4. `G` — wyjdź w górę przez otwarte okno do labiryntu goblinów (`W LABIRYNCIE KORYTARZY`, lokacja `$14`).
5. `PD`, następnie `PD`, `Z`, `D` — przejdź przez labirynt (`$14` → `$18` → `$1C` → `$1B` → `$20`) w dół do pieczary nad Czarnym Jeziorem (`W PIECZARZE NAD CZARNYM JEZIOREM`, lokacja `$20`).
   > **Uwaga:** Nigdy nie wchodź w stronę samego jeziora (`W CZARNYM JEZIORZE`, lokacja `$24`), ponieważ utoniesz (`NIESTETY NIE UMIESZ PŁYWAĆ`).
6. `PDW`, następnie `PDZ` — przejdź wzdłuż brzegu jeziora (`$20` → `$21` → `$22`), gdzie leży złoty pierścień (`ZŁOTY PIERŚCIEŃ`).
   > **Pułapka:** Nie podnoś pierścienia, gdy w tej samej lokacji znajduje się `GOLLUM`, bo natychmiast Cię zabije (`GOLLUM JEST ZDANIA, ŻE PIERŚCIEŃ JEST JEGO WŁASNOŚCIĄ I ZABIJA CIĘ`). Ponieważ Gollum krąży wokół jeziora w turach, w których nie ma Cię obok niego, w chwili dojścia do lokacji `$22` Golluma już tam nie będzie (gdyby jednak był, cofnij się `PNZ` i wróć `PDW`). Po zabraniu pierścienia nigdy nie odzywaj się do Golluma (`POWIEDZ GOLLUMOWI...`), bo zdradzisz swoją obecność głosem (`DOTYCHCZAS CHRONIŁ CIĘ PIERŚCIEŃ DAJĄC CI NIEWIDZIALNOŚĆ, ALE TERAZ GOLLUM USŁYSZAŁ TWÓJ GŁOS...`).
7. `WEŹ PIERŚCIEŃ` — weź złoty pierścień (`ZŁOTY PIERŚCIEŃ`).
8. `PNZ`, następnie `PNW`, `G` — obejdź jezioro (`$22` → `$23` → `$20`) i wejdź w górę z powrotem do labiryntu (`$1B`).
9. `W`, następnie `W`, `W`, `PN` — przejdź przez labirynt (`$1B` → `$1C` → `$1D` → `$1E` → `$1A`) do kamiennych wrót (`KAMIENNE WROTA`).
10. `OTWÓRZ WROTA` — moc `ZŁOTEGO PIERŚCIENIA` pozwala otworzyć `KAMIENNE WROTA`.
11. `PNW` — wyjdź na północny wschód na skalną ścieżkę (`NA SKALNEJ ŚCIEZCE`, lokacja `$12`). Dzięki pierścieniowi gobliny już Cię nie porywają.

---

### Etap 4: Dom Beorna, Czarna Rzeka i Pająk w Mrocznej Puszczy (Lokacje `$25`–`$33`)
1. `W` — idź na wschód przez otwartą bramę (`BRAMA`) na ścieżkę (lokacja `$25`).
2. `PNW` — idź na północny wschód na podwórze przed domem Beorna (`NA PODWÓRZU POD DOMEM BEORNA`, lokacja `$26`).
   > **Pułapka:** **Pod żadnym pozorem nie otwieraj samemu drewnianych drzwi (`DREWNIANE DRZWI`)!** Jeśli otworzysz je bez pozwolenia gospodarza, po wejściu do środka Beorn Cię zabije (`OKAZUJE SIĘ, ŻE BEORN BARDZO NIE LUBI JEŚLI OTWIERA SIĘ JEGO DRZWI BEZ POZWOLENIA...`).
3. `C` *(powtarzaj, aż pojawi się `BEORN OTWIERA DREWNIANE DRZWI` lub `KTOŚ OTWIERA DREWNIANE DRZWI`)* — poczekaj, aż Beorn sam otworzy drzwi od wewnątrz.
4. `W` — wejdź do domu Beorna (`W DOMU BEORNA`, lokacja `$27`). Beorn dzieli się z Tobą zapasami i daje Ci suszone mięso (`SUSZONE MIĘSO`).
5. `ZJEDZ ŚNIADANIE` — zjedz śniadanie od Elronda (`NIAM NIAM NIAM...`), aby odnowić zapas sił.
6. `W`, następnie `W`, `W` — idź na wschód przez las (`$27` → `$29` → `$2A` → `$2C`) na zachodni brzeg Czarnej Rzeki (`NA ZACHODNIM BRZEGU CZARNEJ RZEKI`).
   * Dzięki `ZŁOTEMU PIERŚCIENIOWI` widzisz zaczarowaną łódkę (`ŁÓDKA`).
   * Upewnij się, że Thorin jest już z Tobą w tej lokacji (jeśli nie, wpisz raz `C`). Musisz najpierw przeprawić Thorina, aby pomógł Ci w walce z pająkiem.
7. `POWIEDZ THORINOWI WEJDŹ DO ŁÓDKI` — Thorin wsiada do łódki i przeprawia się na wschodni brzeg (`$2E`).
8. `WEJDŹ DO ŁÓDKI` — moc pierścienia porusza łódkę (`MOC PIERŚCIENIA PORUSZA ŁÓDKĘ`) i przenosi Cię na wschodni brzeg (`NA WSCHODNIM BRZEGU CZARNEJ RZEKI`, lokacja `$2E`).
9. `W`, następnie `W`, `PN`, `PDW` — przejdź przez Mroczną Puszczę (`$2E` → `$2F` → `$32` → `$30` → `$33`) na leśną polanę (`NA LEŚNEJ POLANIE`, lokacja `$33`), gdzie drogę zagradza czarny pająk (`CZARNY PAJĄK`).
10. *(Jeśli Thorin jeszcze nie wszedł na polanę, zaczekaj jedną turę komendą `C`.)*
11. `POWIEDZ THORINOWI ZABIJ PAJĄKA TOPOREM` — Thorin zabija pająka swoim toporem (`THORIN ZABIJA CZARNEGO PAJĄKA WIELKIM TOPOREM`).

---

### Etap 5: Lochy Króla Leśnych Elfów i Ucieczka w Beczce (Lokacje `$34`–`$3B` → `$37`)
1. `W` — idź na wschód na kolejną leśną polanę (lokacja `$34`). Pojawiają się leśne elfy (`POJAWIA SIĘ KILKUNASTU ELFÓW / ELFY PORYWAJĄ CIĘ`) i zamykają Cię w celi (`W LOCHU KRÓLA ELFÓW`, lokacja `$38`), a Thorina w sąsiedniej celi (`$39`).
   > **Ważne:** **Zostaw Thorina zamkniętego w jego celi!** Jeśli uwolnisz Thorina i dotrze on z Tobą do Jaskini Smoka, na widok Klejnotu Durina (`KRYSZTAŁOWA KULA`) oszaleje z chciwości i Cię zabije (`NA WIDOK KLEJNOTU DURINA THORIN TRACI GŁOWĘ...`).
2. `WEŹ CHLEB` — zabierz chleb (`CHLEB`) leżący w celi.
3. `OTWÓRZ DRZWI` — otwiera okute drzwi (`OKUTE DRZWI`) za pomocą złotego klucza (`ZŁOTY KLUCZ`).
4. `ZOSTAW KLUCZ` — odłóż złoty klucz.
5. `W`, następnie `W` — przejdź na wschód przez korytarz (`W KORYTARZU`, lokacja `$3A`) do pałacowej piwnicy (`W PAŁACOWEJ PIWNICY`, lokacja `$3B`).
   > **Uwaga:** Nie schodź w dół przez drewnianą klapę (`W WODOSPADZIE`) bez beczki, bo utoniesz.
6. `WEJDŹ DO OTWARTEJ BECZKI` — wejdź do otwartej beczki (`OTWARTA BECZKA`). Beczka wpada przez klapę do rzeki i dopływa do południowego brzegu Wielkiej Rzeki (`NA POŁUDNIOWYM BRZEGU WIELKIEJ RZEKI`, lokacja `$37`), gdzie rozbija się o brzeg.

---

### Etap 6: Miasto nad Jeziorem, Bard i Jaskinia Smoka (Lokacje `$37`–`$52`)
1. `W` — idź na wschód do Miasta nad Jeziorem (`W MIEŚCIE NAD JEZIOREM`, lokacja `$41`).
2. `PDW`, następnie `PNW`, `Z` — przejdź przez ulice miasta (`$41` → `$46` → `$43` → `$42`). Gdy spotkasz `BARDA`, powie Ci:
   `BARD MÓWI : POKAŻĘ CI UKRYTE PRZEJŚCIE. CHODŹ ZA MNĄ.` (odkrywając `UKRYTE PRZEJŚCIE` w lokacji `$40`).
3. `C` *(powtarzaj, aż `BARD` wejdzie do Twojej lokacji)* — zaczekaj na Barda.
4. `POWIEDZ BARDOWI ZABIJ SMOKA` — Bard odpowie: `ŚWIETNY POMYSŁ! JAK GO TYLKO ZOBACZĘ`.
5. `PNW`, następnie `W` — idź na północny wschód (`$3F`) i na wschód (`$40`), gdzie znajduje się `UKRYTE PRZEJŚCIE`.
6. `IDŹ PRZEZ UKRYTE PRZEJŚCIE` — przejdź ukrytym przejściem na przystań (`NA PRZYSTANI`, lokacja `$4C`).
7. `WEJDŹ NA TRATWĘ` — przepłyń tratwą przez Długie Jezioro (`TRATWA RUSZA I PŁYNIE PO FALACH DŁUGIEGO JEZIORA`) na kamienistą plażę (`NA KAMIENISTEJ PLAŻY`, lokacja `$4F`).
8. *(Jeśli nie słyszałeś jeszcze komunikatu `DOBIEGA CIĘ RYK KONAJĄCEGO SMOKA`, wpisuj `C`, aż Bard zabije Smauga nad miastem.)*
9. `W` (lub `IDŹ PRZEZ GŁÓWNE WEJŚCIE`) — wejdź do Jaskini Smoka (`W JASKINI SMOKA`, lokacja `$52`).
10. `OTWÓRZ SKRZYNIĘ` — otwórz okutą skrzynię (`OKUTA SKRZYNIA`).
11. `WEŹ KULĘ` — zabierz Arcyklejnot, czyli Kryształową Kulę (`KRYSZTAŁOWA KULA`).

---

### Etap 7: „...i wewte” — Powrót z Klejnotem do Bag End (Lokacje `$52` → `$01`)
Zgodnie z tytułem gry (*„Hobbit czyli w te i wewte...”*), musisz teraz zanieść `KRYSZTAŁOWĄ KULĘ` z powrotem do `GANDALFA` czekającego w Bag End (`W WYGODNYM TUNELU`, lokacja `$01`):

1. `ZJEDZ MIĘSO` (oraz w razie potrzeby `ZJEDZ CHLEB`) — posil się przed drogą powrotną.
2. `Z` — wyjdź z jaskini na zachód na kamienistą plażę (`NA KAMIENISTEJ PLAŻY`, lokacja `$4F`).
3. `WEJDŹ NA TRATWĘ` — wróć tratwą przez jezioro na przystań (`NA PRZYSTANI`, lokacja `$4C`).
4. `IDŹ PRZEZ UKRYTE PRZEJŚCIE` — wróć do Miasta nad Jeziorem (lokacja `$40`).
5. `Z`, następnie `PDZ`, `W`, `PDZ`, `PNZ`, `Z` — przejdź przez Miasto nad Jeziorem (`$40` → `$3F` → `$42` → `$43` → `$46` → `$41` → `$37`) na południowy brzeg Wielkiej Rzeki (`NA POŁUDNIOWYM BRZEGU WIELKIEJ RZEKI`).
6. `WEJDŹ DO ŁÓDKI` — przepraw się łódką na północny brzeg Wielkiej Rzeki (`NA PÓŁNOCNYM BRZEGU WIELKIEJ RZEKI`, lokacja `$35`).
7. `Z`, następnie `Z` — przejdź na zachód przez leśne polany (`$35` → `$34` → `$33`; posiadanie `KRYSZTAŁOWEJ KULI` sprawia, że elfy w lokacji `$34` już Cię nie zatrzymują).
8. `PNZ`, następnie `PD`, `Z`, `Z` — wróć przez Mroczną Puszczę (`$33` → `$30` → `$32` → `$2F` → `$2E`) na wschodni brzeg Czarnej Rzeki.
9. `WEJDŹ DO ŁÓDKI` — przepłyń Czarną Rzekę na zachodni brzeg (lokacja `$2C`).
10. `Z`, następnie `Z`, `Z`, `Z` — przejdź przez las i dom Beorna (`$2C` → `$2A` → `$29` → `$27` → `$26`).
11. `PDZ`, następnie `Z`, `Z`, `Z`, `Z`, `Z`, `Z` — wróć szlakiem przez Dolinę Mgieł, Rivendell, Polanę Trolli i Pustkowie (`$26` → `$25` → `$12` → `$07` → `$06` → `$03` → `$02` → `$01`) do swojego tunelu (`W WYGODNYM TUNELU`).
12. `DAJ KULĘ GANDALFOWI` — oddaj `KRYSZTAŁOWĄ KULĘ` Gandalfowi, aby ukończyć grę!

---

## 3. Pełny zapis tekstowy przejścia gry (Transkrypcja z gry)

Poniżej znajduje się pełny, dosłowny zapis tekstu wypisywanego przez grę podczas przejścia od ekranu początkowego aż do zwycięskiego finału:

### Wprowadzenie fabularne (`str_intro_story`)

```text
 DAWNO TEMU W PODZIEMNYM MIEŚCIE MORIA,
ZWANYM W JĘZYKU KRASNOLUDÓW KHAZAD-DUM,
NAD WALECZNYM LUDEM KHUZDUL PANOWAŁ
WIELKI DURIN. KRASNOLUDY SŁYNĘŁY W
CAŁYM ŚWIECIE ZE SWYCH KLEJNOTÓW. ALE
SŁAWA ICH DOTARŁA AŻ NA PÓŁNOC, GDZIE
W CZARNEJ KRAINIE MORDOR PANUJE ZŁY
MORGOTH. I OTO WOJSKA MORGOTHA ZAJĘŁY
PODZIEMNE PAŁACE MORII, A SKARBY RODU
KHUZDUL ZAGARNĄŁ CZARNY WÓDZ. JEDEN
TYLKO NAJCENNIEJSZY KLEJNOT, BRYLANTOWĄ
KULĘ, ZABRAŁ KTOŚ INNY.
 NA WYSPIE NA DŁUGIM JEZIORZE MIESZKA
JEDEN Z POTOMKÓW STAREGO GLAURUNGA,
STRASZLIWY SMOK SMAUG. W JEGO JASKINI
ZNAJDUJE SIĘ NAJWIĘKSZE DZIEŁO
KRASNOLUDZKICH MISTRZÓW.
 NIEWIELU POZOSTAŁO Z TYCH, KTÓRZY
ZNAJĄ DAWNE DNI. TO MITHRANDIR Z RODU
CZARODZIEJÓW ZWANY TEŻ GANDALFEM. TO
KRASNOLUD THORIN SYN THRORA Z DRUŻYNY
DURINA. TO ELROND PÓŁELF, POSIADAJĄCY
SZTUKĘ CZYTANIA STAROŻYTNEGO PISMA
ELFÓW, TO DZIKI STRAŻNIK LASÓW BEORN,
TO NIEUSTRASZONY BARD Z MIASTA NAD
JEZIOREM. ALE TYLKO KTOŚ Z RODU MAŁYCH
HOBBITÓW MOŻE DOJŚĆ DO JASKINI SMAUGA
I ZANIEŚĆ KLEJNOT DURINA GANDALFOWI.
```

### Kompletny zapis rozgrywki

```text
CZY ODTWARZASZ NAGRANĄ GRĘ? (T/N)

=== ETAP 1: BAG END I TROLLE ===

ZNAJDUJESZ SIĘ W WYGODNYM TUNELU

WYJŚCIA:
WSCHÓD
WIDZISZ:
GANDALFA
WIELKĄ DREWNIANĄ SKRZYNIĘ
 WIELKA DREWNIANA SKRZYNIA JEST
ZAMKNIĘTA
OKRĄGŁE DRZWI NA WSCHODZIE
 OKRĄGŁE DRZWI SĄ ZAMKNIĘTE

> OTWÓRZ SKRZYNIĘ

OTWIERASZ WIELKĄ DREWNIANĄ SKRZYNIĘ
 WIELKA DREWNIANA SKRZYNIA JEST
OTWARTA
GANDALF MÓWI :
NA CO CZEKASZ, SPIESZ SIĘ!

> WEŹ MAPĘ

BIERZESZ STARĄ MAPĘ
KTOŚ OTWIERA OKRĄGŁE DRZWI
> OTWÓRZ DRZWI

 OKRĄGŁE DRZWI SĄ OTWARTE
WCHODZI THORIN
> W

IDZIESZ PRZEZ OKRĄGŁE DRZWI
ZNAJDUJESZ SIĘ NA PUSTKOWIU

WYJŚCIA:
PÓŁNOCNY WSCHÓD
WSCHÓD
ZACHÓD
WIDZISZ:
OKRĄGŁE DRZWI NA ZACHODZIE
 OKRĄGŁE DRZWI SĄ OTWARTE

WCHODZI THORIN
> W

IDZIESZ NA WSCHÓD
ZNAJDUJESZ SIĘ NA POLANIE TROLLI

WYJŚCIA:
PÓŁNOC
WSCHÓD
ZACHÓD
WIDZISZ:
STAREGO DZIKIEGO TROLLA
 STARY DZIKI TROLL MA:
  WIELKI KLUCZ
MŁODEGO DZIKIEGO TROLLA

WCHODZI THORIN
MŁODY DZIKI TROLL MÓWI :
 ZOBACZ, WILL, WESZŁO ŚNIADANIE!
STARY DZIKI TROLL MÓWI :
 COŚ TY, ON JEST ZA MAŁY, NIE NAJEMY SIĘ

> PN

IDZIESZ NA PÓŁNOC
ZNAJDUJESZ SIĘ NA SKALNEJ ŚCIEŻCE

WYJŚCIA:
PÓŁNOC
POŁUDNIOWY WSCHÓD
POŁUDNIE
POŁUDNIOWY ZACHÓD
WIDZISZ:
KAMIENNE DRZWI NA PÓŁNOCY
 KAMIENNE DRZWI SĄ ZAMKNIĘTE

WCHODZI THORIN
> C

CZEKASZ
WSTAJE DZIEŃ...

> PD

IDZIESZ NA POŁUDNIE
ZNAJDUJESZ SIĘ NA POLANIE TROLLI

WYJŚCIA:
PÓŁNOC
WSCHÓD
ZACHÓD
WIDZISZ:
SKAMIENIAŁEGO STAREGO TROLLA
SKAMIENIAŁEGO MŁODEGO TROLLA
WIELKI KLUCZ

WCHODZI THORIN
> WEŹ KLUCZ

BIERZESZ WIELKI KLUCZ
> PN

IDZIESZ NA PÓŁNOC
ZNAJDUJESZ SIĘ NA SKALNEJ ŚCIEŻCE

WYJŚCIA:
PÓŁNOC
POŁUDNIOWY WSCHÓD
POŁUDNIE
POŁUDNIOWY ZACHÓD
WIDZISZ:
KAMIENNE DRZWI NA PÓŁNOCY
 KAMIENNE DRZWI SĄ ZAMKNIĘTE

WCHODZI THORIN
> OTWÓRZ DRZWI

OTWIERASZ KAMIENNE DRZWI
 KAMIENNE DRZWI SĄ OTWARTE
> ZOSTAW KLUCZ

ZOSTAWIASZ WIELKI KLUCZ
> PN

IDZIESZ PRZEZ KAMIENNE DRZWI
ZNAJDUJESZ SIĘ W SKALNEJ PIECZARZE

WYJŚCIA:
POŁUDNIE
WIDZISZ:
MIECZ
WIELKI TOPÓR
KAMIENNE DRZWI NA POŁUDNIU
 KAMIENNE DRZWI SĄ OTWARTE

WCHODZI THORIN
THORIN MÓWI:
JEST TO TOPÓR WYKUTY W PODZIEMNYM
MIEŚCIE KHAZAD-DUM. TYLKO MY, WOJOWNICY
Z RODU KRASNOLUDÓW POTRAFIMY POSŁUŻYĆ
SIĘ TAKIM TOPOREM

THORIN ZABIERA WIELKI TOPÓR

> WEŹ MIECZ

BIERZESZ MIECZ
>

=== ETAP 2: RIVENDELL I GÓRY MGLISTE ===
PD

IDZIESZ PRZEZ KAMIENNE DRZWI
ZNAJDUJESZ SIĘ NA SKALNEJ ŚCIEŻCE

WYJŚCIA:
PÓŁNOC
POŁUDNIOWY WSCHÓD
POŁUDNIE
POŁUDNIOWY ZACHÓD
WIDZISZ:
WIELKI KLUCZ
KAMIENNE DRZWI NA PÓŁNOCY
 KAMIENNE DRZWI SĄ OTWARTE

WCHODZI THORIN
> PDW

IDZIESZ NA POŁUDNIOWY WSCHÓD
ZNAJDUJESZ SIĘ W RIVENDELL

WYJŚCIA:
WSCHÓD
ZACHÓD
PÓŁNOCNY ZACHÓD
WIDZISZ:
ELRONDA
 ELROND MA:
  ŚNIADANIE

WCHODZI THORIN
> DAJ MAPĘ ELRONDOWI

DAJESZ STARĄ MAPĘ ELRONDOWI
> POWIEDZ ELRONDOWI PRZECZYTAJ MAPĘ
MÓWISZ DO ELRONDA

ELROND ODCZYTUJE STARĄ MAPĘ
ELROND MÓWI :
 SZUKAJ NA POŁUDNIE OD DOLINY MGIEŁ

ELROND MÓWI :
 WEŹ PROWIANT NA DROGĘ, W TAK DŁUGIEJ
PODRÓŻY MOŻESZ CZASEM BYĆ GŁODNY.
ELROND DAJE CI ŚNIADANIE

> W

IDZIESZ NA WSCHÓD
ZNAJDUJESZ SIĘ W DOLINIE MGIEŁ

WYJŚCIA:
PÓŁNOC
WSCHÓD
POŁUDNIE
ZACHÓD

WCHODZI THORIN
> PD

IDZIESZ NA POŁUDNIE
ZNAJDUJESZ SIĘ W GÓRACH MGLISTYCH

WYJŚCIA:
PÓŁNOC
POŁUDNIE
DÓŁ

WCHODZI THORIN
> PD

IDZIESZ NA POŁUDNIE
ZNAJDUJESZ SIĘ W GÓRACH MGLISTYCH

WYJŚCIA:
PÓŁNOC
WSCHÓD
POŁUDNIE

WCHODZI THORIN
> C

CZEKASZ
> C

CZEKASZ
WCHODZI DZIKI WARG
> ZABIJ WARGA MIECZEM

ZABIJASZ DZIKIEGO WARGA MIECZEM
> ZOSTAW MIECZ

ZOSTAWIASZ MIECZ
> W

IDZIESZ NA WSCHÓD
ZNAJDUJESZ SIĘ W GÓRACH MGLISTYCH

WYJŚCIA:
POŁUDNIE
ZACHÓD
DÓŁ

WCHODZI THORIN
> D

IDZIESZ W DÓŁ
ZNAJDUJESZ SIĘ W GÓRACH MGLISTYCH

WYJŚCIA:
POŁUDNIE
GÓRA

WCHODZI THORIN
> PD

IDZIESZ NA POŁUDNIE
ZNAJDUJESZ SIĘ W GÓRACH MGLISTYCH

WYJŚCIA:
PÓŁNOC
GÓRA
WIDZISZ:
ZŁOTY KLUCZ

WCHODZI THORIN
> WEŹ KLUCZ

BIERZESZ ZŁOTY KLUCZ
> PN

IDZIESZ NA PÓŁNOC
ZNAJDUJESZ SIĘ W GÓRACH MGLISTYCH

WYJŚCIA:
POŁUDNIE
GÓRA

WCHODZI THORIN
> G

IDZIESZ W GÓRĘ
ZNAJDUJESZ SIĘ W GÓRACH MGLISTYCH

WYJŚCIA:
POŁUDNIE
ZACHÓD
DÓŁ

WCHODZI THORIN
> Z

IDZIESZ NA ZACHÓD
ZNAJDUJESZ SIĘ W GÓRACH MGLISTYCH

WYJŚCIA:
PÓŁNOC
WSCHÓD
POŁUDNIE
WIDZISZ:
DZIKIEGO ZABITEGO WARGA
MIECZ

WCHODZI THORIN
> PN

IDZIESZ NA PÓŁNOC
ZNAJDUJESZ SIĘ W GÓRACH MGLISTYCH

WYJŚCIA:
PÓŁNOC
POŁUDNIE
DÓŁ

WCHODZI THORIN
> PN

IDZIESZ NA PÓŁNOC
ZNAJDUJESZ SIĘ W DOLINIE MGIEŁ

WYJŚCIA:
PÓŁNOC
WSCHÓD
POŁUDNIE
ZACHÓD

WCHODZI THORIN
>

=== ETAP 3: LOCHY GOBLINÓW, LABIRYNT I PIERŚCIEŃ GOLLUMA ===
W

IDZIESZ NA WSCHÓD
ZNAJDUJESZ SIĘ NA SKALNEJ ŚCIEZCE

WYJŚCIA:
WSCHÓD
POŁUDNIOWY ZACHÓD
ZACHÓD
WIDZISZ:
KAMIENNE WROTA NA POŁUDNIOWYM
ZACHODZIE
 KAMIENNE WROTA SĄ ZAMKNIĘTE

WCHODZI THORIN
NAGLE POJAWIAJĄ SIĘ GOBLINY
MIMO PRÓB UCIECZKI DOSTAJESZ SIĘ DO
NIEWOLI

ZNAJDUJESZ SIĘ W LOCHU GOBLINÓW

WYJŚCIA:
GÓRA
WIDZISZ:
OKNO NA GÓRZE
 OKNO JEST ZAMKNIĘTE

> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
WCHODZI THORIN
> POWIEDZ THORINOWI OTWÓRZ OKNO
MÓWISZ DO THORINA

THORIN OTWIERA OKNO
 OKNO JEST OTWARTE
> G

IDZIESZ PRZEZ OKNO
ZNAJDUJESZ SIĘ W LABIRYNCIE KORYTARZY

WYJŚCIA:
WSCHÓD
POŁUDNIE
DÓŁ
WIDZISZ:
OKNO NA DOLE
 OKNO JEST OTWARTE

WCHODZI THORIN
> PD

IDZIESZ NA POŁUDNIE
ZNAJDUJESZ SIĘ W LABIRYNCIE KORYTARZY

WYJŚCIA:
PÓŁNOC
WSCHÓD
POŁUDNIE

WCHODZI THORIN
WCHODZI MŁODY GOBLIN
> PD

IDZIESZ NA POŁUDNIE
ZNAJDUJESZ SIĘ W LABIRYNCIE KORYTARZY

WYJŚCIA:
PÓŁNOC
WSCHÓD
ZACHÓD
WIDZISZ:
CHUDEGO GOBLINA

WCHODZI THORIN
WCHODZI GRUBY GOBLIN
CHUDY GOBLIN IDZIE NA ZACHÓD
> Z

IDZIESZ NA ZACHÓD
ZNAJDUJESZ SIĘ W LABIRYNCIE KORYTARZY

WYJŚCIA:
WSCHÓD
POŁUDNIE
DÓŁ
WIDZISZ:
CHUDEGO GOBLINA

WCHODZI THORIN
CHUDY GOBLIN IDZIE NA WSCHÓD
> D

IDZIESZ W DÓŁ
ZNAJDUJESZ SIĘ W PIECZARZE NAD CZARNYM  JEZIOREM

WYJŚCIA:
POŁUDNIOWY WSCHÓD
POŁUDNIE
POŁUDNIOWY ZACHÓD
GÓRA
WIDZISZ:
CZARNE JEZIORO NA POŁUDNIU

WCHODZI THORIN
> PDW

IDZIESZ NA POŁUDNIOWY WSCHÓD
ZNAJDUJESZ SIĘ W PIECZARZE NAD CZARNYM  JEZIOREM

WYJŚCIA:
POŁUDNIOWY ZACHÓD
ZACHÓD
PÓŁNOCNY ZACHÓD
WIDZISZ:
CZARNE JEZIORO NA ZACHODZIE

WCHODZI THORIN
> PDZ

IDZIESZ NA POŁUDNIOWY ZACHÓD
ZNAJDUJESZ SIĘ W PIECZARZE NAD CZARNYM  JEZIOREM

WYJŚCIA:
PÓŁNOC
PÓŁNOCNY WSCHÓD
PÓŁNOCNY ZACHÓD
WIDZISZ:
ZŁOTY PIERŚCIEŃ
CZARNE JEZIORO NA PÓŁNOCY

WCHODZI THORIN
> WEŹ PIERŚCIEŃ

BIERZESZ ZŁOTY PIERŚCIEŃ
> PNZ

IDZIESZ NA PÓŁNOCNY ZACHÓD
ZNAJDUJESZ SIĘ W PIECZARZE NAD CZARNYM  JEZIOREM

WYJŚCIA:
PÓŁNOCNY WSCHÓD
WSCHÓD
POŁUDNIOWY WSCHÓD
WIDZISZ:
CZARNE JEZIORO NA WSCHODZIE

WCHODZI THORIN
ZACZYNA CI SIĘ CHCIEĆ JEŚĆ

> PNW

IDZIESZ NA PÓŁNOCNY WSCHÓD
ZNAJDUJESZ SIĘ W PIECZARZE NAD CZARNYM  JEZIOREM

WYJŚCIA:
POŁUDNIOWY WSCHÓD
POŁUDNIE
POŁUDNIOWY ZACHÓD
GÓRA
WIDZISZ:
CZARNE JEZIORO NA POŁUDNIU

WCHODZI THORIN
> G

IDZIESZ W GÓRĘ
ZNAJDUJESZ SIĘ W LABIRYNCIE KORYTARZY

WYJŚCIA:
WSCHÓD
POŁUDNIE
DÓŁ
WIDZISZ:
STAREGO GOBLINA

WCHODZI THORIN
> W

IDZIESZ NA WSCHÓD
ZNAJDUJESZ SIĘ W LABIRYNCIE KORYTARZY

WYJŚCIA:
PÓŁNOC
WSCHÓD
ZACHÓD

WCHODZI THORIN
> W

IDZIESZ NA WSCHÓD
ZNAJDUJESZ SIĘ W LABIRYNCIE KORYTARZY

WYJŚCIA:
PÓŁNOC
WSCHÓD
ZACHÓD

WCHODZI THORIN
ZACZYNA CI SIĘ CHCIEĆ JEŚĆ

> W

IDZIESZ NA WSCHÓD
ZNAJDUJESZ SIĘ W LABIRYNCIE KORYTARZY

WYJŚCIA:
PÓŁNOC
POŁUDNIE
ZACHÓD

WCHODZI THORIN
> PN

IDZIESZ NA PÓŁNOC
ZNAJDUJESZ SIĘ W LABIRYNCIE KORYTARZY

WYJŚCIA:
PÓŁNOC
PÓŁNOCNY WSCHÓD
WSCHÓD
POŁUDNIOWY WSCHÓD
POŁUDNIE
WIDZISZ:
KAMIENNE WROTA NA PÓŁNOCNYM
WSCHODZIE
 KAMIENNE WROTA SĄ ZAMKNIĘTE

WCHODZI THORIN
> OTWÓRZ WROTA

OTWIERASZ KAMIENNE WROTA
 KAMIENNE WROTA SĄ OTWARTE
> PNW

IDZIESZ PRZEZ KAMIENNE WROTA
ZNAJDUJESZ SIĘ NA SKALNEJ ŚCIEZCE

WYJŚCIA:
WSCHÓD
POŁUDNIOWY ZACHÓD
ZACHÓD
WIDZISZ:
KAMIENNE WROTA NA POŁUDNIOWYM
ZACHODZIE
 KAMIENNE WROTA SĄ OTWARTE

WCHODZI THORIN
ZACZYNA CI SIĘ CHCIEĆ JEŚĆ

>

=== ETAP 4: DOM BEORNA, CZARNA RZEKA I MROCZNA PUSZCZA ===
W

IDZIESZ NA WSCHÓD
ZNAJDUJESZ SIĘ NA SKALNEJ ŚCIEZCE

WYJŚCIA:
PÓŁNOCNY WSCHÓD
ZACHÓD
WIDZISZ:
BRAMĘ NA PÓŁNOCNYM WSCHODZIE
 BRAMA JEST OTWARTA

WCHODZI THORIN
> PNW

IDZIESZ PRZEZ BRAMĘ
ZNAJDUJESZ SIĘ NA PODWÓRZU POD DOMEM
BEORNA

WYJŚCIA:
WSCHÓD
POŁUDNIOWY ZACHÓD
WIDZISZ:
BRAMĘ NA POŁUDNIOWYM ZACHODZIE
 BRAMA JEST OTWARTA
DREWNIANE DRZWI NA WSCHODZIE
 DREWNIANE DRZWI SĄ ZAMKNIĘTE

WCHODZI THORIN
> C

CZEKASZ
BEORN OTWIERA DREWNIANE DRZWI
> W

IDZIESZ PRZEZ DREWNIANE DRZWI
ZNAJDUJESZ SIĘ W DOMU BEORNA

WYJŚCIA:
PÓŁNOCNY WSCHÓD
WSCHÓD
POŁUDNIOWY WSCHÓD
ZACHÓD
WIDZISZ:
BEORNA
 BEORN MA:
  SUSZONE MIĘSO
DREWNIANE DRZWI NA ZACHODZIE
 DREWNIANE DRZWI SĄ OTWARTE

WCHODZI THORIN
BEORN MÓWI :
 MUSISZ MIEĆ ŻYWNOŚĆ NA DROGĘ
NIE MAM WIELE ALE PODZIELĘ SIĘ
TYM CO MAM

ZACZYNA CI SIĘ CHCIEĆ JEŚĆ

> ZJEDZ ŚNIADANIE

JESZ ŚNIADANIE
NIAM NIAM NIAM...

> W

IDZIESZ NA WSCHÓD
ZNAJDUJESZ SIĘ W LESIE

WYJŚCIA:
WSCHÓD
ZACHÓD

WCHODZI THORIN
> W

IDZIESZ NA WSCHÓD
ZNAJDUJESZ SIĘ W LESIE

WYJŚCIA:
PÓŁNOC
WSCHÓD
POŁUDNIE
ZACHÓD

WCHODZI THORIN
> W

IDZIESZ NA WSCHÓD
ZNAJDUJESZ SIĘ NA ZACHODNIM BRZEGU
CZARNEJ RZEKI

WYJŚCIA:
WSCHÓD
ZACHÓD
WIDZISZ:
ŁÓDKĘ

WCHODZI THORIN
> POWIEDZ THORINOWI WEJDŹ DO ŁÓDKI
MÓWISZ DO THORINA

THORIN IDZIE DO ŁÓDKI
> WEJDŹ DO ŁÓDKI

IDZIESZ DO ŁÓDKI
MOC PIERŚCIENIA PORUSZA ŁÓDKĘ

ZNAJDUJESZ SIĘ NA WSCHODNIM BRZEGU
CZARNEJ RZEKI

WYJŚCIA:
WSCHÓD
ZACHÓD
WIDZISZ:
THORINA
 THORIN MA:
  WIELKI TOPÓR
ŁÓDKĘ

> W

IDZIESZ NA WSCHÓD
ZNAJDUJESZ SIĘ W LESIE

WYJŚCIA:
WSCHÓD
POŁUDNIE
ZACHÓD
PÓŁNOCNY ZACHÓD

WCHODZI THORIN
> W

IDZIESZ NA WSCHÓD
ZNAJDUJESZ SIĘ W LESIE

WYJŚCIA:
PÓŁNOC
POŁUDNIOWY WSCHÓD
ZACHÓD

WCHODZI THORIN
> PN

IDZIESZ NA PÓŁNOC
ZNAJDUJESZ SIĘ W LESIE

WYJŚCIA:
POŁUDNIOWY WSCHÓD
POŁUDNIE
POŁUDNIOWY ZACHÓD
ZACHÓD
PÓŁNOCNY ZACHÓD

WCHODZI THORIN
> PDW

IDZIESZ NA POŁUDNIOWY WSCHÓD
ZNAJDUJESZ SIĘ NA LEŚNEJ POLANIE

WYJŚCIA:
WSCHÓD
PÓŁNOCNY ZACHÓD
WIDZISZ:
CZARNEGO PAJĄKA

WCHODZI THORIN
UWAŻAJ, PAJĄK ATAKUJE!

> POWIEDZ THORINOWI ZABIJ PAJĄKA TOPOREM
MÓWISZ DO THORINA

THORIN ZABIJA CZARNEGO PAJĄKA
WIELKIM TOPOREM
>

=== ETAP 5: LOCHY KRÓLA LEŚNYCH ELFÓW I UCIECZKA W BECZCE ===
W

IDZIESZ NA WSCHÓD
ZNAJDUJESZ SIĘ NA LEŚNEJ POLANIE

WYJŚCIA:
WSCHÓD
ZACHÓD

WCHODZI THORIN
POJAWIA SIĘ KILKUNASTU ELFÓW
ELFY PORYWAJĄ CIĘ

ZNAJDUJESZ SIĘ W LOCHU KRÓLA ELFÓW

WYJŚCIA:
WSCHÓD
WIDZISZ:
OKUTE DRZWI NA WSCHODZIE
 OKUTE DRZWI SĄ ZAMKNIĘTE
CHLEB

> WEŹ CHLEB

BIERZESZ CHLEB
> OTWÓRZ DRZWI

OTWIERASZ OKUTE DRZWI
 OKUTE DRZWI SĄ OTWARTE
> ZOSTAW KLUCZ

ZOSTAWIASZ ZŁOTY KLUCZ
> W

IDZIESZ PRZEZ OKUTE DRZWI
ZNAJDUJESZ SIĘ W KORYTARZU

WYJŚCIA:
PÓŁNOC
WSCHÓD
ZACHÓD
WIDZISZ:
OKUTE DRZWI NA ZACHODZIE
 OKUTE DRZWI SĄ OTWARTE
DREWNIANE DRZWI NA PÓŁNOCY
 DREWNIANE DRZWI SĄ ZAMKNIĘTE

> W

IDZIESZ NA WSCHÓD
ZNAJDUJESZ SIĘ W PAŁACOWEJ PIWNICY

WYJŚCIA:
ZACHÓD
DÓŁ
WIDZISZ:
KRÓLEWSKIEGO STRAZNIKA
DREWNIANĄ KLAPĘ NA DOLE
 DREWNIANA KLAPA JEST OTWARTA
OTWARTĄ BECZKĘ
ZAMKNIĘTE BECZKI

STRAŻNIK WYRZUCA JEDNĄ Z BECZEK
PRZEZ KLAPĘ W PODŁODZE

> WEJDŹ DO OTWARTEJ BECZKI

IDZIESZ DO OTWARTEJ BECZKI
CZUJESZ, ŻE BECZKA PORUSZA SIĘ I SPADA
PRZEZ PEWIEN CZAS CZUJESZ KOŁYSANIE
POTEM SILNE UDERZENIE I BECZKA
ROZBIJA SIĘ

ZNAJDUJESZ SIĘ NA POŁUDNIOWYM BRZEGU
WIELKIEJ RZEKI

WYJŚCIA:
PÓŁNOC
WSCHÓD
WIDZISZ:
ŁÓDKĘ

>

=== ETAP 6: MIASTO NAD JEZIOREM, BARD I JASKINIA SMOKA ===
W

IDZIESZ NA WSCHÓD
ZNAJDUJESZ SIĘ W MIEŚCIE NAD JEZIOREM

WYJŚCIA:
POŁUDNIOWY WSCHÓD
POŁUDNIOWY ZACHÓD
ZACHÓD

> PDW

IDZIESZ NA POŁUDNIOWY WSCHÓD
ZNAJDUJESZ SIĘ W MIEŚCIE NAD JEZIOREM

WYJŚCIA:
PÓŁNOCNY WSCHÓD
ZACHÓD
PÓŁNOCNY ZACHÓD
WIDZISZ:
BARDA

BARD MÓWI :
POKAŻĘ CI UKRYTE PRZEJŚCIE.
CHODŹ ZA MNĄ.

BARD IDZIE NA PÓŁNOCNY WSCHÓD
> PNW

IDZIESZ NA PÓŁNOCNY WSCHÓD
ZNAJDUJESZ SIĘ W MIEŚCIE NAD JEZIOREM

WYJŚCIA:
WSCHÓD
POŁUDNIOWY ZACHÓD
ZACHÓD
WIDZISZ:
BARDA

BARD IDZIE NA ZACHÓD
> Z

IDZIESZ NA ZACHÓD
ZNAJDUJESZ SIĘ W MIEŚCIE NAD JEZIOREM

WYJŚCIA:
PÓŁNOC
PÓŁNOCNY WSCHÓD
WSCHÓD
PÓŁNOCNY ZACHÓD
WIDZISZ:
BARDA

BARD IDZIE NA PÓŁNOCNY WSCHÓD
> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
WCHODZI BARD
> POWIEDZ BARDOWI ZABIJ SMOKA
MÓWISZ DO BARDA
BARD MÓWI :

 ŚWIETNY POMYSŁ! JAK GO TYLKO ZOBACZĘ

BARD IDZIE NA PÓŁNOCNY WSCHÓD
> PNW

IDZIESZ NA PÓŁNOCNY WSCHÓD
ZNAJDUJESZ SIĘ W MIEŚCIE NAD JEZIOREM

WYJŚCIA:
WSCHÓD
POŁUDNIOWY ZACHÓD
WIDZISZ:
BARDA

BARD IDZIE NA WSCHÓD
DOBIEGA CIĘ RYK KONAJĄCEGO SMOKA

> W

IDZIESZ NA WSCHÓD
ZNAJDUJESZ SIĘ W MIEŚCIE NAD JEZIOREM

WYJŚCIA:
ZACHÓD
WIDZISZ:
BARDA
UKRYTE PRZEJŚCIE

> IDŹ PRZEZ UKRYTE PRZEJŚCIE

IDZIESZ PRZEZ UKRYTE PRZEJŚCIE
ZNAJDUJESZ SIĘ NA PRZYSTANI

WYJŚCIA:
WSCHÓD
WIDZISZ:
UKRYTE PRZEJŚCIE
TRATWĘ
JEZIORO NA WSCHODZIE

> WEJDŹ NA TRATWĘ

IDZIESZ NA TRATWĘ
TRATWA RUSZA I PŁYNIE PO FALACH
DŁUGIEGO JEZIORA
TRATWA DOBIJA DO BRZEGU. WYSIADASZ

ZNAJDUJESZ SIĘ NA KAMIENISTEJ PLAŻY

WYJŚCIA:
PÓŁNOCNY WSCHÓD
WSCHÓD
ZACHÓD
WIDZISZ:
TRATWĘ
GŁÓWNE WEJŚCIE NA WSCHODZIE
JEZIORO NA ZACHODZIE

> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
> C

CZEKASZ
> W

IDZIESZ PRZEZ GŁÓWNE WEJŚCIE
ZNAJDUJESZ SIĘ W JASKINI SMOKA

WYJŚCIA:
ZACHÓD
GÓRA
WIDZISZ:
GŁÓWNE WEJŚCIE NA ZACHODZIE
PRZEJŚCIE NA GÓRZE
OKUTĄ SKRZYNIĘ
 OKUTA SKRZYNIA JEST ZAMKNIĘTA

> OTWÓRZ SKRZYNIĘ

OTWIERASZ OKUTĄ SKRZYNIĘ
 OKUTA SKRZYNIA JEST OTWARTA
> WEŹ KULĘ

BIERZESZ KRYSZTAŁOWĄ KULĘ
>

=== ETAP 7: POWRÓT („...I WEWTE”) DO BAG END ===
ZJEDZ MIĘSO

JESZ SUSZONE MIĘSO
NIAM NIAM NIAM...

> Z

IDZIESZ PRZEZ GŁÓWNE WEJŚCIE
ZNAJDUJESZ SIĘ NA KAMIENISTEJ PLAŻY

WYJŚCIA:
PÓŁNOCNY WSCHÓD
WSCHÓD
ZACHÓD
WIDZISZ:
TRATWĘ
GŁÓWNE WEJŚCIE NA WSCHODZIE
JEZIORO NA ZACHODZIE

> WEJDŹ NA TRATWĘ

IDZIESZ NA TRATWĘ
TRATWA RUSZA I PŁYNIE PO FALACH
DŁUGIEGO JEZIORA
TRATWA DOBIJA DO BRZEGU. WYSIADASZ

ZNAJDUJESZ SIĘ NA PRZYSTANI

WYJŚCIA:
WSCHÓD
WIDZISZ:
UKRYTE PRZEJŚCIE
TRATWĘ
JEZIORO NA WSCHODZIE

> IDŹ PRZEZ UKRYTE PRZEJŚCIE

IDZIESZ PRZEZ UKRYTE PRZEJŚCIE
ZNAJDUJESZ SIĘ W MIEŚCIE NAD JEZIOREM

WYJŚCIA:
ZACHÓD
WIDZISZ:
UKRYTE PRZEJŚCIE

> Z

IDZIESZ NA ZACHÓD
ZNAJDUJESZ SIĘ W MIEŚCIE NAD JEZIOREM

WYJŚCIA:
WSCHÓD
POŁUDNIOWY ZACHÓD

> PDZ

IDZIESZ NA POŁUDNIOWY ZACHÓD
ZNAJDUJESZ SIĘ W MIEŚCIE NAD JEZIOREM

WYJŚCIA:
PÓŁNOC
PÓŁNOCNY WSCHÓD
WSCHÓD
PÓŁNOCNY ZACHÓD

WCHODZI BARD
> W

IDZIESZ NA WSCHÓD
ZNAJDUJESZ SIĘ W MIEŚCIE NAD JEZIOREM

WYJŚCIA:
WSCHÓD
POŁUDNIOWY ZACHÓD
ZACHÓD

> PDZ

IDZIESZ NA POŁUDNIOWY ZACHÓD
ZNAJDUJESZ SIĘ W MIEŚCIE NAD JEZIOREM

WYJŚCIA:
PÓŁNOCNY WSCHÓD
ZACHÓD
PÓŁNOCNY ZACHÓD

> PNZ

IDZIESZ NA PÓŁNOCNY ZACHÓD
ZNAJDUJESZ SIĘ W MIEŚCIE NAD JEZIOREM

WYJŚCIA:
POŁUDNIOWY WSCHÓD
POŁUDNIOWY ZACHÓD
ZACHÓD

> Z

IDZIESZ NA ZACHÓD
ZNAJDUJESZ SIĘ NA POŁUDNIOWYM BRZEGU
WIELKIEJ RZEKI

WYJŚCIA:
PÓŁNOC
WSCHÓD
WIDZISZ:
ŁÓDKĘ

> WEJDŹ DO ŁÓDKI

IDZIESZ DO ŁÓDKI
MOC PIERŚCIENIA PORUSZA ŁÓDKĘ

ZNAJDUJESZ SIĘ NA PÓŁNOCNYM BRZEGU
WIELKIEJ RZEKI

WYJŚCIA:
POŁUDNIE
ZACHÓD
WIDZISZ:
ŁÓDKĘ

> Z

IDZIESZ NA ZACHÓD
ZNAJDUJESZ SIĘ NA LEŚNEJ POLANIE

WYJŚCIA:
WSCHÓD
ZACHÓD

> Z

IDZIESZ NA ZACHÓD
ZNAJDUJESZ SIĘ NA LEŚNEJ POLANIE

WYJŚCIA:
WSCHÓD
PÓŁNOCNY ZACHÓD
WIDZISZ:
CZARNEGO ZABITEGO PAJĄKA

> PNZ

IDZIESZ NA PÓŁNOCNY ZACHÓD
ZNAJDUJESZ SIĘ W LESIE

WYJŚCIA:
POŁUDNIOWY WSCHÓD
POŁUDNIE
POŁUDNIOWY ZACHÓD
ZACHÓD
PÓŁNOCNY ZACHÓD

> PD

IDZIESZ NA POŁUDNIE
ZNAJDUJESZ SIĘ W LESIE

WYJŚCIA:
PÓŁNOC
POŁUDNIOWY WSCHÓD
ZACHÓD

> Z

IDZIESZ NA ZACHÓD
ZNAJDUJESZ SIĘ W LESIE

WYJŚCIA:
WSCHÓD
POŁUDNIE
ZACHÓD
PÓŁNOCNY ZACHÓD

> Z

IDZIESZ NA ZACHÓD
ZNAJDUJESZ SIĘ NA WSCHODNIM BRZEGU
CZARNEJ RZEKI

WYJŚCIA:
WSCHÓD
ZACHÓD
WIDZISZ:
ŁÓDKĘ

> WEJDŹ DO ŁÓDKI

IDZIESZ DO ŁÓDKI
MOC PIERŚCIENIA PORUSZA ŁÓDKĘ

ZNAJDUJESZ SIĘ NA ZACHODNIM BRZEGU
CZARNEJ RZEKI

WYJŚCIA:
WSCHÓD
ZACHÓD
WIDZISZ:
ŁÓDKĘ

> Z

IDZIESZ NA ZACHÓD
ZNAJDUJESZ SIĘ W LESIE

WYJŚCIA:
PÓŁNOC
WSCHÓD
POŁUDNIE
ZACHÓD

> Z

IDZIESZ NA ZACHÓD
ZNAJDUJESZ SIĘ W LESIE

WYJŚCIA:
WSCHÓD
ZACHÓD

> Z

IDZIESZ NA ZACHÓD
ZNAJDUJESZ SIĘ W DOMU BEORNA

WYJŚCIA:
PÓŁNOCNY WSCHÓD
WSCHÓD
POŁUDNIOWY WSCHÓD
ZACHÓD
WIDZISZ:
BEORNA
DREWNIANE DRZWI NA ZACHODZIE
 DREWNIANE DRZWI SĄ OTWARTE

> Z

IDZIESZ PRZEZ DREWNIANE DRZWI
ZNAJDUJESZ SIĘ NA PODWÓRZU POD DOMEM
BEORNA

WYJŚCIA:
WSCHÓD
POŁUDNIOWY ZACHÓD
WIDZISZ:
BRAMĘ NA POŁUDNIOWYM ZACHODZIE
 BRAMA JEST OTWARTA
DREWNIANE DRZWI NA WSCHODZIE
 DREWNIANE DRZWI SĄ OTWARTE

> PDZ

IDZIESZ PRZEZ BRAMĘ
ZNAJDUJESZ SIĘ NA SKALNEJ ŚCIEZCE

WYJŚCIA:
PÓŁNOCNY WSCHÓD
ZACHÓD
WIDZISZ:
BRAMĘ NA PÓŁNOCNYM WSCHODZIE
 BRAMA JEST OTWARTA

> Z

IDZIESZ NA ZACHÓD
ZNAJDUJESZ SIĘ NA SKALNEJ ŚCIEZCE

WYJŚCIA:
WSCHÓD
POŁUDNIOWY ZACHÓD
ZACHÓD
WIDZISZ:
KAMIENNE WROTA NA POŁUDNIOWYM
ZACHODZIE
 KAMIENNE WROTA SĄ OTWARTE

> Z

IDZIESZ NA ZACHÓD
ZNAJDUJESZ SIĘ W DOLINIE MGIEŁ

WYJŚCIA:
PÓŁNOC
WSCHÓD
POŁUDNIE
ZACHÓD

> Z

IDZIESZ NA ZACHÓD
ZNAJDUJESZ SIĘ W RIVENDELL

WYJŚCIA:
WSCHÓD
ZACHÓD
PÓŁNOCNY ZACHÓD

> Z

IDZIESZ NA ZACHÓD
ZNAJDUJESZ SIĘ NA POLANIE TROLLI

WYJŚCIA:
PÓŁNOC
WSCHÓD
ZACHÓD
WIDZISZ:
SKAMIENIAŁEGO STAREGO TROLLA
SKAMIENIAŁEGO MŁODEGO TROLLA

> Z

IDZIESZ NA ZACHÓD
ZNAJDUJESZ SIĘ NA PUSTKOWIU

WYJŚCIA:
PÓŁNOCNY WSCHÓD
WSCHÓD
ZACHÓD
WIDZISZ:
OKRĄGŁE DRZWI NA ZACHODZIE
 OKRĄGŁE DRZWI SĄ OTWARTE

> Z

IDZIESZ PRZEZ OKRĄGŁE DRZWI
ZNAJDUJESZ SIĘ W WYGODNYM TUNELU

WYJŚCIA:
WSCHÓD
WIDZISZ:
GANDALFA
WIELKĄ DREWNIANĄ SKRZYNIĘ
 WIELKA DREWNIANA SKRZYNIA JEST
OTWARTA
OKRĄGŁE DRZWI NA WSCHODZIE
 OKRĄGŁE DRZWI SĄ OTWARTE

GANDALF MÓWI :
NA CO CZEKASZ, SPIESZ SIĘ!

> DAJ KULĘ GANDALFOWI

DAJESZ KRYSZTAŁOWĄ KULĘ GANDALFOWI

╔══════════════════════════════════════╗
║  DOKONAŁEŚ WIELKIEGO CZYNU. KLEJNOT  ║
║  DURINA ZNALAZŁ SIĘ WE WŁAŚCIWYCH    ║
║  RĘKACH. ZNOWU WRACA SPOKÓJ, A NA    ║
║  PAMIĄTKĘ WYPRAWY POZOSTAŁ TYLKO     ║
║  ZŁOTY PIERŚCIEŃ...                  ║
║      G R A   S K O Ń C Z O N A       ║
╚══════════════════════════════════════╝
```

---

## 4. Wszystkie wypowiedzi postaci, komunikaty i zdarzenia w grze

Poniżej zebrano wszystkie komunikaty fabularne, dialogi postaci niezależnych (NPC), opisy śmierci/pułapek oraz komunikaty systemowe zaszyte w kodzie gry (`$174D`–`$260F`):

### Wypowiedzi postaci i zdarzenia fabularne

| Postać / Zdarzenie | Pełny tekst komunikatu w grze | Kiedy występuje |
| :--- | :--- | :--- |
| **Gandalf** (`msg_gandalf_hurry`) | `GANDALF MÓWI :`<br>`NA CO CZEKASZ, SPIESZ SIĘ!` | Gdy gracz przebywa w lokacji `$01` (`W WYGODNYM TUNELU`) z Gandalfem |
| **Młody i Stary Troll** (`msg_trolls_breakfast`, `msg_trolls_too_small`) | `MŁODY DZIKI TROLL MÓWI :`<br>` ZOBACZ, WILL, WESZŁO ŚNIADANIE!`<br>`STARY DZIKI TROLL MÓWI :`<br>` COŚ TY, ON JEST ZA MAŁY, NIE NAJEMY SIĘ` | Pierwsza tura po wejściu na Polanę Trolli (`$03`) |
| **Trolle — śmierć gracza** (`msg_trolls_eat_you`) | `TROLLE DOCHODZĄ DO WNIOSKU, ŻE NA`<br>`ŚNIADANIE JESTEŚ JEDNAK WYSTARCZAJĄCO`<br>`TŁUSTY...` | Pozostanie na Polanie Trolli (`$03`) na kolejną turę przed nastaniem świtu |
| **Świt i skamienienie trolli** (`msg_dawn_breaks`) | `WSTAJE DZIEŃ...` | Po wejściu na Polanę Trolli i odczekaniu tury — trolle kamienieją i upuszczają `WIELKI KLUCZ` |
| **Thorin o toporze z Khazad-dûm** (`msg_thorin_axe_story`) | `THORIN MÓWI:`<br>`JEST TO TOPÓR WYKUTY W PODZIEMNYM`<br>`MIEŚCIE KHAZAD-DUM. TYLKO MY, WOJOWNICY`<br>`Z RODU KRASNOLUDÓW POTRAFIMY POSŁUŻYĆ`<br>`SIĘ TAKIM TOPOREM`<br><br>`THORIN ZABIERA WIELKI TOPÓR` | Gdy Thorin wchodzi do Skalnej Pieczary (`$05`), w której leży `WIELKI TOPÓR` |
| **Nieudana próba odczytania mapy** (`msg_ancient_script`) | `NIE MOŻESZ PRZECZYTAĆ STAROZYTNEGO PISMA`<br>`KTÓRYM OPISANA JEST MAPA` | Gdy gracz (lub ktoś inny niż Elrond) próbuje samemu przeczytać `STARĄ MAPĘ` |
| **Elrond odczytuje mapę** (`msg_search_south`, `msg_elrond_advice`) | `ELROND ODCZYTUJE STARĄ MAPĘ`<br>`ELROND MÓWI :`<br>` SZUKAJ NA POŁUDNIE OD DOLINY MGIEŁ`<br><br>`ELROND MÓWI :`<br>` WEŹ PROWIANT NA DROGĘ, W TAK DŁUGIEJ`<br>`PODRÓŻY MOŻESZ CZASEM BYĆ GŁODNY.`<br>`ELROND DAJE CI ŚNIADANIE` | Po wydaniu polecenia `POWIEDZ ELRONDOWI PRZECZYTAJ MAPĘ` w Rivendell (`$06`) |
| **Dziki Warg** (`msg_warg_blocks_way`, `msg_warg_attacks`, `msg_warg_kills_you`) | `WARG NIE POZWALA CI ODEJŚĆ`<br>`UWAŻAJ, DZIKI WARG ATAKUJE!`<br>`NIESTETY, WARG OKAZAŁ SIĘ SILNIEJSZY` | Spotkanie z Dzikim Wargiem w Górach Mglistych (`$0C`–`$0F`) |
| **Zasadzka Goblinów** (`msg_goblins_capture`) | `NAGLE POJAWIAJĄ SIĘ GOBLINY`<br>`MIMO PRÓB UCIECZKI DOSTAJESZ SIĘ DO`<br>`NIEWOLI` | Wejście na Skalną Ścieżkę (`$12`) bez Złotego Pierścienia |
| **Gollum — kradzież pierścienia na jego oczach** (`msg_gollum_kills_for_ring`) | `GOLLUM JEST ZDANIA, ŻE PIERŚCIEŃ JEST`<br>`JEGO WŁASNOŚCIĄ I ZABIJA CIĘ` | Próba podniesienia `ZŁOTEGO PIERŚCIENIA` w obecności Golluma |
| **Gollum — lament po stracie pierścienia** (`msg_gollum_laments`) | `GOLLUM MOWI :`<br>` KTOŚ UKRADŁ MÓJ PIERŚCIEŃ I POSIADŁ MOC`<br>`ELFÓW, KTÓRE GO WYKUŁY! ZABIJĘ GO!` | Gdy Gollum zauważa zniknięcie pierścienia nad Czarnym Jeziorem |
| **Gollum — zdradzenie się głosem** (`msg_ring_slips_off`) | `DOTYCHCZAS CHRONIŁ CIĘ PIERŚCIEŃ DAJĄC CI`<br>`NIEWIDZIALNOŚĆ, ALE TERAZ GOLLUM`<br>`USŁYSZAŁ TWÓJ GŁOS I WIE, ŻE TU JESTEŚ` | Gdy gracz posiadający pierścień odezwie się do Golluma (`POWIEDZ GOLLUMOWI...`) |
| **Beorn — wejście bez pozwolenia** (`msg_beorn_kills_you`) | `OKAZUJE SIĘ, ŻE BEORN BARDZO NIE LUBI`<br>`JEŚLI OTWIERA SIĘ JEGO DRZWI BEZ`<br>`POZWOLENIA. NIESTETY MA ON ZWYCZAJ`<br>`ZABIJANIA NIEPOŻĄDANYCH GOŚCI` | Jeśli gracz sam otworzy `DREWNIANE DRZWI` na podwórzu Beorna (`$26`) i wejdzie do środka |
| **Beorn — poczęstunek** (`msg_beorn_gives_food`) | `BEORN MÓWI :`<br>` MUSISZ MIEĆ ŻYWNOŚĆ NA DROGĘ`<br>`NIE MAM WIELE ALE PODZIELĘ SIĘ`<br>`TYM CO MAM` | Po wejściu do Domu Beorna (`$27`), gdy Beorn sam otworzył drzwi |
| **Zaczarowana łódka** (`msg_ring_moves_boat`) | `MOC PIERŚCIENIA PORUSZA ŁÓDKĘ` | Wejście do łódki (`WEJDŹ DO ŁÓDKI`) na brzegu Czarnej lub Wielkiej Rzeki |
| **Czarny Pająk** (`msg_spider_blocks_way`, `msg_spider_attacks`, `msg_spider_kills_you`) | `PAJAK NIE POZWALA CI ODEJŚĆ`<br>`UWAŻAJ, PAJĄK ATAKUJE!`<br>`NIESTETY, PAJĄK OKAZAŁ SIĘ SILNIEJSZY` | Spotkanie z Czarnym Pająkiem na Leśnej Polanie (`$33`) |
| **Porwanie przez Leśne Elfy** (`msg_elves_capture`) | `POJAWIA SIĘ KILKUNASTU ELFÓW`<br>`ELFY PORYWAJĄ CIĘ` | Wejście na Leśną Polanę (`$34`) bez `KRYSZTAŁOWEJ KULI` |
| **Strażnik w piwnicy elfów** (`msg_guard_throws_barrel`, `msg_guard_throws_thorin`) | `STRAŻNIK WYRZUCA JEDNĄ Z BECZEK`<br>`PRZEZ KLAPĘ W PODŁODZE`<br>*(lub)*<br>`WIDZISZ JAK STRAŻNIK WYRZUCA BECZKĘ`<br>`Z SIEDZĄCYM W NIEJ THORINEM PRZEZ KLAPĘ` | W Pałacowej Piwnicy (`$3B`) |
| **Spływ w beczce** (`msg_barrel_river_ride`) | `CZUJESZ, ŻE BECZKA PORUSZA SIĘ I SPADA`<br>`PRZEZ PEWIEN CZAS CZUJESZ KOŁYSANIE`<br>`POTEM SILNE UDERZENIE I BECZKA`<br>`ROZBIJA SIĘ` | Po wpisaniu `WEJDŹ DO OTWARTEJ BECZKI` w Pałacowej Piwnicy (`$3B`) |
| **Bard — ukryte przejście** (`msg_bard_secret_pass`) | `BARD MÓWI :`<br>`POKAŻĘ CI UKRYTE PRZEJŚCIE.`<br>`CHODŹ ZA MNĄ.` | Pierwsze spotkanie z Bardem w Mieście nad Jeziorem |
| **Bard — zlecenie zabicia smoka** (`msg_bard_great_idea`, `msg_bard_already_told`, `msg_bard_already_killed`) | ` ŚWIETNY POMYSŁ! JAK GO TYLKO ZOBACZĘ`<br>*(ponownie:)* ` JUŻ MI TO MÓWIŁEŚ`<br>*(po zabiciu smoka:)* ` JEDNEGO JUŻ ZABIŁEM` | Po wpisaniu `POWIEDZ BARDOWI ZABIJ SMOKA` |
| **Przeprawa tratwą** (`msg_raft_sails`, `msg_raft_lands`) | `TRATWA RUSZA I PŁYNIE PO FALACH`<br>`DŁUGIEGO JEZIORA`<br>`TRATWA DOBIJA DO BRZEGU. WYSIADASZ` | Po wpisaniu `WEJDŹ NA TRATWĘ` na przystani (`$4C`) lub kamienistej plaży (`$4F`) |
| **Smok Smaug** (`msg_dragon_flies_in`, `msg_dragon_flies_away`, `msg_bard_kills_dragon`, `msg_dying_dragon_roar`) | `WLATUJE STRASZNY SMOK`<br>`STRASZNY SMOK ODLATUJE`<br>`WIDZISZ JAK BARD ZABIJA SMOKA`<br>`DOBIEGA CIĘ RYK KONAJĄCEGO SMOKA` | Loty Smauga i śmierć smoka z ręki Barda |
| **Smaug broni skarbu** (`msg_dragon_kills_you`) | `OKAZUJE SIĘ, ŻE SMOK NIE LUBI, KIEDY`<br>`KTOŚ DOBIERA SIĘ DO JEGO WŁASNOŚCI...` | Próba otwarcia skrzyni lub zabrania kuli, gdy żywy smok jest w jaskini (`$52`) |
| **Szaleństwo Thorina na widok Arcyklejnotu** (`msg_thorin_gems_speech`) | `NA WIDOK KLEJNOTU DURINA THORIN TRACI`<br>`GŁOWĘ`<br>`THORIN MÓWI :`<br>` KRYSZTAŁOWA KULA KRASNOLUDÓW MUSI`<br>`POZOSTAĆ W RĘKU JEDNEGO Z NICH`<br>`ZABIJĘ KAŻDEGO KTO JEJ DOTKNIE!`<br><br>`...I THORIN ROBI TO CO ZAPOWIEDZIAŁ` | Gdy gracz weźmie `KRYSZTAŁOWĄ KULĘ` w obecności Thorina |
| **Odejście zniecierpliwionego Thorina** (`msg_thorin_leaves`) | `THORIN MÓWI :`<br>` MAM JUŻ DOŚĆ, ODCHODZĘ. ŻEGNAJ`<br>`THORIN ODCHODZI` | Gdy gracz każe Thorinowi czekać zbyt długo |
| **Utonięcie** (`msg_cannot_swim`) | `NIESTETY NIE UMIESZ PŁYWAĆ` | Wejście do głębokiej wody (`$24`, `$2D`, `$36`, `$3C`, `$4D`, `$4E`) bez łódki/tratwy/beczki |

### Komunikaty głodu i jedzenia (`hunger_msg_ptr_table`)
* `NIAM NIAM NIAM...` — po zjedzeniu `ŚNIADANIA`, `SUSZONEGO MIĘSA` lub `CHLEBA`
* `ZACZYNA CI SIĘ CHCIEĆ JEŚĆ`
* `COŚ BY SIĘ ZJADŁO...`
* `CHCE CI SIĘ JEŚĆ`
* `JESTEŚ BARDZO GŁODNY`
* `CZUJESZ, ŻE CIĘ SSIE Z GŁODU!`
* `PRAWIE UMIERASZ Z GŁODU`
* `NIESTETY, HOBBIT TO NIE JEST WIELBŁĄD I / CO JAKIŚ CZAS MUSI COŚ ZJEŚĆ, INACZEJ / GINIE Z GŁODU.` (śmierć głodowa)

### Komunikaty parsera i silnika
* `ZDANIE ZBYT DŁUGIE.` / `ZDANIE ZBYT SKOMPLIKOWANE.`
* `NIE ROZUMIEM` / `NIE ROZUMIEM SLOWA "..."`
* `NIE BARDZO ROZUMIEM O CO CHODZI` / `SPRÓBUJ WYRAŻAĆ SIĘ JAŚNIEJ` / `ŻE CO?` / `O CO CHODZI, NIE ROZUMIEM`
* `SPRECYZUJ ...`
* `NIE WIDZISZ ...` / `NIE WIDZĘ ...`
* `NIE MOŻESZ ...` / `NIE MOGĘ ...` / `NIE CHCE ...`
* `NIE DA SIĘ ROZMAWIAĆ Z ...`
* `TU NIE MA PRZEJŚCIA`
* `PRÓBUJESZ ZABIĆ ... WALKA JEST ZACIĘTA, ALE JESTEŚ ZBYT SŁABY. ZOSTAJESZ POKONANY PRZEZ ...`

---

## 5. Spis wszystkich 82 lokacji (`$01`–`$52`)

Wszystkie 82 lokacje zdefiniowane w tablicach `room_desc_table` (`$2610`–`$2C72`) oraz `room_exits` (`$C94F`–`$CC82`):

| ID (Hex) | ID (Dec) | Opis lokacji (`ZNAJDUJESZ SIĘ ...`) | Dostępne wyjścia (`room_exits`) |
| :---: | :---: | :--- | :--- |
| `$01` | 1 | `W WYGODNYM TUNELU` | `W`→`$02` |
| `$02` | 2 | `NA PUSTKOWIU` | `PNW`→`$04`, `W`→`$03`, `Z`→`$01` |
| `$03` | 3 | `NA POLANIE TROLLI` | `PN`→`$04`, `W`→`$06`, `Z`→`$02` |
| `$04` | 4 | `NA SKALNEJ ŚCIEŻCE` | `PN`→`$05`, `PDW`→`$06`, `PD`→`$03`, `PDZ`→`$02` |
| `$05` | 5 | `W SKALNEJ PIECZARZE` | `PD`→`$04` |
| `$06` | 6 | `W RIVENDELL` | `W`→`$07`, `Z`→`$03`, `PNZ`→`$04` |
| `$07` | 7 | `W DOLINIE MGIEŁ` | `PN`→`$08`, `W`→`$12`, `PD`→`$0B`, `Z`→`$06` |
| `$08` | 8 | `W GÓRACH MGLISTYCH` | `PD`→`$07`, `D`→`$09` |
| `$09` | 9 | `W GÓRACH MGLISTYCH` | `PD`→`$0A`, `G`→`$08` |
| `$0A` | 10 | `W GÓRACH MGLISTYCH` | `PN`→`$09`, `G`→`$0B` |
| `$0B` | 11 | `W GÓRACH MGLISTYCH` | `PN`→`$07`, `PD`→`$0C`, `D`→`$0A` |
| `$0C` | 12 | `W GÓRACH MGLISTYCH` | `PN`→`$0B`, `W`→`$0D`, `PD`→`$0F` |
| `$0D` | 13 | `W GÓRACH MGLISTYCH` | `PD`→`$0E`, `Z`→`$0C`, `D`→`$11` |
| `$0E` | 14 | `W GÓRACH MGLISTYCH` | `PN`→`$0D`, `Z`→`$0F`, `D`→`$10` |
| `$0F` | 15 | `W GÓRACH MGLISTYCH` | `PN`→`$0C`, `W`→`$0E` |
| `$10` | 16 | `W GÓRACH MGLISTYCH` | `PN`→`$11`, `G`→`$0E` |
| `$11` | 17 | `W GÓRACH MGLISTYCH` | `PD`→`$10`, `G`→`$0D` |
| `$12` | 18 | `NA SKALNEJ ŚCIEZCE` | `W`→`$25`, `PDZ`→`$1A`, `Z`→`$07` |
| `$13` | 19 | `W LOCHU GOBLINÓW` | `G`→`$14` |
| `$14` | 20 | `W LABIRYNCIE KORYTARZY` | `W`→`$15`, `PD`→`$18`, `D`→`$13` |
| `$15` | 21 | `W LABIRYNCIE KORYTARZY` | `W`→`$16`, `PD`→`$19`, `Z`→`$14` |
| `$16` | 22 | `W LABIRYNCIE KORYTARZY` | `PN`→`$19`, `Z`→`$15` |
| `$17` | 23 | `W LABIRYNCIE KORYTARZY` | `PD`→`$1A`, `Z`→`$1A`, `PNZ`→`$1A` |
| `$18` | 24 | `W LABIRYNCIE KORYTARZY` | `PN`→`$14`, `W`→`$19`, `PD`→`$1C` |
| `$19` | 25 | `W LABIRYNCIE KORYTARZY` | `PN`→`$15`, `W`→`$1F`, `PD`→`$1D`, `Z`→`$18`, `PNZ`→`$1E` |
| `$1A` | 26 | `W LABIRYNCIE KORYTARZY` | `PN`→`$17`, `PNW`→`$12`, `W`→`$17`, `PDW`→`$17`, `PD`→`$1E` |
| `$1B` | 27 | `W LABIRYNCIE KORYTARZY` | `W`→`$1C`, `PD`→`$1F`, `D`→`$20` |
| `$1C` | 28 | `W LABIRYNCIE KORYTARZY` | `PN`→`$18`, `W`→`$1D`, `Z`→`$1B` |
| `$1D` | 29 | `W LABIRYNCIE KORYTARZY` | `PN`→`$19`, `W`→`$1E`, `Z`→`$1C` |
| `$1E` | 30 | `W LABIRYNCIE KORYTARZY` | `PN`→`$1A`, `PD`→`$19`, `Z`→`$1D` |
| `$1F` | 31 | `W LABIRYNCIE KORYTARZY` | `PN`→`$1B`, `Z`→`$19` |
| `$20` | 32 | `W PIECZARZE NAD CZARNYM  JEZIOREM` | `PDW`→`$21`, `PD`→`$24`, `PDZ`→`$23`, `G`→`$1B` |
| `$21` | 33 | `W PIECZARZE NAD CZARNYM  JEZIOREM` | `PDZ`→`$22`, `Z`→`$24`, `PNZ`→`$20` |
| `$22` | 34 | `W PIECZARZE NAD CZARNYM  JEZIOREM` | `PN`→`$24`, `PNW`→`$21`, `PNZ`→`$23` |
| `$23` | 35 | `W PIECZARZE NAD CZARNYM  JEZIOREM` | `PNW`→`$20`, `W`→`$24`, `PDW`→`$22` |
| `$24` | 36 | `W CZARNYM JEZIORZE` | *(brak — śmierć / pułapka)* |
| `$25` | 37 | `NA SKALNEJ ŚCIEZCE` | `PNW`→`$26`, `Z`→`$12` |
| `$26` | 38 | `NA PODWÓRZU POD DOMEM BEORNA` | `W`→`$27`, `PDZ`→`$25` |
| `$27` | 39 | `W DOMU BEORNA` | `PNW`→`$28`, `W`→`$29`, `PDW`→`$2B`, `Z`→`$26` |
| `$28` | 40 | `W LESIE` | `W`→`$2A`, `PD`→`$2A`, `PDZ`→`$27` |
| `$29` | 41 | `W LESIE` | `W`→`$2A`, `Z`→`$27` |
| `$2A` | 42 | `W LESIE` | `PN`→`$28`, `W`→`$2C`, `PD`→`$2B`, `Z`→`$29` |
| `$2B` | 43 | `W LESIE` | `PN`→`$2A`, `W`→`$2A`, `PNZ`→`$27` |
| `$2C` | 44 | `NA ZACHODNIM BRZEGU CZARNEJ RZEKI` | `W`→`$2D`, `Z`→`$2A` |
| `$2D` | 45 | `W CZARNEJ RZECE` | `W`→`$2E`, `Z`→`$2C` |
| `$2E` | 46 | `NA WSCHODNIM BRZEGU CZARNEJ RZEKI` | `W`→`$2F`, `Z`→`$2D` |
| `$2F` | 47 | `W LESIE` | `W`→`$32`, `PD`→`$31`, `Z`→`$2E`, `PNZ`→`$32` |
| `$30` | 48 | `W LESIE` | `PDW`→`$33`, `PD`→`$32`, `PDZ`→`$31`, `Z`→`$31`, `PNZ`→`$31` |
| `$31` | 49 | `W LESIE` | `PN`→`$2F`, `PNW`→`$30`, `W`→`$30`, `PDW`→`$30` |
| `$32` | 50 | `W LESIE` | `PN`→`$30`, `PDW`→`$2F`, `Z`→`$2F` |
| `$33` | 51 | `NA LEŚNEJ POLANIE` | `W`→`$34`, `PNZ`→`$30` |
| `$34` | 52 | `NA LEŚNEJ POLANIE` | `W`→`$35`, `Z`→`$33` |
| `$35` | 53 | `NA PÓŁNOCNYM BRZEGU WIELKIEJ RZEKI` | `PD`→`$36`, `Z`→`$34` |
| `$36` | 54 | `W WIELKIEJ RZECE` | `PN`→`$35`, `PD`→`$37` |
| `$37` | 55 | `NA POŁUDNIOWYM BRZEGU WIELKIEJ RZEKI` | `PN`→`$36`, `W`→`$41` |
| `$38` | 56 | `W LOCHU KRÓLA ELFÓW` | `W`→`$3A` |
| `$39` | 57 | `W LOCHU KRÓLA ELFÓW` | `PD`→`$3A` |
| `$3A` | 58 | `W KORYTARZU` | `PN`→`$39`, `W`→`$3B`, `Z`→`$38` |
| `$3B` | 59 | `W PAŁACOWEJ PIWNICY` | `Z`→`$3A`, `D`→`$3C` |
| `$3C` | 60 | `W WODOSPADZIE` | `G`→`$3B` |
| `$3D` | 61 | `W MIEŚCIE NAD JEZIOREM` | `PDW`→`$42` |
| `$3E` | 62 | `W MIEŚCIE NAD JEZIOREM` | `PNW`→`$49`, `PD`→`$42` |
| `$3F` | 63 | `W MIEŚCIE NAD JEZIOREM` | `W`→`$40`, `PDZ`→`$42` |
| `$40` | 64 | `W MIEŚCIE NAD JEZIOREM` | `Z`→`$3F` |
| `$41` | 65 | `W MIEŚCIE NAD JEZIOREM` | `PDW`→`$46`, `PDZ`→`$48`, `Z`→`$37` |
| `$42` | 66 | `W MIEŚCIE NAD JEZIOREM` | `PN`→`$3E`, `PNW`→`$3F`, `W`→`$43`, `PNZ`→`$3D` |
| `$43` | 67 | `W MIEŚCIE NAD JEZIOREM` | `W`→`$44`, `PDZ`→`$46`, `Z`→`$42` |
| `$44` | 68 | `W MIEŚCIE NAD JEZIOREM` | `PDZ`→`$47`, `Z`→`$43` |
| `$45` | 69 | `W MIEŚCIE NAD JEZIOREM` | `W`→`$46` |
| `$46` | 70 | `W MIEŚCIE NAD JEZIOREM` | `PNW`→`$43`, `Z`→`$45`, `PNZ`→`$41` |
| `$47` | 71 | `W MIEŚCIE NAD JEZIOREM` | `PNW`→`$44` |
| `$48` | 72 | `W MIEŚCIE NAD JEZIOREM` | `PNW`→`$41` |
| `$49` | 73 | `W MIEŚCIE NAD JEZIOREM` | `W`→`$4A`, `PDZ`→`$3E` |
| `$4A` | 74 | `W MIEŚCIE NAD JEZIOREM` | `W`→`$4B`, `Z`→`$49` |
| `$4B` | 75 | `W PAŁACU` | `Z`→`$4A` |
| `$4C` | 76 | `NA PRZYSTANI` | `W`→`$4D` |
| `$4D` | 77 | `W JEZIORZE` | `Z`→`$4C` |
| `$4E` | 78 | `W JEZIORZE` | `W`→`$4F` |
| `$4F` | 79 | `NA KAMIENISTEJ PLAŻY` | `PNW`→`$50`, `W`→`$52`, `Z`→`$4E` |
| `$50` | 80 | `NA SKALNEJ PÓŁCE` | `W`→`$51`, `PDZ`→`$4F` |
| `$51` | 81 | `W CIASNEJ PIECZARZE` | `Z`→`$50`, `D`→`$52` |
| `$52` | 82 | `W JASKINI SMOKA` | `Z`→`$4F`, `G`→`$51` |

---

## 6. Spis wszystkich 53 obiektów i postaci (`$01`–`$35`)

Wszystkie 53 obiekty zdefiniowane w tablicy początkowej `init_objects` (`$C7A6`–`$C94E`, kopiowanej do `$B000`):

| ID (Hex) | Nazwa w grze (Mianownik) | Lokacja początkowa | Uwagi / Właściwości |
| :---: | :--- | :--- | :--- |
| `$01` | `THORIN` | `$02` (`NA PUSTKOWIU`) | Postać niezależna; podąża za graczem, zabiera `WIELKI TOPÓR`, otwiera `OKNO` w lochu goblinów, zabija `CZARNEGO PAJĄKA` |
| `$02` | `GANDALF` | `$01` (`W WYGODNYM TUNELU`) | Postać niezależna; oddanie mu `KRYSZTAŁOWEJ KULI` kończy grę zwycięstwem |
| `$03` | `ELROND` | `$06` (`W RIVENDELL`) | Postać niezależna; odczytuje `STARĄ MAPĘ` i daje `ŚNIADANIE` |
| `$04` | `BEORN` | `$27` (`W DOMU BEORNA`) | Postać niezależna; otwiera `DREWNIANE DRZWI` i daje `SUSZONE MIĘSO` |
| `$05` | `DZIKI WARG` | `$0C` (`W GÓRACH MGLISTYCH`) | Wróg; do pokonania bronią `$13` (`MIECZ`) |
| `$06` | `GRUBY GOBLIN` | `$1A` (`W LABIRYNCIE KORYTARZY`) | Krąży po labiryncie goblinów |
| `$07` | `CHUDY GOBLIN` | `$1A` (`W LABIRYNCIE KORYTARZY`) | Krąży po labiryncie goblinów |
| `$08` | `STARY GOBLIN` | `$1A` (`W LABIRYNCIE KORYTARZY`) | Krąży po labiryncie goblinów |
| `$09` | `MŁODY GOBLIN` | `$1A` (`W LABIRYNCIE KORYTARZY`) | Krąży po labiryncie goblinów |
| `$0A` | `STARY DZIKI TROLL` | `$03` (`NA POLANIE TROLLI`) | Posiada `WIELKI KLUCZ`; o świcie zamienia się w `SKAMIENIAŁEGO STAREGO TROLLA` |
| `$0B` | `MŁODY DZIKI TROLL` | `$03` (`NA POLANIE TROLLI`) | O świcie zamienia się w `SKAMIENIAŁEGO MŁODEGO TROLLA` |
| `$0C` | `KRÓLEWSKI STRAZNIK` | `$3B` (`W PAŁACOWEJ PIWNICY`) | Wrzuca beczki przez klapę w podłodze |
| `$0D` | `BARD` | `$3D` (`W MIEŚCIE NAD JEZIOREM`) | Pokazuje `UKRYTE PRZEJŚCIE` i na prośbę gracza zabija `STRASZNEGO SMOKA` |
| `$0E` | `STRASZNY SMOK` | `$52` (`W JASKINI SMOKA`) | Smaug; lata między jaskinią a Miastem nad Jeziorem |
| `$0F` | `GOLLUM` | `$22` (`W PIECZARZE NAD CZARNYM JEZIOREM`) | Krąży wokół Czarnego Jeziora (`$20`–`$23`) |
| `$10` | `WIELKA DREWNIANA SKRZYNIA` | `$01` (`W WYGODNYM TUNELU`) | Zawiera `STARĄ MAPĘ` (`$12`) |
| `$11` | `ZŁOTY PIERŚCIEŃ` | `$22` (`W PIECZARZE NAD CZARNYM JEZIOREM`) | Daje niewidzialność, otwiera `KAMIENNE WROTA`, ujawnia i napędza `ŁÓDKĘ` |
| `$12` | `STARA MAPA` | W skrzyni `$10` (lokacja `$01`) | Do odczytania przez `ELRONDA` |
| `$13` | `MIECZ` | `$05` (`W SKALNEJ PIECZARZE`) | Broń potrzebna do zabicia `DZIKIEGO WARGA` (`$05`) |
| `$14` | `WIELKI TOPÓR` | `$05` (`W SKALNEJ PIECZARZE`) | Zabierany przez `THORINA`; broń potrzebna do zabicia `CZARNEGO PAJĄKA` (`$31`) |
| `$15` | `ŚNIADANIE` | W ekwipunku `ELRONDA` (`$03`) | Prowiant (`ZJEDZ ŚNIADANIE`) |
| `$16` | `OKRĄGŁE DRZWI` | `$01` ↔ `$02` | Drzwi między Bag End a Pustkowiem |
| `$17` | `WIELKI KLUCZ` | W ekwipunku `STAREGO TROLLA` (`$0A`) | Otwiera `KAMIENNE DRZWI` (`$18`) |
| `$18` | `KAMIENNE DRZWI` | `$04` ↔ `$05` | Prowadzą do Skalnej Pieczary; wymagają `WIELKIEGO KLUCZA` (`$17`) |
| `$19` | `ZŁOTY KLUCZ` | `$10` (`W GÓRACH MGLISTYCH`) | Otwiera `OKUTE DRZWI` (`$24`) i `DREWNIANE DRZWI` (`$25`) w lochach elfów |
| `$1A` | `KAMIENNE WROTA` | `$1A` ↔ `$12` | Wyjście z labiryntu goblinów; wymagają `ZŁOTEGO PIERŚCIENIA` (`$11`) |
| `$1B` | `CZARNE JEZIORO` | `$20` → `$24` | Wejście powoduje utonięcie |
| `$1C` | `CZARNE JEZIORO` | `$23` → `$24` | Wejście powoduje utonięcie |
| `$1D` | `OKNO` | `$13` ↔ `$14` | W lochu goblinów; otwierane przez `THORINA` |
| `$1E` | `CZARNE JEZIORO` | `$22` → `$24` | Wejście powoduje utonięcie |
| `$1F` | `CZARNE JEZIORO` | `$21` → `$24` | Wejście powoduje utonięcie |
| `$20` | `BRAMA` | `$25` ↔ `$26` | Prowadzi na podwórze pod domem Beorna |
| `$21` | `DREWNIANE DRZWI` | `$26` ↔ `$27` | Drzwi do domu Beorna (musi je otworzyć sam Beorn) |
| `$22` | `ŁÓDKA` | `$2C` ↔ `$2E` | Przeprawa przez Czarną Rzekę (widoczna i poruszana dzięki `ZŁOTEMU PIERŚCIENIOWI`) |
| `$23` | `ŁÓDKA` | `$35` ↔ `$37` | Przeprawa przez Wielką Rzekę |
| `$24` | `OKUTE DRZWI` | `$38` ↔ `$3A` | Drzwi celi gracza w lochu Króla Elfów; otwierane `ZŁOTYM KLUCZEM` (`$19`) |
| `$25` | `DREWNIANE DRZWI` | `$39` ↔ `$3A` | Drzwi celi Thorina w lochu Króla Elfów |
| `$26` | `DREWNIANA KLAPA` | `$3B` ↔ `$3C` | Klapa w podłodze pałacowej piwnicy |
| `$27` | `OTWARTA BECZKA` | `$3B` → `$37` | Pozwala uciec z piwnicy elfów rzeką na brzeg `$37` |
| `$28` | `ZAMKNIĘTE BECZKI` | `$3B` (`W PAŁACOWEJ PIWNICY`) | Dekoracja w piwnicy |
| `$29` | `UKRYTE PRZEJŚCIE` | `$40` ↔ `$4C` | Ujawniane przez `BARDA`; łączy Miasto nad Jeziorem z Przystanią |
| `$2A` | `PAŁACOWA BRAMA` | `$4A` ↔ `$4B` | Prowadzi do Pałacu w Mieście nad Jeziorem |
| `$2B` | `TRATWA` | `$4C` ↔ `$4F` | Przeprawa przez Długie Jezioro między Przystanią a Kamienistą Plażą |
| `$2C` | `GŁÓWNE WEJŚCIE` | `$4F` ↔ `$52` | Wejście z Kamienistej Plaży do Jaskini Smoka |
| `$2D` | `PRZEJŚCIE` | `$51` ↔ `$52` | Górne przejście między Ciasną Pieczarą a Jaskinią Smoka |
| `$2E` | `OTWÓR` | `$50` ↔ `$51` | Przejście ze Skalnej Półki do Ciasnej Pieczary |
| `$2F` | `JEZIORO` | `$4C` → `$4D` | Wejście bez tratwy powoduje utonięcie |
| `$30` | `JEZIORO` | `$4E` ↔ `$4F` | Wejście bez tratwy powoduje utonięcie |
| `$31` | `CZARNY PAJĄK` | `$33` (`NA LEŚNEJ POLANIE`) | Wróg; do pokonania przez Thorina bronią `$14` (`WIELKI TOPÓR`) |
| `$32` | `OKUTA SKRZYNIA` | `$52` (`W JASKINI SMOKA`) | Zawiera `KRYSZTAŁOWĄ KULĘ` (`$33`) |
| `$33` | `KRYSZTAŁOWA KULA` | W skrzyni `$32` (lokacja `$52`) | Klejnot Durina (Arcyklejnot); należy zanieść go `GANDALFOWI` w lokacji `$01` |
| `$34` | `SUSZONE MIĘSO` | W ekwipunku `BEORNA` (`$04`) | Prowiant (`ZJEDZ MIĘSO`) |
| `$35` | `CHLEB` | `$38` (`W LOCHU KRÓLA ELFÓW`) | Prowiant (`ZJEDZ CHLEB`) |
