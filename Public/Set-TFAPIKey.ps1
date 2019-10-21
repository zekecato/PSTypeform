<#
Use this function to save your API key in your powershell profile to be loaded on module import.
#>
function Set-TFAPIKey {
    param(
        [Parameter(Mandatory=$true, position=0,HelpMessage="Please enter your TypeForm API key")]
        [ValidateNotNullOrEmpty()]
        [string]$APIKey
    )

#if there is no powershell profile, create one.
    if (!(Test-Path $profile.CurrentUserAllHosts)){New-Item -ItemType File $profile.CurrentUserAllHosts}
#Load profile contents into memory
    $profileContent = Get-Content $profile.CurrentUserAllHosts
#check for line in profile which sets api key
    Switch ($profileContent){
        {$_ -like '$TFAPIKey*'} {$ProfileSetKeyPath = $true}
    }
#if api key path is set in profile, then replace that line with the new user specified path. Otherwise, append setting to end pf profile.
    if ($ProfileSetKeyPath){
        $profileContent | ForEach-Object { $_ -replace '^\$TFAPIKey.*$',"`$TFAPIKey = '$APIKey'"} | Set-Content $profile.CurrentUserAllHosts
    }else{
        '' | Out-File $profile.CurrentUserAllHosts -Append -Encoding utf8
        "`$TFAPIKey = `"$APIKey`"" | Add-Content $profile.CurrentUserAllHosts -Force -Encoding UTF8
    }

    $Global:TFAPIKey = $APIKey
}
