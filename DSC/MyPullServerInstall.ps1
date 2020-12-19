Find-Module xPSDesiredStateConfiguration
Find-Module xWebAdministration


Install-Module -Name xPSDesiredStateConfiguration, xWebAdministration -Force

Import-Module -Name xPSDesiredStateConfiguration

Start-DscConfiguration -ComputerName GOVERLA -Path .\MOF\ -Wait -Verbose

Restart-computer -ComputerName GOVERLA -Wait -Force

Test-DscConfiguration -ComputerName GOVERLA

Start-Process -FilePath iexplore.exe https://GOVERLA:8080/PSDSCPullServer.svc

Get-Module -ListAvailable