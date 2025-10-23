# Email_Logs Lab - Student Walkthrough
## Email & System Log Analysis

**Time Estimate:** 1.5-2.5 hours
**Difficulty:** Intermediate
**Tools:** grep, awk, Python, text analysis tools

---

## 📸 Context: How Email and Logs are Captured (In Real Forensic Practice)

**Important Context:** In this lab, you're analyzing a **pre-captured email mailbox** (`mail.mbox`) and system logs. In real incident response, email and logs are extracted from live systems using forensically sound methods.

### Real-World Email & Log Capture Process

In a real incident response, a forensic technician would:

1. **Email Acquisition:**
   - Access email server (with proper authorization/warrant)
   - Export mailbox to standard format (mbox, PST, EML)
   - Tools used:
     - **Microsoft Outlook** - Export to PST format
     - **Google Vault** / **Microsoft Discovery** - Cloud email export
     - **pst-parser** (open source) - PST/OST file extraction
     - **mail server tools** - Native export from Exchange, Gmail, etc.
   - Capture with metadata: Sender, Recipient, Date, Subject, Attachments, Headers
   - Hash the exported mailbox file

2. **System Log Acquisition:**
   - Export logs from target system:
     - **Windows:** Event Viewer export (EVTX format) or text export
     - **Linux:** /var/log files (syslog, auth, kern.log, etc.)
   - Tools used:
     - **wevtutil** (Windows) - Event log export
     - **rsync/tar** (Linux) - Preserve permissions and timestamps
     - **FTK Imager** - Can extract logs from disk images
     - **Splunk/ELK** - Export from centralized logging
   - Document log sources and date ranges captured

3. **Verification:**
   - Hash each exported file
   - Verify date ranges and completeness
   - Check for truncation or missing entries
   - Document any access controls or filtering applied

4. **Documentation:**
   - When captured, by whom, from what system
   - Email server type and version
   - Date range of emails and logs
   - Hash of exported files
   - Any filtering or access restrictions
   - Completeness verification

### In This Lab

We've **skipped the export/capture phase** and provided you with:
- Pre-captured email mailbox (`mail.mbox` in standard mbox format)
- Analyzed email evidence from the Cloudcore incident

This lets you focus on:
- Email analysis
- Evidence interpretation
- Timeline correlation
- Investigating data exfiltration

But remember: In real forensics, email capture is CRITICAL because:
- ✓ Email servers can be modified (cover-up attempts)
- ✓ Hashing proves email integrity during export
- ✓ Chain of custody documents access to email system
- ✓ Professional tools preserve email headers and metadata
- ✓ Missing this step = evidence could be challenged in court

**Note:** This lab uses a simplified mbox format. Real email systems vary widely (Exchange, Gmail, Office 365, etc.) and require different extraction methods.

---

## 📋 Pre-Lab Setup

### 1. Copy Templates to Your Lab Folder

```bash
cp templates/chain_of_custody.csv cases/Email_Logs/chain_of_custody.csv
cp templates/analysis_log.csv cases/Email_Logs/analysis_log.csv
```

### 2. Verify Evidence Files

