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
- **Link to Labs:** Lab 1 (Imaging & Triage) – Establish chain-of-custody for `disk.img`, recover deleted artifacts using Sleuth Kit and Foremost, build initial Plaso timeline showing file creation/deletion events around 12-05 14:30-15:00.
- **Key Findings:** Deleted file contained partial project notes; timeline shows mount at `/mnt/usb` followed by deletion to hide tracks.

### Phase 2: Memory Capture and Process Analysis (2009-12-05, 10:00 AM)
- **Activity:** Alex runs TrueCrypt to create an encrypted container for `project_secrets.zip`, spawning processes for hiding data (e.g., under explorer.exe), and initiates network staging.
- **Link to Labs:** Lab 2 (Memory Forensics) – Analyze `evidence/memory.winddramimage` (M57 scenario dump) with Volatility 3. Plugins (pslist/pstree) reveal TrueCrypt.exe (PID ~1000+, parent explorer.exe) for encryption; netscan shows localhost SMB/RPC and outbound connections (e.g., port 445) prepping data transfer. Dump process memory to extract strings like volume paths or IPs.
- **Key Findings:** TrueCrypt process tree indicates data concealment (hidden volumes for exfil prep); netscan detects external outbound (e.g., 192.168.1.100 suspect IP) linking to later network phase—correlates to Lab 1 deletion as staging hidden tracks.

### Phase 3: GUI Exploration and Deep Dive (2009-12-05, Afternoon)
- **Activity:** Full filesystem walkthrough identifies metadata anomalies (e.g., modified timestamps on `/home/alex/Documents/secrets/`).
- **Link to Labs:** Lab 3 (Autopsy GUI) – Load `disk.img` into Autopsy via noVNC. Keyword search for \"secret\" yields metadata hits; recover thumbnails of USB drive icons.
- **Key Findings:** Autopsy reports confirm file modifications post-deletion; hash lookups match known good artifacts.

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
