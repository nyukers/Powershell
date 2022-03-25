# Книга рецептов автоматизации Windows Server при помощи PowerShell, 4е
# Glava 14

# 1)
Find-Module -Name PSScriptAnalyzer |
  Format-List Name, Type, Desc*, Author, Company*, *Date, *URI*

Get-Command -Module PSScriptAnalyzer

Get-ScriptAnalyzerRule | Select-Object -First 1 | Format-List

Get-ChildItem d:\PS\!!!\Bad.ps1

Invoke-ScriptAnalyzer -Path d:\PS\!!!\Bad.ps1 | Sort-Object -Property Line

$Script1 = @'
function foo {"hello!"
Get-ChildItem -Path D:\PS\!!!
}
'@
		

$Settings = @{
  IncludeRules = @("PSPlaceOpenBrace", "PSUseConsistentIndentation")
  Rules = @{
    PSPlaceOpenBrace = @{
      Enable = $true
      OnSameLine = $true
    }
    PSUseConsistentIndentation = @{
      Enable = $true
    }
  }
}

Invoke-Formatter -ScriptDefinition $Script1 -Settings $Settings

$Settings.Rules.PSPlaceOpenBrace.OnSameLine = $False
Invoke-Formatter -ScriptDefinition $Script1 -Settings $Settings

# 2) BPA
Get-Module -Name BestPractices -List
Get-Command -Module BestPractices | Format-Table -AutoSize
Get-BPAModel  | Format-Table -Property Name,Id, LastScanTime -AutoSize  
Invoke-BpaModel -ModelID Microsoft/Windows/UpdateServices -Mode ALL | Format-Table -AutoSize

Get-BpaResult -ModelID Microsoft/Windows/UpdateServices  |
      Where-Object Resolution -ne $null|
        Format-List -Property Problem, Resolution


# 3)
# Общая теория состоит в том, что любая сетевая проблема заключается в DNS (пока вы не докажете обратное). Вы начинаете данный рецепт с получения полного доменного имени (FQDN), 
# fully qualifed domain name своего хоста и значения IP адреса его DNS сервера, а затем проверяете работает ли этот сервер DNS.
# Затем вы применяете сконфигурированный сервер DNS на предмет определения значений имён Контроллеров домена в своём домене и убеждаетесь что способны достигать каждого Контроллера домена как по порту 389 (LDAP), так и по 445 (для GPO). 
# Затем вы проверяете доступность шлюза по умолчанию. Наконец, вы тестируете возможность достижения удалённого хоста по порту 80 (http) и по порту 443 (HTTP поверх SSL/ TLS).

# Получаем значение имени DNS данного хоста

$DNSDomain = $Env:USERDNSDOMAIN
$FQDN      = "$Env:COMPUTERNAME.$DNSDomain"
		
# Получаем значение адреса этого DNS сервера

$DNSHT = @{
  InterfaceAlias = "Ethernet"
  AddressFamily  = 'IPv4'
}
$DNSServers = (Get-DnsClientServerAddress @DNSHT).ServerAddresses
$DNSServers
		
# Убеждаемся в доступности этих DNS серверов

Foreach ($DNSServer in $DNSServers) {
  $TestDNS = Test-NetConnection -Port 53 -ComputerName $DNSServer   
  $Result  = $TestDNS ? "Available" : ' Not reachable'
  "DNS Server [$DNSServer] is $Result"
}
		
# Определяем поиск Контроллеров домена в нашем домене

$DNSRRName = "_ldap._tcp." + $DNSDomain
$DNSRRName
		
# Получаем записи SRV для выявленных Контроллеров домена

$DCRRS = Resolve-DnsName -Name $DNSRRName -Type all | 
    Where-Object IP4address -ne $null
$DCRRS
		
# Проверяем каждый из Контроллеров домена на доступность через LDAP

ForEach ($DNSRR in $DCRRS){
  $TestDC = Test-NetConnection -Port 389 -ComputerName $DNSRR.IPAddress
  $Result  = $TestDC ? 'DC Available' : 'DC Not reachable'
  "DC [$($DNSRR.Name)]  at [$($DNSRR.IPAddress)]   $Result for LDAP" 
}
		
# Проверяем доступность Контроллеров домена для SMB

ForEach ($DNSRR in $DCRRS){
  $TestDC = Test-NetConnection -Port 445 -ComputerName $DNSRR.IPAddress
  $Result  = $TestDC ? 'DC Available' : 'DC Not reachable'
  "DC [$($DNSRR.Name)]  at [$($DNSRR.IPAddress)]   $Result for SMB"
}
		
# Проверяем шлюз по умолчанию

$NIC    = Get-NetIPConfiguration -InterfaceAlias Ethernet
$DG     = $NIC.IPv4DefaultGateway.NextHop
$TestDG = Test-NetConnection $DG
$Result  = $TestDG.PingSucceeded ? "Reachable" : ' NOT Reachable'
"Default Gateway for [$($NIC.Interfacealias) is [$DG] - $Result"
		
# При помощи ICMP проверяем некоторый удалённый вебсайт
$Site = 'ua.energy'

$TestIP = Test-Connection -ComputerName $Site
$ResultIP    = $TestIP  ? 'Site Reachable' : 'Site NOT reachable'
"ICMP to $Site : $ResultIP"
		
# Тестируем удалённый вебсайт по порту 80

$TestPort80 = Test-Connection -ComputerName $Site -TcpPort 80
$Result80    = $TestPort80  ? 'Site Reachable' : 'Site NOT reachable'
"$Site over port 80   : $Result80"
		
# Тестируем удалённый вебсайт по порту 443

$TestPort443 = Test-Connection -ComputerName $Site -TcpPort 443
$Result443   = $TestPort443  ? 'Site Reachable' : 'Site NOT reachable'
"$Site over port 443  : $Result443"


# 4) Get-NeView
Find-Module -Name Get-NetView
Install-Module -Name Get-NetView -Force -AllowClobber
Get-Module -Name Get-NetView -ListAvailable
Import-Module -Name Get-NetView -Force
$OF = 'D:\Reports'
Get-NetView -OutputDirectory $OF


# 5) swicth to Powershell 7.2.1
Get-Alias ??

Get-PSSessionConfiguration
Enable-PSRemoting

Enter-PSSession -ConfigurationName powershell.7 -ComputerName localhost
