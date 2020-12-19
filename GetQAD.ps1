#Add-PSSnapin Quest.ActiveRoles.ADManagemcom
#get-command *qad*


Get-ADUser Admin.EA -properties * | ft
Get-QADUser Oval* -properties * | fl 

Get-QADObject 'cn=users,dc=forza,dc=com' -SecurityMask Dacl | Get-QADPermission -Inherited -SchemaDefault