import-module activedirectory

$ADForestRootDomain = (Get-ADForest).RootDomain
$AllADForestDomains = (Get-ADForest).Domains
$ForestKRBTGTInfo = @()

ForEach ($AllADForestDomainsItem in $AllADForestDomains)
{
[string]$DomainDC = (Get-ADDomainController -Discover -Force -Service “PrimaryDC” -DomainName $AllADForestDomainsItem).HostName
[array]$ForestKRBTGTInfo += Get-ADUSer -filter {name -like “krbtgt*”} -Server $DomainDC -Prop Name,Created,logonCount,Modified,PasswordLastSet,PasswordExpired,msDS-KeyVersionNumber,CanonicalName,msDS-KrbTgtLinkBl
}
$ForestKRBTGTInfo | Select Name,Created,logonCount,PasswordLastSet,PasswordExpired,msDS-KeyVersionNumber,CanonicalName | ft -auto