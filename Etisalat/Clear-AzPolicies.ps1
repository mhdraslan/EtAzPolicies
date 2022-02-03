#
#Get-AzPolicySetDefinition -ManagementGroupName Etisalat | ?{$_.Properties.PolicyType -eq "Custom"} | Remove-AzPolicySetDefinition -Force
$Initiatives = Get-AzPolicySetDefinition -ManagementGroupName Etisalat | ?{$_.Properties.PolicyType -eq "Custom"} 

foreach($Initiative in $Initiatives){
    Invoke-Command -ScriptBlock {param($Initiative) Remove-AzPolicySetDefinition -Id $Initiative.PolicySetDefinitionId -Force} -ArgumentList $Initiative -AsJob
}
#>


#Get-AzPolicyDefinition -ManagementGroupName Etisalat | ?{$_.Properties.PolicyType -eq "Custom"} | Remove-AzPolicyDefinition -Force
$Policies = Get-AzPolicyDefinition -ManagementGroupName Etisalat | ?{$_.Properties.PolicyType -eq "Custom"} 

foreach($Policy in $Policies){
    Invoke-Command -ScriptBlock {param($Initiative) Remove-AzPolicyDefinition -Id $Policy.PolicyDefinitionId -Force} -ArgumentList $Policy -AsJob
}
