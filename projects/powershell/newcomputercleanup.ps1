# Clean Work Environment Setup Script
# Run this script with administrator privileges

# Uninstall Unnecessary Apps
$unnecessaryApps = @(
    "Microsoft.XboxApp",
    "Microsoft.XboxGamingOverlay",
    "Microsoft.YourPhone",
    "Microsoft.MixedReality.Portal",
    "Microsoft.GetHelp",
    "Microsoft.Getstarted",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo"
)

foreach ($app in $unnecessaryApps) {
    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
    Get-AppxProvisionedPackage -Online | Where-Object DisplayName -EQ $app | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
}

# Disable Cortana
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0 -Force

# Disable Telemetry (Data Collection)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Force

# Turn Off Unnecessary Notifications
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -Value 0

# Stop and Disable Unused Services
$unusedServices = @(
    "DiagTrack",   # Connected User Experiences and Telemetry
    "MapsBroker",  # Downloadable Maps Manager
    "RetailDemo"
)

foreach ($service in $unusedServices) {
    Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
    Set-Service -Name $service -StartupType Disabled
}

# Optimize Power Settings for Performance
powercfg -change -monitor-timeout-ac 0
powercfg -change -disk-timeout-ac 0
powercfg -change -standby-timeout-ac 0
powercfg -change -hibernate-timeout-ac 0
powercfg -setactive SCHEME_MIN  # Set High-Performance Plan

# Disable Public Network Sharing
Set-NetConnectionProfile -NetworkCategory Private

# Enable Windows Updates (Optional, can be commented out)
# Set-Service -Name "wuauserv" -StartupType Manual
# Start-Service -Name "wuauserv"

# Remove Temporary Files
Get-ChildItem -Path "C:\Windows\Temp" -Recurse | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "$env:TEMP" -Recurse | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

# Display Completion Message
Write-Host "System cleaned and optimized for a work environment." -ForegroundColor Green
