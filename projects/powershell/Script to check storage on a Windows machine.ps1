#Script to check storage on a Windows machine

#begining
write-host 'getting storage information...' --ForegroundColor Cyan

# Check if the script is running with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run this script as an administrator." -ForegroundColor Red
    exit
}

# Get all drives
$drives = Get-PSDrive -PSProvider FileSystem

#give total storage
Write-Host "Total Storage: $(Get-PSDrive -PSProvider FileSystem | Measure-Object -Property Used -Sum).Sum GB"

#give free storage
Write-Host "Free Storage: $(Get-PSDrive -PSProvider FileSystem | Measure-Object -Property Free -Sum).Sum GB"

#total filled storage
Write-Host "Filled Storage: $(Get-PSDrive -PSProvider FileSystem | Measure-Object -Property Used -Sum).Sum GB"

