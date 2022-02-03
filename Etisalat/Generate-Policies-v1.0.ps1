# Script to generate ARM template for azure initiatives
[string]$baseFolderPath = "C:\Repos\EESLZPolicies\Etisalat"
[string]$outputInitiativeFileName = "policy-arm.json"

function CreatePolicyArmTemplate([string]$policySourcePath, [string]$policyOutputPath){
    # create new blank ARM template
    "{" | Out-File -FilePath $policyOutputPath
    "    `"`$schema`": `"https://schema.management.azure.com/schemas/2019-08-01/managementGroupDeploymentTemplate.json#`"," | Out-File -FilePath $policyOutputPath -Append
    "    `"contentVersion`": `"1.0.0.0`"," | Out-File -FilePath $policyOutputPath -Append
    "    `"parameters`": {}," | Out-File -FilePath $policyOutputPath -Append    
    "    `"variables`": {}," | Out-File -FilePath $policyOutputPath -Append    
    "    `"resources`": [" | Out-File -FilePath $policyOutputPath -Append

    $policySourceContent = Get-Content -Path $policySourcePath
    [bool]$inMetadataBlock = $false
    foreach($line in $policySourceContent){
        # read each line from the exported initiative
        # if the line says "policyType" then delete it
        if($line -match "`"policyType`""){}

        # if the line says "metadata" then set flag
        elseif($line -match "`"metadata`""){
            $inMetadataBlock = $true
            $line | Out-File -FilePath $policyOutputPath -Append
        }

        # if the line says } then check if it was the closure of the metadata section
        elseif(($line -match "}") -and ($inMetadataBlock)){
            $inMetadataBlock = $false
            $line | Out-File -FilePath $policyOutputPath -Append
        }

        # if the lines says "category" then delete any trailing comma
        elseif(($line -match "`"category`"") -and ($inMetadataBlock)){
            $line.Substring(0,$line.IndexOf(",")) | Out-File -FilePath $policyOutputPath -Append
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

        # if the line says "[ then add a training [
        elseif($line -match "`"\["){
            $line.Replace("`"[","`"[[") | Out-File -FilePath $policyOutputPath -Append
        }

        # if the line says "id" then delete it
        elseif($line -match "`"id`""){}

        # if we are writing the type field, we need also to add the apiversion field
        elseif ($line -match "`"type`": `"Microsoft.Authorization/policyDefinitions`","){
            $line | Out-File -FilePath $policyOutputPath -Append
            "`"apiVersion`": `"2019-09-01`"," | Out-File -FilePath $policyOutputPath -Append
        }

        else{
            $line | Out-File -FilePath $policyOutputPath -Append
        }
    }

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
    $policyOutputPath = $policyDefinition.FullName + "\" + $outputInitiativeFileName
    CreatePolicyArmTemplate $policyDefinitionPath $policyOutputPath
    <#
    $policyDefinitionPath
    $policyOutputPath
    Write-Host " " 
    #>
}
