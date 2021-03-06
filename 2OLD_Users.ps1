# Cписок работников, из CSV разделенного  ";" & перемещаем в ОУ OLD_Users работников 
#
# Формат входного файла UTF-8:
# Name;
# User PIB1;
# User PIB2

# Import-module ActiveDirectory
$count = 0
$mcount = 0

$users = Import-Csv -Encoding UTF8 -path "d:\Quartly!\2OLD_Users.csv" -Delimiter ";" 

foreach($user in $users){
 #$user.name
 $user_object = "Name -like '" + $user.name + "'"
 #$user_object  
 $user_object = Get-ADUser -Server 192.168.1.20 -Filter $user_object 
 #$user_object
 
 $count = $count + 1
 
 # проверяем, может этот пользователь уже в ОУ "старые пользователи", если не находится, то перемещаем его туда
 if ($user_object.DistinguishedName -NotLike "*OU=OLD_Users,OU=OLD,DC=forza,DC=com"){
   
  Move-ADObject -Identity $user_object -TargetPath "OU=OLD_Users,OU=OLD,DC=forza,DC=com"
  $mcount = $mcount + 1
  $user_object.DistinguishedName + " has been moved."
  }

}

"Total:"
"Запланованих користувачів - " + $count
"Переміщенних користувачів в OLD_Users - " + $mcount