```bash
# On your host machine
ls -lh evidence/
# You should see: mail.mbox, network.cap, and possibly logs/
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

## 📧 Part 1: Chain of Custody - Hash Email Evidence

**CRITICAL:** Before analyzing ANY evidence, calculate and document hash values. This proves the evidence hasn't been tampered with.

### Step 1: Calculate MD5 Hash

```bash
md5sum /evidence/mail.mbox
```

**Example Output:**
```
83a0f673cada8bb15d22dcfbc4cfba18  /evidence/mail.mbox
```

**📋 Document in cases/Email_Logs/chain_of_custody.csv:**
- Evidence_ID: EMAIL-001
- MD5_Hash: (paste the hash from above)
- SHA256_Hash: (you'll add this next)
- Analyst_Name: (your name)
- Date_Received: (today's date)

### Step 2: Calculate SHA256 Hash

```bash
sha256sum /evidence/mail.mbox
```

**Example Output:**
```
45ae66a11ff995a1a6e71484202418358c4531659dffa18eb21b1e1c335e8c7a  /evidence/mail.mbox
```

**📋 Update chain_of_custody.csv:**
- Add the SHA256_Hash value above

**Why document hashes?**
- **Integrity verification:** Proves evidence hasn't been modified or corrupted
- **Legal admissibility:** Courts require hash verification for digital evidence
- **Reproducibility:** Other investigators can verify they're analyzing the same evidence
- **Chain of custody:** Documents the starting point of analysis

**📋 Document in analysis_log.csv:**

```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: md5sum /evidence/mail.mbox
exit_code: 0
note: Chain of custody - calculated MD5 hash of mail.mbox: 83a0f673cada8bb15d22dcfbc4cfba18
```

```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: sha256sum /evidence/mail.mbox
exit_code: 0
note: Chain of custody - calculated SHA256 hash of mail.mbox: 45ae66a11ff995a1a6e71484202418358c4531659dffa18eb21b1e1c335e8c7a
```

---

## 📨 Part 2: Extract Email Headers

**Why this step matters:**
Email headers are the "metadata" of communication - they show who contacted whom, when, about what, and whether evidence was attached. In insider threat cases, email headers often provide direct proof of intent and knowledge of wrongdoing. We're looking for:
- Communications to external addresses (exfiltration indicator)
- Timing patterns (coordinated attacks, specific dates)
- Subject lines that seem innocent but hide suspicious activity
- References to attachments (what data was sent?)

**How we know to do this:**
Email is often the "smoking gun" in data theft investigations. Unlike system logs that require interpretation, emails are explicit: "I'm sending X to Y at this time." Courts accept email headers as strong evidence of intent.

Mailbox (.mbox) files are text-based collections of emails. Extract headers to see sender, recipient, date, subject:

```bash
# List all senders and recipients
grep -E "^From:|^To:|^Date:|^Subject:" /evidence/mail.mbox > /cases/Email_Logs/email_headers.txt
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: grep -E "^From:|^To:|^Date:|^Subject:" /evidence/mail.mbox > /cases/Email_Logs/email_headers.txt
exit_code: 0
note: Extract email headers (sender, recipient, date, subject) - initial triage
```

Review the headers:

```bash
cat /cases/Email_Logs/email_headers.txt
```

**Expected Output:**
```
From: admin@cloudcore.com Mon Dec  7 08:00:00 2009
Date: Mon,  7 Dec 2009 08:00:00 +0000
From: admin@cloudcore.com
To: team@cloudcore.com
Subject: Daily System Backup Complete
From: hr@cloudcore.com Mon Dec  7 08:30:00 2009
Date: Mon,  7 Dec 2009 08:30:00 +0000
From: hr@cloudcore.com
To: all@cloudcore.com
Subject: Holiday Reminder
From: alex@cloudcore.com Mon Dec  7 09:45:00 2009
Date: Mon,  7 Dec 2009 09:45:00 +0000
From: alex@cloudcore.com
To: exfil@personal.com
Subject: Project Update
```

**🔍 Analysis Hints - What to look for:**

1. **Identify normal emails:** Which emails are routine company business?
   - Answer: Emails 1 & 2 (admin backups, HR announcements)

2. **Spot the suspicious email:** Which email stands out?
   - Answer: Email 3 - alex@cloudcore.com sending to **exfil@personal.com** (external personal account = RED FLAG)

3. **Red flag indicators:**
   - **External addresses:** Notice `exfil@personal.com` - NOT a company domain
   - **Personal account naming:** "exfil@" explicitly suggests "exfiltration"
   - **Innocent subject disguise:** "Project Update" hides true intent (actual intent: data theft)
   - **Timing pattern:** Dec 7, 09:45 - same day as other incidents

4. **Follow-up questions:**
   - What's in the "Project Update" attachment?
   - Why would an engineer email code to a personal email address?
   - Is exfil@personal.com linked to the suspect or external party?

---

## 🔍 Part 3: Search for Sensitive Keywords in Email

**Why this step matters:**
Keyword searching helps identify emails that discuss sensitive topics. Criminals and insider threats often use specific language patterns:
- "confidential", "secret", "do not forward" (data they know is sensitive)
- "export", "backup", "archive" (exfiltration terminology)
- "password", "credential", "access" (stealing authentication)
- "client", "proprietary" (intellectual property theft)

**How we know to do this:**
Email keyword analysis is a standard IR technique. Finding emails that explicitly mention sensitive data, export methods, or suspicious recipients gives investigators quick leads for prioritization.

```bash
# Search for suspicious keywords
grep -i "confidential\|secret\|password\|admin\|export\|backup\|exfil\|external" /evidence/mail.mbox > /cases/Email_Logs/email_keywords.txt
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: grep -i "confidential|secret|password|admin|export|backup|exfil|external" /evidence/mail.mbox > /cases/Email_Logs/email_keywords.txt
exit_code: 0
note: TRIAGE - Keyword search for suspicious terms in email content
```

Review results:

```bash
wc -l /cases/Email_Logs/email_keywords.txt
head -20 /cases/Email_Logs/email_keywords.txt
```

**Expected Output:**
```
7 /cases/Email_Logs/email_keywords.txt
From: admin@cloudcore.com Mon Dec  7 08:00:00 2009
From: admin@cloudcore.com
Subject: Daily System Backup Complete
Routine backup logs attached. No issues.
To: exfil@personal.com
Attached: project_secrets.zip
(Contents: Sensitive code - exfiltrated)
```

**🔍 Analysis Hints:**

1. **Count interpretation:** 7 lines of keyword matches from 3 emails
   - This is relatively low - means only a few emails have suspicious keywords
   - The presence of multiple keywords in one email is more suspicious than scattered occurrences

2. **Analyze keyword matches:**
   - **"backup"** found in Email 1 (routine admin task - benign)
   - **"exfil@"** found in Email 3 (THE RED FLAG - personal external account)
   - **"project_secrets"** found in Email 3 (confirms sensitive data being sent)
   - **"Sensitive code"** in Email 3 (explicit acknowledgment that it's sensitive!)

3. **Most suspicious finding:** Email 3 contains MULTIPLE red flags:
   - External recipient (exfil@personal.com)
   - Project secrets in subject
   - Attachment explicitly labeled "Sensitive code - exfiltrated"
   - Use of word "exfil" (common abbreviation for exfiltration)

4. **Pattern recognition:**
   - Compare with USB findings: project_secrets.zip matches project_secrets.txt recovered from USB
   - This email IS the exfiltration method
   - Timeline: Same date (Dec 7, 09:45) as other suspicious activity

5. **Key insight:**
   - The person who wrote this email ACKNOWLEDGES the data is sensitive
   - Sending to "exfil@personal.com" (not a typo - intentional account name)
   - This proves INTENT and KNOWLEDGE of wrongdoing
   - Strong evidence for prosecution

---

## 📊 Part 4: Extract Individual Emails

**Why this step matters:**
Once we've identified suspicious emails via headers and keywords, we need to read the complete messages. Individual emails show:
- Full message bodies (intent, planning, coordination)
- Actual attachment names and sizes
- Complete recipient lists (did they include BCC'd addresses?)
- Exact timestamps for timeline correlation

**How we know to do this:**
Individual email extraction is standard practice before detailed evidence analysis. It allows us to examine complete messages in context, not just extracted fields.

Extract complete emails for detailed analysis:

**Note:** The split command syntax varies by platform:

**On Linux (inside Docker container - recommended):**
```bash
# Split mailbox into individual emails using GNU split
split --separator="^From " /evidence/mail.mbox /cases/Email_Logs/email_
```

**On macOS/BSD (if running locally):**
```bash
# BSD split doesn't support --separator, use awk instead
awk '/^From /{filename=++count} {print > "/cases/Email_Logs/email_"filename}' /evidence/mail.mbox
```

For this lab, we'll use the **Linux version** (you're in Docker):

```bash
split --separator="^From " /evidence/mail.mbox /cases/Email_Logs/email_
```

List extracted emails:

```bash
ls -lh /cases/Email_Logs/email_*
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: split --separator="^From " /evidence/mail.mbox /cases/Email_Logs/email_
exit_code: 0
note: Extract individual emails from mailbox for detailed analysis
```

**Expected output:**
```
email_0
email_1
email_2
email_3
```

(3 emails total = 3 files + 1 empty header file)

---

## 📝 Part 5: Analyze Email Content

**Why this step matters:**
Now that we have individual emails, we can do detailed analysis. We're looking for:
- Specific suspicious communications (intent)
- Attachment evidence (what data was exfiltrated?)
- Timeline patterns (when did suspicious activity occur?)
- Proof of knowledge (did the sender know this was wrong?)

**How we know to do this:**
Complete email analysis reveals the "story" of the incident. Individual emails show planning, execution, and intent - the human element that transforms technical evidence into a narrative a jury can understand.

Review extracted emails for suspicious content:

```bash
# Count total emails
ls /cases/Email_Logs/email_* | wc -l

