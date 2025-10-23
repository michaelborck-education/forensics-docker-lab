# Autopsy_GUI Lab - Student Walkthrough
## Graphical Forensic Analysis

**Time Estimate:** 1-2 hours
**Difficulty:** Beginner
**Tools:** Autopsy GUI (web-based via noVNC), web browser

---

## 📸 Context: Graphical Analysis Tools in Forensic Practice

**Important Context:** In this lab, you're using **Autopsy**, a graphical forensic analysis tool that automates many tasks. This teaches you how professional investigators use GUI tools for faster analysis after disk images are captured.

### Autopsy in Real Forensic Practice

In a real investigation, a forensic technician would:

1. **After Disk Imaging:**
   - Image acquired (using Encase, FTK Imager, dd, etc. - see USB_Imaging context)
   - Chain of custody established
   - Image hashed and verified

2. **Load into Autopsy:**
   - Open the disk image in Autopsy GUI
   - Autopsy automatically:
     - Detects filesystem type (FAT32, NTFS, ext4, etc.)
     - Indexes all files and metadata
     - Runs keyword searches
     - Identifies file types and carves deleted data
     - Builds timeline of file modifications
   - Investigator searches for evidence through the GUI

3. **Why Autopsy?**
   - **Speed:** Automated analysis of thousands of files
   - **Visual:** Interactive GUI shows evidence clearly
   - **Correlation:** Links files, timelines, and metadata
   - **Scalability:** Can handle multi-TB disk images
   - **Reporting:** Generates professional reports for court

4. **Alternatives to Autopsy:**
   - **FTK (Forensic Toolkit)** (AccessData) - Premium, most comprehensive
   - **EnCase** (Guidance Software) - Industry standard, expensive
   - **X-Ways Forensics** - German tool, very powerful
   - **SANS SIFT/Sleuth Kit** - Command-line (what we used in USB_Imaging)
   - **OSForensics** - Budget-friendly option

### In This Lab

We're using **Autopsy** to:
- Load the USB disk image from USB_Imaging analysis
- Perform GUI-based evidence analysis
- Demonstrate how professionals accelerate investigations
- Show automated timeline and keyword features
- Correlate evidence across the filesystem

This lab teaches:
- How GUI tools complement command-line analysis
- Autopsy's powerful file indexing and searching
- Timeline analysis and metadata extraction
- When to use automated tools vs. manual analysis

---

## 📋 Pre-Lab Setup

### 1. Copy Templates to Your Lab Folder

```bash
cp templates/chain_of_custody.csv cases/Autopsy_GUI/chain_of_custody.csv
cp templates/analysis_log.csv cases/Autopsy_GUI/analysis_log.csv
```

### 2. Verify Evidence File

```bash
ls -lh evidence/usb.img
```

---

## 🚀 Connecting to the DFIR Workstation

**On macOS/Linux:**
```bash
./scripts/forensics-workstation
```

**On Windows (PowerShell):**
```powershell
.\scripts\forensics-workstation.bat
```

---

## 📦 Part 1: Chain of Custody

Hash the disk image:

```bash
sha256sum /evidence/usb.img
md5sum /evidence/usb.img
```

**📋 Document in chain_of_custody.csv:**
- Evidence_ID: USB-AUTOPSY-001
- SHA256_Hash: (paste hash)
- Analyst_Name: (your name)
- Evidence_Description: USB disk image for Autopsy GUI analysis

---

## 💻 Part 2: Launch Autopsy Web Interface

**Why this step:** Autopsy is a Java-based application that runs as a web server. We start it so you can access the graphical interface through your browser.

Autopsy provides a graphical interface for forensic analysis. Start it:

```bash
# Start Autopsy (runs on localhost:8888)
# This launches the Autopsy server on port 8888
autopsy
```

**What this command does:**
- Starts the Autopsy forensic framework
- Listens on localhost (127.0.0.1) port 8888
- Initializes the database for case management
- Waits for browser connection

**Expected output:**
```
Autopsy server starting...
Navigate to: http://localhost:8888
```

Once you see this, open a browser on your host machine and navigate to the URL.

---

## 🗂️ Part 3: Create a Case in Autopsy

**Why this step:** Every forensic investigation starts with a "case" that organizes evidence, analysis, and reports. Autopsy uses cases to manage multiple investigations.

In the Autopsy GUI (in your browser):

1. **Select "New Case"**
   - Creates a new investigation container
   - All evidence and analysis will be stored here

