param location string = resourceGroup().location
param privateEndpointName string
param subnetResourceId string
param privateLinkServiceId string
@allowed([
  'namespace'           // service bus namespace or event hub namespace
  'sites'               // app service
  'blob'                // storage acct blob
  'table'               // storage acct table
  'file'                // storage acct file
  'vault'               // key vault
  'registry'            // container registry
  'SqlServer'           // Azure SQL server
  'configurationStores' // app configuration
  'SqlOnDemand'         // Synapse workspace serverless SQL endpoint
])
param groupIds string[]

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2023-04-01' = {
  name: privateEndpointName
  location: location
  properties: {
    subnet: {
      id: subnetResourceId
    }
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          privateLinkServiceId: privateLinkServiceId
          groupIds: groupIds
        }
      }
    ]
  }
}

output privateEndpoint object = privateEndpoint
