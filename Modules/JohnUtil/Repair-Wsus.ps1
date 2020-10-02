Function Repair-Wsus {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, 
            Position = 0,
            HelpMessage = "Name of the computer to repair WSUS on.")]
        [String]$ComputerName,
        [Parameter(Mandatory = $true, 
            Position = 1, 
            HelpMessage = "Wsus Server URL")]
        [String]$WsusUrl
    )
    BEGIN {
        if (!(Test-Connection $ComputerName -Count 1 -Quiet)) {
            Write-Error "Could not connect to host $ComputerName."
            break
        }
    }
    PROCESS {
        $script = {
            Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\ -Name "WUServer" -Value $WsusUrl
            Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\ -Name "WUStatusServer" -Value $WsusUrl
            Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\ -Name "UseWUServer" -Value 1
            Get-Service wuauserv | Restart-Service
        }
        Invoke-Command -ComputerName $ComputerName -ScriptBlock $script -Credential $Global:admcred
        Write-Host -ForegroundColor Green "Repair Task Completed."
    }
}