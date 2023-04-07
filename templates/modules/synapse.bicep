// Scope

targetScope = 'resourceGroup'

// Parameters

param pSynapseWorkspaceName string
param pLocation string

// Variables



// Resources

resource synapseWorkspace 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: pSynapseWorkspaceName
  location: pLocation
}

// Outputs
