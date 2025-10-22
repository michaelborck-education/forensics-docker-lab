#!/usr/bin/env bash
set -euo pipefail
mkdir -p evidence cases
IMG="evidence/usb.img"

echo "[*] Creating 100MB EXT4 image at $IMG"
dd if=/dev/zero of="$IMG" bs=1M count=100 status=progress
mkfs.ext4 -F "$IMG"

echo "[*] Mounting loopback (requires sudo)"
sudo mkdir -p /mnt/practice
sudo mount -o loop,rw "$IMG" /mnt/practice

echo "[*] Creating realistic Cloudcore investigation scenario"

# Create directory structure matching the storyline
sudo mkdir -p /mnt/practice/home/alex/Documents /mnt/practice/home/alex/Downloads /mnt/practice/tmp
sudo mkdir -p /mnt/practice/var/log

# Create realistic files that would be in the case
echo "Project Cloudcore - Confidential Source Code
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
" | sudo tee /mnt/practice/home/alex/Documents/project_secrets.txt >/dev/null

# Create a more substantial file (the zip file mentioned in storyline)
echo "Creating project_secrets.zip..."
cd /mnt/practice/home/alex/Documents
sudo zip -r project_secrets.zip project_secrets.txt >/dev/null 2>&1
sudo rm project_secrets.txt

# Create some log entries with realistic timestamps
echo "Dec  5 14:30:01 workstation kernel: USB device connected" | sudo tee -a /mnt/practice/var/log/syslog
echo "Dec  5 14:31:15 workstation sudo: alex_doe : TTY=pts/0 ; PWD=/home/alex ; USER=root ; COMMAND=/bin/mount /dev/sdb1 /mnt/usb" | sudo tee -a /mnt/practice/var/log/auth.log
echo "Dec  5 14:32:22 workstation cp: copied '/home/alex/Documents/project_secrets.zip' to '/mnt/usb/'" | sudo tee -a /mnt/practice/var/log/syslog

# Create the flag.txt file (for original lab exercise)
echo "FLAG{digital_forensics_cloudcore_case_2009}" | sudo tee /mnt/practice/flag.txt >/dev/null

# Create some additional files to make it more realistic
echo "Email to exfil@personal.com
Subject: Project Update
Attached: project_secrets.zip
Contents: Sensitive code - exfiltrated" | sudo tee /mnt/practice/tmp/email_draft.txt >/dev/null

echo "TrueCrypt Volume Configuration
Volume Type: Hidden
Size: 50MB
Encryption: AES-256
Created: 2009-12-05
Purpose: Secure data transfer" | sudo tee /mnt/practice/tmp/truecrypt_config.txt >/dev/null

sync
sleep 2

echo "[*] Simulating file deletion (evidence staging)"
# Delete the files to simulate hiding evidence
sudo rm /mnt/practice/flag.txt
sudo rm /mnt/practice/tmp/email_draft.txt
sudo rm /mnt/practice/tmp/truecrypt_config.txt
sudo rm /mnt/practice/home/alex/Documents/project_secrets.zip

sync
sleep 2

echo "[*] Unmounting"
sudo umount /mnt/practice

echo "[*] Practice image created successfully!"
echo "[*] Evidence includes:"
echo "    - Deleted flag.txt (for recovery exercise)"
echo "    - Deleted project_secrets.zip (case evidence)"
echo "    - Deleted email drafts and TrueCrypt config"
echo "    - System logs with USB activity"
echo "[*] Use tsk_recover and foremost to find deleted files"