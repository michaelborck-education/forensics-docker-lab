# Volatility 3 - Symbol Downloads and First Run

## Overview

Volatility 3 is included in the `dfir` forensic workstation. Students can run `vol` commands directly inside the interactive container:

```bash
# Enter forensic workstation
docker compose run --rm -it dfir

# Inside the workstation:
analyst@forensics-lab:~$ vol -f /evidence/memory.raw windows.info.Info
```

## First Run: Symbol Download

**Important:** The first time a student runs Volatility against a Windows memory dump, Volatility will automatically download Windows debugging symbols from Microsoft's symbol server.

### What to Expect

```
analyst@forensics-lab:~$ vol -f /evidence/memory.raw windows.info.Info
Volatility 3 Framework 2.26.2
Progress:    0.20		Reading file http://msdl.microsoft.com/download/symbols/ntoskrnl.pdb/...
Progress:   10.00		Reading file http://msdl.microsoft.com/download/symbols/ntoskrnl.pdb/...
Progress:   50.00		Reading file http://msdl.microsoft.com/download/symbols/ntoskrnl.pdb/...
Progress:  100.00		Downloading http://msdl.microsoft.com/download/symbols/ntoskrnl.pdb/...
```

### Download Details

- **Duration:** 30-60 seconds (depending on internet speed)
- **Size:** ~2-5 MB per symbol file
- **Frequency:** One-time per Windows version/build
- **Storage:** Cached in tmpfs (temporary in-memory filesystem)
- **Internet Required:** Yes - Volatility connects to `msdl.microsoft.com`

### Symbol Cache Location

Symbols are stored in:
```
/usr/local/lib/python3.13/dist-packages/volatility3/symbols/
```

This directory is mounted as tmpfs in `docker-compose.yml`:
```yaml
tmpfs:
  - /tmp
  - /usr/local/lib/python3.13/dist-packages/volatility3/symbols:uid=1000,gid=1000
```

**Why tmpfs?**
- ✅ Writable (container is read-only for forensic integrity)
- ✅ Fast (in-memory storage)
- ✅ No disk space consumed
- ⚠️ Symbols discarded when container stops (acceptable trade-off)

### Subsequent Runs

After the first successful symbol download, subsequent `vol` commands for the same Windows version will use the cached symbols and run immediately without downloading.

**However:** If you stop and restart the container (`docker compose run --rm ...`), the tmpfs is cleared and symbols must be re-downloaded.

## Troubleshooting

### Error: "Unable to open database file"

If you see:
```
sqlite3.OperationalError: unable to open database file
```

**Cause:** Volatility cache directory doesn't exist.

**Solution:** This was fixed in commit d3eb1e0. Rebuild the container:
```bash
docker compose build --no-cache dfir
```

### Error: "No symbol files found at provided filename: pdb"

This can occur even after successful symbol download. Possible causes:

1. **Memory dump is corrupted or incomplete**
   - Verify file size (should be hundreds of MB)
   - Check hash against known good dump

2. **Memory dump is from unsupported Windows version**
   - Very old (pre-XP) or very new (bleeding-edge builds)
   - Try alternative Volatility plugins

3. **Symbols failed to parse**
   - Re-run the command (downloads fresh symbols)
   - Check internet connectivity during download

4. **Memory dump is not Windows**
   - If dump is from Linux, use `linux.` plugins instead of `windows.`
   - Example: `vol -f memory.raw linux.pslist.PsList`

### Slow Performance

Memory forensics is CPU-intensive. Each Volatility plugin can take:
- **Simple plugins** (pslist): 10-30 seconds
- **Complex plugins** (netscan): 1-3 minutes
- **Heavy plugins** (malfind, vadinfo): 5-10+ minutes

**Solutions:**
- Be patient - this is normal
- Allocate more resources to Docker (Settings → Resources → increase CPU/RAM)
- Run commands in the background and check back later

### No Internet Connection

If the forensic workstation has no internet access:

**Option 1:** Pre-download symbols (advanced)
- Download symbols on a networked machine
- Copy symbol files to `cases/.volatility_symbols/`
- Mount in container (requires docker-compose.yml modification)

