# # create scheduled task by powershell cmdlet
$action1 = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-ExecutionPolicy Bypass -File `"c:\test.ps1`""
$username = New-ScheduledTaskPrincipal -UserId 'NT AUTHORITY\SYSTEM' -LogonType ServiceAccount -RunLevel Highest
$triggers=@(
    New-ScheduledTaskTrigger -Once -At '12am' -RepetitionInterval (New-TimeSpan -Minutes 1)
    New-ScheduledTaskTrigger -AtStartup
)
$task = New-ScheduledTask -Action $action1 -Principal $username -Trigger $triggers
Register-ScheduledTask -TaskName 'test' -InputObject $task -Force

# modify repetition to startup trigger
# $task = Get-ScheduledTask -TaskName 'test'
# $task.Triggers.repetition.interval = 'PT1H'  # add interval for every 1 hour
# $task | Set-ScheduledTask

# ===============================================================

# create scheduled task by COM
# $service = New-Object -ComObject Schedule.Service
# $service.connect()
# $rootFolder = $service.GetFolder("\")

# $taskDefinition = $service.NewTask(0) # 0 for new task
# $trigger1 = $taskDefinition.Triggers.Create(1)  # create trigger,1 for once, 2 for daily trigger, 8 for startup trigger
# $trigger1.StartBoundary = (Get-Date).AddMinutes(1).ToLocalTime().ToString("yyyy-MM-ddTHH:mm:ss")
# $trigger1.Repetition.Interval = 'PT1M'
# $trigger1.Enabled = $true
# $trigger2 = $taskDefinition.Triggers.Create(8)
# $action1 = $taskDefinition.Actions.Create(0)  # 0 for execute program
# $action1.Path = "powershell.exe"
# $action1.Arguments = "-ExecutionPolicy Bypass -File `"c:\test.ps1`""
# $username = $taskDefinition.Principal
# $username.UserId = "NT AUTHORITY\SYSTEM"
# $username.LogonType = 5
# $username.RunLevel = 1  # 1 for highest

# $rootFolder.RegisterTaskDefinition(
#     "test", # task name
#     $taskDefinition,
#     6, # 6 for create/update task
#     $null, # username
#     $null, # password
#     5, # logon type
#     $null #SDDL
# )