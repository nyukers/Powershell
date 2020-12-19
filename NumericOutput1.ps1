$lastday = ((Get-Date).AddDays(-365))
$global:i=0
Get-ADUser -filter {(lastlogondate -notlike '*') -and (whencreated -ge $lastday)} -properties cn,whencreated,lastlogondate,DistinguishedName | sort CN `
| Select @{Name="#";Expression={$global:i++;$global:i.Tostring()}},CN,WhenCreated,LastLogonDate,DistinguishedName

#OR
$global:i=0
Get-Service | where {$_.Status -eq "Running" } | Select @{Name="#";Expression={$global:i++;$global:i.Tostring() + ">"}},Status,Name,Displayname 
$global:i=0

#OR
$a=1;
Get-service |ForEach-Object {"$($a). $($_.name)"; $a++} 