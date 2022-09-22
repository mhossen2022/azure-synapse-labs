param(
    [string]
    $WorkSpacename
)

$dataset1 = Get-AzSynapseDataset -WorkspaceName $WorkSpacename -Name adworksraw
if ($dataset1)
{
    Write-Host "dataset adworksraw created"
}
else
{
    Write-Host "dataset adworksraw not created"
}
$dataset2 = Get-AzSynapseDataset -WorkspaceName $WorkSpacename -Name raw
if ($dataset2)
{
    Write-Host "dataset raw created"
}
else
{
    Write-Host "dataset raw not created"
}
