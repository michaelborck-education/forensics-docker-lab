# Scripts Directory - Organization & Usage

## 📍 Overview

This directory contains utility scripts for the Forensics Docker Lab. They're organized into three categories:

```
scripts/
├── forensics-workstation      ← START HERE (bash/Linux/Mac)
├── forensics-workstation.bat  ← START HERE (PowerShell/Windows)
├── coc-log                     ← Use inside forensic workstation
├── verify_setup.sh             ← Run once to verify setup
└── instructor/                 ← Instructor-only tools
```

---

## 👨‍🎓 For Students

### Primary Entry Point

**On macOS/Linux/Windows WSL:**
```bash
./scripts/forensics-workstation
```

**On Windows PowerShell:**
```powershell
.\scripts\forensics-workstation.bat
```

Both scripts:
- Prompt for your analyst name
- Check Docker is running
- Verify evidence files exist
- Display the forensic lab banner
- Connect you to the DFIR workstation

### Inside the Workstation

Once connected, use the chain of custody logging tool:

```bash
analyst@forensics-lab:/cases$ coc-log "your command" "description"
```

This automatically:
- Records timestamp and analyst name
- Executes your command
- Hashes the output
- Saves output files
- Logs to analysis_log.csv

### Initial Lab Verification

Before starting, verify your setup is correct:

```bash
./scripts/verify_setup.sh
```

This checks:
- Docker is installed and running
- Directory structure is correct
- Evidence files are accessible
- Forensic tools are available
- New features (forensics-workstation, coc-log) are ready

---
1. **Image Creation (varies by platform)**
   - `scripts/instructor/make_practice_image_container.sh` - Cross-platform (recommended)

2. **E01 Conversion**
   - `scripts/instructor/convert_to_e01_container.sh` - Docker-based (cross-platform)
   - `scripts/hashlog.py` - Generate hash logs for chain of custody
   - `scripts/instructor/shift_time.sh` - Adjust timestamps on evidence

### Creating/Updating Evidence Images

```bash
# Full workflow (assuming you're on instructor branch)
cd /path/to/forensics-docker-lab

# Create raw disk image with forensic evidence
./scripts/instructor/make_practice_image_container.sh

# Convert to E01 format
./scripts/instructor/convert_to_e01_container.sh

# Generate hash logs
python3 scripts/instructor/hashlog.py evidence/ evidence/hashes.csv SHA256
```

### Distributing to Students

1. Evidence files should be distributed separately (OneDrive/cloud)
2. Students download and place in `evidence/` folder
3. They should NOT clone instructor branch
4. Main branch is automatically used by default

---

## 🔧 Script Details

### forensics-workstation (bash)

**Usage:**
```bash
./scripts/forensics-workstation [analyst_name]
./scripts/forensics-workstation "Alice Johnson"
```

**Features:**
- Analyst name prompt (optional parameter)
- Docker availability check
- Evidence file verification
- Connection/disconnection messages
- Case menu selection (optional)

**Environment:**
- Requires: Docker and Docker Compose
- Runs on: macOS, Linux, Windows WSL

### forensics-workstation.bat (PowerShell)

**Usage:**
```powershell
.\scripts\forensics-workstation.bat
.\scripts\forensics-workstation.bat -AnalystName "Alice Johnson"
.\scripts\forensics-workstation.bat -Help
```

**Features:**
- Same functionality as bash version
- Native Windows PowerShell (no WSL needed)
- Colored output on PowerShell 7+
- Handles Windows path conventions

**Requirements:**
- PowerShell 5.0+ (Windows 10/11 built-in)
- Docker Desktop for Windows
- WSL 2 backend configured

### coc-log (bash)

**Usage (inside container):**
```bash
coc-log "command to run" "description of action"
coc-log "fls -r /evidence/usb.img" "Initial filesystem listing"
```

**Features:**
- Automatic timestamp (UTC ISO 8601)
- Analyst name from environment
- Command execution with output capture
- SHA256 hashing of output
- CSV logging to analysis_log.csv
- Individual output file preservation
- Exit code tracking

**Output:**
- CSV entry in: `/cases/[CaseName]/analysis_log.csv`
- Output files in: `/cases/[CaseName]/outputs/`

### verify_setup.sh (bash)

**Usage:**
```bash
./scripts/verify_setup.sh
```

**Checks:**
1. Docker installation and version
2. Docker daemon running
3. Directory structure
4. Documentation files
5. Docker image build
6. Container startup
7. Forensic tools availability
8. Volume mounts
9. New features (forensics-workstation, coc-log)

**Output:** Pass/fail summary with remediation hints

---

## 🐛 Troubleshooting

### "forensics-workstation: command not found"
- Make sure you're in the project root directory
- Check permissions: `chmod +x scripts/forensics-workstation`
- Verify file exists: `ls -la scripts/forensics-workstation`

### PowerShell error "cannot be loaded because running scripts is disabled"
```powershell
# Enable script execution (one-time setup)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### "coc-log: command not found"
- Only available INSIDE the forensic workstation
- Make sure you ran `./scripts/forensics-workstation` first
- Verify Docker image was rebuilt with: `docker compose build dfir`

### Docker image won't build
- Check Docker Desktop is running
- Clear cache: `docker compose build --no-cache dfir`
- Review error messages carefully (may be network issue)

---

## 🔄 For Script Maintenance

### Adding New Scripts

1. **Student-facing:** Keep in `scripts/` root directory
2. **Instructor-only:** Place in `scripts/instructor/`
4. **Always:** Include usage comments at top

