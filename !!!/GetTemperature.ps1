
function Get-Temperature {
    $t = Get-WmiObject MSAcpi_ThermalZoneTemperature -Namespace "root/wmi"
    $returntemp = @()

    foreach ($i in 0..($t.Count - 1)) {
        $temperatureInstance = $t[$i]
        $currentTempKelvin = $temperatureInstance.CurrentTemperature / 10
        $currentTempCelsius = $currentTempKelvin - 273.15
        $currentTempCelsius = [math]::Round($currentTempCelsius, 2)
        $currentTempFahrenheit = (9/5) * $currentTempCelsius + 32
        $instanceName = $temperatureInstance.InstanceName

#        $returntemp += "$instanceName - $currentTempCelsius C : $currentTempFahrenheit F : $currentTempKelvin K"
        $returntemp += "$instanceName : $currentTempCelsius C"
    }

    return $returntemp
}

Get-Temperature
