// Scope

targetScope = 'subscription'

// Parameters

param pDateTime string = utcNow('u')
param pCustomerCode string
param pResourceName string
param pLocation string
param pEnvironment string

// Variables

var vDeploymentId = substring(uniqueString('${pDateTime}'), 0, 8)

// Resource Groups

resource synapseResourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: '${pCustomerCode}-rg-${pResourceName}-${pEnvironment}-${pLocation}'
  location: pLocation
}

// Module Deployments

module synapseWorkspace 'modules/synapse.bicep' = {
  scope: synapseResourceGroup
  name: 'deploy_synapse_workspace_${vDeploymentId}'
  params: {
    pLocation: pLocation
    pSynapseWorkspaceName: '${pCustomerCode}-syn-${pResourceName}-${pEnvironment}-${pLocation}'
  }
}
