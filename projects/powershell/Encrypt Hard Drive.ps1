# Script to Encrypt a Hard Drive and Store the Key on a Flash Drive and Local Folder
# Run this script with administrator privileges

param (
    [string]$DriveLetter = "C:",  # Drive to encrypt
    [string]$FlashDriveLetter = "E:"  # Flash drive to store the encryption key
)

# Check if BitLocker is enabled
$bitlockerStatus = Get-BitLockerVolume -MountPoint $DriveLetter
if ($bitlockerStatus.ProtectionStatus -eq "On") {
    Write-Host "The drive $DriveLetter is already encrypted." -ForegroundColor Yellow
    exit
}

# Generate encryption key path
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$keyFolderPath = "$scriptPath\encrypt_keys"
$keyFilePath = "$keyFolderPath\$DriveLetter-key.bek"
$flashKeyPath = "$FlashDriveLetter\$DriveLetter-key.bek"

# Ensure key storage folder exists
if (!(Test-Path $keyFolderPath)) {
    New-Item -ItemType Directory -Path $keyFolderPath | Out-Null
}

# Enable BitLocker and save the key
Write-Host "Encrypting $DriveLetter and saving recovery key..." -ForegroundColor Cyan
Enable-BitLocker -MountPoint $DriveLetter -RecoveryKeyPath $keyFolderPath -UsedSpaceOnly -EncryptionMethod XtsAes256 -Confirm:$false

# Copy key to flash drive
if (Test-Path $FlashDriveLetter) {
    Copy-Item -Path $keyFilePath -Destination $flashKeyPath -Force
    Write-Host "Encryption key saved to flash drive: $flashKeyPath" -ForegroundColor Green
} else {
    Write-Host "Flash drive not found. Key saved only in local folder." -ForegroundColor Yellow
}

Write-Host "Encryption complete. Store your recovery key safely!" -ForegroundColor Green
