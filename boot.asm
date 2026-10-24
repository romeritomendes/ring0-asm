ORG 0x7C00

BITS 16

start:
  xor ax, ax
  mov ds, ax
  mov es, ax

  mov si, message
  call print_string

  jmp $

print_char:
  mov ah, 0x0E
  mov bh, 0x00
  mov bl, 0x07
  int 0x10
  
  ret

print_string:

.print_loop:
  lodsb
  cmp al, 0
  je .done

  call print_char
  jmp .print_loop

.done:
  ret

message db "Hello world!", 0

times 510 - ($ - $$) db 0x00

dw 0xAA55
