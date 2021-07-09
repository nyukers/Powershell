﻿get-wmiobject Win32_Product | sort-object -property Name | Format-Table IdentifyingNumber, Name, LocalPackage -AutoSize

$UninstallKeys = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall", "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
$null = New-PSDrive -Name HKA -PSProvider Registry -Root Registry::HKEY_USERS
$UninstallKeys += Get-ChildItem HKU: -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'S-\d-\d+-(\d+-){1,14}\d+$' } | ForEach-Object { "HKU:\$($_.PSChildName)\Software\Microsoft\Windows\CurrentVersion\Uninstall" }
foreach ($UninstallKey in $UninstallKeys) {
Get-ChildItem -Path $UninstallKey -ErrorAction SilentlyContinue | Where {$_.PSChildName -match '^{[A-Z0-9]{8}-([A-Z0-9]{4}-){3}[A-Z0-9]{12}}$'} | Select-Object @{n='GUID';e={$_.PSChildName}}, @{n='Name'; e={$_.GetValue('DisplayName')}}
}
