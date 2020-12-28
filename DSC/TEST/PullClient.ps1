Configuration LCMPullConfig 
{ 
    LocalConfigurationManager 
    { 
        ConfigurationID = "VSUDO50"; 
        RefreshMode = "PULL";
        DownloadManagerName = "WebDownloadManager";
        RebootNodeIfNeeded = $false;
        RefreshFrequencyMins = 60;
        ConfigurationModeFrequencyMins = 30; 
        ConfigurationMode = "ApplyAndAutoCorrect";
        DownloadManagerCustomData = @{
        ServerUrl = "http://Puller.forza.com:8080/PSDSCPullServer/PSDSCPullServer.svc"; 
        AllowUnsecureConnection = "TRUE"}
    } 
} 

# Create the .mof meta file for the target node
LCMPullConfig -OutputPath "D:\Reports"

# We're essentially turning on Pull Mode on the Target
Set-DSCLocalConfigurationManager -Computer localhost -Path "D:\Reports" -Verbose

Get-DscLocalConfigurationManager