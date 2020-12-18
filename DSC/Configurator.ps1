Start-DscConfiguration
Start-DscConfiguration -Path 'D:\Reports' -Wait -Verbose

Get-DscConfiguration

Get-DscResource

###
Get-DscLocalConfigurationManager

Get-WmiObject -Namespace "Root\Microsoft\Windows\DesiredStateConfiguration" -List

###
# Import-DSCResource –ModuleName PSDesiredStateConfiguration 
# Import-DscResource -ModuleName PSDscResources

Configuration LocalConfigurationManager
{
    Node "localhost"
    {
        LocalConfigurationManager
        {
	        ConfigurationMode = "ApplyOnly"
            ConfigurationModeFrequencyMins = 45
            DownloadManagerName = "WebDownloadManager"
            RefreshMode = "Pull"
            RefreshFrequencyMins = 90
            RebootNodeIfNeeded = $false
            AllowModuleOverwrite = $false
        }
    }
}

LocalConfigurationManager -OutputPath "D:\Reports"

Set-DscLocalConfigurationManager -Path "D:\Reports"