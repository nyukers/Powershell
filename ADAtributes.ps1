Get-ADUser -filter * -property * | Export-CSV d:\ADUsers.csv -NoTypeInformation -Encoding UTF8
# ft -Wrap –Auto 

Get-ADUser -filter * -property name,extensionAttribute1,extensionAttribute2,extensionAttribute3,extensionAttribute10,extensionAttribute11 `
| select name,extensionAttribute1,extensionAttribute2,extensionAttribute3,extensionAttribute10,extensionAttribute11 `
| Export-CSV d:\ADUsersattr.csv -NoTypeInformation -Encoding UTF8

Search-ADAccount -UsersOnly -Searchbase "OU=OLD_Users,OU=foxa,DC=foxa,DC=forza,DC=com" 
Search-ADAccount -AccountDisabled -ComputersOnly | Format-Table *
Search-ADAccount –ComputersOnly –AccountInactive –TimeSpan $t | sort Name

$admpwd = Get-ADComputer -Filter {(Name -eq 'VIT-55')} -property name,ms-Mcs-AdmPwd,ms-Mcs-AdmPwdExpirationTime 
$admtime = $admpwd | select ms-Mcs-AdmPwdExpirationTime
$admtime = $([datetime]::FromFileTime([convert]::ToInt64($admtime.'ms-MCS-AdmPwdExpirationTime',10)))

Write-Host "Expired password date:"
$admtime 
$admpwd | select name,ms-Mcs-AdmPwd

Get-ADUser -Filter * -Property Company | sort name | select Name,Company | Export-Csv "d:\Commany.csv" -Encoding UTF8
Get-ADUser -Filter "UserPrincipalName -notlike '*foxa.com'" -Property * | select UserPrincipalName

Get-ADComputer -Filter {(Name -eq 'VIT-23')} -property name,operatingSystem,ms-MCS-AdmPwd | select Name,operatingSystem 

Get-ADComputer -Filter {(Description -like '*Imano*')} -Property Description | select Name,Description

Get-ADUser -Filter {(Description -like '*.3.32*')} -Property Description | select UserPrincipalName,Description

Get-ADComputer -Filter * -SearchBase "OU=OLD_PC,OU=OLD,DC=foxa,DC=forza,DC=com" | Get-AdmPwdPassword -ComputerName {$_.Name}

