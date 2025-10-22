# Forensic Commands Quick Reference

This guide provides quick command examples for the Cloudcore 2009 investigation labs.

---

## 🚀 Getting Started: Enter the Forensic Workstation

### Starting Your Forensic Session

**On your laptop (host machine):**
```bash
# Build the forensic container (first time only)
docker compose build dfir

# Enter the forensic workstation
docker compose run --rm -it dfir
```

**You'll see the forensic lab banner, then you're inside the workstation:**
```
  ________________________________________________________________
 /                                                                \
|   DIGITAL FORENSICS & INCIDENT RESPONSE LABORATORY              |
|   Cloudcore 2009 Data Exfiltration Investigation               |
 \________________________________________________________________/

analyst@forensics-lab:/cases$
```

**Now you can run forensic commands directly** without the `docker compose run --rm dfir` prefix!

### Exiting Your Session

```bash
# When done with your analysis
exit
```

You're back on your laptop. Any files saved to `/cases/` inside the container are available in `./cases/` on your laptop.

---

## 📁 Chain of Custody

**Always hash evidence first** (run on host, not inside workstation):

```bash
# Basic hash
docker compose run --rm hashlog

# With custom note
COC_NOTE="Lab 1 intake by Student 12345" docker compose run --rm hashlog
```

Results are appended to `cases/chain_of_custody.csv`.

---

## 💾 Lab 1: Disk Forensics (Sleuth Kit)

**Enter workstation first:** `docker compose run --rm dfir`

### File System Analysis

```bash
# List all files (including deleted)
fls -r /evidence/disk.img

# List with full path mactime format
fls -r -m / /evidence/disk.img > USB_Imaging/fls.txt

# Display partition table
mmls /evidence/disk.img

# Show file system info
fsstat /evidence/disk.img

# Extract a specific file by inode
icat /evidence/disk.img 12345 > USB_Imaging/recovered_file.txt
```

### Deleted File Recovery

```bash
# Recover all allocated and unallocated files
mkdir -p USB_Imaging/tsk_recover_out
tsk_recover -a /evidence/disk.img USB_Imaging/tsk_recover_out

# View recovered files
ls -lah USB_Imaging/tsk_recover_out/
```

### File Carving (Foremost)

```bash
# Carve files by signature
mkdir -p USB_Imaging/foremost_out
foremost -i /evidence/disk.img -o USB_Imaging/foremost_out

# View carved files
ls -lah USB_Imaging/foremost_out/
```

### Metadata Extraction

```bash
# Extract EXIF metadata from recovered images
exiftool USB_Imaging/tsk_recover_out/*.jpg

# Recursive metadata extraction
exiftool -r USB_Imaging/foremost_out/ > USB_Imaging/metadata.txt
```

---

## 🧠 Lab 2: Memory Forensics (Volatility 3)

**Note:** Volatility runs in a separate container, so run these on your **host machine** (not inside workstation).

### Basic Memory Analysis

```bash
# Get system info
docker compose run --rm vol3 vol -f /evidence/memory.raw windows.info.Info

# List running processes
docker compose run --rm vol3 vol -f /evidence/memory.raw windows.pslist.PsList > cases/Memory_Forensics/vol_output/pslist.txt

# Process tree (parent-child relationships)
docker compose run --rm vol3 vol -f /evidence/memory.raw windows.pstree.PsTree > cases/Memory_Forensics/vol_output/pstree.txt

# Network connections
docker compose run --rm vol3 vol -f /evidence/memory.raw windows.netscan.NetScan > cases/Memory_Forensics/vol_output/netscan.txt
```

### Advanced Memory Analysis

```bash
# List DLLs for a specific process
docker compose run --rm vol3 vol -f /evidence/memory.raw windows.dlllist.DllList --pid 1234

# Scan for hidden processes
docker compose run --rm vol3 vol -f /evidence/memory.raw windows.psscan.PsScan

# Dump process memory
docker compose run --rm vol3 vol -f /evidence/memory.raw -o /cases/Memory_Forensics/vol_output windows.memmap.Memmap --pid 1234 --dump

# Command line arguments
docker compose run --rm vol3 vol -f /evidence/memory.raw windows.cmdline.CmdLine
```

### Analyzing Volatility Output

**Enter workstation to analyze results:**
```bash
docker compose run --rm -it dfir

# Search for suspicious process names
grep -i "truecrypt\|tor\|proxy" Memory_Forensics/vol_output/pslist.txt

# Find IRC connections (port 6667)
grep "6667" Memory_Forensics/vol_output/netscan.txt

# Extract process PIDs
awk '{print $1, $7}' Memory_Forensics/vol_output/pslist.txt | head -20
```

---

## 📊 Timeline Analysis (Plaso)

**Run on host machine:**

```bash
# Create timeline database
docker compose run --rm plaso log2timeline.py /cases/USB_Imaging/timeline.plaso /evidence/disk.img

# Export to CSV
docker compose run --rm plaso psort.py -o l2tcsv /cases/USB_Imaging/timeline.plaso > cases/USB_Imaging/timeline.csv

# Export to Excel-friendly format
docker compose run --rm plaso psort.py -o xlsx /cases/USB_Imaging/timeline.plaso -w /cases/USB_Imaging/timeline.xlsx

# Filter by date range
docker compose run --rm plaso psort.py -o l2tcsv /cases/USB_Imaging/timeline.plaso "date > '2009-10-01 00:00:00' AND date < '2009-10-31 23:59:59'" > cases/USB_Imaging/october_timeline.csv
```

