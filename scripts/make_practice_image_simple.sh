#!/usr/bin/env bash
set -euo pipefail

# Simple cross-platform script - works on Mac, Windows, and Linux
# Creates a practice image using native tools only

mkdir -p evidence cases
IMG="evidence/disk.img"

echo "[*] Creating 100MB disk image at $IMG"
dd if=/dev/zero of="$IMG" bs=1M count=100 status=progress

echo "[*] Creating filesystem (using FAT32 for maximum compatibility)"
# FAT32 works on all platforms without additional tools
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    DEVICE=$(hdiutil attach -nomount $IMG | grep "/dev/disk" | head -1 | awk '{print $1}')
    diskutil erasevolume FAT32 "PRACTICE" $DEVICE
    hdiutil detach $DEVICE
else
    # Linux
    mkfs.vfat -F 32 "$IMG"
fi

echo "[*] Creating temporary mount point"
mkdir -p /tmp/practice_mount

echo "[*] Mounting the image"
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    DEVICE=$(hdiutil attach -nomount $IMG | grep "/dev/disk" | head -1 | awk '{print $1}')
    mount -t msdos "$DEVICE" /tmp/practice_mount
else
    # Linux
    sudo mount -o loop "$IMG" /tmp/practice_mount
fi

echo "[*] Creating realistic Cloudcore investigation scenario"

# Create directory structure
mkdir -p /tmp/practice_mount/home/alex/Documents
mkdir -p /tmp/practice_mount/home/alex/Downloads  
mkdir -p /tmp/practice_mount/tmp
mkdir -p /tmp/practice_mount/var/log

# Create the main flag file
cat > /tmp/practice_mount/flag.txt << 'EOF'
FLAG{deleted_file_recovery_success_2024}
Congratulations! You've successfully recovered this deleted file.
This demonstrates proper file carving and undeletion techniques.
EOF

# Create project secrets file
cat > /tmp/practice_mount/home/alex/Documents/project_secrets.txt << 'EOF'
Project Cloudcore - Confidential Source Code
This file contains proprietary algorithms and client data.
DO NOT DISTRIBUTE - Internal Use Only

Client: MegaCorp Inc.
Project: Cloud Migration System
Status: In Development
Last Modified: December 2009

// Sample source code
function encryptData(data) {
    var key = 'cloudcore_secret_2009';
    return AES.encrypt(data, key);
}

// Database credentials (TEMPORARY)
db_host = '192.168.1.100'
db_user = 'alex_doe'
db_pass = 'TempPass_2009!'
EOF

# Create email draft
cat > /tmp/practice_mount/tmp/email_draft.txt << 'EOF'
To: sarah.connor@cloudcore.com
Subject: Project Security Concern

Hi Sarah,

I'm concerned about the security of our Cloudcore project. The database
credentials I'm using are temporary and should be changed before we go
live. Also, I've noticed some unusual network activity from the development
server.

Can we schedule a security review next week?

Best regards,
Alex Doe
Software Engineer
Cloudcore Systems
EOF

# Create system logs with USB activity
cat > /tmp/practice_mount/var/log/system.log << 'EOF'
Dec 15 09:15:32 cloudcore-server kernel: USB device connected: SanDisk USB 3.0
Dec 15 09:16:01 cloudcore-server kernel: USB mass storage detected
Dec 15 09:16:45 cloudcore-server login: alex_doe logged in from 192.168.1.105
Dec 15 09:17:22 cloudcore-server sudo: alex_doe : TTY=pts/0 ; PWD=/home/alex_doe ; USER=root ; COMMAND=/bin/mv /home/alex/Documents/project_secrets.txt /tmp/
Dec 15 09:18:03 cloudcore-server sudo: alex_doe : TTY=pts/0 ; PWD=/home/alex_doe ; USER=root ; COMMAND=/bin/rm -f /home/alex/Documents/project_secrets.txt
Dec 15 09:19:15 cloudcore-server sudo: alex_doe : TTY=pts/0 ; PWD=/home/alex_doe ; USER=root ; COMMAND=/bin/mv /tmp/email_draft.txt /tmp/
Dec 15 09:19:45 cloudcore-server sudo: alex_doe : TTY=pts/0 ; PWD=/home/alex_doe ; USER=root ; COMMAND=/bin/rm -f /tmp/email_draft.txt
Dec 15 09:20:12 cloudcore-server sudo: alex_doe : TTY=pts/0 ; PWD=/home/alex_doe ; USER=root ; COMMAND=/bin/mv /flag.txt /tmp/
Dec 15 09:20:33 cloudcore-server sudo: alex_doe : TTY=pts/0 ; PWD=/home/alex_doe ; USER=root ; COMMAND=/bin/rm -f /tmp/flag.txt
Dec 15 09:21:00 cloudcore-server kernel: USB device disconnected: SanDisk USB 3.0
EOF

echo "[*] Simulating file deletion (moving files to 'deleted' state)"
# Move files to simulate deletion
mv /tmp/practice_mount/flag.txt /tmp/practice_mount/tmp/flag_backup.txt
mv /tmp/practice_mount/home/alex/Documents/project_secrets.txt /tmp/practice_mount/tmp/project_secrets_backup.txt

# Actually delete them (but they'll still be recoverable)
rm -f /tmp/practice_mount/tmp/flag_backup.txt
rm -f /tmp/practice_mount/tmp/project_secrets_backup.txt  
rm -f /tmp/practice_mount/tmp/email_draft.txt

echo "[*] Unmounting and cleaning up"
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    DEVICE=$(mount | grep practice_mount | awk '{print $1}')
    hdiutil detach "$DEVICE" || true
else
    # Linux
    sudo umount /tmp/practice_mount
fi

rmdir /tmp/practice_mount

echo "[✓] Practice image created successfully at $IMG"
echo "[*] Image size: $(ls -lh "$IMG" | awk '{print $5}')"
echo ""
echo "[*] Files to recover:"
echo "    - flag.txt (contains the flag)"
echo "    - home/alex/Documents/project_secrets.txt (case evidence)"
echo "    - tmp/email_draft.txt (incriminating evidence)"
echo ""
echo "[*] Test with: docker compose run --rm dfir fls -r /evidence/disk.img"
echo "[*] Or use: foremost -v -t all -i $IMG -o cases/output"