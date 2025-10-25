# Assessment Rubrics for Forensic Labs

## Grading Philosophy

These rubrics provide a framework for assessing student work on forensic analysis labs. They emphasize:
- **Evidence integrity** (chain of custody, hashing)
- **Technical execution** (proper tool use, methodology)
- **Forensic reasoning** (analysis, interpretation, correlation)
- **Documentation** (reproducibility, professional standards)

Labs can be assigned in any order (except Final_Report which synthesizes all evidence). Scale each lab 100% if students complete all sections.

---

## USB_Imaging Lab Assessment

**Chain of Custody (20%)**
- Evidence hash (SHA256/MD5) documented
- Timestamp recorded
- Evidence ID assigned
- Analysis log entries track all commands

**File Recovery & Triage (30%)**
- Deleted files successfully recovered (icat or file carving)
- Files listed with inode numbers, sizes, timestamps
- Suspicious files identified (project_secrets.txt, email_draft.txt, etc.)
- Timeline of file creation/deletion documented

**Evidence Analysis (30%)**
- Manual keyword searches conducted (password, secret, confidential)
- Deleted file contents extracted and examined
- File metadata analyzed (creation time, modification time, access time)
- Evidence correlations noted for later labs

**Documentation & Report (20%)**
- Chain of custody CSV complete
- Analysis log CSV documents all commands with timestamps
- Findings clearly written with artifact references (inode numbers, file paths)
- Professional report format suitable for legal review

---

## Memory_Forensics Lab Assessment

**Chain of Custody (20%)**
- Memory dump hash documented
- Capture method and timestamp recorded
- File size and integrity verified

**Process Analysis (30%)**
- Process listing generated (pslist output)
- Suspicious processes identified (ToolKeylogger.exe, unusual network processes, etc.)
- Process hierarchy examined (parent-child relationships)
- Network connections from processes analyzed (netscan output)

**Evidence Extraction (30%)**
- String extraction from suspicious processes
- Memory dump volumes or encrypted containers identified
- DLL analysis for malware indicators
- Evidence saved for correlation with disk/network findings

**Documentation & Report (20%)**
- Analysis log entries document each analysis step
- Screenshots or output files show process trees and network connections
- Findings correlate to disk evidence (matching file names, timestamps)
- Professional report explains what each finding means forensically

---

## Autopsy_GUI Lab Assessment

**GUI Environment Setup (20%)**
- Case created in Autopsy
- Evidence (disk image) successfully loaded
- Ingest modules configured and completed

**Evidence Exploration (30%)**
- Filesystem browsed and suspicious files identified
- Keyword search conducted (password, secret, confidential)
- Deleted files found and examined in timeline
- Metadata extracted (timestamps, file properties)

**Correlation with CLI Analysis (30%)**
- GUI findings compared with USB_Imaging lab results
- Matching files and timestamps verified
- Discrepancies investigated and explained
- Conclusion on tool comparison documented

**Documentation & Report (20%)**
- Analysis log entries document each Autopsy action
- HTML/PDF report generated from Autopsy
- Findings documented with file paths and timestamps
- Comparison summary explains GUI vs. CLI methodology

---

## Email_Logs Lab Assessment

**Chain of Custody (20%)**
- Evidence hashes documented (mbox, logs if applicable)
- File integrity verified
- Timestamps recorded

**Email Analysis (30%)**
- Emails extracted and parsed (headers, sender, recipient, subject, body)
- Suspicious emails identified (external recipients, attachments)
- Email content analyzed for evidence of intent
- Timestamps compared with other evidence

**Correlation & Timeline (30%)**
- Email timestamps matched with disk evidence
- Email recipients cross-referenced with network evidence
- Attachment evidence tied to files recovered in disk/memory labs
- Attack timeline refined with email evidence

**Documentation & Report (20%)**
- Analysis log documents all search/parsing commands
- Email extracts provided with annotations
- Timeline summary shows coordination across evidence sources
- Professional analysis explains investigative significance

---

## Network_Analysis Lab Assessment

**Chain of Custody (20%)**
- Network capture file (PCAP) hash documented
- Packet count and time range verified
- Capture integrity established

**Protocol Analysis (30%)**
- DNS queries extracted and analyzed
- HTTP/HTTPS traffic examined
- IRC C2 connections identified (if present)
- Suspicious domains and servers documented

**Data Exfiltration Detection (30%)**
- TCP conversations analyzed for data volume
- Large outbound transfers identified
- Asymmetric traffic patterns noted
- Destination IPs and ports documented

**Documentation & Report (20%)**
- Analysis log documents all tshark commands
- Host summary, DNS queries, and connection lists generated
- Timeline of connections created
- Findings correlated with disk/memory/email evidence

---

## Final_Report Lab Assessment

**Evidence Synthesis (25%)**
- Findings from all labs integrated into unified timeline
- Evidence from multiple sources (disk, memory, network, email) coordinated
- Timeline shows attack progression chronologically
- All major artifacts referenced

**Forensic Analysis & Reasoning (25%)**
- Evidence interpretation explained (what does each finding mean?)
- Correlations documented (how do findings from different labs support each other?)
- Attack narrative constructed (story of the compromise)
- Intent demonstrated (evidence of deliberate action vs. accident)

**Professional Documentation (25%)**
- Report follows professional forensic report standards
- Executive summary provided
- Detailed findings section with evidence references
- Appendix with analysis logs and supporting outputs
- Suitable for legal/management review

**Critical Reflection (25%)**
- Investigation methodology evaluated
- Tool effectiveness compared (CLI vs. GUI, automated vs. manual)
- Limitations acknowledged (what evidence was missing? what couldn't be determined?)
- Recommendations for future investigations

---

## Grading Scale

**Excellent (90-100%)**: All sections completed thoroughly. Evidence well-documented. Analysis shows deep understanding. Report professional and well-reasoned.

**Good (80-89%)**: All sections completed. Most evidence documented. Analysis shows solid understanding. Minor gaps or formatting issues.

**Satisfactory (70-79%)**: All main sections attempted. Basic documentation present. Analysis adequate but lacking depth. Some completeness issues.

**Needs Improvement (Below 70%)**: Incomplete sections. Missing key evidence or documentation. Analysis superficial or incorrect. Significant gaps.

---

## Notes for Instructors

- Rubrics are flexible and can be weighted differently based on course emphasis
- Students should understand that in real forensics, incomplete evidence is common - emphasize reasoning with available data
- Encourage students to document methodology thoroughly (others should be able to repeat the investigation and get similar results)
- Use these rubrics as teaching points: what makes analysis credible? What makes a report professional?
