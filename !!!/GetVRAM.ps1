Get-WmiObject win32_videocontroller | Select-Object Name, CurrentRefreshRate
Get-WmiObject win32_videocontroller | Select-Object Name, VideoProcessor, AdapterRAM
Get-WmiObject win32_videocontroller | Select-Object Name, VideoProcessor, @{Name='AdapterRAM (GB)';Expression={[math]::Round($_.AdapterRAM / 1GB, 2)}}

Get-ComputerInfo | Select-Object CsTotalPhysicalMemory
Get-WmiObject win32_videocontroller | Select-Object Name, VideoProcessor, @{Name='DedicatedVRAM (GB)';Expression={[math]::Round($_.AdapterRAM / 1GB, 2)}}, @{Name='SharedVRAM (GB)';Expression={[math]::Round($_.SharedSystemMemory / 1GB, 2)}}

Get-WmiObject Win32_VideoController | Select-Object Name, VideoProcessor, @{Name='DedicatedVRAM (MB)';Expression={[math]::Round($_.AdapterRAM / 1MB, 0)}}, @{Name='SharedVRAM (MB)';Expression={[math]::Round($_.SharedSystemMemory / 1MB, 0)}}

Get-CimInstance Win32_VideoController | Select-Object Name, VideoProcessor, @{Name='DedicatedVRAM (MB)';Expression={[math]::Round($_.AdapterRAM / 1MB, 0)}}, @{Name='SharedVRAM (MB)';Expression={[math]::Round($_.SharedSystemMemory / 1MB, 0)}}

dxdiag
# Запускаємо dxdiag і зберігаємо в текстовий файл
dxdiag /t c:\ps\dxdiag.txt

# Читаємо файл dxdiag.txt
$dxdiagFile = Get-Content "dxdiag.txt"

# Шукаємо потрібні дані про пам'ять
$dedicatedMemory = ($dxdiagFile | Select-String -Pattern "Dedicated Memory" | ForEach-Object { $_.Line }) -replace ".*: ",""
$sharedMemory = ($dxdiagFile | Select-String -Pattern "Shared Memory" | ForEach-Object { $_.Line }) -replace ".*: ",""

# Виводимо результат
Write-Host "Dedicated Memory: $dedicatedMemory"
Write-Host "Shared Memory: $sharedMemory"
