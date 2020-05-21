resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "MDSVNET3" {
  name                = "MDSLoadBalancerRG-network3"
  address_space       = ["10.10.0.0/16"]
  location            = azurerm_resource_group.MDSLB.location
  resource_group_name = azurerm_resource_group.MDSLB.name
}

resource "azurerm_virtual_wan" "MDSWAN" {
  name                = "MDSLoadBalancer-vwan"
  resource_group_name = azurerm_resource_group.MDSLB.name
  location            = azurerm_resource_group.MDSLB.location
}

resource "azurerm_virtual_hub" "MDSHUB" {
  name                = "MDSLoadBalancer-hub"
  resource_group_name = azurerm_resource_group.MDSLB.name
  location            = azurerm_resource_group.MDSLB.location
  virtual_wan_id      = azurerm_virtual_wan.example.id
  address_prefix      = "10.0.1.0/24"
}

resource "azurerm_vpn_gateway" "MDSVPNG" {
  name                = "MDSLoadBalancer-vpng"
  location            = azurerm_resource_group.MDSLB.location
  resource_group_name = azurerm_resource_group.MDSLB.name
  virtual_hub_id      = azurerm_virtual_hub.example.id
}
resource "azurerm_virtual_network" "MDSVNET3" {
  name                = "MDSLoadBalancerRG-network3"
  address_space       = ["10.10.0.0/16"]
  location            = azurerm_resource_group.MDSLB.location
  resource_group_name = azurerm_resource_group.MDSLB.name
}
resource "azurerm_subnet" "internal3" {
  name                 = "internal3"
  resource_group_name  = azurerm_resource_group.MDSLB.name
  virtual_network_name = azurerm_virtual_network.MDSVNET3.name
  address_prefix       = "10.10.2.0/24"
}