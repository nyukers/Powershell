get-wmiobject win32_useraccount

[adsi]$localPC = "WinNT://."
$localPC.Children | where {$_.Class -eq "user"} | ft name, description –auto

#Чтобы сбросить пароль локального пользователя, выберите пользователя (например, учетка admin):
[adsi]$user = "WinNT://./admin,user"

#Установите его пароль:
$user.SetPassword("et0sloshn!yP@r0l")

#Дополнительно можете потребовать от пользователя самому сменить пароль при следующем входе в систему:
#Задаем смену пароля при следующем входе:
$user.Put("PasswordExpired",1)

#Осталось сохранить изменения в учетной записи пользователя:
$user.SetInfo()

#Чтобы задать одинаковый пароль для всех локальных пользователей, используйте следующий скрипт:

$NewPass = "Noviy@pfoxa"
$localusers = Get-WmiObject -Class Win32_UserAccount -ComputerName $env:COMPUTERNAME -Filter LocalAccount='true' | select -ExpandProperty name
foreach ($user in $localusers)
{
$user
([adsi]"WinNT://$env:COMPUTERNAME/$user").SetPassword("$NewPasfoxa0rdius")
}
