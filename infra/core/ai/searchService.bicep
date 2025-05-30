@description('Name of the Azure Cognitive Search service')
param searchServiceName string = 'srch-${uniqueString(resourceGroup().id, location)}'

@description('The SKU of the Azure Cognitive Search service')
param searchSkuName string = 'standard'

@description('The location for the Azure Cognitive Search service')
param location string = resourceGroup().location

param tags object = {}

resource searchService 'Microsoft.Search/searchServices@2023-11-01' = {
  name: searchServiceName
  identity: {
    type: 'SystemAssigned'
  }
  location: location
  sku: {
    name: searchSkuName
  }
  properties: {
    hostingMode: 'default'
    partitionCount: 1
    replicaCount: 1
    publicNetworkAccess: 'enabled'
  }
  tags: tags
}

output searchServiceName string = searchService.name
output searchServiceId string = searchService.id
output searchServiceLocation string = searchService.location
output searchServiceIdentity string = searchService.identity.principalId