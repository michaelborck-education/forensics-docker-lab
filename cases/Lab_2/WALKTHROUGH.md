# Lab 2: Memory Forensics with Volatility 3 - Complete Walkthrough

## Overview

This lab teaches you to analyze a captured memory dump from the **2009 Cloudcore Data Exfiltration Case** using Volatility 3 within a Docker container. You'll discover evidence of malicious processes, network connections, and potential data theft.

**Time Estimate:** 90 minutes
**Difficulty:** Intermediate
**Tools:** Volatility 3, Docker, hashlog

---

## Case Context

According to the investigation timeline, on **October 10, 2009**, Cloudcore's IT department noticed suspicious network traffic. A memory dump was captured from the suspect workstation before shutdown. Your job is to analyze this memory image to:

- Identify suspicious processes
- Discover active network connections
- Find evidence of data exfiltration tools (hint: encryption software)
- Document your findings for the investigation report

---

## Prerequisites Checklist

Before starting, ensure:

- [ ] Docker and Docker Compose are installed and running
- [ ] You've completed Lab 1 (disk forensics) or are familiar with the case
- [ ] Evidence files are in place: `evidence/memory.raw` exists (~511MB)
- [ ] You've read `STORYLINE.md` for case background
- [ ] Docker toolbox image is built: `docker compose build dfir`
- [ ] Chain of custody CSV exists: `cases/chain_of_custody.csv`

**Test your setup:**
```bash
# Verify Docker is running
docker compose ps

# Verify evidence file exists
ls -lh evidence/memory.raw
```

---

## Lab Setup

### 1. Create Output Directory

```bash
mkdir -p cases/Lab_2/vol_output
```

This directory will store all Volatility plugin outputs.

### 2. Verify Evidence Integrity

Before analyzing, establish chain of custody:

```bash
COC_NOTE="Lab 2: Memory dump analysis started" docker compose run --rm hashlog
```

**Expected Output:**
```
Hashing /evidence...
Added: memory.raw | SHA256: [long hash] | Lab 2: Memory dump analysis started
```

**Important:** Copy the SHA256 hash to your `memory_report.md` file.

---

## Step-by-Step Analysis

### Step 1: Identify the Operating System Profile

First, let Volatility detect the OS profile:

```bash
docker compose run --rm vol3 vol -f /evidence/memory.raw windows.info.Info
```

**Expected Output:**
```
Volatility 3 Framework ...
Variable        Value
Kernel Base     0x...
DTB             0x...
Symbols         windows/...
Is64Bit         False
IsPAE           True
...
```

**What to note:**
- OS version (likely Windows XP or 7)
- Architecture (32-bit or 64-bit)
- If this fails, see Troubleshooting section below

---

### Step 2: List Running Processes (pslist)

Get a flat list of all running processes at the time of capture:

```bash
docker compose run --rm vol3 vol -f /evidence/memory.raw windows.pslist.PsList > cases/Lab_2/vol_output/pslist.txt
```

**Review the output:**
```bash
cat cases/Lab_2/vol_output/pslist.txt
```

**Expected Output Format:**
```
PID     PPID    ImageFileName           Offset(V)       Threads Handles SessionId
4       0       System                  0x...           ...     ...     ...
...
1234    568     explorer.exe            0x...           ...     ...     1
2048    1234    iexplore.exe            0x...           ...     ...     1
...
```

**What to look for:**
- **System processes** (System, smss.exe, csrss.exe, services.exe, lsass.exe)
- **User processes** (explorer.exe, browser processes)
- **Suspicious processes:**
  - Unusual names (misspellings like "svch0st.exe" instead of "svchost.exe")
  - Processes running from unusual locations (temp directories, user folders)
  - Unexpected parent-child relationships (PPID column)
  - **TrueCrypt.exe** - encryption software (key finding for this case!)

**Action:** Highlight any suspicious PIDs for further investigation.

---

### Step 3: View Process Tree (pstree)

See the parent-child relationships between processes:

```bash
docker compose run --rm vol3 vol -f /evidence/memory.raw windows.pstree.PsTree > cases/Lab_2/vol_output/pstree.txt
```

**Review the output:**
```bash
cat cases/Lab_2/vol_output/pstree.txt
```

**Expected Output Format:**
```
PID     PPID    ImageFileName           Offset(V)       Threads Handles SessionId
4       0       System                  0x...           ...     ...     ...
* 368   4       smss.exe                0x...           ...     ...     ...
** 456  368     csrss.exe               0x...           ...     ...     ...
...
* 1234  568     explorer.exe            0x...           ...     ...     1
** 2048 1234    iexplore.exe            0x...           ...     ...     1
```

