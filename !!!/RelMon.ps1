$DaysAgo = (Get-Date).AddDays(-3)
$RealiabilityFilter= "TimeGenerated > '$DaysAgo' and (SourceName='Microsoft-Windows-WindowsUpdateClient' or SourceName='MsiInstaller')"
Get-CimInstance -ClassName Win32_ReliabilityRecords -filter $RealiabilityFilter|Select TimeGenerated,ProductName,User,message |Out-GridView