---

## 🔍 Search & Pattern Matching

**Inside workstation:**

### grep Searches

```bash
# Case-insensitive search
grep -i "password" USB_Imaging/*.txt

# Recursive search in directory
grep -r "truecrypt" USB_Imaging/

# Show line numbers
grep -n "exfiltrat" USB_Imaging/triage_report.md

# Show context (3 lines before/after)
grep -C 3 "suspicious" USB_Imaging/fls.txt
```

### YARA Scanning

```bash
# Scan with specific rule
yara /rules/malware.yar /evidence/disk.img

# Recursive scan
yara -r /rules/malware.yar /evidence/

# Fast scan mode
yara -f /rules/malware.yar /evidence/memory.raw
```

### bulk_extractor

```bash
# Extract features (emails, URLs, credit cards, etc.)
bulk_extractor -o USB_Imaging/bulk_out /evidence/disk.img

# View extracted email addresses
cat USB_Imaging/bulk_out/email.txt

# View URLs
cat USB_Imaging/bulk_out/url.txt
```

---

## 🧮 Hashing & Verification

**Inside workstation:**

```bash
# SHA-256 hash
sha256sum /evidence/disk.img

# MD5 hash
md5sum /evidence/disk.img

# Multiple hashes at once
hashdeep -c sha256,md5 /evidence/disk.img

# Recursive hashing
hashdeep -r -c sha256 USB_Imaging/tsk_recover_out/ > USB_Imaging/recovered_hashes.txt

# Verify hashes
sha256sum -c USB_Imaging/hashes.txt
```

---

## 📝 Documentation & Reporting

**Inside workstation:**

```bash
# Create command history log
history > USB_Imaging/commands_executed.txt

# Document file listings
ls -lah USB_Imaging/tsk_recover_out/ > USB_Imaging/recovered_files_list.txt

# Create evidence manifest
find USB_Imaging -type f -exec sha256sum {} \; > USB_Imaging/evidence_manifest.txt

# Count files recovered
find USB_Imaging/tsk_recover_out/ -type f | wc -l
```

---

## 🛠️ Utilities

**Inside workstation:**

```bash
# View file type
file /evidence/disk.img

# View hex dump
xxd /evidence/disk.img | head -100

# Search for strings
strings /evidence/disk.img | grep "password"

# View text files with pagination
less USB_Imaging/fls.txt

# Edit reports
nano USB_Imaging/triage_report.md
vim USB_Imaging/triage_report.md

# Check disk space usage
du -sh USB_Imaging/*
```

---

## 🌐 Network Analysis (Lab 5)

**Network analysis uses Wireshark/tshark on your host machine** (not in container):

```bash
# Install tshark if needed
# macOS: brew install wireshark
# Linux: sudo apt install tshark

# Basic packet analysis
tshark -r evidence/network.cap

# Filter by protocol
tshark -r evidence/network.cap -Y "irc"
tshark -r evidence/network.cap -Y "http"

# Extract HTTP objects
tshark -r evidence/network.cap --export-objects http,Network_Analysis/http_objects

# Conversation statistics
tshark -r evidence/network.cap -q -z conv,ip
```

---

## 💡 Tips & Best Practices

### Working Efficiently

1. **Use tab completion** inside the workstation for file paths
2. **Command history** persists in `cases/.bash_history`
3. **Use `less` for viewing large files** (press `q` to quit)
4. **Redirect output to files** to preserve results: `command > output.txt`
5. **Use grep to filter** large outputs: `command | grep "pattern"`

### Common Workflows

**Typical Lab Session:**
```bash
# 1. Enter workstation
docker compose run --rm -it dfir

# 2. Create lab directory
mkdir -p Lab_X/output

# 3. Run analysis commands
fls -r /evidence/disk.img > Lab_X/fls.txt
grep -i "suspicious" Lab_X/fls.txt

# 4. Document findings
nano Lab_X/report.md

# 5. Exit
exit

# 6. Hash evidence (on host)
docker compose run --rm hashlog
```

### Troubleshooting

**Command not found?**
- Make sure you're inside the workstation: `docker compose run --rm dfir`
- Check spelling and use tab-completion

**Permission denied?**
- Evidence directory is read-only (by design)
- Write outputs to `/cases/` (which is writable)

**Output too long?**
- Pipe through `less`: `command | less`
- Redirect to file: `command > output.txt`
- Limit with `head`: `command | head -100`

**Container taking too long to start?**
- First run downloads images (can take 5-10 minutes)
- Subsequent runs are fast (1-2 seconds)

---

## 📚 Additional Resources

- **Sleuth Kit Wiki:** https://sleuthkit.org/sleuthkit/docs.php
- **Volatility 3 Docs:** https://volatility3.readthedocs.io/
- **YARA Rules:** https://github.com/Yara-Rules/rules
- **Plaso Guide:** https://plaso.readthedocs.io/

---

## 🆘 Getting Help

**Inside the workstation, use man pages and help:**
```bash
man fls
vol --help
yara --help
```

**For lab-specific guidance:**
- See each lab's `README.md` for step-by-step instructions
- See `WALKTHROUGH.md` files for detailed analysis guidance
- Check `TROUBLESHOOTING.md` for common issues

---

**Remember:** The forensic workstation is your safe space for analysis. Evidence is read-only, so experiment freely!
