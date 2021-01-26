# PullClientConfig by Names

[DSCLocalConfigurationManager()]
configuration PullClientConfigNames
{
    Node localhost
    {
        Settings
        {
            RefreshMode = 'Pull'
            RefreshFrequencyMins = 30
            RebootNodeIfNeeded = $true
        }
        ConfigurationRepositoryWeb log01.forza.com
        {
            ServerURL = 'https://log01.forza.com:8080/PSDSCPullServer.svc'
            RegistrationKey = 'b0cad761-d079-4bdc-83c8-f9f68e8bd041'
            ConfigurationNames = @('GenericConfig')
        }

        ReportServerWeb log01.forza.com
        {
            ServerURL = 'https://log01.forza.com:8080/PSDSCPullServer.svc'
            RegistrationKey = 'b0cad761-d079-4bdc-83c8-f9f68e8bd041'
        }
    }
}

PullClientConfigNames

Set-DSCLocalConfigurationManager –ComputerName localhost –Path .\PullClientConfigNames –Verbose -Force

Get-DSCLocalConfigurationManager 

# AgentID = '330CD891-45E4-11EB-8517-B88584B86E93'
# https://log01.forza.com:8080/PSDSCPullServer.svc/Nodes(AgentId='330CD891-45E4-11EB-8517-B88584B86E93')/Reports

Update-DSCConfiguration -ComputerName localhost

Test-DSCConfiguration


# PullClientConfig by ID

[System.Guid]::NewGuid()

[DSCLocalConfigurationManager()]
configuration PullClientConfigID
{
    Node localhost
    {
        Settings
        {
            RefreshMode = 'Pull'
            ConfigurationID = '1d545e3b-60c3-47a0-bf65-5afc05182fd0'
            RefreshFrequencyMins = 30
            RebootNodeIfNeeded = $true
        }

        ConfigurationRepositoryWeb log01.forza.com
        {
            ServerURL = 'https://log01.forza.com:8080/PSDSCPullServer.svc'
        }

        ResourceRepositoryWeb log01.forza.com
        {
            ServerURL = 'https://log01.forza.com:8080/PSDSCPullServer.svc'
        }

        ReportServerWeb log01.forza.com
        {
            ServerURL = 'https://log01.forza.com:8080/PSDSCPullServer.svc'
        }
                
    }
}

PullClientConfigID

Set-DSCLocalConfigurationManager –ComputerName localhost –Path .\PullClientConfigID –Verbose
