<#

.SYNOPSIS

Created by: https://ingogegenwarth.wordpress.com/
Version:	42 ("What do you get if you multiply six by nine?")
Changed:	17.07.2015

.LINK

http://blogs.technet.com/b/ashleymcglone/
http://blogs.msdn.com/b/powershell/archive/2014/05/29/how-to-retrieve-node-information-from-pull-server.aspx

.DESCRIPTION

The script will query the PSDSCComplianceServer component of a DSC pull server and returns the nodes status.

.PARAMETER PullServer

The name of the DSC pull server.

.PARAMETER Port

The port of the PSDSCComplianceServer component of a DSC pull server. The default is 9080

.EXAMPLE 

Get-NodeInformation.ps1 -PullServer 'fabpullsrv.fabrikam.local' -Port 9080
.NOTES
#>

Param (      
       [string]$PullServer,
       [int]$Port = "9080"
     )

function QueryNodeInformation
{
  Param (      
       [string] $Uri = "http://$($PullServer):$($Port)/PSDSCComplianceServer.svc/Status",                         
       [string] $ContentType = "application/json"           
     )

  Write-Host "Querying node information from pull server URI  = $Uri" -ForegroundColor Green

  Write-Host "Querying node status in content type  = $ContentType " -ForegroundColor Green

   $response = Invoke-WebRequest -Uri $Uri -Method Get -ContentType $ContentType -UseDefaultCredentials -Headers @{Accept = $ContentType}

   if($response.StatusCode -ne 200)
 {
     Write-Host "node information was not retrieved." -ForegroundColor Red
 }

 $jsonResponse = ConvertFrom-Json $response.Content

  return $jsonResponse
}

$StatusCode = @"

0 = Configuration was applied successfully

1 = Download Manager initialization failure

2 = Get configuration command failure

3 = Unexpected get configuration response from pull server

4 = Configuration checksum file read failure

5 = Configuration checksum validation failure

6 = Invalid configuration file

7 = Available modules check failure

8 = Invalid configuration Id In meta-configuration

9 = Invalid DownloadManager CustomData in meta-configuration

10 = Get module command failure

11 = Get Module Invalid Output

12 = Module checksum file not found

13 = Invalid module file

14 = Module checksum validation failure

15 = Module extraction failed

16 = Module validation failed

17 = Downloaded module is invalid

18 = Configuration file not found

19 = Multiple configuration files found

20 = Configuration checksum file not found

21 = Module not found

22 = Invalid module version format

23 = Invalid configuration Id format

24 = Get Action command failed

25 = Invalid checksum algorithm

26 = Get Lcm Update command failed

27 = Unexpected Get Lcm Update response from pull server

28 = Invalid Refresh Mode in meta-configuration

29 = Invalid Debug Mode in meta-configuration

"@

$hashStatusCode = ConvertFrom-StringData $StatusCode

$json = QueryNodeInformation

$nodes = $json.value

$nodes | Add-Member -MemberType ScriptProperty -Name HostName -Value {([System.Net.Dns]::GetHostEntry($this.targetname)).HostName}

$nodes | Add-Member -MemberType ScriptProperty -Name LastCompliance -Value {[datetime]$this.LastComplianceTime}

$nodes | Add-Member -MemberType ScriptProperty -Name LastHeartbeat -Value {[datetime]$this.LastHeartbeatTime}

$nodes | Add-Member -MemberType ScriptProperty -Name StatusMessage -Value {[string]$hashStatusCode[[string]$this.StatusCode]}

$nodes | select * -ExcludeProperty LastCompliance,LastCompliance