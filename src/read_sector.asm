[BITS 16]

read_sector:
  mov ah, 0x02    ; Function: Read Sector(s)

; TODO: Need to be dinamic
  mov al, 0x01    ; Number of sectors
  int 0x13

  jc .fail
  ret

.fail:
  mov si, read_error_msg
  call print_string

.hang
  hlt
  jmp .hang

; TODO: it should be different for each Drive
read_error_msg db "Disk Read Error", 0
