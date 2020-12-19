$ConfigurationData = @{ 
    AllNodes = @(
        @{NodeName = 'GOVERLA01';FileText='Configuration for Role 1'},
        @{NodeName = 'GOVERLA';FileText='Configuration for Role 2'}
    )
    }

Configuration AddFile {

Import-DscResource –ModuleName PSDesiredStateConfiguration

    Node $AllNodes.NodeName { 
        File TestFile {
        Ensure = 'Present'
        Type = 'File'
        DestinationPath = 'C:\TestFolder\TestFile1.txt'
        Contents = $Node.FileText 
        Force = $true
                    }
    }
}

#AddFile -OutputPath c:\VM\shared\PS\DSC -ConfigurationData $ConfigurationData 
