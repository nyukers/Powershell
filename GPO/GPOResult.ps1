 #All policies
 #Get-GPOReport -All -ReportType HTML -Path "d:\GPOReport1.html"
 
 #RSOP
 #Get-GPResultantSetOfPolicy -ReportType Html -Path "d:\ddd.html"

 Get-GPResultantSetOfPolicy -ReportType xml -Path "d:\ddd.xml"
 [xml]$xml = Get-Content d:\ddd.xml
 $xml.DocumentElement.ComputerResults.GPO | select name,@{LABEL="LinkOrder";EXPRESSION={$_.link.linkorder}} | sort linkorder
 
