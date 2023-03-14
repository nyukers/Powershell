$a = Get-NetAdapter -Physical | where Status -eq "Up" | select InterfaceDescription, LinkSpeed
$a.InterfaceDescription+': '+$a.LinkSpeed

$b = $PSVersionTable.PSVersion.Major
$c = $PSVersionTable.PSVersion.Minor
[string]$b+'.'+[string]$c

(gcim Win32_OperatingSystem).LastBootUpTime

(gcim Win32_OperatingSystem).Locale