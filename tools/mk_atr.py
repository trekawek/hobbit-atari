#!/usr/bin/env python3
"""Build a bootable Atari DOS 2.5 floppy image (.atr) with AUTORUN.SYS."""

import os
import struct
import sys


def build_atr(xex_path: str, atr_path: str, dos_dir: str) -> None:
    with open(os.path.join(dos_dir, "boot.bin"), "rb") as f:
        boot_bin = bytearray(f.read())
    with open(os.path.join(dos_dir, "dos.sys"), "rb") as f:
        dos_sys = f.read()
    with open(os.path.join(dos_dir, "dup.sys"), "rb") as f:
        dup_sys = f.read()
    with open(xex_path, "rb") as f:
        autorun_sys = f.read()

    # Standard 90 KB Single Density (720 sectors * 128 bytes)
    num_sectors = 720
    sec_size = 128
    disk = bytearray(num_sectors * sec_size)

    # Free sector bitmap (True = free, False = allocated)
    free_map = [True] * num_sectors
    free_map[0] = False  # Sector 0 does not exist
    for s in range(1, 4):
        free_map[s] = False  # Boot sectors 1..3
    for s in range(360, 369):
        free_map[s] = False  # VTOC (360) + Directory (361..368)

    next_Candidate = 4

    def alloc_sector() -> int:
        nonlocal next_Candidate
        while next_Candidate < 720:
            s = next_Candidate
            next_Candidate += 1
            if free_map[s]:
                free_map[s] = False
                return s
        raise RuntimeError("Disk full while building .atr image")

    dir_entries = []

    def add_file(name8: str, ext3: str, payload: bytes) -> int:
        file_no = len(dir_entries)
        chunks = [payload[i : i + 125] for i in range(0, len(payload), 125)]
        sectors = [alloc_sector() for _ in chunks]
        for idx, chunk in enumerate(chunks):
            sec_no = sectors[idx]
            nxt = sectors[idx + 1] if idx + 1 < len(sectors) else 0
            off = (sec_no - 1) * sec_size
            disk[off : off + len(chunk)] = chunk
            disk[off + 125] = ((file_no & 0x3F) << 2) | ((nxt >> 8) & 0x03)
            disk[off + 126] = nxt & 0xFF
            disk[off + 127] = len(chunk)
        entry = struct.pack(
            "<BHH8s3s",
            0x42,
            len(sectors),
            sectors[0],
            name8.ljust(8).encode("ascii"),
            ext3.ljust(3).encode("ascii"),
        )
        dir_entries.append(entry)
        return sectors[0]

    dos_start = add_file("DOS", "SYS", dos_sys)
    add_file("DUP", "SYS", dup_sys)
    add_file("AUTORUN", "SYS", autorun_sys)

    # Place boot sectors 1..3 with DOS.SYS starting sector at $070F-$0710
    boot_bin[0x0F] = dos_start & 0xFF
    boot_bin[0x10] = (dos_start >> 8) & 0xFF
    disk[0 : 3 * sec_size] = boot_bin

    # Write Directory at sectors 361..368
    dir_base = (361 - 1) * sec_size
    for idx, entry in enumerate(dir_entries):
        disk[dir_base + idx * 16 : dir_base + (idx + 1) * 16] = entry

    # Write VTOC at sector 360
    vtoc_off = (360 - 1) * sec_size
    free_count = sum(1 for s in range(1, 720) if free_map[s])
    disk[vtoc_off + 0] = 0x02  # DOS 2.0 / 2.5 signature
    struct.pack_into("<H", disk, vtoc_off + 1, 707)
    struct.pack_into("<H", disk, vtoc_off + 3, free_count)
    for s in range(720):
        if free_map[s]:
            disk[vtoc_off + 10 + (s >> 3)] |= 1 << (7 - (s & 7))

    # 16-byte ATR header ($0296 magic, paragraphs = 720*128/16 = $1680, sec_size = 128)
    paragraphs = (num_sectors * sec_size) // 16
    atr_header = struct.pack("<HHHHII", 0x0296, paragraphs, sec_size, 0, 0, 0)

    os.makedirs(os.path.dirname(os.path.abspath(atr_path)), exist_ok=True)
    with open(atr_path, "wb") as f:
        f.write(atr_header)
        f.write(disk)


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <input.xex> <output.atr>", file=sys.stderr)
        sys.exit(1)
    script_dir = os.path.dirname(os.path.abspath(__file__))
    build_atr(sys.argv[1], sys.argv[2], os.path.join(script_dir, "dos25"))
