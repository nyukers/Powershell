# Chapter 15
Invoke-Pester -Path 'D:\Install\Part III\1Creating PowerLab and Automating Virtual Environment Provisioning\Prerequisites.Tests.ps1'

New-Item -Path 'C:\Program Files\WindowsPowerShell\Modules\PowerLab' -ItemType Directory
New-Item -Path 'C:\Program Files\WindowsPowerShell\Modules\PowerLab\PowerLab.psm1'

New-ModuleManifest -Path 'C:\Program Files\WindowsPowerShell\Modules\PowerLab\PowerLab.psd1'`
 -Author 'Admin'`
 -CompanyName 'Forza Ltd., 2022'`
 -RootModule 'PowerLab.psm1'`
 -Description 'This module automates all tasks to provision entire environments of a domain controller, SQL server and IIS web server from scratch.'

 Get-Module -Name PowerLab –ListAvailable

 New-VMSwitch -Name PowerLab -SwitchType Internal

############### Reuse it! ############
 Import-Module -Name PowerLab -Force
 Get-Module -Name PowerLab –ListAvailable
 Get-Command -Module PowerLab
####################################

 New-PowerLabSwitch –Verbose

 New-VM -Name 'LABDC' -Path 'C:\PowerLab\VMs' -MemoryStartupBytes 2GB -Switch 'PowerLab' -Generation 2

 New-PowerLabVm -Name 'LABDC' –Verbose

 New-Vhd -Path 'D:\PowerLab\VHDs\MYVM.vhdx' -SizeBytes 50GB –Dynamic
 Test-Path -Path 'd:\PowerLab\VHDs\MYVM.vhdx'

Get-VM -Name LABDC | Add-VMHardDiskDrive -Path 'D:\PowerLab\VHDs\MYVM.vhdx'
Get-VM -Name LABDC | Get-VMHardDiskDrive

 Invoke-Pester -Path 'D:\Install\Part III\1Creating PowerLab and Automating Virtual Environment Provisioning\Creating PowerLab and Automating Virtual Environment Provisioning.Tests.ps1'

# Chapter 16
 Invoke-Pester -Path 'D:\Install\Part III\2Automating Operating System Installs\Prerequisites.Tests.ps1'

 Install-LABDCOperatingSystem.ps1

 (Get-VMFirmware -VMName 'LABDC').Bootorder
 Start-VM -Name LABDC

 Get-Credential | Export-CliXml -Path d:\PowerLab\LabCredential.xml
 $cred = Import-Clixml -Path d:\PowerLab\LabCredential.xml

 Invoke-Command -VMName LABDC -ScriptBlock { hostname } -Credential $cred
  
 Invoke-Command -VMName LABDC -ScriptBlock { (Get-NetIPAddress -AddressFamily IPv4 | where { $_.InterfaceAlias -notmatch 'Loopback' }).IPAddress } -Credential $cred
 Invoke-Command -VMName LABDC -ScriptBlock { (Get-CimInstance -ClassName Win32_OperatingSystem).Caption } -Credential $cred
 
 Invoke-Pester -Path 'D:\Install\Part III\2Automating Operating System Installs\Automating Operating System Installs.Tests.ps1'

# Chapter 17

Invoke-Pester -Path 'D:\Install\Part III\3Creating an Active Directory Forest\Prerequisites.Tests.ps1'

Invoke-Command -VMName 'LABDC' -Credential $cred -ScriptBlock { Install-Windowsfeature -Name AD-Domain-Services }

# net user Администратор P@$$w0rd12

 'P@$$w0rd12' | ConvertTo-SecureString -Force -AsPlainText | Export-Clixml -Path D:\PowerLab\SafeModeAdmin.xml
 
 $safeModePsw = Import-CliXml -Path D:\PowerLab\SafeModeAdmin.xml
 $cred        = Import-CliXml -Path D:\PowerLab\LabCredential.xml

 $forestParams = @{
 DomainName = 'powerlab.local' 
 DomainMode = 'WinThreshold' 
 ForestMode = 'WinThreshold'
 Confirm = $false 
 SafeModeAdministratorPassword = $safeModePsw 
 WarningAction = 'Ignore'
 Force = $true
 }

Invoke-Command -VMName 'LABDC' -Credential $cred -ScriptBlock { Install-ADDSForest @using:forestParams }

