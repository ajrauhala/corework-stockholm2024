param appName string
param storageaccountName string
param appserviceplanName string
param location string = resourceGroup().location
param privateEndpointName string = 'prep-${appName}'
param enablePublicEndpoint bool = true
param enablePrivateEndpoint bool = false
param vnetIntegrationSubnetResourceId string = ''
param privateEndpointSubnetResourceId string = ''

resource storage 'Microsoft.Storage/storageAccounts@2023-05-01' existing = {
  name: storageaccountName
}

resource functionApp 'Microsoft.Web/sites@2021-03-01' = {
  name: appName
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: resourceId('Microsoft.Web/serverfarms', appserviceplanName)
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storage.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storage.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storage.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storage.listKeys().keys[0].value}'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
      ]
      netFrameworkVersion: '8'
      ftpsState: 'FtpsOnly'
      minTlsVersion: '1.2'
      publicNetworkAccess: enablePublicEndpoint ? 'Enabled' : 'Disabled'
      vnetRouteAllEnabled: vnetIntegrationSubnetResourceId == '' ? false : true
      alwaysOn: true
      
    }
    httpsOnly: true
    virtualNetworkSubnetId: vnetIntegrationSubnetResourceId
  }
}

module pepModule './privateendpoint.bicep' = if(enablePrivateEndpoint) {
  name: 'module-${privateEndpointName}'
  params: {
    groupIds: ['sites']
    privateEndpointName: privateEndpointName
    privateLinkServiceId: functionApp.id
    subnetResourceId: privateEndpointSubnetResourceId
    location: location
  }
}
