Function Resize-VMDrive {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, 
                    HelpMessage = "Name of the VM to grow drives on")]
        [String]$ComputerName,
        [Parameter(Mandatory = $true, 
                    HelpMessage = "Drive Letter on the VM to grow.")]
        [String]$DriveLetter,
        [Parameter(Mandatory = $true, 
                    HelpMessage = "Amount (in GB) to grow the disk")]
        [int]$AddGB
    )
    BEGIN{
        #Check if we're connected to vSphere
        if(!$Global:DefaultVIServers){
            Write-Error "Not connected to vSphere! Please run Connect-ViServer first."
            break
        }

        #Check for admin creds
        if(!$Global:admcred){
            Write-Error 'Please set $admcred!'
            break
        }

        #create globals
        $s = New-PSSession -ComputerName $ComputerName -Credential $Global:admcred
        $vm = Get-VM $ComputerName

        #check that the remote host is running a non-garbage version of powershell
        $winversion = Invoke-Command -ScriptBlock {(Get-WmiObject Win32_OperatingSystem).Version} -Session $s
        if($winversion -lt 6.2){
            Write-Error "Server is over a decade old, you're gonna have to do this one manually."
            break
        }
    }
    PROCESS{
        $s = New-PSSession -ComputerName $ComputerName -Credential $Global:admcred
        $vm = Get-VM $ComputerName

        #Get the disk number from Windows
        $partition = Invoke-Command -ScriptBlock {param($dl);  Get-Partition -DriveLetter $dl} -ArgumentList $DriveLetter  -Session $s

        #Convert windows disk to vmware disk
        $vmpartition = $partition.DiskNumber + 1
        $diskstring = "Hard Disk $vmpartition"

        #Get the current disk info from vSphere
        $vmdisk = $vm | Get-HardDisk | Where-Object Name -eq $diskstring

        #Grow the disk in vSphere
        $newcap = $vmdisk.CapacityGB + $AddGB
        Set-HardDisk $vmdisk -CapacityGB $newcap -Confirm:$false | Out-Null

        #wait 5 seconds for disks to settle
        Start-Sleep -s 5

        #Grow the disk in Windows
        Invoke-Command -ScriptBlock {param($dn); Update-Disk -Number $dn} -ArgumentList $partition.DiskNumber -Session $s
        Invoke-Command -ScriptBlock {param($dl); Resize-Partition -DriveLetter $dl -Size (Get-PartitionSupportedSize -DriveLetter $dl).SizeMax} -ArgumentList $DriveLetter -Session $s
        $resizeddisk = Invoke-Command -ScriptBlock {param($dn); Get-Disk -Number $dn} -ArgumentList $partition.DiskNumber -Session $s
        $newdisksize = $resizeddisk.Size/1GB
        Write-Host -ForegroundColor Green "Disk grown by $AddGB GB, new disk size is $newdisksize GB."
    }
}