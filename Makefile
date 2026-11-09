MADS ?= $(shell which mads 2>/dev/null || ([ -x $(HOME)/bin/mads ] && echo $(HOME)/bin/mads) || echo mads)
BUILD_DIR = build
SRC_DIR = src

C64_TARGET = $(BUILD_DIR)/hobbit.prg
ATARI_TARGET = $(BUILD_DIR)/hobbit.xex
ATARI_ATR = $(BUILD_DIR)/hobbit.atr

.PHONY: all c64 atari check clean

all: c64 atari

c64: $(C64_TARGET)

atari: $(ATARI_TARGET) $(ATARI_ATR)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(C64_TARGET): $(SRC_DIR)/hobbit.asm $(SRC_DIR)/c64.inc | $(BUILD_DIR)
	$(MADS) $(SRC_DIR)/hobbit.asm -i:$(SRC_DIR) -o:$@

$(ATARI_TARGET): $(SRC_DIR)/hobbit.asm $(SRC_DIR)/atari.inc | $(BUILD_DIR)
	$(MADS) $(SRC_DIR)/hobbit.asm -d:TARGET_ATARI=1 -i:$(SRC_DIR) -o:$@

$(ATARI_ATR): $(ATARI_TARGET) tools/mk_atr.py | $(BUILD_DIR)
	python3 tools/mk_atr.py $(ATARI_TARGET) $@

check: $(C64_TARGET) $(ATARI_TARGET) $(ATARI_ATR)
	md5sum -c checksum.md5

clean:
	rm -rf $(BUILD_DIR)
