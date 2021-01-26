function GetReport
{
    param
    (
        $AgentId = "$((glcm).AgentId)",
        $serviceURL = "https://log01.forza.com:8080/PSDSCPullServer.svc"
    )

    $requestUri = "$serviceURL/Nodes(AgentId= '$AgentId')/Reports"
    $request = Invoke-WebRequest -Uri $requestUri  -ContentType "application/json;odata=minimalmetadata;streaming=true;charset=utf-8" `
               -UseBasicParsing -Headers @{Accept = "application/json";ProtocolVersion = "2.0"} `
               -ErrorAction SilentlyContinue -ErrorVariable ev
    $object = ConvertFrom-Json $request.content
    return $object.value
}

$reports = GetReport
$reports[1]
$reports[2]

$reportsByStartTime = $reports | Sort-Object {$_."StartTime" -as [DateTime] } -Descending
$reportMostRecent = $reportsByStartTime[0]

$statusData = $reports[1].Errors | ConvertFrom-Json
$statusData.ErrorMessage

$statusData = $reportMostRecent.StatusData | ConvertFrom-Json
$statusData

$statusData.ResourcesInDesiredState
$statusData
