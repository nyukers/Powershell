#$OU = "OU=foxa,DC=foxa,DC=forza,DC=com"
#get-ADUser -SearchBase $OU -Filter {(EmailAddress -like '*')} -Properties EmailAddress | Select Name,EmailAddress,SamAccountName,Enabled | Sort Name | ft -hidetableheaders | out-file List2.txt -Encoding Oem

$OU = "DC=foxa,DC=forza,DC=com"
(get-ADUser -SearchBase $OU -Filter {(EmailAddress -notlike '*')} -Properties EmailAddress | Select Name,EmailAddress,SamAccountName,Enabled | Sort Name).count