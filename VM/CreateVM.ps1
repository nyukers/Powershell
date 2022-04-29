$vmname = 'SuperSrv-01'
New-VM `
  -Name $vmname `
  -MemoryStartupBytes 8GB `
  -NewVHDPath "D:\VM\$vmname\$vmname.vhdx" `
  -NewVHDSizeBytes 500GB `
  -SwitchName 'TEAM-20GB' `
  -Generation 2 `
  -Path 'D:\VM\'

# Сеть
Set-VMNetworkAdapterVlan -VMName $vmname -Access -VlanId 10
Set-VMNetworkAdapter -VMName $vmname -MaximumBandwidth 200000000

# ЦПУ и ОЗУ
Set-VM -VMName $vmname -DynamicMemory -ProcessorCount 4

# Включение EnhancedSessionMode
Set-VMHost -EnableEnhancedSessionMode $True -Passthru

# Включение гостевого пакета интеграции
Enable-VMIntegrationService -VMName $vmname -Name "Guest Service Interface"

# Удаленная сессия
Enter-PSSession -VMName $vmname
Invoke-Command -VMName $vmname -ScriptBlock {Set-Service "Remote Desktop Services" -StartupType Automatic}
Close-PSSession -VMName $vmname

# Установка RDP-сервиса на автоматический запуск
Set-Service "Remote Desktop Services" -StartupType Automatic

# Загрузочный образ
$dvd = Add-VMDvdDrive -VMName $vmname -Path 'D:\VM\Win11.iso' -Passthru

# Стартуем с DVD
Set-VMFirmware -VMName $vmname -FirstBootDevice $dvd 

# Старт VM
Start-VM -Name $vmname
