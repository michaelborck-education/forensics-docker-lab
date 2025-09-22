# Module 06 — Forensic Lab 2: Memory Forensics with Volatility 3

**Goal:** Learn to analyze a captured memory image using Volatility 3 inside Docker.

**Skills:**  
- Verify integrity of memory dump (hashing, CoC).  
- Run basic Volatility plugins (pslist, pstree, netscan).  
- Extract suspicious processes and dump artifacts.  
- Document findings in a reproducible report.

---

## What to submit
- `cases/Lab2/vol_output/` with plugin outputs (CSV/TXT).  
- `cases/Lab2/memory_report.md` (template provided).  
- Updated `cases/chain_of_custody.csv` including memory dump hash.

---

## Evidence
Download and place `mair_dump1.raw` (safe Windows XP memory dump ~128MB from Digital Corpora: https://digitalcorpora.org/downloads/mair-windows-memdumps/) into `evidence/memdump.raw`. (Public training set; no malware.)

---

## Steps
1. **Hash the memory dump**
```bash
COC_NOTE="Lab2 memory intake" docker compose run --rm hashlog
```

2. **Run basic plugins**
```bash
docker compose run --rm vol3 vol -f /evidence/memdump.raw windows.pslist.PsList > cases/Lab2/vol_output/pslist.txt
docker compose run --rm vol3 vol -f /evidence/memdump.raw windows.pstree.PsTree > cases/Lab2/vol_output/pstree.txt
docker compose run --rm vol3 vol -f /evidence/memdump.raw windows.netscan.NetScan > cases/Lab2/vol_output/netscan.txt
```

3. **Optional: Extract suspicious process memory**
```bash
docker compose run --rm vol3 vol -f /evidence/memdump.raw -o /cases/Lab2/vol_output windows.memmap.Memmap --pid <pid>
```

4. **Fill in memory_report.md** with findings.

---

## Marking Rubric
- Chain-of-custody (20%)  
- Correct plugin usage (30%)  
- Quality of analysis (30%)  
- Report quality (20%)
