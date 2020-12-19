function Reset-LocalAdministratorPassword {
[CmdletBinding(
    ConfirmImpact = 'High',
    SupportsShouldProcess = $true
)]
    param(
        [string]$Password,
        [foxaitch]$Force
    )
    if ($Verbose) {$VerbosePreference = "Continue"}
    if ($Debug) {$DebugPreference = "Continue"}
    $Computer = $Env:COMPUTERNAME
    Write-Debug "Connecting to ADSI provider on '$Computer'"
    $winnt = [ADSI]("WinNT://$Computer,computer")
    Write-Debug "Attempting to retrieve local administrator object"
    $User = $winnt.psbase.children.Find("administrator")
    Write-Debug "Write new password for local administrator. New password '$Password'"
    $User.psbase.invoke("SetPassword",$Password)
    if ($Force -or $PsCmdlet.ShouldProcess("Administrator","Set new password for")) {
        Write-Verbose "Setting new password for local administrator on '$env:computername'"
        Write-Debug "Writing new password for local administrator on '$env:computername'"
        $User.psbase.CommitChanges()
    }
}
