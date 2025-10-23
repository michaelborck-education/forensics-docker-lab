# Autopsy_GUI Lab - Student Walkthrough
## Graphical Forensic Analysis

**Time Estimate:** 1-2 hours
**Difficulty:** Beginner
**Tools:** Autopsy GUI (web-based via noVNC), web browser

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

Autopsy provides a graphical interface for forensic analysis. Start it:

```bash
# Start Autopsy (runs on localhost:8888)
autopsy
```

**Expected output:**
```
Autopsy server starting...
Navigate to: http://localhost:8888
```

**In your host machine (new terminal):**
```bash
# Open browser to Autopsy
open http://localhost:8888   # macOS
# OR
firefox http://localhost:8888  # Linux
# OR
start http://localhost:8888   # Windows
```

---

## 🗂️ Part 3: Create a Case in Autopsy

1. **Select "New Case"**
2. **Case Name:** USB_Evidence_Analysis
3. **Base Directory:** `/cases/Autopsy_GUI/`
4. Click **Next**

---

## 🔎 Part 4: Add Evidence

1. **Click "Add Data Source"**
2. **Select "Disk Image or VM file"**
3. **Browse to:** `/evidence/usb.img`
4. **Next** through prompts (use defaults)
5. **Ingest modules:** Select all available
6. **Finish** and wait for processing (~5-10 minutes)

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: Autopsy GUI - Created case and ingested /evidence/usb.img
exit_code: 0
note: Added disk image and ran all ingest modules
```

---

## 📊 Part 5: Browse Files & Results

Once processing completes:

### Step 1: View File System

1. Click **"Data Sources"** → **"usb.img"**
2. Explore the directory tree
3. Look for suspicious files and deleted entries
4. Take notes on interesting findings

### Step 2: Keyword Search

1. Click **"Tools"** → **"Keyword Search"**
2. Enter keywords: `password`, `confidential`, `secret`
3. Review results

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: Autopsy GUI - Keyword search for sensitive terms
exit_code: 0
note: Searched for password, confidential, secret - found X matches
```

### Step 3: View Timeline

1. Click **"Tools"** → **"Timeline"**
2. Analyze file creation/modification dates
3. Look for patterns (mass creation/deletion at specific times)

### Step 4: Analyze Artifacts

1. Click **"Results"** → **"Extracted Content"**
2. Browse recovered artifacts (emails, documents, images)
3. Review metadata

**📋 Document findings:**
- Number of files analyzed
- Suspicious files discovered
- Timeline patterns observed
- Key artifacts recovered

---

## 🖼️ Part 6: Generate Reports

Autopsy can export professional reports:

1. **Tools** → **"Generate Report"**
2. **Select format:** HTML or PDF
3. **Output location:** `/cases/Autopsy_GUI/`
4. **Generate** (takes 2-5 minutes)

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: Autopsy GUI - Generated case report
exit_code: 0
note: HTML report exported to cases/Autopsy_GUI/
```

---

## 📁 Part 7: Compare with CLI Findings

Compare your Autopsy results with Lab 1 (CLI):

1. Open CLI outputs from Lab 1: `cases/USB_Imaging/`
2. Compare:
   - Total files (fls output vs Autopsy)
   - Deleted files (deleted_files.txt vs Autopsy timeline)
   - Keywords found (keyword_search.txt vs Autopsy search)

**Document similarities and differences in your report.**

---

## 🚪 Part 8: Exit the Workstation

```bash
exit
```

---

## ✅ Deliverables

You should have created in `cases/Autopsy_GUI/`:

- ✅ `chain_of_custody.csv` - Evidence hash
- ✅ `analysis_log.csv` - All actions documented
- ✅ `[CaseName]/` - Autopsy case directory
- ✅ HTML or PDF report from Autopsy

---

## 📊 Analysis Summary

Document your findings:

1. **Total files analyzed:** (from Autopsy summary)
2. **Deleted files found:** (compare with Lab 1)
3. **Suspicious keywords:** (search results)
4. **Timeline anomalies:** (suspicious clusters of activity)
5. **Key artifacts:** (most important recovered items)
6. **Comparison to Lab 1:** (what's different between CLI and GUI analysis?)

---

## 🆘 Troubleshooting

### "Cannot connect to Autopsy"
- Verify it's still running in the container
- Check port 8888 is accessible
- Try different browser (Chrome/Firefox recommended)

### "Processing taking too long"
- Large disks take time - be patient
- Processing usually completes in 10-30 minutes
- Don't close the browser tab

### "Case files not saving"
- Verify `/cases/Autopsy_GUI/` exists and is writable
- Check directory permissions
- Restart Autopsy if needed

---

## 📚 Next Steps

After this lab:

1. Review your Autopsy findings
2. Compare with CLI analysis from Lab 1
3. Note any discrepancies or new discoveries
4. Proceed to Email_Logs (Lab 4) when ready

---

## 📝 Summary - GUI Workflow

```bash
# INSIDE the workstation:

# Hash verification
sha256sum /evidence/usb.img

# Launch Autopsy (web-based)
autopsy

# In your host browser:
# Visit http://localhost:8888
# Create case → Add disk image → Run ingest → Analyze → Generate report

# Exit workstation
exit
```

---

**Remember:** GUI analysis complements CLI analysis - use both for complete picture!
