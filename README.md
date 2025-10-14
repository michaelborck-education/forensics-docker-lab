# Forensic Analysis Lab (Docker)

A reproducible **forensic analysis** environment that uses containers **to analyse evidence** (not to run malware).
It includes CLI tools (Sleuth Kit, ewf-tools, TestDisk/PhotoRec, Foremost, YARA, Volatility 3), Plaso, and an **optional** Autopsy GUI via noVNC.

Features an **immersive interactive forensic workstation** that simulates working in a real forensic lab environment.

## Quick start

### Interactive Workstation (Recommended)

```bash
# 1) Setup directories
mkdir -p evidence cases rules

# 2) Build the forensic workstation
docker compose build dfir

# 3) Enter the interactive forensic workstation
docker compose run --rm -it dfir

# You'll see a banner and get an analyst prompt:
# analyst@forensics-lab:/cases$

# Inside the workstation, run commands directly:
fls -r /evidence/disk.img
tsk_recover -a /evidence/disk.img Lab_1/recovered/
grep -i "password" Lab_1/*.txt

# Exit when done
exit
```

See [docs/INTERACTIVE_WORKSTATION.md](docs/INTERACTIVE_WORKSTATION.md) for detailed guide.

### One-Off Commands (Alternative)

```bash
# Record chain-of-custody hashes
docker compose run --rm hashlog

# Use tools with one-off commands
# Plaso super-timeline from an image:
docker compose run --rm plaso log2timeline.py /cases/timeline.plaso /evidence/disk.img

# View timeline contents:
docker compose run --rm plaso psort.py -o l2tcsv /cases/timeline.plaso > cases/timeline.csv

# Sleuth Kit file listing:
docker compose run --rm dfir fls -r -m / /evidence/disk.img > cases/fls.txt

# Carve with Foremost:
docker compose run --rm dfir foremost -i /evidence/disk.img -o /cases/foremost_out

# TestDisk/PhotoRec (interactive TUI):
docker compose run --rm -it dfir photorec

# Volatility 3 (Windows example):
docker compose run --rm vol3 vol -f /evidence/memory.raw windows.pslist.PsList

# YARA scan recursively with your rules:
docker compose run --rm yara yara -r /rules ./evidence > cases/yara_hits.txt
```

### Optional: Autopsy GUI in your browser
```bash
docker compose up -d novnc autopsy
# If Autopsy doesn't auto-launch, start it:
docker compose exec autopsy autopsy &
# Open http://localhost:8080/vnc.html
```
Evidence (`./evidence`) is **mounted read-only** into every container. All outputs go to `./cases`.

## Create safe practice evidence
Create a tiny EXT4 image and delete a file for carving practice:
```bash
dd if=/dev/zero of=evidence/disk.img bs=1M count=100
mkfs.ext4 -F evidence/disk.img
# Mount loopback (Linux host), add a file, then delete it
sudo mkdir -p /mnt/practice && sudo mount -o loop,rw evidence/disk.img /mnt/practice
echo "secret" | sudo tee /mnt/practice/flag.txt
sync && sudo rm /mnt/practice/flag.txt && sync
sudo umount /mnt/practice
# Recover with TSK/Foremost
docker compose run --rm dfir tsk_recover -a /evidence/disk.img /cases/tsk_recover_out
docker compose run --rm dfir foremost -i /evidence/disk.img -o /cases/foremost_out
```

## Chain of custody
Append SHA-256 hashes of all evidence files to `cases/chain_of_custody.csv`:
```bash
COC_NOTE="drive seized 2025-08-28, initial intake" docker compose run --rm hashlog
```

## Notes & images
- **Plaso** official image: `log2timeline/plaso`  
- **Volatility 3** container: `sk4la/volatility3`  
- **Autopsy** (community images vary): `bannsec/autopsy` + `theasp/novnc`  
- **CLI toolbox** is built locally with Debian packages for Sleuth Kit, ewf-tools, TestDisk/PhotoRec, Foremost, bulk_extractor, YARA, exiftool, hashdeep, and Python Volatility3.

Everything runs as your user (`PUID/PGID` in `.env`) so outputs in `cases/` are owned by you.
