# Windows Setup and Troubleshooting Guide

## Common Issues and Solutions

### Issue: "exec /usr/local/bin/entrypoint.sh: no such file or directory"

**Cause:** Windows Git checkout converted Unix line endings (LF) to Windows line endings (CRLF), breaking the script.

**Solution 1: Fix Line Endings and Rebuild (PowerShell - Works on All Windows)**

```powershell
# Open PowerShell in the project folder:
cd C:\path\to\forensics-docker-lab

# Run the fix script:
.\scripts\fix-line-endings.ps1

# Rebuild the Docker image (no cache):
docker compose build --no-cache dfir

# Try again:
docker compose run --rm -it dfir
```

**Alternative (If you have Git Bash or WSL):**

```bash
bash scripts/fix-line-endings.sh
docker compose build --no-cache dfir
docker compose run --rm -it dfir
```

**Solution 2: Re-clone with Correct Settings**

```bash
# Configure Git to NOT convert line endings:
git config --global core.autocrlf false

# Re-clone the repository:
cd ..
rm -rf forensics-docker-lab
git clone https://github.com/yourorg/forensics-docker-lab.git
cd forensics-docker-lab

# Build:
docker compose build dfir
```

**Solution 3: Manual Fix**

```bash
# In Git Bash:
sed -i 's/\r$//' images/dfir-cli/entrypoint.sh
sed -i 's/\r$//' images/dfir-cli/Dockerfile

# Rebuild:
docker compose build dfir
```

**Prevent Future Issues:**

The repository now includes `.gitattributes` to force Unix line endings for shell scripts. Make sure you pull the latest version.

---

### Issue: `docker compose run --rm -it dfir` Hangs or No Prompt

This is a common issue on Windows with certain terminals. Try these solutions:

---

## Solution 1: Use PowerShell (Recommended)

**PowerShell** works best with Docker on Windows:

```powershell
# Open PowerShell (not PowerShell ISE)
# Navigate to your project folder
cd C:\path\to\forensics-docker-lab

# Run with -it flag
docker compose run --rm -it dfir
```

**Expected result:** You should see the banner and get a prompt.

---

## Solution 2: Use `winpty` with Git Bash

If you're using **Git Bash**, you need `winpty`:

```bash
# In Git Bash:
winpty docker compose run --rm -it dfir
```

**Why?** Git Bash on Windows doesn't properly handle TTY allocation without `winpty`.

**Install winpty:**
- Usually included with Git for Windows
- If missing: `pacman -S winpty` (in Git Bash)

---

## Solution 3: Use WSL2 (Best Option)

**WSL2 (Windows Subsystem for Linux)** provides the best Docker experience on Windows:

### Setup WSL2:

1. **Install WSL2:**
   ```powershell
   # In PowerShell (Admin):
   wsl --install
   ```

2. **Install Docker Desktop with WSL2 backend:**
   - Download: https://www.docker.com/products/docker-desktop
   - Enable "Use WSL 2 based engine" in Docker Desktop settings

3. **Run commands in WSL:**
   ```bash
   # Open WSL (Ubuntu):
   wsl

   # Navigate to project:
   cd /mnt/c/path/to/forensics-docker-lab

   # Works perfectly:
   docker compose run --rm -it dfir
   ```

---

## Solution 4: Use CMD (Command Prompt)

Try Windows **CMD** (not PowerShell):

```cmd
REM Navigate to project folder
cd C:\path\to\forensics-docker-lab

REM Run command
docker compose run --rm -it dfir
```

---

## Solution 5: Check Docker Desktop Settings

1. Open **Docker Desktop**
2. Go to **Settings** → **General**
3. Ensure these are enabled:
   - ✅ "Use the WSL 2 based engine"
   - ✅ "Expose daemon on tcp://localhost:2375 without TLS" (optional)

4. Go to **Settings** → **Resources** → **WSL Integration**
5. Enable integration with your WSL distributions

6. Restart Docker Desktop

---

## Solution 6: Alternative - Run Commands One at a Time

If interactive mode won't work, use one-off commands:

```powershell
# Instead of entering the workstation, run commands directly:
docker compose run --rm dfir fls -r /evidence/disk.img

docker compose run --rm dfir tsk_recover -a /evidence/disk.img /cases/Lab_1/recovered

docker compose run --rm dfir grep -i "password" /cases/Lab_1/*.txt
```

**Downside:** No banner, more typing, but it works.

---

## Platform-Specific Quick Reference

### PowerShell ✅ (Best Native Option)
```powershell
docker compose run --rm -it dfir
```

### Git Bash ⚠️ (Needs winpty)
```bash
winpty docker compose run --rm -it dfir
```

### WSL2 ✅ (Best Overall)
```bash
docker compose run --rm -it dfir
```

### CMD ⚠️ (May Work)
```cmd
docker compose run --rm -it dfir
```

---

## Diagnosing the Issue

### Test 1: Check Docker is Running
```powershell
docker --version
docker compose version
```

**Expected:** Version numbers displayed.

### Test 2: Check Container Image Exists
```powershell
docker images | findstr forensic
```

**Expected:** You should see `forensic/dfir-cli`.

### Test 3: Test Non-Interactive Command
```powershell
docker compose run --rm dfir pwd
```

