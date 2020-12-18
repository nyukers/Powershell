#requires -version 2.0

#find GPOs with extra registry, ie non-ADM settings

Function Test-GPOExtraRegistry {

Param (
[Parameter(Position=0,ValueFromPipeline=$True,
ValueFromPipelinebyPropertyName=$True)]
[string]$DisplayName
)

Begin {
    #import the GroupPolicy Module
    Import-Module GroupPolicy
}

Process {
#create an XML report
[xml]$report=Get-GPOReport -Name $displayname -ReportType XML
#define the XML namespace
$ns=@{q3="http://www.microsoft.com/GroupPolicy/Settings/Registry"}
$nodes=Select-Xml -Xml $report -Namespace $ns -XPath "//q3:RegistrySetting" | 
select -expand Node | Where {$_.AdmSetting -eq 'false'}

if ($nodes) {
  #extra settings were found so get the GPO and write it to the pipeline
  Get-GPO -Name $Displayname
}

}

End {}

} #function

Import-Module GroupPolicy
Get-GPO -all | Test-GPOExtraRegistry 