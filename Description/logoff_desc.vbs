On Error Resume Next
Set objSysInfo = CreateObject("ADSystemInfo")
Set objUser = GetObject("LDAP://" & objSysInfo.UserName)
Set objComputer = GetObject("LDAP://" & objSysInfo.ComputerName)
dim NIC1
Set NIC1 = GetObject("winmgmts:").InstancesOf("Win32_NetworkAdapterConfiguration")
For Each Nic in NIC1
if Nic.IPEnabled then
StrIP = Nic.IPAddress(i)
StrMAC = Nic.MACAddress(i)
'WScript.Echo StrIP&StrMAC&i
Exit For
end if
next

objComputer.Description =  "Out:" + objUser.sAMAccountName + "/" + cstr(now)+ "/" + StrIP + "/" + StrMAC
objUser.Description = "Out:" + objComputer.CN + "/" + cstr(now)+ "/" + StrIP + "/" + StrMAC

objComputer.SetInfo
objUser.SetInfo

