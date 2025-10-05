param dnszones_contoso98_com_name string = 'contoso98.com'
param virtualNetworks_CoreServicesVnet_name string = 'CoreServicesVnet'
param applicationSecurityGroups_asg_web_name string = 'asg-web'
param networkSecurityGroups_myNSGSecure_name string = 'myNSGSecure'
param virtualNetworks_ManufacturingVnet_name string = 'ManufacturingVnet'
param privateDnsZones_private_contoso98_com_name string = 'private.contoso98.com'

resource applicationSecurityGroups_asg_web_name_resource 'Microsoft.Network/applicationSecurityGroups@2024-07-01' = {
  name: applicationSecurityGroups_asg_web_name
  location: 'southcentralus'
  properties: {}
}

resource dnszones_contoso98_com_name_resource 'Microsoft.Network/dnszones@2023-07-01-preview' = {
  name: dnszones_contoso98_com_name
  location: 'global'
  properties: {
    zoneType: 'Public'
  }
}

resource privateDnsZones_private_contoso98_com_name_resource 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: privateDnsZones_private_contoso98_com_name
  location: 'global'
  properties: {}
}

resource virtualNetworks_CoreServicesVnet_name_resource 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: virtualNetworks_CoreServicesVnet_name
  location: 'southcentralus'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.20.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'SharedServicesSubnet'
        id: virtualNetworks_CoreServicesVnet_name_SharedServicesSubnet.id
        properties: {
          addressPrefix: '10.20.10.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'DatabaseSubnet'
        id: virtualNetworks_CoreServicesVnet_name_DatabaseSubnet.id
        properties: {
          addressPrefix: '10.20.20.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource virtualNetworks_ManufacturingVnet_name_resource 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: virtualNetworks_ManufacturingVnet_name
  location: 'southcentralus'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.30.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'SensorSubnet1'
        id: virtualNetworks_ManufacturingVnet_name_SensorSubnet1.id
        properties: {
          addressPrefix: '10.30.20.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'SensorSubnet2'
        id: virtualNetworks_ManufacturingVnet_name_SensorSubnet2.id
        properties: {
          addressPrefix: '10.30.21.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource dnszones_contoso98_com_name_www 'Microsoft.Network/dnszones/A@2023-07-01-preview' = {
  parent: dnszones_contoso98_com_name_resource
  name: 'www'
  properties: {
    TTL: 3600
    ARecords: [
      {
        ipv4Address: '10.1.1.4'
      }
    ]
    targetResource: {}
    trafficManagementProfile: {}
  }
}

resource Microsoft_Network_dnszones_NS_dnszones_contoso98_com_name 'Microsoft.Network/dnszones/NS@2023-07-01-preview' = {
  parent: dnszones_contoso98_com_name_resource
  name: '@'
  properties: {
    TTL: 172800
    NSRecords: [
      {
        nsdname: 'ns1-07.azure-dns.com.'
      }
      {
        nsdname: 'ns2-07.azure-dns.net.'
      }
      {
        nsdname: 'ns3-07.azure-dns.org.'
      }
      {
        nsdname: 'ns4-07.azure-dns.info.'
      }
    ]
    targetResource: {}
    trafficManagementProfile: {}
  }
}

resource Microsoft_Network_dnszones_SOA_dnszones_contoso98_com_name 'Microsoft.Network/dnszones/SOA@2023-07-01-preview' = {
  parent: dnszones_contoso98_com_name_resource
  name: '@'
  properties: {
    TTL: 3600
    SOARecord: {
      email: 'azuredns-hostmaster.microsoft.com'
      expireTime: 2419200
      host: 'ns1-07.azure-dns.com.'
      minimumTTL: 300
      refreshTime: 3600
      retryTime: 300
      serialNumber: 1
    }
    targetResource: {}
    trafficManagementProfile: {}
  }
}

resource networkSecurityGroups_myNSGSecure_name_resource 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name: networkSecurityGroups_myNSGSecure_name
  location: 'southcentralus'
  properties: {
    securityRules: [
      {
        name: 'DenyInterweb'
        id: networkSecurityGroups_myNSGSecure_name_DenyInterweb.id
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'Internet'
          access: 'Deny'
          priority: 4096
          direction: 'Outbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'AllowASGWeb'
        id: networkSecurityGroups_myNSGSecure_name_AllowASGWeb.id
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: [
            '80'
            '443'
          ]
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
          sourceApplicationSecurityGroups: [
            {
              id: applicationSecurityGroups_asg_web_name_resource.id
            }
          ]
        }
      }
    ]
  }
}

resource networkSecurityGroups_myNSGSecure_name_DenyInterweb 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  name: '${networkSecurityGroups_myNSGSecure_name}/DenyInterweb'
  properties: {
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '*'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: 'Internet'
    access: 'Deny'
    priority: 4096
    direction: 'Outbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_myNSGSecure_name_resource
  ]
}

resource privateDnsZones_private_contoso98_com_name_sensorvm 'Microsoft.Network/privateDnsZones/A@2024-06-01' = {
  parent: privateDnsZones_private_contoso98_com_name_resource
  name: 'sensorvm'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: '10.1.1.4'
      }
    ]
  }
}

resource Microsoft_Network_privateDnsZones_SOA_privateDnsZones_private_contoso98_com_name 'Microsoft.Network/privateDnsZones/SOA@2024-06-01' = {
  parent: privateDnsZones_private_contoso98_com_name_resource
  name: '@'
  properties: {
    ttl: 3600
    soaRecord: {
      email: 'azureprivatedns-host.microsoft.com'
      expireTime: 2419200
      host: 'azureprivatedns.net'
      minimumTtl: 10
      refreshTime: 3600
      retryTime: 300
      serialNumber: 1
    }
  }
}

resource virtualNetworks_CoreServicesVnet_name_DatabaseSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name: '${virtualNetworks_CoreServicesVnet_name}/DatabaseSubnet'
  properties: {
    addressPrefix: '10.20.20.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_CoreServicesVnet_name_resource
  ]
}

resource virtualNetworks_ManufacturingVnet_name_SensorSubnet1 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name: '${virtualNetworks_ManufacturingVnet_name}/SensorSubnet1'
  properties: {
    addressPrefix: '10.30.20.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_ManufacturingVnet_name_resource
  ]
}

resource virtualNetworks_ManufacturingVnet_name_SensorSubnet2 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name: '${virtualNetworks_ManufacturingVnet_name}/SensorSubnet2'
  properties: {
    addressPrefix: '10.30.21.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_ManufacturingVnet_name_resource
  ]
}

resource virtualNetworks_CoreServicesVnet_name_SharedServicesSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name: '${virtualNetworks_CoreServicesVnet_name}/SharedServicesSubnet'
  properties: {
    addressPrefix: '10.20.10.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_CoreServicesVnet_name_resource
  ]
}

resource networkSecurityGroups_myNSGSecure_name_AllowASGWeb 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  name: '${networkSecurityGroups_myNSGSecure_name}/AllowASGWeb'
  properties: {
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 100
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: [
      '80'
      '443'
    ]
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
    sourceApplicationSecurityGroups: [
      {
        id: applicationSecurityGroups_asg_web_name_resource.id
      }
    ]
  }
  dependsOn: [
    networkSecurityGroups_myNSGSecure_name_resource
  ]
}

resource privateDnsZones_private_contoso98_com_name_manufacturing_link 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: privateDnsZones_private_contoso98_com_name_resource
  name: 'manufacturing-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetworks_ManufacturingVnet_name_resource.id
    }
  }
}
