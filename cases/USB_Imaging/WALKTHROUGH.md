# USB_Imaging Lab - Student Walkthrough
## Evidence Triage & Deleted File Recovery

**Time Estimate:** 2-3 hours
**Difficulty:** Beginner
**Tools:** Sleuth Kit (fls, icat, fsstat), ewf-tools, strings, grep

---

## 📋 Pre-Lab Setup

### 1. Copy Templates to Your Lab Folder

Before starting, copy the CSV templates to your lab folder so you can track evidence and commands:

```bash
# On your host machine (outside the container)
cp templates/chain_of_custody.csv cases/USB_Imaging/chain_of_custody.csv
cp templates/analysis_log.csv cases/USB_Imaging/analysis_log.csv
```

**These files will store:**
- **chain_of_custody.csv**: Evidence hashes (MD5, SHA256) for integrity verification
- **analysis_log.csv**: Every command you run and when you ran it

Keep these files open on your host machine so you can copy-paste entries as you work.

### 2. Verify Your Evidence File

Check that the USB image exists:

```bash
# On your host machine
ls -lh evidence/
```

You should see `usb.E01` (Encase Evidence File format, ~100-800 MB).

**Note:** If you see `usb.img` instead, the analysis process is the same - just substitute `usb.E01` in the commands below.

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

**Inside the workstation, all commands work the same as standard Linux - NO Docker prefixes needed.**

---

## 📦 Part 1: Chain of Custody - Verify Evidence Integrity

**CRITICAL:** Before analyzing ANY evidence, you must calculate and document hash values. This proves the evidence hasn't been tampered with.

### Step 1: Calculate MD5 Hash

```bash
md5sum /evidence/usb.E01
```

**Example Output:**
```
6a4ae5319e4c1757793dec70d5746703  /evidence/usb.E01
```

