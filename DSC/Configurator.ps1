Start-DscConfiguration
Start-DscConfiguration -Path 'D:\Reports' -Wait -Verbose

Get-DscConfiguration

Get-Command -Noun dsc*
Get-DscResource  -Name Script | fl

Import-DSCResource -ModuleName PSDesiredStateConfiguration
Import-DSCResource -ModuleName xPSDesiredStateConfiguration
#Import-DSCResource -ModuleName @{ModuleName=”xPSDesiredStateConfiguration”;ModuleVersion=”6.0.0.0″}

Get-Module -ListAvailable | measure

# NoGo
Get-Command -Module xPSDesiredStateConfiguration

# NoGo
xService | Get-Member

# Shows all DSC Resources currently installed in PS ModulePath
# Access PSModulepath 
# cd env:
# dir | Where-Object Name -eq PSModulePath
Get-DscResource 

# Get all the DSC Resources in the xPSDesiredStateConfiguration Module
Get-DscResource -Module xPSDesiredStateConfiguration

# How to view the properties of DSC Resources
Get-DscResource -Name xService | Select-Object -ExpandProperty Properties



###
Get-DscLocalConfigurationManager

Get-WmiObject -Namespace "Root\Microsoft\Windows\DesiredStateConfiguration" -List

###
# Import-DSCResource –ModuleName PSDesiredStateConfiguration 
# Import-DscResource -ModuleName PSDscResources

Configuration LCMPullConfig 
{ 
    LocalConfigurationManager 
    { 
        ConfigurationID = "WVIT-50N"; 
        RefreshMode = "PULL";
        DownloadManagerName = "WebDownloadManager";
        RebootNodeIfNeeded = $false;
        RefreshFrequencyMins = 60;
        ConfigurationModeFrequencyMins = 30; 
        ConfigurationMode = "ApplyAndAutoCorrect";
        DownloadManagerCustomData = @{
        ServerUrl = "http://servername:8080/PSDSCPullServer/PSDSCPullServer.svc"; 
        AllowUnsecureConnection = "TRUE"}
    } 
} 

# Create the .mof meta file for the target node
LCMPullConfig -OutputPath "D:\Reports"

# We're essentially turning on Pull Mode on the Target
Set-DSCLocalConfigurationManager -Computer localhost -Path "D:\Reports" -Verbose

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
