Function Test-TCPPort {
[cmdletbinding()]
Param (
[parameter(ValueFromPipeline=$True,
ValueFromPipelineByPropertyName=$True)]
[Alias("CN","Server","__Server","IPAddress")]
[string[]]$Computername = $env:COMPUTERNAME,
[parameter()]
[Int32[]]$Port = 23,
[parameter()]
[Int32]$TimeOut = 5000
)

Process {
ForEach ($Computer in $Computername) {
ForEach ($p in $port) {

Write-Verbose ("Checking port {0} on {1}" -f $p, $computer)

$tcpClient = New-Object System.Net.Sockets.TCPClient

$async = $tcpClient.BeginConnect($Computer,$p,$null,$null)

$wait = $async.AsyncWaitHandle.WaitOne($TimeOut,$false)

If (-Not $Wait) {
[pscustomobject]@{
Computername = $Computername
Port = $P
State = 'Closed'
Notes = 'Connection timed out'
}

} Else {

Try {
$tcpClient.EndConnect($async)
[pscustomobject]@{
Computername = $Computer
Port = $P
State = 'Open'
Notes = $Null
}

} Catch {
[pscustomobject]@{
Computername = $Computer
Port = $P
State = 'Closed'
Notes = ("{0}" -f $_.Exception.Message)
}
}
}
}
}
}
}

Test-TCPPort -Computername localhost -Port 7,21