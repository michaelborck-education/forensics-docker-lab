# Week 7: USB Evidence Triage Lab
## Forensics & Incident Response Course

---

## 🎯 Lab Overview

This is a hands-on digital forensics lab where you will conduct a real-world style investigation of a suspected data exfiltration incident at Cloudcore Inc. You'll use professional forensic tools in a containerized environment to analyze a USB device, recover deleted files, and produce a professional triage report.

**Case:** CLOUDCORE-2024-INS-001 - USB Evidence Triage
**Environment:** Docker-based forensic workstation
**Tools:** Sleuth Kit, libewf-tools (E01 handling), standard UNIX utilities

---

## 📦 What's in This Package?

```
forensics-lab-week1-dfir/
├── README.md                    ← You are here (quick start guide)
├── SCENARIO.md                  ← Complete case background and context
├── BACKGROUND.md                ← Quick reference summary
├── ASSIGNMENT.md                ← Detailed assignment tasks and rubric
├── COMMANDS.md                  ← Forensic commands quick reference
│
├── verify_setup.sh              ← Setup verification (macOS/Linux)
├── verify_setup.ps1             ← Setup verification (Windows PowerShell)
│
├── Dockerfile                   ← Forensic container definition
├── docker-compose.yml           ← Container orchestration
├── banner.txt                   ← Welcome banner for lab environment
├── entrypoint.sh                ← Container startup script
│
├── evidence/                    ← READ-ONLY evidence files
│   ├── cloudcore_suspect_usb.E01   (or usb.img - forensic image)
│   └── README.md
│
├── cases/                       ← YOUR WORKSPACE (writable)
│   └── README.txt               ← Output directory info
│
├── guides/                      ← Interactive guides (HTML)
│   ├── worksheet.html           ← Lab walkthrough
│   ├── chain-custody-guide.html ← CoC form helper
│   └── forensic-image-primer.html
│
└── templates/                   ← Student templates
    └── WORKBOOK.md              ← Report template
```

---

## 🚀 Quick Start (10 Minutes)

### Step 1: Prerequisites

**Install Docker Desktop:**
- **Windows/Mac:** Download from https://www.docker.com/products/docker-desktop
- **Linux (Ubuntu/Debian):**
  ```bash
  sudo apt update
  sudo apt install docker.io docker-compose
  sudo usermod -aG docker $USER
  # Log out and back in for group changes to take effect
  ```

**Verify Installation:**
```bash
docker --version
docker compose version
```

**System Requirements:**
- 4GB RAM minimum (8GB recommended if using Autopsy GUI)
- 10GB free disk space
- Internet connection (first build only)

### Step 2: Build the Forensic Environment

```bash
# Navigate to this directory in terminal/command prompt
cd /path/to/forensics-lab-week1-dfir

# Build the container (first time: ~2-5 minutes depending on connection)
docker compose build

# Verify build succeeded
docker compose run --rm dfir echo "Environment ready!"
```

You should see the forensic lab banner appear!

### Step 3: Verify Your Setup (Recommended)

**Windows users (PowerShell):**
```powershell
.\verify_setup.ps1
```

**macOS/Linux users (or Windows WSL):**
```bash
./verify_setup.sh
```

This will check that everything is configured correctly. All checks should pass (✓ in green).

If you skip this step, continue to Step 4 below.

### Step 4: Start Your Investigation - Immersive Workstation

**The Modern Way - Immersive Workstation Login:**
```bash
# Enter the forensic workstation with analyst identification
./scripts/forensics-workstation

# You'll be prompted for your analyst name (for case documentation)
# Then you're inside the forensic workstation
```

You'll see the forensic lab banner, then you're inside the workstation:
```
  ╔═════════════════════════════════════════════════════════════════╗
  ║                                                                 ║
  ║     DIGITAL FORENSICS & INCIDENT RESPONSE LABORATORY           ║
  ║                                                                 ║
  ║           Cyber Security Investigation Environment             ║
  ║                                                                 ║
  ╚═════════════════════════════════════════════════════════════════╝

alice@forensics-lab:/cases$
```

