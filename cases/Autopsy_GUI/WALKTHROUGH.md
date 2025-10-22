# Lab 3: GUI Forensics with Autopsy - Complete Walkthrough

## Overview

This lab teaches you to analyze forensic evidence using the **Autopsy GUI platform** accessed through a web-based noVNC session. You'll investigate the same disk image from Lab 1, but this time using a graphical interface that provides visualization, timeline analysis, and automated artifact extraction.

**Time Estimate:** 75 minutes
**Difficulty:** Beginner to Intermediate
**Tools:** Docker, noVNC, Autopsy 4, browser (Chrome/Firefox recommended)

---

## Case Context

This lab represents **Phase 3** of the Cloudcore investigation (December 5, 2009, afternoon). After the initial disk imaging (Lab 1) and memory analysis (Lab 2), you'll now use Autopsy's GUI capabilities to:

- Visualize the complete file system structure
- Perform keyword searches across the entire disk
- Analyze metadata and timestamps
- Generate professional reports for stakeholders
- Compare GUI findings with your CLI results from previous labs

The disk image (`/evidence/disk.img`) contains evidence of file staging, deletion attempts, and suspicious activity that complements the TrueCrypt findings from Lab 2.

---

## Prerequisites Checklist

Before starting, ensure:

- [ ] Docker and Docker Compose are installed and running
- [ ] You've completed Labs 1-2 or understand the case context
- [ ] Evidence files are in place: `evidence/disk.img` exists
- [ ] You've read `STORYLINE.md` for case background
- [ ] Docker toolbox image is built: `docker compose build dfir`
- [ ] Chain of custody CSV exists: `cases/chain_of_custody.csv`
- [ ] Modern web browser available (Chrome/Firefox recommended over Safari)

**Test your setup:**
```bash
# Verify Docker is running
docker compose ps

# Verify evidence file exists
ls -lh evidence/disk.img

# Test browser compatibility (important for noVNC)
# Chrome/Firefox work best, Safari may have issues
```

---

## Lab Setup

### 1. Start Required Docker Services

```bash
docker compose up -d novnc autopsy
```

**Expected Output:**
```
[+] Running 2/2
 ✔ Container forensic-lab-novnc-1  Started
 ✔ Container forensic-lab-autopsy-1  Started
```

**Verify services are running:**
```bash
docker compose ps
```

You should see both `novnc` and `autopsy` containers marked as "Up".

### 2. Access the noVNC Web Interface

Open your web browser and navigate to:
```
http://localhost:8080/vnc.html
```

**Troubleshooting:**
- If blank screen: Refresh the page and wait 10-15 seconds
- If "connection refused": Check `docker compose ps` to ensure containers are running
- Safari users: Switch to Chrome/Firefox if possible

**Expected View:**
- A Linux desktop interface should load in your browser
- You should see a desktop with icons and a taskbar

### 3. Launch Autopsy from the Desktop

In the noVNC window:
1. Look for the Autopsy icon on the desktop
2. Double-click to launch Autopsy
3. Alternatively, find it in the applications menu

**Expected:** Autopsy should open with a welcome screen showing "Create New Case" and "Open Case" options.

---

## Step-by-Step Analysis

### Step 1: Create a New Autopsy Case

1. **Click "Create New Case"**
2. **Fill in case details:**
   - **Case Name:** `Lab3_<YourName>` (replace with your actual name)
   - **Base Directory:** `/cases/Autopsy_GUI/autopsy_case`
   - **Case Number:** `LAB3-001`
   - **Examiner:** Your name
   - **Description:** `Cloudcore investigation - Phase 3 GUI analysis`

3. **Click "Finish"** to create the case

**What to expect:**
- Autopsy will create the case directory structure
- You'll see the main case interface with "Add Data" button

### Step 2: Add the Disk Image Evidence

1. **Click "Add Data"**
2. **Select "Disk Image or VM File"**
3. **Browse to evidence location:**
   - Navigate to `/evidence/`
   - Select `disk.img`
4. **Configure data source:**
   - **Data Source Name:** `Cloudcore_Workstation_Disk`
   - **Type:** Autopsy should auto-detect as "Disk Image"
   - **Timezone:** Leave as default (UTC)
5. **Click "Next"** and then **"Finish"**

**Expected Processing:**
- Autopsy will begin ingesting the disk image
- You'll see progress indicators for various modules:
  - File extraction
  - Hash calculation
  - Keyword indexing
  - Artifact extraction

**Wait time:** 2-5 minutes depending on system performance

### Step 3: Explore the File System View

Once processing completes, you'll see the main analysis interface:

1. **Navigate to "File Views"** in the left panel
2. **Explore the directory structure:**
   - Click through folders to understand the layout
   - Look for user directories (e.g., `/home/alex/`)
   - Check for suspicious directories (e.g., `/tmp/`, `/var/tmp/`)

**What to look for:**
- **Deleted files** (marked with red X or special icons)
- **Hidden directories** (names starting with `.`)
- **Unusual file locations** (executables in user folders)
- **Large files** that might contain stolen data
- **Recent modifications** (check timestamps)

