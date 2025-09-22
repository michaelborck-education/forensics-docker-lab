# Setup Guide

## Prerequisites
- Docker & Docker Compose (v2+)
- Linux/macOS/WSL2 (sudo for Lab 1 mount)
- Basic CLI knowledge (bash, git)

## Quick Repo Setup
1. Clone: `git clone <repo-url> && cd forensics-docker-lab`
2. Install: `docker compose build dfir` (builds toolbox; ~5min)
3. Create dirs: `mkdir -p evidence cases rules`
4. Add evidence (see STORYLINE.md/Lab READMEs):
   - Run `bash scripts/make_practice_image.sh` (sudo needed) for disk.img.
   - Download/copy memory.ram, network.cap, mail.mbox, logs/ (or use dummies).
5. Baseline hashes: `docker compose run --rm hashlog` (logs to cases/chain_of_custody.csv)
6. Start services: `docker compose up -d dfir plaso vol3 yara novnc autopsy` (optional GUI).

## Test Run
- Lab 1: `docker compose run --rm dfir fls -r /evidence/disk.img` (lists files).
- Verify: No errors; evidence/ owned by user (PUID/PGID in .env).

## Troubleshooting
See TROUBLESHOOTING.md.

For full labs, follow per-lab READMEs. Run `git pull` for updates.
