On Error Resume Next

winmgt = "winmgmts:{impersonationLevel=impersonate}!//"
Set oWMI_Query_Result = GetObject(winmgt).InstancesOf("Win32_OperatingSystem")

For Each oOS In oWMI_Query_Result
	iOSLoc = oOS.Locale
Next

Select Case iOSLoc
	Case "0409" iOSLang = "English"
	Case "0422" iOSLang = "Ukrainian"
	Case "0419" iOSLang = "Russian"
	Case Else   iOSLang = "Unknown"
End Select

Echo iOSLang
