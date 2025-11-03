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
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Url,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$StorePath
    )
    $FileName = [System.IO.Path]::GetFileName($Url)
    $FilePath = "$StorePath\$FileName"
    $resolveIP = "10.0.0.1"

    # check network
    if (!((Resolve-DnsName example.com).IPAddress -eq $resolveIP)) { Show-Status "Network is not right." -Tag FAIL; exit } # check dns resolve correct
    $Fetch_Hash = (Invoke-WebRequest -Uri "$Url" -Method Head).headers["x-content-sha256"] # check hash fetch successfully, need to add custom header for URL
    if (!$Fetch_Hash) { Show-Status "Fetch $FileName hash fail." -Tag FAIL; exit }
    if (!($Fetch_Hash -match "^[0-9a-zA-Z]{64}$")) {Show-Status "The $FileName hash format is not right." -Tag FAIL; exit} # check sha256 format

    # download 
    Invoke-WebRequest -Uri "$Url" -OutFile "$FilePath" -UseBasicParsing 
    if (!(Test-Path "$FilePath")) { Show-Status "Download $FileName fail." -Tag FAIL; exit }

    # check hash
    $File_Hash = (Get-FileHash "$FilePath" -Algorithm SHA256).hash
    if ($File_Hash -ne $Fetch_Hash) { 
        Show-Status "$FileName hash is not matched." -Tag FAIL
        Remove-Item -Path "$FilePath" -Force
        exit
    }
    Show-Status "Download $FileName" successfully. -Tag OK
}

$DownloadURL = ""
$DownloadPath = ""

Show-Status "Downloading..."
Invoke-DownloadFile -Url $DownloadURL -StorePath $DownloadPath
