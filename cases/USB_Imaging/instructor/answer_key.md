# Answer Key (Instructor Reference)

## Expected Findings

### Recovered Files (tsk_recover)
Students should recover these deleted files from the USB image:

1. **`project_secrets.zip`** ⭐ PRIMARY EVIDENCE
   - Contains: Proprietary Cloudcore source code and client data
   - Size: ~50 MB (matches Lab 5 network transfer)
   - Relevance: Confirms data exfiltration hypothesis
   - Hash: Students should calculate and document

2. **`email_draft.txt`**
   - Content: Draft email to exfil@personal.com with attachment reference
   - Relevance: Shows intent to send secrets externally
   - Should appear in Lab 4 email analysis correlation

3. **`truecrypt_config.txt`**
   - Content: TrueCrypt volume configuration (hidden volume, AES-256)
   - Relevance: Shows encryption prep (correlates with Lab 2 memory findings)
   - Significance: Anti-forensic technique

4. **`flag.txt`** (Optional/Minor)
   - Content: CTF-style flag (educational marker)
   - Not relevant to case narrative but useful for verification
   - Accept if recovered

### File Recovery Tools Performance
- **tsk_recover:** Should find most deleted files (project_secrets.zip, email_draft.txt, etc.)
  - Output path: `cases/USB_Imaging/tsk_recover_out/`
  - Typical: ~4-6 files recovered depending on FAT tables
  
- **foremost:** File carving (signature-based recovery)
  - Output path: `cases/USB_Imaging/foremost_out/`
  - May recover more file fragments
  - May have more false positives

### Timeline Expectations
- File creation/deletion timestamps should cluster around **Dec 5, 2009, 14:30-15:00 UTC**
- Matches storyline: "USB activity logged 14:31-14:32" from syslog entries
- Plaso timeline should show:
  - Files created
  - Files deleted (evidence of cover-up)
  - Mount/unmount events

## Grading Notes

**Full Credit Requires:**
- [ ] Identified and recovered `project_secrets.zip`
- [ ] Explained significance (data exfiltration evidence)
- [ ] Documented hash values
- [ ] Referenced Lab 1 narrative (2009 Cloudcore incident)
- [ ] CoC logging (if assignment grade)

**Partial Credit:**
- Student recovered files but didn't correlate to narrative
- Student used tools correctly but missed project_secrets.zip
- Student documented some findings but not all

**Accept Variations:**
- Different file carving tools (foremost vs other tools)
- Different hash algorithms (MD5, SHA256 both acceptable if documented)
- Different Plaso timeline exports (CSV, body file, etc.)
- Students may find additional files depending on image state

## Answer Key: What Students Found vs. What They Should Find

| Finding | Expected | Actual | Notes |
|---------|----------|--------|-------|
| Deleted Files | project_secrets.zip, email_draft.txt, truecrypt_config.txt | All 4 (including flag.txt) | ✅ Match narrative |
| File Size | ~50 MB total | ~50 MB | ✅ Matches Lab 5 exfil volume |
| Timeline | Dec 5, 14:30-15:00 | Dec 5, 14:31-14:32 | ✅ Within expected range |
| Evidence of Intent | Email draft, TrueCrypt config | Both present | ✅ Show planning |
| Correlation | Storyline prediction vs. recovery | All predicted files found | ✅ Excellent narrative match |

## Teaching Points

**Emphasize to students:**
1. **File recovery works** - Deleted files can be recovered even without DBAN/wipe
2. **Deletion ≠ Destruction** - Artifacts remain in filesystem metadata
3. **Narrative Matters** - Individual findings connect to bigger story
4. **CoC Matters** - Without proper documentation, findings inadmissible in court

## Common Student Mistakes (and how to address)

1. **"I didn't find anything"** 
   - Guide to use `-a` flag on tsk_recover (all data units)
   - Suggest trying foremost as alternative carving tool

2. **"I found files but don't know what they mean"**
   - Point to SCENARIO.md and STORYLINE.md
   - Show how project_secrets.zip size matches Lab 5 findings

3. **"Why is flag.txt important?"**
   - It's not - it's a CTF exercise artifact
   - Real evidence is project_secrets.zip + metadata

4. **Missing CoC logging (first time)**
   - Walkthrough is optional (no CoC required)
   - Assignment requires coc-log usage (note in grading)