# Look at each email for suspicious content
cat /cases/Email_Logs/email_aa  # First email
cat /cases/Email_Logs/email_ab  # Second email
cat /cases/Email_Logs/email_ac  # Third email

# Search for attachments across all emails
grep -i "Content-Disposition: attachment\|Attached:" /cases/Email_Logs/email_* | wc -l

# Find emails mentioning external addresses
grep -i "exfil@\|personal\|gmail\|yahoo\|hotmail" /cases/Email_Logs/email_*
```

**📋 Document in analysis_log.csv for each suspicious email:**

```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: cat /cases/Email_Logs/email_ac
exit_code: 0
note: EVIDENCE ANALYSIS - Email from alex@cloudcore.com to exfil@personal.com, Subject: "Project Update", contains project_secrets.zip attachment. Direct evidence of intentional exfiltration to external personal account.
```

**Questions to answer:**
1. **How many emails total?** (count email_* files)
2. **Which are suspicious?** (emails to external domains, with attachments, mentioning secrets)
3. **What was attached?** (look for attachment names and descriptions)
4. **Timeline:** When was each email sent? Does it correlate with other incidents?
5. **Intent:** Do the emails show knowledge of wrongdoing? ("Project Update" as disguise, sending to personal account)

**In this lab's evidence, look for:**
- Email from alex@cloudcore.com to exfil@personal.com (personal external account = red flag)
- Subject line "Project Update" (innocent-sounding disguise)
- Attachment: project_secrets.zip (data exfiltration)
- This email is your "smoking gun" - direct proof of intent

---

## 🐍 Part 5b: Alternative - Automated Analysis with Python Script

**Two Approaches to Email Analysis:**

Forensic investigators have two tools available:
1. **Manual Unix commands** (Parts 2-5): Learn how email works, understand each field, detective-like
2. **Automated Python script** (this section): Fast, systematic, good for large datasets

### Which Approach When?

| Scenario | Unix Commands | Python Script |
|----------|---------------|---------------|
| **Learning/Training** | ✓ Better | - |
| **Understanding email structure** | ✓ Better | - |
| **Large mailbox (1000+ emails)** | - | ✓ Better |
| **Quick triage** | - | ✓ Better |
| **Detailed court analysis** | ✓ Better | - |
| **Finding patterns across many emails** | - | ✓ Better |
| **First principles forensics** | ✓ Better | - |

### Option A: Keep Manual Unix Analysis (Recommended for Learning)

You've already done this in Parts 2-5. The manual approach is excellent for understanding email structure and teaches forensic thinking.

**Pros:**
- ✓ Learn exactly how email files work
- ✓ Understand each field (From, To, Date, Subject, Attachments)
- ✓ See the evidence directly (detective-like approach)
- ✓ Easy to explain in court ("I examined each email individually")
- ✓ No script dependencies or assumptions
- ✓ Full transparency (jury sees the actual analysis)

**Cons:**
- ✗ Time-consuming for large mailboxes (1000+ emails)
- ✗ Manual extraction prone to human error
- ✗ Difficult to find patterns across many emails
- ✗ Not scalable to enterprise environments

### Option B: Use Python Script for Faster Analysis (Optional)

If you want to see an automated alternative, here's a Python script that does similar analysis programmatically:

**Script location:** `/cases/Email_Logs/analyse_emails.py`

**What the script does:**
```python
# Parse mbox file
# Extract From, To, Subject, Date fields
# Detect suspicious patterns:
#   - External recipients (personal.com, external.com)
#   - Suspicious subjects (project, secret, etc.)
# Print formatted report
```

**Run the script:**

```bash
# Run the analysis script (from anywhere in the workstation)
python3 /cases/Email_Logs/analyse_emails.py
```

**Note:** The script path in the original code may need to be fixed. The script should open `/evidence/mail.mbox` using the absolute path or from the correct directory. If you get a "FileNotFoundError", edit the script to use:
```python
with open("/evidence/mail.mbox", 'r') as f:  # absolute path
```

**Expected output:**
```
=== Email Analysis ===
Total emails: 3

