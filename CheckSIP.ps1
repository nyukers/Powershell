Get-ADUser -Filter "Name -like 'Іщенко*'" -property name, msRTCSIP-PrimaryUserAddress | select name, msRTCSIP-PrimaryUserAddress | sort name 

Get-ADUser -Filter "msRTCSIP-PrimaryUserAddress -notlike '*'" -property name, msRTCSIP-PrimaryUserAddress | select name, msRTCSIP-PrimaryUserAddress | sort name | Export-Csv "d:\NoSkype.csv" -Encoding UTF8

