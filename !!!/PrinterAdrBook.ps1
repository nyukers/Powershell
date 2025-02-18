# Define the URL of the address book for the HP printer
$addressBookUrl = "http://HPPrinterHostname/addressbook/index.dhtml"  # Replace with the actual URL

# Define the output file path where the address book will be saved
$outputFile = "C:\path\to\save\addressbook.html"

# Define the credentials (if needed)
$username = "your_username"
$password = "your_password"
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential($username, $securePassword)

try {
    # Send a web request to retrieve the address book
    $response = Invoke-WebRequest -Uri $addressBookUrl -Credential $credentials -Method Get

    # Check if the request was successful
    if ($response.StatusCode -eq 200) {
        # Save the address book content to a file
        $response.Content | Out-File -FilePath $outputFile
        Write-Host "Address book saved to $outputFile"
    } else {
        Write-Host "Failed to retrieve the address book. Status code: $($response.StatusCode)"
    }
} catch {
    Write-Host "An error occurred: $_"
}
