# Student Worksheet — Lab 1

## Learning outcomes
By the end of this lab you will be able to:

1. **Apply** a chain-of-custody process using hashing and logging.
2. **Recover** deleted files from a disk image using Sleuth Kit/Foremost.
3. **Construct** a Plaso timeline and **interpret** notable events.
4. **Document** a minimal triage report that is reproducible.

## Checklist
- [ ] Ran `hashlog` and inspected `cases/chain_of_custody.csv`  
- [ ] Created `evidence/disk.img` via script  
- [ ] Recovered at least one file with `tsk_recover`  
- [ ] Generated `timeline.csv` with `psort.py`  
- [ ] Completed `triage_report.md`

## Hints
- Use `fls` output to target interesting inodes with `icat` if needed.
- Validate recovered files with `hashdeep` and include hashes in the report.
- If Plaso is slow, reduce scope: `--yara_rules` or targeted partition (advanced).

## Extension (optional)
- Compare TSK vs Foremost results: what’s different and why?
- Add a custom YARA rule and scan `./evidence` to practice signature-based triage.
