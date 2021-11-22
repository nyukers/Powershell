param(
     [Parameter()]
     [string]$Username,
     [Parameter()]
     [string]$HomeFolderPath
 )
# New-LocalUser –Name $Username
 New-Item –Path $HomeFolderPath –ItemType Directory
