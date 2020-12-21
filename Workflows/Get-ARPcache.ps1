Workflow Get-ARPCache {
$data = InlineScript {
  $results = "arp -a" 
  } #inlinescript
$data 
} #workflow

Get-ARPCache -Verbose

workflow Test-MyWorkflow {
   get-service -name win*
   start-sleep -seconds 10
   get-process -name powershell*
}

Test-MyWorkflow