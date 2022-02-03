$TopLevelManagemntGroupId = "Etisalat"
New-AzManagementGroupDeployment -Name "EtisalatAzPoliciesImport" `
                                -ManagementGroupId $TopLevelManagemntGroupId `
                                -Location "UAENorth" `
                                -TemplateFile C:\Repos\EESLZPolicies\policies.json

New-AzManagementGroupDeployment -Name "Etisalat-AzInitiatives-Import" `
                                -ManagementGroupId $TopLevelManagemntGroupId `
                                -Location UAENorth `
                                -TemplateFile C:\Repos\EESLZPolicies\Initiatives.json `
                                -mgmtGroupId $TopLevelManagemntGroupId
