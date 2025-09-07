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

Show-Status "work successfully" -Tag "OK"
Show-Status "something error" -Tag "WARN" 
Show-Status "fail to run" -Tag "FAIL"
Show-Status "No Tag"

# show error
Show-Status "ERROR ERROR" -Tag "ERROR"
Show-Status -Tag "WARN" 