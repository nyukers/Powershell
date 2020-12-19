### for Pull Server installation 

Find-Module xPSDesiredStateConfiguration
Find-Module xWebAdministration


Install-Module -Name xPSDesiredStateConfiguration, xWebAdministration -Force

Import-Module -Name xPSDesiredStateConfiguration

Start-DscConfiguration -ComputerName GOVERLA -Path .\MOF\ -Wait -Verbose

Restart-computer -ComputerName GOVERLA -Wait -Force

Test-DscConfiguration -ComputerName GOVERLA

Start-Process -FilePath iexplore.exe https://GOVERLA:8080/PSDSCPullServer.svc

### for Guest configuration

$psclientid = New-Guid | select -ExpandProperty guid
$psclientid
#5827c542-20bb-487c-89cb-484cbe5f0b1f

$pscs = New-CimSession -ComputerName GUEST01
$psclientid = Get-DscLocalConfigurationManager -CimSession $pscs | select -ExpandProperty ConfigurationID

Get-ChildItem -Path C:\scripts\MOF\GUEST01.mof | Rename-Item -NewName "C:\scripts\MOF\$psclientid.mof"
New-DscChecksum -Path "C:\scripts\MOF\$psclientid.mof" -Force

#The MOF and checksum files
#5827c542-20bb-487c-89cb-484cbe5f0b1f.mof
#5827c542-20bb-487c-89cb-484cbe5f0b1f.mof.checksum