2. **Case Name:** USB_Evidence_Analysis
   - Descriptive name for this investigation

3. **Base Directory:** `/cases/Autopsy_GUI/`
   - Where Autopsy will store case files, databases, reports
   - Must be accessible to the Autopsy server

4. Click **Next**

**What happens:** Autopsy creates a case database and prepares to import evidence.

---

## 🔎 Part 4: Add Evidence (Disk Image Ingestion)

**Why this step:** This imports your forensic image into Autopsy's analysis system. Autopsy will:
- Parse the filesystem
- Index all files and metadata
- Run automated analysis modules
- Prepare for keyword searching and timeline analysis

In the Autopsy GUI:

1. **Click "Add Data Source"**
   - Tells Autopsy you want to add evidence to analyze

2. **Select "Disk Image or VM file"**
   - You're providing a raw disk image (not live system)
   - Autopsy will mount and analyze the image

3. **Browse to:** `/evidence/usb.img`
   - This is the USB image from USB_Imaging
   - Autopsy will read it in read-only mode (safe)

4. **Next** through prompts (use defaults)
   - Autopsy detects filesystem automatically (FAT32, NTFS, ext4)
   - Configures analysis options

5. **Ingest modules:** Select all available
   - Autopsy has multiple analysis engines:
     - **File type identification** - Determines file types
     - **Keyword searching** - Indexes all text for later searches
     - **Hash lookup** - Compares files against known bad hash databases
     - **Timeline analysis** - Builds chronological view of events
     - **Artifact parsing** - Extracts system artifacts (metadata, timestamps)
   - "Select all" ensures comprehensive analysis

6. **Finish** and wait for processing (~5-10 minutes)
   - Autopsy is now:
     - Reading every sector of the image
     - Cataloging all files
     - Extracting metadata
     - Carving deleted files
     - Building searchable index

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: Autopsy GUI - Created case and ingested /evidence/usb.img
exit_code: 0
note: Added disk image and ran all ingest modules
```

---

## 📊 Part 5: Analyze Evidence Through Autopsy GUI

**Why these steps:** Now that Autopsy has indexed the evidence, you'll use the GUI to explore and analyze it. The automated analysis reveals:
- What files exist (and were deleted)
- What data is suspicious (keyword matches)
- Timeline of events (when files were modified)
- Metadata that proves intent or malicious activity

Once processing completes, Autopsy shows multiple analysis views:

### Step 1: View File System

**Why:** Explore the actual filesystem structure to understand the drive layout and spot suspicious files.

1. Click **"Data Sources"** → **"usb.img"**
   - Autopsy shows the complete filesystem hierarchy
   - You see all active AND deleted files (with [Deleted] marker)

2. Explore the directory tree
   - Navigate through folders like a normal file browser
   - Look for suspicious folder names or file locations
   - Examples: /evidence/, /mnt/, suspicious naming patterns

3. Look for suspicious files and deleted entries
   - Files with names like: `secret*`, `project*`, `flag*`
   - Look for archive files: `.zip`, `.rar`, `.tar`
   - Check for deleted files (marked with asterisk or note)

4. Take notes on interesting findings
   - Document suspicious files you find
   - Note file paths and sizes
   - Example: "/home/alex/Documents/project_secrets.txt [Deleted]"

### Step 2: Keyword Search

**Why:** Automated keyword search finds evidence across the entire image, even in deleted/unallocated space. This is much faster than manual browsing.

1. Click **"Tools"** → **"Keyword Search"**
   - Opens the keyword search interface
   - Searches the entire indexed content
   - Results show context around keyword matches

2. Enter keywords: `password`, `confidential`, `secret`
   - These are common in data theft evidence
   - Autopsy will find these words anywhere in the image
   - Add more keywords as needed: `flag`, `exfil`, `backup`

3. Review results
   - Autopsy shows each match with context
   - See which files contain sensitive keywords
   - Note frequencies (one mention vs. repeated mentions)

**Example findings:** If you see 5 matches for "secret" all in one file, that's more suspicious than scattered matches.

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: Autopsy GUI - Keyword search for password, confidential, secret
exit_code: 0
note: AUTOMATED SEARCH - Found X matches for sensitive keywords. Top findings: project_secrets.txt (5 matches), email_draft.txt (2 matches)
```

### Step 3: View Timeline

**Why:** Timeline analysis shows WHEN activity occurred. Attackers often work in bursts - mass file creation before deletion, suspicious activity at specific times. This temporal pattern proves intent.

