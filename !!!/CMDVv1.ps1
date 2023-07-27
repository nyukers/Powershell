################################################################################
# This Function to retrieve data about Windows host. See Example uses below
#
# Revision: v1.0 Initial Version, author Nyukers (C)opyright, Vinnytsia, 2023
################################################################################
# Options: # CSV report file maybe imported to Excel book directly!
#
# The following ImportExcel module must be instaled one time:
#    Install-Module ImportExcel -Scope CurrentUser -force
#
# File booker.xlsx must be offline in Excel before:
#    Import-csv -Path 'c:\_report.csv' | Export-Excel -Path 'c:\booker.xlsx' -AutoSize -WorksheetName CMDB -Append
#
################################################################################


Function Get-CMDBInfo {
    <#
    .SYNOPSIS
    This function get information about Windows host.
    
    .DESCRIPTION
    Function get data about Windows host and export it to CSV file as filename like _hostname:
    Hostname    
    Serial number
    Product number (SKU)
    Model host     
    OS Type    
    OS Locale  
    OS Bits (32/64)   
    CPU Type   
    RAM Size (GB) 
    Disk Size (GB)
    IP Address of active physical adapters
        
    .EXAMPLE: Call from current file
    Get-CMDBInfo -Path2File 'd:\'
       
    .EXAMPLE: Call from external file
    . d:\CMDB.ps1
    -OR-
    . .\!!!\CMDB.ps1
    Get-CMDBInfo -Path2File 'd:\reports\'

    .PARAMETER Path2File
    Mandatory. Path to the Log file.
    #>

    [cmdletbinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline)]
        [string]$Path2File
    )

# Retrieve system information
$systemInfo = @{
    a0Date_info      = Get-Date
    a0Hostname       = $env:COMPUTERNAME
    a0Serial_number  = (gcim Win32_bios).SerialNumber
    a0Product_number = (gcim Win32_computersystem).SystemSKUNumber
    a0Model          = (Get-WmiObject -Class:Win32_ComputerSystem).Model
    b1OS_Type        = (Get-CimInstance Win32_OperatingSystem).Caption
    OS_Locale        = (Get-CimInstance Win32_OperatingSystem).Locale
    OS_Bits          = (Get-CimInstance Win32_OperatingSystem).OSArchitecture
    a1CPU_Type       = (Get-CimInstance Win32_Processor).Name -join ', '
    a1RAM_Size       = '{0:N1} GB' -f (((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory -as [double]) / 1GB)
    a1Disk_Size      = '{0:N1} GB' -f ((Get-PhysicalDisk | Measure-Object Size -Sum).Sum / 1GB)
    b0IP_Address     = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias (Get-NetAdapter -Physical | Where-Object Status -eq 'Up').InterfaceAlias).IPAddress -join ', '
}
# Convert LCID to language name
$languages = @{
    "0409" = "English";
    "0422" = "Ukrainian";
    "0419" = "Russian";
    # Add more LCID and language mappings here...
}
$lcid = $systemInfo['OS_Locale']
$languageName = $languages[$lcid]
$systemInfo['OS_Locale'] = $languageName

# OS release
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\ProductOptions"
$productType = Get-ItemPropertyValue -Path $regPath -Name "ProductType"
if ($productType -eq "WinNT") {
    $systemInfo['OS_release'] = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name DisplayVersion).DisplayVersion
  #  Write-Host "Workstation"
} elseif ($productType -eq "ServerNT") {
  #  Write-Host "Server"
    $systemInfo['OS_release'] = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ReleaseID).ReleaseID
} 

$sortedSystemInfo = [Ordered]@{}
$systemInfo.GetEnumerator() | Sort-Object -Property Name | foreach {
    $sortedSystemInfo[$_.Name] = $_.Value
}

# Visual control for output the sorted hashtable
$sortedSystemInfo

# Convert hashtable to custom object
#$systemObject = New-Object -TypeName PSObject -Property $systemInfo 
$systemObject = New-Object -TypeName PSObject -Property $sortedSystemInfo

# Export system information to CSV file
$systemObject | Export-Csv -Path $Path2File'_'$env:COMPUTERNAME'.txt' -Encoding UTF8 -NoTypeInformation -Force

}

