# Script to generate ARM template for azure initiatives
[string]$baseFolderPath = "C:\Repos\EESLZPolicies\Etisalat"
[string]$outputPolicyFileName = "policy-arm.json"

function CreatePolicyArmTemplate([string]$policySourcePath, [string]$policyOutputPath){
    # create new blank ARM template
    "{" | Out-File -FilePath $policyOutputPath
    "    `"`$schema`": `"https://schema.management.azure.com/schemas/2019-08-01/managementGroupDeploymentTemplate.json#`"," | Out-File -FilePath $policyOutputPath -Append
    "    `"contentVersion`": `"1.0.0.0`"," | Out-File -FilePath $policyOutputPath -Append
    "    `"parameters`": {}," | Out-File -FilePath $policyOutputPath -Append    
    "    `"variables`": {}," | Out-File -FilePath $policyOutputPath -Append    
    "    `"resources`": [" | Out-File -FilePath $policyOutputPath -Append
    "        {" | Out-File -FilePath $policyOutputPath -Append

    $policy = Get-Content -Path $policySourcePath | ConvertFrom-Json
    "           `"type`": `"Microsoft.Authorization/policyDefinitions`"," | Out-File -FilePath $policyOutputPath -Append
    "           `"name`": `"$($policy.name)`"," | Out-File -FilePath $policyOutputPath -Append
    "           `"apiVersion`": `"2019-09-01`"," | Out-File -FilePath $policyOutputPath -Append
    "            `"properties`": {" | Out-File -FilePath $policyOutputPath -Append
    "                `"displayName`": `"$($policy.properties.displayName)`"," | Out-File -FilePath $policyOutputPath -Append
    "                `"description`": `"$($policy.properties.description)`"," | Out-File -FilePath $policyOutputPath -Append
    "                `"mode`": `"$($policy.properties.mode)`"," | Out-File -FilePath $policyOutputPath -Append
    $metadata = $policy.properties.metadata | Select-Object * -ExcludeProperty createdBy,createdOn,updatedBy,updatedOn | ConvertTo-Json -Depth 5
    $metadata = $metadata.Replace("/providers/Microsoft.Management/managementGroups/ESLZ","/providers/Microsoft.Management/managementGroups/$mgmtGroupId")
    "                `"metadata`": $metadata," | Out-File -FilePath $policyOutputPath -Append
    "                `"parameters`": $($policy.properties.parameters | ConvertTo-Json -Depth 5)," | Out-File -FilePath $policyOutputPath -Append
    $policyRule = ($policy.properties.policyRule | ConvertTo-Json -Depth 5).Replace("`"[","`"[[")
    $policyRule = $policyRule.Replace("/providers/Microsoft.Management/managementGroups/ESLZ","/providers/Microsoft.Management/managementGroups/$mgmtGroupId")
    "                `"policyRule`": $policyRule" | Out-File -FilePath $policyOutputPath -Append
    "            }" | Out-File -FilePath $policyOutputPath -Append


    # close the ARM template
    "    ]," | Out-File -FilePath $policyOutputPath -Append
    "    `"outputs`": {}" | Out-File -FilePath $policyOutputPath -Append    
    "}" | Out-File -FilePath $policyOutputPath -Append    
}

# list all policies in policies folder
$policiesFolderPath = $baseFolderPath + "\policies"
$policyDefinitions = Get-ChildItem -Path $policiesFolderPath

# import policies
foreach($policyDefinition in $policyDefinitions){
    $policyDefinitionPath = $policyDefinition.FullName + "\policy.json"
    $policyOutputPath = $policyDefinition.FullName + "\" + $outputPolicyFileName
    CreatePolicyArmTemplate $policyDefinitionPath $policyOutputPath
    <#
    $policyDefinitionPath
    $policyOutputPath
    Write-Host " " 
    #>
}
