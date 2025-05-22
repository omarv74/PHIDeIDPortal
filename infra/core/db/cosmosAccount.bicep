@description('Name of the Cosmos DB account')
param name string
@description('Location for the Cosmos DB account')
param location string = resourceGroup().location
@description('Tags to apply to the Cosmos DB account')
param tags object = {}
@description('Cosmos DB API kind')
param kind string = 'GlobalDocumentDB'

resource cosmosDb 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' = {
  name: name
  location: location
  kind: kind
  tags: tags
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
