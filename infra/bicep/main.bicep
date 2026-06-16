// main.bicep - eShopOnWeb Azure Landing Zone
targetScope = 'resourceGroup'

param location string = resourceGroup().location
param environment string = 'dev'
param projectName string = 'eshop'
param sqlAdminLogin string = 'sqladmin'
@secure()
param sqlAdminPassword string

var prefix = '${projectName}-${environment}'
var acrName = replace('acr${projectName}${environment}', '-', '')

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: acrName
  location: location
  sku: { name: 'Standard' }
  properties: { adminUserEnabled: false }
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: 'kv-${prefix}'
  location: location
  properties: {
    sku: { family: 'A', name: 'standard' }
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
    enableSoftDelete: true
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: 'asp-${prefix}'
  location: location
  sku: { name: 'P1v3', tier: 'PremiumV3', capacity: 1 }
  kind: 'linux'
  properties: { reserved: true }
}

resource webApp 'Microsoft.Web/sites@2023-01-01' = {
  name: 'app-${prefix}'
  location: location
  kind: 'app,linux,container'
  identity: { type: 'SystemAssigned' }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'DOCKER|${acr.properties.loginServer}/eshop-web:latest'
      alwaysOn: true
      minTlsVersion: '1.2'
    }
  }
}

output acrLoginServer string = acr.properties.loginServer
output webAppHostName string = webApp.properties.defaultHostName
output keyVaultUri string = keyVault.properties.vaultUri
