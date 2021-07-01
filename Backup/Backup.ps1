��������� ����������� � ������� Windows Backup � PowerShell
������ ������������
-----------------------------------------------------------------------------------------------------------------

# ��������� snap-in Windows Backup
$SnapIn = "Windows.ServerBackup"
if (Get-PSSnapin -Name $SnapIn -ea "SilentlyContinue")
{
    Write-Log "�������� $SnapIn ��� ����������"
}
 elseif (Get-PSSnapin -Name $SnapIn -registered -ea "SilentlyContinue")
{
    Write-Log "�������� $SnapIn ����������������, �� �� ����������"
    Write-Log "���������� �������� $SnapIn"
    Add-PSSnapin -Name $SnapIn
}
 else
 {
    Write-Log "�������� $SnapIn �� �������! ��������, �� ���������� ��������� Windows Backup."
    Write-Log "����� ����� ����������: $($ElapsedTime.Elapsed.ToString())"
    Exit
}



# ������� ��������
$WBPolicy = New-WBPolicy
Write-Log "������� ��������: $WBPolicy"


# ������ ���� ��� ������
$WBTarget = New-WBBackupTarget -NetworkPath $FullBackupPath
Write-Log "������ ���� ��� ������: $WBTarget"


# ������ ���� ��� ������
$WBTarget = New-WBBackupTarget -VolumePath ($BackupPath)
Write-Log "������ ���� ��� ������: $WBTarget"


# ��������� ���� � ��������� ��������
Add-WBBackupTarget -Policy $WBPolicy -Target $WBTarget -force | Out-Null



# ��������� ������� ��� ������
if($BackupType)
{
    Write-Log "��������� ������ System State"
    Add-WBSystemState -Policy $WBPolicy | Out-Null
} else
{
    Write-Log "��������� ������ Bare Metal Recovery"
    Add-WBBareMetalRecovery -Policy $WBPolicy | Out-Null
}



# ������ ���������� �������
Write-Log "��������� �������"
Start-WBBackup -Policy $WBPolicy | Out-Null



# ���������, ������� �� �������� �����
if (!(Get-WBSummary).LastBackupResultHR)
{
    Write-Log "����� ���������� �������"
    if ((!$IsNetworkBackup) -and (!$BackupType))
    {
        # �������� ID �������� ��� ���������� ������
        $CurrSnapshotId = (Get-WBBackupSet).SnapshotId | Select -Last 1
        # ��������� ��� Bare Metal Recovery
        UpdateBmrLog "Add" $CurrSnapshotId
    }
} else
{
    $WBError = (Get-WBSummary).DetailedMessage
    Write-Log "����� ���������� � �������!"
    Write-Log "$WBError"
}



# ���������� � ��� ��������� ������ �������
Write-Log "��� �������� �������� Windows Backup: $((Get-WBJob -Previous 1).SuccessLogPath)"
Write-Log "��� �������� Windows Backup � ��������: $((Get-WBJob -Previous 1).FailureLogPath)"



# �������� ��� ���������� ����������
$SName=$env:ComputerName

# ������� ������ �� ��������� ����� ��� System State
&WBADMIN DELETE SYSTEMSTATEBACKUP -backupTarget:$Path -machine:$SName -keepVersions:$MaxBackups | Out-Null



# � ������� ���� �������� ���������, ������� �� ������ �����
if(!$LastExitCode)
{
    Write-Log "���������� ������ System State �������"
} else
{
    Write-Log "������ �������� ������� System State!"
}


# ��������� ������� �������� ��� ����� Bare Metal Recovery
if (!(Test-Path $script:BmrLogFolder))
{
    Write-Log "����������� ����� ��� ���� Bare Metal Recovery, �������"
    # ������� �����������, �������
    New-Item (Join-Path -Path $script:SDirPath -ChildPath $script:BmrLogFolder) -Type Directory | Out-Null
}


# ������ ���������� ���� � ������
$BmrLogContent = @(Get-Content $script:BmrLogFilePath)


# ����������/������ ID ���������
if ($Action -eq "Add")
{
    Write-Log "��������� � ��� Bare Metal Recovery ������ � �������� $SnapshotIdList"
    # ��������� ����� ID � ��� ������������ � �����
    $BmrLogContent = $BmrLogContent + $SnapshotIdList
    # ��������� ����
    Set-Content $script:BmrLogFilePath $BmrLogContent

} elseif ($Action -eq "Remove")
{
    Write-Log "������� �� ���� Bare Metal Recovery ������ � �������� $SnapshotIdList"
    # ���������� ������ ID �� ����� � ���������� ID, 
    # ������� ����������
    $BmrLogContent = Compare-Object -ReferenceObject $BmrLogContent -DifferenceObject $SnapshotIdList -PassThru
    # ��������� ����
    Set-Content $script:BmrLogFilePath $BmrLogContent
}


# ���������� ��� ���������� ����� ��� ������� DiskShadow
$TmpFile = Join-Path -Path $Env:TEMP -ChildPath ([System.IO.Path]::GetRandomFileName())
# ���������� ���� ������� ��� �������� ��������
Set-Content $TmpFile "delete shadows ID {$SnapshotId}"


# ��������� DiskShadow
$DelOutput = &diskshadow -s $TmpFile
# ��������� ��� �������� DiskShadow
$DelExitCode = $LastExitCode
# ������� ��������� ����
$TmpFile | Remove-Item -Force -Confirm:$false


# � ������� ���� �������� ���������, ������� �� ������ �������
if (!$DelExitCode)
{
    # ������� ������ �������
    Write-Log "������� ������ ������� $SnapshotId"
    return $true
} else
{
    # ��������� ������, ��������� � ��� ����� DiskShadow
    Write-Log "������ ��� �������� �������� $SnapshotId"
    Write-Log "$DelOutput"
    return $false
}



# ������� �������� ��������� ���������� ������ ��������
if ($Ret)
{
    # ������� ������� ������, ��������� ��� Bare Metal Recovery
    Write-Log "��������� ��� Bare Metal Recovery"
    UpdateBmrLog "Remove" $SnapshotIdList[$i]
} else
{
    # ��������� ������ �� ����� �������� ��������
    Write-Log "������ �������� ��������, �� ��������� ��� Bare Metal Recovery"
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

