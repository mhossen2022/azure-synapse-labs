param(
    [string]
    $WorkSpacename
)
$pipeline = Get-AzSynapsePipeline -WorkspaceName $WorkSpacename -Name Load CSV_data_to_adworks
if ($pipeline)
{
    Write-Host "pipeline created"
}
else
{
    Write-Host "pipeline not created"
}
