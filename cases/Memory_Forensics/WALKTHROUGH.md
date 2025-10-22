# Lab 2: Memory Forensics with Volatility 2 - Complete Walkthrough

## Overview

This lab teaches you to analyze a captured memory dump from the **2009 Cloudcore Data Exfiltration Case** using the DFIR forensics container (which includes Volatility 2, Volatility 3, YARA, and other tools). You'll discover evidence of malicious processes, network connections, and potential data theft.

**Time Estimate:** 90 minutes
**Difficulty:** Intermediate
**Tools:** DFIR container (Volatility 2/3, YARA, Sleuth Kit), hashlog

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

# Build vol2 if needed
docker compose build vol2
```

---

## Lab Setup

### 1. Create Output Directory

```bash
mkdir -p cases/Memory_Forensics/vol_output
```

This directory will store all Volatility plugin outputs.

### 2. Start Interactive DFIR Forensics Shell

Open an interactive shell to the main forensics container with all tools available:

```bash
docker compose run --rm -it dfir /bin/bash
```

**You're now INSIDE the dfir forensics container.** All commands below run WITHOUT the `docker compose` prefix.

**Available tools in this container:**
- Sleuth Kit, TestDisk, Foremost, ewf-tools, exiftool, hashdeep, bulk_extractor
- **Volatility 2** (use: `vol2` command for legacy Windows analysis)
- **Volatility 3** (use: `vol` command for modern Windows analysis)
- **YARA** (use: `yara` command for malware scanning)
- Standard utilities: sha256sum, strings, grep, find, etc.

### 3. Verify Evidence Integrity (Chain of Custody)

Generate and record the SHA256 hash for chain of custody:

```bash
sha256sum /evidence/memory.raw
```

**Expected Output:**
```
a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6a7b8c9d0e1f  /evidence/memory.raw
```

**Important:** Copy this SHA256 hash to your `memory_report.md` file for chain of custody documentation.

---

## Step-by-Step Analysis

### Step 1: Identify the Operating System Profile

First, let Volatility detect the OS profile. (You're inside the dfir container):

```bash
vol2 -f /evidence/memory.raw imageinfo
```

**Expected Output:**
```
Volatility Foundation Volatility Framework 2.x
INFO    : volatility.debug    : Parsing image file
INFO    : volatility.debug    : Image Parameters
INFO    : volatility.debug    : OS : Windows XP Service Pack 3 x86
...
Suggested Profile(s) : WinXPSP3x86, WinXPSP2x86
AS Layer                 : IA32PagedMemory
DTB                      : 0x...
KDBG                     : 0x...
Image Type               : MemoryDump
Image Date               : [timestamp]
...
```

**What to note:**
- OS version (likely Windows XP or 7)
- Architecture (32-bit or 64-bit)
- If this fails, see Troubleshooting section below

---

### Step 2: List Running Processes (pslist)

Get a flat list of all running processes at the time of capture. Use the profile from Step 1:

```bash
vol2 -f /evidence/memory.raw --profile=WinXPSP3x86 pslist > /cases/Memory_Forensics/vol_output/pslist.txt
```

**Review the output:**
```bash
cat /cases/Memory_Forensics/vol_output/pslist.txt
```

**Expected Output Format:**
```
 Offset(V)  Name                    PID   PPID   Thds   Hnds Time
