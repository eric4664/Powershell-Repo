# # create scheduled task by powershell cmdlet
# $action1 = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-ExecutionPolicy Bypass -File `"c:\test.ps1`""
# $username = New-ScheduledTaskPrincipal -UserId 'NT AUTHORITY\SYSTEM' -LogonType ServiceAccount -RunLevel Highest
# $trigger1 = New-ScheduledTaskTrigger -AtStartup
# $task = New-ScheduledTask -Action $action1 -Principal $username -Trigger $trigger1
# Register-ScheduledTask -TaskName 'test' -InputObject $task -Force

# # add repetition to startup trigger
# $task = Get-ScheduledTask -TaskName 'test'
# $task.Triggers.repetition.interval = 'PT1H'  # add interval for every 1 hour
# $task | Set-ScheduledTask

# ===============================================================

# create scheduled task by COM
$service = New-Object -ComObject Schedule.Service
$service.connect()
$rootFolder = $service.GetFolder("\")
$taskDefinition = $service.NewTask(0) # 0 for new task
$trigger1 = $taskDefinition.Triggers.Create(8)  # 2 for daily trigger, 8 for startup trigger
# $trigger1.StartBoundary = (Get-Date).AddMinutes(1).ToString("yyyy-MM-ddTHH:mm:ss")
# $trigger1.DaysInterval = 1
$trigger1.Repetition.Interval = 'PT1H'
$trigger1.Enabled = $true
$action1 = $taskDefinition.Actions.Create(0)  # 0 for execute program
$action1.Path = "powershell.exe"
$action1.Arguments = "-ExecutionPolicy Bypass -File `"c:\test.ps1`""
$username = $taskDefinition.Principal
$username.UserId = "NT AUTHORITY\SYSTEM"
$username.LogonType = 5
$username.RunLevel = 1  # 1 for highest
$rootFolder.RegisterTaskDefinition(
    "test", # task name
    $taskDefinition,
    6, # 6 for create/update task
    $null, # username
    $null, # password
    5, # logon type
    $null #SDDL
)