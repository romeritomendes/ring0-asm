[BITS 16]

read_sector:
  mov ah, 0x02
  mov al, 0x01
  int 0x13

  jc .fail
  ret
.fail:
  mov si, read_error_msg
  call print_string

read_error_msg db "Disk Read Error", 0
