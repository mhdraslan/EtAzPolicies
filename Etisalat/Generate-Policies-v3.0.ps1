# Script to generate ARM template for azure initiatives
[string]$baseFolderPath = "C:\Repos\EESLZPolicies\Etisalat"
[string]$outputPolicyFilePath = "C:\Temp-Local\policies.json"

function AddPolicyArmTemplate([string]$policySourcePath, [string]$outputPolicyFilePath){
    $policy = Get-Content -Path $policySourcePath | ConvertFrom-Json
    "        {" | Out-File -FilePath $outputPolicyFilePath -Append
    "           `"type`": `"Microsoft.Authorization/policyDefinitions`"," | Out-File -FilePath $outputPolicyFilePath -Append
    "           `"name`": `"$($policy.name)`"," | Out-File -FilePath $outputPolicyFilePath -Append
    "           `"apiVersion`": `"2019-09-01`"," | Out-File -FilePath $outputPolicyFilePath -Append
    "            `"properties`": {" | Out-File -FilePath $outputPolicyFilePath -Append
    "                `"displayName`": `"$($policy.properties.displayName)`"," | Out-File -FilePath $outputPolicyFilePath -Append
    "                `"description`": `"$($policy.properties.description)`"," | Out-File -FilePath $outputPolicyFilePath -Append
    "                `"mode`": `"$($policy.properties.mode)`"," | Out-File -FilePath $outputPolicyFilePath -Append
    $metadata = $policy.properties.metadata | Select-Object * -ExcludeProperty createdBy,createdOn,updatedBy,updatedOn | ConvertTo-Json -Depth 10
    $metadata = $metadata.Replace("/providers/Microsoft.Management/managementGroups/ESLZ","/providers/Microsoft.Management/managementGroups/$mgmtGroupId")
    "                `"metadata`": $metadata," | Out-File -FilePath $outputPolicyFilePath -Append
    "                `"parameters`": $($policy.properties.parameters | ConvertTo-Json -Depth 10)," | Out-File -FilePath $outputPolicyFilePath -Append
    $policyRule = ($policy.properties.policyRule | ConvertTo-Json -Depth 10).Replace("`"[","`"[[")
    $policyRule = $policyRule.Replace("/providers/Microsoft.Management/managementGroups/ESLZ","/providers/Microsoft.Management/managementGroups/$mgmtGroupId")
    "                `"policyRule`": $policyRule" | Out-File -FilePath $outputPolicyFilePath -Append
    "            }" | Out-File -FilePath $outputPolicyFilePath -Append
    "        }," | Out-File -FilePath $outputPolicyFilePath -Append
}

# list all policies in policies folder
$policiesFolderPath = $baseFolderPath + "\policies"
$policyDefinitions = Get-ChildItem -Path $policiesFolderPath

# create ARM template header
"{" | Out-File -FilePath $outputPolicyFilePath
"    `"`$schema`": `"https://schema.management.azure.com/schemas/2019-08-01/managementGroupDeploymentTemplate.json#`"," | Out-File -FilePath $outputPolicyFilePath -Append
"    `"contentVersion`": `"1.0.0.0`"," | Out-File -FilePath $outputPolicyFilePath -Append
"    `"parameters`": {}," | Out-File -FilePath $outputPolicyFilePath -Append    
"    `"variables`": {}," | Out-File -FilePath $outputPolicyFilePath -Append    
"    `"resources`": [" | Out-File -FilePath $outputPolicyFilePath -Append


# add policies as resources
foreach($policyDefinition in $policyDefinitions){
    $policyDefinitionPath = $policyDefinition.FullName + "\policy.json"
    AddPolicyArmTemplate $policyDefinitionPath $outputPolicyFilePath
    <#
    $policyDefinitionPath
    $outputPolicyFilePath
    Write-Host " " 
    #>
}


# close the ARM template
"    ]," | Out-File -FilePath $outputPolicyFilePath -Append
"    `"outputs`": {}" | Out-File -FilePath $outputPolicyFilePath -Append    
"}" | Out-File -FilePath $outputPolicyFilePath -Append    
