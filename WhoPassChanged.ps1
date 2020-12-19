# + включить аудит пользователей

(Get-ADComputer -SearchBase 'OU=Domain Controllers,DC=winitpro,DC=loc' -Filter *).Name | foreach {
Get-WinEvcom -ComputerName $_ -FilterHashtable @{LogName="Security";ID=4724 }| Foreach {
$evcom = [xml]$_.ToXml()
if($evcom)
{
$Time = Get-Date $_.TimeCreated -UFormat "%Y-%m-%d %H:%M:%S"
$AdmUser = $evcom.Evcom.EvcomData.Data[4]."#text"
$User = $evcom.Evcom.EvcomData.Data[0]."#text"
$dc = $evcom.Evcom.System.computer
write-host "Admin " $AdmUser " reset password to " $User " on " $dc " " $Time
}
}
}