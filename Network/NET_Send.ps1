# Section 49.2: TCP Sender

Function Send-TCPMessage {
Param (
    [Parameter(Mandatory=$true, Position=0)]
    [ValidateNotNullOrEmpty()]
    [string]
    $EndPoint
    ,
    [Parameter(Mandatory=$true, Position=1)]
    [int]
    $Port
    ,
    [Parameter(Mandatory=$true, Position=2)]
    [string]
    $Message
)
Process {
    # Setup connection
    $IP = [System.Net.Dns]::GetHostAddresses($EndPoint)
    $Address = [System.Net.IPAddress]::Parse($IP)
    $Socket = New-Object System.Net.Sockets.TCPClient($Address,$Port)
    # Setup stream writer
    $Stream = $Socket.GetStream()
    $Writer = New-Object System.IO.StreamWriter($Stream)
    # Write message to stream
    $Message | % {
        $Writer.WriteLine($_)
        $Writer.Flush()
    }
    # Close connection and stream
    $Stream.Close()
    $Socket.Close()
    }
}

# Send a message with:

Send-TCPMessage -Port 29800 -Endpoint 192.168.1.180 -message "My first TCP message!"

# Note: TCP messages may be blocked by your software firewall or any external facing firewalls you are trying to go
# through. Ensure that the TCP port you set in the above command is open and that you are have setup the listener
# on the same port.
