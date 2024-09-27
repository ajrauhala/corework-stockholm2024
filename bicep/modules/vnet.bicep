param location string = resourceGroup().location
param virtualNetworkName string
param addressPrefixes array
param subnets array

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    subnets: subnets
  }
}

output virtualnetwork object = virtualNetwork
