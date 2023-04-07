// Scope

targetScope = 'resourceGroup'

// Parameters

param pWorkspaceName string
param pManagedResourceGroupName string
param pLocation string
param pStorageUrl string
param pFileSystemName string

// Variables

// Existing Resources

resource managedResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  scope: subscription()
  name: pManagedResourceGroupName
}

// Resources

resource synapseWorkspace 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: pWorkspaceName
  location: pLocation
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    defaultDataLakeStorage: {
      accountUrl: pStorageUrl
      filesystem: pFileSystemName
    }
    managedResourceGroupName: managedResourceGroup.name
  }
}

// Outputs
