@description('Name of the Cosmos DB account')
param name string
@description('Location for the Cosmos DB account')
param location string = resourceGroup().location
@description('Tags to apply to the Cosmos DB account')
#disable-next-line no-unused-vars
param tags object = {}
@description('Cosmos DB API kind')
param kind string = 'GlobalDocumentDB'

resource cosmosDb 'Microsoft.DocumentDB/databaseAccounts@2025-05-01-preview' = {
  name: name
  location: location
  kind: kind
  identity: {
    type: 'None'
  }
  tags: {
    defaultExperience: '    Core (SQL)'
    'hidden-workload-type': 'Production'
    'hidden-cosmos-mmspecial': ''
  }
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
  }
}

output cosmosDbName string = cosmosDb.name
output cosmosDbId string = cosmosDb.id
output cosmosDbEndpoint string = cosmosDb.properties.documentEndpoint
