param(
    [string]
    $Resourcegroupname
)
$WorkSpace = Get-AzResource -ResourceGroupName ayush-e2e-synapse-lab15 -Resourcetype Microsoft.Synapse/workspaces
$WorkSpacename = $WorkSpace.Name
$pipeline = Get-AzSynapsePipeline -WorkspaceName $WorkSpacename -Name Load CSV_data_to_adworks
if ($pipeline)
{
    Write-Host "pipeline created"
}
else
{
    Write-Host "pipeline not created"
}
