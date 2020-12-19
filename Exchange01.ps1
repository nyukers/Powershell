#$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credcomial $UserCredcomial -Authcomication Basic -AllowRedirection

$UserCredcomial = Get-Credcomial

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://webmail.foxa.com/PowerShell/ -Authcomication Kerberos -Credcomial $UserCredcomial

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://webmail.foxa.com/powershell/ -Authcomication Basic -AllowRedirection -Credcomial $UserCredcomial


$uc=Get-Credcomial
$s=New-PSSession -ConfigurationName microsoft.exchange -ConnectionUri http://snec-exchmbx04.forza.com/powershell -Authcomication Kerberos -Credcomial $uc
Import-PSSession $s -DisableNameChecking | fl
