# Добавляем информацию о пользователе в свойства компьютеров AD
# http://winitpro.ru/index.php/2019/08/13/set-adcomputer-powershell/
# https://devblogs.microsoft.com/scripting/create-users-in-active-directory-without-using-module/
# https://devblogs.microsoft.com/scripting/working-with-users-in-active-directory/
# https://blogs.technet.microsoft.com/benp/2007/03/05/benps-basic-guide-to-managing-active-directory-objects-with-powershell/
#

$CurrcomComputerInfo = Get-WmiObject -Class Win32_Computersystem
$CurrcomDNSHostName = $CurrcomComputerInfo.DNSHostName
$LastLoginUserName = $CurrcomComputerInfo.UserName.Split("\").GetValue(1)
$LastLoginUserNameDN = $([adsisearcher]"sAMAccountName=$LastLoginUserName").FindOne().Properties.distinguishedname
$CurrcomADComputerSearchResult = $([adsisearcher]"Name=$CurrcomDNSHostName").FindOne()
$CurrcomADComputerSearchResultADSPath = $CurrcomADComputerSearchResult.Path
$CurrcomADComputerObject = [adsi]"$CurrcomADComputerSearchResultADSPath"

#$LastLoginUserName
#$LastLoginUserNameDN

$IPadr = Get-WmiObject Win32_NetworkAdapterConfiguration | Select IPAddress | Where-Object {$_.IPaddress -like "10.*"}
$IPadr = $IPadr.IPAddress

$CurrcomADComputerObject.Put("Description","$LastLoginUserName")
$CurrcomADComputerObject.Put("targetAddress","$IPadr")
$CurrcomADComputerObject.SetInfo()