#Scan machine S/N into MoverDevices Text file and save. 
#Press play button in powershell.

$DestinationOU = "MHS-Client Computers/"
foreach ($machine in Get-Content .\MoverDevices.txt) {
    $machine = "MSL-" + $machine
    Write-Host "------------- $machine -----------------" -ForegroundColor Cyan
    try {
        if (Get-ADComputer -Identity $machine) {
            #Before being moved
            $Condition = $False
            $ADRecord = Get-ADComputer -Identity $machine -Properties * | Format-List CanonicalName | Out-String
            $ADRString = $ADRecord.Substring(55, 33)
            if ($ADRString -eq ($DestinationOU + $machine)) {
                Write-Host "Device already in correct OU | " -NoNewLine
                Write-Host $ADRString -ForegroundColor Green
                $Condition = $True
            } else {
                Write-Host "Device found | " -NoNewLine
                Write-Host $ADRString -ForegroundColor Yellow
            }
            Get-ADComputer -Identity $machine | Move-ADObject -TargetPath 'OU=MHS-Client Computers,OU=Migration Staging,DC=act-maxopco2,DC=com'

            #After being moved
            if (($Condition -eq $False) -and ($ADRString -eq ($DestinationOU + $machine))) {
                Write-Host "Device moved | " -NoNewLine
                Write-Host $ADRString -ForegroundColor Green
            } elseif (($Condition -eq $True)) {
                #Don't need to do anything.
            } else {
                Write-Host "Something went wrong, printing record properties" -ForegroundColor Red
                Get-ADComputer -Identity $machine -Properties *
            }
        }
    } catch [System.UnauthorizedAccessException] {
        Write-Host "Administrative rights required" -ForegroundColor Red
    } catch {
        Write-Host "No record found" -ForegroundColor Red
    }
}

Read-Host "Press any key to close program"