Get-WindowsCapability -Name RSAT* -Online
Get-WindowsCapability -Name RSAT* -Online | Select-Object -Property DisplayName, State

Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability –Online

$val = Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "UseWUServer" | select -ExpandProperty UseWUServer
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "UseWUServer" -Value 0
Restart-Service wuauserv
Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability –Online
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "UseWUServer" -Value $val
Restart-Service wuauserv