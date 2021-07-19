cls
configuration Demo2
{
    Import-DscResource -module xJEA

    xJeaToolKit SMBGet
    {
        Name         = 'SMBGet'
        CommandSpecs = @"
Module,Name,Parameter,ValidateSet,ValidatePattern
SMBShare,get-*
"@
    }
    xJeaEndPoint Demo2EP
    {
        Name                   = 'Demo2EP'
        Toolkit                = 'SMBGet'
        SecurityDescriptorSddl = 'O:NSG:BAD:P(A;;GX;;;WD)S:P(AU;FA;GA;;;WD)(AU;SA;GXGW;;;WD)'                                  
        DependsOn              = '[xJeaToolKit]SMBGet'
    }



}

Demo2 -OutputPath C:\JeaDemo

Start-DscConfiguration -Path C:\JeaDemo -ComputerName localhost -Verbose -wait -debug -ErrorAction SilentlyContinue -ErrorVariable errors

if($errors | ? FullyQualifiedErrorId -ne 'HRESULT 0x803381fa')
{
    $errors | Write-Error      
}

start-sleep -Seconds 30 #Wait for WINRM to restart

$s = New-PSSession -cn . -ConfigurationName Demo2EP
Invoke-command $s {get-command} |out-string
# Enter-pssession $s

Remove-PSSession $s
#EOF