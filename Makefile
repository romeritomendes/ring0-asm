.PHONY: all build docker-build simu lint rebuild clean

IMAGE_NAME = qemu-vnc-bootloader
SRC        = ./src/boot.asm
BIN_DIR    = ./bin
BIN        = $(BIN_DIR)/boot

all: build docker-build

$(BIN): $(SRC)
	@mkdir -p $(BIN_DIR)
	nasm $(SRC) -o $(BIN)

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
		-v $(PWD)/$(BIN):/app/bootloader.bin \
		$(IMAGE_NAME)

clean:
	rm -rf $(BIN_DIR)
