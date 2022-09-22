param(
    [string]
    $WorkSpacename
)
$sqlscript = Get-AzSynapseSqlScript  -WorkspaceName $WorkSpacename -Name create_table_dedicated
if ($sqlscript)
{
    Write-Host "Sql Script create_table_dedicated created"
}
else
{
    Write-Host "Sql Script create_table_dedicated not created"
}
