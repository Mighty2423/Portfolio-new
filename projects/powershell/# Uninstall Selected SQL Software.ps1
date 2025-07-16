# Uninstall Selected SQL Software
# Run this script as Administrator

# Function to uninstall a program if found
function Uninstall-Software {
    param (
        [string]$softwareName
    )

    $app = Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE Name LIKE '%$softwareName%'" -ErrorAction SilentlyContinue

    if ($app) {
        Write-Host "Uninstalling $softwareName..." -ForegroundColor Yellow
        $app.Uninstall()
        Write-Host "$softwareName has been uninstalled." -ForegroundColor Green
    } else {
        Write-Host "$softwareName not found. Skipping..." -ForegroundColor Cyan
    }
}

# Choose which SQL software to remove (comment out the ones you want to keep)
Uninstall-Software "Microsoft OLE DB Driver for SQL Server"
Uninstall-Software "SQL Server Management Studio Language Pack - English"
Uninstall-Software "SQL Server Management Studio"
Uninstall-Software "Microsoft ODBC Driver 17 for SQL Server"

Write-Host "Uninstallation process completed!" -ForegroundColor Green
