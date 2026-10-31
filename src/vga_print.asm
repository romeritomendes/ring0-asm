[BITS 16]

VGA_BUFFER  equ 0xB800
VGA_WIDTH   equ 80
VGA_HEIGHT  equ 60
; BLANK_CELL  equ 0x0F20  ; 0x0F (White/Black) + ASCII 0x20 (' ')

BYTES_PER_LINE  equ 160
COLOR_ATTR      equ 0x0A

; section .data
  ; cursor_y dd 0

print_char:
  mov [es:di], ax
  add di, 2
  ret

print_string:
  ; mov ax, [cursor_y]
  ; imul dx, ax, BYTES_PER_LINE
  ; add dx, VGA_BUFFER
  ; mov es, dx
  mov ax, VGA_BUFFER
  mov es, ax
  ; mov di, [cursor_y]
  mov ah, COLOR_ATTR

.print_loop:
  lodsb
  cmp al, 0
  je .newline

  call print_char
  jmp .print_loop

.newline:
  ; inc dword [cursor_y]
  ; di = ((di / 160) + 1) * 160
  mov ax, di
  mov cx, BYTES_PER_LINE
  xor dx, dx
  div cx                  ; AX / CX => AX
  inc ax                  ; AX + 1 => AX
  mul cx                  ; AX * CX => AX
  mov di, ax

.done:
  ret
