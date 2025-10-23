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

## 🗂️ Part 3: Analyze File System

### Step 1: Get File System Information

```bash
fsstat /tmp/ewf/ewf1 > /cases/USB_Imaging/filesystem_info.txt
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: 2024-10-23T14:32:15Z
analyst: [Your Name]
command: fsstat /tmp/ewf/ewf1 > /cases/USB_Imaging/filesystem_info.txt
exit_code: 0
note: Get file system information (type, size, cluster info)
```

To get the timestamp, run:
```bash
date -u
```

### Step 2: Check Partition Table (Optional)

```bash
mmls /tmp/ewf/ewf1
```

**⚠️ Note for FAT32 USB Drives:**
USB flash drives typically don't have partition tables - they're formatted directly as FAT32. If you see:
```
Cannot determine partition type
```

This is **normal and expected**. The fsstat output already told us it's FAT32 formatted.

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: fsstat /tmp/ewf/ewf1 > /cases/USB_Imaging/filesystem_info.txt
exit_code: 0
note: Get file system information (type, size, cluster info)
```

---

## 📂 Part 4: List All Files (Including Deleted)

This is the most important step. The `fls` command lists ALL files, including ones the suspect tried to delete.

### Step 1: List All Files

```bash
fls -r -d /tmp/ewf/ewf1 > /cases/USB_Imaging/file_list.txt
```

**Flags:**
- `-r`: recursive (all subdirectories)
- `-d`: show deleted files (marked with `*`)

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: fls -r -d /tmp/ewf/ewf1 > /cases/USB_Imaging/file_list.txt
exit_code: 0
note: List all files including deleted files
```

### Step 2: Extract Just the Deleted Files

```bash
grep "\* " /cases/USB_Imaging/file_list.txt > /cases/USB_Imaging/deleted_files.txt
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: grep "\* " /cases/USB_Imaging/file_list.txt > /cases/USB_Imaging/deleted_files.txt
exit_code: 0
note: Extract list of deleted files for easier review
```

Review the deleted files:
```bash
cat /cases/USB_Imaging/deleted_files.txt
```

**💡 TIP:** Look for file types that might contain sensitive data:
- `.xlsx`, `.csv`, `.json` - data files
- `.txt`, `.docx` - documents
- `.db`, `.pst` - databases/email

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
