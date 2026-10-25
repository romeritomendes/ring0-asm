ORG 0x7C00

BITS 16

jmp 0x0000:start

start:
  xor ax, ax
  mov ds, ax
  mov es, ax
  mov ss, ax
  mov sp, 0x7C00

  mov si, message
  call print_string

  jmp $

print_char:
  mov [es:di], al
  mov [es:di + 1], 0x0A

  add di, 2
  
  ret

print_string:
  mov ax, 0xB800
  mov es, ax
  mov di, 0x0000
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
