workflow Get-WFInfo
 {
 parallel
 {
  Get-CimInstance -ClassName win32_BaseBoard
  Get-CimInstance -ClassName win32_bios
  #Get-NetAdapter

  Get-Disk -CimSession $PSComputerName
  #Get-Partition -CimSession $PSComputerName
 }
}

#Get-WFInfo
Get-WFInfo -PSComputerName Goverla2  | select CimClass,SystemName,PSComputerName