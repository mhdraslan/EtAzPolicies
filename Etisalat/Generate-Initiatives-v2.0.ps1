# Script to generate ARM template for azure initiatives
[string]$baseFolderPath = "C:\Repos\EESLZPolicies\Etisalat"
[string]$outputInitiativeFileName = "Initiative.json"
[string]$mgmtGroupId = "Etisalat"

function CreateInitiativeArmTemplate([string]$initiativeSourcePath, [string]$initiativeOutputPath,[string]$mgmtGroupId){
    # create new blank ARM template
    "{" | Out-File -FilePath $initiativeOutputPath
    "    `"`$schema`": `"https://schema.management.azure.com/schemas/2019-08-01/managementGroupDeploymentTemplate.json#`"," | Out-File -FilePath $initiativeOutputPath -Append
    "    `"contentVersion`": `"1.0.0.0`"," | Out-File -FilePath $initiativeOutputPath -Append
    "    `"parameters`": {}," | Out-File -FilePath $initiativeOutputPath -Append    
    "    `"variables`": {}," | Out-File -FilePath $initiativeOutputPath -Append    
    "    `"resources`": [" | Out-File -FilePath $initiativeOutputPath -Append
    "        {" | Out-File -FilePath $initiativeOutputPath -Append

    $initiative = Get-Content -Path $initiativeSourcePath | ConvertFrom-Json
    "           `"type`": `"Microsoft.Authorization/policySetDefinitions`"," | Out-File -FilePath $initiativeOutputPath -Append
    "           `"name`": `"$($initiative.name)`"," | Out-File -FilePath $initiativeOutputPath -Append
    "           `"apiVersion`": `"2019-09-01`"," | Out-File -FilePath $initiativeOutputPath -Append
    "            `"properties`": {" | Out-File -FilePath $initiativeOutputPath -Append
    "                `"displayName`": `"$($initiative.properties.displayName)`"," | Out-File -FilePath $initiativeOutputPath -Append
    "                `"description`": `"$($initiative.properties.description)`"," | Out-File -FilePath $initiativeOutputPath -Append
    $metadata = $initiative.properties.metadata | Select-Object * -ExcludeProperty createdBy,createdOn,updatedBy,updatedOn | ConvertTo-Json -Depth 5
    $metadata = $metadata.Replace("/providers/Microsoft.Management/managementGroups/ESLZ","/providers/Microsoft.Management/managementGroups/$mgmtGroupId")
    "                `"metadata`": $metadata," | Out-File -FilePath $initiativeOutputPath -Append
    "                `"parameters`": $($initiative.properties.parameters | ConvertTo-Json -Depth 5)," | Out-File -FilePath $initiativeOutputPath -Append
    $policyDefinition = ($initiative.properties.policyDefinitions | ConvertTo-Json -Depth 5).Replace("`"[","`"[[")
    $policyDefinition = $policyDefinition.Replace("/providers/Microsoft.Management/managementGroups/ESLZ","/providers/Microsoft.Management/managementGroups/$mgmtGroupId")
    "                `"policyDefinitions`": $policyDefinition" | Out-File -FilePath $initiativeOutputPath -Append
    "            }" | Out-File -FilePath $initiativeOutputPath -Append

    # close the ARM template
    "        }" | Out-File -FilePath $initiativeOutputPath -Append
    "    ]," | Out-File -FilePath $initiativeOutputPath -Append
    "    `"outputs`": {}" | Out-File -FilePath $initiativeOutputPath -Append    
    "}" | Out-File -FilePath $initiativeOutputPath -Append    
}


# list all initiatives in initiatives folder
$policySetsFolderPath = $baseFolderPath + "\initiatives"
$policySetDefinitions = Get-ChildItem -Path $policySetsFolderPath

# import initiatives
foreach($policySetDefinition in $policySetDefinitions){
    $policySetDefinitionPath = $policySetDefinition.FullName + "\policyset.json"
    $initiativeOutputPath = $policySetDefinition.FullName + "\" + $outputInitiativeFileName
    CreateInitiativeArmTemplate $policySetDefinitionPath $initiativeOutputPath $mgmtGroupId
    <#
    $policySetDefinitionPath
    $initiativeOutputPath
    Write-Host " " 
    #>
}
