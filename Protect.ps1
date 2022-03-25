function SuperDecrypt

{

 param($script)

 

 $bytes = [Convert]::FromBase64String($script)

 

 ## XOR “encryption”

 $xorKey = 0x42

 for($counter = 0; $counter -lt $bytes.Length; $counter++)

 {

 $bytes[$counter] = $bytes[$counter] -bxor $xorKey

 }

 
  [System.Text.Encoding]::Unicode.GetString($bytes)

}

$decrypted = SuperDecrypt “FUIwQitCNkInQm9CCkItQjFCNkJiQmVCEkI1QixCJkJlQg==”

Invoke-Expression $decrypted

Write-Host 'dfsdfsdf'

Enable-PSScriptBlockLogging
Enable-PSScriptBlockInvocationLogging

$crt = dir Cert:\LocalMachine\My -DocumentEncryptionCert

New-SelfSignedCertificate -Subject 'nyukers@sunhose.ua' -Type DocumentEncryptionCertLegacyCsp

$p = 'Its my favotire certficate' | Protect-CmsMessage -To '*nyukers@sunhose.ua*'
Get-CmsMessage $p
$p | Unprotect-CmsMessage

Enable-ProtectedEventLogging $crt
Disable-ProtectedEventLogging