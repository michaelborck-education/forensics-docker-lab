# Suggested Course Mapping: Cyber Forensics (12 Weeks)

This 12-week schedule maps theory, readings, and hands-on labs from the repo to a typical cyber forensics course. 

Total: 25 credits, ~3hrs/week theory + lab. 

Assessments: 

* 1 (20%, Lab 1-2), 
* 2 (40%, Labs 3-5), 
* 3 (40%, Lab 6 report). 

Adjust for class size/time.

## Week 1: Introduction to Cyber Forensics
- **Theory**: Overview of DFIR (Digital Forensics & Incident Response); roles, principles (ACPO/ISO 27037).
- **Readings**: STORYLINE.md (case narrative); main README (setup).
- **Activities**: Course intro, repo clone/setup (SETUP.md). No lab.
- **Assessment**: None.
- **Duration**: 2hrs lecture + 1hr setup.

## Week 2: Legal and Regulatory Requirements for Cyber Forensics
- **Theory**: Laws (e.g., Computer Misuse Act, GDPR for 2009 context); admissibility, ethics.
- **Readings**: GLOSSARY.md (CoC); ATTRIBUTIONS.md (public data ethics).
- **Activities**: Discussion: "Legal implications in M57 patent theft story."
- **Assessment**: None.
- **Duration**: 3hrs lecture.

## Week 3: Chain of Custody and Running Record
- **Theory**: CoC principles, hashing (SHA-256), documentation.
- **Readings**: FACILITATION.md (prep); RUBRICS.md (scoring).
- **Activities**: Intro Lab 1 (hashlog run; discuss evidence handling).
- **Assessment**: Homework: Simulate CoC for a file.
- **Duration**: 2hrs theory + 1hr activity.

## Week 4: Role of Persistent and Volatile Storage in Cyber Forensics
- **Theory**: Disk (EXT4/NTFS) vs. RAM (processes, encryption like TrueCrypt).
- **Readings**: TROUBLESHOOTING.md (tool issues).
- **Activities**: Overview Labs 1 (disk) & 2 (memory); demo pls/vol3.
- **Assessment**: Quiz on storage types.
- **Duration**: 2hrs theory + 1hr demo.

## Week 5: Data Acquisition Processes and Procedures
- **Theory**: Imaging (dd/fls), volatile capture (Volatility prep).
- **Readings**: Lab 1 README (acquisition script).
- **Activities**: Full Lab 1: Create/acquire disk.img, CoC baseline.
- **Assessment 1 (20%)**: Lab 1 submission (recovery/timeline report).
- **Duration**: 1hr theory + 2hrs lab.

## Week 6: Analysing Acquired Persistent Storage Images
- **Theory**: Filesystem analysis, carving, metadata.
- **Readings**: GLOSSARY.md (carving); WORKBOOK.md (Lab 3 template).
- **Activities**: Lab 3: Autopsy on disk.img (explore deleted, keywords).
- **Assessment**: Peer review Lab 1 reports.
- **Duration**: 1hr theory + 2hrs lab.

## Week 7: Analysing Acquired Volatile Storage Images
- **Theory**: Memory forensics (processes, netscan, extraction).
- **Readings**: Lab 2 README (plugins).
- **Activities**: Full Lab 2: Volatility on memory.ram (TrueCrypt/net).
- **Assessment**: None (prep for Assessment 2).
- **Duration**: 1hr theory + 2hrs lab.

## Week 8: Acquiring and Analysing Network Data
- **Theory**: PCAP basics, protocols (IRC/HTTP), C2 detection.
- **Readings**: Lab 5 README (tshark).
- **Activities**: Lab 5: Analyse network.cap (IRC bot/exfil).
- **Assessment**: Group discussion: "C2 in M57 vs. story."
- **Duration**: 1hr theory + 2hrs lab.

## Week 9: Analysing Logs and Correlating Events
- **Theory**: Log parsing (syslog/mbox), correlation techniques.
- **Readings**: Lab 4 README (grep).
- **Activities**: Full Lab 4: Parse mail.mbox/logs (USB/email tie).
- **Assessment**: None.
- **Duration**: 1hr theory + 2hrs lab.

## Week 10: Understanding Arbitrary Data Formats
- **Theory**: Carving arbitrary files, binary analysis (e.g., exfil payloads).
- **Readings**: WORKBOOK.md (notes); RUBRICS.md (Lab 6).
- **Activities**: Review Labs 1-5; prep encrypted_container.dat carving.
- **Assessment 2 (40%)**: Labs 3-5 combined (GUI + logs + network report).
- **Duration**: 1hr theory + 2hrs review.

## Week 11: Constructing a Coherent Forensic Timeline
- **Theory**: Timeline building (Plaso + manual merge), event correlation.
- **Readings**: STORYLINE.md (phases).
- **Activities**: Lab 6 part 1: Merge artifacts (disk/memory/logs/PCAP).
- **Assessment**: Timeline draft.
- **Duration**: 2hrs theory + 1hr activity.

## Week 12: Preparing a Forensic Report
- **Theory**: Report writing (structure, executive summary, appendices).
- **Readings**: FACILITATION.md (grading).
- **Activities**: Lab 6 part 2: Final report (narrative, recommendations).
- **Assessment 3 (40%)**: Full Lab 6 report.
- **Duration**: 1hr theory + 2hrs finalisation.

## Notes
- **Integration**: Labs follow theory; use WORKBOOK.md for notes.
- **Adapt**: Shorten to 8 weeks by combining 4/5, 6/8.
- **Resources**: TROUBLESHOOTING.md for issues; GLOSSARY.md for terms.
- **Total Assessments**: Progressive (build skills to report).

Update as needed.
