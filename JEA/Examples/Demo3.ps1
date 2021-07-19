cls

configuration Demo3
{
    Import-DscResource -module xJEA

    xJeaToolKit FileSystem
    {
        Name = 'FileSystem'
            CommandSpecs = @"
Module,name,Parameter,ValidateSet,ValidatePattern
,Get-ChildItem
,Get-Content
,Get-Item
,Copy-Item
,Move-Item
,Rename-Item
,Remove-Item
,Copy-ItemProperty
,Clear-ItemProperty
,Move-ItemProperty
,New-ItemProperty
,Remove-ItemProperty
,Rename-ItemProperty
,Set-ItemProperty
,Get-Location
,Pop-Location
,Push-Location
,Set-Location
,Convert-Path
,Join-Path
,Resolve-Path
,Split-Path
,Test-Path
,Get-PSDrive
,New-PSDrive
,out-file
"@
        Ensure = 'Present'        
    }
    
    xJeaEndPoint Demo3EP
    {
        Name      = 'Demo3EP'
        ToolKit   = 'FileSystem'
        Ensure    = 'Present'
        DependsOn = '[xJeaToolKit]FileSystem'
    }
}

Demo3 -OutputPath C:\JeaDemo

Start-DscConfiguration -Path C:\JeaDemo -ComputerName localhost -Verbose -wait -debug -ErrorAction SilentlyContinue -ErrorVariable errors
if($errors | ? FullyQualifiedErrorId -ne 'HRESULT 0x803381fa')
{
    $errors | Write-Error      
}

start-sleep -Seconds 30 #Wait for WINRM to restart

# This endpoint allows you to navigate the filesystem but not see the CONTENTS
# of any of the files

$s = New-PSSession -cn . -ConfigurationName Demo3EP
Invoke-command $s {dir 'C:\JeaDemo\Activity\ActivityLog.csv'} 
Invoke-Command $s {get-content 'C:\JeaDemo\Activity\ActivityLog.csv'}
# Enter-pssession $s

Remove-PSSession $s
#EOF