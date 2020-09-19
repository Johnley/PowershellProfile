Function Get-LoggedOnUsers {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, 
            Position=0,
            HelpMessage = "Name of the computer to get users.")]
        [String]$ComputerName
    )
    BEGIN {
        if(!(Test-Connection $ComputerName -Count 1 -Quiet)){
            Write-Error "Could not connect to host $ComputerName."
            break
        }
    }
    PROCESS {
        $users = Invoke-Command -ScriptBlock {((quser) -replace '^>', '') -replace '\s{2,}', ',' | ConvertFrom-Csv} -ComputerName $ComputerName -Credential $admcred
        Write-Output "Sessions for $ComputerName"
        $users | Select-Object "USERNAME", "ID", "STATE","IDLE TIME", "LOGON TIME" | Format-Table
    }
}