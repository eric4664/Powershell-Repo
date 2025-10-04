function Show-Status {
    param (
        [ValidateSet("OK","WARN","FAIL")]
        [string]$Tag,

        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Content
    )
    switch ($Tag) {
        "OK"    { Write-Host "[  $Tag  ] " -ForegroundColor Green -NoNewline; Write-Host "$Content" }
        "WARN"  { Write-Host "[ $Tag ] " -ForegroundColor Yellow -NoNewline; Write-Host "$Content" }
        "FAIL"  { Write-Host "[ $Tag ] " -ForegroundColor Red -NoNewline; Write-Host "$Content" }
        default { Write-Host "[      ] $Content" }
    }
}

function Invoke-DownloadFile {
    param(
        [string]$Url
    )
    $FileName = [System.IO.Path]::GetFileName($Url)
    $FilePath = "C:\$FileName"

    # check network
    if (!((Resolve-DnsName xensor.evaair.com).IPAddress -eq "10.0.0.1")) { Show-Status "Network is not in the company" -Tag FAIL; exit } # change ip if needed
    $Net_Hash = (Invoke-WebRequest -Uri "$Url" -Method Head).headers["x-content-sha256"] # need to add custom header for URL
    if (!$Net_Hash) { Show-Status "Fetch $FileName hash fail." -Tag FAIL; exit }
    if (!($Net_Hash -match "^[0-9a-zA-Z]{64}$")) {Show-Status "The format fetching form $FileName hash is not right." -Tag FAIL; exit}

    # download 
    Invoke-WebRequest -Uri "$Url" -OutFile "$FilePath" -UseBasicParsing 
    if (!(Test-Path "$FilePath")) { Show-Status "Download $FileName fail." -Tag FAIL; exit }

    # check hash
    $File_Hash = (Get-FileHash "$FilePath" -Algorithm SHA256).hash
    if ($File_Hash -ne $Net_Hash) { 
        Show-Status "$FileName hash is not matched." -Tag FAIL
        Remove-Item -Path "$FilePath" -Force
        exit
    }
    Show-Status "Download $FileName" successfully. -Tag OK
}

$DownloadURL = ""

Show-Status "Downloading..."
Invoke-DownloadFile -Url $DownloadURL