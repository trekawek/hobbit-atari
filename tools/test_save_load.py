#!/usr/bin/env python3
"""Execute the assembled Atari save/load routines with a simulated CIO device.

Requires MADS and py65 (``python3 -m pip install py65``). This verifies the game
and adapter's 6502 code, including DOS memory swaps; CIO itself is mocked, so it
does not replace testing with an Atari OS and real disk/cassette handlers.
"""

import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

try:
    from py65.devices.mpu6502 import MPU
except ImportError:
    raise SystemExit("Install the test dependency with: python3 -m pip install py65")


ROOT = Path(__file__).resolve().parents[1]
OBJECT_BYTES = 53 * 8 + 1
SAVE_BYTES = 13 + 1 + OBJECT_BYTES
RETURN_PC = 0x0200


def assemble(directory):
    mads = os.environ.get("MADS") or shutil.which("mads")
    if not mads:
        fallback = Path.home() / "bin/mads"
        mads = str(fallback) if fallback.is_file() else "mads"
    executable = Path(directory) / "hobbit.xex"
    labels = Path(directory) / "hobbit.lab"
    subprocess.run(
        [mads, str(ROOT / "src/hobbit.asm"), "-d:TARGET_ATARI=1",
         f"-i:{ROOT / 'src'}", f"-o:{executable}", f"-t:{labels}"],
        check=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True,
    )
    symbols = {}
    for line in labels.read_text().splitlines():
        fields = line.split()
        if len(fields) == 3 and fields[0] == "00":
            symbols[fields[2].rsplit(".", 1)[-1].lower()] = int(fields[1], 16)
    memory = [0] * 65536
    data = executable.read_bytes()
    offset = 0
    while offset < len(data):
        start = int.from_bytes(data[offset:offset + 2], "little")
        offset += 2
        if start == 0xffff:
            continue
        end = int.from_bytes(data[offset:offset + 2], "little")
        offset += 2
        size = end - start + 1
        memory[start:end + 1] = data[offset:offset + size]
        offset += size
    return memory, symbols


class Game:
    def __init__(self, image, symbols, device):
        self.memory = image.copy()
        self.symbols = symbols
        self.cpu = MPU(memory=self.memory)
        self.device = device
        self.media = None
        self.failure = None
        self.calls = []
        self.messages = []
        self.opened = False
        # Run the real relocation/bootstrap and object-table initialization.
        self.cpu.pc = self.address("atari_boot_entry")
        self.run({self.address("main_entry")})
        self.cpu.pc = self.address("init_new_game")
        self.run({self.address("room_loop")})
        self.low_ram = bytes(self.memory[0x0800:0x2000])
        self.dos_ram = bytes(self.memory[0x7000:0x8800])

    def address(self, name):
        return self.symbols[name]

    def word(self, address):
        return self.memory[address] + 256 * self.memory[address + 1]

    def rts(self):
        self.cpu.pc = (self.cpu.stPopWord() + 1) & 0xffff

    def cio(self):
        mem, cpu = self.memory, self.cpu
        command = mem[0x0352]
        buffer = self.word(0x0354)
        length = self.word(0x0358)
        self.calls.append(command)
        if self.device == "disk":
            assert mem[self.address("dos_is_banked")] == 1
            assert bytes(mem[0x0800:0x2000]) == self.dos_ram
        else:
            assert mem[self.address("dos_is_banked")] == 0
        status = 1
        if command == 3:
            end = mem.index(0x9b, buffer)
            filename = bytes(mem[buffer:end])
            assert filename == (b"D:HOBBIDATA" if self.device == "disk" else b"C:")
            if self.failure == "open":
                status = 170  # File not found.
            else:
                self.opened = True
        elif command == 7:
            assert self.opened and length == SAVE_BYTES
            data = self.media or b""
            if self.failure == "read":
                data = data[:19]
            mem[buffer:buffer + min(length, len(data))] = data[:length]
            if len(data) < length:
                status = 136  # End of file before the requested count.
        elif command == 11:
            assert self.opened and length == SAVE_BYTES
            if self.failure == "write":
                status = 144  # Device error.
            else:
                self.media = bytes(mem[buffer:buffer + length])
        elif command == 12:
            if self.opened and self.failure == "close":
                status = 144
            self.opened = False
        else:
            raise AssertionError(f"Unexpected CIO command: {command}")
        mem[0x0353] = status
        cpu.a = 0x5a  # CIO does not preserve the accumulator.
        cpu.y = status
        cpu.p = (cpu.p & ~(cpu.NEGATIVE | cpu.ZERO)) | (status & cpu.NEGATIVE)
        self.rts()

    def run(self, stops):
        for _ in range(500000):
            if self.cpu.pc in stops:
                return self.cpu.pc
            if self.cpu.pc == self.address("atari_ciov"):
                self.cio()
            elif self.cpu.pc == self.address("print_string"):
                self.messages.append(self.cpu.x + 256 * self.cpu.y)
                self.cpu.step()
            elif self.cpu.pc == self.address("atari_getin"):
                self.cpu.a = ord("D" if self.device == "disk" else "T")
                self.rts()
            else:
                self.cpu.step()
        raise AssertionError(f"6502 routine did not finish; PC=${self.cpu.pc:04x}")

    def call(self, name):
        self.cpu.stPushWord(RETURN_PC - 1)
        self.cpu.pc = self.address(name)
        retry = self.symbols.get("restore_prompt", self.address("main_entry") + 6)
        return self.run({RETURN_PC, retry})

    def state(self):
        header = self.address("turn_wait_cnt")
        objects = self.word(self.address("obj_table_ptr"))
        return (bytes(self.memory[header:header + 13])
                + bytes([self.memory[self.address("current_room")]])
                + bytes(self.memory[objects:objects + OBJECT_BYTES]))

    def change_state(self):
        header = self.address("turn_wait_cnt")
        self.memory[header:header + 13] = [i * 7 + 3 for i in range(13)]
        self.memory[self.address("current_room")] = 42
        objects = self.word(self.address("obj_table_ptr"))
        # Move the first and last objects and change inventory/container flags.
        self.memory[objects + 3] = 0xff
        self.memory[objects + 6] = 0x44
        self.memory[objects + 52 * 8 + 3] = 42

    def assert_clean(self, case):
        case.assertEqual(self.cpu.sp, 0xff, "stack was not restored")
        case.assertFalse(self.opened, "IOCB was left open")
        case.assertEqual(self.memory[self.address("dos_is_banked")], 0)
        case.assertEqual(self.memory[self.address("io_channel")], 0)
        case.assertEqual(bytes(self.memory[0x0800:0x2000]), self.low_ram)
        case.assertEqual(bytes(self.memory[0x7000:0x8800]), self.dos_ram)


class SaveLoadTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.directory = tempfile.TemporaryDirectory(prefix="hobbit-save-test-")
        cls.addClassCleanup(cls.directory.cleanup)
        cls.image, cls.symbols = assemble(cls.directory.name)

    def game(self, device):
        return Game(self.image, self.symbols, device)

    def test_round_trip(self):
        for device in ("tape", "disk"):
            with self.subTest(device=device):
                saved = self.game(device)
                saved.change_state()
                expected = saved.state()
                self.assertEqual(saved.call("save_game"), RETURN_PC)
                self.assertEqual(saved.media, expected)
                self.assertEqual(saved.media[-1], 0xfe)
                saved.assert_clean(self)
                # Load into a fresh boot, avoiding dependence on cached state.
                restored = self.game(device)
                restored.media = saved.media
                self.assertNotEqual(restored.state(), expected)
                self.assertEqual(restored.call("load_game"), RETURN_PC)
                self.assertEqual(restored.state(), expected)
                restored.assert_clean(self)

    def test_failed_load_preserves_state_and_releases_device(self):
        for device in ("tape", "disk"):
            for failure in ("open", "read", "truncated", "sentinel"):
                with self.subTest(device=device, failure=failure):
                    game = self.game(device)
                    game.change_state()
                    before = game.state()
                    game.media = before
                    game.failure = failure
                    if failure == "truncated":
                        game.media = game.media[:-1]
                    if failure == "sentinel":
                        game.media = game.media[:-1] + b"\x00"
                    # A previous successful operation must not mask new failure.
                    game.memory[game.address("save_ram_valid")] = 1
                    buffer = game.address("save_ram_buf")
                    game.memory[buffer:buffer + SAVE_BYTES] = before
                    self.assertNotEqual(game.call("load_game"), RETURN_PC)
                    self.assertEqual(game.state(), before)
                    self.assertIn(game.address("msg_read_err"), game.messages)
                    game.assert_clean(self)

    def test_write_errors_are_reported_and_release_device(self):
        for device in ("tape", "disk"):
            for failure in ("open", "write", "close"):
                with self.subTest(device=device, failure=failure):
                    game = self.game(device)
                    game.failure = failure
                    self.assertEqual(game.call("save_game"), RETURN_PC)
                    self.assertIn(game.address("msg_write_err"), game.messages)
                    game.assert_clean(self)


if __name__ == "__main__":
    unittest.main(verbosity=2)
