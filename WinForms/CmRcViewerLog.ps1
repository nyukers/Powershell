while (1 -eq 1) 
{
$Computername = read-host "Enter Computername or IP" 
$logpath = "D:\CmRcViewerSessions.log" 

if ($Computername -ne $null)
 {
  & "D:\Program Files\Microsoft Configuration Manager\AdminConsole\bin\i386\CmRcViewer.exe" $Computername
  $date = Get-Date 
  Out-File -Filepath $logpath -InputObject "$date_$Computername" -Append 
 }

}
