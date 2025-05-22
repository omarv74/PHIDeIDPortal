@description('Name of the Function App')
param functionAppName string = 'functionappname'
@description('OS type for the Function App')
param osType string = 'Windows'
@description('Runtime for the Function App')
param runtime string = 'dotnet'
@description('Storage account name for the Function App')
param storageAccountName string
@description('App Service plan name for the Function App')
param appServicePlanName string
@description('Location for the Function App')
param location string = resourceGroup().location

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
          value: concat('DefaultEndpointsProtocol=https;AccountName=', storageAccountName, ';EndpointSuffix=core.windows.net')
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

output functionAppName string = functionApp.name
output functionAppId string = functionApp.id
