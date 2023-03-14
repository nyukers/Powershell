$Myfolder = "c:\tmp"

(Get-ACL $MyFolder).Access  |
Select @{n="DisplayName"; e={([adsisearcher]"samaccountname=$($_.IdentityReference.Value.split("\")[1])").FindOne().Properties["displayname"]}}, 
IdentityReference, FilesystemRights | 
Export-Csv -Encoding "Unicode" -Path "c:\FolderRightsReport.csv" -Delimiter ";"

[system.enum]::getnames([System.Security.AccessControl.FileSystemRights])

(Get-ACL C:\tmp\).access