**📋 Document in cases/USB_Imaging/chain_of_custody.csv:**
- Evidence_ID: USB-001
- MD5_Hash: (paste the hash from above)
- SHA256_Hash: (you'll add this next)
- Analyst_Name: (your name)
- Date_Received: (today's date)

### Step 2: Calculate SHA256 Hash

```bash
sha256sum /evidence/usb.E01
```

**Example Output:**
```
49a0bc914cc6f02bdb96e20c1081755ddb5ee7a653e60f088b6d680e07f722b2  /evidence/usb.E01
```

**📋 Update chain_of_custody.csv:**
- Add the SHA256_Hash value above

---

## 💾 Part 2: Mount the Evidence Image

E01/IMG files are compressed forensic formats. We need to "mount" them to access the files inside.

### Step 1: Create Mount Point

```bash
mkdir -p /tmp/ewf
```

### Step 2: Mount the E01 File

```bash
ewfmount /evidence/usb.E01 /tmp/ewf
```

**No output = success!** Verify it worked:

```bash
ls -lh /tmp/ewf/
```

You should see `ewf1` (the virtual raw disk image) with size ~100M.

**✅ Expected Output:**
```
total 0
-r--r--r-- 1 root root 100M Oct 23 21:55 ewf1
```

**⚠️ IMPORTANT:** From now on, ALL commands use `/tmp/ewf/ewf1`, NOT the original image file.

---

## 🗂️ Part 3: Analyze File System Structure

**Why this step matters:**
Before we can list files, we need to understand the filesystem structure. Is it FAT32? NTFS? What's the cluster size? These details affect how we recover deleted files and interpret timestamps. We also check if the drive has multiple partitions - some USB drives have hidden recovery partitions.

**How we know to do this:**
Forensic investigators follow a systematic approach: understand the storage layout → find files → recover deleted data. Skipping filesystem analysis means missing important details about how data was stored and deleted.

### Step 1: Get File System Information

```bash
fsstat /tmp/ewf/ewf1 > /cases/USB_Imaging/filesystem_info.txt
```

**What this tells us:**
- **File System Type:** FAT32, NTFS, exFAT, etc.
- **Volume Label:** Name of the USB drive
- **Cluster Size:** How data is grouped (important for recovery)
- **Free Space:** Was the drive nearly full? (suggests rapid deletion)
- **FAT (File Allocation Table):** Maps which clusters contain which files

**Example from our evidence:**
```
File System Type: FAT32
Volume Label: PRACTICE
Cluster Size: 512
Free Sector Count: 201538
```

This tells us:
- Simple FAT32 filesystem (older, simpler to analyze)
- Drive was labeled "PRACTICE" (for training?)
- Lots of free space available (~100MB free out of 200MB total)
- Deleted files can likely be recovered

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: fsstat /tmp/ewf/ewf1 > /cases/USB_Imaging/filesystem_info.txt
exit_code: 0
note: Get file system information (type, size, cluster info) - Found FAT32 drive labeled 'PRACTICE'
```

### Step 2: Check Partition Table

```bash
mmls /tmp/ewf/ewf1 > /cases/USB_Imaging/partition_table.txt
```

**What this tells us:**
The `mmls` command analyzes the Master Boot Record (MBR) and partition table. Professional USB drives might have:
- Multiple partitions (data + recovery)
- Hidden partitions (for firmware)
- No partition table (raw FAT32, common on simple USB drives)

**Why we run it:**
An experienced investigator doesn't assume - they verify. We run mmls to:
1. Confirm there's only ONE filesystem (not multiple partitions)
2. Document what we found for the investigation report
3. Ensure we're not missing hidden partitions with deleted data

**Expected output for simple USB drives:**
```
Cannot determine partition type
```

**This is NORMAL and EXPECTED** - it means the drive is formatted directly as FAT32 with no partition table. This is actually good for us - simpler to analyze, fewer places to hide data.

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: mmls /tmp/ewf/ewf1 > /cases/USB_Imaging/partition_table.txt
exit_code: 0
note: Check partition table - Result: No partition table (simple FAT32 USB drive, no hidden partitions)
```

**Review what you found:**
```bash
cat /cases/USB_Imaging/partition_table.txt
cat /cases/USB_Imaging/filesystem_info.txt
```

**Key Questions to Ask:**
- How much free space is on the drive?
- Were files deleted recently (high free space = yes)?
- Is the filesystem FAT32 or something else?
- Are there multiple partitions?

---

## 📂 Part 4: List All Files (Including Deleted)

**Why this step matters:**
This is the MOST IMPORTANT step in USB forensics. Suspects delete files thinking they're gone, but FAT32 doesn't actually erase the data - it just marks the clusters as "free". The `fls` command reads the FAT and recovers the references to deleted files BEFORE we even recover the data. This tells us:
1. What files were on the drive (including deleted ones)
2. Their original locations and timestamps
3. How recently they were deleted (fragmentation level)
4. Which files are worth recovering in detail

**How we know to do this:**
Digital forensics principle: **"A deleted file is just a file with a deleted directory entry."** The actual file data stays on disk until overwritten. By reading the filesystem tables, we can list deleted files before attempting data recovery.

### Step 1: List All Files (Active and Deleted)

```bash
fls -r -d /tmp/ewf/ewf1 > /cases/USB_Imaging/file_list.txt
```

**What the flags do:**
- `-r`: recursive (scan all subdirectories)
- `-d`: show deleted files (marked with `*` in the output)

**Understanding the output format:**
```
d/d 3:  Documents/
+ r/r 4: Documents/project.xlsx (recovered)
- r/r 5: Documents/secret.txt (DELETED - marked with -)
```
- `d/d`: directory
- `r/r`: regular file
- `+`: allocated (active file)
- `-`: unallocated (DELETED file) ← These are what we're hunting for!

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: fls -r -d /tmp/ewf/ewf1 > /cases/USB_Imaging/file_list.txt
exit_code: 0
note: List all files (active and deleted). The '-' prefix indicates deleted files.
```

### Step 2: Extract Just the Deleted Files

**Why separate them:**
It's easier to analyze if we create a focused list of ONLY the deleted files. These are the suspicious ones.

```bash
grep "\* " /cases/USB_Imaging/file_list.txt > /cases/USB_Imaging/deleted_files.txt
```

**What this does:**
The grep command searches for lines starting with `*` (or containing `* ` in fls output), which marks deleted entries. We save these to a separate file for analysis.

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: grep "\* " /cases/USB_Imaging/file_list.txt > /cases/USB_Imaging/deleted_files.txt
exit_code: 0
note: Extract deleted files for focused analysis. Patterns suggest intentional deletion.
```

Review the deleted files:
```bash
cat /cases/USB_Imaging/deleted_files.txt
wc -l /cases/USB_Imaging/deleted_files.txt  # Count deleted files
```

**Forensic Analysis - What to look for:**
Files that are INTENTIONALLY deleted (vs. accidental) often follow patterns:
- **Data files:** `.xlsx`, `.csv`, `.json`, `.xml` - Why delete financial/project data?
- **Documents:** `.txt`, `.docx`, `.pdf` - Confidential information?
- **Databases:** `.db`, `.pst`, `.sqlite` - Customer records? Secrets?
- **Archives:** `.zip`, `.rar`, `.tar` - Bundled data for exfiltration?
- **Executables:** `.exe`, `.bat`, `.sh` - Malware? Tools?
- **Scripts:** `.py`, `.ps1`, `.vbs` - Automation for theft/vandalism?

**Red Flags for Investigation:**
- Deleted files grouped by type (e.g., all .xlsx files deleted)
- Large archive files (.zip) deleted
- Multiple files deleted at same timestamp (mass deletion = cover-up?)

---

## 📤 Part 5: Recover Deleted Files

### Step 1: Bulk Recovery

```bash
mkdir -p /cases/USB_Imaging/recovered
tsk_recover /tmp/ewf/ewf1 /cases/USB_Imaging/recovered
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: tsk_recover /tmp/ewf/ewf1 /cases/USB_Imaging/recovered
exit_code: 0
note: Bulk recover all files (active and deleted) to recovered/ folder
```

### Step 2: Explore Recovered Files

```bash
ls -R /cases/USB_Imaging/recovered | head -50
```

**⚠️ CAUTION:** In real forensics, be VERY careful opening recovered files - they might contain malware. Use `strings` and `grep` for safe text extraction:

```bash
# List all text strings from a file (safe)
strings /cases/USB_Imaging/recovered/suspicious_file.exe

# Search for keywords in text files
grep -i "password" /cases/USB_Imaging/recovered/*.txt
```

---

## 🔍 Part 6: Keyword Searching

Search the entire image for keywords related to your case.

### Step 1: Search the Raw Image

```bash
strings /tmp/ewf/ewf1 | grep -iE "password|confidential|client|admin" > /cases/USB_Imaging/keyword_search.txt
```

**Flags:**
- `-i`: case-insensitive search
- `-E`: extended regex (allows `|` for OR)

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: strings /tmp/ewf/ewf1 | grep -iE "password|confidential|client|admin" > /cases/USB_Imaging/keyword_search.txt
exit_code: 0
note: Search entire image for sensitive keywords
```

### Step 2: Count Results

```bash
wc -l /cases/USB_Imaging/keyword_search.txt
```

How many hits did you find? Large numbers might indicate significant evidence.

### Step 3: Review Results

```bash
head -20 /cases/USB_Imaging/keyword_search.txt
```

---

## 🚪 Part 7: Exit the Workstation

When done, exit the forensic environment:

```bash
exit
```

You're back on your host machine.

---

## ✅ Deliverables for This Lab

When you exit the container, you should have created these files in `cases/USB_Imaging/`:

**CSV Files (Documentation):**
- ✅ `chain_of_custody.csv` - Evidence hashes and integrity verification
- ✅ `analysis_log.csv` - Commands executed with timestamps

**Evidence Files (from analysis):**
- ✅ `filesystem_info.txt` - File system details
- ✅ `partition_table.txt` - Partition information
- ✅ `file_list.txt` - All files (active + deleted)
- ✅ `deleted_files.txt` - Just the deleted files
- ✅ `keyword_search.txt` - Keyword search results
- ✅ `recovered/` - Directory with all recovered files

---

## 📊 Analysis Summary

Before moving to the next lab, answer these questions in your lab notes:

1. **How many files total?** (run `wc -l file_list.txt`)
2. **How many deleted files?** (run `wc -l deleted_files.txt`)
3. **What file types did you find?** (xlsx, csv, docx, etc.)
4. **Most suspicious finding?** (what's the strongest evidence?)
5. **Timeline clues:** (any dates visible in filenames?)

---

## 🆘 Troubleshooting

### "ewf1 not found"
- Verify ewfmount succeeded: `ls -lh /tmp/ewf/`
- Re-run ewfmount command
- Check the path is exactly `/tmp/ewf` not `/tmp/ewf/`

### "fls: cannot open image"
- You're probably using the E01 path instead of `/tmp/ewf/ewf1`
- Must run ewfmount first!
- Check your command uses `/tmp/ewf/ewf1`

### "No deleted files found"
- Make sure you used both flags: `fls -r -d`
- The `-d` flag is required to show deleted files

### "Permission denied"
- Make sure you're inside the forensic workstation
- Check your prompt ends with `#` (you're at bash prompt)

---

## 📚 Next Steps

After completing this lab:

1. **Analyze the recovered files** in detail
2. **Calculate hashes** of key recovered files
3. **Document your findings** in your lab report
4. **Proceed to Memory_Forensics** (Lab 2) when ready

The evidence you recovered here will be referenced in later labs!

---

## 📝 Summary - Quick Command Reference

```bash
# INSIDE the workstation:

# Hash verification
md5sum /evidence/usb.E01
sha256sum /evidence/usb.E01

# Mount E01 evidence file
mkdir -p /tmp/ewf
ewfmount /evidence/usb.E01 /tmp/ewf

# Verify mount succeeded
ls -lh /tmp/ewf/ewf1

# File system analysis
fsstat /tmp/ewf/ewf1 > /cases/USB_Imaging/filesystem_info.txt

# List files (all + deleted)
fls -r -d /tmp/ewf/ewf1 > /cases/USB_Imaging/file_list.txt

# Extract deleted file list
grep "\* " /cases/USB_Imaging/file_list.txt > /cases/USB_Imaging/deleted_files.txt

# Recover files
mkdir -p /cases/USB_Imaging/recovered
tsk_recover /tmp/ewf/ewf1 /cases/USB_Imaging/recovered

# Keyword search
strings /tmp/ewf/ewf1 | grep -i "keyword" > /cases/USB_Imaging/keyword_search.txt

# Exit workstation
exit
```

---

**Remember:** Chain of custody is critical. Document EVERYTHING!
