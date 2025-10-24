# Forensic Lab Templates

This directory contains templates and starting points for evidence documentation during forensic analysis labs.

---

## 📋 Overview

For each forensic lab (USB_Imaging, Memory_Forensics, Autopsy_GUI, Email_Logs, Network_Analysis), students should maintain **three key documents**:

1. **Chain of Custody** (`chain_of_custody.csv`) - Evidence handling record
2. **Analysis Log** (`analysis_log.csv`) - Command execution log with hashes
3. **Lab Report** (`lab_report.md`) - Written findings and analysis

The **Final_Report** lab synthesizes findings from all other labs into a comprehensive incident investigation report.

---

## 📁 Templates in This Directory

### chain_of_custody.csv

**Purpose**: Track evidence handling for forensic integrity and legal admissibility

**When to use**:
- At the START of each lab
- Copy this template to your case directory: `cases/[CaseName]/chain_of_custody.csv`
- Fill in evidence details before beginning analysis

**What it contains**:
- Evidence ID (e.g., USB-DISK-001)
- Date and time received
- Received from (chain of custody)
- Hash values (MD5, SHA256) for integrity verification
- Analyst name
- Case number
- Evidence description (what the evidence is)
- Storage location

**Example**:
```
Evidence_ID,Date_Received,Time_Received,Received_From,MD5_Hash,SHA256_Hash,Analyst_Name,Case_Number,Evidence_Description,Storage_Location
USB-DISK-001,2025-09-23,14:00:00,Cloudcore Security Team,d41d8cd98f00b204e9800998ecf8427e,e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855,Alice Johnson,CLOUDCORE-2024-INS-001,"16GB SanDisk USB drive (usb.img forensic image), NTFS formatted",./cases/USB_Imaging/
```

---

### analysis_log.csv

**Purpose**: Document every analysis command for reproducibility and chain of custody

**When to use**:
- AUTOMATICALLY created when using the `coc-log` script
- OR manually maintained if not using coc-log
- Copy template to: `cases/[CaseName]/analysis_log.csv` (or it will be auto-created)

**What it contains**:
- Timestamp (UTC ISO 8601 format)
- Analyst name
- Command executed
- Exit code (0 = success)
- Output line count
- Output hash (SHA256)
- Note describing the command

**Example**:
```
timestamp_utc,analyst,command,exit_code,output_lines,output_hash,note
2025-09-23T14:05:00Z,Alice Johnson,"fls -r /evidence/usb.img",0,150,a3e2b5c4d9f1e7a2b8c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f,"Initial filesystem listing"
2025-09-23T14:10:30Z,Alice Johnson,"icat /evidence/usb.img 2048 > recovered_file.txt",0,5000,b4f3c6d5e0g2f8a3b9c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f,"Extract deleted file from inode 2048"
```

**Manual Usage** (if not using coc-log):
1. Create the CSV file in your case directory
2. Run your forensic commands
3. Manually add entries after each command
4. Capture command output and hash it: `sha256sum command_output.txt`

**Using coc-log Script** (recommended):
```bash
# Inside the forensics-workstation container, from your case directory
coc-log "fls -r /evidence/usb.img" "Initial filesystem listing"
coc-log "icat /evidence/usb.img 2048" "Extract deleted file"
```

The script automatically:
- Records timestamp and analyst name
- Executes the command
- Captures output
- Calculates SHA256 hash
- Logs to analysis_log.csv
- Saves output to outputs/ folder

---

### lab_report_template.md

**Purpose**: Write findings and analysis for individual forensic labs

**When to use**:
- After completing a forensic lab
- Use for: USB_Imaging, Memory_Forensics, Autopsy_GUI, Email_Logs, Network_Analysis
- Copy template to: `cases/[CaseName]/lab_report.md`

**What it contains**:
- Title page (lab name, student info, analyst name)
- Chain of custody verification
- Analysis methodology (tools, phases, approach)
- Findings and analysis (what was discovered, with artifacts and significance)
- Forensic reasoning (what it means)
- Correlation with other labs (how does this connect to other evidence?)
- Recommendations (what should happen next?)
- Methodology reflection (tool effectiveness, reproducibility, integrity)
- Appendices (logs, supporting files)

