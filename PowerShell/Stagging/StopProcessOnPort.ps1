$portToStop = 5115

$processes = Get-NetTCPConnection -LocalPort $portToStop | Select-Object -ExpandProperty OwningProcess
foreach ($process in $processes) {
    $processName = (Get-Process -Id $process).ProcessName
    Write-Host "Killing process: $processName (PID: $process)"
    Stop-Process -Id $process -Force
}
