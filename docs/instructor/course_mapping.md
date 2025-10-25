# Suggested Course Mapping: Cyber Forensics (12 Weeks)

This 12-week schedule maps theory, readings, and hands-on labs from the repo to a typical cyber forensics course. The labs can be assigned in different orders based on your curriculum - this mapping is one suggested approach.

**Course Structure:**
- Total: ~25-30 hours, 2-3 hrs/week of theory and lab work
- Labs are flexible - can be reordered based on student interests and curriculum fit
- Assessments progressively build skills from evidence handling to final reporting

**Assessment Weighting** (example):
- Assessment 1 (20%): Evidence handling fundamentals (USB_Imaging or Memory_Forensics)
- Assessment 2 (40%): Multi-source analysis (2-3 labs combined)
- Assessment 3 (40%): Final Report synthesis

---

## Week 1: Introduction to Cyber Forensics

- **Theory**: Overview of DFIR (Digital Forensics & Incident Response); roles, principles (ACPO/ISO 27037); investigative workflow.
- **Readings**:
  - `storyline.md` (case narrative - what actually happened)
  - `scenario.md` (incident background and context)
  - `setup.md` (environment setup instructions)
- **Activities**: Course introduction, environment setup, repository familiarization. No lab work.
- **Assessment**: None (formative - participation).
- **Duration**: 2hrs lecture + 1hr setup/demo.

---

## Week 2: Legal, Ethical, and Regulatory Foundations

- **Theory**: Laws and regulations (Computer Misuse Act, GDPR, admissibility); ethics in forensics; professional standards.
- **Readings**:
  - `glossary.md` (forensic terms and concepts)
  - `scenario.md` (historical context of the Cloudcore incident)
- **Activities**:
  - Discussion: "What legal and ethical issues does this case raise?"
  - Activity: Identify potential evidence admissibility problems in your jurisdiction
- **Assessment**: None (formative - discussion participation).
- **Duration**: 2hrs lecture + 1hr discussion.

---

## Week 3: Chain of Custody and Evidence Integrity

- **Theory**: Chain of custody principles, hashing (MD5/SHA-256), documentation standards, evidence handling procedures.
- **Readings**:
  - `facilitation.md` (pre-course preparation section)
  - `rubrics.md` (assessment framework showing CoC emphasis)
  - `glossary.md` (write blockers, carving, investigation phases)
- **Activities**:
  - Lecture: CoC importance and real cases where it failed
  - Hands-on: Practice creating and documenting hash values
  - Case study: "How would you establish CoC in the Cloudcore incident?"
- **Assessment**: Homework - Design a CoC procedure for a hypothetical incident.
- **Duration**: 2hrs lecture + 1hr activity.

---

## Week 4: Persistent vs. Volatile Storage and Acquisition

- **Theory**:
  - Filesystems (FAT32, NTFS, ext4) and disk structure
  - RAM and volatile data
  - Acquisition methods (write blockers, dd, imaging tools)
  - Evidence preservation and verification
- **Readings**:
  - `glossary.md` (write blockers, carving, Sleuth Kit tools)
  - `troubleshooting.md` (Docker/FUSE issues)
- **Activities**:
  - Demo: Show FUSE mounting and filesystem structure
  - Overview of USB_Imaging and Memory_Forensics labs
  - Discussion: "Why does the order of acquisition matter?"
- **Assessment**: Quiz on storage types and acquisition methods.
- **Duration**: 2hrs lecture + 1hr demo.

---

## Week 5: Disk Forensics - File Recovery and Triage

**Suggested Lab: USB_Imaging**

- **Theory**: Filesystem analysis, deleted file recovery, carving, metadata extraction.
- **Readings**:
  - `cases/USB_Imaging/WALKTHROUGH.md` (detailed lab instructions)
  - `glossary.md` (carving, Sleuth Kit, chain of custody)
- **Activities**:
  - Full USB_Imaging lab: Recover deleted files, build timeline, document evidence
  - In-class: Compare recovered files with expected evidence
  - Discussion: "What evidence did you find? What does it suggest?"
- **Assessment 1 (20%)**: USB_Imaging lab submission (recovery findings + analysis log)
  - Chain of custody documentation (20%)
  - File recovery and triage (30%)
  - Evidence analysis and findings (30%)
  - Professional documentation (20%)
- **Duration**: 1hr theory + 2hrs lab work.

---

## Week 6: Graphical Forensic Tools and Automation

**Suggested Lab: Autopsy_GUI**

- **Theory**:
  - GUI forensic tools vs. CLI tools
  - Automated analysis (keyword searching, timeline generation, artifact extraction)
  - Tool limitations and validation
