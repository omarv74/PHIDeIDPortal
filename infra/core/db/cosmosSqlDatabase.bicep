@description('Name of the Cosmos DB account')
param accountName string
@description('Location for the Cosmos DB SQL database')
param location string = resourceGroup().location
@description('Name of the SQL database')
param databaseName string = 'deid'
@description('Throughput for the SQL database')
param throughput int = 400

resource sqlDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2023-04-15' = {
  name: '${accountName}/${databaseName}'
  location: location
  properties: {
    resource: {
      id: databaseName
    }
    options: {
      autoscaleSettings: {
        maxThroughput: throughput
      }
    }
  }
}

output sqlDatabaseName string = sqlDatabase.name
output sqlDatabaseId string = sqlDatabase.id