**Expected:** Should print `/cases` after banner.

### Test 4: Test Interactive Without Docker Compose
```powershell
docker run --rm -it forensic/dfir-cli:latest
```

**Expected:** Should show banner and prompt.

If Test 4 works but docker compose doesn't, there's an issue with your `docker-compose.yml`.

---

## Common Error Messages

### Error: "the input device is not a TTY"

**Solution:** Use `winpty` in Git Bash:
```bash
winpty docker compose run --rm -it dfir
```

### Error: "Cannot connect to Docker daemon"

**Solution:** Start Docker Desktop and wait for it to fully initialize (icon turns green).

### Error: "permission denied"

**Solution:** Run PowerShell/CMD as Administrator, or add your user to the `docker-users` group:
1. Open "Computer Management"
2. Go to "Local Users and Groups" → "Groups"
3. Double-click "docker-users"
4. Add your user account
5. Log out and log back in

### Error: "No such file or directory" for evidence

**Solution:** Ensure evidence files are in the right location:
```powershell
# Check evidence exists:
dir evidence

# Should show: disk.img, memory.raw, network.cap, etc.
```

---

## Creating a Windows Alias (PowerShell)

Add to your PowerShell profile:

```powershell
# Edit profile:
notepad $PROFILE

# Add this line:
function forensics { docker compose run --rm -it dfir }

# Save and reload:
. $PROFILE

# Now just run:
forensics
```

---

## Creating a Windows Alias (Git Bash)

Add to `~/.bashrc`:

```bash
# Edit bashrc:
nano ~/.bashrc

# Add this line:
alias forensics='winpty docker compose run --rm -it dfir'

# Save and reload:
source ~/.bashrc

# Now just run:
forensics
```

---

## File Path Issues on Windows

Windows uses backslashes (`\`), but Docker uses forward slashes (`/`).

### Mounting Evidence from Windows Path:

Your `docker-compose.yml` should have:
```yaml
volumes:
  - ./evidence:/evidence:ro  # ✅ Relative paths work
  - ./cases:/cases           # ✅ Relative paths work
```

**Not:**
```yaml
volumes:
  - C:\Users\You\forensics-docker-lab\evidence:/evidence  # ❌ Won't work
```

### Always Use Relative Paths:
```powershell
# Navigate to project folder first:
cd C:\path\to\forensics-docker-lab

# Then run (uses relative paths from docker-compose.yml):
docker compose run --rm -it dfir
```

---

## Performance Tips for Windows

### 1. Use WSL2 for Better Performance
WSL2 is **significantly faster** than native Windows for Docker.

### 2. Store Project in WSL Filesystem
```bash
# Instead of /mnt/c/Users/... (slow)
# Use /home/username/... (fast)

# In WSL:
cd ~
git clone https://github.com/yourorg/forensics-docker-lab.git
cd forensics-docker-lab
docker compose run --rm -it dfir
```

### 3. Allocate More Resources to Docker Desktop
1. Open Docker Desktop → Settings → Resources
2. Increase:
   - **CPUs:** At least 4
   - **Memory:** At least 8GB
   - **Disk:** At least 60GB

---

## Verification Checklist

- [ ] Docker Desktop installed and running
- [ ] WSL2 enabled (if using WSL)
- [ ] Navigated to project folder: `cd path\to\forensics-docker-lab`
- [ ] Evidence files in `evidence/` folder
- [ ] Built image: `docker compose build dfir`
- [ ] Using correct terminal (PowerShell or WSL)
- [ ] Using `-it` flag: `docker compose run --rm -it dfir`
- [ ] If Git Bash, using: `winpty docker compose run --rm -it dfir`

---

## Still Not Working?

### Collect Diagnostic Info:

```powershell
# Run these and share output:
docker --version
docker compose version
docker ps -a
docker images | findstr forensic
wsl --version
$PSVersionTable.PSVersion
```

### Check Docker Logs:
1. Open Docker Desktop
2. Click the "Troubleshoot" icon (bug)
3. View logs for errors

### Try Minimal Test:
```powershell
# Test with simple alpine container:
docker run --rm -it alpine sh

# If this works but dfir doesn't, there's an issue with the forensic image.
```

---

## Recommended Setup for Windows Students

**Best Option:** PowerShell + WSL2

1. **Install WSL2:** `wsl --install`
2. **Install Docker Desktop** with WSL2 backend
3. **Clone repo in WSL:**
   ```bash
   wsl
   cd ~
   git clone <repo-url>
   cd forensics-docker-lab
   ```
4. **Run from WSL:**
   ```bash
   docker compose run --rm -it dfir
   ```

**Alternative:** PowerShell (Native)
```powershell
cd C:\path\to\forensics-docker-lab
docker compose run --rm -it dfir
```

---

## Summary

| Terminal | Command | Works? |
|----------|---------|--------|
| **PowerShell** | `docker compose run --rm -it dfir` | ✅ Usually |
| **Git Bash** | `winpty docker compose run --rm -it dfir` | ✅ With winpty |
| **WSL2** | `docker compose run --rm -it dfir` | ✅ Best option |
| **CMD** | `docker compose run --rm -it dfir` | ⚠️ Sometimes |

**Recommendation:** Use **WSL2** for best experience, or **PowerShell** for native Windows.
