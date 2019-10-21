function Invoke-TFCall {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Uri,

        [Parameter(Mandatory=$true)]
        [Microsoft.PowerShell.Commands.WebRequestMethod]$Method,

        [Parameter()]
        $Body,

        [Parameter()]
        $APIKey = $TFAPIKey
    )

    $FullUri = $config.API.Endpoint + $Uri
    $RestArgs = @{
        #ContentType = 'application/json'
        Uri = $FullUri
        Headers = @{
           # 'Content-type'= 'application/json'
            Authorization = 'Bearer '+ $APIKey
            Accept = 'application/json'
        }
        Method = $Method
    }

    if($Body){
        $RestArgs.Add('Body',$Body) | Out-Null
    }

    Invoke-RestMethod @RestArgs
}