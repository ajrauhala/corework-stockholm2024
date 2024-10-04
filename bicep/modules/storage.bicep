param storagename string
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param storageSKU string = 'Standard_LRS'
param location string = resourceGroup().location
param privateEndpointSubnetResourceId string = ''
param enablePublicEndpoint bool = true
param enablePrivateEndpoint bool = false
param privateEndpointName string = 'prep-blob-${storagename}'

resource storage 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storagename
  location: location
  sku: {
    name: storageSKU
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      defaultAction: enablePublicEndpoint ? 'Allow' : 'Deny'
    }
    supportsHttpsTrafficOnly: true
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' = {
  name: 'default'
  parent: storage
}

module blobPrivateEndpoint './privateendpoint.bicep' = if(enablePrivateEndpoint) {
  name: 'module-${storagename}-blobprep'
  params: {
    groupIds: ['blob']
    subnetResourceId: privateEndpointSubnetResourceId
    privateEndpointName: privateEndpointName
    privateLinkServiceId: storage.id
    location: location
  }
}

output storage object = storage
