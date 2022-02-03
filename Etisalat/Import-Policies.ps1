# define variables
$mgmtGroupId = "Etisalat"
$baseFolderPath = "C:\Repos\EESLZPolicies\Etisalat"


# list all policies in policies folder
$policiesFolderPath = $baseFolderPath + "\policies"
$policyDefinitions = Get-ChildItem -Path $policiesFolderPath

# import policies
foreach($policyDefinition in $policyDefinitions){
    $policyDefinitionFile = $policyDefinition.FullName + "\policy-arm.json"
    $policyName = $policyDefinition.Name
    <#
    if($policyName.Length -gt 64) {$policyName = $($policyDefinition.Name).Substring(0,63)}
    #$policyName
    $importOutput = New-AzPolicyDefinition -Name $policyName -ManagementGroupName $mgmtGroupId -Policy $policyDefinitionFile
    $importOutput
    #>
    New-AzManagementGroupDeployment -Name "PolicyDeployment-$policyName" -ManagementGroupId $mgmtGroupId -Location UAENorth -TemplateFile $policyDefinitionFile
}
#>

$initiativesFolderPath = $baseFolderPath + "\initiatives"
$initiativeDefinitions = Get-ChildItem -Path $initiativesFolderPath

# import initiatives
foreach($initiativeDefinition in $initiativeDefinitions){
    $initiativeDefinitionFile = $initiativeDefinition.FullName + "\initiative.json"
    $initaitiveName = $initiativeDefinition.Name

    New-AzManagementGroupDeployment -Name "InitiativeDeployment-$initaitiveName" -ManagementGroupId $mgmtGroupId -Location UAENorth -TemplateFile $initiativeDefinitionFile
}
#>