**What to look for:**
- Processes spawned by unusual parents (e.g., cmd.exe spawned by Word)
- Orphaned processes (no parent)
- Multiple instances of the same process
- TrueCrypt spawned by user (explorer.exe)

---

### Step 4: Scan Network Connections (netscan)

Identify active and recent network connections:

```bash
docker compose run --rm vol3 vol -f /evidence/memory.raw windows.netscan.NetScan > cases/Lab_2/vol_output/netscan.txt
```

**Review the output:**
```bash
cat cases/Lab_2/vol_output/netscan.txt
```

**Expected Output Format:**
```
Offset          Proto   LocalAddr       LocalPort       ForeignAddr     ForeignPort     State           PID     Owner
0x...           TCPv4   192.168.1.100   49152           8.8.8.8         443             ESTABLISHED     2048    iexplore.exe
0x...           TCPv4   192.168.1.100   49153           10.0.0.50       6667            ESTABLISHED     3456    unknown.exe
```

**What to look for:**
- **Unusual ports:**
  - 6667, 6668 (IRC - common for C2 communications)
  - High-numbered ports to foreign IPs
- **Suspicious processes with network activity:**
  - Unknown executables
  - System processes with external connections (rare)
- **Foreign IP addresses:**
  - Non-corporate IPs
  - Known malicious IPs (cross-reference with threat intel)
- **Correlation:** Match PIDs from netscan with suspicious processes from pslist

**Key Finding:** If you see IRC connections (port 6667) from a suspicious process, this strongly suggests command-and-control activity.

---

### Step 5: List DLLs for Suspicious Process (Optional)

If you identified a suspicious PID (e.g., 3456), list its loaded DLLs:

```bash
docker compose run --rm vol3 vol -f /evidence/memory.raw windows.dlllist.DllList --pid 3456 > cases/Lab_2/vol_output/dlllist_3456.txt
```

**What to look for:**
- Malicious DLLs
- DLLs loaded from unusual paths
- Known vulnerable or exploit DLLs

---

### Step 6: Dump Suspicious Process Memory (Optional)

To extract the full memory space of a suspicious process for deeper analysis:

```bash
docker compose run --rm vol3 vol -f /evidence/memory.raw -o /cases/Lab_2/vol_output windows.memmap.Memmap --pid 3456 --dump
```

**Note:** This creates large files. Only dump if you need to:
- Extract embedded executables
- Perform strings analysis on process memory
- Search for encryption keys or passwords

---

### Step 7: Check for Hidden/Unlinked Processes (Advanced)

Some malware "unlinks" processes from the active process list. Check for discrepancies:

```bash
docker compose run --rm vol3 vol -f /evidence/memory.raw windows.psscan.PsScan > cases/Lab_2/vol_output/psscan.txt
```

Compare `psscan.txt` with `pslist.txt`. Any process in psscan but NOT in pslist is hidden.

---

## Analysis Guidance

### Building Your Investigation

As you analyze the outputs, answer these questions in your `memory_report.md`:

1. **Evidence Integrity**
   - What is the SHA256 hash of memory.raw?
   - When was the memory dump captured?
   - Is it documented in chain_of_custody.csv?

2. **System Baseline**
   - What OS version is this?
   - How many processes were running?
   - What user account was logged in?

3. **Suspicious Processes**
   - Did you find TrueCrypt.exe? (This is a smoking gun!)
   - Any processes with unusual names or locations?
   - Any processes with unexpected network connections?

4. **Network Activity**
   - Are there IRC connections (port 6667)?
   - Any connections to external IPs?
   - Which process PIDs match network activity?

5. **Correlation with Other Evidence**
   - Does the network activity match findings from Lab 5 (network.cap)?
   - Does TrueCrypt explain the encrypted_container.dat from Lab 1?
   - Do timestamps align with the case timeline?

---

## Expected Key Findings

By the end of this lab, you should have discovered:

1. **TrueCrypt process running** - indicates data encryption/exfiltration preparation
2. **Suspicious network connections** - possibly IRC C2 channel
3. **Process tree anomalies** - unusual parent-child relationships
4. **Timeline correlation** - memory capture aligns with October 10 incident

These findings support the theory that the suspect:
- Used TrueCrypt to encrypt stolen data (encrypted_container.dat)
- Maintained C2 communications via IRC
- Exfiltrated data before detection

---

## Completing the Report

Fill in `cases/Lab_2/Lab2/memory_report.md` with:

### 1. Evidence & Integrity
- File name: `memory.raw`
- SHA256 hash (from hashlog)
- Chain of custody entry

### 2. Methods
```
Commands executed:
- docker compose run --rm vol3 vol -f /evidence/memory.raw windows.info.Info
- docker compose run --rm vol3 vol -f /evidence/memory.raw windows.pslist.PsList
- docker compose run --rm vol3 vol -f /evidence/memory.raw windows.pstree.PsTree
- docker compose run --rm vol3 vol -f /evidence/memory.raw windows.netscan.NetScan
```