**Now run forensic commands directly:**
```bash
# Verify evidence integrity
analyst@forensics-lab:/cases$ ewfverify /evidence/usb.E01

# Mount evidence
analyst@forensics-lab:/cases$ mkdir -p /tmp/ewf
analyst@forensics-lab:/cases$ ewfmount /evidence/usb.E01 /tmp/ewf

# List files
analyst@forensics-lab:/cases$ fls -r -d /tmp/ewf/ewf1

# Log commands for chain of custody
analyst@forensics-lab:/cases$ coc-log "fls -r /evidence/usb.img" "Initial USB filesystem listing"

# When done, exit the workstation
analyst@forensics-lab:/cases$ exit
```

**Benefits of the immersive approach:**
- ✅ **Immersive forensic lab experience** - feels like connecting to a real DFIR workstation
- ✅ **Analyst identification** - your name is used in chain of custody logs
- ✅ **Less typing** - no `docker compose` prefix on every command
- ✅ **Real-world workflow** - matches industry practice of SSH-ing into dedicated forensic machines
- ✅ **Comprehensive logging** - `coc-log` automatically timestamps and hashes all commands

**For Advanced Users - Direct Docker Commands:**
If you prefer direct Docker commands (not recommended for students):
```bash
docker compose build
docker compose run --rm -it dfir bash
```

---

## 📚 How to Use This Lab

### Week 7 Lab Session (3 Hours) - Guided Practice

1. **Read the Case** (15 minutes)
   - Open `SCENARIO.md` for complete background
   - Read `BACKGROUND.md` for quick reference
   - Understand the investigation objectives

2. **Setup and Verify** (15 minutes)
   - Build Docker environment (Step 2 above)
   - Test access to evidence files
   - Familiarize yourself with the container environment

3. **Hands-On Analysis** (2 hours)
   - Open `guides/worksheet.html` in your web browser
   - Follow the guided exercises
   - Practice evidence handling, file listing, recovery
   - Work alongside instructor demonstrations

4. **Save Your Work** (30 minutes)
   - All outputs auto-save to `./cases/` directory
   - Review what you've learned
   - Note any questions for independent work phase

### Independent Work (5-7 Hours) - Complete Assignment

1. **Conduct Full Analysis**
   - Follow tasks in `ASSIGNMENT.md`
   - Use `COMMANDS.md` as your reference guide
   - Document every command you execute

2. **Write Professional Report**
   - Use `templates/WORKBOOK.md` as starting point
   - Include chain of custody, methodology, findings
   - Add screenshots and evidence
   - Write AI usage reflection

3. **Prepare Submission**
   - Organize files per `ASSIGNMENT.md` structure
   - Create submission ZIP file
   - Verify all required components included

4. **Submit to LMS**
   - Upload ZIP file
   - Due: End of Week 7

---

## 🖥️ Platform-Specific Notes

### Windows Users

**Terminal Options:**
- ✅ **Recommended:** Windows Terminal with PowerShell
- ✅ **Also works:** WSL (Ubuntu/Debian) - you have this since Docker Desktop requires it
- ⚠️ **Not Recommended:** CMD (Command Prompt) - limited features

**Which terminal should I use?**
- **PowerShell (recommended):** Easiest for most students
  - Use `.\verify_setup.ps1` for verification
  - Docker commands work the same: `docker compose run --rm dfir`
- **WSL bash:** If you're comfortable with Linux
  - Use `./verify_setup.sh` for verification
  - All commands work exactly like macOS/Linux

**Docker Desktop Settings:**
- Enable WSL 2 backend for better performance (usually default)
- Allocate at least 4GB RAM in Docker Desktop settings
- Make sure Docker Desktop is running before using commands

