(Get-WmiObject -query "SELECT * FROM SoftwareLicensingService").OA3xOriginalProductKey
(Get-WmiObject -query "SELECT * FROM SoftwareLicensingService").KeyManagementServiceProductKeyID

Get-WmiObject -query "SELECT * FROM SoftwareLicensingService"

wmic path  softwarelicensingservice  get  OA3xOriginalProductKeyDescription
wmic path  softwarelicensingservice  get  KeyManagementServiceProductKeyID

wmic path  softwarelicensingservice  get  * > 11111.txt

slmgr.vbs /dlv

Get-WmiObject -Class Win32_OperatingSystem