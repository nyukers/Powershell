Резервное копирование с помощью Windows Backup и PowerShell
Сергей Горбановский
-----------------------------------------------------------------------------------------------------------------

# Загружаем snap-in Windows Backup
$SnapIn = "Windows.ServerBackup"
if (Get-PSSnapin -Name $SnapIn -ea "SilentlyContinue")
{
    Write-Log "Оснастка $SnapIn уже подключена"
}
 elseif (Get-PSSnapin -Name $SnapIn -registered -ea "SilentlyContinue")
{
    Write-Log "Оснастка $SnapIn зарегистрирована, но не подключена"
    Write-Log "Подключаем оснастку $SnapIn"
    Add-PSSnapin -Name $SnapIn
}
 else
 {
    Write-Log "Оснастка $SnapIn не найдена! Возможно, не установлен компонент Windows Backup."
    Write-Log "Общее время выполнения: $($ElapsedTime.Elapsed.ToString())"
    Exit
}



# Создаем политику
$WBPolicy = New-WBPolicy
Write-Log "Создаем политику: $WBPolicy"


# Задаем цель для бэкапа
$WBTarget = New-WBBackupTarget -NetworkPath $FullBackupPath
Write-Log "Задаем цель для бэкапа: $WBTarget"


# Задаем цель для бэкапа
$WBTarget = New-WBBackupTarget -VolumePath ($BackupPath)
Write-Log "Задаем цель для бэкапа: $WBTarget"


# Добавляем цель к созданной политике
Add-WBBackupTarget -Policy $WBPolicy -Target $WBTarget -force | Out-Null



# Добавляем объекты для бэкапа
if($BackupType)
{
    Write-Log "Добавляем объект System State"
    Add-WBSystemState -Policy $WBPolicy | Out-Null
} else
{
    Write-Log "Добавляем объект Bare Metal Recovery"
    Add-WBBareMetalRecovery -Policy $WBPolicy | Out-Null
}



# Запуск созданного задания
Write-Log "Запускаем задание"
Start-WBBackup -Policy $WBPolicy | Out-Null



# Проверяем, успешно ли выполнен бэкап
if (!(Get-WBSummary).LastBackupResultHR)
{
    Write-Log "Бэкап завершился успешно"
    if ((!$IsNetworkBackup) -and (!$BackupType))
    {
        # Получаем ID снэпшота для последнего бэкапа
        $CurrSnapshotId = (Get-WBBackupSet).SnapshotId | Select -Last 1
        # Обновляем лог Bare Metal Recovery
        UpdateBmrLog "Add" $CurrSnapshotId
    }
} else
{
    $WBError = (Get-WBSummary).DetailedMessage
    Write-Log "Бэкап завершился с ошибкой!"
    Write-Log "$WBError"
}



# Записываем в лог результат работы задания
Write-Log "Лог успешных операций Windows Backup: $((Get-WBJob -Previous 1).SuccessLogPath)"
Write-Log "Лог операций Windows Backup с ошибками: $((Get-WBJob -Previous 1).FailureLogPath)"



# Получаем имя локального компьютера
$SName=$env:ComputerName

# Удаляем бэкапы на локальном диске для System State
&WBADMIN DELETE SYSTEMSTATEBACKUP -backupTarget:$Path -machine:$SName -keepVersions:$MaxBackups | Out-Null



# С помощью кода возврата проверяем, успешно ли удален бэкап
if(!$LastExitCode)
{
    Write-Log "Устаревшие бэкапы System State удалены"
} else
{
    Write-Log "Ошибка удаления бэкапов System State!"
}


# Проверяем наличие каталога для логов Bare Metal Recovery
if (!(Test-Path $script:BmrLogFolder))
{
    Write-Log "Отсутствует папка для лога Bare Metal Recovery, создаем"
    # Каталог отсутствует, создаем
    New-Item (Join-Path -Path $script:SDirPath -ChildPath $script:BmrLogFolder) -Type Directory | Out-Null
}


# Читаем содержимое лога в массив
$BmrLogContent = @(Get-Content $script:BmrLogFilePath)


# Записываем/читаем ID снэпшотов
if ($Action -eq "Add")
{
    Write-Log "Добавляем в лог Bare Metal Recovery запись о снэпшоте $SnapshotIdList"
    # Добавляем новый ID к уже существующим в файле
    $BmrLogContent = $BmrLogContent + $SnapshotIdList
    # Сохраняем файл
    Set-Content $script:BmrLogFilePath $BmrLogContent

} elseif ($Action -eq "Remove")
{
    Write-Log "Удаляем из лога Bare Metal Recovery запись о снэпшоте $SnapshotIdList"
    # Сравниваем список ID из файла и переданные ID, 
    # удаляем совпадения
    $BmrLogContent = Compare-Object -ReferenceObject $BmrLogContent -DifferenceObject $SnapshotIdList -PassThru
    # Сохраняем файл
    Set-Content $script:BmrLogFilePath $BmrLogContent
}


# Генерируем имя временного файла для скрипта DiskShadow
$TmpFile = Join-Path -Path $Env:TEMP -ChildPath ([System.IO.Path]::GetRandomFileName())
# Генерируем тело скрипта для удаления снэпшота
Set-Content $TmpFile "delete shadows ID {$SnapshotId}"


# Запускаем DiskShadow
$DelOutput = &diskshadow -s $TmpFile
# Сохраняем код возврата DiskShadow
$DelExitCode = $LastExitCode
# Удаляем временный файл
$TmpFile | Remove-Item -Force -Confirm:$false


# С помощью кода возврата проверяем, успешно ли удален снэпшот
if (!$DelExitCode)
{
    # Снэпшот удален успешно
    Write-Log "Успешно удален снэпшот $SnapshotId"
    return $true
} else
{
    # Произошла ошибка, сохраняем в лог вывод DiskShadow
    Write-Log "Ошибка при удалении снэпшота $SnapshotId"
    Write-Log "$DelOutput"
    return $false
}



# Функция удаления снэпшотов возвращает статус операции
if ($Ret)
{
    # Снэпшот успешно удален, обновляем лог Bare Metal Recovery
    Write-Log "Обновляем лог Bare Metal Recovery"
    UpdateBmrLog "Remove" $SnapshotIdList[$i]
} else
{
    # Произошла ошибка во время удаления снэпшота
    Write-Log "Ошибка удаления снэпшота, не обновляем лог Bare Metal Recovery"
}



[Backup]
BackupPath=D:
IsNetworkBackup=0
BackupType=1
MaxBackups=5

[Email]
SendEmail=1
Sender=WinBackup@mycompany.ru
Receipt=admin@mycompany.ru
Server=mail.mycompany.ru
Login=winbackup
Password=password
Port=25
SSL=0
TrustAnyCert=0

