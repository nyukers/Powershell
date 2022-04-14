Get-Service -Name snmp*

#Windwos 10 сборка 1803
Enable-WindowsOptionalFeature -online -FeatureName SNMP

Get-WindowsCapability  -Online -Name "SNMP*"

Add-WindowsCapability  -Online -Name "SNMP.Client~~~~0.0.1.0"

Add-WindowsCapability  -Online -Name "SNMP.Client*"

#HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\
#UseWUServer = 0
#netsh winhttp reset proxy
#net stop wuauserv
#net start wuauserv

DISM /online /get-capabilities

DISM /online /Cleanup-Image /StartComponentCleanup
DISM /online /Cleanup-Image /RestoreHealth
#DISM /Online /Cleanup-Image /RestoreHealth /source:WIM:E:\Sources\Install.wim:1 /LimitAccess
DISM /online /add-capability /capabilityname:SNMP.Client~~~~0.0.1.0

dism /online /enable-feature /featurename:SNMP