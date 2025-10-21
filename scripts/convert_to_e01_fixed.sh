#!/usr/bin/env bash
set -euo pipefail

# Fixed E01 conversion using ewfacquire with correct syntax
# This script works on Mac, Windows, and Linux via Docker

IMG="evidence/disk.img"
E01="evidence/disk.e01"

if [[ ! -f "$IMG" ]]; then
    echo "[!] Error: $IMG not found. Run make_practice_image_simple.sh first."
    exit 1
fi

echo "[*] Converting $IMG to E01 format using ewfacquire..."
echo "[*] This creates an industry-standard E01 evidence file"

# Use ewfacquire with proper syntax
# The -u flag enables unattended mode to avoid interactive prompts
docker compose run --rm dfir bash -c "
    echo 'Creating E01 from raw image...'
    ewfacquire -u \
        -d 'Cloudcore Investigation - Lab 1 Practice Image' \
        -e 'Digital Forensics Training' \
        -t '$E01' \
        '$IMG'
"

if [[ -f "$E01" ]]; then
    echo "[✓] E01 conversion completed: $E01"
    echo "[*] Original image size: $(ls -lh "$IMG" | awk '{print $5}')"
    echo "[*] E01 file size: $(ls -lh "$E01" | awk '{print $5}')"
    
    echo ""
    echo "[*] To verify E01 file integrity:"
    echo "    docker compose run --rm dfir ewfverify $E01"
    echo ""
    echo "[*] To use E01 in Sleuth Kit:"
    echo "    docker compose run --rm dfir fls -f ewf -r $E01"
else
    echo "[!] Error: E01 conversion failed - no output file created"
    echo "[*] Trying alternative approach..."
    
    # Fallback: Try basic ewfacquire
    docker compose run --rm dfir bash -c "
        cd /evidence
        ewfacquire -u disk.img
    "
    
    # Check if any .e01 files were created
    E01_FILES=(evidence/*.e01)
    if [[ -f "${E01_FILES[0]}" ]]; then
        echo "[✓] E01 created with default naming: ${E01_FILES[0]}"
        mv "${E01_FILES[0]}" "$E01"
    else
        echo "[!] E01 conversion failed completely"
        exit 1
    fi
fi