# Script to fix exported azure policies folder names to be used when importing them back
$baseFolderPath = "C:\Repos\EESLZPolicies\Etisalat"

# get list of all policy folders
$policiesFolderPath = $baseFolderPath + "\policies"
$policyDefinitions = Get-ChildItem -Path $policiesFolderPath


# for each policy, open policy file
foreach($policyDefinition in $policyDefinitions){
    $policyDefinitionFile = $policyDefinition.FullName + "\policy.json"
    
    # parse content, read policy name
    $policyContentJson = Get-Content -Path $policyDefinitionFile | ConvertFrom-Json
    $policyName = $policyContentJson.name
    $policyName
    
    # rename folder name
    Rename-Item -Path $policyDefinition.FullName -NewName $policyName
}

# get list of all initiative folders
$initiativesFolderPath = $baseFolderPath + "\initiatives"
$initaitiveDefinitions = Get-ChildItem -Path $initiativesFolderPath


# for each initiative, open initiative file
foreach($initiativeDefinition in $initaitiveDefinitions){
    $initiativeDefinitionFile = $initiativeDefinition.FullName + "\policyset.json"
    
    # parse content, read initiative name
    $initiativeContentJson = Get-Content -Path $initiativeDefinitionFile | ConvertFrom-Json
    $initiativeName = $initiativeContentJson.name
    $initiativeName
    
    # rename folder name
    Rename-Item -Path $initiativeDefinition.FullName -NewName $initiativeName
}