Email 1:
  From: admin@cloudcore.com
  To: team@cloudcore.com
  Subject: Daily System Backup Complete
  Date: Mon,  7 Dec 2009 08:00:00 +0000

Email 2:
  From: hr@cloudcore.com
  To: all@cloudcore.com
  Subject: Holiday Reminder
  Date: Mon,  7 Dec 2009 08:30:00 +0000

Email 3:
  From: alex@cloudcore.com
  To: exfil@personal.com
  Subject: Project Update
  Date: Mon,  7 Dec 2009 09:45:00 +0000
  ⚠️  SUSPICIOUS: External recipient detected
  ⚠️  SUSPICIOUS: Potentially sensitive subject
```

**📋 Document in analysis_log.csv (if you run the script):**

```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: python3 analyse_emails.py
exit_code: 0
note: COMPARISON - Ran automated analysis script to verify manual findings and demonstrate automated approach
```

**Pros of Script Approach:**
- ✓ Fast analysis of large mailboxes
- ✓ Consistent pattern detection (no human variation)
- ✓ Easy to modify for different keywords
- ✓ Can scale to 10,000+ emails
- ✓ Good for initial triage of enterprise environments

**Cons of Script Approach:**
- ✗ Requires understanding Python code
- ✗ Script assumptions might miss evidence
- ✗ Black box approach (jury doesn't see how detection works)
- ✗ May miss sophisticated attacks (relies on keyword matching)
- ✗ Requires verification with manual analysis anyway

### Recommendation for This Lab:

**For Students:**
Use the manual Unix approach (Parts 2-5) because:
1. Learn how email evidence actually works
2. Develop forensic intuition and pattern recognition
3. Can explain each step to a jury
4. No dependencies on script assumptions

**In Real Forensic Work:**
Use BOTH approaches:
1. **First:** Python script for fast triage of large dataset
2. **Second:** Manual analysis of suspicious emails identified by script
3. **Third:** Manual Unix commands to verify script findings and document evidence
4. **Finally:** Expert testimony based on manual analysis

### Try It Yourself (Optional):

If you want to see the automated approach in action:

```bash
# You've already done manual analysis (Parts 2-5)
# Optionally, run the script to compare:
python3 /cases/Email_Logs/analyse_emails.py

