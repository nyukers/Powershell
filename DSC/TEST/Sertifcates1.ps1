Get-ChildItem -Path Cert:LocalMachine\MY

Get-ChildItem  -Path Cert:\LocalMachine\MY | Where-Object {$_.Subject -Match "ssw"} | Select-Object FriendlyName, Thumbprint, Subject, NotBefore, NotAfter



#Change to the location of the personal certificates
Set-Location Cert:\CurrentUser\My

#Change to the location of the local machine certificates
Set-Location Cert:\LocalMachine\My

#Get the installed certificates in that location
Get-ChildItem | Format-Table Subject, FriendlyName, Thumbprint -AutoSize

#Get the installed certificates from a remote machine
$Srv = "SERVER-HOSTNAME"
$Certs = Invoke-Command -Computername $Srv -Scriptblock {Get-ChildItem "Cert:\LocalMachine\My"}