param(
    [string]
    $Resourcegroupname
)
$WorkSpace = Get-AzResource -ResourceGroupName $Resourcegroupname -Resourcetype Microsoft.Synapse/workspaces
$WorkSpacename = $WorkSpace.Name

$notebook = Get-AzSynapseNotebook -WorkspaceName $WorkSpacename -Name ntb_Open_DataSet_To_ADLS
if ($notebook)
{
    Write-Host "notebook ntb_Open_DataSet_To_ADLS created"
}
else
{
    Write-Host "notebook ntb_Open_DataSet_To_ADLS not created"
}

$notebook = Get-AzSynapseNotebook -WorkspaceName $WorkSpacename -Name ntb_Open_DataSet_To_LakeDB
if ($notebook)
{
    Write-Host "notebook ntb_Open_DataSet_To_LakeDB created"
}
else
{
    Write-Host "notebook ntb_Open_DataSet_To_LakeDB not created"
}
