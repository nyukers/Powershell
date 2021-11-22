<#
describe 'Unit test script' {
     
     mock 'New-Item' {
         return $null
     }
     
     
     it 'Attempts to create the home folder at the right path' {
         C:\VM\shared\PS\!!!\New-UserProvision.ps1 –UserName 'someuser' –HomeFolderPath 'somefolderpath'
         
         Assert-MockCalled 'New-Item' –ParameterFilter { $Path –eq 'somefolderpath' }
     }
 }
#>

<#
describe ‘Integration test script’ {
     
     $parameters = @{
         ‘Username’ = ‘someuser’
         ‘HomeFolderPath’ = ‘F:\tmp\HomeFolders\someuser’
     }
     
     C:\VM\shared\PS\!!!\New-UserProvision.ps1 @parameters
     
     it ‘Attempts to create the home folder at the right path’ {
         
         Test-Path -Path $parameters.HomeFolderPath | should be $true
     }
 }
#>

Param($ComputerName)
describe 'Integration test: Enable-RemoteDesktop' {

     it 'Enables the Remote Desktop firewall rule display group' {
         Invoke-Command -ComputerName $ComputerName -ScriptBlock {(Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server').fDenyTSConnections } |`
          should be 0
     }

     it 'Sets the fDenyTSConnections registry value to 0' {
         $result = (Invoke-Command -ComputerName $ComputerName -ScriptBlock { Get-NetFirewallRule -DisplayGroup 'Дистанционное управление рабочим столом' }).Enabled 
         Compare-Object $result @($true,$true,$true) | should be $null
     }
 }

<#
describe ‘Acceptance (validation) test script’ {
     
     $parameters = @{
         ‘Username’ = ‘someuser’
         ‘HomeFolderPath’ = ‘F:\tmp\HomeFolders\someuser’
     }
     
     C:\VM\shared\PS\!!!\New-UserProvision.ps1 @parameters
     
     ???
 }
#>
