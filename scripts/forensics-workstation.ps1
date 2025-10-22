# DFIR Workstation Login Simulator - PowerShell Version for Windows
# This script provides an immersive entry experience for the Forensics Docker Lab

param(
    [string]$AnalystName = ""
)

# Get project root
$ProjectRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

# Colors
$Cyan = "Cyan"
$Green = "Green"
$Red = "Red"
$Yellow = "Yellow"
$Blue = "Cyan"

# Banner
Write-Host ""
Write-Host "  +=====================================================================+" -ForegroundColor $Blue
Write-Host "  |                                                                     |" -ForegroundColor $Blue
Write-Host "  |     DIGITAL FORENSICS INCIDENT RESPONSE LABORATORY                |" -ForegroundColor $Blue
Write-Host "  |                                                                     |" -ForegroundColor $Blue
Write-Host "  |           Cloudcore 2009 Data Exfiltration Investigation          |" -ForegroundColor $Blue
Write-Host "  |                                                                     |" -ForegroundColor $Blue
Write-Host "  +=====================================================================+" -ForegroundColor $Blue
Write-Host ""

# Get analyst name
if ([string]::IsNullOrWhiteSpace($AnalystName)) {
    Write-Host "Forensic Analyst Login" -ForegroundColor $Cyan
    $AnalystName = Read-Host "Enter analyst name (for case documentation)"
    if ([string]::IsNullOrWhiteSpace($AnalystName)) {
        $AnalystName = "analyst"
    }
}

# Show lab summary
Write-Host ""
Write-Host "Lab Environment - Available Tasks:" -ForegroundColor $Cyan
Write-Host "  1 - USB_Imaging - Evidence handling and initial triage"
Write-Host "  2 - Memory_Forensics - Memory analysis with Volatility 2"
Write-Host "  3 - Autopsy_GUI - Graphical forensic examination"
Write-Host "  4 - Email_Logs - Email artifact and log analysis"
Write-Host "  5 - Network_Analysis - Network traffic and C2 detection"
Write-Host "  6 - Final_Report - Synthesis and professional reporting"
Write-Host ""
Write-Host "Access Mode: All labs available in one environment" -ForegroundColor $Cyan
Write-Host ""

$continueChoice = Read-Host "Continue to DFIR workstation? (y/n) [y]"
if ([string]::IsNullOrWhiteSpace($continueChoice)) {
    $continueChoice = "y"
}

if ($continueChoice -notmatch "^[Yy]$") {
    Write-Host "Exiting without connecting" -ForegroundColor $Yellow
    Write-Host ""
    exit 0
}

# Connect to workstation
Write-Host ""
Write-Host "Connecting to DFIR Workstation..." -ForegroundColor $Blue
Start-Sleep -Seconds 1
Write-Host "Initializing forensic environment..." -ForegroundColor $Cyan
Start-Sleep -Seconds 1
Write-Host "Connection established" -ForegroundColor $Green
Start-Sleep -Seconds 1
Write-Host ""

# Set location and environment
Set-Location $ProjectRoot
$AnalystNameSanitized = $AnalystName -replace ' ', '_' -replace '[^\w]', ''
$env:ANALYST_NAME = $AnalystNameSanitized

# Run Docker container
try {
    & docker compose run --rm --env "ANALYST_NAME=$AnalystNameSanitized" -it dfir bash
}
catch {
    Write-Host "Error running Docker container" -ForegroundColor $Red
    exit 1
}

# Goodbye
Write-Host ""
Write-Host "Disconnecting from DFIR Workstation..." -ForegroundColor $Cyan
Start-Sleep -Seconds 1
Write-Host "Session ended" -ForegroundColor $Green
Write-Host ""
Write-Host "Thank you for using the Forensics Lab"
Write-Host "All work saved to cases folder"
