Get-ADUser -Filter {(Enabled -eq 'True') -and (PasswordNeverExpires -eq 'true')} -Properties * | Sort Name | Select Name,SamAccountName

Get-ADUser -Filter {(Enabled -eq 'True') -and (Name -like 'kr*') -and (PasswordNeverExpires -eq 'true')} -Properties * | Sort Name | Select Name

Get-ADUser -Filter "PasswordLastSet -notlike '*'" | Sort Name

Get-ADUser -Filter "SamAccountName -like 'chipi*'" -Properties * | fl

Get-ADUser -Filter "SamAccountName -like 'Bilo*'" -Properties * | `
Select SamAccountName,Name,DistinguishedName,UserPrincipalName,DisplayName,CN,sn,Surname,GivenName | fl



Get-ADComputer -Filter "name -like 'VNAT*'" -Properties * | Select Name,Description,IPv4Address,targetAddress,*Logondate*,WhenChanged | fl
