#!/usr/bin/env bash
set -euo pipefail

# Container-based E01 conversion - works on Mac, Windows, and Linux
# Converts disk.img to E01 format using Docker

IMG="evidence/disk.img"
E01="evidence/disk.e01"

if [ ! -f "$IMG" ]; then
    echo "[!] Error: $IMG not found. Run make_practice_image_container.sh first."
    exit 1
fi

echo "[*] Converting $IMG to E01 format using Docker..."
echo "[*] This creates an industry-standard E01 evidence file"

# Use the dfir container to convert to E01 format
docker compose run --rm dfir bash -c "
echo '[*] Converting /evidence/disk.img to /evidence/disk.e01...'
ewfexport -c -t 'Cloudcore Investigation - Lab 1 Practice Image' -e 'Digital Forensics Training' -o /evidence/disk.e01 /evidence/disk.img

echo '[*] Conversion complete!'
echo '[*] Created: /evidence/disk.e01'
echo '[*] You can now use either disk.img or disk.e01 for analysis'

# Show file sizes for comparison
echo ''
echo '[*] File size comparison:'
ls -lh /evidence/disk.img /evidence/disk.e01

echo ''
echo '[*] To verify E01 file integrity:'
echo '    ewfverify /evidence/disk.e01'
echo ''
echo '[*] To use E01 in Sleuth Kit:'
echo '    fls -f ewf -r -m / /evidence/disk.e01'
echo '    tsk_recover -f ewf -a /evidence/disk.e01 /path/to/recovery'
"