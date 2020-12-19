#Search-ADAccount -UsersOnly –searchbase "OU=foxa,DC=foxa,DC=forza,DC=com"

#(Get-ADUser –searchbase "OU=VDD,OU=foxa,DC=foxa,DC=forza,DC=com" -Filter *).SamAccountName

#Get-ADComputer –searchbase "OU=VZ,OU=foxa,DC=foxa,DC=forza,DC=com" -Filter * -Properties * | Sort Name | FT Name, LastLogonDate -Autosize

#Get-ADComputer -Idcomity VIT-50
#Get-AComputer -Filter {Name -like "*anc*"}

#Get-ADUser -Filter {SamAccountName -like "zabbix*"}

(Get-ADUser -Filter {SamAccountName -like "*"}).count

