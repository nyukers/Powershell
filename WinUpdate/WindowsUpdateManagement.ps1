
$watch = [System.Diagnostics.Stopwatch]::StartNew()
$watch.Start()

[string]$Logfile_name = $env:COMPUTERNAME + "_auto_update.log" #log file name

#generate log full path
if ($PSScriptRoot) {
    $Logfile = Join-Path $PSScriptRoot $Logfile_name
} else {
    $Logfile = Join-Path $((Get-Location).Path) $Logfile_name
}

#create log file if his not exist
if (!(Test-Path $LogFile)) {New-Item "$LogFile" -ItemType "file" | Out-Null}

#function write log
function Write-Log {
    [CmdletBinding()]
    Param (
        [Parameter(Position=0, ValueFromPipeline)]
        [string]$LogString="Empty line. No text set when writing a log",

        [Parameter(Position=1)]
        [switch]$Time
    )    
    if ($Time) {
        $Stamp = (Get-Date).toString("dd/MM/yyyy HH:mm:ss")
        $LogMessage = "$Stamp $LogString"       
    } else {
        $LogMessage = $LogString
    }   
    Add-content $LogFile -value $LogMessage
}

# Function to check pending reboot.
function Get-PendingReboot {
    if (Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -EA Ignore) { return $true }
    if (Get-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -EA Ignore) { return $true }
    if (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name PendingFileRenameOperations -EA Ignore) { return $true }
    try { 
        $util = [wmiclass]"\\.\root\ccm\clientsdk:CCM_ClientUtilities"
        $status = $util.DetermineIfRebootPending()
        if (($null -ne $status) -and $status.RebootPending) {
            return $true
        }
    } catch {}

    return $false
}

Write-Log "**************************************************************"
Write-Log "Start" -Time

# Import the required module.
Try {
    Import-Module PSWindowsUpdate
} catch {
    Write-Log "$($error[0].Exception.Message) `r`n $($error[0].InvocationInfo.PositionMessage)" -Time
}


# Look for all updates, download, install and don't reboot yet.
try {
    Get-WindowsUpdate -AcceptAll -Download -Install -IgnoreReboot | Out-File $Logfile -force -Append -Encoding utf8
    if ($?) {
        $Reply = "The process of finding,downloading or\and installing updates has been successfully completed"
        Write-Log $Reply -Time               
    }
} catch {
    $Reply =  "$($error[0].Exception.Message) `r`n $($error[0].InvocationInfo.PositionMessage)"
    Write-Log $Reply -Time        
}



# Check if a pending reboot is found, notify users if that is the case. If none found just close the session.
$reboot = Get-PendingReboot

if($reboot -eq $true){
    Write-Log "Pending reboot found. Reboot at $((get-date).AddMinutes(5)).." -Time
    cmd /c "msg * "Windows update has finished downloading and needs to reboot to install the required updates. Rebooting in 5 minutes..""
    cmd /c "Shutdown /r /f /t 300 /c "Windows update has finished downloading and needs to reboot to install the required updates. Rebooting in 5 minutes.." /d p:4:1"
}else {
    Write-Log "No Pending reboot. Shutting down PowerShell.." -Time
}

$watch.Stop()

Write-Log "Script execution time $($watch.Elapsed)"
Write-Log "Script complete `r`n" -Time

$Timer = (Get-Date).toString("dd/MM/yyyy HH:mm:ss")

$OSver = (Get-WMIObject win32_operatingsystem) | Select Name

# (Get-host).Version
# $OSver = (Get-WMIObject win32_operatingsystem) | Select Name
# Send-MailMessage -To "nyukers@gmail.com" -From  "nyukers@gmail.com" -SmtpServer &&&&&& -Subject "$env:COMPUTERNAME autoupdate" -Body "$Timer $OSver $Reply"

