[BITS 16]

[ORG 0x7C00]

jmp 0x0000:start

start:
  xor ax, ax
  mov ds, ax
  mov es, ax
  mov ss, ax
  mov sp, 0x7C00

  mov si, message
  call print_string

  mov ax, 0x0000
  mov es, ax      ; Memory segment 0x0000
  mov bx, 0x0500  ; Memory offset 0x0500

  mov dl, 0x00    ; Drive 0 (Floppy) - Drive 1 (Hard disk)
  mov ch, 0x00    ; Cylinder 0
  mov cl, 0x02    ; Sector 2
  mov dh, 0x00    ; Head 0
  call read_sector

  mov si, 0x0500
  call print_string

  jmp $

message db "Reading sector 2...", 0

%include "src/vga_print.asm"
%include "src/floppy_read.asm"

times 510 - ($ - $$) db 0x00

dw 0xAA55
