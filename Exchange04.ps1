$User = read-host -Prompt "Введите имя пользователя"

$user_dn = (get-mailbox $user).distinguishedname

"Пользователь " + $User + " входит в следующие группы рассылок:"

foreach ($group in get-distributiongroup -resultsize unlimited){

if ((get-distributiongroupmember $group.idcomity | select -expand distinguishedname) -contains $user_dn){$group.name}

}