Configuration stdShare {
    param
    (
    [Parameter(Mandatory=$true)]
    [string[]]$ComputerName
    )

Import-DscResource -ModuleName PSDesiredStateConfiguration 
#Import-DscResource -ModuleName xSmbShare

Node $ComputerName {
    File TestFolder { 
        Ensure = 'Present'
        Type = 'Directory'
        DestinationPath = 'C:\TestFolder'
        Force = $true
}

File TestFile { 
    Ensure = 'Present'
    Type = 'File'
    DestinationPath = 'C:\TestFolder\TestFile1.txt'
    Contents = 'My first Configuration'
    Force = $true
}

<#
xSmbShare StandardShare 
{
    Ensure = "Present"
    Name = "Standard"
    Path = 'C:\TestFolder'
    Description = "This is a test SMB Share"
    ConcurrentUserLimit = 0
}
#>
}
}

stdShare -ComputerName GUEST01 -OutputPath .\MOF