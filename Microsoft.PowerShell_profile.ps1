

$settings = Get-Content -Path "$PSScriptRoot\config.json" | ConvertFrom-Json
$InformationPreference = $settings.info_preference
Write-Information "Settings Loaded."

Import-Module ShawUtil

Write-Information "Prompting for Admin ID..."
if(!$settings.admin_id){
    $admcred = Get-Credential -Message 'Please provide your admin ID. This will be stored in the variable $admcred for future use.'
    Write-Information 'Credential $admcred created.'
    $settings.admin_id = $admcred.UserName
    $settings | ConvertTo-Json -depth 100 | Out-File "$PSScriptRoot\config.json"
    Write-Information "Admin Username saved."
    if($settings.store_admin_id){
        $admcred | Export-CliXml -Path "$PSScriptRoot\admcred.xml"
    }
} else {
    #check if we have a credential
    if(Test-Path -Path "$PSScriptRoot\admcred.xml"){
        $admcred = Import-Clixml -Path "$PSScriptRoot\admcred.xml"
    } else {
        $admcred = Get-Credential -UserName $settings.admin_id -Message 'Please provide your admin ID. This will be stored in the variable $admcred for future use.'
        if($settings.store_admin_id){
            $admcred | Export-CliXml -Path "$PSScriptRoot\admcred.xml"
        }
    }
    
    Write-Information 'Credential $admcred created.'
}

if($settings.vmware_autoconnect){
    Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -Confirm:$false | Out-Null
    Write-Output "Connecting to vSphere..."
    Connect-VIServer sw72vmvc1 -AllLinked -Credential $admcred | Out-Null
    Write-Output "Connected."
}


