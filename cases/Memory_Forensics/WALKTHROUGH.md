---
format:
  html:
    embed-resources: true
---

# Memory_Forensics Lab - Student Walkthrough
## Memory Analysis with Volatility 2

**Time Estimate:** 2-3 hours

**Difficulty:** Intermediate

**Tools:** Volatility 2, strings, grep, analysis tools

---

## 📸 Context: How Memory Dumps are Captured (In Real Forensic Practice)

**Important Context:** In this lab, you're analysing a **pre-captured memory dump** (`memory.raw`). In real incident response, capturing RAM is time-critical and must be done before shutting down the system.

### Real-World Memory Capture Process

In a real incident response, a forensic technician would:

1. **Live System Acquisition (Time-Critical):**
   - Respond to incident while system is still running
   - Connect via network OR USB (depending on network accessibility)
   - Capture memory BEFORE powering down system
   - Power down = loss of all volatile data (RAM)

2. **Memory Capture Tools (Industry Standard):**
   - **Volatility 2/3** - Can create memory dumps (in addition to analysing them)
   - **FTK Imager** (Accessdata) - GUI tool for Windows memory capture
   - **winpmem** - Windows memory acquisition (open source)
   - **LiME** (Linux Memory Extractor) - Linux kernel module for RAM capture
   - **DumpIt** - Windows memory dumper
   - All tools calculate hashes during capture

3. **Verification:**
   - Hash the captured memory file
   - Document the hash
   - Verify captured size matches installed RAM
   - Check for memory errors or truncation

4. **Documentation:**
   - When captured, by whom, on what system
   - System OS and version
   - Total RAM captured
   - Hash of memory dump
   - Any errors or warnings during capture
   - System uptime and current time

### In This Lab

We've **skipped the capture phase** and provided you with a pre-captured memory dump (`memory.raw` from a Windows XP SP3 system). This lets you focus on:

- Analysis skills
- Process forensics
- Malware detection
- DLL and network analysis

But remember: In real forensics, the memory capture step is CRITICAL because:

- ✓ RAM capture must happen while system is running (volatile!)
- ✓ Hashing proves memory integrity during capture
- ✓ Chain of custody documents when capture occurred
- ✓ Professional tools ensure complete RAM acquisition
- ✓ Missing this step = missing active process evidence

**Note:** This lab uses `memory.raw` from a Windows XP system (provided). In real practice, you'd capture from the actual system where the incident occurred.

---

## 📋 Pre-Lab Setup

### 1. Verify Lab Templates Are Ready

The lab folder should already contain three template files. Verify they exist:

```bash
# On your host machine
ls -lh cases/Memory_Forensics/
```

You should see:

- **chain_of_custody.csv** - Evidence handling record
- **analysis_log.csv** - Command execution log
- **lab_report.md** - Report template for your findings
- **WALKTHROUGH.md** - This document

**What each file does:**

| File | Purpose | When Used |
|------|---------|-----------|
| **chain_of_custody.csv** | Documents evidence integrity (hashes, analyst, date) | Before lab starts - fill in evidence details |
| **analysis_log.csv** | Logs every command you run with timestamps and output hashes | During lab - use `coc-log` script to auto-update |
| **lab_report.md** | Template for writing your findings and analysis | After lab - document what you discovered |

If any files are missing, copy them from templates/:

```bash
# Copy missing templates (if needed)
cp templates/chain_of_custody.csv cases/Memory_Forensics/chain_of_custody.csv
cp templates/analysis_log.csv cases/Memory_Forensics/analysis_log.csv
cp templates/lab_report_template.md cases/Memory_Forensics/lab_report.md
```

**Tips for using these files:**
- **chain_of_custody.csv**: Edit with spreadsheet app or text editor. Fill in evidence hash, analyst name, case number before beginning.
- **analysis_log.csv**: Use `coc-log` script inside container to automatically log commands (recommended). If not using coc-log, manually add entries after each command.
- **lab_report.md**: Use as starting point for your findings report. Replace placeholders with your actual analysis and evidence.

### 2. Verify Evidence File

```bash
# On your host machine
ls -lh evidence/memory.raw
```

You should see `memory.raw` (~511 MB).

---

## 🚀 Connecting to the DFIR Forensic Workstation

The `scripts/forensics-workstation` script provides an immersive forensic environment that hides Docker complexity and simulates logging into a professional forensic workstation.

