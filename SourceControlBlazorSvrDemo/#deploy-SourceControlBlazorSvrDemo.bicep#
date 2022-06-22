
/*
(insert (search-replace-string (search-replace-string (file-name-nondirectory(buffer-file-name)) "^deploy-" "") "\\.bicep$" ""))
   Begin common prolog commands
   write-output "common prolog"
   $name='SourceControlBlazorSvrDemo'
   $rg="rg_$name"
   $loc='westus2'
   End common prolog commands

   emacs 1
   Begin commands to deploy this file using Azure CLI with PowerShell
   write-output "begin deploy"
   az.cmd deployment group create --name $name --resource-group $rg   --template-file deploy-SourceControlBlazorSvrDemo.bicep
   End commands to deploy this file using Azure CLI with PowerShell

   emacs 2
   Begin commands to shut down this deployment using Azure CLI with PowerShell
   write-output "begin shut down"
   az.cmd deployment group create --mode complete --template-file ./clear-resources.json --resource-group $rg
   Get-AzResource -ResourceGroupName $rg | ft
   End commands to shut down this deployment using Azure CLI with PowerShell

   emacs 3
   Begin commands for one time initializations using Azure CLI with PowerShell
   az.cmd group create -l $loc -n $rg
   $id=(az.cmd group show --name $rg --query 'id' --output tsv)
   write-output "id=$id"
   $sp="spad_$name"
   az.cmd ad sp create-for-rbac --name $sp --sdk-auth --role contributor --scopes $id
   write-output "go to github settings->secrets and create a secret called AZURE_CREDENTIALS with the above output"
   End commands for one time initializations using Azure CLI with PowerShell

*/



@description('region we are operating in')
param location string = resourceGroup().location
param name string = uniqueString(resourceGroup().id)

@description('The web site hosting plan')
@allowed([
  'F1'
  'D1'
  'B1'
  'B2'
  'B3'
  'S1'
  'S2'
  'S3'
  'P1'
  'P2'
  'P3'
  'P4'
])
param webPlanSku string ='F1'

resource plan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: '${name}-plan'
  location: location
  sku: {
    name: webPlanSku
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}
resource website 'Microsoft.Web/sites@2021-03-01' {
  name: '${name}-website'
  location: location
  properties:{
    httpsOnly: true
    siteConfig:{
      appSettings:[]
      linuxFxVersion: 'DOTNETCORE|6'
    }
  }
  resource logs 'config' = {
    name: 'logs'
    properties: {
      applicationLogs: {
        fileSystem: {
          level: 'Warning'
        }
      }
      httpLogs: {
        fileSystem: {
          enabled: true
        }
      }
      detailedErrorMessages: {
        enabled: true
      }
    }
  }
  resource srcControls 'sourcecontrols@2021-03-01' = {
    name: 'web'
    properties: {
      repoUrl: 'https://github.com/siegfried01/SourceControlsAzureBicepDemo02.git'
      branch: 'main'
      isManualIntegration: false
      isGitHubAction: true
      gitHubActionConfiguration: {
        codeConfiguration: {
          runtimeStack: 'DOTNETCORE'
          runtimeVersion: '6'
        }
        generateWorkflowFile: true
        isLinux: true
      }
    }
  }
}
