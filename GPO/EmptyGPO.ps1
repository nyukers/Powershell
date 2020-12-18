#requires -version 2.0

#find empty gpos in the domain

Function Get-EmptyGPO {

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

 #totally empty
 if ((-Not $report.gpo.user.extensiondata) -AND (-not $report.gpo.computer.extensiondata)) {
    #no extension data so write
    Get-GPO -Name $Displayname
}

} #process

End {}

} #function

Function Test-EmptyGPO {

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

    #set default values
    $User=$False
    $Computer=$False
    #create an XML report
    [xml]$report=Get-GPOReport -Name $displayname -ReportType XML

    if ($report.gpo.user.extensiondata) {
     $User=$True
    }
    If ( $report.gpo.computer.extensiondata) {
     $Computer=$True
    }
    #write a custom object to the pipeline
    New-Object -TypeName PSObject -Property @{
    Displayname=$report.gpo.name
    UserData=$User
    ComputerData=$Computer
    }

} #Process

End {}

} #function

Get-GPO -All | Get-EmptyGPO
#Get-GPO -All | Test-EmptyGPO