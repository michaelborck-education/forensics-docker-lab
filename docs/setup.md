# Setup Guide

## Prerequisites
- Docker & Docker Compose (v2+)
- Linux/macOS/WSL2 (sudo for Lab 1 mount)
- Basic CLI knowledge (bash, git)

## Quick Repo Setup
1. Clone: `git clone <repo-url> && cd forensics-docker-lab`
2. Build forensic workstation: `docker compose build dfir` (builds toolbox; ~5min)
3. Create dirs: `mkdir -p evidence cases rules`
4. Add evidence (see STORYLINE.md/Lab READMEs):
   - Run `bash scripts/make_practice_image.sh` (sudo needed) for usb.img.
   - Download/copy memory.raw, network.cap, mail.mbox, logs/ (or use dummies).
5. Baseline hashes: `docker compose run --rm hashlog` (logs to cases/chain_of_custody.csv)

## Interactive Workstation Usage (Recommended)

The forensic environment is designed to feel like logging into a dedicated forensic workstation:

```bash
# Enter the forensic workstation
docker compose run --rm -it dfir
```

You'll see a banner with available tools and get an interactive bash prompt:
```
  ________________________________________________________________
 /                                                                \
|   DIGITAL FORENSICS & INCIDENT RESPONSE LABORATORY              |
|   Cloudcore 2009 Data Exfiltration Investigation               |
 \________________________________________________________________/

  🔍 Tools Installed:
    • Sleuth Kit (fls, icat, fsstat, tsk_recover, mmls, blkls)
    • Volatility 3 (vol -f /evidence/memory.raw ...)
    ...

analyst@forensics-lab:/cases$
```

**Inside the workstation**, you can run commands directly:
```bash
# List files in disk image
fls -r /evidence/usb.img

# Recover deleted files
tsk_recover -a /evidence/usb.img USB_Imaging/recovered/

# Search for patterns
grep -i "password" USB_Imaging/*.txt

# Exit when done
exit
```

**Benefits:**
- Less typing (no `docker compose run --rm dfir` prefix)
- Tab completion works
- Command history persists (saved to cases/.bash_history)
- More immersive learning experience

## Alternative: One-Off Commands

You can still run individual commands without entering the workstation:
```bash
docker compose run --rm dfir fls -r /evidence/usb.img
```

## Test Run
```bash
# Enter the workstation
docker compose run --rm -it dfir

# Inside, test tools:
fls -r /evidence/usb.img
vol --help
yara --version

# Exit
exit
```

Verify: No errors; evidence/ owned by user (PUID/PGID in .env).

## Optional Services
- **Autopsy GUI**: `docker compose up -d novnc autopsy` → http://localhost:8080/vnc.html
- **Plaso/Volatility**: Run as needed (see lab READMEs)

## Troubleshooting
See TROUBLESHOOTING.md.

For full labs, follow per-lab READMEs. Run `git pull` for updates.
