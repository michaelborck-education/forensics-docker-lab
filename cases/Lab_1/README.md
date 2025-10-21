# Forensic Lab 1: Imaging, Integrity & Initial Triage

**Goal:** Learn a repeatable evidence-handling workflow using the Docker Forensic Lab:
- Establish chain of custody and verify integrity (hashing).
- Create a safe practice disk image (no malware).
- Recover deleted files and produce a minimal triage report.
- Build a Plaso timeline and identify notable events.

**You’ll use:** `hashlog`, Sleuth Kit (`fls`, `icat`, `tsk_recover`), `foremost`, `exiftool`, Plaso (`log2timeline.py`, `psort.py`).

---

## What to submit
1. **`cases/chain_of_custody.csv`** with your entries.
2. **`cases/Lab_1/triage_report.md`** (template provided).
3. **`cases/Lab_1/timeline.csv`** (export from psort).
4. **Recovered artifacts** folder (`cases/Lab_1/tsk_recover_out` and/or `cases/Lab_1/foremost_out`).

> Tip: Put your student ID and name in the first line of each Markdown file.

---

## Timebox (90 minutes)
- 0–15 min: Setup & hash baseline
- 15–35 min: Create practice evidence image & simulate deletion
- 35–60 min: Recover deleted file(s)
- 60–80 min: Build timeline & extract notable events
- 80–90 min: Complete triage report

---

## Steps

### 0) Build and enter the forensic workstation
```bash
# First time only: Build the forensic container
docker compose build dfir

# Enter the interactive forensic workstation
docker compose run --rm -it dfir
```

You'll see the forensic lab banner and get a bash prompt. All commands below can be run **inside this interactive session** (recommended) or as one-off commands (see Alternative below).

### 1) Hash baseline (integrity & intake)
**Inside the workstation:**
```bash
# Exit the workstation temporarily (or open a new terminal)
exit
```

**On your host:**
```bash
docker compose run --rm hashlog
# Optionally add a note
COC_NOTE="Lab1 intake by <YourName>" docker compose run --rm hashlog
```
Check `cases/chain_of_custody.csv` — confirm timestamps and SHA-256 values recorded.

### 2) Create safe practice EXT4 image and simulate deletion
> Use the container-based script (works on all platforms including Mac):
```bash
bash scripts/make_practice_image_container.sh
```
This creates **`evidence/disk.img`** with multiple deleted files including:
- `flag.txt` (forensic recovery exercise)
- `project_secrets.zip` (Cloudcore case evidence)
- Email drafts and TrueCrypt configuration files
- System logs with USB activity timestamps

> **Note for Mac/Windows users:** The container version handles filesystem creation that your host OS might not support.

### 2b) Optional: Convert to E01 format (industry standard)
> Create an E01 evidence file for professional practice:
```bash
bash scripts/convert_to_e01_container.sh
```
This creates **`evidence/disk.e01`** - the industry-standard E01 format used in real investigations. You can use either `disk.img` or `disk.e01` for the remaining steps.

### 3) List file system and recover deleted items
**Re-enter the workstation:**
```bash
docker compose run --rm -it dfir
```

**Inside the workstation, run:**
```bash
# File system listing (Sleuth Kit) - look for deleted files (marked with *)
fls -r /evidence/disk.img

# Detailed listing with full paths
fls -r -m / /evidence/disk.img > Lab_1/fls.txt

# View the listing to identify deleted files
cat Lab_1/fls.txt | grep -E "^\*|flag\.txt|project_secrets\.zip"

# Recover ALL deleted files with TSK
mkdir -p Lab_1/tsk_recover_out
tsk_recover -a /evidence/disk.img Lab_1/tsk_recover_out

# Check what was recovered
ls -la Lab_1/tsk_recover_out/
cat Lab_1/tsk_recover_out/flag.txt 2>/dev/null || echo "flag.txt not recovered"

# Optional: Compare with Foremost carving (file carving)
mkdir -p Lab_1/foremost_out
foremost -i /evidence/disk.img -o Lab_1/foremost_out

# Check foremost results
ls -la Lab_1/foremost_out/

# Exit to run Plaso (different container)
exit
```

