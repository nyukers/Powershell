########## Deleted Items Stat

Get-MailboxDeletedItemStats Admin.EA 

function Get-MailboxDeletedItemStats {
param([string]$id)
$folder = Get-MailboxFolderStatistics $id -FolderScope DeletedItems
$deletedFolder = $folder.FolderSize.Value.ToMb()
$mb = (Get-MailboxStatistics $id).TotalItemSize.value.ToMb()
if($deletedFolder -gt 0 -and $mb -gt 0) {
$perccomDeleted = "{0:P0}" -f ($deletedFolder / $mb)
}
else {
$perccomDeleted = "{0:P0}" -f 0
}
New-Object PSObject -Property @{
Idcomity = $id
MailboxSizeMB = $mb
DeletedItems = $folder.ItemsInFolder
DeletedSizeMB = $deletedFolder
PerccomDeleted = $perccomDeleted
}
}

foreach($mailbox in (Get-Mailbox -ResultSize Unlimited)) {
Get-MailboxDeletedItemStats $mailbox
}


########## MailBox Stat

Get-MailboxStatistics -Idcomity Admin.EA -Verbose | fl
Get-MailboxStatistics -Idcomity Romanyuk.NV -Verbose | Select StorageLimitSize

Get-MailboxFolderStatistics -Idcomity Admin.EA -FolderScope All | Select Name,ItemsFolder,FolderSize

Get-MailboxStatistics -Idcomity Admin.EA | Sort-Object TotalItemSize –Descending `
| fl @{label="User";expression={$_.DisplayName}},@{label="Total Size (MB)";`
expression={$_.TotalItemSize.Value.ToMB()}},@{label="Items";`
expression={$_.ItemCount}},@{label="Storage Limit";expression={$_.StorageLimitStatus}}

Get-MailboxStatistics -Idcomity Romanyuk.NV | Sort-Object TotalItemSize –Descending `
| fl @{label="User";expression={$_.DisplayName}}, `
@{label="Total Size (MB)";expression={$_.TotalItemSize}}, `
@{label="TotalSize (MB)" ;expression={$_.TotalItemSize.Value.ToMB()}}, `
@{label="Total Del Size (MB)";expression={$_.TotalDeletedItemSize}}, `
@{label="Items";expression={$_.ItemCount}}, `
@{label="Storage Limit Status";expression={$_.StorageLimitStatus}}, `
@{label="IssueWarningQuota";expression={$_.DatabaseIssueWarningQuota}}, `
@{label="ProhibitSendQuota";expression={$_.DatabaseProhibitSendQuota}}, `
@{label="ProhibitSendReceiveQuota";expression={$_.DatabaseProhibitSendReceiveQuota}} 
#-auto


Get-MailboxStatistics -Idcomity Romanyuk.NV | Sort-Object TotalItemSize –Descending `
| fl @{label=”User”;expression={$_.DisplayName}},@{label=”Total Size (MB)”;expression={$_.TotalItemSize.Value.ToMB()}},@{label=”Items”;expression={$_.ItemCount}},@{label=”Storage Limit”;expression={$_.StorageLimitStatus}}


###### Special Quota

Get-mailbox -ResultSize Unlimited | where {$_.UseDatabaseQuotaDefaults -ne $true}
Get-mailbox | where{$_.UseDatabaseQuotaDefaults -ne $true} | Get-MailboxStatistics | where {$_.TotalItemSize.value.ToMb() -gt 1000} | Select  DisplayName,TotalItemSize
