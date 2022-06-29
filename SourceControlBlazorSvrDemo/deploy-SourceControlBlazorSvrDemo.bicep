
/*

   Begin common prolog commands
   write-output "begin common prolog"
   $name='SourceControlBlazorSvrDemo'
   $rg="rg_$name"
   $loc='westus2'
   write-output "end common prolog"
   End common prolog commands

   emacs 1
   Begin commands to deploy this file using Azure CLI with PowerShell
   echo WaitForBuildComplete
   WaitForBuildComplete
   write-output "previous build is complete! begin deployment build"
   #az.cmd deployment group create --name $name --resource-group $rg   --template-file  webapp_with_scm.json --parameters appplanName=appplanfee location=$loc appname=websrcctrldemo
   az.cmd deployment group create --name $name --resource-group $rg   --template-file deploy-SourceControlBlazorSvrDemo.bicep
   write-output "end deployment build"
   End commands to deploy this file using Azure CLI with PowerShell

   emacs 2
   Begin commands to shut down this deployment using Azure CLI with PowerShell
   echo CreateBuildEvent.exe
   CreateBuildEvent.exe&
   write-output "begin shutdown"
   az.cmd deployment group create --mode complete --template-file ./clear-resources.json --resource-group $rg
   BuildIsComplete.exe
   Get-AzResource -ResourceGroupName $rg | ft
   write-output "showdown is complete"
   End commands to shut down this deployment using Azure CLI with PowerShell

   emacs 3
   Begin commands for one time initializations using Azure CLI with PowerShell
   az.cmd group create -l $loc -n $rg
   $id=(az.cmd group show --name $rg --query 'id' --output tsv)
   write-output "id=$id"
   $sp="spad_$name"
   az.cmd ad sp create-for-rbac --appId $sp --sdk-auth --role contributor --scopes $id
   write-output "go to github settings->secrets and create a secret called AZURE_CREDENTIALS with the above output"
   End commands for one time initializations using Azure CLI with PowerShell

   see https://docs.microsoft.com/en-us/azure/app-service/deploy-github-actions?tabs=applevel
      configure with Portal (does not use sourceControls resource) https://docs.microsoft.com/en-us/azure/app-service/deploy-continuous-deployment?tabs=github

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
resource website 'Microsoft.Web/sites@2020-12-01' = {
  name: '${name}-website'
  location: location
  properties:{
    serverFarmId: plan.id
    httpsOnly: true
    siteConfig:{
      linuxFxVersion: 'DOTNETCORE|6.0'
      webSocketsEnabled: true
      netFrameworkVersion: 'v6.0'
      metadata:[
         {
            name: 'CURRENT_STACK'
            value: 'dotnet'
         }
      ]
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

// https://docs.microsoft.com/en-us/azure/templates/microsoft.web/sites/sourcecontrols?tabs=bicep 
// https://docs.microsoft.com/en-us/azure/templates/microsoft.web/sourcecontrols?tabs=bicep
/*
  resource srcControls 'sourcecontrols@2021-03-01' = {
    name: 'web'
    properties: {
      repoUrl: 'https://github.com/siegfried01/SourceControlsAzureBicepDemo02.git'
      branch: 'master'
      isManualIntegration: false
      isGitHubAction: true
      gitHubActionConfiguration: {
        codeConfiguration: {
          runtimeStack: 'DOTNET'
          runtimeVersion: '6.0'
        }
        generateWorkflowFile: true
        isLinux: true        
      }      
    }
  }
*/
}
