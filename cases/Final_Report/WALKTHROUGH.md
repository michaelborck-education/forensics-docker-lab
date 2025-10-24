# Final_Report Lab - Student Walkthrough
## Case Consolidation & Professional Report

**Time Estimate:** 3-5 hours
**Difficulty:** Intermediate
**Tools:** Text editor, spreadsheet application, all previous labs

---

## 🎯 Mission

Synthesize findings from all 5 labs (USB_Imaging, Memory_Forensics, Autopsy_GUI, Email_Logs, Network_Analysis) into a unified, professional investigation report. This is where individual artifacts become a coherent narrative proving guilt or innocence.

---

## 📋 Pre-Lab Setup

This lab does NOT use the forensic workstation. You'll work on your **host machine** consolidating evidence.

### 1. Verify Final_Report Templates Are Ready

The lab folder should already contain template files. Verify they exist:

```bash
# On your host machine
ls -lh cases/Final_Report/
```

You should see:
- **chain_of_custody.csv** - Evidence handling record (from all labs)
- **analysis_log.csv** - Master command log (optional for consolidation)
- **lab_report.md** - Available if alternative format needed
- **final_report.md** - Report template for comprehensive incident synthesis (PRIMARY)
- **WALKTHROUGH.md** - This document

**What each file does:**

| File | Purpose | When Used |
|------|---------|-----------|
| **chain_of_custody.csv** | Master evidence record from all 5 labs | Before starting - consolidate all evidence hashes |
| **analysis_log.csv** | Optional master log if tracking all commands | During lab - optional for tracking consolidated analysis |
| **final_report.md** | Template for comprehensive incident investigation | Main deliverable - synthesize all evidence into narrative |
| **lab_report.md** | Alternative format if needed | Optional - individual lab-style reporting |

If any files are missing, copy them from templates/:

```bash
# Copy missing templates (if needed)
cp templates/chain_of_custody.csv cases/Final_Report/chain_of_custody.csv
cp templates/analysis_log.csv cases/Final_Report/analysis_log.csv
cp templates/lab_report_template.md cases/Final_Report/lab_report.md
cp templates/final_report_template.md cases/Final_Report/final_report.md
```

**Tips for using these files:**
- **chain_of_custody.csv**: Consolidate evidence records from all 5 lab folders. This becomes your master evidence list.
- **final_report.md**: Use this as your primary template. It's designed for synthesizing evidence from multiple sources into a unified incident narrative.
- **lab_report.md**: Available if you prefer the individual lab format instead of the comprehensive final report format.

### 2. Review All Previous Labs

Open these folders and review all findings and evidence:
```bash
cases/USB_Imaging/        # Files, deleted items, lab_report.md, chain_of_custody.csv, analysis_log.csv
cases/Memory_Forensics/   # Processes, network connections, lab_report.md, chain_of_custody.csv, analysis_log.csv
cases/Autopsy_GUI/        # Timeline, artifacts, lab_report.md, chain_of_custody.csv, analysis_log.csv
cases/Email_Logs/         # Communications, lab_report.md, chain_of_custody.csv, analysis_log.csv
cases/Network_Analysis/   # Traffic, exfiltration, lab_report.md, chain_of_custody.csv, analysis_log.csv
```

**Key documents to review:**
- Each lab's `lab_report.md` for analysis and findings
- Each lab's `chain_of_custody.csv` for evidence details and hashes
- Each lab's `analysis_log.csv` for methodology transparency

---

## 📊 Part 1: Consolidate Chain of Custody

Combine hashes from all 5 labs into a master file.

**Open these files:**
- cases/USB_Imaging/chain_of_custody.csv
- cases/Memory_Forensics/chain_of_custody.csv
- cases/Autopsy_GUI/chain_of_custody.csv
- cases/Email_Logs/chain_of_custody.csv
- cases/Network_Analysis/chain_of_custody.csv

