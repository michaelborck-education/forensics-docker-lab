@echo off
REM DFIR Workstation Login Simulator - Pure Batch Implementation for Windows
REM This script provides an immersive entry experience for the Forensics Docker Lab
REM No PowerShell required - pure batch for maximum compatibility
REM
REM Usage: forensics-workstation.bat [analyst_name]
REM Example: forensics-workstation.bat "Alice Johnson"

setlocal enabledelayedexpansion

REM Get script directory (parent is project root)
set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..") do set "PROJECT_ROOT=%%~fI"

REM Get analyst name from command line or prompt
set "ANALYST_NAME=%~1"
if "!ANALYST_NAME!"=="" (
    echo.
    echo Forensic Analyst Login
    set /p ANALYST_NAME="Enter analyst name (for case documentation): "
    if "!ANALYST_NAME!"=="" set "ANALYST_NAME=analyst"
)

REM Display banner
echo.
echo   ╔═════════════════════════════════════════════════════════════════╗
echo   ║                                                                 ║
echo   ║     DIGITAL FORENSICS INCIDENT RESPONSE LABORATORY             ║
echo   ║                                                                 ║
echo   ║           Cloudcore 2009 Data Exfiltration Investigation       ║
echo   ║                                                                 ║
echo   ╚═════════════════════════════════════════════════════════════════╝
echo.

REM Show case menu
echo Available Cases:
echo   1 - USB_Imaging - Evidence handling and initial triage
echo   2 - Memory_Forensics - Memory analysis with Volatility 2
echo   3 - Autopsy_GUI - Graphical forensic examination
echo   4 - Email_Logs - Email artifact and log analysis
echo   5 - Network_Analysis - Network traffic and C2 detection
echo   6 - Final_Report - Synthesis and professional reporting
echo   0 - Skip case selection (all labs available)
echo.

set /p LAB_CHOICE="Select lab (0-6) [0]: "
if "!LAB_CHOICE!"=="" set "LAB_CHOICE=0"

if "!LAB_CHOICE!"=="1" echo Success: USB_Imaging selected
if "!LAB_CHOICE!"=="2" echo Success: Memory_Forensics selected
if "!LAB_CHOICE!"=="3" echo Success: Autopsy_GUI selected
if "!LAB_CHOICE!"=="4" echo Success: Email_Logs selected
if "!LAB_CHOICE!"=="5" echo Success: Network_Analysis selected
if "!LAB_CHOICE!"=="6" echo Success: Final_Report selected
if not "!LAB_CHOICE!"=="0" if not "!LAB_CHOICE!"=="1" if not "!LAB_CHOICE!"=="2" if not "!LAB_CHOICE!"=="3" if not "!LAB_CHOICE!"=="4" if not "!LAB_CHOICE!"=="5" if not "!LAB_CHOICE!"=="6" (
    echo Warning: Invalid selection, proceeding with all labs
    set "LAB_CHOICE=0"
)

REM Connect to workstation
echo.
echo Connecting to DFIR Workstation...
timeout /t 1 /nobreak > nul
echo Initializing forensic environment...
timeout /t 1 /nobreak > nul
echo Connection established
timeout /t 1 /nobreak > nul
echo.

REM Change to project directory and run Docker
cd /d "!PROJECT_ROOT!"

REM Sanitize analyst name (remove spaces and special characters)
setlocal enabledelayedexpansion
set "ANALYST_CLEAN=!ANALYST_NAME: =_!"
REM Remove any remaining special characters by replacing problematic ones
set "ANALYST_CLEAN=!ANALYST_CLEAN:,=!"
set "ANALYST_CLEAN=!ANALYST_CLEAN:'=!"
set "ANALYST_CLEAN=!ANALYST_CLEAN:\"=!"

REM Run Docker container
docker compose run --rm --env "ANALYST_NAME=!ANALYST_CLEAN!" -it dfir bash

REM Goodbye
echo.
echo Disconnecting from DFIR Workstation...
timeout /t 1 /nobreak > nul
echo Session ended
echo.
echo Thank you for using the Forensics Lab
echo All work saved to cases folder

endlocal