### 3. Findings
**Processes:**
- TrueCrypt.exe (PID: XXXX) - encryption software running
- [Any other suspicious processes]

**Network:**
- IRC connection to X.X.X.X:6667 from PID XXXX
- [Other notable connections]

**Artifacts:**
- [Any dumped memory segments]

### 4. Limitations
- Some plugins may have returned no data (mention which)
- Memory dump may be incomplete or corrupted (note any errors)
- No symbols for certain processes (if applicable)

### 5. Conclusion
Summarize:
- Evidence of TrueCrypt use confirms data encryption capability
- IRC connections suggest C2 communications
- Findings consistent with data exfiltration scenario
- Recommend correlation with network traffic analysis (Lab 5)

---

## Troubleshooting

### Problem: "Unable to detect OS profile"
**Solution:**
- Ensure memory.raw is a valid memory dump (check file size ~500MB+)
- Try specifying the profile manually if you know the OS
- Memory dump may be corrupted - verify hash against known good

### Problem: "No output from plugin"
**Possible causes:**
- Plugin not compatible with OS version
- Memory dump incomplete or corrupted
- Process already terminated before capture

**Solution:**
- Try alternative plugins (e.g., psscan instead of pslist)
- Check Volatility 3 documentation for plugin compatibility
- Note limitation in report

### Problem: "Permission denied" when writing output
**Solution:**
```bash
# Ensure output directory exists and is writable
chmod -R 755 cases/Lab_2/vol_output
```

### Problem: Commands hang or take too long
**Solution:**
- Memory analysis is CPU-intensive and can take 1-5 minutes per plugin
- If longer than 10 minutes, try Ctrl+C and re-run
- Check Docker resource limits (allocate more CPU/RAM in Docker Desktop settings)

### Problem: "File not found: /evidence/memdump.raw"
**Solution:**
- The README references `memdump.raw` but the actual file is `memory.raw`
- Use `/evidence/memory.raw` in all commands (as shown in this walkthrough)

---

## Submission Checklist

Before submitting, ensure you have:

- [ ] `cases/Lab_2/vol_output/` folder with:
  - `pslist.txt`
  - `pstree.txt`
  - `netscan.txt`
  - (Optional) `psscan.txt`, `dlllist_*.txt`
- [ ] `cases/Lab_2/Lab2/memory_report.md` completed with all sections
- [ ] `cases/chain_of_custody.csv` updated with memory.raw hash
- [ ] All suspicious PIDs documented with justification
- [ ] Correlation with case timeline noted

---

## Going Further (Optional Extensions)

If you finish early or want deeper analysis:

1. **Extract process executables:**
   ```bash
   docker compose run --rm vol3 vol -f /evidence/memory.raw -o /cases/Lab_2/vol_output windows.pslist.PsList --dump --pid <suspicious_pid>
   ```

2. **Search for encryption keys in memory:**
   ```bash
   docker compose run --rm dfir strings /evidence/memory.raw | grep -i "password\|truecrypt\|key"
   ```

3. **Check for registry persistence mechanisms:**
   ```bash
   docker compose run --rm vol3 vol -f /evidence/memory.raw windows.registry.printkey.PrintKey --key "Software\Microsoft\Windows\CurrentVersion\Run"
   ```

4. **Timeline all process creation times:**
   ```bash
   docker compose run --rm vol3 vol -f /evidence/memory.raw windows.pslist.PsList --output csv > cases/Lab_2/vol_output/pslist.csv
   ```

5. **YARA scan the memory dump:**
   ```bash
   docker compose run --rm yara yara -r /rules/malware_signatures.yar /evidence/memory.raw
   ```

---

## Additional Resources

- **Volatility 3 Documentation:** https://volatility3.readthedocs.io/
- **Windows Process Baseline:** Know normal processes (System, smss, csrss, services, lsass, svchost)
- **IRC Protocol:** Understand port 6667 and C2 communications
- **TrueCrypt:** Full-disk/container encryption tool (discontinued, but used in 2009)
- **DFIR Training:** See `STORYLINE.md` and `COURSE_MAPPING.md` for context

---

## Questions or Issues?

- Check `TROUBLESHOOTING.md` in the root directory
- Review `FACILITATION.md` for teaching notes
- Consult with your instructor or lab assistant
- Reference `ANSWER_KEY.md` ONLY after attempting the lab yourself

**Remember:** Digital forensics requires patience, attention to detail, and methodical documentation. Take notes as you go!

---

**Next Lab:** Lab 3 - GUI Analysis with Autopsy
