@description('Name of the Function App')
param functionAppName string = 'functionappname'
// @description('OS type for the Function App')
// param osType string = 'Windows'
@description('Runtime for the Function App')
param runtime string = 'dotnet'
// @description('Storage account resource for the Function App')
// param roleAssignmentScope resource 'Microsoft.Storage/storageAccounts@2023-01-01'
@description('Storage account name for the Function App')
param storageAccountName string
@description('App Service plan name for the Function App')
param appServicePlanName string
@description('Location for the Function App')
param location string = resourceGroup().location


// resource existingStorage 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
//   name: 'storage'
// }


resource functionApp 'Microsoft.Web/sites@2022-03-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: resourceId('Microsoft.Web/serverfarms', appServicePlanName)
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=core.windows.net'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: runtime
        }
      ]
      use32BitWorkerProcess: true
      linuxFxVersion: ''
    }
    httpsOnly: true
  }
  identity: {
    type: 'SystemAssigned'
  }
}

// resource storageBlobContributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
//   name: guid(functionApp.id, 'Storage Blob Data Contributor')
//   scope: existingStorage // roleAssignmentScope // storageAccountResource // resourceId('Microsoft.Storage/storageAccounts', storageAccountName)
//   properties: {
//     roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
//     principalId: functionApp.identity.principalId
//     principalType: 'ServicePrincipal'
//   }
// }

output functionAppName string = functionApp.name
output functionAppId string = functionApp.id
output functionAppPrincipalId string = functionApp.identity.principalId
