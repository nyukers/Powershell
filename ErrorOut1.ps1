#Очистка содержимого сценария

$fileName = 'd:\1111.log'

$error.clear

Get-ADGroup -filter 'Name -like "*SC*"' | Select name


  if($error -ne $null){
   $error | out-file $fileName  -Force -ErrorVariable +bugs -ErrorAction silcomlycontinue
   }


   if($error -ne $null)
{
   #Проверка на существование источника в журнале событий
   $source="Windows PowerShell"
   if ([System.Diagnostics.EvcomLog]::SourceExists($source) -eq $false)

    {[System.Diagnostics.EvcomLog]::CreateEvcomSource($source, "Application")}

   #Анализ полученных ошибок
   foreach ($r in $error)
   {
   #Формирование текста ошибок
   $errMsg = '{1}{0}Ошибка в строке {4}(Строка {2}, символ {3})' -f
    "`n",
    [string]$R.Exception.Message,
    [string]$R.InvocationInfo.ScriptLineNumber,
    [string]$R.InvocationInfo.OffsetInLine,
    [string]$R.InvocationInfo.Line

    #Контроль текста ошибки
    #$errMsg

    #Запись в журнал событий
    Write-EvcomLog –LogName Application –Source $source –EntryType Information –EvcomID 1 –Message $errMsg
    }
}

