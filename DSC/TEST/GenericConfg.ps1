Configuration GenericConfig {

Import-DscResource –ModuleName PSDesiredStateConfiguration

    Node localhost {

        File TestFile {
        Ensure = 'Present'
        Type = 'File'
        DestinationPath = 'C:\TestFolder\TestFile934.txt'
        Contents = 'Impreza Alba'
        Force = $true
        }
    }
}

GenericConfig

New-DscChecksum -Path '.\' -Force