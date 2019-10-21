function Get-TFForm {
    [CmdletBinding(DefaultParameterSetName = 'Bulk')]
    param(
        [Parameter(Mandatory=$true,ParameterSetName='Individual',Position=1)]
        [string]$Id,

        [Parameter(ParameterSetName='Bulk')]
        [string]$SearchString,
        
        [Parameter(ParameterSetName='Bulk')]
        [int]$PageStart = 1,
        
        [Parameter(ParameterSetName='Bulk')]
        [int]$PageSize = 200,
        
        [Parameter(ParameterSetName='Bulk')]
        [string]$WorkspaceID
    )
    
        $Uri = "/forms"
        $CallArgs = @{
            Method = 'GET'
        }
        #If we are getting a specific object then build up the URI here
        if($Id){
            $Uri += "/$Id"
                    $CallArgs.add('Uri',$Uri)

        return Invoke-TFCall @CallArgs

        }
        #If we have a query to submit or just want all records for a particular resource then build up the URI here.

        $Query = [TFQueryParameters]::new()
        $Query.Hashtable = @{
            page = $PageStart
            page_size = $PageSize
        }
        if($WorkspaceID){$Query.Hashtable.Add('workspace_id',$WorkspaceID)}
        if($SearchString){$Query.Hashtable.Add('search',$SearchString)}

        $allresults=@()
        do{
            Write-Verbose "Calling for records from Typeform"

            $Callargs['Uri'] = $Uri + $Query.ToURLString()
            $resultset = Invoke-TFCall @CallArgs

            $allresults += $resultset.items
            $Query.Hashtable.page++
        }while($resultset.items.count -eq $PageSize)

        Write-Verbose "Found $($allresults.count) forms at TypeForm"
        return $allresults
 

        
}