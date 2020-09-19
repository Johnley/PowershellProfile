Function Repair-Wsus {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, 
            Position = 0,
            HelpMessage = "Name of the computer to repair WSUS on.")]
        [String]$ComputerName
    )
    BEGIN {
        if (!(Test-Connection $ComputerName -Count 1 -Quiet)) {
            Write-Error "Could not connect to host $ComputerName."
            break
        }
    }
    PROCESS {
        $script = {
            Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\ -Name "WUServer" -Value "http://wsus.shawinc.com"
            Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\ -Name "WUStatusServer" -Value "http://wsus.shawinc.com"
            Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\ -Name "UseWUServer" -Value 1
            Get-Service wuauserv | Restart-Service
        }
        Invoke-Command -ComputerName $ComputerName -ScriptBlock $script -Credential $Global:admcred
        Write-Host -ForegroundColor Green "Repair Task Completed."
    }
}