
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
   echo WaitForBuildComplete
   WaitForBuildComplete
   write-output "begin deploy"
   az.cmd deployment group create --name $name --resource-group $rg   --template-file deploy-SourceControlBlazorSvrDemo.bicep
   write-output "end deploy"
   End commands to deploy this file using Azure CLI with PowerShell

   emacs 2
   Begin commands to shut down this deployment using Azure CLI with PowerShell
   echo CreateBuildEvent.exe
   CreateBuildEvent.exe&
   write-output "begin shut down"
   az.cmd deployment group create --mode complete --template-file ./clear-resources.json --resource-group $rg
   BuildIsComplete.exe
   Get-AzResource -ResourceGroupName $rg | ft
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
      appSettings:[]
      linuxFxVersion: 'DOTNETCORE|6.0'
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

/*

ERROR: {"status":"Failed","error":{"code":"DeploymentFailed","message":"At least one resource deployment operation failed. Please list deployment operations for details. Please see https://aka.ms/DeployOperations for usage details.","details":[{"code":"BadRequest","message":"{
  "Code": "BadRequest",
  "Message": "<Error xmlns=\\"http://schemas.microsoft.com/windowsazure\\" xmlns:i=\\"http://www.w3.org/2001/XMLSchema-instance\\"><Code>BadRequest</Code><Message>Repository 'UpdateSiteSourceControl' operation failed with Microsoft.Web.Hosting.SourceControls.OAuthException: GitHub GetSecretsPublicKey: API rate limit exceeded for user ID 11192805.
   at Microsoft.Web.Hosting.SourceControls.GitHubProxy.&lt;ProcessResponse&gt;d__31`1.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   at Microsoft.Web.Hosting.SourceControls.GitHubProxy.&lt;GetSecretsPublicKey&gt;d__22.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   at Microsoft.Web.Hosting.Administration.GitHubActionRepositoryProvider.&lt;CreateOrUpdateGitHubActionSecret&gt;d__19.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   at Microsoft.Web.Hosting.Administration.GitHubActionRepositoryProvider.&lt;UpdateSiteSourceControl&gt;d__16.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   at Microsoft.Web.Hosting.Administration.WebCloudController.&lt;&gt;c__DisplayClass326_1.&lt;&lt;UpdateSiteSourceControl&gt;b__1&gt;d.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   at Microsoft.Web.Hosting.AsyncHelper.RunSync[TResult](Func`1 func)
   at Microsoft.Web.Hosting.Administration.WebCloudController.UpdateSiteSourceControl(String subscriptionName, String webspaceName, String name, SiteSourceControl siteSourceControl).</Message><ExtendedCode>05007</ExtendedCode><MessageTemplate>Repository '{0}' operation failed with {1}.</MessageTemplate><Parameters xmlns:a=\\"http://schemas.microsoft.com/2003/10/Serialization/Arrays\\"><a:string>UpdateSiteSourceControl</a:string><a:string>Microsoft.Web.Hosting.SourceControls.OAuthException: GitHub GetSecretsPublicKey: API rate limit exceeded for user ID 11192805.
   at Microsoft.Web.Hosting.SourceControls.GitHubProxy.&lt;ProcessResponse&gt;d__31`1.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   at Microsoft.Web.Hosting.SourceControls.GitHubProxy.&lt;GetSecretsPublicKey&gt;d__22.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   at Microsoft.Web.Hosting.Administration.GitHubActionRepositoryProvider.&lt;CreateOrUpdateGitHubActionSecret&gt;d__19.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   at Microsoft.Web.Hosting.Administration.GitHubActionRepositoryProvider.&lt;UpdateSiteSourceControl&gt;d__16.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   at Microsoft.Web.Hosting.Administration.WebCloudController.&lt;&gt;c__DisplayClass326_1.&lt;&lt;UpdateSiteSourceControl&gt;b__1&gt;d.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   at Microsoft.Web.Hosting.AsyncHelper.RunSync[TResult](Func`1 func)
   at Microsoft.Web.Hosting.Administration.WebCloudController.UpdateSiteSourceControl(String subscriptionName, String webspaceName, String name, SiteSourceControl siteSourceControl)</a:string></Parameters><InnerErrors i:nil=\\"true\\"/><Details i:nil=\\"true\\"/><Target i:nil=\\"true\\"/></Error>",
  "Target": null,
  "Details": [
    {
      "Message": "<Error xmlns=\\"http://schemas.microsoft.com/windowsazure\\" xmlns:i=\\"http://www.w3.org/2001/XMLSchema-instance\\"><Code>BadRequest</Code><Message>Repository 'UpdateSiteSourceControl' operation failed with Microsoft.Web.Hosting.SourceControls.OAuthException: GitHub GetSecretsPublicKey: API rate limit exceeded for user ID 11192805.
   at Microsoft.Web.Hosting.SourceControls.GitHubProxy.&lt;ProcessResponse&gt;d__31`1.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   at Microsoft.Web.Hosting.SourceControls.GitHubProxy.&lt;GetSecretsPublicKey&gt;d__22.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   at Microsoft.Web.Hosting.Administration.GitHubActionRepositoryProvider.&lt;CreateOrUpdateGitHubActionSecret&gt;d__19.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   at Microsoft.Web.Hosting.Administration.GitHubActionRepositoryProvider.&lt;UpdateSiteSourceControl&gt;d__16.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   at Microsoft.Web.Hosting.Administration.WebCloudController.&lt;&gt;c__DisplayClass326_1.&lt;&lt;UpdateSiteSourceControl&gt;b__1&gt;d.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   at Microsoft.Web.Hosting.AsyncHelper.RunSync[TResult](Func`1 func)
   at Microsoft.Web.Hosting.Administration.WebCloudController.UpdateSiteSourceControl(String subscriptionName, String webspaceName, String name, SiteSourceControl siteSourceControl).</Message><ExtendedCode>05007</ExtendedCode><MessageTemplate>Repository '{0}' operation failed with {1}.</MessageTemplate><Parameters xmlns:a=\\"http://schemas.microsoft.com/2003/10/Serialization/Arrays\\"><a:string>UpdateSiteSourceControl</a:string><a:string>Microsoft.Web.Hosting.SourceControls.OAuthException: GitHub GetSecretsPublicKey: API rate limit exceeded for user ID 11192805.
   at Microsoft.Web.Hosting.SourceControls.GitHubProxy.&lt;ProcessResponse&gt;d__31`1.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   at Microsoft.Web.Hosting.SourceControls.GitHubProxy.&lt;GetSecretsPublicKey&gt;d__22.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   at Microsoft.Web.Hosting.Administration.GitHubActionRepositoryProvider.&lt;CreateOrUpdateGitHubActionSecret&gt;d__19.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   at Microsoft.Web.Hosting.Administration.GitHubActionRepositoryProvider.&lt;UpdateSiteSourceControl&gt;d__16.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   at Microsoft.Web.Hosting.Administration.WebCloudController.&lt;&gt;c__DisplayClass326_1.&lt;&lt;UpdateSiteSourceControl&gt;b__1&gt;d.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   at Microsoft.Web.Hosting.AsyncHelper.RunSync[TResult](Func`1 func)
   at Microsoft.Web.Hosting.Administration.WebCloudController.UpdateSiteSourceControl(String subscriptionName, String webspaceName, String name, SiteSourceControl siteSourceControl)</a:string></Parameters><InnerErrors i:nil=\\"true\\"/><Details i:nil=\\"true\\"/><Target i:nil=\\"true\\"/></Error>"
    },
    {
      "Code": "BadRequest"
    },
    {
      "ErrorEntity": {
        "Code": "BadRequest",
        "Message": "<Error xmlns=\\"http://schemas.microsoft.com/windowsazure\\" xmlns:i=\\"http://www.w3.org/2001/XMLSchema-instance\\"><Code>BadRequest</Code><Message>Repository 'UpdateSiteSourceControl' operation failed with Microsoft.Web.Hosting.SourceControls.OAuthException: GitHub GetSecretsPublicKey: API rate limit exceeded for user ID 11192805.
   at Microsoft.Web.Hosting.SourceControls.GitHubProxy.&lt;ProcessResponse&gt;d__31`1.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   at Microsoft.Web.Hosting.SourceControls.GitHubProxy.&lt;GetSecretsPublicKey&gt;d__22.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   at Microsoft.Web.Hosting.Administration.GitHubActionRepositoryProvider.&lt;CreateOrUpdateGitHubActionSecret&gt;d__19.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   at Microsoft.Web.Hosting.Administration.GitHubActionRepositoryProvider.&lt;UpdateSiteSourceControl&gt;d__16.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   at Microsoft.Web.Hosting.Administration.WebCloudController.&lt;&gt;c__DisplayClass326_1.&lt;&lt;UpdateSiteSourceControl&gt;b__1&gt;d.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   at Microsoft.Web.Hosting.AsyncHelper.RunSync[TResult](Func`1 func)
   at Microsoft.Web.Hosting.Administration.WebCloudController.UpdateSiteSourceControl(String subscriptionName, String webspaceName, String name, SiteSourceControl siteSourceControl).</Message><ExtendedCode>05007</ExtendedCode><MessageTemplate>Repository '{0}' operation failed with {1}.</MessageTemplate><Parameters xmlns:a=\\"http://schemas.microsoft.com/2003/10/Serialization/Arrays\\"><a:string>UpdateSiteSourceControl</a:string><a:string>Microsoft.Web.Hosting.SourceControls.OAuthException: GitHub GetSecretsPublicKey: API rate limit exceeded for user ID 11192805.
   at Microsoft.Web.Hosting.SourceControls.GitHubProxy.&lt;ProcessResponse&gt;d__31`1.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   at Microsoft.Web.Hosting.SourceControls.GitHubProxy.&lt;GetSecretsPublicKey&gt;d__22.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   at Microsoft.Web.Hosting.Administration.GitHubActionRepositoryProvider.&lt;CreateOrUpdateGitHubActionSecret&gt;d__19.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   at Microsoft.Web.Hosting.Administration.GitHubActionRepositoryProvider.&lt;UpdateSiteSourceControl&gt;d__16.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   at Microsoft.Web.Hosting.Administration.WebCloudController.&lt;&gt;c__DisplayClass326_1.&lt;&lt;UpdateSiteSourceControl&gt;b__1&gt;d.MoveNext()
--- End of stack trace from previous location where exception was thrown ---
   at System.Runtime.ExceptionServices.ExceptionDispatchInfo.Throw()
   at System.Runtime.CompilerServices.TaskAwaiter.HandleNonSuccessAndDebuggerNotification(Task task)
   at Microsoft.Web.Hosting.AsyncHelper.RunSync[TResult](Func`1 func)
   at Microsoft.Web.Hosting.Administration.WebCloudController.UpdateSiteSourceControl(String subscriptionName, String webspaceName, String name, SiteSourceControl siteSourceControl)</a:string></Parameters><InnerErrors i:nil=\\"true\\"/><Details i:nil=\\"true\\"/><Target i:nil=\\"true\\"/></Error>"
      }
    }
  ],
  "Innererror": null
}"}]}}

*/
// https://docs.microsoft.com/en-us/azure/templates/microsoft.web/sites/sourcecontrols?tabs=bicep 
// https://docs.microsoft.com/en-us/azure/templates/microsoft.web/sourcecontrols?tabs=bicep
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