1. Click **"Tools"** → **"Timeline"**
   - Autopsy displays all file events chronologically
   - Shows: File creation, modification, deletion
   - Color-coded: Green=created, Blue=modified, Red=deleted

2. Analyze file creation/modification dates
   - Suspicious activity often happens at odd hours
   - Mass operations (many files modified/deleted at same time) = deliberate
   - Legitimate users create/modify files gradually over time

3. Look for patterns (mass creation/deletion at specific times)
   - **Pattern 1:** Many files created same day, deleted next day = staging & cleanup
   - **Pattern 2:** All modifications at 2am = automated/unattended access
   - **Pattern 3:** Files on USB modified same time as email sent = staging before exfiltration

### Step 4: Analyze Extracted Artifacts

**Why:** Autopsy automatically extracts and parses artifacts (metadata, embedded data, deleted file headers). This reveals evidence even in fragments.

1. Click **"Results"** → **"Extracted Content"**
   - Shows recovered files and data Autopsy found
   - Includes partial/deleted files recovered by carving
   - Organizes by file type

2. Browse recovered artifacts (emails, documents, images)
   - Look for actual file content
   - Check file sizes and timestamps
   - Deleted files are clearly marked

3. Review metadata
   - File creation/modification dates
   - Author information (if embedded)
   - Version history
   - Geographic location (if images with EXIF)

**📋 Document findings:**
- Number of files analyzed
- Suspicious files discovered
- Timeline patterns observed
- Key artifacts recovered

---

## 🖼️ Part 6: Generate Reports

**Why this step:** Forensic reports are essential for legal proceedings. Autopsy generates professional reports that document all findings, analysis steps, and evidence, making them suitable for court presentation. The report becomes the official record of your investigation.

Autopsy can export professional reports in multiple formats:

1. **Click Tools** → **"Generate Report"**
   - Autopsy bundles all case data, analysis results, and artifacts into a single document
   - This ensures nothing is missed and all findings are documented systematically

2. **Select format:**
   - **HTML:** Interactive, searchable, includes images and file previews
   - **PDF:** Static, print-friendly, better for email and archiving
   - Most labs use HTML for completeness, PDF for submission

3. **Output location:** `/cases/Autopsy_GUI/`
   - Report is saved in your case directory alongside other analysis files
   - Accessible outside Autopsy once generated

4. **Generate** (takes 2-5 minutes)
   - Autopsy is compiling:
     - All files discovered
     - Timeline events
     - Keyword search results
     - Artifact extractions
     - Metadata summaries
     - Analysis summary
   - Report size depends on evidence volume

