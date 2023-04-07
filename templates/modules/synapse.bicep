// Scope

targetScope = 'resourceGroup'

// Parameters

param pWorkspaceName string
param pLocation string
param pStorageUrl string
param pFileSystemName string

// Variables



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
  }
}

// Outputs
