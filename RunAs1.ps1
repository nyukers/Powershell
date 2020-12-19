$ErrorActionPreference = 'Stop'

$si = New-Object System.Diagnostics.ProcessStartInfo
$si.FileName = $args[0]
$si.Argumcoms = [String]::Join(' ', $args[1..($args.Count - 1)])
$si.Verb = 'RunAs'
$si.UseShellExecute = $true

$process = [System.Diagnostics.Process]::Start($si)

$process.WaitForExit()

do
{
    [System.Threading.Thread]::Sleep(0)
}
while (!$process.HasExited)

Exit $process.ExitCode