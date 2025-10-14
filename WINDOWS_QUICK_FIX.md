# Windows Quick Fix

## Error: "exec /usr/local/bin/entrypoint.sh: no such file or directory"

### Quick Solution:

```bash
# 1. Fix line endings
bash scripts/fix-line-endings.sh

# 2. Rebuild
docker compose build dfir

# 3. Run
docker compose run --rm -it dfir
```

### Explanation:
Windows Git converted Unix line endings (LF) to Windows line endings (CRLF), breaking the shell script.

### Prevent in Future:
```bash
git config --global core.autocrlf false
```

---

## Full Troubleshooting Guide:
See [docs/WINDOWS_SETUP.md](docs/WINDOWS_SETUP.md)
