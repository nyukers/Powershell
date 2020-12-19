Configuration AddFile {

    param (
    [Parameter(Mandatory=$true)]
    [string[]]$ComputerName 
    )

Import-DscResource –ModuleName "PSDesiredStateConfiguration"

    Node $ComputerName { 
        File TestFile { 
            Ensure = 'Present'
            Type = 'File'
            DestinationPath = 'C:\TestFolder\TestFile1.txt'
            Contents = 'My first Configuration'
            Force = $true
                      }
                  }
}
AddFile -OutputPath c:\VM\shared\PS\DSC -ComputerName 'GOVERLA01','GOVERLA'

Test-DscConfiguration -ComputerName GOVERLA -verbose `
-ReferenceConfiguration c:\VM\shared\PS\DSC\MOF\GOVERLA.mof |
Format-List

Start-DscConfiguration -ComputerName GOVERLA -Path c:\VM\shared\PS\DSC\MOF -Wait -Verbose


Get-Job -IncludeChildJob

Get-DscConfiguration -CimSession GOVERLA | 
Format-Table PSComputerName, ConfigurationName, Ensure, Type -AutoSize

Invoke-Command -ComputerName GOVERLA -ScriptBlock {
Get-Content -Path c:\testfolder\testfile1.txt
}

#check current configuration
$cs = New-CimSession -ComputerName GOVERLA
Get-DscConfiguration -CimSession $cs

Remove-CimSession -CimSession $cs


Test-Path -Path \\GOVERLA\C$\TestFolder\TestFile1.txt