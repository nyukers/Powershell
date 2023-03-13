Write-Host "Version of PS:"
$PSVersionTable.PSVersion

# Устанавливаем корневую папку           
$Root = "C:\PS\"            
# Переходим в неё           
Set-Location $Root      

# папки PS
Write-Host ""
Write-Host "Root folder  :" $Root
Write-Host "Home folder  :" $Home
Write-Host "PsHome folder:" $PsHome
Write-Host "My Profile   :" $Profile
Write-Host "Path to modules:" $env:PSModulePath
Write-Host ""

#[Console]::outputEncoding
chcp
[Console]::outputEncoding = [System.Text.Encoding]::GetEncoding('cp866')
chcp

Function StartTranscript {
	$TranScriptFolder = $($(Split-Path $profile) + '\TranscriptLog\')
	if (!(Test-Path -Path $TranScriptFolder )) { New-Item -ItemType directory -Path $TranScriptFolder }
	Start-Transcript -Append ($($TranScriptFolder + $(get-date -format 'yyyyMMdd-HHmmss') + '.txt')) -ErrorVariable Transcript -ErrorAction stop
                         }
#StartTranscript

