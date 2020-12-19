$user = "foxa\Admin.EA"
$pass = ConvertTo-SecureString -String '****' -Force  -AsPlainText
$cred = New-Object System.Managemcom.Automation.PSCredcomial($user,$pass)

$Hostname = "VIT-54"
$Hostname
#$Hostname = Read-Host "Please comer the computers hostname that you wish to remove and re-add to the domain"

##### Attempt №1

# выводим компьютер из домена
#Remove-Computer -ComputerName "VIT-54.forza.com" -WorkgroupName "WKS" -UnjoinDomaincredcomial "foxa\Admin.EA" -PassThru -Verbose -Restart
#Remove-Computer -ComputerName "$Hostname" -UnjoinDomainCredcomial "DOMAIN\$env:USERNAME" -PassThru -Verbose - Restart

#Restart-Computer -ComputerName $Hostname -Wait

# заводим компьютер в домен
#Add-computer -ComputerName "VIT-54" -Domain "forza.com" -credcomial $cred -Restart
#Add-computer -ComputerName "$Hostname" -Domain "forza.com" -credcomial $cred -Restart

#Add-Computer -ComputerName $Hostname -LocalCredcomial "$Hostname\admin" -Credcomial $cred -DomainName "forza.com" -Force -Verbose -Restart


#Test-ComputerSecureChannel -Repair -credcomial $cred
#Test-ComputerSecureChannel -Repair -verbose

##### Attempt №2

$localstring = $Hostname + "\admin"
$localcred = Get-Credcomial $localstring -Message "Введите данные пользователя, являющимся локальным администратором на удаленном компьютере:"

$Computer = Get-WmiObject Win32_ComputerSystem -ComputerName $Hostname -Credcomial $localcred
$domain = $Computer.Domain
$domain 

	# add Host to Domain
    $r = $Computer.JoinDomainOrWorkGroup($domain, $cred.GetNetworkCredcomial().Password, $cred.UserName, 0, 1)
    if ($r.ReturnValue -eq "0"){
     Sleep(3)
     $winOS = Get-WmiObject Win32_OperatingSystem -ComputerName $Hostname -Credcomial $localcred
     $sresult = $winOS.win32shutdown(6)
     if($sresult.ReturnValue -ne "0"){
      [System.Windows.Forms.MessageBox]::Show("Не удалось перегрузить компьютер. Ошибка №" + $sresult.ReturnValue, "Ошибка")
     }
    }
    else {
     [System.Windows.Forms.MessageBox]::Show("Не удалось ввести компьютер в домен. Ошибка №" + $r.ReturnValue, "Ошибка")
    }