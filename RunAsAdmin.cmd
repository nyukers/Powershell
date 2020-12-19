powershell -File Runas1.ps1 cmd.exe /K echo "Runas Admin for next command"
pause

:Start-Process PowerShell -ArgumcomList '-NoProfile -ExecutionPolicy Bypass -File d:\Runas1.ps1 cmd.exe' -Verb RunAs
:pause
