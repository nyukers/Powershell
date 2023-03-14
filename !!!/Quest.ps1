# с помощью этого скрипта вы сможете найти нужное слово среди файлов всех форматов

$path = "c:\tmp"

$files = Get-Childitem $path -Include *.docx,*.doc,*.txt,*.pdf,*.docm,*.dot,*.dotx,*.rtf,*.xml,*.csv,*.xls,*.xlsx -Recurse | Where-Object { !($_.psiscontainer) }

$application = New-Object -comobject Word.Application
$application.visible = $False
$findtext = "Мама" #regex

Function getStringMatch
{

Foreach ($file In $files) {
$file
$document = $application.documents.open($file.FullName,$false,$true)
$arrContents = $document.content.text.split()
$varCounter = 0
    ForEach ($line in $arrContents) {
        $varCounter++
        If($line -match $findtext) {
            "Found $file"
            }
        }
        $document.close()
    }
$application.quit() 
}

getStringMatch