**If using E01 format instead:**
```bash
# Replace /evidence/disk.img with /evidence/disk.e01
# Add -f ewf flag to specify E01 format
fls -f ewf -r /evidence/disk.e01
tsk_recover -f ewf -a /evidence/disk.e01 Lab_1/tsk_recover_out
```

### 4) Build a Plaso super-timeline and export CSV
**On your host:**
```bash
docker compose run --rm plaso log2timeline.py /cases/Lab_1/timeline.plaso /evidence/disk.img
docker compose run --rm plaso psort.py -o l2tcsv /cases/Lab_1/timeline.plaso > cases/Lab_1/timeline.csv
```
Open `cases/Lab_1/timeline.csv` in your spreadsheet tool. Identify 3–5 notable events (file creation/deletion, mount, etc.).

### 5) Complete your triage report
Fill in `cases/Lab_1/triage_report.md` using the template. Reference recovered files and timeline evidence.

---

## Alternative: One-Off Commands (Not Recommended for Learning)

If you prefer not to use the interactive workstation, you can run individual commands:

```bash
docker compose run --rm dfir fls -r -m / /evidence/disk.img > cases/Lab_1/fls.txt
docker compose run --rm dfir tsk_recover -a /evidence/disk.img /cases/Lab_1/tsk_recover_out
```

**However, the interactive mode is recommended** because:
- Less typing (no `docker compose run --rm dfir` prefix)
- More realistic forensic workflow
- Better for learning and exploration
- Tab completion and command history work properly

---

## Marking rubric (summary)
- **Chain-of-custody (20%)**: Accurate, complete, consistent.
- **Recovery (30%)**: Correct methods and validated artifacts.
- **Timeline (30%)**: Clear notable events with justification.
- **Report quality (20%)**: Concise, reproducible steps, correct hashes/paths.

See `rubric.csv` for detail.

---

## Troubleshooting

### Problem: "No deleted files found" or "tsk_recover finds nothing"
**Common causes and solutions:**

1. **Using wrong fls command:**
   ```bash
   # Look for files marked with * (deleted)
   fls -r /evidence/disk.img
   
   # NOT just: fls /evidence/disk.img (misses deleted files)
   ```

2. **File system not fully processed:**
   ```bash
   # Try force recovery of all files
   tsk_recover -a -f /evidence/disk.img Lab_1/tsk_recover_out
   ```

3. **Using E01 format without specifying:**
   ```bash
   # Must specify E01 format
   tsk_recover -f ewf -a /evidence/disk.e01 Lab_1/tsk_recover_out
   ```

### Problem: "Permission denied" running make_practice_image.sh
**Solution:**
- Ensure you have sudo privileges on your system
- The script requires sudo for mounting loopback devices
- On WSL2, you may need to run as Administrator

### Problem: "Docker container can't find evidence files"
**Solution:**
- Ensure evidence files are in the correct location: `evidence/disk.img`
- Check file permissions: `ls -lh evidence/disk.img`
- Verify Docker volume mounting in docker-compose.yml

### Problem: "Plaso timeline is empty"
**Solutions:**
1. Check disk image format: `file evidence/disk.img`
2. Ensure sufficient disk space for timeline file
3. Try with smaller image first to test

---

## Expected Results

If everything works correctly, you should find:

**Deleted Files Recovered:**
- `flag.txt` containing: `FLAG{digital_forensics_cloudcore_case_2009}`
- `project_secrets.zip` (if recovery is successful)
- Various temporary files

**Timeline Events:**
- File creation timestamps around December 5, 2009
- File deletion events
- System log entries with USB activity

**Hash Values:**
- Record SHA-256 hashes in chain_of_custody.csv
- Verify integrity throughout the process
