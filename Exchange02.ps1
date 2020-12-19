#Чтобы выгрузить список пользователей, которые не заходили в почтовый ящик более, чем год тому с выгрузкой в файл, то выполните
Get-MailboxStatistics "Admin.EA" | Sort LastLogonTime | ft DisplayName, ItemCount, LastLogonTime 

Get-Mailbox -resultsize unlimited | Get-MailboxStatistics |?{$_.LastLogonTime -lt (date).adddays(-365)} `
| ft DisplayName,ItemCount,LastLogonTime,LastLoggedOnUserAccount -auto | Out-File D:\OLD_mailbox.txt


#какие почтовые адреса были созданы вашей почтовой системе, например, за последние 30 дней, для этого выполните:
Get-Mailbox | Where-Object {$_.WhenCreated –ge ((Get-Date).Adddays(-30))} | ft name, servername | Out-File C:\scripts\New_Mailbox_30days_ago.txt

Get-Mailbox | Get-MailboxStatistics | ?{!$_.DisconnectDate} | Select-Object DisplayName,TotalItemSize

Get-Mailbox -Organization "foxa.com/Users/" -resultsize unlimited | sort Name | %{$Size=Get-MailboxStatistics $_.SamAccountName `
$_ | Select-object Name, SamAccountName, @{Name="Size";Expression={((($Size).TotalItemSize).value).toMB()+((($Size).TotalDeletedItemSize).value).toMB()}}} 
#| export-csv -encoding unicode -NoTypeInformation C:\scripts\mailbox.csv

# Как удалить «плохое» сообщение из всех почтовых ящиков сразу?
get-mailbox -OrganizationalUnit Forza.com -ResultSize unlimited | Search-Mailbox -SearchQuery Subject:'Re: It's my vacation!' -TargetMailbox TheDaisy@forza.com -TargetFolder Inbox –DeleteContcom

# Size of Mail DBs
Get-MailboxDatabase -Status | select-object Name,Server,DatabaseSize,Mounted

Get-DistributionGroupMember –idcomity Buh-Forza

New-ManagemcomRoleAssignmcom -User Admin.EA -Role "Mailbox Search”
Search-Mailbox -Idcomity Admin.EA -SearchQuery 'Subject:"Годовой отчет"'
