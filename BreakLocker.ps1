# Maybe need to change the language to adjust the days if necessary
$DayBreaks = "monday", "tuesday", "wednesday", "thursday", "friday"
$WifiNetworks = "Network_SSID" # Adjust the wifi network name if necessary
$TimeBreaks = "11:00", "12:30", "14:30" # Adjust the time if necessary
$ProgramingLanguages = "node", "php", "python" # Adjust the programming languages if necessary
$wshell = New-Object -ComObject Wscript.Shell
$lastTriggeredTime = ""
$ssid = (netsh wlan show interfaces) -Match 'SSID' | ForEach-Object { $_.Split(':')[1].Trim() }

# Will run continuously to check the day and time for every minute
while ($true) {
    $run = Read-Host "run the script? (y/n)"
    if ('n' -eq $run) {
        break
    } elseif ('y' -eq $run) {
        $GetTime = Get-Date -Format "HH:mm"
        $GetDay = Get-Date -Format "dddd"
        $ConditionForNetworks = $ssid -match $WifiNetworks
        if ($ConditionForNetworks) {
            if ($DayBreaks -contains $GetDay) {
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
                            Write-Host "Continue Working"
                            Start-Sleep -Seconds 60
                            $lastTriggeredTime = $GetTime
                        } else {
                            Write-Host "Invalid input"
                        }
                        $userChoice = $wshell.Popup("Break Time! Do you want to close your Windows Device.", 0, "Break Time", 4 + 32)
                        if ($userChoice -eq 6) {
                            Write-Host "Stopping the process $GetTime"
                            rundll32.exe user32.dll,LockWorkStation
                        } elseif ($userChoice -eq 7) {
                            Write-Host "Continue Working"
                            Start-Sleep -Seconds 60
                        }
                        $lastTriggeredTime = $GetTime
                    } else {
                        $userChoice = $wshell.Popup("Break Time! Do you want to close your Windows Device.", 0, "Break Time", 4 + 32)
                        if ($userChoice -eq 6) {
                            Write-Host "Stopping the process $GetTime"
                            rundll32.exe user32.dll,LockWorkStation
                        } elseif ($userChoice -eq 7) {
                            Write-Host "Continue Working"
                            Start-Sleep -Seconds 60
                        }
                    }
                }
            } else {
                Write-Host "Not connected to your school wifi"
                Start-Sleep -Seconds 60
                continue
            }
        }
        Start-Sleep -Seconds 60
    }
}