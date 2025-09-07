# create scheduled task for resume job
$resumeActionscript = '-ExecutionPolicy Bypass -WindowStyle Hidden -NoLogo -NoProfile -Command "& {Import-Module –Name PSWorkflow; write-host "Resuming job..."; Get-Job -state Suspended | resume-job -wait | wait-job}"'
$act = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -Argument $resumeActionscript
$trig = New-ScheduledTaskTrigger -AtLogOn -RandomDelay 00:00:55
Register-ScheduledTask -TaskName ResumeWFJobTask -Action $act -Trigger $trig -RunLevel Highest 

# recover to initial states
Remove-Item C:\users\admin\desktop\beforeSuspend.txt -ErrorAction SilentlyContinue -Force
Remove-Item C:\users\admin\desktop\afterResume.txt -ErrorAction SilentlyContinue -Force

workflow run-work {
    # action before reboot
    InlineScript {
        Get-Date | Out-File -FilePath C:\users\admin\desktop\beforeSuspend.txt
    }
    # Suspend using Restart-Computer activity or Suspend activity
    Restart-Computer -Wait
    # action after reboot
    InlineScript {
        Get-Date | Out-File -FilePath C:\users\admin\desktop\afterResume.txt 
        New-Item -Path "$env:userprofile\desktop\test" -ItemType Directory -Force 
        #Invoke-WebRequest -Uri "https://live.sysinternals.com/procexp.chm" -OutFile "$env:userprofile\desktop\todo.ps1" -UseBasicParsing
        Copy-Item -Path "$env:userprofile\desktop\source\todo.ps1" -Destination $env:userprofile\desktop\test -Force 
        Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -file $env:userprofile\desktop\test\todo.ps1"
        Get-ScheduledTask -TaskName ResumeWFJobTask –EA SilentlyContinue | Unregister-ScheduledTask -Confirm:$false 
    }
}

# execute workflow
Write-Host "executing workflow..." 
run-work -AsJob | Wait-Job