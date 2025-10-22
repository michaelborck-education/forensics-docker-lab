@echo off
REM DFIR Workstation Login Simulator - Batch file wrapper for PowerShell
REM This wrapper allows running the PowerShell script without execution policy issues
REM
REM Usage: forensics-workstation.bat [analyst_name]
REM Example: forensics-workstation.bat "Alice Johnson"

setlocal enabledelayedexpansion

REM Get script directory
set "SCRIPT_DIR=%~dp0"
set "PS_SCRIPT=%SCRIPT_DIR%forensics-workstation.ps1"

REM Build PowerShell command with arguments
set "PS_ARGS="
if not "%~1"=="" (
    set "PS_ARGS=-AnalystName '%~1'"
)

REM Run PowerShell with bypass execution policy (only for this script)
powershell -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT%" %PS_ARGS%

endlocal
