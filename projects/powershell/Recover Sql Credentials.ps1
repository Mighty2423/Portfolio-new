# Script to Recover MSSQL and MySQL Workbench Credentials
# Run this script with administrator privileges

Write-Host "Attempting to retrieve saved SQL credentials..." -ForegroundColor Yellow

# Retrieve MSSQL Authentication Info (Windows Authentication)
Write-Host "Checking Windows Credential Manager for MSSQL saved credentials..." -ForegroundColor Cyan
$creds = cmdkey /list | Select-String "MSSQL"
if ($creds) {
    Write-Host "MSSQL Credentials Found:" -ForegroundColor Green
    Write-Host $creds
} else {
    Write-Host "No MSSQL credentials found in Windows Credential Manager." -ForegroundColor Red
}

# Extract MySQL Workbench Saved Passwords (If Stored in User Config)
$mysqlConfigPath = "$env:APPDATA\MySQL\Workbench\wb_options.xml"
if (Test-Path $mysqlConfigPath) {
    Write-Host "Extracting stored MySQL Workbench settings..." -ForegroundColor Cyan
    $config = Get-Content $mysqlConfigPath | Select-String "password="
    if ($config) {
        Write-Host "Potential MySQL Workbench Credentials Found:" -ForegroundColor Green
        Write-Host $config
    } else {
        Write-Host "No saved passwords found in MySQL Workbench config." -ForegroundColor Red
    }
} else {
    Write-Host "MySQL Workbench config file not found." -ForegroundColor Red
}

Write-Host "Credential retrieval complete." -ForegroundColor Green
