On Error Resume Next

' Call Powershell
Set objShell = CreateObject("Wscript.Shell")
Status = objShell.Exec("powershell.exe -Nologo -ExecutionPolicy Bypass ľNoprofile -Windowstyle Hidden -File PSver.ps1").StdOut.ReadAll()
Echo Status
