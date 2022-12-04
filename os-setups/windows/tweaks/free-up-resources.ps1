for ($i=0;$i -lt 5;$i++) {
  Get-Process | Where-Object {$_.ProcessName -Like "adobenoti*"} | Stop-Process
  Get-Process | Where-Object {$_.ProcessName -Like "adobeipc*"} | Stop-Process
  Get-Process | Where-Object {$_.ProcessName -Like "adobeupd*"} | Stop-Process
  Get-Process | Where-Object {$_.ProcessName -Like "googlecrash*"} | Stop-Process
  Get-Process | Where-Object {$_.ProcessName -Like "msedgeweb*"} | Stop-Process
  Get-Process | Where-Object {$_.ProcessName -Like "wechatbrow*"} | Stop-Process
  Get-Process | Where-Object {$_.ProcessName -Like "wechatplay*"} | Stop-Process
  Get-Process | Where-Object {$_.ProcessName -Like "wechatapp*"} | Stop-Process


  Get-Service | where {$_.Name -Like "adobe*"} | Where-Object {$_.Status -eq "Running"} | Stop-Service -Force
  Get-Service | where {$_.Name -Like "*docker*"} | Where-Object {$_.Status -eq "Running"} | Stop-Service -Force
  Get-Service | where {$_.Name -Like "gamein*"} | Where-Object {$_.Status -eq "Running"} | Stop-Service -Force
  Get-Service | where {$_.Name -Like "*gamingser*"} | Where-Object {$_.Status -eq "Running"} | Stop-Service -Force
  Get-Service | where {$_.Name -Like "*clickto*"} | Where-Object {$_.Status -eq "Running"} | Stop-Service -Force
  Get-Service | where {$_.Name -eq "phonesvc"} | Where-Object {$_.Status -eq "Running"} | Stop-Service -Force
  Get-Service | where {$_.DisplayName -Like "*razer*"} | Where-Object {$_.Status -eq "Running"} | Stop-Service -Force
  Get-Service | where {$_.displayName -Like "remote desk*"} | Where-Object {$_.Status -eq "Running"} | Stop-Service -Force
}



foreach($name in @("wechat*", "discord*", "Teams", "nvidia*")) {
  Get-Process | Where-Object {$_.ProcessName -Like $name} | foreach-object {
    Write-Output $_.ProcessName
    $_.ProcessorAffinity=3584
    $_.PriorityClass="BelowNormal"
  }
}


timeout 50