**Option 2:** Use alternative tools
- strings, grep, hexdump for manual analysis
- Alternative memory forensics tools (Rekall, etc.)

**Option 3:** Provide symbols via USB/offline media
- Instructor provides pre-downloaded symbol package
- Students extract to shared volume

## Teaching Notes

### For Instructors

When introducing Volatility:

1. **Warn students about first-run delay**
   - "The first time you run Volatility, it will download Windows symbols from Microsoft. This takes about 30 seconds."

2. **Explain why symbols are needed**
   - Windows kernel structures change between versions
   - Symbols provide a "map" to interpret raw memory bytes
   - Like having a dictionary to translate a foreign language

3. **Demonstrate the download process**
   - Show the progress bars on screen
   - Explain what's happening behind the scenes
   - Reassure students this is normal and expected

4. **Container restart caveat**
   - Each new container run requires re-download
   - This is a trade-off for read-only forensic security
   - In production forensics, symbols would be cached persistently

### For Students

**First Time Using Volatility:**

1. Ensure you have internet connectivity
2. Run your first command (e.g., `windows.info.Info`)
3. Wait patiently for symbol download (~30-60 seconds)
4. You'll see progress bars - this is normal!
5. Once complete, subsequent commands will be faster

**Tips:**
- Don't interrupt the download (Ctrl+C) - let it finish
- If download fails, just re-run the command
- Symbol download only happens once per container session
- Plan ahead: run the first command early in your lab session

## Technical Details

### Symbol Download Process

1. Volatility scans memory dump for Windows kernel version identifier
2. Constructs URL to Microsoft Symbol Server: `http://msdl.microsoft.com/download/symbols/ntoskrnl.pdb/[GUID]/ntoskrnl.pdb`
3. Downloads PDB (Program Database) file containing debugging symbols
4. Parses PDB and caches data structures in SQLite database
5. Uses symbols to interpret memory structures for all subsequent plugins

### Alternative: Linux Memory Dumps

For Linux memory dumps, Volatility uses different symbol resolution:
- Linux symbols are in the memory dump itself (DWARF debugging info)
- Or compiled into Volatility profiles (ISF files)
- Usually no internet download required

### Security Considerations

**Is it safe to download symbols from Microsoft?**
- ✅ Yes - this is the official Microsoft Symbol Server
- ✅ Used by debuggers (WinDbg), forensic tools worldwide
- ✅ Files are signed and integrity-checked
- ✅ Read-only data (cannot modify memory dump)

**Firewall/Proxy Issues:**
- If behind corporate firewall, may need to configure proxy
- Volatility respects `HTTP_PROXY` / `HTTPS_PROXY` environment variables
- Alternatively, pre-download symbols offline

## Command Reference

### Working with Volatility Inside the Workstation

```bash
# Enter interactive forensic workstation
docker compose run --rm -it dfir

# Inside workstation - use vol directly:
vol -f /evidence/memory.raw windows.info.Info
vol -f /evidence/memory.raw windows.pslist.PsList
vol -f /evidence/memory.raw windows.netscan.NetScan

# Redirect output to case folder (persists on host):
vol -f /evidence/memory.raw windows.pslist.PsList > /cases/Lab_2/pslist.txt
```

### Available Volatility Plugins

List all available plugins:
```bash
vol --help | grep windows
```

Common plugins:
- `windows.info.Info` - System information
- `windows.pslist.PsList` - Process list
- `windows.pstree.PsTree` - Process tree
- `windows.netscan.NetScan` - Network connections
- `windows.psscan.PsScan` - Scan for hidden processes
- `windows.dlllist.DllList` - List DLLs for a process
- `windows.cmdline.CmdLine` - Process command lines
- `windows.filescan.FileScan` - Scan for file objects

## Further Reading

- **Volatility 3 Official Docs:** https://volatility3.readthedocs.io/
- **Microsoft Symbol Server:** https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/microsoft-public-symbols
- **Memory Forensics Guide:** https://github.com/volatilityfoundation/volatility/wiki

---

**Last Updated:** October 2025
**Volatility Version:** 3.26.2
**Python Version:** 3.13
