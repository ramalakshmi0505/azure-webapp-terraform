###############################################################
# Module: Networking
# Creates VNet, Subnet for App Service VNet Integration
###############################################################

variable "resource_group_name" {}
variable "location"            {}
variable "project_name"        {}
variable "environment"         {}
variable "tags"                {}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "${var.project_name}-vnet-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
  tags                = var.tags
}

# Subnet for App Service VNet Integration
resource "azurerm_subnet" "appservice" {
  name                 = "appservice-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "appservice-delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

output "vnet_id"            { value = azurerm_virtual_network.main.id }
output "appservice_subnet_id" { value = azurerm_subnet.appservice.id }
