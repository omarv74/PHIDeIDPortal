@description('Name of the App Service plan')
param name string
@description('Location for the App Service plan')
param location string = resourceGroup().location
@description('SKU for the App Service plan')
param skuName string = 'S1'

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: name
  location: location
  sku: {
    name: skuName
    tier: 'Standard'
  }
}

output appServicePlanName string = appServicePlan.name
output appServicePlanId string = appServicePlan.id
