$i=3
while($True){
$error.clear()
$MappedDrives = Get-SmbMapping |where -property Status -Value Unavailable -EQ | select LocalPath,RemotePath
foreach( $MappedDrive in $MappedDrives)
{
try {
New-SmbMapping -LocalPath $MappedDrive.LocalPath -RemotePath $MappedDrive.RemotePath -Persistcom $True
} catch {
Write-Host "Ошибка подключения сетевого каталога $MappedDrive.RemotePath в диск $MappedDrive.LocalPath"
}
}
$i = $i - 1
if($error.Count -eq 0 -Or $i -eq 0) {break}
Start-Sleep -Seconds 30
}