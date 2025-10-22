# Tutor Notes — Lab 1

## Setup
- Ensure students have Docker running and have built the `dfir` image: `docker compose build dfir`.
- If using lab machines, pre-pull `log2timeline/plaso`, `sk4la/volatility3`, `blacktop/yara`.

## Timing Guide (90 min)
- 0–15: Chain-of-custody demo; run `hashlog` together, open CSV.
- 15–35: Students run `scripts/make_practice_image.sh` to create `evidence/disk.img`.
- 35–60: Recovery with `tsk_recover`; sanity-check outputs; optionally `foremost`.
- 60–80: Plaso pipeline; export `timeline.csv` and identify 3–5 events.
- 80–90: Report wrap-up; quick QA on reproducibility & integrity.

## Common Issues
- **Permissions**: If output files are root-owned, set `PUID/PGID` in `.env` correctly and restart.
- **WSL2 pathing**: Advise placing the project in the Linux filesystem (`~/`) rather than Windows mounts.
- **Autopsy**: Community images vary; keep this optional, CLI tools suffice.

## Assessment Tips
- Look for specific commands in student reports.
- Require hashes for recovered artifacts.
- Reward concise reasoning in timeline analysis (event → rationale).

