@echo off
REM Forensics Lab Setup Verification Script for Windows
REM Run this to verify your Docker environment is properly configured

echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo   Forensics Lab - Environment Verification
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

set PASSED=0
set FAILED=0

REM Function to check and report
:check
if %ERRORLEVEL% EQU 0 (
    echo [OK] %~1
    set /A PASSED+=1
) else (
    echo [FAIL] %~1
    set /A FAILED+=1
)
goto :eof

REM 1. Check Docker is installed
echo Checking Docker installation...
docker --version >nul 2>&1
call :check "Docker is installed"

docker compose version >nul 2>&1
call :check "Docker Compose is available"
echo.

REM 2. Check Docker daemon is running
echo Checking Docker daemon...
docker ps >nul 2>&1
call :check "Docker daemon is running"
echo.

REM 3. Check evidence directory exists
echo Checking lab structure...
if exist "evidence\" (
    echo [OK] Evidence directory exists
    set /A PASSED+=1
) else (
    echo [FAIL] Evidence directory exists
    set /A FAILED+=1
)

if exist "cases\" (
    echo [OK] Cases directory exists
    set /A PASSED+=1
) else (
    echo [FAIL] Cases directory exists
    set /A FAILED+=1
)

if exist "Dockerfile" (
    echo [OK] Dockerfile exists
    set /A PASSED+=1
) else (
    echo [FAIL] Dockerfile exists
    set /A FAILED+=1
)

if exist "docker-compose.yml" (
    echo [OK] docker-compose.yml exists
    set /A PASSED+=1
) else (
    echo [FAIL] docker-compose.yml exists
    set /A FAILED+=1
)
echo.

REM 4. Check documentation files
echo Checking documentation...
if exist "README.md" (
    echo [OK] README.md exists
    set /A PASSED+=1
) else (
    echo [FAIL] README.md exists
    set /A FAILED+=1
)

if exist "docs\scenario.md" (
    echo [OK] scenario.md exists
    set /A PASSED+=1
) else (
    echo [FAIL] scenario.md exists
    set /A FAILED+=1
)
echo.

REM 5. Try to build container
echo Testing Docker build...
docker compose build >nul 2>&1
call :check "Docker image builds successfully"
echo.

REM 6. Test container startup
echo Testing container startup...
docker compose run --rm dfir echo "Container test" >nul 2>&1
call :check "Container starts and runs commands"
echo.

REM 7. Verify forensic tools
echo Verifying forensic tools...
docker compose run --rm dfir fls -V >nul 2>&1
call :check "Sleuth Kit (fls) is available"

docker compose run --rm dfir md5sum --version >nul 2>&1
call :check "Hash tools (md5sum) are available"
echo.

REM 8. Test volume mounts
echo Testing volume mounts...
docker compose run --rm dfir test -d /evidence >nul 2>&1
call :check "Evidence directory is mounted at /evidence"

docker compose run --rm dfir test -w /cases >nul 2>&1
call :check "Cases directory is writable at /cases"
echo.

REM 9. Check immersive features
echo Checking immersive features...
if exist "scripts\forensics-workstation.bat" (
    echo [OK] forensics-workstation.bat script is available
    set /A PASSED+=1
) else (
    echo [FAIL] forensics-workstation.bat script is available
    set /A FAILED+=1
)

docker compose run --rm dfir which coc-log >nul 2>&1
call :check "coc-log utility is available in container"

if exist "templates\analysis_log.csv" (
    echo [OK] analysis_log.csv template exists
    set /A PASSED+=1
) else (
    echo [FAIL] analysis_log.csv template exists
    set /A FAILED+=1
)
echo.

REM Summary
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo   Verification Summary
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo Passed: %PASSED%
echo Failed: %FAILED%
echo.

if %FAILED% EQU 0 (
    echo [SUCCESS] All checks passed! Your environment is ready.
    echo.
    echo Next steps:
    echo   1. Read docs\scenario.md for the case background
    echo   2. Explore the cases\ directory for available cases
    echo   3. Start your investigation:
    echo     • Recommended: scripts\forensics-workstation.bat
    echo     • Advanced: docker compose run --rm dfir
    echo.
) else (
    echo [WARNING] Some checks failed. Please review errors above.
    echo.
    echo Common fixes:
    echo   • Start Docker Desktop ^(Windows/Mac^)
    echo   • Ensure you're in the correct directory
    echo   • Check README.md troubleshooting section
    echo   • Run as Administrator if needed
    echo.
)

echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
pause