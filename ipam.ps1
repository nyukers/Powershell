Install-WindowsFeature IPAM -IncludeManagementTools

Set-IpamConfiguration -ProvisioningMethod Automatic -GpoPrefix IPAM

Invoke-IpamGpoProvisioning -Domain forza.com -GpoPrefixName IPAM
Invoke-IpamGpoProvisioning –Domain forza.com –GpoPrefixName IPAM –DelegatedGpoUser Administrator –IpamServerFqdn srv-ipam.forza.com