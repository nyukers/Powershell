$vmname = 'SuperSrv-01'
New-VM `
  -Name $vmname `
  -MemoryStartupBytes 8GB `
  -NewVHDPath "D:\VM\$vmname\$vmname.vhdx" `
  -NewVHDSizeBytes 500GB `
  -SwitchName 'TEAM-20GB' `
  -Generation 2 `
  -Path 'D:\VM\'

# ����
Set-VMNetworkAdapterVlan -VMName $vmname -Access -VlanId 10
Set-VMNetworkAdapter -VMName $vmname -MaximumBandwidth 200000000

# ��� � ���
Set-VM -VMName $vmname -DynamicMemory -ProcessorCount 4

# ��������� EnhancedSessionMode
Set-VMHost -EnableEnhancedSessionMode $True -Passthru

# ��������� ��������� ������ ����������
Enable-VMIntegrationService -VMName $vmname -Name "Guest Service Interface"

# ��������� ������
Enter-PSSession -VMName $vmname
Invoke-Command -VMName $vmname -ScriptBlock {Set-Service "Remote Desktop Services" -StartupType Automatic}
Close-PSSession -VMName $vmname

# ��������� RDP-������� �� �������������� ������
Set-Service "Remote Desktop Services" -StartupType Automatic

# ����������� �����
$dvd = Add-VMDvdDrive -VMName $vmname -Path 'D:\VM\Win11.iso' -Passthru

# �������� � DVD
Set-VMFirmware -VMName $vmname -FirstBootDevice $dvd 

# ����� VM
Start-VM -Name $vmname
