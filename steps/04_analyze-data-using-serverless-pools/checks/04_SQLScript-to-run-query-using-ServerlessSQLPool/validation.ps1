param(
    [string]
    $Resourcegroupname
)
$WorkSpace = Get-AzResource -ResourceGroupName $Resourcegroupname -Resourcetype Microsoft.Synapse/workspaces
$WorkSpacename = $WorkSpace.Name
$sqlscript = Get-AzSynapseSqlScript  -WorkspaceName $WorkSpacename -Name nyc_sql
if ($sqlscript)
{
    Write-Host "Sql Script nyc_sql created"
}
else
{
    Write-Host "Sql Script nyc_sql not created"
}