# You should see the same suspicious email (Email 3) flagged
# Now you can appreciate why the manual approach found it:
# - External recipient (personal.com)
# - Suspicious subject (Project Update)
# - This matches what the script detected
```

---

## 📋 Part 6: Analyze System Logs (Optional)

If log files exist, analyze them:

```bash
# Check what logs are available
ls -lh /evidence/logs/
```

If USB logs exist:

```bash
# Extract USB device activity
grep -i "usb" /evidence/logs/* > /cases/Email_Logs/usb_activity.txt
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: grep -i "usb" /evidence/logs/* > /cases/Email_Logs/usb_activity.txt
exit_code: 0
note: Extract USB device connection/disconnection events from system logs
```

---

## 📈 Part 7: Timeline Correlation

Compare email timestamps with evidence from other labs:

**Create a timeline file:**

```bash
cat > /cases/Email_Logs/correlation_timeline.txt << 'EOF'
CORRELATION WITH OTHER LABS

USB_Imaging Findings:
- Files deleted: [date/time from USB_Imaging analysis]
- Timestamps of suspicious files:

Memory_Forensics Findings:
- Memory dump captured: [timestamp]
- TrueCrypt running: [yes/no]

Email_Logs Findings:
- Emails sent: [dates/times]
- To external address: [yes/no]

Network_Analysis Findings:
- Network capture date: [when]
- Suspicious traffic detected: [what/when]

TIMELINE ALIGNMENT:
Do the events correlate? Were files deleted, then encrypted, then emailed, then exfiltrated?
EOF
cat /cases/Email_Logs/correlation_timeline.txt
```

**📋 Document in analysis_log.csv:**
```
timestamp_utc: [run date -u]
analyst: [Your Name]
command: Created correlation_timeline.txt manually
exit_code: 0
note: Correlate email evidence with findings from Labs 1, 2, 5
```

---

## 🚪 Part 8: Exit the Workstation

```bash
exit
```

---

## ✅ Deliverables

You should have created in `cases/Email_Logs/`:

- ✅ `chain_of_custody.csv` - Evidence hash
- ✅ `analysis_log.csv` - All commands documented
- ✅ `email_headers.txt` - Extracted email headers
- ✅ `email_keywords.txt` - Keyword search results
- ✅ `email_*` - Individual email files
- ✅ `usb_activity.txt` - Log analysis (if applicable)
- ✅ `correlation_timeline.txt` - Timeline comparison

---

## 📊 Analysis Summary

Document your findings:

1. **Total emails:** (count of email_* files)
2. **Suspicious recipients:** (external email addresses)
3. **Keywords found:** (count and list of top keywords)
4. **Attachment count:** (total attachments in mailbox)
5. **Timeline patterns:** (suspicious timing?)
6. **Correlation with other labs:** (do events align?)

---

## 🆘 Troubleshooting

### "No mail.mbox file"
- Check evidence/ folder exists
- Verify file is named exactly mail.mbox
- Check file permissions

### "Split command doesn't work"
- Use alternative: `awk` to split emails
- Or use Python script to parse mbox files
- Ask instructor for email parsing script

### "grep finds nothing"
- Keywords might use different case or spelling
- Try broader search patterns
- Check file actually contains readable text

---

## 📚 Next Steps

After this lab:

1. Review all extracted emails
2. Identify most suspicious communications
3. Document sender/recipient patterns
4. Proceed to Network_Analysis when ready

Network traffic analysis will corroborate email findings!

---

## 📝 Summary - Quick Command Reference

```bash
# INSIDE the workstation:

# Hash verification
sha256sum /evidence/mail.mbox
md5sum /evidence/mail.mbox

# Extract headers
grep -E "^From:|^To:|^Date:|^Subject:" /evidence/mail.mbox > /cases/Email_Logs/email_headers.txt

# Keyword search
grep -i "confidential|secret|password|export" /evidence/mail.mbox > /cases/Email_Logs/email_keywords.txt

# Split into individual emails
split -p "^From " /evidence/mail.mbox /cases/Email_Logs/email_

# Count attachments
grep -i "Content-Disposition: attachment" /cases/Email_Logs/email_* | wc -l

# Search logs (if available)
grep -i "usb" /evidence/logs/* > /cases/Email_Logs/usb_activity.txt

# Exit workstation
exit
```

---

**Remember:** Email evidence often provides direct proof of intent and knowledge!
