# Memory_Forensics Lab - Student Walkthrough
## Memory Analysis with Volatility 2

**Time Estimate:** 2-3 hours
**Difficulty:** Intermediate
**Tools:** Volatility 2, strings, grep, analysis tools

---

## 📋 Pre-Lab Setup

### 1. Copy Templates to Your Lab Folder

```bash
# On your host machine
cp templates/chain_of_custody.csv cases/Memory_Forensics/chain_of_custody.csv
cp templates/analysis_log.csv cases/Memory_Forensics/analysis_log.csv
```

### 2. Verify Evidence File

```bash
# On your host machine
ls -lh evidence/memory.raw
```

You should see `memory.raw` (~511 MB).

---

## 🚀 Connecting to the DFIR Forensic Workstation

**On macOS/Linux:**
```bash
./scripts/forensics-workstation
```

**On Windows (PowerShell):**
```powershell
.\scripts\forensics-workstation.bat
```

You're now inside the forensic environment. All commands below run WITHOUT Docker prefixes.

---

## 📦 Part 1: Chain of Custody - Hash the Memory File

Before any analysis, calculate and document the SHA256 hash.

```bash
sha256sum /evidence/memory.raw
```

**Example Output:**
```
a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6a7b8c9d0e1f  /evidence/memory.raw
```

**📋 Document in cases/Memory_Forensics/chain_of_custody.csv:**
- Evidence_ID: MEMORY-001
- SHA256_Hash: (paste the hash above)
- Analyst_Name: (your name)
- Date_Received: (today's date)
- Evidence_Description: Windows XP memory dump (memory.raw)

Also calculate MD5 (if your template asks for it):

```bash
md5sum /evidence/memory.raw
```

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

**What to look for:**
- **Normal system processes:** System, smss.exe, csrss.exe, services.exe, lsass.exe, svchost.exe, explorer.exe
- **User processes:** iexplore.exe, firefox.exe, chrome.exe
- **⚠️ SUSPICIOUS:** TrueCrypt.exe, unusual process names (misspellings like "svch0st.exe"), processes in temp directories

**Key Finding in This Case:** Look for **TrueCrypt.exe** - this is encryption software used to encrypt/hide data!

### Step 2: Process Tree (pstree)

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

**What to look for:**
- Unusual parent-child relationships (e.g., Word spawning cmd.exe)
- Orphaned processes (processes with no parent)
- Multiple instances of normally-single processes

---

## 🌐 Part 4: Network Connections (netscan)

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

**What to look for:**
- **Suspicious ports:**
  - 6667, 6668 (IRC - Command & Control communications)
  - 445, 139 (SMB - often used for lateral movement)
  - High-numbered unusual ports
- **Foreign IPs:** Are they internal (10.0.0.0, 192.168.0.0, 172.16.0.0) or external?
- **Matching PIDs:** Cross-reference with pslist - which process owns each connection?

**Example suspicious finding:**
```
If you see: PID 3456 connecting to 8.8.8.8:6667 (IRC port)
This suggests: That process is receiving commands via IRC
```

### Optional: Extract IRC connections only

```bash
grep -i "6667\|6668" /cases/Memory_Forensics/netscan.txt > /cases/Memory_Forensics/irc_connections.txt
```

---

## 🔐 Part 5: DLL Analysis (Optional)

If you found a suspicious PID, see what libraries it loaded:

```bash
# Example: If you found TrueCrypt at PID 3456
vol2 -f /evidence/memory.raw --profile=WinXPSP3x86 dlllist -p 3456 > /cases/Memory_Forensics/dlllist_3456.txt
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: vol2 -f /evidence/memory.raw --profile=WinXPSP3x86 dlllist -p 3456 > /cases/Memory_Forensics/dlllist_3456.txt
exit_code: 0
note: List DLLs loaded by PID 3456 (TrueCrypt)
```

---

## 🎯 Part 6: Search for Hidden Processes (Advanced)

Some malware "hides" by removing itself from the process list. Check for hidden processes:

```bash
vol2 -f /evidence/memory.raw --profile=WinXPSP3x86 psscan > /cases/Memory_Forensics/psscan.txt
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: vol2 -f /evidence/memory.raw --profile=WinXPSP3x86 psscan > /cases/Memory_Forensics/psscan.txt
exit_code: 0
note: Scan for all processes including hidden ones
```

Compare with pslist:

```bash
# Processes in psscan but NOT in pslist = hidden processes
diff <(grep "^0x" /cases/Memory_Forensics/pslist.txt) <(grep "^0x" /cases/Memory_Forensics/psscan.txt)
```

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
2. **Processes Found:**
   - Is TrueCrypt.exe present?
   - List any suspicious processes and their PIDs
3. **Network Activity:**
   - Are there IRC connections (port 6667/6668)?
   - To which IP addresses?
   - Which processes own these connections?
4. **Hidden Processes:**
   - Did you find any processes in psscan but NOT in pslist?
5. **Timeline:**
   - When was the memory dump captured?
   - Does this align with the known incident date?

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
   - Did you find TrueCrypt? Check Lab 1 for encrypted containers
   - Did you find IRC connections? Check Lab 5 network traffic
3. **Document findings in your report**
4. **Proceed to Autopsy_GUI (Lab 3)** when ready

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
