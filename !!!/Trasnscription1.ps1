function Enable-PSTranscription

{

 [CmdletBinding()]

 param(

 $OutputDirectory,

 [Switch] $IncludeInvocationHeader

 )

 ## Ensure the base path exists

 $basePath = “HKLM:\Software\Policies\Microsoft\Windows\PowerShell\Transcription”

 if(-not (Test-Path $basePath))

 {

 $null = New-Item $basePath -Force

 }

 ## Enable transcription

 Set-ItemProperty $basePath -Name EnableTranscripting -Value 1

 ## Set the output directory

 if($PSCmdlet.MyInvocation.BoundParameters.ContainsKey(“OutputDirectory”))

 {

 Set-ItemProperty $basePath -Name OutputDirectory -Value $OutputDirectory

 }

## Set the invocation header

 if($IncludeInvocationHeader)

 {

 Set-ItemProperty $basePath -Name IncludeInvocationHeader -Value 1

 }

}

function Disable-PSTranscription

{

 Remove-Item HKLM:\Software\Policies\Microsoft\Windows\PowerShell\Transcription -Force -Recurse

}

################################################

function Enable-PSScriptBlockLogging

{

 $basePath = “HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging”

 if(-not (Test-Path $basePath))

 {

 $null = New-Item $basePath -Force

 }

 Set-ItemProperty $basePath -Name EnableScriptBlockLogging -Value “1”

}

function Disable-PSScriptBlockLogging

{

 Remove-Item HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging -Force -Recurse

}


function Enable-PSScriptBlockInvocationLogging

{

 $basePath = “HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging”


 if(-not (Test-Path $basePath))

 {

 $null = New-Item $basePath -Force

 }

 Set-ItemProperty $basePath -Name EnableScriptBlockInvocationLogging -Value “1”

}

##################################### Cryptographic Message Syntax (CMS)

function Enable-ProtectedEventLogging

{

 param(

 [Parameter(Mandatory)]

 $Certificate

 ) 

 $basePath = “HKLM:\Software\Policies\Microsoft\Windows\EventLog\ProtectedEventLogging”

 if(-not (Test-Path $basePath))

 {

 $null = New-Item $basePath –Force

 } 

Set-ItemProperty $basePath -Name EnableProtectedEventLogging -Value “1”

Set-ItemProperty $basePath -Name EncryptionCertificate -Value $Certificate 

} 

function Disable-ProtectedEventLogging

{

 Remove-Item HKLM:\Software\Policies\Microsoft\Windows\EventLog\ProtectedEventLogging -Force –Recurse

}