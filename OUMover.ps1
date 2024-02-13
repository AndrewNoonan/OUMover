#Scan machine S/N into MoverDevices Text file and save. 
#Press play button in powershell.

foreach ($machine in Get-Content .\MoverDevices.txt) {
    $machine = "MSL-" + $machine
    Write-Host "------------- $machine -----------------" -ForegroundColor Cyan
    Get-ADComputer -Identity $machine | Format-Table Distinguishedname
    try {
        Get-ADComputer -Identity $machine | Move-ADObject -TargetPath 'OU=MHS-Client Computers,OU=Migration Staging,DC=act-maxopco2,DC=com'
        Get-ADComputer -Identity $machine | Format-Table Distinguishedname
    } catch {
        Write-Host "You must be an administrator" -ForegroundColor Red
    }
}

Read-Host "Press any key to close program"