# Do it for 'powerlab\powerlabuser' once!
 Get-Credential | Export-CliXml -Path d:\PowerLab\LabCredential.xml
 $cred = Import-Clixml -Path d:\PowerLab\LabCredential.xml

New-PowerLabActiveDirectoryForest -VMName 'LABDC' -DomainName 'powerlab.local' -Credential $cred -SafeModePassword $safeModePsw

Invoke-Command -VMName 'LABDC' -Credential $cred -ScriptBlock { Get-ADUser -Filter * }
Invoke-Command -VMName 'LABDC' -Credential $cred -ScriptBlock { Get-ADComputer -Filter * }

Test-PowerLabActiveDirectoryForest -VMName 'LABDC' -Credential $cred

Get-PackageProvider -ListAvailable

Install-Module -Name ImportExcel
Import-Module -Name ImportExcel -Force

Import-Excel -Path 'D:\Install\Part III\3Creating an Active Directory Forest\ActiveDirectoryObjects.xlsx' -WorksheetName Users | Format-Table -AutoSize
Import-Excel -Path 'D:\Install\Part III\3Creating an Active Directory Forest\ActiveDirectoryObjects.xlsx' -WorksheetName Groups | Format-Table -AutoSize

New-PowerLabActiveDirectoryTestObject -SpreadsheetPath 'D:\Install\Part III\3Creating an Active Directory Forest\ActiveDirectoryObjects.xlsx'

Invoke-Pester -Path 'D:\Install\Part III\3Creating an Active Directory Forest\Creating an Active Directory Forest.Tests.ps1'

# Chapter 18

Invoke-Pester -Path 'D:\Install\Part III\4Creating SQL Servers From Scratch\Prerequisites.Tests.ps1'

Invoke-Command -VMName 'LABDC' -Credential $cred -ScriptBlock { (Get-AddomainController).Domain }
Invoke-Command -VMName 'LABDC' -Credential $cred -ScriptBlock { $env:USERDNSDOMAIN }
Invoke-Command -VMName 'LABDC' -Credential $cred -ScriptBlock { Get-WmiObject -Namespace root\cimv2 -Class Win32_ComputerSystem | Select Name, Domain }


Invoke-Pester -Path 'D:\Install\Part III\4Creating SQL Servers From Scratch\Creating SQL Servers From Scratch.Tests.ps1'

# Chapter 20

New-PowerLabServer -ServerType Web -DomainCredential (Import-Clixml -Path D:\PowerLab\LabCredential.xml) -VMCredential (Import-Clixml -Path D:\PowerLab\LabCredentialAdmin.xml) -Name WEBSRV

Invoke-Pester -Path 'D:\Install\Part III\6Creating and Configuring IIS Web Servers\Prerequisites.Tests.ps1'

$cred = Import-Clixml -Path D:\PowerLab\LabCredential.xml
Invoke-Command -VMName WEBSRV -ScriptBlock { hostname } -Credential $cred

# Do it for 'websrv\powerlabuser' once!
Get-Credential | Export-CliXml -Path d:\PowerLab\LabCredentialWeb.xml
$cred = Import-Clixml -Path d:\PowerLab\LabCredentialWeb.xml

Install-PowerLabWebServer –ComputerName WEBSRV –DomainCredential $cred

$session = New-PSSession -VMName WEBSRV -Credential $cred
Enter-PSSession -Session $session

[WEBSRV]: PS> Import-Module WebAdministration
[WEBSRV]: PS> Get-PSDrive -Name IIS | Format-Table -AutoSize
[WEBSRV]: PS> Get-Website -Name 'Default Web Site'

[WEBSRV]: PS> Get-Website -Name 'Default Web Site' | Remove-Website
[WEBSRV]: PS> Get-Website
[WEBSRV]: PS>

[WEBSRV]: PS> New-Website -Name PowerShellForSysAdmins -PhysicalPath C:\inetpub\wwwroot\
[WEBSRV]: PS> Set-WebBinding -Name 'PowerShellForSysAdmins' -BindingInformation "*:80:" -PropertyName Port -Value 81
[WEBSRV]: PS> Get-Website -Name PowerShellForSysAdmins

[WEBSRV]: PS> Get-IISAppPool
[WEBSRV]: PS> Get-Command -Name *apppool*
[WEBSRV]: PS> New-WebAppPool -Name 'PowerShellForSysAdmins'
[WEBSRV]: PS> Set-ItemProperty -Path 'IIS:\Sites\PowerShellForSysAdmins' -Name 'ApplicationPool' -Value 'PowerShellForSysAdmins'
[WEBSRV]: PS> Get-Website -Name PowerShellForSysAdmins | Stop-WebSite
[WEBSRV]: PS> Get-Website -Name PowerShellForSysAdmins | Start-WebSite
[WEBSRV]: PS> Get-Website -Name PowerShellForSysAdmins | Select-Object -Property applicationPool

