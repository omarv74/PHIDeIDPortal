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
        {
          name: 'PII_REDACTION_PROMPT'
          value: '<Prompt Placeholder>' // ToDo: Replace with actual prompt for PII redaction
        }
        {
          name: 'COSMOS_CONTAINER_NAME'
          value: '' 
        }
        {
          name: 'COSMOS_DATABASE_NAME'
          value: ''
        }
        {
          name: 'COSMOS_ENDPOINT_URI'
          value: ''
        }
        {
          name: 'COSMOS_PARTITION_KEY'
          value: ''
        }
        {
          name: 'OPENAI_API_KEY'
          value: ''
        }
        {
          name: 'OPENAI_DEPLOYMENT_NAME'
          value: ''
        }
        {
          name: 'OPENAI_ENDPOINT'
          value: ''
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

resource publishingPolicy 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-03-01' = {
  name: 'scm'
  parent: functionApp
  properties: {
    allow: true
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
output principalId string = functionApp.identity.principalId
