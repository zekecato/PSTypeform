function Get-TFResponse {
    param(
        [Parameter(Mandatory=$true)]
        [string]$FormID,
        [int]$PageSize = 1000,
        #only submitted forms
        [bool]$Completed = $true,
        #contains substring
        [string]$SearchString
    )

    #region Set Query Parameters
    $Query = [TFQueryParameters]::new()
    $Query.Hashtable.Add('completed',$Completed.ToString().ToLower())
    $Query.Hashtable.Add('page_size',$PageSize)

    if($SearchString){
        $Query.Hashtable.Add('query',$SearchString)
    }

    #endregion query parameters

    $Uri = "/forms/$FormID/responses"
    $CallArgs = @{
        Method = 'GET'
    }

    $allresults=@()
    do{
        Write-Verbose "Calling for records from Typeform"

        $Callargs['Uri'] = $Uri + $Query.ToURLString()
        $resultset = Invoke-TFCall @CallArgs

        $allresults += $resultset.items
        $Query.Hashtable['before'] = $resultset.items[-1].token
    }while($resultset.items.count -eq $PageSize)

    Write-Verbose "Found $($allresults.count) responses at TypeForm"
    return $allresults


}