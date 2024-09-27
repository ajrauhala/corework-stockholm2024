param sku string = 'F1' // The SKU of App Service Plan
param location string = resourceGroup().location // Location for all resources
param appServicePlanName string

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: sku
  }
  kind: 'linux'
}

output appServicePlan object = appServicePlan
