Configuration SetLCMPullMode {
    param([string]$ComputerName,
          [guid]$Guid
    )
    
    Node $ComputerName {
        LocalConfigurationManager {
            ConfigurationID                    = $Guid
            DownloadManagerName                = 'WebDownloadManager'
            RefreshMode                        = 'Pull' 
            RebootNodeIfNeeded                 = $true
            RefreshFrequencyMins               = 30
            ConfigurationModeFrequencyMins     = 45
            ConfigurationMode                  = 'ApplyAndAutoCorrect'
            DownloadManagerCustomData = @{
                ServerUrl                      = 'http://log01.forza.com:8080/PSDSCPullServer.svc' 
                AllowUnsecureConnection        = $true
            }
        }
    }
}

#Create the .MOF meta file for the target node
SetLCMPullMode -ComputerName WKS015155 -Guid 070f92f2-3d04-4fbf-ad44-a37051c267c4

#We're essenially turning on pull mode on the target
Set-DscLocalConfigurationManager -Path .\SetLCMPullMode -Verbose

#Forcefully pull update dsc configuration and apply it, check the status
Update-DscConfiguration -Wait -Verbose

Get-DSCLocalConfigurationManager -Verbose
Get-DscConfigurationStatus

Test-DscConfiguration
