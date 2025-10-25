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

    # Split by mbox separator (--- between messages in this format)
    messages = content.split('\n---\n')

    for msg in messages:
        try:
            msg = msg.strip()
            if not msg:
                continue
                
            # Extract basic info using regex
            from_match = re.search(r'From: (.+)', msg)
            to_match = re.search(r'To: (.+)', msg)
            subj_match = re.search(r'Subject: (.+)', msg)
            date_match = re.search(r'Date: (.+)', msg)

            email_info = {
                'mbox_from': '',
                'date': date_match.group(1).strip() if date_match else '',
                'from': from_match.group(1).strip() if from_match else '',
                'to': to_match.group(1).strip() if to_match else '',
                'subject': subj_match.group(1).strip() if subj_match else ''
            }

            # Only add if we have some content
            if email_info['from'] or email_info['to']:
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
