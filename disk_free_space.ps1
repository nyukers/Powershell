$disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'" | Select-Object Size, FreeSpace
Write-Host ("{0}" -f [math]::truncate($disk.FreeSpace / 1GB))