Configuration DeleteFile {

 param (
    [Parameter(Mandatory=$true)]
    [string[]]$ComputerName 
    )

Import-DscResource –ModuleName "PSDesiredStateConfiguration"

    Node $ComputerName {
        File TestFile {
            Ensure = 'Absent' 
            Type = 'File'
            DestinationPath = 'C:\TestFolder\TestFile1.txt'
            Force = $true
    }

        File TestFolder {
            Ensure = 'Absent' 
            Type = 'Directory'
            DestinationPath = 'C:\TestFolder'
            Force = $true
            DependsOn = '[File]TestFile' 
    }
}
}

DeleteFile -OutputPath c:\VM\shared\PS\DSC\MOF -ComputerName 'GOVERLA'

# Check MOF-file
Test-DscConfiguration -ComputerName GOVERLA -verbose `
-ReferenceConfiguration c:\VM\shared\PS\DSC\MOF\GOVERLA.mof |
Format-List

# Get applied configuration on host GOVERLA 
Get-DscConfiguration | Format-Table ConfigurationName, Ensure, Type -AutoSize
Get-DscLocalConfigurationManager -Verbose

# Apply MOF-file to host GOVERLA
Start-DscConfiguration -ComputerName GOVERLA -Path c:\VM\shared\PS\DSC\MOF -Wait -Verbose

