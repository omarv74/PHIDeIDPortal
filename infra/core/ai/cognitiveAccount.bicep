metadata description = 'Creates an Azure storage account.'
param name string
param location string = resourceGroup().location
param tags object = {}

resource cognitiveAccount 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
	name: name
	location: location 
	sku: {
		name: 'S0'
	}
	kind: 'CognitiveServices'
	properties: {
		apiProperties: {}
		networkAcls: {
			defaultAction: 'Allow'
		}
	}
	
	tags: tags
}