---------- -------------------- ------ ------ ------ ------ ----
0x...      System                    4      0     59    331 1970-01-01 00:00:00 UTC+0000
...
0x...      explorer.exe           1234    568     12    234 2009-10-10 14:23:45 UTC+0000
0x...      iexplore.exe           2048   1234      8    156 2009-10-10 14:25:10 UTC+0000
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
vol2 -f /evidence/memory.raw --profile=WinXPSP3x86 pstree > /cases/Memory_Forensics/vol_output/pstree.txt
```

**Review the output:**
```bash
cat /cases/Memory_Forensics/vol_output/pstree.txt
```

**Expected Output Format:**
```
Name                                                  PID   PPID   Offset             Time
System                                                  4      0 0x...     1970-01-01 00:00:00 UTC+0000
. smss.exe                                           368      4 0x...     2009-10-10 13:45:00 UTC+0000
.. csrss.exe                                         456    368 0x...     2009-10-10 13:45:01 UTC+0000
...
. explorer.exe                                      1234    568 0x...     2009-10-10 14:00:00 UTC+0000
.. iexplore.exe                                     2048   1234 0x...     2009-10-10 14:25:10 UTC+0000
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
vol2 -f /evidence/memory.raw --profile=WinXPSP3x86 netscan > /cases/Memory_Forensics/vol_output/netscan.txt
```

**Review the output:**
```bash
cat /cases/Memory_Forensics/vol_output/netscan.txt
```

**Expected Output Format:**
```
Offset(V)      Proto   LocalAddr           LocalPort ForeignAddr         ForeignPort State            PID
0x...          TCPv4   192.168.1.100       49152     8.8.8.8             443         ESTABLISHED      2048
0x...          TCPv4   192.168.1.100       49153     10.0.0.50           6667        ESTABLISHED      3456
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
vol2 -f /evidence/memory.raw --profile=WinXPSP3x86 dlllist -p 3456 > /cases/Memory_Forensics/vol_output/dlllist_3456.txt
```

**What to look for:**
- Malicious DLLs
- DLLs loaded from unusual paths
- Known vulnerable or exploit DLLs

---

### Step 6: Dump Suspicious Process Memory (Optional)

To extract the full memory space of a suspicious process for deeper analysis:

```bash
vol2 -f /evidence/memory.raw --profile=WinXPSP3x86 memdump -p 3456 -D /cases/Memory_Forensics/vol_output
```

**Note:** This creates large files. Only dump if you need to:
- Extract embedded executables
- Perform strings analysis on process memory
- Search for encryption keys or passwords

---

### Step 7: Check for Hidden/Unlinked Processes (Advanced)

Some malware "unlinks" processes from the active process list. Check for discrepancies:

```bash
vol2 -f /evidence/memory.raw --profile=WinXPSP3x86 psscan > /cases/Memory_Forensics/vol_output/psscan.txt
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

Fill in `cases/Memory_Forensics/Lab2/memory_report.md` with:

### 1. Evidence & Integrity
- File name: `memory.raw`
- SHA256 hash (from hashlog)
- Chain of custody entry

### 2. Methods
```
Container: dfir (all-in-one DFIR forensics container)
Commands executed (run inside: docker compose run --rm -it dfir /bin/bash):
- vol2 -f /evidence/memory.raw imageinfo
- vol2 -f /evidence/memory.raw --profile=WinXPSP3x86 pslist
- vol2 -f /evidence/memory.raw --profile=WinXPSP3x86 pstree
- vol2 -f /evidence/memory.raw --profile=WinXPSP3x86 netscan
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

## About YARA

**YARA is now integrated into the dfir container.** No need to juggle multiple containers!

### Running YARA

Simply run YARA from within the dfir shell:

```bash
# Start the dfir container
docker compose run --rm -it dfir /bin/bash

# Inside the dfir container, run YARA:
yara -r /rules/malware_signatures.yar /evidence/memory.raw

# Or save output to a file
yara -r /rules/malware_signatures.yar /evidence/memory.raw > /cases/Memory_Forensics/vol_output/yara_scan.txt
```

All your analysis happens in one unified forensics environment!

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
chmod -R 755 cases/Memory_Forensics/vol_output
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

- [ ] `cases/Memory_Forensics/vol_output/` folder with:
  - `pslist.txt`
  - `pstree.txt`
  - `netscan.txt`
  - (Optional) `psscan.txt`, `dlllist_*.txt`
- [ ] `cases/Memory_Forensics/Lab2/memory_report.md` completed with all sections
- [ ] `cases/chain_of_custody.csv` updated with memory.raw hash
- [ ] All suspicious PIDs documented with justification
- [ ] Correlation with case timeline noted

---

## Going Further (Optional Extensions)

If you finish early or want deeper analysis (all inside the dfir container):

1. **Extract process executables:**
   ```bash
   vol2 -f /evidence/memory.raw --profile=WinXPSP3x86 procdump -p <suspicious_pid> -D /cases/Memory_Forensics/vol_output
   ```

2. **Search for encryption keys in memory:**
   ```bash
   strings /evidence/memory.raw | grep -i "password\|truecrypt\|key"
   ```

3. **Check for registry persistence mechanisms:**
   ```bash
   vol2 -f /evidence/memory.raw --profile=WinXPSP3x86 printkey -K "Software\Microsoft\Windows\CurrentVersion\Run"
   ```

4. **Timeline all process creation times:**
   ```bash
   vol2 -f /evidence/memory.raw --profile=WinXPSP3x86 timeliner > /cases/Memory_Forensics/vol_output/timeliner.txt
   ```

5. **YARA scan the memory dump:**
   ```bash
   yara -r /rules/malware_signatures.yar /evidence/memory.raw > /cases/Memory_Forensics/vol_output/yara_scan.txt
   ```

6. **Use Sleuth Kit tools for disk analysis:**
   ```bash
   fls -r /evidence/disk.img
   ```

---

## Additional Resources

- **Volatility 2 Documentation:** https://www.volatilityfoundation.org/documentation
- **Volatility 2 Command Reference:** https://github.com/volatilityfoundation/volatility/wiki/Command-Reference
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
