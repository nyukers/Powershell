$DevGuard = Get-CimInstance –ClassName Win32_DeviceGuard –Namespace root\Microsoft\Windows\DeviceGuard
if ($DevGuard.SecurityServicesConfigured -contains 1) {"Credential Guard configured"}
if ($DevGuard.SecurityServicesRunning -contains 1) {"Credential Guard running"}

Set-MpPreference -DisableRealtimeMonitoring $True
Set-MpPreference -DisableRealtimeMonitoring $false

Set-MpPreference -DisableIOAVProtection $true
Set-MpPreference -DisableIOAVProtection $false

Get-MpComputerStatus | Select AMProductVersion