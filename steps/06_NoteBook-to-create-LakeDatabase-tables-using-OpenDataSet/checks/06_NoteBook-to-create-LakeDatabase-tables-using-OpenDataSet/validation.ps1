param(
    [string]
    $WorkSpacename
)

$notebook = Get-AzSynapseNotebook -WorkspaceName $WorkSpacename -Name ntb_Open_DataSet_To_LakeDB
if ($notebook)
{
    Write-Host "notebook ntb_Open_DataSet_To_LakeDB created"
}
else
{
    Write-Host "notebook ntb_Open_DataSet_To_LakeDB not created"
}
