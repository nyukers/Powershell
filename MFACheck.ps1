Param(
[parameter(mandatory=$false)]$User,
[switch]$AllMFAConditional,
[switch]$AllMFAPortal
)
#Autocomplete
$User = $User + "@nyukers.onmicrosoft.com"
$vPath = (Get-Location).Path + "\"
 
If ($AllMFAConditional){
$vUser = Get-MSOLUser -All | Where {$_.StrongAuthenticationMethods -ne $null }
Write-Host
Write-Host "Number of users with MFA (Conditional) enabled: " $vUser.count
Write-Host
Write-Host "List of all users configured with MFA (Conditional).."
Write-Host
$vUser | % { Write-Host $_.DisplayName "-" $_.UserPrincipalName}
Write-Host
break
}
If ($AllMFAPortal){
$vUser = Get-MsolUser -all | where-Object { $_.StrongAuthenticationRequirements.State -ne $null }
Write-Host
Write-Host "Number of users with MFA (Portal) enabled: " $vUser.count
Write-Host
Write-Host "List of all users configured with MFA (Portal).."
write-host
$vUser | % { Write-Host $_.DisplayName "-" $_.UserPrincipalName}
Write-host
break
}
$vUser = Get-MsolUser -UserPrincipalName $User -ErrorAction SilentlyContinue
If ($vUser) {
Write-Host
Write-Host User Details for $vUser.UserPrincipalName
Write-Host
Write-Host "Self-Service Password Feature (SSP)..: " -NoNewline;
If ($vUser.StrongAuthenticationUserDetails) {  Write-Host -ForegroundColor Green "Enabled"}Else{ Write-Host -ForegroundColor Yellow "Not Configured"}
Write-Host "MFA Feature (Portal) ................: " -NoNewline;
If ((($vuser | Select-Object -ExpandProperty StrongAuthenticationRequirements).State) -ne $null) { Write-Host -ForegroundColor Yellow "Enabled! It overrides Conditional"}Else{ Write-Host -ForegroundColor Green "Not Configured"}
Write-Host "MFA Feature (Conditional)............: " -NoNewline;
If ($vUser.StrongAuthenticationMethods){
Write-Host -ForegroundColor Green "Enabled"
Write-Host
Write-host "Authentication Methods:"
for ($i=0;$i -lt $vuser.StrongAuthenticationMethods.Count;++$i){
Write-host $vUser.StrongAuthenticationMethods[$i].MethodType "(" $vUser.StrongAuthenticationMethods[$i].IsDefault ")"
}
Write-Host
Write-Host "Phone entered by the end-user:"
Write-Host "Phone Number.........: " $vuser.StrongAuthenticationUserDetails.PhoneNumber
Write-Host "Alternative Number...: "$vuser.StrongAuthenticationUserDetails.AlternativePhoneNumber
}Else{
Write-Host -ForegroundColor Yellow "Not Configured"
}
Write-Host
Write-Host "License Requirements.................: " -NoNewline;
$vLicense = $False
for ($i=0;$i -lt $vuser.Licenses.Count;++$i){
if (($vuser.licenses[$i].AccountSkuid) -like '*P1*') { $vLicense = $true }
}
If ($vLicense){Write-Host -ForegroundColor Green "Enabled"}Else{ Write-Host -ForegroundColor Yellow "Not Licensed"}
}Else{
write-host
write-host -ForegroundColor Red "[Error]: User " $user " couldn't be found. Check the username and try again"
Break
}