module vnet 'modules/vnet.bicep' = {
  name: 'vnetmodule'
  params: {
    addressPrefixes: ['10.0.0.0/16']
    subnets: [
      {
        name: 'privateendpoints'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
      {
        name: 'appserviceplan'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
    virtualNetworkName: 'vnet-stockholm-2024'
  }
}

module storage './modules/storage.bicep' = {
  name: 'storagemodule'
  params: {
    storagename: 'ststkhlm2024'
    storageSKU: 'Standard_LRS'
    privateEndpointSubnetResourceId: '${vnet.outputs.virtualnetwork.id}/subnets/privateendpoints'
    enablePublicEndpoint: false
    enablePrivateEndpoint: true
  }
  dependsOn: [
    vnet
  ]
}

module appserviceplan './modules/appserviceplan.bicep' = {
  name: 'appserviceplanmodule'
  params: {
    appServicePlanName: 'asp-stockholm-2024'
    sku: 'B1'
  }
  dependsOn: [
    vnet
  ]
}

module functionapp 'modules/functionapp.bicep' = {
  name: 'functionappmodule'
  params : {
    appName: 'func-stockholm-2024'
    appserviceplanName: 'asp-stockholm-2024'
    storageaccountName: 'ststkhlm2024'
    enablePrivateEndpoint: false
    enablePublicEndpoint: true
    vnetIntegrationSubnetResourceId: '${vnet.outputs.virtualnetwork.id}/subnets/appserviceplan'
  }
  dependsOn: [
    storage
    appserviceplan
  ]
}
