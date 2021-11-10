# 1
$User = @"
{
   "firstName": "Иван",
   "lastName": "Иванов",
   "address": {
       "streetAddress": "Московское ш., 101, кв.101",
       "city": "Ленинград",
       "postalCode": 101101
   },
   "phoneNumbers": [
       "812 123-1234",
       "916 123-4567"
   ]
}
"@ | ConvertFrom-Json

$User.firstName
$User.phoneNumbers[0]

# 2
$json = @"
{
  "ServerName"        : "$env:ComputerName",
  "UserName"          : "$env:UserName",
  "ComputerInfo"      :
  {
    "Manufacturer": "$((Get-WmiObject Win32_ComputerSystem).Manufacturer)",
    "Architecture": "$((Get-wmiObject Win32_OperatingSystem).OSArchitecture)",
    "SerialNumber": "$((Get-wmiObject Win32_OperatingSystem).SerialNumber)"
  },
  "CollectionDate"    : "$(Get-Date)"
 }
"@

$Info = ConvertFrom-Json -InputObject $json
$Info.ServerName
$Info.ComputerInfo.Manufacturer
$Info.ComputerInfo.Architecture

# 3
$File = Get-ChildItem C:\Windows\System32\calc.exe
$File.VersionInfo | ConvertTo-Json
$File.VersionInfo | fl -Property *

# 4
$response = Invoke-WebRequest -Uri "https://fixmypc.ru/json.html"
$response | Get-Member
$response.Content
$json = ConvertFrom-Json -InputObject $response.Content
$json | Get-Member
$json.employee

# {"employee":{"name":"sonoo","salary":[56000, 30000],"married":true}}
$json = @"
{
"employee":
    {
    "name": "sonar",
    "salary":[
              56000, 
              30000
             ],
    "married":true
    }
}
"@
$Info = ConvertFrom-Json -InputObject $json
$info.employee.name
$info.employee.Salary[0]
ConvertFrom-Json -InputObject $json | SELECT -ExpandProperty Employee

ConvertTo-Json -InputObject (Get-Service)

# 5
(Get-Content -Path C:\vm\shared\ps\1233\1.json -Raw | ConvertFrom-Json).employee