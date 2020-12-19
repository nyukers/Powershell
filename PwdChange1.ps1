$userAD = 'Maxima'
$newpfoxa = '1234ty678'

Set-ADAccountPassword $userAD -NewPassword (ConvertTo-SecureString -AsPlainText -String $newpfoxa -force)

#Set-ADUser -Idcomity $userAD -ChangePasswordAtLogon $false
Get-ADUser -Filter "SamAccountName -like 'Ftykok*'" -Properties * | `
Select SamAccountName,Name,DistinguishedName,UserPrincipalName,DisplayName,CN,sn,Surname,GivenName | fl


$Date = (Get-Date).AddDays(-10065)
$Users = Get-ADUser -Filter {PasswordLastSet -LT $Date} -Properties PasswordLastSet

forEach ($us in $Users)
{ 
	Set-ADAccountPassword $us -NewPassword (ConvertTo-SecureString -AsPlainText -String $newpfoxa -force)
}

Get-ADUser -Filter "SamAccountName -like 'Levi*'" -Properties * | `
Select Name, SamAccountName, Enabled, LastLogonDate, passwordlastset, Passwordneverexpires 