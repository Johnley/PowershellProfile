Function Get-ComputerMemoryUsage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, 
            Position=0,
            HelpMessage = "Name of the computer to get memory usage from.")]
        [String]$ComputerName
    )
    BEGIN {
        if(!(Test-Connection $ComputerName -Count 1 -Quiet)){
            Write-Error "Could not connect to host $ComputerName."
            break
        }
    }
    PROCESS {
        # Memory utilization
        $ComputerMemory = Get-WmiObject -Class WIN32_OperatingSystem -ComputerName $ComputerName -Credential $Global:admcred
        $Memory = ((($ComputerMemory.TotalVisibleMemorySize - $ComputerMemory.FreePhysicalMemory) * 100) / $ComputerMemory.TotalVisibleMemorySize)

        # Top process
        $TopMem = Get-WmiObject WIN32_PROCESS -ComputerName $ComputerName -Credential $Global:admcred | Sort-Object -Property ws -Descending | Select-Object -first 1 processname, @{Name = "Mem Usage(MB)"; Expression = { [math]::round($_.ws / 1mb) } }, @{Name = "UserID"; Expression = { $_.getowner().user } }

        If ($TopMem -and $ComputerMemory) {
            $ProcessName = $TopMem.ProcessName
            $ProcessMem = $TopMem.'Mem Usage(MB)'
            $ProcessUser = $TopMem.UserID
            $RoundMemory = [math]::Round($Memory, 2)
        }
        Else {
            $ProcessName = "(Null)"
            $ProcessMem = "(Null)"
            $ProcessUser = "(Null)"
            $RoundMemory = "(Null)"
        }
        $Object = New-Object PSObject -Property ([ordered]@{ 
                "Server name"            = $ComputerName
                "Total usage %"          = $RoundMemory
                "Top process"            = $ProcessName
                "Top process usage (MB)" = $ProcessMem
                "Top process user"       = $ProcessUser
            })
    }
    END{
        $Object | format-list
    }
}
