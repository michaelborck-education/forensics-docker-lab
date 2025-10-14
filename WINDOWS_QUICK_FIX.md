# Windows Quick Fix

## Error: "exec /usr/local/bin/entrypoint.sh: no such file or directory"

### Quick Solution (PowerShell):

```powershell
# 1. Open PowerShell in the project folder
cd C:\path\to\forensics-docker-lab

# 2. Fix line endings
.\scripts\fix-line-endings.ps1

# 3. Rebuild (no cache)
docker compose build --no-cache dfir

# 4. Test
docker compose run --rm -it dfir
```

### Alternative (If you have Git Bash/WSL):

```bash
# 1. Fix line endings
bash scripts/fix-line-endings.sh

# 2. Rebuild
docker compose build --no-cache dfir

# 3. Test
docker compose run --rm -it dfir
```

### Explanation:
Windows Git converted Unix line endings (LF) to Windows line endings (CRLF), breaking the shell script inside Docker.

### Prevent in Future:
```powershell
# PowerShell:
git config --global core.autocrlf false

# Then re-clone the repository
```

---

## Full Troubleshooting Guide:
See [docs/WINDOWS_SETUP.md](docs/WINDOWS_SETUP.md)
