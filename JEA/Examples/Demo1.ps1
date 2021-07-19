cls

configuration Demo1
{
    Import-DscResource -module xJEA

    xJeaToolKit Process
    {
        Name         = 'Process'
        CommandSpecs = @"
Name,Parameter,ValidateSet,ValidatePattern
Get-ChildItem
Get-Content
Get-Process
Get-Service
Stop-Process,Name,calc;notepad
Restart-Service,Name,,^A
"@
    }
    xJeaEndPoint Demo1EP
    {
        Name                   = 'Demo1EP'
        Toolkit                = 'Process'
        SecurityDescriptorSddl = 'O:NSG:BAD:P(A;;GX;;;WD)S:P(AU;FA;GA;;;WD)(AU;SA;GXGW;;;WD)'                                  
        DependsOn              = '[xJeaToolKit]Process'
    }
}

Demo1 -OutputPath C:\JeaDemo

Start-DscConfiguration -Path C:\JeaDemo -ComputerName localhost -Verbose -Force -debug -ErrorAction SilentlyContinue -ErrorVariable errors

if($errors | ? FullyQualifiedErrorId -ne 'HRESULT 0x803381fa')
{
    $errors | Write-Error      
}

start-sleep -Seconds 30 #Wait for WINRM to restart

Get-PSSessionConfiguration | Where {($_.Name -like "Demo*")} | fl 
Get-LocalUser

Update-DscConfiguration
Get-DscConfiguration
$winrm = Get-Service WinRM

$s = New-PSSession -cn . -ConfigurationName Demo1EP
Invoke-command $s {get-command} | out-string
Invoke-Command $s {get-command stop-process -Syntax}
Invoke-command $s {dir 'C:\JeaDemo\Activity\ActivityLog.csv'} 
Invoke-Command $s {get-content 'C:\JeaDemo\Activity\ActivityLog.csv'}
# Enter-pssession $s

Remove-PSSession $s
Get-PSSession
#EOF