**On macOS/Linux:**
```bash
./scripts/forensics-workstation
```

**On Windows (PowerShell):**
```powershell
.\scripts\forensics-workstation.bat
```

You'll see:

1. A welcome banner asking for your analyst name
2. A lab summary showing all available cases
3. A connection message, then you'll see the forensic workstation prompt



---

## 📦 Part 1: Chain of Custody - Hash the Memory File

**CRITICAL:** Before analysing ANY evidence, you must calculate and document hash values. This proves the evidence hasn't been tampered with.

### Step 1: Calculate MD5 Hash

```bash
md5sum /evidence/memory.raw
```

**Example MD5 Output:**
```
fbe64517ecc93a02ed61aac8fddbe721  /evidence/memory.raw
```

**📋 Document MD5 in cases/Memory_Forensics/chain_of_custody.csv:**

- Evidence_ID: MEMORY-002
- MD5_Hash: (paste output from running the above command)
- SHA256_Hash: (you'll add this next)
- Analyst_Name: (your name)
- Date_Received: (today's date)
- Case_Number: CLOUDCORE-2024-INS-001
- Evidence_Description: Windows XP memory dump (memory.raw)
- Storage_Location: /evidence/memory.raw

### Step 2: Calculate SHA256 Hash

```bash
sha256sum /evidence/memory.raw
```

**Example SHA256 Output:**
```
9bdf773dd3316d447661085715344e3aa58b136815698e2cc03dbffc777a9e1b  /evidence/memory.raw
```

**📋 Update chain_of_custody.csv:**
- Add the SHA256_Hash value above

**Why document hashes?**

- **Integrity verification:** Proves evidence hasn't been modified or corrupted
- **Legal admissibility:** Courts require hash verification for digital evidence
- **Reproducibility:** Other investigators can verify they're analysing the same evidence
- **Chain of custody:** Documents the starting point of analysis


**📋 Document in analysis_log.csv:**

```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: md5sum /evidence/memory.raw
exit_code: 0
note: Chain of custody - calculated MD5 hash of memmory.raw : fbe64517ecc93a02ed61aac8fddbe721
```

```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: sha256sum /evidence/memmory.raw
exit_code: 0
note: Chain of custody - calculated SHA256 hash of memory.raw: 9bdf773dd3316d447661085715344e3aa58b136815698e2cc03dbffc777a9e1b
```

**Why document commands?**

- **Reproducibility:** Lets others repeat your exact steps to verify findings.
- **Legal Defensibility:** Creates a transparent, auditable log for court.
- **Evidence Integrity:** Shows exactly how you interacted with the data.
- **Accurate Reporting:** Provides the precise technical "how" for your report.
- **Peer Review & QA:** Allows colleagues to check your process for accuracy.
- **Contemporaneous Notes:** Logs actions as they happen, preventing memory errors.



---

## 🔍 Part 2: Detect OS Profile

The first step in Volatility analysis is identifying the operating system and architecture.

```bash
vol2 -f /evidence/memory.raw imageinfo > /cases/Memory_Forensics/imageinfo.txt
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: vol2 -f /evidence/memory.raw imageinfo > /cases/Memory_Forensics/imageinfo.txt
exit_code: 0
note: Detect OS profile and image parameters
```

Review the output:

```bash
cat /cases/Memory_Forensics/imageinfo.txt
```

**Key Info to Note:**

- Suggested Profile (e.g., WinXPSP3x86)
- OS version (Windows XP, Vista, 7, etc.)
- Architecture (32-bit or 64-bit)

**Store the profile name - you'll use it for all subsequent commands.**

---

## 🔎 Part 3: List Running Processes

### Step 1: Basic Process List (pslist)

**Why this step matters:**
When a computer is compromised, attackers often install malware or hacking tools. By examining the running processes, we can identify what was active on the system at the time of memory capture. This is our first "What was running?" investigation.

**How we know to do this:**
Malware analysis best practices require process listing as the first step. Volatility's `pslist` plugin shows all processes that were in the Windows process list at capture time.

```bash
vol2 -f /evidence/memory.raw --profile=WinXPSP3x86 pslist > /cases/Memory_Forensics/pslist.txt
```

**Replace `WinXPSP3x86` with the profile from your imageinfo output.**

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: vol2 -f /evidence/memory.raw --profile=WinXPSP3x86 pslist > /cases/Memory_Forensics/pslist.txt
exit_code: 0
note: List all running processes and their PIDs
```

Review the output:

```bash
cat /cases/Memory_Forensics/pslist.txt
```

**✅ Feedback - Command Success Indicators:**

- You should see output with multiple columns: `Offset(V)`, `Name`, `PID`, `PPID`, `Thds`, etc.
- You should see familiar Windows processes like: System, csrss.exe, services.exe, explorer.exe, svchost.exe
- Timestamps should match the memory dump date (2009-12-05)

**What to look for:**

- **Normal system processes:** System, smss.exe, csrss.exe, services.exe, lsass.exe, svchost.exe, explorer.exe
- **User processes:** iexplore.exe, firefox.exe, chrome.exe, Office applications
- **⚠️ SUSPICIOUS:**
  - Unusual process names (misspellings like "svch0st.exe" instead of "svchost.exe")
  - Processes in TEMP directories
  - Keyloggers or monitoring tools
  - Processes with truncated names (name field cut off)

**Key Finding in This Case:** Look for **ToolKeylogger.e** - this appears to be a keylogger (PID 280, parent explorer.exe). This is malicious!

### Step 2: Process Tree (pstree)

**Why this step matters:**
Understanding process relationships reveals how malware was launched. Normally, explorer.exe spawns user programs. If we see unusual parents (like cmd.exe spawning notepad.exe or explorer.exe spawning system tools), this indicates suspicious activity.

**How we know to do this:**
Process trees are critical for understanding attack chains. A malicious executable spawned from an unexpected parent process is a red flag.

Shows parent-child relationships between processes:

```bash
vol2 -f /evidence/memory.raw --profile=WinXPSP3x86 pstree > /cases/Memory_Forensics/pstree.txt
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: vol2 -f /evidence/memory.raw --profile=WinXPSP3x86 pstree > /cases/Memory_Forensics/pstree.txt
exit_code: 0
note: Show process tree with parent-child relationships
```

Review:

```bash
cat /cases/Memory_Forensics/pstree.txt
```

**✅ Feedback - Command Success Indicators:**

- Output shows a tree structure with indentation (dots: `.`, `..`, `...`)
- Normal boot sequence: System → smss.exe → csrss.exe + winlogon.exe → services.exe
- explorer.exe (PID 168) is the parent of most user processes
- Should have 30+ processes listed

**What to look for:**

- Unusual parent-child relationships (e.g., explorer.exe spawning keyloggers, cmd.exe spawning svchost.exe)
- Orphaned processes (processes with invalid parent PIDs)
- Multiple instances of normally-single processes
- **Key Finding:** ToolKeylogger.e (PID 280) is a child of explorer.exe - suspicious!

---

## 🌐 Part 4: Network Connections (netscan)

**Why this step matters:**
Network connections reveal command & control (C2) communication with attackers, data exfiltration, or lateral movement. Malware often "phones home" to receive instructions or send stolen data.

**How we know to do this:**
Network forensics is essential in incident response. Looking for suspicious ports (especially IRC port 6667/6668 for botnets) helps identify active compromise.

Identify active and recent network connections at the time of memory capture.

```bash
vol2 -f /evidence/memory.raw --profile=WinXPSP3x86 netscan > /cases/Memory_Forensics/netscan.txt
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: vol2 -f /evidence/memory.raw --profile=WinXPSP3x86 netscan > /cases/Memory_Forensics/netscan.txt
exit_code: 0
note: List all network connections (TCP/UDP)
```

Review:

```bash
cat /cases/Memory_Forensics/netscan.txt
```

**⚠️ Known Issue - Windows XP Profile:**
The `netscan` plugin may not support Windows XP profiles. If you get an error like:
```
ERROR: This command does not support the profile WinXPSP3x86
```

This is **normal** - netscan is primarily for Windows Vista and later. Document this in your analysis log and move to the next step.

**What to look for (if command succeeds):**

- **Suspicious ports:**
  - 6667, 6668 (IRC - Command & Control communications)
  - 445, 139 (SMB - often used for lateral movement)
  - High-numbered unusual ports
- **Foreign IPs:** Are they internal (10.0.0.0, 192.168.0.0, 172.16.0.0) or external?
- **Matching PIDs:** Cross-reference with pslist - which process owns each connection?

**Example suspicious finding:**
```
If you see: PID 280 (ToolKeylogger.e) connecting to 192.168.1.100:445 (SMB)
This suggests: The keylogger is exfiltrating data over SMB protocol
```

### Optional: Extract IRC connections only (if netscan succeeded)

```bash
grep -i "6667\|6668" /cases/Memory_Forensics/netscan.txt > /cases/Memory_Forensics/irc_connections.txt
```

---

## 🔐 Part 5: DLL Analysis - Examine Suspicious Process Libraries

**Why this step matters:**
Malware reveals its purpose through the libraries (DLLs) it loads. A keylogger needs keyboard hooks (USER32.dll), and if it exfiltrates data, it needs internet libraries (WININET.dll, urlmon.dll). By examining loaded DLLs, we can confirm the malware's functionality.

**How we know to do this:**
DLL analysis is standard malware reverse engineering. The DLLs a process loads tell us:

- What APIs it uses
- What capabilities it has
- Whether it's designed for persistence, exfiltration, or keylogging

Analyse the suspicious keylogger we found:

```bash
vol2 -f /evidence/memory.raw --profile=WinXPSP3x86 dlllist -p 280 > /cases/Memory_Forensics/dlllist_280.txt
```

**Replace `280` with the PID of your suspicious process.**

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: vol2 -f /evidence/memory.raw --profile=WinXPSP3x86 dlllist -p 280 > /cases/Memory_Forensics/dlllist_280.txt
exit_code: 0
note: List DLLs loaded by PID 280 (ToolKeylogger.e keylogger)
```

Review:

```bash
cat /cases/Memory_Forensics/dlllist_280.txt
```

**✅ Feedback - Command Success Indicators:**

- Output shows executable path: `C:\Program Files\XP Advanced\ToolKeylogger.exe`
- Output shows command line that launched it
- Should list 40+ DLLs
- Format has columns: Base, Size, LoadCount, LoadTime, Path

**What to look for:**

- **Keylogging indicators:** USER32.dll, KERNEL32.dll (for API hooking)
- **Internet connectivity:** WININET.dll, urlmon.dll, iertutil.dll (for C2 or data exfiltration)
- **Persistence:** Registry DLLs, file system libraries
- **Custom/suspicious DLLs:** Any DLL from non-standard locations like Program Files folders

**Key Finding in This Case:**

- **Executable:** ToolKeylogger.exe from "C:\Program Files\XP Advanced\"
- **Supporting DLL:** ToolKeyloggerDLL.dll (the actual keylogging code)
- **Internet libraries:** Loaded WININET, urlmon, iertutil - this keylogger sends data to an attacker!
- **Conclusion:** This is a fully functional keylogger with internet communication capability

---

## 🎯 Part 6: Verify Hidden Processes (Analysis of Previous Output)

**Why this step matters:**
Sophisticated malware uses rootkit techniques to hide from the process list. `pslist` only shows processes in the Windows process list, but `psscan` scans memory for all PROCESS structures, even ones deliberately hidden. By comparing the two, we can detect if malware is actively concealing itself.

**How we know to do this:**
Advanced malware analysis requires checking for hidden processes. If a process is in psscan but NOT in pslist, the malware is actively hiding itself from detection - a sign of sophisticated rootkit activity.

**Reusing Previous Output:**

You already ran psscan earlier. Let's analyse those results:

```bash
# Review the psscan output you already collected
cat /cases/Memory_Forensics/psscan.txt

# Compare process counts
echo "Processes in pslist:"
grep -c "^0x" /cases/Memory_Forensics/pslist.txt

echo "Processes in psscan:"
grep -c "^0x" /cases/Memory_Forensics/psscan.txt
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: Analysis of psscan output (previously collected)
exit_code: 0
note: Compare pslist vs psscan to detect hidden processes
```

**✅ Expected Output:**

- Both pslist and psscan should show ~33 processes
- If they match exactly, no processes are hidden
- If psscan shows MORE processes than pslist, some are hidden

**What to look for:**

- **Hidden Processes:** If psscan shows MORE processes than pslist, some are hidden
- **Compare process names:** Look for processes in psscan that don't appear in pslist
- **Timing anomalies:** Processes with exit times but still in memory

**Key Finding in This Case:**
In this evidence, psscan and pslist show the same processes - the attacker didn't hide the keylogger. This indicates **less sophisticated malware**. A more advanced attacker would use rootkit techniques to hide the keylogger from detection.

---

## 🚪 Part 7: Exit the Workstation

```bash
exit
```

---

## ✅ Deliverables

You should have created these files in `cases/Memory_Forensics/`:

**CSV Files (Documentation):**

- ✅ `chain_of_custody.csv` - Evidence hash
- ✅ `analysis_log.csv` - All commands run

**Evidence Analysis Files:**

- ✅ `imageinfo.txt` - OS profile and detection
- ✅ `pslist.txt` - All running processes
- ✅ `pstree.txt` - Process tree
- ✅ `netscan.txt` - Network connections
- ✅ `psscan.txt` - Process scan (hidden processes)
- ✅ `irc_connections.txt` - IRC traffic only (if found)
- ✅ `dlllist_*.txt` - DLL info for suspicious processes

---

## 📊 Analysis Summary

Before moving to the next lab, answer these questions:

1. **OS Profile:** What operating system and version?
   - Expected: Windows XP SP3 (WinXPSP3x86)

2. **Malicious Processes Found:**
   - What suspicious processes did you identify?
   - **Key Finding:** ToolKeylogger.e (PID 280) is a keylogger
   - Parent process: explorer.exe (PID 168)
   - Why is this suspicious? Keyloggers capture user keystrokes - this is malicious!

3. **Process Relationships:**
   - How was the keylogger launched?
   - Is it running under a normal user process (explorer.exe)?
   - What other processes are suspicious?

4. **Network Activity:**
   - Does netscan work on this Windows XP image?
   - If yes: Are there IRC connections (port 6667/6668)?
   - If no: Document the limitation and continue

5. **Hidden Processes:**
   - Are there more processes in psscan than in pslist?
   - Are any processes deliberately hidden?
   - In this case: The keylogger is visible (not hidden) - less sophisticated

6. **Timeline:**
   - When was the memory dump captured? (2009-12-05 18:47:28 UTC)
   - When were suspicious processes started? (2009-12-05 02:11:23 UTC)
   - Time delta: How long was the attacker active before capture?

---

## 🆘 Troubleshooting

### "Unable to detect OS profile"

- Memory file might be corrupted
- Verify hash matches expected value
- Try specifying profile manually if known

### "No output from netscan"

- Memory dump might not have any network activity
- Try alternative: `netstat` plugin instead
- This is okay - note it in your report

### "Plugin not found" error

- Make sure you're using correct plugin name
- `vol2` for Volatility 2 (legacy Windows)
- Check spelling of profile name

### "Permission denied" writing files
```bash
chmod -R 755 /cases/Memory_Forensics/
```

---

## 📚 Next Steps

After completing this lab:

1. **Review all output files** and identify key findings
2. **Correlate with other labs:**
   - Did you find TrueCrypt? Check USB_Imaging for encrypted containers
   - Did you find IRC connections? Check Network_Analysis for network traffic
3. **Document findings in your report**
4. **Continue with other labs** in the series when ready

---

## 📝 Summary - Quick Command Reference

```bash
# INSIDE the workstation:

# Hash verification
sha256sum /evidence/memory.raw
md5sum /evidence/memory.raw

# Detect OS
vol2 -f /evidence/memory.raw imageinfo > /cases/Memory_Forensics/imageinfo.txt

# Process analysis
vol2 -f /evidence/memory.raw --profile=WinXPSP3x86 pslist > /cases/Memory_Forensics/pslist.txt
vol2 -f /evidence/memory.raw --profile=WinXPSP3x86 pstree > /cases/Memory_Forensics/pstree.txt

# Network analysis
vol2 -f /evidence/memory.raw --profile=WinXPSP3x86 netscan > /cases/Memory_Forensics/netscan.txt

# Advanced
vol2 -f /evidence/memory.raw --profile=WinXPSP3x86 psscan > /cases/Memory_Forensics/psscan.txt
vol2 -f /evidence/memory.raw --profile=WinXPSP3x86 dlllist -p <PID> > /cases/Memory_Forensics/dlllist_<PID>.txt

# Exit workstation
exit
```

---

**Remember:** Document EVERY command and timestamp in analysis_log.csv!
