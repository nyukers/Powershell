describe 'New VM test' {
     it 'creates a new VM' {
         
         if (Get-Item -Path "F:\tmp\HomeFolders\") 
 {
             Set-TestInconclusive –Message "The test VM name MYVM already exists."
         } 
 else 
 {
             ## Execute the script to create the VM
 .\NewVMScript.ps1 –Name MYVM
         
         ## Check to see if the VM was created
             Get-Item -Path "F:\tmp\HomeFolders\" | should not be $null
         }
     }
 }

#Get-Item -Path "F:\tmp\HomeFolders\"