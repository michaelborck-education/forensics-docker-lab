# Forensic Lab 2: Memory Forensics with Volatility 2 (Windows XP)

**Goal:** Learn to analyse a Windows XP memory image using Volatility 2 inside Docker.

**Skills:**  
- Verify integrity of memory dump (hashing, CoC).  
- Run basic Volatility plugins (pslist, pstree, netscan).  
- Extract suspicious processes and dump artifacts.  
- Document findings in a reproducible report.

---

## 🚀 Quick Start - Immersive Workstation

**Mac/Linux:** `./scripts/forensics-workstation`
**Windows:** `.\scripts\forensics-workstation.ps1`

---

## What to submit
- `cases/Memory_Forensics/vol_output/` with plugin outputs (CSV/TXT).
- `cases/Memory_Forensics/memory_report.md` - Start with: `cp templates/WORKBOOK.md cases/Memory_Forensics/memory_report.md`
- Updated `cases/chain_of_custody.csv` with memory dump hash.

---

## Evidence
The memory dump `evidence/memory.raw` (~511MB) is provided as part of the 2009 Cloudcore investigation. This is a captured memory image from a Windows XP SP2 workstation taken on October 10, 2009.

**Important:** This is a Windows XP memory image which requires Volatility 2. Volatility 3 does not support Windows XP/2000/NT systems.

**Note:** See `WALKTHROUGH.md` for detailed step-by-step guidance with expected outputs and analysis tips.

---

## Steps

### 0) Build and enter the forensic workstation
```bash
# First time only: Build the forensic container
docker compose build dfir

# Enter the interactive forensic workstation
docker compose run --rm -it dfir
```

You'll see the forensic lab banner and get a bash prompt. **Note:** For Volatility 2 commands, we use a specialized container (vol2), but most preparation work is done in the main workstation.

### 1) Create output directory and hash the memory dump
**Inside the workstation:**
```bash
mkdir -p Memory_Forensics/vol_output
exit
```

**On your host:**
```bash
COC_NOTE="Lab2 memory intake" docker compose run --rm hashlog
```

### 2) Run Volatility 2 plugins
Volatility 2 runs in its own container. First identify the profile, then run analysis commands **on your host**:

```bash
# Identify the memory profile (Windows XP SP2 x86)
docker compose exec vol2 vol.py -f /evidence/memory.raw imageinfo

# Process list
docker compose exec vol2 vol.py -f /evidence/memory.raw --profile=WinXPSP2x86 pslist > cases/Memory_Forensics/vol_output/pslist.txt

# Process tree
docker compose exec vol2 vol.py -f /evidence/memory.raw --profile=WinXPSP2x86 pstree > cases/Memory_Forensics/vol_output/pstree.txt

# Network connections (XP specific)
docker compose exec vol2 vol.py -f /evidence/memory.raw --profile=WinXPSP2x86 connections > cases/Memory_Forensics/vol_output/connections.txt
```

**Tip:** These commands can take 1-5 minutes each depending on memory dump size.

### 3) Analyze the outputs
**Re-enter the workstation to review outputs:**
```bash
docker compose run --rm -it dfir

# View the results
cat Memory_Forensics/vol_output/pslist.txt | less
cat Memory_Forensics/vol_output/pstree.txt | less
cat Memory_Forensics/vol_output/netscan.txt | less

# Look for suspicious processes (keyloggers, unusual executables)
grep -i keylogger Memory_Forensics/vol_output/pslist.txt

# Look for suspicious processes
grep -E "(ToolKeylogger|win32dd)" Memory_Forensics/vol_output/pslist.txt

# Look for network connections
grep -v "LISTENING" Memory_Forensics/vol_output/connections.txt
```

### 4) Optional: Extract suspicious process memory
If you identified a suspicious PID (e.g., 3456), dump its memory:

**On your host:**
```bash
# Dump process memory (replace <pid> with actual PID)
docker compose exec vol2 vol.py -f /evidence/memory.raw --profile=WinXPSP2x86 procdump -p <pid> -D cases/Memory_Forensics/vol_output/

# Extract executable
docker compose exec vol2 vol.py -f /evidence/memory.raw --profile=WinXPSP2x86 procdump -p <pid> -n <executable_name>.dmp -D cases/Memory_Forensics/vol_output/
```

### 5) Fill in memory_report.md with findings
Use the template at `cases/Memory_Forensics/Lab2/memory_report.md`.

**For detailed guidance**, see `WALKTHROUGH.md` in this directory.

---

## Alternative: One-Off Commands

You can run all commands as one-offs without entering the workstation, but you'll miss tab-completion and easier output review. See the original commands above, ensuring all use full paths like `cases/Memory_Forensics/vol_output/...`

---

## Marking Rubric
- Chain-of-custody (20%)  
- Correct plugin usage (30%)  
- Quality of analysis (30%)  
- Report quality (20%)
