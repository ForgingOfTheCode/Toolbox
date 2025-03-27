
Get-NetTCPConnection -LocalAddress 127.0.0.1 | select @{Name="Name";Expression={(Get-Process -Id $_.OwningProcess).ProcessName}}, LocalPort, State, AppliedSetting, CreationTime |  Sort-Object -Property Name -Unique | Format-Table -AutoSize
