# Define time range (last 1 hour)

$startTime = (Get-Date).AddHours(-1)
$endTime = Get-Date  # Current time

# Define event log source (System, Application, Security, etc.)
$logName = "System"  # Change this as needed (e.g., "Application", "Security")

# Get events from the last hour
$events = Get-WinEvent -LogName $logName -FilterXPath "*[System[TimeCreated[timediff(@SystemTime) <= 3600000]]]" -MaxEvents 100

# Output the events
$events | Select-Object TimeCreated, Id, ProviderName, Message | Format-Table -AutoSize

# Optional: Export to a CSV file
$events | Select-Object TimeCreated, Id, ProviderName, Message | Export-Csv -Path "C:\logs\LastHourEvents.csv" -NoTypeInformation
