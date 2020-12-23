# It's take MOF-file only

$ConfigurationData=@{ 
    AllNodes = @(

    @{
        NodeName = 'GOVERLA'
        Role = @('Web', 'PullServer')
        CertThumbPrint = Invoke-Command -Computername 'GOVERLA' -ScriptBlock {
        Get-Childitem -Path Cert:\LocalMachine\My |
        where Subject -Like 'CN=GOVERLA*' |
        Select-Object -ExpandProperty ThumbPrint}
    }
  );
}

Configuration Pullserver {

Import-DscResource -ModuleName PSDesiredStateConfiguration
Import-DscResource -ModuleName xPSDesiredStateConfiguration
Import-DscResource -ModuleName xWebAdministration

Node $AllNodes.where{$_.Role -eq 'Web'}.NodeName { 
WindowsFeature IIS {

Ensure = "Present"
Name = "Web-Server"
}

WindowsFeature NetExtens4 { 
Ensure = "Present"
Name = "Web-Net-Ext45"
DependsOn = '[WindowsFeature]IIS'
}

WindowsFeature AspNet45 {
Ensure = "Present"
Name = "Web-Asp-Net45"
DependsOn = '[WindowsFeature]IIS'
}

WindowsFeature ISAPIExt {
Ensure = "Present"
Name = "Web-ISAPI-Ext"
DependsOn = '[WindowsFeature]IIS'
}

WindowsFeature ISAPIFilter {
Ensure = "Present"
Name = "Web-ISAPI-filter"
DependsOn = '[WindowsFeature]IIS'
}

WindowsFeature DirectoryBrowsing { 
Ensure = "Absent"
Name = "Web-Dir-Browsing"
DependsOn = '[WindowsFeature]IIS'
}

WindowsFeature StaticCompression {
Ensure = "Absent"
Name = "Web-Stat-Compression"
DependsOn = '[WindowsFeature]IIS'
}

WindowsFeature Management { 
Name = 'Web-Mgmt-Service'
Ensure = 'Present'
DependsOn = @('[WindowsFeature]IIS')
}

Registry RemoteManagement {
Key = 'HKLM:\SOFTWARE\Microsoft\WebManagement\Server' 
ValueName = 'EnableRemoteManagement'
ValueType = 'Dword'
ValueData = '1'
DependsOn = @('[WindowsFeature]IIS','[WindowsFeature]Management')
}

Service StartWMSVC {
Name = 'WMSVC'
StartupType = 'Automatic'
State = 'Running'
DependsOn = '[Registry]RemoteManagement'
}

xWebsite DefaultSite {
Name = "Default Web Site"
State = "Started"
PhysicalPath = "C:\inetpub\wwwroot"
DependsOn = "[WindowsFeature]IIS"
}
}

Node $AllNodes.where{$_.Role -eq 'PullServer'}.NodeName { 
WindowsFeature DSCServiceFeature {
Ensure = "Present"
Name = "DSC-Service"
}

xDscWebService DSCPullServer {
Ensure = "Present"
EndpointName = "PullServer"
Port = 8080
PhysicalPath = "$env:SystemDrive\inetpub\wwwroot\PullServer"
CertificateThumbPrint = $Node.CertThumbprint
ModulePath = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules"
ConfigurationPath = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration"
State = "Started"
UseSecurityBestPractices = $false
DependsOn = "[WindowsFeature]DSCServiceFeature"
}

xDscWebService DSCComplianceServer {
Ensure = "Present"
EndpointName = "ComplianceServer"
Port = 9080
PhysicalPath = "$env:SystemDrive\inetpub\wwwroot\ComplianceServer"
CertificateThumbPrint = "AllowUnencryptedTraffic"
State = "Started"
UseSecurityBestPractices = $false
DependsOn = ("[WindowsFeature]DSCServiceFeature","[xDSCWebService]DSCPullServer")
}
}
}

Pullserver -ConfigurationData $ConfigurationData -outputPath .\MOF
