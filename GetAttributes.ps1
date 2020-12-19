#get-aduser Admin.EA -properties *|select name,UserAccountControl | ft
#Get-ADUser -Properties * -ldapFilter "(useraccountcontrol=66048)"

Function ConvertUserAccountControl ([int]$UAC)
{
$UACPropertyFlags = @(
"SCRIPT",
"ACCOUNTDISABLE",
"RESERVED",
"HOMEDIR_REQUIRED",
"LOCKOUT",
"PASfoxaD_NOTREQD",
"PASfoxaD_CANT_CHANGE",
"ENCRYPTED_TEXT_PWD_ALLOWED",
"TEMP_DUPLICATE_ACCOUNT",
"NORMAL_ACCOUNT",
"RESERVED",
"INTERDOMAIN_TRUST_ACCOUNT",
"WORKSTATION_TRUST_ACCOUNT",
"SERVER_TRUST_ACCOUNT",
"RESERVED",
"RESERVED",
"DONT_EXPIRE_password",
"MNS_LOGON_ACCOUNT",
"SMARTCARD_REQUIRED",
"TRUSTED_FOR_DELEGATION",
"NOT_DELEGATED",
"USE_DES_KEY_ONLY",
"DONT_REQ_PREAUTH",
"password_EXPIRED",
"TRUSTED_TO_AUTH_FOR_DELEGATION",
"RESERVED",
"PARTIAL_SECRETS_ACCOUNT"
"RESERVED"
"RESERVED"
"RESERVED"
"RESERVED"
"RESERVED"
)
$Attributes = ""
0..($UACPropertyFlags.Length) | Where-Object {$UAC -bAnd [math]::Pow(2,$_)} | ForEach-Object {If ($Attributes.Length -EQ 0) {$Attributes = $UACPropertyFlags[$_]} Else {$Attributes = $Attributes + " | " + $UACPropertyFlags[$_]}}
Return $Attributes
}

#ConvertUserAccountControl 66050

get-aduser Admin.EA -properties *|select @{n='UserAcc_Attributes';e={ConvertUserAccountControl($_.userAccountControl)}}
