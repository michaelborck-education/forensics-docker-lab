# Cases Directory - Your Analysis Workspace

## Purpose
This folder is your WRITABLE workspace for all forensic analysis outputs.
Everything you create inside the Docker container at `/cases/` will appear here.

## Important Rules
✅ SAVE ALL YOUR WORK HERE
✅ This directory is mounted as read-write in the container
✅ Files created here are automatically synchronized to your host machine
✅ All analysis outputs, recovered files, and reports go here

⚠️ DO NOT modify files in /evidence (read-only)
⚠️ DO NOT commit this folder with sensitive recovered data to version control

## Recommended Structure

Organize your outputs like this:

cases/
├── chain_of_custody.csv          ← Evidence handling documentation
├── file_list.txt                 ← Complete file listing (fls output)
├── filesystem_timeline.csv       ← Timeline of file activity
├── filesystem_info.txt           ← File system metadata (fsstat output)
├── keyword_hits.txt              ← Keyword search results
├── command_log.txt               ← History of commands executed
├── recovered/                    ← Recovered files directory
│   ├── deleted_files/           ← Deleted files separated here
│   ├── files_of_interest/       ← Suspicious files isolated here
│   └── all_files/               ← Bulk recovery output
├── screenshots/                  ← Terminal screenshots and evidence
│   ├── terminal_output/
│   └── findings/
└── triage_report.md             ← Your final report (or .docx)

## How To Use

Inside the Docker container:
```bash
# Save file listings
fls -r -d /tmp/ewf/ewf1 > /cases/file_list.txt

# Recover all files
mkdir -p /cases/recovered
tsk_recover /tmp/ewf/ewf1 /cases/recovered

# Create subdirectories as needed
mkdir -p /cases/screenshots/terminal_output
```

On your host machine:
- Open `./cases/` in your file explorer
- View recovered files directly
- Edit reports in your preferred text editor
- Take screenshots and save to `./cases/screenshots/`

## Submission Preparation

When ready to submit, create this structure in a ZIP file:

StudentID_USB_Triage/
├── chain_of_custody.csv
├── recovered/
│   ├── deleted_files/
│   └── files_of_interest/
├── screenshots/
│   ├── autopsy_findings/ (if used)
│   └── terminal_output/
└── triage_report.docx (or .md)

See ASSIGNMENT.md for complete submission requirements.

## Need Help?

- See README.md for workspace organization tips
- Check COMMANDS.md for how to save outputs properly
- Review ASSIGNMENT.md for required deliverables

---

Note: This README.txt can be deleted before submission if desired.
It's here to help you organize your work during the lab.
