#requires -version 2.0

<#
 Find unlinked GPOs. This requires the Active Directory Module
 This version does not query for site links
 #>

Import-Module ActiveDirectory,GroupPolicy

#GUID regular expression pattern
[Regex]$RegEx = "(([0-9a-fA-F]){8}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){12})"

#create an array of distinguishednames
$dn=@()
$dn+=Get-ADDomain | select -ExpandProperty DistinguishedName
$dn+=Get-ADOrganizationalUnit -filter * | select -ExpandProperty DistinguishedName

$links=@()

#get domain and OU links
    
foreach ($container in $dn) {

    #pull the GUID and add it to the array of links

    get-adobject -identity $container -prop gplink | 
    where {$_.gplink} | Select -expand gplink | foreach {
      
      #there might be multiple GPO links so split 
            
      foreach ($item in ($_.Split("]["))) {
        $links+=$regex.match($item).Value
      } #foreach item
    } #foreach
} #foreach container

#$links

<#
 get all gpos where the ID doesn't belong to the array
 write the GPO to the pipeline
#>

Get-GPO -All | Where {$links -notcontains $_.id} 
