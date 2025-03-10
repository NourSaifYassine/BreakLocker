# Maybe need to change the language to adjust the days if necessary
$DayBreaks = "monday", "tuesday", "wednesday", "thursday", "friday"
$TimeBreaks = "11:00", "12:30", "14:30", "13:18" # Adjust the time if necessary
$ProgramingLanguages = "node", "php", "python" # Adjust the programming languages if necessary
$wshell = New-Object -ComObject Wscript.Shell
$lastTriggeredTime = ""

# Will run continuously to check the day and time for every minute
while ($true) {
    $GetTime = Get-Date -Format "HH:mm"
    $GetDay = Get-Date -Format "dddd"

    if ($DayBreaks -contains $GetDay) {
        Write-Host "Test dag"
        if ($TimeBreaks -contains $GetTime -and $lastTriggeredTime -ne $GetTime) {
            if (Get-Process | Where-Object { $_.ProcessName -in $ProgramingLanguages }) {
                Write-Host "Break time on $GetTime"
                $StopInput = Read-Host -Prompt "Do you want to stop coding(stop the process type yes/no)?"
                if ($StopInput -eq "yes") {
                    Write-Host "Stopping the process $GetTime"
                    foreach ($language in $ProgramingLanguages) { 
                        Stop-Process -Name $language -Force -ErrorAction SilentlyContinue 
                    }
                    $lastTriggeredTime = $GetTime
                } elseif ($StopInput -eq "no") {
                    Write-Host "Continue coding"
                    Start-Sleep -Seconds 60
                    $lastTriggeredTime = $GetTime
                } else {
                    Write-Host "Invalid input"
                }
                $wshell.Popup("Break Time! Time to stop coding on your Windows device", 0, "Break Time", 0x0)
                rundll32.exe user32.dll,LockWorkStation
                $lastTriggeredTime = $GetTime
            } else {
                Write-Host "Break time on $GetTime"
                $wshell.Popup("Break Time! Time to close your Windows device", 0, "Break Time", 0x0)
                rundll32.exe user32.dll,LockWorkStation
                $lastTriggeredTime = $GetTime
            }
        }
    }
    
    Start-Sleep -Seconds 60
}