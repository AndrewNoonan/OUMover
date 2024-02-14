#Scan machine S/N into MoverDevices Text file and save. 
#Press play button in powershell.
$OriginOU = "Imaging - limited policies/"
$DestinationOU = "MHS-Client Computers/"
foreach ($machine in Get-Content .\MoverDevices.txt) {
    $machine = "MSL-" + $machine
    $Conditional = $False
    Write-Host "------------- $machine -----------------" -ForegroundColor Cyan

    try {
        if (Get-ADComputer -Identity $machine){
            $Conditional = $True
        }    
    } catch {
        Write-Host "No record found" -ForegroundColor Red
    }

    if ($Conditional -eq $True) {
        try {
            $Condition = $False
            $ADRecord = Get-ADComputer -Identity $machine -Properties * | Format-List CanonicalName | Out-String
            $ADRString = $ADRecord.Substring(40, 50)

            if ($ADRString.Contains(($OriginOU + $machine))) {
                Write-Host "Device found | " -NoNewLine
                Write-Host $ADRString.Substring(15, 35) -ForegroundColor Yellow
                Get-ADComputer -Identity $machine | Move-ADObject -TargetPath 'OU=MHS-Client Computers,OU=Migration Staging,DC=act-maxopco2,DC=com'
            } elseif ($ADRString.Contains($DestinationOU + $machine)) {
                Write-Host "Device already in correct OU | " -NoNewLine
                Write-Host $ADRString.Substring(15, 35) -ForegroundColor Green
            }
        } catch [System.UnauthorizedAccessException] {
            Write-Host "Administrative rights required" -ForegroundColor Red
        }
    }
}
Read-Host "Press any key to close program"