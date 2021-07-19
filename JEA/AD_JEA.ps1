# 1. C:\Program Files\WindowsPowerShell\Modules\xJea\0.2.16.6\Examples\SetupJEA.ps1.

Configuration SetupJea
    {
      Import-DscResource -module xjea Node localhost
      {
        xJeaEndPoint CleanAll
        {
          Name     = 'CleanALL'
          CleanAll = $true
        }
        LocalConfigurationManager
        {
          RefreshFrequencyMins = 30
          ConfigurationMode    = "ApplyAndAutoCorrect"
          DebugMode            = "ForceModuleImport"  
          #This disables provider caching
        }
      }
    }
    SetupJea -OutputPath C:\JeaDemo
    Set-DscLocalConfigurationManager -Path C:\JeaDemo -Verbose
    Start-DscConfiguration -Path c:\JeaDemo -Wait -Verbose
#EOF
 	 
# 2. JEA поставляется с тремя демонстрационными настройками конечных точек, которыми можно пользоваться в качестве руководства для создания некой конечной точки. 
# Эти демонстрационные файлы расположены в C:\ProgramFiles\WindowsPowerShell\Modules\xJea\0.2.16.6\Examples, а также Demo1.ps1, который содержит следующее:

cls configuration Demo1
{
  Import-DscResource -module xjea
  xJeaToolKit Process
  {
    Name         = 'Process'
    CommandSpecs = @"Name,Parameter,ValidateSet,ValidatePattern Get-Process Get-Service Stop-Process,Name,calc;notepad Restart-Service,Name,,^A"@
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

Start-DscConfiguration -Path C:\JeaDemo -ComputerName localhost -Verbose -wait -debug -ErrorAction SilentlyContinue -ErrorVariable errors
if($errors | ? FullyQualifiedErrorId -ne 'HRESULT 0x803381fa')
{
    $errors | Write-Error    
}

start-sleep -Seconds 30 #Wait for WINRM to restart

# 2.1.
$s = New-PSSession -cn . -ConfigurationName Demo1EP
Invoke-command $s {get-command} |out-string
Invoke-Command $s {get-command stop-process -Syntax}
# Enter-pssession $s
Remove-PSSession $s
#EOF 

# 3. Наш следующий этап состоит в полключении к новой конечной точке. 
# Это можно сделать при помощи такой команды:
Enter-PSSession –ComputerName localhost –ConfigurationName Demo1EP
Get-LocalUser 
Get-LocalGroupMember -Group "Administrators"


# 4. Настройки конечной точки Demo2.ps1 сосредоточены вокруг соответствующего администратора файлового сервера:

configuration Demo2
{
  Import-DscResource -module xjea

  xJeaToolKit SMBGet
  {
    Name = 'SMBGet'
    CommandSpecs = @"Module,Name,Parameter,ValidateSet,ValidatePattern SMBShare,get-* "@
  }
  xJeaEndPoint Demo2EP
  {
    Name = 'Demo2EP'
    Toolkit = 'SMBGet'
    SecurityDescriptorSddl = 'O:NSG:BAD:P(A;;GX;;;WD)S:P(AU;FA;GA;;;WD)(AU;SA;GXGW;;;WD)' 
    DependsOn = '[xJeaToolKit]SMBGet'
  }
}

Demo2 -OutputPath C:\JeaDemo
Start-DscConfiguration -Path C:\JeaDemo -ComputerName localhost -Verbose ` -wait -debug -ErrorAction SilentlyContinue -ErrorVariable errors
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

# 5. Demo3.ps1 предоставляет свою конечную точку для управления файловой системой и навигации по ней:

configuration Demo3
{
  Import-DscResource -module xjea

  xJeaToolKit FileSystem
  {
    Name = 'FileSystem'
    CommandSpecs = @"Module,name,Parameter,ValidateSet,ValidatePattern Get-ChildItem,Get-Item,Copy-Item,Move-Item,Rename-Item,Remove-Item,Copy-ItemProperty,Clear-ItemProperty,Move-ItemProperty,New-ItemProperty,Remove-ItemProperty,Rename-ItemProperty,Set-ItemProperty,Get-Location,Pop-Location,Push-Location,Set-Location,Convert-Path,Join-Path,Resolve-Path,Split-Path,Test-Path,Get-PSDrive,New-PSDrive, out-file "@
    Ensure = 'Present' 
  }
 
  xJeaEndPoint Demo3EP
  {
     Name = 'Demo3EP'
     ToolKit = 'FileSystem'
     Ensure = 'Present'
     DependsOn = '[xJeaToolKit]FileSystem'
  }
}

Demo3 -OutputPath C:\JeaDemo

Start-DscConfiguration -Path C:\JeaDemo -ComputerName localhost -Verbose ` -wait -debug -ErrorAction SilentlyContinue -ErrorVariable errors
if($errors | ? FullyQualifiedErrorId -ne 'HRESULT 0x803381fa')
{
 $errors | Write-Error 
}

start-sleep -Seconds 30 #Wait for WINRM to restart

# This endpoint allows you to navigate the filesystem but not see 
# the CONTENTS of any of the files
$s = New-PSSession -cn . -ConfigurationName Demo3EP
Invoke-command $s {dir 'C:\Program Files\Jea\Activity\ActivityLog.csv'} 
Invoke-Command $s {get-content 'C:\Program Files\Jea\Activity\ActivityLog.csv'}
# Enter-pssession $s

Remove-PSSession $s
#EOF