**Key Finding Areas:**
- `/home/alex/Documents/` - Look for project files
- `/home/alex/Downloads/` - Check for downloaded tools
- `/tmp/` - Temporary files from malware/tools
- `/var/log/` - System logs (correlates with Lab 4)

### Step 4: Perform Keyword Searches

1. **Click the "Search" tab** at the top
2. **Try these keywords:**
   - `secret` (should find the deleted file from Lab 1)
   - `password`
   - `truecrypt` (correlates with Lab 2 findings)
   - `project_secrets` (the staged data)
   - `flag` (from Lab 1 carving exercise)

3. **Review search results:**
   - Click on each hit to see the file context
   - Note the file path and metadata
   - Check if files are deleted or existing

**Expected Findings:**
- References to deleted `flag.txt` file
- Possible TrueCrypt configuration files
- Project-related documents with suspicious timestamps

### Step 5: Analyze File Metadata and Timestamps

1. **Select interesting files** from your search or exploration
2. **View the "File Metadata" panel** (usually right side)
3. **Look for:**
   - **Modified times** - When were files changed?
   - **Access times** - When were files viewed?
   - **Created times** - When were files created?
   - **File sizes** - Any unusually large files?
   - **Hash values** - Do any match known malware?

**Timeline Analysis:**
- Focus on files modified around **December 5, 2009**
- Look for clusters of activity around specific times
- Correlate with memory analysis timeline from Lab 2

### Step 6: Use the Timeline View (Advanced)

1. **Click "Timeline"** in the left panel
2. **Filter by date range:**
   - Set to December 1-6, 2009
   - Look for activity spikes
3. **Filter by event type:**
   - File modifications
   - File deletions
   - Executable executions

**What to look for:**
- **Bursts of activity** suggesting data staging
- **Deletion events** after file modifications
- **Pattern of access** indicating systematic data collection

### Step 7: Check for Artifacts of Interest

1. **Navigate to "Artifacts"** section
2. **Look for:**
   - **Installed Programs** - Any unusual software?
   - **USB Device History** - Matches Lab 4 findings
   - **Web History** - Any suspicious browsing?
   - **Registry Keys** - Persistence mechanisms

**Key Artifacts:**
- USB device insertion/removal events
- Recently accessed documents
- Browser history or downloads
- System startup programs

### Step 8: Generate and Export Reports

1. **Click "Generate Report"** (usually top menu or right-click case)
2. **Configure report:**
   - **Format:** HTML (recommended) or PDF
   - **Scope:** Entire case or specific findings
   - **Include:** Screenshots, file lists, search results
3. **Export location:** `/cases/Autopsy_GUI/autopsy_case/export/`
4. **Wait for generation** and verify the export

**Report Contents:**
- Case summary
- File system overview
- Search results
- Key findings
- Timeline summary
- Screenshots (if included)

---

## Analysis Guidance

### Building Your Investigation

As you explore Autopsy, answer these questions in your `autopsy_report.md`:

1. **Evidence Integrity**
   - What is the hash of disk.img? (Compare with Lab 1)
   - Did Autopsy calculate the same hash?
   - Is this documented in chain_of_custody.csv?

2. **File System Analysis**
   - What deleted files did you recover that Lab 1 missed?
   - Are there any files Lab 1 found that Autopsy didn't detect?
   - How do the GUI timestamps compare with CLI timeline analysis?

3. **Keyword Search Results**
   - What did the search for "secret" reveal?
   - Any TrueCrypt-related files that correlate with Lab 2?
   - Did you find evidence of the `project_secrets.zip` file?

4. **Timeline Correlation**
   - Do file modification times align with memory analysis from Lab 2?
   - Are there USB artifacts that will correlate with Lab 4?
   - How does the December 5th activity compare across all tools?

5. **GUI vs CLI Comparison**
   - What advantages does Autopsy provide over CLI tools?
   - What limitations did you encounter?
   - Which approach would you use in a real investigation?

---

## Expected Key Findings

By the end of this lab, you should have discovered:

1. **Deleted file recovery** - `flag.txt` and other deleted artifacts
2. **Metadata evidence** - Timestamps showing file staging activity
3. **Keyword hits** - References to secret projects and encryption tools
4. **Timeline patterns** - Clusters of activity around December 5, 2009
5. **GUI advantages** - Visual file relationships and automated extraction

These findings should correlate with:
- **Lab 1:** Deleted file carving and timeline analysis
- **Lab 2:** TrueCrypt process discovery and memory artifacts
- **Lab 4:** USB device usage and system logs
- **Lab 5:** Network activity patterns

---

## Completing the Report

Fill in `cases/Autopsy_GUI/Lab3/autopsy_report.md` with:

### 1. Setup
- Docker commands used
- noVNC access URL and browser used
- Case creation details (name, path)

### 2. Methods
```
Tools and modules used:
- Autopsy 4.19.0 (via noVNC)
- File system viewer
- Keyword search module
- Timeline analysis
- Artifact extraction
- Report generation (HTML format)
```

