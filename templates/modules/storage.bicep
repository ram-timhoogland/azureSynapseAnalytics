// Scope

targetScope = 'resourceGroup'

// Parameters

param pStorageAccountName string
param pLocation string

// Variables

// Existing resources

// Resources

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: pStorageAccountName
  location: pLocation
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    isHnsEnabled: true
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
  }
}

resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  parent: storageAccount
  name: 'default'
  properties: {
    containerDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: true
      days: 7
    }
  }
}

resource fileServices 'Microsoft.Storage/storageAccounts/fileServices@2022-09-01' = {
  parent: storageAccount
  name: 'default'
  properties: {
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

// Outputs

output oStorageUrl string = storageAccount.properties.primaryEndpoints.dfs
