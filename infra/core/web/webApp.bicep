@description('Name of the Web App')
param webAppName string = 'webname'
@description('Runtime for the Web App')
param runtime string = 'DOTNET|8.0'
@description('App Service plan name for the Web App')
param appServicePlanName string
@description('Location for the Web App')
param location string = resourceGroup().location

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: location
  kind: 'app'
  properties: {
    serverFarmId: resourceId('Microsoft.Web/serverfarms', appServicePlanName)
    siteConfig: {
      windowsFxVersion: runtime
    }
    httpsOnly: true
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource publishingPolicy 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-03-01' = {
  name: '${webAppName}/scm'
  // scope: rg
  location: location
  properties: {
    allow: true
  }
}

output webAppName string = webApp.name
output webAppId string = webApp.id
output webAppPrincipalId string = webApp.identity.principalId
