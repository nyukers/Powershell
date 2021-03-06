#############################################
# SECTION 3
# Execute my code on the Target Host
#############################################

# Get all the DSC CMDLets
Get-Command -Noun dsc*

# Get Available Resources
# Refer to powershellgallery.com for additional resources
Get-DscResource

# What can we configure for each resource
Get-DscResource File | Select -ExpandProperty Properties

#############################################
# Step 1

# Generate a LCM Config for target node
# Target Node LCM Configuration

Configuration LCMConfig {
    # Parameters
  Param([string[]]$ComputerName = "localhost")
    # Target Node
    Node $ComputerName {
      # LCM Resource
      LocalConfigurationManager {
        ConfigurationMode = "ApplyAndAutoCorrect"
        ConfigurationModeFrequencyMins = 30
        }
      }
   }

   # Generate MOF File
   LCMConfig -ComputerName EXCH

   # Check LCM Settings on target node
   Get-DscLocalConfigurationManager -CimSession EXCH 

   # Apply the LCMConfig for each Target Node
   Set-DscLocalConfigurationManager -Path LCMConfig

   # Check the LCM Config again
   # Notice the CoConfigurationModeFrequencyMins value changed to 30
   Get-DscLocalConfigurationManager -CimSession EXCH


#############################################
# Step 2


# Your Configuration
Configuration ExchangeService {

    # Parameters
    # Accepts a string value computername or defaults to localhost
    Param([string[]]$ComputerName = "localhost")

    # Target Node
    Node $ComputerName {

        # Service Resource
        # Ensure a service is started
        Service MSExchangeTransport {
            Name = 'MSExchangeTransport'
            State = 'Running'
        }
    }
}

# Generate the .MOF files
ExchangeService -ComputerName EXCH

# MOF files are created in whatever directory you're in the PS Console
# 1 MOF file per target node

# Apply the configuration
Start-DscConfiguration -path ExchangeService -Wait -Verbose -Force

# View Deployed Configurations
Get-DscConfiguration -CimSession EXCH

#Testing Config (detect drift)
Test-DscConfiguration -CimSession EXCH
