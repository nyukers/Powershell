Get-ADObject -Filter 'objectcategory -eq "person" -and objectclass -eq "user" -and -not useraccountcontrol -Band 2 -and pwdlastset -eq 0 -and objectsid -notlike "-501"'


$Date = (Get-Date).AddDays(-1065)
$Users = Get-ADUser -Filter {PasswordLastSet -LT $Date} -Properties PasswordLastSet
$Users | Sort Name | ft Name, SamAccountName, Enabled, LastLogonDate, passwordlastset, Passwordneverexpires 