function Set-MSIProperty {
    param(
        [string]$Path,
        [string]$Comment
    )
    $installer = New-Object -ComObject WindowsInstaller.Installer
    $database = $installer.OpenDatabase($Path, 1)  # 1 = Read/Write in transaction mode
    $summaryInfo = $database.SummaryInformation(4)
    $summaryInfo.Property(6) = "$Comment"  # Property 6 = Comments
    $summaryInfo.Persist()
    $database.Commit()
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($summaryInfo) | Out-Null
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($database) | Out-Null
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($installer) | Out-Null
}

Set-MSIProperty -Path = "C:\Users\User\Desktop\test.msi" -Comment "C:\Users\User\Desktop\test.cfg"
