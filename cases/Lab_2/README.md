# Forensic Lab 2: Memory Forensics with Volatility 3

**Goal:** Learn to analyse a captured memory image using Volatility 3 inside Docker.

**Skills:**  
- Verify integrity of memory dump (hashing, CoC).  
- Run basic Volatility plugins (pslist, pstree, netscan).  
- Extract suspicious processes and dump artifacts.  
- Document findings in a reproducible report.

---

## What to submit
- `cases/Lab_2/vol_output/` with plugin outputs (CSV/TXT).  
- `cases/Lab_2/memory_report.md` (template provided).  
- Updated `cases/chain_of_custody.csv` including memory dump hash.

---

## Evidence
The memory dump `evidence/memory.raw` (~511MB) is provided as part of the 2009 Cloudcore investigation. This is a captured memory image from the suspect workstation taken on October 10, 2009.

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

You'll see the forensic lab banner and get a bash prompt. **Note:** For Volatility 3 commands, we use a specialized container, but most preparation work is done in the main workstation.

### 1) Create output directory and hash the memory dump
**Inside the workstation:**
```bash
mkdir -p Lab_2/vol_output
exit
```

**On your host:**
```bash
COC_NOTE="Lab2 memory intake" docker compose run --rm hashlog
```

### 2) Run Volatility 3 plugins
Volatility runs in its own container. Run these commands **on your host**:

```bash
# Process list
docker compose run --rm vol3 vol -f /evidence/memory.raw windows.pslist.PsList > cases/Lab_2/vol_output/pslist.txt

# Process tree
docker compose run --rm vol3 vol -f /evidence/memory.raw windows.pstree.PsTree > cases/Lab_2/vol_output/pstree.txt

# Network connections
docker compose run --rm vol3 vol -f /evidence/memory.raw windows.netscan.NetScan > cases/Lab_2/vol_output/netscan.txt
```

**Tip:** These commands can take 1-5 minutes each depending on memory dump size.

### 3) Analyze the outputs
**Re-enter the workstation to review outputs:**
```bash
docker compose run --rm -it dfir

# View the results
cat Lab_2/vol_output/pslist.txt | less
cat Lab_2/vol_output/pstree.txt | less
cat Lab_2/vol_output/netscan.txt | less

# Look for suspicious processes (TrueCrypt, unusual executables)
grep -i truecrypt Lab_2/vol_output/pslist.txt

# Look for IRC connections (port 6667)
grep 6667 Lab_2/vol_output/netscan.txt
```

### 4) Optional: Extract suspicious process memory
If you identified a suspicious PID (e.g., 3456), dump its memory:

**On your host:**
```bash
docker compose run --rm vol3 vol -f /evidence/memory.raw -o /cases/Lab_2/vol_output windows.memmap.Memmap --pid <pid> --dump
```

### 5) Fill in memory_report.md with findings
Use the template at `cases/Lab_2/Lab2/memory_report.md`.

**For detailed guidance**, see `WALKTHROUGH.md` in this directory.

---

## Alternative: One-Off Commands

You can run all commands as one-offs without entering the workstation, but you'll miss tab-completion and easier output review. See the original commands above, ensuring all use full paths like `cases/Lab_2/vol_output/...`

---

## Marking Rubric
- Chain-of-custody (20%)  
- Correct plugin usage (30%)  
- Quality of analysis (30%)  
- Report quality (20%)
