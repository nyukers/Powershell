On Error Resume Next

Set objSysInfo = CreateObject("ADSystemInfo")
Set objUser = GetObject("LDAP://" & objSysInfo.UserName)
Set objComputer = GetObject("LDAP://" & objSysInfo.ComputerName)

 
WScript.Echo "User Principal Name: " & objUser.userPrincipalName
WScript.Echo "SAM Account Name: " & objUser.sAMAccountName
WScript.Echo "User Workstations: " & objUser.userWorkstations

