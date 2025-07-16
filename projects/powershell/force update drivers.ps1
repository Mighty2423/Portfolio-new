# Run PowerShell as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as Administrator!" -ForegroundColor Red
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Force Windows Update to check and install driver updates
Write-Host "🔄 Checking for driver updates via Windows Update..." -ForegroundColor Cyan
Install-Module -Name PSWindowsUpdate -Force -Confirm:$false

# Import the module
Import-Module PSWindowsUpdate

# Check and install updates (including drivers)
Get-WindowsUpdate -MicrosoftUpdate -AcceptAll -Install -IgnoreReboot

# Scan for hardware changes in Device Manager
Write-Host "🔄 Scanning for hardware changes in Device Manager..." -ForegroundColor Cyan
pnputil /scan-devices

# Update all drivers automatically using Device Manager
Write-Host "🔄 Forcing Windows to update all drivers..." -ForegroundColor Yellow
Get-PnpDevice | Where-Object { $_.Status -eq "OK" } | ForEach-Object { 
    Write-Host "Updating driver for: $($_.FriendlyName)" -ForegroundColor Green
    pnputil /update-driver "$($_.InstanceId)"
}

Write-Host "✅ Driver update process completed!" -ForegroundColor Green
