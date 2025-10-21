#!/usr/bin/env bash
set -euo pipefail

# Simple E01 conversion using ewf-tools in a minimal container
# This avoids the big build by using a pre-built ewf-tools image

IMG="evidence/disk.img"
E01="evidence/disk.E01"

if [[ ! -f "$IMG" ]]; then
    echo "[!] Error: $IMG not found. Run make_practice_image_simple.sh first."
    exit 1
fi

echo "[*] Converting $IMG to E01 format"
echo "[*] This may take a few minutes..."

# Use a lightweight pre-built container with just ewf-tools
docker run --rm \
    -v "$(pwd)/evidence:/evidence" \
    --platform linux/amd64 \
    debian:stable-slim \
    sh -c "
        apt-get update -qq && 
        apt-get install -y ewf-tools && 
        cd /evidence &&
        echo 'disk.img' | ewfacquire -c case -e evidence -E examiner -M logical disk.img &&
        apt-get clean && rm -rf /var/lib/apt/lists/*
    "

echo "[✓] E01 conversion completed: $E01"
echo "[*] E01 size: $(ls -lh "$E01" 2>/dev/null | awk '{print $5}' || echo 'conversion failed')"