param(
    [string]
    $Resourcegroupname
)
$WorkSpace = Get-AzResource -ResourceGroupName $Resourcegroupname -Resourcetype Microsoft.Synapse/workspaces
$WorkSpacename = $WorkSpace.Name
  $df = Get-AzSynapseDataFlow -WorkspaceName $WorkSpacename -Name adworks_DF
  if ($df.Name -eq "adworks_DF") { 
    Write-Host "Data flow adworks_DF created" }
else { Write-Host "Data flow adworks_DF not created" }
