On Error Resume Next

Dim dt

dt=now
'output format: yyyymmddHHnn
'Echo ((year(dt)*100 + month(dt))*100 + day(dt))*10000 + hour(dt)*100 + minute(dt)
Echo dt