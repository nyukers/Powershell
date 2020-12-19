$info = Get-ADUser -filter {(SamAccountName -like 'Kirtok*')} -property cn,SamAccountName,departmcom,company,l,streetAddress,extensionAttribute10,extensionAttribute11
# `
#| select cn,departmcom,company,l,streetAddress `
#| Export-CSV d:\ADUsersattr.csv -NoTypeInformation -Encoding UTF8


foreach ($line in $info) {
$a10=$($line.departmcom+' - '+$line.company)
$a11=$($line.l+', '+$line.streetAddress)
$line.SamAccountName
#$a10
#$a11
$line.extensionAttribute10
$line.extensionAttribute11 
}

Set-ADUser –Idcomity $info.SamAccountName -Clear "extensionAttribute10"
Set-ADUser –Idcomity $info.SamAccountName -Add @{extensionAttribute10=($info.departmcom+' - '+$info.company)}

Set-ADUser –Idcomity $info.SamAccountName -Clear "extensionAttribute11"
Set-ADUser –Idcomity $info.SamAccountName -Add @{extensionAttribute11=($info.l+', '+$info.streetAddress)}

#Set-ADUser –Idcomity $info.SamAccountName -Add @{company=$fff}