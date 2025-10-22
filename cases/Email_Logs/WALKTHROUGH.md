# Lab 4: Email & Log Analysis - Complete Walkthrough

## Overview

This lab teaches you to analyze **email evidence and system logs** to build a comprehensive timeline of the Cloudcore data exfiltration incident. You'll parse mailbox files, extract email headers, analyze system logs for USB activity, and correlate all findings with evidence from previous labs.

**Time Estimate:** 90 minutes
**Difficulty:** Intermediate
**Tools:** grep, awk, sed, Python, hashlog (all within forensics container)

---

## Case Context

This lab represents **Phase 4** of the Cloudcore investigation (December 6, 2009). After the disk analysis (Lab 1), memory forensics (Lab 2), and GUI exploration (Lab 3), you'll now examine:

- **Email communications** that may contain exfiltrated data
- **System logs** showing USB device activity and user actions
- **Timeline correlation** between all evidence sources

The evidence suggests Alex Doe emailed sensitive files to an external account and used USB devices for physical data transfer. Your job is to find and document this evidence.

---

## Prerequisites Checklist

Before starting, ensure:

- [ ] Docker and Docker Compose are installed and running
- [ ] You've completed Labs 1-3 or understand the case context
- [ ] Evidence files exist: `evidence/mail.mbox`, `evidence/logs/`
- [ ] You've read `STORYLINE.md` for case background
- [ ] Docker toolbox image is built: `docker compose build dfir`
- [ ] Chain of custody CSV exists: `cases/chain_of_custody.csv`

**Test your setup:**
```bash
# Start the forensics container and login
docker compose run --rm dfir bash

# Once inside the container, verify evidence files exist
ls -lh /evidence/mail.mbox
ls -lh /evidence/logs/

# Verify log files
ls -lh /evidence/logs/syslog_usb
ls -lh /evidence/logs/mail.log

# Exit the container when done
exit
```

**Important:** All commands in this lab should be run from inside the forensics container. The workflow is:
1. Login: `docker compose run --rm dfir bash`
2. Run all analysis commands inside the container
3. Exit when complete: `exit`

---

## Lab Setup

### 1. Login to Forensics Workstation

```bash
# Start the forensics container and login
docker compose run --rm dfir bash
```

You should now be at a command prompt inside the forensics container, similar to Labs 1-2.

### 2. Create Output Directory

```bash
mkdir -p /cases/Email_Logs/analysis_output
```

This directory will store your extracted headers, log extracts, and analysis files.

### 3. Verify Evidence Integrity

Before analyzing, establish chain of custody for all evidence files:

```bash
COC_NOTE="Lab 4: Email and log analysis started" hashlog
```

**Expected Output:**
```
Hashing /evidence...
Added: mail.mbox | SHA256: [long hash] | Lab 4: Email and log analysis started
Added: logs/syslog_usb | SHA256: [long hash] | Lab 4: Email and log analysis started
Added: logs/mail.log | SHA256: [long hash] | Lab 4: Email and log analysis started
```

**Important:** Copy all SHA256 hashes to your `email_log_report.md` file.

---

## Step-by-Step Analysis

### Step 1: Examine the Mailbox Structure

First, understand the structure of the .mbox file:

```bash
# Count total messages
grep -c "^From " /evidence/mail.mbox

# View message separators
grep "^From " /evidence/mail.mbox | head -10
```

**Expected Output:**
```
3
From admin@cloudcore.com Mon Dec  7 08:00:00 2009
From hr@cloudcore.com Mon Dec  7 08:30:00 2009
From alex@cloudcore.com Mon Dec  7 09:45:00 2009
```

**What to note:**
- Total number of messages in the mailbox
- Date range of messages
- Senders and approximate sending times

### Step 2: Extract Email Headers

Extract headers from all messages for analysis:

```bash
# Extract all headers
awk '/^From / {msg=1} msg && /^$/ {msg=0} msg && !/^$/ {print}' /evidence/mail.mbox > /cases/Email_Logs/analysis_output/all_headers.txt

# View the extracted headers
cat /cases/Email_Logs/analysis_output/all_headers.txt
```

**Expected Output Format:**
```
From admin@cloudcore.com Mon Dec  7 08:00:00 2009
Date: Mon,  7 Dec 2009 08:00:00 +0000
From: admin@cloudcore.com
To: team@cloudcore.com
Subject: Daily System Backup Complete
Message-ID: <001@cloudcore.com>

From hr@cloudcore.com Mon Dec  7 08:30:00 2009
Date: Mon,  7 Dec 2009 08:30:00 +0000
From: hr@cloudcore.com
To: all@cloudcore.com
Subject: Holiday Reminder
Message-ID: <002@cloudcore.com>

From alex@cloudcore.com Mon Dec  7 09:45:00 2009
Date: Mon,  7 Dec 2009 09:45:00 +0000
From: alex@cloudcore.com
To: exfil@personal.com
Subject: Project Update
Message-ID: <123@cloudcore.com>
```