**What the report contains:**
- Executive summary (files found, results overview)
- Detailed file listing (name, size, timestamps, deleted status)
- Timeline analysis (all activities chronologically)
- Keyword search results with context
- Extracted artifacts (emails, documents, images)
- Hash database hits
- Investigation notes

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: Autopsy GUI - Generated case report (HTML format)
exit_code: 0
note: Report contains complete summary of all findings - total files analyzed, deleted files recovered, keyword search hits, timeline analysis
```

---

## 📁 Part 7: Compare with CLI Findings

**Why this step:** In real investigations, comparing results across different tools validates findings. If CLI and GUI analysis show the same evidence, your conclusion is stronger. Discrepancies might reveal new findings or tool limitations.

In forensic practice:
- **CLI tools** (fls, icat, strings) show raw filesystem data, require manual interpretation
- **GUI tools** (Autopsy) automate the process, easier to navigate but can miss edge cases
- **Best practice:** Use both for validation and completeness

Compare your Autopsy results with USB_Imaging (CLI analysis):

1. **Open CLI outputs from USB_Imaging:**
   - Navigate to: `cases/USB_Imaging/`
   - Review files created in USB_Imaging analysis:
     - `deleted_files.txt` - Files recovered with icat
     - `filesystem_structure.txt` - Directory listing with fls
     - `keyword_search.txt` - Manual grep results

2. **Comparison matrix:**
   - **Total files:** Count from `fls` output vs. Autopsy summary
     - Should be nearly identical (minor differences acceptable due to method)
     - Large differences suggest missed evidence or misconfiguration

   - **Deleted files:**
     - USB_Imaging recovered: `project_secrets.txt`, `email_draft.txt`, `flag_backup.txt`, etc.
     - Autopsy should show same files marked as [Deleted] in timeline
     - If Autopsy misses deleted files, its ingest modules may not have completed

   - **Keywords found:**
     - USB_Imaging: `password`, `confidential`, `secret` matches in files
     - Autopsy: Same keywords should appear in search results
     - Compare context around matches (same file, same line)

3. **Expected similarities:**
   ```
   COMPARISON RESULTS

   Deleted files recovered:
   - USB_Imaging (CLI):  4 files via icat
   - Autopsy GUI:  4 files in timeline [Deleted] marker
   - MATCH: ✓ Yes

   Keyword search "password":
   - USB_Imaging (CLI):  Found in project_secrets.txt, email_draft.txt
   - Autopsy GUI:  Same files, Autopsy adds additional context
   - MATCH: ✓ Yes

   Timeline analysis:
   - USB_Imaging (CLI):  Timestamps from istat output
   - Autopsy GUI:  Visual timeline showing color-coded events
   - MATCH: ✓ Yes, same timestamps, easier visualization in GUI
   ```

4. **Document in your summary:**
   - List files found in both methods
   - Note any discrepancies (and why they might exist)
   - Confirm Autopsy validated CLI findings
   - Document if Autopsy discovered additional evidence

**Key insight:** If both methods find the same evidence, you can be confident in your analysis. If they differ, investigate why - it might reveal important details.

---

## 🚪 Part 8: Exit the Workstation

**Why this step:** Properly closing the workstation ensures all data is written to disk and the forensic environment is cleanly shut down. This is important for documentation - you want to record the exact time analysis was completed.

```bash
# Close Autopsy (File → Close case in the GUI first)
# Then exit the workstation
exit
```

**What happens:**
- Autopsy saves any pending data to the case database
- All analysis results are finalized
- Case directory is safely closed
- DFIR workstation container stops
- Back at your host machine prompt

---

## ✅ Deliverables

You should have created in `cases/Autopsy_GUI/`:

- ✅ `chain_of_custody.csv` - Evidence hash (documented at lab start)
- ✅ `analysis_log.csv` - All commands documented with timestamps
- ✅ `[CaseName]/` - Autopsy case directory (created during analysis)
  - Contains: Case database, ingest results, extracted artifacts
- ✅ HTML or PDF report from Autopsy (generated in Part 6)
- ✅ Optionally: Screenshots or notes from GUI analysis

**How to verify deliverables:**
```bash
# From your host machine (outside the workstation):
ls -lh cases/Autopsy_GUI/

# Should show:
# - chain_of_custody.csv
# - analysis_log.csv
# - USB_Evidence_Analysis/ (or your case name)
# - Report_[date].html or .pdf
```

---

## 📊 Analysis Summary

Document your complete findings in a summary file. This becomes your official report:

1. **Total files analyzed:**
   - Count from Autopsy summary
   - Compare with USB_Imaging fls output
   - Should match or be very close

2. **Deleted files found:**
   - Count from Autopsy timeline
   - Compare with USB_Imaging icat recovery
   - Document file names, sizes, timestamps

3. **Suspicious keywords:**
   - List keywords searched
   - Show hits and context
   - Highest priority matches

4. **Timeline anomalies:**
   - Files created at odd times
   - Mass modifications/deletions (staging/cleanup patterns)
   - Correlation with other suspicious activity

5. **Key artifacts:**
   - Most important recovered items
   - Evidence of intent or wrongdoing
   - Direct proof points

6. **Comparison to USB_Imaging:**
   - What did CLI find that GUI missed (or vice versa)?
   - Did both tools validate each other?
   - Any surprising differences?

**Example summary:**
```
AUTOPSY_GUI LAB FINDINGS

Total Files: 247 files analyzed
- Deleted files: 4 (recovered by Autopsy)
- Archive files: 1 (.zip backup)

Keyword Matches:
- "password": 3 files (project_secrets.txt, config.ini, email_draft.txt)
- "secret": 5 matches (all in project_secrets.txt)
- "confidential": 2 matches (email_draft.txt)

Timeline Findings:
- 2009-11-20: project_secrets.txt created (9 AM)
- 2009-12-07: Multiple files deleted (10 PM) - possible cleanup
- 2009-12-08: USB accessed after deletion

Validated by USB_Imaging?: YES
- Same deleted files recovered in both CLI and GUI
- Keyword search matches CLI grep results
- Timeline timestamps match istat output

