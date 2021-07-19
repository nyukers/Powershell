cls

configuration Demo4
{
Import-DscResource -module xJEA

	xJeaToolKit Process
   {
       Name = 'Process'
       CommandSpecs = @"       
Name,Parameter,ValidateSet,ValidatePattern
Get-Process
Get-Service
Stop-Process,Name,calc;notepad
Restart-Service,Name,,^A
"@
	    applications = "ipconfig"
#CommandSpecs = Get-Content "C:\Toolkit\tools.csv" –Delimiter "NoSuch"
   }
   
   xJeaEndPoint Demo4x
   {
       Name             = 'Demo4x'
       Toolkit          = 'Process'
       DependsOn        = '[xJeaToolKit]Process'
   }
}

Demo4 -OutputPath C:\JeaDemo

Start-DscConfiguration -Path C:\JeaDemo -ComputerName localhost -Verbose –force
