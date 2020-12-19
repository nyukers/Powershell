Get-WindowsCapability -Online | ? Name -like 'OpenSSH*'
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

net start sshd
netsh advfirewall firewall add rule name="SSHD Port" dir=in action=allow protocol=TCP localport=22