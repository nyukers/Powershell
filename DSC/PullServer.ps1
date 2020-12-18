configuration PullServer {
 
    Import-DSCResource -ModuleName PSDesiredStateConfiguration
 
    Node srvpull.test.lab {
 
        WindowsFeature DSCServiceFeature {
 
            Ensure = "Present"
            Name   = "DSC-Service"
 
        }
 
        xDscWebService PSDSCPullServer  {
 
            Ensure                  = "Present"
            EndpointName            = "DSCPullServer"
            Port                    = 8080
            PhysicalPath            = "$env:SystemDrive\inetpub\wwwroot\PSDSCPullServer"
            CertificateThumbPrint   = "AllowUnencryptedTraffic"
            ModulePath              = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules"
            ConfigurationPath       = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration"
            State                   = "Started"
            DependsOn               = "[WindowsFeature]DSCServiceFeature"
 
        }
 
        xDscWebService PSDSCComplianceServer {
 
            Ensure                  = "Present"
            EndpointName            = "DSCComplianceServer"
            Port                    = 8081
            PhysicalPath            = "$env:SystemDrive\inetpub\wwwroot\PSDSCComplianceServer"
            CertificateThumbPrint   = "AllowUnencryptedTraffic"
            State                   = "Started"
            IsComplianceServer      = $true
            DependsOn               = ("[WindowsFeature]DSCServiceFeature","[xDSCWebService]PSDSCPullServer")
 
        }
    }
}
 
 PullServer
