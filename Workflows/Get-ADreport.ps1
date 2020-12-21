workflow get-disabled {

  Search-ADAccount -AccountDisabled | Select-Object -Property DistinguishedName |
  Export-Csv -Path d:\Reports\DisabledAccounts.csv -NoTypeInformation -Encoding UTF8

 }
 
workflow get-expired {

  Search-ADAccount -AccountExpired | Select-Object -Property DistinguishedName |
  Export-Csv -Path d:\Reports\ExpiredAccounts.csv -NoTypeInformation -Encoding UTF8

 }
 
workflow get-passwordneverexpire {

  Search-ADAccount -PasswordNeverExpires | Select-Object -Property DistinguishedName | 
  Export-Csv -Path d:\Reports\PsswdNeverExpireAccounts.csv -NoTypeInformation -Encoding UTF8

 }
 
workflow get-ADReport {
  parallel {
    get-disabled
    get-expired
    get-passwordneverexpire
  }
}

Get-ADReport