$str1 = Get-VMHost | Select @{Name="Host";Expression={$_.Name +'.'+ $_.FullyQualifiedDomainName}},@{label='Host RAM(GB)';expression={$_.MemoryCapacity/1gb -as [int]}}

$str2 = Get-VM | Select Name,State,notes

$str3 = Get-VM | Select-Object Name, @{Name="Dynamic Memory";Expression={$_.DynamicMemoryEnabled}},
@{label='Start RAM(GB)';expression={$_.MemoryStartup/1gb -as [int]}}, 
@{label='Min RAM(GB)';expression={$_.MemoryMinimum/1gb -as [int]}}, 
@{label='Max RAM(GB)';expression={$_.MemoryMaximum/1gb -as [int]}}, 
@{label='Assign RAM(GB)';expression={$_.MemoryAssigned/1gb -as [int]}} `
| Sort Name  

$str4 = Get-VM | Select-Object Name,VMId | Get-VHD | select vhdtype,vhdformat,path,@{label='Size VHD(GB)';expression={$_.filesize/1gb -as [int]}} | Sort Name

$str5 = Get-VM | get-vmnetworkadapter | Select-Object @{Name="Name";Expression={$_.VMName}},@{Name="Status";Expression={$_.Status}},MacAddress,SwitchName,@{Name="IP";Expression={$_.IPAddresses}} | Sort Name 

$str6 = Get-VMNetworkAdapterVlan | Select OperationMode,AccessVlanId 

$Hyper = $env:computername
$filename1 =  'd:\' + $Hyper + '.csv'
$str0 = '"Host","Host RAM(GB)","Name","State","Notes","Dynamic Memory","Start RAM(GB)","Min RAM(GB)","Max RAM(GB)","Assign RAM(GB)","vhdtype","vhdformat","Size VHD(GB)","path","IP","MacAddress","SwitchName","OperationMode","AccessVlanId","Status"'

$str0 | Out-File $filename1 -Encoding UTF8
$str1 | Export-Csv $filename1 -Append -Force -Encoding UTF8
$str2 | Export-Csv $filename1 -Append -Force -Encoding UTF8
$str3 | Export-Csv $filename1 -Append -Force -Encoding UTF8
$str4 | Export-Csv $filename1 -Append -Force -Encoding UTF8
$str5 | Export-Csv $filename1 -Append -Force -Encoding UTF8
$str6 | Export-Csv $filename1 -Append -Force -Encoding UTF8



########

Get-VM | where { $_.state -eq 'running'} | get-vmnetworkadapter | Select VMName,SwitchName,@{Name="IP";Expression={$_.IPAddresses | where {$_ -match "^10."}}} | Sort VMName

Get-VM | get-vmnetworkadapter | Select VMName,SwitchName,@{Name="IP";Expression={$_.IPAddresses | where {$_ -match "^10."}}} | Sort VMName

$VMs = Get-VM | Select-Object Name

Foreach ($Names in $VMs) {

$Dynamic = Get-VM -Name $Names.Name | Select DynamicMemoryEnabled

    if ($Dynamic -like "*False*"){
    Get-VM -Name $Names.Name | Select-Object Name,State,ProcessorCount,DynamicMemoryEnabled,
    @{label='Start RAM(GB)';expression={$_.MemoryStartup/1gb -as [int]}}, 
    @{label='Min RAM(GB)';expression={0 -as [int]}}, 
    @{label='Max RAM(GB)';expression={0 -as [int]}}, 
    @{label='Assign RAM(GB)';expression={$_.MemoryAssigned/1gb -as [int]}} `
    | ft
    }
    else {
    Get-VM -Name $Names.Name | Select-Object Name,State,ProcessorCount,DynamicMemoryEnabled,
    @{label='Start RAM(GB)';expression={$_.MemoryStartup/1gb -as [int]}}, 
    @{label='Min RAM(GB)';expression={$_.MemoryMinimum/1gb -as [int]}}, 
    @{label='Max RAM(GB)';expression={$_.MemoryMaximum/1gb -as [int]}}, 
    @{label='Assign RAM(GB)';expression={$_.MemoryAssigned/1gb -as [int]}} `
    | ft
    }
}
