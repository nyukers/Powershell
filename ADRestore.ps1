#Import-Module ActiveDirectory
Get-ADOptionalFeature 'Recycle Bin Feature'
Get-ADObject -SearchScope subtree -SearchBase “cn=Deleted Objects,dc=foxa,dc=forza,dc=com” -includeDeletedObjects -filter { name -like "test-comp*" }`
| Restore-ADObject 