# Lab 4 - Instructor Notes & Changes Made

## Summary of Enhancements

Created a comprehensive `WALKTHROUGH.md` to supplement the existing `README.md`. The original README was too sparse for students unfamiliar with email forensics and log analysis techniques.

## Key Issues Addressed

### 1. Missing Evidence File Locations
- **Issue:** README references evidence files but doesn't specify exact paths
- **Fix:** Added precise file paths and verification commands
- **Benefit:** Students won't waste time searching for evidence files

### 2. Lack of Email Analysis Techniques
- **Issue:** Students don't know how to parse .mbox files or extract headers
- **Fix:** Added detailed email parsing commands and header extraction methods
- **Benefit:** Structured approach to email forensics with expected outputs

### 3. No Log Analysis Guidance
- **Issue:** Students don't know what to look for in system logs
- **Fix:** Added specific log patterns and USB event identification
- **Benefit:** Focused analysis on relevant forensic artifacts

### 4. Missing Correlation Framework
- **Issue:** Students don't know how to connect email/log findings with previous labs
- **Fix:** Added correlation sections linking to Labs 1-3 findings
- **Benefit:** Students see the investigative timeline coming together

### 5. No Tool-Specific Instructions
- **Issue:** Students don't know which commands to use for analysis
- **Fix:** Added specific grep, awk, and Python commands for each task
- **Benefit:** Hands-on skill development with real forensic tools

## What's Included in WALKTHROUGH.md

### Sections:
1. **Overview** - Context and learning objectives
2. **Case Context** - Connection to Cloudcore investigation (Phase 4)
3. **Prerequisites Checklist** - Setup verification including evidence files
4. **Lab Setup** - Directory creation and evidence verification
5. **Step-by-Step Analysis** (7 detailed steps):
   - Evidence hashing and chain of custody
   - Email analysis and header extraction
   - Attachment analysis
   - System log examination
   - USB event identification
   - Timeline correlation
   - Report generation
6. **Analysis Guidance** - Questions to answer
7. **Expected Key Findings** - What students should discover
8. **Completing the Report** - Template guidance with examples
9. **Troubleshooting** - Common parsing and analysis issues
10. **Submission Checklist**
11. **Going Further** - Optional extensions
12. **Additional Resources**

### Key Features:
- **Specific command examples** for email and log parsing
- **Expected output formats** for each analysis step
- **"What to look for"** guidance for suspicious indicators
- **Correlation matrix** linking findings to previous labs
- **Time estimate** (90 minutes)
- **Python script examples** for automated analysis

## Recommended Next Steps

### Option 1: Keep Both Documents
- Use `README.md` as quick reference
- Use `WALKTHROUGH.md` for detailed instructions
- Update README.md to add: "See WALKTHROUGH.md for detailed step-by-step instructions"

### Option 2: Replace README.md
- Rename `WALKTHROUGH.md` to `README.md`
- Keep original README as `README.ORIGINAL.md` for reference

### Option 3: Merge Documents
- Keep README structure but add sections from WALKTHROUGH:
  - Evidence file verification commands
  - Expected findings
  - Troubleshooting
  - Command examples

## Files That Should Be Updated

1. **cases/Email_Logs/README.md**
   - Add evidence file verification commands
   - Add: "See WALKTHROUGH.md for detailed step-by-step instructions"
   - Mention expected time: 90 minutes

2. **Root README.md or SETUP.md**
   - Mention that Lab 4 requires email and log analysis skills
   - Link to Lab 4 WALKTHROUGH.md

3. **FACILITATION.md**
   - Reference the new walkthrough for Lab 4
   - Note that WALKTHROUGH includes correlation guidance

## Teaching Tips

### Before Lab:
- Ensure students have completed Labs 1-3 or understand the case context
- Verify evidence files are present and accessible
- Review email header structure and log format basics

### During Lab:
- Let students attempt manual parsing before showing automated methods
- Ask: "How does this email timestamp correlate with your USB findings?"
- Point out the importance of chain of custody for digital evidence
- Encourage students to build a timeline of events

### After Lab:
- Group discussion: "How strong is the exfiltration evidence now?"
- Preview Lab 5: "How will network traffic confirm these findings?"
- Emphasize report quality - this lab builds the prosecution narrative

## Estimated Student Time

- **Fast students:** 75 minutes
- **Average students:** 90 minutes
- **Struggling students:** 120 minutes (with walkthrough)

## Assessment Notes

### Grading with Walkthrough:
- Students now have detailed guidance, so raise expectations for:
  - Precise timestamp correlation across all evidence types
  - Professional header extraction and documentation
  - Clear narrative linking all findings
  - Technical accuracy in log analysis

### Red Flags:
- If student report exactly matches walkthrough without original analysis = plagiarism
- Check for unique insights or additional correlations beyond walkthrough
- Verify extracted headers match actual evidence (not fabricated)

## Optional Enhancements

Consider adding:
1. **Sample Python scripts** for automated email parsing
2. **Email header analysis worksheet** with common fields to extract
3. **Log pattern matching exercises** with regex examples
4. **Timeline visualization template** for correlation
5. **Mock email headers** for practice before real evidence

## Feedback Loop

After students complete Lab 4:
- Collect feedback on parsing difficulty
- Note which correlation patterns caused confusion
- Track completion times
- Update WALKTHROUGH.md based on common questions

## Version Control

- Created: 2025-10-21
- Status: Initial version
- Next review: After first cohort completes Lab 4
- Maintenance: Update if evidence files change or tools evolve

---

**Questions or Updates?**
Contact: [Add your contact info here]