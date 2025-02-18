Install-Module -Name SecretManagement.KeePass
Get-Command -Module SecretManagement.KeePass
Get-Command -Module Microsoft.PowerShell.SecretManagement

Register-SecretVault -Name "KeePassDB" -ModuleName "SecretManagement.Keepass" -VaultParameters @{
Path = "C:\App\keypass2\Database.kdbx"
UseMasterPassword = $true
}

Register-SecretVault -Name "KeePassSW" -ModuleName "SecretManagement.Keepass" -VaultParameters @{
Path    = "C:\App\keypass2\SWES.kdbx"
KeyPath = "C:\App\keypass2\SWES.keyx"
UseMasterPassword = $true
}
	
UnRegister-SecretVault -Name "KeePassSW"

Test-SecretVault -Name KeePassDB
Test-SecretVault -Name KeePassSW
Get-SecretVault

Get-SecretInfo -Vault KeePassDB
$Cred = Get-Secret -Vault KeePassDB ZTE
$secur = Get-Secret -Vault KeePassDB ZTE -AsPlainText
$secur.GetNetworkCredential().password

Get-SecretInfo -Vault KeePassSW | Ft Name, Metadata

Set-Secret -Vault KeePassDB -Name "ILO_adm" -Secret (Get-Credential winitpro\ILO_adm)
Set-Secret -Vault KeePassDB -Name "ILO_adm" -Secret ($Cred)