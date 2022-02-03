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

    $initiativeSourceContent = Get-Content -Path $initiativeSourcePath
    foreach($line in $initiativeSourceContent){
        # read each line from the exported initiative
        # if the line says "policyType" then delete it
        if($line -match "`"policyType`""){}
        
        # if the lines says "category" then delete any trailing comma
        elseif($line -match "`"category`""){
            $line.Substring(0,$line.IndexOf(",")) | Out-File -FilePath $initiativeOutputPath -Append
        }

        # if the line says "createdBy" then delete it
        elseif($line -match "`"policyType`""){}

        # if the line says "createdOn" then delete it
        elseif($line -match "`"createdOn`""){}

        # if the line says "updatedBy" then delete it
        elseif($line -match "`"updatedBy`""){}

        # if the line says "updatedOn" then delete it
        elseif($line -match "`"updatedOn`""){}

        # if the line says "createdBy" then delete it
        elseif($line -match "`"createdBy`""){}

        # if the line says "value": "[ then add a training [
        elseif($line -match "`"value`": `"\["){
            $line.Replace("`"value`": `"[","`"value`": `"[[") | Out-File -FilePath $initiativeOutputPath -Append
        }

        # if the line says "id" then delete it
        elseif($line -match "`"id`""){}

        # if the line says /providers/Microsoft.Management/managementGroups/ESLZ then replace ESLZ by the policies management group id
        elseif($line -match "/providers/Microsoft.Management/managementGroups/ESLZ"){
            $line.Replace("/providers/Microsoft.Management/managementGroups/ESLZ","/providers/Microsoft.Management/managementGroups/" + $mgmtGroupId.ToString()) | Out-File -FilePath $initiativeOutputPath -Append
        }

        # if we are writing the type field, we need also to add the apiversion field
        elseif ($line -match "`"type`": `"Microsoft.Authorization/policySetDefinitions`","){
            $line | Out-File -FilePath $initiativeOutputPath -Append
            "`"apiVersion`": `"2020-09-01`"," | Out-File -FilePath $initiativeOutputPath -Append
        }

        else{
            $line | Out-File -FilePath $initiativeOutputPath -Append
        }
    }

    # close the ARM template
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
