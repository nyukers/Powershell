<#
.Synopsis
Get-CurrentCPUTemperature uses the MSAcpi_ThermalZoneTemperature class to return the current CPU temperature.
Vasken Houdoverdov
 
.Parameter Celsius
Return current temperature as Celsius
 
.Parameter Fahrenheit
Return current temperature as Fahrenheit
 
.Parameter Kelvin
Return current temperature as Kelvin
 
.Description
Get-CurrentCPUTemperature uses the MSAcpi_ThermalZoneTemperature class to return the current CPU temperature. Specify temperature unit using the parameters -Celsius, -Fahrenheit, and/or -Kelvin.
 
.Example
Get-CurrentCPUTemperature -Celsius
 
.Example
Get-CurrentCPUTemperature -Fahrenheit
 
.Example
Get-CurrentCPUTemperature -Kelvin
 
.Example
Get-CurrentCPUTemperature -Celsius -Kelvin -Fahrenheit
#>

function Get-CurrentCPUTemperature
{
    [CmdletBinding()]
    param(
        [Switch]$Celsius,
        [Switch]$Fahrenheit,
        [Switch]$Kelvin,
        [String]$LogFile ="$Home\Get-CurrentCPUTemperature_errors.txt"
        )
    begin 
        {
        $base = Get-WmiObject MSAcpi_ThermalZoneTemperature -Namespace "root/wmi"
        $base = $($base.CurrentTemperature/10)
        $res = @();
        }
    process
        {
        if($Celsius)
            {
            $c = $(($base)-273.15)
            $res += "$c" + [char]0x00B0 + " Celsius"
            }
        if($Fahrenheit)
            {
            $f = $((($base)-273.15) * (9/5) + 32)
            $res += "$f" + [char]0x00B0 +" Fahrenheit"
            }
        if($Kelvin)
            {
            $k = $base
            $res += "$k" + [char]0x00B0 +" Kelvin"
            }
        }
    end
       {
       return $res
       }
}

<#
.Synopsis
Get-CriticalTripPoint uses the MSAcpi_ThermalZoneTemperature class to return the CPU temperature that triggers system cooling to begin.
Vasken Houdoverdov
 
.Parameter Celsius
Return the critical tripping point as Celsius
 
.Parameter Fahrenheit
Return the critical tripping point as Fahrenheit
 
.Parameter Kelvin
Return the critical tripping point as Kelvin
 
.Description
Get-CriticalTripPoint uses the MSAcpi_ThermalZoneTemperature class to return the CPU temperature that triggers system cooling to begin. Specify temperature unit using the parameters -Celsius, -Fahrenheit, and/or -Kelvin.
 
.Example
Get-CriticalTripPoint -Celsius
 
.Example
Get-CriticalTripPoint -Fahrenheit
 
.Example
Get-CriticalTripPoint -Kelvin
 
.Example
Get-CriticalTripPoint -Celsius -Kelvin -Fahrenheit
#>

function Get-CriticalTripPoint 
{
    [CmdletBinding()]
    param(
        [Switch]$Celsius,
        [Switch]$Fahrenheit,
        [Switch]$Kelvin,
        [String]$LogFile ="$Home\Get-CriticalTripPoint_errors.txt"
        )
    begin 
        {
        $base = Get-WmiObject MSAcpi_ThermalZoneTemperature -Namespace "root/wmi"
        $base = $($base.CriticalTripPoint/10)
        $res = @();
        }
    process
        {
        if($Celsius)
            {
            $c = $(($base)-273.15)
            $res += "$c" + [char]0x00B0 + " Celsius"
            }
        if($Fahrenheit)
            {
            $f = $((($base)-273.15) * (9/5) + 32)
            $res += "$f" + [char]0x00B0 +" Fahrenheit"
            }
        if($Kelvin)
            {
            $k = $base
            $res += "$k" + [char]0x00B0 +" Kelvin"
            }
        }
    end
       {
       return $res
       }
}

<#
.Synopsis
Get-PassiveTripPoint uses the MSAcpi_ThermalZoneTemperature class to return the passive tripping point temperature of the cPU.
Vasken Houdoverdov
 
.Parameter Celsius
Return the passive tripping point as Celsius
 
.Parameter Fahrenheit
Return the passive tripping point as Fahrenheit
 
.Parameter Kelvin
Return the passive tripping point as Kelvin
 
.Description
Get-PassiveTripPoint uses the MSAcpi_ThermalZoneTemperature class to return the passive tripping point temperature of the cPU. Specify temperature unit using the parameters -Celsius, -Fahrenheit, and/or -Kelvin.
 
.Example
Get-PassiveTripPoint -Celsius
 
.Example
Get-PassiveTripPoint -Fahrenheit
 
.Example
Get-PassiveTripPoint -Kelvin
 
.Example
Get-PassiveTripPoint -Celsius -Kelvin -Fahrenheit
#>

function Get-PassiveTripPoint 
{
    [CmdletBinding()]
    param(
        [Switch]$Celsius,
        [Switch]$Fahrenheit,
        [Switch]$Kelvin,
        [String]$LogFile ="$Home\Get-PassiveTripPoint_errors.txt"
        )
    begin 
        {
        $base = Get-WmiObject MSAcpi_ThermalZoneTemperature -Namespace "root/wmi"
        $base = $($base.PassiveTripPoint/10)
        $res = @();
        }
    process
        {
        if($Celsius)
            {
            $c = $(($base)-273.15)
            $res += "$c" + [char]0x00B0 + " Celsius"
            }
        if($Fahrenheit)
            {
            $f = $((($base)-273.15) * (9/5) + 32)
            $res += "$f" + [char]0x00B0 +" Fahrenheit"
            }
        if($Kelvin)
            {
            $k = $base
            $res += "$k" + [char]0x00B0 +" Kelvin"
            }
        }
    end
       {
       return $res
       }
}

<#
.Synopsis
Get-SamplingPeriod uses the MSAcpi_ThermalZoneTemperature class to return the sampling period.
Vasken Houdoverdov
 
.Description
Get-SamplingPeriod uses the MSAcpi_ThermalZoneTemperature class to return the sampling period.
 
.Example
Get-SamplingPeriod
#>

function Get-SamplingPeriod 
{
    [CmdletBinding()]
    param(
        [String]$LogFile ="$Home\Get-SamplingPeriod_errors.txt"
        )
    begin 
        {
        $base = Get-WmiObject MSAcpi_ThermalZoneTemperature -Namespace "root/wmi"
        $base = $base.SamplingPeriod
        }
    process
        {
        }
    end
       {
       return $base
       }
}

<#
.Synopsis
Get-ThermalStamp uses the MSAcpi_ThermalZoneTemperature class to return the thermal stamp.
Vasken Houdoverdov
 
.Description
Get-ThermalStamp uses the MSAcpi_ThermalZoneTemperature class to return the thermal stamp.
 
.Example
Get-ThermalStamp
#>

function Get-ThermalStamp 
{
    [CmdletBinding()]
    param(
        [String]$LogFile ="$Home\Get-ThermalStamp_errors.txt"
        )
    begin 
        {
        $base = Get-WmiObject MSAcpi_ThermalZoneTemperature -Namespace "root/wmi"
        $base = $base.ThermalStamp
        }
    process
        {
        }
    end
       {
       return $base
       }
}

Export-ModuleMember -Cmdlet * -Function *