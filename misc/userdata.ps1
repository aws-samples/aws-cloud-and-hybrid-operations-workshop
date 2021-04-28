<powershell>
$url="https://raw.githubusercontent.com/aws-samples/aws-cloud-and-hybrid-operations-workshop/main/misc/loop-and-stress.ps1"
Invoke-WebRequest $url -OutFile "c:\loop-and-stress.ps1"
New-Item -Path HKLM:\SOFTWARE -Name \"SampleApp\"
Set-ItemProperty -Path HKLM:\SOFTWARE\SampleApp -Type DWORD -Name CrazyLogs -Value 1
$trigger = New-JobTrigger -AtStartup -RandomDelay 00:00:30
Register-ScheduledJob -Trigger $trigger -FilePath c:\loop-and-stress.ps1 -Name StressCPU
Restart-Computer
</powershell>