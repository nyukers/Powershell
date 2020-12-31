workflow Get-LockedOut {

  Search-ADAccount -UsersOnly -LockedOut | sort LastLogonDate | Select Name,LastLogonDate,DistinguishedName | 
  Export-Csv "d:\AD\Monitoring!\LockedUsers.csv" -Encoding UTF8

 }
 
workflow Get-DisabledUsers {
 
  Search-ADAccount -UsersOnly -AccountDisabled | sort Name | Select Name,LastLogonDate,DistinguishedName | 
  Export-Csv "d:\AD\Monitoring!\DisabledUsers.csv" -Encoding UTF8

 }
 
workflow Get-DisabledUsers2OLD {

 Search-ADAccount -UsersOnly -AccountDisabled | Where {$_.DistinguishedName -notlike "*OU=OLD_Users,OU=OLD,DC=foxa,DC=forza,DC=com"} | 
 sort Name | Select Name,LastLogonDate,DistinguishedName | Export-Csv "d:\AD\Monitoring!\DisabledUsers2OLD.csv" -Encoding UTF8

 }

workflow Get-InactiveUsers30 {

  $t30 = New-Timespan –Days 30
  Search-ADAccount –UsersOnly –AccountInactive –TimeSpan $t30 | sort Name | Select Name,LastLogonDate,DistinguishedName | 
  Export-Csv "d:\AD\Monitoring!\InactiveUsers30a.csv" -Encoding UTF8
  
 }

workflow get-InactiveUsers365 {

  $t365 = New-Timespan –Days 365
  Search-ADAccount –UsersOnly –AccountInactive –TimeSpan $t365 | sort Name | Select Name,LastLogonDate,DistinguishedName | 
  Export-Csv "d:\AD\Monitoring!\InactiveUsers365a.csv" -Encoding UTF8
    
 }

workflow Get-InactiveUsersNoLogin {

Get-ADUser -filter {(Enabled -eq 'False') -and (lastlogondate -notlike '*')} -properties CN,Enabled,DistinguishedName | Select CN,Enabled,DistinguishedName `
| Export-Csv "d:\AD\Monitoring!\InactiveUsersNoLogin.csv" -Encoding UTF8

}
 
workflow get-ADReport {
  parallel {

  Get-LockedOut 
  Get-DisabledUsers 
  Get-DisabledUsers2OLD 
  Get-InactiveUsers30 
  get-InactiveUsers365
  Get-InactiveUsersNoLogin 
  
  }
}

Get-ADReport