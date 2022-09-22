param(
    [string]
    $WorkSpacename
)

$notebook = Get-AzSynapseNotebook -WorkspaceName $WorkSpacename -Name ntb_Open_DataSet_To_ADLS
if ($notebook)
{
    Write-Host "notebook ntb_Open_DataSet_To_ADLS created"
}
else
{
    Write-Host "notebook ntb_Open_DataSet_To_ADLS not created"
}