**Path Format:**
- Always use forward slashes `/` in Docker commands (not backslashes `\`)
- Example: `docker compose run --rm dfir` (correct)

**Common Issues:**
- If "command not found": Restart Docker Desktop and PowerShell
- If build fails: Check Windows Defender isn't blocking Docker
- If PowerShell execution policy error: Run PowerShell as Administrator and execute:
  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  ```

### macOS Users (Intel and Apple Silicon)

**Terminal:** Use built-in Terminal app or iTerm2

**Apple Silicon (M1/M2/M3) Notes:**
- Docker Desktop uses Rosetta 2 for compatibility - this is automatic
- Performance is excellent despite architecture translation
- Build may take slightly longer on first run (~5-7 minutes)

**Permissions:**
- May need to approve Docker in System Preferences → Security & Privacy
- Case folder should be writable automatically

**Common Issues:**
- If "Permission denied": Right-click Docker Desktop → Open
- If slow: Increase Docker Desktop RAM allocation in preferences

### Linux Users (Ubuntu/Debian/Fedora)

**Docker Group:**
```bash
# Add your user to docker group (one-time setup)
sudo usermod -aG docker $USER

# Log out and log back in, then verify:
groups | grep docker
```

**Permissions:**
- The `./cases/` directory should be writable by your user
- If permission errors: `chmod -R 755 cases/`

**Using `sudo`:**
- ⚠️ Avoid `sudo docker` - use docker group instead
- If you must use sudo, outputs in `./cases/` will be root-owned

**Common Issues:**
- If "Cannot connect to Docker daemon": `sudo systemctl start docker`
- If compose not found: Install `docker-compose-plugin` package

---

## 💡 Essential Commands

### Starting and Stopping

```bash
# Enter the forensic workstation (interactive session)
docker compose run --rm dfir

# Exit the workstation when done
exit

# Stop all background containers (cleanup)
docker compose down
```

### Evidence Analysis Workflow

**First, enter the forensic workstation:**
```bash
docker compose run --rm dfir
```

**Then, inside the workstation, run these commands:**
```bash

# 1. Verify evidence integrity
ewfverify /evidence/cloudcore_suspect_usb.E01
md5sum /evidence/cloudcore_suspect_usb.E01
sha256sum /evidence/cloudcore_suspect_usb.E01

# 2. Mount E01 file
mkdir -p /tmp/ewf
ewfmount /evidence/cloudcore_suspect_usb.E01 /tmp/ewf

# 3. Analyze file system
fsstat /tmp/ewf/ewf1
fls -r -d /tmp/ewf/ewf1 > /cases/file_list.txt

# 4. Recover files
mkdir -p /cases/recovered
tsk_recover /tmp/ewf/ewf1 /cases/recovered

# 5. Exit
exit
```

**📘 For complete command reference, see `COMMANDS.md`**

---

## 📁 Workspace Organization

### Evidence Directory (`./evidence/`)

- **READ-ONLY** - Never modify files here
- Contains: `cloudcore_suspect_usb.E01` (forensic image)
- Mounted inside container as `/evidence`

### Cases Directory (`./cases/`)

- **WRITABLE** - Save all your work here
- Mounted inside container as `/cases`
- Everything you create in `/cases/` inside the container appears in `./cases/` on your host machine
- This is where you'll save:
  - File listings
  - Recovered files
  - Chain of custody forms
  - Analysis notes
  - Screenshots

**Example Structure:**
```
./cases/
├── chain_of_custody.csv
├── file_list.txt
├── filesystem_timeline.csv
├── keyword_hits.txt
├── recovered/
│   ├── deleted_files/
│   └── files_of_interest/
├── screenshots/
└── triage_report.md
```

---

## 🖼️ Optional: Enabling Autopsy GUI

**By default, Autopsy GUI is disabled** to conserve resources. All lab tasks can be completed using CLI tools only.

### Should I Enable Autopsy?

**Enable Autopsy if:**
- ✅ You prefer visual/graphical interfaces over command line
- ✅ You have 8GB+ RAM available
- ✅ You want to explore GUI forensic tools
- ✅ You're comfortable with browser-based VNC interfaces

**Skip Autopsy if:**
- ❌ You have less than 8GB RAM (container may be slow)
- ❌ You prefer command-line workflows
- ❌ You want faster performance
- ✅ **Note:** CLI tools are sufficient for full marks - Autopsy is purely optional!

### How to Enable Autopsy GUI

**Step 1: Uncomment the Autopsy Service**

Edit `docker-compose.yml` and uncomment the autopsy section (lines 24-36):

```yaml
# Change FROM this (commented out):
#  autopsy:
#    build:
#      context: .

# TO this (uncommented):
  autopsy:
    build:
      context: .
```

**Step 2: Build the Autopsy Container**

```bash
docker compose build autopsy
```

⏱️ **This will take 5-10 minutes:**
- Downloads ~500MB (Ubuntu + Java + Autopsy)
- One-time setup - subsequent starts are fast

**Step 3: Start Autopsy**

```bash
docker compose up -d autopsy
```

**Step 4: Access Autopsy in Browser**

Open your web browser and navigate to:
```
http://localhost:8080/vnc.html
```

You should see the Autopsy GUI in your browser!

### Using Autopsy

**Creating a Case:**
1. Click "Create New Case"
2. Enter case name (e.g., "Cloudcore_Investigation")
3. Set case directory to `/cases/autopsy_case/`
4. Add your details as investigator

**Adding Evidence:**
1. Select "Add Data Source"
2. Choose "Disk Image or VM File"
3. Browse to `/evidence/cloudcore_suspect_usb.E01`
4. Autopsy automatically processes E01 format - no mounting needed!

**Running Analysis:**
1. Select ingest modules (Hash Lookup, Keyword Search, File Type ID)
2. Configure keyword lists if searching for specific terms
3. Start ingest and wait for processing
4. Explore results in the GUI

### Customizing Screen Resolution

**If the VNC window doesn't fit your screen:**

See the troubleshooting section below: "Autopsy window is too large/small for my screen"

**Quick fix:** Click the noVNC sidebar (left edge) → Scaling Mode → "Local Scaling"

**Permanent fix:** Edit `.env` file and change `DISPLAY_WIDTH`/`DISPLAY_HEIGHT`

### Stopping Autopsy

**To stop Autopsy when done:**
```bash
docker compose down autopsy
```

**To restart later:**
```bash
docker compose up -d autopsy
```

Your case data is preserved in `./cases/autopsy_case/` between sessions.

---

## 🔧 Troubleshooting

### "Docker command not found"

**Fix:**
- Ensure Docker Desktop is running (Windows/Mac)
- Restart terminal after installing Docker
- Linux: Check `sudo systemctl status docker`

### "Cannot connect to Docker daemon"

**Fix:**
- **Windows/Mac:** Start Docker Desktop application
- **Linux:** `sudo systemctl start docker`

### "Permission denied" on /evidence

**This is expected!**
- `/evidence` is intentionally read-only
- Save all outputs to `/cases/` instead
- ✅ Correct: `fls -r /tmp/ewf/ewf1 > /cases/output.txt`
- ❌ Wrong: `fls -r /tmp/ewf/ewf1 > /evidence/output.txt`

### "No such file: /tmp/ewf/ewf1"

**Fix:**
- You need to mount the E01 file first:
```bash
mkdir -p /tmp/ewf
ewfmount /evidence/cloudcore_suspect_usb.E01 /tmp/ewf
```

### "Build failed" or "Container won't start"

**Fix:**
1. Check Docker Desktop has enough resources (4GB RAM minimum)
2. Close other heavy applications
3. Rebuild from scratch:
   ```bash
   docker compose down -v
   docker compose build --no-cache
   ```

### "Command works in container but output isn't saved"

**Fix:**
- Ensure you're saving to `/cases/` directory
- Check the `./cases/` folder on your host machine
- Files are synchronized in real-time

### "Port 8080 already in use" (if using Autopsy)

**Fix:**
- Edit `docker-compose.yml`
- Change `8080:8080` to another port like `8081:8080`
- Or stop other services using port 8080

### "Autopsy window is too large/small for my screen" (if using Autopsy GUI)

**The VNC window doesn't fit my laptop screen:**

**Option 1: Use noVNC scaling mode (easiest)**
- Open http://localhost:8080/vnc.html
- Click the sidebar toggle (left edge of screen)
- Click "Scaling Mode: None" → Select "Remote Resizing" or "Local Scaling"
- Window will auto-scale to fit your browser

**Option 2: Change resolution permanently**
- Edit `.env` file in project root
- Modify `DISPLAY_WIDTH` and `DISPLAY_HEIGHT`
- Recommended settings:
  - **Small laptops (1366x768):** `DISPLAY_WIDTH=1280` `DISPLAY_HEIGHT=720` (default)
  - **Mid-range laptops:** `DISPLAY_WIDTH=1366` `DISPLAY_HEIGHT=768`
  - **Large screens:** `DISPLAY_WIDTH=1920` `DISPLAY_HEIGHT=1080`
- Rebuild: `docker compose build autopsy`
- Restart: `docker compose up -d autopsy`

### Getting More Help

- **Lab Session:** Ask instructor or teaching assistants
- **Office Hours:** [Insert times]
- **LMS Forum:** Post technical questions
- **Documentation:** Review `COMMANDS.md` and `SCENARIO.md`

---

## 🎓 Learning Objectives

By completing this lab, you will:

1. ✅ Understand proper digital evidence handling procedures (chain of custody, hashing)
2. ✅ Gain hands-on experience with industry-standard forensic tools (Sleuth Kit, libewf)
3. ✅ Learn to work with E01 forensic image format (Expert Witness Format)
4. ✅ Practice file system analysis and deleted file recovery
5. ✅ Develop professional forensic documentation skills
6. ✅ Critically reflect on AI tool usage in forensic investigations
7. ✅ Experience realistic incident response scenarios

---

## 📝 Next Steps

### First Time Here?

1. ✅ Read this README (you're doing it!)
2. → Read `SCENARIO.md` for the full case background
3. → Review `ASSIGNMENT.md` for detailed tasks and grading
4. → Build Docker environment (Quick Start above)
5. → Open `guides/worksheet.html` in your browser
6. → Attend Week 7 lab session

### Ready to Start?

```bash
# Build the environment
docker compose build

# Start investigating!
docker compose run --rm dfir

# Inside the container, verify evidence:
ewfverify /evidence/cloudcore_suspect_usb.E01
```

### Need a Quick Reference?

- **Commands:** See `COMMANDS.md`
- **Case Details:** See `SCENARIO.md` or `BACKGROUND.md`
- **Report Template:** See `templates/WORKBOOK.md`

---

## ⚖️ Academic Integrity Reminder

- This is an **individual assessment** - collaborate on concepts, not code or reports
- **AI tools are permitted** but must be documented in your reflection
- **Never copy-paste** AI outputs without understanding them
- **Verify all commands** before executing them
- **Your work should be reproducible** - document every step

---

## 🆘 Need Help?

**Technical Issues:**
- Check this README's Troubleshooting section
- Review error messages carefully
- Search error messages online (with "docker" + "sleuthkit")
- Post on course LMS forum with:
  - Your operating system
  - Exact error message
  - What you were trying to do
  - What you've already tried

**Forensic Concepts:**
- Review `SCENARIO.md` and `COMMANDS.md`
- Attend lab session and office hours
- Check Sleuth Kit documentation: https://sleuthkit.org
- Ask conceptual questions on LMS forum

**Assignment Questions:**
- Review `ASSIGNMENT.md` rubric
- Check example outputs in worksheet.html
- Ask instructor during lab session
- Use office hours for clarification

---

## 🔒 Important Notes

- **Never modify evidence files** - work on copies only
- **Document everything** - reproducibility is key in forensics
- **Report objectively** - present facts, not accusations
- **Test your submission ZIP** - ensure all files are included
- **Start early** - don't wait until the last day
- **Ask questions** - it's better to ask than to guess

---

**Good luck with your investigation! Remember: professionalism, documentation, and objectivity are the hallmarks of excellent forensic work.**

---

*Last updated: October 2024 | Version 2.0*
*This lab is part of a 5-week forensics series. See course materials for Labs 1-5.*
