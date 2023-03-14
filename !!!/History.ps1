Set-PSReadlineOption -HistorySaveStyle SaveNothing 
Set-PSReadlineOption -HistorySaveStyle SaveIncrementally

Get-Command -Module PSReadLine
Import-Module PSReadLine

Set-PSReadlineOption -HistorySavePath C:\Users\Pixel\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\Windows23.txt
Set-PSReadlineOption -MaximumHistoryCount 4096

(Get-PSReadlineOption).HistorySavePath
dir
ls

# это назначение клавишам Вверх и Вниз функций клавиш F8 и Shift+F8.
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

Remove-Item (Get-PSReadlineOption).HistorySavePath

cat (Get-PSReadlineOption).HistorySavePath
Get-History 
Get-Host

Get-Module -ListAvailable | where {$_.name -like "*PSReadline*"}
Get-PSReadlineOption | select HistoryNoDuplicates, MaximumHistoryCount, HistorySearchCursorMovesToEnd, HistorySearchCaseSensitive, HistorySavePath, HistorySaveStyle
