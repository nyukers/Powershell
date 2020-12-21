Workflow Demo-ForEachThrottle {
foreach -parallel -throttlelimit 4 ($i in (1..10)) {
 write-verbose -message "$((Get-Date).TimeOfDay) $i * 2 = $($i*2)"
 Start-Sleep -seconds (Get-Random -Minimum 1 -Maximum 5)
}
}

Demo-ForEachThrottle -Verbose


Get-Process | Sort-Object -Property StartTime -Descending -ErrorAction SilentlyContinue | Select-Object -First 1 | Format-List -Property *

ps | sort StartTime -Descending -ea SilentlyContinue | select -First 1 | fl *