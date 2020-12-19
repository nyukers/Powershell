$Username = "Sturkiv.VO"


$Pdce = (Get-AdDomain).PDCEmulator
$GweParams = @{
	"Computername" = $Pdce
	"LogName" = "Security"
    "MaxEvcoms" = 1
	"FilterXPath" = "*[System[EvcomID=4624] and EvcomData[Data[@Name='TargetUserName']='$Username']]"
	}

$Evcoms = Get-WinEvcom @GweParams
$Evcoms | ForEach-Object {'Acct ' + $Username + ' has been blocked by: '+ $_.Properties[1].value + ' at: ' + $_.TimeCreated}

#$Evcoms | select -expand message