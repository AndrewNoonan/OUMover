Get-ADComputer -Identity MSL-PW04B8NT -Properties * | Format-List Name, CanonicalName
$Machine = Get-ADComputer -Identity MSL-PW04B8NT -Properties * | Format-List CanonicalName | Out-String
$count = 0
foreach ($n in $Machine.ToCharArray()) {
    Write-Host $count")"$n
    $count++
}
$DestinationOU = "MHS-Client Computers/"
#Scan machine S/N into MoverDevices Text file and save. 
#Press play button in powershell.

foreach ($machine in Get-Content .\MoverDevices.txt) {
    $machine = "MSL-" + $machine
    Write-Host "------------- $machine -----------------" -ForegroundColor Cyan

    $ADRecord = Get-ADComputer -Identity $machine -Properties * | Format-List CanonicalName | Out-String
    $ADRString = $ADRecord.Substring(55, 33)
    Write-Host $ADRString
    if ($ADRString -eq ($DestinationOU + $machine)) {
        Write-Host "Device location | " -NoNewLine
        Write-Host $c -ForegroundColor Green
    }
}

Read-Host "Press any key to close program"
