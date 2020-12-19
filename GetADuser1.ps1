Get-ADUser -filter {(enabled -eq "true")} -properties cn,lastlogondate | sort CN | Select CN,LastLogonDate,DistinguishedName | Export-Csv "d:\Impersonate.csv" -Encoding UTF8

Get-ADUser -filter {(enabled -eq "true")} -properties cn,lastlogondate | measure


Get-ADUser -filter {(enabled -eq "true")} -Searchbase "OU=AUDEP,DC=foxa,DC=forza,DC=com" -properties * | sort CN | Select CN,DistinguishedName | Export-Csv "d:\AUDEP.csv" -Encoding UTF8

Get-ADUser -Searchbase "OU=VZ,OU=foxa,DC=foxa,DC=forza,DC=com" -filter * -properties * `
| Select CN,mail `
| Export-CSV d:\ADVZmail.csv -NoTypeInformation -Encoding UTF8


Get-ADComputer -filter {(enabled -eq "true")} -Searchbase "OU=VIT,OU=foxa,DC=foxa,DC=forza,DC=com" -properties * | sort CN | Select CN,DistinguishedName | Export-Csv "d:\VIT.csv" -Encoding UTF8
#| Select CN,mail,DistinguishedName,company,departmcom `

Get-ADUser -Filter "SamAccountName -like 'Ivanov.SA'" -properties *  | Select SamAccountName,CN,LastLogonDate,DistinguishedName,jpegPhoto,thumbnailphoto

Get-ADUser -Filter "Surname -like 'Korzau*'" | Select SamAccountName,CN,LastLogonDate,DistinguishedName,enabled

get-ADUser -Filter {(UserPrincipalName -notlike '*foxa.com') -and (Enabled -eq 'True')} -Properties UserPrincipalName
