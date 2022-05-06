# Резервное копирования и ротация бэкапов для VM под управлением Hyper-V
# Минимальные требования для работы скрипта: PowerShell v2, Windows Server 2008.
 
 
# Функции, используемые в скрипте
 
# Функция для логирования
Function Write-Log ([string]$Message)
{
    # Дата для вывода на экран
    $strDate = Get-Date -Format "HH:mm:ss"
     
    if ($script:LogPath)
    {
        # Создаем каталог для логов, если его нет
        if (!(Test-Path $script:LogPath))
        {
            New-Item $script:LogPath -Type Directory | Out-Null
        }
 
        $FullLogPath = Join-Path $script:LogPath -ChildPath $script:LogFilename
 
        # Пишем лог в файл  
        Write-Output "$strDate $Message" | Out-File -FilePath $FullLogPath -Append -Encoding Unicode
    }
 
    # Пишем лог в консоль
    Write-Host "$strDate $Message"
}
 
# Функция отправки отчета на e-mail
function EmailNotification([string]$Sender, [string]$Receipt, [string]$Server, [boolean]$SSL = $False, [int]$Port = 25, [string]$Login, [string]$Password, [boolean]$TrustAnyCert = $False)
{
    Write-Log "Отправляем отчет на $Receipt"
 
    # Тема письма
    $Object = $env:computername+": Отчет о резервном копировании VM от " + (Get-Date)
 
    # Содержимое письма
    $Content = Get-Content (Join-Path $script:LogPath -ChildPath $script:LogFilename) | Out-String
    $SMTPclient = New-Object System.Net.Mail.SmtpClient $Server
 
    # SMTP порт
    $SMTPClient.Port = $Port
 
    # SSL
    if ($SSL)
    {
        # Устанавливаем режим SSL
        $SMTPclient.EnableSsl = $SSL
 
        # Отключаем проверку сертификатов, если наш почтовый сервер использует самоподписанный сертификат или он не установлен в системе.
        if ($TrustAnyCert)
        {
            [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$True}
        }
    }
   
    # Если указан логин, инициализируем учетные данные SMTP-клиента
    if ($Login)
    {
        $SMTPClient.Credentials = New-Object System.Net.NetworkCredential($Login, $Password)
    }
 
    # Создаем письмо
    $Message = New-Object System.Net.Mail.MailMessage $Sender, $Receipt, $Object, $Content
   
    # Тело письма будет в текстовом формате
    $Message.IsBodyHtml = $False;
 
    # Отправляем письмо
    $SMTPclient.Send($Message)
}
 
 
# Функция, для определения относительного пути и его нормализации, если необходимо
Function NormalizePath ([string]$Path)
{
    # Проверяем, относительный-ли путь
    if ([System.IO.Path]::IsPathRooted($Path))
    {
        # Если нет, то ничего не делаем
        $NormPath = $Path
    } else
    {
        # Если путь относительный, то нормализуем его
        $Path = Join-Path -Path $script:SDirPath -ChildPath $Path
        $NormPath = [System.IO.Path]::GetFullPath($Path)
    }
 
    return $NormPath
}
 
 
# Функция, для установки путей
Function SetPaths
{
    # Устанавливаем глобальные переменные
 
    # Определяем путь, откуда запущен скрипт
    $FullPath = $script:MyInvocation.MyCommand.Path
 
    # Каталог скрипта
    $script:SDirPath = Split-Path $FullPath
 
    # Путь к файлу с настройками (ИмяСкрипта.ini)
    $SBaseFileName = [System.IO.Path]::GetFileNameWithoutExtension($FullPath)
    $script:SIniFile = Join-Path -Path $script:SDirPath -ChildPath $SBaseFileName".ini"
 
    # Дата и время для имени лог-файла
    $flDate = Get-Date -Format "dd-MM-yyyy_HH-mm-ss"
 
    # Подкаталог для лог-файлов
    $LogSubFolder = "Logs"
 
    # Путь к лог-файлу
    $script:LogPath = Join-Path -Path $script:SDirPath -ChildPath $LogSubFolder
 
    # Имя лог-файла
    $script:LogFilename = $SBaseFileName + "_" + $flDate + ".log"
    Write-Log "Пишем лог в: $script:LogFilename"
}
 
