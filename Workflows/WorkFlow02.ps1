workflow New-VirtualMachines

{

  [CmdletBinding()]

  Param (

    [Parameter(Mandatory=$true,Position=0)]$VMName,

    [Parameter(Mandatory=$true,Position=1)]$VMCount,

    [Parameter(Mandatory=$true,Position=2)]$VHDSize

  )

  $VMs = 1..$VMCount

  foreach -parallel ($VM in $VMs)

  {

    New-VM -Name $VMName$VM -MemoryStartupBytes 512MB -NewVHDPath «D:\Hyper-V\Virtual Hard Disks\$VMName$VM.vhdx» -NewVHDSizeBytes $VHDSize

  }

}

# Вы можете вызвать этот рабочий процесс так же, как и функцию:

New-VirtualMachines -VMName VM -VMCount 5 -VHDSize 15GB