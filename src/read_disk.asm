[BITS 16]


read_from_boot_drive:
  mov dl, [BOOT_DRIVE]
; TODO: Need to be dinamic
  mov ch, 0x00    ; Cylinder 0
  mov cl, 0x02    ; Sector 2
  mov dh, 0x00    ; Head 0
; TODO: Need to be dinamic
  mov al, 0x01    ; Number of sectors
  call read_sector
  ret

read_from_floppy:
  mov dl, 0x00    ; Drive 0x00 (Floppy)

; TODO: Need to be dinamic
  mov ch, 0x00    ; Cylinder 0
  mov cl, 0x02    ; Sector 2
  mov dh, 0x00    ; Head 0
; TODO: Need to be dinamic
  mov al, 0x01    ; Number of sectors
  call read_sector
  ret

read_from_harddisk:
  mov dl, 0x80    ; Drive 0x80 (Hard disk)

; TODO: Need to be dinamic
  mov ch, 0x00    ; Cylinder 0
  mov cl, 0x02    ; Sector 2
  mov dh, 0x00    ; Head 0
; TODO: Need to be dinamic
  mov al, 0x01    ; Number of sectors
  call read_sector
  ret

