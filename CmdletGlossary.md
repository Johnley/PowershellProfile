# Cmdlet Glossary

## Connect-Rdp

Connects to the specified server. if $Global:admcred is set, you don't need to specify a credential.

### Examples

regular server: `Connect-Rdp sw72comctrps`

AD Server (prompts for credentials): `Connect-Rdp sw72ad1 -Credential (Get-Credential)`

## Get-ComputerMemoryUsage

Gets the current memory usage % of the specified server, and the biggest memory hogging process.

### Example

`Get-ComputerMemoryUsage sw65ysfprd1`

Output:

```Text
Server name            : sw65ysfprd1
Total usage %          : 26.65
Top process            : Tomcat6.exe
Top process usage (MB) : 1321
Top process user       : SYSTEM
```

## Get-LoggedOnUsers

Gets the users that are RDP'd or Consoled into a computer.

### Example

`GetLoggedOnUsers.ps1 sw72comctrps`

Output:

```Text
Sessions for sw72comctrps

USERNAME     ID STATE  IDLE TIME LOGON TIME
--------     -- -----  --------- ----------
jconleyadmin 3  Active .         9/19/2020 3:14 AM
```

## New-VaultCredential

A simple wrapper around cmdkey.exe to create credentials in the windows credential manager. Used internally by other cmdlets.

## Remove-VaultCredential

A simple wrapper around cmdkey.exe to remove credentials from the windows credential manager. Used internally by other cmdlets.

## Repair-Wsus

repairs the registry entries for a remote server and restarts windows update. useful for errors ending in EFD.

### Example

`Repair-Wsus sw72comctrps`

Output:

```Text
Repair Task Completed.
```

## Resize-VMDrive

Grows Virtual Machine Disks, then grows the partitions in the Windows VM.

### Example

`Resize-VMDrive -ComputerName sw72comctrps -DriveLetter D -AddGB 2`

Output:

```Text
Disk grown by 0 GB, new disk size is 7 GB.
```
