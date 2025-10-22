# Forensic Lab 4: Email & Log Analysis

**Goal:** Learn to analyse mailbox exports and system logs to detect evidence of exfiltration.

**Skills:**  
- Parse mailbox (`.mbox`) headers and attachments.  
- Search system logs for USB insert/remove events.  
- Correlate timestamps with prior disk/memory findings.  

---

## 🚀 Quick Start - Immersive Workstation

**Mac/Linux:** `./scripts/forensics-workstation`
**Windows:** `.\scripts\forensics-workstation.ps1`

---

## Evidence
- `evidence/mail.mbox` (exported mailbox).  
- `evidence/logs/` (system logs).  

---

## Tasks
1. Hash all evidence files (`mail.mbox`, logs).
2. Extract headers from suspicious emails (look for external recipients, attachments).
3. Identify log entries showing USB mount events.
4. Correlate timestamps with recovered files and memory findings.
5. Document in `email_log_report.md` - Start with: `cp templates/WORKBOOK.md cases/Email_Logs/email_log_report.md`

---

## Deliverables
- `cases/Email_Logs/email_log_report.md` (template).  
- Copies of suspicious email headers (`cases/Email_Logs/headers.txt`).  
- Annotated log extracts (`cases/Email_Logs/log_extracts.txt`).  
- Updated chain_of_custody.csv.
