
#Powershell show all devices connected

Write-Host 'Showing devices currently' --ForegroundColor Cyan

#step 1 retitve listing all deives connected and not connected
$devices = Get-PnpDevice -PresentOnly | Where-Object { $_.Status -eq 'OK' }
$devices = $devices | Sort-Object -Property FriendlyName

#step 2 display the devices
$devices | ForEach-Object {
    $device = $_
    Write-Host "Device Name: $($device.FriendlyName)" -ForegroundColor Green
    Write-Host "Device ID: $($device.InstanceId)" -ForegroundColor Yellow
    Write-Host "Device Class: $($device.Class)" -ForegroundColor Cyan
    Write-Host "Status: $($device.Status)" -ForegroundColor Magenta
    Write-Host "----------------------------------------"
}

#step 3 check if no devices found
if ($devices.Count -eq 0) {
    Write-Host "No devices found." -ForegroundColor Red
} else {
    Write-Host "Total devices found: $($devices.Count)" -ForegroundColor Green
}

#step 4 end of script
write-host "Device listing completed." -ForegroundColor Blue

#step5 listing deviced external and internal
$externalDevices = Get-PnpDevice -PresentOnly | Where-Object { $_.Class -eq 'USB' }
$internalDevices = Get-PnpDevice -PresentOnly | Where-Object { $_.Class -ne 'USB' }
Write-Host "External Devices:" -ForegroundColor Cyan
$externalDevices | ForEach-Object {
    Write-Host " - $($_.FriendlyName)" -ForegroundColor Green
}
Write-Host "Internal Devices:" -ForegroundColor Cyan
$internalDevices | ForEach-Object {
    Write-Host " - $($_.FriendlyName)" -ForegroundColor Green
}