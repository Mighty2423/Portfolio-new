# Run this script with administrator privileges
$logPath = "$env:USERPROFILE\SetupScript.log"

# Function to write log messages
function Write-Log {
    param ([string]$Message)
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Add-Content -Path $logPath -Value "$timestamp - $Message"
    Write-Host "$Message" -ForegroundColor Cyan
}

# Ensure running as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as Administrator!" -ForegroundColor Red
    exit
}

Write-Log "Script execution started."

# Install PSWindowsUpdate if needed
#if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
#    Install-Module PSWindowsUpdate -Force -SkipPublisherCheck
#    Import-Module PSWindowsUpdate
#}
#Write-Log "PSWindowsUpdate module installed."

# Perform Windows Update
#Write-Log "Updating Windows..."
#Get-WindowsUpdate -Install -AcceptAll -AutoReboot
#Write-Log "Windows updates completed."

# Update Drivers
Write-Log "Scanning for driver updates..."
pnputil /scan-devices
Write-Log "Driver scan completed."

# Define installation URLs
#$softwareUrls = @{
    #"Python" = "https://www.python.org/ftp/python/3.12.0/python-3.12.0-amd64.exe";
    #"MySQLWorkbench" = "https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community-8.0.34-winx64.msi";
    #"MSSQL" = "https://aka.ms/ssmsfullsetup";
    #"VSCode" = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user";
    #"VirtualBox" = "https://download.virtualbox.org/virtualbox/7.0.10/VirtualBox-7.0.10-158379-Win.exe";
    #"Office365Installer" = "https://go.microsoft.com/fwlink/p/?linkid=844014"; 
    #"Steam" = "https://cdn.cloudflare.steamstatic.com/client/installer/SteamSetup.exe";
    #"GitHubDesktop" = "https://central.github.com/deployments/desktop/desktop/latest/win32";
    #"Git" = "https://git-scm.com/download/win";
    #"Docker" = "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe";
    #"Gimp" = "https://download.gimp.org/gimp/v2.10/windows/gimp-2.10.38-setup-1.exe";
    #".NET" = "https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/sdk-8.0.406-windows-x64-installer";
    #"Wireshark" = "https://2.na.dl.wireshark.org/win64/Wireshark-4.4.3-x64.exe";
    #"NodeJS" = "https://nodejs.org/dist/v20.10.0/node-v20.10.0-x64.msi";
    #"PostgreSQL" = "https://get.enterprisedb.com/postgresql/postgresql-16.2-1-windows-x64.exe";
    #"7-Zip" = "https://www.7-zip.org/a/7z2401-x64.exe";
    #"BraveBrowser" = "https://referrals.brave.com/latest/BraveBrowserSetup.exe";
#}

# Download and install each software
# Get the user's Downloads folder
#$downloadsFolder = [System.IO.Path]::Combine([System.Environment]::GetFolderPath("UserProfile"), "Downloads")
#
## Ensure the Downloads folder exists
#if (!(Test-Path -Path $downloadsFolder)) {
#    New-Item -ItemType Directory -Path $downloadsFolder -Force
#}
#
## Download and install each software
#foreach ($software in $softwareUrls.GetEnumerator()) {
#    $downloadPath = [System.IO.Path]::Combine($downloadsFolder, "$($software.Key).exe")
#    
#    Write-Host "Downloading $($software.Key) to $downloadPath..." -ForegroundColor Yellow
#    Invoke-WebRequest -Uri $software.Value -OutFile $downloadPath
#
#    Write-Host "Installing $($software.Key)..." -ForegroundColor Yellow
#    Start-Process -FilePath $downloadPath -ArgumentList "/quiet /norestart" -Wait
#}
#Write-Log "Software installations completed."
#Write-Host "All software installations completed!" -ForegroundColor Green


# Remove Old Office 365 and Install New
Write-Log "Office 365 installed."

# Encrypt & Securely Store Admin Password
#$adminUser = "HiddenAdmin" # Change to your preferred name
#$passwordFile = "$env:USERPROFILE\adminPassword.sec"
#
#if (-not (Test-Path $passwordFile)) {
#    $securePassword = Read-Host "Enter the admin password" -AsSecureString
#    $securePassword | ConvertFrom-SecureString | Set-Content $passwordFile
#    Write-Log "Admin password encrypted and stored."
#} else {
#    Write-Log "Using stored admin password."
#    $securePassword = Get-Content $passwordFile | ConvertTo-SecureString
#}

# Create Hidden Admin Account
#$adminCredential = New-Object System.Management.Automation.PSCredential($adminUser, $securePassword)
#New-LocalUser -Name $adminUser -Password $securePassword -FullName "Admin Account" -Description "Hidden Admin Access" -PasswordNeverExpires:$true
#Add-LocalGroupMember -Group "Administrators" -Member $adminUser
#Write-Log "Hidden admin account $adminUser created."

# Enable Secure Remote Admin Control
Write-Log "Enabling remote admin control securely..."
Enable-PSRemoting -Force
Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $false
Write-Log "Remote admin setup completed."

Write-Log "Script execution completed successfully."
Write-Host "Setup Complete. Log file: $logPath" -ForegroundColor Green
