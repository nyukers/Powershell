function Get-FileContents
 {
     [CmdletBinding()]
     param
     (
         [Parameter(Mandatory)]
         [ValidateNotNullOrEmpty()]
         [string]$Path
     )
     
     if (Test-Path -Path $Path -PathType Leaf)
     {
         Get-Content -Path $Path
     }
     else
     {
         Add-Content -Path $Path -Value 'something in here'
         Get-Content -Path $Path
     }
 }

describe 'Get-FileContents' {
     it 'creates a file then reads if the file does not exist' {
         mock -CommandName 'Test-Path' –MockWith {
             return $false  
         }
         mock -CommandName 'Get-Content' –MockWith {
             return $null
         }
         mock -CommandName 'Add-Content' –MockWith {
             return $null
         }
         Get-FileContents –Path 'F:\tmp\HomeFolders\1.txt'
         Assert-MockCalled –CommandName 'Get-Content' –Times 1 –Scope It
         Assert-MockCalled –CommandName 'Add-Content' –Times 1 –Scope It
     }
     it 'only reads the file if it already exists' {
         mock -CommandName 'Test-Path' –MockWith {
             return $true            
         }
         mock -CommandName 'Get-Content' –MockWith {
             return $null
         } 
         Get-FileContents –Path 'F:\tmp\HomeFolders\1.txt'
         Assert-MockCalled –CommandName 'Get-Content' –Times 1 –Scope It
     }
 }