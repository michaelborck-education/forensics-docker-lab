# Consolidated Rubrics

## Lab 1: Imaging & Triage (100%)
- Chain-of-custody (20%): Accurate CSV entries, timestamps, hashes.
- Recovery (30%): Correct TSK/Foremost use; flag.txt content "secret" verified.
- Timeline (30%): Plaso CSV with 3-5 notable events (mount/create/delete/umount).
- Report (20%): Clear steps, references artifacts; ID/name included.

## Lab 2: Memory Forensics (100%)
- CoC (20%): Hash logged for memory.ram.
- Plugins (30%): pslist/pstree/netscan outputs; TrueCrypt PID identified.
- Extraction (30%): Memmap dump with strings (volume paths/URLs).
- Report (20%): Analysis tying to exfil prep; screenshot plugins.

## Lab 3: Autopsy GUI (100%)
- Setup (20%): Case load, evidence add in GUI.
- Exploration (30%): Files/keywords (secret hits), metadata recovery.
- Report Export (30%): HTML/PDF with recovered files, USB thumbnails.
- Documentation (20%): Screenshots/notes correlating to disk.

## Lab 4: Email & Logs (100%)
- CoC (20%): Hashes for mbox/logs.
- Parsing (30%): Headers (exfil email to personal.com), USB events extracted.
- Correlation (30%): Timestamps link email (09:45) to USB (09:50).
- Report (20%): Annotated extracts; intent evidence.

## Lab 5: Network Analysis (100%)
- CoC (20%): Hash for network.cap.
- Parsing (30%): Tshark IRC C2 (hunt3d, downloads), .advscan.
- Suspicious (30%): Botnet/deploy exfil tool tied to HTTP POST ~50MB.
- Report (20%): Phases fit (C2 for deniability).

## Lab 6: Consolidation (100%)
- CoC (20%): Maintained across all.
- Timeline (30%): Unified events from tools (2009-12-05/06).
- Findings (30%): IP theft narrative, TrueCrypt/IRC correlations.
- Report (20%): Professional (summary, appendix, recommendations).

Total: Holistic scoring; 100% if complete.
