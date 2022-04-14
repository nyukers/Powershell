$RemoteServers = "WSORK22","IT-007"
$Ports = "135","445"

foreach ($RemoteServer in $RemoteServers)
{
    foreach ($port in $ports)
    {
        $test = New-Object System.Net.Sockets.TcpClient
    Try
    {
        $test.Connect($RemoteServer, $Port);
        Write-host "[$RemoteServer][$port] Connection successful" -ForegroundColor Green
    }
    Catch
    {
        Write-host "[$RemoteServer][$port] Connection failed" -ForegroundColor Red
    }
    $test.Close()
    }
}