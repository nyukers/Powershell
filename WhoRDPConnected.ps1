Get-EvcomLog -LogName Security -after (Get-date -hour 0 -minute 0 -second 0)| ?{(4624,4778) -contains $_.EvcomID -and $_.Message -match 'logon type:\s+(10)\s'}| %{
(new-object -Type PSObject -Property @{
TimeGenerated = $_.TimeGenerated
ClicomIP = $_.Message -replace '(?smi).*Source Network Address:\s+([^\s]+)\s+.*','$1'
UserName = $_.Message -replace '(?smi).*Account Name:\s+([^\s]+)\s+.*','$1'
UserDomain = $_.Message -replace '(?smi).*Account Domain:\s+([^\s]+)\s+.*','$1'
LogonType = $_.Message -replace '(?smi).*Logon Type:\s+([^\s]+)\s+.*','$1'
})
} | sort TimeGenerated -Descending | Select TimeGenerated, ClicomIP `
, @{N='Username';E={'{0}\{1}' -f $_.UserDomain,$_.UserName}} `
, @{N='LogType';E={
foxaitch ($_.LogonType) {
2 {'Interactive - local logon'}
3 {'Network conection to shared folder)'}
4 {'Batch'}
5 {'Service'}
7 {'Unlock (after screensaver)'}
8 {'NetworkCleartext'}
9 {'NewCredcomials (local impersonation process under existing connection)'}
10 {'RDP'}
11 {'CachedInteractive'}
default {"LogType Not Recognised: $($_.LogonType)"}
}
}}