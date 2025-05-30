@description('Name of the Azure OpenAI resource')
param aoaiName string
@description('Location for the Azure OpenAI resource')
param location string = resourceGroup().location
@description('Tags to apply to the Azure OpenAI resource')
param tags object = {}

resource aoai 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: aoaiName
  location: location
  kind: 'OpenAI'
  sku: {
    name: 'S0'
    // name: 'Standard'
    capacity: 1400
  }
  tags: tags
  properties: {
    apiProperties: {
      enableDynamicThrottling: true
    }
    publicNetworkAccess: 'Enabled'
  }
}

resource gpt4oMiniDeployment 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = {
  name: 'gpt-4o-mini'
  parent: aoai
  properties: {
    model: {
      format: 'OpenAI'
      name: 'gpt-4o-mini'
      version: '2024-07-18'
    }
  }
}

output aoaiName string = aoai.name
output aoaiId string = aoai.id
output gpt4oMiniDeploymentName string = gpt4oMiniDeployment.name
output gpt4oMiniDeploymentId string = gpt4oMiniDeployment.id
