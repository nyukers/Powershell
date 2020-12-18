Import-Module ActiveDirectory
Import-Module GroupPolicy
#$dc = Get-ADDomainController -Discover -Service PrimaryDC
#Get-GPOReport -All -Domain forza.com -Server $dc -ReportType HTML -Path d:\Tmp\GPOReportsAll.html

Backup-GPO -All -Path "d:\tmp"

Get-GPO -All | % {$_.GenerateReport('xml') | Out-File "d:\tmp\$_.DisplayName.xml"}


# Создаем cписок всех политик
Get-GPO -all | where {-not $_.description} | select displayname, description | Export-CSV D:\GPOModReport.csv
Get-GPO -all | select displayname, description

# Создаем для каждого объекта групповых политик свой отчет
Get-GPO -all | foreach { 
 $f="{0}.htm" -f ($_.Displayname).Replace(" ","_")
 $htmfile=Join-Path -Path "d:\tmp" -ChildPath $f
 Get-GPOReport -Name $_.Displayname -ReportType HTML -Path $htmfile
 #Get-Item $htmfile 
}


# что было изменено за последние 30 дней
Get-GPO -all | Where {$_.ModificationTime -gt (Get-Date).AddDays(-30)} | `
Sort ModificationTime -Descending | Where {$_.ModificationTime -ge (Get-Date).AddDays(-30)} | Select Displayname,ModificationTime,Description


Get-GPO -all | Sort GPOStatus | format-table -GroupBy GPOStatus Displayname,*Time
Get-GPO -all | where {$_.GPOStatus -match "disabled"} | Select GPOStatus,Displayname
Get-GPO -all | where {$_.GPOStatus -match "AllSettingsDisabled"}

# не залинкованные политики
Get-ADOrganizationalUnit -filter * | select-object
-ExpandProperty DistinguishedName | get-adobject 
-prop gplink | where {$_.gplink} | Select-object 
-expand gplink | foreach-object { 
foreach ($item in ($_.Split("]["))) {
$links+=$regex.match($item).Value
   } 
} 
Get-GPO -All | Where {$links -notcontains $_.id}