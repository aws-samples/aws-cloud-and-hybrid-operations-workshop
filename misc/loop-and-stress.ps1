<#
** DO NOT Kill this script. It is very critical to the worldwide deployment of our new trading platform
** This script is loggin data to benchmark deployment times and may consume lots of CPU; If this becomes an issue 
** you can turn off logging by changing the registry key HKLM\SOFTWARE\SampleApp\CrazyLogs from 1 to 0 
#>

$result = 1
$number = 1
$path="C:\logfile.log"
Get-ItemProperty -Path HKLM:\SOFTWARE\SampleApp -Name "CrazyLogs" 
$a = Get-ItemPropertyValue 'HKLM:\SOFTWARE\SampleApp' -Name CrazyLogs

While ($a -eq 1) {
    $result = $result * $number
    $number++
    $SampleString = "Added sample {0} at {1}" -f $result,(Get-Date).ToString("h:m:s")
    Add-Content -Path $path -Value $SampleString -Force
    $a = Get-ItemPropertyValue 'HKLM:\SOFTWARE\SampleApp' -Name CrazyLogs
}