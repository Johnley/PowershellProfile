Function New-VaultCredential {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, 
            Position=0,
            HelpMessage = "Credential to pass to the vault.")]
        [System.Management.Automation.PSCredential]$Credential,
        [Parameter(Mandatory = $true, 
            Position=1,
            HelpMessage = "Target to attach the credential to.")]
        [string]$Target
    )
    BEGIN {
        
    }
    PROCESS {
        $user = $Credential.UserName
        $pass = $Credential.GetNetworkCredential().Password
        cmdkey /add:$Target /user:$user /pass:$pass
    }
}