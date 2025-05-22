@description('Name of the Cosmos DB account')
param accountName string
@description('Name of the SQL database')
param databaseName string = 'deid'
@description('Name of the SQL container')
param containerName string = 'metadata'
@description('Partition key path for the container')
param partitionKeyPath string = '/Uri'
@description('Location for the Cosmos DB SQL container')
param location string = resourceGroup().location

resource sqlContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2023-04-15' = {
  name: '${accountName}/${databaseName}/${containerName}'
  location: location
  properties: {
    resource: {
      id: containerName
      partitionKey: {
        paths: [partitionKeyPath]
        kind: 'Hash'
      }
    }
    options: {}
  }
}

output sqlContainerName string = sqlContainer.name
output sqlContainerId string = sqlContainer.id
