# INTERNET PROXY
$profile
[System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials

Register-PSRepository -Default
Register-PSRepository -Default -Name 'PSGallery' –SourceLocation 'https://www.powershellgallery.com/api/v2/' -Proxy 'https://clust01.forza.com:9090'
Get-PSRepository

Find-Module -Name xPSDesiredStateConfiguration

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Verbose -Force

Save-Module -Name xPSDesiredStateConfiguration -Path D:\Reports

# NO INTERNET
$env:PSModulePath

# Copy files from D:\Reports to PSModulePath

Get-Module -ListAvailable

# NET 5.1
$PSVersionTable.PSVersion
Windows8.1-KB2883200-x64.msu
Windows8.1-KB2894029-x64.msu
Windows8.1-KB2894179-x64.msu
Windows8.1-KB2919355-x64.msu
Win8.1AndW2K12R2-KB3191564-x64.msu

Get-Module -ListAvailable

# WinRM start up
winrm quickconfig
Enable-PSRemoting -Force
Set-Item WSMan:\localhost\Client\TrustedHosts -Value *
Get-Item WSMan:\localhost\Client\TrustedHosts

Get-ExecutionPolicy
