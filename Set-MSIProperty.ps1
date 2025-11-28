function Set-MSIProperty {
    $msiPath = "C:\Users\User\Desktop\test.msi"
    $newComment = Get-Content "C:\Users\User\Desktop\test.cfg"
    $installer = New-Object -ComObject WindowsInstaller.Installer
    $database = $installer.OpenDatabase($msiPath, 1)  # 1 = Read/Write in transaction mode
    $summaryInfo = $database.SummaryInformation(4)
    $summaryInfo.Property(6) = "$newComment"  # Property 6 = Comments
    $summaryInfo.Persist()
    $database.Commit()
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($summaryInfo) | Out-Null
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($database) | Out-Null
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($installer) | Out-Null
}

Set-MSIProperty
