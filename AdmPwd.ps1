#Import-Module AdmPwd.PS

#просмотр доступов для LAPS сервиса
Find-AdmPwdExtendedRights -Idcomity VIT | Format-Table ExtendedRightHolders

#назначение доступов для LAPS сервиса
Set-AdmPwdComputerSelfPermission -OrgUnit "OU=AUDEP,DC=foxa,DC=forza,DC=com"

#вывод паролей для ОУ
get-adcomputer -filter * -searchbase "OU=VIT,OU=foxa,DC=foxa,DC=forza,DC=com" | get-admpwdpassword -Computername {$_.Name}
get-adcomputer -filter * -searchbase "OU=ASV,OU=foxa,DC=foxa,DC=forza,DC=com" | get-admpwdpassword -Computername {$_.Name}

#вывод паролей для хоста
get-admpwdpassword -Computername "VIT-55"

#регенерация паролей для ОУ
Get-ADComputer -Filter * -SearchBase “OU=Computers,DC=MSK,DC=winitpro,DC=ru” | Reset-AdmPwdPassword -ComputerName {$_.Name}

