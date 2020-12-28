#############################################
# SECTION 1
# Create the Pull Server. 

# SECTION 2
# Create my Host Configuration

# SECTION 3
# Execute my code on the Target Host
##############################################

# SECTION 1
# Execute this section on DSC Server 
# 1 time!!!
##############################################

# Step 1 Install xPSDesiredStateConfiguration
Install-Module -Name xPSDesiredStateConfiguration

# Step 2
# Create the Pull Server. 

Configuration CreatePullServer {
  param (
    [string[]]$ComputerName = 'localhost'
  )

  Import-DSCResource -ModuleName xPSDesiredStateConfiguration
  Import-DSCResource –ModuleName PSDesiredStateConfiguration

  Node $ComputerName {
    WindowsFeature DSCServiceFeature {
      Ensure = "Present"
      Name  = "DSC-Service"
    }

    xDscWebService PSDSCPullServer {
      Ensure         = "Present"
      UseSecurityBestPractices = 0
      EndpointName      = "PSDSCPullServer"
      Port          = 8080
      PhysicalPath      = "$env:SystemDrive\inetpub\wwwroot\PSDSCPullServer"
      CertificateThumbPrint  = "AllowUnencryptedTraffic"
      ModulePath       = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules"
      ConfigurationPath    = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration"
      State          = "Started"
      DependsOn        = "[WindowsFeature]DSCServiceFeature"
    }

  }

}

#Creates the .mof file
CreatePullServer


# Apply the Pull Server configuration to the Pull Server
Test-DscConfiguration -Verbose
Start-DscConfiguration -Path 'C:\CreatePullServer' -Wait -Verbose
Get-DscConfiguration

#############################################
# SECTION 2
# Execute this section on DSC Server!
#############################################

# Your Configuration
Configuration AddFile {
# Parameters, accepts a string value computername or defaults to localhost
    Param
    (
    [Parameter(Mandatory=$true)]
    [string[]]$ComputerName
    )

Import-DscResource –ModuleName PSDesiredStateConfiguration

    # Target Node
    Node $ComputerName {

        File TestFile {
        Ensure = 'Present'
        Type = 'File'
        DestinationPath = 'C:\TestFolder\TestFile1.txt'
        Contents = $Node.FileText 
        Force = $true
        }
    }
}

# Generate the .MOF files
 AddFile -ComputerName 'VSUDO50'
 
# Create a Checksum for the file listed above
 New-DscChecksum ".\AddFile\VSUDO50.mof"

# Files
# .\AddFile\VSUDO50.mof
# .\AddFile\VSUDO50.mof.cheksum
# copy to
# C:\Program files\WindowsPowershell\DscService\Configuration

#############################################
# SECTION 3
# Execute this section on the Target host!
# 1 time!!!
#############################################

# Run on the target node where:
# ServerName - it's hostname of DSC Server from SECTION 1
# "VSUDO50" - it's must be EQUAL to filename EXCH.mof from SECTION 2

Configuration LCMPullConfig 
{ 
    LocalConfigurationManager 
    { 
        ConfigurationID = "VSUDO50"; 
        RefreshMode = "PULL";
        DownloadManagerName = "WebDownloadManager";
        RebootNodeIfNeeded = $true;
        RefreshFrequencyMins = 30;
        ConfigurationModeFrequencyMins = 30; 
        ConfigurationMode = "ApplyAndAutoCorrect";
        DownloadManagerCustomData = @{
        ServerUrl = "http://puller.forza.com:8080/PSDSCPullServer/PSDSCPullServer.svc"; 
        AllowUnsecureConnection = "TRUE"}
    } 
} 

# Create the .mof meta file for the target node
LCMPullConfig

# We're essentially turning on Pull Mode on the Target
Set-DSCLocalConfigurationManager -Computer localhost -Path ./LCMPullConfig -Verbose

