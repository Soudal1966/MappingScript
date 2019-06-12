    
$azDriveMAppingScriptUrl= "https://raw.githubusercontent.com/Soudal1966/DriveMap/master/DriveMapping.ps1?token=AMKYWYWQD3EHGIVDN2ZIMGS5ADIGW"

$regKeyLocation="HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"

$psCommand= "PowerShell.exe -ExecutionPolicy Bypass -windowstyle hidden -command $([char]34)& {(Invoke-RestMethod '$azDriveMAppingScriptUrl').Replace('ï','').Replace('»','').Replace('¿','') | Invoke-Expression}$([char]34)"

if (-not(Test-Path -Path $regKeyLocation)){

    New-ItemProperty -Path $regKeyLocation -Force
}

Set-ItemProperty -Path $regKeyLocation -Name "PowerShellDriveMapping" -Value $psCommand -Force

Invoke-Expression $psCommand