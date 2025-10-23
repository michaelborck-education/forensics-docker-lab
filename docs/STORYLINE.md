# Forensics Docker Lab: Overall Investigative Timeline and Story

## Case Background
This lab series simulates a digital forensics investigation into a suspected data exfiltration incident at Cloudcore Inc., a mid-sized software company. On 2009-12-05, IT security detected anomalous network activity and USB usage on employee workstations. The incident response team imaged affected systems (disks, memory) and collected logs, emails, and PCAPs. Your role is a forensic analyst piecing together the timeline of events.

## Key Timeline of Events (Chronological Narrative)
The following outlines the suspected exfiltration storyline, derived from artifacts across all labs. Each lab builds on prior findings to construct a coherent picture.

### Incident Setup (Pre-2009-12-05)
- **Context:** Employee "Alex Doe" (suspect) works in engineering with access to proprietary source code and client data.
- **Initial Actions:** Alex copies sensitive files (e.g., `project_secrets.zip`) to a workstation for staging.

### Phase 1: Local Preparation and Deletion (2009-12-01 to 12-05)
- **Disk Activity:** Files are created and mounted (visible in EXT4 timestamps). Deleted files like `flag.txt` (placeholder for secrets) are recovered via carving.
- **Link to Labs:** Lab 1 (Imaging & Triage) – Establish chain-of-custody for `usb.img`, recover deleted artifacts using Sleuth Kit and Foremost, build initial Plaso timeline showing file creation/deletion events around 12-05 14:30-15:00.
- **Key Findings:** Deleted file contained partial project notes; timeline shows mount at `/mnt/usb` followed by deletion to hide tracks.

### Phase 2: Malware Installation and Memory Analysis (2009-12-05, 02:11 AM)
- **Activity:** Previously, a keylogger (ToolKeylogger.exe) was installed to capture credentials and sensitive data. The malware runs silently under explorer.exe with internet connectivity to exfiltrate captured keystrokes to an attacker server.
- **Link to Labs:** Lab 2 (Memory Forensics) – Analyse `evidence/memory.raw` (Windows XP SP3 memory dump) with Volatility 2. Plugins (pslist/pstree) reveal ToolKeylogger.e (PID 280, parent explorer.exe) running malicious keylogger; dlllist shows loaded keylogging DLL and internet libraries (WININET.dll, urlmon.dll, iertutil.dll) for remote data exfiltration. psscan verifies the process is not hidden (visible in process list). Process started at 2009-12-05 02:11:23 UTC.
- **Key Findings:** Keylogger process tree shows malicious code spawned from normal user processes; loaded internet libraries prove data exfiltration capability; malware was active for 16+ hours before memory capture (18:47:28), capturing keystrokes and potentially passwords throughout the day. This is the mechanism for credential theft enabling later data access.

### Phase 3: GUI Exploration and Deep Dive (2009-12-05, Afternoon)
- **Activity:** Full filesystem and disk analysis reveals the timeline of file operations and hidden data. USB evidence is analyzed for data staging and removal.
- **Link to Labs:** Lab 3 (Autopsy GUI) – Load `usb.img` into Autopsy via noVNC. Keyword search for sensitive data (\"secret\", \"password\", \"project\") yields metadata hits; recover file timestamps and deleted artifacts; correlate with keylogger timeline from Lab 2.
- **Key Findings:** Autopsy reports confirm file operations during the time keylogger was active; deleted files and USB mount timeline correlate with keylogger capturing credentials; hash analysis identifies staging of sensitive files.

### Phase 4: Email and Log Correlation (2009-12-06)
- **Activity:** Alex emails attachments to external account (`exfil@personal.com`) and inserts USB for physical transfer.
- **Link to Labs:** Lab 4 (Email & Logs) – Parse `mail.mbox` for headers showing sent emails with ZIP attachments (08-13 09:45). Logs (`/var/log/syslog`) show USB mount events (e.g., \"New USB device found, ID 08-13 09:50\") correlating with email timestamps.
- **Key Findings:** Email headers reveal BCC to external domain; logs confirm USB serial \"12345-ABC\" insertion right after email, suggesting staged data transfer.

### Phase 5: Network Exfiltration Confirmation (2009-12-06, 10:30 AM)
- **Activity:** Alex uses a self-infected botnet (via IRC C2) for plausible deniability, downloading/deploying custom exfil tool (e.g., ysbinstall_1000489_3.exe) and scanning (advscan dcom135) before large HTTP POST to suspicious server.
- **Link to Labs:** Lab 5 (Network Analysis) – Tshark on `evidence/network.cap` (~114KB from ethical-hacking caps) reveals IRC connection to hunt3d.devilz.net (#s01/#sl0w3r), bot commands for exe downloads (bbnz.exe/jocker.exe/ysbinstall_1000489_3.exe), .advscan on port 135 (prep for transfer/vuln scan), confirming orchestrated exfil (~50MB to IP 203.0.113.50:8080 matching project_secrets.zip).
- **Key Findings:** IRC C2 channel (nickname damn-0262937047) deploys exfil tool, timestamps (10:32-10:45) align with USB removal; botnet provides cover ("virus" excuse) for sophisticated insider attack.

### Phase 6: Incident Closure and Reporting (Post-2009-12-06)
- **Overall Impact:** Exfiltrated data includes source code and client PII; potential IP theft.
- **Link to Labs:** Lab 6 (Consolidation) – Correlate all sources into a unified timeline (e.g., Plaso + PCAP + logs). Produce final report for management, recommending employee termination and system purge.

## Visual Timeline Reference
See `forensic_case_timeline.png` (or `.svg`) for a graphical overview of correlated events across sources. Key markers:

- Red: Suspicious actions (deletions, mounts, outbound traffic).
- Blue: Corroborating evidence (timestamps, hashes).
- Green: Chain-of-custody verification points.

## Learning Progression
- **Labs 1-3:** Build foundational skills (disk/memory analysis).
- **Labs 4-5:** Add correlation (logs/email/network).
- **Lab 6:** Synthesize into professional report.

This storyline ensures labs are interconnected: Start with isolated artifacts, end with holistic investigation. Update as needed based on your analysis findings.
