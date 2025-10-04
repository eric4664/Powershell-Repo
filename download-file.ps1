# use HTTPS to download file
$URL = ""
$Path = ""
$Username = ""


# check security protocol, if not support tls1.2, then add it
if([Net.ServicePointManager]::SecurityProtocol -ne 'SystemDefault') {   # check systemdefault, if not add it
    $sec = ([Net.ServicePointManager]::SecurityProtocol).tostring()
    [Net.ServicePointManager]::SecurityProtocol = $sec + ', Tls12'
}


# download file via SMB
Copy-Item -Source "$URL" -Destination "$Path" -Credential "$Username"


# download file via Invoke-WebRequest
Invoke-WebRequest -Uri "$URL" -OutFile "$Path" -UseBasicParsing -Credential "$Username"



# download file via Start-BitsTransfer
Start-BitsTransfer -Source "$URL" -Destination "$Path"



# download file via .net WebClient
(New-Object System.Net.WebClient).DownloadFile("$URL","$Path")


