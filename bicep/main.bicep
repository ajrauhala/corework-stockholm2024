module storage './modules/storage.bicep' = {
  name: 'storagemodule'
  params: {
    storagename: 'ststkhlm2024'
    storageSKU: 'Standard_LRS'
  }
}

module appserviceplan './modules/appserviceplan.bicep' = {
  name: 'appserviceplanmodule'
  params: {
    appServicePlanName: 'asp-stockholm-2024'
    sku: 'B1'
  }
}

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


module functionapp 'modules/functionapp.bicep' = {
  name: 'functionappmodule'
  params : {
    appName: 'func-stockholm-2024'
    appserviceplanName: 'asp-stockholm-2024'
    storageaccountName: 'ststkhlm2024'
  }
  dependsOn: [
    storage
    appserviceplan
  ]
}
