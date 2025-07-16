# VM Settings
$VMName = "DBLabVM"
$VHDPath = "C:\HyperV\Virtual Hard Disks\$VMName.vhdx"
$SwitchName = "Default Switch"  # Or a bridged network adapter name
$ISOPath = "C:\Users\alton\Downloads\ubuntu-24.04.2-desktop-amd64.iso"
$MemoryStartup = 31GB
$VHDSize = 64GB

# Create VM
New-VM -Name $VMName -MemoryStartupBytes $MemoryStartup -Generation 2 -NewVHDPath $VHDPath -NewVHDSizeBytes $VHDSize -SwitchName $SwitchName

# Attach Ubuntu ISO
Set-VMDvdDrive -VMName $VMName -Path $ISOPath

# Set boot from DVD
Set-VMFirmware -VMName $VMName -FirstBootDevice $(Get-VMFirmware -VMName $VMName).BootOrder | Where-Object { $_.Device -eq "CD" }

# Enable secure boot with Ubuntu template
Set-VMFirmware -VMName $VMName -EnableSecureBoot On -SecureBootTemplate "MicrosoftUEFICertificateAuthority"

# Optional: Enable Enhanced Session Mode
Set-VM -Name $VMName -EnhancedSessionTransportType HvSocket

# Start VM
Start-VM -Name $VMName
