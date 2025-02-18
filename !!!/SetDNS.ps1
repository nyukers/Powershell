Get-DnsClientServerAddress -AddressFamily IPv4

$intV4 = 20 
$dns0 = '192.168.1.1'
$dns1 = '1.1.1.1'
$dns2 = '8.8.8.8'

Set-DnsClientServerAddress -InterfaceIndex $intV4 -ServerAddress ($dns0,$dns1,$dns2)