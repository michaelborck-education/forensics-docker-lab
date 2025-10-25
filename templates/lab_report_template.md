# Lab Report Template

Use this template for reporting findings from individual forensic labs (USB_Imaging, Memory_Forensics, Autopsy_GUI, Email_Logs, Network_Analysis).

---

## Title Page

**Lab Name**: [USB_Imaging | Memory_Forensics | Autopsy_GUI | Email_Logs | Network_Analysis]
**Student ID**: [Your Student ID]
**Name**: [Your Full Name]
**Date**: [Submission Date]
**Analyst Name** (in coc-log): [Name used during analysis]

---

## Table of Contents

- Evidence Chain of Custody
- Analysis Methodology
- Findings and Analysis
- Forensic Reasoning
- Correlation with Other Evidence
- Recommendations
- Methodology Reflection

---

## Evidence Chain of Custody

**Evidence File(s)**:
- File name: [e.g., usb.img or usb.E01]
- Size: [in bytes/MB/GB]
- MD5 Hash: [hash value]
- SHA256 Hash: [hash value]

**Acquisition Details**:
- Acquisition date/time: [UTC ISO format]
- Acquisition method: [Tool name and version, e.g., FTK Imager 4.x, Volatility 2.6]
- Write blocker used: [Yes/No, which model if applicable]

**Chain of Custody**:
- Evidence ID assigned: [e.g., USB-DISK-001]
- Case number: [if applicable]
- Storage location: [where evidence is kept]
- Access log: [attach chain_of_custody.csv]

---

## Analysis Methodology

**Tools Used**:
- [Tool name] (version): [What it does]
- [Tool name] (version): [What it does]

**Analysis Phases**:

### Phase 1: Triage
[Brief summary of initial reconnaissance—what tools were used to get an overview of the evidence. Which artifacts stood out as potentially significant?]

### Phase 2: Evidence Collection
[Detailed procedures used to extract evidence. Include:
- Specific commands/tool features used
- Rationale for each step (why this tool or approach?)
- Why you chose automated vs. manual analysis]

### Phase 3: Validation
[How did you verify findings? Did you cross-reference results? Run commands twice?]

---

## Findings and Analysis

### Key Evidence Discovered

**Finding 1: [Descriptive title]**
- Artifact(s): [File path(s), inode numbers, registry keys, network connections, etc.]
- Significance: [What does this indicate forensically?]
- Forensic Context: [How does this relate to the case?]
- Supporting evidence: [Include relevant output, file contents, or metadata]

**Finding 2: [Descriptive title]**
- Artifact(s): [...]
- Significance: [...]
- Forensic Context: [...]
- Supporting evidence: [...]

[Repeat for each significant finding]

### Evidence Summary Table

| Finding | Source | Timestamp | Hash/ID | Significance |
|---------|--------|-----------|---------|--------------|
| [Finding 1] | [Where found] | [When] | [Hash/ID] | [Brief significance] |
| [Finding 2] | [Where found] | [When] | [Hash/ID] | [Brief significance] |

---

## Forensic Reasoning

**What do these findings tell us?**

[Narrative analysis connecting findings to show what happened. Address:
- Timeline of events (when did suspicious activity occur?)
- Intent (evidence of deliberate vs. accidental activity?)
- Correlation (how do findings from different tools/sources support each other?)
- Gaps (what evidence is missing or incomplete?)]

---

## Correlation with Other Evidence

**Links to other labs** (if applicable):
- USB_Imaging findings: [How do your findings relate to disk evidence?]
- Memory_Forensics findings: [How do your findings relate to process/memory evidence?]
- Network_Analysis findings: [How do your findings relate to network traffic?]
- Email_Logs findings: [How do your findings relate to communications?]

---

## Recommendations

**For this investigation**:
[What should the investigator do next? What additional labs or deep dives would be valuable?]

**For the organisation**:
[Based on your findings, what should the organisation do to prevent similar incidents?]

---

## Methodology Reflection

**Tool Effectiveness**:
- Which tools were most useful for this lab? Why?
- Were there limitations in the tools used?
- Would a different tool or approach have been better?

**Analysis Reproducibility**:
- Could another analyst repeat your analysis and get the same results? (Consider: exact commands, tool versions, system differences)
- What documentation would they need?

**Forensic Integrity**:
- How did you maintain chain of custody during analysis?
- How did you verify evidence integrity throughout?

---

## Appendices

### A. Analysis Log
Attach `analysis_log.csv` showing all commands executed with timestamps, hashes, and output.

### B. Chain of Custody Documentation
Attach `chain_of_custody.csv` with complete evidence handling record.

### C. Supporting Output Files
List and briefly describe:
- Screenshots of key findings
- Tool output files (e.g., Volatility process listings, tshark packet summaries)
- Extracted artifacts (recovered files, email messages, etc.)

### D. References
- Tools/versions used: [with links to documentation]
- Case background: [scenario.md, storyline.md]
- Forensic principles: [relevant sections from course materials]

---

## Submission Checklist

- [ ] Lab name clearly identified
- [ ] Student information completed
- [ ] Chain of custody details included with hash verification
- [ ] All analysis commands documented in analysis_log.csv
- [ ] Findings clearly explained with artifacts referenced
- [ ] Forensic reasoning articulated (what do findings mean?)
- [ ] Correlation attempted with other evidence sources
- [ ] Methodology reflection addresses tool choices and limitations
- [ ] All appendices included (analysis log, CoC, supporting files)
- [ ] Report is 600-1000 words (excluding appendices)
- [ ] Professional formatting and writing quality

---

**Word Count Target**: 600-1000 words (excluding appendices)
**Format**: Submit as .md or .docx
**Include**: This lab report, analysis_log.csv, chain_of_custody.csv, and supporting files
