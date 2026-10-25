# ring0-asm

## Prerequisites

- [Docker](https://www.docker.com/)
- [NASM](https://www.nasm.us/)

## Environment Setup & Execution

1. **Build Docker Image**

```bash
  docker build -t qemu-vnc-bootloader .
```

2. **_Compile the assembly_**

```bash
  nasm ./src/boot.asm -o ./bin/boot.bin
```

3. **_Execute_**

```bash
  docker run --rm -it \
    -p 5900:5900 -p 6080:6080 \
    -v $(pwd)/bin/boot.bin:/app/bootloader.bin \
    qemu-vnc-bootloader
```

4. Open browser with address <http://localhost:6080>
