$filterXml = @"
<QueryList>
  <Query Id="0" Path="Directory Service">
     <Select Path="Directory Service">*[System[(EvcomID=2041) and TimeCreated[timediff(@SystemTime) &lt;= 3600000]]]</Select>
  </Query>
</QueryList>
"@


$Pdce = (Get-AdDomain).PDCEmulator

$Evcoms = Get-WinEvcom –FilterXml $filterXml -ComputerName $Pdce -MaxEvcom 10

$global:i=0
$Evcoms | select @{Name="#";Expression={$global:i++;$global:i.Tostring()}},TimeCreated,ID,LogName,message | fl

$Evcoms | select TimeCreated,ID,LogName,message

<#
<Query Id="0" Path="Microsoft-Windows-Sysmon/Operational">
<Select Path="Microsoft-Windows-Sysmon/Operational">*[System[(EvcomID=2) and TimeCreated[timediff(@SystemTime) &lt;= 3600000]]]</Select>
<Select Path="Security">*[System[((EvcomID &gt;= 4624 and EvcomID &lt;= 4625)) and TimeCreated[timediff(@SystemTime) &lt;= 3600000]]]</Select>
    

    Critical System[(Level=1)]
    Error (Level=2)
    Warning (Level=3)
    Information (Level=4)
    Verbose (Level=5)
 #>