# Define log file
$logFile = "C:\Chipset_Diagnostics.txt"

# Function to write output to file
function LogWrite {
    Param ([string]$logText)
    $logText | Out-File -FilePath $logFile -Append
}

# Clear previous log file
if (Test-Path $logFile) { Remove-Item $logFile }

LogWrite "===== SYSTEM CHIPSET & HARDWARE DIAGNOSTICS ====="
LogWrite ""

# 1️⃣ Get System Information
LogWrite "🔹 System Information:"
systeminfo | Out-File -FilePath $logFile -Append
LogWrite ""

# 2️⃣ Get Chipset & Motherboard Details
LogWrite "🔹 Chipset & Motherboard:"
Get-WmiObject Win32_BaseBoard | Select-Object Manufacturer, Product, SerialNumber | Format-List | Out-File -FilePath $logFile -Append
LogWrite ""

# 3️⃣ Get Installed Chipset Drivers
LogWrite "🔹 Installed Chipset Drivers:"
Get-WmiObject Win32_PnPSignedDriver | Where-Object { $_.DeviceName -like "*chipset*" -or $_.DeviceName -like "*PCI*Root*"} | 
Select-Object DeviceName, DriverVersion, Manufacturer | Format-Table -AutoSize | Out-File -FilePath $logFile -Append
LogWrite ""

# 4️⃣ Check for DPC Latency Issues (Event Viewer)
LogWrite "🔹 Recent System Errors (DPC & Kernel-Power Issues):"
Get-EventLog -LogName System -EntryType Error -Newest 20 | Where-Object { $_.EventID -eq 129 -or $_.EventID -eq 41 } | 
Select-Object TimeGenerated, Source, EventID, Message | Format-Table -AutoSize | Out-File -FilePath $logFile -Append
LogWrite ""

# 5️⃣ Get PCI Express Issues
LogWrite "🔹 PCI Express Warnings:"
Get-EventLog -LogName System -EntryType Warning -Newest 20 | Where-Object { $_.Source -like "*PCI*" } | 
Select-Object TimeGenerated, Source, EventID, Message | Format-Table -AutoSize | Out-File -FilePath $logFile -Append
LogWrite ""

# 6️⃣ List Running Processes with High CPU/Disk Usage
LogWrite "🔹 High CPU & Disk Usage Processes:"
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 ProcessName, CPU, ID | Format-Table -AutoSize | Out-File -FilePath $logFile -Append
LogWrite ""

# 7️⃣ Check System Power Issues (Sleep, Throttling, etc.)
LogWrite "🔹 System Power & Performance Issues:"
powercfg /energy /output C:\power_report.html
LogWrite "Power report saved as C:\power_report.html"
LogWrite ""

LogWrite "===== END OF REPORT ====="
Write-Host "Report saved to: C:\Chipset_Diagnostics.txt"
