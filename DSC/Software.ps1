Import-DSCResource –ModuleName PSDesiredStateConfiguration 

configuration Software {

    param (
        [String[]]$Server=$env:computerName
    )
 
    Node $Server {
 
        File SetupFile {
 
            Ensure          = "present"
            SourcePath      = "F:\Setup.exe"
            DestinationPath = "C:\Temp"
            Type            = "File"
 
        }
    }
}
 
Software -Server ("srv01","srv02")