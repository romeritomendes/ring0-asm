.PHONY: all build docker-build simu lint rebuild clean

IMAGE_NAME = qemu-vnc-bootloader
SRC_DIR    = $(PWD)/src
BIN_DIR    = $(PWD)/bin

# Sources
SRC        = $(SRC_DIR)/boot.asm
SECTOR2    = $(SRC_DIR)/sector2.txt

ASM_SRCS = $(wildcard $(SRC_DIR)/*.asm)

# Created Artefacts
BIN        = $(BIN_DIR)/boot
FLOPPY     = $(BIN_DIR)/diskette
DOCKER_STAMP = $(BIN_DIR)/.docker-built

all: build docker-build

$(BIN): $(ASM_SRCS)
	@mkdir -p $(BIN_DIR)
	@echo "===> [BUILD] Compiling Assembly using NASM..."
	nasm $(SRC) -o $(BIN)

$(FLOPPY): $(BIN) $(SECTOR2)
	@echo "===> [BUILD] Creating floppy disk: $(FLOPPY)..."
	dd if=/dev/zero of=$(FLOPPY) bs=1474560 count=1 conv=notrunc
	@echo "===> [BUILD] Copping bootloader $(BIN) to sector 1 (512 Bytes)..."
	dd if=$(BIN) of=$(FLOPPY) bs=512 count=1 conv=notrunc
	@echo "===> [BUILD] Copping $(SECTOR2) to sector 2 (512 Bytes)..."
	dd if=$(SECTOR2) of=$(FLOPPY) bs=512 count=1 conv=notrunc seek=1

build: $(FLOPPY)

lint:
	@echo "===> [LINT] Checking Assembly sintax using NASM..."
	nasm -w+orphan-labels -w+number-overflow -E $(SRC) > /dev/null
	@echo "✓ Sintax checked."

rebuild: clean build

$(DOCKER_STAMP): Dockerfile entrypoint.sh
	@mkdir -p $(BIN_DIR)
	@echo "===> [DOCKER] Creating Image Docker..."
	docker build -t $(IMAGE_NAME) .
	@touch $(DOCKER_STAMP)

docker-build: $(DOCKER_STAMP)

simu: build docker-build
	docker run --rm -it \
		-p 5900:5900 \
		-p 6080:6080 \
		-v $(FLOPPY):/app/bootloader.bin \
		$(IMAGE_NAME)

clean:
	rm -rf $(BIN_DIR)
