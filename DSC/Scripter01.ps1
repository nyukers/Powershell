Configuration ScriptTest {

param (
    [Parameter(Mandatory=$true)]
    [string[]]$ComputerName 
    )

Import-DscResource -ModuleName 'PSDesiredStateConfiguration'

    Node $ComputerName 
    {
        Script ScriptExample
        {
            #1: check if Testfile.txt exist
            TestScript = { Test-Path "C:\TempFolder\TestFile.txt" }

            #2: create Testfile.txt if not exist before
            SetScript = {
                $sw = New-Object System.IO.StreamWriter("C:\TempFolder\TestFile.txt")
                $sw.WriteLine("Some sample string")
                $sw.Close()
            }
            
            #3: return content of Testfile.txt
            GetScript = { @{ Result = (Get-Content C:\TempFolder\TestFile.txt) } }
        }
    }
}

ScriptTest -OutputPath c:\VM\shared\PS\DSC\MOF -ComputerName 'GOVERLA'

# Check MOF-file
Test-DscConfiguration -ComputerName GOVERLA -verbose `
-ReferenceConfiguration c:\VM\shared\PS\DSC\MOF\GOVERLA.mof | Format-List

Test-DscConfiguration -Verbose

# Apply MOF-file to host GOVERLA
Start-DscConfiguration -ComputerName GOVERLA -Path c:\VM\shared\PS\DSC\MOF -Force -Verbose

# Get applied configuration on host GOVERLA 
Get-DscConfiguration | Format-Table ConfigurationName, Ensure, Type -AutoSize
Get-DscLocalConfigurationManager -Verbose


Get-Host