- **Readings**:
  - `cases/Autopsy_GUI/WALKTHROUGH.md` (Autopsy lab with detailed explanations)
  - `glossary.md` (Autopsy, Sleuth Kit, forensic tools)
- **Activities**:
  - Full Autopsy_GUI lab: Load disk image, run ingest modules, perform analysis
  - Compare Autopsy results with USB_Imaging CLI findings
  - Group activity: "What did GUI automation find that CLI required manual steps for?"
- **Assessment**: Peer review of USB_Imaging reports; formative feedback on Autopsy methodology.
- **Duration**: 1hr theory + 2hrs lab work.

---

## Week 7: Memory Forensics and Malware Analysis

**Suggested Lab: Memory_Forensics**

- **Theory**:
  - Memory structure and processes
  - Live memory acquisition and analysis
  - Detecting malware (keyloggers, rootkits, remote access tools)
  - Network connections in memory
- **Readings**:
  - `cases/Memory_Forensics/WALKTHROUGH.md` (memory analysis lab)
  - `glossary.md` (Volatility, keylogger, C2, memory forensics)
- **Activities**:
  - Full Memory_Forensics lab: Analyze memory dump with Volatility
  - Identify suspicious processes and network connections
  - Extract evidence from memory (DLL analysis, strings extraction)
  - Discussion: "How does memory evidence support or refute disk evidence?"
- **Assessment**: Formative - lab completion and process documentation.
- **Duration**: 1hr theory + 2hrs lab work.

---

## Week 8: Network Forensics and Attack Detection

**Suggested Lab: Network_Analysis**

- **Theory**:
  - Network protocols (TCP/IP, DNS, HTTP, IRC)
  - PCAP analysis and filtering
  - C2 detection and data exfiltration identification
  - Network timeline construction
- **Readings**:
  - `cases/Network_Analysis/WALKTHROUGH.md` (network analysis lab with comprehensive explanations)
  - `glossary.md` (tshark, IRC, C2, exfiltration, botnet)
- **Activities**:
  - Full Network_Analysis lab: Analyze PCAP file, identify IRC C2, detect exfiltration
  - Protocol filtering with tshark (DNS, HTTP, IRC)
  - Conversation analysis and data volume calculation
  - Group discussion: "What does the network evidence tell us about the attack?"
- **Assessment**: Formative - discussion and lab process.
- **Duration**: 1hr theory + 2hrs lab work.

---

## Week 9: Email and Log Analysis

**Suggested Lab: Email_Logs**

- **Theory**:
  - Email format and headers (SMTP, IMAP, POP3)
  - Log format and parsing (syslog, Windows Event Viewer)
  - Evidence of intent in communications
  - Timeline correlation across sources
- **Readings**:
  - `cases/Email_Logs/WALKTHROUGH.md` (email analysis lab)
  - `glossary.md` (chain of custody, exfiltration, correlation)
- **Activities**:
  - Full Email_Logs lab: Extract and analyze emails, identify suspicious communications
  - Correlate email timestamps with other evidence (disk, memory, network)
  - Timeline building: "When did each phase of the attack occur?"
  - Case analysis: "Does the email prove intent to steal data?"
- **Assessment**: Formative - lab completion and evidence correlation notes.
- **Duration**: 1hr theory + 2hrs lab work.

---

## Week 10: Evidence Correlation and Forensic Reasoning

- **Theory**:
  - Multi-source evidence analysis
  - Timeline construction and synchronization
  - Establishing proof through correlation
  - Burden of proof and evidence standards
- **Readings**:
  - `storyline.md` (what actually happened - reveals correlations students should find)
  - `glossary.md` (investigation phases: triage, deep dive, correlation, reporting)
  - `rubrics.md` (final report assessment criteria)
- **Activities**:
  - Review findings from labs completed so far
  - Build unified timeline combining disk, memory, network, and email evidence
  - Peer activity: "Which evidence is most damning? Why?"
  - Group work: Start constructing Final_Report narrative
- **Assessment 2 (40%)**: Multi-source analysis report
  - Evidence synthesis from at least 3 different labs
  - Timeline showing coordination across sources
  - Correlation narrative explaining what happened
  - Can be structured as report or presentation
- **Duration**: 1hr theory + 2hrs group work.

---

## Week 11: Constructing Forensic Reports

- **Theory**:
  - Report writing standards and structure
  - Executive summaries for different audiences
  - Appendices and supporting evidence
  - Legal vs. technical documentation
  - Presentation strategies
- **Readings**:
  - `facilitation.md` (student learning outcomes and assessment guidance)
  - `rubrics.md` (final report assessment criteria)
  - Examples of well-structured reports (case studies)
