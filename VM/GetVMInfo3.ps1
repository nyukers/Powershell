$Hyper = $env:computername
$filename1 =  'd:\' + $Hyper + '.csv'
$str0 = '"Host","Host RAM(GB)","Name","State","Notes","Dynamic Memory","Start RAM(GB)","Min RAM(GB)","Max RAM(GB)","Assign RAM(GB)","vhdtype","vhdformat","Size VHD(GB)","path","IP","MacAddress","SwitchName","OperationMode","AccessVlanId","Status"'
$str0 | Out-File $filename1 -Encoding UTF8

##########
$str1 = Get-VMHost | Select @{Name="Host";Expression={$_.Name +'.'+ $_.FullyQualifiedDomainName}},@{label='Host RAM(GB)';expression={$_.MemoryCapacity/1gb -as [int]}}
$str2 = Get-VM | Select Name,State,notes

$str3 = Get-VM | Select-Object @{Name="DynamicMemory";Expression={$_.DynamicMemoryEnabled}},
@{label='StartRAM';expression={$_.MemoryStartup/1gb -as [int]}}, 
@{label='MinRAM';expression={$_.MemoryMinimum/1gb -as [int]}}, 
@{label='MaxRAM';expression={$_.MemoryMaximum/1gb -as [int]}}, 
@{label='AssignRAM';expression={$_.MemoryAssigned/1gb -as [int]}} `
| Sort Name  

$str4 = Get-VM | Select-Object Name,VMId | Get-VHD | select vhdtype,vhdformat,path,@{label='Size';expression={$_.filesize/1gb -as [int]}} | Sort Name
$str5 = Get-VM | get-vmnetworkadapter | Select-Object @{Name="Name";Expression={$_.VMName}},@{Name="Status";Expression={$_.Status}},MacAddress,SwitchName,@{Name="IP";Expression={$_.IPAddresses}} | Sort Name 
$str6 = Get-VMNetworkAdapterVlan | Select OperationMode,AccessVlanId

$str1 | Export-Csv $filename1 -Append -Force -Encoding UTF8

$i = 0
foreach ($item in $str6)
{ 
    $out = $str6[$i] | Select OperationMode,AccessVlanId, @{Label="Name";Expression={($str2).Name[$i]}}, @{Label="State";Expression={($str2).State[$i]}}, @{Label="Notes";Expression={($str2).notes[$i]}}, `
    @{Label="vhdtype";Expression={($str4).vhdtype[$i]}}, @{Label="vhdformat";Expression={($str4).vhdformat[$i]}},@{Label="Size VHD(GB)";Expression={($str4).size[$i]}},@{Label="Path";Expression={($str4).path[$i]}}, `
    @{Label="status";Expression={($str5).status[$i]}}, @{Label="MacAddress";Expression={($str5).MacAddress[$i]}},@{Label="IP";Expression={($str5).IP[$i]}},@{Label="Switchname";Expression={($str5).Switchname[$i]}},`
    @{Label="Dynamic Memory";Expression={($str3).DynamicMemory[$i]}},@{Label="Start RAM(GB)";Expression={($str3).StartRAM[$i]}},@{Label="Min RAM(GB)";Expression={($str3).MinRAM[$i]}},`
    @{Label="Max RAM(GB)";Expression={($str3).MaxRAM[$i]}},@{Label="Assign RAM(GB)";Expression={($str3).AssignRAM[$i]}}

    $out | Export-Csv $filename1 -Append -Force -Encoding UTF8
    $i++
}