# Функция для получения списка VM и их статусов
function GetVMs()
{
    Write-Log "Получаем список VM"
    # Запрос к WMI для получения списка VM.
    # VM в переходных состояниях нас не интересуют.
    $VMs = Get-WmiObject -Computername localhost -Namespace root\Virtualization -Query "Select * from MSVM_Computersystem where Description like'%Virtual%' AND (EnabledState = 2 OR EnabledState=3 OR EnabledState=32768 OR EnabledState=32769)"
 
    # Пребразуем коды статусов в human-readable вид
    foreach ($VM IN $VMs)
    {
        switch ($VM.EnabledState)
        {
            2{$State = "Running"}
            3{$State = "Stopped"}
            32768{$State = "Paused"}
            32769{$State = "Suspended"}
            32770 {$State = "Starting"}
            32771{$State = "Taking Snapshot"}
            32773{$State = "Saving"}
            32774{$State = "Stopping"}
        }
 
        # Добавляем в хеш-таблицу
        $VMList.add($VM.ElementName, $State)
        Write-Log "$($VM.ElementName) ($State)"
    }
    # Возвращаем полученную таблицу
    return $VMList
}
 
# Функция для запуска утилиты бэкапа
function LaunchEXE ($VMPath, $VMName)
{
    Write-Log "Запускаем утилиту для бэкапа"
    $VMBackupTime = Measure-Command {&$script:BackupExe --backup --outputformat "{0}_{2:dd-MM-yyyy_HH-mm-ss}.zip" --output "$VMPath" --list "$VMName"}
    Write-Log "Бэкап $VMName занял $VMBackupTime"
}
 
# Функция ротации бэкапов
function DoRotation([string]$Path, [int]$MaxItems)
{
    Write-Log "Начинаем ротацию"
    # Выходим, если кол-во хранимых бэкапов равно 0
    if (!$MaxItems)
    {
        Write-Log "Ротация отключена в настройках"
        return
    }
 
    # Получаем список всех файлов с бэкапами, отсортированный по дате создания
    $Items = @(Get-ChildItem -Path $Path\*) | Sort-Object -Property CreationTime
 
    # Выходим, если бэкапов нет
    if (!$Items)
    {
        Write-Log "Предыдущие бэкапы не найдены"
        return
    }
 
    # Задаем параметры для цикла удаления
    $NbrBackups = $Items.Count
    $i = 0
    Write-Log "Найдено предыдущих бэкапов: $NbrBackups"
 
    # Удаляем старые бэкапы
    while ($NbrBackups -ge $MaxItems)
    {
        Write-Log "Удаляем предыдущий бэкап $($Items[$i])"
        $Items[$i] | Remove-Item -Force -Recurse -Confirm:$false
        $NbrBackups -= 1
        $i++
    }
}
 
# Основная функция бэкапа
function DoBackup([hashtable]$VMList, [string]$BackupPath, [int]$MaxBackupsActive, [int]$MaxBackupsInactive, [bool]$LazyMode)
{
    Write-Log "Начинаем бэкап"
    # Получаем имя локального компьютера
    $PCName = $env:computername
 
    # Генерируем имя папки для бэкапа этого компьютера
    $PCBackupPath = Join-Path -Path $BackupPath -ChildPath $PCName
 
    # Ротация\бэкап для каждой VM в списке
    foreach ($VM in $VMList.GetEnumerator())
    {    
        # Генерируем имя папки для бэкапа этой VM
        $VMBackupPath = Join-Path -Path $PCBackupPath -ChildPath $VM.Key
        Write-Log "Бэкапим $($VM.Key) в папку $VMBackupPath"
         
        # В зависимости от статуса VM
        if ($VM.Value -eq "Running")
        {
            Write-Log "VM активна"
            # Делаем ротацию бэкапов
            DoRotation $VMBackupPath $MaxBackupsActive
 
            # Создаем каталог, если его нет
            if (!(Test-Path $VMBackupPath))
            {
                Write-Log "Отсутствует папка для бэкапа VM, создаем"
                New-Item $VMBackupPath -Type Directory | Out-Null
            }
 
            #Запускаем утилиту для бэкапа
            LaunchEXE $VMBackupPath $VM.Key
        } else
        {
            Write-Log "VM не активна"
            # А не ленимся ли мы?
            if ($LazyMode)
            {
                Write-Log "Включен ленивый режим"
                # Проверяем, есть ли бэкапы
                $ExistingBackups = @(Get-ChildItem -Path $VMBackupPath\*)
 
                # Нет? Сделаем один..
                if (!$ExistingBackups.Count)
                {
                    Write-Log "У данной VM нет ни одного бэкапа, делаем"
                    # Создаем каталог, если его нет
                    if (!(Test-Path $VMBackupPath))
                    {
                        Write-Log "Создаем папку для бэкапа VM"
                        New-Item $VMBackupPath -Type Directory | Out-Null
                    }
 
                    #Запускаем утилиту для бэкапа
                    LaunchEXE $VMBackupPath $VM.Key
 
                } else {Write-Log "У данной VM уже есть бэкапы, ничего не делаем"}
 
            } else
            {
                # Для неактивных VM делаем ротацию, только если не используется ленивый режим
                DoRotation $VMBackupPath $MaxBackupsInactive
 
                # Создаем каталог, если его нет
                if (!(Test-Path $VMBackupPath))
                {
                    Write-Log "Создаем папку для бэкапа VM"
                    New-Item $VMBackupPath -Type Directory | Out-Null
                }
 
                #Запускаем утилиту для бэкапа
                LaunchEXE $VMBackupPath $VM.Key
            }
        }
    }
}
 
 
 