$session | Remove-PSSession
Get-PSSession

New-IISCertificate -WebServerName WEBSRV -PrivateKeyPassword 'P@$$w0rd12'

Invoke-Pester -Path 'D:\Install\Part III\6Creating and Configuring IIS Web Servers\Creating and Configuring IIS Web Servers.Tests.ps1'

# After All
$cred = Import-Clixml -Path d:\PowerLab\LabCredentialSQL2.xml
$session = New-PSSession -VMName SQLSRV -Credential $cred
Enter-PSSession -Session $session
Invoke-WebRequest https://10.0.0.102

$session | Remove-PSSession
Get-PSSession

Import-Module -Name PowerLab -Force
Get-Module -Name PowerLab –ListAvailable

$cred = Import-Clixml -Path d:\PowerLab\LabCredential.xml
Invoke-Command -VMName 'LABDC' -Credential $cred -ScriptBlock { Add-WindowsFeature -Name DHCP -IncludeManagementTools }
Invoke-Command -VMName 'LABDC' -Credential $cred -ScriptBlock { Add-WindowsFeature -Name DNS -IncludeManagementTools }

$ScriptBlock = {
    (Get-WindowsFeature -Name DHCP).Installed
    (Get-WindowsFeature -Name DNS).Installed
    
    Get-Service -Name DHCP
    Get-Service -Name DNS

    Get-DhcpServerv4Scope
}
Invoke-Command -VMName 'LABDC' -Credential $cred -ScriptBlock $ScriptBlock

$ScriptBlock = {
    Add-DhcpServerv4Scope -Name "Internal" -StartRange 10.0.0.110 -EndRange 10.0.0.250 -SubnetMask 255.0.0.0 -Description "PowerLab Internal Network" 
    Set-DhcpServerv4OptionValue -DNSServer 10.0.0.100 -DNSDomain powerlab.local -Router 10.0.0.254
}

Invoke-Command -VMName 'LABDC' -Credential $cred -ScriptBlock $ScriptBlock

Invoke-Command -VMName 'LABDC' -Credential $cred -ScriptBlock { Restart-Service -Name DHCP -Force }
Invoke-Command -VMName 'LABDC' -Credential $cred -ScriptBlock { Get-ADComputer -Filter * | Select Name }


Set-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\WinLogon' -Name Shell -Value 'PowerShell.exe'

$ScriptBlock = {
    # Get-ComputerInfo | select WindowsProductName, WindowsVersion, OsHardwareAbstractionLayer
    # Get-NetIPConfiguration
    # Disable-NetAdapterBinding -Name "Ethernet" -ComponentID ms_tcpip6
    # Get-NetAdapterBinding -ComponentID ms_tcpip6
    # Configure-SMRemoting.exe -Get
    # Enable-NetFirewallRule -DisplayGroup "Windows Remote Management"
    # Get-NetFirewallProfile   -Profile Domain,Public,Private 
    # Get-Hotfix
    # Get-WindowsFeature | Where-Object {$_. installstate -eq "installed"} | ft Name,Installstate

    #Get-PhysicalDisk | Sort Size | FT FriendlyName, Size, MediaType, SpindleSpeed, HealthStatus, OperationalStatus -AutoSize
    #Get-WmiObject -Class Win32_LogicalDisk |`
#        Select-Object -Property DeviceID, VolumeName, @{Label='FreeSpace (Gb)'; expression={($_.FreeSpace/1GB).ToString('F2')}},`
#        @{Label='Total (Gb)'; expression={($_.Size/1GB).ToString('F2')}},`
#        @{label='FreePercent'; expression={[Math]::Round(($_.freespace / $_.size) * 100, 2)}}|ft

#    Get-EventLog system | where-object {$_.eventid -eq 6006} | select -last 10
#    Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Format-Table –AutoSize

     Get-WindowsFeature
     }

Invoke-Command -VMName 'LABDC' -Credential $cred -ScriptBlock $ScriptBlock

# Test GUI 
. "d:\Convert-WindowsImage.ps1"
Convert-WindowsImage -ShowUI
