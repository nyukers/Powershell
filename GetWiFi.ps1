netsh wlan show interfaces
netsh wlan show drivers

netsh wlan show network mode=bssid

$logs=@()
$date=Get-Date
$cmd=netsh wlan show networks mode=bssid
$n=$cmd.Count
For($i=0;$i -lt $n;$i++)
{
 
If($cmd[$i] -Match '^SSID[^:]+:.(.*)$')
 {
$ssid=$Matches[1]
$i++
$bool=$cmd[$i] -Match 'Тип[^:]+:.(.+)$'
$Type=$Matches[1]
$i++
$bool=$cmd[$i] -Match 'Проверка[^:]+:.(.+)$'
$authent=$Matches[1]
$i++
$bool=$cmd[$i] -Match 'Шифрование[^:]+:.(.+)$'
$chiffrement=$Matches[1]
#Write-Output $cmd[$i];
$i++

While($cmd[$i] -Match 'BSSID[^:]+:.(.+)$')
  {
$bssid=$Matches[1]
$i++
$bool=$cmd[$i] -Match 'Сигнал[^:]+:.(.+)$'
$signal=$Matches[1]
#Write-Output $cmd[$i];
$i++
$bool=$cmd[$i] -Match 'Тип[^:]+:.(.+)$'
$radio=$Matches[1]
$i++
$bool=$cmd[$i] -Match 'Канал[^:]+:.(.+)$'
$Channel=$Matches[1]
$i=$i+2
$logs+=[PSCustomObject]@{date=$date;ssid=$ssid;Authentication=$authent;Cipher=$chiffrement;bssid=$bssid;signal=$signal;radio=$radio;Channel=$Channel}
  }
 }
}

$cmd=$null
$logs|Out-GridView -Title 'Scan Wifi Script'