**What to look for:**
- **External recipients** (non-cloudcore.com domains)
- **Suspicious subject lines** (vague but potentially sensitive)
- **Message timing** (outside business hours?)
- **Message-ID patterns** (sequential or unusual)

### Step 3: Identify Suspicious Emails

Filter for emails sent to external domains:

```bash
# Find emails with external recipients
grep -A 10 -B 2 "exfil@personal.com" /evidence/mail.mbox > /cases/Email_Logs/analysis_output/suspicious_email.txt

# View the suspicious email
cat /cases/Email_Logs/analysis_output/suspicious_email.txt
```

**Expected Finding:**
```
From alex@cloudcore.com Mon Dec  7 09:45:00 2009
Date: Mon,  7 Dec 2009 09:45:00 +0000
From: alex@cloudcore.com
To: exfil@personal.com
Subject: Project Update
Message-ID: <123@cloudcore.com>

Attached: project_secrets.zip
(Contents: Sensitive code - exfiltrated)
```

**Key Evidence:**
- **Sender:** alex@cloudcore.com (the suspect)
- **Recipient:** exfil@personal.com (external personal account)
- **Time:** 09:45:00 (morning of December 7)
- **Subject:** "Project Update" (vague, potentially hiding true content)
- **Attachment:** project_secrets.zip (matches findings from other labs)

### Step 4: Analyze System Logs for USB Activity

Examine USB device insertion/removal events:

```bash
# View USB-related log entries
cat /evidence/logs/syslog_usb

# Extract USB events with timestamps
grep "usb" /evidence/logs/syslog_usb > /cases/Email_Logs/analysis_output/usb_events.txt

# View extracted USB events
cat /cases/Email_Logs/analysis_output/usb_events.txt
```

**Expected Output:**
```
Dec  6 09:45:01 workstation kernel: [12345.678] usb 1-1: New USB device found, idVendor=1234, idProduct=5678
```

**What to analyze:**
- **Timestamp:** December 6, 09:45:01 (day before the email)
- **Device details:** Vendor ID 1234, Product ID 5678
- **Correlation:** USB activity precedes email sending

### Step 5: Analyze Mail Server Logs

Check mail server logs for sending activity:

```bash
# View mail log entries
cat /evidence/logs/mail.log

# Extract email sending events
grep "TO:" /evidence/logs/mail.log > /cases/Email_Logs/analysis_output/mail_events.txt

# View extracted mail events
cat /cases/Email_Logs/analysis_output/mail_events.txt
```

**Expected Output:**
```
Dec  6 10:30:01 workstation postfix/smtp[pid]: TO: exfil@external.com
```

**What to analyze:**
- **Timestamp:** December 6, 10:30:01 (45 minutes after USB insertion)
- **Recipient:** exfil@external.com (matches the email analysis)
- **Process:** postfix/smtp (standard mail sending process)

### Step 6: Create Timeline Correlation

Build a timeline of all events:

```bash
# Create timeline file
cat > /cases/Email_Logs/analysis_output/timeline.txt << EOF
=== Cloudcore Investigation Timeline ===

Dec  6 09:45:01 - USB device inserted (Vendor:1234, Product:5678)
Dec  6 10:30:01 - Email sent to exfil@external.com via postfix
Dec  7 09:45:00 - Alex sends email to exfil@personal.com with project_secrets.zip

Correlation with Previous Labs:
- Lab 1: Deleted files around Dec 5, 14:30-15:00 (data staging)
- Lab 2: TrueCrypt process running Dec 5, 10:00 AM (encryption prep)
- Lab 3: File metadata showing modifications Dec 5 (GUI confirmation)
EOF

# View the timeline
cat cases/Email_Logs/analysis_output/timeline.txt
```

### Step 7: Advanced Analysis (Optional)

Use Python for more sophisticated analysis:

```bash
# Create Python script for email analysis
cat > /cases/Email_Logs/analysis_output/analyze_emails.py << 'EOF'
#!/usr/bin/env python3
import re
import email
from email import policy
from datetime import datetime

def parse_mbox(file_path):
    """Parse mbox file and extract email information"""
    emails = []
    
    with open(file_path, 'r') as f:
        content = f.read()
    
    # Split by mbox separator
    messages = content.split('\nFrom ')
    
    for msg in messages[1:]:  # Skip first empty split
        try:
            # Re-add the From separator that was removed
            msg = 'From ' + msg
            lines = msg.split('\n')
            
            # Extract basic info
            from_line = lines[0] if lines else ""
            date_match = re.search(r'Date: (.+)', msg)
            from_match = re.search(r'From: (.+)', msg)
            to_match = re.search(r'To: (.+)', msg)
            subj_match = re.search(r'Subject: (.+)', msg)
            
            email_info = {
                'mbox_from': from_line,
                'date': date_match.group(1) if date_match else '',
                'from': from_match.group(1) if from_match else '',
                'to': to_match.group(1) if to_match else '',
                'subject': subj_match.group(1) if subj_match else ''
            }
            
            emails.append(email_info)
            
        except Exception as e:
            print(f"Error parsing message: {e}")
    
    return emails

def analyze_emails(emails):
    """Analyze emails for suspicious patterns"""
    print("=== Email Analysis ===")
    print(f"Total emails: {len(emails)}")
    print()
    
    for i, email in enumerate(emails, 1):
        print(f"Email {i}:")
        print(f"  From: {email['from']}")
        print(f"  To: {email['to']}")
        print(f"  Subject: {email['subject']}")
        print(f"  Date: {email['date']}")
        
        # Check for suspicious patterns
        if 'personal.com' in email['to'] or 'external.com' in email['to']:
            print("  ⚠️  SUSPICIOUS: External recipient detected")
        
        if 'project' in email['subject'].lower() or 'secret' in email['subject'].lower():
            print("  ⚠️  SUSPICIOUS: Potentially sensitive subject")
        
        print()

if __name__ == "__main__":
    emails = parse_mbox("/evidence/mail.mbox")
    analyze_emails(emails)
EOF

# Run the analysis
python3 /cases/Email_Logs/analysis_output/analyze_emails.py
```

**Expected Output:**
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

---

## Analysis Guidance

### Building Your Investigation

As you analyze the evidence, answer these questions in your `email_log_report.md`:

1. **Evidence Integrity**
   - What are the SHA256 hashes of all evidence files?
   - Are they documented in chain_of_custody.csv?
   - Any evidence of tampering?

2. **Email Analysis**
   - How many total emails in the mailbox?
   - Which emails are suspicious and why?
   - What external domains received emails?
   - Are there attachments mentioned in suspicious emails?

3. **Log Analysis**
   - What USB devices were inserted and when?
   - What email sending activity occurred?
   - Do log timestamps match email headers?

4. **Timeline Correlation**
   - How do these findings correlate with Labs 1-3?
   - What's the complete sequence of events?
   - Are there any gaps or inconsistencies?

5. **Investigative Conclusions**
   - Does the evidence support data exfiltration?
   - How strong is the case against Alex Doe?
   - What additional evidence would strengthen the case?

---

## Expected Key Findings

By the end of this lab, you should have discovered:

1. **Suspicious Email Activity**
   - Alex emailed `project_secrets.zip` to external account
   - Timing correlates with USB activity
   - External recipient domain suggests personal exfiltration

2. **USB Device Evidence**
   - USB device inserted on December 6 at 09:45:01
   - 45 minutes before email sending activity
   - Suggests physical data transfer preparation

3. **Timeline Correlation**
   - December 5: File staging and deletion (Lab 1)
   - December 5: TrueCrypt encryption (Lab 2)
   - December 5: File modifications confirmed (Lab 3)
   - December 6: USB insertion and email sending (Lab 4)
   - December 7: Final exfiltration email

4. **Method of Operation**
   - Alex used multiple methods: USB + email
   - Staggered timing to avoid detection
   - External personal accounts for receiving data

---

## Completing the Report

Fill in `cases/Email_Logs/Lab4/email_log_report.md` with:

### 1. Evidence Summary
```
Evidence Files:
- mail.mbox (SHA256: [hash])
- logs/syslog_usb (SHA256: [hash])
- logs/mail.log (SHA256: [hash])

Chain of Custody:
- All hashes documented in cases/chain_of_custody.csv
- No evidence of tampering detected
```

### 2. Methods
```
Tools Used:
- grep/awk/sed for log parsing
- Python 3 for email analysis
- hashlog for evidence integrity
- Manual timeline correlation

Commands Executed:
- grep -c "^From " evidence/mail.mbox
- awk '/^From / {msg=1} msg && /^$/ {msg=0} msg && !/^$/ {print}' evidence/mail.mbox
- grep "usb" evidence/logs/syslog_usb
- grep "TO:" evidence/logs/mail.log
- Custom Python script for email analysis
```

### 3. Findings
**Email Analysis:**
- Total emails: 3
- Suspicious emails: 1 (alex@cloudcore.com to exfil@personal.com)
- External domains: personal.com
- Attachments: project_secrets.zip mentioned

**Log Analysis:**
- USB insertion: Dec 6 09:45:01 (Vendor:1234, Product:5678)
- Email sending: Dec 6 10:30:01 to exfil@external.com
- Process: postfix/smtp

