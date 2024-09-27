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
    sku: 'F1'
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
