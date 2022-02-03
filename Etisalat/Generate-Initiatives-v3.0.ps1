# Script to generate ARM template for azure initiatives
[string]$baseFolderPath = "C:\Repos\EESLZPolicies\Etisalat"
[string]$outputInitiativeFilePath = "C:\Temp-Local\Initiative.json"
[string]$mgmtGroupId = "Etisalat"

function AddInitiativeArmTemplate([string]$initiativeSourcePath, [string]$outputInitiativeFilePath,[string]$mgmtGroupId){
    "        {" | Out-File -FilePath $outputInitiativeFilePath -Append

    $initiative = Get-Content -Path $initiativeSourcePath | ConvertFrom-Json
    "           `"type`": `"Microsoft.Authorization/policySetDefinitions`"," | Out-File -FilePath $outputInitiativeFilePath -Append
    "           `"name`": `"$($initiative.name)`"," | Out-File -FilePath $outputInitiativeFilePath -Append
    "           `"apiVersion`": `"2019-09-01`"," | Out-File -FilePath $outputInitiativeFilePath -Append
    "            `"properties`": {" | Out-File -FilePath $outputInitiativeFilePath -Append
    "                `"displayName`": `"$($initiative.properties.displayName)`"," | Out-File -FilePath $outputInitiativeFilePath -Append
    "                `"description`": `"$($initiative.properties.description)`"," | Out-File -FilePath $outputInitiativeFilePath -Append
    $metadata = $initiative.properties.metadata | Select-Object * -ExcludeProperty createdBy,createdOn,updatedBy,updatedOn | ConvertTo-Json -Depth 5
    $metadata = $metadata.Replace("/providers/Microsoft.Management/managementGroups/ESLZ","/providers/Microsoft.Management/managementGroups/$mgmtGroupId")
    "                `"metadata`": $metadata," | Out-File -FilePath $outputInitiativeFilePath -Append
    "                `"parameters`": $($initiative.properties.parameters | ConvertTo-Json -Depth 5)," | Out-File -FilePath $outputInitiativeFilePath -Append
    $policyDefinition = ($initiative.properties.policyDefinitions | ConvertTo-Json -Depth 5).Replace("`"[","`"[[")
    $policyDefinition = $policyDefinition.Replace("/providers/Microsoft.Management/managementGroups/ESLZ","/providers/Microsoft.Management/managementGroups/$mgmtGroupId")
    "                `"policyDefinitions`": $policyDefinition" | Out-File -FilePath $outputInitiativeFilePath -Append
    "            }" | Out-File -FilePath $outputInitiativeFilePath -Append
    "        }," | Out-File -FilePath $outputInitiativeFilePath -Append

}


# list all initiatives in initiatives folder
$policySetsFolderPath = $baseFolderPath + "\initiatives"
$policySetDefinitions = Get-ChildItem -Path $policySetsFolderPath

# create ARM template header
"{" | Out-File -FilePath $outputInitiativeFilePath
"    `"`$schema`": `"https://schema.management.azure.com/schemas/2019-08-01/managementGroupDeploymentTemplate.json#`"," | Out-File -FilePath $outputInitiativeFilePath -Append
"    `"contentVersion`": `"1.0.0.0`"," | Out-File -FilePath $outputInitiativeFilePath -Append
"    `"parameters`": {}," | Out-File -FilePath $outputInitiativeFilePath -Append    
"    `"variables`": {}," | Out-File -FilePath $outputInitiativeFilePath -Append    
"    `"resources`": [" | Out-File -FilePath $outputInitiativeFilePath -Append

# import initiatives
foreach($policySetDefinition in $policySetDefinitions){
    $policySetDefinitionPath = $policySetDefinition.FullName + "\policyset.json"
    AddInitiativeArmTemplate $policySetDefinitionPath $outputInitiativeFilePath $mgmtGroupId
    <#
    $policySetDefinitionPath
    $outputInitiativeFilePath
    Write-Host " " 
    #>
}

# close the ARM template
"    ]," | Out-File -FilePath $outputInitiativeFilePath -Append
"    `"outputs`": {}" | Out-File -FilePath $outputInitiativeFilePath -Append    
"}" | Out-File -FilePath $outputInitiativeFilePath -Append    
