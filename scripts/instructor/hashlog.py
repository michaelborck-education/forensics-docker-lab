#!/usr/bin/env python3
import sys, os, hashlib, csv, time, getpass
from datetime import datetime, timezone

def hash_file(path, algo):
    h = hashlib.new(algo)
    with open(path, 'rb') as f:
        for chunk in iter(lambda: f.read(1024*1024), b''):
            h.update(chunk)
    return h.hexdigest()

def main():
    if len(sys.argv) < 4:
        print("Usage: hashlog.py <evidence_dir> <csv_out> <algo>", file=sys.stderr)
        sys.exit(1)
    root, out_csv, algo = sys.argv[1:4]
    note = os.environ.get("COC_NOTE","")
    rows = []
    for base, dirs, files in os.walk(root):
        for name in files:
            path = os.path.join(base, name)
            try:
                digest = hash_file(path, algo)
            except Exception as e:
                digest = f"ERROR:{e}"
            rows.append({
                "timestamp_utc": datetime.now(timezone.utc).isoformat(),
                "analyst": getpass.getuser(),
                "algorithm": algo,
                "path": os.path.relpath(path, root),
                "hash": digest,
                "note": note
            })
    header = ["timestamp_utc","analyst","algorithm","path","hash","note"]
    exists = os.path.exists(out_csv)
    os.makedirs(os.path.dirname(out_csv), exist_ok=True)
    with open(out_csv, "a", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=header)
        if not exists:
            w.writeheader()
        w.writerows(rows)
    print(f"Wrote {len(rows)} rows to {out_csv}")

if __name__ == "__main__":
    main()
