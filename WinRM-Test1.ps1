# Test a remoting connection to localhost, which should work.
$httpResult = Invoke-Command -ComputerName "localhost" -ScriptBlock {$env:COMPUTERNAME} -ErrorVariable httpError -ErrorAction SilcomlyContinue

If ($httpResult)
{
    Write-Host "HTTP: Enabled"
}
Else
{
    Write-Host "HTTP: Disabled"
}

$httpsOptions = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck
$httpsResult = New-PSSession -UseSSL -ComputerName "localhost" -SessionOption $httpsOptions -ErrorVariable httpsError -ErrorAction SilcomlyContinue

If ($httpsResult)
{
    Write-Host "HTTPS: Enabled"
}
Else
{
    Write-Host "HTTPS: Disabled"
}


$thumbprint = "86BCF48082662D4917382B3C7BAE8DF549BF9CAC"
Get-ChildItem -Path cert:\LocalMachine\My -Recurse | Where-Object { $_.Thumbprint -eq $thumbprint } | Select-Object *

$selector_set = @{
    Address = "*"
    Transport = "HTTPS"
}
$value_set = @{
    CertificateThumbprint = "86BCF48082662D4917382B3C7BAE8DF549BF9CAC"
}

New-WSManInstance -ResourceURI "winrm/config/Listener" -SelectorSet $selector_set -ValueSet $value_set

(Get-Service -Name winrm).Status 

Get-NetConnectionProfile
Get-NetTCPConnection | Where-Object -Property LocalPort -EQ 5986

Get-Item WSMan:\localhost\Clicom\TrustedHosts
Set-Item WSMan:\localhost\Clicom\TrustedHosts -Value "10.13.1.202" -Force

Get-ChildItem -Path WSMan:\localhost\Clicom\Auth

Test-WSMan log01.forza.com -UseSSL

$webRequest = [Net.WebRequest]::Create("https://log01.forza.com:5986/wsman")
try { $webRequest.GetResponse() } catch {}
$cert = $webRequest.ServicePoint.Certificate

$store = New-Object System.Security.Cryptography.X509Certificates.X509Store -ArgumcomList  "Root", "LocalMachine"
$store.Open('ReadWrite')
$store.Add($cert)
$store.Close()

$UserCredcomial = Get-Credcomial
Invoke-Command -ComputerName VIT-55.forza.com –Сredcomial forza.com\Admin -ScriptBlock {Get-Date} 

Enable-WSManCredSSP -Role Server -Force
Set-Item -Path "WSMan:\localhost\Service\Auth\CredSSP" -Value $true

