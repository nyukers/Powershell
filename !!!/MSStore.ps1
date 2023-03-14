$manifest = (Get-AppxPackage Microsoft.WindowsStore).InstallLocation + '\AppxManifest.xml' 
Add-AppxPackage -DisableDevelopmentMode -Register $manifest