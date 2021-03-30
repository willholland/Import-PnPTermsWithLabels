[CmdletBinding()]
PARAM(
    [Parameter(Mandatory=$true)]
    [string]$TenantAdminUrl
    [Parameter(Mandatory=$true)]
    [string]$Path
)
BEGIN{

}
PROCESS{
    Connect-PnPOnline $TenantAdminUrl -Interactive

    # Load the CSV Data
    $data = Import-Csv -Path $path | Group-Object -Property termGroup, termSet

    if($null -eq $data -or $data.Length -eq 0){
        Write-Error "No data to import"
    }
    else{
        foreach($grouping in $data){            
            $termGroup = $grouping.Group[0].termGroup
            $termSet = $grouping.Group[0].termSet

            # Try to create the Term Group & Term Set, in case they don't exist
            New-PnPTermGroup -Name $termGroup -ErrorAction SilentlyContinue | Out-Null
            New-PnPTermSet -Name $termSet -TermGroup $termGroup -ErrorAction SilentlyContinue | Out-Null

            foreach($term in $grouping.Group){
                try{
                    $termName = $term.Name.Trim()
                    # Get or Create the Term
                    $oTerm = Get-PnPTerm -Identity $termName -TermGroup $termGroup -TermSet $termSet -ErrorAction SilentlyContinue
                    if($null -eq $oTerm){
                        $oTerm = New-PnPTerm -Name $termName -TermGroup $termGroup -TermSet $termSet -ErrorAction Stop
                    }

                    # Split our labels & add each to term
                    $labels = $term.Labels.split(';')
                    $update = $false                
                    for($i = 0; $i -lt $labels.Count; $i++){
                        $label = $labels[$i]

                        if(![string]::IsNullOrWhiteSpace($label) -and $label -ne $termName){
                            $oTerm.CreateLabel($label, $term.LCID, $false) | Out-Null
                            $update = $true
                        }
                    }
                    
                    # Update the term
                    if($update){
                        try{
                            Invoke-PnPQuery -ErrorAction Stop | Out-Null
                        }
                        catch{
                            if(!$_.Exception.Message.StartsWith('Cannot create a duplicated label')){
                                Write-Error "Error adding labels to term $($termName): $_"
                            }
                        }
                    }
                }
                catch{
                    Write-Error "Error adding Term. Term Group: '$termGroup', Term Set: '$termSet', Term Name: '$termName'"
                }
            }
        }
    }
}
END{
    Disconnect-PnPOnline
}
