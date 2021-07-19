#################################
# 1 move module xJEA manually

$env:PSModulePath
Find-Module –Name xJEA | fl
#Install-Module -Name xJea

#################################
# 2 without DSC

New-PSSessionConfigurationFile -Path 'C:\Install\JEA\dc_manage.pssc'
Test-PSSessionConfigurationFile -Path 'C:\Install\JEA\dc_manage.pssc'

New-PSRoleCapabilityFile -Path 'C:\Program Files\WindowsPowerShell\Modules\JEA\RoleCapabilities\Administration.psrc'

Register-PSSessionConfiguration –Name JEA-HelpDesk -Path 'C:\Install\JEA\dc_manage.pssc'
Restart-Service WinRM

UnRegister-PSSessionConfiguration –Name JEA-HelpDesk

Get-PSSessionConfiguration | ft name

#################################
# 3 check WinRM

winrm get winrm/config
winrm e winrm/config/listener

$httpResult = Invoke-Command -ComputerName "localhost" -ScriptBlock {$env:COMPUTERNAME} -ErrorVariable httpError -ErrorAction SilentlyContinue
$httpsOptions = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck
$httpsResult = New-PSSession -UseSSL -ComputerName "localhost" -SessionOption $httpsOptions -ErrorVariable httpsError -ErrorAction SilentlyContinue
If ($httpResult -and $httpsResult)
{
    Write-Host "HTTP: Enabled | HTTPS: Enabled"
}
ElseIf ($httpsResult -and !$httpResult)
{
    Write-Host "HTTP: Disabled | HTTPS: Enabled"
}
ElseIf ($httpResult -and !$httpsResult)
{
    Write-Host "HTTP: Enabled | HTTPS: Disabled"
}
Else
{
    Write-host "Unable to establish an HTTP or HTTPS remoting session."
}
