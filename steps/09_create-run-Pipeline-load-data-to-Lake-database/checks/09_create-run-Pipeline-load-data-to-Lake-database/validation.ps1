param(
    [string]
    $Resourcegroupname
)
$WorkSpace = Get-AzResource -ResourceGroupName $Resourcegroupname -Resourcetype Microsoft.Synapse/workspaces
$WorkSpacename = $WorkSpace.Name
$pipeline = Get-AzSynapsePipeline -WorkspaceName $WorkSpacename -Name Load_CSV_data_to_adworks
if ($pipeline)
{
    Write-Host "pipeline created"
}
else
{
    Write-Host "pipeline not created"
}
