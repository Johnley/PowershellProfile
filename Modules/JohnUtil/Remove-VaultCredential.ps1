Function Remove-VaultCredential {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, 
            Position=0,
            HelpMessage = "Target credential to remove.")]
        [string]$Target
    )
    BEGIN {
        
    }
    PROCESS {
        cmdkey /delete:$Target
    }
}