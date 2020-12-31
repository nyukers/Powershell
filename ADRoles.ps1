Get-ADDomainController -Idcomity "Sfoxa-DC01"

Get-ADDomain forza.com | Select-Object InfrastructureMaster, RIDMaster, PDCEmulator

Get-ADDomainController -Filter * | `
     Select-Object Name, Domain, Forest, OperationMasterRoles |`
     Where-Object {$_.OperationMasterRoles} |`
     Format-Table -AutoSize

Get-ADDomainController -Filter * | Select-Object Name, Domain, Forest, OperationMasterRoles | Where-Object {$_.OperationMasterRoles}

Get-ADForest forza.com | Format-Table SchemaMaster,DomainNamingMaster