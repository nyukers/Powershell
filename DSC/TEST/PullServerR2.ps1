#############################################
# SECTION 1
# Create the Pull Server. 

# SECTION 2
# Create my Host Configuration

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
Start-DscConfiguration -Path 'C:\CreatePullServer' -Wait -Verbose

Test-DscConfiguration -Verbose

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
        DestinationPath = 'C:\TestFolder\TestFile111.txt'
        Contents = 'Radisson Impreza'
        Force = $true
        }
    }
}

# Generate the .MOF files
AddFile -ComputerName 'WS310155'

# Create a Checksum for the file listed above
$Guid = New-Guid | Select-Object -ExpandProperty Guid
$SourceMof = 'C:\Users\Username\AddFile\WS310155.mof'
$DestinationMof = 'C:\Program Files\WindowsPowerShell\DscService\Configuration\'+$Guid+'.mof'
Copy-Item $SourceMof $DestinationMof
New-DscChecksum $DestinationMof


# Files
# .\exchangeservice\exch.mof
# .\exchangeservice\exch.mof.cheksum
# copy to
# C:\Program files\WindowsPowershell\DscService\Configuration

# Check it as IIS work properly
# http://log01.forza.com:8080/PSDSCPullServer.svc/
