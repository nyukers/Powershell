 param (
    $User,
    $PDC = "SGfoxa-DC01",
    $Count = 5
 ) 

$Username = "Opiruk.GG"

    $FilterHash = @{}
    $FilterHash.LogName = "Security"
    $FilterHash.ID = "4740"
    if ($User) {
        $FilterHash.data =$User
        $Count = 1
    }
    
    $FilterHash2 = @{}
    $FilterHash2.LogName = "Security"
    $FilterHash2.ID = "4740"
    #$FilterHash2.ID = @("4625", "4740", "4771")

    Get-WinEvcom -Computername $PDC -FilterHashtable $FilterHash -MaxEvcoms $Count | ForEach-Object {
        $ResultHash = @{} 
        $ResultHash.Username = ([xml]$_.ToXml()).Evcom.EvcomData.Data | ? {$_.Name -eq "TargetUserName"} | %{$_."#text"}
        $ResultHash.CallerFrom = ([xml]$_.ToXml()).Evcom.EvcomData.Data | ? {$_.Name -eq "TargetDomainName"} | %{$_."#text"}
        $ResultHash.LockTime = $_.TimeCreated

        $FilterHash2.data = $Username
        Get-WinEvcom -Computername $PDC -FilterHashtable $FilterHash2 -MaxEvcoms $Count | ForEach-Object {
            $ResultHash.SrcAdrHost = ([xml]$_.ToXml()).Evcom.EvcomData.Data | ? {$_.Name -eq "IpAddress"} | %{$_."#text"}
            $ResultHash.LogonType = ([xml]$_.ToXml()).Evcom.EvcomData.Data | ? {$_.Name -eq "LogonType"} | %{$_."#text"}
            $ResultHash.FalureTime = $_.TimeCreated
            $ResultHash 
        }
    }
 
 