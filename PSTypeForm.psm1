#region Import Functions
#Get public and private function definition files.
    $Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
    $Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
    Foreach($import in @($Public + $Private))
    {
        Try
        {
            . $import.fullname
        }
        Catch
        {
            Write-Error -Message "Failed to import function $($import.fullname): $_"
        }
    }
#endregion

#Load the config file
$Script:Config = Import-PowerShellDataFile $PSScriptRoot\config.psd1

#If there's no API Key loaded in the profile, prompt the user to set one, unless it's the task scheduling user. In that case, load from config.
if(!$TFAPIKey -and $env:USERNAME -ne $Config.ScheduledTask.User){
    Set-TFAPIKey
}

if($env:USERNAME -eq $Config.ScheduledTask.User){
    $Global:TFAPIKey = $Config.ScheduledTask.APIKey
}

Export-ModuleMember -Function $Public.Basename

enum TFResource {
    Forms
    Workspace
}

class TFQueryParameters {
    
    [hashtable]$Hashtable = @{}

    [string]ToURLString(){
        $Output = '?'
        foreach($Param in $this.Hashtable.Keys){
            if($this.Hashtable."$Param".gettype().basetype.name -eq 'Array'){
                $Output+="$Param=$($this.Hashtable."$Param" -join ',')&"
                continue
            }
            $Output+="$Param=$($this.Hashtable."$Param")&"
        }
        $Output.TrimEnd('&')

        return $Output
    }
}