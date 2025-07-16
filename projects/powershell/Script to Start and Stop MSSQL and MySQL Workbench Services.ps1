# Script to Start and Stop MSSQL and MySQL Workbench Services
# Run this script with administrator privileges

param (
    [string]$Action  # Accepts "start" or "stop"
)

# Validate input
if ($Action -ne "start" -and $Action -ne "stop") {
    Write-Host "Invalid action. Use 'start' or 'stop'." -ForegroundColor Red
    exit 1
}

# Define service names
$services = @(
    "MSSQLSERVER",  # Default MSSQL Server Service
    "MySQL80"       # Default MySQL Workbench Service (adjust if necessary)
)

foreach ($service in $services) {
    if (Get-Service -Name $service -ErrorAction SilentlyContinue) {
        if ($Action -eq "start") {
            Write-Host "Starting $service..." -ForegroundColor Cyan
            Start-Service -Name $service -ErrorAction SilentlyContinue
        } elseif ($Action -eq "stop") {
            Write-Host "Stopping $service..." -ForegroundColor Yellow
            Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
        }
    } else {
        Write-Host "$service not found." -ForegroundColor Red
    }
}

Write-Host "Action '$Action' completed for database services." -ForegroundColor Green
