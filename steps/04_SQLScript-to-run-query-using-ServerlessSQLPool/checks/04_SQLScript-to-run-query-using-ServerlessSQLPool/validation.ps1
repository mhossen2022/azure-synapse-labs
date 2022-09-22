param(
    [string]
    $WorkSpacename
)
$sqlscript = Get-AzSynapseSqlScript  -WorkspaceName $WorkSpacename -Name nyc_sql
if ($sqlscript)
{
    Write-Host "Sql Script nyc_sql created"
}
else
{
    Write-Host "Sql Script nyc_sql not created"
}
