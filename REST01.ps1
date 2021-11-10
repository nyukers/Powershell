# GET
 Invoke-RestMethod -Method GET -ContentType "application/json" -Uri "https://petstore.swagger.io/v2/pet/19"

# POST
$Body = @{
    id = 19
    category = @{
        id = 45
        name = "Whatever"
    }
    name = "Dawg"
    photoUrls = @(
        "string"
    )
    tags = @(
        @{
            id = 0
            name = "string"
        }
    )
    status = "available"
}

$JsonBody = $Body | ConvertTo-Json
$Uri = "https://petstore.swagger.io/v2/pet"
Invoke-RestMethod -ContentType "application/json" -Uri $Uri -Method POST -Body $JsonBody

# DELETE
Invoke-RestMethod -ContentType "application/json" -Uri "https://petstore.swagger.io/v2/pet/1" -Method DELETE

# PUT
$Body = [PSCustomObject]@{
    id = 19
    name = "Dawg is a cool boy"
}

$JsonBody = $Body | ConvertTo-Json
$Uri = "https://petstore.swagger.io/v2/pet"
Invoke-RestMethod -ContentType "application/json" -Uri $Uri -Method PUT -Body $JsonBody

# Function GET
Function Get-PetstorePet {
    [cmdletbinding()]
    param(
        # Id of the pet
        [Parameter(Mandatory,ValueFromPipeline)]
        [int]$Id
    )
    Begin{}
    Process{
        $RestMethodParams = @{
            Uri = "https://petstore.swagger.io/v2/pet/$Id"
            ContentType = "application/json"
            Method = "GET"
        }
        Invoke-RestMethod @RestMethodParams
    }
    End{}
}

Get-PetstorePet -Id 19

# Function POST
Function Add-PetstorePet {
    [cmdletbinding()]
    param(
        # Id of the pet
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [int]$Id,
        # Name of the pet
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string]$Name,        
        # Status of the pet (available, sold etc)
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string]$Status,        
        # Id of the pet category
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [int]$CategoryId,        
        # Name of the pet category
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string]$CategoryName,        
        # URLs to photos of the pet
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string[]]$PhotoUrls,
        # Tags of the pets as hashtable array: @{Id=1;Name="Dog"}
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [Hashtable[]]$Tags
    )
    Begin{}
    Process{
        $Body = @{
            id = $Id
            category = @{
                id = $CategoryId
                name = $CategoryName
            }
            name = $Name
            photoUrls = $PhotoUrls
            tags = $Tags
            status = $Status
        }
        $BodyJson = $Body | ConvertTo-Json
        $RestMethodParams = @{
            Uri = "https://petstore.swagger.io/v2/pet/"
            ContentType = "application/json"
            Method = "Post"
            Body = $BodyJson
        }
        Invoke-RestMethod @RestMethodParams
    }
    End{}
}

$AddPetStorePetsParams = @{
    Id = 44
    Name = "Birdie"
    Status = "available"
    CategoryId = 50
    CategoryName = "Hawks"
    PhotoUrls = "https://images.contoso.com/hawk.jpg"
    Tags = @(
        @{
            Id=10
            Name="Not eagles"
        }
    )
}

Add-PetStorePet @AddPetStorePetsParams