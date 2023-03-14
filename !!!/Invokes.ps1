'Get-Service bits' | Invoke-Expression

Invoke-Expression 'Get-Service bits'

Invoke-Command -ScriptBlock {
    Get-Process Chrome
}

Invoke-Expression -Command "Get-Process Chrome"

do{
    $Response = Read-Host "Please enter a process name"
    $RunningProcesses = Get-Process

    #Validate the user input here before proceeding
    if($Response -notin $RunningProcesses.Name){
        Write-Host "That process wasn't found, please try again.`n" #Avoid using $Response here
    }
} until ($Response -in $RunningProcesses.Name)

$Command = "Get-Process $Response"
Invoke-Expression $Command