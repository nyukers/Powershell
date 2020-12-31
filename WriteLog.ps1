Function Write-Log
{
    $Message = $args[0]
    Write-EvcomLog -LogName Application -Source $EvcomSource -EntryType Information -EvcomId 1 -Message $Message
}

Function Write-VerboseLog
{
    $Message = $args[0]
    Write-Verbose $Message
    Write-Log $Message
}

Function Write-HostLog
{
    $Message = $args[0]
    Write-Output $Message
    Write-Log $Message
}


$VerbosePreference = "Continue"
$host.PrivateData.ErrorForegroundColor = "Yellow"
$EvcomSource = "Powershell CLI"

$Message = "PowerShell version 3 or higher is required!"

$Message1 = 'Host:' + $Message
Write-Host $Message1
$Message2 = 'Output:'+$Message
Write-Output $Message2
$Message3 = 'Log:'+$Message
Write-Log $Message3
$Message4 = 'Verbose:'+$Message
Write-Verbose $Message4
$Message5 = 'VerboseLog:'+$Message
Write-VerboseLog $Message5
$Message6 = 'HostLog:'+$Message
Write-HostLog $Message6

Write-Error $Message6
Throw $Message6

Сообщения могут быть написаны с помощью;

Write-Verbose "Detailed Message"
Write-Information "Information Message"
Write-Debug "Debug Message"
Write-Progress "Progress Message"
Write-Warning "Warning Message"

Каждая из них имеет переменную предпочтения;

$VerbosePreference = "SilentlyContinue"
$InformationPreference = "SilentlyContinue"
$DebugPreference = "SilentlyContinue"
$ProgressPreference = "Continue"
$WarningPreference = "Continue"

Переменная предпочтения контролирует, как обрабатывается сообщение и последующее выполнение скрипта;

$InformationPreference = "SilentlyContinue"
Write-Information "This message will not be shown and execution continues"

$InformationPreference = "Continue"
Write-Information "This message is shown and execution continues"

$InformationPreference = "Inquire"
Write-Information "This message is shown and execution will optionally continue"

$InformationPreference = "Stop"
Write-Information "This message is shown and execution terminates"

Цвет сообщений можно контролировать для Write-Error , установив;
$host.PrivateData.ErrorBackgroundColor = "Black"
$host.PrivateData.ErrorForegroundColor = "Red"

Аналогичные настройки доступны для Write-Verbose , Write-Debug и Write-Warning.


Write-Output генерирует выходной сигнал. Этот вывод может перейти к следующей команде после конвейера или консоли, чтобы он просто отображался.

Командлет отправляет объекты по основному конвейеру, также известному как «выходной поток» или «конвейер успеха». Чтобы отправить объекты ошибок в конвейер ошибок, используйте Write-Error.

# 1.) Output to the next Cmdlet in the pipeline
Write-Output 'My text' | Out-File -FilePath "$env:TEMP\Test.txt"

Write-Output 'Bob' | ForEach-Object {
    "My name is $_"
}

# 2.) Output to the console since Write-Output is the last command in the pipeline
Write-Output 'Hello world'

# 3.) 'Write-Output' CmdLet missing, but the output is still considered to be 'Write-Output'
'Hello world'

Командлет Write-Output отправляет указанный объект по конвейеру в следующую команду.
Если команда является последней командой в конвейере, объект отображается в консоли.
Интерпретатор PowerShell рассматривает это как неявный Write-Output.
Поскольку поведение по умолчанию Write-Output - отображать объекты в конце конвейера, обычно нет необходимости использовать командлет. Например, Get-Process | Write-Output эквивалентен Get-Process .

