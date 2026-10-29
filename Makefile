.PHONY: all build docker-build simu lint rebuild clean

IMAGE_NAME = qemu-vnc-bootloader
SRC        = ./src/boot.asm
BIN_DIR    = ./bin
BIN        = $(BIN_DIR)/boot
FLOPPY     = $(BIN_DIR)/diskette
SECTOR2    = $(BIN_DIR)/sector2.txt

all: build docker-build

$(BIN): $(SRC)
	@mkdir -p $(BIN_DIR)
	nasm $(SRC) -o $(BIN)
	dd if=/dev/zero of=$(FLOPPY) bs=1474560 count=1 conv=notrunc
	dd if=$(BIN) of=$(FLOPPY) bs=512 count=1 conv=notrunc
	dd if=$(SECTOR2) of=$(FLOPPY) bs=512 count=1 conv=notrunc seek=1

build: $(BIN)

lint:
	@echo "===> [LINT] Checking Assembly sintax using NASM..."
	nasm -w+orphan-labels -w+number-overflow -E $(SRC) > /dev/null
	@echo "✓ Sintax checked."

rebuild: clean build

docker-build:
	docker build -t $(IMAGE_NAME) .

simu: build docker-build
	docker run --rm -it \
		-p 5900:5900 \
		-p 6080:6080 \
		-v $(PWD)/$(FLOPPY):/app/bootloader.bin \
		$(IMAGE_NAME)

clean:
	rm -rf $(BIN_DIR)
