$cs = New-CimSession -ComputerName GOVERLA
Get-DscLocalConfigurationManager -CimSession $cs

Remove-CimSession -CimSession $cs

[DSCLocalConfigurationManager()]
    Configuration LCM {
    Param (
        [Parameter(Mandatory=$true)]
        [string[]]$ComputerName
    )
    Node $Computername
    {
    Settings
    {
        ConfigurationMode = 'ApplyAndAutoCorrect'
        RebootNodeIfNeeded = $false
    }
    }
}

LCM -computername GOVERLA -OutputPath .\MOF

Set-DscLocalConfigurationManager -CimSession $cs -Path .\MOF\ -Verbose

Get-DscLocalConfigurationManager -CimSession $cs | select ConfigurationMode, RefreshMode, RefreshFrequencyMins, RebootNodeIfNeeded | fl