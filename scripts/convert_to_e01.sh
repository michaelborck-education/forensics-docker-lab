#!/usr/bin/env bash
set -euo pipefail

# Script to convert disk.img to E01 format (industry standard)
# Usage: bash scripts/convert_to_e01.sh

IMG="evidence/disk.img"
E01="evidence/disk.e01"

if [ ! -f "$IMG" ]; then
    echo "[!] Error: $IMG not found. Run make_practice_image.sh first."
    exit 1
fi

echo "[*] Converting $IMG to E01 format..."
echo "[*] This creates an industry-standard E01 evidence file"

# Use ewf-tools (libewf) to convert to E01 format
# The -c flag creates compressed E01, -t adds case info
ewfexport -c -t "Cloudcore Investigation - Lab 1 Practice Image" -e "Digital Forensics Training" -o "$E01" "$IMG"

echo "[*] Conversion complete!"
echo "[*] Created: $E01"
echo "[*] You can now use either disk.img or disk.e01 for analysis"

# Show file sizes for comparison
echo ""
echo "[*] File size comparison:"
ls -lh "$IMG" "$E01"

echo ""
echo "[*] To verify E01 file integrity:"
echo "    ewfverify $E01"
echo ""
echo "[*] To use E01 in Sleuth Kit:"
echo "    fls -f ewf -r -m / $E01"
echo "    tsk_recover -f ewf -a $E01 /path/to/recovery"