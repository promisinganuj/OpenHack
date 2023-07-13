

param(
    [string]$teamCount = "5",
    [string]$DeploymentTemplateFile = "$PSScriptRoot\ARM\DeployMDWOpenHackLab.json",
    [string]$DeploymentParameterFile = "$PSScriptRoot\ARM\DeployMDWOpenHackLab.parameters.json",
    [string]$Location = "westus3",
    [securestring]$SqlAdminLoginPassword,
    [securestring]$VMAdminPassword
)
$teamCount = Read-Host "How many teams are hacking?";

for ($i = 0; $i -le $teamCount; $i++)
{
    $teamName = $i;
    if ($i -lt 10)
    {
        $teamName = "0" + $i;
    }

    $region = switch($i)
        {
            0 {"australiaeast"}
            1 {"australiaeast"}
            2 {"australiaeast"}
            3 {"centralindia"}
            4 {"centralindia"}
            5 {"centralindia"}
        }

    $purviewName = "pview-team-" + $teamName
    $resourceGroupName = "rg-fabric-oh-team-" + $teamName
    $deploymentName = "azuredeploy" + "-" + (Get-Date).ToUniversalTime().ToString('MMdd-HHmmss')
    Write-Host("Now deploying RG to " + $resourceGroupName);

    New-AzResourceGroup -Name $resourceGroupName -Location $region

    $resourceGroup = Get-AzResourceGroup -Name $ResourceGroupName -ErrorVariable notPresent -ErrorAction SilentlyContinue
    if (!$resourceGroup) {
        $resourceGroup = New-AzResourceGroup -Name $ResourceGroupName -Location $region
    }
    New-AzResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroupName -Location $region -TemplateFile $DeploymentTemplateFile -TemplateParameterFile $DeploymentParameterFile -purviewName $purviewName -sqlAdminLoginPassword $SqlAdminLoginPassword -VMAdminPassword $VMAdminPassword -AsJob    
}
