$a = Get-NetAdapter -Physical | where Status -eq "Up" | select Name,InterfaceDescription,LinkSpeed

if (($a.Name -like "Wi-Fi*") -or ($a.Name -like "Беспроводная*")) {
    # It's a Wi-Fi interface
    $b = (get-netconnectionProfile).Name 
    $c = (netsh wlan show interfaces) -Match '^\s+Channel' -Replace '^\s+Channel\s+:\s+',''
    $a.Name+': ' + $b +', ch:' + $c +', max:'+$a.LinkSpeed
    }
else {
    # It's an Ethernet interface
    $a.Name+': '+$a.LinkSpeed
}

#$a.Name+': ' + $b +', Ch #' + $C +', '+$a.LinkSpeed
#$a = Get-NetAdapter -Physical | where Status -eq "Disconnected" | select Name,InterfaceDescription,LinkSpeed
