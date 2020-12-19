Get-ADUser -Filter "SamAccountName -like 'Kuchera*'" -Properties * | `
Select SamAccountName,Name,DistinguishedName,UserPrincipalName,DisplayName,CN,sn,Surname,GivenName | fl

Get-ADUser -Filter "SamAccountName -like 'Kuchera*'" -Properties * | Format-List *Pass*
Get-ADUser -Filter "SamAccountName -like 'Kuchera*'" -Properties * | Format-List *Logon*