# Serial number
Get-WmiObject win32_bios | select Serialnumber
wmic bios get SerialNumber

# Product number
Get-WmiObject win32_computersystem | Select-Object SystemSKUNumber
wmic computersystem get SystemSKUNumber

# Узнать производителя 
Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty Manufacturer
wmic csproduct get vendor

# Узнать модель 
Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty Model
wmic csproduct get name