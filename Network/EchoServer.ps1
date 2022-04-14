[cmdletbinding()]
Param()
[console]::Title = "Echo Server"
$Listener = New-Object System.Net.Sockets.TcpListener -ArgumentList 7

#Get-NetTCPConnection -LocalPort 7

$Listener.Start()
Write-Verbose "Server started"

Get-NetTCPConnection | Where LocalPort -eq 7
$incomingClient.Client
#$incomingClient.Client.Dispose()

While ($True) {
    $incomingClient = $Listener.AcceptTcpClient()
    $remoteClient = $incomingClient.client.RemoteEndPoint.Address.IPAddressToString
    
    Write-Verbose ("New connection from {0}" -f $remoteClient)

    Start-Sleep -Milliseconds 1000

    $stream = $incomingClient.GetStream()
    $activeConnection = $True

    While ($incomingClient.Connected) {
        If ($Stream.DataAvailable) {
            Do {
                [byte[]]$byte = New-Object byte[] 1024
                Write-Verbose ("{0} Bytes Left from {1}" -f $return.Available,$remoteClient)
                $bytesReceived = $stream.Read($byte, 0, $byte.Length)
                If ($bytesReceived -gt 0) {
                    Write-Verbose ("{0} Bytes received from {1}" -f
                    $bytesReceived,$remoteClient)
                    $String +=
[text.Encoding]::Ascii.GetString($byte[0..($bytesReceived - 1)])
        } Else {
            $activeConnection = $False
            Break
        }
    } While ($Stream.DataAvailable)

If ($String) {
    Write-Host -Foreground Green -background Black ("Message received from {0}:`n {1}" -f $remoteClient,$string) -Verbose
    
    $bytes = [text.Encoding]::Ascii.GetBytes($string)
    $string = $Null
    Write-Verbose ("Echoing {0} bytes to {1}" -f $bytes.count, $remoteClient)
    $Stream.Write($bytes,0,$bytes.length)
    $stream.Flush()
    }
   }
  }
}
