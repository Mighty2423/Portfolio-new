# List All Installed SQL-Related Software
# Run this script as Administrator

# Function to log results
function Write-Log {
    param ([string]$Message)
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Write-Host "$timestamp - $Message" -ForegroundColor Cyan
}

Write-Log "Searching for installed SQL-related software..."

# Search for all installed programs related to SQL
$installedSQL = Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE Name LIKE '%SQL%'" -ErrorAction SilentlyContinue

if ($installedSQL) {
    Write-Host "Found the following SQL-related software:" -ForegroundColor Green
    $installedSQL | Select-Object Name, Version, Vendor
} else {
    Write-Host "No SQL-related software found." -ForegroundColor Red
}
