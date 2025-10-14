# PowerShell script to fix line endings on Windows
# Run this if you get: "exec /usr/local/bin/entrypoint.sh: no such file or directory"

Write-Host "Fixing line endings for Docker compatibility..." -ForegroundColor Cyan
Write-Host ""

# Files that need Unix line endings (LF only, no CRLF)
$files = @(
    "images\dfir-cli\entrypoint.sh",
    "images\dfir-cli\Dockerfile",
    "docker-compose.yml"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "  Fixing: $file" -ForegroundColor Yellow

        # Read file content
        $content = Get-Content $file -Raw

        # Convert CRLF to LF
        $content = $content -replace "`r`n", "`n"

        # Write back without BOM, with LF line endings
        [System.IO.File]::WriteAllText("$(Get-Location)\$file", $content, [System.Text.UTF8Encoding]::new($false))

        Write-Host "    ✓ Fixed" -ForegroundColor Green
    } else {
        Write-Host "    ✗ Not found: $file" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "✓ Line endings fixed!" -ForegroundColor Green
Write-Host ""
Write-Host "Now rebuild the Docker image:" -ForegroundColor Cyan
Write-Host "  docker compose build --no-cache dfir" -ForegroundColor White
Write-Host ""
Write-Host "Then test:" -ForegroundColor Cyan
Write-Host "  docker compose run --rm -it dfir" -ForegroundColor White
Write-Host ""
