$a = Get-WmiObject Win32_VideoController -filter "name like '%NVIDIA%'" | select name, @{Expression={$_.adapterram/1MB};label="Size"}
$a.Name+'/'+$a.Size+' MB'