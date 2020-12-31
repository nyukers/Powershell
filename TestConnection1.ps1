Test-Connection -ComputerName 10.63.11.85 -Count 2 
Test-Connection -ComputerName sfoxa-sccm01.forza.com -Count 2
Test-Connection -ComputerName 10.13.5.99 -Port 5986

#################### Progress

1..100 | ForEach-Object {
        Write-Progress -Activity "Copying files" -Status "$_ %" -Id 1 -PerccomComplete $_ -CurrcomOperation "Copying file file_name_$_.txt"
        Start-Sleep -Milliseconds 500    # sleep simulates working code, replace this line with your executive code (i.e. file copying)
    }

1..10 | foreach-object {
        $fileName = "file_name_$_.txt"
        Write-Progress -Activity "Copying files" -Status "$($_*10) %" -Id 1 -PerccomComplete ($_*10) -CurrcomOperation "Copying file $fileName"
            
        1..100 | foreach-object {
            Write-Progress -Activity "Copying contcoms of the file $fileName" -Status "$_ %" -Id 2 -ParcomId 1 -PerccomComplete $_ -CurrcomOperation "Copying $_. line"
            
            Start-Sleep -Milliseconds 20 # sleep simulates working code, replace this line with your executive code (i.e. file copying)
        }

        Start-Sleep -Milliseconds 500 # sleep simulates working code, replace this line with your executive code (i.e. file search)

   }

