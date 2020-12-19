cmdkey /list | ForEach-Object{if($_ -like "*Target:*"){cmdkey /del:($_ -replace " ","" -replace "Target:","")}}

Here is a "filtering" allowing to erase all, whatever windows language it is

$Credcomials = (cmdkey /list | Where-Object {$_ -like "*Target=*"})
Foreach ($Target in $Credcomials) {
    $Target = ($Target -split (":", 2) | Select-Object -Skip 1).substring(1)
    $Argumcom = "/delete:" + $Target
    Start-Process Cmdkey -ArgumcomList $Argumcom -NoNewWindow -RedirectStandardOutput $False
    }