Conclusion: GUI analysis confirms CLI findings and provides easier visualization
```

---

## 🆘 Troubleshooting

### "Cannot connect to Autopsy"
**Problem:** Browser says "Connection refused" or "Cannot reach localhost:8888"

**Solutions:**
- Verify Autopsy is still running in the container (check terminal for errors)
- Ensure you're using the correct URL: `http://localhost:8888` (not https://)
- Check that port 8888 is not blocked by firewall
- Try different browser (Chrome/Firefox have best Autopsy compatibility)
- Restart Autopsy: Kill it with Ctrl+C, run `autopsy` again

### "Processing taking too long"
**Problem:** Ingest has been running for >30 minutes

**What's happening:**
- Autopsy is indexing every file in the image
- With 250+ files and multiple analysis modules, this can take 30+ minutes
- This is normal for large disks - patience required

**Solutions:**
- **Wait longer:** Processing can take 30-60 minutes for medium disks
- **Don't close the browser tab:** This terminates Autopsy processing
- **Monitor progress:** Check Autopsy GUI for "Ingest running" indicator
- **Check CPU:** Watch system resources (Activity Monitor on Mac) - if idle, restart

### "Case files not saving" / "Permission denied" errors
**Problem:** Autopsy shows error when saving case or generating report

**Solutions:**
- Verify directory exists: `ls -la /cases/Autopsy_GUI/`
- Check permissions: Should be writable by Autopsy user
- On Linux: Ensure case directory is not read-only
- Restart Autopsy if needed (close case → exit → rerun `autopsy`)
- Check available disk space: `df -h /cases/`

### "Keyword search finds nothing"
**Problem:** No results for keywords that should definitely exist

**Solutions:**
- Verify ingest completed fully (check "Ingest running" status)
- Try different keywords (shorter terms often work better)
- Check if files are in indexed data sources (Part 4 step 5 should select all modules)
- Restart keyword search engine or Autopsy

---

## 📚 Next Steps

After this lab:

1. **Review your findings:** Did Autopsy find the expected evidence?
2. **Compare with USB_Imaging:** Do GUI results match CLI analysis?
3. **Document discrepancies:** If findings differ, why? (tool limitation vs. new discovery)
4. **Prepare report:** Compile summary of all findings for presentation
5. **Proceed to Email_Logs:** When ready, move on to Email analysis

**Key question:** Did GUI analysis reveal anything CLI missed? This validates your methodology.

---

## 📝 Summary - GUI Workflow

```bash
# INSIDE the forensics workstation:

# ========== PRE-ANALYSIS ==========
# Hash the evidence
sha256sum /evidence/usb.img

# ========== LAUNCH TOOL ==========
# Start Autopsy server
autopsy

# ========== IN YOUR BROWSER ==========
# Navigate to: http://localhost:8888
# 1. Create case: USB_Evidence_Analysis
# 2. Add data source: /evidence/usb.img
# 3. Run ingest: Select all modules
# 4. Analyze: Browse files, search keywords, view timeline
# 5. Generate: Export HTML/PDF report

# ========== CLEANUP ==========
# Close case in Autopsy (File → Close case)
# Exit workstation
exit
```

**Workflow time:** 2-3 hours total (1 hour prep/ingest, 1-2 hours analysis)

---

## 🔄 Forensic Analysis Methodology

**Why this lab exists:**

This lab teaches you how professional investigators use GUI tools. In real practice:

1. **First pass (Triage):** Quick scan with automated tools to identify evidence
   - *This is what you did with Autopsy*
   - Fast, covers everything, good for overview

2. **Deep dive (Detailed Analysis):** Manual examination of suspicious files
   - Use CLI tools for precise analysis
   - Extract file content, examine metadata
   - Compare multiple evidence sources

3. **Validation (Cross-verification):** Compare findings across tools
   - *This is what USB_Imaging (CLI) vs Autopsy_GUI (GUI) does*
   - If both find the same evidence = high confidence
   - If they differ = investigate discrepancy

4. **Reporting (Documentation):** Professional report for court
   - Autopsy's report handles this automatically
   - Shows methodology, findings, and evidence
   - Suitable for legal proceedings

**Key insight:** No single tool finds everything. Use multiple tools, compare results, and validate findings!

---

**Remember:** Autopsy is powerful, but it's not a magic bullet. Always validate automated results with manual analysis and cross-reference with other evidence sources. The combination of CLI analysis (USB_Imaging) and GUI analysis (Autopsy_GUI) gives you the complete picture.
