# data "azurerm_resource_group" "rg-VNET-AUTOMATION" {
#   name = "VNET-AUTOMATION"
# }
# data "azurerm_virtual_network" "VNET-AUTOMATION" {
#  name = var.vnet_name
#  resource_group_name = data.azurerm_resource_group.rg-VNET-AUTOMATION.name
# }

module "rg" {
  source   = "../resources/rg"
  prefix   = var.name-xol-svil
  location = local.azure_region
  providers = {
    azurerm = azurerm
  }
  tags = var.tags
}

/* module "rg-RG-XOL-COLL" {
  source   = "./resources/rg"
  prefix   = var.name-xol-coll
  location = local.azure_region
  providers = {
    azurerm = azurerm
  }
  tags = var.tags
} */

module "azurerm_subnet" "subnet" {

}

module "redis-cache" {
  source = "../resources/cache"
}

module "private-endpoint" {
  source = "../resources/pvt-endpoint"
}