**Structure**:
- ~600-1000 words (excluding appendices)
- Clear findings with artifact references (file paths, inode numbers, etc.)
- Evidence integrity emphasis
- Professional documentation suitable for legal review

**Section Highlights**:
- **Evidence Chain of Custody**: Hash values, acquisition details, access log
- **Analysis Methodology**: Triage → evidence collection → validation phases
- **Findings and Analysis**: Significant artifacts with forensic context
- **Forensic Reasoning**: What do findings tell us? What's the timeline?
- **Correlation**: How do these findings relate to other evidence sources?

---

### final_report_template.md

**Purpose**: Synthesize findings from ALL labs into a comprehensive incident investigation report

**When to use**:
- For the Final_Report lab (only)
- After completing 3+ other forensic labs
- Use to answer: What happened? How? Who was involved? When?

**What it contains**:
- Title page (case name, student info, report classification)
- Investigation scope (which evidence, which labs)
- Methodology (analysis approach, tools, chain of custody)
- Unified timeline (combining evidence from all sources)
- Evidence synthesis (narrative of each incident phase)
- Forensic conclusions (what findings tell us about the incident)
- Recommendations and remediation (what to do now and in future)
- Limitations and gaps (what evidence is missing? what's uncertain?)
- Appendices (all lab reports, complete logs, supporting evidence)

**Structure**:
- ~1500-2500 words (excluding appendices)
- Chronological narrative timeline with evidence sources
- Multi-source evidence corroboration
- Clear answers to key investigative questions
- Professional quality suitable for legal proceedings

**Key Principle**:
Each finding in the final report should be supported by evidence from multiple sources (disk + memory + network + email when possible). This demonstrates forensic rigor and corroboration.

---

## 🚀 Workflow: Using Templates

### For Individual Labs (USB_Imaging, Memory_Forensics, etc.)

1. **Before you begin**:
   ```bash
   # Copy templates to your case directory
   cp templates/chain_of_custody.csv cases/[CaseName]/
   cp templates/analysis_log.csv cases/[CaseName]/
   cp templates/lab_report_template.md cases/[CaseName]/lab_report.md

   # Fill in CoC details (evidence ID, hash, analyst name, etc.)
   # Edit chain_of_custody.csv with case-specific information
   ```

2. **During analysis**:
   ```bash
   # Use coc-log to document every command
   coc-log "your-forensic-command" "description of what you're doing"

   # This automatically updates analysis_log.csv and saves outputs
   ```

3. **After analysis**:
   ```bash
   # Complete lab_report.md
   # - Add your findings
   # - Reference artifacts from analysis_log.csv
   # - Explain forensic significance
   # - Correlate with other evidence if available

   # Attach:
   # - lab_report.md
   # - chain_of_custody.csv
   # - analysis_log.csv
   # - outputs/ folder (from coc-log)
   ```

### For Final Report

1. **Before you begin**:
   ```bash
   # Copy final report template
   cp templates/final_report_template.md cases/Final_Report/final_report.md

   # Gather all lab reports completed so far
   ```

2. **During writing**:
   - Create unified timeline combining all evidence sources
   - Reference findings from each lab report
   - Show corroboration (same fact proven by multiple evidence types)
   - Build narrative of the incident
   - Address forensic conclusions and recommendations

3. **Submission**:
   - final_report.md (main document)
   - All individual lab reports (USB_Imaging, Memory_Forensics, etc.)
   - All analysis_log.csv files
   - All chain_of_custody.csv files
   - Supporting evidence and outputs folder

---

## 📊 Understanding Chain of Custody (CSV)

The chain of custody CSV tracks evidence handling for **forensic integrity**.

**Key fields**:
- **Evidence_ID**: Unique identifier (e.g., USB-DISK-001, MEM-DUMP-001)
- **Date_Received / Time_Received**: When evidence came into your custody
- **Received_From**: Who provided the evidence (maintains chain)
- **MD5_Hash / SHA256_Hash**: Cryptographic hashes proving evidence hasn't been modified
- **Analyst_Name**: Who is analyzing (may be different from who captured it)
- **Case_Number**: Reference for organization
- **Evidence_Description**: What the evidence is (disk image, memory dump, etc.)
- **Storage_Location**: Where the evidence is kept

**Why it matters**:
- In forensics, you can't "re-take" evidence if you damage it
- Chain of custody proves evidence integrity in court
- Hash values prove no one has modified the evidence
- Documentation shows every person who touched the evidence

---

## 📝 Understanding Analysis Log (CSV)

The analysis log CSV tracks **every command executed** during investigation.

**Key fields**:
- **timestamp_utc**: When the command was run (ISO 8601 format, UTC timezone)
- **analyst**: Who ran it
- **command**: The exact command executed
- **exit_code**: 0 = success, non-zero = error
- **output_lines**: How many lines of output
- **output_hash**: SHA256 hash of command output (proves it wasn't modified later)
- **note**: Why you ran this command

**Why it matters**:
- **Reproducibility**: Another analyst can run the same commands and get the same results
- **Transparency**: Shows your methodology and reasoning
- **Integrity**: Hash values prove output hasn't been changed
- **Documentation**: Creates a forensic record of your analysis steps

**Example interpretation**:
```
2025-09-23T14:05:00Z,Alice Johnson,"fls -r /evidence/usb.img",0,150,a3e2...,"Initial filesystem listing"
```
Means: At 14:05:00 UTC on Sept 23, Alice ran `fls -r /evidence/usb.img`, it succeeded (exit code 0), produced 150 lines of output with hash a3e2..., and she noted this was an "Initial filesystem listing".

---

## 🔍 Making Templates Your Own

**When copying templates**:
1. Keep the structure and section headings
2. Fill in YOUR findings and analysis
3. Reference YOUR artifacts and commands
4. Include YOUR evidence hashes and timestamps
5. Explain YOUR forensic reasoning

**Templates are guides, not fill-in-the-blanks**:
- Each lab will have different findings
- Each student will have different evidence
- Your analysis should reflect YOUR investigation
- Professional reports are customized to the evidence, not generic

---

## 📌 Quick Reference: What Goes Where

| Document | Created | Updated | Location | Purpose |
|---|---|---|---|---|
| **chain_of_custody.csv** | Before lab starts | No | `cases/[CaseName]/` | Evidence handling record |
| **analysis_log.csv** | During lab (auto with coc-log) | Yes (with each command) | `cases/[CaseName]/` | Command execution log |
| **lab_report.md** | After lab completes | Yes (final report) | `cases/[CaseName]/` | Lab findings and analysis |
| **final_report.md** | Start of Final_Report lab | Yes | `cases/Final_Report/` | Synthesis of all evidence |

---

## ✅ Submission Checklist

**For each individual lab**:
- [ ] chain_of_custody.csv (completed with evidence details and hashes)
- [ ] analysis_log.csv (all commands documented with timestamps and hashes)
- [ ] lab_report.md (findings, analysis, correlation)
- [ ] outputs/ folder (command outputs and evidence files)

**For Final_Report**:
- [ ] final_report.md (comprehensive incident analysis)
- [ ] All lab reports included (as appendices or referenced)
- [ ] All analysis_log.csv files (appendices)
- [ ] All chain_of_custody.csv files (appendices)
- [ ] Unified timeline with evidence sources
- [ ] Evidence corroboration across labs

---

## 🔗 Related Documentation

- **`docs/glossary.md`**: Forensic terminology and tool definitions
- **`docs/scenario.md`**: Case background and incident context
- **`docs/storyline.md`**: What actually happened (for reference/comparison)
- **`cases/*/WALKTHROUGH.md`**: Detailed instructions for each lab

---

**Remember**: In forensics, documentation is as important as the findings themselves. Clear, detailed, reproducible analysis creates credible evidence suitable for legal proceedings.
