Import-DSCResource –ModuleName PSDesiredStateConfiguration 

configuration Software {

    param (
        [String[]]$Server=$env:computerName
    )
 
    Node $Server {
 
        File SetupFile {
 
            Ensure          = "present"
            SourcePath      = "D:\test.cmd"
            DestinationPath = "D:\Reports"
            Type            = "File"
 
        }
    }
}
 
Software -Server ("srv01","srv02")