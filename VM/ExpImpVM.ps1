# Export
# Выгнать хост из домена до операции экспорта! 
# И не вводить до тех пор пока не переименуем клон после импорта.

$OldVM  = 'PrevVM-01'
Export-VM -Name $OldVM -Path 'D:\Backup-HV\test'

# Import
# Подставить в $OldVMx имя файла из папки экспорта!

$OldVMx = 'AAC16770-6B31-4ACE-ADD1-EE1D41827140.vmcx'
$NewVM  = 'NextVM-01'

Import-VM -Path "D:\Backup-HV\Test\$OldVM\Virtual Machines\$OldVMx" `
-VhdDestinationPath "D:\Hyper-V\$NewVM\Virtual Hard Disk" `
-VirtualMachinePath "D:\Hyper-V\$NewVM\" `
-Copy -GenerateNewId

# После первого включения импортированного хоста даем новый Адрес и новое Имя хосту.
# Только после этого вводим его в домен.


