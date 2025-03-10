$a = (gcim Win32_bios).SerialNumber
$b = (gcim Win32_computersystem).SystemSKUNumber
'PC serial:' + $a +', product:' + $b
