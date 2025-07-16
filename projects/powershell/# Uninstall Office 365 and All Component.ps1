# Uninstall Office 365 Completely (Fix for Access Denied Errors)
# Run this script as Administrator

# Function to log actions
function Write-Log {
    param ([string]$Message)
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Write-Host "$timestamp - $Message" -ForegroundColor Cyan
}

# Ensure the script runs as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as Administrator!" -ForegroundColor Red
    exit
}

Write-Log "Starting Office 365 uninstallation process..."

# Step 1: Try Standard Office Uninstall
$officeApp = Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE Name LIKE '%Microsoft Office%'" -ErrorAction SilentlyContinue
if ($officeApp) {
    Write-Host "Uninstalling Microsoft Office..." -ForegroundColor Yellow
    $officeApp.Uninstall()
    Write-Log "Standard Office uninstallation completed."
} else {
    Write-Log "No Microsoft Office found via Win32_Product. Proceeding with alternate methods."
}

# Step 2: Use Office Click-to-Run Uninstaller
$officeClickToRun = "C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeC2RClient.exe"
if (Test-Path $officeClickToRun) {
    Write-Host "Running Office Click-to-Run uninstaller..." -ForegroundColor Yellow
    Start-Process -FilePath $officeClickToRun -ArgumentList "/uninstall OfficeProPlusRetail /quiet /norestart" -Wait
    Write-Log "Office Click-to-Run uninstallation completed."
} else {
    Write-Log "Office Click-to-Run uninstaller not found. Skipping this method."
}

# Step 3: Remove Office Apps via Microsoft Store (Fix for Access Denied)
Write-Log "Removing Office Apps installed via Microsoft Store..."
$officeApps = @(
    "Microsoft.Office.Desktop",
    "Microsoft.Office.OneNote",
    "Microsoft.Office.Outlook",
    "Microsoft.Office.Word",
    "Microsoft.Office.Excel",
    "Microsoft.Office.PowerPoint"
)

foreach ($app in $officeApps) {
    try {
        Write-Host "Removing $app..." -ForegroundColor Yellow
        Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -ErrorAction Stop
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -EQ $app | Remove-AppxProvisionedPackage -Online -ErrorAction Stop
        Write-Log "$app removed successfully."
    } catch {
        Write-Log "Failed to remove $app. Trying force removal..."
        Start-Process -FilePath "powershell.exe" -ArgumentList "Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage" -Verb RunAs -Wait
    }
}

Write-Log "Office Microsoft Store apps removed."

# Step 4: Remove Office Registry Entries
Write-Log "Cleaning up Office registry entries..."
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Office" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "HKCU:\SOFTWARE\Microsoft\Office" -Recurse -Force -ErrorAction SilentlyContinue
Write-Log "Office registry cleanup completed."

# Step 5: Remove Office Installation Folders (Fix for Permission Errors)
Write-Log "Removing Office installation folders..."
$officeFolders = @(
    "C:\Program Files\Microsoft Office",
    "C:\Program Files (x86)\Microsoft Office",
    "C:\ProgramData\Microsoft\Office",
    "$env:APPDATA\Microsoft\Office"
)

foreach ($folder in $officeFolders) {
    if (Test-Path $folder) {
        Write-Host "Taking ownership of $folder..." -ForegroundColor Yellow
        takeown /f $folder /r /d Y
        icacls $folder /grant Administrators:F /T /C
        Remove-Item -Path $folder -Recurse -Force -ErrorAction SilentlyContinue
        Write-Log "Removed $folder"
    }
}
Write-Log "Office folders deleted."

Write-Host "Microsoft Office 365 has been completely removed!" -ForegroundColor Green
Write-Log "Office 365 uninstallation process completed successfully."
