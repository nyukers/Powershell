function Get-VMIPAddresses {
<#
.SYNOPSIS
	Lists the IP addresses for a virtual machine.

.DESCRIPTION
	Lists the IP addresses for a virtual machine. Can optionally be limited to IPv4 or IPv6 addresses.

.PARAMETER Name
	The name of the virtual machine whose IP addresses you wish to retrieve. Cannot be used with VM.

.PARAMETER ComputerName
	The name of the host that contains the virtual machine whose IP addresses you wish to receive. Cannot be used with VM.

.PARAMETER VM
	The VM object whose IP addresses you wish to receive. Cannot be used with Name or ComputerName.

.PARAMETER Type
	"Any" shows all IP addresses.
	"IPv4" shows only IPv4 addresses.
	"IPv6" shows only IPv6 addresses.

.PARAMETER IgnoreAPIPA
	Skips 169.254.0.0/16 IPv4 addresses and fe80::/64 IPv6 addresses.

.OUTPUTS
	A string array of the virtual machine's IP addresses.

.NOTES
	Author: Eric Siron
	Copyright: (C) 2014 Altaro Software
	Version 1.0
	Authored Date: November 17, 2014

.LINK
	
Hyper-V and PowerShell: Get Hyper-V VM IP Addresses


.EXAMPLE
	C:\PS> .\Get-VMIPAddresses -Name svtest

	Description
	-----------
	Retrieves the IP addresses for the VM named svtest.

.EXAMPLE 
	C:\PS> .\Get-VMIPAddresses -Name svtest -ComputerName svhv2

	Description
	-----------
	Retrieves the IP addresses for the VM named svtest on host svhv2.

.EXAMPLE
	C:\PS> .\Get-VMIPAddresses -Name svtest -Type IPv6

	Description
	-----------
	Retrieves only the IPv6 addresses used by svtest.
#>

#requires -Version 3
#requires -Modules Hyper-V

[CmdletBinding()]
param
(
	[Alias("VMName")]
	[Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, ParameterSetName='ByName', Mandatory=$true, Position=1)]
	[String]$Name,

	[Alias("VMHost")]
	[Parameter(ValueFromPipelineByPropertyName=$true, Position=2, ParameterSetName='ByName')]
	[String]$ComputerName = $env:COMPUTERNAME,

	[Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, ParameterSetName='ByVM')]
	[Microsoft.HyperV.PowerShell.VirtualMachine]$VM,

	[Parameter(ValueFromPipelineByPropertyName=$true)]
	[ValidateSet("Any", "IPv4", "IPv6")]
	[String]$Type,

	[Parameter(ValueFromPipelineByPropertyName=$true)]
	[Switch]$IgnoreAPIPA=$false
)

BEGIN {
	New-Variable -Name DefaultType -Value "Any" -Option Constant # Change to IPv4 or IPv6 if desired
}

PROCESS {
	if([String]::IsNullOrEmpty($Type))
	{
		$Type = $DefaultType
	}
	if($VM)
	{
		$ParameterSet = @{ 'VM'=$VM }
	}
	else
	{
		$ParameterSet = @{ 'VMName'="$Name"; 'ComputerName'="$ComputerName" }
	}
	$IPAddresses = (Get-VMNetworkAdapter @ParameterSet).IPAddresses
	switch($Type)
	{
		"IPv4" {
			$IPAddresses = $IPAddresses | where { $_ -match "\." }
		}
		"IPv6" {
			$IPAddresses = $IPAddresses | where { $_ -match ":" }
		}
	}
	if($IgnoreAPIPA)
	{
		$IPAddresses = $IPAddresses | where { $_ -notmatch "^(169.254)|(fe80)" }
	}
	$IPAddresses
}

END {}

}

Get-VMIPAddresses -ComputerName ssw-hv06.sw.ukrenergo.ent -Name SSW-Audit01-10.13.3.119