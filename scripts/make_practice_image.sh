#!/usr/bin/env bash
set -euo pipefail
mkdir -p evidence cases
IMG="evidence/disk.img"

echo "[*] Creating 100MB EXT4 image at $IMG"
dd if=/dev/zero of="$IMG" bs=1M count=100 status=progress
mkfs.ext4 -F "$IMG"

echo "[*] Mounting loopback (requires sudo)"
sudo mkdir -p /mnt/practice
sudo mount -o loop,rw "$IMG" /mnt/practice

echo "[*] Writing then deleting a file (flag.txt)"
echo "secret" | sudo tee /mnt/practice/flag.txt >/dev/null
sync
sudo rm /mnt/practice/flag.txt
sync

echo "[*] Unmounting"
sudo umount /mnt/practice
echo "[*] Done. Now try tsk_recover and foremost."
