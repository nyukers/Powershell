Резервное копирование Hyper-V. PowerShell-скрипт и утилита HVBackup
Сергей Горбановский
---------------------------------------------------------------------

HVBackup --all --output c:\backup


HVBackup --list VM1,VM2 --output  \\yourserver\backup


HVBackup --file list.txt --output c:\backup



$FullPath = $script:MyInvocation.MyCommand.Path



$SBaseFileName = [System.IO.Path]::GetFileNameWithoutExtension($FullPath)
$script:SIniFile = Join-Path -Path $script:SDirPath -ChildPath $SBaseFileName".ini"



Get-Content $script:SIniFile | ForEach-Object -begin {$SSettings=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $SSettings.Add($k[0], $k[1]) } }



[string]$BackupPath = $SSettings.Get_Item("BackupPath")



$VMs = Get-WmiObject -Computername localhost -Namespace root\Virtualization -Query "Select * from MSVM_Computersystem where Description like'%Virtual%' AND (EnabledState = 2 OR EnabledState=3 OR EnabledState=32768 OR EnabledState=32769)"



$VMs = Get-WmiObject -Computername localhost -Namespace root\Virtualization -Query "Select * from MSVM_Computersystem where Description like'%Virtual%'"



$Items = @(Get-ChildItem -Path $Path\*) | Sort-Object -Property CreationTime



$VMBackupTime = Measure-Command {&$script:BackupExe --backup --outputformat "{0}_{2:dd-MM-yyyy_HH-mm-ss}.zip" --output "$VMPath" --list "$VMName"}
Write-Log "Бэкап $VMName занял $VMBackupTime"



$VMBackupTime = Measure-Command {&$script:BackupExe --backup --outputformat "{0}_{2:dd-MM-yyyy_HH-mm-ss}.zip" --output "$VMPath" --list "$VMName"" –compressionlevel 0}



Trap
{
    # Все критические ошибки в процессе работы будут записаны в лог
    $TrapMessage = $error[0].ToString() + " " + $error[0].InvocationInfo.PositionMessage
    Write-Log "$TrapMessage";Continue;
}



[Backup]
BackupPath=E:\Backup\Hyper-V\
MaxBackupsActive=3
MaxBackupsInactive=1
LazyMode=1
BackupExe=.\HVBackup\HVBackup.exe

[Email]
SendEmail=1
Sender=HVBackup@mycompany.ru
Receipt=admin@mycompany.ru
Server=mail.mycompany.ru
Login=hvbackup
Password=password
Port=25
SSL=0
TrustAnyCert=0
