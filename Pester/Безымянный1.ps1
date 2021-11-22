Invoke-Pester -Path C:\VM\shared\PS\!!!\T5.Tests.ps1

New-Fixture -Path C:\VM\shared\PS\!!! –Name T3

Invoke-Pester -Path C:\VM\shared\PS\!!!\New-UserProvision.Tests.ps1 

Invoke-Pester –Script @{'Path' = 'C:\VM\shared\PS\!!!\New-UserProvision.Tests.ps1';'Parameters' = @{'ComputerName' = 'GOVERLA'}}

Invoke-Pester –Script @{'Path' = 'C:\VM\shared\PS\!!!\T3.Tests.ps1';'Parameters' = @{'ComputerName' = 'GOVERLA'}}

New-LocalUser -
New-Item

param(
     [Parameter()]
     [string]$Username,
     [Parameter()]
     [string]$HomeFolderPath
 )
 New-LocalUser –Name $Username
 New-Item –Path $HomeFolderPath –ItemType Directory

 $HomeFolderPath = ‘F:\tmp\HomeFolders\someuser’
 Test-Path -Path $HomeFolderPath

 Get-NetFirewallRule -DisplayGroup 'Дистанци*' | Select DisplayGroup