**In cases/Final_Report/master_chain_of_custody.csv:**
Add one row for EACH evidence item with:
- Evidence_ID: USB-001, MEMORY-001, EMAIL-001, etc.
- Date_Received: (when seized)
- MD5_Hash: (from each lab)
- SHA256_Hash: (from each lab)
- Analyst_Name: (your name)
- Evidence_Description: Brief description

**Example row:**
```
USB-001,2024-10-20,14:00:00,Field Agent,fc8096...,6ebe35...,Michael,CASE-2024-001,"16GB SanDisk USB (usb.img)",./cases/secure_evidence/
```

---

## 📝 Part 2: Consolidate Analysis Log

Combine all commands run across all 5 labs.

**Open these files:**
- cases/USB_Imaging/analysis_log.csv
- cases/Memory_Forensics/analysis_log.csv
- cases/Autopsy_GUI/analysis_log.csv
- cases/Email_Logs/analysis_log.csv
- cases/Network_Analysis/analysis_log.csv

**In cases/Final_Report/master_analysis_log.csv:**
Copy all rows from each lab's analysis_log.csv in chronological order.

**Sort by timestamp_utc** to create a complete timeline of analysis activities.

---

## 🔍 Part 3: Build Master Timeline

Create a comprehensive timeline showing WHEN attacks happened.

**File:** cases/Final_Report/MASTER_TIMELINE.txt

```
CLOUDCORE INCIDENT TIMELINE
Case: CLOUDCORE-2024-INS-001

=== PHASE 1: PREPARATION ===
[Date/Time from Lab 1] - Files created on USB
- Evidence: [from USB_Imaging file list]
- Suspicious files: [project_secrets.zip, client_database.csv, etc.]
- Timestamp correlation: [were these created same day?]

=== PHASE 2: ENCRYPTION/STAGING ===
[Date/Time from Lab 2] - Memory dump captured
- TrueCrypt.exe running: [yes/no, PID]
- Network connections: [IRC port 6667?, external IPs?]
- Timestamp: [when was memory dumped?]
- Indicates: [suspect was encrypting/preparing data]

=== PHASE 3: COMMUNICATION ===
[Date/Time from Lab 4] - Emails sent
- Recipients: [external email addresses]
- Subject: [what was said?]
- Attachments: [file names, sizes]
- When: [specific timestamps]
- Indicates: [suspect communicating with accomplice]

=== PHASE 4: EXFILTRATION ===
[Date/Time from Lab 5] - Network traffic
- IRC C2 commands received: [yes/no]
- Large data transfer detected: [size, destination]
- Duration: [how long did transfer take?]
- When: [specific timestamp]
- Indicates: [data being stolen over network]

=== PHASE 5: CLEANUP ===
[Date/Time from Lab 1] - Files deleted
- Deleted files: [list what was deleted]
- When: [after exfiltration?]
- Indicates: [suspect covering tracks]

=== CONCLUSION ===
Timeline shows coordinated, planned attack:
1. Prepare data on USB
2. Load into memory
3. Encrypt with TrueCrypt
4. Email to accomplice
5. Exfiltrate over network
6. Delete traces
Total duration: [X hours/days]
```

---

## 🔗 Part 4: Create Evidence Correlation Matrix

Show how findings from different labs support each other.

**File:** cases/Final_Report/CORRELATION_MATRIX.txt

```
EVIDENCE CORRELATION MATRIX

Finding: "project_secrets.zip" file
- Lab 1: Found in recovered files (inode 257)
- Lab 1: File deleted (marked with *)
- Lab 4: Referenced in email subject line
- Lab 5: Large transfer (50MB) to external server
→ CONCLUSION: Same file from USB → emailed → exfiltrated

Finding: TrueCrypt process
- Lab 2: TrueCrypt.exe running (PID 2048)
- Lab 2: Network connections from PID 2048 to 8.8.8.8:6667
- Lab 1: encrypted_container.dat found on USB
→ CONCLUSION: Suspect used TrueCrypt to encrypt stolen data

Finding: IRC C2 Communication
- Lab 2: Memory shows connection to port 6667
- Lab 5: Network capture shows IRC traffic
- Lab 5: Commands visible in pcap (if readable)
→ CONCLUSION: Malware or direct attacker control via IRC

STRONG CORRELATIONS = PLANNED, COORDINATED ATTACK
```

