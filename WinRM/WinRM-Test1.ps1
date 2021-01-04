# Test a remoting connection to localhost, which should work.

$httpResult = Invoke-Command -ComputerName "localhost" -ScriptBlock {$env:COMPUTERNAME} -ErrorVariable httpError -ErrorAction SilentlyContinue

If ($httpResult)
{
    Write-Host "HTTP: Enabled"
}
Else
{
    Write-Host "HTTP: Disabled"
}

$httpsOptions = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck
$httpsResult = New-PSSession -UseSSL -ComputerName "localhost" -SessionOption $httpsOptions -ErrorVariable httpsError -ErrorAction SilentlyContinue

If ($httpsResult)
{
    Write-Host "HTTPS: Enabled"
}
Else
{
    Write-Host "HTTPS: Disabled"
}


#######################################################

(Get-Service -Name winrm).Status 

Get-NetConnectionProfile
Get-NetTCPConnection | Where-Object -Property LocalPort -EQ 5986

Write-Host $env:computerName'.'$env:USERDNSDOMAIN
$hostFQDN = [System.Net.Dns]::GetHostByName(($env:computerName)).Hostname
Write-Host $hostFQDN

# new certificate

$thumbprint = "‎11e281d98636753a1fc14d45b869d50a7e326591"
Get-ChildItem -Path cert:\LocalMachine\My -Recurse | Where-Object { $_.Thumbprint -eq $thumbprint } | Select-Object *

$selector_set = @{
    Address = "*"
    Transport = "HTTPS"
}
$value_set = @{
    CertificateThumbprint = "11E281D98636753A1FC14D45B869D50A7E326591"
}

New-WSManInstance -ResourceURI "winrm/config/Listener" -SelectorSet $selector_set -ValueSet $value_set

