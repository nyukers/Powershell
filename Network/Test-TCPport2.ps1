
filter Test-TcpPort {
    # Input:
    # paramaters (1) (optional, default = 80): [int] port
    # object pipeline: [string] IP addresses and hostnames

    # Output:
    # [string] "$_ ## status" where # is port number
    # TODO: create custom object for output instead of strings
    # also need to trap the connect errors
    
    Param([int]$port = 80)
    # Скрываем неявные ошибки
    $ErrorActionPreference = "SilentlyContinue"
    $socket = new-object Net.Sockets.TcpClient
    $socket.Connect($_, $port)
    if ($socket.Connected) {
        $status = "Открыт"
        $socket.Close()
    } else {
        $status = "Закрыт / Отфильтрован"
    }
    $socket = $null
    write-output "$_`t$port`t$status"
}

# Список (массив) хостов или IP
$a = 'ukr.net','google.com'

# Собственно проверка
$a | Test-TcpPort