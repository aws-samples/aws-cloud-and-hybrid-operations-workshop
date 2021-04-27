<powershell>
#
#Download the script and save to the c: drive
#Gotta change to github raw folder
#
Invoke-WebRequest `
    https://notasdofelip.s3.amazonaws.com/loop-and-stress.ps1 `
    -OutFile c:\loop-and-stress.ps1

#
#Create Registry Entry needed by the stress script
#
New-Item -Path HKLM:\SOFTWARE -Name "benfelip"
Set-ItemProperty -Path HKLM:\SOFTWARE\benfelip -Type DWORD -Name CrazyLogs -Value 1

#Setup the trigger to run everytime it boots
$trigger = New-JobTrigger -AtStartup -RandomDelay 00:00:30
Register-ScheduledJob -Trigger $trigger -FilePath c:\loop-and-stress.ps1 -Name StressCPU

</powershell>