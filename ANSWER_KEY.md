# Forensics Docker Lab: Answer Key and Expected Findings

This document provides spoiler-free guidance on expected outcomes for each lab. Use it to verify analyses, prepare teaching, or self-assess. It reveals key artifacts and findings tied to the overarching exfiltration storyline (employee Alex Doe staging/deleting sensitive data, using USB/email/network for transfer). Avoid sharing with students before completing labs.

## Lab 1: Imaging, Integrity & Initial Triage (Disk Recovery)
- **Chain-of-Custody:** `cases/chain_of_custody.csv` logs SHA-256 of `evidence/disk.img` (e.g., post-creation hash: ~`e3b0c442...` for empty-like, but verify your runtime).
- **File Listing (`fls.txt`):** Shows deleted entry for `/flag.txt` (inode ~12, size 7 bytes, deleted timestamp ~2025-08-10 15:00).
- **Recovery:**
  - TSK: `tsk_recover_out/$ORPHAN_FILES/flag.txt` or similar; content: "secret".
  - Foremost: `foremost_out/flag.txt` carves the text string.
- **Timeline (`timeline.csv`):** Notable events:
  - Mount: 2025-08-10 14:30 (inode 2).
  - File create/delete: 2025-08-10 15:00 (inode 12, event types: CREATED, DELETED).
  - Umount: 2025-08-10 15:05.
- **Triage Report:** Summarize recovery of "secret" as initial evidence of hidden data; timeline indicates quick staging/deletion.

## Lab 2: Memory Forensics with Volatility 3
- **Chain-of-Custody:** Updated CSV with `memdump.raw` hash (sample: ~`5f4dcc3b...` for test dumps).
- **Plugin Outputs:**
  - `pslist.txt`: Lists processes; suspect: PID 1234 "notepad.exe" (PPID 1, start ~10:00, injected code).
  - `pstree.txt`: Tree shows "notepad.exe" child of explorer.exe; anomalies: hidden threads.
  - `netscan.txt`: Localhost connections (127.0.0.1:445 to 1234) for staging; prep outbound to 192.168.1.100.
- **Extraction:** Memmap PID 1234 dumps ~1MB memory containing encoded "project_secrets" string.
- **Memory Report:** Identify exfil process masquerading as notepad; correlates to Lab 1 deletion time (~2 hours later in memory capture).

## Lab 3: Autopsy GUI Exploration
- **Case Setup:** Loads `disk.img`; base dir `/cases/Lab3/autopsy_case`.
- **Exploration Findings:**
  - Files: Recovers `/flag.txt` (deleted, metadata: modified 15:00, size 7).
  - Keyword Search ("secret"): Hits on carved content.
  - Metadata: Timestamps match Plaso; thumbnails show USB icon in /mnt.
- **Report Export:** HTML/PDF lists 1 recovered file, 0 hash matches (if no DB); notes USB mount anomaly.
- **Autopsy Report:** GUI confirms disk findings; screenshot keyword hits as "suspicious hidden data".

## Lab 4: Email & Log Analysis
- **Chain-of-Custody:** Hashes for `mail.mbox` (~`d41d8cd9...`), logs files.
- **Email Headers (`headers.txt`):** From `mail.mbox`:
  - Subject: "Project Update", To: exfil@personal.com, Date: 2025-08-13 09:45, Attachment: project_secrets.zip (~50MB implied).
  - BCC external; user-agent suspicious (custom script).
- **Log Extracts (`log_extracts.txt`):**
  - syslog_usb: "Aug 13 09:50:01 ... New USB device found, idVendor=1234" (post-email).
  - mail.log: SMTP delivery to external.com at 09:45.
- **Correlation:** USB insert 5 min after email; matches Lab 1/2 timestamps (staging to physical transfer).
- **Email/Log Report:** Evidence of intentional exfil via email + USB; serial ID links to suspect device.

## Lab 5: Network Artifact Analysis
- **Chain-of-Custody:** Hash for `network.pcap` (~`4da6c...` for http sample).
- **Connections (`connections.txt`):** Tshark output:
  - TCP 203.0.113.50:8080 (external server), 10:32-10:45, transferred ~50MB (matches ZIP).
  - User-agent: "CustomExfil/1.0"; non-HTTP headers indicate tool.
- **Suspicious Sessions:** Large POST after USB removal (from logs); port 8080 odd for standard traffic.
- **Network Report:** Confirms final exfil over network post-staging; IP geolocates to suspect's region.

## Lab 6: Case Consolidation & Final Report
- **Unified Timeline:** Merge Plaso (disk events 08-10), Volatility (08-12 processes), logs/email (08-13 09:45-10:30), PCAP (10:32 transfer).
  - Full story: Deletion (hide tracks) → Memory staging → Email alert/USB copy → Network send.
- **Findings:** Exfiltrated "project_secrets.zip" (code/PII); suspect Alex Doe via process/email/IP.
- **Final Report:** Executive summary: IP theft detected, timeline graphic, recommendations (terminate employee, audit logs).
- **Appendix:** Reference all hashes, artifact paths; rubric score: 100% if correlations made.

## Verification Tips
- Run labs in order; use STORYLINE.md for narrative ties.
- Hashes vary by runtime (e.g., timestamps); focus on content matches.
- For teaching: Hide this file or use private branch; extend with real tools like Autopsy reports.

Update as samples evolve. This ensures reproducible education on DFIR workflows.