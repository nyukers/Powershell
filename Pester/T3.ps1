function T3 {
     [CmdletBinding()]
     param
     (
         [Parameter(Mandatory)]
         [string]$ComputerName
     )
     $sb = { Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name 'fDenyTSConnections' -Value 0;
     Enable-NetFirewallRule -DisplayGroup 'Дистанционное управление рабочим столом'
 }
     Invoke-Command -ComputerName $ComputerName -ScriptBlock $sb
}
