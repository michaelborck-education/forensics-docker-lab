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

### 1) Hash baseline (integrity & intake)
```bash
docker compose run --rm hashlog
# Optionally add a note
COC_NOTE="Lab1 intake by <YourName>" docker compose run --rm hashlog
```
Check `cases/chain_of_custody.csv` — confirm timestamps and SHA-256 values recorded.

### 2) Create safe practice EXT4 image and simulate deletion
> On your host (Linux/macOS, or WSL2), run the helper script:
```bash
bash scripts/make_practice_image.sh
```
This creates **`evidence/disk.img`** with a deleted file (`flag.txt`) to recover later.

### 3) List file system and recover deleted items
```bash
# File system listing (Sleuth Kit)
docker compose run --rm dfir fls -r -m / /evidence/disk.img > cases/Lab_1/fls.txt

# Recover deleted with TSK
docker compose run --rm dfir tsk_recover -a /evidence/disk.img /cases/Lab_1/tsk_recover_out

# Optional: Compare with Foremost carving
docker compose run --rm dfir foremost -i /evidence/disk.img -o /cases/Lab_1/foremost_out
```

### 4) Build a Plaso super-timeline and export CSV
```bash
docker compose run --rm plaso log2timeline.py /cases/Lab_1/timeline.plaso /evidence/disk.img
docker compose run --rm plaso psort.py -o l2tcsv /cases/Lab_1/timeline.plaso > cases/Lab_1/timeline.csv
```
Open `cases/Lab_1/timeline.csv` in your spreadsheet tool. Identify 3–5 notable events (file creation/deletion, mount, etc.).

### 5) Complete your triage report
Fill in `cases/Lab_1/triage_report.md` using the template. Reference recovered files and timeline evidence.

---

## Marking rubric (summary)
- **Chain-of-custody (20%)**: Accurate, complete, consistent.
- **Recovery (30%)**: Correct methods and validated artifacts.
- **Timeline (30%)**: Clear notable events with justification.
- **Report quality (20%)**: Concise, reproducible steps, correct hashes/paths.

See `rubric.csv` for detail.
