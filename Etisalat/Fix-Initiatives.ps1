$file = Get-Content C:\Temp-Local\Initiative.json
foreach($line in $file){
    if($line -match "policyDefinitionId"){
        $line = $line.replace("/providers/Microsoft.Management/managementGroups/Etisalat","[concat(`'/providers/Microsoft.Management/managementGroups/`', parameters(`'mgmtGroupId`'),`'")
        $line = $line.Replace("`",","`')]`",")
        $line | Out-File -FilePath "C:\Temp-Local\Initiative2.json" -Append
    }
    elseif($line -match "parameterScopes"){
        # if you find /providers/Microsoft.Management/managementGroups/Etisalat then replace it by $mgmtgroupid
        $line | Out-File -FilePath "C:\Temp-Local\Initiative2.json" -Append
    }
    else {
        $line | Out-File -FilePath "C:\Temp-Local\Initiative2.json" -Append
    }
}



<#
$x = "`"/providers/Microsoft.Management/managementGroups/Etisalat/providers/Microsoft.Authorization/policyDefinitions/Deploy-Nsg-FlowLogs-to-LA`","
$x = "/providers/Microsoft.Management/managementGroups/Etisalat/providers/Microsoft.Authorization/policyDefinitions/Deploy-Nsg-FlowLogs-to-LA"
$x -replace "^(`"/providers/Microsoft.Management/managementGroups/Etisalat).*`",$" , "$1`')]`","

"justin.rich@technet.com" -replace "^(\w+)\.(\w+)@", '$1-$2@'
"justin.rich@technet.com" -match "^\w+\.(\w+)@"

"jrich888" -replace "(\d)\d{2}", "`${1}23"

#>
