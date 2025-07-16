# Windows System Maintenance Script
# Run this script with administrator privileges

Write-Host "Starting Windows System Maintenance..." -ForegroundColor Cyan

# System File Check
Write-Host "Running System File Checker (SFC)..." -ForegroundColor Yellow
sfc /scannow

# DISM Repair
Write-Host "Checking Windows image health..." -ForegroundColor Yellow
DISM /Online /Cleanup-Image /CheckHealth
DISM /Online /Cleanup-Image /ScanHealth
DISM /Online /Cleanup-Image /RestoreHealth

# Check Disk for Errors
Write-Host "Checking disk for errors..." -ForegroundColor Yellow
chkdsk C: /f /r /x

# Windows Memory Diagnostic
#Write-Host "Initiating Windows Memory Diagnostic..." -ForegroundColor Yellow
#Start-Process -NoNewWindow -Wait mdsched.exe

# Generate System Performance Report
Write-Host "Generating system performance report..." -ForegroundColor Yellow
perfmon /report

# Network Reset & Repair
Write-Host "Flushing DNS and resetting network settings..." -ForegroundColor Yellow
ipconfig /flushdns
netsh winsock reset
netsh int ip reset

# Windows Update Troubleshooter
Write-Host "Forcing Windows Update Check..." -ForegroundColor Yellow
wuauclt /detectnow
wuauclt /updatenow

Write-Host "System Maintenance Complete!" -ForegroundColor Green
