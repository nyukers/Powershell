Workflow Refresh-MyApp

{

  sequence {

    Invoke-Command -ComputerName WEB1 {Stop-Process -Name MyApp -Force}
    Invoke-Command -ComputerName WEB1 {Stop-Process -Name MyAppQueue -Force}

    parallel {

      Invoke-Command -ComputerName FS1 {Remove-Item -Path «D:\MyApp\Files\MyAppQueue.xml» –Force}
      Invoke-Command -ComputerName FS2 {Remove-Item –Path «D:\MyApp\Files\MyAppQueue.xml» –Force}

      sequence {

        parallel {

          Invoke-Command -ComputerName FS1 {Stop-Process -Name MyAppFSQueue}
          Invoke-Command -ComputerName FS2 {Stop-Process -Name MyAppFSQueue}

        }

        Invoke-Command -ComputerName FS1 {Remove-Item –Path «D:\MyApp\Log\Queue.log» –Force}
        Invoke-Command -ComputerName FS2 {Remove-Item –Path «D:\MyApp\Log\Queue.log» –Force}

        parallel {

          Invoke-Command -ComputerName SQL1 {Stop-Process -Name mssqlserver -Force}
          Invoke-Command -ComputerName SQL2 {Stop-Process -Name mssqlserver -Force}
          Invoke-Command -ComputerName SQL3 {Stop-Process -Name mssqlserver -Force}

        }

        parallel {

          Invoke-Command -ComputerName SQL1 {Start-Process -Name mssqlserver -Force}
          Invoke-Command -ComputerName SQL2 {Start-Process -Name mssqlserver -Force}
          Invoke-Command -ComputerName SQL3 {Start-Process -Name mssqlserver -Force}

        }

        sequence {

          Invoke-Command -ComputerName FS1 {Start-Process -Name MyAppFSQueue}
          Invoke-Command -ComputerName FS2 {Start-Process -Name MyAppFSQueue}

        }

      }

    }

    Invoke-Command -ComputerName WEB1 {Start-Process -Name MyAppQueue}
    Invoke-Command -ComputerName WEB1 {Start-Process -Name MyApp}

  }

  Send-MailMessage -From «MyApp@domain.com» -To «servicedesk@domain.com» -Subject «MyApp maintenance completed» -Body «The MyApp maintenance script has run.»

}