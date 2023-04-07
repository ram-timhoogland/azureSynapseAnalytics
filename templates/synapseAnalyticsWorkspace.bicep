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
  name: '${pCustomerCode}-rg-${pResourceName}-${pEnvironment}-${substring(pLocation, 0, 6)}'
  location: pLocation
}

// Module Deployments

module synapseStorage 'modules/storage.bicep' = {
  scope: synapseResourceGroup
  name: 'deploy_synapse_storage_${vDeploymentId}'
  params: {
    pLocation: pLocation
    pStorageAccountName: '${pCustomerCode}st${uniqueString(pResourceName, substring(pLocation, 0, 6))}${pEnvironment}'
  }
}

module synapseWorkspace 'modules/synapse.bicep' = {
  scope: synapseResourceGroup
  name: 'deploy_synapse_workspace_${vDeploymentId}'
  params: {
    pLocation: pLocation
    pWorkspaceName: '${pCustomerCode}-syn-${pResourceName}-${pEnvironment}-${pLocation}'
    pManagedResourceGroupName: '${pCustomerCode}-rg-${pResourceName}-managed-${pEnvironment}-${substring(pLocation, 0, 6)}'
    pStorageUrl: synapseStorage.outputs.oStorageUrl
    pFileSystemName: 'fileSystem'
  }
}
