describe 'IIS' {
    context 'Windows features' {
        it 'installs the Web-Server Windows feature' {
            $parameters = @{
                ComputerName = 'GOVERLA'
                Name = 'Appinfo'
            }
            (Get-Service @parameters).Status | should be Running
        }
    }
}


#(Get-Service -ComputerName GOVERLA -Name Appinfo).Status

# Call it:
# Invoke-Pester -Path C:\VM\shared\PS\!!!\T1.ps1