# !! Начало скрипта !!
 
# Очищаем экран
Clear-Host
 
# Запускаем таймер для определения времени выполнения скрипта
$ElapsedTime = [System.Diagnostics.Stopwatch]::StartNew()
 
# Устанавливаем глобальный обработчик исключений
Trap
{
    # Все критические ошибки в процессе работы будут записаны в лог
    $TrapMessage = $error[0].ToString() + " " + $error[0].InvocationInfo.PositionMessage
    Write-Log "$TrapMessage";Continue;
}
 
# Настраиваем пути для логов и файла настроек
SetPaths
 
# Загружаем и парсим файл настроек
Write-Log "Читаем настройки из: $script:SIniFile"
Get-Content $script:SIniFile | ForEach-Object -begin {$SSettings=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $SSettings.Add($k[0], $k[1]) } }
 
# Путь к каталогу для бэкапов
[string]$BackupPath = $SSettings.Get_Item("BackupPath")
Write-Log "Путь к каталогу для бэкапов: $BackupPath"
 
# Путь к утилите для бэкапов, можно использовать относительные
$script:BackupExe = NormalizePath ($SSettings.Get_Item("BackupExe"))
Write-Log "Путь к утилите для бэкапов: $script:BackupExe"
 
# Кол-во хранимых бэкапов для активных VM. 0 - не удалять старые
[int]$MaxBackupsActive = $SSettings.Get_Item("MaxBackupsActive")
Write-Log "Кол-во хранимых бэкапов для активных VM: $MaxBackupsActive"
 
# Кол-во хранимых бэкапов для неактивных VM. 0 - не удалять старые
[int]$MaxBackupsInactive = $SSettings.Get_Item("MaxBackupsInactive")
Write-Log "Кол-во хранимых бэкапов для неактивных VM: $MaxBackupsInactive"
 
# Ленивый режим, бэкапит неактивные машины только в случае отсутствия бэкапов
# В PowerShell нельзя привести строковой 0 в boolean напрямую, используем специальную конструкцию
[boolean]$LazyMode = [System.Convert]::ToInt32($SSettings.Get_Item("LazyMode"))
Write-Log "Ленивый режим: $LazyMode"
 
# Посылать отчет на e-mail?
# В PowerShell нельзя привести строковой 0 в boolean напрямую, используем специальную конструкцию
[boolean]$SendEmail = [System.Convert]::ToInt32($SSettings.Get_Item("SendEmail"))
Write-Log "Посылать отчет на e-mail: $SendEmail"
 
# Создаем новую пустую хеш-таблицу
[hashtable]$VMList = @{}
 
# Получаем список VM со статусами
$VMList = GetVMs
 
# Запускаем бэкап
DoBackup $VMList $BackupPath $MaxBackupsActive $MaxBackupsInactive $LazyMode
 
# Бэкап окончен
Write-Log "Общее время выполнения: $($ElapsedTime.Elapsed.ToString())"
 
# Проверяем, включена-ли отправка отчетов на e-mail
if ($SendEmail)
{
    # Устанавливаем параметры для отчета на e-mail
 
    # Адрес отправителя
    [string]$Sender = $SSettings.Get_Item("Sender")
 
    # Адрес получателя
    [string]$Receipt = $SSettings.Get_Item("Receipt")
 
    # SMTP сервер
    [string]$Server = $SSettings.Get_Item("Server")
 
    # SMTP порт
    [int]$Port = $SSettings.Get_Item("Port")
 
    # SSL
    # В PowerShell нельзя привести строковой 0 в boolean напрямую, используем специальную конструкцию
    [boolean]$SSL = [System.Convert]::ToInt32($SSettings.Get_Item("SSL"))
    [boolean]$TrustAnyCert = [System.Convert]::ToInt32($SSettings.Get_Item("TrustAnyCert"))
 
    # Логин
    [string]$Login = $SSettings.Get_Item("Login")
 
    # Пароль
    [string]$Password = $SSettings.Get_Item("Password")
 
    Write-Log "Отчет на e-mail будет отправлен с $Sender на $Receipt через $Server"
    Write-Log "SSL: $SSL, Игнорировать ошибки сертификатов: $TrustAnyCert, Порт: $Port, Логин: $Login)"
 
    # Отсылаем отчет на e-mail
    EmailNotification $Sender $Receipt $Server $SSL $Port $Login $Password $TrustAnyCert
}
 
