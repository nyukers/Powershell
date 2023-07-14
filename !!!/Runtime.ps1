. .\!!!\CMDB.ps1
Get-CMDBInfo -Path2File 'c:\tmp\'

# ImportExcel module must be instaled one time.
Install-Module ImportExcel -Scope CurrentUser -force

# File booker.xlsx must be offline in Excel before!
Import-csv -Path 'c:\tmp\_paragon.csv' | Export-Excel -Path 'c:\tmp\booker.xlsx' -AutoSize -WorksheetName Sheet1 -Append -Show

UnInstall-Module ImportExcel -force
