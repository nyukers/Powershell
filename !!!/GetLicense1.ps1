(Get-WmiObject -query "SELECT * FROM SoftwareLicensingService").OA3xOriginalProductKey
(Get-WmiObject -query "SELECT * FROM SoftwareLicensingService").KeyManagementServiceProductKeyID

Get-WmiObject -query "SELECT * FROM SoftwareLicensingService"

Get-WmiObject -Class Win32_OperatingSystem

wmic path  softwarelicensingservice  get  OA3xOriginalProductKeyDescription
wmic path  softwarelicensingservice  get  KeyManagementServiceProductKeyID

wmic path  softwarelicensingservice  get  * > 11111.txt

slmgr.vbs /dlv
slmgr.vbs /dli
slmgr.vbs /xpr

slmgr.vbs /rilc

Set-Location -Path "$env:windir\System32"
$command = "cscript.exe slmgr.vbs /dlv > C:\tmp\activation.txt"
Invoke-Expression $command
