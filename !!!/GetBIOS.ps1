Get-WmiObject -Class Win32_BIOS | Format-List *

Get-WmiObject -Class Win32_BIOS -Property Caption,BIOSVersion,BIOSCharacteristics

Get-WmiObject -Class Win32_SMBIOSMemory | Format-List *
Get-WmiObject -Class Win32_SystemBIOS | Format-List *

WMIC BIOS GET Name,Version,Status,SMBIOSPresent