Get-ADUser -filter {(Enabled -eq 'True')} -property CN,SamAccountName | Select CN,SamAccountName | measure

Get-ADUser -filter {(Enabled -eq 'True')} -property CN,SamAccountName,MemberOf | Sort CN | Select CN,SamAccountName |Export-Csv "d:\Forzaadmin.csv" -Encoding UTF8

Get-ADUser -Filter "SamAccountName -like 'Oval*'" -property CN,SamAccountName,MemberOf | fl

