Param($ComputerName)

describe 'Enable-RemoteDesktop' {

     it 'Enables the Remote Desktop firewall rule display group' {
         Invoke-Command -ComputerName $ComputerName -ScriptBlock {(Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server').fDenyTSConnections } |`
          should be 0
     }

     it 'Sets the fDenyTSConnections registry value to 0' {
         $result = (Invoke-Command -ComputerName $ComputerName -ScriptBlock { Get-NetFirewallRule -DisplayGroup 'Дистанционное управление рабочим столом' }).Enabled 
         Compare-Object $result @($true,$true,$true) | should be $null
     }
 }