###
Import-Module ActiveDirectory

[string]$dnsRoot = (Get-ADDomain).DNSRoot

[string[]]$Partitions = (Get-ADRootDSE).namingContexts

$contextType = [System.DirectoryServices.ActiveDirectory.DirectoryContextType]::Domain

$context = new-object System.DirectoryServices.ActiveDirectory.DirectoryContext($contextType,$dnsRoot)

$domainController = [System.DirectoryServices.ActiveDirectory.DomainController]::findOne($context)

ForEach($partition in $partitions)
    {

    $domainControllerMetadata = $domainController.GetReplicationMetadata($partition)

    $dsaSignature = $domainControllerMetadata.Item('dsaSignature')

    Write-Host "$partition was backed up $($dsaSignature.LastOriginatingChangeTime.DateTime)'n"

    }


###

[reflection.assembly]::loadwithpartialname('System.Windows.Forms') | Out-Null

$openFile = New-Object System.Windows.Forms.OpenFileDialog
$openFile.Filter = 'txt files (*.txt)|*.txt|All files (*.*)|*.*'

If($openFile.ShowDialog() -eq [System.Windows.Forms.OpenFileDialog]::OK)
{get-content $openFile.FileName}

###
[reflection.assembly]::loadwithpartialname('System.Speech') | Out-Null

$SayIt = New-Object system.Speech.Synthesis.SpeechSynthesizer

$SayIt.Speak('.Net and PowerShell are cooler than cool')

###

Get-ScheduledTask -TaskName Recovery-Check | select TaskName,State,TaskPath | ? state -eq Disabled

###
$ScriptBlock = { if ($_.StartType -eq 'Automatic' -and $_.Status -eq 'Stopped') { Start-Service $_ } }
Get-Service | ForEach-Object -Process $ScriptBlock

#the same
Get-Service | ForEach-Object Name
Get-Service | foreach Name
Get-Service | % Name

Get-Process | ForEach-Object -Begin { [long]$WorkingSet = 0 } -Process { $WorkingSet += $_.WS } -End { $WorkingSet }
