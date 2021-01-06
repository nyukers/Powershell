# Configure Local User Account with DSC
# https://jdhitsolutions.com/blog/powershell/3796/configure-local-user-account-with-dsc/

# requires -version 4.0
# requires -RunasAdministrator

param(
[Parameter(Position=0,Mandatory)]
[ValidatePattern("^CHI")]
[string[]]$Computername
)

Configuration LocalUserAccounts {

Param(
[Parameter(Position=0,Mandatory)]
[ValidatePattern("^CHI")]
[string[]]$Computername,
[Parameter(Position=1,Mandatory)]
[PScredential]$Password
)

Node $Computername {

User LocalAdmin {
    UserName="localadmin"
    Description="Local administrator account"
    Disabled=$False
    Ensure="Present"
    Password=$Password
}

# add the account to the Administrators group
Group Administrators {
    GroupName="Administrators"
    DependsOn="[User]LocalAdmin"
    MembersToInclude="localadmin"
}

} #node

} #end configuration

# create config data to allow plain text passwords
$ConfigData=@{AllNodes=$Null}

# initialize an array for node information
$nodes=@()
foreach ($computer in $computername) {
  #write-host "Adding $computer" -foreground green
  #define a hashtable for each computername and add to the nodes array
  $nodes+=@{
          NodeName = "$computer"
          PSDscAllowPlainTextPassword=$true
        }
}

# add the nodes to AllNodes
$ConfigData.AllNodes = $nodes 

# you will be prompted to enter a credential
Write-Host "Enter the credential for localadmin" -foregroundcolor green

# create the configurations
localuseraccounts $computername -configurationdata $configdata -OutputPath c:\scripts\LocalUserAccounts

# push it to the server
Start-DSCConfiguration -path c:\scripts\localuseraccounts