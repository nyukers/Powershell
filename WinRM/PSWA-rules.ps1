Install-WindowsFeature -Name WindowsPowerShellWebAccess -IncludeManagementTools

Install-PswaWebApplication -UseTestCertificate

#Add-PswaAuthorizationRule –UserGroupName forza-log01\Administrators -ComputerName forza-log01 -ConfigurationName Microsoft.PowerShell

Add-PswaAuthorizationRule –UserGroupName 'forza.com\DL-Srv-Local-Admins' -ComputerName forza-ep01 -ConfigurationName Microsoft.PowerShell
Add-PswaAuthorizationRule –UserGroupName 'forza.com\DL-Srv-Local-Admins' -ComputerName forza-log01 -ConfigurationName Microsoft.PowerShell


Add-PswaAuthorizationRule –UserGroupName 'forza.com\DL-Srv-Local-Admins' -ComputerGroupName 'forza.com\Infrastructure Servers' -ConfigurationName Microsoft.PowerShell

Add-PswaAuthorizationRule -UserName forza.com\MikeCrouly.EA -ComputerName * -ConfigurationName Microsoft.PowerShell

Test-PswaAuthorizationRule -UserName forza.com\MikeCrouly.EA-MSA -ComputerName forza-log01 -ConfigurationName Microsoft.PowerShell

Get-PswaAuthorizationRule 

Enable-PsRemoting

