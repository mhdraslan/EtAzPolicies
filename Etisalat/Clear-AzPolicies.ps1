Get-AzPolicySetDefinition -ManagementGroupName Etisalat | ?{$_.Properties.PolicyType -eq "Custom"} | Remove-AzPolicySetDefinition -Force
Get-AzPolicyDefinition -ManagementGroupName Etisalat | ?{$_.Properties.PolicyType -eq "Custom"} | Remove-AzPolicyDefinition -Force
