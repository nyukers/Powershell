On Error Resume Next

Dim o
Set o = CreateObject("MSXML2.XMLHTTP")
o.open "GET", "http://ifconfig.me/ip", False
o.send

Echo o.responseText
