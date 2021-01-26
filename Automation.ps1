# Automating Pull mode
# https://www.red-gate.com/simple-talk/sysadmin/powershell/powershell-desired-state-configuration-automating-and-monitoring-pull-mode/

# We saw in the previous chapter the steps required to publish these files:

# 1)Create a DSC configuration
# 2)Generate the MOF files
# 3)Create the “Checksum” files
# 4)Finally, copy all files to the pull server

# This article is aimed at being as generic as possible for all readers, so I have chosen to detail the first method which seems to me accessible to everyone. For this, I have automated the deployment process of a MOF file with the following script. This is pretty basic and is divided into four sections:

# PART1: Contains parameters that will be passed to the script: the filename and path of the CSV file, what to do (create, add, or publish) and finally the name of the node.
# PART2: Contains the DSC configuration to be applied to the node.
# PART3: Contains the “Create / Add / Publish” functions used in the following section.
# PART4: Contains the available actions that the user indicates via the script parameter. It can create the CSV file, update it or publish the DSC configuration on the node.

# $GUID = [GUID]::Empty
# $GUID = [GUID]::NewGuid()
# -OR-
# $GUID = [GUID]("17034f9a-a7fe-4779-986a-0ce9d0303116")
# $GUID = [GUID]::NewGuid().ToString()
# $GUID
 

#### PART 1 -Script parameters ####
param(
       [string] $FileName = "DSC-Nodes.csv",                         
       [string] $FilePath = "C:\Temp",
       [Parameter(Mandatory=$true)][string] $Action = "",
       [string] $Node = ""
)
 
#### PART 2 - DSC Configuration ####
Configuration DeployHostFile {
    Param(
        [Parameter(Mandatory=$True)]
        [String[]]$NodeGUID
    )
    
    Node $NodeGUID {
 
        File CopyHostFile
        {
        Ensure = "Present"
        Type = "File"
        SourcePath = $SourceFile
        DestinationPath = $DestinationFile
        }
    }
}
 
#### PART 3 - Functions ####
Function CreateCSVFile {
Param ([string] $FileName = "DSC-Nodes.csv",[string] $FilePath = "C:\Temp")
 
    New-Item -Type file -Name $FileName $FilePath
    "name,guid" | Add-Content -Path $FilePath\$FileName -PassThru
    Write-Host "$FilePath\$FileName created!" -ForegroundColor Green
}
 
Function AddContentToCSVFile {
Param (      
       [string] $Node = "",                         
       [string] $GUID = "",
       [string] $CSVFile = "C:\Temp\DSC-Nodes.csv"
     )
 
"$Node,$GUID" | Add-Content -Path $CSVFile -PassThru
}
 
Function PublishMOFFiles {
Param ([Parameter(Mandatory=$true)][string] $Node = "",[string]$CSVFile = "C:\Temp\DSC-Nodes.csv")
 
    Write-Host "Checking node = GUID and creating MOF File in C:\" -ForegroundColor Cyan
        
    $guidImportCSV = Import-Csv $CSVFile
    $Obj = New-Object PSObject
    ForEach ($guidImport in $guidImportCSV)
    {
        Write-host $guidImport.Name  -ForegroundColor Cyan
        $Obj | Add-Member -Name Name -MemberType NoteProperty -Value $guidImport.Name
        $Obj | Add-Member -Name GUID -MemberType NoteProperty -Value $guidImport.Guid
    }
    $NodeGuid = ($obj | Where-Object { $_.Name -match $Node }).guid
    DeployHostFile -NodeGUID $NodeGuid
    Set-Location .\DeployHostFile
 
    Write-Host "Creating checksums..." -ForegroundColor Cyan
    New-DSCCheckSum -ConfigurationPath . -OutPath . -Verbose -Force
 
    Write-Host "Copying configurations to pull server..." -ForegroundColor Cyan
    $SourceFiles = ".\*.mof*"
    $TargetFiles = "C:\Program Files\WindowsPowershell\DscService\Configuration"
    Move-Item $SourceFiles $TargetFiles -Force
}
 
#### PART 4 - List of available actions ####
switch ($Action) 
    { 
        Create  {CreateCSVFile -FileName $FileName -FilePath $FilePath} 
        Add     {AddContentToCSVFile -Node $Node -GUID ([guid]::NewGuid()) -CSVFile "$FilePath\$FileName"} 
        Publish {PublishMOFFiles -Node $Node} 
        default {Write-Host "The action could not be determined." -ForegroundColor Red}
    }