- **Activities**:
  - Lecture: "What makes a forensic report credible?"
  - Work session: Students begin structuring their Final_Report
  - Peer review of report outlines
  - Final evidence synthesis: Ensure all findings are documented
- **Assessment**: Draft report submitted for feedback.
- **Duration**: 1hr lecture + 2hrs work session.

---

## Week 12: Final Reports and Course Synthesis

**Final Lab: Final_Report**

- **Theory**:
  - Critical reflection on forensic methodology
  - Acknowledging limitations and gaps
  - Recommendations for future investigations
  - Course synthesis
- **Activities**:
  - Complete Final_Report lab: Synthesize all evidence into professional report
  - Report should include:
    - Executive summary
    - Timeline of attack phases
    - Evidence from each lab with correlation analysis
    - Forensic reasoning and conclusions
    - Recommendations for the organization
    - Acknowledgment of limitations
  - Final presentations (5 min each if class size allows)
  - Course reflection: "What was most challenging? What did you learn?"
- **Assessment 3 (40%)**: Final_Report submission
  - Evidence synthesis (25%)
  - Forensic analysis and reasoning (25%)
  - Professional documentation (25%)
  - Critical reflection on methodology (25%)
- **Duration**: 1hr guidance + 2hrs work + presentations.

---

## Course Structure Summary

### Lab Assignment Options:

**Sequential Option** (this mapping):
- Weeks 5-9: One lab per week (USB_Imaging, Autopsy_GUI, Memory_Forensics, Network_Analysis, Email_Logs)
- Weeks 10-12: Integration and reporting

**Parallel Option** (for longer courses):
- Week 5-6: USB_Imaging + Memory_Forensics simultaneously
- Week 7-8: Autopsy_GUI + Network_Analysis simultaneously
- Week 9-10: Email_Logs + begin Final_Report
- Week 11-12: Complete Final_Report

**Interest-Based Option** (let students choose):
- Provide all labs simultaneously after Week 4
- Students choose which labs interest them (min 3, max 5)
- Stagger submissions
- All must complete Final_Report

---

## Assessment Summary

| Assessment | Week | Weight | Content | Skills Assessed |
|---|---|---|---|---|
| **Assessment 1** | 5 | 20% | One forensic lab (USB_Imaging recommended) | CoC, evidence handling, triage, analysis |
| **Assessment 2** | 10 | 40% | Multi-source correlation (2-3 labs) | Synthesis, timeline building, reasoning |
| **Assessment 3** | 12 | 40% | Final Report | Professional reporting, critical reflection, conclusions |

---

## Resources for Instructors

**Student-Facing Docs:**
- `scenario.md` - Case background
- `storyline.md` - What actually happened (answers key)
- `glossary.md` - Forensic terms
- `setup.md` - Environment setup
- `troubleshooting.md` - Common issues

**Instructor Docs:**
- `facilitation.md` - Teaching strategies and engagement tips
- `rubrics.md` - Grading rubrics and assessment framework
- `course_mapping.md` - This document

**Lab Walkthroughs:**
- `cases/USB_Imaging/WALKTHROUGH.md`
- `cases/Memory_Forensics/WALKTHROUGH.md`
- `cases/Autopsy_GUI/WALKTHROUGH.md`
- `cases/Email_Logs/WALKTHROUGH.md`
- `cases/Network_Analysis/WALKTHROUGH.md`
- `cases/Final_Report/WALKTHROUGH.md`

---

## Notes for Adaptation

- **Shorter course (8 weeks)**: Combine Weeks 1-2 (legal/intro), 4-5 (storage/USB), 6-7 (Autopsy/Memory), 8-9 (Network/Email), 10-12 (Reporting). Have students do 3 labs minimum + Final_Report.

- **Longer course (16 weeks)**: Add deep dives on specific topics:
  - Advanced memory analysis (rootkit detection, kernel exploitation)
  - Encrypted evidence (encrypted containers, file encryption)
  - Advanced network analysis (SSL/TLS certificate analysis, steganography)
  - Malware analysis (YARA rules, behavior analysis)

- **Different student levels**:
  - Introductory: Labs 1, 4, Final_Report
  - Intermediate: All standard labs
  - Advanced: Add forensic tools comparison, cloud forensics, incident response playbooks

- **Lab ordering flexibility**: These labs work in any order except Final_Report. Customize based on your curriculum flow or student interests.

---

## Notes

- Update readings/theory to match your textbook and course materials
- See `facilitation.md` for detailed teaching tips for each lab
- See `rubrics.md` for grading guidance
- Adjust assessment weighting based on your institution's requirements
- Encourage students to consult `glossary.md` for unfamiliar forensic terms

Update as your course evolves.
