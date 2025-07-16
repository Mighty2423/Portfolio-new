# PowerShell Update and SQL Compatibility Setup Script
# Run this script with administrator privileges
#run in visostudio

Write-Host "Starting PowerShell Update and SQL Setup..." -ForegroundColor Cyan

# Step 1: Update PowerShell to the Latest Version
Write-Host "Checking for PowerShell Updates..." -ForegroundColor Yellow
winget install --id Microsoft.Powershell --source winget -e

# Step 2: Install Required PowerShell Modules
Write-Host "Installing SQL Server PowerShell Module..." -ForegroundColor Yellow
Install-Module -Name SQLServer -Scope CurrentUser -Force
Import-Module SQLServer

Write-Host "Installing Windows Management Framework (WMF)..." -ForegroundColor Yellow
Install-Module -Name PSReadline -Scope CurrentUser -Force
Install-Module -Name PowerShellGet -Scope CurrentUser -Force

# Step 3: Enable Execution Policy for Scripts
Write-Host "Setting Execution Policy..." -ForegroundColor Yellow
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# Step 4: Install MySQL Connector and Tools
Write-Host "Installing MySQL Tools and Connectors..." -ForegroundColor Yellow
winget install -e --id Oracle.MySQL
winget install -e --id Oracle.MySQL.Workbench

# Step 5: Enable and Start SQL Services
Write-Host "Ensuring SQL Services are Running..." -ForegroundColor Yellow
$services = @("MSSQLSERVER", "MySQL80")
foreach ($service in $services) {
    Set-Service -Name $service -StartupType Automatic
    Start-Service -Name $service
}

# Step 6: Verify Installation
Write-Host "Verifying SQL Server Module..." -ForegroundColor Yellow
Get-Module -ListAvailable | Where-Object { $_.Name -like "SQLServer" }

Write-Host "PowerShell and SQL Setup Complete!" -ForegroundColor Green
