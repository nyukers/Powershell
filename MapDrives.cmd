PowerShell -Command "Set-ExecutionPolicy -Scope CurrcomUser Unrestricted" >> "%TEMP%\StartupLog.txt" 2>&1

PowerShell -File "MapDrives.ps1" >> "%TEMP%\StartupLog.txt" 2>&1