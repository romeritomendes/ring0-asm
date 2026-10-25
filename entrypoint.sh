#!/usr/bin/env bash
set -e

BOOT_IMG="${1:-/app/bootloader.bin}"

if [ ! -f "$BOOT_IMG" ]; then
  echo "[ERROR] :: bootloader not found! Please review on $BOOT_IMG"
  echo "[ERROR - PROPOSED SOLUTION] :: Mount the volume with: -v \$(pwd)/bin/boot.bin:/app/bootloader.bin"
  exit 1
fi

ln -sf /usr/share/novnc/vnc.html /usr/share/novnc/index.html

echo "===> Websocket starting and brigde the no VNC (Port 6080 -> 5900)..."
websockify --web /usr/share/novnc 6080 localhost:5900 >/dev/null 2>&1 &

echo "===> QMEU starting in VNC mode (Port 5900)..."
echo "===> Loading image from $BOOT_IMG"

exec qemu-system-i386 \
  -drive format=raw,file="$BOOT_IMG" \
  -vnc 0.0.0.0:0 \
  -m 64M
