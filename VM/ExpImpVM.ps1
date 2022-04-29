# Export
$OldVM  = 'PrevVM-01'
Export-VM -Name $OldVM -Path 'D:\Backup-HV\test'

# Import
$OldVMx = 'AAC16770-6B31-4ACE-ADD1-EE1D41827140.vmcx'
$NewVM  = 'NextVM-01'

Import-VM -Path "D:\Backup-HV\Test\$OldVM\Virtual Machines\$OldVMx" `
-VhdDestinationPath "D:\Hyper-V\$NewVM\Virtual Hard Disk" `
-VirtualMachinePath "D:\Hyper-V\$NewVM\" `
-Copy -GenerateNewId

