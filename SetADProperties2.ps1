Get-ADComputer VIT-50 -properties *|select-object dNSHostName,operatingSystem,company,departmcom, description|ft -wrap -auto

$curhostname=$env:computername
$env:HostIP = (
Get-NetIPConfiguration |
Where-Object {
$_.IPv4DefaultGateway -ne $null -and
$_.NetAdapter.Status -ne "Disconnected"
}
).IPv4Address.IPAddress
#$currus_cn=(get-aduser $env:UserName -properties *).DistinguishedName
$currus_cn=(get-aduser $env:UserName -properties *).SamAccountName
$ADComp = Get-ADComputer -Idcomity $curhostname -properties *
$env:HostIP
$currus_cn
$ADComp | fl

#$ADComp.ManagedBy = $currus_cn
$ADComp.Description = $currus_cn
$ADComp.targetAddress = $env:HostIP
Set-ADComputer -Instance $ADComp