---

## 📄 Part 5: Write Professional Report

**File:** cases/Final_Report/INVESTIGATION_REPORT.md

### Executive Summary (1-2 pages)
- What was the incident?
- What evidence was found?
- What is the conclusion?
- Who is responsible?

### Methodology (1-2 pages)
- What evidence was collected?
- What tools were used? (Sleuth Kit, Volatility, tshark, Autopsy)
- What chain of custody procedures were followed?
- Link to master_chain_of_custody.csv

### Findings by Lab (5-8 pages total)

#### Lab 1: Disk Forensics
- Total files on USB: [number]
- Deleted files recovered: [number]
- Suspicious files found: [list with evidence]
- Key artifacts: [what's most incriminating?]

#### Lab 2: Memory Forensics
- OS version: [Windows XP/etc]
- Total processes: [number]
- TrueCrypt.exe: [running, PID, timestamp]
- Network connections: [IRC, external IPs]
- Key finding: [smoking gun?]

#### Lab 3: GUI Analysis (Autopsy)
- Total files analyzed: [number]
- Timeline anomalies: [suspicious clusters?]
- Metadata patterns: [what do timestamps show?]
- Key finding: [what did GUI reveal that CLI didn't?]

#### Lab 4: Email Analysis
- Total emails: [number]
- External recipients: [list addresses]
- Suspicious subjects: [what was discussed?]
- Attachments: [file names, sizes, when sent?]
- Key finding: [proof of communication?]

#### Lab 5: Network Analysis
- Total packets: [number]
- IRC C2 traffic: [yes/no, server IP, timestamps]
- Data exfiltration: [yes/no, size, destination, when?]
- DNS queries: [suspicious domains?]
- Key finding: [proof of theft?]

### Timeline (1-2 pages)
- Link to MASTER_TIMELINE.txt
- Narrative version of events
- Show cause → effect relationships

### Correlations (1-2 pages)
- Link to CORRELATION_MATRIX.txt
- Explain how evidence supports conclusion
- Show consistency across multiple labs

### Conclusion (0.5-1 page)
- Based on ALL evidence, what happened?
- Who did it? How? When? Why?
- Confidence level: (strong, moderate, weak)
- Recommendation: (prosecution, further investigation, acquittal)

### Appendices
- Link to all CSV files
- Link to all analysis outputs
- References to specific findings

---

## 📋 Part 6: Create Summary Checklist

**File:** cases/Final_Report/DELIVERABLES_CHECKLIST.txt

```
COMPLETE FORENSIC INVESTIGATION CHECKLIST

EVIDENCE COLLECTION & CoC:
☐ Master chain_of_custody.csv contains all 5 labs
☐ All evidence hashes documented (MD5 and SHA256)
☐ Analyst names and dates recorded
☐ Evidence descriptions clear and specific

ANALYSIS DOCUMENTATION:
☐ Master analysis_log.csv contains all commands from 5 labs
☐ All timestamps UTC format
☐ All commands include output redirection filenames
☐ Notes explain purpose of each command

FINDINGS:
☐ USB_Imaging: Files listed and deleted files recovered
☐ Memory_Forensics: Suspicious processes and network connections documented
☐ Autopsy_GUI: Timeline and artifact analysis complete
☐ Email_Logs: Headers, keywords, and recipients identified
☐ Network_Analysis: IRC, DNS, and exfiltration analyzed

SYNTHESIS:
☐ Master timeline created (MASTER_TIMELINE.txt)
☐ Correlation matrix shows evidence relationships (CORRELATION_MATRIX.txt)
☐ Professional report written (INVESTIGATION_REPORT.md)
☐ Findings support conclusion
☐ Timeline is consistent across all labs

REPORT QUALITY:
☐ Professional tone (formal, objective)
☐ Evidence cited properly (specific file names, PIDs, timestamps)
☐ Conclusion is supported by evidence
☐ No speculation without evidence
☐ All suspicious findings documented
☐ Grammar and spelling correct

SUBMISSION:
☐ All files in cases/Final_Report/
☐ Report is readable (PDF or Markdown)
☐ CSV files are valid (can open in Excel/spreadsheet)
☐ All supporting documents included
```

---

## 📁 Part 7: Organize Deliverables

Final folder structure should look like:

```
cases/Final_Report/
├── master_chain_of_custody.csv      # All evidence hashes
├── master_analysis_log.csv          # All commands run
├── MASTER_TIMELINE.txt              # When did attacks happen?
├── CORRELATION_MATRIX.txt           # How do labs support each other?
├── INVESTIGATION_REPORT.md          # Professional final report
├── DELIVERABLES_CHECKLIST.txt       # Did we complete everything?
└── [output files from each lab]     # Reference materials
```

---

## 🎯 Part 8: Reflect on Investigation Process

**File:** cases/Final_Report/PROCESS_REFLECTION.txt

Questions to answer:

1. **What evidence was MOST important?**
   - Which single piece of evidence proved guilt?
   - Why was that more important than others?

2. **What did each lab contribute?**
   - Could we have solved it with just Lab 1? Lab 2?
   - Why was having all 5 labs necessary?

3. **What challenges did you face?**
   - Command syntax errors?
   - Evidence interpretation?
   - Thinking like an attacker?

4. **What would you do differently?**
   - Better search keywords?
   - Different tools?
   - Different analysis order?

5. **How confident in your conclusion?**
   - Strong (multiple corroborating sources)
   - Moderate (some gaps)
   - Weak (inconclusive)
   - Why?

---

## ✅ Final Deliverables

**In cases/Final_Report/, you should have:**

- ✅ master_chain_of_custody.csv - All evidence hashes consolidated
- ✅ master_analysis_log.csv - All commands documented
- ✅ MASTER_TIMELINE.txt - Attack timeline
- ✅ CORRELATION_MATRIX.txt - Evidence relationships
- ✅ INVESTIGATION_REPORT.md - Professional report (2-10 pages)
- ✅ DELIVERABLES_CHECKLIST.txt - Quality verification
- ✅ PROCESS_REFLECTION.txt - Your thoughts on investigation

---

## 📋 Quick Checklist for Report Quality

- [ ] **Professional tone**: Formal, objective, no opinions
- [ ] **Specific evidence**: All findings cite file names, PIDs, timestamps, IP addresses
- [ ] **Timeline consistency**: Events make logical sense in order
- [ ] **Chain of custody**: All evidence properly documented with hashes
- [ ] **Correlation**: Findings from different labs support each other
- [ ] **Conclusion clarity**: Reader understands WHO, WHAT, WHEN, WHERE, HOW
- [ ] **No speculation**: Only facts supported by evidence
- [ ] **Proper grammar**: Spell-checked and proofread

---

## 📚 Summary

This lab brings all 5 previous investigations together into a unified case narrative. Your report should answer:

**THE 5 W's + H:**
- **WHO** committed the crime?
- **WHAT** did they do?
- **WHEN** did it happen? (timeline)
- **WHERE** did evidence go?
- **WHY** did they do it? (motive, if evident)
- **HOW** did they carry it out? (method)

If your report answers all 6 questions with supporting evidence, you've written a complete forensic investigation!

---

**Congratulations on completing all 6 labs!**

You've now experienced a complete forensic investigation from evidence collection through professional reporting. This is what real-world digital forensics looks like.

Remember: **Documentation is Evidence. Evidence is Truth.**
