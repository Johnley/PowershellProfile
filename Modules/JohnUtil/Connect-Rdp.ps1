Function Connect-Rdp {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, 
            Position=0,
            HelpMessage = "Computer to connect to")]
        [string]$ComputerName,
        [Parameter(Mandatory = $false, 
            Position=1,
            HelpMessage = "Credentials to connect with.")]
        [System.Management.Automation.PSCredential]$Credential = $Global:admcred
    )
    BEGIN {
        New-VaultCredential -Credential $Credential -Target $ComputerName | Out-Null
    }
    PROCESS {
        mstsc /v:$ComputerName
    }
    END{
        #Gotta wait because RDP is slow.
        Start-Sleep -Seconds 2
        Remove-VaultCredential -Target $ComputerName | Out-Null
    }
}