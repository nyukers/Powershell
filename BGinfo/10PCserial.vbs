On Error Resume Next

' Call Powershell
Set objShell = CreateObject("Wscript.Shell")
Status = objShell.Exec("powershell.exe -Nologo -ExecutionPolicy Bypass ľNoprofile -Windowstyle Hidden -File PCSerial.ps1").StdOut.ReadAll()
Echo Status