### 3. Findings
**File System:**
- [List of interesting files discovered]
- [Deleted files recovered]
- [Suspicious directories or locations]

**Keyword Search:**
- "secret": [number] hits, including [specific files]
- "truecrypt": [number] hits, including [specific files]
- [Other keywords and results]

**Timeline:**
- Peak activity: [date/time] with [description]
- File deletion cluster: [date/time]
- Correlation with Lab 2: [specific connections]

**Artifacts:**
- USB devices: [list if found]
- Installed programs: [suspicious software]
- Web history: [if available]

### 4. Exported Report
- Report location: `/cases/Autopsy_GUI/autopsy_case/export/`
- Report format: HTML/PDF
- Key screenshots included: [list]
- Report size: [MB]

### 5. Conclusion
**GUI vs CLI Comparison:**
- Autopsy advantages: [visualization, automation, reporting]
- CLI advantages: [speed, flexibility, scripting]
- Combined approach benefits: [comprehensive coverage]

**Case Progress:**
- How Lab 3 findings support the data exfiltration theory
- New evidence discovered compared to Labs 1-2
- Preparation for Lab 4 (email/logs) correlation

---

## Troubleshooting

### Problem: "noVNC shows blank screen"
**Solutions:**
- Wait 15-30 seconds for the desktop to load
- Refresh the browser page
- Try a different browser (Chrome/Firefox recommended)
- Check Docker containers are running: `docker compose ps`

### Problem: "Autopsy won't launch from desktop"
**Solutions:**
- Double-click the Autopsy icon again
- Look for Autopsy in the applications menu
- Restart the containers: `docker compose restart autopsy novnc`

### Problem: "Disk image ingestion fails"
**Possible causes:**
- Disk image corrupted or incomplete
- Insufficient Docker memory allocation
- Permission issues with evidence file

**Solutions:**
- Verify disk.img exists and has expected size: `ls -lh evidence/disk.img`
- Increase Docker memory allocation in Docker Desktop settings
- Check file permissions: `chmod 644 evidence/disk.img`

### Problem: "Search returns no results"
**Solutions:**
- Ensure keyword indexing completed (check progress bar)
- Try different keywords (case-insensitive)
- Check if you're searching the entire case vs specific files

### Problem: "Report generation fails"
**Solutions:**
- Ensure case directory is writable: `chmod -R 755 cases/Autopsy_GUI/`
- Try HTML format instead of PDF
- Check available disk space
- Restart Autopsy and try again

### Problem: "Browser performance is slow"
**Solutions:**
- Close other browser tabs
- Use a wired internet connection if possible
- Reduce noVNC resolution in settings
- Consider using a more powerful machine

---

## Submission Checklist

Before submitting, ensure you have:

- [ ] `cases/Autopsy_GUI/autopsy_case/` directory with:
  - Complete case structure
  - Export folder with generated report
- [ ] `cases/Autopsy_GUI/Lab3/autopsy_report.md` completed with all sections
- [ ] Screenshots documenting key findings (embedded in report)
- [ ] Comparison analysis between GUI and CLI methods
- [ ] Correlation notes with Labs 1-2 findings
- [ ] `cases/chain_of_custody.csv` updated if needed

---

## Going Further (Optional Extensions)

If you finish early or want deeper analysis:

1. **Advanced Timeline Analysis:**
   - Use the timeline view to create a detailed activity graph
   - Filter by specific file types or users
   - Export timeline data for external analysis

2. **Registry Analysis:**
   - Navigate to registry artifacts
   - Look for persistence mechanisms
   - Check USB device history in detail

3. **Hash Analysis:**
   - Export file hashes from Autopsy
   - Cross-reference with malware databases
   - Compare with Lab 1 hash calculations

4. **Data Unit Analysis:**
   - Examine unallocated space
   - Look for file carving opportunities
   - Compare with Foremost results from Lab 1

5. **Advanced Reporting:**
   - Create custom report templates
   - Include specific artifact categories
   - Generate multiple report formats

6. **Performance Comparison:**
   - Time Autopsy operations vs equivalent CLI commands
   - Document resource usage differences
   - Analyze accuracy differences between tools

---

## Additional Resources

- **Autopsy Documentation:** https://autopsy.com/docs/
- **noVNC Documentation:** https://github.com/novnc/noVNC
- **Sleuth Kit vs Autopsy:** Understanding when to use each
- **Digital Forensics GUI Tools:** Comparison of commercial options
- **Browser Compatibility:** VNC client recommendations
- **DFIR Training:** See `STORYLINE.md` and `COURSE_MAPPING.md` for context

---

## Questions or Issues?

- Check `TROUBLESHOOTING.md` in the root directory
- Review `FACILITATION.md` for teaching notes
- Consult with your instructor or lab assistant
- Reference `AUTOPSY_ARM_MAC_WORKAROUND.md` if on Apple Silicon

**Remember:** GUI tools provide excellent visualization and reporting capabilities, but CLI tools offer precision and automation. Professional investigators use both!

---

**Next Lab:** Lab 4 - Email and Log Analysis