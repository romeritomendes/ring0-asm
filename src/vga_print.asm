[BITS 16]

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
