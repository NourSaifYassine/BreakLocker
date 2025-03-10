$SchoolDays = "monday", "tuesday", "wednesday", "Thursday", "Friday" # Adjust the days if necessary
$SchoolPauzes = "11:00", "12:30", "14:30", "10:13" # Adjust the time if necessary
$wshell = New-Object -ComObject Wscript.Shell
$lastTriggeredTime = ""

# Will run continuously to check the day and time for every minute
while ($true) {
    $GetTime = Get-Date -Format "HH:mm"
    $GetDay = Get-Date -Format "dddd"

    if ($SchoolDays -contains $GetDay) {
        if ($SchoolPauzes -contains $GetTime -and $lastTriggeredTime -ne $GetTime) {
            Write-Host "Break time on $GetTime"
            $wshell.Popup("Break Time! Time to close your Windows device", 0, "Break Time", 0x0)
            rundll32.exe user32.dll,LockWorkStation
            $lastTriggeredTime = $GetTime
        }
    }
    
    Start-Sleep -Seconds 60
}