**Timeline Correlation:**
- Dec 5: File staging/deletion (Lab 1)
- Dec 5: TrueCrypt activity (Lab 2)
- Dec 6: USB + email preparation (Lab 4)
- Dec 7: Final exfiltration email

### 4. Interpretation
**Supporting Evidence:**
- Multiple exfiltration methods (USB + email)
- Consistent timeline across all evidence types
- External recipient confirms data left organization

**Contradictions:**
- None found - all evidence aligns

**Case Strength:**
- Strong correlation between all labs
- Multiple independent evidence sources
- Clear method of operation established

### 5. Conclusion
**Assessment:**
- Evidence strongly supports data exfiltration theory
- Alex Doe used sophisticated multi-method approach
- Timeline shows deliberate, staged data theft

**Recommendations:**
- Proceed with Lab 5 network analysis for final confirmation
- Prepare for Lab 6 comprehensive reporting
- Consider legal implications of evidence

---

## Troubleshooting

### Problem: "grep returns no results from mbox file"
**Solutions:**
- Check file encoding: `file evidence/mail.mbox`
- Try different line ending handling: `dos2unix evidence/mail.mbox`
- Verify file is not corrupted: `head -20 evidence/mail.mbox`

### Problem: "Python script fails to parse emails"
**Solutions:**
- Check Python version: `docker compose run --rm dfir python3 --version`
- Verify file paths in script are correct
- Try simpler parsing approach first (basic grep)

### Problem: "Log files show different timestamps"
**Possible causes:**
- Timezone differences between logs
- System clock drift
- Different log formats

**Solutions:**
- Standardize all timestamps to UTC
- Note timezone differences in your report
- Use relative timing (deltas) rather than absolute times

### Problem: "Chain of custody hashes don't match"
**Solutions:**
- Re-hash files and update documentation
- Check for file corruption: `hexdump -C evidence/mail.mbox | head`
- Document any discrepancies in your report

### Problem: "Timeline has gaps or overlaps"
**Solutions:**
- Review timestamp precision (some logs only show minute-level)
- Consider log rotation or missing entries
- Document uncertainties in your analysis

---

## Submission Checklist

Before submitting, ensure you have:

- [ ] `cases/Email_Logs/analysis_output/` folder with:
  - `all_headers.txt`
  - `suspicious_email.txt`
  - `usb_events.txt`
  - `mail_events.txt`
  - `timeline.txt`
  - `analyze_emails.py` (if used)
- [ ] `cases/Email_Logs/Lab4/email_log_report.md` completed with all sections
- [ ] `cases/chain_of_custody.csv` updated with all evidence hashes
- [ ] Timeline correlation with Labs 1-3 clearly documented
- [ ] All suspicious findings highlighted and explained

---

## Going Further (Optional Extensions)

If you finish early or want deeper analysis:

1. **Advanced Email Parsing:**
```bash
# Extract all attachments (if any exist)
   munpack -f /evidence/mail.mbox
   ```

2. **Log Pattern Analysis:**
   ```bash
   # Search for other suspicious log patterns
   grep -E "(error|fail|denied|unauthorized)" /evidence/logs/* > /cases/Email_Logs/analysis_output/suspicious_logs.txt
   ```

3. **Timeline Visualization:**
   ```python
   # Create timeline visualization script
   # (Use matplotlib or similar for timeline graph)
   ```

4. **Cross-Reference with Network Evidence:**
   - Preview Lab 5 network.cap for IP addresses
   - Correlate email server logs with network traffic

5. **Metadata Extraction:**
   ```bash
   # Extract full email metadata
   python3 -c "
   import email
   with open('/evidence/mail.mbox', 'r') as f:
       for msg in email.message_from_file(f):
           print('Message-ID:', msg.get('Message-ID'))
           print('Received:', msg.get('Received'))
           print('---')
   "
   ```

---

## Additional Resources

- **Email Header Analysis:** https://toolbox.googleapps.com/apps/messageheader/
- **Mbox Format Documentation:** RFC 4155
- **Linux Log Analysis:** https://www.thegeekstuff.com/2009/08/linux-log-files/
- **Digital Forensics Timeline:** Correlation techniques and tools
- **DFIR Training:** See `STORYLINE.md` and `COURSE_MAPPING.md` for context

---

## Questions or Issues?

- Check `TROUBLESHOOTING.md` in the root directory
- Review `FACILITATION.md` for teaching notes
- Consult with your instructor or lab assistant
- Reference email forensics documentation for advanced techniques

**Remember:** Email and log analysis often provides the crucial timeline evidence that ties all other forensic artifacts together. Precision in timestamp correlation is key!

---

**Next Lab:** Lab 5 - Network Traffic Analysis