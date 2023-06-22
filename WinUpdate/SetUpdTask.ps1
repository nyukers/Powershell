$cred = Get-Credential

Register-ScheduledTask -Xml (get-content 'C:\Script\WindowsAutoPatching.xml' | out-string) `
-TaskName "Weekly System AutoUpdate" -User ".\Administrator" -Password $cred –Force