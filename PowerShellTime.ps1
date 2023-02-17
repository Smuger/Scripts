$startTime = Get-Date

# WORK
Start-Sleep -Seconds 2

$endTime = Get-Date
$executionTime = New-TimeSpan $startTime $endTime

$executionTimeSeconds = "{0:N0}" -f $executionTime.TotalSeconds
Write-Host "The script took $executionTimeSeconds seconds to run."
